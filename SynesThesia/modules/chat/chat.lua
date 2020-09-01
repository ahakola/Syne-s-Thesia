--[[----------------------------------------------------------
--	Syne's Thesia, an ElvUI edit by ahak @ tukui.org
--
--	This file contains changes/additions to the ElvUI Chat
--
--  Something in this file causes following error when I
--  recieve first whisper (opening new whisper- or BN-Chat)
--  from someone while in CombatLockdown:
--
--  1x [ADDON_ACTION_BLOCKED] AddOn 'ElvUI' tried to call the protected function 'RightChatPanel:SetSize()'.
--  [string "@!BugGrabber\BugGrabber.lua"]:519: in function <!BugGrabber\BugGrabber.lua:519>
--  [string "=[C]"]: in function `SetSize'
--  [string "@ElvUI\Core\Toolkit.lua"]:191: in function `Size'
--  [string "@ElvUI\Modules\chat\Chat-Chat.lua"]:869: in function <ElvUI\Modules\chat\Chat.lua:863>
--  [string "=[C]"]: in function `PositionChat'
--  [string "@ElvUI\Modules\chat\Chat-Chat.lua"]:1810: in function <ElvUI\Modules\chat\Chat.lua:1770>
--  [string "=[C]"]: in function `?'
--  [string "@AddOnSkins\Libs\Ace3\AceHook-3.0\AceHook-3.0-8.lua"]:103: in function <...Ons\AddOnSkins\Libs\Ace3\AceHook-3.0\AceHook-3.0.lua:100>
--  [string "=[C]"]: in function `FCF_OpenTemporaryWindow'
--  [string "@FrameXML\FloatingChatFrame.lua"]:2560: in function <FrameXML\FloatingChatFrame.lua:2549>
--
--  Later whispers from same user after the first whisper (the
--  one that opens the new tab) doesn't cause any additional
--  errors.
--
--  Probably something to do with I'm not properly callin APIs
--  inside the WoW RestrictedEnvironment when setting up new
--  chat-tab?
----------------------------------------------------------]]--
local E, L, V, P, G, _ = unpack(ElvUI) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local CH = E:GetModule("Chat")
local SY = E:GetModule("SynesThesia")
local LSM = LibStub("LibSharedMedia-3.0")

local ChatFont = LSM:Fetch("font", SY.media.chat)
local ChatFontSize = 13

local knownRightChats = {}
local function IsRightChat(chatId)
	if not (E.db.SY and E.db.SY.chat and E.db.SY.chat.timestampsOnRight) then
		return false
	end

	-- Maybe caching is faster than iterating through the frames all the time?
	if knownRightChats[chatId] == nil then
		-- Iterate throuh all of the chat frames to cache results for later use
		for _, frameName in pairs(_G.CHAT_FRAMES) do
			local chat = _G[frameName]
			local id = chat:GetID()

			knownRightChats[id] = (E:FramesOverlap(chat, _G.RightChatPanel) and not E:FramesOverlap(chat, _G.LeftChatPanel))
		end
	end

	return knownRightChats[chatId]
end

-- Modified copy of ElvUI's AddMessage-function just to have timestamps on the right side
function SY.AddMessage(self, msg, infoR, infoG, infoB, infoID, accessID, typeID, isHistory, historyTime)
	local historyTimestamp --we need to extend the arguments on AddMessage so we can properly handle times without overriding
	if isHistory == "ElvUI_ChatHistory" then historyTimestamp = historyTime end

	if (CH.db.timeStampFormat and CH.db.timeStampFormat ~= "NONE" ) then
		local timeStamp = BetterDate(CH.db.timeStampFormat, historyTimestamp or time())
		timeStamp = gsub(timeStamp, " ", "")
		timeStamp = gsub(timeStamp, "AM", " AM")
		timeStamp = gsub(timeStamp, "PM", " PM")
		if CH.db.useCustomTimeColor then
			local color = CH.db.customTimeColor
			local hexColor = E:RGBToHex(color.r, color.g, color.b)
			if IsRightChat(self:GetID()) then
				msg = format("%s %s[%s]|r", msg, hexColor, timeStamp)
			else
				msg = format("%s[%s]|r %s", hexColor, timeStamp, msg)
			end
		else
			if IsRightChat(self:GetID()) then
				msg = format("%s [%s]", msg, timeStamp)
			else
				msg = format("[%s] %s", timeStamp, msg)
			end
		end
	end

	if CH.db.copyChatLines then
		if IsRightChat(self:GetID()) then
			msg = format("%s |Hcpl:%s|h%s|h", msg, self:GetID(), E:TextureString(E.Media.Textures.ArrowRight, ":14"))
		else
			msg = format("|Hcpl:%s|h%s|h %s", self:GetID(), E:TextureString(E.Media.Textures.ArrowRight, ":14"), msg)
		end
	end

	self.OldAddMessage(self, msg, infoR, infoG, infoB, infoID, accessID, typeID)
end

--Replace function to prevent it from setting timestamp
function CH:AddMessage(text, ...)
	return SY.AddMessage(self, text, ...)
end


local function positionEditbox(editbox)
	editbox:ClearAllPoints()
	--editbox:SetPoint("TOPRIGHT", ChatLineLeft2, "BOTTOMRIGHT", 0, E:Scale(-4))
	--editbox:SetPoint("BOTTOMLEFT", ChatLineLeft2, "BOTTOMLEFT", 0, E:Scale(-12))
	editbox:SetPoint("TOPRIGHT", ChatLineLeft2, "BOTTOMRIGHT", 0, E:Scale(-3))
	editbox:SetPoint("BOTTOMLEFT", ChatLineLeft2, "BOTTOMLEFT", 0, E:Scale(-21))
end

local CreatedFrames = 0
local function UpdateChatStyle(self, frame)
	local id = frame:GetID()
	local chat = frame:GetName()
	local tab = _G[chat.."Tab"]
	local editbox = _G[chat.."EditBox"]

	--SY:Print("UpdateChatStyle", chat, editbox:GetName()) -- Debug

	positionEditbox(editbox)

	editbox:SetTemplate("Transparent")
	editbox:SetBackdropColor(0, 0, 0, 0)
	--editbox:SetBackdropBorderColor(0, 0, 0, 0)
	editbox:SetBackdropBorderColor(0, 0, 0, .5)

	-- create our own texture for edit box
	local EditBoxBackground = CreateFrame("frame", chat.."EditBoxBackground", editbox)
	SY:LeftGradient(EditBoxBackground, 1, 1, "LEFT", editbox, "LEFT", 0, 0)
	EditBoxBackground:ClearAllPoints()
	EditBoxBackground:SetPoint("TOPRIGHT", ChatLineLeft2, "BOTTOMRIGHT")
	EditBoxBackground:SetPoint("BOTTOMLEFT", ChatLineLeft2, "BOTTOMLEFT", 0, E:Scale(-24))
	EditBoxBackground:SetFrameStrata("LOW")
	EditBoxBackground:SetFrameLevel(1)

	editbox:SetHeight(24)

	-- I'm not 100% sure this does anything let alone what it is supposed to be doing...
	local function colorize(r,g,b)
		--SY:Print("Colorize", r, g, b) -- Debug
		EditBoxBackground:SetBackdropBorderColor(r, g, b)
	end

	-- update border color according where we talk
	hooksecurefunc("ChatEdit_UpdateHeader", function(editbox)
		local chatType = editbox:GetAttribute("chatType")
		if not chatType then return end

		local ChatTypeInfo = _G.ChatTypeInfo
		local info = ChatTypeInfo[chatType]
		local chanTarget = editbox:GetAttribute("channelTarget")
		local chanName = chanTarget and GetChannelName(chanTarget)

		if chanName and (chatType == "CHANNEL") then
			if chanName == 0 then
				colorize(unpack(SY.media.bordercolor))
			else
				info = ChatTypeInfo[chatType..chanName]
				colorize(info.r, info.g, info.b)
			end
		else
			colorize(info.r, info.g, info.b)
		end
	end)

	CreatedFrames = id
end
hooksecurefunc(CH, "StyleChat", UpdateChatStyle)

local function SetupChat(self)
	--SY:Print("SetupChat") -- Debug
	-- Let's clear this to be sure if we have new frames to be handled
	wipe(knownRightChats)
end
hooksecurefunc(CH, "SetupChat", SetupChat)

local function UpdateAnchors(self)
	--SY:Print("UpdateAnchors") -- Debug

	for _, frameName in pairs(_G.CHAT_FRAMES) do
		local editBox = _G[frameName.."EditBox"]
		if not editBox then break end

		positionEditbox(editBox)
	end
end
hooksecurefunc(CH, "UpdateAnchors", UpdateAnchors)

-- From Syne's Edit
local function SetupChatFont()	
	--SY:Print("SetupChatFont") -- Debug

	--for i = 1, NUM_CHAT_WINDOWS do
	for i = 1, CreatedFrames do
		local chat = _G[format("ChatFrame%s", i)]
		--local tab = _G[format("ChatFrame%sTab", i)]
		local id = chat:GetID()
		local name = FCF_GetChatWindowInfo(id)
		local point = GetChatWindowSavedPosition(id)
		--local _, fontSize = FCF_GetChatWindowInfo(id)

		-- Change the chat frame font 
		_G["ChatFrame"..i]:SetFont(ChatFont, ChatFontSize)

		-- set font align to right if a any chat is found at right of your screen.
		if i == 3 or name == (LOOT.." / "..TRADE) or point == "RIGHT" or point == "TOPRIGHT" then
			chat:SetJustifyH("RIGHT")
		end
	end

	-- reposition battle.net popup over chat #1
	--BNToastFrame:HookScript("OnShow", function(self)
	--	self:ClearAllPoints()
	--	self:SetPoint("BOTTOMLEFT", ChatLineLeft1, "TOPLEFT", E:Scale(10), E:Scale(5))
	--end)
	SY:SetMoverPosition("BNETMover", "BOTTOMLEFT", LeftChatPanel, "TOPLEFT", E:Scale(10), E:Scale(5))
	SY:SetMoverPosition("TooltipMover", "BOTTOMRIGHT", RightChatPanel, "TOPRIGHT", E:Scale(-9), E:Scale(-33))
end

-- Introduce these here because we need to be ready to RegisterEvent in the UpdateChatPosition-hook
local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", function(self, event, ...)
	return self[event] and self[event](self, event, ...)
end)
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

local function UpdateChatPosition(self, override)
	--if InCombatLockdown() then -- In combat, let's do this later
	if ((InCombatLockdown() and not override and self and self.initialMove) or (IsMouseButtonDown("LeftButton") and not override)) then
		--SY:Print("UpdateChatPosition -> InCombatLockdown", override) -- Debug
		frame:RegisterEvent("PLAYER_REGEN_ENABLED")
		return false
	end
	--SY:Print("UpdateChatPosition", override) -- Debug

	--for i = 1, NUM_CHAT_WINDOWS do
	for i = 1, CreatedFrames do
		local chat = _G[format("ChatFrame%s", i)]
		local id = chat:GetID()
		local name = FCF_GetChatWindowInfo(id)

		if chat:IsShown() and id <= NUM_CHAT_WINDOWS then
			-- force chat position on #1 and #4, needed if we change ui scale or resolution
			-- also set original width and height of chatframes 1 and 4 if first time we run tukui.
			-- doing resize of chat also here for users that hit "cancel" when default installation is show.
			if i == 1 then
				chat:ClearAllPoints()
				--chat:SetPoint("BOTTOMLEFT", LeftChat, "BOTTOMLEFT", E:Scale(4), E:Scale(4))
				chat:SetPoint("BOTTOMLEFT", LeftChat, "BOTTOMLEFT", E:Scale(4), 0)
				chat:SetPoint("TOPRIGHT", LeftChat, "TOPRIGHT", E:Scale(-4), 0)
				--FCF_SavePositionAndDimensions(chat)
				if chat:GetLeft() then
					FCF_SavePositionAndDimensions(chat, true) -- 2nd parameter is part of ElvUI hacks to prevent looping on some hook they are doing or something important like that
				end
			elseif i == 3 and name == (LOOT.." / "..TRADE) then
				if not chat.isDocked then
					chat:ClearAllPoints()
					--chat:SetPoint("BOTTOMLEFT", RightChat, "BOTTOMLEFT", E:Scale(4), E:Scale(4))
					chat:SetPoint("BOTTOMLEFT", RightChat, "BOTTOMLEFT", E:Scale(4), 0)
					chat:SetPoint("TOPRIGHT", RightChat, "TOPRIGHT", E:Scale(-4), 0)
					--FCF_SavePositionAndDimensions(chat)
					if chat:GetLeft() then
						FCF_SavePositionAndDimensions(chat, true) -- 2nd parameter is part of ElvUI hacks to prevent looping on some hook they are doing or something important like that
					end
				end
			end
		end
	end

	SY:SetMoverPosition("BNETMover", "BOTTOMLEFT", LeftChatPanel, "TOPLEFT", E:Scale(10), E:Scale(5))
	SY:SetMoverPosition("TooltipMover", "BOTTOMRIGHT", RightChatPanel, "TOPRIGHT", E:Scale(-9), E:Scale(-33))
end
--hooksecurefunc(CH, "PositionChat", UpdateChatPosition)

function frame:ADDON_LOADED(event, addon)
	if addon == "Blizzard_CombatLog" then
		self:UnregisterEvent(event)
		SetupChat()
	end
end
function frame:PLAYER_ENTERING_WORLD(event, isInitialLogin, isReloadingUi)
	self:UnregisterEvent(event)
	SetupChatFont()
	--UpdateChatPosition()
end
function frame:PLAYER_REGEN_ENABLED(event)
	self:UnregisterEvent(event)
	--UpdateChatPosition(nil, true) -- Combat over, let's override
end


--Chat options
local function ChatOptions()
	E.Options.args.SY.args.chat = {
		order = 300,
		type = "group",
		name = L["Chat"],
		args = {
			chatHeader = {
				order = 10,
				type = "header",
				name = SY:ColorStr(L["Chat"]),
			},
			timestampsOnRight = {
				order = 20,
				type = "toggle",
				name = L["Right Timestamps"],
				desc = L["Set timestamps to the right side of the ChatFrame on the RightChatPanel"],
				get = function(info) return E.db.SY.chat[ info[#info] ] end,
				set = function(info, value) E.db.SY.chat[ info[#info] ] = value; SetupChat(); end,
			},
		},
	}
end
SY.configs["chat"] = ChatOptions