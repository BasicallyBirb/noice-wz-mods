# Noice Warzone Mods

A collection of standalone MWIII / Warzone GSC modifications for offline and LAN play. Built with Atian COD Tools, designed to run on any MWIII client/modloader that loads compiled GSC after native scripts.

## Noice's Better Warzone Bots

A full bot overhaul for Warzone, adding competent AI teammates and opponents to private matches and LAN lobbies.

### Features

**Bot behavior & combat**
- Stick with the squad leader throughout the game, assisting in combat and survival, and only spread out when necessary. 
- Run-and-gun bot personality
- Enemy targeting and combat engagement
- Boarding vehicles as passengers
- Buyback station usage for eliminated teammates
- Armor plate management and resupply
- Cash collection (in all gamemodes) and banking (only in plunder)

**Fake Banking**
- Bots use the verified native direct Plunder bank function after a safe 2.5-second channel
- Bots bank when stocked and carrying more than their cash reserve
- Reserve is calculated as the maximum of `noice_wz_cash_reserve`, `noice_wz_deposit_at` (minimum 500), or buyback cost when eligible
- Spare cash under 500 is not banked

**Native Ping System**
- Bots mark visible enemies and recent contacts on the tacmap
- Humans can order same-team bots to move to tacmap marks
- Player-mark order logging
- Script-created pings expire automatically via configurable lifetimes:
  - Enemy pings: 10 seconds
  - Danger pings: 60 seconds

**Armor Plate Sharing**
- Bots provide spare armor plates to low-health human teammates
- Bot verifies its own armor reserve decreased before declaring success
- Bot keeps at least one plate for itself

**Portability**
- No LUMEN-specific APIs; works with any MWIII client/modloader that loads Atian-compiled GSC after native scripts with equivalent namespace and path handling

## Cash Drop Fix

A standalone fix for the broken offline Warzone Cash Drop crate interaction.

### Features

- Replaces the non-functional offline Cash Drop crate-use path
- Spawns verified Plunder cash loot piles when a Cash Drop crate is opened
- Pile values and weights match the game's own loot tables: 50 (37.5%), 80 (42%), 120 (15%), 200 (5%), and 350 (0.5%)
- Updates Plunder cash counters when piles are collected
- Falls back to direct cash credit if loot pile spawning fails
- Configurable via `cashdrop_fix` and `cashdrop_piles` dvars

## More to come

This is an active project. Additional fixes and modifications are planned and will be released as standalone scripts.
