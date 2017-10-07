# WHDB
Continued WHDB addon for classic WoW

## This Addon has been discontinued. Use [ClassicDB](https://github.com/Muehe/classicdb) instead.

Requires Cartographer addon (using the [modified WHDB version of Cartographer](https://github.com/Muehe/Cartographer) is advised but not required).

# Description:

This addon is a fork of the original "Wowhead DB" addon as provided in RapidQuestPack 1.2. It plots notes on the World Map (at zone level only so far). You can mark NPCs, objects and item drops. Quest objectives can be marked as well, but there are some blind spots (better data is WIP). It can plot several thousand notes at the same time. If you want to know what that means try "/whdb item Copper Ore" with minimum drop chance 0 (the standard setting).

Can be used with Questie and ShaguDB (ShaguDB is a little buggy due to using Cartographer as well, but I didn't encounter any big issues).

# Installation Instructions:

 1. Download WHDB
 2. Download modified [Cartographer](https://github.com/Muehe/Cartographer) (optional if you already have the original, but adds some convienient features).
 3. Copy or move the WHDB and Cartographer folders into WOW_FOLDER\Interface\Addons\
 4. If you have Questie installed and want the Questie Notes to only show on the world and continent maps do the following:
  * Go to WOW_FOLDER\Interface\Addons\\!Questie\Modules and open the QuestieNotes.lua file
  * Search for ```Questie:DRAW_NOTES();```
  * Replace with ```if (z == 0) then Questie:DRAW_NOTES(); end```
  * Note that WHDB is not showing all the notes Questie shows right now. Hopefully this will be fixed in the future.
 5. Start the game and login to the character selection screen.
 6. Click the AddOns button in the bottom left corner.
 7. Set the "Script Memory" in the top right corner to something bigger (256 MB seems fine) and click Okay button.

# Credits:

**UniRing** and **Bërsërk** for the original WHDB Addon.

**rapidlord** for the RapidQuestPack, from which this addon was forked.

**cmangos/classicdb** for the data used in this addon.

**Eric Mauser** creator of ShaguDB, an addon quite like mine (also forked from WHDB), of which I was unaware when starting to improve the old WHDB. Some of his stuff was incorporated into this addon (e.g. the beautiful icons).

# Screenshots:
http://imgur.com/a/iyegU

<img src="http://i.imgur.com/AG29iuy.jpg" alt="Small Map, big icons"/>

<img src="http://i.imgur.com/bXdSXw2.jpg" alt="Big Map, Small Icons"/>

<img src="http://i.imgur.com/j8kSAXf.jpg" alt="Single Quest Display"/>

<img src="http://i.imgur.com/K8qGT76.jpg" alt="Multi Quest Display"/>

<img src="http://i.imgur.com/yXPQZas.jpg" alt="Quest Start Display"/>


