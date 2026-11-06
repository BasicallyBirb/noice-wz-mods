#using scripts\common\system;
#using scripts\cp_mp\calloutmarkerping;
#using scripts\mp\bots\bots_util;
#using scripts\mp\bots\bots_loadout;
#using scripts\mp\bots\bots_gametype_br;
#using scripts\mp\bots\bots_strategy;
#using scripts\mp\class;
#using scripts\mp\teams;
#using scripts\mp\gamelogic;
#using scripts\engine\utility;
#using scripts\engine\trace;
#using scripts\mp\laststand;
#using scripts\cp_mp\armor;
#using scripts\cp_mp\killstreaks\uav;
#using script_40e63dd222434655;
#using script_d74ae0b4aa21186;
#using script_7c79573f6d201a19;
#using scripts\mp\gametypes\br;
#using scripts\mp\gametypes\br_public;
#using scripts\mp\gametypes\br_circle;
#using scripts\mp\gametypes\br_armory_kiosk;
#using scripts\mp\gametypes\br_pickups;
#using scripts\mp\killstreaks\killstreaks;
#using scripts\mp\utility\game;
#using scripts\mp\gametypes\br_plunder;
#using scripts\mp\gametypes\br_lootcache;
#using scripts\mp\gametypes\br_weapons;
#using scripts\mp\gametypes\br_gametypes;
#using scripts\cp_mp\vehicles\vehicle_occupancy;

