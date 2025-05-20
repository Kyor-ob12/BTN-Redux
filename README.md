

![BTN](https://github.com/Rparadise-Team/BTN/assets/110534038/f6274ba3-46c5-4409-924d-656fa24765d2)

### **DISCLAIMER**

Hello everyone:

First of all, THANK YOU to Miyoo for giving us some units for development, also to Ninoh_FOX for the standalone emulators and the LED script and to Steward Fu for the Drastic emulator and the SORR 5.2 port.

This image does NOT have games or bios. The "bios" files must be placed in the path "/RetroArch/.retroarch/system" and if you use PCSX and Picodrive standalone emulators, you will also have to put it in their corresponding folders.

Please note that the scrapes should be placed in a folder named "Imgs" inside each system folder within the "ROMS" directory (Roms/Imgs). The scrape should have the same name as the ROM and be in "png" format.
It is recommended that scrapes have a maximum resolution of 320x240 to avoid performance issues.


### **INCLUDED SYSTEMS**

AMIGA, AMSTRAD CPC, ARCADE, ATARI2600, ATARI5200, ATARI7800, COMMODORE64, CPS1, CPS2, CPS3, DREAMCAST, DOOM, MS-DOS, FBNEO, NES, FAMILY DISK SYSTEM, GAME BOY, GAME BOY COLOR, GAME BOY ADVANCE, GAME GEAR, GAME & WATCH, LYNX, MEGADRIVE, MASTER SYSTEM, MSU-1, MSUMD, MSX, NINTENDO64, NINTENDO DS, NEOGEO, NEOGEOCD, NEO GEO POCKET, ODYSSEY2, PCENGINE, PCENGINECD, PICO-8, POKEMON MINI, PSP, PSX, QUAKE, SCUMMVM, SEGA 32X, SEGA CD, SG-1000, SUPER NINTENDO, SUPER GAME BOY, SUPERVISION, TIC-80, VIRTUAL BOY, WOLF3D, WONDERSWAN, X68000 and ZX SPECTRUM.

### **CONTROLS IN THE MIYOO OPERATING SYSTEM**

_In the main menu:_

- DPAD: Navigate through menus.
- HOME: Shows a menu to search ROMs by name and refresh ROM lists.
- A/Y: OK.
- B: Back.
- SELECT: Search ROMs by name.
- L2 and R2: Fast scrolling.
- START + L1/R1: Adjust brightness.
- SELECT + L1/R1: Adjust volume.

_In a system's game list:_

- DPAD: Navigate through the list.
- HOME: Show menu to open the game, add it to favorites, or delete it.
- X: Change core to use with the game (does not save the selection).
- A/Y: OK.
- B: Back.
- SELECT: Search ROMs by name.
- L2 and R2: Fast scrolling.
- START + L1/R1: Adjust brightness.
- SELECT + L1/R1: Adjust volume.

### **CONTROLS IN RETROARCH (HOTKEYS)**

- HOME + A: Pause.
- HOME + B: Fast Forward (not recommended for PS1, may cause performance issues).
- HOME + Y: Show/hide FPS.
- HOME + X: Miyoo menu (from here you can save and load states).
- HOME + L1: Load Savestate.
- HOME + R1: Save Savestate.
- HOME + L2: Previous Savestate slot.
- HOME + R2: Next Savestate slot.
- HOME + START: Exit the game (same as exiting from the Miyoo menu).
- START + L1/R1: Adjust brightness.
- SELECT + L1/R1: Adjust volume.

### **EXTRA SHORTCUTS FOR CERTAIN SYSTEMS**

- GAME BOY: Use R2 and L2 to switch color palettes and R1 to speed up the game.
- GAME BOY COLOR: Use R1 to speed up the game.
- GAME BOY ADVANCE: Use R2 to speed up the game.
- ARCADE: Use R2 to open the configuration menu, where you can change switches or activate cheats.
- NEO GEO AND NEOGEO CD: A+B+C: Press this on the Universal Bios screen to change region, BIOS configuration, and other options. Select + Start or Start + A + B + C: Access the in-game menu to activate cheats. Hold Start for a few seconds: Access the game's switch menu (Neo Geo only).
To load a save state when starting a game, do so after the Unibios loading screen to avoid corruption. If corruption occurs, you can reload the state after exiting and re-entering the game.
- CAPCOM (CPS1, CPS2, AND CPS3): BOM's switch files have been used. Although FBA cannot change them, it can read them, so games like Alien vs Predator and the first D&D are in Spanish, while games like SFA 3 have proper difficulty and one-credit settings.

### **PICO-8 STANDALONE EMULATOR CONTROLS**

_In joypad mode:_

- DPAD & STICK: Direction.
- A: Button X.
- B: Button O.
- X: Escape (options).
- HOME: Escape (options).
- START: Option.
- SELECT: Change to mouse mode.

_In mouse mode_

- STICK: Direction.
- DPAD: Move mouse cursor.
- A: Button X.
- B: Button O.
- X: Escape (options).
- L2: Mouse button right.
- R2: Mouse button left.
- SELECT: Change to joypad mode.

### **IMPORTANT INFORMATION**

- To make the standalone Pico-8 emulator work you need buy pico8 raspberry pi 32bit code and put "pico8_dyn" and "pico8.dat" in "App/pico/bin" in your MicroSD card.
- For systems like DC, PSP, N64 and NDS it is not recommended to play for long periods as the console heats up, and these systems are not really meant to be played on this console.
- Remember that you can switch cores when loading a game. If a game doesn't perform well with one core, try another. The Miyoo system does not allow saving core assignments (something we cannot remedy).
By default, Arcade loads games with the "mame2003_plus_libretro" core, but some games may need others. For demanding games, use the "km_mame2003_xtreme_libretro" core, and for others, "fbneo_libretro" may be necessary. This requires experimentation.
- After exiting sleep mode, both background music and screen brightness do not return to default values (this is not an image fault but a console issue).
- If the analog control has "drift," it is recommended to calibrate it in the system settings until it works correctly.

This is a BETA version. As firmware updates will be released from Miyoo, we will do everything possible to refine the image as much as possible. Anything you detect, please tell us.

To download click on this link: https://github.com/Rparadise-Team/BTN/releases

Rparadise Team.

---

### **BTN-Redux, a BTN customization**

### **Disclaimer**

This is still a BTN BETA version, just customized by me — one dev doing it all solo.  
So if you run into any bugs, sorry in advance! Could be stuff I broke or things that were already in the original. - Kyor0812.

**Huge thanks to the RParadise Team** — the ones who brought us BTN in the first place.  
A great custom firmware focused on performance, made with love for retro gamers.

**Big thanks as well to the Spruce OS team** — a lot of ideas came from their work, like the base system/game settings customization, advanced menu, logger, message display, shaders, overlays, themes organization, and more.

**Massive thanks to the Miyoo Spanish community** — you were the fuel behind this little project.  
You made it real and gave me so much without even knowing it.

---

**And most of all, my deepest gratitude to Alber (ATC)** — main developer of BTN, an active force in this community, and an incredibly talented designer and professional.  
Everything I’ve done here is built on top of his original vision and hard work.  
**This project wouldn’t exist without him, and I hope this little extension of his work makes him proud.**

---

### **Changelog**

#### version feature-v1.1.0-rc

- Solved minor typo error showing system name in "per system" configuration menu.
- Added "fbalpha2012" and "fbneo_miyoo_plus" cores to NEOGEO core list.
- "fbneo_miyoo_plus" core could be used for Netplay with other Miyoos using BOM as CFW.


#### version feature-v1.0.0-rc

#### Game execution with dynamic and persistent CPU and core/emulator resource configuration  
You can now fine-tune settings per-system or adjust them for specific games.  
**Note:** This doesn't work for NDS, as the config is hardcoded in the Drastic binary and resets on each launch. If your A30 overheats when running NDS, reduce the core count to 2 manually in Drastic every time you start a game.

#### New options in the game menu (press `X` on a game)
- **"Launch with current system/game config"**. If there's a game-specific config, it overrides the system one.
- **"Advanced system/game config"**. Access *Advanced settings* to edit system-wide or per-game settings.
- **"Save current launch settings as per-game override"**.
- **"Remove per-game launch setting override"**.

#### Theme additions  
Added the "SuperGameBoyMicro" theme by MLOPEZMAD (originally for Miyoo Mini), customized by myself for Miyoo A30.  
Includes `README` with original credits and acknowledgments.

#### openBOR support  
Added `openBOR` as a new system.

#### SoRR location change  
Moved `SoRR` from `/Apps` to `/Emu/PORTS`. Now accessible via the system menu under `PORTS`.

#### Log support  
Log output is now available at `/CFW/btn.log`, imported from *spruceOS*.

#### Experimental scripts added under `/CFW/scripts`
- `refresh_emus_with_roms.sh`: Moves systems between `/Emu` and `/Emu/.unused` based on ROM presence. Cleans up the system menu. Not well tested—use with caution. Could become an app in the future.
- `get_core_lists.sh`: Parses `/Emu/*/config.json` to extract cores used in the original BTN's `launch*.sh`. Developer tool.
- `collect_icons.sh`: Collected icons from `/Emu` and `/Apps` and moved them to `/Themes/.icons`. Developer tool.
- `helperFunctions.sh`: Partial function library from *spruceOS*. Currently uses `display` and `log_message`, with others included for future development.

#### Deprecated: legacy system config  
Obsolete system for managing dynamic/persistent CPU and core/emulator settings.  
Scripts in `/Emu/.emu_setup`:
- `core_switch.sh`
- `cpu_cores_switch.sh`
- `cpu_switch.sh`  
To function properly, `launchlist` in each system's `config.json` must include sections that match the current system config.  
See example in `/Emu/.emu_setup/.examples/config.json`.  
Each script rotates through configuration options on each run, showing current values.  
Game-specific config can be derived from system config, but cannot be independently edited—only created or deleted.
