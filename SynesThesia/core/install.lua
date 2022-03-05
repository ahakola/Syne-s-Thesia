--[[--------------------------------------------------------------------
--	Syne's Thesia, an ElvUI edit by ahak @ tukui.org
--
--	This file contains the installation script.
--	It is a modified version of the installation script found in ElvUI.
--	Only necessary installation choices are kept:
--		- Cvars
--		- Chat
--		- Layout: Tank/Healer/Caster DPS/Physical DPS
--
--	Everything else will need to be configured manually if the user
--	is not satisfied with the default settings set in this edit.
--------------------------------------------------------------------]]--
local E, L, V, P, G, _ = unpack(ElvUI) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local CH = E:GetModule("Chat")
local DT = E:GetModule("DataTexts")
local SY = E:GetModule("SynesThesia")

--Cache global variables
--Lua functions
local _G = _G
local unpack = unpack
local format = string.format
--WoW API / Variables
local CreateFrame = CreateFrame
local SetCVar = SetCVar
local GetCVarBool = GetCVarBool
local StopMusic = StopMusic
local PlayMusic = PlayMusic
local PlaySoundFile = PlaySoundFile
local ReloadUI = ReloadUI
local IsAddOnLoaded = IsAddOnLoaded
local FCF_ResetChatWindows = FCF_ResetChatWindows
local FCF_SetLocked = FCF_SetLocked
local FCF_DockFrame = FCF_DockFrame
local FCF_OpenNewWindow = FCF_OpenNewWindow
local FCF_GetChatWindowInfo = FCF_GetChatWindowInfo
local FCF_SavePositionAndDimensions = FCF_SavePositionAndDimensions
local FCF_StopDragging = FCF_StopDragging
local FCF_SetChatWindowFontSize = FCF_SetChatWindowFontSize
local FCF_SetWindowName = FCF_SetWindowName
local ChatFrame_RemoveMessageGroup = ChatFrame_RemoveMessageGroup
local ChatFrame_RemoveAllMessageGroups = ChatFrame_RemoveAllMessageGroups
local ChatFrame_AddMessageGroup = ChatFrame_AddMessageGroup
local ToggleChatColorNamesByClassGroup = ToggleChatColorNamesByClassGroup
local LOOT = LOOT
local CONTINUE = CONTINUE
local PREVIOUS = PREVIOUS
local GUILD_EVENT_LOG = GUILD_EVENT_LOG
local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

--Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS: ChatFrame1, ChatFrame2, ChatFrame3, ChatFrame4, ChatFrame5, ChatFrame6,
-- GLOBALS: LeftChatToggleButton, RightChatToggleButton, PluginInstallStepComplete
-- GLOBALS: ElvUF_PlayerMover, ElvUF_PetMover, ElvUF_TargetMover, ElvUF_TargetTargetMover
-- GLOBALS: ElvUF_FocusMover, Minimap, ElvUIPlayerDebuffs, ElvUI_Bar1, LeftChatPanel
-- GLOBALS: BossButton, AltPowerBarMover, BossHeaderMover, ClassBarMover, UIFrameFadeOut
-- GLOBALS: DBM, DBM_AllSavedOptions, DBT_AllPersistentOptions, SkadaDB, MSBTProfiles_SavedVars
-- GLOBALS: MikSBT, ElvUIParent, PluginInstallFrame, AddOnSkins

local CURRENT_PAGE = 0
local MAX_PAGE = 8

local function SetupChat()
	-- Original Syne's Edit had 3rd tab on LeftChat and it was called 'Spam' containing channels 'LookingForGroup' and 'GuildRecruitment' (which doesn't exist anymore?).
	-- 'Loot' was the 4th tab, but we skip the spam alltogether since those channels aren't relevant anymore and put 'Loot / Trade' in 3rd tab instead.
	-- In 9.0 VoiceChat or TTS (?) takes over ChatFrame3 so we need to put the 'Loot / Trade' back to Chatframe4?
	FCF_ResetChatWindows()
	FCF_SetLocked(_G.ChatFrame1, 1)
	FCF_DockFrame(_G.ChatFrame2)
	FCF_SetLocked(_G.ChatFrame2, 1)

	FCF_OpenNewWindow(LOOT)
	FCF_UnDockFrame(_G.ChatFrame4)
	FCF_SetLocked(_G.ChatFrame4, 1)
	ChatFrame4:Show()

	-- Set up the General chat frame to filter out stuff shown in the Loot chat frame
	ChatFrame_RemoveChannel(_G.ChatFrame1, "Trade")
	ChatFrame_RemoveMessageGroup(_G.ChatFrame1, "COMBAT_XP_GAIN")
	ChatFrame_RemoveMessageGroup(_G.ChatFrame1, "COMBAT_HONOR_GAIN")
	ChatFrame_RemoveMessageGroup(_G.ChatFrame1, "COMBAT_FACTION_CHANGE")
	ChatFrame_RemoveMessageGroup(_G.ChatFrame1, "SKILL")
	ChatFrame_RemoveMessageGroup(_G.ChatFrame1, "LOOT")
	ChatFrame_RemoveMessageGroup(_G.ChatFrame1, "CURRENCY")
	ChatFrame_RemoveMessageGroup(_G.ChatFrame1, "MONEY")

	-- Set up the Loot chat frame
	ChatFrame_RemoveAllMessageGroups(_G.ChatFrame4)
	ChatFrame_AddChannel(_G.ChatFrame4, "Trade")
	ChatFrame_AddMessageGroup(_G.ChatFrame4, "COMBAT_XP_GAIN")
	ChatFrame_AddMessageGroup(_G.ChatFrame4, "COMBAT_HONOR_GAIN")
	ChatFrame_AddMessageGroup(_G.ChatFrame4, "COMBAT_FACTION_CHANGE")
	ChatFrame_AddMessageGroup(_G.ChatFrame4, "SKILL")
	ChatFrame_AddMessageGroup(_G.ChatFrame4, "LOOT")
	ChatFrame_AddMessageGroup(_G.ChatFrame4, "CURRENCY")
	ChatFrame_AddMessageGroup(_G.ChatFrame4, "MONEY")

	-- Enable classcolor automatically on login and on each character without doing /configure each time.
	ToggleChatColorNamesByClassGroup(true, "SAY")
	ToggleChatColorNamesByClassGroup(true, "EMOTE")
	ToggleChatColorNamesByClassGroup(true, "YELL")
	ToggleChatColorNamesByClassGroup(true, "GUILD")
	ToggleChatColorNamesByClassGroup(true, "OFFICER")
	ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "WHISPER")
	ToggleChatColorNamesByClassGroup(true, "PARTY")
	ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID")
	ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND_LEADER")   
	ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT")
	ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT_LEADER")  
	ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL5")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL6")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL7")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL8")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL9")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL10")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL11")

	if E.Chat then
		--E.Chat:PositionChat(true)
		E.Chat:PositionChats()
		if E.db["RightChatPanelFaded"] then
			RightChatToggleButton:Click()
		end

		if E.db["LeftChatPanelFaded"] then
			LeftChatToggleButton:Click()
		end
	end

	--for i = 1, NUM_CHAT_WINDOWS do
	--	local frame = _G[format("ChatFrame%s", i)]
	for _, name in ipairs(_G.CHAT_FRAMES) do
		local frame = _G[name]
		local chatFrameId = frame:GetID()
		local chatName = FCF_GetChatWindowInfo(chatFrameId)

		CH:FCFTab_UpdateColors(CH:GetTab(_G[name]))

		-- move general bottom left
		if chatFrameId == 1 then
			frame:ClearAllPoints()
			if LeftChat then
				frame:SetPoint("BOTTOMLEFT", LeftChat, "BOTTOMLEFT", E:Scale(4), 0)
				frame:SetPoint("TOPRIGHT", LeftChat, "TOPRIGHT", E:Scale(-4), 0)
			else
				frame:Point("BOTTOMLEFT", _G.LeftChatToggleButton, "TOPLEFT", 1, 3)
			end
		elseif chatFrameId == 3 then
			VoiceTranscriptionFrame_UpdateVisibility(frame)
			VoiceTranscriptionFrame_UpdateVoiceTab(frame)
			VoiceTranscriptionFrame_UpdateEditBox(frame)
		elseif chatFrameId == 4 then
			frame:ClearAllPoints()
			if RightChat then
				frame:SetPoint("BOTTOMLEFT", RightChat, "BOTTOMLEFT", E:Scale(4), 0)
				frame:SetPoint("TOPRIGHT", RightChat, "TOPRIGHT", E:Scale(-4), 0)
			else
				frame:Point("BOTTOMLEFT", _G.RightChatDataPanel, "TOPLEFT", 1, 3)
			end
		end

		FCF_SavePositionAndDimensions(frame)
		FCF_StopDragging(frame)

		-- set default Elvui font size
		--FCF_SetChatWindowFontSize(nil, frame, 12)
		FCF_SetChatWindowFontSize(nil, frame, 13)

		-- rename chat windows
		if chatFrameId == 1 then
			FCF_SetWindowName(frame, GENERAL)
		elseif chatFrameId == 2 then
			FCF_SetWindowName(frame, GUILD_EVENT_LOG)
		elseif chatFrameId == 4 then
			FCF_SetWindowName(frame, LOOT.." / "..TRADE)
		end
	end

	SY:SetMoverPosition("BNETMover", "BOTTOMLEFT", LeftChatPanel, "TOPLEFT", E:Scale(10), E:Scale(5))
	SY:SetMoverPosition("TooltipMover", "BOTTOMRIGHT", RightChatPanel, "TOPRIGHT", E:Scale(-9), E:Scale(-33))

	PluginInstallStepComplete.message = L["Chat Set"]
	PluginInstallStepComplete:Show()
end

local function SetupCVars()
	-- Some new stuff
	SetCVar("ActionButtonUseKeyDown", 1)
	SetCVar("autoLootDefault", 0)
	SetCVar("bloatnameplates", 0)
	SetCVar("deselectOnClick", 1)
	SetCVar("interactOnLeftClick", 0)
	SetCVar("nameplateShowFriendlyNPCs", 1)
	SetCVar("showTimestamps", "%H:%M ")
	SetCVar("UnitNameGuildTitle", 0)

	-- Original Syne's Edit
	SetCVar("buffDurations", 1)
	SetCVar("consolidateBuffs", 0)
	SetCVar("lootUnderMouse", 0) -- altered to 0 from 1
	SetCVar("autoSelfCast", 1)
	SetCVar("mapQuestDifficulty", 1)
	SetCVar("scriptErrors", 1)
	SetCVar("nameplateShowFriends", 0)
	SetCVar("nameplateShowFriendlyPets", 0)
	SetCVar("nameplateShowFriendlyGuardians", 0)
	SetCVar("nameplateShowFriendlyTotems", 0)
	SetCVar("nameplateShowEnemies", 1)
	SetCVar("nameplateShowEnemyPets", 1)
	SetCVar("nameplateShowEnemyGuardians", 1)
	SetCVar("nameplateShowEnemyTotems", 1)
	SetCVar("ShowClassColorInNameplate", 1)
	SetCVar("screenshotQuality", 10) -- altered to 10 from 8
	-- This next one is removed in Legion 7.0
	--SetCVar("cameraDistanceMax", 50)
	-- This one was renamed in Legion 7.1
	--SetCVar("cameraDistanceMaxFactor", 4) -- altered to 4 from 3.4
	-- This is the new since Legion 7.1
	SetCVar("cameraDistanceMaxZoomFactor", 2.6) -- Range 1 - 2.6
	SetCVar("chatMouseScroll", 1)
	SetCVar("chatStyle", "classic") -- altered to "classic" from "im"
	SetCVar("WholeChatWindowClickable", 0)
	SetCVar("ConversationMode", "inline")
	SetCVar("CombatDamage", 1)
	SetCVar("CombatHealing", 1)
	SetCVar("showTutorials", 0)
	SetCVar("showNewbieTips", 0)
	SetCVar("Maxfps", 120)
	SetCVar("autoDismountFlying", 1)
	SetCVar("autoQuestWatch", 1)
	SetCVar("autoQuestProgress", 1)
	SetCVar("showLootSpam", 1)
	SetCVar("guildMemberNotify", 1) -- 0
	SetCVar("chatBubblesParty", 1) -- 0
	SetCVar("chatBubbles", 1) -- 0
	SetCVar("UnitNameOwn", 0) -- 1
	SetCVar("UnitNameNPC", 0)
	SetCVar("UnitNameNonCombatCreatureName", 0)
	SetCVar("UnitNamePlayerGuild", 1)
	SetCVar("UnitNamePlayerPVPTitle", 1)
	SetCVar("UnitNameFriendlyPlayerName", 0)
	SetCVar("UnitNameFriendlyPetName", 0)
	SetCVar("UnitNameFriendlyGuardianName", 0) -- 1
	SetCVar("UnitNameFriendlyTotemName", 0)
	SetCVar("UnitNameEnemyPlayerName", 1)
	SetCVar("UnitNameEnemyPetName", 1)
	SetCVar("UnitNameEnemyGuardianName", 1)
	SetCVar("UnitNameEnemyTotemName", 1)
	SetCVar("UberTooltips", 1)
	SetCVar("removeChatDelay", 1)
	SetCVar("showVKeyCastbar", 1)
	SetCVar("colorblindMode", 0)
	SetCVar("bloatthreat", 0)
	SetCVar("bloattest", 0)
	SetCVar("showArenaEnemyFrames", 0)

	PluginInstallStepComplete.message = L["CVars Set"]
	PluginInstallStepComplete:Show()
end

local function SetupColors(theme) -- classic, default (aka dark), class
	local classColor = E.myclass == "PRIEST" and E.PriestColors or RAID_CLASS_COLORS[E.myclass]

	E.private.theme = theme
	--E.db.SY.general.darkTheme = (theme == "default")

	-- Per Theme Settings
	--if E.db.SY.general.darkTheme then
	if theme == "default" then -- Dark
		-- General
		E.db.general.bordercolor = E:GetColor(.2, .2, .2)
		E.db.general.backdropcolor = E:GetColor(.02, .02, .02)
		E.db.general.backdropfadecolor = E:GetColor(.02, .02, .02, .8)

		-- Unitframe
		E.db.unitframe.colors.health = E:GetColor(.1, .1, .1)
		E.db.unitframe.colors.borderColor = (E.PixelMode and E:GetColor(0, 0, 0) or E:GetColor(.1, .1, .1))
		E.db.unitframe.colors.auraBarBuff = E:GetColor(.1, .1, .1)
		E.db.unitframe.colors.castColor = E:GetColor(.1, .1, .1)
	elseif theme == "class" then -- Class
		-- General
		E.db.general.bordercolor = (E.PixelMode and E:GetColor(0, 0, 0) or E:GetColor(.3, .3, .3))
		E.db.general.backdropcolor = E:GetColor(.1, .1, .1)
		E.db.general.backdropfadecolor = E:GetColor(.06, .06, .06, .8)

		-- Unitframe
		E.db.unitframe.colors.borderColor = (E.PixelMode and E:GetColor(0, 0, 0) or E:GetColor(.3, .3, .3))
		E.db.unitframe.colors.auraBarBuff = E:GetColor(classColor.r, classColor.g, classColor.b)
	else -- Classic
		-- General
		E.db.general.bordercolor = (E.PixelMode and E:GetColor(0, 0, 0) or E:GetColor(.3, .3, .3))
		E.db.general.backdropcolor = E:GetColor(.1, .1, .1)
		E.db.general.backdropfadecolor = E:GetColor(0.13, 0.13, 0.13, 0.69)

		-- Unitframe
		E.db.unitframe.colors.health = E:GetColor(.3, .3, .3)
		E.db.unitframe.colors.borderColor = (E.PixelMode and E:GetColor(0, 0, 0) or E:GetColor(.3, .3, .3))
		E.db.unitframe.colors.auraBarBuff = E:GetColor(.3, .3, .3)
		E.db.unitframe.colors.castColor = E:GetColor(.3, .3, .3)
	end

	-- Shared Theme Settings
	-- Unitframe
	E.db.unitframe.colors.colorhealthbyvalue = false
	E.db.unitframe.colors.healthclass = (theme == "class")
	E.db.unitframe.colors.transparentHealth = false
	E.db.unitframe.colors.customhealthbackdrop = true
	E.db.unitframe.colors.health_backdrop = { r = .1, g = .1, b = .1 }
	E.db.unitframe.colors.disconnected = { r = .84, g = .75, b = .65 }

	E.db.unitframe.colors.powerclass = false

	E.db.unitframe.colors.castClassColor = (theme == "class")

	-- Value Color
	if theme == "class" then
		E.db.general.valuecolor = E:GetColor(classColor.r, classColor.b, classColor.g)
	else
		E.db.general.valuecolor = { r = 0, g = 179/255, b = 1 }
		--E.db.general.valuecolor = { r = 254/255, g = 123/255, b = 44/255 }
		--E.db.general.valuecolor = { r = 0, g = .8, b = 1, a = 1 }
		--E.db.general.valuecolor = { r = 0, g = 1, b = 0, a = 1 }
	end

	E:UpdateStart(true, true)
end

local function classBarMover()
	SY:SetMoverPosition("ClassBarMover", "BOTTOM", ElvUF_PlayerMover, "TOP", 0, -1) -- -1 to overlap borders to prevent double-border
end
local function altPowerBarMover()
	SY:SetMoverPosition("AltPowerBarMover", "TOP", E.UIParent, "TOP", 0, -32)
end
local function petBattleActionBarMover()
	ElvUIPetBattleActionBar:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, 48)
end

