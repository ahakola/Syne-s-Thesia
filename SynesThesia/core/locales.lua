--[[------------------------------------------------------------
--	Syne's Thesia, an ElvUI edit by ahak @ tukui.org
--
--	This file contains localization code for Syne's Thesia
------------------------------------------------------------]]--
local E, L, V, P, G, _ = unpack(ElvUI) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local L = LibStub("AceLocale-3.0-ElvUI"):NewLocale("ElvUI", "enUS", true)
if not L then return end

-- Probably many of these could be found from ElvUI Locales or GlobalStrings already...

-- core\init
L["Your version of ElvUI is older than recommended for use with %s. Please update ElvUI at your earliest convenience."] = true
L["%s version %s by Sanex @ Arathor-EU"] = true -- SY.title, SY:ColorStr(SY.version)
L["%s is an external edit of ElvUI based on the original Syne's Edit of TukUI."] = true -- SY.title
L["Installation"] = true
L["Credits"] = true
L["The installation guide should pop up automatically after you have completed the ElvUI installation. Click the button below if you ever wish to run the installation process for %s again."] = true -- SY.title
L["Install"] = true
L["Run the installation process."] = true
L["You can change the layout after install with slash-commands %s for Tank/DPS-layout and %s for Healer-layout."] = true -- SY:ColorStr("/dps"), SY:ColorStr("/heal")

-- core\config
L["SY_CREDITS"] = "I couldn't have done this edit without the help or 'help' (copy&paste) and inspiration of the following people:"
L["Coding:"] = true
L["Testing:"] = true
L["Donations:"] = true

-- core\core
L["Miscellaneous"] = true
L["Buff Reminder"] = true
L["This is now the new Inner Fire warning script for all armors/aspects of a class."] = true
L["Recount fix"] = true
L["This hack should fix the problem of Recount not showing up when it should."] = true
-- Experimental
L["Experimental"] = true
for i = 1, 5 do
	L["Experimental " .. i] = true
	L["Experimental ".. i .. " Desc"] = true
end
L["SY_EXPERIMENTAL_DESC"] = "\n\nThese settings probably won't work: (Select any or all!)\n   a) how intended\n   b) how you think\n   c) at all"

-- core\install
L["Chat Set"] = true
L["CVars Set"] = true
L["Layout Set"] = true
-- AddOns
L["A profile for '%s' has been created."] = true -- AddOnName
L["%s Profile Created"] = true -- AddOnName
L["The AddOn '%s' is not enabled. Profile not created."] = true -- AddOnName
L["%s is not enabled, aborting."] = true -- AddOnName
L["The AddOn '%s' couldn't be loaded: %s. Profile not created."] = true -- AddOnName, reason
L["%s couldn't be loaded, aborting."] = true -- AddOnName
-- AddOnSkins
L["%s settings for AddOnSkins have been set."] = true -- AddOnName
L["The AddOn 'AddOnSkins' is not enabled. No settings have been changed."] = true
-- Installer
L["Welcome to %s version %s,\nfor ElvUI version %s and above."] = true -- SY.title, SY:ColorStr(SY.version), SY:ColorStr(SY.versionMinE)
L["This installation process will guide you through a few steps and apply settings to your current ElvUI profile. If you want to be able to go back to your original settings then create a new profile (/ec -> Profiles) before going through this installation process."] = true
L["Options provided by this edit can be found in the %s category of the ElvUI Config (/ec)."] = true -- SY.title
L["Please press the continue button if you wish to go through the installation process, otherwise click the 'Skip Process' button."] = true
L["Skip Process"] = true
L["CVars"] = true
L["This step changes a few World of Warcraft default options. These options are partially copied from Syne's Edit and partially tailored to the needs of the author of %s and are not necessary for this edit to function."] = true -- SY.title
L["Please click the button below to setup your CVars."] = true
L["Importance: |cffFF0000Low|r"] = true
L["Setup CVars"] = true
L["Chat"] = true
L["This step changes your chat windows and positions them all in the left chat panel. These changes are partially copied from Syne's Edit and partially tailored to the needs of the author of %s and are not necessary for this edit to function."] = true -- SY.title
L["Please click the button below to setup your chat windows."] = true
L["Setup Chat"] = true
L["Color Themes"] = true
L["This part of the installation will apply a Color Theme"] = true
L["Please click a button below to apply a color theme."] = true
L["Classic"] = true
L["Dark"] = true
L["Layouts"] = true
L["These are the layouts mimicking the original Syne's Edit layouts. There isn't any difference between Tank- and DPS-layouts, but the Healer-layout is different from others.\n\nYou can change the layout after install with slash-commands %s for Tank/DPS-layout and %s for Healer-layout."] = true -- SY:ColorStr("/dps"), SY:ColorStr("/heal")
L["Please click any one button below to apply the layout of your choosing."] = true
L["Importance: |cff07D400High|r"] = true
L["Tank"] = true
L["Healer"] = true
L["Physical DPS"] = true
L["Caster DPS"] = true
L["AddOns"] = true
L["This step allows you to apply pre-configured settings to various AddOns in order to make their appearance match %s."] = true -- SY.title
L["Please click any button below to apply the pre-configured settings for that particular AddOn. A new profile named %s will be created for that particular AddOn, which you might have to select manually."] = true -- SY.title
L["AddOnSkins Configuration"] = true
L["This step allows you to apply pre-configured settings to AddOnSkins in order to make certain AddOns match %s."] = true -- SY.title
L["Please click any button below to apply the pre-configured settings for that particular AddOn to the AddOnSkins settings."] = true
L["Installation Complete"] = true
L["You have completed the installation process.\nIf you need help or wish to report a bug, please go to http://tukui.org"] = true
L["Please click the button below in order to finalize the process and automatically reload your UI."] = true
L["Finished"] = true
L["Syne's Bottom Gradient DataTexts"] = true
L["Syne's Left DataTexts"] = true
L["Syne's Right DataTexts"] = true