function private autoexec __init__system__()
{
    // The worker must start after native postinit, not while scripts link.
    system::register(#"noice_warzone_bots", undefined, undefined, &__init__);
}

function __init__()
{
    level thread [[ &water_wz_boot ]]();
}

function init()
{
    level thread [[ &water_wz_boot ]]();
}

function main()
{
    level thread [[ &water_wz_boot ]]();
}

function water_wz_boot()
{
    level endon("game_ended");
    if (isdefined(level.water_wz_booted)) return;
    level.water_wz_booted = 1;
    level thread [[ &noice_flyover_boot ]]();
    water_wz_log("[NoiceWZ] boot v31.9.10 DIAG\n", true);
    level.water_wz_forced_uav_before = getdvarint(@"scr_game_forceuav", 0);
    system::function_3f680182ad0b9ef7();
    water_wz_log("[NoiceWZ] native systems ready\n", false);
    while (!isdefined(level.gametype)) wait 0.25;
    mode = level.gametype;
    if (mode != "br" && !issubstr(mode, "br_"))
    {
        water_wz_log("[NoiceWZ] inactive: mode=" + mode + "\n", true);
        return;
    }
    level.noice_wz_map_fix = noice_wz_map_profile(getdvar(@"g_mapname"), level.script);
    if (level.noice_wz_map_fix == "fortunes_keep") level thread [[ &noice_fk_tracking_guard_worker ]]();
    noice_wz_tuning_initialize();
    level thread [[ &noice_wz_tuning_worker ]]();
    setdvar(@"scr_game_forceuav", 0);
    water_wz_log("[NoiceWZ] forced_uav_before=" + level.water_wz_forced_uav_before + "\n", false);
    level thread [[ &water_wz_forced_radar_cleanup ]]();
    level.water_wz_next_loadout_slot = 0;
    level.water_wz_next_airstrike = gettime() + water_wz_strike_delay();
    level.water_wz_last_supply = undefined;
    level.water_wz_shots = [];
    level.water_wz_humans = [];
    level.water_wz_attached = 0;
    level.water_wz_purchased = 0;
    level.water_wz_hunted = 0;
    level.water_wz_equipped = 0;
    level.water_wz_streaks = 0;
    level.water_wz_investigations = 0;
    level.water_wz_human_focus = 0;
    level.water_wz_bot_focus = 0;
    level.water_wz_handoffs = 0;
    level.water_wz_recoveries = 0;
    level.water_wz_goal_failures = 0;
    level.water_wz_landings = 0;
    level.water_wz_projection_failures = 0;
    level.water_wz_unsafe_goals = 0;
    level.water_wz_native_rejections = 0;
    level.water_wz_actual_goal_sets = 0;
    level.water_wz_cached_goals = 0;
    level.water_wz_scaled_hits = 0;
    level.water_wz_finish_shots = 0;
    level.water_wz_jump_moves = 0;
    level.water_wz_drop_moves = 0;
    level.water_wz_sprint_requests = 0;
    level.water_wz_sprint_windows = 0;
    level.water_wz_radar_repairs = 0;
    level.water_wz_radar_ticks = 0;
    level.water_wz_ranged_human_shots = 0;
    level.water_wz_self_revives = 0;
    level.water_wz_local_defenses = 0;
    level.water_wz_local_pushes = 0;
    level.water_wz_duel_shots = 0;
    level.water_wz_cover_plans = 0;
    level.water_wz_retreats = 0;
    level.water_wz_plate_requests = 0;
    level.water_wz_opportunity_pushes = 0;
    level.water_wz_third_parties = 0;
    level.water_wz_rotations = 0;
    level.water_wz_grenade_requests = 0;
    level.water_wz_grenade_cancels = 0;
    level.water_wz_next_human_grenade = 0;
    level.water_wz_hunt_replacements = 0;
    level.water_wz_search_plans = 0;
    level.water_wz_armor_grants = 0;
    level.water_wz_plate_resupplies = 0;
    level.water_wz_plate_insertions = 0;
    level.water_wz_plate_failures = 0;
    level.water_wz_fast_reactions = 0;
    level.water_wz_water_rescues = 0;
    level.water_wz_next_water_rescue = 0;
    level.water_wz_cash_claims = [];
    level.water_wz_follow_regroups = 0;
    level.water_wz_revive_claims = [];
    level.water_wz_revive_attempts = 0;
    level.water_wz_revives = 0;
    level.water_wz_revive_fails = 0;
    level.water_wz_plate_gifts = 0;
    level.water_wz_caches_opened = 0;
    level.water_wz_loot_taken = 0;
    level.water_wz_buybacks = 0;
    level.water_wz_banks = 0;
    level.water_wz_bank_value = 0;
    level.water_wz_vehicle_boards = 0;
    level.water_wz_cash_targets = 0;
    level.water_wz_cash_pickups = 0;
    level.water_wz_cash_value = 0;
    level.water_wz_cash_failures = 0;
    level.water_wz_cash_scans = 0;
    level.water_wz_cash_scan_frame = -1;
    level.water_wz_cash_scan_count = 0;
    level.noice_wz_mark_times = [];
    level.noice_wz_pings_created = 0;
    level.noice_wz_player_orders = 0;
    level.water_wz_hunt_slots = [];
    level.water_wz_hunt_limit = water_wz_hunt_budget(randomint(100));
    level.water_wz_next_hunt_limit = gettime() + randomintrange(30000, 60000);

    while (!isdefined(level.modifyplayerdamage)) wait 0.25;
    level.water_wz_native_damage = level.modifyplayerdamage;
    level.modifyplayerdamage = &water_wz_modify_damage;
    water_wz_log("[NoiceWZ] bot-on-bot damage scale=" + getdvarfloat(@"noice_wz_damage_to_bot", 0.15) + " after native clamps; bot-to-human scale=" + getdvarfloat(@"noice_wz_damage_to_player", 1.66) + "\n", false);
    water_wz_log("[NoiceWZ] active Warzone; speed=" + getdvarfloat(@"noice_wz_speed") + "\n", true);
    level thread [[ &water_wz_heartbeat ]]();
    level thread [[ &noice_wz_ping_worker ]]();
    first_scan = true;
    for (;;)
    {
        water_wz_preserve_population();
        if (isdefined(level.players))
        {
            humans = [];
            foreach (player in level.players)
            {
                if (!isdefined(player)) continue;
                if (!isbot(player)) humans[humans.size] = player;
                if (isdefined(player.water_wz_managed)) continue;
                player.water_wz_managed = 1;
                player thread [[ &water_wz_hear_shots ]]();
                if (isbot(player)) player thread [[ &water_wz_supervise ]]();
                else
                {
                    player thread [[ &water_wz_human_notice ]]();
                    player thread [[ &water_wz_radar_watch ]]();
                    player thread [[ &noice_wz_player_mark_watch ]]();
                }
            }
            level.water_wz_humans = humans;
        }
        water_wz_replace_hunters();
        if (first_scan)
        {
            first_scan = false;
            water_wz_log("[NoiceWZ] initial player scan complete\n", false);
        }
        wait 0.5;
    }
}

function water_wz_preserve_population()
{
    if (!getdvarint(@"noice_wz_enabled", 1)) return;

    if (!isdefined(level.water_wz_random_fights_paused))
    {
        setdvar(@"hash_e0ec70c334cf532a", 86400);
        level.water_wz_random_fights_paused = 1;
        water_wz_log("[NoiceWZ] random-fight population removals paused\n", false);
    }
    if (!isdefined(level.var_de1b021064d0f5bb) || !isdefined(level.var_de1b021064d0f5bb.points)) return;
    if (level.var_de1b021064d0f5bb.points.size == 0 || level.var_de1b021064d0f5bb.points[0][0] != 86400 || level.var_de1b021064d0f5bb.points[0][1] != 10000)
    {
        level.water_wz_original_survival_points = level.var_de1b021064d0f5bb.points;
        metadata = getdvarint(@"hash_116700c9b39c1eba", getdvarint(@"party_maxplayers", 150)) * 100 + 30;
        if (level.water_wz_original_survival_points.size > 0) metadata = level.water_wz_original_survival_points[0][2];
        level.var_de1b021064d0f5bb.points = [];
        level.var_de1b021064d0f5bb.points[0] = (86400, 10000, metadata);
        level.var_de1b021064d0f5bb.curindex = 0;
        level.water_wz_population_guard = 1;
        water_wz_log("[NoiceWZ] survival curve protected, including empty native curves\n", false);
    }

    if (isdefined(level.water_wz_native_consider_dead) || !isdefined(level.brgametype) || !isdefined(level.brgametype.funcs) || !isdefined(level.brgametype.funcs["mayConsiderPlayerDead"])) return;
    level.water_wz_native_consider_dead = level.brgametype.funcs["mayConsiderPlayerDead"];

    level.brgametype.funcs["mayConsiderPlayerDead"] = &water_wz_consider_dead;
    water_wz_log("[NoiceWZ] population_guard applied: survival culling/random-fight removals paused; natural BR deaths retained\n", false);
}

function water_wz_consider_dead(player)
{
    if (isdefined(player) && isbot(player)) return undefined;
    return [[ level.water_wz_native_consider_dead ]](player);
}

function water_wz_heartbeat()
{
    level endon("game_ended");
    for (;;)
    {
        wait 20;
        nav = isnavmeshloaded();
        water_wz_log("[NoiceWZ] heartbeat bots=" + level.water_wz_attached + " nav=" + nav + " hunts=" + level.water_wz_hunted + " purchases=" + level.water_wz_purchased + " loadouts=" + level.water_wz_equipped + " streaks=" + level.water_wz_streaks + " investigations=" + level.water_wz_investigations + " human_focus=" + level.water_wz_human_focus + " bot_focus=" + level.water_wz_bot_focus + " handoffs=" + level.water_wz_handoffs + " recoveries=" + level.water_wz_recoveries + " goal_failures=" + level.water_wz_goal_failures + " landings=" + level.water_wz_landings + "\n", false);
        water_wz_pressure_diagnostics();
        water_wz_radar_diagnostics();
        water_wz_log("[NoiceWZ] radar_repairs=" + level.water_wz_radar_repairs + " ranged_human_fire_requests=" + level.water_wz_ranged_human_shots + "\n", false);
        water_wz_prune_hunts();
        water_wz_log("[NoiceWZ] hunt_slots active=" + level.water_wz_hunt_slots.size + " limit=" + level.water_wz_hunt_limit + " replacements=" + level.water_wz_hunt_replacements + " search_plans=" + level.water_wz_search_plans + "\n", false);
        water_wz_log("[NoiceWZ] combat_summary scaled_bot_hits=" + level.water_wz_scaled_hits + " finish_shots=" + level.water_wz_finish_shots + " jumps=" + level.water_wz_jump_moves + " drops=" + level.water_wz_drop_moves + " sprint_requests=" + level.water_wz_sprint_requests + " native_slide_windows=" + level.water_wz_sprint_windows + " local_defenses=" + level.water_wz_local_defenses + " local_push_goals=" + level.water_wz_local_pushes + " duel_shots=" + level.water_wz_duel_shots + "\n", false);
        water_wz_log("[NoiceWZ] tactics cover=" + level.water_wz_cover_plans + " retreats=" + level.water_wz_retreats + " plate_requests=" + level.water_wz_plate_requests + " grenade_requests=" + level.water_wz_grenade_requests + " grenade_cancels=" + level.water_wz_grenade_cancels + " opportunity_pushes=" + level.water_wz_opportunity_pushes + " third_parties=" + level.water_wz_third_parties + " rotations=" + level.water_wz_rotations + "\n", false);
        water_wz_armor_diagnostics();
        water_wz_cash_diagnostics();
    }
}

function water_wz_pressure_diagnostics()
{
    if (!isdefined(level.players)) return;
    ready = 0;
    other_controller = 0;
    missing_controller = 0;
    hunters = 0;
    close_hunters = 0;
    nearby_hunters = 0;
    replaced = 0;
    samples = 0;
    foreach (bot in level.players)
    {
        if (!isdefined(bot) || !isbot(bot) || !isdefined(bot.water_wz_managed)) continue;
        if (bot.water_wz_nav_controller == "other") other_controller++;
        if (bot.water_wz_nav_controller == "missing") missing_controller++;
        if (!water_wz_in_map(bot)) continue;
        ready++;
        human = bot.water_wz_human;
        if (!bot water_wz_has_hunt(human) || !water_wz_in_map(human)) continue;
        hunters++;
        remaining = distancesquared(bot.origin, human.origin);
        if (remaining <= 4000000) close_hunters++;
        if (remaining <= 36000000) nearby_hunters++;
        has_goal = bot bothasscriptgoal();
        changed = false;
        goal_remaining = -1;
        target_offset = -1;
        if (has_goal)
        {
            actual = bot botgetscriptgoal();
            goal_remaining = distancesquared(bot.origin, actual);
            target_offset = distancesquared(actual, human.origin);
            if (isdefined(bot.water_wz_goal_point)) changed = distancesquared(actual, bot.water_wz_goal_point) >= 4096;
        }
        if (changed) replaced++;
        if (samples >= 4) continue;
        samples++;
        closer = -1;
        moved = -1;
        if (isdefined(bot.water_wz_diag_previous_human) && bot.water_wz_diag_previous_human == human)
        {
            closer = remaining < bot.water_wz_diag_previous_distance;
            moved = distancesquared(bot.origin, bot.water_wz_diag_previous_origin);
        }
        bot.water_wz_diag_previous_human = human;
        bot.water_wz_diag_previous_distance = remaining;
        bot.water_wz_diag_previous_origin = bot.origin;
        water_wz_log("[NoiceWZ] pressure_sample bot=" + bot getentitynumber() + " owner=" + bot.water_wz_nav_controller + " target_dist_sq=" + remaining + " goal_dist_sq=" + goal_remaining + " goal_target_offset_sq=" + target_offset + " has_path=" + bot botpathexists() + " goal_changed=" + changed + " visible=" + bot botcanseeentity(human) + " closer=" + closer + " moved_sq=" + moved + " goal_status=" + bot.water_wz_goal_status + " trade=" + isdefined(bot.water_wz_trade) + " streak=" + bot.water_wz_using_streak + "\n", false);
    }
    water_wz_log("[NoiceWZ] pressure_summary ready=" + ready + " other_controller=" + other_controller + " missing_controller=" + missing_controller + " live_hunters=" + hunters + " within_50m=" + close_hunters + " within_150m=" + nearby_hunters + " replaced_goals=" + replaced + " automation=" + getdvarint(@"enable_automation_bot", 0) + " projected_fail=" + level.water_wz_projection_failures + " unsafe=" + level.water_wz_unsafe_goals + " native_reject=" + level.water_wz_native_rejections + " actual_sets=" + level.water_wz_actual_goal_sets + " cached=" + level.water_wz_cached_goals + "\n", false);
}

// Persistent banner: a client HUD text element along the bottom-centre edge of
// the screen that stays up for the whole match (hidden while menus are open).
function water_wz_human_notice()
{
    self endon("disconnect");
    level endon("game_ended");
    while (!isalive(self)) wait 0.25;
    self thread [[ &water_wz_banner_cleanup ]]();
    for (;;)
    {
        if (!isdefined(self.water_wz_banner))
        {
            banner = newclienthudelem(self);
            banner.x = 320;
            banner.y = 476;
            banner.alignx = "center";
            banner.aligny = "bottom";
            banner.horzalign = "fullscreen";
            banner.vertalign = "fullscreen";
            banner.font = "smallfixed";
            banner.fontscale = 1.0;
            banner.sort = 5;
            banner.foreground = 1;
            banner.archived = 0;
            banner.hidewheninmenu = 1;
            banner.alpha = 0.85;
            banner settext("^5noice's warzone bots ^7| v31.9.10 DIAG | speed 1.5 | 2-5 initial drops | plunder cash");
            self.water_wz_banner = banner;
        }
        wait 1;
    }
}

function water_wz_banner_cleanup()
{
    self endon("disconnect");
    level waittill("game_ended");
    if (isdefined(self.water_wz_banner)) self.water_wz_banner destroy();
    self.water_wz_banner = undefined;
}

function water_wz_radar_watch()
{
    self endon("disconnect");
    level endon("game_ended");
    next_reveal_sample = 0;
    for (;;)
    {
        water_wz_radar_tick();
        if (gettime() >= next_reveal_sample)
        {
            water_wz_reveal_sample();
            next_reveal_sample = gettime() + 500;
        }
        wait 0.1;
    }
}

function water_wz_radar_tick()
{
    if (gamelogic::inprematch() || !isalive(self) || !isdefined(self.sessionstate) || self.sessionstate != "playing" || self scripts\mp\gametypes\br_public::isplayerinorgoingtogulag()) return;
    if (!isdefined(level.teambased) || !level.teambased || !isdefined(self.team)) return;
    if ((isdefined(self.insidecuavbunker) && self.insidecuavbunker) || (isdefined(self.skipuavupdate) && self.skipuavupdate) || (isdefined(self.var_8fee5ee1de16c41f) && self.var_8fee5ee1de16c41f)) return;
    if (!isdefined(level.activeuavs) || !isdefined(level.activeuavs[self.team]) || !isdefined(level.activeadvanceduavs) || !isdefined(level.activeadvanceduavs[self.team]) || !isdefined(level.activecounteruavs) || !isdefined(level.activecounteruavs[self.team]) || !isdefined(level.totalactivecounteruavs)) return;
    level.water_wz_radar_ticks++;

    data = uav::function_ddcbf96c5ef69597(self.team, undefined);
    previous = self.radarstrength;
    uav::function_13b8682b55619852(self, data);
    if (isdefined(previous) && previous != self.radarstrength) level.water_wz_radar_repairs++;
}

function water_wz_log(message, important)
{
    // Keep diagnostic sampling and native argument evaluation independent of output.
    if (important || getdvarint(@"noice_wz_debug", getdvarint(@"water_wz_debug", 0))) logprint(message);
}

function water_wz_log_value(value)
{
    if (!isdefined(value)) return "unset";
    return value;
}

function water_wz_radar_diagnostics()
{
    if (!isdefined(level.players)) return;
    mode = level.gametype;
    if (isdefined(level.gametypebundle) && isdefined(level.gametypebundle.brsubgametype)) mode = level.gametypebundle.brsubgametype;
    foreach (player in level.players)
    {
        if (!isdefined(player) || isbot(player)) continue;
        own_uav = -1;
        own_advanced = -1;
        own_counter = -1;
        own_portable = -1;
        if (isdefined(player.team))
        {
            if (isdefined(level.activeuavs) && isdefined(level.activeuavs[player.team])) own_uav = level.activeuavs[player.team];
            if (isdefined(level.activeadvanceduavs) && isdefined(level.activeadvanceduavs[player.team])) own_advanced = level.activeadvanceduavs[player.team];
            if (isdefined(level.activecounteruavs) && isdefined(level.activecounteruavs[player.team])) own_counter = level.activecounteruavs[player.team];
            if (isdefined(level.var_1a92f34363247d37) && isdefined(level.var_1a92f34363247d37[player.team])) own_portable = level.var_1a92f34363247d37[player.team].size;
        }
        gulag = player scripts\mp\gametypes\br_public::isplayerinorgoingtogulag();
        water_wz_log("[NoiceWZ] radar_state mode=" + water_wz_log_value(mode) + " human=" + player getentitynumber() + " team=" + water_wz_log_value(player.team) + " teambased=" + water_wz_log_value(level.teambased) + " prematch=" + gamelogic::inprematch() + " alive=" + isalive(player) + " gulag=" + water_wz_log_value(gulag) + " session=" + water_wz_log_value(player.sessionstate) + " strength=" + water_wz_log_value(player.radarstrength) + " hasradar=" + water_wz_log_value(player.hasradar) + " radarmode=" + water_wz_log_value(player.radarmode) + " own_uav=" + water_wz_log_value(own_uav) + " own_advanced=" + water_wz_log_value(own_advanced) + " own_counter=" + water_wz_log_value(own_counter) + " own_portable=" + water_wz_log_value(own_portable) + " hide_weapon_pings=" + water_wz_log_value(level.radarhideshots) + " skip=" + water_wz_log_value(player.skipuavupdate) + " bunker=" + water_wz_log_value(player.insidecuavbunker) + " native_skip=" + water_wz_log_value(player.var_8fee5ee1de16c41f) + " applied_ticks=" + level.water_wz_radar_ticks + " repairs=" + level.water_wz_radar_repairs + "\n", false);
    }
}

function water_wz_reveal_sample()
{
    if (!isdefined(level.gametypebundle) || !isdefined(level.gametypebundle.brsubgametype) || !issubstr(level.gametypebundle.brsubgametype, "resurg")) return;
    tracked = self getclientomnvar("ui_br_resurgence_tracked_teams");
    nemeses = self getclientomnvar("ui_resurgence_team_nemeses");
    tracking = self getclientomnvar("ui_br_interrogate_tracking_other_team");
    if (isdefined(self.water_wz_reveal_tracked) && tracked == self.water_wz_reveal_tracked && nemeses == self.water_wz_reveal_nemeses && tracking == self.water_wz_reveal_tracking) return;
    self.water_wz_reveal_tracked = tracked;
    self.water_wz_reveal_nemeses = nemeses;
    self.water_wz_reveal_tracking = tracking;
    circle = -1;
    respawn_enabled = -1;
    if (isdefined(level.br_circle) && isdefined(level.br_circle.circleindex)) circle = level.br_circle.circleindex;
    if (isdefined(level.brgametype) && isdefined(level.brgametype.respawnenable)) respawn_enabled = level.brgametype.respawnenable;
    water_wz_log("[NoiceWZ] resurgence_reveal human=" + self getentitynumber() + " tracked_teams=" + tracked + " nemeses=" + nemeses + " tracking_other_team=" + tracking + " respawn_enabled=" + respawn_enabled + " circle=" + circle + "\n", false);
}

function water_wz_forced_radar_cleanup()
{
    level endon("game_ended");

    wait 1.25;
    water_wz_clear_forced_radar();
}

function water_wz_clear_forced_radar()
{
    if (level.water_wz_forced_uav_before == 0 || !isdefined(level.teambased) || !level.teambased || !isdefined(level.totalactiveuavs) || level.totalactiveuavs != 0 || !isdefined(level.teamnamelist) || !isdefined(level.activeuavs) || !isdefined(level.activeadvanceduavs)) return;

    foreach (team in level.teamnamelist)
    {
        level.activeuavs[team] = 0;
        level.activeadvanceduavs[team] = 0;
        uav::uav_updateteamstatus(team, undefined);
    }
    level.activeadvanceduavcount = 0;
    water_wz_log("[NoiceWZ] forced_uav_synthetic_counters_cleared\n", false);
}

function water_wz_in_map(player)
{
    return water_wz_deployed(player, false);
}

function water_wz_target_state(alive, playing, downed, allow_downed, infil, airborne, gulag, remote)
{
    return alive && playing && (!downed || allow_downed) && !infil && !airborne && !gulag && !remote;
}

function water_wz_deployed(player, allow_downed)
{
    if (!isdefined(player) || !isalive(player)) return false;
    playing = isdefined(player.sessionstate) && player.sessionstate == "playing";
    downed = isdefined(player.inlaststand) && player.inlaststand;
    infil = isdefined(player.br_infil_type);
    airborne = player isskydiving() || player isparachuting();
    gulag = player scripts\mp\gametypes\br_public::isplayerinorgoingtogulag();
    remote = isdefined(player.isusingremote) && player.isusingremote;
    return water_wz_target_state(true, playing, downed, allow_downed, infil, airborne, gulag, remote);
}

function water_wz_damage_amount(amount, enabled, victim_bot, attacker_bot, same_entity, gulag)
{
    if (enabled && victim_bot && attacker_bot && !same_entity && !gulag && amount > 0) return amount * min(10, max(0, getdvarfloat(@"noice_wz_damage_to_bot", 0.15)));
    if (enabled && !victim_bot && attacker_bot && !same_entity && !gulag && amount > 0) return amount * min(10, max(0, getdvarfloat(@"noice_wz_damage_to_player", 1.66)));
    return amount;
}

function water_wz_damage_owner(attacker, inflictor)
{
    if (isdefined(attacker) && isplayer(attacker)) return attacker;
    if (isdefined(attacker) && isdefined(attacker.owner) && isplayer(attacker.owner)) return attacker.owner;
    if (isdefined(inflictor) && isdefined(inflictor.streakinfo) && isdefined(inflictor.streakinfo.owner) && isplayer(inflictor.streakinfo.owner)) return inflictor.streakinfo.owner;
    if (isdefined(inflictor) && isdefined(inflictor.owner) && isplayer(inflictor.owner)) return inflictor.owner;
    return undefined;
}

function water_wz_fractional_damage(amount, carry)
{
    result = spawnstruct();
    result.amount = amount;
    result.carry = carry;
    if (amount <= 0) return result;
    total = amount + carry;
    result.amount = int(total + 0.000001);
    result.carry = total - result.amount;
    if (result.carry < 0) result.carry = 0;
    return result;
}

function water_wz_modify_damage(inflictor, victim, attacker, damage, means, weapon, point, direction, hitloc, flags, weapon_damage)
{
    if (getdvarint(@"noice_wz_enabled", 1) && means == "MOD_FALLING" && isdefined(victim) && isplayer(victim) && isbot(victim)) return 0;

    if (damage > 0 && isdefined(victim) && isdefined(attacker) && isplayer(victim) && isplayer(attacker) && isbot(victim) && !isbot(attacker))
    {
        victim.water_wz_hit_human = attacker;
        victim.water_wz_hit_time = gettime();
    }
    owner = water_wz_damage_owner(attacker, inflictor);
    if (damage > 0 && isdefined(victim) && isplayer(victim) && isdefined(owner) && owner != victim)
    {
        // Squad focus: remember who each human is fighting.
        if (!isbot(owner)) water_wz_note_human_focus(owner, victim);
        if (!isbot(victim)) water_wz_note_human_focus(victim, owner);
    }

    damage = [[ level.water_wz_native_damage ]](inflictor, victim, attacker, damage, means, weapon, point, direction, hitloc, flags, weapon_damage);
    if (getdvarint(@"noice_wz_enabled", 1) && damage > 0 && isdefined(victim) && isplayer(victim) && isbot(victim))
    {
        victim.water_wz_last_hurt = gettime();

        if ((isdefined(victim.water_wz_plate_override) && victim.water_wz_plate_override) || (isdefined(victim.insertingarmorplate) && victim.insertingarmorplate) || (isdefined(victim.armorqueued) && victim.armorqueued > 0))
            victim notify("armor_cancel", "noice_plate_damage_delay", "hit");
    }
    bot_attacker = isdefined(victim) && isplayer(victim) && isdefined(owner) && isbot(owner);
    if (bot_attacker && getdvarint(@"noice_wz_enabled", 1) && victim != owner && !victim scripts\mp\gametypes\br_public::isplayerinorgoingtogulag() && !owner scripts\mp\gametypes\br_public::isplayerinorgoingtogulag())
    {
        if (damage > 0) level.water_wz_scaled_hits++;
        damage = water_wz_damage_amount(damage, true, isbot(victim), true, false, false);
        if (isbot(victim))
        {
            if (!isdefined(victim.water_wz_damage_carry)) victim.water_wz_damage_carry = 0;
            fractional = water_wz_fractional_damage(damage, victim.water_wz_damage_carry);
            victim.water_wz_damage_carry = fractional.carry;
            damage = fractional.amount;
        }
    }
    return damage;
}

function water_wz_reset_encounter()
{
    self.water_wz_encounter = undefined;
    self.water_wz_nearby_bot = undefined;
    self.water_wz_dueling_bot = false;
    self.water_wz_defending = false;
}

function water_wz_reset_contact()
{
    self.water_wz_contact = undefined;
    self.water_wz_contact_point = undefined;
    self.water_wz_contact_time = undefined;
    self.water_wz_contact_velocity = undefined;
    self.water_wz_next_contact_velocity = 0;
}

function water_wz_reset_search()
{
    self.water_wz_search_active = false;
    self.water_wz_search_points = undefined;
    self.water_wz_search_time = undefined;
    self.water_wz_search_target = undefined;
}

function water_wz_watch_spawn()
{
    self endon("disconnect");
    level endon("game_ended");
    for (;;)
    {
        self waittill("spawned_player");
        water_wz_plate_release(true);
        self botsetflag("disable_attack", 0);
        self.water_wz_spawn_serial++;
        self.water_wz_last_hurt = -100000;
        self.water_wz_armor_ready_serial = undefined;
        self.water_wz_armor_ready_since = undefined;
        self botsetflag("force_sprint", 0);
        self.water_wz_goal_retry_point = undefined;
        self.water_wz_goal_retry_after = 0;
        self.water_wz_goal_kind = undefined;
        self.water_wz_damage_carry = 0;
        self.water_wz_revive_used = false;
        self.water_wz_revive_granted = false;
        self.water_wz_revive_deadline = undefined;
        self.water_wz_native_paused = false;
        self notify("water_wz_native_helpers_stop");
        self.water_wz_native_kind = undefined;
        self.water_wz_saved_native_controller = undefined;
        self.water_wz_destination_released = false;
        self.water_wz_landing = undefined;
        self.water_wz_drop_start = undefined;
        self.water_wz_hit_human = undefined;
        self.water_wz_hit_time = undefined;
        self.noice_wz_order_serial = 0;
        self.noice_wz_order_done = false;
        water_wz_reset_encounter();
        water_wz_reset_contact();
        self.water_wz_loadout_started_serial = undefined;
        self.water_wz_owned_primary = undefined;
        self.water_wz_owned_secondary = undefined;
        water_wz_reset_tactics();
        self notify("water_wz_life_reset");
    }
}

function water_wz_can_start_loadout()
{
    return getdvarint(@"noice_wz_enabled", 1)
        && !water_wz_healing() && !water_wz_action_busy() && !self.water_wz_using_streak
        && gettime() >= self.water_wz_next_loadout_attempt
        && water_wz_hunt_eligible(self)
        && water_wz_loadout_due(self.water_wz_spawn_serial, self.water_wz_equipped_serial, water_wz_in_map(self), self.water_wz_ground_equipped_serial, water_wz_missing_loadout())
        && (!isdefined(self.water_wz_loadout_started_serial) || self.water_wz_loadout_started_serial != self.water_wz_spawn_serial)
        && water_wz_loadout_slot(gettime());
}

function water_wz_supervise()
{
    self endon("disconnect");
    level endon("game_ended");
    self.water_wz_spawn_serial = 0;
    self.water_wz_revive_used = false;
    self.water_wz_revive_granted = false;
    self.water_wz_free_revive_issued = false;
    self.water_wz_revive_deadline = undefined;
    self.water_wz_using_streak = false;
    self.water_wz_hunter = randomint(100) < 70;
    self.water_wz_personality = water_wz_personality(randomint(100));
    self.water_wz_flank_side = 1;
    if (randomint(2)) self.water_wz_flank_side = -1;
    water_wz_reset_tactics();
    water_wz_log("[NoiceWZ] personality bot=" + self getentitynumber() + " role=" + self.water_wz_personality + "\n", false);
    self.water_wz_native_paused = false;
    self.water_wz_destination_released = false;
    self.water_wz_nav_controller = "waiting";
    self.water_wz_goal_status = "none";
    self.water_wz_next_loadout_attempt = 0;
    self.water_wz_next_cash_scan = 0;
    self.noice_wz_next_enemy_ping = 0;
    self thread [[ &water_wz_watch_spawn ]]();
    self thread [[ &water_wz_plate_events ]]();
    previous = -1;
    running = false;
    level.water_wz_attached++;
    water_wz_log("[NoiceWZ] attached bot=" + self getentitynumber() + "\n", false);
    for (;;)
    {
        water_wz_plate_guard_tick();
        water_wz_self_revive_tick();
        water_wz_fast_landing();
        water_wz_water_tick();
        water_wz_starting_armor_tick();
        water_wz_plate_resupply_tick();

        if (water_wz_can_start_loadout())
        {
            self.water_wz_loadout_started_serial = self.water_wz_spawn_serial;
            self.water_wz_next_loadout_attempt = gettime() + 2000;
            self thread [[ &water_wz_equip_loadout ]]();
        }
        ready = water_wz_in_map(self) && getdvarint(@"noice_wz_enabled", 1);
        if (!ready)
        {
            if (running)
            {
                self notify("water_wz_life_reset");
                self botsetflag("force_sprint", 0);
                self botclearscriptenemy();
                self botsetflag("disable_attack", 0);
                self botclearscriptgoal();
                self botsetstance("none");
                self setmovespeedscale(1.0);
                water_wz_clear_trade();
                water_wz_reset_encounter();
                // This handoff clears contact identity only; spawn/rescue also clear its motion.
                self.water_wz_contact = undefined;
                self.water_wz_contact_time = undefined;
                water_wz_reset_tactics();
                running = false;
            }

            if (self.water_wz_native_paused && isalive(self) && (self.water_wz_native_kind == "automation" || !getdvarint(@"noice_wz_enabled", 1) || self scripts\mp\gametypes\br_public::isplayerinorgoingtogulag()))
            {
                water_wz_resume_native();
            }
        }
        else if (!running || previous != self.water_wz_spawn_serial)
        {
            if (!water_wz_take_navigation()) { wait 0.25; continue; }
            self notify("water_wz_life_reset");
            water_wz_clear_trade();
            self.water_wz_bought_loadout = false;
            self.water_wz_next_buy = gettime() + randomintrange(2500, 6000);
            self.water_wz_using_streak = false;
            if (!isdefined(self.water_wz_next_supply)) self.water_wz_next_supply = gettime() + randomintrange(20000, 45000);
            self.water_wz_target = undefined;
            self.water_wz_script_enemy = undefined;
            self.water_wz_encounter = undefined;
            self.water_wz_nearby_bot = undefined;
            self.water_wz_dueling_bot = false;
            water_wz_reset_tactics();
            self.water_wz_defending = false;
            self.water_wz_checked_shot = -1;
            self.water_wz_investigating_shot = -1;
            self.water_wz_goal_point = undefined;
            self.water_wz_next_goal = 0;
            self.water_wz_progress_origin = self.origin;
            self.water_wz_progress_time = gettime();
            self.water_wz_progress_remaining = undefined;
            self.water_wz_recover_until = 0;
            self.water_wz_move_until = 0;
            self.water_wz_next_move = gettime() + randomintrange(1200, 2400);
            self.water_wz_next_jump = gettime() + randomintrange(4000, 7000);
            self.water_wz_move_kind = "stand";
            water_wz_configure();
            self thread [[ &water_wz_navigate ]]();
            self thread [[ &water_wz_combat ]]();
            previous = self.water_wz_spawn_serial;
            running = true;
        }
        wait 0.25;
    }
}

function water_wz_water_point(point)
{
    feet = (point[0], point[1], point[2] + 8);
    body = (point[0], point[1], point[2] + 40);
    return utility::ispointinwater(feet) || utility::ispointinwater(body);
}

function water_wz_water_destination()
{
    if (!isnavmeshloaded() || !water_wz_circle_ready()) return undefined;
    start = 0;
    has_spots = isdefined(level.bot_landing_spots) && level.bot_landing_spots.size > 0;
    if (has_spots) start = randomint(level.bot_landing_spots.size);
    for (attempt = 0; attempt < 8; attempt++)
    {
        hint = undefined;
        if (has_spots && attempt < 4)
        {
            index = (start + attempt) % level.bot_landing_spots.size;
            spot = level.bot_landing_spots[index];
            if (isdefined(spot) && isdefined(spot.origin)) hint = spot.origin;
        }
        if (!isdefined(hint)) hint = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle(0, 0.8);

        point = getclosestpointonnavmesh(hint, self);
        if (!isdefined(point) || !water_wz_safe(point) || water_wz_water_point(point)) continue;
        destination = (point[0], point[1], point[2] + 4);

        if (attempt < 6)
        {
            crowded = false;
            humans = level.water_wz_humans;
            if (!isdefined(humans)) humans = level.players;
            if (isdefined(humans))
            {
                foreach (player in humans)
                {
                    if (!isdefined(player) || isbot(player) || !isalive(player) || !isdefined(player.origin)) continue;
                    if (distancesquared(destination, player.origin) < 589824) { crowded = true; break; }
                }
            }
            if (crowded) continue;
        }
        if (!canspawn(destination, self)) continue;

        endpoint = (destination[0], destination[1], destination[2] + 5);
        if (playerphysicstrace(destination, endpoint) != endpoint) continue;
        return destination;
    }
    return undefined;
}

function water_wz_water_cleanup()
{
    water_wz_search_clear();
    self botclearscriptgoal();
    self botclearscriptenemy();
    self.water_wz_script_enemy = undefined;
    self.water_wz_target = undefined;
    water_wz_reset_encounter();
    water_wz_reset_contact();
    self.water_wz_hit_human = undefined;
    self.water_wz_hit_time = undefined;
    self.water_wz_goal_point = undefined;
    self.water_wz_goal_request = undefined;
    self.water_wz_goal_kind = undefined;
    self.water_wz_goal_retry_point = undefined;
    self.water_wz_goal_retry_after = 0;
    self.water_wz_next_goal = 0;
    self.water_wz_recover_until = 0;
    self.water_wz_progress_remaining = undefined;
    self.water_wz_progress_origin = self.origin;
    self.water_wz_progress_time = gettime();
    self.water_wz_landing = undefined;
    self.water_wz_drop_human = undefined;
    self.water_wz_drop_start = undefined;
    self.desired_landing_spot = undefined;
    water_wz_reset_tactics();
    water_wz_slide_stop();
    self.water_wz_next_move = gettime() + 1000;
    self.water_wz_next_jump = gettime() + 4000;
}

function water_wz_water_tick()
{
    if (!isbot(self)) return;
    now = gettime();
    if (!isdefined(self.water_wz_water_spawn_serial) || self.water_wz_water_spawn_serial != self.water_wz_spawn_serial)
    {
        self.water_wz_water_spawn_serial = self.water_wz_spawn_serial;
        self.water_wz_water_since = undefined;
        self.water_wz_water_dry_since = undefined;
        self.water_wz_water_rescued = false;
        self.water_wz_next_water_rescue = 0;
        self.water_wz_next_water_probe = now + randomint(1000);
    }
    cinematic = (isdefined(level.infilcinematicactive) && level.infilcinematicactive) || (isdefined(level.infiltransistioning) && level.infiltransistioning);
    deployment_pending = (isdefined(game["liveLobbyCompleted"]) && !game["liveLobbyCompleted"]) || (isdefined(self.infil_landing_done) && !self.infil_landing_done);
    if (!getdvarint(@"noice_wz_enabled", 1) || gamelogic::inprematch() || cinematic || deployment_pending || !water_wz_deployed(self, false) || self islinked() || self isvehicleactive() || water_wz_riding())
    {
        self.water_wz_water_since = undefined;
        self.water_wz_water_dry_since = undefined;
        return;
    }
    swimming = self isswimming();
    grounded = self isonground();
    if (!swimming && !grounded)
    {
        self.water_wz_water_since = undefined;
        self.water_wz_water_dry_since = undefined;
        return;
    }

    if (!swimming)
    {
        if (now < self.water_wz_next_water_probe) return;
        self.water_wz_next_water_probe = now + 1000;
    }
    wet = swimming || water_wz_water_point(self.origin);
    if (!wet)
    {
        self.water_wz_water_since = undefined;
        if (grounded)
        {
            if (!isdefined(self.water_wz_water_dry_since)) self.water_wz_water_dry_since = now;
            if (now - self.water_wz_water_dry_since >= 1000) self.water_wz_water_rescued = false;
        }
        else self.water_wz_water_dry_since = undefined;
        return;
    }
    self.water_wz_water_dry_since = undefined;
    if (self.water_wz_water_rescued) return;
    if (!isdefined(self.water_wz_water_since)) self.water_wz_water_since = now;
    if (now - self.water_wz_water_since < 1000) return;
    if (water_wz_healing() || water_wz_action_busy() || isdefined(self.water_wz_trade) || (isdefined(self.water_wz_using_streak) && self.water_wz_using_streak) || isdefined(self.water_wz_loadout_started_serial)) return;
    if (now < self.water_wz_next_water_rescue) return;
    if (isdefined(level.water_wz_next_water_rescue) && now < level.water_wz_next_water_rescue) return;
    self.water_wz_next_water_rescue = now + 5000;
    level.water_wz_next_water_rescue = now + 350;
    destination = water_wz_water_destination();
    if (!isdefined(destination)) return;
    water_wz_water_cleanup();
    self setorigin(destination, 1);
    self setvelocity((0, 0, 0));
    self.water_wz_progress_origin = destination;
    self.water_wz_progress_time = now;
    self.water_wz_water_since = undefined;
    self.water_wz_water_rescued = true;
    if (!isdefined(level.water_wz_water_rescues)) level.water_wz_water_rescues = 0;
    level.water_wz_water_rescues++;
    water_wz_log("[NoiceWZ] water_rescued bot=" + self getentitynumber() + " position=" + destination + "\n", false);
}

function water_wz_restore_plate_stock(count)
{
    if (!isdefined(count) || count <= 0) return true;
    capacity = self armor::function_47320a25b8ee003();
    count = int(max(0, min(count, capacity)));
    if (count == 0) return true;
    weapon = armor::function_46cd39650beb293f();
    if (!isdefined(weapon) || !isdefined(self.equipment)) return false;

    if (!self hasweapon(weapon)) self giveweapon(weapon);
    self.equipment["health"] = "equip_armorplate";
    self armor::function_774133dc8df0ccd5(count);
    return self armor::function_20b8437058079297() >= count;
}

function water_wz_starting_armor_tick()
{
    if (!isbot(self) || !getdvarint(@"noice_wz_enabled", 1) || gamelogic::inprematch() || !isdefined(level.allowarmor) || !level.allowarmor || !water_wz_in_map(self) || water_wz_healing())
    {
        self.water_wz_armor_ready_serial = undefined;
        self.water_wz_armor_ready_since = undefined;
        return;
    }

    if ((isdefined(game["liveLobbyCompleted"]) && !game["liveLobbyCompleted"]) || (isdefined(self.infil_landing_done) && !self.infil_landing_done) || (isdefined(level.infilcinematicactive) && level.infilcinematicactive) || (isdefined(level.infiltransistioning) && level.infiltransistioning))
    {
        self.water_wz_armor_ready_serial = undefined;
        self.water_wz_armor_ready_since = undefined;
        return;
    }
    serial = self.water_wz_spawn_serial;
    if (isdefined(self.water_wz_armor_granted_serial) && self.water_wz_armor_granted_serial == serial) return;
    if (!isdefined(self.armorinitialized) || !self.armorinitialized) self armor::initarmor(0);
    if (!isdefined(self.maxarmorhealth) || self.maxarmorhealth <= 0) return;
    now = gettime();
    if (!isdefined(self.water_wz_armor_ready_serial) || self.water_wz_armor_ready_serial != serial)
    {
        self.water_wz_armor_ready_serial = serial;
        self.water_wz_armor_ready_since = now;
    }
    if (now - self.water_wz_armor_ready_since < 750) return;
    desired = max(0, self armor::function_47320a25b8ee003());
    reserve = self armor::function_20b8437058079297();
    if (reserve < desired && !water_wz_restore_plate_stock(desired)) return;

    if (!isdefined(self.water_wz_last_hurt) || self.water_wz_last_hurt < 0)
    {
        self armor::setarmorhealth(self.maxarmorhealth, 1);
        if (!isdefined(self.armorhealth) || self.armorhealth < self.maxarmorhealth) return;
    }

    self.water_wz_armor_granted_serial = serial;
    self.water_wz_plate_resupply_after = now + 30000;
    self.water_wz_plate_supply_serial = serial;
    level.water_wz_armor_grants++;
    water_wz_log("[NoiceWZ] starting_armor bot=" + self getentitynumber() + " spawn=" + serial + " armor=" + self.armorhealth + " max=" + self.maxarmorhealth + " reserve=" + self armor::function_20b8437058079297() + "\n", false);
}

function water_wz_plate_resupply_tick()
{
    if (!getdvarint(@"noice_wz_free_plates", 1)) return;
    serial = self.water_wz_spawn_serial;
    if (!isdefined(self.water_wz_armor_granted_serial) || self.water_wz_armor_granted_serial != serial) return;
    if (!getdvarint(@"noice_wz_enabled", 1) || gamelogic::inprematch() || !water_wz_in_map(self) || water_wz_healing()) return;
    if (!isdefined(self.water_wz_plate_resupply_after) || gettime() < self.water_wz_plate_resupply_after) return;
    if (!isdefined(self.armorhealth) || !isdefined(self.maxarmorhealth) || self.armorhealth >= self.maxarmorhealth) return;
    if (self armor::function_20b8437058079297() > 0 || gettime() - self.water_wz_last_hurt < 5000 || !water_wz_plate_safe()) return;

    count = max(0, min(6, self armor::function_47320a25b8ee003()));
    if (count <= 0 || !water_wz_restore_plate_stock(count)) return;
    self.water_wz_plate_resupply_serial = serial;
    self.water_wz_plate_resupply_after = gettime() + randomintrange(30000, 60001);
    level.water_wz_plate_resupplies++;
    water_wz_log("[NoiceWZ] plate_resupply bot=" + self getentitynumber() + " spawn=" + serial + " reserve=" + count + "\n", false);
}

function water_wz_armor_diagnostics()
{
    if (!isdefined(level.players)) return;
    ready = 0;
    full = 0;
    empty = 0;
    no_spares = 0;
    foreach (bot in level.players)
    {
        if (!isdefined(bot) || !isbot(bot) || !water_wz_in_map(bot) || !isdefined(bot.armorhealth) || !isdefined(bot.maxarmorhealth)) continue;
        ready++;
        if (bot.armorhealth >= bot.maxarmorhealth && bot.maxarmorhealth > 0) full++;
        if (bot.armorhealth <= 0) empty++;
        if (bot armor::function_20b8437058079297() <= 0) no_spares++;
    }
    water_wz_log("[NoiceWZ] armor_state ready=" + ready + " full=" + full + " empty=" + empty + " no_spares=" + no_spares + " starting_grants=" + level.water_wz_armor_grants + " resupplies=" + level.water_wz_plate_resupplies + " inserted=" + level.water_wz_plate_insertions + " plate_failures=" + level.water_wz_plate_failures + " fast_reactions=" + level.water_wz_fast_reactions + "\n", false);
}

function water_wz_self_revive_tick()
{
    if (!isbot(self) || !getdvarint(@"noice_wz_enabled", 1) || gamelogic::inprematch() || !water_wz_deployed(self, true))
    {
        self.water_wz_revive_deadline = undefined;
        return;
    }
    if (!getdvarint(@"noice_wz_self_revive", 0))
    {
        self.water_wz_revive_deadline = undefined;

        if (self scripts\mp\gametypes\br_public::hasselfrevivetoken())
            self scripts\mp\gametypes\br_pickups::removeselfrevivetoken();
        return;
    }
    downed = isdefined(self.inlaststand) && self.inlaststand;
    if (self.water_wz_revive_used)
    {

        if (downed || !self scripts\mp\gametypes\br_public::hasselfrevivetoken()) return;
        self.water_wz_revive_used = false;
    }
    if (!downed)
    {
        self.water_wz_revive_deadline = undefined;
        if (!self.water_wz_revive_granted && !self.water_wz_free_revive_issued)
        {
            if (!self scripts\mp\gametypes\br_public::hasselfrevivetoken())
                self scripts\mp\gametypes\br_pickups::addselfrevivetoken(1, undefined, undefined, 0);
            self.water_wz_revive_granted = self scripts\mp\gametypes\br_public::hasselfrevivetoken();
            if (self.water_wz_revive_granted) self.water_wz_free_revive_issued = true;
        }
        else if (!self scripts\mp\gametypes\br_public::hasselfrevivetoken())
            self.water_wz_revive_used = true;
        return;
    }
    if (!self scripts\mp\gametypes\br_public::hasselfrevivetoken()) return;

    if (self isinexecutionvictim() || (isdefined(self.beingrevived) && self.beingrevived) || (isdefined(self.isselfreviving) && self.isselfreviving))
    {
        self.water_wz_revive_deadline = undefined;
        return;
    }
    now = gettime();
    if (!isdefined(self.water_wz_revive_deadline)) self.water_wz_revive_deadline = now + 6000;
    if (now < self.water_wz_revive_deadline) return;
    self.water_wz_revive_used = true;
    self.water_wz_revive_deadline = undefined;

    if (self laststand::finishreviveplayer("self_revive_success", self))
    {
        self scripts\mp\gametypes\br_pickups::removeselfrevivetoken();
        level.water_wz_self_revives++;
        water_wz_log("[NoiceWZ] self_revived bot=" + self getentitynumber() + "\n", false);
    }
}

function water_wz_controller_kind(present, legacy_match, automation_match)
{
    if (!present) return "missing";
    if (legacy_match) return "legacy";
    if (automation_match) return "automation";
    return "other";
}

function water_wz_native_helper(callback)
{
    self endon("disconnect");
    self endon("death_or_disconnect");
    self endon("water_wz_native_helpers_stop");
    level endon("game_ended");
    self [[ callback ]]();
}

function water_wz_resume_native()
{
    if (!self.water_wz_native_paused || !isdefined(self.water_wz_saved_native_controller)) return;
    self notify("water_wz_native_helpers_stop");
    self.water_wz_native_paused = false;
    self.water_wz_nav_controller = self.water_wz_native_kind + "_resumed";
    self thread [[ self.water_wz_saved_native_controller ]]();
    water_wz_log("[NoiceWZ] native controller resumed bot=" + self getentitynumber() + " kind=" + self.water_wz_native_kind + "\n", false);
}

function water_wz_take_navigation()
{
    if (self.water_wz_native_paused) return true;
    if (!water_wz_in_map(self) || self islinked()) return false;
    if (gamelogic::inprematch()) return false;
    if (self scripts\mp\gametypes\br_public::isbrpracticemode() && !isdefined(self.infil_complete)) return false;
    if (self scripts\mp\bots\bots_strategy::bot_has_tactical_goal(undefined, undefined)) return false;
    if (!isdefined(level.bot_funcs) || !isdefined(level.bot_funcs["gametype_think"]))
    {
        self.water_wz_nav_controller = "missing";
        return true;
    }
    native = level.bot_funcs["gametype_think"];
    kind = water_wz_controller_kind(true, native == &bots_gametype_br::bot_br_think, native == &namespace_7823423e849112c7::function_f7453e13040e1140);
    if (kind == "other")
    {
        self.water_wz_nav_controller = "other";
        return false;
    }
    self.water_wz_native_kind = kind;
    self.water_wz_saved_native_controller = native;
    if (kind == "legacy" && !self.water_wz_destination_released)
    {
        self.water_wz_destination_released = true;
        self notify("goal");
        wait 0.1;
    }
    if (!water_wz_in_map(self) || self islinked()) return false;
    if (self scripts\mp\bots\bots_strategy::bot_has_tactical_goal(undefined, undefined)) return false;
    self.water_wz_native_paused = true;
    self.water_wz_nav_controller = kind + "_paused";
    if (kind == "automation")
    {

        self notify("bot_br_super_think");
        if (isdefined(self.mind)) self mind::function_cd40e795b7776f14();
    }
    else self notify("bot_br_think");
    if (!water_wz_in_map(self))
    {
        if (isalive(self)) water_wz_resume_native();
        return false;
    }
    self.ignoreall = 0;
    self botsetflag("disable_all_ai", 0);
    self botsetflag("suspended", 0);
    self botclearscriptgoal();
    if (kind == "automation")
    {
        self notify("water_wz_native_helpers_stop");
        self thread [[ &water_wz_native_helper ]](&namespace_7823423e849112c7::function_3b14fd3847fb5fe6);
        self thread [[ &water_wz_native_helper ]](&namespace_7823423e849112c7::function_290494c263cb346d);
        self thread [[ &water_wz_native_helper ]](&namespace_7823423e849112c7::function_b4b715fd038025c6);
    }
    level.water_wz_handoffs++;
    water_wz_log("[NoiceWZ] grounded navigation handoff bot=" + self getentitynumber() + " kind=" + kind + "\n", false);
    return true;
}

function water_wz_descent_speed(height, vertical_speed)
{
    if (height <= 1800 || vertical_speed >= 0) return vertical_speed;
    return max(-1000, min(-650, vertical_speed * 2.5));
}

function water_wz_landing_point()
{
    if (!isnavmeshloaded() || !water_wz_circle_ready()) return undefined;
    for (attempt = 0; attempt < 6; attempt++)
    {
        point = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle(0, 0.9);
        if (!water_wz_safe(point)) continue;
        projected = getclosestpointonnavmesh(point, self);
        if (isdefined(projected) && water_wz_safe(projected)) return projected;
    }
    return undefined;
}

function water_wz_fast_landing()
{
    if (!getdvarint(@"noice_wz_enabled", 1) || !isalive(self) || self.sessionstate != "playing") return;
    if (isdefined(self.br_infil_type) || self scripts\mp\gametypes\br_public::isplayerinorgoingtogulag()) return;
    if (!self isskydiving() && !self isparachuting())
    {

        if (!gamelogic::inprematch() && water_wz_in_map(self) && (isdefined(self.water_wz_first_drop_serial) || (isdefined(self.infil_complete) && self.infil_complete))) self.water_wz_initial_drop_closed = true;
        if (isdefined(self.water_wz_drop_start) && self.water_wz_native_paused) self botlookatpoint(undefined);
        self.water_wz_landing = undefined;
        self.water_wz_drop_human = undefined;
        self.water_wz_drop_start = undefined;
        return;
    }
    if (!gamelogic::inprematch() && !isdefined(self.water_wz_first_drop_serial)) self.water_wz_first_drop_serial = self.water_wz_spawn_serial;
    if (!isdefined(self.water_wz_drop_start)) self.water_wz_drop_start = gettime();
    if (gettime() - self.water_wz_drop_start < 750) return;
    ground = self scripts\mp\gametypes\br::groundraycast(self.origin);
    if (!isdefined(ground) || ground == (0, 0, 0)) return;
    height = self.origin[2] - ground[2];
    if (height > 1800 && !gamelogic::inprematch() && (!isdefined(self.water_wz_initial_drop_closed) || !self.water_wz_initial_drop_closed) && isdefined(self.water_wz_first_drop_serial) && self.water_wz_first_drop_serial == self.water_wz_spawn_serial && (!isdefined(self.water_wz_next_nearby_drop) || gettime() >= self.water_wz_next_nearby_drop))
    {
        self.water_wz_next_nearby_drop = gettime() + 500;
        nearby = water_wz_nearby_initial_drop();
        if (isdefined(nearby))
        {
            self.water_wz_landing = nearby;
            self.desired_landing_spot = nearby;
            level.water_wz_landings++;
        }
    }
    if (height > 1800 && (!isdefined(self.water_wz_landing) || !water_wz_safe(self.water_wz_landing)))
    {
        self.water_wz_landing = water_wz_landing_point();
        if (isdefined(self.water_wz_landing))
        {
            level.water_wz_landings++;

            self.desired_landing_spot = self.water_wz_landing;
        }
    }
    if (self.water_wz_native_paused)
    {

        if (!isdefined(self.desired_landing_spot)) self.desired_landing_spot = ground;
        delta = self.desired_landing_spot - self geteye();
        if (delta[2] > 0 && vectordot(vectornormalize(delta), (0, 0, 1)) > 0.939693)
            self.desired_landing_spot = self.origin - (0, 0, 100);
        angles = vectortoangles(self.desired_landing_spot - self.origin);
        self botlookatpoint(self.desired_landing_spot, 0.25, "script_forced");
        self botsetscriptmove(angles[1], 0.25, 1);
    }
    if (!self isparachuting()) return;
    velocity = self getvelocity();
    descent = water_wz_descent_speed(height, velocity[2]);
    if (descent != velocity[2]) self setvelocity((velocity[0], velocity[1], descent));
}

function water_wz_configure()
{
    self botsetdifficulty("veteran");
    if (isdefined(level.bot_personality_type)) self scripts\mp\bots\bots_util::bot_set_personality("run_and_gun");
    self allowcrouch(true);
    self allowprone(true);

    self botsetstance("stand");

    self botsetflag("allow_slide_for_any_script_goal", 1);
    self.water_wz_settings_dirty = true;
    water_wz_apply_settings();
}

function water_wz_apply_settings()
{
    speed = min(2.0, max(1.0, getdvarfloat(@"noice_wz_speed", 1.5)));

    self setmovespeedscale(speed);

    self botsetawareness(2.0);
    difficulty = self botgetdifficulty();
    if (!self.water_wz_settings_dirty && isdefined(self.water_wz_settings_difficulty) && difficulty == self.water_wz_settings_difficulty) return;
    self botsetdifficultysetting("minInaccuracy", 0);
    self botsetdifficultysetting("maxInaccuracy", 0);
    self botsetdifficultysetting("hitInaccuracyChance", 0);
    self botsetdifficultysetting("sniperInaccuracyScale", 0);
    self botsetdifficultysetting("minAimResponse", 0);
    self botsetdifficultysetting("maxAimResponse", 0);
    self botsetdifficultysetting("reactionTime", 0);
    self botsetdifficultysetting("averageEnemySightTime", 0);
    self botsetdifficultysetting("slideChance", 1);
    self botsetdifficultysetting("strafeChance", 1);
    self botsetdifficultysetting("intelligentSprintLevel", 2);
    self botsetdifficultysetting("hearingDeaf", 0);
    self botsetdifficultysetting("fireAtDeadTime", 0);
    self botsetdifficultysetting("chanceToSeekOutKiller", 1);
    self botsetdifficultysetting("allowGrenades", 1);
    self botsetdifficultysetting("adsDelayFireIn", 0);
    self botsetdifficultysetting("adsDelayFireOut", 0);
    self botsetdifficultysetting("adsDelayFireFullAuto", 0);
    self botsetdifficultysetting("adsDelayFireTime", 0);
    self botsetdifficultysetting("adsDelayFireTimeScoped", 0);
    self botsetdifficultysetting("minNonAutoFireDelay", 40);
    self botsetdifficultysetting("maxNonAutoFireDelay", 80);
    self botsetdifficultysetting("minBurstFireTime", 1000);
    self botsetdifficultysetting("maxBurstFireTime", 1500);
    self botsetdifficultysetting("minTimeBetweenBursts", 50);
    self botsetdifficultysetting("maxTimeBetweenBursts", 100);
    self botsetdifficultysetting("intelligentReload", 1);
    self botsetdifficultysetting("cornerFireChance", 1);
    self botsetdifficultysetting("cornerJumpChance", 0.1);
    self botsetdifficultysetting("minSwitchToCrouchCheckDelay", 60000);
    self botsetdifficultysetting("maxSwitchToCrouchCheckDelay", 60000);
    self botsetdifficultysetting("visionBlinded", 0);
    self botsetdifficultysetting("yawSpeed", 10);
    self botsetdifficultysetting("yawSpeedAds", 10);
    self botsetdifficultysetting("pitchSpeed", 10);
    self botsetdifficultysetting("pitchSpeedAds", 10);
    self.water_wz_settings_difficulty = difficulty;
    self.water_wz_settings_dirty = false;
}

function water_wz_missing_loadout()
{
    if (!isdefined(self.water_wz_owned_primary) || !isdefined(self.water_wz_owned_secondary)) return false;
    return !self hasweapon(self.water_wz_owned_primary) || !self hasweapon(self.water_wz_owned_secondary);
}

function water_wz_loadout_due(serial, equipped, grounded, ground_equipped, kit_missing)
{
    if (!isdefined(equipped) || equipped != serial) return true;
    return grounded && (!isdefined(ground_equipped) || ground_equipped != serial || kit_missing == true);
}

function water_wz_apply_reload_speed(serial)
{
    if (!isbot(self) || !isdefined(serial) || !isdefined(self.water_wz_spawn_serial) || serial != self.water_wz_spawn_serial || !getdvarint(@"noice_wz_enabled", 1)) return false;
    self setperk("specialty_fastreload", 1);
    return true;
}

function water_wz_equip_loadout()
{
    self endon("disconnect");
    self endon("death");
    self endon("spawned_player");
    level endon("game_ended");
    if (water_wz_healing() || water_wz_action_busy() || self.water_wz_using_streak || !water_wz_loadout_due(self.water_wz_spawn_serial, self.water_wz_equipped_serial, water_wz_in_map(self), self.water_wz_ground_equipped_serial, water_wz_missing_loadout()))
    {
        self.water_wz_loadout_started_serial = undefined;
        return;
    }
    serial = self.water_wz_spawn_serial;
    if (!isdefined(level.botloadouts) || !isdefined(level.botloadouts.initialized) || !level.botloadouts.initialized)
    {
        self.water_wz_loadout_started_serial = undefined;
        return;
    }

    if (!isdefined(self.water_wz_spawn_loadout))
    {
        primary = water_wz_pick_spawn_loadout(false);
        secondary = water_wz_pick_spawn_loadout(true);
        self.water_wz_spawn_loadout = water_wz_combine_loadout(primary, secondary);
    }
    self.classcallback = &water_wz_loadout_callback;
    water_wz_random_operator();

    classdata = self scripts\mp\class::loadout_getclassstruct();
    classdata = self scripts\mp\class::loadout_updateclass(classdata, "callback");
    self.water_wz_primary_blueprint = "none";
    self.water_wz_secondary_blueprint = "none";
    water_wz_apply_blueprint(classdata, false);
    water_wz_apply_blueprint(classdata, true);
    self scripts\mp\class::loadout_updateclassfinalweapons(classdata);

    self scripts\mp\class::preloadandqueueclassstruct(classdata, 1, 0);
    if (serial != self.water_wz_spawn_serial || !getdvarint(@"noice_wz_enabled", 1) || !water_wz_hunt_eligible(self) || water_wz_healing() || water_wz_action_busy() || self.water_wz_using_streak)
    {
        self.water_wz_loadout_started_serial = undefined;
        return;
    }
    plate_reserve_before = self armor::function_20b8437058079297();
    scripts\mp\gametypes\br::br_giveselectedclass(self, 0, 0);
    water_wz_apply_reload_speed(serial);

    if (serial == self.water_wz_spawn_serial && water_wz_in_map(self) && self armor::function_20b8437058079297() < plate_reserve_before) water_wz_restore_plate_stock(plate_reserve_before);
    if (isdefined(self.water_wz_operator)) self scripts\mp\teams::setupplayermodel();
    if (isdefined(self.classstruct.loadoutprimaryobject))
    {
        self givemaxammo(self.classstruct.loadoutprimaryobject);
        self switchtoweapon(self.classstruct.loadoutprimaryobject);
    }
    if (isdefined(self.classstruct.loadoutsecondaryobject)) self givemaxammo(self.classstruct.loadoutsecondaryobject);
    primary_held = isdefined(self.classstruct.loadoutprimaryobject) && self hasweapon(self.classstruct.loadoutprimaryobject);
    secondary_held = isdefined(self.classstruct.loadoutsecondaryobject) && self hasweapon(self.classstruct.loadoutsecondaryobject);
    grounded = water_wz_in_map(self);

    water_wz_log("[NoiceWZ] kit_result bot=" + self getentitynumber() + " primary=" + self.classstruct.loadoutprimary + " secondary=" + self.classstruct.loadoutsecondary + " primary_blueprint=" + self.water_wz_primary_blueprint + " secondary_blueprint=" + self.water_wz_secondary_blueprint + " primary_held=" + primary_held + " secondary_held=" + secondary_held + " grounded=" + grounded + "\n", !primary_held || !secondary_held);
    self.water_wz_loadout_started_serial = undefined;
    if (!primary_held || !secondary_held) return;
    self.water_wz_owned_primary = self.classstruct.loadoutprimaryobject;
    self.water_wz_owned_secondary = self.classstruct.loadoutsecondaryobject;
    self.water_wz_equipped_serial = self.water_wz_spawn_serial;
    if (grounded) self.water_wz_ground_equipped_serial = self.water_wz_spawn_serial;
    level.water_wz_equipped++;
}

function water_wz_random_operator()
{
    if (!isdefined(self.water_wz_operator))
    {
        scripts\mp\teams::function_d650608c959c9675();
        if (!isdefined(level.var_b113f6fe0e7c93bf)) return;
        choices = [];
        foreach (team, operators in level.var_b113f6fe0e7c93bf)
        {
            if (operators.size > 0) choices[choices.size] = team;
        }
        if (choices.size == 0) return;
        team = choices[randomint(choices.size)];
        refs = getarraykeys(level.var_b113f6fe0e7c93bf[team]);
        operator = refs[randomint(refs.size)];
        skins = level.var_b113f6fe0e7c93bf[team][operator];
        if (!isdefined(skins) || skins.size == 0) return;
        self.water_wz_operator = operator;
        self.water_wz_operator_skin = skins[randomint(skins.size)];
        self.botoperatorteam = team;
        self.botoperatorref = operator;
    }
    self.pers["operatorSkinRef"] = self.water_wz_operator_skin;
    self scripts\mp\teams::createoperatorcustomization(self.water_wz_operator, self.water_wz_operator_skin);
    water_wz_log("[NoiceWZ] operator bot=" + self getentitynumber() + " ref=" + self.water_wz_operator + " skin=" + self.water_wz_operator_skin + "\n", false);
}

function water_wz_blueprint_eligible(variant, locked, attachments)
{
    return variant > 0 && !locked && attachments >= 4;
}

function water_wz_apply_blueprint(classdata, secondary)
{
    if (!isdefined(level.weaponlootmapdata)) return;
    pick = self.water_wz_primary_blueprint_pick;
    if (secondary) pick = self.water_wz_secondary_blueprint_pick;
    if (!isdefined(pick))
    {
        choices = [];
        foreach (key, data in level.weaponlootmapdata)
        {
            if (!isdefined(data.variantid)) continue;

            map = data.attachcustomtoidmap;
            if (!isdefined(map)) map = data.attachdefaulttoidmap;
            if (!isdefined(map)) continue;
            locked = isdefined(data.islocked) && data.islocked;
            if (!water_wz_blueprint_eligible(data.variantid, locked, getarraykeys(map).size)) continue;
            root = strtok(key, "|")[0];
            if (!water_wz_spawn_weapon_kind(root, secondary)) continue;
            choices[choices.size] = [key, root, data, map];
        }
        if (choices.size == 0) return;
        pick = choices[randomint(choices.size)];
        if (secondary) self.water_wz_secondary_blueprint_pick = pick;
        else self.water_wz_primary_blueprint_pick = pick;
    }
    attachments = [];
    ids = [];
    foreach (attachment, id in pick[3])
    {
        attachments[attachments.size] = attachment;
        ids[ids.size] = id;
    }

    if (secondary)
    {
        classdata.loadoutsecondary = pick[1];
        classdata.loadoutsecondaryattachments = attachments;
        classdata.loadoutsecondaryattachmentids = ids;
        classdata.loadoutsecondaryvariantid = pick[2].variantid;
        self.water_wz_secondary_blueprint = pick[0];
    }
    else
    {
        classdata.loadoutprimary = pick[1];
        classdata.loadoutprimaryattachments = attachments;
        classdata.loadoutprimaryattachmentids = ids;
        classdata.loadoutprimaryvariantid = pick[2].variantid;
        self.water_wz_primary_blueprint = pick[0];
    }
}

function water_wz_spawn_weapon_kind(name, secondary)
{
    if (secondary) return issubstr(name, "_sm_");
    return issubstr(name, "_ar_") || issubstr(name, "_lm_");
}

function water_wz_attachment_score(weapon)
{
    score = 0;
    if (isdefined(weapon.attachment1) && weapon.attachment1 != "none") score++;
    if (isdefined(weapon.attachment2) && weapon.attachment2 != "none") score++;
    if (isdefined(weapon.attachment3) && weapon.attachment3 != "none") score++;
    if (isdefined(weapon.attachment4) && weapon.attachment4 != "none") score++;
    if (isdefined(weapon.attachment5) && weapon.attachment5 != "none") score++;
    if (isdefined(weapon.attachment6) && weapon.attachment6 != "none") score++;
    return score;
}

function water_wz_pick_spawn_loadout(secondary)
{
    choices = [];
    best = -1;
    pool = level.botloadouts.loadoutsets["run_and_gun_veteran_archetype_assault"];
    if (isdefined(pool))
    {
        foreach (name in pool)
        {
            candidate = level.botloadouts.loadouts[name];
            if (!isdefined(candidate) || !isdefined(candidate.primaryweapon) || !isdefined(candidate.primaryweapon.weapon)) continue;
            if (!water_wz_spawn_weapon_kind(candidate.primaryweapon.weapon, secondary)) continue;
            score = water_wz_attachment_score(candidate.primaryweapon);
            if (score > best) { choices = []; best = score; }
            if (score == best) choices[choices.size] = candidate;
        }
    }
    if (choices.size > 0) return choices[randomint(choices.size)];
    if (secondary) return water_wz_pick_spawn_loadout(false);

    return scripts\mp\bots\bots_loadout::function_70d701f63acab018();
}

function water_wz_combine_loadout(primary, secondary)
{
    loadout = spawnstruct();
    loadout.archetype = primary.archetype;
    loadout.primaryweapon = primary.primaryweapon;
    loadout.secondaryweapon = secondary.primaryweapon;
    loadout.equipment = spawnstruct();
    loadout.equipment.primary = "equip_frag";
    loadout.equipment.secondary = "equip_flash";
    if (randomint(2)) loadout.equipment.secondary = "equip_concussion";
    loadout.perks = primary.perks;
    loadout.extraperks = primary.extraperks;
    loadout.gesture = primary.gesture;
    loadout.fieldupgrade1 = primary.fieldupgrade1;
    loadout.fieldupgrade2 = primary.fieldupgrade2;
    loadout.specialist = primary.specialist;
    return loadout;
}

function water_wz_loadout_callback()
{
    return self.water_wz_spawn_loadout;
}

function water_wz_enemy(candidate)
{
    if (!isdefined(candidate) || !water_wz_deployed(candidate, !isbot(candidate)) || candidate == self) return false;
    if (!isdefined(candidate.team) || !isdefined(self.team)) return false;
    return candidate.team != self.team && candidate.team != "spectator";
}

function water_wz_human_target()
{
    chosen = undefined;
    best = 999999999999;
    foreach (player in level.players)
    {
        if (isbot(player) || !water_wz_enemy(player)) continue;
        d = distancesquared(self.origin, player.origin);
        if (d < best) { chosen = player; best = d; }
    }
    return chosen;
}

function water_wz_bot_target()
{
    chosen = undefined;
    best = 999999999999;
    foreach (player in level.players)
    {
        if (!isdefined(player) || !isbot(player) || !isdefined(player.origin)) continue;
        d = distancesquared(self.origin, player.origin);
        if (d > 4000000 || d >= best || !water_wz_enemy(player)) continue;
        if (!water_wz_local_bot_fight(d, water_wz_visible(player))) continue;
        if (d < best) { chosen = player; best = d; }
    }
    return chosen;
}

function water_wz_local_bot_fight(distance_sq, visible)
{
    return distance_sq <= 4000000 && visible;
}

function water_wz_hunt_budget(roll)
{
    phase = noice_wz_pacing_phase(); // PACING HOOK 1
    if (phase >= 0) return noice_wz_pacing_hunt_budget(phase, roll); // PACING HOOK 1
    if (roll < 50) return 1;
    return 2;
}

function water_wz_make_hunt_slot(bot, human, now)
{
    slot = spawnstruct();
    slot.bot = bot;
    slot.human = human;
    slot.claimed_time = now;
    slot.progress_origin = bot.origin;
    slot.progress_time = now;
    return slot;
}

function water_wz_hunt_reserved(bot)
{
    if (!isdefined(bot)) return false;
    foreach (slot in level.water_wz_hunt_slots)
    {
        if (water_wz_same_entity(slot.bot, bot)) return true;
    }
    return false;
}

function water_wz_hunt_candidate(bot, human, now)
{
    if (!water_wz_hunt_eligible(bot) || !water_wz_in_map(bot)) return false;
    if (!isdefined(bot.water_wz_managed) || !isdefined(bot.team) || !isdefined(human.team)) return false;
    if (bot.team == human.team || bot.team == "spectator") return false;
    if (!water_wz_safe(bot.origin) || water_wz_hunt_reserved(bot)) return false;
    if (isdefined(bot.water_wz_hunt_retry_after) && now < bot.water_wz_hunt_retry_after) return false;
    if (isdefined(bot.water_wz_using_streak) && bot.water_wz_using_streak) return false;
    if (isdefined(bot.water_wz_trade) || isdefined(bot.water_wz_loadout_started_serial)) return false;
    if (isdefined(bot.water_wz_plate_active) && bot.water_wz_plate_active) return false;
    if (isdefined(bot.insertingarmorplate) && bot.insertingarmorplate) return false;
    return true;
}

function water_wz_release_hunt(human, now)
{
    self.water_wz_hunt_retry_after = now + 12000;
    visible_combat = water_wz_enemy(human) && self water_wz_visible(human);
    water_wz_search_clear();
    if (isdefined(self.water_wz_contact) && self.water_wz_contact == human)
    {
        water_wz_reset_contact();
    }
    if (!visible_combat && isdefined(self.water_wz_script_enemy) && self.water_wz_script_enemy == human)
    {
        self botclearscriptenemy();
        self.water_wz_script_enemy = undefined;
    }
    if (isdefined(self.water_wz_target) && self.water_wz_target == human)
    {

        if (self.water_wz_tactic == "push" || self.water_wz_tactic == "flank" || self.water_wz_tactic == "cutoff" || self.water_wz_tactic == "hold" || self.water_wz_tactic == "cover" || self.water_wz_tactic == "peek" || self.water_wz_tactic == "third")
        {
            self.water_wz_tactic = "normal";
            self.water_wz_tactic_point = undefined;
            self.water_wz_tactic_target = undefined;
            self.water_wz_tactic_until = 0;
        }
        self botclearscriptgoal();
        self.water_wz_target = undefined;
        self.water_wz_goal_point = undefined;
        self.water_wz_next_goal = 0;
        self.water_wz_goal_retry_point = undefined;
        self.water_wz_goal_retry_after = 0;
        self.water_wz_recover_until = 0;
        self.water_wz_progress_remaining = undefined;
    }
}

function water_wz_replace_hunters()
{
    if (!getdvarint(@"noice_wz_enabled", 1) || gamelogic::inprematch()) return;
    if (!isdefined(level.players) || !isdefined(level.water_wz_hunt_slots)) return;
    now = gettime();
    if (isdefined(level.water_wz_next_hunt_maintenance) && now < level.water_wz_next_hunt_maintenance) return;
    level.water_wz_next_hunt_maintenance = now + 4000;
    water_wz_prune_hunts();
    foreach (slot in level.water_wz_hunt_slots)
    {
        incumbent = slot.bot;
        human = slot.human;
        if (!water_wz_hunt_eligible(incumbent) || !water_wz_deployed(human, true)) continue;
        if (!isdefined(slot.claimed_time)) slot.claimed_time = now;
        if (!isdefined(slot.progress_origin) || !isdefined(slot.progress_time))
        {
            slot.progress_origin = incumbent.origin;
            slot.progress_time = now;
        }

        if (distancesquared(incumbent.origin, slot.progress_origin) >= 16384)
        {
            slot.progress_origin = incumbent.origin;
            slot.progress_time = now;
        }
        if (now - slot.claimed_time < 12000) continue;
        incumbent_distance = distancesquared(incumbent.origin, human.origin);
        stalled = now - slot.progress_time >= 8000;
        if (incumbent_distance <= 36000000 && !stalled) continue;
        visible = incumbent water_wz_visible(human);
        if (visible && (incumbent_distance <= 36000000 || water_wz_downed_human(human))) continue;

        preferred = undefined;
        fallback = undefined;
        preferred_distance = 999999999999;
        fallback_distance = 999999999999;
        foreach (candidate in level.players)
        {
            if (!water_wz_hunt_candidate(candidate, human, now)) continue;
            candidate_distance = distancesquared(candidate.origin, human.origin);

            if (candidate_distance > incumbent_distance * 0.25) continue;
            if (isdefined(candidate.water_wz_hunter) && candidate.water_wz_hunter)
            {
                if (candidate_distance < preferred_distance)
                {
                    preferred = candidate;
                    preferred_distance = candidate_distance;
                }
            }
            else if (candidate_distance < fallback_distance)
            {
                fallback = candidate;
                fallback_distance = candidate_distance;
            }
        }
        replacement = preferred;
        replacement_distance = preferred_distance;
        if (!isdefined(replacement))
        {
            replacement = fallback;
            replacement_distance = fallback_distance;
        }
        if (!isdefined(replacement)) continue;
        slot.bot = replacement;
        slot.claimed_time = now;
        slot.progress_origin = replacement.origin;
        slot.progress_time = now;
        replacement.water_wz_human = human;

        incumbent water_wz_release_hunt(human, now);
        if (!isdefined(level.water_wz_hunt_replacements)) level.water_wz_hunt_replacements = 0;
        level.water_wz_hunt_replacements++;
        water_wz_log("[NoiceWZ] hunter_replaced old=" + incumbent getentitynumber() + " new=" + replacement getentitynumber() + " old_distance_sq=" + incumbent_distance + " new_distance_sq=" + replacement_distance + " stalled=" + stalled + "\n", false);
    }
}

function water_wz_hunt_eligible(bot)
{
    if (gamelogic::inprematch()) return false;
    if (!isdefined(bot) || !isbot(bot) || !isalive(bot)) return false;
    if (!isdefined(bot.sessionstate) || bot.sessionstate != "playing") return false;
    if (isdefined(bot.inlaststand) && bot.inlaststand) return false;
    if (isdefined(bot.br_infil_type)) return false;
    if (bot scripts\mp\gametypes\br_public::isplayerinorgoingtogulag()) return false;
    if (isdefined(bot.isusingremote) && bot.isusingremote) return false;
    return true;
}

function water_wz_prune_hunts()
{
    if (gettime() >= level.water_wz_next_hunt_limit)
    {
        level.water_wz_hunt_limit = water_wz_hunt_budget(randomint(100));
        level.water_wz_next_hunt_limit = gettime() + randomintrange(30000, 60000);
    }
    kept = [];
    foreach (slot in level.water_wz_hunt_slots)
    {
        if (kept.size >= level.water_wz_hunt_limit) break;
        if (!water_wz_hunt_eligible(slot.bot) || !water_wz_deployed(slot.human, true)) continue;
        kept[kept.size] = slot;
    }
    level.water_wz_hunt_slots = kept;
}

function water_wz_claim_hunt(human)
{
    water_wz_prune_hunts();
    if (!water_wz_enemy(human) || isbot(human) || !water_wz_hunt_eligible(self)) return false;
    foreach (slot in level.water_wz_hunt_slots)
    {
        if (slot.bot == self) return slot.human == human;
    }
    if (level.water_wz_hunt_slots.size >= level.water_wz_hunt_limit) return false;
    if (isdefined(self.water_wz_hunt_retry_after) && gettime() < self.water_wz_hunt_retry_after) return false;
    slot = water_wz_make_hunt_slot(self, human, gettime());
    level.water_wz_hunt_slots[level.water_wz_hunt_slots.size] = slot;
    return true;
}

function water_wz_has_hunt(human)
{
    if (!isdefined(human)) return false;
    foreach (slot in level.water_wz_hunt_slots)
    {
        if (water_wz_same_entity(slot.bot, self) && water_wz_same_entity(slot.human, human)) return true;
    }
    return false;
}

function water_wz_target_kind(hunter, human_valid, bot_valid, finish_human)
{
    if (human_valid && (hunter || finish_human || !bot_valid)) return "human";
    if (!hunter && bot_valid) return "bot";
    return "none";
}

function water_wz_encounter_target()
{
    chosen = undefined;
    best = 999999999999;
    humans = level.water_wz_humans;
    if (!isdefined(humans)) humans = level.players;
    foreach (player in humans)
    {
        if (!isdefined(player) || isbot(player) || !water_wz_enemy(player) || !water_wz_visible(player)) continue;
        d = distancesquared(self.origin, player.origin);
        if (d < best) { chosen = player; best = d; }
    }
    return chosen;
}

function water_wz_duel_priority(has_hunt, bot_visible, bot_distance, human_visible, human_distance, human_hit, finish_human)
{
    if (has_hunt || human_hit || finish_human || !bot_visible) return false;
    if (!human_visible) return true;

    return human_distance > 1440000 && bot_distance < human_distance * 0.25;
}

function water_wz_combat_choice(preferred, encounter, preferred_human, has_hunt, duel)
{
    if (isdefined(duel)) return duel;
    if (isdefined(encounter)) return encounter;
    if (preferred_human && !has_hunt) return undefined;
    return preferred;
}

function water_wz_urgent_target()
{
    target = self.water_wz_hit_human;
    if (!isdefined(self.water_wz_hit_time) || !water_wz_recent_human_hit(gettime() - self.water_wz_hit_time)) return undefined;
    if (!water_wz_enemy(target) || isbot(target) || !water_wz_visible(target)) return undefined;
    if (distancesquared(self.origin, target.origin) > 4000000) return undefined;
    return target;
}

function water_wz_same_entity(a, b)
{
    if (!isdefined(a)) return !isdefined(b);
    if (!isdefined(b)) return false;
    return a == b;
}

function water_wz_commit_target(proposed)
{
    now = gettime();
    urgent = water_wz_urgent_target();
    paired = isdefined(self.water_wz_three_way) && self.water_wz_three_way.active;
    previous = self.water_wz_committed_target;

    human_interrupt = !paired && water_wz_enemy(previous) && isbot(previous) && water_wz_enemy(proposed) && !isbot(proposed) && water_wz_visible(proposed);
    if (isdefined(urgent))
    {
        if (paired) self.water_wz_three_way.active = false;
        proposed = urgent;
    }
    else if (!paired && !human_interrupt && water_wz_enemy(previous) && water_wz_visible(previous) && now < self.water_wz_commit_until)
    {
        same_life = !isdefined(self.water_wz_commit_serial) || (isdefined(previous.water_wz_spawn_serial) && previous.water_wz_spawn_serial == self.water_wz_commit_serial);
        if (same_life && !water_wz_downed_human(proposed)) return previous;
    }
    if (!water_wz_same_entity(previous, proposed))
    {
        self.water_wz_commit_until = now + 800;
        self.water_wz_commit_serial = undefined;
        if (isdefined(proposed)) self.water_wz_commit_serial = proposed.water_wz_spawn_serial;
    }
    self.water_wz_committed_target = proposed;
    return proposed;
}

function water_wz_navigation_target(proposed, hunting)
{
    target = self.water_wz_fight_target;
    if (!hunting && water_wz_enemy(target) && water_wz_visible(target))
    {
        if (!isbot(target) || water_wz_local_bot_fight(distancesquared(self.origin, target.origin), true)) return target;
    }
    return proposed;
}

function water_wz_blocked_route(target)
{
    now = gettime();
    if (!isdefined(target) || !water_wz_same_entity(self.water_wz_blocked_target, target) || !isdefined(self.water_wz_blocked_since) || now - self.water_wz_blocked_since < 400) return false;
    if (isdefined(self.water_wz_next_blocked_route) && now < self.water_wz_next_blocked_route) return false;
    if (!water_wz_enemy(target) || !water_wz_visible(target) || water_wz_clear_shot(target)) return false;
    self.water_wz_next_blocked_route = now + 2000;
    point = water_wz_flank_point(target.origin, false);
    if (!isdefined(point)) return false;
    water_wz_set_tactic("flank", point, 1800);
    if (!water_wz_goal(point, 48))
    {
        water_wz_set_tactic("normal", undefined, 0);
        return false;
    }
    self.water_wz_tactic_target = target;
    return true;
}

function water_wz_recent_human_hit(age)
{
    return age >= 0 && age <= 2500;
}

function water_wz_local_push(distance_sq, visible, downed)
{
    if (!visible) return false;
    if (downed) return distance_sq > 4096;
    return distance_sq > 16384;
}

function water_wz_contact_memory(age, distance_sq)
{
    return age >= 0 && age <= 12000 && distance_sq > 16384;
}

function water_wz_contact_goal()
{
    if (self.water_wz_dueling_bot == true) return undefined;
    if (water_wz_enemy(self.water_wz_encounter) && water_wz_visible(self.water_wz_encounter))
    {

        if (!water_wz_same_entity(self.water_wz_contact, self.water_wz_encounter) || !isdefined(self.water_wz_next_contact_velocity) || gettime() >= self.water_wz_next_contact_velocity)
        {
            self.water_wz_contact_velocity = self.water_wz_encounter getvelocity();
            self.water_wz_next_contact_velocity = gettime() + 250;
        }
        self.water_wz_contact = self.water_wz_encounter;
        self.water_wz_contact_point = self.water_wz_encounter.origin;
        self.water_wz_contact_time = gettime();
        return self.water_wz_contact_point;
    }
    if (!isdefined(self.water_wz_contact_time) || !water_wz_enemy(self.water_wz_contact)) return undefined;
    remaining = distancesquared(self.origin, self.water_wz_contact_point);
    if (!water_wz_contact_memory(gettime() - self.water_wz_contact_time, remaining)) return undefined;
    return self.water_wz_contact_point;
}

function water_wz_downed_human(target)
{
    return isdefined(target) && !isbot(target) && isdefined(target.inlaststand) && target.inlaststand;
}

function water_wz_visible(target)
{
    if (!water_wz_enemy(target)) return false;
    now = gettime();
    if (!isdefined(self.water_wz_visibility_time) || self.water_wz_visibility_time != now)
    {
        self.water_wz_visibility_time = now;
        self.water_wz_visibility = [];
    }
    id = target getentitynumber();
    if (isdefined(self.water_wz_visibility[id])) return self.water_wz_visibility[id];
    result = water_wz_visible_uncached(target);
    self.water_wz_visibility[id] = result;
    return result;
}

function water_wz_visible_uncached(target)
{
    if (self botcanseeentity(target)) return true;
    if (isbot(target)) return false;

    if (water_wz_downed_human(target)) return water_wz_clear_shot(target);
    return water_wz_exposed_human(target);
}

function water_wz_exposed_human(target)
{
    if (!water_wz_enemy(target) || isbot(target)) return false;

    if (distancesquared(self.origin, target.origin) > 16000000) return false;
    now = gettime();
    id = target getentitynumber();
    if (!isdefined(self.water_wz_exposed_retry)) self.water_wz_exposed_retry = [];
    if (isdefined(self.water_wz_exposed_retry[id]) && now < self.water_wz_exposed_retry[id]) return false;
    eye = self geteye();
    angles = self getplayerangles();
    fov = self botgetfovdot();
    foreach (tag in ["j_head", "j_spinelower"])
    {
        point = target gettagorigin(tag);
        if (!isdefined(point) || !utility::within_fov(eye, angles, point, fov)) continue;
        if (sighttracepassed(eye, point, 0, self, target)) return true;
    }

    self.water_wz_exposed_retry[id] = now + 100;
    return false;
}

function water_wz_personality(roll)
{
    if (roll < 50) return "rusher";
    if (roll < 80) return "flanker";
    if (roll < 95) return "cautious";
    return "marksman";
}

function water_wz_tactic_choice(unsafe, low_health, low_armor, can_plate, visible, hit_age, finishing, vulnerable)
{
    if (unsafe) return "gas";
    if (finishing) return "finish";
    if (low_health && (visible || hit_age < 1500)) return "retreat";
    if (low_armor && visible) return "retreat";
    if (can_plate && !visible && hit_age >= 5000) return "plate";
    if (visible && vulnerable) return "push";
    return "normal";
}

function water_wz_engagement_range(personality, hunting)
{
    if (hunting || personality == "rusher") return 192;
    if (personality == "flanker") return 512;
    if (personality == "cautious") return 900;
    return 1800;
}

function water_wz_rotation_due(distance_sq, radius, closing, seconds_to_close, lead_seconds)
{
    return radius > 0 && distance_sq > radius * radius * 0.49 && (closing || seconds_to_close <= lead_seconds);
}

function water_wz_third_party_ready(age, distance_sq, cluster_count, has_hunt, threat_visible)
{
    return age >= 0 && age <= 6000 && distance_sq <= 36000000 && cluster_count >= 2 && !has_hunt && !threat_visible;
}

function water_wz_fast_human_reaction(visible, human, distance_sq)
{
    return visible && human && distance_sq <= 4000000;
}

function water_wz_fire_allowed(plating, tactic, visible, distance_sq, phase, fast_human)
{
    if (plating || !visible) return false;
    if (fast_human) return true;
    if (tactic == "retreat") return distance_sq <= 65536;
    if (tactic == "cover" || tactic == "peek" || tactic == "hold") return phase;
    return true;
}

function water_wz_reset_tactics()
{
    water_wz_cash_clear();
    water_wz_bank_clear();
    self.water_wz_bank_next = 0;
    self.water_wz_boarding = false;
    water_wz_revive_stop(false);
    self.water_wz_regrouping = false;
    self.water_wz_follow_point = undefined;
    self.water_wz_follow_anchor = undefined;
    self.water_wz_next_follow_point = 0;
    if (isdefined(self.water_wz_three_way)) self.water_wz_three_way.active = false;
    self.water_wz_three_way = undefined;
    self.water_wz_committed_target = undefined;
    self.water_wz_commit_serial = undefined;
    self.water_wz_commit_until = 0;
    self.water_wz_aim_point = undefined;
    self.water_wz_exposed_retry = [];
    self.water_wz_blocked_target = undefined;
    self.water_wz_blocked_since = 0;
    self.water_wz_next_blocked_route = 0;
    self.water_wz_slide_fire_at = undefined;
    water_wz_plate_release(true);
    self.water_wz_reaction_target = undefined;
    self.water_wz_reaction_until = 0;
    water_wz_reset_search();
    self.water_wz_searched_time = undefined;
    self.water_wz_search_index = 0;
    self.water_wz_next_search_rotation = 0;
    self.water_wz_tactic = "normal";
    self.water_wz_tactic_until = 0;
    self.water_wz_tactic_started = gettime();
    self.water_wz_tactic_point = undefined;
    self.water_wz_tactic_target = undefined;
    self.water_wz_threat_eye = undefined;
    self.water_wz_threat_time = -100000;
    self.water_wz_peek_point = undefined;
    self.water_wz_cover_point = undefined;
    self.water_wz_cover_hold = 0;
    self.water_wz_next_tactic = gettime() + randomintrange(500, 1600);
    self.water_wz_next_retreat = 0;
    self.water_wz_next_plate = 0;
    self.water_wz_plate_active = false;
    self.water_wz_fight_target = undefined;
    if (!isdefined(self.water_wz_last_hurt)) self.water_wz_last_hurt = -100000;
    self.water_wz_third_time = -1;
    self.water_wz_third_wait = 0;
    self.water_wz_third_point = undefined;
    self.water_wz_third_watch = undefined;
    self.water_wz_next_third = 0;
    self.water_wz_return_point = undefined;
    self.water_wz_grenade_until = 0;
    self.water_wz_next_grenade = gettime() + randomintrange(3000, 7000);
}

function water_wz_reachable_point(point)
{
    if (!isdefined(point) || !isnavmeshloaded()) return undefined;
    reachable = self getclosestreachablepointonnavmesh(point);
    if (!isdefined(reachable) || !water_wz_safe(reachable)) return undefined;
    if (reachable[2] - self.origin[2] > 160 || reachable[2] - self.origin[2] < -160) return undefined;
    if (distancesquared(point, reachable) > 262144) return undefined;
    return reachable;
}

function water_wz_search_due(age, has_hunt, dueling)
{
    return age >= 0 && age <= 12000 && has_hunt && !dueling;
}

function water_wz_search_clear()
{
    if (isdefined(self.water_wz_search_active) && self.water_wz_search_active)
    {
        self botclearscriptgoal();
        self.water_wz_next_goal = 0;
        self.water_wz_progress_remaining = undefined;
    }
    water_wz_reset_search();
    self.water_wz_search_index = 0;
}

function water_wz_search_points(center, observed_velocity)
{
    direction = observed_velocity;
    if (!isdefined(direction)) direction = (0, 0, 0);
    direction = (direction[0], direction[1], 0);
    if (distancesquared((0, 0, 0), direction) <= 1)
        direction = (center[0] - self.origin[0], center[1] - self.origin[1], 0);
    if (distancesquared((0, 0, 0), direction) <= 1) direction = (1, 0, 0);
    direction = vectornormalize(direction);

    candidates = [];
    candidates[0] = center;
    candidates[1] = (center[0] + direction[0] * 384, center[1] + direction[1] * 384, center[2]);
    candidates[2] = (center[0] - direction[1] * 320, center[1] + direction[0] * 320, center[2]);
    candidates[3] = (center[0] + direction[1] * 320, center[1] - direction[0] * 320, center[2]);
    candidates[4] = (center[0] + direction[0] * 640, center[1] + direction[1] * 640, center[2]);
    points = [];
    foreach (candidate in candidates)
    {
        point = water_wz_reachable_point(candidate);
        if (!isdefined(point)) continue;
        duplicate = false;
        foreach (existing in points)
        {
            if (distancesquared(existing, point) < 9216) { duplicate = true; break; }
        }
        if (!duplicate) points[points.size] = point;
    }
    return points;
}

function water_wz_search_tick()
{
    now = gettime();
    if (!isdefined(self.water_wz_contact_time) || !water_wz_enemy(self.water_wz_contact))
    {
        water_wz_search_clear();
        return false;
    }
    if (water_wz_visible(self.water_wz_contact))
    {
        water_wz_search_clear();
        return false;
    }
    if (!water_wz_search_due(now - self.water_wz_contact_time, water_wz_has_hunt(self.water_wz_contact), self.water_wz_dueling_bot) || !water_wz_in_map(self) || !water_wz_safe(self.origin) || !water_wz_safe(self.water_wz_contact_point))
    {
        water_wz_search_clear();
        return false;
    }
    if (isdefined(self.water_wz_searched_time) && self.water_wz_searched_time == self.water_wz_contact_time) return false;

    if (isdefined(self.water_wz_search_active) && self.water_wz_search_active && (self.water_wz_search_time != self.water_wz_contact_time || !water_wz_same_entity(self.water_wz_search_target, self.water_wz_contact))) water_wz_search_clear();
    if (!isdefined(self.water_wz_search_active) || !self.water_wz_search_active)
    {
        self.water_wz_search_time = self.water_wz_contact_time;
        self.water_wz_search_target = self.water_wz_contact;
        self.water_wz_search_points = water_wz_search_points(self.water_wz_contact_point, self.water_wz_contact_velocity);
        self.water_wz_search_index = 0;
        self.water_wz_search_waypoint_until = now + 2500;
        self.water_wz_search_active = true;
        self botclearscriptgoal();
        self.water_wz_next_goal = 0;
        self.water_wz_progress_remaining = undefined;
        level.water_wz_search_plans++;
    }

    while (self.water_wz_search_index < self.water_wz_search_points.size)
    {
        point = self.water_wz_search_points[self.water_wz_search_index];
        if (distancesquared(self.origin, point) <= 9216 || now >= self.water_wz_search_waypoint_until || !water_wz_safe(point))
        {
            self.water_wz_search_index++;
            self.water_wz_search_waypoint_until = now + 2000;
            self.water_wz_next_goal = 0;
            continue;
        }
        if (!water_wz_goal(point, 48))
        {
            self.water_wz_search_index++;
            self.water_wz_search_waypoint_until = now + 2000;
        }
        else self botpressbutton("sprint", 0.6);
        return true;
    }
    self.water_wz_searched_time = self.water_wz_search_time;
    water_wz_search_clear();
    return false;
}

function water_wz_cover_position(target, retreat)
{
    if (!water_wz_enemy(target)) return undefined;
    enemy_eye = target gettagorigin("j_head");
    if (!isdefined(enemy_eye)) return undefined;
    angles = vectortoangles(target.origin - self.origin);
    chosen = undefined;
    best = 999999999999;

    for (i = 0; i < 8; i++)
    {
        yaw = angles[1] + 45 * i + randomfloatrange(-12, 12);
        radius = randomfloatrange(192, 640);
        if (retreat) radius = randomfloatrange(512, 1100);
        point = water_wz_reachable_point(self.origin + anglestoforward((0, yaw, 0)) * radius);
        if (!isdefined(point) || distancesquared(self.origin, point) < 16384) continue;
        if (retreat && distancesquared(point, target.origin) < distancesquared(self.origin, target.origin)) continue;
        if (sighttracepassed(enemy_eye, point + (0, 0, 60), 0, self, target)) continue;
        score = distancesquared(self.origin, point);
        peek = undefined;

        foreach (side in [-1, 1])
        {
            candidate = water_wz_reachable_point(point + anglestoforward((0, angles[1] + 90, 0)) * (144 * side));
            if (!isdefined(candidate) || distancesquared(candidate, point) > 65536) continue;
            if (!sighttracepassed(enemy_eye, candidate + (0, 0, 60), 0, self, target)) continue;
            peek = candidate;
            break;
        }
        if (!retreat && !isdefined(peek)) continue;
        if (score < best)
        {
            chosen = spawnstruct();
            chosen.point = point;
            chosen.peek = peek;
            best = score;
        }
    }
    return chosen;
}

function water_wz_flank_point(point, retreat)
{
    if (!isdefined(point)) return undefined;
    angles = vectortoangles(point - self.origin);
    yaw = angles[1] + self.water_wz_flank_side * randomfloatrange(55, 100);
    radius = randomfloatrange(320, 700);
    if (self.water_wz_personality == "flanker") radius = randomfloatrange(650, 1200);
    if (retreat) { yaw = angles[1] + 180 + randomfloatrange(-35, 35); radius = randomfloatrange(700, 1100); }
    return water_wz_reachable_point(self.origin + anglestoforward((0, yaw, 0)) * radius);
}

function water_wz_set_tactic(kind, point, duration)
{
    self.water_wz_tactic = kind;
    self.water_wz_tactic_point = point;
    self.water_wz_tactic_target = undefined;
    self.water_wz_tactic_until = gettime() + duration;
    self.water_wz_tactic_started = gettime();
    self.water_wz_cover_hold = 0;
    self botclearscriptgoal();
    self.water_wz_next_goal = 0;
}

function water_wz_attack_kind(visible, vulnerable, finishing, recent_contact, roll, flanker)
{
    if (finishing) return "finish";
    if (!visible && !recent_contact) return "normal";
    if (visible && vulnerable) return "push";
    if (flanker && roll < 70) return "flank";
    if (roll < 45) return "push";
    if (roll < 75) return "flank";
    if (roll < 90) return "cutoff";
    return "hold";
}

function water_wz_flank_slot_side(index)
{
    if (index == 1) return -1;
    return 1;
}

function water_wz_attack_point(point, target, kind, hunting, visible)
{
    if (!isdefined(point)) return undefined;
    if (hunting)
    {
        index = 0;
        foreach (slot in level.water_wz_hunt_slots)
        {
            if (!isdefined(target) || !water_wz_same_entity(slot.human, target)) continue;
            if (water_wz_same_entity(slot.bot, self)) { self.water_wz_flank_side = water_wz_flank_slot_side(index); break; }
            index++;
        }
    }
    if (kind == "flank") return water_wz_flank_point(point, false);
    if (kind == "cutoff")
    {

        if (visible)
        {
            velocity = target getvelocity();
            velocity = (velocity[0], velocity[1], 0);
            if (distancesquared((0, 0, 0), velocity) > 250000) velocity = vectornormalize(velocity) * 500;
            point = point + velocity * 0.8;
        }
        cutoff = water_wz_reachable_point(point);
        if (isdefined(cutoff)) return cutoff;
        return water_wz_flank_point(point, false);
    }
    direction = self.origin - point;
    direction = (direction[0], direction[1], 0);
    if (distancesquared((0, 0, 0), direction) < 1) return undefined;
    range = 160;
    if (kind == "hold") range = 700;
    return water_wz_reachable_point(point + vectornormalize(direction) * range);
}

function water_wz_action_busy()
{
    if (isdefined(self.water_wz_revive_until) && gettime() < self.water_wz_revive_until) return true;
    return isdefined(self.water_wz_grenade_until) && gettime() < self.water_wz_grenade_until;
}

function water_wz_grenade_allowed(visible, age, distance_sq, finishing, healing, reloading, ammo)
{
    return (visible || (age >= 0 && age <= 6000)) && distance_sq >= 640000 && distance_sq <= 16000000 && !finishing && !healing && !reloading && ammo;
}

function water_wz_grenade_tick()
{
    now = gettime();
    if (now < self.water_wz_next_grenade || water_wz_action_busy() || self.water_wz_using_streak || isdefined(self.water_wz_trade) || isdefined(self.water_wz_loadout_started_serial)) return false;
    if (self.water_wz_tactic == "retreat" || self.water_wz_tactic == "reload" || self.water_wz_tactic == "plate") return false;
    target = self.water_wz_fight_target;
    visible = water_wz_visible(target);
    point = undefined;
    age = 100000;
    if (visible && !isbot(target)) { point = target.origin; age = 0; }
    else if (!self.water_wz_dueling_bot && water_wz_enemy(self.water_wz_contact) && isdefined(self.water_wz_contact_time))
    {
        target = self.water_wz_contact;
        visible = false;
        point = self.water_wz_contact_point;
        age = now - self.water_wz_contact_time;
    }
    if (!isdefined(point) || !water_wz_safe(point) || now < level.water_wz_next_human_grenade) return false;
    type = "lethal";
    if (randomint(100) < 55) type = "tactical";
    grenade = self botfirstavailablegrenade(type);
    if (!isdefined(grenade)) return false;

    name = grenade.basename;
    if (!isdefined(name)) return false;
    eligible = issubstr(name, "frag") || issubstr(name, "flash") || issubstr(name, "concussion") || issubstr(name, "stun");
    ammo = eligible && self getammocount(grenade) > 0;
    distance_sq = distancesquared(self.origin, point);
    if (!water_wz_grenade_allowed(visible, age, distance_sq, water_wz_downed_human(target), water_wz_healing(), self isreloading(), ammo)) return false;

    if (type == "lethal")
    {
        foreach (player in level.players)
        {
            if (!isdefined(player) || player == self || player.team != self.team || !isalive(player)) continue;
            if (distancesquared(player.origin, point) < 360000) return false;
        }
    }
    point = point + (0, 0, 32);
    self.water_wz_next_grenade = now + randomintrange(8000, 14000);
    self.water_wz_grenade_until = now + 1800;
    level.water_wz_next_human_grenade = now + randomintrange(3500, 5500);
    self botclearscriptenemy();
    self.water_wz_script_enemy = undefined;
    self botsetstance("stand");
    self.water_wz_move_kind = "stand";
    self thread [[ &water_wz_grenade_worker ]](point, type, grenade);
    return true;
}

function water_wz_grenade_abort(reason, deadline)
{
    if (self.water_wz_grenade_until != deadline) return;
    self.water_wz_grenade_until = 0;
    level.water_wz_grenade_cancels++;
    water_wz_log("[NoiceWZ] grenade_cancel bot=" + self getentitynumber() + " reason=" + reason + " released_ms=" + max(0, deadline - gettime()) + "\n", false);
}

function water_wz_grenade_worker(point, type, grenade)
{
    self endon("disconnect");
    self endon("death");
    self endon("spawned_player");
    self endon("water_wz_life_reset");
    level endon("game_ended");
    deadline = self.water_wz_grenade_until;

    wait 0.2;
    if (!water_wz_in_map(self) || !water_wz_safe(self.origin) || water_wz_healing() || self isreloading() || self.water_wz_using_streak || isdefined(self.water_wz_loadout_started_serial)) { water_wz_grenade_abort("state", deadline); return; }
    if (!self hasweapon(grenade) || self getammocount(grenade) <= 0) { water_wz_grenade_abort("inventory", deadline); return; }
    if (!water_wz_safe(point) || distancesquared(self.origin, point) < 640000) { water_wz_grenade_abort("placement", deadline); return; }
    if (type == "lethal")
    {
        foreach (player in level.players)
        {
            if (!isdefined(player) || player == self || player.team != self.team || !isalive(player)) continue;
            if (distancesquared(player.origin, point) < 360000) { water_wz_grenade_abort("squad", deadline); return; }
        }
    }
    self botthrowscriptedgrenade(point, type, 1);
    level.water_wz_grenade_requests++;
}

function water_wz_plate_release(cancel)
{
    if (isdefined(self.water_wz_plate_override) && self.water_wz_plate_override)
    {
        if (cancel && isalive(self)) self notify("try_armor_cancel", "noice_plate_cleanup");
        restore_script_flag = self.water_wz_plate_restore_script_flag;

        if (self.water_wz_native_kind == "automation" && isdefined(self.inlaststand) && self.inlaststand) restore_script_flag = 0;
        self botsetflag("ignore_script_weapon", restore_script_flag);
        self botsetflag("disable_attack", 0);
        self.water_wz_plate_override = false;
    }
    self.water_wz_plate_active = false;
}

function water_wz_plate_guard_tick()
{
    if (getdvarint(@"noice_wz_enabled", 1) && isdefined(self.water_wz_last_hurt) && gettime() - self.water_wz_last_hurt < 5000)
    {
        if ((isdefined(self.insertingarmorplate) && self.insertingarmorplate) || (isdefined(self.armorqueued) && self.armorqueued > 0))
            self notify("armor_cancel", "noice_plate_damage_delay", "hit");
        if (isdefined(self.water_wz_plate_override) && self.water_wz_plate_override) water_wz_plate_release(true);
        return;
    }
    if (!isdefined(self.water_wz_plate_override) || !self.water_wz_plate_override) return;
    if (!getdvarint(@"noice_wz_enabled", 1) || !water_wz_in_map(self) || !water_wz_safe(self.origin) || self.water_wz_spawn_serial != self.water_wz_plate_override_serial || !self.water_wz_plate_active || gettime() >= self.water_wz_plate_override_until)
        water_wz_plate_release(true);
}

function water_wz_plate_events()
{
    self endon("disconnect");
    level endon("game_ended");
    self.water_wz_plate_inserted_total = 0;
    for (;;)
    {
        self waittill("armor_plate_inserted");
        self.water_wz_plate_inserted_total++;
        level.water_wz_plate_insertions++;
    }
}

function water_wz_plate_worker()
{
    self endon("disconnect");
    self endon("death");
    self endon("spawned_player");
    self endon("water_wz_life_reset");
    level endon("game_ended");

    wait 0.2;
    if (!water_wz_in_map(self) || !water_wz_plate_safe() || !self armor::function_cf37789d18fbcc1b())
    {
        water_wz_plate_release(false);
        return;
    }
    serial = self.water_wz_spawn_serial;
    armor_before = self.armorhealth;
    reserve_before = self armor::function_20b8437058079297();
    inserted_before = self.water_wz_plate_inserted_total;

    self.water_wz_plate_restore_script_flag = 0;
    if (self.water_wz_native_kind == "automation") self.water_wz_plate_restore_script_flag = 1;
    self.water_wz_plate_override = true;
    self.water_wz_plate_override_serial = serial;
    self.water_wz_plate_override_until = gettime() + 8000;
    self botsetflag("ignore_script_weapon", 0);
    self botsetflag("disable_attack", 1);
    self notify("water_wz_slide_cancel");
    water_wz_slide_stop();
    self botclearscriptenemy();
    self.water_wz_script_enemy = undefined;
    self botclearscriptgoal();
    self.water_wz_next_goal = 0;
    self botsetstance("stand");
    self.water_wz_move_kind = "stand";
    count = min(3, self armor::function_20b8437058079297());
    self armor::function_9f1608bd570dd94c(count);
    level.water_wz_plate_requests++;
    deadline = gettime() + 6500;
    start_deadline = gettime() + 2000;
    wait 0.1;
    while (self.water_wz_plate_override && (!isdefined(self.insertingarmorplate) || !self.insertingarmorplate) && self.water_wz_plate_inserted_total == inserted_before && gettime() < start_deadline) wait 0.05;
    while (self.water_wz_plate_override && isdefined(self.insertingarmorplate) && self.insertingarmorplate && gettime() < deadline) wait 0.1;
    inserted = self.water_wz_plate_inserted_total - inserted_before;
    reserve_after = self armor::function_20b8437058079297();
    success = inserted > 0 || self.armorhealth > armor_before;
    cancel = isdefined(self.insertingarmorplate) && self.insertingarmorplate;
    water_wz_plate_release(cancel);
    self.water_wz_next_plate = gettime() + 900;
    if (!success)
    {
        level.water_wz_plate_failures++;
        self.water_wz_next_plate = gettime() + 2500;
    }
    water_wz_log("[NoiceWZ] plate_result bot=" + self getentitynumber() + " spawn=" + serial + " success=" + success + " inserted=" + inserted + " armor_before=" + armor_before + " armor_after=" + self.armorhealth + " reserve_before=" + reserve_before + " reserve_after=" + reserve_after + " timeout=" + cancel + "\n", !success);
}

function water_wz_plate_safe()
{
    if (water_wz_action_busy() || self.water_wz_using_streak || self isreloading() || self isswitchingweapon()) return false;
    if (isdefined(self.water_wz_loadout_started_serial)) return false;
    if (!water_wz_safe(self.origin) || gettime() - self.water_wz_last_hurt < 5000) return false;

    if (isdefined(self.water_wz_threat_eye) && gettime() - self.water_wz_threat_time < 5000)
    {
        if (sighttracepassed(self.water_wz_threat_eye, self geteye(), 0, self)) return false;
    }
    return true;
}

function water_wz_healing()
{
    return (isdefined(self.water_wz_plate_active) && self.water_wz_plate_active) || (isdefined(self.insertingarmorplate) && self.insertingarmorplate);
}

function water_wz_rotation_goal()
{
    if (!water_wz_circle_ready() || level.br_circle.circleindex < 0 || !isdefined(level.br_circle.starttime) || !isdefined(level.br_level.br_circledelaytimes)) return undefined;
    index = level.br_circle.circleindex;
    if (index >= level.br_level.br_circledelaytimes.size) return undefined;
    center = scripts\mp\gametypes\br_circle::getsafecircleorigin();
    radius = scripts\mp\gametypes\br_circle::getsafecircleradius();
    seconds = (level.br_circle.starttime + level.br_level.br_circledelaytimes[index] * 1000 - gettime()) / 1000;
    lead = 55;
    if (self.water_wz_personality == "cautious" || self.water_wz_personality == "marksman") lead = 75;
    if (!water_wz_rotation_due(distance2dsquared(self.origin, center), radius, isdefined(level.circleclosing) && level.circleclosing, seconds, lead)) return undefined;

    angles = vectortoangles(self.origin - center);
    for (i = 0; i < 4; i++)
    {
        point = center + anglestoforward((0, angles[1] + randomfloatrange(-25, 25), 0)) * (radius * randomfloatrange(0.45, 0.65));
        point = (point[0], point[1], self.origin[2]);

        reachable = self getclosestreachablepointonnavmesh(point);
        if (isdefined(reachable) && water_wz_safe(reachable) && distance2dsquared(reachable, center) < radius * radius * 0.49) return reachable;
    }
    return undefined;
}

function water_wz_third_party_event(hunting, visible)
{
    if (hunting || visible || gettime() < self.water_wz_next_third) return undefined;
    now = gettime();
    chosen = undefined;
    newest = -1;
    checked = 0;

    foreach (shot in level.water_wz_shots)
    {
        if (!isdefined(shot) || shot.human || water_wz_same_entity(shot.shooter, self) || shot.team == self.team || shot.time <= self.water_wz_third_time || !water_wz_safe(shot.origin)) continue;
        age = now - shot.time;
        distance_sq = distancesquared(self.origin, shot.origin);
        if (age < 0 || age > 6000 || distance_sq > 36000000) continue;
        if (checked >= 8) break;
        checked++;
        cluster = 1;
        foreach (other in level.water_wz_shots)
        {
            if (!isdefined(other) || other.human || water_wz_same_entity(other.shooter, shot.shooter) || water_wz_same_entity(other.shooter, self) || other.team == shot.team) continue;
            if (now - other.time < 0 || now - other.time > 3000) continue;
            if (distancesquared(other.origin, shot.origin) <= 4000000) { cluster++; break; }
        }
        if (water_wz_third_party_ready(age, distance_sq, cluster, hunting, visible) && shot.time > newest) { chosen = shot; newest = shot.time; }
    }
    return chosen;
}

function water_wz_observed_knock(player)
{
    if (!isdefined(player) || !isdefined(player.inlaststand) || !player.inlaststand) return false;
    head = player gettagorigin("j_head");
    return isdefined(head) && sighttracepassed(self geteye(), head, 0, self, player);
}

function water_wz_roam_point()
{
    for (i = 0; i < 4; i++)
    {
        point = self.origin + anglestoforward((0, randomint(360), 0)) * randomfloatrange(1200, 3200);
        reachable = water_wz_reachable_point(point);
        if (isdefined(reachable) && distancesquared(self.origin, reachable) > 262144) return reachable;
    }
    if (water_wz_circle_ready()) return scripts\mp\gametypes\br_circle::getrandompointincurrentcircle(0, 0.8);
    return undefined;
}

function water_wz_tactics(target, hunting)
{
    now = gettime();
    water_wz_contact_goal();
    if (water_wz_enemy(self.water_wz_fight_target)) target = self.water_wz_fight_target;
    visible = water_wz_visible(target);
    if (visible)
    {
        self.water_wz_threat_eye = target gettagorigin("j_head");
        self.water_wz_threat_time = now;
    }
    finishing = visible && water_wz_downed_human(target);
    armor_known = isdefined(self.armorhealth) && isdefined(self.maxarmorhealth) && self.maxarmorhealth > 0;
    low_armor = armor_known && self.armorhealth < self.maxarmorhealth * 0.30;
    low_health = isdefined(self.health) && isdefined(self.maxhealth) && self.health < self.maxhealth * 0.40;
    hit_age = now - self.water_wz_last_hurt;
    native_plating = isdefined(self.insertingarmorplate) && self.insertingarmorplate;
    if (self.water_wz_plate_active || native_plating) { water_wz_search_clear(); return true; }
    if (self.water_wz_tactic == "plate") self.water_wz_tactic = "normal";

    if (self isreloading())
    {
        water_wz_search_clear();
        if (self.water_wz_tactic != "reload")
        {
            point = undefined;
            if (visible)
            {
                cover = water_wz_cover_position(target, true);
                if (isdefined(cover)) point = cover.point;
                self.water_wz_return_point = target.origin;
            }
            water_wz_set_tactic("reload", point, 5000);
        }
        if (isdefined(self.water_wz_tactic_point)) water_wz_goal(self.water_wz_tactic_point, 48);
        return true;
    }
    if (self.water_wz_tactic == "reload") water_wz_set_tactic("normal", undefined, 0);
    can_plate = armor_known && self.armorhealth < self.maxarmorhealth * 0.90 && now >= self.water_wz_next_plate && water_wz_plate_safe() && self armor::function_cf37789d18fbcc1b();

    vulnerable = visible && (target isreloading() || (isdefined(target.insertingarmorplate) && target.insertingarmorplate) || (isdefined(target.armorhealth) && isdefined(target.maxarmorhealth) && target.maxarmorhealth > 0 && target.armorhealth <= target.maxarmorhealth * 0.25));
    choice = water_wz_tactic_choice(!water_wz_safe(self.origin), low_health, low_armor, can_plate, visible, hit_age, finishing, vulnerable);
    if (choice == "gas") { water_wz_search_clear(); return false; }
    blocked_finish = isdefined(target) && self.water_wz_tactic == "flank" && water_wz_same_entity(self.water_wz_tactic_target, target) && water_wz_same_entity(self.water_wz_blocked_target, target) && now < self.water_wz_tactic_until;
    if (choice == "finish" && self.water_wz_tactic != "normal" && !blocked_finish)
    {
        water_wz_set_tactic("normal", undefined, 0);
        return false;
    }
    if (choice == "plate")
    {
        water_wz_search_clear();
        water_wz_set_tactic("plate", undefined, 5000);
        self.water_wz_plate_active = true;
        self.water_wz_next_plate = now + 5000;
        self thread [[ &water_wz_plate_worker ]]();
        return true;
    }
    if (choice == "retreat" && now >= self.water_wz_next_retreat && water_wz_enemy(target))
    {
        cover = undefined;
        if (visible) cover = water_wz_cover_position(target, true);
        point = undefined;
        if (isdefined(cover)) point = cover.point;
        threat = self.water_wz_threat_eye;
        if (visible) threat = target.origin;
        if (!isdefined(point)) point = water_wz_flank_point(threat, true);
        self.water_wz_next_retreat = now + 10000;
        if (isdefined(point))
        {
            self.water_wz_return_point = threat;
            water_wz_set_tactic("retreat", point, 4500);
            self.water_wz_tactic_target = target;
            level.water_wz_retreats++;
        }
    }
    if (choice == "push" && self.water_wz_tactic != "push" && self.water_wz_tactic != "retreat")
    {
        water_wz_set_tactic("push", target.origin, 2800);
        level.water_wz_opportunity_pushes++;
    }
    protected_search = (self.water_wz_tactic == "retreat" || self.water_wz_tactic == "rotate") && now < self.water_wz_tactic_until;
    if (protected_search) water_wz_search_clear();
    else
    {

        can_search = isdefined(self.water_wz_contact_time) && water_wz_enemy(self.water_wz_contact) && water_wz_search_due(now - self.water_wz_contact_time, water_wz_has_hunt(self.water_wz_contact), self.water_wz_dueling_bot) && !water_wz_visible(self.water_wz_contact);
        if (can_search && now >= self.water_wz_next_search_rotation)
        {
            self.water_wz_next_search_rotation = now + 1500;
            rotation = water_wz_rotation_goal();
            if (isdefined(rotation))
            {
                water_wz_search_clear();
                water_wz_set_tactic("rotate", rotation, 8000);
                level.water_wz_rotations++;
                return water_wz_goal(rotation, 96);
            }
        }
        if (can_search && (!isdefined(self.water_wz_searched_time) || self.water_wz_searched_time != self.water_wz_contact_time) && self.water_wz_tactic != "normal") water_wz_set_tactic("normal", undefined, 0);
        if (water_wz_search_tick())
        {
            return true;
        }
    }

    if (!protected_search && !hunting && !visible && !self.water_wz_dueling_bot && isdefined(self.water_wz_contact) && !isbot(self.water_wz_contact) && isdefined(water_wz_contact_goal()))
    {
        if (self.water_wz_tactic != "normal") water_wz_set_tactic("normal", undefined, 0);
        return false;
    }
    if (!protected_search && choice != "retreat" && water_wz_blocked_route(target)) return true;
    if (self.water_wz_tactic != "normal" && now < self.water_wz_tactic_until)
    {
        if (self.water_wz_tactic == "third" && (visible || hunting)) water_wz_set_tactic("normal", undefined, 0);
        else
        {
            point = self.water_wz_tactic_point;
            if (self.water_wz_tactic == "push" && visible && !isbot(target))
            {
                point = target.origin;
                self.water_wz_tactic_point = point;
            }
            if (self.water_wz_tactic == "cover" || self.water_wz_tactic == "peek")
            {
                if (!water_wz_enemy(self.water_wz_tactic_target) || (visible && target != self.water_wz_tactic_target)) water_wz_set_tactic("normal", undefined, 0);
                else if (distancesquared(self.origin, point) <= 9216)
                {
                    if (self.water_wz_cover_hold == 0) self.water_wz_cover_hold = now + randomintrange(250, 500);
                    if (now >= self.water_wz_cover_hold)
                    {
                        if (self.water_wz_tactic == "cover") { self.water_wz_tactic = "peek"; point = self.water_wz_peek_point; }
                        else { self.water_wz_tactic = "cover"; point = self.water_wz_cover_point; }
                        self.water_wz_tactic_point = point;
                        self.water_wz_cover_hold = 0;
                        self.water_wz_next_goal = 0;
                    }
                }
            }
            if (self.water_wz_tactic == "third")
            {
                if (water_wz_observed_knock(self.water_wz_third_watch)) self.water_wz_third_wait = now;
                if (now >= self.water_wz_third_wait) point = self.water_wz_third_point;
            }
            if (self.water_wz_tactic != "normal")
            {
                if (!isdefined(point) || !water_wz_safe(point) || !water_wz_goal(point, 48))
                {
                    water_wz_set_tactic("normal", undefined, 0);
                    self.water_wz_next_tactic = now + 1500;
                    return false;
                }
                if ((!visible || self.water_wz_tactic == "retreat") && (self.water_wz_tactic == "retreat" || self.water_wz_tactic == "push" || self.water_wz_tactic == "flank" || self.water_wz_tactic == "cutoff" || self.water_wz_tactic == "rotate" || (self.water_wz_tactic == "third" && now >= self.water_wz_third_wait))) self botpressbutton("sprint", 0.6);
                return true;
            }
        }
    }
    if (self.water_wz_tactic != "normal") water_wz_set_tactic("normal", undefined, 0);
    if (!finishing && isdefined(self.water_wz_return_point) && !low_health && !low_armor)
    {
        point = water_wz_flank_point(self.water_wz_return_point, false);
        self.water_wz_return_point = undefined;
        if (isdefined(point))
        {
            water_wz_set_tactic("flank", point, 2500);
            self.water_wz_next_tactic = now + 2500;
            return water_wz_goal(point, 48);
        }
    }
    if (finishing || now < self.water_wz_next_tactic) return false;
    self.water_wz_next_tactic = now + randomintrange(1200, 2200);
    rotation = water_wz_rotation_goal();
    if (isdefined(rotation))
    {
        water_wz_set_tactic("rotate", rotation, 8000);
        level.water_wz_rotations++;
        return water_wz_goal(rotation, 96);
    }
    contact_point = undefined;
    recent_contact = !self.water_wz_dueling_bot && isdefined(self.water_wz_contact_time) && now - self.water_wz_contact_time <= 12000 && water_wz_enemy(self.water_wz_contact);
    if (visible && !isbot(target)) contact_point = target.origin;
    else if (recent_contact) contact_point = self.water_wz_contact_point;
    if (isdefined(contact_point))
    {
        roll = randomint(100);
        flanker = self.water_wz_personality == "flanker";

        if (hunting)
        {
            index = 0;
            foreach (slot in level.water_wz_hunt_slots)
            {
                if (!isdefined(target) || !water_wz_same_entity(slot.human, target)) continue;
                if (water_wz_same_entity(slot.bot, self)) { flanker = index > 0; break; }
                index++;
            }
        }
        kind = water_wz_attack_kind(visible, vulnerable, finishing, recent_contact, roll, flanker);
        if (kind == "hold" && visible)
        {
            cover = water_wz_cover_position(target, false);
            if (isdefined(cover))
            {
                water_wz_set_tactic("cover", cover.point, 2500);
                self.water_wz_tactic_target = target;
                self.water_wz_cover_point = cover.point;
                self.water_wz_peek_point = cover.peek;
                level.water_wz_cover_plans++;
                return water_wz_goal(cover.point, 48);
            }
        }
        point = water_wz_attack_point(contact_point, target, kind, hunting, visible);
        if (isdefined(point))
        {
            water_wz_set_tactic(kind, point, 2500);
            if (kind == "push") level.water_wz_opportunity_pushes++;
            return water_wz_goal(point, 48);
        }
    }
    if (visible && isbot(target))
    {
        roll = randomint(100);
        cover_chance = 80;
        if (self.water_wz_personality == "rusher" || hunting) cover_chance = 35;
        if (self.water_wz_personality == "marksman") cover_chance = 95;
        if (roll < cover_chance)
        {
            cover = water_wz_cover_position(target, false);
            if (isdefined(cover))
            {
                water_wz_set_tactic("cover", cover.point, 4500);
                self.water_wz_tactic_target = target;
                self.water_wz_cover_point = cover.point;
                self.water_wz_peek_point = cover.peek;
                level.water_wz_cover_plans++;
                return water_wz_goal(cover.point, 48);
            }
        }
        if (self.water_wz_personality == "flanker" || roll < 40)
        {
            point = water_wz_flank_point(target.origin, false);
            if (isdefined(point))
            {
                water_wz_set_tactic("flank", point, 1800);
                return water_wz_goal(point, 48);
            }
        }
        range = water_wz_engagement_range(self.water_wz_personality, hunting);
        if (!hunting && self.water_wz_personality != "rusher")
        {

            direction = self.origin - target.origin;
            direction = (direction[0], direction[1], 0);
            if (distancesquared((0, 0, 0), direction) > 1)
            {
                point = water_wz_reachable_point(target.origin + vectornormalize(direction) * range);
                if (isdefined(point))
                {
                    water_wz_set_tactic("position", point, 1800);
                    return water_wz_goal(point, 96);
                }
            }
        }
    }
    event = water_wz_third_party_event(hunting, visible);
    if (isdefined(event))
    {
        point = water_wz_flank_point(event.origin, false);
        destination = water_wz_reachable_point(event.origin);
        if (isdefined(point) && isdefined(destination))
        {
            delay = randomintrange(300, 900);
            if (self.water_wz_personality == "cautious" || self.water_wz_personality == "marksman") delay = randomintrange(2500, 4500);
            water_wz_set_tactic("third", point, 10000);
            self.water_wz_third_time = event.time;
            self.water_wz_third_wait = now + delay;
            self.water_wz_third_point = destination;
            self.water_wz_third_watch = event.shooter;
            self.water_wz_next_third = now + 15000;
            level.water_wz_third_parties++;
            return water_wz_goal(point, 64);
        }
    }
    return false;
}

function water_wz_combat_move(visible, downed, distance_sq, moving, roll)
{
    if (downed) return "stand";
    if (moving && roll < 85) return "slide";
    if (visible && distance_sq <= 1440000)
    {
        if ((moving && roll < 90) || (!moving && roll < 8)) return "jump";
        if (roll >= 90 && roll < 96) return "drop";
    }
    return "stand";
}

function water_wz_move_interval(moving, visible)
{
    if (moving && visible) return randomintrange(2500, 4500);
    if (moving) return randomintrange(1500, 2800);
    return randomintrange(900, 1700);
}

function water_wz_move(target, visible)
{
    now = gettime();
    if (water_wz_riding()) return;
    if (self.water_wz_plate_active || (isdefined(self.insertingarmorplate) && self.insertingarmorplate) || water_wz_action_busy() || self isreloading()) return;
    if (water_wz_downed_human(target))
    {
        self.water_wz_move_until = 0;
        self.water_wz_move_kind = "stand";
        self botsetflag("force_sprint", 0);
        self botsetstance("stand");
        return;
    }
    if (now < self.water_wz_move_until) return;
    if (now < self.water_wz_next_move) return;
    self botsetflag("force_sprint", 0);
    self botsetstance("stand");
    self.water_wz_move_kind = "stand";
    velocity = self getvelocity();
    moving = velocity[0] * velocity[0] + velocity[1] * velocity[1] > 14400;
    self.water_wz_next_move = now + water_wz_move_interval(moving, visible);
    distance_sq = 999999999999;
    if (water_wz_enemy(target)) distance_sq = distancesquared(self.origin, target.origin);
    kind = water_wz_combat_move(visible, false, distance_sq, moving, randomint(100));
    if (kind == "jump" && now < self.water_wz_next_jump) kind = "stand";
    self.water_wz_move_kind = kind;
    if (kind == "jump")
    {
        self.water_wz_next_jump = now + randomintrange(5000, 8000);
        self botpressbutton("jump", 0.15);
        self.water_wz_move_until = now + 450;
        level.water_wz_jump_moves++;
    }
    else if (kind == "drop")
    {
        self botsetstance("prone");
        self.water_wz_move_until = now + 500;
        level.water_wz_drop_moves++;
    }
    else if (kind == "slide")
    {
        self.water_wz_move_until = now + 800;
        level.water_wz_sprint_requests++;
        self thread [[ &water_wz_slide_worker ]]();
    }
}

function water_wz_loadout_slot(now)
{
    if (now < level.water_wz_next_loadout_slot) return false;
    level.water_wz_next_loadout_slot = now + 200;
    return true;
}

function water_wz_slide_ready()
{
    if (self.water_wz_move_kind != "slide") return false;
    if (!water_wz_in_map(self) || !water_wz_safe(self.origin) || water_wz_healing() || water_wz_action_busy() || self isreloading() || self.water_wz_using_streak || isdefined(self.water_wz_trade)) return false;
    velocity = self getvelocity();
    return velocity[0] * velocity[0] + velocity[1] * velocity[1] >= 40000;
}

function water_wz_slide_stop()
{
    self botsetflag("force_sprint", 0);

    if (water_wz_in_map(self) && getdvarint(@"noice_wz_enabled", 1)) self botsetstance("stand");
    else self botsetstance("none");
    self.water_wz_move_kind = "stand";
    self.water_wz_move_until = 0;
    self.water_wz_slide_fire_at = undefined;
}

function water_wz_slide_worker()
{
    self endon("disconnect");
    self endon("death");
    self endon("spawned_player");
    self endon("water_wz_life_reset");
    self endon("water_wz_slide_cancel");
    level endon("game_ended");
    self.water_wz_slide_fire_at = undefined;
    self botclearbutton("ads");
    self botsetflag("force_sprint", 1);
    self botsetstance("none");
    self botpressbutton("sprint", 0.9);
    wait 0.2;
    if (!water_wz_slide_ready()) { water_wz_slide_stop(); return; }

    level.water_wz_sprint_windows++;
    self.water_wz_slide_fire_at = gettime();
    wait 0.6;
    water_wz_slide_stop();
}

function water_wz_reaction_opening(target, fast_human, busy)
{
    if (!isdefined(target) || !fast_human || busy)
    {
        self.water_wz_reaction_target = undefined;
        return false;
    }
    now = gettime();
    if (!water_wz_same_entity(self.water_wz_reaction_target, target))
    {
        self.water_wz_reaction_target = target;
        self.water_wz_reaction_until = now + 500;
        self.water_wz_next_move = max(self.water_wz_next_move, self.water_wz_reaction_until);
        level.water_wz_fast_reactions++;
        if (self.water_wz_move_kind == "slide" && !isdefined(self.water_wz_slide_fire_at))
        {
            self notify("water_wz_slide_cancel");
            water_wz_slide_stop();
        }
    }

    return now < self.water_wz_reaction_until;
}

function water_wz_combat()
{
    self endon("disconnect");
    self endon("death");
    self endon("water_wz_life_reset");
    level endon("game_ended");
    for (;;)
    {

        if (self.water_wz_move_kind != "stand" && gettime() >= self.water_wz_move_until)
        {
            self botsetflag("force_sprint", 0);
            if (water_wz_in_map(self) && getdvarint(@"noice_wz_enabled", 1)) self botsetstance("stand");
            else self botsetstance("none");
            self.water_wz_move_kind = "stand";
        }
        if (water_wz_in_map(self) && water_wz_safe(self.origin) && !isdefined(self.water_wz_trade) && !self.water_wz_using_streak)
        {

            if (isdefined(self.water_wz_hit_time) && water_wz_recent_human_hit(gettime() - self.water_wz_hit_time) && water_wz_enemy(self.water_wz_hit_human))
            {
                hit_head = self.water_wz_hit_human gettagorigin("j_head");
                if (isdefined(hit_head)) self setplayerangles(vectortoangles(hit_head - self geteye()));
            }
            self.water_wz_encounter = water_wz_encounter_target();
            has_hunt = water_wz_has_hunt(self.water_wz_human);
            duel_target = self.water_wz_nearby_bot;
            bot_visible = water_wz_enemy(duel_target) && water_wz_visible(duel_target);
            bot_distance = 0;
            if (bot_visible) bot_distance = distancesquared(self.origin, duel_target.origin);
            human_visible = isdefined(self.water_wz_encounter);
            human_distance = 0;
            if (human_visible) human_distance = distancesquared(self.origin, self.water_wz_encounter.origin);
            human_hit = isdefined(self.water_wz_hit_time) && water_wz_recent_human_hit(gettime() - self.water_wz_hit_time) && water_wz_enemy(self.water_wz_hit_human);
            self.water_wz_dueling_bot = water_wz_duel_priority(has_hunt, bot_visible, bot_distance, human_visible, human_distance, human_hit, water_wz_downed_human(self.water_wz_encounter));
            if (!self.water_wz_dueling_bot) duel_target = undefined;
            target = self.water_wz_target;
            preferred_human = isdefined(target) && !isbot(target);
            target = water_wz_combat_choice(target, self.water_wz_encounter, preferred_human, preferred_human && water_wz_has_hunt(target), duel_target);
            split_target = water_wz_three_way_target(target, self.water_wz_encounter, self.water_wz_fight_target);
            if (!water_wz_same_entity(split_target, target) && isdefined(split_target)) self.water_wz_dueling_bot = isbot(split_target);
            target = split_target;
            squad_focus = water_wz_squad_focus_target(water_wz_squad_leader_cached());
            if (isdefined(squad_focus) && !isdefined(water_wz_urgent_target()) && water_wz_visible(squad_focus)) target = squad_focus;
            target = water_wz_commit_target(target);
            visible = water_wz_visible(target);
            self.water_wz_fight_target = target;
            self.water_wz_dueling_bot = water_wz_enemy(target) && isbot(target);
            if (visible && !isbot(target)) self.water_wz_encounter = target;
            water_wz_contact_goal();
            plating = self.water_wz_plate_active || (isdefined(self.insertingarmorplate) && self.insertingarmorplate) || water_wz_action_busy() || self isreloading() || isdefined(self.water_wz_loadout_started_serial);
            distance_sq = 999999999999;
            if (water_wz_enemy(target)) distance_sq = distancesquared(self.origin, target.origin);
            fast_human = water_wz_fast_human_reaction(visible, water_wz_enemy(target) && !isbot(target), distance_sq);

            opening = water_wz_reaction_opening(target, visible && water_wz_enemy(target) && !isbot(target) && distance_sq <= 16000000, plating);
            if (!opening) water_wz_move(target, visible);
            phase = (gettime() - self.water_wz_tactic_started) % 1100 < 750;
            sliding = self.water_wz_move_kind == "slide" && gettime() < self.water_wz_move_until;
            slide_fire = sliding && isdefined(self.water_wz_slide_fire_at) && gettime() >= self.water_wz_slide_fire_at;
            clear_shot = water_wz_clear_shot(target);
            if (visible && !clear_shot && !plating)
            {
                if (!water_wz_same_entity(self.water_wz_blocked_target, target))
                {
                    self.water_wz_blocked_target = target;
                    self.water_wz_blocked_since = gettime();
                }
            }
            else self.water_wz_blocked_target = undefined;
            if (!plating) self botsetflag("disable_attack", !clear_shot);
            if (!clear_shot) self botclearbutton("attack");

            if (water_wz_enemy(target) && clear_shot && (!sliding || slide_fire) && water_wz_fire_allowed(plating, self.water_wz_tactic, visible, distance_sq, phase, fast_human || opening))
            {
                if (!sliding) self botsetflag("force_sprint", 0);
                self getenemyinfo(target);
                self botsetscriptenemy(target);
                self.water_wz_script_enemy = target;
                head = self.water_wz_aim_point;
                if (isdefined(head)) self setplayerangles(vectortoangles(head - self geteye()));
                if (sliding) self botclearbutton("ads");
                else self botpressbutton("ads", 0.12);
                self botpressbutton("attack", 0.12);
                if (water_wz_downed_human(target)) level.water_wz_finish_shots++;
                if (self.water_wz_dueling_bot) level.water_wz_duel_shots++;
                if (!isbot(target) && distance_sq > 640000) level.water_wz_ranged_human_shots++;
            }
            else if (isdefined(self.water_wz_script_enemy))
            {
                self botclearscriptenemy();
                self.water_wz_script_enemy = undefined;
            }
        }
        else
        {
            self botclearbutton("attack");
            if (!water_wz_healing() && !self.water_wz_using_streak) self botsetflag("disable_attack", 0);
            self.water_wz_encounter = undefined;
            self.water_wz_reaction_target = undefined;
            self.water_wz_dueling_bot = false;
            self.water_wz_fight_target = undefined;
        }
        wait 0.05;
    }
}

function water_wz_hear_shots()
{
    self endon("disconnect");
    level endon("game_ended");
    last = -1000;
    for (;;)
    {
        self waittill("weapon_fired");
        now = gettime();
        if (!water_wz_in_map(self) || now - last < 250) continue;
        shot = spawnstruct();
        shot.origin = self.origin;
        shot.team = self.team;
        shot.shooter = self;
        shot.human = !isbot(self);
        shot.time = now;

        level.water_wz_shots[self getentitynumber()] = shot;
        last = now;
        if (!isbot(self)) water_wz_human_aim_focus();
    }
}

function water_wz_shot_audible(human, age, distance_sq, radius, safe)
{
    if (!safe || age < 0) return false;
    if (human) return age <= 90000 && noice_wz_pacing_human_audible(distance_sq); // PACING HOOK 2
    return age <= 6000 && distance_sq <= radius * radius;
}

function water_wz_nearby_shot()
{
    chosen = undefined;
    newest = -1;
    chosen_human = false;
    radius = min(12000, max(0, getdvarfloat(@"noice_wz_hearing_radius", 6000)));
    radius = min(12000, radius * noice_wz_pacing_hearing_scale()); // PACING HOOK 3
    foreach (shot in level.water_wz_shots)
    {
        if (!isdefined(shot) || water_wz_same_entity(shot.shooter, self) || shot.team == self.team) continue;
        if (shot.human && shot.time <= self.water_wz_checked_shot) continue;
        if (!water_wz_shot_audible(shot.human, gettime() - shot.time, distancesquared(self.origin, shot.origin), radius, water_wz_safe(shot.origin))) continue;
        if (chosen_human && !shot.human) continue;
        if (shot.human == chosen_human && shot.time <= newest) continue;
        chosen = shot;
        newest = shot.time;
        chosen_human = shot.human;
    }
    return chosen;
}

function water_wz_circle_ready()
{
    return isdefined(level.br_circle) && isdefined(level.br_circle.dangercircleent) && isdefined(level.br_circle.circleindex) && isdefined(level.br_level) && isdefined(level.br_level.br_circleradii);
}

function water_wz_safe(point)
{
    if (!water_wz_circle_ready()) return true;
    return scripts\mp\gametypes\br_circle::ispointincurrentsafecircle(point);
}

function water_wz_goal(point, radius)
{
    if (!isnavmeshloaded() || !isdefined(point))
    {
        self.water_wz_goal_status = "nav_or_point_missing";
        return false;
    }
    now = gettime();
    if (isdefined(self.noice_wz_failed_goal) && now < self.noice_wz_failed_until && distancesquared(point, self.noice_wz_failed_goal) < 65536)
    {
        self.water_wz_goal_status = "stalled_destination";
        return false;
    }
    kind = water_wz_goal_type(water_wz_safe(self.origin));
    if (kind == "hunt" && self bothasscriptgoal() && !water_wz_safe(self botgetscriptgoal()))
    {
        self botclearscriptgoal();
        self.water_wz_next_goal = 0;
    }
    if (isdefined(self.water_wz_goal_kind) && self.water_wz_goal_kind != kind)
    {
        self botclearscriptgoal();
        self.water_wz_next_goal = 0;
        self.water_wz_goal_retry_point = undefined;
    }
    self.water_wz_goal_kind = kind;

    if (isdefined(self.water_wz_goal_point) && isdefined(self.water_wz_goal_request) && isdefined(self.water_wz_goal_radius) && radius == self.water_wz_goal_radius && distancesquared(point, self.water_wz_goal_request) < 16384 && self bothasscriptgoal() && distancesquared(self botgetscriptgoal(), self.water_wz_goal_point) < 4096 && (now < self.water_wz_next_goal || self botpathexists()) && (distancesquared(self.origin, self.water_wz_goal_point) > radius * radius || distancesquared(point, self.water_wz_goal_point) < 262144))
    {
        self.water_wz_goal_status = "cached";
        level.water_wz_cached_goals++;
        return true;
    }
    now = gettime();
    if (isdefined(self.water_wz_goal_retry_point) && now < self.water_wz_goal_retry_after && distancesquared(point, self.water_wz_goal_retry_point) < 16384)
    {
        self.water_wz_goal_status = "retry_wait";
        return false;
    }
    waypoint = point;

    if (distancesquared(self.origin, point) > 144000000)
        waypoint = self.origin + vectornormalize(point - self.origin) * 8000;
    reachable = self getclosestreachablepointonnavmesh(waypoint);
    usable = isdefined(reachable);
    if (usable)
    {

        if (distancesquared(reachable, waypoint) > 16384 && distancesquared(self.origin, reachable) <= 16384) usable = false;

        safety_goal = point;
        if (kind == "critical" && isdefined(self.noice_wz_gas_goal) && water_wz_safe(self.noice_wz_gas_goal)) safety_goal = self.noice_wz_gas_goal;
        if (!water_wz_safe(reachable) && (kind != "critical" || !water_wz_safe(safety_goal) || distance2dsquared(reachable, safety_goal) + 16384 >= distance2dsquared(self.origin, safety_goal))) usable = false;
    }
    if (!usable)
    {
        self.water_wz_goal_retry_point = point;
        self.water_wz_goal_retry_radius = radius;
        self.water_wz_goal_retry_after = now + 750;
        level.water_wz_goal_failures++;
        if (!isdefined(reachable))
        {
            self.water_wz_goal_status = "projection_failed";
            level.water_wz_projection_failures++;
        }
        else if (water_wz_safe(reachable))
        {
            self.water_wz_goal_status = "projection_no_progress";
            level.water_wz_projection_failures++;
        }
        else
        {
            self.water_wz_goal_status = "outside_safe_circle";
            level.water_wz_unsafe_goals++;
        }
        return false;
    }
    result = self botsetscriptgoal(reachable, radius, kind, undefined, undefined, 1);
    if (result)
    {
        self.water_wz_goal_retry_point = undefined;
        self.water_wz_goal_kind = kind;
        self.water_wz_goal_status = "accepted";
        level.water_wz_actual_goal_sets++;
        self.water_wz_goal_point = reachable;
        self.water_wz_goal_request = point;
        self.water_wz_goal_radius = radius;
        self.water_wz_next_goal = gettime() + 1250;
    }
    else
    {
        self.water_wz_goal_retry_point = point;
        self.water_wz_goal_retry_radius = radius;
        self.water_wz_goal_retry_after = now + 750;
        self.water_wz_goal_status = "native_rejected";
        level.water_wz_goal_failures++;
        level.water_wz_native_rejections++;
    }
    return result;
}

function water_wz_goal_type(safe)
{
    if (safe) return "hunt";
    return "critical";
}

function noice_wz_map_profile(map_name, script_name)
{
    if (!isdefined(map_name) || map_name == "") map_name = script_name;
    if (isdefined(map_name) && map_name == "mp_jup_sm_island_2") return "fortunes_keep";
    return "none";
}

function noice_fk_offset(point, x, y, z)
{
    return (point[0] + x, point[1] + y, point[2] + z);
}

function noice_fk_reentry_corridor(point)
{
    dx = point[0] - self.origin[0];
    dy = point[1] - self.origin[1];
    dz = point[2] - self.origin[2];
    length = distance2d(self.origin, point);
    if (length < 32 || length > 128 || abs(dz) > 24) return false;
    contents = scripts\engine\trace::create_contents(0, 1, 0, 0, 1, 1, undefined, undefined, undefined, undefined, undefined, undefined);
    for (step = 1; step <= 3; step++)
    {
        sample = noice_fk_offset(self.origin, dx * step / 3, dy * step / 3, dz * step / 3);
        hits = physics_raycast(noice_fk_offset(sample, 0, 0, 24), noice_fk_offset(sample, 0, 0, -32), contents, undefined, 0, "physicsquery_closest", 1);
        if (!isdefined(hits) || hits.size == 0 || !isdefined(hits[0]["position"])) return false;
        floor = hits[0]["position"];
        if (abs(floor[2] - sample[2]) > 24 || water_wz_water_point(floor)) return false;
    }
    for (lane = -1; lane <= 1; lane++)
    {
        x = (0 - dy) / length * 16 * lane;
        y = dx / length * 16 * lane;
        if (!sighttracepassed(noice_fk_offset(self.origin, x, y, 24), noice_fk_offset(point, x, y, 24), 0, self, undefined)) return false;
        if (!sighttracepassed(noice_fk_offset(self.origin, x, y, 48), noice_fk_offset(point, x, y, 48), 0, self, undefined)) return false;
    }
    return true;
}

function noice_fk_nav_reentry()
{
    if (!water_wz_in_map(self) || self islinked() || self botpathexists() || !isnavmeshloaded()) return false;
    angle = randomint(360);
    for (attempt = 0; attempt < 4; attempt++)
    {
        candidate = self.origin + anglestoforward((0, angle, 0)) * 96;
        angle += 90;

        point = getclosestpointonnavmesh(candidate, self);
        if (!isdefined(point) || abs(point[2] - self.origin[2]) > 24 || distancesquared(self.origin, point) < 1024 || distancesquared(self.origin, point) > 16384 || water_wz_water_point(point)) continue;
        if (!water_wz_safe(point) && (water_wz_safe(self.origin) || !isdefined(self.noice_wz_gas_goal) || !water_wz_safe(self.noice_wz_gas_goal) || distance2dsquared(point, self.noice_wz_gas_goal) + 1024 >= distance2dsquared(self.origin, self.noice_wz_gas_goal))) continue;
        if (!noice_fk_reentry_corridor(point)) continue;
        self botclearscriptgoal();
        self.water_wz_next_goal = 0;
        self.water_wz_goal_retry_point = undefined;
        self.water_wz_goal_retry_after = 0;
        self.water_wz_tactic = "normal";
        self.water_wz_tactic_point = undefined;
        self.water_wz_tactic_until = 0;
        direction = vectortoangles(point - self.origin);
        self botsetscriptmove(direction[1], 0.1, 0.6);
        self.noice_fk_reentry_until = gettime() + 250;
        self.noice_fk_recover_until = 0;
        level.water_wz_recoveries++;
        return true;
    }
    return false;
}

function noice_fk_recovery_tick()
{
    if (!isdefined(level.noice_wz_map_fix) || level.noice_wz_map_fix != "fortunes_keep") return false;
    now = gettime();
    busy = !water_wz_in_map(self) || self islinked() || water_wz_healing() || water_wz_action_busy() || self isreloading() || self.water_wz_plate_active || (isdefined(self.insertingarmorplate) && self.insertingarmorplate) || self.water_wz_using_streak || isdefined(self.water_wz_trade) || isdefined(self.water_wz_loadout_started_serial);
    if (busy)
    {
        self.noice_fk_progress_origin = self.origin;
        self.noice_fk_progress_time = now;
        self.noice_fk_recover_until = 0;
        return false;
    }

    if (isdefined(self.noice_fk_reentry_until) && now < self.noice_fk_reentry_until) return true;
    goal = undefined;
    radius = 64;
    owned = false;
    if (self bothasscriptgoal())
    {
        goal = self botgetscriptgoal();
        owned = isdefined(self.water_wz_goal_point) && distancesquared(goal, self.water_wz_goal_point) < 4096;
        if (owned && isdefined(self.water_wz_goal_radius)) radius = self.water_wz_goal_radius;
    }
    else if (isdefined(self.water_wz_goal_retry_point))
    {
        goal = self.water_wz_goal_retry_point;
        if (isdefined(self.water_wz_goal_retry_radius)) radius = self.water_wz_goal_retry_radius;
    }
    if (!isdefined(goal) || distancesquared(self.origin, goal) <= (radius + 24) * (radius + 24))
    {
        self.noice_fk_progress_origin = self.origin;
        self.noice_fk_progress_time = now;
        self.noice_fk_recover_until = 0;
        return false;
    }
    if (isdefined(self.noice_fk_recover_until) && now < self.noice_fk_recover_until && isdefined(self.noice_fk_recover_point) && distancesquared(goal, self.noice_fk_recover_point) < 4096) return true;
    if (!isdefined(self.noice_fk_progress_origin) || !isdefined(self.noice_fk_progress_time) || distancesquared(self.origin, self.noice_fk_progress_origin) > 4096)
    {
        self.noice_fk_progress_origin = self.origin;
        self.noice_fk_progress_time = now;
        return false;
    }

    if (owned && now < self.water_wz_next_goal && now - self.noice_fk_progress_time < 1250) return false;
    if (now - self.noice_fk_progress_time < 1000 || (isdefined(self.noice_fk_retry_after) && now < self.noice_fk_retry_after)) return false;

    failed = goal;
    if (owned && isdefined(self.water_wz_goal_request)) failed = self.water_wz_goal_request;
    self.noice_fk_progress_origin = self.origin;
    self.noice_fk_progress_time = now;
    self.noice_fk_retry_after = now + 4000;

    if (!self botpathexists() && noice_fk_nav_reentry())
    {
        self.noice_wz_failed_goal = failed;
        self.noice_wz_failed_until = now + 6000;
        return true;
    }
    angle = randomint(360);
    for (attempt = 0; attempt < 4; attempt++)
    {
        point = self.origin + anglestoforward((0, angle, 0)) * 384;
        angle += 90;
        reachable = self getclosestreachablepointonnavmesh(point);
        if (!isdefined(reachable) || abs(reachable[2] - self.origin[2]) > 128 || distancesquared(self.origin, reachable) < 16384 || distancesquared(reachable, goal) < 16384 || water_wz_water_point(reachable)) continue;
        if (!water_wz_safe(reachable) && (water_wz_safe(self.origin) || !isdefined(self.noice_wz_gas_goal) || !water_wz_safe(self.noice_wz_gas_goal) || distance2dsquared(reachable, self.noice_wz_gas_goal) + 16384 >= distance2dsquared(self.origin, self.noice_wz_gas_goal))) continue;
        self.water_wz_next_goal = 0;
        if (!water_wz_goal(reachable, 64)) continue;
        self.noice_wz_failed_goal = failed;
        self.noice_wz_failed_until = now + 6000;
        self.water_wz_tactic = "normal";
        self.water_wz_tactic_point = undefined;
        self.water_wz_tactic_until = 0;
        self.noice_fk_recover_point = self.water_wz_goal_point;
        self.noice_fk_recover_until = now + 2000;
        self.noice_fk_progress_time = now;
        self botpressbutton("sprint", 0.6);
        level.water_wz_recoveries++;
        return true;
    }

    return false;
}

function water_wz_roam_due(next_roam)
{
    now = gettime();
    if (self bothasscriptgoal() && water_wz_safe(self.origin) && !water_wz_safe(self botgetscriptgoal()))
    {
        self botclearscriptgoal();
        self.water_wz_next_goal = 0;
        return true;
    }
    if (!self bothasscriptgoal())
    {
        if (isdefined(self.water_wz_goal_retry_after) && now < self.water_wz_goal_retry_after && now < next_roam) return false;
        return true;
    }
    radius = 160;
    if (isdefined(self.water_wz_goal_radius)) radius = self.water_wz_goal_radius;
    if (distancesquared(self.origin, self botgetscriptgoal()) <= (radius + 24) * (radius + 24)) return true;

    if (isdefined(self.water_wz_goal_point) && distancesquared(self botgetscriptgoal(), self.water_wz_goal_point) < 4096 && now < self.water_wz_next_goal) return false;
    return now >= next_roam && !self botpathexists();
}

function water_wz_should_recover(elapsed, moved_sq, remaining_sq, visible, previous_remaining_sq)
{
    if (elapsed < 6000 || remaining_sq <= 65536 || visible) return false;
    return moved_sq < 16384 || (elapsed >= 10000 && remaining_sq >= previous_remaining_sq);
}

function water_wz_navigate()
{
    self endon("disconnect");
    self endon("death");
    self endon("water_wz_life_reset");
    level endon("game_ended");
    if (isdefined(level.noice_wz_map_fix) && level.noice_wz_map_fix == "fortunes_keep")
    {
        self.noice_fk_reentry_until = 0;
        self.noice_fk_progress_origin = undefined;
        self.noice_fk_progress_time = undefined;
        self.noice_fk_recover_until = 0;
        self.noice_fk_retry_after = 0;
        self.noice_wz_failed_goal = undefined;
        self.noice_wz_gas_goal = undefined;
    }
    wait randomfloatrange(0.05, 0.25);
    next_settings = 0;
    next_roam = 0;
    next_target_scan = 0;
    focus_human = self.water_wz_hunter;
    if (focus_human) level.water_wz_human_focus++;
    else level.water_wz_bot_focus++;
    bot_target = undefined;
    for (;;)
    {
        if (!water_wz_in_map(self)) { water_wz_search_clear(); water_wz_cash_clear(); water_wz_revive_stop(false); wait 0.25; continue; }
        now = gettime();
        if (now >= next_settings) { water_wz_apply_settings(); next_settings = now + 2000; }
        if (water_wz_vehicle_ride_tick())
        {
            water_wz_search_clear();
            water_wz_cash_clear();
            water_wz_revive_stop(false);
            wait 0.25;
            continue;
        }
        if (isdefined(self.water_wz_trade) || self.water_wz_using_streak) { water_wz_search_clear(); wait 0.25; continue; }
        if (now >= next_target_scan)
        {
            self.water_wz_human = water_wz_human_target();
            bot_target = water_wz_bot_target();
            self.water_wz_nearby_bot = bot_target;
            next_target_scan = now + 1000;
        }
        human_valid = water_wz_enemy(self.water_wz_human);
        shot = water_wz_nearby_shot();
        finish_human = human_valid && water_wz_downed_human(self.water_wz_human) && distancesquared(self.origin, self.water_wz_human.origin) <= 16000000 && water_wz_visible(self.water_wz_human);
        wants_human = self.water_wz_hunter || finish_human || !water_wz_enemy(bot_target) || (isdefined(shot) && shot.human);
        hunting = human_valid && (water_wz_has_hunt(self.water_wz_human) || (wants_human && water_wz_claim_hunt(self.water_wz_human)));
        if (isdefined(self.water_wz_target) && !isbot(self.water_wz_target) && !hunting && !water_wz_visible(self.water_wz_target))
        {
            self botclearscriptenemy();
            self.water_wz_script_enemy = undefined;
            self botclearscriptgoal();
            self.water_wz_next_goal = 0;
            self.water_wz_recover_until = 0;
            self.water_wz_progress_remaining = undefined;
            next_roam = 0;
        }
        focus_human = hunting;
        kind = water_wz_target_kind(self.water_wz_hunter || hunting, human_valid && hunting, water_wz_enemy(bot_target), finish_human && hunting);
        target = undefined;
        if (kind == "human") target = self.water_wz_human;
        else if (kind == "bot") target = bot_target;
        target = water_wz_navigation_target(target, hunting);
        if (isdefined(self.water_wz_target) && isbot(self.water_wz_target) && !water_wz_same_entity(self.water_wz_target, target))
        {
            self botclearscriptenemy();
            self.water_wz_script_enemy = undefined;
            self botclearscriptgoal();
            self.water_wz_next_goal = 0;
            self.water_wz_recover_until = 0;
            self.water_wz_progress_remaining = undefined;
            next_roam = 0;
        }
        self.water_wz_target = target;
        leader = water_wz_squad_leader();
        water_wz_squad_focus_tick(leader);
        if (isdefined(level.noice_wz_map_fix) && level.noice_wz_map_fix == "fortunes_keep" && noice_fk_recovery_tick())
        {
            wait 0.25;
            continue;
        }

        if (!water_wz_safe(self.origin))
        {
            water_wz_search_clear();
            water_wz_cash_clear();
            water_wz_revive_stop(false);
            if (self.water_wz_plate_active || (isdefined(self.insertingarmorplate) && self.insertingarmorplate)) self notify("try_armor_cancel", "gas");
            self.water_wz_tactic = "normal";
            self botclearscriptenemy();
            if (!isdefined(self.noice_wz_gas_goal) || !water_wz_safe(self.noice_wz_gas_goal) || (isdefined(self.noice_wz_failed_goal) && now < self.noice_wz_failed_until && distancesquared(self.noice_wz_gas_goal, self.noice_wz_failed_goal) < 65536))
                self.noice_wz_gas_goal = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle(0, 0.6);
            if (!water_wz_goal(self.noice_wz_gas_goal, 128) && self.water_wz_goal_status != "retry_wait") self.noice_wz_gas_goal = undefined;
            self botpressbutton("sprint", 0.6);
            wait 0.75;
            continue;
        }
        self.noice_wz_gas_goal = undefined;

        if (water_wz_revive_tick(target))
        {
            water_wz_search_clear();
            wait 0.1;
            continue;
        }
        if (water_wz_vehicle_board_tick(leader))
        {
            water_wz_search_clear();
            wait 0.25;
            continue;
        }
        water_wz_streak_tick(target, hunting);
        if (self.water_wz_using_streak) { water_wz_search_clear(); wait 0.25; continue; }
        if (water_wz_action_busy() || water_wz_grenade_tick()) { water_wz_search_clear(); wait 0.25; continue; }
        if (water_wz_tactics(target, hunting))
        {
            wait 0.25;
            continue;
        }

        contact_point = water_wz_contact_goal();
        if (!hunting && isdefined(contact_point))
        {
            if (!isdefined(self.water_wz_defending) || !self.water_wz_defending)
            {
                self botclearscriptgoal();
                self.water_wz_next_goal = 0;
                self.water_wz_recover_until = 0;
                self.water_wz_progress_remaining = undefined;
                next_roam = 0;
                self.water_wz_defending = true;
                level.water_wz_local_defenses++;
            }
            contact_visible = water_wz_enemy(self.water_wz_encounter) && water_wz_visible(self.water_wz_encounter);
            if (!contact_visible || water_wz_local_push(distancesquared(self.origin, contact_point), true, water_wz_downed_human(self.water_wz_encounter)))
            {
                if (water_wz_goal(contact_point, 48)) level.water_wz_local_pushes++;
                if (!contact_visible) self botpressbutton("sprint", 0.6);
            }
            else if (self bothasscriptgoal())
            {
                self botclearscriptgoal();
                self.water_wz_next_goal = 0;
            }
            wait 0.25;
            continue;
        }
        if (isdefined(self.water_wz_defending) && self.water_wz_defending)
        {
            self botclearscriptgoal();
            self.water_wz_next_goal = 0;
            next_roam = 0;
        }
        self.water_wz_defending = false;
        if (isdefined(shot) && shot.human && !hunting) shot = undefined;

        if (isdefined(shot) && !shot.human) shot = undefined;

        if (focus_human && water_wz_enemy(target)) shot = undefined;
        if (isdefined(shot) && shot.human && distancesquared(self.origin, shot.origin) <= 25600)
        {
            self.water_wz_checked_shot = shot.time;
            shot = undefined;
        }
        if (isdefined(shot) && (shot.human || !focus_human))
        {
            if (shot.human && water_wz_enemy(shot.shooter))
            {
                target = shot.shooter;
                self.water_wz_target = target;
            }
            if (shot.human && shot.time != self.water_wz_investigating_shot)
            {
                self.water_wz_investigating_shot = shot.time;
                level.water_wz_investigations++;
            }

            if (shot.human && water_wz_enemy(target)) water_wz_goal(target.origin, 48);
            else water_wz_goal(shot.origin, 48);
            if (!water_wz_enemy(target) || !self botcanseeentity(target)) self botpressbutton("sprint", 0.6);
        }
        else
        {
            if (water_wz_enemy(target))
            {
                remaining = distancesquared(self.origin, target.origin);
                if (!isdefined(self.water_wz_progress_remaining)) self.water_wz_progress_remaining = remaining;
                if (now < self.water_wz_recover_until)
                {
                    self botpressbutton("sprint", 0.6);
                    wait 0.25;
                    continue;
                }
                if (water_wz_should_recover(now - self.water_wz_progress_time, distancesquared(self.origin, self.water_wz_progress_origin), remaining, water_wz_visible(target), self.water_wz_progress_remaining))
                {
                    self botclearscriptgoal();
                    self.water_wz_next_goal = 0;
                    recovery_point = self.origin + anglestoforward((0, randomint(360), 0)) * randomfloatrange(256, 768);
                    if (water_wz_goal(recovery_point, 64))
                    {
                        self.water_wz_recover_until = now + 1500;
                        if (now >= self.water_wz_next_jump)
                        {
                            self botpressbutton("jump", 0.15);
                            self.water_wz_next_jump = now + randomintrange(5000, 8000);
                        }
                        self botpressbutton("sprint", 0.6);
                        level.water_wz_recoveries++;
                    }
                    self.water_wz_progress_origin = self.origin;
                    self.water_wz_progress_remaining = remaining;
                    self.water_wz_progress_time = now;
                    wait 0.25;
                    continue;
                }
                if (now - self.water_wz_progress_time >= 10000)
                {
                    self.water_wz_progress_origin = self.origin;
                    self.water_wz_progress_remaining = remaining;
                    self.water_wz_progress_time = now;
                }
            }
            if (noice_wz_player_order_tick(leader))
            {
                wait 0.25;
                continue;
            }
            if (water_wz_buyback_tick(target, leader))
            {
                wait 0.25;
                continue;
            }
            station = undefined;
            item = undefined;
            if (getdvarint(@"noice_wz_purchases", 1) && now >= self.water_wz_next_buy)
            {
                station = water_wz_station();
                // No reachable kiosk or nothing worth buying: back off instead of rescanning every kiosk each 250ms.
                if (!isdefined(station)) self.water_wz_next_buy = now + randomintrange(2000, 3500);

                if (isdefined(station) && !water_wz_downed_human(target) && (!focus_human || distancesquared(self.origin, station.origin) <= 1440000) && water_wz_follow_allows(leader, station.origin, 2000)) item = water_wz_buy_choice(station);
            }
            if (isdefined(item))
            {
                if (distancesquared(self.origin, station.origin) <= 14400)
                    self thread [[ &water_wz_purchase ]](station, item);
                else water_wz_goal(station.origin, 80);
            }
            else if (water_wz_bank_tick(target, leader))
            {
                // Banking spare cash (workaround; no extraction helicopter).
            }
            else if (water_wz_follow_regroup(leader, target))
            {
                // Too far from the squad's human player: catch up first.
            }
            else if (water_wz_plate_share_tick(leader, target))
            {
                // Taking spare plates to the squad's human player.
            }
            else if (water_wz_cash_tick(target, focus_human && water_wz_enemy(target), leader))
            {
                // Collecting plunder cash this tick.
            }
            else if (water_wz_enemy(target))
            {
                self getenemyinfo(target);
                if (water_wz_goal(target.origin, 32)) level.water_wz_hunted++;
                if (!water_wz_visible(target)) self botpressbutton("sprint", 0.6);
            }
            else if (water_wz_follow_near(leader))
            {
                // Escorting the squad's human player.
            }
            else if (water_wz_roam_due(next_roam) && water_wz_circle_ready())
            {
                accepted = water_wz_goal(water_wz_roam_point(), 160);
                if (accepted) self botpressbutton("sprint", 0.6);
                next_roam = now + 1000;
                if (!accepted) self.water_wz_goal_retry_after = next_roam;
            }
        }
        wait 0.25;
    }
}

// ---------------------------------------------------------------------------
// Squad revive
//
// Bots revive downed teammates (human players first) through the native
// last-stand flow: the reviver flags itself as holding use, then the downed
// player's revive entity is triggered with it - the same sequence the game's
// own revive test uses. Native code runs the hold timer, revive weapon,
// progress UI and finishreviveplayer.
// ---------------------------------------------------------------------------

function water_wz_revive_candidate(downed)
{
    if (!isdefined(downed) || downed == self || !isplayer(downed) || !isalive(downed)) return false;
    if (!isdefined(downed.team) || !isdefined(self.team) || downed.team != self.team) return false;
    if (!isdefined(downed.inlaststand) || !downed.inlaststand) return false;
    if (!isdefined(downed.laststandreviveent)) return false;
    if (downed isinexecutionvictim() || (isdefined(downed.isselfreviving) && downed.isselfreviving)) return false;
    if (downed scripts\mp\gametypes\br_public::isplayerinorgoingtogulag()) return false;
    // Someone else is already reviving them.
    if (isdefined(downed.beingrevived) && downed.beingrevived && !water_wz_same_entity(self.water_wz_reviving, downed)) return false;
    if (!water_wz_safe(downed.origin)) return false;
    return true;
}

function water_wz_revive_claimed(downed)
{
    if (!isdefined(level.water_wz_revive_claims)) return false;
    now = gettime();
    foreach (claim in level.water_wz_revive_claims)
    {
        if (!isdefined(claim) || !isdefined(claim.downed) || claim.downed != downed) continue;
        if (now >= claim.until || !isdefined(claim.bot) || claim.bot == self || !water_wz_in_map(claim.bot)) continue;
        return true;
    }
    return false;
}

function water_wz_revive_claim(downed)
{
    now = gettime();
    kept = [];
    if (isdefined(level.water_wz_revive_claims))
    {
        foreach (claim in level.water_wz_revive_claims)
        {
            if (!isdefined(claim) || !isdefined(claim.downed) || !isdefined(claim.bot) || now >= claim.until || claim.bot == self) continue;
            kept[kept.size] = claim;
        }
    }
    claim = spawnstruct();
    claim.downed = downed;
    claim.bot = self;
    claim.until = now + 20000;
    kept[kept.size] = claim;
    level.water_wz_revive_claims = kept;
}

function water_wz_revive_unclaim()
{
    if (!isdefined(level.water_wz_revive_claims)) return;
    kept = [];
    foreach (claim in level.water_wz_revive_claims)
    {
        if (!isdefined(claim) || (isdefined(claim.bot) && claim.bot == self)) continue;
        kept[kept.size] = claim;
    }
    level.water_wz_revive_claims = kept;
}

// Downed human teammates first, then the nearest downed bot teammate.
// Shared list of downed players, rebuilt at most every 0.4s for all bots.
function water_wz_downed_players()
{
    now = gettime();
    if (isdefined(level.water_wz_downed_time) && now < level.water_wz_downed_time) return level.water_wz_downed;
    list = [];
    if (isdefined(level.players))
    {
        foreach (player in level.players)
        {
            if (isdefined(player) && isalive(player) && isdefined(player.inlaststand) && player.inlaststand) list[list.size] = player;
        }
    }
    level.water_wz_downed = list;
    level.water_wz_downed_time = now + 400;
    return list;
}

function water_wz_revive_pick()
{
    radius = min(12000, max(500, getdvarfloat(@"noice_wz_revive_radius", 4000)));
    chosen = undefined;
    best = 999999999999;
    foreach (player in water_wz_downed_players())
    {
        if (!water_wz_revive_candidate(player) || water_wz_revive_claimed(player) || water_wz_revive_skipped(player)) continue;
        d = distancesquared(self.origin, player.origin);
        limit = radius;
        if (isbot(player)) limit = radius * 0.6;
        if (d > limit * limit) continue;
        // Humans count as much closer so they always win the tie-break.
        score = d;
        if (!isbot(player)) score = d * 0.1;
        if (score < best)
        {
            chosen = player;
            best = score;
        }
    }
    return chosen;
}

function water_wz_revive_skip(downed, duration)
{
    if (!isdefined(downed)) return;
    self.water_wz_revive_skip_target = downed;
    self.water_wz_revive_skip_until = gettime() + duration;
}

function water_wz_revive_skipped(downed)
{
    return isdefined(self.water_wz_revive_skip_target) && self.water_wz_revive_skip_target == downed && isdefined(self.water_wz_revive_skip_until) && gettime() < self.water_wz_revive_skip_until;
}

// Ends a hold (or an approach) and returns the bot to normal control.
function water_wz_revive_stop(keep_target)
{
    // Only this script sets the flag outside dev builds, so always clear it.
    self.var_7f59448717b5aa63 = undefined;
    if (isdefined(self.water_wz_reviving) && isalive(self))
    {
        self botlookatpoint(undefined);
        if (!isdefined(self.water_wz_plate_override) || !self.water_wz_plate_override) self botsetflag("disable_attack", 0);
    }
    self.water_wz_reviving = undefined;
    self.water_wz_revive_until = 0;
    self.water_wz_revive_started = undefined;
    self.water_wz_revive_triggered = false;
    if (!keep_target)
    {
        if (isdefined(self.water_wz_revive_target)) water_wz_revive_unclaim();
        self.water_wz_revive_target = undefined;
    }
}

function water_wz_revive_begin(downed)
{
    if (!isdefined(downed.laststandreviveent)) return false;
    now = gettime();
    water_wz_cash_clear();
    water_wz_search_clear();
    self notify("water_wz_slide_cancel");
    water_wz_slide_stop();
    if (self.water_wz_plate_active || (isdefined(self.insertingarmorplate) && self.insertingarmorplate)) self notify("try_armor_cancel", "noice_revive");
    self botclearscriptenemy();
    self.water_wz_script_enemy = undefined;
    self botclearscriptgoal();
    self.water_wz_next_goal = 0;
    self botsetflag("force_sprint", 0);
    self botsetflag("disable_attack", 1);
    self botsetstance("stand");
    self.water_wz_move_kind = "stand";
    self botlookatpoint(downed.origin + (0, 0, 16), 0.3, "script_forced");
    // Read by the native revive code as "holding the use button".
    self.var_7f59448717b5aa63 = 1;
    self.water_wz_reviving = downed;
    self.water_wz_revive_started = now;
    self.water_wz_revive_until = now + 12000;
    self.water_wz_revive_triggered = false;
    level.water_wz_revive_attempts++;
    return true;
}

function water_wz_revive_hold()
{
    now = gettime();
    downed = self.water_wz_reviving;
    if (!isdefined(downed) || !isalive(downed) || !isdefined(downed.inlaststand) || !downed.inlaststand)
    {
        // Revived (by us or someone else), or they died.
        if (isdefined(downed) && isalive(downed) && self.water_wz_revive_triggered)
        {
            level.water_wz_revives++;
            water_wz_log("[NoiceWZ] revive_success bot=" + self getentitynumber() + " revived=" + downed getentitynumber() + " human=" + !isbot(downed) + "\n", false);
        }
        water_wz_revive_stop(false);
        return false;
    }
    if (now >= self.water_wz_revive_until || distancesquared(self.origin, downed.origin) > 40000 || !isdefined(downed.laststandreviveent))
    {
        level.water_wz_revive_fails++;
        water_wz_log("[NoiceWZ] revive_fail bot=" + self getentitynumber() + " downed=" + downed getentitynumber() + " triggered=" + self.water_wz_revive_triggered + "\n", false);
        water_wz_revive_skip(downed, 4000);
        water_wz_revive_stop(false);
        return false;
    }
    // Short settle so the native "holding use" check sees the flag first.
    if (!self.water_wz_revive_triggered && now - self.water_wz_revive_started >= 250)
    {
        if (isdefined(downed.beingrevived) && downed.beingrevived)
        {
            // Someone beat us to it; stand guard instead.
            water_wz_revive_skip(downed, 8000);
            water_wz_revive_stop(false);
            return false;
        }
        downed.laststandreviveent notify("trigger", self);
        self.water_wz_revive_triggered = true;
    }
    self botlookatpoint(downed.origin + (0, 0, 16), 0.3, "script_forced");
    return true;
}

// Returns true while the bot is going to, or reviving, a downed teammate.
function water_wz_revive_tick(target)
{
    if (!getdvarint(@"noice_wz_enabled", 1) || !getdvarint(@"noice_wz_squad_revive", 1))
    {
        if (isdefined(self.water_wz_reviving) || isdefined(self.water_wz_revive_target)) water_wz_revive_stop(false);
        return false;
    }
    if (isdefined(self.water_wz_reviving)) return water_wz_revive_hold();
    if (self.water_wz_using_streak || isdefined(self.water_wz_trade) || isdefined(self.water_wz_loadout_started_serial) || self islinked()) return false;
    now = gettime();
    downed = self.water_wz_revive_target;
    if (isdefined(downed) && (!water_wz_revive_candidate(downed) || water_wz_revive_claimed(downed)))
    {
        water_wz_revive_stop(false);
        downed = undefined;
    }
    if (!isdefined(downed))
    {
        if (isdefined(self.water_wz_next_revive_scan) && now < self.water_wz_next_revive_scan) return false;
        self.water_wz_next_revive_scan = now + 500;
        downed = water_wz_revive_pick();
        if (!isdefined(downed)) return false;
        self.water_wz_revive_target = downed;
        water_wz_revive_claim(downed);
        water_wz_log("[NoiceWZ] revive_claim bot=" + self getentitynumber() + " downed=" + downed getentitynumber() + " human=" + !isbot(downed) + "\n", false);
    }
    remaining = distancesquared(self.origin, downed.origin);
    // An enemy close and in sight gets dealt with first, unless we're already beside them.
    if (water_wz_enemy(target) && water_wz_visible(target) && distancesquared(self.origin, target.origin) < 1440000 && remaining > 90000) return false;
    if (water_wz_healing() || water_wz_action_busy()) return false;
    if (distance2dsquared(self.origin, downed.origin) <= 4900 && abs(downed.origin[2] - self.origin[2]) <= 64 && self isonground())
    {
        if (!water_wz_revive_begin(downed)) return false;
        return true;
    }
    point = undefined;
    if (isnavmeshloaded()) point = self getclosestreachablepointonnavmesh(downed.origin);
    if (!isdefined(point) || distance2dsquared(point, downed.origin) > 9216)
    {
        water_wz_revive_skip(downed, 6000);
        water_wz_revive_stop(false);
        return false;
    }
    if (!water_wz_goal(point, 24))
    {
        water_wz_revive_skip(downed, 4000);
        water_wz_revive_stop(false);
        return false;
    }
    if (remaining > 40000) self botpressbutton("sprint", 0.6);
    return true;
}

// ---------------------------------------------------------------------------
// Squad vehicle riding
//
// When the squad's human player gets into a vehicle, squad bots walk over and
// take free passenger seats through vehicle_occupancy_enter (the call the game
// uses to seat a bot). They never take the driver's seat. When the player
// gets out or switches vehicle, they get out with vehicle_occupancy_exit.
// While seated, navigation is paused; bots still shoot from seats that allow it.
// ---------------------------------------------------------------------------

function water_wz_vehicle_of(player)
{
    if (!isdefined(player) || !isdefined(player.vehicle) || !isdefined(player.vehicle.vehiclename)) return undefined;
    return player.vehicle;
}

function water_wz_riding()
{
    return isdefined(water_wz_vehicle_of(self));
}

function water_wz_vehicle_free_seat(vehicle)
{
    if (!isdefined(vehicle) || !isdefined(vehicle.vehiclename) || !isdefined(vehicle.occupants) || !isdefined(vehicle.occupantsreserving)) return undefined;
    seats = scripts\cp_mp\vehicles\vehicle_occupancy::vehicle_occupancy_getallvehicleseats(vehicle, 0);
    if (!isdefined(seats)) return undefined;
    foreach (seat in seats)
    {
        if (scripts\cp_mp\vehicles\vehicle_occupancy::vehicle_occupancy_isdriverseat(vehicle, seat)) continue;
        if (scripts\cp_mp\vehicles\vehicle_occupancy::vehicle_occupancy_seatisavailable(vehicle, seat, self)) return seat;
    }
    return undefined;
}

// Seated: get out when the player is no longer in this vehicle. Returns true
// while the bot is in a vehicle so navigation stays paused.
function water_wz_vehicle_ride_tick()
{
    vehicle = water_wz_vehicle_of(self);
    if (!isdefined(vehicle)) return false;
    leader = water_wz_squad_leader();
    leader_vehicle = water_wz_vehicle_of(leader);
    stay = getdvarint(@"noice_wz_enabled", 1) && getdvarint(@"noice_wz_squad_vehicles", 1) && isdefined(leader_vehicle) && leader_vehicle == vehicle;
    if (!stay)
    {
        now = gettime();
        if (!isdefined(self.water_wz_next_vehicle_exit) || now >= self.water_wz_next_vehicle_exit)
        {
            self.water_wz_next_vehicle_exit = now + 1500;
            seat = scripts\cp_mp\vehicles\vehicle_occupancy::vehicle_occupancy_getoccupantseat(vehicle, self);
            if (isdefined(seat))
            {
                self thread scripts\cp_mp\vehicles\vehicle_occupancy::vehicle_occupancy_exit(vehicle, seat, self);
                water_wz_log("[NoiceWZ] vehicle_exit bot=" + self getentitynumber() + "\n", false);
            }
        }
    }
    return true;
}

// The player is in a vehicle nearby: run over and take a passenger seat.
// Seats the bot, checks it really sat down, and if the normal animated entry
// didn't complete, retries with the game's immediate seat entry.
function water_wz_vehicle_board_worker(vehicle, seat, leader)
{
    self endon("disconnect");
    self endon("death");
    level endon("game_ended");
    self.water_wz_boarding = true;
    self thread scripts\cp_mp\vehicles\vehicle_occupancy::vehicle_occupancy_enter(vehicle, seat, self);
    wait 3;
    method = "normal";
    if (!water_wz_riding() && isdefined(vehicle) && (!isdefined(vehicle.isdestroyed) || !vehicle.isdestroyed) && isdefined(leader) && water_wz_same_entity(water_wz_vehicle_of(leader), vehicle))
    {
        retry = water_wz_vehicle_free_seat(vehicle);
        if (isdefined(retry))
        {
            method = "immediate";
            self thread scripts\cp_mp\vehicles\vehicle_occupancy::vehicle_occupancy_enter(vehicle, retry, self, undefined, 1);
            wait 1.5;
        }
    }
    seated = water_wz_riding();
    self.water_wz_boarding = false;
    if (seated) level.water_wz_vehicle_boards++;
    else water_wz_cash_note("board_fail");
    distance = -1;
    if (isdefined(vehicle)) distance = int(distance2d(self.origin, vehicle.origin));
    water_wz_log("[NoiceWZ] vehicle_board bot=" + self getentitynumber() + " seated=" + seated + " method=" + method + " dist=" + distance + "\n", false);
}

function water_wz_vehicle_board_tick(leader)
{
    if (isdefined(self.water_wz_boarding) && self.water_wz_boarding) return true;
    if (!getdvarint(@"noice_wz_squad_vehicles", 1) || !isdefined(leader)) return false;
    vehicle = water_wz_vehicle_of(leader);
    if (!isdefined(vehicle) || (isdefined(vehicle.isdestroyed) && vehicle.isdestroyed)) return false;
    if (self islinked() || water_wz_healing() || water_wz_action_busy() || self.water_wz_using_streak || isdefined(self.water_wz_trade)) return false;
    now = gettime();
    if (isdefined(self.water_wz_next_board) && now < self.water_wz_next_board) return false;
    distance_sq = distancesquared(self.origin, vehicle.origin);
    // Too far away (or the vehicle already drove off): normal follow/regroup takes over.
    if (distance_sq > 9000000)
    {
        water_wz_vehicle_note("too_far", distance_sq);
        return false;
    }
    if (distance_sq <= 48400 && abs(vehicle.origin[2] - self.origin[2]) <= 140)
    {
        seat = water_wz_vehicle_free_seat(vehicle);
        if (!isdefined(seat))
        {
            // Full (or only the driver's seat is left): stay out and keep escorting.
            water_wz_vehicle_note("no_free_seat", distance_sq);
            self.water_wz_next_board = now + 3000;
            return false;
        }
        self.water_wz_next_board = now + 8000;
        water_wz_cash_clear();
        water_wz_search_clear();
        self notify("water_wz_slide_cancel");
        water_wz_slide_stop();
        self botclearscriptgoal();
        self.water_wz_next_goal = 0;
        self thread [[ &water_wz_vehicle_board_worker ]](vehicle, seat, leader);
        return true;
    }
    point = undefined;
    if (isnavmeshloaded()) point = self getclosestreachablepointonnavmesh(vehicle.origin);
    if (!isdefined(point) || !water_wz_goal(point, 48))
    {
        water_wz_vehicle_note("no_path_" + self.water_wz_goal_status, distance_sq);
        self.water_wz_next_board = now + 2000;
        return false;
    }
    self botpressbutton("sprint", 0.6);
    return true;
}

function water_wz_vehicle_note(reason, distance_sq)
{
    now = gettime();
    if (isdefined(self.water_wz_vehicle_note_after) && now < self.water_wz_vehicle_note_after) return;
    self.water_wz_vehicle_note_after = now + 5000;
    water_wz_log("[NoiceWZ] vehicle_skip bot=" + self getentitynumber() + " reason=" + reason + " dist=" + int(sqrt(distance_sq)) + "\n", false);
}

// ---------------------------------------------------------------------------
// Squad follow
//
// Bots on a human player's team stay with that player: they fight and loot
// around them, regroup when they drift past the leash, and hold a spread
// formation behind them when there is nothing else to do.
// ---------------------------------------------------------------------------

function water_wz_follow_leash()
{
    return min(4000, max(400, getdvarfloat(@"noice_wz_follow_leash", 1000)));
}

function water_wz_squad_leader_cached()
{
    now = gettime();
    if (isdefined(self.water_wz_leader_time) && now < self.water_wz_leader_time) return self.water_wz_leader_cache;
    self.water_wz_leader_cache = water_wz_squad_leader();
    self.water_wz_leader_time = now + 250;
    return self.water_wz_leader_cache;
}

function water_wz_squad_leader()
{
    if (!getdvarint(@"noice_wz_enabled", 1) || !getdvarint(@"noice_wz_squad_follow", 1) || !isdefined(self.team)) return undefined;
    humans = level.water_wz_humans;
    if (!isdefined(humans)) humans = level.players;
    if (!isdefined(humans)) return undefined;
    chosen = undefined;
    best = 999999999999;
    foreach (player in humans)
    {
        if (!isdefined(player) || isbot(player) || !isdefined(player.team) || player.team != self.team || !isalive(player)) continue;
        if (!isdefined(player.sessionstate) || player.sessionstate != "playing" || isdefined(player.br_infil_type)) continue;
        if (player scripts\mp\gametypes\br_public::isplayerinorgoingtogulag()) continue;
        d = distancesquared(self.origin, player.origin);
        if (d < best)
        {
            chosen = player;
            best = d;
        }
    }
    return chosen;
}

// Ground position to follow: the player, or the ground under them while they skydive.
function water_wz_follow_anchor(leader)
{
    if (!isdefined(leader) || !isalive(leader)) return undefined;
    if (leader isskydiving() || leader isparachuting())
    {
        ground = leader scripts\mp\gametypes\br::groundraycast(leader.origin);
        if (!isdefined(ground) || ground == (0, 0, 0)) return undefined;
        return ground;
    }
    return leader.origin;
}

function water_wz_follow_allows(leader, point, slack)
{
    if (!isdefined(leader) || !isdefined(point)) return true;
    anchor = water_wz_follow_anchor(leader);
    if (!isdefined(anchor)) return true;
    return distance2dsquared(point, anchor) <= slack * slack;
}

function water_wz_follow_count(leader)
{
    count = 0;
    if (!isdefined(level.players) || !isdefined(leader) || !isdefined(leader.team)) return 0;
    foreach (bot in level.players)
    {
        if (isdefined(bot) && isbot(bot) && isdefined(bot.team) && bot.team == leader.team && water_wz_in_map(bot)) count++;
    }
    return count;
}

// Spread squad bots in an arc behind the player, one slot each.
function water_wz_follow_point(leader, anchor)
{
    now = gettime();
    if (isdefined(self.water_wz_follow_point) && isdefined(self.water_wz_follow_anchor) && now < self.water_wz_next_follow_point && distancesquared(anchor, self.water_wz_follow_anchor) < 40000) return self.water_wz_follow_point;
    slot = 0;
    count = 0;
    foreach (bot in level.players)
    {
        if (!isdefined(bot) || !isbot(bot) || !isdefined(bot.team) || bot.team != self.team) continue;
        if (bot == self) slot = count;
        count++;
    }
    spread = 0;
    if (count > 1) spread = (slot - (count - 1) * 0.5) * 50;
    angles = leader getplayerangles();
    distance_back = min(900, max(128, getdvarfloat(@"noice_wz_follow_distance", 300)));
    candidate = anchor + anglestoforward((0, angles[1] + 180 + spread, 0)) * distance_back;
    point = undefined;
    if (isnavmeshloaded())
    {
        point = self getclosestreachablepointonnavmesh(candidate);
        if (!isdefined(point) || distance2dsquared(point, anchor) > (distance_back * 2.5) * (distance_back * 2.5)) point = self getclosestreachablepointonnavmesh(anchor);
        if (!isdefined(point)) point = getclosestpointonnavmesh(anchor, self);
    }
    if (!isdefined(point)) return undefined;
    self.water_wz_follow_point = point;
    self.water_wz_follow_anchor = anchor;
    self.water_wz_next_follow_point = now + 1000;
    return point;
}

// Past the leash with no enemy in sight: drop looting and catch up.
function water_wz_follow_regroup(leader, target)
{
    if (!isdefined(leader))
    {
        self.water_wz_regrouping = false;
        return false;
    }
    // A bot briefly banking spare cash finishes before being pulled back.
    if (isdefined(self.water_wz_bank_until) && gettime() < self.water_wz_bank_until) return false;
    if (water_wz_enemy(target) && water_wz_visible(target)) return false;
    anchor = water_wz_follow_anchor(leader);
    if (!isdefined(anchor)) return false;
    leash = water_wz_follow_leash();
    remaining = distance2dsquared(self.origin, anchor);
    // Hysteresis: once regrouping, keep going until well inside the leash.
    if (isdefined(self.water_wz_regrouping) && self.water_wz_regrouping)
    {
        if (remaining <= (leash * 0.6) * (leash * 0.6))
        {
            self.water_wz_regrouping = false;
            return false;
        }
    }
    else
    {
        if (remaining <= leash * leash) return false;
        self.water_wz_regrouping = true;
        level.water_wz_follow_regroups++;
    }
    water_wz_cash_clear();
    point = water_wz_follow_point(leader, anchor);
    if (!isdefined(point) || !water_wz_goal(point, 96)) return false;
    if (remaining > 360000) self botpressbutton("sprint", 0.6);
    return true;
}

// Nothing to fight or loot: hold a formation slot near the player.
function water_wz_follow_near(leader)
{
    if (!isdefined(leader)) return false;
    anchor = water_wz_follow_anchor(leader);
    if (!isdefined(anchor)) return false;
    point = water_wz_follow_point(leader, anchor);
    if (!isdefined(point)) return false;
    if (distancesquared(self.origin, point) > 36864)
    {
        if (!water_wz_goal(point, 128)) return false;
        velocity = leader getvelocity();
        if (distancesquared(self.origin, point) > 250000 || velocity[0] * velocity[0] + velocity[1] * velocity[1] > 40000) self botpressbutton("sprint", 0.6);
    }
    return true;
}

// ---------------------------------------------------------------------------
// Squad focus fire
//
// Each human remembers the enemy they are fighting: whoever they last damaged
// or were damaged by (from the damage hook), or whoever is under their
// crosshair when they fire. Squad bots switch to that enemy when they can see
// it, and move toward it when they can't.
// ---------------------------------------------------------------------------

function water_wz_note_human_focus(human, enemy)
{
    if (!isdefined(human) || !isdefined(enemy) || !isplayer(human) || !isplayer(enemy) || isbot(human) || human == enemy) return;
    if (!isdefined(human.team) || !isdefined(enemy.team) || human.team == enemy.team) return;
    human.water_wz_focus_enemy = enemy;
    human.water_wz_focus_time = gettime();
}

// Called on a human's weapon_fired: picks the enemy closest to their crosshair.
function water_wz_human_aim_focus()
{
    if (!getdvarint(@"noice_wz_enabled", 1) || !getdvarint(@"noice_wz_squad_focus", 1) || !isdefined(level.players) || !isalive(self) || !isdefined(self.team)) return;
    eye = self geteye();
    forward = anglestoforward(self getplayerangles());
    chosen = undefined;
    chosen_point = undefined;
    best = 0.996;
    foreach (player in level.players)
    {
        if (!isdefined(player) || player == self || !isdefined(player.team) || player.team == self.team || !water_wz_deployed(player, true)) continue;
        point = player gettagorigin("j_spinelower");
        if (!isdefined(point) || distancesquared(eye, point) > 64000000) continue;
        dot = vectordot(vectornormalize(point - eye), forward);
        if (dot <= best) continue;
        chosen = player;
        chosen_point = point;
        best = dot;
    }
    if (!isdefined(chosen) || !sighttracepassed(eye, chosen_point, 0, self, chosen)) return;
    water_wz_note_human_focus(self, chosen);
}

function water_wz_squad_focus_target(leader)
{
    if (!isdefined(leader) || !getdvarint(@"noice_wz_squad_focus", 1)) return undefined;
    enemy = leader.water_wz_focus_enemy;
    if (!isdefined(enemy) || !isdefined(leader.water_wz_focus_time) || gettime() - leader.water_wz_focus_time > 4000) return undefined;
    if (!water_wz_enemy(enemy) || distancesquared(self.origin, enemy.origin) > 16000000) return undefined;
    return enemy;
}

// Navigation side: make the bot aware of the squad's target and, when it can't
// see it, remember its position so contact handling moves the bot in.
function water_wz_squad_focus_tick(leader)
{
    focus = water_wz_squad_focus_target(leader);
    if (!isdefined(focus) || water_wz_visible(focus)) return;
    self getenemyinfo(focus);
    if (!water_wz_follow_allows(leader, focus.origin, water_wz_follow_leash() * 2)) return;
    self.water_wz_contact = focus;
    self.water_wz_contact_point = focus.origin;
    self.water_wz_contact_time = gettime();
    if (!isdefined(self.water_wz_next_contact_velocity) || gettime() >= self.water_wz_next_contact_velocity)
    {
        self.water_wz_contact_velocity = focus getvelocity();
        self.water_wz_next_contact_velocity = gettime() + 250;
    }
}

// ---------------------------------------------------------------------------
// Plate sharing
//
// A squad bot with spare plates walks up to its human player when they are
// low and hands them some plates directly.
// ---------------------------------------------------------------------------

function water_wz_plate_share_tick(leader, target)
{
    if (!getdvarint(@"noice_wz_plate_share", 1) || !isdefined(leader) || !isalive(leader)) return false;
    if (!isdefined(level.allowarmor) || !level.allowarmor) return false;
    if (isdefined(leader.inlaststand) && leader.inlaststand) return false;
    if (leader isskydiving() || leader isparachuting()) return false;
    if (water_wz_enemy(target) && water_wz_visible(target)) return false;
    if (water_wz_healing() || water_wz_action_busy() || isdefined(self.water_wz_trade)) return false;
    now = gettime();
    if (isdefined(self.water_wz_next_plate_share) && now < self.water_wz_next_plate_share) return false;
    if (isdefined(leader.water_wz_plate_gift_after) && now < leader.water_wz_plate_gift_after) return false;
    human_cap = leader armor::function_47320a25b8ee003();
    human_have = leader armor::function_20b8437058079297();
    if (human_have >= 2 || human_have >= human_cap) return false;
    mine = self armor::function_20b8437058079297();
    if (mine < 2) return false;
    give = int(min(min(human_cap - human_have, mine - 1), 3));
    if (give <= 0) return false;
    distance_sq = distancesquared(self.origin, leader.origin);
    // Only bots already close by walk over; nobody crosses the map for this.
    if (distance_sq > 490000) return false;
    if (distance_sq > 12100)
    {
        point = undefined;
        if (isnavmeshloaded()) point = self getclosestreachablepointonnavmesh(leader.origin);
        if (!isdefined(point) || !water_wz_goal(point, 64))
        {
            self.water_wz_next_plate_share = now + 10000;
            return false;
        }
        return true;
    }
    // Hand the plates straight to the human with the game's own give function (the
    // one the gulag reward uses). Ground drops were spawning nothing usable.
    self armor::function_774133dc8df0ccd5(mine - give);
    given = scripts\mp\gametypes\br_pickups::br_forcegivecustompickupitem(leader, "brloot_armor_plate", 1, give);
    if (!isdefined(given) || !given || self armor::function_20b8437058079297() != mine - give)
    {
        // Hand-off failed: give the plates back to the bot.
        self armor::function_774133dc8df0ccd5(mine);
        self.water_wz_next_plate_share = now + 20000;
        water_wz_log("[NoiceWZ] plate_share_failed bot=" + self getentitynumber() + "\n", false);
        return false;
    }
    self.water_wz_next_plate_share = now + 45000;
    leader.water_wz_plate_gift_after = now + 25000;
    level.water_wz_plate_gifts++;
    leader iprintln("^2" + self.name + " ^7gave you " + give + " armor plate(s)");
    water_wz_log("[NoiceWZ] plate_share bot=" + self getentitynumber() + " human=" + leader getentitynumber() + " plates=" + give + "\n", false);
    return true;
}

// ---------------------------------------------------------------------------
// Plunder banking (workaround)
//
// Bots no longer use extraction pads or helicopters for banking. When a bot
// is stocked up and carrying more cash than it needs to keep in reserve, it
// briefly channels and the game banks the spare cash directly. Banking is
// cancelled by combat, recent damage, death/reset, or no longer being stocked.
// ---------------------------------------------------------------------------

function water_wz_bank_active()
{
    now = gettime();
    if (isdefined(level.water_wz_bank_active_time) && now < level.water_wz_bank_active_time) return level.water_wz_bank_active_cache;
    active = water_wz_bank_compute();
    level.water_wz_bank_active_cache = active;
    level.water_wz_bank_active_time = now + 1000;
    if (!isdefined(level.water_wz_bank_status_logged) && !gamelogic::inprematch())
    {
        // One line per match so a non-working setup can be diagnosed from the log.
        level.water_wz_bank_status_logged = 1;
        logprint("[NoiceWZ] bank_status active=" + active + " cash_mode=" + water_wz_cash_mode_active() + " plunder=" + water_wz_plunder_mode() + "\n");
    }
    return active;
}

function water_wz_bank_compute()
{
    if (!getdvarint(@"noice_wz_deposit", 1) || !water_wz_cash_mode_active() || !water_wz_plunder_mode()) return false;
    return isdefined(level.br_plunder_enabled) && level.br_plunder_enabled;
}

function water_wz_bank_clear()
{
    self.water_wz_bank_until = undefined;
    self.water_wz_bank_amount = undefined;
}

function water_wz_bank_stocked()
{
    if (water_wz_plates_low()) return false;
    if (getdvarint(@"noice_wz_self_revive", 0) && !self scripts\mp\gametypes\br_public::hasselfrevivetoken()) return false;
    if (water_wz_weapon_ammo_low(self.water_wz_owned_primary) || water_wz_weapon_ammo_low(self.water_wz_owned_secondary)) return false;
    return true;
}

function water_wz_bank_reserve()
{
    reserve = max(0, getdvarint(@"noice_wz_cash_reserve", 0));
    keep = int(max(500, getdvarfloat(@"noice_wz_deposit_at", 5000)));
    if (keep > reserve) reserve = keep;
    if (getdvarint(@"noice_wz_buyback", 1))
    {
        mate = water_wz_buyback_target();
        token = isdefined(self.hasrespawntoken) && self.hasrespawntoken;
        if (isdefined(mate) && !token)
        {
            cost = water_wz_buyback_cost();
            if (isdefined(cost) && cost > reserve) reserve = cost;
        }
    }
    return int(reserve);
}

function water_wz_bank_safe(target)
{
    if (water_wz_enemy(target) && water_wz_visible(target)) return false;
    if (isdefined(self.water_wz_last_hurt) && gettime() - self.water_wz_last_hurt < 5000) return false;
    return water_wz_safe(self.origin);
}

function water_wz_bank_apply(amount)
{
    before = water_wz_carried();
    amount = int(min(amount, before));
    if (amount <= 0) return 0;
    data = spawnstruct();
    data.player = self;
    data.playersplash = "none";
    data.playplundersound = 0;
    data.playanimation = 0;
    data.playerscoreeventvalue = 0;
    self scripts\mp\gametypes\br_plunder::playerplunderbank(amount, undefined, data);
    banked = before - water_wz_carried();
    if (banked > 0)
    {
        level.water_wz_banks++;
        level.water_wz_bank_value += banked;
    }
    return banked;
}

// Returns true while the bot is banking (or has just banked) spare cash.
function water_wz_bank_tick(target, leader)
{
    if (!water_wz_bank_active())
    {
        water_wz_bank_clear();
        return false;
    }
    now = gettime();
    if (!water_wz_in_map(self) || self islinked() || water_wz_healing() || water_wz_action_busy() || self.water_wz_using_streak || isdefined(self.water_wz_trade) || isdefined(self.water_wz_loadout_started_serial))
    {
        water_wz_bank_clear();
        return false;
    }
    if (isdefined(self.water_wz_bank_until))
    {
        if (!water_wz_bank_safe(target) || !water_wz_bank_stocked() || (isdefined(leader) && !water_wz_follow_allows(leader, self.origin, water_wz_follow_leash() * 3)))
        {
            water_wz_log("[NoiceWZ] bank_cancel bot=" + self getentitynumber() + " carried=" + water_wz_carried() + "\n", true);
            water_wz_bank_clear();
            self.water_wz_bank_next = now + 4000;
            return false;
        }
        if (self bothasscriptgoal()) self botclearscriptgoal();
        if (now < self.water_wz_bank_until) return true;
        reserve = water_wz_bank_reserve();
        amount = int(min(self.water_wz_bank_amount, max(0, water_wz_carried() - reserve)));
        banked = water_wz_bank_apply(amount);
        water_wz_bank_clear();
        if (banked > 0)
        {
            self.water_wz_bank_next = now + randomintrange(8000, 15000);
            water_wz_log("[NoiceWZ] bank bot=" + self getentitynumber() + " banked=" + banked + " carried=" + water_wz_carried() + " reserve=" + reserve + "\n", true);
            return true;
        }
        self.water_wz_bank_next = now + 5000;
        return false;
    }
    if (isdefined(self.water_wz_bank_next) && now < self.water_wz_bank_next) return false;
    self.water_wz_bank_next = now + 2000;
    if (!water_wz_bank_safe(target) || !water_wz_bank_stocked()) return false;
    if (isdefined(leader) && !water_wz_follow_allows(leader, self.origin, water_wz_follow_leash() * 3)) return false;
    carried = water_wz_carried();
    reserve = water_wz_bank_reserve();
    amount = carried - reserve;
    if (amount < 500) return false;
    self.water_wz_bank_amount = amount;
    self.water_wz_bank_until = now + 2500;
    water_wz_cash_clear();
    if (self bothasscriptgoal()) self botclearscriptgoal();
    water_wz_log("[NoiceWZ] bank_start bot=" + self getentitynumber() + " amount=" + amount + " carried=" + carried + " reserve=" + reserve + "\n", true);
    return true;
}

// ---------------------------------------------------------------------------
// Squad buybacks
//
// When a squadmate is eliminated and eligible for a buyback, a bot that can
// afford it goes to the nearest buy station and makes the station's own
// "br_team_revive" purchase for that squadmate. Human squadmates come first.
// ---------------------------------------------------------------------------

function water_wz_carried()
{
    if (!isdefined(self.plundercount)) return 0;
    return self.plundercount;
}

function water_wz_buyback_claimed(mate)
{
    if (!isdefined(level.water_wz_buyback_claims)) return false;
    claim = level.water_wz_buyback_claims[mate getentitynumber()];
    return isdefined(claim) && isdefined(claim.bot) && claim.bot != self && gettime() < claim.until && water_wz_in_map(claim.bot);
}

// Shared list of players eligible for a buyback, rebuilt at most every 2s.
function water_wz_eliminated_players()
{
    now = gettime();
    if (isdefined(level.water_wz_eliminated_time) && now < level.water_wz_eliminated_time) return level.water_wz_eliminated;
    list = [];
    if (isdefined(level.players))
    {
        foreach (player in level.players)
        {
            if (isdefined(player) && !isalive(player) && isdefined(player.sessionuimemberindex) && player scripts\mp\gametypes\br_public::iseligibleforteamrevive()) list[list.size] = player;
        }
    }
    level.water_wz_eliminated = list;
    level.water_wz_eliminated_time = now + 2000;
    return list;
}

function water_wz_buyback_target()
{
    if (!isdefined(self.team)) return undefined;
    chosen = undefined;
    foreach (mate in water_wz_eliminated_players())
    {
        if (!isdefined(mate) || mate == self || !isdefined(mate.team) || mate.team != self.team || !isdefined(mate.sessionuimemberindex)) continue;
        if (!mate scripts\mp\gametypes\br_public::iseligibleforteamrevive() || water_wz_buyback_claimed(mate)) continue;
        if (!isbot(mate)) return mate;
        if (!isdefined(chosen)) chosen = mate;
    }
    return chosen;
}

function water_wz_buyback_cost()
{
    if (!isdefined(level.br_armory_kiosk) || !isdefined(level.br_armory_kiosk.items)) return undefined;
    itemdata = scripts\mp\gametypes\br_armory_kiosk::function_601181692f53e4ed("teamrevive");
    if (!isdefined(itemdata) || !isdefined(itemdata.cost)) return undefined;
    return scripts\mp\gametypes\br_armory_kiosk::_getactualcost(self, itemdata);
}

function water_wz_buyback_station(leader)
{
    if (!isdefined(level.br_armory_kiosk_enabled) || !level.br_armory_kiosk_enabled) return undefined;
    stations = scripts\mp\gametypes\br_armory_kiosk::getallspawninstances();
    if (!isdefined(stations)) return undefined;
    chosen = undefined;
    best = 144000000;
    foreach (station in stations)
    {
        if (!isdefined(station) || !isdefined(station.origin)) continue;
        if ((isdefined(station.disabled) && station.disabled) || (isdefined(station.disablederrormsg) && station.disablederrormsg)) continue;
        if (!water_wz_safe(station.origin)) continue;
        if (isdefined(leader) && !water_wz_follow_allows(leader, station.origin, water_wz_follow_leash() * 4)) continue;
        d = distancesquared(self.origin, station.origin);
        if (d >= best || !scripts\mp\gametypes\br_armory_kiosk::canusekiosk(station, self)) continue;
        chosen = station;
        best = d;
    }
    return chosen;
}

function water_wz_buyback_worker(station, mate)
{
    self endon("disconnect");
    self endon("death");
    self endon("water_wz_life_reset");
    level endon("game_ended");
    if (isdefined(self.water_wz_trade) || !water_wz_in_map(self) || !isdefined(mate) || !isdefined(mate.sessionuimemberindex)) return;
    if (!mate scripts\mp\gametypes\br_public::iseligibleforteamrevive()) return;
    self.water_wz_trade = station;
    self.water_wz_old_kiosk = self.br_kiosk;
    self.water_wz_old_permission = self.armorykioskpurchaseallowed;
    self.br_kiosk = station;
    self.armorykioskpurchaseallowed = 1;
    if (!isdefined(station.playersusing)) station.playersusing = [];
    before = water_wz_carried();
    token_before = isdefined(self.hasrespawntoken) && self.hasrespawntoken;
    self scripts\mp\gametypes\br_armory_kiosk::onarmorykioskpurchase("br_team_revive", mate.sessionuimemberindex + 1);
    deadline = gettime() + 3000;
    while (gettime() < deadline && isdefined(mate) && mate scripts\mp\gametypes\br_public::iseligibleforteamrevive() && water_wz_carried() == before) wait 0.1;
    token_after = isdefined(self.hasrespawntoken) && self.hasrespawntoken;
    success = water_wz_carried() < before || (token_before && !token_after) || (isdefined(mate) && !mate scripts\mp\gametypes\br_public::iseligibleforteamrevive());
    water_wz_clear_trade();
    if (success) level.water_wz_buybacks++;
    else water_wz_cash_note("buyback_fail");
    human = isdefined(mate) && !isbot(mate);
    water_wz_log("[NoiceWZ] buyback bot=" + self getentitynumber() + " human=" + human + " success=" + success + " cash=" + water_wz_carried() + "\n", !success);
    if (success) self.water_wz_next_buyback = gettime() + 3000;
    else self.water_wz_next_buyback = gettime() + 15000;
}

function water_wz_buyback_tick(target, leader)
{
    if (!getdvarint(@"noice_wz_buyback", 1) || !getdvarint(@"noice_wz_enabled", 1)) return false;
    now = gettime();
    if (isdefined(self.water_wz_next_buyback) && now < self.water_wz_next_buyback) return false;
    if (!water_wz_in_map(self) || self islinked() || water_wz_healing() || water_wz_action_busy() || self.water_wz_using_streak || isdefined(self.water_wz_trade) || isdefined(self.water_wz_loadout_started_serial)) return false;
    if (water_wz_enemy(target) && water_wz_visible(target)) return false;
    mate = water_wz_buyback_target();
    if (!isdefined(mate))
    {
        self.water_wz_next_buyback = now + 2000;
        return false;
    }
    cost = water_wz_buyback_cost();
    token = isdefined(self.hasrespawntoken) && self.hasrespawntoken;
    if (!isdefined(cost) || (!token && (!isdefined(self.plundercount) || self.plundercount < cost)))
    {
        self.water_wz_next_buyback = now + 4000;
        return false;
    }
    // The person being bought back no longer anchors the follow leash.
    if (isdefined(leader) && leader == mate) leader = undefined;
    station = water_wz_buyback_station(leader);
    if (!isdefined(station))
    {
        self.water_wz_next_buyback = now + 4000;
        return false;
    }
    if (!isdefined(level.water_wz_buyback_claims)) level.water_wz_buyback_claims = [];
    claim = spawnstruct();
    claim.bot = self;
    claim.until = now + 30000;
    level.water_wz_buyback_claims[mate getentitynumber()] = claim;
    water_wz_cash_clear();
    if (distancesquared(self.origin, station.origin) <= 14400)
    {
        self.water_wz_next_buyback = now + 4000;
        self thread [[ &water_wz_buyback_worker ]](station, mate);
        return true;
    }
    if (!water_wz_goal(station.origin, 80))
    {
        self.water_wz_next_buyback = now + 4000;
        return false;
    }
    self botpressbutton("sprint", 0.6);
    return true;
}

// ---------------------------------------------------------------------------
// Ground loot and loot boxes
//
// The cash collector also picks up loot the bot actually needs (armor plates
// when short, ammo for its own guns, a self-revive when those are enabled) and
// opens closed loot boxes. Loot goes through br_pickups::lootused like cash;
// boxes go through br_lootcache::lootcacheused with the "body" part, which is
// how the game opens them for a player.
// ---------------------------------------------------------------------------

function water_wz_collect_active()
{
    if (!getdvarint(@"noice_wz_enabled", 1)) return false;
    return water_wz_cash_mode_active() || getdvarint(@"noice_wz_ground_loot", 1) || getdvarint(@"noice_wz_open_caches", 1);
}

function water_wz_cache_ready(instance)
{
    if (!getdvarint(@"noice_wz_open_caches", 1) || !isdefined(instance) || isdefined(instance.entity)) return false;
    // Personal supply boxes build their contents from the opener's saved loadouts; bots skip them.
    if (isdefined(instance.type) && isstring(instance.type) && issubstr(instance.type, "personal")) return false;
    if (scripts\mp\gametypes\br_gametypes::isbrgametypefuncdefined("isCachePersonalSupply"))
    {
        personal = scripts\mp\gametypes\br_gametypes::runbrgametypefunc("isCachePersonalSupply", instance);
        if (isdefined(personal) && personal) return false;
    }
    if (!instance getscriptablehaspart("body")) return false;
    state = instance getscriptablepartstate("body");
    return isdefined(state) && (state == "closed_usable" || state == "closed_usable_no_collision");
}

function water_wz_plates_low()
{
    if (!isdefined(level.allowarmor) || !level.allowarmor) return false;
    return self armor::function_20b8437058079297() < self armor::function_47320a25b8ee003();
}

function water_wz_weapon_ammo_wanted(weapon, name)
{
    if (!water_wz_weapon_ammo_low(weapon)) return false;
    ammo = scripts\mp\gametypes\br_weapons::br_ammo_type_for_weapon(weapon);
    return isdefined(ammo) && isstring(ammo) && ammo == name;
}

function water_wz_loot_wanted(name)
{
    if (!getdvarint(@"noice_wz_ground_loot", 1) || !isdefined(name) || !isstring(name)) return false;
    if (name == "brloot_armor_plate") return water_wz_plates_low();
    if (name == "brloot_self_revive") return getdvarint(@"noice_wz_self_revive", 0) && !self scripts\mp\gametypes\br_public::hasselfrevivetoken();
    if (scripts\mp\gametypes\br_public::isammo(name)) return water_wz_weapon_ammo_wanted(self.water_wz_owned_primary, name) || water_wz_weapon_ammo_wanted(self.water_wz_owned_secondary, name);
    return false;
}

// True when anything on the ground could be useful, so the wide loot query is worth running.
function water_wz_loot_needed()
{
    if (!getdvarint(@"noice_wz_ground_loot", 1)) return false;
    if (water_wz_plates_low()) return true;
    if (getdvarint(@"noice_wz_self_revive", 0) && !self scripts\mp\gametypes\br_public::hasselfrevivetoken()) return true;
    return water_wz_weapon_ammo_low(self.water_wz_owned_primary) || water_wz_weapon_ammo_low(self.water_wz_owned_secondary);
}

function water_wz_weapon_ammo_low(weapon)
{
    return isdefined(weapon) && self hasweapon(weapon) && self getweaponammostock(weapon) < weaponmaxammo(weapon) * 0.6;
}

// "cash", "loot", "cache" or "" for an instance this bot should go for.
function water_wz_loot_kind(instance)
{
    if (!isdefined(instance) || !isdefined(instance.origin)) return "";
    name = water_wz_cash_name(instance);
    if (!isdefined(name)) return "";
    if (scripts\mp\gametypes\br_pickups::iscache(name))
    {
        if (water_wz_cache_ready(instance)) return "cache";
        return "";
    }
    if (isdefined(instance.type) && instance getscriptablehaspart(instance.type) && instance getscriptablepartstate(instance.type) == "hidden") return "";
    if (water_wz_cash_is_name(name))
    {
        if (water_wz_cash_mode_active()) return "cash";
        return "";
    }
    if (water_wz_loot_wanted(name)) return "loot";
    return "";
}

function water_wz_loot_worth(instance, kind)
{
    if (kind == "cash") return water_wz_cash_value(instance);
    if (kind == "cache") return 1200;
    name = water_wz_cash_name(instance);
    if (isdefined(name) && isstring(name) && name == "brloot_armor_plate")
    {
        if (self armor::function_20b8437058079297() <= 0) return 3000;
        return 1500;
    }
    if (isdefined(name) && isstring(name) && name == "brloot_self_revive") return 2000;
    return 800;
}

function water_wz_loot_entry(instance, kind)
{
    entry = spawnstruct();
    entry.instance = instance;
    entry.kind = kind;
    return entry;
}

// Cash piles (name-filtered when that works), plus loot and boxes from one
// unfiltered query when the bot needs loot or boxes are enabled.
function water_wz_loot_candidates(origin, radius)
{
    found = [];
    cash_mode = water_wz_cash_mode_active();
    filtered_cash = 0;
    if (cash_mode && (!isdefined(level.water_wz_cash_query) || level.water_wz_cash_query != "raw"))
    {
        foreach (name in water_wz_cash_names())
        {
            items = getlootscriptablearrayinradius(name, undefined, origin, radius);
            if (!isdefined(items)) continue;
            foreach (instance in items)
            {
                if (found.size >= 64) break;
                if (water_wz_cash_live(instance)) found[found.size] = water_wz_loot_entry(instance, "cash");
            }
        }
        filtered_cash = found.size;
        if (filtered_cash > 0 && !isdefined(level.water_wz_cash_query))
        {
            level.water_wz_cash_query = "filtered";
            water_wz_log("[NoiceWZ] cash_query=filtered\n", false);
        }
    }
    cash_needs_raw = cash_mode && filtered_cash == 0 && (!isdefined(level.water_wz_cash_query) || level.water_wz_cash_query == "raw");
    // The wide "all loot" query is the expensive part: only run it when this bot
    // needs loot, when cash can only be found that way, or every ~8s for boxes.
    want_boxes = getdvarint(@"noice_wz_open_caches", 1) && (!isdefined(self.water_wz_next_box_scan) || gettime() >= self.water_wz_next_box_scan);
    if (!cash_needs_raw && !want_boxes && !water_wz_loot_needed()) return found;
    if (want_boxes) self.water_wz_next_box_scan = gettime() + randomintrange(7000, 10000);
    raw = getlootscriptablearrayinradius(undefined, undefined, origin, min(radius, 1500));
    if (!isdefined(raw)) return found;
    checked = 0;
    raw_cash = 0;
    foreach (instance in raw)
    {
        if (checked >= 150 || found.size >= 96) break;
        checked++;
        kind = water_wz_loot_kind(instance);
        if (kind == "") continue;
        if (kind == "cash")
        {
            // Already gathered by the name filter.
            if (!cash_needs_raw) continue;
            raw_cash++;
        }
        found[found.size] = water_wz_loot_entry(instance, kind);
    }
    if (raw_cash > 0 && !isdefined(level.water_wz_cash_query))
    {
        level.water_wz_cash_query = "raw";
        water_wz_log("[NoiceWZ] cash_query=raw (name filter returned nothing)\n", false);
    }
    return found;
}

function water_wz_loot_take(instance, kind)
{
    if (water_wz_loot_kind(instance) != kind) return false;
    if (kind == "cash") return water_wz_cash_pickup(instance);
    if (kind == "cache")
    {
        state = instance getscriptablepartstate("body");
        scripts\mp\gametypes\br_lootcache::lootcacheused(instance, "body", state, self, 0);
        opened = !water_wz_cache_ready(instance);
        if (opened) level.water_wz_caches_opened++;
        else water_wz_cash_note("cache_fail");
        water_wz_log("[NoiceWZ] cache_open bot=" + self getentitynumber() + " success=" + opened + "\n", !opened);
        return opened;
    }
    plates_before = self armor::function_20b8437058079297();
    name = water_wz_cash_text(water_wz_cash_name(instance));
    scripts\mp\gametypes\br_pickups::lootused(instance, instance.type, "visible", self, 0);
    taken = water_wz_loot_kind(instance) != "loot" || self armor::function_20b8437058079297() > plates_before;
    if (taken) level.water_wz_loot_taken++;
    else water_wz_cash_note("loot_fail");
    water_wz_log("[NoiceWZ] loot_pickup bot=" + self getentitynumber() + " item=" + name + " success=" + taken + "\n", false);
    return taken;
}

// ---------------------------------------------------------------------------
// Plunder cash collection
//
// Cash piles are loot scriptables (brloot_plunder_cash_*). Bots find them with
// getlootscriptablearrayinradius, path beside the pile, and collect through
// br_pickups::lootused - the call the game makes for scripted loot rewards - so
// plundercount, team plunder totals and analytics run natively and the pile is
// hidden/freed for everyone.
// ---------------------------------------------------------------------------

function water_wz_cash_note(reason)
{
    if (!isdefined(level.water_wz_cash_reasons)) level.water_wz_cash_reasons = [];
    if (!isdefined(level.water_wz_cash_reasons[reason])) level.water_wz_cash_reasons[reason] = 0;
    level.water_wz_cash_reasons[reason]++;
}

function water_wz_cash_count(reason)
{
    if (!isdefined(level.water_wz_cash_reasons) || !isdefined(level.water_wz_cash_reasons[reason])) return 0;
    return level.water_wz_cash_reasons[reason];
}

function water_wz_plunder_mode()
{
    if (isdefined(level.water_wz_plunder_mode) && level.water_wz_plunder_mode) return true;
    now = gettime();
    if (isdefined(level.water_wz_next_plunder_check) && now < level.water_wz_next_plunder_check) return false;
    level.water_wz_next_plunder_check = now + 5000;
    sub = undefined;
    if (isdefined(level.gametypebundle)) sub = scripts\mp\utility\game::getsubgametype();
    plunder = false;
    if (isdefined(sub) && isstring(sub) && (issubstr(sub, "plunder") || issubstr(sub, "risk"))) plunder = true;
    if (isdefined(level.gametype) && isstring(level.gametype) && issubstr(level.gametype, "plunder")) plunder = true;
    // Set only by br_gametype_plunder::init.
    if (isdefined(level.teamplunderscoremechanic)) plunder = true;
    if (scripts\engine\utility::issharedfuncdefined("plunder", "packClientMatchData", 0)) plunder = true;
    level.water_wz_plunder_mode = plunder;
    level.water_wz_plunder_sub = sub;
    if (plunder) water_wz_log("[NoiceWZ] cash_mode plunder detected subgametype=" + water_wz_cash_text(sub) + "\n", false);
    return plunder;
}

function water_wz_cash_names()
{
    if (isdefined(level.br_plunder) && isdefined(level.br_plunder.names) && level.br_plunder.names.size > 0) return level.br_plunder.names;
    return ["brloot_plunder_cash_common_1", "brloot_plunder_cash_uncommon_1", "brloot_plunder_cash_uncommon_2", "brloot_plunder_cash_uncommon_3", "brloot_plunder_cash_rare_1", "brloot_plunder_cash_rare_2", "brloot_plunder_cash_epic_1", "brloot_plunder_cash_epic_2", "brloot_plunder_cash_legendary_1"];
}

function water_wz_cash_economy()
{
    return (isdefined(level.br_plunder_enabled) && level.br_plunder_enabled) || isdefined(level.br_plunder);
}

function water_wz_cash_mode_active()
{
    now = gettime();
    if (isdefined(level.water_wz_cash_mode_time) && now < level.water_wz_cash_mode_time) return level.water_wz_cash_mode_cache;
    level.water_wz_cash_mode_cache = water_wz_cash_mode_compute();
    level.water_wz_cash_mode_time = now + 1000;
    return level.water_wz_cash_mode_cache;
}

function water_wz_cash_mode_compute()
{
    if (!getdvarint(@"noice_wz_enabled", 1)) return false;
    mode = getdvarint(@"noice_wz_cash_mode", 1);
    if (mode <= 0) return false;
    if (mode >= 2) return water_wz_cash_economy();
    return water_wz_plunder_mode() || (water_wz_cash_economy() && isdefined(level.teamplunderscoremechanic));
}

function water_wz_cash_name(instance)
{
    if (!isdefined(instance)) return undefined;
    return scripts\mp\gametypes\br_pickups::lootgetscriptablename(instance);
}

function water_wz_cash_is_name(name)
{
    if (!isdefined(name)) return false;
    if (scripts\mp\gametypes\br_pickups::isplunder(name)) return true;
    if (!isstring(name)) return false;
    if (issubstr(name, "plunder_cash")) return true;
    foreach (cash in water_wz_cash_names())
    {
        if (cash == name) return true;
    }
    return false;
}

function water_wz_cash_live(instance)
{
    if (!isdefined(instance) || !isdefined(instance.origin)) return false;
    // Newer loot objects may not carry .type; only test the hidden state when they do.
    if (isdefined(instance.type) && instance getscriptablehaspart(instance.type) && instance getscriptablepartstate(instance.type) == "hidden") return false;
    return water_wz_cash_is_name(water_wz_cash_name(instance));
}

function water_wz_cash_value(instance)
{
    value = 0;
    if (isdefined(instance.count)) value = scripts\mp\gametypes\br_pickups::loot_getitemcount(instance);
    name = water_wz_cash_name(instance);
    if (value <= 0 && isdefined(name) && isdefined(level.br_pickups) && isdefined(level.br_pickups.counts) && isdefined(level.br_pickups.counts[name])) value = level.br_pickups.counts[name];
    return max(1, value);
}

function water_wz_cash_claimed(instance)
{
    if (!isdefined(level.water_wz_cash_claims)) return false;
    now = gettime();
    foreach (claim in level.water_wz_cash_claims)
    {
        if (!isdefined(claim) || !isdefined(claim.instance) || claim.instance != instance) continue;
        if (now >= claim.until || !isdefined(claim.bot) || !isalive(claim.bot) || claim.bot == self) continue;
        return true;
    }
    return false;
}

function water_wz_cash_claim(instance, until)
{
    now = gettime();
    kept = [];
    if (isdefined(level.water_wz_cash_claims))
    {
        foreach (claim in level.water_wz_cash_claims)
        {
            if (!isdefined(claim) || !isdefined(claim.instance) || !isdefined(claim.bot) || !isalive(claim.bot) || now >= claim.until || claim.bot == self) continue;
            kept[kept.size] = claim;
        }
    }
    claim = spawnstruct();
    claim.instance = instance;
    claim.bot = self;
    claim.until = until;
    kept[kept.size] = claim;
    level.water_wz_cash_claims = kept;
}

function water_wz_cash_unclaim()
{
    if (!isdefined(level.water_wz_cash_claims)) return;
    kept = [];
    foreach (claim in level.water_wz_cash_claims)
    {
        if (!isdefined(claim) || (isdefined(claim.bot) && claim.bot == self)) continue;
        kept[kept.size] = claim;
    }
    level.water_wz_cash_claims = kept;
}

function water_wz_cash_clear()
{
    if (isdefined(self.water_wz_cash_target)) water_wz_cash_unclaim();
    self.water_wz_cash_target = undefined;
    self.water_wz_cash_kind = undefined;
    self.water_wz_cash_point = undefined;
    self.water_wz_cash_deadline = undefined;
}

function water_wz_cash_skip(instance, duration)
{
    if (!isdefined(instance)) return;
    now = gettime();
    kept = [];
    if (isdefined(self.water_wz_cash_skips))
    {
        foreach (entry in self.water_wz_cash_skips)
        {
            if (!isdefined(entry) || !isdefined(entry.instance) || now >= entry.until || entry.instance == instance) continue;
            if (kept.size >= 15) break;
            kept[kept.size] = entry;
        }
    }
    entry = spawnstruct();
    entry.instance = instance;
    entry.until = now + duration;
    kept[kept.size] = entry;
    self.water_wz_cash_skips = kept;
}

function water_wz_cash_skipped(instance)
{
    if (!isdefined(self.water_wz_cash_skips)) return false;
    now = gettime();
    foreach (entry in self.water_wz_cash_skips)
    {
        if (isdefined(entry) && isdefined(entry.instance) && entry.instance == instance && now < entry.until) return true;
    }
    return false;
}

function water_wz_cash_point(instance)
{
    if (!isnavmeshloaded()) return undefined;
    reachable = self getclosestreachablepointonnavmesh(instance.origin);
    if (!isdefined(reachable)) reachable = getclosestpointonnavmesh(instance.origin, self);
    if (!isdefined(reachable)) return undefined;
    // Piles on roofs/ledges with no walkable floor beside them are skipped.
    if (distance2dsquared(reachable, instance.origin) > 9216 || abs(reachable[2] - instance.origin[2]) > 80) return undefined;
    if (!water_wz_safe(reachable) || water_wz_water_point(reachable)) return undefined;
    return reachable;
}

function water_wz_cash_in_reach(instance)
{
    return distance2dsquared(self.origin, instance.origin) <= 12544 && abs(instance.origin[2] - self.origin[2]) <= 96;
}

function water_wz_cash_scan_slot(now)
{
    // Caps engine loot queries per server frame across all bots.
    if (!isdefined(level.water_wz_cash_scan_frame) || level.water_wz_cash_scan_frame != now)
    {
        level.water_wz_cash_scan_frame = now;
        level.water_wz_cash_scan_count = 0;
    }
    if (level.water_wz_cash_scan_count >= 1) return false;
    level.water_wz_cash_scan_count++;
    return true;
}

// anchor/anchor_radius: only targets near the squad leader. toward: hunters only take
// targets that don't pull them away from their target.
function water_wz_cash_scan(radius, anchor, anchor_radius, toward)
{
    level.water_wz_cash_scans++;
    chosen = undefined;
    best = -1;
    toward_dist = 0;
    if (isdefined(toward)) toward_dist = distance2d(self.origin, toward);
    foreach (entry in water_wz_loot_candidates(self.origin, radius))
    {
        instance = entry.instance;
        if (abs(instance.origin[2] - self.origin[2]) > 480) continue;
        if (isdefined(anchor) && distance2dsquared(instance.origin, anchor) > anchor_radius * anchor_radius) continue;
        if (isdefined(toward) && distance2d(instance.origin, toward) > toward_dist + 150) continue;
        if (!water_wz_safe(instance.origin) || water_wz_cash_skipped(instance) || water_wz_cash_claimed(instance)) continue;
        // Value per distance: a big stack a bit further away beats a small pile next door.
        score = water_wz_loot_worth(instance, entry.kind) / (distance(self.origin, instance.origin) + 400);
        if (score > best)
        {
            chosen = entry;
            best = score;
        }
    }
    return chosen;
}

function water_wz_cash_pickup(instance)
{
    if (!water_wz_cash_live(instance)) return false;
    expected = water_wz_cash_value(instance);
    before = 0;
    if (isdefined(self.plundercount)) before = self.plundercount;
    scripts\mp\gametypes\br_pickups::lootused(instance, instance.type, "visible", self, 0);
    after = before;
    if (isdefined(self.plundercount)) after = self.plundercount;
    if (after > before)
    {
        level.water_wz_cash_pickups++;
        level.water_wz_cash_value += after - before;
        water_wz_log("[NoiceWZ] cash_pickup bot=" + self getentitynumber() + " value=" + (after - before) + " carried=" + after + "\n", false);
        return true;
    }
    level.water_wz_cash_failures++;
    water_wz_cash_note("pickup_fail");
    water_wz_log("[NoiceWZ] cash_pickup_failed bot=" + self getentitynumber() + " expected=" + expected + " carried=" + after + " name=" + water_wz_cash_text(water_wz_cash_name(instance)) + "\n", false);
    return false;
}

function water_wz_cash_tick(target, hunting, leader)
{
    if (!isbot(self) || !water_wz_collect_active())
    {
        if (isdefined(self.water_wz_cash_target)) water_wz_cash_clear();
        water_wz_cash_note("inactive");
        return false;
    }
    water_wz_cash_note("ticks");
    if (!water_wz_in_map(self) || self islinked() || water_wz_healing() || water_wz_action_busy() || self.water_wz_using_streak || isdefined(self.water_wz_trade) || isdefined(self.water_wz_loadout_started_serial)) return false;
    // Never loot with an enemy in sight; combat and tactics own the bot then.
    if (water_wz_enemy(target) && water_wz_visible(target))
    {
        water_wz_cash_clear();
        return false;
    }
    now = gettime();
    if (!isdefined(self.water_wz_next_cash_scan)) self.water_wz_next_cash_scan = 0;
    radius = min(12000, max(256, getdvarfloat(@"noice_wz_cash_radius", 3500)));
    toward = undefined;
    if (hunting)
    {
        // Hunters only grab cash right on their way, and not back-to-back.
        if (isdefined(self.water_wz_hunt_cash_after) && now < self.water_wz_hunt_cash_after) return false;
        radius = min(radius, 450);
        if (water_wz_enemy(target)) toward = target.origin;
    }
    anchor = undefined;
    anchor_radius = 0;
    if (isdefined(leader))
    {
        // Squad bots loot around the player they follow, not across the map.
        anchor = water_wz_follow_anchor(leader);
        anchor_radius = water_wz_follow_leash();
        if (isdefined(anchor)) radius = min(radius, anchor_radius * 2);
    }

    instance = self.water_wz_cash_target;
    if (isdefined(instance))
    {
        live = water_wz_loot_kind(instance) == self.water_wz_cash_kind;
        stale = !live || now >= self.water_wz_cash_deadline || water_wz_cash_claimed(instance) || !water_wz_safe(instance.origin) || distancesquared(self.origin, instance.origin) > (radius + 256) * (radius + 256);
        if (!stale && isdefined(anchor) && distance2dsquared(instance.origin, anchor) > (anchor_radius + 200) * (anchor_radius + 200)) stale = true;
        if (stale)
        {
            if (live)
            {
                water_wz_cash_skip(instance, 15000);
                water_wz_cash_note("timeout");
            }
            water_wz_cash_clear();
            instance = undefined;
        }
    }
    if (!isdefined(instance))
    {
        if (now < self.water_wz_next_cash_scan || !water_wz_cash_scan_slot(now)) return false;
        self.water_wz_next_cash_scan = now + randomintrange(3000, 4500);
        entry = water_wz_cash_scan(radius, anchor, anchor_radius, toward);
        if (!isdefined(entry))
        {
            water_wz_cash_note("scan_empty");
            return false;
        }
        instance = entry.instance;
        point = water_wz_cash_point(instance);
        if (!isdefined(point))
        {
            water_wz_cash_skip(instance, 20000);
            water_wz_cash_note("no_point");
            self.water_wz_next_cash_scan = now + 400;
            return false;
        }
        travel = int(distance(self.origin, point) / 200 * 1000);
        self.water_wz_cash_target = instance;
        self.water_wz_cash_kind = entry.kind;
        self.water_wz_cash_point = point;
        self.water_wz_cash_deadline = now + int(min(25000, 3000 + travel));
        water_wz_cash_claim(instance, self.water_wz_cash_deadline);
        level.water_wz_cash_targets++;
    }

    if (water_wz_cash_in_reach(instance))
    {
        if (!water_wz_loot_take(instance, self.water_wz_cash_kind)) water_wz_cash_skip(instance, 20000);
        water_wz_cash_clear();
        // Chain straight into the next pile of a cluster.
        self.water_wz_next_cash_scan = now + 200;
        if (hunting) self.water_wz_hunt_cash_after = now + randomintrange(6000, 9000);
        return true;
    }
    if (!water_wz_goal(self.water_wz_cash_point, 16))
    {
        water_wz_cash_skip(instance, 20000);
        level.water_wz_cash_failures++;
        water_wz_cash_note("goal_" + self.water_wz_goal_status);
        water_wz_cash_note("goal_fail");
        water_wz_cash_clear();
        return false;
    }
    if (distancesquared(self.origin, instance.origin) > 160000) self botpressbutton("sprint", 0.6);
    return true;
}

// Turns a value into log text safely (loot names can be hashes, not strings).
function water_wz_cash_text(value)
{
    if (!isdefined(value)) return "unset";
    if (isstring(value) || isint(value) || isfloat(value)) return "" + value;
    return "?";
}

function water_wz_cash_bot_states()
{
    states = spawnstruct();
    states.bots = 0;
    states.ground = 0;
    states.driven = 0;
    states.other = 0;
    states.waiting = 0;
    states.infil = 0;
    states.holders = 0;
    states.carried = 0;
    states.collecting = 0;
    if (!isdefined(level.players)) return states;
    foreach (bot in level.players)
    {
        if (!isdefined(bot) || !isbot(bot)) continue;
        states.bots++;
        if (water_wz_in_map(bot)) states.ground++;
        if (isalive(bot) && isdefined(bot.br_infil_type)) states.infil++;
        controller = bot.water_wz_nav_controller;
        if (isdefined(controller) && isstring(controller))
        {
            if (issubstr(controller, "_paused") || controller == "missing") states.driven++;
            else if (controller == "other") states.other++;
            else states.waiting++;
        }
        if (isdefined(bot.plundercount) && bot.plundercount > 0)
        {
            states.holders++;
            states.carried += bot.plundercount;
        }
        if (isdefined(bot.water_wz_cash_target)) states.collecting++;
    }
    return states;
}

function water_wz_cash_diagnostics()
{
    states = water_wz_cash_bot_states();
    water_wz_log("[NoiceWZ] cash_summary active=" + water_wz_cash_mode_active() + " plunder=" + water_wz_plunder_mode() + " economy=" + water_wz_cash_economy() + " sub=" + water_wz_cash_text(level.water_wz_plunder_sub) + " query=" + water_wz_cash_text(level.water_wz_cash_query) + " bots=" + states.bots + " ground=" + states.ground + " driven=" + states.driven + " other=" + states.other + " waiting=" + states.waiting + " infil=" + states.infil + " collecting=" + states.collecting + " holders=" + states.holders + " carried=" + states.carried + " ticks=" + water_wz_cash_count("ticks") + " inactive=" + water_wz_cash_count("inactive") + " scans=" + level.water_wz_cash_scans + " empty=" + water_wz_cash_count("scan_empty") + " no_point=" + water_wz_cash_count("no_point") + " goal_fail=" + water_wz_cash_count("goal_fail") + " timeout=" + water_wz_cash_count("timeout") + " pickups=" + level.water_wz_cash_pickups + " value=" + level.water_wz_cash_value + " pickup_fail=" + water_wz_cash_count("pickup_fail") + " purchases=" + level.water_wz_purchased + "\n", true);
}

function water_wz_station()
{
    if (!isdefined(self.plundercount) || self.plundercount <= 0) return undefined;
    if (!isdefined(level.br_armory_kiosk_enabled) || !level.br_armory_kiosk_enabled) return undefined;
    if (!isdefined(level.br_armory_kiosk) || !isdefined(level.br_armory_kiosk.items)) return undefined;
    stations = scripts\mp\gametypes\br_armory_kiosk::getallspawninstances();
    if (!isdefined(stations)) return undefined;
    chosen = undefined;
    best = 144000000;
    foreach (station in stations)
    {
        if (!isdefined(station) || !isdefined(station.origin)) continue;
        if (isdefined(station.disabled) && station.disabled) continue;
        if (isdefined(station.disablederrormsg) && station.disablederrormsg) continue;
        if (!water_wz_safe(station.origin)) continue;
        d = distancesquared(self.origin, station.origin);
        if (d >= best) continue;
        if (!scripts\mp\gametypes\br_armory_kiosk::canusekiosk(station, self)) continue;
        if (!isdefined(water_wz_buy_choice(station))) continue;
        chosen = station;
        best = d;
    }
    return chosen;
}

function water_wz_plate_item(ref)
{
    switch (ref)
    {
        case #"hash_43f2312fe01322cf": return true;
        case #"hash_25789111b74943b4": return true;
        case #"hash_2dcde97962801ba9": return true;
        default: return false;
    }
}

// Buy-station refs are hashed in the shipped scripts; these cases mirror the
// _handlespecialpurchase switch in br_armory_kiosk.gsc.
function water_wz_kiosk_kind(ref)
{
    switch (ref)
    {
        case #"hash_43f2312fe01322cf":
        case #"hash_25789111b74943b4":
        case #"hash_2dcde97962801ba9": return "plate";
        case #"hash_e67a71b27007444": return "munitions";
        case #"hash_1c3e21ffbc842487":
        case #"hash_4f292feb06ad9942": return "self_revive";
        case #"hash_4808e1f340e11163":
        case #"hash_dcf82d1f65a6b16e": return "gasmask";
        default: return "";
    }
}

// Plunder with deposits on: cash wins the match, so bots only buy what they lack.
function water_wz_buy_need(item)
{
    kind = water_wz_kiosk_kind(item.ref);
    plates = self armor::function_20b8437058079297();
    if (kind == "plate" && plates <= 0) return 4;
    if (kind == "self_revive" && getdvarint(@"noice_wz_self_revive", 0) && !self scripts\mp\gametypes\br_public::hasselfrevivetoken()) return 3.5;
    if (kind == "plate" && plates < max(1, self armor::function_47320a25b8ee003()) * 0.5) return 2;
    if (kind == "munitions" && (water_wz_weapon_ammo_low(self.water_wz_owned_primary) || water_wz_weapon_ammo_low(self.water_wz_owned_secondary))) return 1.5;
    return -1;
}

function water_wz_buy_priority(item, cash_mode)
{
    if (cash_mode && water_wz_bank_active()) return water_wz_buy_need(item);
    kind = water_wz_kiosk_kind(item.ref);
    plates = self armor::function_20b8437058079297();
    if (kind == "plate" && plates <= 0) return 4;
    if (kind == "self_revive" && getdvarint(@"noice_wz_self_revive", 0) && !self scripts\mp\gametypes\br_public::hasselfrevivetoken()) return 3.5;
    if (item.ref == "loadout_default" && !self.water_wz_bought_loadout) return 3;
    if (item.type == "killstreak" && water_wz_streak_kind(item.ref) != "" && water_wz_streak_registered(item.ref) && !self scripts\mp\gametypes\br_pickups::hasanykillstreak()) return 2 + randomfloat(0.9);
    if (!cash_mode) return -1;

    // Extra shopping list for cash modes: bots actually spend what they collect.
    if (kind == "plate" && plates < max(1, self armor::function_47320a25b8ee003()) * 0.5) return 1.6;
    if (kind == "munitions") return 1.2;
    if (kind == "gasmask" && !water_wz_plunder_mode()) return 1.0;
    return -1;
}

function water_wz_buy_choice(station)
{
    if (!isdefined(self.plundercount) || self.plundercount <= 0) return undefined;
    cash_mode = water_wz_cash_mode_active();
    reserve = 0;
    if (cash_mode) reserve = max(0, getdvarint(@"noice_wz_cash_reserve", 0));
    choice = undefined;
    best = -1;
    foreach (index, item in level.br_armory_kiosk.items)
    {
        if (!isdefined(item) || !isdefined(item.ref) || !isdefined(item.type) || !isdefined(item.cost)) continue;
        priority = water_wz_buy_priority(item, cash_mode);
        if (priority <= best || (isdefined(item.filtered) && item.filtered)) continue;
        // Keep the configured reserve, except for the empty-plates emergency buy.
        if (reserve > 0 && priority < 4 && self.plundercount - item.cost < reserve) continue;
        if (!water_wz_validate_buy(station, item)) continue;
        choice = spawnstruct();
        choice.index = index;
        choice.ref = item.ref;
        choice.loadout = item.ref == "loadout_default";
        best = priority;
    }
    return choice;
}

function water_wz_validate_buy(station, item)
{
    old_kiosk = self.br_kiosk;
    self.br_kiosk = station;
    result = self scripts\mp\gametypes\br_armory_kiosk::_validateitempurchase(station, item, 1, 0, 1);
    self.br_kiosk = old_kiosk;
    return result == 1;
}

function water_wz_purchase(station, choice)
{
    self endon("disconnect");
    self endon("death");
    self endon("water_wz_life_reset");
    level endon("game_ended");
    if (isdefined(self.water_wz_trade) || !water_wz_in_map(self)) return;
    if (distancesquared(self.origin, station.origin) > 14400) return;
    if (!scripts\mp\gametypes\br_armory_kiosk::canusekiosk(station, self)) return;
    self.water_wz_next_buy = gettime() + 10000;
    item = level.br_armory_kiosk.items[choice.index];
    if (!isdefined(item) || !water_wz_validate_buy(station, item)) return;
    self.water_wz_trade = station;
    self.water_wz_old_kiosk = self.br_kiosk;
    self.water_wz_old_permission = self.armorykioskpurchaseallowed;
    self.br_kiosk = station;
    self.armorykioskpurchaseallowed = 1;
    if (!isdefined(station.playersusing)) station.playersusing = [];
    before = self.plundercount;
    if (choice.loadout)
        self scripts\mp\gametypes\br_armory_kiosk::onarmorykioskpurchase("class_select", 100 + randomint(5));
    else self scripts\mp\gametypes\br_armory_kiosk::onarmorykioskpurchase("br_item_purchase", choice.index);

    deadline = gettime() + 5000;
    while (gettime() < deadline && self.plundercount == before) wait 0.1;
    success = self.plundercount < before;
    if (success)
    {
        level.water_wz_purchased++;
        if (choice.loadout)
        {
            self.water_wz_bought_loadout = true;

            scripts\mp\gametypes\br_armory_kiosk::function_469cfcbc4a5185c1(station, item.entryref);
        }
    }
    water_wz_log("[NoiceWZ] buy " + choice.ref + " success=" + success + " cash=" + self.plundercount + "\n", !success);
    water_wz_clear_trade();
}

function water_wz_clear_trade()
{
    if (!isdefined(self.water_wz_trade)) return;
    self.br_kiosk = self.water_wz_old_kiosk;
    self.armorykioskpurchaseallowed = self.water_wz_old_permission;
    self.water_wz_trade = undefined;
}

function water_wz_streak_kind(name)
{
    if (name == "precision_airstrike" || name == "toma_strike") return "targeted";
    if (name == "uav" || name == "counter_uav" || name == "directional_uav") return "support";
    return "";
}

function water_wz_streak_target_ok(name, distance_sq, safe)
{
    kind = water_wz_streak_kind(name);
    if (kind == "support") return true;
    return kind == "targeted" && distance_sq >= 640000 && safe;
}

function water_wz_streak_registered(name)
{
    return isdefined(level.killstreaksetups) && isdefined(level.killstreaksetups[name]) && isdefined(level.killstreaksetups[name].triggeredfunc);
}

function water_wz_strike_on_human(roll, human_target)
{
    return human_target && roll < 50;
}

function water_wz_strike_delay()
{
    return randomintrange(30000, 180001);
}

function water_wz_random_strike_clear(point)
{
    if (!isdefined(point) || !water_wz_safe(point)) return false;
    if (distancesquared(self.origin, point) < 640000) return false;

    foreach (player in level.players)
    {
        if (!isdefined(player) || !isplayer(player) || isbot(player) || !isdefined(player.origin)) continue;
        if (distance2dsquared(point, player.origin) < 25000000) return false;
    }
    return true;
}

function water_wz_random_strike_position()
{
    if (!water_wz_circle_ready()) return undefined;
    for (attempt = 0; attempt < 8; attempt++)
    {
        point = scripts\mp\gametypes\br_circle::getrandompointincurrentcircle(0, 0.9);
        if (water_wz_random_strike_clear(point)) return point;
    }

    return undefined;
}

function water_wz_supply_name(roll)
{
    if (roll < 20) return "precision_airstrike";
    if (roll < 40) return "toma_strike";
    if (roll < 60) return "uav";
    if (roll < 80) return "counter_uav";
    return "directional_uav";
}

function water_wz_select_supply(previous)
{
    candidates = [];
    for (index = 0; index < 5; index++)
    {
        name = water_wz_supply_name(index * 20);
        if (water_wz_streak_registered(name) && (!isdefined(previous) || name != previous)) candidates[candidates.size] = name;
    }
    if (candidates.size > 0) return candidates[randomint(candidates.size)];

    if (isdefined(previous) && water_wz_streak_registered(previous)) return previous;
    return undefined;
}

function water_wz_streak_tick(target, hunting)
{
    if (water_wz_action_busy() || self isreloading()) return;
    if (self.water_wz_using_streak || self.water_wz_plate_active || (isdefined(self.insertingarmorplate) && self.insertingarmorplate)) return;
    if (isdefined(self.water_wz_trade) || isdefined(self.water_wz_loadout_started_serial) || self.water_wz_tactic == "retreat" || self.water_wz_tactic == "plate") return;
    if (!water_wz_enemy(target) || water_wz_downed_human(target)) return;

    if (!isbot(target) && (!hunting || !water_wz_has_hunt(target))) return;
    if (isbot(target) && !water_wz_visible(target)) return;
    now = gettime();
    if (hunting && getdvarint(@"noice_wz_streak_supply", 1) && now >= self.water_wz_next_supply && !self scripts\mp\gametypes\br_pickups::hasanykillstreak())
    {

        name = water_wz_select_supply(level.water_wz_last_supply);
        self.water_wz_next_supply = now + randomintrange(60000, 100000);
        if (isdefined(name))
        {
            self scripts\mp\killstreaks\killstreaks::awardkillstreak(name, "other", undefined, undefined, undefined, 1, undefined);
            level.water_wz_last_supply = name;
            water_wz_log("[NoiceWZ] supplied=" + name + " bot=" + self getentitynumber() + "\n", false);
        }
    }
    water_wz_use_owned_streak(target);
}

function water_wz_use_owned_streak(target)
{
    if (water_wz_healing() || isdefined(self.water_wz_loadout_started_serial)) return;
    if (self.water_wz_using_streak || !self scripts\mp\gametypes\br_pickups::hasanykillstreak()) return;
    if (isdefined(self.water_wz_next_streak) && gettime() < self.water_wz_next_streak) return;
    streak = self.streakdata.streaks[1];
    name = streak.streakname;
    if (water_wz_streak_kind(name) == "targeted" && gettime() < level.water_wz_next_airstrike) return;
    if (water_wz_streak_kind(name) == "" || !water_wz_streak_registered(name)) return;
    if (!self scripts\mp\gametypes\br_pickups::iskillstreakavailable(name)) return;
    position = undefined;
    distance_sq = 0;
    safe = false;
    if (water_wz_streak_kind(name) == "targeted")
    {

        if (!isdefined(streak.water_wz_strike_roll)) streak.water_wz_strike_roll = randomint(100);
        streak.water_wz_strike_human = water_wz_strike_on_human(streak.water_wz_strike_roll, water_wz_enemy(target) && !isbot(target));
        if (streak.water_wz_strike_human) position = target.origin;
        else position = water_wz_random_strike_position();
        if (!isdefined(position))
        {
            self.water_wz_next_streak = gettime() + 5000;
            return;
        }
        distance_sq = distancesquared(self.origin, position);
        safe = water_wz_safe(position);
    }
    if (!water_wz_streak_target_ok(name, distance_sq, safe)) return;
    self.water_wz_next_streak = gettime() + 7500;
    self thread [[ &water_wz_deploy_streak ]](streak, position);
}

function water_wz_deploy_streak(streak, position)
{
    self endon("disconnect");
    self endon("death");
    self endon("water_wz_life_reset");
    level endon("game_ended");
    if (water_wz_healing() || isdefined(self.water_wz_loadout_started_serial) || self.water_wz_using_streak || !self scripts\mp\gametypes\br_pickups::iskillstreakavailable(streak.streakname)) return;
    if (isbot(self) && water_wz_streak_kind(streak.streakname) == "support")
    {
        if (water_wz_private_recon(streak)) level.water_wz_streaks++;
        return;
    }
    if (water_wz_streak_kind(streak.streakname) == "targeted")
    {
        if (!isdefined(position) || !water_wz_safe(position)) return;
        if (!streak.water_wz_strike_human && !water_wz_random_strike_clear(position)) return;
        if (gettime() < level.water_wz_next_airstrike) return;
        level.water_wz_next_airstrike = gettime() + water_wz_strike_delay();
        strike_kind = "random-map";
        if (streak.water_wz_strike_human) strike_kind = "human";
        water_wz_log("[NoiceWZ] strike_target=" + strike_kind + " roll=" + streak.water_wz_strike_roll + " next_gap_ms=" + (level.water_wz_next_airstrike - gettime()) + "\n", false);
    }
    self.water_wz_using_streak = true;
    name = streak.streakname;
    if (water_wz_streak_kind(name) == "targeted") self.kstargetlocation = position;

    result = self scripts\mp\killstreaks\killstreaks::triggerkillstreak(streak, 1);
    self.kstargetlocation = undefined;
    self.water_wz_using_streak = false;
    if (result) level.water_wz_streaks++;
    water_wz_log("[NoiceWZ] streak=" + name + " deployed=" + result + "\n", !result);
}

function water_wz_private_recon(streak)
{
    if (!isbot(self) || !isdefined(streak)) return false;
    name = streak.streakname;
    if (name != "uav" && name != "directional_uav" && name != "counter_uav") return false;
    if (!isdefined(self.streakdata) || !isdefined(self.streakdata.streaks) || !isdefined(self.streakdata.streaks[1]) || self.streakdata.streaks[1] != streak) return false;

    self scripts\mp\killstreaks\killstreaks::removekillstreak(1);
    water_wz_log("[NoiceWZ] private_recon=" + name + " bot=" + self getentitynumber() + "\n", false);
    return true;
}

function water_wz_clear_shot(target)
{
    self.water_wz_aim_point = undefined;
    if (!water_wz_enemy(target)) return false;
    point = target gettagorigin("j_head");
    if (isdefined(point) && sighttracepassed(self geteye(), point, 0, self, target))
    {
        self.water_wz_aim_point = point;
        return true;
    }

    point = target gettagorigin("j_spinelower");
    if (!isdefined(point) || !sighttracepassed(self geteye(), point, 0, self, target)) return false;
    self.water_wz_aim_point = point;
    return true;
}

function water_wz_nearby_initial_drop()
{
    if (gamelogic::inprematch()) return undefined;
    if ((isdefined(self.water_wz_initial_drop_closed) && self.water_wz_initial_drop_closed) || !isdefined(self.water_wz_first_drop_serial) || self.water_wz_first_drop_serial != self.water_wz_spawn_serial) return undefined;
    if (isdefined(self.water_wz_nearby_initial_used) && self.water_wz_nearby_initial_used) return undefined;
    if (!isdefined(level.water_wz_drop_limit))
    {
        level.water_wz_drop_limit = noice_wz_pacing_drop_limit(randomintrange(2, 6)); // PACING HOOK 4
        level.water_wz_drop_points = [];
    }
    if (level.water_wz_drop_points.size >= level.water_wz_drop_limit) { self.water_wz_nearby_initial_used = true; return undefined; }
    if (!isdefined(level.water_wz_drop_anchor))
    {
        if (isdefined(level.water_wz_next_drop_anchor) && gettime() < level.water_wz_next_drop_anchor) return undefined;
        level.water_wz_next_drop_anchor = gettime() + 250;
        foreach (player in level.players)
        {
            if (!isdefined(player) || isbot(player) || !isalive(player) || !isdefined(player.team) || player.team == self.team || player.team == "spectator") continue;
            if (!player isskydiving() && !player isparachuting() && !water_wz_in_map(player)) continue;
            anchor = player.desired_landing_spot;
            if (!isdefined(anchor)) anchor = player scripts\mp\gametypes\br::groundraycast(player.origin);
            if (!isdefined(anchor) || anchor == (0, 0, 0) || !water_wz_safe(anchor)) continue;
            level.water_wz_drop_anchor = anchor;
            level.water_wz_drop_anchor_time = gettime();
            break;
        }
    }
    if (!isdefined(level.water_wz_drop_anchor)) return undefined;
    if (isdefined(level.water_wz_drop_anchor_time) && gettime() - level.water_wz_drop_anchor_time > 45000) return undefined;
    for (attempt = 0; attempt < 4; attempt++)
    {
        hint = level.water_wz_drop_anchor + anglestoforward((0, randomint(360), 0)) * randomfloatrange(800, 2400);
        point = getclosestpointonnavmesh(hint, self);
        if (!isdefined(point) || !water_wz_safe(point) || water_wz_water_point(point)) continue;
        range = distance2dsquared(point, level.water_wz_drop_anchor);
        if (range < 640000 || range > 5760000) continue;
        clear = true;
        foreach (other in level.water_wz_drop_points)
        {
            if (distance2dsquared(point, other) < 16384) { clear = false; break; }
        }
        if (!clear) continue;
        level.water_wz_drop_points[level.water_wz_drop_points.size] = point;
        self.water_wz_nearby_initial_used = true;
        return point;
    }
    return undefined;
}

function water_wz_three_way_hunter(player)
{
    if (!isdefined(player)) return false;
    if (!isdefined(level.water_wz_hunt_slots)) return false;
    foreach (slot in level.water_wz_hunt_slots)
    {
        if (water_wz_same_entity(slot.bot, player)) return true;
    }
    return false;
}

function water_wz_three_way_solo(first, second, human)
{
    if (!isdefined(level.players)) return false;
    first_count = 0;
    second_count = 0;
    human_count = 0;
    foreach (player in level.players)
    {
        if (!isdefined(player) || !isdefined(player.team)) continue;
        if (player.team == first.team) first_count++;
        if (player.team == second.team) second_count++;
        if (player.team == human.team) human_count++;
    }
    return first_count == 1 && second_count == 1 && human_count == 1;
}

function water_wz_three_way_sees(player, target)
{
    if (!isdefined(player) || !isdefined(target) || !water_wz_in_map(player) || !water_wz_deployed(target, true)) return false;
    if (player.team == target.team || !player botcanseeentity(target)) return false;
    point = target gettagorigin("j_head");
    return isdefined(point) && sighttracepassed(player geteye(), point, 0, player, target);
}

function water_wz_three_way_valid(pair, now)
{
    if (!isdefined(pair) || !pair.active || now >= pair.expires) return false;
    if (!water_wz_in_map(pair.first) || !water_wz_in_map(pair.second) || !water_wz_deployed(pair.human, true)) return false;
    if (!isdefined(pair.first_serial) || !isdefined(pair.second_serial) || !isdefined(pair.first.water_wz_spawn_serial) || !isdefined(pair.second.water_wz_spawn_serial)) return false;
    if (pair.first.water_wz_spawn_serial != pair.first_serial || pair.second.water_wz_spawn_serial != pair.second_serial) return false;
    if (pair.first.team != pair.first_team || pair.second.team != pair.second_team || pair.human.team != pair.human_team) return false;
    if (water_wz_three_way_hunter(pair.first) || water_wz_three_way_hunter(pair.second)) return false;
    if (now >= pair.next_check)
    {

        contact = water_wz_three_way_sees(pair.diverter, pair.human) && water_wz_three_way_sees(pair.duelist, pair.diverter);
        if (contact) pair.lost_since = undefined;
        else
        {
            if (!isdefined(pair.lost_since)) pair.lost_since = now;
            if (now - pair.lost_since >= 500) return false;
        }
        pair.next_check = now + 250;
        pair.expires = now + 3000;
    }
    return true;
}

function water_wz_three_way_target(original, human, opponent)
{
    now = gettime();
    pair = self.water_wz_three_way;
    if (isdefined(pair) && isdefined(water_wz_urgent_target()))
    {
        pair.active = false;
        self.water_wz_three_way = undefined;
        return original;
    }
    if (isdefined(pair))
    {
        if (water_wz_three_way_valid(pair, now))
        {
            if (pair.diverter == self) return pair.human;
            return pair.diverter;
        }
        pair.active = false;
        self.water_wz_three_way = undefined;
        return original;
    }
    if (water_wz_three_way_hunter(self) || !isdefined(human) || isbot(human)) return original;

    if (!isdefined(opponent) || !isbot(opponent) || opponent == self || !water_wz_same_entity(opponent.water_wz_fight_target, self)) return original;
    if (water_wz_three_way_hunter(opponent) || !water_wz_three_way_solo(self, opponent, human)) return original;
    if (isdefined(opponent.water_wz_three_way) && opponent.water_wz_three_way.active && now < opponent.water_wz_three_way.expires) return original;
    if (!water_wz_three_way_sees(self, human) || !water_wz_three_way_sees(self, opponent) || !water_wz_three_way_sees(opponent, self)) return original;
    diverter = self;
    if (water_wz_three_way_sees(opponent, human) && opponent getentitynumber() < self getentitynumber()) diverter = opponent;
    pair = spawnstruct();
    pair.active = true;
    pair.first = self;
    pair.second = opponent;
    pair.human = human;
    pair.first_serial = self.water_wz_spawn_serial;
    pair.second_serial = opponent.water_wz_spawn_serial;
    pair.first_team = self.team;
    pair.second_team = opponent.team;
    pair.human_team = human.team;
    pair.diverter = diverter;
    pair.duelist = opponent;
    if (diverter == opponent) pair.duelist = self;
    pair.next_check = now + 250;
    pair.expires = now + 3000;
    self.water_wz_three_way = pair;
    opponent.water_wz_three_way = pair;
    if (diverter == self) return human;
    return diverter;
}

function noice_flyover_boot()
{
    level endon("game_ended");
    while (!isdefined(level.gametype)) wait 0.1;
    if (level.gametype != "br" && getsubstr(level.gametype, 0, 3) != "br_") return;
    if (isdefined(level.noice_flyover_guard_started)) return;
    level.noice_flyover_guard_started = 1;
    while (!noice_flyover_install()) wait 0.1;
}

function noice_flyover_install()
{
    if (isdefined(level.noice_flyover_original)) return 1;
    if (!scripts\engine\utility::issharedfuncdefined("br_flyover", "getFlyoverScriptbundleName", 0)) return 0;
    level.noice_flyover_original = scripts\engine\utility::getsharedfunc("br_flyover", "getFlyoverScriptbundleName");
    scripts\engine\utility::registersharedfunc("br_flyover", "getFlyoverScriptbundleName", &noice_flyover_safe_preset, 0);
    return 1;
}

function noice_flyover_safe_preset()
{
    if (!isdefined(level.noice_flyover_original)) return undefined;
    preset = [[ level.noice_flyover_original ]]();
    if (!isdefined(preset)) return undefined;
    if (!isdefined(getscriptbundle(hashcat(%"hash_4951d6ef559952e1", preset)))) return undefined;
    return preset;
}


// ---------------------------------------------------------------------------
// PACING (Battle Royale only)
//
// Makes a BR match build up like a real one: quiet while the circle is large,
// busier mid-game, chaotic late. Everything for this feature is in this block
// plus six lines tagged "PACING HOOK 1..5" elsewhere (hook 1 is two lines). To
// remove it, delete this block and those lines (or set noice_wz_pacing 0 to switch it off).
// Not used in Plunder or Resurgence.
//
// Phase comes from the circle index: 0 early, 1 mid, 2 late (-1 = not active).
// ---------------------------------------------------------------------------

function noice_wz_pacing_enabled()
{
    if (!getdvarint(@"noice_wz_enabled", 1) || !getdvarint(@"noice_wz_pacing", 1)) return false;
    if (isdefined(level.noice_wz_pacing_br)) return level.noice_wz_pacing_br;
    if (gamelogic::inprematch() || !isdefined(level.gametypebundle) || !isdefined(level.br_level)) return false;
    br = !water_wz_plunder_mode();
    sub = level.gametypebundle.brsubgametype;
    if (isdefined(sub) && isstring(sub) && issubstr(sub, "resurg")) br = false;
    level.noice_wz_pacing_br = br;
    water_wz_log("[NoiceWZ] pacing br=" + br + "\n", false);
    return br;
}

function noice_wz_pacing_phase()
{
    if (!noice_wz_pacing_enabled()) return -1;
    now = gettime();
    if (isdefined(level.noice_wz_pacing_time) && now < level.noice_wz_pacing_time) return level.noice_wz_pacing_cache;
    level.noice_wz_pacing_time = now + 1000;
    phase = 0;
    if (water_wz_circle_ready() && level.br_circle.circleindex >= 0)
    {
        total = level.br_level.br_circleradii.size;
        frac = level.br_circle.circleindex / max(1, total - 1);
        if (frac >= 0.65) phase = 2;
        else if (frac >= 0.3) phase = 1;
    }
    if (!isdefined(level.noice_wz_pacing_cache) || level.noice_wz_pacing_cache != phase)
    {
        // Re-roll how many bots may hunt a human as soon as the phase changes.
        level.water_wz_next_hunt_limit = 0;
        water_wz_log("[NoiceWZ] pacing phase=" + phase + "\n", false);
    }
    level.noice_wz_pacing_cache = phase;
    return phase;
}

// How many bots may hunt a human at once: almost none early, more as the circle closes.
function noice_wz_pacing_hunt_budget(phase, roll)
{
    if (phase == 0)
    {
        if (roll < 15) return 1;
        return 0;
    }
    if (phase == 1)
    {
        if (roll < 60) return 1;
        return 2;
    }
    if (roll < 50) return 2;
    return 3;
}

// Human gunfire is only heard nearby early on; anywhere once the circle is small.
function noice_wz_pacing_human_audible(distance_sq)
{
    phase = noice_wz_pacing_phase();
    if (phase == 0) return distance_sq <= 9000000;
    if (phase == 1) return distance_sq <= 49000000;
    return true;
}

// Bots hear each other's shots over a shorter range early and a longer one late.
function noice_wz_pacing_hearing_scale()
{
    phase = noice_wz_pacing_phase();
    if (phase == 0) return 0.6;
    if (phase == 2) return 1.3;
    return 1;
}

// Bots deliberately landing next to a human: fewer of them in BR (0-2 instead of 2-5).
function noice_wz_pacing_drop_limit(default_limit)
{
    if (!noice_wz_pacing_enabled()) return default_limit;
    return randomintrange(0, 3);
}

// ---------------------------------------------------------------------------
// Map pings and player map marks
//
// Bots use the game's native callout-marker system: a bot that can see (or has
// just seen) an enemy drops a live enemy ping that decays to danger. (Loot pings
// were removed: they passed a loot index where the engine expects an entity id.)
// Human players are polled for their own location/go tacmap ping; when
// one appears, same-team bots path to it until they arrive or it is removed.
// ---------------------------------------------------------------------------

function noice_wz_ping_enabled()
{
    return getdvarint(@"noice_wz_enabled", 1) && getdvarint(@"noice_wz_bot_pings", 1);
}

function noice_wz_mark_claim(key, duration)
{
    now = gettime();
    if (!isdefined(level.noice_wz_mark_times)) level.noice_wz_mark_times = [];
    if (isdefined(level.noice_wz_mark_times[key]) && now < level.noice_wz_mark_times[key]) return false;
    level.noice_wz_mark_times[key] = now + duration;
    return true;
}

function noice_wz_mark_cooldown(key, duration)
{
    if (!isdefined(level.noice_wz_mark_times)) level.noice_wz_mark_times = [];
    level.noice_wz_mark_times[key] = gettime() + duration;
}

function noice_wz_create_ping(type, origin, objectid, lifetime)
{
    if (!isdefined(self) || !isdefined(origin)) return undefined;
    pingindex = undefined;
    if (isdefined(objectid)) pingindex = self scripts\cp_mp\calloutmarkerping::calloutmarkerping_createcallout(type, origin, objectid);
    else pingindex = self scripts\cp_mp\calloutmarkerping::calloutmarkerping_createcallout(type, origin);
    if (!isdefined(pingindex)) return undefined;
    if (!isdefined(level.noice_wz_pings_created)) level.noice_wz_pings_created = 0;
    level.noice_wz_pings_created++;
    if (isdefined(lifetime) && lifetime > 0) self thread [[ &noice_wz_ping_expire ]](pingindex, lifetime);
    return pingindex;
}

function noice_wz_ping_expire(pingindex, lifetime)
{
    self endon("disconnect");
    self endon("predictiveCalloutClear_" + pingindex);
    level endon("game_ended");
    wait lifetime;
    if (isdefined(self)) self scripts\cp_mp\calloutmarkerping::calloutmarkerping_removecallout(pingindex);
}

function noice_wz_mark_enemy_tick()
{
    if (!noice_wz_ping_enabled() || !water_wz_in_map(self) || !isalive(self)) return;
    now = gettime();
    if (isdefined(self.noice_wz_next_enemy_ping) && now < self.noice_wz_next_enemy_ping) return;
    target = self.water_wz_target;
    if (!water_wz_enemy(target)) target = self.water_wz_encounter;
    if (!water_wz_enemy(target)) return;
    recent = isdefined(self.water_wz_contact) && water_wz_same_entity(self.water_wz_contact, target) && isdefined(self.water_wz_contact_time) && now - self.water_wz_contact_time <= 4000;
    if (!water_wz_visible(target) && !recent) return;
    key = "enemy_" + self.team + "_" + target getentitynumber();
    if (!noice_wz_mark_claim(key, 7000)) return;
    type = 9;
    pingindex = noice_wz_create_ping(type, target.origin, target getentitynumber(), 10);
    if (!isdefined(pingindex))
    {
        type = 6;
        pingindex = noice_wz_create_ping(type, target.origin + (0, 0, 82), 0, 60);
    }
    if (!isdefined(pingindex))
    {
        noice_wz_mark_cooldown(key, 2000);
        self.noice_wz_next_enemy_ping = now + 2000;
        return;
    }
    self.noice_wz_next_enemy_ping = now + randomintrange(5000, 8000);
    water_wz_log("[NoiceWZ] ping_enemy bot=" + self getentitynumber() + " target=" + target getentitynumber() + " type=" + type + " ping=" + pingindex + "\n", false);
}

function noice_wz_ping_worker()
{
    level endon("game_ended");
    for (;;)
    {
        if (noice_wz_ping_enabled() && isdefined(level.players))
        {
            foreach (player in level.players)
            {
                if (!isdefined(player) || !isbot(player)) continue;
                player noice_wz_mark_enemy_tick();
            }
        }
        wait 0.5;
    }
}

function noice_wz_is_move_ping(type)
{
    return isdefined(type) && (type == 2 || type == 17 || type == 18);
}

function noice_wz_player_mark_watch()
{
    self endon("disconnect");
    level endon("game_ended");
    self.noice_wz_mark_serial = 0;
    known = "";
    active = false;
    for (;;)
    {
        if (!getdvarint(@"noice_wz_enabled", 1) || !getdvarint(@"noice_wz_player_mark", 1) || !isalive(self) || !isdefined(self.team))
        {
            if (active)
            {
                active = false;
                self.noice_wz_mark_point = undefined;
            }
            wait 0.5;
            continue;
        }
        found = undefined;
        foundsig = "";
        for (i = 0; i < 10; i++)
        {
            if (!self calloutmarkerping_getactive(i)) continue;
            type = self calloutmarkerping_gettype(i);
            if (!noice_wz_is_move_ping(type)) continue;
            origin = self calloutmarkerping_getorigin(i);
            if (!isdefined(origin) || origin == (0, 0, 0)) continue;
            found = origin;
            foundsig = "" + i + ":" + type + ":" + int(origin[0] / 64) + ":" + int(origin[1] / 64) + ":" + int(origin[2] / 64);
            break;
        }
        if (isdefined(found))
        {
            if (!active || foundsig != known)
            {
                self.noice_wz_mark_serial++;
                if (!isdefined(level.noice_wz_player_orders)) level.noice_wz_player_orders = 0;
                level.noice_wz_player_orders++;
                water_wz_log("[NoiceWZ] player_mark human=" + self getentitynumber() + " point=" + found + " serial=" + self.noice_wz_mark_serial + "\n", true);
            }
            active = true;
            known = foundsig;
            self.noice_wz_mark_point = found;
            self.noice_wz_mark_time = gettime();
        }
        else if (active)
        {
            active = false;
            known = "";
            self.noice_wz_mark_point = undefined;
        }
        wait 0.25;
    }
}

function noice_wz_mark_source(leader)
{
    if (isdefined(leader) && isalive(leader) && isdefined(leader.noice_wz_mark_point) && isdefined(leader.noice_wz_mark_serial)) return leader;
    if (!isdefined(level.water_wz_humans) || !isdefined(self.team)) return undefined;
    chosen = undefined;
    best = 999999999999;
    foreach (human in level.water_wz_humans)
    {
        if (!isdefined(human) || isbot(human) || !isdefined(human.team) || human.team != self.team || !isalive(human) || !isdefined(human.noice_wz_mark_point)) continue;
        d = distancesquared(self.origin, human.origin);
        if (d < best)
        {
            chosen = human;
            best = d;
        }
    }
    return chosen;
}

function noice_wz_player_order_tick(leader)
{
    if (!getdvarint(@"noice_wz_enabled", 1) || !getdvarint(@"noice_wz_player_mark", 1)) return false;
    source = noice_wz_mark_source(leader);
    if (!isdefined(source)) return false;
    point = source.noice_wz_mark_point;
    serial = source.noice_wz_mark_serial;
    if (!isdefined(point) || !isdefined(serial)) return false;
    if (isdefined(self.noice_wz_order_serial) && self.noice_wz_order_serial == serial && isdefined(self.noice_wz_order_done) && self.noice_wz_order_done) return false;
    if (!isdefined(self.noice_wz_order_serial) || self.noice_wz_order_serial != serial)
    {
        self.noice_wz_order_serial = serial;
        self.noice_wz_order_done = false;
        water_wz_cash_clear();
        water_wz_search_clear();
    }
    if (distance2dsquared(self.origin, point) <= 65536)
    {
        self.noice_wz_order_done = true;
        if (self bothasscriptgoal())
        {
            self botclearscriptgoal();
            self.water_wz_next_goal = 0;
        }
        water_wz_log("[NoiceWZ] player_mark_arrived bot=" + self getentitynumber() + " human=" + source getentitynumber() + "\n", false);
        return true;
    }
    accepted = water_wz_goal(point, 96);
    if (accepted && distancesquared(self.origin, point) > 360000) self botpressbutton("sprint", 0.6);
    return accepted;
}

function noice_wz_register_option(primary_name, legacy_name, default_value, reset)
{
    option = spawnstruct();
    option.primary = primary_name;
    option.legacy = legacy_name;
    value = getdvarfloat(option.primary, getdvarfloat(option.legacy, default_value));
    if (reset) value = default_value;
    setdvar(option.primary, value);
    setdvar(option.legacy, value);
    option.value = value;
    level.noice_wz_options[level.noice_wz_options.size] = option;
}

function noice_wz_tuning_initialize()
{
    level.noice_wz_options = [];
    noice_wz_register_option(@"noice_wz_enabled", @"water_wz_enabled", 1, 0);
    noice_wz_register_option(@"noice_wz_speed", @"water_wz_speed", 1.5, 1);
    noice_wz_register_option(@"noice_wz_hearing_radius", @"water_wz_hearing_radius", 6000, 0);
    noice_wz_register_option(@"noice_wz_purchases", @"water_wz_purchases", 1, 0);
    noice_wz_register_option(@"noice_wz_streak_supply", @"water_wz_streak_supply", 1, 0);
    noice_wz_register_option(@"noice_wz_self_revive", @"water_wz_self_revive", 0, 1);
    noice_wz_register_option(@"noice_wz_damage_to_player", @"water_wz_damage_to_player", 1.66, 0);
    noice_wz_register_option(@"noice_wz_damage_to_bot", @"water_wz_damage_to_bot", 0.15, 0);
    noice_wz_register_option(@"noice_wz_cash_mode", @"water_wz_cash_mode", 1, 0);
    noice_wz_register_option(@"noice_wz_cash_radius", @"water_wz_cash_radius", 3500, 0);
    noice_wz_register_option(@"noice_wz_cash_reserve", @"water_wz_cash_reserve", 0, 0);
    noice_wz_register_option(@"noice_wz_squad_follow", @"water_wz_squad_follow", 1, 0);
    noice_wz_register_option(@"noice_wz_squad_revive", @"water_wz_squad_revive", 1, 0);
    noice_wz_register_option(@"noice_wz_squad_focus", @"water_wz_squad_focus", 1, 0);
    noice_wz_register_option(@"noice_wz_bot_pings", @"water_wz_bot_pings", 1, 0);
    noice_wz_register_option(@"noice_wz_player_mark", @"water_wz_player_mark", 1, 0);
    noice_wz_register_option(@"noice_wz_pacing", @"water_wz_pacing", 1, 0); // PACING HOOK 5
    noice_wz_register_option(@"noice_wz_plate_share", @"water_wz_plate_share", 1, 0);
    noice_wz_register_option(@"noice_wz_open_caches", @"water_wz_open_caches", 1, 0);
    noice_wz_register_option(@"noice_wz_ground_loot", @"water_wz_ground_loot", 1, 0);
    noice_wz_register_option(@"noice_wz_free_plates", @"water_wz_free_plates", 1, 0);
    noice_wz_register_option(@"noice_wz_buyback", @"water_wz_buyback", 1, 0);
    noice_wz_register_option(@"noice_wz_deposit", @"water_wz_deposit", 1, 0);
    noice_wz_register_option(@"noice_wz_deposit_at", @"water_wz_deposit_at", 5000, 0);
    noice_wz_register_option(@"noice_wz_squad_vehicles", @"water_wz_squad_vehicles", 1, 0);
    noice_wz_register_option(@"noice_wz_revive_radius", @"water_wz_revive_radius", 4000, 0);
    noice_wz_register_option(@"noice_wz_follow_leash", @"water_wz_follow_leash", 1000, 0);
    noice_wz_register_option(@"noice_wz_follow_distance", @"water_wz_follow_distance", 300, 0);
}

function noice_wz_tuning_sync()
{
    foreach (option in level.noice_wz_options)
    {
        primary = getdvarfloat(option.primary, option.value);
        legacy = getdvarfloat(option.legacy, option.value);
        if (primary == option.value && legacy == option.value) continue;
        value = legacy;
        if (primary != option.value) value = primary;
        setdvar(option.primary, value);
        setdvar(option.legacy, value);
        option.value = value;
    }
}

function noice_wz_tuning_worker()
{
    level endon("game_ended");
    for (;;)
    {
        wait 0.25;
        noice_wz_tuning_sync();
    }
}

function noice_fk_tracking_guard()
{
    if (!isdefined(level.noice_wz_map_fix) || level.noice_wz_map_fix != "fortunes_keep") return false;
    if (!isdefined(level.var_6b0dbf939b653e13) || !isdefined(level.var_6b0dbf939b653e13.var_6420b42c7add53cc)) return false;
    level.var_6b0dbf939b653e13.var_6420b42c7add53cc = 0;
    return true;
}

function noice_fk_contract_guard(bot, native_contract_score)
{
    if (!isdefined(level.noice_wz_map_fix) || level.noice_wz_map_fix != "fortunes_keep") return false;
    if (!isdefined(bot) || !isdefined(bot.mind) || !isdefined(bot.mind.var_f0a8822dcc782c9d) || !isdefined(bot.mind.var_f0a8822dcc782c9d.var_577f45571c039a54)) return false;
    changed = false;
    foreach (decision in bot.mind.var_f0a8822dcc782c9d.var_577f45571c039a54)
    {
        if (!isdefined(decision) || !isdefined(decision.evaluatescore) || decision.evaluatescore != native_contract_score) continue;
        decision.enabled = 0;
        decision.var_10f0b5c52ece08ce = 0;
        decision.score = 0;
        changed = true;
    }
    return changed;
}

function noice_fk_tracking_guard_worker()
{
    level endon("game_ended");
    if (!isdefined(level.noice_wz_map_fix) || level.noice_wz_map_fix != "fortunes_keep") return;
    native_contract_score = &namespace_326a108db3341ff9::function_e0844a2b7f904b14;
    for (;;)
    {
        noice_fk_tracking_guard();
        if (isdefined(level.players))
        {
            foreach (player in level.players)
            {
                if (isdefined(player) && isbot(player)) noice_fk_contract_guard(player, native_contract_score);
            }
        }
        wait 0.25;
    }
}
