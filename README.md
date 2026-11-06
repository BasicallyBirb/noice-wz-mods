# Noice Warzone Mods

A collection of standalone MWIII / Warzone GSC modifications for offline and LAN play. Built with Atian COD Tools, designed to run on any MWIII client/modloader that loads compiled GSC after native scripts.

## Noice's Better Warzone Bots [v31.9.10 DIAG]

A full bot overhaul for Warzone, adding competent AI teammates and opponents to private matches and LAN lobbies.

### Features

**Bot behavior & combat**
- Stick with the squad leader throughout the game, assisting in combat and survival, and only spread out when necessary.
- Run-and-gun bot personality
- Enemy targeting and combat engagement
- Boarding vehicles as passengers and actively gunning down threats.
- Buyback station usage for eliminated teammates
- Armor plate management and resupply
- Cash collection (Plunder-style modes by default; `noice_wz_cash_mode 2` enables it in any mode with an economy) and banking (only in Plunder)

**Battle Royale Pacing (BR only)**
- Matches build up like a real one: quiet while the circle is large, busier mid-game, chaotic late
- Early circles: bots rarely hunt you, and only hear your gunfire from nearby (about 3,000 units)
- Mid circles: one or two bots may hunt you, and your gunfire carries about 7,000 units
- Late circles: two or three hunters, your gunfire is heard from anywhere, and bots hear each other 30% farther
- Fewer bots (0-2 instead of 2-5) deliberately land next to you at the start
- Not used in Plunder or Resurgence; turn off with `noice_wz_pacing 0`

**Fake Banking**
- Bots use the verified native direct Plunder bank function after a safe 2.5-second channel
- Bots bank when stocked and carrying more than their cash reserve
- Reserve is calculated as the maximum of `noice_wz_cash_reserve`, `noice_wz_deposit_at` (minimum 500), or buyback cost when eligible
- Spare cash under 500 is not banked

**Native Ping System**
- Bots mark visible enemies and recent contacts on the tacmap (enemy pings only; bots do not ping loot)
- Humans can order same-team bots to move to tacmap marks
- Player-mark order logging
- Script-created pings expire automatically via configurable lifetimes:
  - Enemy pings: 10 seconds
  - Danger pings: 60 seconds

**Armor Plate Sharing**
- Bots hand spare armor plates directly to low-armor human teammates (up to 3 at a time, using the game's own give function)
- Bot verifies its own armor reserve decreased before declaring success; if the hand-off fails, the plates go back to the bot
- Bot keeps at least one plate for itself

## Cash Drop Fix

A standalone fix for the broken offline Warzone Cash Drop crate interaction.

### Features

- Replaces the non-functional offline Cash Drop crate-use path
- Spawns verified Plunder cash loot piles when a Cash Drop crate is opened
- Pile values and weights match the game's own loot tables: 50 (37.5%), 80 (42%), 120 (15%), 200 (5%), and 350 (0.5%)
- Updates Plunder cash counters when piles are collected
- Falls back to direct cash credit if loot pile spawning fails
- Configurable via `cashdrop_fix` and `cashdrop_piles` dvars

# Installation

- Put the compiled `.gscc` files obtained from the releases-page into `jupiter\Assets\Scripts\Custom\br`

**Portability**
- No LUMEN-specific APIs; works with any MWIII client/modloader that loads Atian-compiled GSC after native scripts with equivalent namespace and path handling

## More to come

This is an active project. Additional fixes and modifications are planned and will be released as standalone scripts.

## Credits

- **Activision** — for *Call of Duty: Modern Warfare III* and *Warzone*, the game these mods are built for.
- **Atian**[https://github.com/ate47/atian-cod-tools] — for *Atian COD Tools* (the `acts.exe` GSC compiler and related tooling) used to compile these scripts.