-- modules\actionbars
L["ActionBars"] = true
L["12 Button Rows"] = true
L["Enables '12 Button Rows'. Disable to use '22 Button Rows' instead."] = true
L["Bottom ActionBar Rows"] = true
L["Third row is shown only if '12 Button Rows' are Enabled and 'Side ActionBars' are Disabled."] = true
L["Side ActionBars"] = true
L["Enables 6x2 ActionBar on both sides of the bottom ActionBar(s)."] = true
L["Middle Bar"] = true
L["Enables extra ActionBar in the middle of the screen."] = true
L["Middle Bar X-Offset"] = true
L["Horizontal offset for 'Middle Bar'."] = true
L["Middle Bar Y-Offset"] = true
L["Vertical offset for 'Middle Bar'."] = true

-- modules\bags
L["Stack items in bank"] = true
L["Hold Shift:"] = true
L["Stack items to bags"] = true
L["Stack items in bags"] = true
L["Stack items to bank"] = true

-- modules\chat
L["Right Timestamps"] = true
L["Set timestamps to the right side of the ChatFrame on the RightChatPanel"] = true

-- modules\datatexts
L["Datatexts"] = true
--L["Bottom Gradient Datatexts"] = true
L["Use the ElvUI's own %s -> %s to config DataTexts!"] = true -- L["DataTexts"], L["Panels"]

-- Iterator
--[[
L["SynesLeftDataText"] = "Left Chat Datatexts"
L["SynesRightDataText"] = "Right Chat Datatexts"
for i = 1, 8 do
	L["SynesDataText"..i] = format("Bottom Datatext %d", i)
end
]]

-- modules\misc
L["Threat on current target:"] = true
L["Undress"] = true

