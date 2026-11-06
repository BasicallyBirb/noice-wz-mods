// Cash Drop fix for offline Warzone (MWIII/LUMEN)
//
// The retail Cash Drop pays out through the shared function
// "br_cashcrate" / "cashCrate_onCrateUse" when a cash crate is captured.
// In offline play that payout can be missing, so this script installs an
// equivalent handler: capturing a Cash Drop spills 10 Plunder cash piles
// using the retail MWIII weights (50/80/120/200/350). In Plunder this event
// is cash-only; there is no hidden weapon/armor loot in it.
//
// Compile as its own custom script, for example:
// acts.exe gscc cash_drop_fix.gsc -g mwiii --name "custom/br/cash_drop_fix.gsc" --namespace "cash_drop_fix" -o cash_drop_fix
//
// Optional dvars:
//   cashdrop_fix   1 = enabled (default), 0 = disabled
//   cashdrop_piles number of cash piles per crate (default 10)

#using scripts\common\system;
#using scripts\engine\utility;
#using scripts\mp\gametypes\br_plunder;
#using scripts\mp\gametypes\br_pickups;
#using scripts\mp\gametypes\br_public;
#using scripts\mp\objidpoolmanager;
#using scripts\mp\utility\game;

function private autoexec __init__system__()
{
    system::register(#"cash_drop_fix", undefined, undefined, &__init__);
}

function __init__()
{
    level thread [[ &cdf_boot ]]();
}

function init()
{
    level thread [[ &cdf_boot ]]();
}

function main()
{
    level thread [[ &cdf_boot ]]();
}

function cdf_boot()
{
    level endon("game_ended");
    if (isdefined(level.cash_drop_fix_booted)) return;
    level.cash_drop_fix_booted = 1;

    // Install early, then keep checking for a while: offline script/event
    // init order can vary, and the game may register its own handler after us.
    for (i = 0; i < 60; i++)
    {
        cdf_install();
        wait 0.5;
    }
    logprint("[CashDropFix] installed\n");
    level thread [[ &cdf_watchdog ]]();
}

function cdf_watchdog()
{
    level endon("game_ended");
    for (;;)
    {
        cdf_install();
        wait 2;
    }
}

function cdf_install()
{
    if (!getdvarint(@"cashdrop_fix", 1)) return;
    if (!scripts\engine\utility::issharedfuncdefined("br_cashcrate", "cashCrate_onCrateUse") || scripts\engine\utility::getsharedfunc("br_cashcrate", "cashCrate_onCrateUse") != &cdf_on_crate_use)
    {
        scripts\engine\utility::registersharedfunc("br_cashcrate", "cashCrate_onCrateUse", &cdf_on_crate_use);
    }
}

function cdf_plunder_active()
{
    return isdefined(level.br_plunder_enabled) && level.br_plunder_enabled;
}

function cdf_cleanup_objective()
{
    if (isdefined(self.scriptedobjid))
    {
        objective_delete(self.scriptedobjid);
        scripts\mp\objidpoolmanager::returnobjectiveid(self.scriptedobjid);
        self.scriptedobjid = undefined;
    }
    if (isdefined(self.smokesignal))
    {
        self.smokesignal setscriptablepartstate("smoke_signal", "off", 0);
        self.smokesignal delete();
        self.smokesignal = undefined;
    }
}

function cdf_cash_amount(name)
{
    if (isdefined(level.br_pickups) && isdefined(level.br_pickups.counts) && isdefined(level.br_pickups.counts[name])) return int(level.br_pickups.counts[name]);
    if (name == "brloot_plunder_cash_uncommon_1") return 50;
    if (name == "brloot_plunder_cash_uncommon_2") return 80;
    if (name == "brloot_plunder_cash_uncommon_3") return 120;
    if (name == "brloot_plunder_cash_rare_1") return 200;
    if (name == "brloot_plunder_cash_rare_2") return 350;
    return 50;
}

function cdf_roll_cash_name()
{
    roll = randomint(1000);
    if (roll < 375) return "brloot_plunder_cash_uncommon_1";
    if (roll < 795) return "brloot_plunder_cash_uncommon_2";
    if (roll < 945) return "brloot_plunder_cash_uncommon_3";
    if (roll < 995) return "brloot_plunder_cash_rare_1";
    return "brloot_plunder_cash_rare_2";
}

// Called on the crate (self = crate) by airdrop's capture callback.
function cdf_on_crate_use(player)
{
    if (!getdvarint(@"cashdrop_fix", 1)) return;
    if (!isdefined(self) || !isdefined(player) || !isalive(player)) return;
    if (istrue(self.cdf_paid)) return;
    self.cdf_paid = 1;
    self.itemsdropped = 0;

    cdf_cleanup_objective();

    piles = getdvarint(@"cashdrop_piles", 10);
    if (piles < 1) piles = 1;
    if (piles > 20) piles = 20;

    dropstruct = scripts\mp\gametypes\br_pickups::function_7b9f3966a7a42003();
    total = 0;
    spawned = 0;
    fallback = 0;

    for (i = 0; i < piles; i++)
    {
        name = cdf_roll_cash_name();
        amount = cdf_cash_amount(name);
        total += amount;

        pickup = undefined;
        dropinfo = scripts\mp\gametypes\br_pickups::getitemdroporiginandangles(dropstruct, self.origin, self.angles, self);
        if (isdefined(dropinfo)) pickup = scripts\mp\gametypes\br_pickups::spawnpickup(name, dropinfo, amount, 1);

        if (isdefined(pickup))
        {
            spawned++;
            self.itemsdropped++;
            if (cdf_plunder_active())
            {
                scripts\mp\gametypes\br_plunder::modify_plunder_itemsinworld(name, 1);
                if (scripts\mp\gametypes\br_plunder::inplunderlivelobby())
                {
                    if (!isdefined(level.br_plunder_ents)) level.br_plunder_ents = [];
                    level.br_plunder_ents[level.br_plunder_ents.size] = pickup;
                }
            }
        }
        else fallback += amount;
    }

    // If pickup spawning failed in this build, do not lose the payout in
    // Plunder: credit the capturing player directly instead.
    if (fallback > 0 && cdf_plunder_active())
    {
        player scripts\mp\gametypes\br_plunder::playerplunderpickup(fallback, undefined, undefined, 1);
    }

    if (cdf_plunder_active() && isdefined(level.br_plunder))
    {
        level.br_plunder.plunder_items_dropped += spawned;
        level.br_plunder.plunder_value_dropped += total;
    }

    if (!isdefined(player.lootcachesopened)) player.lootcachesopened = 1;
    else player.lootcachesopened++;

    sub = scripts\mp\utility\game::getsubgametype();
    if (sub == "plunder" || sub == "risk") player scripts\mp\gametypes\br_public::updatebrscoreboardstat("lootCachesOpened", player.lootcachesopened);

    logprint("[CashDropFix] paid player=" + player getentitynumber() + " piles=" + spawned + " total=" + total + " fallback=" + fallback + "\n");
}
