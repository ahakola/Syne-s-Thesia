Syne's Thesia
=============

![Syne's Thesia](/logo_synesthesia.png?raw=true "Syne's Thesia")

>Synesthesia is a perceptual phenomenon in which stimulation of one sensory or cognitive pathway leads to involuntary experiences in a second sensory or cognitive pathway.
[Synesthesia - Wikipedia](https://en.wikipedia.org/wiki/Synesthesia)

*Syne's Thesia* is an external edit of *ElvUI* based on the original *Syne's Edit* of *TukUI*.

![Hunter with all name plates enabled and Recount-profile enabled](/Screenshots/Hunter-Nameplates-FriendlyNameplates-Tooltip-PetBat-RecountStyled.png?raw=true "Hunter with all name plates enabled and Recount-profile enabled")

This isn't 1:1 recreation of the *Syne's Edit*, since there has been ton of new features added and some old features removed from the game over the years compared to the era of the original *Syne's Edit*, but I have tried my best to keep the core features and preserve the style of the original UI by reading the original UI's code like Devil reads the Bible and cross-referencing screenshots and counting pixels for hours. Even with all this work put into this project, I couldn't add all of the features the way they were in the original. I also added few small quality of life -changes here and there that weren't in the original edit, but I felt weren't too invading to the spirit of the original.


## Features

Most of these are from *Syne's Edit* and few of them are my own edits.

- Installer
  - Should pop-up if/after *ElvUI* install has been completed
  - Create style matching (more or less) profiles for *DBM*, *Recount* and *InFlight*
  - Setup *AddOnSkins* for *DBM* and *Recount*
- Layouts
  - Tank/DPS- and Healer-layouts with all the unit frames styled properly
  - You can change between the styles with slash-commands `/dps` and `/heal`
- Layout User-config
  - Hardcoded layouts only affect some of the options for *Party*, *Raid*, *Raid-40* and *Raid Pet* unit frames but I still wanted you to have as much control as possible over your UI so I made the "Layout User-config" -feature
  - You can type your own changes to the parts of the layout otherwise hardcoded
  - On layout change *Syne's Thesia* will parse them after the hardcoded changes has been applied first
- Unit frames
  - `Low mana` -warning for Player with configurable threshold level
  - Combat Feedback on Player and Target frames
  - You can change the *ElvUI* role icons into *Syne's Edit* -styled colored squares
  - You can select between two different aura styles for Target unit frame
  - Player and Target cast bars can be either embedded to the unit frame or detached to be placed anywhere on the screen
  - While in Healing-layout, you can replace the Party frames with Raid frames by enabling `Grid only -mode`
  - You can change the scale of the Grid styled Raid frames
- Name plates
  - All the name plates are styled, even friendly ones for those who want to enable them outside of the instances
- Data texts
  - 8 new data text panels under the action bars
- Action bars
  - Up to 3 bottom action bars with side action bars (limited to 2 bottom action bars with side action bars enabled)
  - Side action bars at the bottom of the screen
  - Possibility to replace the 12 button bottom actions bars with up to 2 wide action bars with 22 buttons each
  - Possibility to enable extra action bar in the middle of the screen (exact position is user place able)
- Chat
  - Possibility to align the timestamps on the right side of the chat on Right Chat -window
- Miscellaneous
  - Buff reminder if you are missing your own buff while in combat
  - Undress-button in Dress Up Frame
  - Stack items in/to -buttons in Bags and Bank
  - Fix to my personal problem where *ElvUI* and *AddOnSkins* with auto hide embedded AddOns would make *Recount* stay invisible

Also at least bags and bank, data bars, mirror bars, tooltips, threat bar and some of the fonts in the UI have been styled to match the *Syne's Edit*.


## Requirements and installation

*Syne's Thesia* has been developed and tested only with *ElvUI* versions `11.27` - `11.372`, but for best results, use only with WoW patch 8.3 and the latest suitable version of *ElvUI*.

1. If you haven't completed your *ElvUI* installation yet, go through it first (you can just press `Continue`-button on all the steps and press the `Finished`-button at the last step).
2. Installer should show up after login/*ElvUI* installation.
  - If the installer doesn't pop up automatically, you can launch it from the in game ElvUI-config under the `Syne's Thesia` -section by pressing the `Install`-button.
3. During the installation follow the instructions on the screen and don't be afraid if the UI doesn't look right, everything should fall into right place after the UI reload at the end of the process.

To activate the additional profile-features available for *AddOnSkins*, *DBM*, *Recount* and *InFlight* you might have to change the used profile yourself.

- For *DBM* the installer tries to enable profile automatically.
- For *InFlight* the installer should edit the `Default`-profile which is used for every character if the `Character Specific Options`-setting is turned OFF.
- For *Recount* you have to manually enable the newly created `SynesThesia`-profile either by using the GUI or with command `/recount profile choose SynesThesia`.
- For *AddOnSkins* the embed settings might not work properly until you have reloaded the UI at the end of the installation.

After the UI reload at the end of the install process, you can fine-tune the look of the UI through ElvUI-config. Please note, using the slash-commands to change the layout changes some of the *Party*, *Raid*, *Raid-40* and *Raid Pet* unit frames settings, but you can override those by using the *Layout User-config*.


## Layout User-config

I liked the idea of fast and easy layout changes with slash-command and pre-hardcoded settings, but I still wanted for the user to have almost full control over the UI. My solution to this was this feature where you can set your own edits to the UI and on layout change *Syne's Thesia* will evaluate your changes for the selected layout after applying the hardcoded changes first.

The feature consists of two editboxes, one for Tank/DPS-layout and the other for Healer-layout, under the `Syne's Thesia` -section of ElvUI-config where you can paste your own personalised settings. I know this feature sounds pretty advanced compared to the primitive implementation and isn't exactly newbie-friendly, but I assumed most of the users of the external edits either have some knowledge and understanding how this works or don't care about this feature.

1. First edit the group unit frames to your liking through `UnitFrames`-section under ElvUI-config.
2. Export your profile in "Plugin"-format (`Profiles`-section under ElvUI-config) and find the settings you changed and discard the rest.
3. Paste the changes into the right layout's editbox. If the changes doesn't validate, there is most likely an error, typo or missing character in your paste.
4. If you want to position the frames, you can use the `SY:SetMoverPosition()`-function with the frames Mover.
  - Use it like `:SetPoint()`-method with Mover's global name added as first argument.
5. If the changes validates, reapply the layout with slash-command to confirm the wanted results.
6. Repeat from the beginning if needed.

**N.B.:** If the editbox's content doesn't validate, *Syne's Thesia* won't parse your changes on layout change!

##### Example:

```lua
E.db.unitframe.units.party.buffs.sizeOverride = 44
E.db.unitframe.units.party.debuffs.enable = false
E.db["unitframe"]["units"]["party"]["name"]["text_format"] = "[difficultycolor][level] [namecolor][name:long]"
SY:SetMoverPosition("ElvUF_PartyMover", "TOPLEFT", E.UIParent, "TOPLEFT", 100, -100)
```

**N.B.:** Remember, the layout changes only affects parts of the *Party*, *Raid*, *Raid-40* and *Raid Pet* unit frames settings of the UI. All other changes you made to the UI with ElvUI-config won't be touched when changing layouts and can be omitted!


## Screenshots

<details>
<summary>Target auras</summary>

###### Rogue with Target auras
![Rogue with Target auras](/Screenshots/Rogue-TargetAuras.png?raw=true "Rogue with Target auras")

###### Rogue with Tank/DPS-layout Raid40 frames with Player and Target auras
![Rogue with Tank/DPS-layout Raid40 frames with Player and Target auras](/Screenshots/Rogue-DPSRaid40-Player&TargetAuras.png?raw=true "Rogue with Tank/DPS-layout Raid40 frames with Player and Target auras")

###### Rogue with Alternative-style on Target auras
![Rogue with Alternative-style on Target auras](/Screenshots/Rogue-AltStyleAuras.png?raw=true "Rogue with Alternative-style on Target auras")
</details>

<details>
<summary>Unit frames</summary>

###### Rogue with Tank/DPS-layout Party and Arena frames
![Rogue with Tank/DPS-layout Party and Arena frames](/Screenshots/Rogue-DPSParty-Arena.png?raw=true "Rogue with Tank/DPS-layout Party and Arena frames")

###### Paladin with Healer-layout Party frames
![Paladin with Healer-layout Party frames](/Screenshots/Paladin-HealerParty.png?raw=true "Paladin with Healer-layout Party frames")

###### Rogue with Tank/DPS-layout Raid and Boss frames
![Rogue with Tank/DPS-layout Raid and Boss frames](/Screenshots/Rogue-DPSRaid-Boss.png?raw=true "Rogue with Tank/DPS-layout Raid and Boss frames")

###### Paladin with Healer-layout Raid frames with Grid-scale 1.0
![Paladin with Healer-layout Raid frames with Grid-scale 1.0](/Screenshots/Paladin-HealerRaid-Scale10.png?raw=true "Paladin with Healer-layout Raid frames with Grid-scale 1.0")

###### Paladin with Healer-layout Raid frames with Grid-scale 1.2
![Paladin with Healer-layout Raid frames with Grid scale 1.2](/Screenshots/Paladin-HealerRaid-Scale12.png?raw=true "Paladin with Healer-layout Raid frames with Grid-scale 1.2")

###### Rogue with Tank/DPS-layout Raid40 frames with Player and Target auras
![Rogue with Tank/DPS-layout Raid40 frames with Player and Target auras](/Screenshots/Rogue-DPSRaid40-Player&TargetAuras.png?raw=true "Rogue with Tank/DPS-layout Raid40 frames with Player and Target auras")
</details>

<details>
<summary>Action, stance and pet bars</summary>

###### Druid with stance bar
![Druid with stance bar](/Screenshots/Druid-StanceBar-Tooltip.png?raw=true "Druid with stance bar")

###### Rogue with two '22 button row' action bars
![Rogue with two '22 button row' action bars](/Screenshots/Rogue-ActionBars2Wide.png?raw=true "Rogue with two '22 button row' action bars")

###### Rogue with three action bars
![Rogue with three action bars](/Screenshots/Rogue-ActionBars3Normal.png?raw=true "Rogue with three action bars")

###### Hunter with pet bar and all name plates and Recount-profile enabled
![Hunter with all name plates enabled and Recount-profile enabled](/Screenshots/Hunter-Nameplates-FriendlyNameplates-Tooltip-PetBat-RecountStyled.png?raw=true "Hunter with all name plates enabled and Recount-profile enabled")
</details>

<details>
<summary>Friendly name plates</summary>

###### Hunter with friendly name plates turned on while targeting NPC
![Hunter with friendly name plates turned on while targeting NPC](/Screenshots/Hunter-FriendlyNamePlates-TargetingNPC.png?raw=true "Hunter with friendly name plates turned on while targeting NPC")

###### Hunter with Friendly name plates while targeting Player
![Hunter with friendly name plates turned on while targeting other Player](/Screenshots/Hunter-FriendlyNamePlates-TargetingPlayer.png?raw=true "Hunter with friendly name plates turned on while targeting other Player")
</details>

<details>
<summary>Cast bars</summary>

###### Rogue with embedded cast bars
![Rogue with embedded cast bars](/Screenshots/Rogue-CastbarsEmbedded.png?raw=true "Rogue with embedded cast bars")

###### Rogue with detached cast bars
![Rogue with detached cast bars](/Screenshots/Rogue-CastbarsDetached.png?raw=true "Rogue with detached cast bars")
</details>

<details>
<summary>Bags and bank</summary>

###### Rogue with bags and bank open
![Rogue with bags and bank open](/Screenshots/Rogue-Bags-Bank-UndressButton.png?raw=true "Rogue with bags and bank open")
</details>


## Issues

If you run into any new issues or have an idea how to better achieve what I'm trying to do, don't hesitate to contact me at [Issues](/../../issues/).

#### Known issues

These are the issues I'm aware of, if you have any idea what causes them or how to fix them, don't hesitate to contact me!

##### New chat-tabs opened while in CombatLockdown causes an error

This bug happens when you are in combat lockdown and receive first (opening a new chat-tab) whisper or BN-whisper from someone. The later whispers received from same user doesn't cause any additional errors, but any whispers from other users will cause the same error to fire for every first whisper.

This bug has probably something to do with improper API-calls inside the WoW Restricted Environment when setting up new chat-tab?

```
1x [ADDON_ACTION_BLOCKED] AddOn 'ElvUI' tried to call the protected function 'RightChatPanel:SetSize()'.
[string "@!BugGrabber\BugGrabber.lua"]:519: in function <!BugGrabber\BugGrabber.lua:519>
[string "=[C]"]: in function `SetSize'
[string "@ElvUI\Core\Toolkit.lua"]:191: in function `Size'
[string "@ElvUI\Modules\chat\Chat-Chat.lua"]:869: in function <ElvUI\Modules\chat\Chat.lua:863>
[string "=[C]"]: in function `PositionChat'
[string "@ElvUI\Modules\chat\Chat-Chat.lua"]:1810: in function <ElvUI\Modules\chat\Chat.lua:1770>
[string "=[C]"]: in function `?'
[string "@AddOnSkins\Libs\Ace3\AceHook-3.0\AceHook-3.0-8.lua"]:103: in function <...Ons\AddOnSkins\Libs\Ace3\AceHook-3.0\AceHook-3.0.lua:100>
[string "=[C]"]: in function `FCF_OpenTemporaryWindow'
[string "@FrameXML\FloatingChatFrame.lua"]:2560: in function <FrameXML\FloatingChatFrame.lua:2549>
```

##### Collapsing empty space reserved for auras on Target unit frame

If you use the primary style for auras on unit frames, the UI reserves huge amount of screen space for debuffs pushing the aura bars really high if there are only few debuffs. In an ideal world the AddOn could collapse the empty rows of aura icon or having different aura styles for friendly and hostile targets making the aura bars come way down when all the lines aren't fully populated.

This was one of the reasons I created the alternative-style, but it has its limitations on how many buffs it can show which is a shame when targeting friendly target.


## What was left out

These were the features (not present in the original) I at one point thought about adding to the UI, but decided later to leave them out for one reason or another.

##### Ordering debuffs on Target unit frame

Currently only debuffs applied by you are saturated. I would like for the UI also sort debuffs applied by you to the front of the list and have rest of the desaturated debuffs listed after. This might already be possible, but was probably outside of my oUF-editing skills.

##### I had this really sweet idea of Player debuffs...

But it would probably have required ton of custom code and it wasn't in *Syne's Edit* -style so I didn't bother implementing it.

##### *Damn Achievement Spam* -style Achievement spam -jammer

*Damn Achievement Spam* was an AddOn that collected all the achievements gained from the chat in short time window and bunched them into one per different achievement. This reduced the number of lines in chat and guild chat if a raid group gained an achievement. Not implemented, because this was never at the top of my priority list, and the time saved was used to improve other aspects of the UI.


## Thanks

I couldn't have done this edit without the help or "help" (Copy&Paste) and inspiration of the following people:

- Syne (*Syne's Edit*)
- Blazeflack (*CodeNameBlaze* and *ElvUI CustomTweaks*)
- Phanx (CombatText from *oUF_Phanx*)
- Vik and Nefarion (Undress-button)

And of course we shall not forget the hard work and inspiration of:

- Everyone who helped Tukz creating TukUI
- Everyone who helped Elv creating ElvUI

I have also taken look at the code and soaked some inspiration from other TukUI and ElvUI edit creators over the years, but I can't possibly remember all of the names, and it would be unfair to list only few of you all.

I would also like to give special thanks to everyone who has helped me directly or indirectly to improve my skills over the years by providing nice coding tips and practices or even full code snippets over the years at TukUI-, WoWInterface- and CurseForge-forums. If you have ever read these forums, you know the familiar names who pop in giving great advices thread after thread, year after year. And only couple of these tips has been ever given straight to me, reading all the tips and tricks you guys and girls have given to other users has saved me from many troubles later.


---

History or "The Longest Programming Project of My Life"
-------------------------------------------------------

I have always remembered the original *Syne's Edit* with warmth and I was bit lost when Syne stopped updating his UI. When I first contacted Syne in 2014 about this recreation-project, I never would have guessed it would take me nearly **6 years** to get this edit done.

First of all, I had already moved on to *ElvUI*, because the *Syne's Edit* was so out of date it was practically impossible to enjoy the game with patch 4.2.0. I chose *ElvUI* over *TukUI* because it had these quality of life -improvements built into it and it saved me the effort of finding/creating AddOns for many of these small things.

Second problem was the fact I was doing this all alone and this was the biggest project I had ever done before that. After throwing in most of the key functions from the original into this new edit of *ElvUI* I created, I quickly realised I would be "sliding backwards" because I wouldn't be able to keep up with the changes in the codebase of the *ElvUI*. I solved this "never ending need of merging" -problem by turning the project into external edit.

The development was still slow with my own limited free time and there was the release of *World of Warcraft: Warlords of Draenor* in the horizon. This meant there was going to be a major overhaul in the *ElvUI* risking the project might not work with the upcoming WoD-version of the *ElvUI* without huge rewrites even as an external edit. With the feeling of all the work I had done so far could be futile within few months, I ended putting the project into a hiatus...

Time passed on and months I planned to wait turned into years and we had already skipped *World of Warcraft: Warlords of Draenor* completely. It was around **3 years** to be exact when I picked up this project again. It was somewhere around middle of *World of Warcraft: Legion* and I thought I could finish this project now fast by just updating my project by fixing what was broken and adding the missing parts. I made the changes, added some missing features from the original to the project, but it still turned out to be too huge task for me to bend the *ElvUI* to my will externally with the time available to me back then. As the easy and fast fixes were in and the visible progress on the project slowed down, and so did my motivation for this project at the time and once again I decided to take a short break...

As another period of almost **3 years** passed by and we were not only in the *World of Warcraft: Battle for Azeroth* already, but *The Eternal Palace* -raid had been on farm for quite a long time, the time for patch 8.3.0 release was counted in weeks instead of months and the reveal of *World of Warcraft: Shadowlands* had felt really underwhelming to me. I wasn't sure I was going to keep playing after BfA and I wanted to give this project one last good try before I possibly quit the game, just to prove myself this wan't just a pipe dream and I *COULD* do it and out of respect to Syne and the original edit. Even after making the decision to try once more, I really didn't have the time needed in my schedule, so this had to wait for little bit more. But this time I wasn't going to let it slide into eternity, I was sure about that.

Between Christmas 2019 and New Year 2020, when I finally had the time to focus on my own projects again, I started the last attempt to finish the project. Instead of continuing the old project, I had my "Now you're thinking with portals!"-moment and picked up an existing external edit called *CodeNameBlaze* by Blazeflack and started converting it to *Syne's Edit* -clone. First I threw in the same key functions I started with the original project almost **6 years** ago and started going through the edit file by file changing them to match the *Syne's Edit* -style.

I don't know how huge impact the increase in my own coding skills over the years, or the fact this was my third try on this, was compared to the very well made working base AddOn, but the project was making progress faster than it ever had before and I really felt I could finish this in a few weeks, maybe even get it ready for the launch of *Ny'alotha, the Waking City* -raid, launching at January 14th, if I was lucky and worked hard. Few weeks passed, the new raid had just opened, and I had made steady progress through making changes to almost all of the files, deleting rest and creating some new ones. At this point I had the UI mostly working, but it lacked some fine tuning and polishing, still had couple of bugs in it and the in game config was still yet to be finished. This was around the end of January 2020 and I felt the project was maybe week, maximum of two weeks, away from finishing.

Then came February 4th 2020 and the new *ElvUI* version 11.34 when disaster hit. The new *ElvUI* version had the following new addition: `The options window has been upgraded and sections have been reorganized a bit (Repooc does NOT like it tho).` The old config layout I had been working on didn't work with the new options window. I had to rethink the whole "already thought through in game config" -part of my UI and at the time I was so taken aback about this change, I had zero idea how to do this actually really simple task. This combined with a nasty bug in the Chat-system I had been trying to fix for some time already, which I still haven't been able to fix until this day, or even pinpoint what exactly causes it, meant I started to feel like the project was slowing down and possibly coming to a halting stop.

But no, I wasn't going to stop this time. I was going to give myself the possibility of this project being my swan song (or even some kind of magnum opus) of my own WoW AddOns. So I kept on fighting for the project, almost endless fine tuning of elements, fixing the bugs I could find, testing out different possible layouts for the new in game config, filling out the *locales.lua* and even added few new last minute features. More than 2 months after the disaster hit, at the night between April 18th and 19th 2020, I finalized the "Layout User-config" -feature (last feature added to first release version) and the project was ready to be called **Syne's Thesia version 1.0**.

I know it isn't perfect or even close to being 1:1 copy of the original in all aspects, but I felt I had reached all the goals I have set myself for this project over all the years. Also I wasn't sure the changes needed to make it even closer to the original were even in the reach for me with my current coding skills.

---