-- modules\unitframes
L["LOW MANA"] = true
L["UnitFrames"] = true
L["Low Mana Threshold"] = true
L["Percentage of Mana at which point the flashing 'Low Mana'-text appears on Player unit frame."] = true
L["Combat Feedback Text (*)"] = true
L["Enables 'Combat Feedback Text' on Player and Target unit frames."] = true
L["Role Icons"] = true
L["Enables 'ElvUI Role Icons' instead of 'Syne's Edit Role Colors' on unit frames."] = true
L["Alt-style on Target Auras"] = true
L["Enables 'Alternative-style' on Target unit frame auras."] = true
L["\n\n(*) Requires reloading of the UI for changes to take effect!"] = true
L["Cast bars"] = true
L["Cast bar-layout"] = true
L["Embed/Detach Player and Target cast bars to/from unit frames."] = true
L["Embedded cast bars"] = true
L["Detached cast bars"] = true
L["Player cast bar anchor-point"] = true
L["Anchor point for detached Player cast bar."] = true
L["Center"] = true
L["Top"] = true
L["Top Left"] = true
L["Top Right"] = true
L["Bottom"] = true
L["Bottom Left"] = true
L["Bottom Right"] = true
L["Left"] = true
L["Right"] = true
L["Player cast bar X-Offset"] = true
L["Horizontal offset for detached Player cast bar."] = true
L["Player cast bar Y-Offset"] = true
L["Vertical offset for detached Player cast bar."] = true
L["Target cast bar anchor-point"] = true
L["Anchor point for detached Target cast bar."] = true
L["Target cast bar X-Offset"] = true
L["Horizontal offset for detached Target cast bar."] = true
L["Target cast bar Y-Offset"] = true
L["Vertical offset for detached Target cast bar."] = true
L["Raid Healer-layout"] = true
L["These settings affect only the Healer-layout!"] = true
L["Grid only -mode"] = true
L["Replace Party frames with Raid grid in all group modes and sizes."] = true
L["Grid scale"] = true
L["Size scaling factor for Raid grid."] = true
L["Layout User-config"] = true
L["%s uses hardcoded settings for group unit frames settings and positioning on layout changes. You can still have almost full control over these features by having your own user-config in these editboxes. On layout change %s will evaluate the content of the selected layouts editbox after applying the hardcoded changes first."] = true -- SY.title, SY.title
L["Remember, the layout changes only affects parts of the %s, %s, %s and %s unit frames settings of the UI. All other changes you made to the UI with ElvUI-config won't be touched when changing layouts and can be omitted from these editboxes!"] = true -- SY:ColorStr(L["Party"]), SY:ColorStr(L["Raid"]), SY:ColorStr(L["Raid-40"]), SY:ColorStr(L["Raid Pet"])
L["Party"] = true
L["Raid"] = true
L["Raid-40"] = true
L["Raid Pet"] = true
L["Tank/DPS-layout"] = true
L["These changes are applied to the Tank/DPS-layout after hardcoded settings has been applied."] = true
L["Healer-layout"] = true
L["These changes are applied to the Healer-layout after hardcoded settings has been applied."] = true
L["User-configurations validate:"] = true
L["OK"] = true
L["ERROR"] = true
L["HOWTO"] = true
L["SY_USERCONFIG_HELP"] = "%s Edit the UI to your liking through 'UnitFrames'-section under ElvUI-config.\n%s Go to 'Profiles'-section under ElvUI-config, export your profile in 'Plugin'-format.\n%s Find the parts you changed and paste them to the right layout's editbox.\n%s If you want to reposition frames, use %s-function with the frame's Mover.\n     %s Use it like %s-method with Mover's global name added as first argument.\n%s Reapply the layout with slash-command to confirm the wanted results.\n%s Repeat from the beginning if needed." -- SY:ColorStr("1."), SY:ColorStr("2."), SY:ColorStr("3."), SY:ColorStr("4."), SY:ColorStr("SY:SetMoverPosition()"), SY:ColorStr(L["Tip:"]), SY:ColorStr(":SetPoint()"), SY:ColorStr("5."), SY:ColorStr("6.")
L["Tip:"] = true
L["Example:"] = true
L["Healer-layout user-config"] = true
L["Healer-layout user-config doesn't validate, skipping..."] = true
L["Healer-layout enabled (%s to switch back to Tank/DPS-layout)"] = true -- SY:ColorStr("/dps")
L["Tank/DPS-layout user-config"] = true
L["Tank/DPS-layout user-config doesn't validate, skipping..."] = true
L["Tank/DPS-layout enabled (%s to switch back to Healer-layout)"] = true -- SY:ColorStr("/heal")