local function SetGroupUnitframePositions(layout)
	--Party / Raid / Raid40
	if layout == "healer" then
		--Party
		SY:SetMoverPosition("ElvUF_PartyMover", "TOPLEFT", E.UIParent, "TOPLEFT", 300, -300)
		SY:SetMoverPosition("ElvUF_RaidpetMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 20, 310) -- Should be BOTTOMLEFT, ChatLineLeft1, TOPLEFT, 20, 30

		--Raid
		SY:SetMoverPosition("ElvUF_RaidMover", "TOPLEFT", E.UIParent, "TOPLEFT", 20,-250)
	else
		--Party
		SY:SetMoverPosition("ElvUF_PartyMover", "TOPLEFT", E.UIParent, "TOPLEFT", 15, -399)
		SY:SetMoverPosition("ElvUF_RaidpetMover", "TOPLEFT", ElvUF_PartyMover, "BOTTOMLEFT", 0, -10)

		--Raid
		--SY:SetMoverPosition("ElvUF_RaidMover", "TOPLEFT", E.UIParent, "TOPLEFT", 20, -350) -- Original
		--SY:SetMoverPosition("ElvUF_RaidMover", "TOPLEFT", E.UIParent, "TOPLEFT", 20, -60) -- For 6 groups
		SY:SetMoverPosition("ElvUF_RaidMover", "TOPLEFT", E.UIParent, "TOPLEFT", 20, -150) -- For 5 groups

		--Raid40
		SY:SetMoverPosition("ElvUF_Raid40Mover", "TOPLEFT", E.UIParent, "TOPLEFT", 15, -20)
	end
end

local function SetPositions(layout)
	E:ResetMovers("")
	E.db["movers"] = E.db["movers"] or {}

	-- Chat
		--SY:SetMoverPosition("LeftChatMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 2, 81)
		--SY:SetMoverPosition("RightChatMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -2, 81)
		SY:SetMoverPosition("LeftChatMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 0, 90)
		SY:SetMoverPosition("RightChatMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", 0, 90)

	-- Actionbars
		SY:SetMoverPosition("ElvAB_1", "BOTTOM", E.UIParent, "BOTTOM", 0, 48)
		SY:SetMoverPosition("ElvAB_2", "BOTTOM", ElvUI_Bar1, "TOP", 0, 4)
		SY:SetMoverPosition("ElvAB_3", "BOTTOMRIGHT", ElvUI_Bar1, "BOTTOMLEFT", -12, 0)
		SY:SetMoverPosition("ElvAB_4", "BOTTOMLEFT", ElvUI_Bar1, "BOTTOMRIGHT", 12, 0)
		SY:SetMoverPosition("ElvAB_5", "RIGHT", E.UIParent, "RIGHT", -4, 0)
		SY:SetMoverPosition("ElvAB_6", "CENTER", E.UIParent, "CENTER", 150, -50)
		SY:SetMoverPosition("PetAB", "BOTTOM", E.UIParent, "BOTTOM", 0, 134) -- BOTTOM, BottomLine2, TOP, 0, 3
		SY:SetMoverPosition("ShiftAB", "TOPRIGHT", E.UIParent, "BOTTOMRIGHT", -10, 49) -- TOPRIGHT, ChatLineRight2, "BOTTOMRIGHT", -10, -5
		--SY:SetMoverPosition("TotemBarMover", "TOPRIGHT", E.UIParent, "BOTTOMRIGHT", -10, 39) -- This parents to ShiftAB mover in Syne's Edit
		SY:SetMoverPosition("TotemBarMover", "TOPRIGHT", E.UIParent, "BOTTOMRIGHT", -6, 53) -- This was 4px off to the left and 4px off to the bottom
		SY:SetMoverPosition("VehicleLeaveButton", "BOTTOM", E.UIParent, "BOTTOM", 0, 162) -- BOTTOM, BottomLine2, TOP, 0, 35
		if ElvUIPetBattleActionBar then
			ElvUIPetBattleActionBar:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, 48)
		else
			SY:ScheduleTimer(petBattleActionBarMover, 1)
		end

	-- Unitframes
		--Solo
		SY:SetMoverPosition("ElvUF_PlayerMover", "BOTTOMRIGHT", E.UIParent, "BOTTOM", -70, 217) -- BOTTOMRIGHT, BottomLine2, TOP, -70, 86
		SY:SetMoverPosition("ElvUF_FocusMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 217) -- BOTTOM, BottomLine2, TOP, 0, 86
		SY:SetMoverPosition("ElvUF_TargetMover", "BOTTOMLEFT", E.UIParent, "BOTTOM", 70, 217) -- BOTTOMLEFT, BottomLine2, TOP, 70, 86
		SY:SetMoverPosition("ElvUF_TargetTargetMover", "TOP", ElvUF_TargetMover, "BOTTOMRIGHT", 0, -30)
		SY:SetMoverPosition("ElvUF_PetMover", "TOP", ElvUF_PlayerMover, "BOTTOMLEFT", 0, -30)
		SY:SetMoverPosition("ElvUF_FocusTargetMover", "BOTTOM", ElvUF_FocusMover, "TOP", 0, 65)

		--Party / Raid / Raid40
		SetGroupUnitframePositions(layout)

		--Classbar and Altbar
		-- Setting this up, incase user detaches the bar from UF
		if not ClassBarMover then
			SY:ScheduleTimer(classBarMover, 1)
		else
			SY:SetMoverPosition("ClassBarMover", "BOTTOM", ElvUF_PlayerMover, "TOP", 0, -1) -- -1 to overlap borders to prevent double-border
		end
		if not AltPowerBarMover then
			SY:ScheduleTimer(altPowerBarMover, 1)
		else
			SY:SetMoverPosition("AltPowerBarMover", "TOP", E.UIParent, "TOP", 0, -32)
		end

		--Castbars
		if E.db.SY.unitframes.castbarlayout == 1 then -- Castbars inside Unitframe
			SY:SetMoverPosition("ElvUF_PlayerCastbarMover", "BOTTOMRIGHT", E.UIParent, "BOTTOM", -70, 224)
			SY:SetMoverPosition("ElvUF_TargetCastbarMover", "BOTTOMLEFT", E.UIParent, "BOTTOM", 70, 224)
		else -- Separate castbars
			SY:SetMoverPosition("ElvUF_PlayerCastbarMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 353)
			SY:SetMoverPosition("ElvUF_TargetCastbarMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 384)
		end

		SY:SetMoverPosition("ElvUF_FocusCastbarMover", "CENTER", E.UIParent, "CENTER", 0, 250)

		SY:SetMoverPosition("ElvUF_PetCastbarMover", "TOP", ElvUF_PlayerMover, "BOTTOMLEFT", 0, -43)

		--Arena
		SY:SetMoverPosition("ArenaHeaderMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -300, -300)

		--Boss
		SY:SetMoverPosition("BossHeaderMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -300, -300)

	--ObjectiveFrame
		local objectiveFrameYOffset = -10
		local buttonSize = E.db.actionbar.bar1.buttonsize or 32
		local buttonSpacing = E.db.actionbar.bar1.buttonspacing or 4
		if E.db.actionbar.bar6.enabled then
			--SY:SetMoverPosition("ObjectiveFrameMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -90, -300) -- -208)
			objectiveFrameYOffset = -((buttonSize * 2) + (buttonSpacing * (2 + 1)) + E:Scale(14))
		elseif E.db.actionbar.bar5.enabled then
			--SY:SetMoverPosition("ObjectiveFrameMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -54, -300) -- -208)
			objectiveFrameYOffset = -((buttonSize * 1) + (buttonSpacing * (1 + 1)) + E:Scale(14))
		else
			--SY:SetMoverPosition("ObjectiveFrameMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -10, -300) -- -208)
			objectiveFrameYOffset = E:Scale(-10)
		end
		-- Frame is 235px wide, Mover is only 130px wide... You need extra margin of 52,5px
		SY:SetMoverPosition("ObjectiveFrameMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", (objectiveFrameYOffset - 53), E:Scale(-260)) -- -208)

	--Durability
		SY:SetMoverPosition("DurabilityFrameMover", "BOTTOM", E.UIParent, "BOTTOM", 0, E:Scale(200))
		--[[
		if TukuiCF["actionbar"].bottomrows == true then
			self:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, TukuiDB.Scale(228))
		else
			self:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, TukuiDB.Scale(200))
		end
		]]

	--VehicleSeat
		SY:SetMoverPosition("VehicleSeatMover", "BOTTOM", E.UIParent, "BOTTOM", 0, E:Scale(200))
		--[[
		if TukuiCF["actionbar"].bottomrows == true then
			VehicleSeatIndicator:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, TukuiDB.Scale(228))
		else
			VehicleSeatIndicator:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, TukuiDB.Scale(200))
		end
		]]

	--CaptureBar, what ever this is
		--[[
		captureBar:SetPoint("TOP", UIParent, "TOP", 0, TukuiDB.Scale(-120)
		]]

	--GM
		SY:SetMoverPosition("GMMover", "TOPLEFT", E.UIParent, "TOPLEFT", E:Scale(4), E:Scale(-4))
		--[[
		TicketStatusFrame:SetPoint("TOPLEFT", TukuiDB.Scale(4), TukuiDB.Scale(-4))
		]]

	--Buffs
		SY:SetMoverPosition("BuffsMover", "TOPRIGHT", Minimap, "TOPLEFT", E:Scale(-10), 0)

	--Debuffs
		SY:SetMoverPosition("DebuffsMover", "BOTTOMRIGHT", Minimap, "BOTTOMLEFT", E:Scale(-10), 0)

	--Tooltip
		-- FYI: tt:Point("BOTTOMRIGHT", TooltipMover, "TOPRIGHT", -1, 18)
		-- For some reason we still have to adjust the yOffset by -20 to get it to right position?
		--SY:SetMoverPosition("TooltipMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", E:Scale(-9), E:Scale(194))
		SY:SetMoverPosition("TooltipMover", "BOTTOMRIGHT", RightChatPanel, "TOPRIGHT", E:Scale(-9), E:Scale(-33))
		--[[
		self:SetPoint("BOTTOMRIGHT", ChatLineRight1, "TOPRIGHT", TukuiDB.Scale(-10), TukuiDB.Scale(5))
		]]

	--Bags
		-- These should be right because BottomLine1 has same width as WorldFrame
		SY:SetMoverPosition("ElvUIBankMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", E:Scale(13), E:Scale(44))
		SY:SetMoverPosition("ElvUIBagMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", E:Scale(-13), E:Scale(44))
		--[[
		-- Bank
		f:SetPoint("BOTTOMLEFT", BottomLine1, "TOPLEFT", TukuiDB.Scale(13), TukuiDB.Scale(7))
		-- Backbag
		f:SetPoint("BOTTOMRIGHT", BottomLine1, "TOPRIGHT", TukuiDB.Scale(-13), TukuiDB.Scale(7))
		]]

	--Loot
		SY:SetMoverPosition("LootFrameMover", "TOPLEFT", E.UIParent, "TOPLEFT", E:Scale(10), E:Scale(-104)) -- This is supposed to be (0, -104), but I think this one looks slightly better

	--Roll
		-- In Syne's Edit these grow up, but in ElvUI if you position them at top half of the screen.
		-- I'm trying to reverse the order, but if this isn't what it is supposed to be, then I failed... At least for now.
		SY:SetMoverPosition("AlertFrameMover", "CENTER", E.UIParent, "CENTER", 0, E:Scale(-200))

	--Minimap
		-- Syne's Edit takes extra -2px per offset for border. In ElvUI we can ignore that.
		SY:SetMoverPosition("MinimapMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", E:Scale(-10), E:Scale(-10))

	--BNToast
		--SY:SetMoverPosition("BNETMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", E:Scale(10), E:Scale(232))
		SY:SetMoverPosition("BNETMover", "BOTTOMLEFT", LeftChatPanel, "TOPLEFT", E:Scale(10), E:Scale(5))

	--MirrorTimers
		-- Just set MirrorTimer1 and others should attach to it?
		SY:SetMoverPosition("MirrorTimer1Mover", "TOP", E.UIParent, "TOP", 0, -96)
		--[[
		["BREATH"] = "TOP#UIParent#TOP#0#-96"
		["EXHAUSTION"] = "TOP#UIParent#TOP#0#-119"
		["FEIGNDEATH"] = "TOP#UIParent#TOP#0#-142"
		]]

	--PowerBars
		SY:SetMoverPosition("PlayerPowerBarMover", "TOP", E.UIParent, "TOP", 0, -32)
		SY:SetMoverPosition("TargetPowerBarMover", "TOP", E.UIParent, "TOP", 0, -62)

	--BossButton
		-- Zone Ability Button should attach to this?
		SY:SetMoverPosition("BossButton", "BOTTOMRIGHT", ElvUF_PlayerMover, "BOTTOMLEFT", E:Scale(-75), 0)
		-- This didn't exist in Syne's Edit afaik...

	--DigSiteProgressBar
		SY:SetMoverPosition("DigSiteProgressBarMover", "TOP", E.UIParent, "TOP", 0, -400)
		-- This didn't exist in Syne's Edit afaik...
	
	--TalkingHeadFrame
		SY:SetMoverPosition("TalkingHeadFrameMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 373) --265)
		-- This didn't exist in Syne's Edit for 100% sure!

	--Databars
		SY:SetMoverPosition("AzeriteBarMover", "TOP", Minimap, "BOTTOM", 0, 0)
		SY:SetMoverPosition("ReputationBarMover", "TOP", Minimap, "BOTTOM", 0, -11)
		SY:SetMoverPosition("HonorBarMover", "TOP", Minimap, "BOTTOM", 0, -22)
		SY:SetMoverPosition("ExperienceBarMover", "TOP", Minimap, "BOTTOM", 0, -33)

		SY:SetMoverPosition("ThreatBarMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 34) -- 34 for 6px size, 35 for 8px size

	--DataTexts
		SY:SetMoverPosition("DTPanelSynesBottomGradientDataTextMover", "BOTTOM", E.UIParent, "BOTTOM", 0, 8)
		SY:SetMoverPosition("DTPanelSynesLeftDataTextMover", "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 34, 60) -- x = (368 - 300) / 2
		SY:SetMoverPosition("DTPanelSynesRightDataTextMover", "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -34, 60) -- x = -(368 - 300) / 2

	--Below Minimap Container
		SY:SetMoverPosition("BelowMinimapContainerMover", "TOPRIGHT", E.UIParent, "TOPRIGHT", -40, -260)
end

function SY.HealLayout(layout)
	--Party
		E.db.unitframe.units.party.enable = true
		E.db.unitframe.units.party.width = 230
		E.db.unitframe.units.party.height = 35
		E.db.unitframe.units.party.growthDirection = "DOWN_LEFT"
		E.db.unitframe.units.party.numGroups = 1
		E.db.unitframe.units.party.groupsPerRowCol = 1
		E.db.unitframe.units.party.verticalSpacing = 25
		E.db.unitframe.units.party.showPlayer = true
		E.db.unitframe.units.party.visibility = "[@raid6,exists][nogroup] hide;show"

		E.db.unitframe.units.party.classbar.enabled = true
		E.db.unitframe.units.party.classbar.height = 10
		E.db.unitframe.units.party.classbar.width = "fill"

		E.db.unitframe.units.party.buffs.enable = true
		E.db.unitframe.units.party.buffs.perrow = 6
		E.db.unitframe.units.party.buffs.numrows = 1
		E.db.unitframe.units.party.buffs.sizeOverride = 22
		E.db.unitframe.units.party.buffs.xOffset = -4
		E.db.unitframe.units.party.buffs.yOffset = 0
		E.db.unitframe.units.party.buffs.spacing = 2
		E.db.unitframe.units.party.buffs.attachTo = "Frame"
		E.db.unitframe.units.party.buffs.anchorPoint = "LEFT"
		E.db.unitframe.units.party.buffs.maxDuration = 20

		E.db.unitframe.units.party.castbar.enable = false

		E.db.unitframe.units.party.debuffs.enable = true
		E.db.unitframe.units.party.debuffs.perrow = 5
		E.db.unitframe.units.party.debuffs.numrows = 1
		E.db.unitframe.units.party.debuffs.sizeOverride = 26
		E.db.unitframe.units.party.debuffs.xOffset = 4
		E.db.unitframe.units.party.debuffs.yOffset = 0
		E.db.unitframe.units.party.debuffs.spacing = 2
		E.db.unitframe.units.party.debuffs.attachTo = "Frame"
		E.db.unitframe.units.party.debuffs.anchorPoint = "RIGHT"

		E.db.unitframe.units.party.healPrediction.enable = true

		E.db.unitframe.units.party.health.attachTextTo = "InfoPanel"
		E.db.unitframe.units.party.health.position = "RIGHT"
		E.db.unitframe.units.party.health.xOffset = 4
		E.db.unitframe.units.party.health.yOffset = -13
		E.db.unitframe.units.party.health.text_format = "[healthcolor][health:current-percent]"

		E.db.unitframe.units.party.infoPanel.enable = true
		E.db.unitframe.units.party.infoPanel.height = 0

		E.db.unitframe.units.party.raidRoleIcons.enable = true
		E.db.unitframe.units.party.raidRoleIcons.position = "TOPLEFT"
		E.db.unitframe.units.party.raidRoleIcons.xOffset = 0
		E.db.unitframe.units.party.raidRoleIcons.yOffset = 0

		E.db.unitframe.units.party.name.position = "CENTER"
		E.db.unitframe.units.party.name.xOffset = 0
		E.db.unitframe.units.party.name.yOffset = -13
		E.db.unitframe.units.party.name.attachTextTo = "InfoPanel"
		E.db.unitframe.units.party.name.text_format = "[namecolor][name:long] [difficultycolor][level]"

		E.db.unitframe.units.party.petsGroup.enable = false

		E.db.unitframe.units.party.power.enable = true
		E.db.unitframe.units.party.power.width = "fill"
		E.db.unitframe.units.party.power.height = 10
		E.db.unitframe.units.party.power.attachTextTo = "InfoPanel"
		E.db.unitframe.units.party.power.position = "LEFT"
		E.db.unitframe.units.party.power.xOffset = 0
		E.db.unitframe.units.party.power.yOffset = -13
		E.db.unitframe.units.party.power.text_format = "[powercolor][power:current-percent]"

		E.db.unitframe.units.party.raidicon.enable = true
		E.db.unitframe.units.party.raidicon.size = 18
		E.db.unitframe.units.party.raidicon.attachTo = "TOP"
		E.db.unitframe.units.party.raidicon.attachToObject = "Frame"
		E.db.unitframe.units.party.raidicon.xOffset = 0
		E.db.unitframe.units.party.raidicon.yOffset = 9

		E.db.unitframe.units.party.readycheckIcon.enable = true
		E.db.unitframe.units.party.readycheckIcon.size = 12
		E.db.unitframe.units.party.readycheckIcon.attachTo = "Power"
		E.db.unitframe.units.party.readycheckIcon.position = "CENTER"
		E.db.unitframe.units.party.readycheckIcon.xOffset = 0
		E.db.unitframe.units.party.readycheckIcon.yOffset = 0

		E.db.unitframe.units.party.roleIcon.enable = true
		E.db.unitframe.units.party.roleIcon.position = "TOPRIGHT"
		E.db.unitframe.units.party.roleIcon.attachTo = "Frame"
		E.db.unitframe.units.party.roleIcon.xOffset = -2
		E.db.unitframe.units.party.roleIcon.yOffset = -2
		E.db.unitframe.units.party.roleIcon.size = 15
		E.db.unitframe.units.party.roleIcon.tank = true
		E.db.unitframe.units.party.roleIcon.healer = true
		E.db.unitframe.units.party.roleIcon.damager = true

	--Raid Pet (for Party)
		E.db.unitframe.units.raidpet.enable = false -- Disable this because it doesn't work as intended
		E.db.unitframe.units.raidpet.width = 75
		E.db.unitframe.units.raidpet.height = 22
		E.db.unitframe.units.raidpet.growthDirection = "LEFT_UP"
		E.db.unitframe.units.raidpet.numGroups = 1
		E.db.unitframe.units.raidpet.horizontalSpacing = 3
		E.db.unitframe.units.raidpet.visibility = "[@raid6,exists][nogroup] hide;show"

		E.db.unitframe.units.raidpet.buffIndicator.enable = true

		E.db.unitframe.units.raidpet.buffs.enable = false

		E.db.unitframe.units.raidpet.debuffs.enable = false

		E.db.unitframe.units.raidpet.healPrediction.enable = true

		E.db.unitframe.units.raidpet.health.text_format = ""

		E.db.unitframe.units.raidpet.name.position = "CENTER"
		E.db.unitframe.units.raidpet.name.xOffset = 0
		E.db.unitframe.units.raidpet.name.yOffset = 0
		E.db.unitframe.units.raidpet.name.attachTextTo = "Frame"
		E.db.unitframe.units.raidpet.name.text_format = "[namecolor][name:medium] [difficultycolor][level]"

		E.db.unitframe.units.raidpet.raidicon.enable = true
		E.db.unitframe.units.raidpet.raidicon.size = 18
		E.db.unitframe.units.raidpet.raidicon.attachTo = "TOP"
		E.db.unitframe.units.raidpet.raidicon.attachToObject = "Frame"
		E.db.unitframe.units.raidpet.raidicon.xOffset = 0
		E.db.unitframe.units.raidpet.raidicon.yOffset = 9

		E.db.unitframe.units.raidpet.rdebuffs.enable = false

	--Raid (Grid)
		E.db.unitframe.units.raid.enable = true
		E.db.unitframe.units.raid.width = 76*E.db.SY.unitframes.gridscale
		E.db.unitframe.units.raid.height = 38*E.db.SY.unitframes.gridscale
		E.db.unitframe.units.raid.growthDirection = "RIGHT_DOWN"
		E.db.unitframe.units.raid.numGroups = 8
		E.db.unitframe.units.raid.groupsPerRowCol = 1
		E.db.unitframe.units.raid.verticalSpacing = -3
		E.db.unitframe.units.raid.horizontalSpacing = 3
		E.db.unitframe.units.raid.groupSpacing = 6
		E.db.unitframe.units.raid.showPlayer = true
		E.db.unitframe.units.raid.visibility = "[@raid6,noexists][nogroup] hide;show"
		E.db.unitframe.units.raid.raidWideSorting = false --true
		E.db.unitframe.units.raid.startFromCenter = true

		E.db.unitframe.units.raid.classbar.enabled = true
		E.db.unitframe.units.raid.classbar.height = 6
		E.db.unitframe.units.raid.classbar.width = "fill"

		E.db.unitframe.units.raid.buffIndicator.enable = true

		E.db.unitframe.units.raid.buffs.enable = false

		E.db.unitframe.units.raid.debuffs.enable = false

		E.db.unitframe.units.raid.healPrediction.enable = true

		E.db.unitframe.units.raid.health.attachTextTo = "Health"
		E.db.unitframe.units.raid.health.position = "CENTER"
		E.db.unitframe.units.raid.health.xOffset = 0
		E.db.unitframe.units.raid.health.yOffset = 0
		E.db.unitframe.units.raid.health.text_format = "[health:deficit]" --"[health:current]"

		E.db.unitframe.units.raid.infoPanel.enable = true
		--E.db.unitframe.units.raid.infoPanel.height = 19
		E.db.unitframe.units.raid.infoPanel.height = 17 -- Make this smaller

		E.db.unitframe.units.raid.raidRoleIcons.enable = true
		E.db.unitframe.units.raid.raidRoleIcons.position = "TOPRIGHT"
		E.db.unitframe.units.raid.raidRoleIcons.xOffset = 0
		E.db.unitframe.units.raid.raidRoleIcons.yOffset = 0

		E.db.unitframe.units.raid.name.position = "CENTER"
		E.db.unitframe.units.raid.name.xOffset = 0
		E.db.unitframe.units.raid.name.yOffset = 0
		E.db.unitframe.units.raid.name.attachTextTo = "InfoPanel"
		E.db.unitframe.units.raid.name.text_format = "[namecolor][name:short]"

		E.db.unitframe.units.raid.power.enable = true
		E.db.unitframe.units.raid.power.width = "fill"
		E.db.unitframe.units.raid.power.height = 6
		E.db.unitframe.units.raid.power.text_format = ""

		E.db.unitframe.units.raid.raidicon.enable = true
		E.db.unitframe.units.raid.raidicon.size = 18*E.db.SY.unitframes.gridscale
		E.db.unitframe.units.raid.raidicon.attachTo = "TOP"
		E.db.unitframe.units.raid.raidicon.attachToObject = "Frame"
		E.db.unitframe.units.raid.raidicon.xOffset = 0
		E.db.unitframe.units.raid.raidicon.yOffset = 9*E.db.SY.unitframes.gridscale

		E.db.unitframe.units.raid.rdebuffs.enable = true
		E.db.unitframe.units.raid.rdebuffs.size = 22*E.db.SY.unitframes.gridscale
		E.db.unitframe.units.raid.rdebuffs.font = "BigNoodleTitling"
		E.db.unitframe.units.raid.rdebuffs.fontSize = 9*E.db.SY.unitframes.gridscale
		E.db.unitframe.units.raid.rdebuffs.fontOutline = "OUTLINE"
		E.db.unitframe.units.raid.rdebuffs.xOffset = 0
		E.db.unitframe.units.raid.rdebuffs.yOffset = 26*E.db.SY.unitframes.gridscale
		E.db.unitframe.units.raid.rdebuffs.stack.xOffset = 0
		E.db.unitframe.units.raid.rdebuffs.stack.yOffset = 2
		E.db.unitframe.units.raid.rdebuffs.stack.color = { r = 1, g = .9, b = 0 }

		E.db.unitframe.units.raid.readycheckIcon.enable = true
		E.db.unitframe.units.raid.readycheckIcon.size = 12
		E.db.unitframe.units.raid.readycheckIcon.attachTo = "Power"
		E.db.unitframe.units.raid.readycheckIcon.position = "CENTER"
		E.db.unitframe.units.raid.readycheckIcon.xOffset = 0
		E.db.unitframe.units.raid.readycheckIcon.yOffset = 0

		E.db.unitframe.units.raid.roleIcon.enable = false -- Setup this anyway, incase I change my mind...
		E.db.unitframe.units.raid.roleIcon.position = "TOPRIGHT"
		E.db.unitframe.units.raid.roleIcon.attachTo = "Frame"
		E.db.unitframe.units.raid.roleIcon.xOffset = -2
		E.db.unitframe.units.raid.roleIcon.yOffset = -2
		E.db.unitframe.units.raid.roleIcon.size = 12*E.db.SY.unitframes.gridscale
		E.db.unitframe.units.raid.roleIcon.tank = true
		E.db.unitframe.units.raid.roleIcon.healer = true
		E.db.unitframe.units.raid.roleIcon.damager = true

	--Raid Pet (for Raid)
		--[[
		E.db.unitframe.units.raidpet.enable = true
		E.db.unitframe.units.raidpet.width = 66*E.db.SY.unitframes.gridscale
		E.db.unitframe.units.raidpet.height = 33*E.db.SY.unitframes.gridscale
		E.db.unitframe.units.raidpet.growthDirection = "LEFT_UP"
		E.db.unitframe.units.raidpet.numGroups = 1
		E.db.unitframe.units.raidpet.horizontalSpacing = 3
		E.db.unitframe.units.raidpet.visibility = "[group:raid] show; hide"

		E.db.unitframe.units.raidpet.buffIndicator.enable = true

		E.db.unitframe.units.raidpet.buffs.enable = false

		E.db.unitframe.units.raidpet.debuffs.enable = false

		E.db.unitframe.units.raidpet.healPrediction.enable = true

		E.db.unitframe.units.raidpet.health.text_format = ""

		E.db.unitframe.units.raidpet.name.position = "CENTER"
		E.db.unitframe.units.raidpet.name.xOffset = 0
		E.db.unitframe.units.raidpet.name.yOffset = 0
		E.db.unitframe.units.raidpet.name.attachTextTo = "Frame"
		E.db.unitframe.units.raidpet.name.text_format = "[namecolor][name:medium] [difficultycolor][level]"

		E.db.unitframe.units.raidpet.raidicon.enable = true
		E.db.unitframe.units.raidpet.raidicon.size = 18
		E.db.unitframe.units.raidpet.raidicon.attachTo = "TOP"
		E.db.unitframe.units.raidpet.raidicon.attachToObject = "Frame"
		E.db.unitframe.units.raidpet.raidicon.xOffset = 0
		E.db.unitframe.units.raidpet.raidicon.yOffset = 9

		E.db.unitframe.units.raidpet.rdebuffs.enable = false
		]]--

	--Raid-40
		E.db.unitframe.units.raid40.enable = false

	--chosenLayout
		E.db.SY.chosenLayout = layout

	-- Positions
		SetGroupUnitframePositions(layout)
end
function SY.DPSLayout(layout)
	--Party
		E.db.unitframe.units.party.enable = true
		E.db.unitframe.units.party.width = 120
		E.db.unitframe.units.party.height = 20
		E.db.unitframe.units.party.growthDirection = "DOWN_RIGHT"
		E.db.unitframe.units.party.numGroups = 1
		E.db.unitframe.units.party.groupsPerRowCol = 1
		E.db.unitframe.units.party.verticalSpacing = 5
		E.db.unitframe.units.party.showPlayer = true
		E.db.unitframe.units.party.visibility = "[@raid6,exists][nogroup] hide;show"

		E.db.unitframe.units.party.classbar.enabled = true
		E.db.unitframe.units.party.classbar.height = 5
		E.db.unitframe.units.party.classbar.width = "fill"

		E.db.unitframe.units.party.buffs.enable = false

		E.db.unitframe.units.party.castbar.enable = false

		E.db.unitframe.units.party.debuffs.enable = false

		E.db.unitframe.units.party.healPrediction.enable = false

		E.db.unitframe.units.party.health.text_format = ""

		E.db.unitframe.units.party.infoPanel.enable = false

		E.db.unitframe.units.party.raidRoleIcons.enable = true
		E.db.unitframe.units.party.raidRoleIcons.position = "TOPLEFT"
		E.db.unitframe.units.party.raidRoleIcons.xOffset = 0
		E.db.unitframe.units.party.raidRoleIcons.yOffset = 0

		E.db.unitframe.units.party.name.position = "LEFT"
		E.db.unitframe.units.party.name.xOffset = 125
		E.db.unitframe.units.party.name.yOffset = 0
		E.db.unitframe.units.party.name.attachTextTo = "Frame"
		E.db.unitframe.units.party.name.text_format = "[namecolor][name:medium] |cffff0000[dead][afk][offline]|r"
		--E.db.unitframe.units.party.name.text_format = "[threatcolor][name:medium] [dead][afk][offline]"

		E.db.unitframe.units.party.petsGroup.enable = false

		E.db.unitframe.units.party.power.enable = true
		E.db.unitframe.units.party.power.width = "fill"
		E.db.unitframe.units.party.power.height = 5
		E.db.unitframe.units.party.power.text_format = ""

		E.db.unitframe.units.party.raidicon.enable = true
		E.db.unitframe.units.party.raidicon.size = 14
		E.db.unitframe.units.party.raidicon.attachTo = "CENTER"
		E.db.unitframe.units.party.raidicon.attachToObject = "Health"
		E.db.unitframe.units.party.raidicon.xOffset = 0
		E.db.unitframe.units.party.raidicon.yOffset = 0

		E.db.unitframe.units.party.readycheckIcon.enable = true
		E.db.unitframe.units.party.readycheckIcon.size = 12
		E.db.unitframe.units.party.readycheckIcon.attachTo = "Health"
		E.db.unitframe.units.party.readycheckIcon.position = "CENTER"
		E.db.unitframe.units.party.readycheckIcon.xOffset = 0
		E.db.unitframe.units.party.readycheckIcon.yOffset = 0

		E.db.unitframe.units.party.roleIcon.enable = true
		E.db.unitframe.units.party.roleIcon.position = "LEFT"
		E.db.unitframe.units.party.roleIcon.attachTo = "Health"
		E.db.unitframe.units.party.roleIcon.xOffset = 0
		E.db.unitframe.units.party.roleIcon.yOffset = 0
		E.db.unitframe.units.party.roleIcon.size = 12
		E.db.unitframe.units.party.roleIcon.tank = true
		E.db.unitframe.units.party.roleIcon.healer = true
		E.db.unitframe.units.party.roleIcon.damager = true

	--Raid Pet (for Party)
		E.db.unitframe.units.raidpet.enable = true
		E.db.unitframe.units.raidpet.width = 120
		--E.db.unitframe.units.raidpet.height = 18
		E.db.unitframe.units.raidpet.height = 16
		E.db.unitframe.units.raidpet.growthDirection = "DOWN_RIGHT"
		E.db.unitframe.units.raidpet.numGroups = 1
		E.db.unitframe.units.raidpet.horizontalSpacing = 5
		E.db.unitframe.units.raidpet.visibility = "[@raid6,exists][nogroup] hide;show"

		E.db.unitframe.units.raidpet.buffIndicator.enable = true

		E.db.unitframe.units.raidpet.buffs.enable = false

		E.db.unitframe.units.raidpet.debuffs.enable = false

		E.db.unitframe.units.raidpet.healPrediction.enable = false

		E.db.unitframe.units.raidpet.health.text_format = ""

		E.db.unitframe.units.raidpet.name.position = "LEFT"
		E.db.unitframe.units.raidpet.name.xOffset = 125
		E.db.unitframe.units.raidpet.name.yOffset = 0
		E.db.unitframe.units.raidpet.name.attachTextTo = "Frame"
		E.db.unitframe.units.raidpet.name.text_format = "[namecolor][name:medium] |cffff0000[dead][afk][offline]|r"
		--E.db.unitframe.units.raidpet.name.text_format = "[threatcolor][name:medium] [dead][afk][offline]"

		E.db.unitframe.units.raidpet.raidicon.enable = true
		E.db.unitframe.units.raidpet.raidicon.size = 14
		E.db.unitframe.units.raidpet.raidicon.attachTo = "CENTER"
		E.db.unitframe.units.raidpet.raidicon.attachToObject = "Health"
		E.db.unitframe.units.raidpet.raidicon.xOffset = 0
		E.db.unitframe.units.raidpet.raidicon.yOffset = 0

		E.db.unitframe.units.raidpet.rdebuffs.enable = false

	--Raid
		E.db.unitframe.units.raid.enable = true
		E.db.unitframe.units.raid.width = 120
		E.db.unitframe.units.raid.height = 18
		E.db.unitframe.units.raid.growthDirection = "DOWN_RIGHT"
		E.db.unitframe.units.raid.numGroups = 5 --6
		E.db.unitframe.units.raid.groupsPerRowCol = 6
		E.db.unitframe.units.raid.verticalSpacing = 5
		E.db.unitframe.units.raid.showPlayer = true
		E.db.unitframe.units.raid.visibility = "[@raid6,noexists][@raid26,exists] hide;show"
		E.db.unitframe.units.raid.raidWideSorting = false --true
		E.db.unitframe.units.raid.startFromCenter = false --true

		E.db.unitframe.units.raid.classbar.enabled = true
		E.db.unitframe.units.raid.classbar.height = 5
		E.db.unitframe.units.raid.classbar.width = "fill"

		E.db.unitframe.units.raid.buffs.enable = false

		E.db.unitframe.units.raid.debuffs.enable = false

		E.db.unitframe.units.raid.healPrediction.enable = false

		E.db.unitframe.units.raid.health.text_format = ""

		E.db.unitframe.units.raid.infoPanel.enable = false

		E.db.unitframe.units.raid.raidRoleIcons.enable = true
		E.db.unitframe.units.raid.raidRoleIcons.position = "TOPLEFT"
		E.db.unitframe.units.raid.raidRoleIcons.xOffset = 0
		E.db.unitframe.units.raid.raidRoleIcons.yOffset = 0

		E.db.unitframe.units.raid.name.position = "LEFT"
		E.db.unitframe.units.raid.name.xOffset = 125
		E.db.unitframe.units.raid.name.yOffset = 0
		E.db.unitframe.units.raid.name.attachTextTo = "Frame"
		E.db.unitframe.units.raid.name.text_format = "[namecolor][name:medium] |cffff0000[dead][afk][offline]|r"
		--E.db.unitframe.units.raid.name.text_format = "[threatcolor][name:medium] [dead][afk][offline]"

		E.db.unitframe.units.raid.power.enable = true
		E.db.unitframe.units.raid.power.width = "fill"
		E.db.unitframe.units.raid.power.height = 5
		E.db.unitframe.units.raid.power.text_format = ""

		E.db.unitframe.units.raid.raidicon.enable = true
		E.db.unitframe.units.raid.raidicon.size = 14
		E.db.unitframe.units.raid.raidicon.attachTo = "CENTER"
		E.db.unitframe.units.raid.raidicon.attachToObject = "Health"
		E.db.unitframe.units.raid.raidicon.xOffset = 0
		E.db.unitframe.units.raid.raidicon.yOffset = 0

		E.db.unitframe.units.raid.rdebuffs.enable = true --false
		E.db.unitframe.units.raid.rdebuffs.size = 22
		E.db.unitframe.units.raid.rdebuffs.font = "BigNoodleTitling"
		E.db.unitframe.units.raid.rdebuffs.fontSize = 12 --9
		E.db.unitframe.units.raid.rdebuffs.fontOutline = "OUTLINE"
		E.db.unitframe.units.raid.rdebuffs.xOffset = 0
		E.db.unitframe.units.raid.rdebuffs.yOffset = 0
		E.db.unitframe.units.raid.rdebuffs.stack.xOffset = 0
		E.db.unitframe.units.raid.rdebuffs.stack.yOffset = 2
		E.db.unitframe.units.raid.rdebuffs.stack.color = { r = 1, g = .9, b = 0 }

		E.db.unitframe.units.raid.readycheckIcon.enable = true
		E.db.unitframe.units.raid.readycheckIcon.size = 12
		E.db.unitframe.units.raid.readycheckIcon.attachTo = "Health"
		E.db.unitframe.units.raid.readycheckIcon.position = "CENTER"
		E.db.unitframe.units.raid.readycheckIcon.xOffset = 0
		E.db.unitframe.units.raid.readycheckIcon.yOffset = 0

		E.db.unitframe.units.raid.roleIcon.enable = true
		E.db.unitframe.units.raid.roleIcon.position = "LEFT"
		E.db.unitframe.units.raid.roleIcon.attachTo = "Health"
		E.db.unitframe.units.raid.roleIcon.xOffset = 0
		E.db.unitframe.units.raid.roleIcon.yOffset = 0
		E.db.unitframe.units.raid.roleIcon.size = 12
		E.db.unitframe.units.raid.roleIcon.tank = true
		E.db.unitframe.units.raid.roleIcon.healer = true
		E.db.unitframe.units.raid.roleIcon.damager = true

	--Raid-40
		E.db.unitframe.units.raid40.enable = true
		E.db.unitframe.units.raid40.width = 100
		E.db.unitframe.units.raid40.height = 14
		E.db.unitframe.units.raid40.growthDirection = "DOWN_RIGHT"
		E.db.unitframe.units.raid40.numGroups = 8
		E.db.unitframe.units.raid40.groupsPerRowCol = 8
		E.db.unitframe.units.raid40.verticalSpacing = 3
		E.db.unitframe.units.raid40.showPlayer = true
		E.db.unitframe.units.raid40.visibility = "[@raid26,noexists] hide;show"
		E.db.unitframe.units.raid40.raidWideSorting = false --true
		E.db.unitframe.units.raid40.startFromCenter = false --true

		E.db.unitframe.units.raid40.classbar.enabled = false

		E.db.unitframe.units.raid40.buffs.enable = false

		E.db.unitframe.units.raid40.debuffs.enable = false

		E.db.unitframe.units.raid40.healPrediction.enable = false

		E.db.unitframe.units.raid40.health.text_format = ""

		E.db.unitframe.units.raid40.infoPanel.enable = false

		E.db.unitframe.units.raid40.raidRoleIcons.enable = true
		E.db.unitframe.units.raid40.raidRoleIcons.position = "TOPLEFT"
		E.db.unitframe.units.raid40.raidRoleIcons.xOffset = 0
		E.db.unitframe.units.raid40.raidRoleIcons.yOffset = 0

		E.db.unitframe.units.raid40.name.position = "LEFT"
		E.db.unitframe.units.raid40.name.xOffset = 105
		E.db.unitframe.units.raid40.name.yOffset = 0
		E.db.unitframe.units.raid40.name.attachTextTo = "Frame"
		E.db.unitframe.units.raid40.name.text_format = "[namecolor][name:medium] |cffff0000[dead][afk][offline]|r"
		--E.db.unitframe.units.raid40.name.text_format = "[threatcolor][name:medium] [dead][afk][offline]"

		E.db.unitframe.units.raid40.power.enable = false

		E.db.unitframe.units.raid40.raidicon.enable = true
		E.db.unitframe.units.raid40.raidicon.size = 14
		E.db.unitframe.units.raid40.raidicon.attachTo = "CENTER"
		E.db.unitframe.units.raid40.raidicon.attachToObject = "Health"
		E.db.unitframe.units.raid40.raidicon.xOffset = 0
		E.db.unitframe.units.raid40.raidicon.yOffset = 0

		E.db.unitframe.units.raid40.readycheckIcon.enable = true
		E.db.unitframe.units.raid40.readycheckIcon.size = 12
		E.db.unitframe.units.raid40.readycheckIcon.attachTo = "Health"
		E.db.unitframe.units.raid40.readycheckIcon.position = "CENTER"
		E.db.unitframe.units.raid40.readycheckIcon.xOffset = 0
		E.db.unitframe.units.raid40.readycheckIcon.yOffset = 0

		E.db.unitframe.units.raid40.roleIcon.enable = false

	--chosenLayout
		E.db.SY.chosenLayout = layout

	-- Positions
		SetGroupUnitframePositions(layout)
end

local function SetupLayout(layout, noDataReset)
	local colorScheme = E.private.theme
	E.db = E:CopyTable(E.db, P)
	SetupColors(colorScheme) -- Don't overwrite the colors we just set up in previous step! Lazy way of fixing this issue
	local classColor = E.myclass == "PRIEST" and E.PriestColors or RAID_CLASS_COLORS[E.myclass]

	--Set up various settings shared across all layouts
	--[[----------------------------------
	--	GlobalDB - General
	--]]----------------------------------
		-- DataTexts
		E.global.datatexts.customPanels["SynesBottomGradientDataText"] = E:CopyTable({}, G.datatexts.newPanelInfo)
		E.global.datatexts.customPanels["SynesBottomGradientDataText"].name = L["Syne's Bottom Gradient DataTexts"]
		E.global.datatexts.customPanels["SynesBottomGradientDataText"].numPoints = 8
		E.global.datatexts.customPanels["SynesBottomGradientDataText"].growth = "HORIZONTAL"
		E.global.datatexts.customPanels["SynesBottomGradientDataText"].width = 940
		E.global.datatexts.customPanels["SynesBottomGradientDataText"].height = 25
		E.global.datatexts.customPanels["SynesBottomGradientDataText"].textJustify = "CENTER"
		E.global.datatexts.customPanels["SynesBottomGradientDataText"].fonts.enable = false
		E.global.datatexts.customPanels["SynesBottomGradientDataText"].fonts.fontSize = 12
		E.global.datatexts.customPanels["SynesBottomGradientDataText"].fonts.font = "PT Sans Narrow"
		E.global.datatexts.customPanels["SynesBottomGradientDataText"].fonts.fontOutline = "OUTLINE"
		E.global.datatexts.customPanels["SynesBottomGradientDataText"].backdrop = false
		E.global.datatexts.customPanels["SynesBottomGradientDataText"].panelTransparency = false
		E.global.datatexts.customPanels["SynesBottomGradientDataText"].mouseover = false
		E.global.datatexts.customPanels["SynesBottomGradientDataText"].border = false
		E.global.datatexts.customPanels["SynesBottomGradientDataText"].frameStrata = "LOW"
		E.global.datatexts.customPanels["SynesBottomGradientDataText"].frameLevel = 1
		E.global.datatexts.customPanels["SynesBottomGradientDataText"].tooltipXOffset = -17
		E.global.datatexts.customPanels["SynesBottomGradientDataText"].tooltipYOffset = 4
		E.global.datatexts.customPanels["SynesBottomGradientDataText"].tooltipAnchor = "ANCHOR_TOPLEFT"
		E.global.datatexts.customPanels["SynesBottomGradientDataText"].visibility = "[petbattle] hide;show"

		E.global.datatexts.customPanels["SynesLeftDataText"] = E:CopyTable({}, G.datatexts.newPanelInfo)
		E.global.datatexts.customPanels["SynesLeftDataText"].name = L["Syne's Left DataTexts"]
		E.global.datatexts.customPanels["SynesLeftDataText"].numPoints = 3
		E.global.datatexts.customPanels["SynesLeftDataText"].growth = "HORIZONTAL"
		E.global.datatexts.customPanels["SynesLeftDataText"].width = 300
		E.global.datatexts.customPanels["SynesLeftDataText"].height = 25
		E.global.datatexts.customPanels["SynesLeftDataText"].textJustify = "CENTER"
		E.global.datatexts.customPanels["SynesLeftDataText"].fonts.enable = false
		E.global.datatexts.customPanels["SynesLeftDataText"].fonts.fontSize = 12
		E.global.datatexts.customPanels["SynesLeftDataText"].fonts.font = "PT Sans Narrow"
		E.global.datatexts.customPanels["SynesLeftDataText"].fonts.fontOutline = "OUTLINE"
		E.global.datatexts.customPanels["SynesLeftDataText"].backdrop = false
		E.global.datatexts.customPanels["SynesLeftDataText"].panelTransparency = false
		E.global.datatexts.customPanels["SynesLeftDataText"].mouseover = false
		E.global.datatexts.customPanels["SynesLeftDataText"].border = false
		E.global.datatexts.customPanels["SynesLeftDataText"].frameStrata = "LOW"
		E.global.datatexts.customPanels["SynesLeftDataText"].frameLevel = 1
		E.global.datatexts.customPanels["SynesLeftDataText"].tooltipXOffset = -17
		E.global.datatexts.customPanels["SynesLeftDataText"].tooltipYOffset = 4
		E.global.datatexts.customPanels["SynesLeftDataText"].tooltipAnchor = "ANCHOR_TOPLEFT"
		E.global.datatexts.customPanels["SynesLeftDataText"].visibility = "[petbattle] hide;show"

		E.global.datatexts.customPanels["SynesRightDataText"] = E:CopyTable({}, G.datatexts.newPanelInfo)
		E.global.datatexts.customPanels["SynesRightDataText"].name = L["Syne's Right DataTexts"]
		E.global.datatexts.customPanels["SynesRightDataText"].numPoints = 3
		E.global.datatexts.customPanels["SynesRightDataText"].growth = "HORIZONTAL"
		E.global.datatexts.customPanels["SynesRightDataText"].width = 300
		E.global.datatexts.customPanels["SynesRightDataText"].height = 25
		E.global.datatexts.customPanels["SynesRightDataText"].textJustify = "CENTER"
		E.global.datatexts.customPanels["SynesRightDataText"].fonts.enable = false
		E.global.datatexts.customPanels["SynesRightDataText"].fonts.fontSize = 12
		E.global.datatexts.customPanels["SynesRightDataText"].fonts.font = "PT Sans Narrow"
		E.global.datatexts.customPanels["SynesRightDataText"].fonts.fontOutline = "OUTLINE"
		E.global.datatexts.customPanels["SynesRightDataText"].backdrop = false
		E.global.datatexts.customPanels["SynesRightDataText"].panelTransparency = false
		E.global.datatexts.customPanels["SynesRightDataText"].mouseover = false
		E.global.datatexts.customPanels["SynesRightDataText"].border = false
		E.global.datatexts.customPanels["SynesRightDataText"].frameStrata = "LOW"
		E.global.datatexts.customPanels["SynesRightDataText"].frameLevel = 1
		E.global.datatexts.customPanels["SynesRightDataText"].tooltipXOffset = -17
		E.global.datatexts.customPanels["SynesRightDataText"].tooltipYOffset = 4
		E.global.datatexts.customPanels["SynesRightDataText"].tooltipAnchor = "ANCHOR_TOPLEFT"
		E.global.datatexts.customPanels["SynesRightDataText"].visibility = "[petbattle] hide;show"


	--[[----------------------------------
	--	PrivateDB - General
	--]]----------------------------------


	--[[----------------------------------
	--	ProfileDB - General
	--]]----------------------------------
		--Misc
		E.db.general.loginmessage = false
		E.db.general.autoRepair = "NONE"
		E.db.general.vendorGrays = true
		E.db.general.bottomPanel = false

		--E.db.general.threat.enable = true
		--E.db.general.threat.textSize = 14
		--E.db.general.threat.textOutline = "OUTLINE"
		E.db.databars.threat.enable = true
		E.db.databars.threat.mouseover = false
		E.db.databars.threat.clickThrough = false
		E.db.databars.threat.width = 400
		E.db.databars.threat.height = 6
		E.db.databars.threat.orientation = "AUTOMATIC"
		E.db.databars.threat.reverseFill = false
		E.db.databars.threat.font = "BigNoodleTitling"
		E.db.databars.threat.fontSize = 14
		E.db.databars.threat.fontOutline = "OUTLINE"

		E.db.general.totems.growthDirection = "HORIZONTAL"

		--Media
			-- Done in SetupColors()

		--Altbar
		E.db.general.altPowerBar.enable = true
		E.db.general.altPowerBar.width = 250
		E.db.general.altPowerBar.height = 20
		E.db.general.altPowerBar.statusBar = "normTex"
		E.db.general.altPowerBar.statusBarColor = { r = 51/255, g = 102/255, b = 204/255 }
		E.db.general.altPowerBar.font = "Agency FB Bold"
		E.db.general.altPowerBar.fontSize = 14
		E.db.general.altPowerBar.fontOutline = "OUTLINE"
		E.db.general.altPowerBar.textFormat = "NAMECURMAX"


	--[[----------------------------------
		ProfileDB - Actionbars
	--]]----------------------------------
		--General
		E.db.actionbar.macrotext = true
		E.db.actionbar.hotkeytext = true
		E.db.actionbar.keyDown = true
		E.db.actionbar.lockActionBars = true

		E.db.actionbar.noRangeColor = { r = 1, g = .1, b = .1 }
		--E.db.actionbar.noPowerColor = { r = 1, g = .45, b = .45 }
		E.db.actionbar.noPowerColor = { r = .45, g = .45, b = 1 }

		E.db.actionbar.font = "BigNoodleTitling"
		E.db.actionbar.fontSize = 14
		E.db.actionbar.fontOutline = "OUTLINE"

		E.db.actionbar.countTextPosition = "BOTTOMRIGHT"
		E.db.actionbar.countTextXOffset = 0
		E.db.actionbar.countTextYOffset = 2
		E.db.actionbar.hotkeyTextPosition = "TOPRIGHT"
		E.db.actionbar.hotkeyTextXOffset = 0
		E.db.actionbar.hotkeyTextYOffset = -3

		--Bar 1
		E.db.actionbar.bar1.enabled = true
		E.db.actionbar.bar1.backdrop = false
		E.db.actionbar.bar1.point = "BOTTOMLEFT"
		E.db.actionbar.bar1.buttons = 12
		E.db.actionbar.bar1.buttonsPerRow = 12
		E.db.actionbar.bar1.buttonsize = 32
		E.db.actionbar.bar1.buttonspacing = 4
		E.db.actionbar.bar1.paging = {
			DRUID = "[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] 8; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;",
			PRIEST = "[bonusbar:1] 7;",
			ROGUE = "[stance:1] 7;  [stance:2] 7; [stance:3] 7;", -- set to "[stance:1] 7; [stance:3] 10;" if you want a shadow dance bar
			MONK = "[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;",
			WARRIOR = "[bonusbar:1] 7; [bonusbar:2] 8;"
		}
		E.db.actionbar.bar1.visibility = "[petbattle] hide; show"

		--Bar 2
		E.db.actionbar.bar2.enabled = true
		E.db.actionbar.bar2.backdrop = false
		E.db.actionbar.bar2.point = "BOTTOMLEFT"
		E.db.actionbar.bar2.buttons = 12
		E.db.actionbar.bar2.buttonsPerRow = 12
		E.db.actionbar.bar2.buttonsize = 32
		E.db.actionbar.bar2.buttonspacing = 4
		E.db.actionbar.bar2.visibility = "[vehicleui] hide; [overridebar] hide; [petbattle] hide; show"

		--Bar 3
		E.db.actionbar.bar3.enabled = true
		E.db.actionbar.bar3.backdrop = false
		E.db.actionbar.bar3.point = "TOPRIGHT"
		E.db.actionbar.bar3.buttons = 12
		E.db.actionbar.bar3.buttonsPerRow = 6
		E.db.actionbar.bar3.buttonsize = 32
		E.db.actionbar.bar3.buttonspacing = 4
		E.db.actionbar.bar3.visibility = "[vehicleui] hide; [overridebar] hide; [petbattle] hide; show"

		--Bar 4
		E.db.actionbar.bar4.enabled = true
		E.db.actionbar.bar4.backdrop = false
		E.db.actionbar.bar4.point = "TOPLEFT"
		E.db.actionbar.bar4.buttons = 12
		E.db.actionbar.bar4.buttonsPerRow = 6
		E.db.actionbar.bar4.buttonsize = 32
		E.db.actionbar.bar4.buttonspacing = 4
		E.db.actionbar.bar4.visibility = "[vehicleui] hide; [overridebar] hide; [petbattle] hide; show"

		--Bar 5
		E.db.actionbar.bar5.enabled = true
		E.db.actionbar.bar5.backdrop = false
		--E.db.actionbar.bar5.mouseover = true
		E.db.actionbar.bar5.mouseover = false
		E.db.actionbar.bar5.point = "BOTTOMLEFT"
		E.db.actionbar.bar5.buttons = 12
		E.db.actionbar.bar5.buttonsPerRow = 1
		E.db.actionbar.bar5.buttonsize = 32
		E.db.actionbar.bar5.buttonspacing = 4
		--E.db.actionbar.bar5.visibility = "[vehicleui] hide; [overridebar] hide; [petbattle] hide; [mod:ctrl] show; hide"
		E.db.actionbar.bar5.visibility = "[vehicleui] hide; [overridebar] hide; [petbattle] hide; show"

		--Bar 6
		E.db.actionbar.bar6.enabled = false
		E.db.actionbar.bar6.backdrop = true
		--E.db.actionbar.bar6.mouseover = true
		E.db.actionbar.bar6.mouseover = false
		E.db.actionbar.bar6.point = "BOTTOMLEFT"
		E.db.actionbar.bar6.buttons = 12
		E.db.actionbar.bar6.buttonsPerRow = 6
		E.db.actionbar.bar6.buttonsize = 32
		E.db.actionbar.bar6.buttonspacing = 4
		--E.db.actionbar.bar6.visibility = "[vehicleui] hide; [overridebar] hide; [petbattle] hide; [mod:ctrl] show; hide"
		E.db.actionbar.bar6.visibility = "[vehicleui] hide; [overridebar] hide; [petbattle] hide; show"

		--Pet Bar
		E.db.actionbar.barPet.enabled = true
		E.db.actionbar.barPet.point = "TOPLEFT"
		E.db.actionbar.barPet.backdrop = false
		E.db.actionbar.barPet.buttons = 10
		E.db.actionbar.barPet.buttonsPerRow = 10
		E.db.actionbar.barPet.buttonsize = 28
		E.db.actionbar.barPet.buttonspacing = 4
		E.db.actionbar.barPet.visibility = "[petbattle] hide; [pet,novehicleui,nooverridebar,nopossessbar] show; hide"

		--Stance Bar
		E.db.actionbar.stanceBar.enabled = true
		E.db.actionbar.stanceBar.point = "BOTTOMRIGHT"
		E.db.actionbar.stanceBar.backdrop = false
		E.db.actionbar.stanceBar.buttons = 6
		E.db.actionbar.stanceBar.buttonsPerRow = 6
		E.db.actionbar.stanceBar.buttonsize = 28
		E.db.actionbar.stanceBar.buttonspacing = 4
		E.db.actionbar.stanceBar.visibility = "[vehicleui] hide; [petbattle] hide;show"

		--Totem Bar (Not actually under AB, but General)
		E.db.general.totems.enable = true
		E.db.general.totems.size = 28
		E.db.general.totems.spacing = 4
		E.db.general.totems.growthDirection = "HORIZONTAL"

		--Vehicle Exit Button
		E.db.actionbar.vehicleExitButton.enable = true
		E.db.actionbar.vehicleExitButton.size = 28

		--Cooldown
		E.db.actionbar.cooldown.override = true
		E.db.actionbar.cooldown.threshold = 6
		E.db.actionbar.cooldown.expiringColor = { r = 1, g = 0, b = 0 }
		E.db.actionbar.cooldown.secondsColor = { r = 1, g = 1, b = 0 }
		E.db.actionbar.cooldown.minutesColor = { r = 1, g = 1, b = 1 }
		E.db.actionbar.cooldown.hoursColor = { r = 0.4, g = 1, b = 1 }
		E.db.actionbar.cooldown.daysColor = { r = 0.4, g = 0.4, b = 1 }
		E.db.actionbar.cooldown.useIndicatorColor = false


	--[[----------------------------------
	--	ProfileDB - Bags
	--]]----------------------------------
		E.db.bags.showBindType = true
		E.db.bags.clearSearchOnClose = true

		E.db.bags.countFont = "BigNoodleTitling"
		E.db.bags.countFontSize = 12
		E.db.bags.countFontOutline = "OUTLINE"

		E.db.bags.itemLevelFont = "BigNoodleTitling"
		E.db.bags.itemLevelFontSize = 14
		E.db.bags.itemLevelFontOutline = "OUTLINE"

		E.db.bags.bagSize = 35
		E.db.bags.bankSize = 35
		E.db.bags.bagWidth = 385
		E.db.bags.bankWidth = 385

		E.db.bags.vendorGrays.enable = true


	--[[----------------------------------
	--	ProfileDB - Buffs and Debuffs
	--]]----------------------------------
		E.db.auras.enable = true
		E.db.auras.fadeThreshold = 15
		E.db.auras.font = "Agency FB Bold"
		E.db.auras.showDuration = true
		E.db.auras.fontOutline = "OUTLINE"
		E.db.auras.timeXOffset = 0
		E.db.auras.timeYOffset = 8
		E.db.auras.countXOffset = 1
		E.db.auras.countYOffset = -2

		E.db.auras.buffs.size = 36
		E.db.auras.buffs.durationFontSize = 12
		E.db.auras.buffs.countFontSize = 12
		E.db.auras.buffs.growthDirection = "LEFT_DOWN"
		E.db.auras.buffs.wrapAfter = 16
		E.db.auras.buffs.maxWraps = 3
		E.db.auras.buffs.horizontalSpacing = 5
		E.db.auras.buffs.verticalSpacing = 5
		--E.db.auras.buffs.sortDir = "+"
		E.db.auras.buffs.seperateOwn = 0

		E.db.auras.debuffs.size = 36
		E.db.auras.debuffs.durationFontSize = 12
		E.db.auras.debuffs.countFontSize = 12
		E.db.auras.debuffs.growthDirection = "LEFT_DOWN"
		E.db.auras.debuffs.wrapAfter = 16
		E.db.auras.debuffs.maxWraps = 1
		E.db.auras.debuffs.horizontalSpacing = 5
		E.db.auras.debuffs.verticalSpacing = 5
		E.db.auras.debuffs.seperateOwn = 0

		E.db.auras.cooldown.override = true
		E.db.auras.cooldown.threshold = 6
		E.db.auras.cooldown.expiringColor = { r = 1, g = 0, b = 0 }
		E.db.auras.cooldown.secondsColor = { r = 1, g = 1, b = 0 }
		E.db.auras.cooldown.minutesColor = { r = 1, g = 1, b = 1 }
		E.db.auras.cooldown.hoursColor = { r = 0.4, g = 1, b = 1 }
		E.db.auras.cooldown.daysColor = { r = 0.4, g = 0.4, b = 1 }
		E.db.auras.cooldown.useIndicatorColor = false


	--[[----------------------------------
	--	ProfileDB - Chat
	--]]----------------------------------
		E.db.chat.enable = true
		E.db.chat.hyperlinkHover = true
		E.db.chat.fade = false
		E.db.chat.emotionIcons = false
		E.db.chat.lfgIcons = true
		E.db.chat.fadeTabsNoBackdrop = false
		E.db.chat.scrollDownInterval = 0
		E.db.chat.timeStampFormat = "%H:%M "

		E.db.chat.panelTabTransparency = true
		E.db.chat.panelBackdrop = "HIDEBOTH"
		E.db.chat.panelWidth = 368
		E.db.chat.panelHeight = 139

		E.db.chat.font = "Agency FB Bold"
		E.db.chat.fontOutline = "NONE"
		E.db.chat.tabFont = "Agency FB Bold"
		E.db.chat.tabFontSize = 15
		E.db.chat.tabFontOutline = "OUTLINE"


	--[[----------------------------------
	--	ProfileDB - Cooldown Text
	--]]----------------------------------
		E.db.cooldown.enable = true
		E.db.cooldown.threshold = 6
		E.db.cooldown.fonts.enable = true
		E.db.cooldown.fonts.font = "BigNoodleTitling"
		E.db.cooldown.fonts.fontSize = 24
		E.db.cooldown.fonts.fontOutline = "OUTLINE"


	--[[----------------------------------
	--	ProfileDB - DataBars
	--]]----------------------------------
		E.db.databars.experience.enable = true
		E.db.databars.experience.hideAtMaxLevel = true
		E.db.databars.experience.hideInCombat = true
		E.db.databars.experience.orientation = "HORIZONTAL"
		E.db.databars.experience.width = 202
		E.db.databars.experience.height = 12
		E.db.databars.experience.font = "Agency FB Bold"
		E.db.databars.experience.textSize = 11
		E.db.databars.experience.fontOutline = "NONE"
		E.db.databars.experience.textFormat = "CURMAX"

		E.db.databars.reputation.enable = true
		E.db.databars.reputation.hideInCombat = false
		E.db.databars.reputation.orientation = "HORIZONTAL"
		E.db.databars.reputation.width = 202
		E.db.databars.reputation.height = 12
		E.db.databars.reputation.font = "Agency FB Bold"
		E.db.databars.reputation.textSize = 11
		E.db.databars.reputation.fontOutline = "NONE"
		E.db.databars.reputation.textFormat = "CURMAX"

		E.db.databars.honor.enable = true
		E.db.databars.honor.hideOutsidePvP = false
		E.db.databars.honor.orientation = "HORIZONTAL"
		E.db.databars.honor.width = 202
		E.db.databars.honor.height = 12
		E.db.databars.honor.font = "Agency FB Bold"
		E.db.databars.honor.textSize = 11
		E.db.databars.honor.fontOutline = "NONE"
		E.db.databars.honor.textFormat = "CURMAX"

		E.db.databars.azerite.enable = true
		E.db.databars.azerite.hideAtMaxLevel = false
		E.db.databars.azerite.hideInCombat = false
		E.db.databars.azerite.orientation = "HORIZONTAL"
		E.db.databars.azerite.width = 202
		E.db.databars.azerite.height = 12
		E.db.databars.azerite.font = "Agency FB Bold"
		E.db.databars.azerite.textSize = 11
		E.db.databars.azerite.fontOutline = "NONE"
		E.db.databars.azerite.textFormat = "CURMAX"


	--[[----------------------------------
	--	ProfileDB - Datatexts
	--]]----------------------------------
		E.db.datatexts.font = "BigNoodleTitling"
		E.db.datatexts.fontSize = 14
		E.db.datatexts.fontOutline = "OUTLINE"

		--[[
		E.db.datatexts.minimapPanels = false
		E.db.datatexts.leftChatPanel = false
		E.db.datatexts.rightChatPanel = false
		E.db.datatexts.minimapTop = false
		E.db.datatexts.minimapTopLeft = false
		E.db.datatexts.minimapTopRight = false
		E.db.datatexts.minimapBottom = false
		E.db.datatexts.minimapBottomLeft = false
		E.db.datatexts.minimapBottomRight = false
		]]

		--E.db.datatexts.currencies.displayedCurrency = "CORRUPTED_MEMENTOS"

		E.db.datatexts.panels.LeftChatDataPanel.enable = false
		E.db.datatexts.panels.LeftChatDataPanel.backdrop = false

		E.db.datatexts.panels.RightChatDataPanel.enable = false
		E.db.datatexts.panels.RightChatDataPanel.backdrop = false

		E.db.datatexts.panels.MinimapPanel.enable = false

		E.db.datatexts.panels["SynesBottomGradientDataText"] = { enable = true }
		E.db.datatexts.panels["SynesBottomGradientDataText"][1] = "Guild"
		E.db.datatexts.panels["SynesBottomGradientDataText"][2] = "Friends"
		E.db.datatexts.panels["SynesBottomGradientDataText"][3] = "QuickJoin"
		E.db.datatexts.panels["SynesBottomGradientDataText"][4] = "DPS"
		E.db.datatexts.panels["SynesBottomGradientDataText"][5] = "HPS"
		E.db.datatexts.panels["SynesBottomGradientDataText"][6] = "CallToArms"
		E.db.datatexts.panels["SynesBottomGradientDataText"][7] = "Bags"
		E.db.datatexts.panels["SynesBottomGradientDataText"][8] = "Currencies"

		E.db.datatexts.panels["SynesLeftDataText"] = { enable = true }
		E.db.datatexts.panels["SynesLeftDataText"][1] = "Talent/Loot Specialization"
		E.db.datatexts.panels["SynesLeftDataText"][2] = "Durability"
		E.db.datatexts.panels["SynesLeftDataText"][3] = "Missions"

		E.db.datatexts.panels["SynesRightDataText"] = { enable = true }
		E.db.datatexts.panels["SynesRightDataText"][1] = "System"
		E.db.datatexts.panels["SynesRightDataText"][2] = "Time"
		E.db.datatexts.panels["SynesRightDataText"][3] = "Gold"

		-- Prevent errors during the installation when setting up custom DTPanels
		DT:BuildPanelFrame("SynesBottomGradientDataText")
		DT:BuildPanelFrame("SynesLeftDataText")
		DT:BuildPanelFrame("SynesRightDataText")


	--[[----------------------------------
	--	ProfileDB - Maps
	--]]----------------------------------
		E.db.general.minimap.size = 200 --176
		E.db.general.minimap.locationText = "SHOW"
		E.db.general.minimap.locationFont = "BigNoodleTitling"
		E.db.general.minimap.locationFontSize = 14
		E.db.general.minimap.locationFontOutline = "OUTLINE"


	--[[----------------------------------
	--	ProfileDB - NamePlates
	--]]----------------------------------
		E.db.nameplates.enable = true

		E.db.nameplates.plateSize.personalWidth = 110
		E.db.nameplates.plateSize.friendlyWidth = 110
		E.db.nameplates.plateSize.enemyWidth = 110

		E.db.nameplates.colors.reactions.bad = { r = .69, g = .31, b = .31 }
		E.db.nameplates.colors.reactions.neutral = { r = .65, g = .63, b = .35 }
		E.db.nameplates.colors.reactions.good = { r = .33, g = .59, b = .33 }

		E.db.nameplates.colors.castColor = { r = 255/255, g = 207/255, b = 0 }
		E.db.nameplates.colors.castNoInterruptColor = { r = .8, g = .05, b = 0 }

		local NP = { "FRIENDLY_PLAYER", "FRIENDLY_NPC", "ENEMY_PLAYER", "ENEMY_NPC" }

		for _, plate in pairs(NP) do -- Don't do same work 4 times, let automation take care of things
			E.db.nameplates.units[plate].enable = true

			E.db.nameplates.units[plate].health.enable = true
			E.db.nameplates.units[plate].health.height = 12
			E.db.nameplates.units[plate].health.text.enable = true
			E.db.nameplates.units[plate].health.text.format = "[health:current-percent]"
			E.db.nameplates.units[plate].health.text.parent = "Health"
			E.db.nameplates.units[plate].health.text.position = "CENTER"
			E.db.nameplates.units[plate].health.text.xOffset = 0
			E.db.nameplates.units[plate].health.text.yOffset = 0
			E.db.nameplates.units[plate].health.text.font = "BigNoodleTitling"
			E.db.nameplates.units[plate].health.text.fontSize = 14
			E.db.nameplates.units[plate].health.text.fontOutline = "OUTLINE"

			E.db.nameplates.units[plate].castbar.enable = true
			E.db.nameplates.units[plate].castbar.width = 110
			E.db.nameplates.units[plate].castbar.height = 5
			E.db.nameplates.units[plate].castbar.xOffset = 0
			E.db.nameplates.units[plate].castbar.yOffset = -14
			E.db.nameplates.units[plate].castbar.textPosition = "ONBAR"
			E.db.nameplates.units[plate].castbar.castTimeFormat = "CURRENT"
			E.db.nameplates.units[plate].castbar.channelTimeFormat = "CURRENT"
			E.db.nameplates.units[plate].castbar.showIcon = true
			E.db.nameplates.units[plate].castbar.iconPosition = "RIGHT"
			E.db.nameplates.units[plate].castbar.iconSize = 22
			E.db.nameplates.units[plate].castbar.iconOffsetX = 5
			E.db.nameplates.units[plate].castbar.iconOffsetY = 0
			E.db.nameplates.units[plate].castbar.font = "BigNoodleTitling"
			E.db.nameplates.units[plate].castbar.fontSize = 14
			E.db.nameplates.units[plate].castbar.fontOutline = "OUTLINE"

			E.db.nameplates.units[plate].buffs.enable = true
			E.db.nameplates.units[plate].buffs.desaturate = true
			E.db.nameplates.units[plate].buffs.numAuras = 4
			E.db.nameplates.units[plate].buffs.spacing = 2
			E.db.nameplates.units[plate].buffs.xOffset = 0
			E.db.nameplates.units[plate].buffs.yOffset = 0

			E.db.nameplates.units[plate].debuffs.enable = true
			E.db.nameplates.units[plate].debuffs.desaturate = true
			E.db.nameplates.units[plate].debuffs.numAuras = 5
			E.db.nameplates.units[plate].debuffs.spacing = 2
			E.db.nameplates.units[plate].debuffs.xOffset = 0
			E.db.nameplates.units[plate].debuffs.yOffset = 30

			E.db.nameplates.units[plate].level.enable = true
			E.db.nameplates.units[plate].level.format = "[difficultycolor][level]"
			E.db.nameplates.units[plate].level.position = "RIGHT"
			E.db.nameplates.units[plate].level.parent = "Health"
			E.db.nameplates.units[plate].level.xOffset = 2
			E.db.nameplates.units[plate].level.yOffset = 0
			E.db.nameplates.units[plate].level.font = "BigNoodleTitling"
			E.db.nameplates.units[plate].level.fontSize = 14
			E.db.nameplates.units[plate].level.fontOutline = "OUTLINE"

			E.db.nameplates.units[plate].name.enable = true
			E.db.nameplates.units[plate].name.format = "[namecolor][name]"
			E.db.nameplates.units[plate].name.position = "CENTER"
			E.db.nameplates.units[plate].name.parent = "Health"
			E.db.nameplates.units[plate].name.xOffset = 0
			E.db.nameplates.units[plate].name.yOffset = 16
			E.db.nameplates.units[plate].name.font = "BigNoodleTitling"
			E.db.nameplates.units[plate].name.fontSize = 14
			E.db.nameplates.units[plate].name.fontOutline = "OUTLINE"

			E.db.nameplates.units[plate].raidTargetIndicator.enable = true
			E.db.nameplates.units[plate].raidTargetIndicator.size = 30
			E.db.nameplates.units[plate].raidTargetIndicator.position = "CENTER"
			E.db.nameplates.units[plate].raidTargetIndicator.xOffset = 0
			E.db.nameplates.units[plate].raidTargetIndicator.yOffset = 35
		end

		-- Nameplate Filters
		-- E.global.nameplate -> E.global.nameplates in ElvUI 12.60 on Jan 18, 2022 ?

		-- Style
		E.global.nameplates.filters["SyneStyle"] = E:CopyTable(E.global.nameplates.filters["SyneStyle"], E.StyleFilterDefaults)
		E.global.nameplates.filters["SyneStyle"].triggers.notTarget = true

		E.global.nameplates.filters["SyneStyle"].triggers.nameplateType.enable = true
		E.global.nameplates.filters["SyneStyle"].triggers.nameplateType.friendlyPlayer = true
		E.global.nameplates.filters["SyneStyle"].triggers.nameplateType.friendlyNPC = true

		E.global.nameplates.filters["SyneStyle"].actions.nameOnly = true

		-- Hide in Instances
		E.global.nameplates.filters["SyneHide"] = E:CopyTable(E.global.nameplates.filters["SyneHide"], E.StyleFilterDefaults)
		E.global.nameplates.filters["SyneHide"].triggers.nameplateType.enable = true
		E.global.nameplates.filters["SyneHide"].triggers.nameplateType.friendlyPlayer = true
		E.global.nameplates.filters["SyneHide"].triggers.nameplateType.friendlyNPC = true

		E.global.nameplates.filters["SyneHide"].triggers.instanceType.none = false
		E.global.nameplates.filters["SyneHide"].triggers.instanceType.scenario = false
		E.global.nameplates.filters["SyneHide"].triggers.instanceType.party = true
		E.global.nameplates.filters["SyneHide"].triggers.instanceType.raid = true
		E.global.nameplates.filters["SyneHide"].triggers.instanceType.arena = false
		E.global.nameplates.filters["SyneHide"].triggers.instanceType.pvp = false

		E.global.nameplates.filters["SyneHide"].triggers.instanceDifficulty.dungeon.normal = true
		E.global.nameplates.filters["SyneHide"].triggers.instanceDifficulty.dungeon.heroic = true
		E.global.nameplates.filters["SyneHide"].triggers.instanceDifficulty.dungeon.mythic = true
		E.global.nameplates.filters["SyneHide"].triggers.instanceDifficulty.dungeon["mythic+"] = true
		E.global.nameplates.filters["SyneHide"].triggers.instanceDifficulty.dungeon.timewalking = true

		E.global.nameplates.filters["SyneHide"].triggers.instanceDifficulty.raid.lfr = true
		E.global.nameplates.filters["SyneHide"].triggers.instanceDifficulty.raid.normal = true
		E.global.nameplates.filters["SyneHide"].triggers.instanceDifficulty.raid.heroic = true
		E.global.nameplates.filters["SyneHide"].triggers.instanceDifficulty.raid.mythic = true
		E.global.nameplates.filters["SyneHide"].triggers.instanceDifficulty.raid.timewalking = true
		E.global.nameplates.filters["SyneHide"].triggers.instanceDifficulty.raid.legacy10normal = true
		E.global.nameplates.filters["SyneHide"].triggers.instanceDifficulty.raid.legacy25normal = true
		E.global.nameplates.filters["SyneHide"].triggers.instanceDifficulty.raid.legacy10heroic = true
		E.global.nameplates.filters["SyneHide"].triggers.instanceDifficulty.raid.legacy25heroic = true

		E.global.nameplates.filters["SyneHide"].actions.hide = true

		-- Enable Filters
		E.db.nameplates.filters["SyneStyle"] = {
			triggers = { enable = true }
		}
		E.db.nameplates.filters["SyneHide"] = {
			triggers = { enable = true }
		}


	--[[----------------------------------
	--	PrivateDB - Skins
	--]]----------------------------------


	--[[----------------------------------
	--	ProfileDB - Tooltip
	--]]----------------------------------
		E.db.tooltip.font = "Agency FB Bold"
		E.db.tooltip.fontOutline = "NONE"
		E.db.tooltip.headerFontSize = 16
		E.db.tooltip.fontSize = 14
		E.db.tooltip.textFontSize = 14
		E.db.tooltip.smallTextFontSize = 14

		E.db.tooltip.useCustomFactionColors = true
		E.db.tooltip.factionColors[1] = { r = 222/255, g = 95/255,  b = 95/255 } -- Hated
		E.db.tooltip.factionColors[2] = { r = 222/255, g = 95/255,  b = 95/255 } -- Hostile
		E.db.tooltip.factionColors[3] = { r = 222/255, g = 95/255,  b = 95/255 } -- Unfriendly
		E.db.tooltip.factionColors[4] = { r = 218/255, g = 197/255, b = 92/255 } -- Neutral
		E.db.tooltip.factionColors[5] = { r = 75/255,  g = 175/255, b = 76/255 } -- Friendly
		E.db.tooltip.factionColors[6] = { r = 75/255,  g = 175/255, b = 76/255 } -- Honored
		E.db.tooltip.factionColors[7] = { r = 75/255,  g = 175/255, b = 76/255 } -- Revered
		E.db.tooltip.factionColors[8] = { r = 75/255,  g = 175/255, b = 76/255 } -- Exalted	

		E.db.tooltip.healthBar.height = 10
		E.db.tooltip.healthBar.statusPosition = "TOP"
		E.db.tooltip.healthBar.text = true
		E.db.tooltip.healthBar.font = "BigNoodleTitling"
		E.db.tooltip.healthBar.fontSize = 14
		E.db.tooltip.healthBar.fontOutline = "OUTLINE"


	--[[----------------------------------
	--	ProfileDB - Unitframes
	--]]----------------------------------
		--Misc
			E.db.unitframe.enable = true
			E.db.unitframe.smoothbars = true
			E.db.unitframe.OORAlpha = .4
			--E.db.unitframe.debuffHighlighting = false

		--Fonts
			E.db.unitframe.font = "BigNoodleTitling"
			E.db.unitframe.fontSize = 14
			E.db.unitframe.fontOutline = "OUTLINE"

		--Colors
			-- Done in SetupColors()

		--Player
			E.db.unitframe.units.player.enable = true
			E.db.unitframe.units.player.width = 250
			E.db.unitframe.units.player.height = 40

			E.db.unitframe.units.player.castbar.enable = true
			if E.db.SY.unitframes.castbarlayout == 1 then -- Castbars inside Unitframe
				E.db.unitframe.units.player.castbar.width = 250
				E.db.unitframe.units.player.castbar.height = 12 -- 11
				E.db.unitframe.units.player.castbar.format = "CURRENTMAX"
				E.db.unitframe.units.player.castbar.xOffsetText = 5
				E.db.unitframe.units.player.castbar.yOffsetText = -4
				E.db.unitframe.units.player.castbar.xOffsetTime = -5
				E.db.unitframe.units.player.castbar.yOffsetTime = -4
				E.db.unitframe.units.player.castbar.icon = true
				E.db.unitframe.units.player.castbar.iconAttached = false
				E.db.unitframe.units.player.castbar.iconSize = 27
				E.db.unitframe.units.player.castbar.iconAttachedTo = "Castbar"
				E.db.unitframe.units.player.castbar.iconPosition = "LEFT"
				E.db.unitframe.units.player.castbar.iconXOffset = -8
				E.db.unitframe.units.player.castbar.iconYOffset = -1
			else -- Separate castbars
				E.db.unitframe.units.player.castbar.width = 272
				E.db.unitframe.units.player.castbar.height = 13
				E.db.unitframe.units.player.castbar.format = "CURRENTMAX"
				E.db.unitframe.units.player.castbar.xOffsetText = 5
				E.db.unitframe.units.player.castbar.yOffsetText = -4
				E.db.unitframe.units.player.castbar.xOffsetTime = -5
				E.db.unitframe.units.player.castbar.yOffsetTime = -4
				E.db.unitframe.units.player.castbar.icon = true
				E.db.unitframe.units.player.castbar.iconAttached = false
				E.db.unitframe.units.player.castbar.iconSize = 28
				E.db.unitframe.units.player.castbar.iconAttachedTo = "Castbar"
				E.db.unitframe.units.player.castbar.iconPosition = "LEFT"
				E.db.unitframe.units.player.castbar.iconXOffset = -10
				E.db.unitframe.units.player.castbar.iconYOffset = 13
			end

			E.db.unitframe.units.player.classbar.enable = true
			E.db.unitframe.units.player.classbar.height = 6
			E.db.unitframe.units.player.classbar.fill = "fill"
			E.db.unitframe.units.player.classbar.additionalPowerText = true
			E.db.unitframe.units.player.classbar.detachFromFrame = false
			E.db.unitframe.units.player.classbar.detachedWidth = 250 -- in case classBar is detached from unitframe by user

			E.db.unitframe.units.player.CombatIcon.enable = true
			E.db.unitframe.units.player.CombatIcon.size = 19
			E.db.unitframe.units.player.CombatIcon.xOffset = 10
			E.db.unitframe.units.player.CombatIcon.yOffset = 1
			E.db.unitframe.units.player.CombatIcon.anchorPoint = "LEFT"

			E.db.unitframe.units.player.healPrediction.enable = true

			E.db.unitframe.units.player.health.attachTextTo = "InfoPanel"
			E.db.unitframe.units.player.health.position = "RIGHT"
			E.db.unitframe.units.player.health.xOffset = 4
			E.db.unitframe.units.player.health.yOffset = -12
			E.db.unitframe.units.player.health.text_format = "[healthcolor][health:current-percent]"

			E.db.unitframe.units.player.infoPanel.enable = true
			E.db.unitframe.units.player.infoPanel.height = 0

			E.db.unitframe.units.player.name.attachTextTo = "InfoPanel"
			E.db.unitframe.units.player.name.position = "CENTER"
			E.db.unitframe.units.player.name.xOffset = 0
			E.db.unitframe.units.player.name.yOffset = -12
			E.db.unitframe.units.player.name.text_format = "[manaflash]" -- Flash "LOW MANA" if player has low mana

			E.db.unitframe.units.player.portrait.enable = true
			E.db.unitframe.units.player.portrait.overlay = true
			E.db.unitframe.units.player.portrait.fullOverlay = true
			E.db.unitframe.units.player.portrait.overlayAlpha = .15

			E.db.unitframe.units.player.power.enable = true
			E.db.unitframe.units.player.power.width = "fill"
			E.db.unitframe.units.player.power.height = 11
			E.db.unitframe.units.player.power.attachTextTo = "InfoPanel"
			E.db.unitframe.units.player.power.position = "LEFT"
			E.db.unitframe.units.player.power.xOffset = 0
			E.db.unitframe.units.player.power.yOffset = -12
			E.db.unitframe.units.player.power.text_format = "[powercolor][power:current-percent]"

			E.db.unitframe.units.player.RestIcon.enable = true

		--Target
			E.db.unitframe.units.target.enable = true
			E.db.unitframe.units.target.width = 250
			E.db.unitframe.units.target.height = 40

			E.db.unitframe.units.target.aurabar.enable = true
			E.db.unitframe.units.target.aurabar.yOffset = 8 -- With default value the first bar is partially behid the buffs

			E.db.unitframe.units.target.buffs.enable = true
			E.db.unitframe.units.target.buffs.perrow = 9
			E.db.unitframe.units.target.buffs.numrows = 1
			E.db.unitframe.units.target.buffs.sizeOverride = 0
			E.db.unitframe.units.target.buffs.xOffset = 0
			E.db.unitframe.units.target.buffs.yOffset = 2
			E.db.unitframe.units.target.buffs.spacing = 2
			E.db.unitframe.units.target.buffs.attachTo = "FRAME"
			E.db.unitframe.units.target.buffs.anchorPoint = "TOPLEFT"
			E.db.unitframe.units.target.buffs.priority = ""

			E.db.unitframe.units.target.castbar.enable = true
			if E.db.SY.unitframes.castbarlayout == 1 then -- Castbars inside Unitframe
				E.db.unitframe.units.target.castbar.width = 250
				E.db.unitframe.units.target.castbar.height = 12 -- 11
				E.db.unitframe.units.target.castbar.format = "CURRENTMAX"
				E.db.unitframe.units.target.castbar.xOffsetText = 5
				E.db.unitframe.units.target.castbar.yOffsetText = -4
				E.db.unitframe.units.target.castbar.xOffsetTime = -5
				E.db.unitframe.units.target.castbar.yOffsetTime = -4
				E.db.unitframe.units.target.castbar.icon = true
				E.db.unitframe.units.target.castbar.iconAttached = false
				E.db.unitframe.units.target.castbar.iconSize = 27
				E.db.unitframe.units.target.castbar.iconAttachedTo = "Castbar"
				E.db.unitframe.units.target.castbar.iconPosition = "RIGHT"
				E.db.unitframe.units.target.castbar.iconXOffset = 8
				E.db.unitframe.units.target.castbar.iconYOffset = -1
			else -- Separate castbars
				E.db.unitframe.units.target.castbar.width = 272
				E.db.unitframe.units.target.castbar.height = 13
				E.db.unitframe.units.target.castbar.format = "CURRENTMAX"
				E.db.unitframe.units.target.castbar.xOffsetText = 5
				E.db.unitframe.units.target.castbar.yOffsetText = -4
				E.db.unitframe.units.target.castbar.xOffsetTime = -5
				E.db.unitframe.units.target.castbar.yOffsetTime = -4
				E.db.unitframe.units.target.castbar.icon = true
				E.db.unitframe.units.target.castbar.iconAttached = false
				E.db.unitframe.units.target.castbar.iconSize = 28
				E.db.unitframe.units.target.castbar.iconAttachedTo = "Castbar"
				E.db.unitframe.units.target.castbar.iconPosition = "RIGHT"
				E.db.unitframe.units.target.castbar.iconXOffset = 10
				E.db.unitframe.units.target.castbar.iconYOffset = -14
			end

			E.db.unitframe.units.target.CombatIcon.enable = false

			E.db.unitframe.units.target.debuffs.enable = true
			E.db.unitframe.units.target.debuffs.desaturate = true
			E.db.unitframe.units.target.debuffs.perrow = 9
			E.db.unitframe.units.target.debuffs.numrows = 3
			E.db.unitframe.units.target.debuffs.sizeOverride = 0
			E.db.unitframe.units.target.debuffs.xOffset = 0
			E.db.unitframe.units.target.debuffs.yOffset = 2
			E.db.unitframe.units.target.debuffs.attachTo = "BUFFS"
			E.db.unitframe.units.target.debuffs.spacing = 2
			E.db.unitframe.units.target.debuffs.anchorPoint = "TOPRIGHT"
			E.db.unitframe.units.target.debuffs.priority = ""

			E.db.unitframe.units.target.healPrediction.enable = true

			E.db.unitframe.units.target.health.attachTextTo = "InfoPanel"
			E.db.unitframe.units.target.health.position = "RIGHT"
			E.db.unitframe.units.target.health.xOffset = 4
			E.db.unitframe.units.target.health.yOffset = -12
			E.db.unitframe.units.target.health.text_format = "[healthcolor][health:current-percent]"

			E.db.unitframe.units.target.infoPanel.enable = true
			E.db.unitframe.units.target.infoPanel.height = 0

			E.db.unitframe.units.target.name.position = "LEFT"
			E.db.unitframe.units.target.name.xOffset = 0
			E.db.unitframe.units.target.name.yOffset = -12
			E.db.unitframe.units.target.name.attachTextTo = "InfoPanel"
			E.db.unitframe.units.target.name.text_format = "[namecolor][name:long] [difficultycolor][level] [shortclassification]"

			E.db.unitframe.units.target.portrait.enable = true
			E.db.unitframe.units.target.portrait.overlay = true
			E.db.unitframe.units.target.portrait.fullOverlay = true
			E.db.unitframe.units.target.portrait.overlayAlpha = .15

			E.db.unitframe.units.target.power.enable = true
			E.db.unitframe.units.target.power.width = "fill"
			E.db.unitframe.units.target.power.height = 11
			E.db.unitframe.units.target.power.text_format = ""
			--E.db.unitframe.units.target.power.hideonnpc = false

		--TargetTarget
			E.db.unitframe.units.targettarget.enable = true
			E.db.unitframe.units.targettarget.width = 130
			E.db.unitframe.units.targettarget.height = 21

			E.db.unitframe.units.targettarget.infoPanel.enable = true
			E.db.unitframe.units.targettarget.infoPanel.height = 0

			E.db.unitframe.units.targettarget.name.position = "CENTER"
			E.db.unitframe.units.targettarget.name.xOffset = 0
			E.db.unitframe.units.targettarget.name.yOffset = -12
			E.db.unitframe.units.targettarget.name.attachTextTo = "InfoPanel"
			E.db.unitframe.units.targettarget.name.text_format = "[namecolor][name:medium]"

			E.db.unitframe.units.targettarget.power.enable = false

			--[[
			E.db.unitframe.units.targettarget.buffs.enable = false
			E.db.unitframe.units.targettarget.buffs.perrow = 5
			E.db.unitframe.units.targettarget.buffs.fontSize = 8
			E.db.unitframe.units.targettarget.buffs.sizeOverride = 0
			E.db.unitframe.units.targettarget.debuffs.enable = true
			E.db.unitframe.units.targettarget.debuffs.fontSize = 8
			E.db.unitframe.units.targettarget.debuffs.yOffset = -2
			E.db.unitframe.units.targettarget.debuffs.sizeOverride = 0
			]]

		--TargetTargetTarget
			E.db.unitframe.units.targettargettarget.enable = false

		--Focus
			E.db.unitframe.units.focus.enable = true
			E.db.unitframe.units.focus.width = 110
			E.db.unitframe.units.focus.height = 27 -- 24
			--E.db.unitframe.units.focus.disableTargetGlow = true

			E.db.unitframe.units.focus.castbar.enable = true
			E.db.unitframe.units.focus.castbar.width = 240
			E.db.unitframe.units.focus.castbar.height = 10
			E.db.unitframe.units.focus.castbar.format = "REMAINING"
			E.db.unitframe.units.focus.castbar.xOffsetText = 4
			E.db.unitframe.units.focus.castbar.yOffsetText = 1
			E.db.unitframe.units.focus.castbar.xOffsetTime = -4
			E.db.unitframe.units.focus.castbar.yOffsetTime = 1
			E.db.unitframe.units.focus.castbar.icon = true
			E.db.unitframe.units.focus.castbar.iconAttached = false
			E.db.unitframe.units.focus.castbar.iconSize = 40
			E.db.unitframe.units.focus.castbar.iconAttachedTo = "Castbar"
			E.db.unitframe.units.focus.castbar.iconPosition = "TOP"
			E.db.unitframe.units.focus.castbar.iconXOffset = 0
			E.db.unitframe.units.focus.castbar.iconYOffset = 5

			E.db.unitframe.units.focus.infoPanel.enable = true
			E.db.unitframe.units.focus.infoPanel.height = 0

			E.db.unitframe.units.focus.name.position = "CENTER"
			E.db.unitframe.units.focus.name.xOffset = 0
			E.db.unitframe.units.focus.name.yOffset = -12
			E.db.unitframe.units.focus.name.attachTextTo = "InfoPanel"
			E.db.unitframe.units.focus.name.text_format = "[namecolor][name:medium] [difficultycolor][level]"

			E.db.unitframe.units.focus.power.enable = true
			E.db.unitframe.units.focus.power.width = "fill"
			E.db.unitframe.units.focus.power.height = 8
			E.db.unitframe.units.focus.power.text_format = ""
			--E.db.unitframe.units.focus.power.hideonnpc = false

		--FocusTarget
			E.db.unitframe.units.focustarget.enable = true
			E.db.unitframe.units.focustarget.width = 110
			E.db.unitframe.units.focustarget.height = 28 -- 24
			--E.db.unitframe.units.focustarget.disableTargetGlow = true

			E.db.unitframe.units.focustarget.castbar.enable = false

			E.db.unitframe.units.focustarget.name.position = "CENTER"
			E.db.unitframe.units.focustarget.name.xOffset = 0
			E.db.unitframe.units.focustarget.name.yOffset = 0
			E.db.unitframe.units.focustarget.name.attachTextTo = "Health"
			E.db.unitframe.units.focustarget.name.text_format = "[namecolor][name:medium]"

			E.db.unitframe.units.focustarget.power.enable = true
			E.db.unitframe.units.focustarget.power.width = "fill"
			E.db.unitframe.units.focustarget.power.height = 6
			E.db.unitframe.units.focustarget.power.text_format = ""
			--E.db.unitframe.units.focus.power.hideonnpc = false

		--Pet
			E.db.unitframe.units.pet.enable = true
			E.db.unitframe.units.pet.width = 130
			E.db.unitframe.units.pet.height = 21
			--E.db.unitframe.units.pet.disableTargetGlow = true

			E.db.unitframe.units.pet.castbar.enable = true
			E.db.unitframe.units.pet.castbar.width = 130
			--E.db.unitframe.units.pet.castbar.height = 10
			E.db.unitframe.units.pet.castbar.height = 5
			E.db.unitframe.units.pet.castbar.format = "REMAINING"
			E.db.unitframe.units.pet.castbar.xOffsetText = 3
			E.db.unitframe.units.pet.castbar.yOffsetText = 1
			E.db.unitframe.units.pet.castbar.xOffsetTime = 0
			E.db.unitframe.units.pet.castbar.yOffsetTime = 1
			E.db.unitframe.units.pet.castbar.icon = false

			E.db.unitframe.units.pet.infoPanel.enable = true
			E.db.unitframe.units.pet.infoPanel.height = 0

			E.db.unitframe.units.pet.name.position = "CENTER"
			E.db.unitframe.units.pet.name.xOffset = 0
			E.db.unitframe.units.pet.name.yOffset = -12
			E.db.unitframe.units.pet.name.attachTextTo = "InfoPanel"
			E.db.unitframe.units.pet.name.text_format = "[namecolor][name:medium]"

			E.db.unitframe.units.pet.power.enable = true
			E.db.unitframe.units.pet.power.width = "fill"
			E.db.unitframe.units.pet.power.height = 6
			E.db.unitframe.units.pet.power.text_format = ""

		--PetTarget
			E.db.unitframe.units.pettarget.enable = false

		-- Party / Raid / Raid40
		if layout == "healer" then
			SY.HealLayout(layout)
		else
			SY.DPSLayout(layout)
		end

		--Tank
			E.db.unitframe.units.tank.enable = false

		--Assist
			E.db.unitframe.units.assist.enable = false

		--Arena
			E.db.unitframe.units.arena.enable = true
			E.db.unitframe.units.arena.width = 230
			E.db.unitframe.units.arena.height = 37
			E.db.unitframe.units.arena.pvpSpecIcon = true
			E.db.unitframe.units.arena.spacing = 25

			E.db.unitframe.units.arena.buffs.enable = false

			E.db.unitframe.units.arena.castbar.enable = true
			E.db.unitframe.units.arena.castbar.width = 193 --230 -- Reduce the pvpSpecIcon lenght (== height of the Frame)
			E.db.unitframe.units.arena.castbar.height = 11
			E.db.unitframe.units.arena.castbar.format = "REMAINING"
			E.db.unitframe.units.arena.castbar.xOffsetText = 1
			E.db.unitframe.units.arena.castbar.yOffsetText = 2
			E.db.unitframe.units.arena.castbar.xOffsetTime = 0
			E.db.unitframe.units.arena.castbar.yOffsetTime = 2
			E.db.unitframe.units.arena.castbar.icon = false

			E.db.unitframe.units.arena.debuffs.enable = true
			E.db.unitframe.units.arena.debuffs.perrow = 5
			E.db.unitframe.units.arena.debuffs.numrows = 1
			E.db.unitframe.units.arena.debuffs.sizeOverride = 26
			E.db.unitframe.units.arena.debuffs.xOffset = 2
			E.db.unitframe.units.arena.debuffs.yOffset = 0
			E.db.unitframe.units.arena.debuffs.spacing = 2
			E.db.unitframe.units.arena.debuffs.attachTo = "Frame"
			E.db.unitframe.units.arena.debuffs.anchorPoint = "RIGHT"

			E.db.unitframe.units.arena.healPrediction.enable = true

			E.db.unitframe.units.arena.health.attachTextTo = "InfoPanel"
			E.db.unitframe.units.arena.health.position = "LEFT"
			E.db.unitframe.units.arena.health.xOffset = 0
			E.db.unitframe.units.arena.health.yOffset = -13
			E.db.unitframe.units.arena.health.text_format = "[healthcolor][health:current-percent]"

			E.db.unitframe.units.arena.infoPanel.enable = true
			E.db.unitframe.units.arena.infoPanel.height = 0

			E.db.unitframe.units.arena.name.position = "CENTER"
			E.db.unitframe.units.arena.name.xOffset = 0
			E.db.unitframe.units.arena.name.yOffset = -13
			E.db.unitframe.units.arena.name.attachTextTo = "InfoPanel"
			E.db.unitframe.units.arena.name.text_format = "[namecolor][name:long]"

			E.db.unitframe.units.arena.power.enable = true
			E.db.unitframe.units.arena.power.width = "fill"
			E.db.unitframe.units.arena.power.height = 11
			E.db.unitframe.units.arena.power.attachTextTo = "InfoPanel"
			E.db.unitframe.units.arena.power.position = "RIGHT"
			E.db.unitframe.units.arena.power.xOffset = 0
			E.db.unitframe.units.arena.power.yOffset = -13
			E.db.unitframe.units.arena.power.text_format = "[powercolor][power:current]"

			E.db.unitframe.units.arena.pvpTrinket.enable = true
			E.db.unitframe.units.arena.pvpTrinket.position = "LEFT"
			E.db.unitframe.units.arena.pvpTrinket.size = 26
			E.db.unitframe.units.arena.pvpTrinket.xOffset = -6
			E.db.unitframe.units.arena.pvpTrinket.yOffset = 0

		--Boss
			E.db.unitframe.units.boss.enable = true
			E.db.unitframe.units.boss.width = 230
			E.db.unitframe.units.boss.height = 37
			E.db.unitframe.units.boss.spacing = 25

			E.db.unitframe.units.boss.buffs.enable = true
			E.db.unitframe.units.boss.buffs.perrow = 3
			E.db.unitframe.units.boss.buffs.numrows = 1
			E.db.unitframe.units.boss.buffs.sizeOverride = 26
			E.db.unitframe.units.boss.buffs.xOffset = -4
			E.db.unitframe.units.boss.buffs.yOffset = 0
			E.db.unitframe.units.boss.buffs.spacing = 2
			E.db.unitframe.units.boss.buffs.attachTo = "Frame"
			E.db.unitframe.units.boss.buffs.anchorPoint = "LEFT"

			E.db.unitframe.units.boss.castbar.enable = true
			E.db.unitframe.units.boss.castbar.width = 230
			E.db.unitframe.units.boss.castbar.height = 12 -- 11
			E.db.unitframe.units.boss.castbar.format = "REMAINING"
			E.db.unitframe.units.boss.castbar.xOffsetText = 1
			E.db.unitframe.units.boss.castbar.yOffsetText = 2
			E.db.unitframe.units.boss.castbar.xOffsetTime = 0
			E.db.unitframe.units.boss.castbar.yOffsetTime = 2
			E.db.unitframe.units.boss.castbar.icon = false

			E.db.unitframe.units.boss.debuffs.enable = false

			E.db.unitframe.units.boss.health.attachTextTo = "InfoPanel"
			E.db.unitframe.units.boss.health.position = "LEFT"
			E.db.unitframe.units.boss.health.xOffset = 0
			E.db.unitframe.units.boss.health.yOffset = -13
			E.db.unitframe.units.boss.health.text_format = "[healthcolor][health:current-percent]"

			E.db.unitframe.units.boss.infoPanel.enable = true
			E.db.unitframe.units.boss.infoPanel.height = 0

			E.db.unitframe.units.boss.name.position = "CENTER"
			E.db.unitframe.units.boss.name.xOffset = 0
			E.db.unitframe.units.boss.name.yOffset = -13
			E.db.unitframe.units.boss.name.attachTextTo = "InfoPanel"
			E.db.unitframe.units.boss.name.text_format = "[namecolor][name:long]"

			E.db.unitframe.units.boss.power.enable = true
			E.db.unitframe.units.boss.power.width = "fill"
			E.db.unitframe.units.boss.power.height = 11
			E.db.unitframe.units.boss.power.attachTextTo = "InfoPanel"
			E.db.unitframe.units.boss.power.position = "RIGHT"
			E.db.unitframe.units.boss.power.xOffset = 0
			E.db.unitframe.units.boss.power.yOffset = -13
			E.db.unitframe.units.boss.power.text_format = "[powercolor][power:current]"

			E.db.unitframe.units.boss.raidicon.enable = true
			E.db.unitframe.units.boss.raidicon.size = 18
			E.db.unitframe.units.boss.raidicon.attachTo = "TOP"
			E.db.unitframe.units.boss.raidicon.attachToObject = "Frame"
			E.db.unitframe.units.boss.raidicon.xOffset = 0
			E.db.unitframe.units.boss.raidicon.yOffset = 9


	--[[----------------------------------
	--  Positions
	--]]----------------------------------
		-- Set positions of some of the stuff later to their final positions through hooks and event handlers, but
		-- let's do some initial stuff for them and position the rest we don't touch.
		SetPositions(layout)


	E:StaggeredUpdateAll("OnProfileChanged", true)

	PluginInstallStepComplete.message = L["Layout Set"]
	PluginInstallStepComplete:Show()
	E.db.SY.chosenLayout = layout
end

local function SetupAddon(addon)
	if addon == "DBM" then
		if IsAddOnLoaded("DBM-Core") then
			--Use the profile creation method built into DBM. Saves me from copying redundant data.
			DBM:CreateProfile("SynesThesia")

			--DBM Settings
			DBM_AllSavedOptions["SynesThesia"]["InfoFramePoint"] = "TOPLEFT"
			DBM_AllSavedOptions["SynesThesia"]["InfoFrameX"] = 498
			DBM_AllSavedOptions["SynesThesia"]["InfoFrameY"] = -591
			DBM_AllSavedOptions["SynesThesia"]["InfoFrameLocked"] = true
			DBM_AllSavedOptions["SynesThesia"]["RangeFramePoint"] = "TOPLEFT"
			DBM_AllSavedOptions["SynesThesia"]["RangeFrameX"] = 498
			DBM_AllSavedOptions["SynesThesia"]["RangeFrameY"] = -462
			DBM_AllSavedOptions["SynesThesia"]["RangeFrameRadarPoint"] = "TOPLEFT"
			DBM_AllSavedOptions["SynesThesia"]["RangeFrameRadarX"] = 498
			DBM_AllSavedOptions["SynesThesia"]["RangeFrameRadarY"] = -462
			DBM_AllSavedOptions["SynesThesia"]["RangeFrameLocked"] = true
			DBM_AllSavedOptions["SynesThesia"]["SpecialWarningFontSize"] = 16
			DBM_AllSavedOptions["SynesThesia"]["SpecialWarningFont"] = "Interface\\AddOns\\SynesThesia\\media\\fonts\\Agency.ttf"
			DBM_AllSavedOptions["SynesThesia"]["SpecialWarningPoint"] = "CENTER"
			DBM_AllSavedOptions["SynesThesia"]["SpecialWarningX"] = 0
			DBM_AllSavedOptions["SynesThesia"]["SpecialWarningY"] = 75
			DBM_AllSavedOptions["SynesThesia"]["WarningIconLeft"] = false
			DBM_AllSavedOptions["SynesThesia"]["WarningIconRight"] = false
			DBM_AllSavedOptions["SynesThesia"]["WarningIconChat"] = false
			DBM_AllSavedOptions["SynesThesia"]["WarningFontSize"] = 20
			DBM_AllSavedOptions["SynesThesia"]["WarningFontShadow"] = true
			DBM_AllSavedOptions["SynesThesia"]["WarningFontStyle"] = "OUTLINE"
			DBM_AllSavedOptions["SynesThesia"]["WarningFont"] = "Interface\\AddOns\\SynesThesia\\media\\fonts\\Agency.ttf"
			DBM_AllSavedOptions["SynesThesia"]["WarningPoint"] = "CENTER"
			DBM_AllSavedOptions["SynesThesia"]["WarningX"] = 0
			DBM_AllSavedOptions["SynesThesia"]["WarningY"] = 150
			DBM_AllSavedOptions["SynesThesia"]["DontShowPT"] = false
			DBM_AllSavedOptions["SynesThesia"]["DontShowPTNoID"] = true
			DBM_AllSavedOptions["SynesThesia"]["PTCountThreshold"] = 11
			DBM_AllSavedOptions["SynesThesia"]["EnableModels"] = false
			DBM_AllSavedOptions["SynesThesia"]["ModelSoundValue"] = ""
			DBM_AllSavedOptions["SynesThesia"]["HPFramePoint"] = "BOTTOMRIGHT"
			DBM_AllSavedOptions["SynesThesia"]["HPFrameX"] = -221
			DBM_AllSavedOptions["SynesThesia"]["HPFrameY"] = 185
			DBM_AllSavedOptions["SynesThesia"]["HealthFrameWidth"] = 275
			DBM_AllSavedOptions["SynesThesia"]["HealthFrameGrowUp"] = true
			DBM_AllSavedOptions["SynesThesia"]["DontShowHealthFrame"] = true
			--DBM_AllSavedOptions["SynesThesia"]["MovieFilter"] = "AfterFirst"
			DBM_AllSavedOptions["SynesThesia"]["MovieFilter"] = "Never"
			DBM_AllSavedOptions["SynesThesia"]["SpamBlockBossWhispers"] = true
			DBM_AllSavedOptions["SynesThesia"]["ShowFlashFrame"] = false
			DBM_AllSavedOptions["SynesThesia"]["SpecialWarningFontCol"] = {0, 0.7, 1,}
			DBM_AllSavedOptions["SynesThesia"]["SpecialWarningFlashCol1"] = {0, 0.7, 1,}
			DBM_AllSavedOptions["SynesThesia"]["SpecialWarningFlashCol2"] = {0, 0.7, 1,}
			DBM_AllSavedOptions["SynesThesia"]["SpecialWarningFlashCol3"] = {0, 0.7, 1,}
			DBM_AllSavedOptions["SynesThesia"]["SpecialWarningFlashCol4"] = {0, 0.7, 1,}
			DBM_AllSavedOptions["SynesThesia"]["WarningColors"] = {
				{
					["r"] = 0,
					["g"] = 0.7,
					["b"] = 1,
				}, --[1]
				{
					["r"] = 0,
					["g"] = 0.7,
					["b"] = 1,
				}, --[2]
				{
					["r"] = 0,
					["g"] = 0.7,
					["b"] = 1,
				}, --[3]
				{
					["r"] = 0,
					["g"] = 0.7,
					["b"] = 1,
				}, --[4]
			}
			DBM_AllSavedOptions["SynesThesia"]["SpecialWarningFontCol"] = {
				0, --[1]
				0.7, --[2]
				1, --[3]
			}
			DBM_AllSavedOptions["SynesThesia"]["SpecialWarningFlashCol1"] = {
				0, --[1]
				0.7, --[2]
				1, --[3]
			}
			DBM_AllSavedOptions["SynesThesia"]["SpecialWarningFlashCol2"] = {
				0, --[1]
				0.7, --[2]
				1, --[3]
			}
			DBM_AllSavedOptions["SynesThesia"]["SpecialWarningFlashCol3"] = {
				0, --[1]
				0.7, --[2]
				1, --[3]
			}

			--DBM Timer Bar settings
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["FillUpBars"] = false
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["IconLeft"] = true
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["IconRight"] = false
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["ColorByType"] = true
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["Font"] = "Interface\\AddOns\\SynesThesia\\media\\fonts\\Agency.ttf"
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["FontSize"] = 8
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["Height"] = 25
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["EnlargeBarTime"] = 15
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["Style"] = "DBM"
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["ExpandUpwards"] = false
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["Texture"] = "Interface\\AddOns\\ElvUI\\media\\textures\\normTex2.tga"
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["Width"] = 230
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["Scale"] = .8
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["TimerPoint"] = "TOPLEFT"
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["TimerX"] = 384
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["TimerY"] = 0
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["BarXOffset"] = 0
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["BarYOffset"] = 5
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["HugeWidth"] = 275
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["HugeScale"] = 1
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["HugeTimerPoint"] = "CENTER"
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["HugeTimerX"] = 0
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["HugeTimerY"] = 245
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["HugeBarXOffset"] = 0
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["HugeBarYOffset"] = 0
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["StartColorR"] = 0
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["StartColorG"] = 0.7
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["StartColorB"] = 1
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["EndColorR"] = 0
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["EndColorG"] = 0.7
			DBT_AllPersistentOptions["SynesThesia"]["DBM"]["EndColorB"] = 1

			--Make sure timer position is updated right away
			DBM:ApplyProfile("SynesThesia")

			SY:Print(L["A profile for '%s' has been created."], addon)
			PluginInstallStepComplete.message = format(L["%s Profile Created"], addon)
			PluginInstallStepComplete:Show()
		else
			SY:Print(L["The AddOn '%s' is not enabled. Profile not created."], addon)
			PluginInstallStepComplete.message = format(L["%s is not enabled, aborting."], addon)
			PluginInstallStepComplete:Show()
		end
	--[[
	elseif addon == "Skada" then
		if IsAddOnLoaded("Skada") then
			SY:Print(L["A profile for '%s' has been created."], "Skada")
			PluginInstallStepComplete.message = format(L["%s Profile Created"], "Skada")
			PluginInstallStepComplete:Show()
			SkadaDB["profiles"]["SynesThesia"] = {
				["feed"] = "Damage: Raid DPS",
				["icon"] = {
					["hide"] = true,
				},
				["columns"] = {
					["Threat_Threat"] = true,
					["Damage_Percent"] = true,
					["Threat_TPS"] = false,
					["Threat_Percent"] = false,
				},
				["tooltiprows"] = 5,
				["showranks"] = false,
				["hidedisables"] = false,
				["tooltippos"] = "topleft",
				["modulesBlocked"] = {
					["Debuffs"] = true,
					["CC"] = true,
					["Interrupts"] = false,
					["TotalHealing"] = false,
					["Power"] = true,
					["Dispels"] = false,
				},
				["windows"] = {
					{
						["titleset"] = false,
						["barmax"] = 8,
						["classicons"] = false,
						["barslocked"] = true,
						["background"] = {
							["borderthickness"] = 0,
							["color"] = {
								["a"] = 0.2000000476837158,
								["r"] = 0,
								["g"] = 0,
								["b"] = 0.5019607843137255,
							},
							["height"] = 144,
							["bordertexture"] = "None",
							["margin"] = 0,
							["texture"] = "Solid",
						},
						["barfont"] = "2002",
						["name"] = "Threat",
						["classcolortext"] = true,
						["barcolor"] = {
							["a"] = 0,
							["b"] = 0.1568627450980392,
							["g"] = 0.1568627450980392,
							["r"] = 0.1568627450980392,
						},
						["barfontsize"] = 10,
						["mode"] = "Threat",
						["spark"] = false,
						["buttons"] = {
							["report"] = false,
							["menu"] = false,
							["mode"] = false,
							["segment"] = false,
							["reset"] = false,
						},
						["barwidth"] = 124.0000305175781,
						["barspacing"] = 1,
						["barbgcolor"] = {
							["a"] = 0,
							["b"] = 0.1647058823529412,
							["g"] = 0.1647058823529412,
							["r"] = 0.1647058823529412,
						},
						["enabletitle"] = false,
						["classcolorbars"] = false,
						["baraltcolor"] = {
							["r"] = 0.8431372549019608,
							["g"] = 0.8431372549019608,
							["b"] = 0.8431372549019608,
						},
						["bartexture"] = "Armory",
						["enablebackground"] = true,
						["title"] = {
							["menubutton"] = false,
							["font"] = "PF T 7 Bold",
							["fontsize"] = 8,
							["fontflags"] = "OUTLINEMONOCHROME",
							["texture"] = "Armory",
						},
					}, -- [1]
					{
						["classcolortext"] = true,
						["titleset"] = false,
						["barheight"] = 15,
						["barfontsize"] = 10,
						["scale"] = 1,
						["barcolor"] = {
							["a"] = 0,
							["b"] = 0.1647058823529412,
							["g"] = 0.1647058823529412,
							["r"] = 0.1647058823529412,
						},
						["mode"] = "Damage",
						["returnaftercombat"] = false,
						["clickthrough"] = false,
						["classicons"] = false,
						["barslocked"] = true,
						["snapto"] = true,
						["barorientation"] = 1,
						["enabletitle"] = false,
						["wipemode"] = "",
						["name"] = "Skada",
						["background"] = {
							["borderthickness"] = 0,
							["color"] = {
								["a"] = 0.2000000476837158,
								["r"] = 0,
								["g"] = 0,
								["b"] = 0.5019607843137255,
							},
							["height"] = 144,
							["bordertexture"] = "None",
							["margin"] = 0,
							["texture"] = "Solid",
						},
						["bartexture"] = "Armory",
						["spark"] = false,
						["set"] = "current",
						["barwidth"] = 246.0000305175781,
						["barspacing"] = 1,
						["hidden"] = false,
						["reversegrowth"] = false,
						["buttons"] = {
							["segment"] = false,
							["menu"] = false,
							["mode"] = false,
							["report"] = true,
							["reset"] = false,
						},
						["barfont"] = "2002",
						["title"] = {
							["color"] = {
								["a"] = 0.800000011920929,
								["r"] = 0.1019607843137255,
								["g"] = 0.1019607843137255,
								["b"] = 0.3019607843137255,
							},
							["bordertexture"] = "None",
							["font"] = "PF T 7 Ext. Bold",
							["borderthickness"] = 2,
							["fontsize"] = 8,
							["fontflags"] = "",
							["height"] = 10,
							["margin"] = 0,
							["texture"] = "Armory",
						},
						["classcolorbars"] = false,
						["display"] = "bar",
						["modeincombat"] = "",
						["barfontflags"] = "",
						["barbgcolor"] = {
							["a"] = 0,
							["b"] = 0.1647058823529412,
							["g"] = 0.1647058823529412,
							["r"] = 0.1647058823529412,
						},
					}, -- [2]
				},
			}
		else
			SY:Print(L["The AddOn '%s' is not enabled. Profile not created."], "Skada")
			PluginInstallStepComplete.message = format(L["%s is not enabled, aborting."], "Skada")
			PluginInstallStepComplete:Show()
		end
	]]
	elseif addon == "Recount" then
		if IsAddOnLoaded("Recount") then
			SY:Print(L["A profile for '%s' has been created."], addon)
			PluginInstallStepComplete.message = format(L["%s Profile Created"], addon)
			PluginInstallStepComplete:Show()
			RecountDB["profiles"]["SynesThesia"] = {
				["MainWindow"] = {
					["Buttons"] = {
						["CloseButton"] = false,
						["LeftButton"] = false,
						["ConfigButton"] = false,
						["RightButton"] = false,
					},
					["RowHeight"] = 15,
					["BarText"] = {
						["NumFormat"] = 3,
					},
					["HideTotalBar"] = false,
				},
				["SegmentBosses"] = true,
				["Colors"] = {
					["Bar"] = {
						["Bar Text"] = {
							["a"] = 1,
						},
						["Total Bar"] = {
							["a"] = 1,
						},
					},
				},
				["CurDataSet"] = "LastFightData",
				["Locked"] = true,
				["BarTexture"] = "ElvUI Norm",
				["Font"] = "PT Sans Narrow",
				["ClampToScreen"] = true,
				--["FrameStrata"] = "2-LOW",
				["BarTextColorSwap"] = false,
			}
		else
			SY:Print(L["The AddOn '%s' is not enabled. Profile not created."], addon)
			PluginInstallStepComplete.message = format(L["%s is not enabled, aborting."], addon)
			PluginInstallStepComplete:Show()
		end
	elseif addon == "InFlight" then
		if IsAddOnLoaded("InFlight_Load") then
			local loaded, reason = LoadAddOn("InFlight")
			if loaded then
				SY:Print(L["A profile for '%s' has been created."], addon)
				PluginInstallStepComplete.message = format(L["%s Profile Created"], addon)
				PluginInstallStepComplete:Show()
				InFlightDB["profiles"]["Default"] = { -- Uses either "Default" or if "Character Specific Options" is enabled, "CharacterName - RealmName".
					["spark"] = false,
					["height"] = 22,
					["width"] = 270,
					["texture"] = "ElvUI Norm",
					["border"] = "None",
					["backcolor"] = {
						["a"] = 0.600000023841858,
						["r"] = 0.101960784313725,
						["g"] = 0.101960784313725,
						["b"] = 0.101960784313725,
					},
					["barcolor"] = {
						["r"] = 0.309803921568627,
						["g"] = 0.450980392156863,
						["b"] = 0.631372549019608,
					},
					["unknowncolor"] = {
						["r"] = 0.2509803921568627,
						["g"] = 0.3098039215686275,
						["b"] = 0.6313725490196078,
					},
					["bordercolor"] = {
						["a"] = 0.800000011920929,
						["r"] = 0,
						["g"] = 0,
						["b"] = 0,
					},
					["inline"] = true,
					["font"] = "PT Sans Narrow",
					["p"] = "TOP",
					["y"] = -262,
					["x"] = 0,
				}
			else
				SY:Print(L["The AddOn '%s' couldn't be loaded: %s. Profile not created."], addon, reason)
				PluginInstallStepComplete.message = format(L["%s couldn't be loaded, aborting."], addon)
				PluginInstallStepComplete:Show()
			end
		else
			SY:Print(L["The AddOn '%s' is not enabled. Profile not created."], addon)
			PluginInstallStepComplete.message = format(L["%s is not enabled, aborting."], addon)
			PluginInstallStepComplete:Show()
		end
	end
end

local function SetupAddOnSkins(addon)
	if IsAddOnLoaded("AddOnSkins") then
		local AS = unpack(AddOnSkins)
		--[[
		if addon == "Skada" then
			SY:Print(L["%s settings for AddOnSkins have been set."], "Skada")
			PluginInstallStepComplete.message = format(L["%s settings for AddOnSkins have been set."], "Skada")
			PluginInstallStepComplete:Show()
			AS.db["EmbedSystem"] = false
			AS.db["EmbedSystemDual"] = true
			AS.db["EmbedBelowTop"] = true
			AS.db["TransparentEmbed"] = true
			AS.db["EmbedMain"] = "Skada"
			AS.db["EmbedLeft"] = "Skada"
			AS.db["EmbedRight"] = "Skada"
			AS.db["EmbedLeftWidth"] = 128
		elseif addon == "DBM" then
		]]
		if addon == "DBM" then
			SY:Print(L["%s settings for AddOnSkins have been set."], "DBM")
			PluginInstallStepComplete.message = format(L["%s settings for AddOnSkins have been set."], "DBM")
			PluginInstallStepComplete:Show()
			AS.db["DBMFont"] = "Agency FB Bold"
			AS.db["DBMFontSize"] = 15
			AS.db["DBMFontFlag"] = "OUTLINE"
		elseif addon == "Recount" then
			SY:Print(L["%s settings for AddOnSkins have been set."], "Recount")
			PluginInstallStepComplete.message = format(L["%s settings for AddOnSkins have been set."], "Recount")
			PluginInstallStepComplete:Show()
			AS.db["EmbedSystem"] = true
			AS.db["EmbedSystemDual"] = false
			AS.db["EmbedBelowTop"] = true
			AS.db["EmbedOoC"] = true
			AS.db["EmbedMain"] = "Recount"
			AS.db["EmbedLeft"] = "Recount"
			AS.db["EmbedRight"] = "Recount"
		end
	else
		SY:Print(L["The AddOn 'AddOnSkins' is not enabled. No settings have been changed."])
		PluginInstallStepComplete.message = format(L["%s is not enabled, aborting."], "AddOnSkins")
		PluginInstallStepComplete:Show()
	end
end

local function InstallComplete()
	E.db.SY.install_version = SY.version

	if GetCVarBool("Sound_EnableMusic") then
		StopMusic()
	end

	ReloadUI()
end

SY.PluginInstaller = {
	Title = "Syne's Thesia Installation",
	Name = "Syne's Thesia",
	tutorialImage = "Interface\\AddOns\\SynesThesia\\media\\textures\\logo_synesthesia.tga",
	Pages = {
		[1] = function()
			PluginInstallFrame.SubTitle:SetText(format(L["Welcome to %s version %s,\nfor ElvUI version %s and above."], SY.title, SY:ColorStr(SY.version), SY:ColorStr(SY.versionMinE)))
			PluginInstallFrame.Desc1:SetText(L["This installation process will guide you through a few steps and apply settings to your current ElvUI profile. If you want to be able to go back to your original settings then create a new profile (/ec -> Profiles) before going through this installation process."])
			PluginInstallFrame.Desc2:SetText(format(L["Options provided by this edit can be found in the %s category of the ElvUI Config (/ec)."], SY.title))
			PluginInstallFrame.Desc3:SetText(L["Please press the continue button if you wish to go through the installation process, otherwise click the 'Skip Process' button."])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", InstallComplete)
			PluginInstallFrame.Option1:SetText(L["Skip Process"])
		end,
		[2] = function()
			PluginInstallFrame.SubTitle:SetText(L["CVars"])
			PluginInstallFrame.Desc1:SetText(format(L["This step changes a few World of Warcraft default options. These options are partially copied from Syne's Edit and partially tailored to the needs of the author of %s and are not necessary for this edit to function."], SY.title))
			PluginInstallFrame.Desc2:SetText(L["Please click the button below to setup your CVars."])
			PluginInstallFrame.Desc3:SetText(L["Importance: |cffFF0000Low|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", SetupCVars)
			PluginInstallFrame.Option1:SetText(L["Setup CVars"])
		end,
		[3] = function()
			PluginInstallFrame.SubTitle:SetText(L["Chat"])
			PluginInstallFrame.Desc1:SetText(format(L["This step changes your chat windows and positions them all in the left chat panel. These changes are partially copied from Syne's Edit and partially tailored to the needs of the author of %s and are not necessary for this edit to function."], SY.title))
			PluginInstallFrame.Desc2:SetText(L["Please click the button below to setup your chat windows."])
			PluginInstallFrame.Desc3:SetText(L["Importance: |cffFF0000Low|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", SetupChat)
			PluginInstallFrame.Option1:SetText(L["Setup Chat"])
		end,
		[4] = function()
			PluginInstallFrame.SubTitle:SetText(L["Color Themes"])
			PluginInstallFrame.Desc1:SetText(L["This part of the installation will apply a Color Theme"])
			PluginInstallFrame.Desc2:SetText(L["Please click a button below to apply a color theme."])
			PluginInstallFrame.Desc3:SetText(L["Importance: |cffFF0000Low|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() SetupColors("classic") end)
			PluginInstallFrame.Option1:SetText(L["Classic"])
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", function() SetupColors("default") end)
			PluginInstallFrame.Option2:SetText(L["Dark"])
			PluginInstallFrame.Option3:Show()
			PluginInstallFrame.Option3:SetScript("OnClick", function() SetupColors("class") end)
			PluginInstallFrame.Option3:SetText(CLASS)
		end,
		[5] = function()
			PluginInstallFrame.SubTitle:SetText(L["Layouts"])
			PluginInstallFrame.Desc1:SetText(format(L["These are the layouts mimicking the original Syne's Edit layouts. There isn't any difference between Tank- and DPS-layouts, but the Healer-layout is different from others.\n\nYou can change the layout after install with slash-commands %s for Tank/DPS-layout and %s for Healer-layout."], SY:ColorStr("/dps"), SY:ColorStr("/heal")))
			PluginInstallFrame.Desc2:SetText(L["Please click any one button below to apply the layout of your choosing."])
			PluginInstallFrame.Desc3:SetText(L["Importance: |cff07D400High|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() SetupLayout("tank") end)
			PluginInstallFrame.Option1:SetText(L["Tank"])
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", function() SetupLayout("healer") end)
			PluginInstallFrame.Option2:SetText(L["Healer"])
			PluginInstallFrame.Option3:Show()
			PluginInstallFrame.Option3:SetScript("OnClick", function() SetupLayout("dpsMelee") end)
			PluginInstallFrame.Option3:SetText(L["Physical DPS"])
			PluginInstallFrame.Option4:Show()
			PluginInstallFrame.Option4:SetScript("OnClick", function() SetupLayout("dpsCaster") end)
			PluginInstallFrame.Option4:SetText(L["Caster DPS"])
		end,
		[6] = function()
			PluginInstallFrame.SubTitle:SetText(L["AddOns"])
			PluginInstallFrame.Desc1:SetFormattedText(L["This step allows you to apply pre-configured settings to various AddOns in order to make their appearance match %s."], SY.title)
			PluginInstallFrame.Desc2:SetFormattedText(L["Please click any button below to apply the pre-configured settings for that particular AddOn. A new profile named %s will be created for that particular AddOn, which you might have to select manually."], SY.title)
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() SetupAddon("DBM") end)
			PluginInstallFrame.Option1:SetText("DBM")
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", function() SetupAddon("Recount") end)
			PluginInstallFrame.Option2:SetText("Recount")
			PluginInstallFrame.Option3:Show()
			PluginInstallFrame.Option3:SetScript("OnClick", function() SetupAddon("InFlight") end)
			PluginInstallFrame.Option3:SetText("InFlight")
		end,
		[7] = function()
			PluginInstallFrame.SubTitle:SetText(L["AddOnSkins Configuration"])
			PluginInstallFrame.Desc1:SetFormattedText(L["This step allows you to apply pre-configured settings to AddOnSkins in order to make certain AddOns match %s."], SY.title)
			PluginInstallFrame.Desc2:SetText(L["Please click any button below to apply the pre-configured settings for that particular AddOn to the AddOnSkins settings."])
			--[[
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() SetupAddOnSkins("Skada") end)
			PluginInstallFrame.Option1:SetText("Skada")
			]]
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() SetupAddOnSkins("DBM") end)
			PluginInstallFrame.Option1:SetText("DBM")
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", function() SetupAddOnSkins("Recount") end)
			PluginInstallFrame.Option2:SetText("Recount")
		end,
		[8] = function()
			PluginInstallFrame.SubTitle:SetText(L["Installation Complete"])
			PluginInstallFrame.Desc1:SetText(L["You have completed the installation process.\nIf you need help or wish to report a bug, please go to http://tukui.org"])
			PluginInstallFrame.Desc2:SetText(L["Please click the button below in order to finalize the process and automatically reload your UI."])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", InstallComplete)
			PluginInstallFrame.Option1:SetText(L["Finished"])
		end,
	},
	StepTitles = {
		[1] = "Welcome",
		[2] = "WoW Client Settings",
		[3] = "Chat Setup",
		[4] = "Color Themes",
		[5] = "Layouts",
		[6] = "3rd Party AddOns",
		[7] = "AddOnSkins",
		[8] = "Installation Complete",
	},
	StepTitlesColor = {1, 1, 1},
	StepTitlesColorSelected = {0, 179/255, 1},
	StepTitleWidth = 200,
	StepTitleButtonWidth = 180,
	StepTitleTextJustification = "RIGHT",
}