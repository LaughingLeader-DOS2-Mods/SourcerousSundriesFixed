# Sorcerous Sundries - Fixed 

This mod fixes the various compatibility issues with the Sorcerous Sundries gift bag, and makes it work with regular and mod-added item.

[Download the latest release here.](https://github.com/LaughingLeader-DOS2-Mods/SourcerousSundriesFixed/releases/latest/download/SorcerousSundriesFixed_Latest.zip)

## Requirements 

[Norbyte's Divinity Script Extender](https://github.com/Norbyte/ositools/releases/latest) is required for this mod to work.

## What issues does this mod fix with Sorcerous Sundries? 

There are two main issues with Sorcerous Sundries:
* Sundries overrides *all* weapon, shield, and armor stats, including NPC stats (which can't be upgraded anyway), to make equipment compatible with the new upgrade crafting recipes. This reverts any changes mods like overhauls may make.
* Presumably a bug with the game, when you load a save with gift bag mods, they end up getting loaded last, after your regular mods. This is what makes Sundries undo any changes mods may make to the base equipment stats. Unfortunately this means you can't simply load Sundries before your mods.

So with those in mind, this mod does the following:
* All of Sorcerous Sundries stat overrides are disabled by overriding the stat files with blank ones. This is thanks to the extender's path override API feature.
* All equipment stats that players can use (i.e. stats that aren't NPC ones) get the new crafting category added to them, making them compatible with the upgrade crafting recipes. Since this is done dynamically to all the equipment stats in the game, this means items added by mods can also be upgraded.
* Sourcerous Sundries is set as a dependency to this mod, which makes it load in the main menu like regular mods.

## Support 

If you're feeling generous, an easy way to show support is by tipping me a coffee:

[![Donate](https://i.imgur.com/NkmwXff.png)](https://ko-fi.com/LaughingLeader)

I love modding this game, and I love interacting with the community. Every bit helps to keep me doing what I'm doing. Thanks!

## Links 

* [Steam Workshop](https://steamcommunity.com/sharedfiles/filedetails/?id=2178619939)
* [Norbyte's Script Extender Source](https://github.com/Norbyte/ositools)
* [LaughingLeader's Lair Discord Server](https://discord.gg/WArseRBz3R)
