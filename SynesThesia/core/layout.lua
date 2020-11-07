--[[------------------------------------------------------------------------
--	Syne's Thesia, an ElvUI edit by ahak @ tukui.org
--
--	This file contains changes/additions to the various ElvUI panels
------------------------------------------------------------------------]]--
local E, L, V, P, G, _ = unpack(ElvUI) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local LO = E:GetModule("Layout")
local DT = E:GetModule("DataTexts")
local SY = E:GetModule("SynesThesia")
local LSM = LibStub("LibSharedMedia-3.0")

local DTFont = LSM:Fetch("font", SY.media.font)

--Cache global variables
--Lua functions
local unpack = unpack
--WoW API / Variables
local CreateFrame = CreateFrame

--Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS: LeftChatDataPanel, LeftChatToggleButton, RightChatDataPanel, RightChatToggleButton
-- GLOBALS: LeftChatPanel, RightChatPanel, LeftMiniPanel, Minimap
-- GLOBALS: RightChatTab, ElvUI_Bar1, LeftChatTabSeparator
-- GLOBALS: RightChatTabSeparator, LeftDataPanelSeparator, RightDataPanelSeparator

local PANEL_HEIGHT = 22

function SY:InitializeLayout()
	local barBG = CreateFrame("Frame", "SynesActionBarBackground", E.UIParent)
	barBG:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, E:Scale(44))

	if E.db.SY.actionbar.smallbottom then
		barBG:SetWidth((E.db.actionbar.bar1.buttonsize * 12) + (E.db.actionbar.bar1.buttonspacing * 13))
		barBG:SetHeight(SY.CalculateBarBGHeight())
	else
		barBG:SetWidth((E.db.actionbar.bar1.buttonsize * 22) + (E.db.actionbar.bar1.buttonspacing * 23))
		barBG:SetHeight(SY.CalculateBarBGHeight())
	end

	barBG:SetFrameStrata("BACKGROUND")
	barBG:SetFrameLevel(1)
	--barBG:SetTemplate("Transparent") -- Debug

	local BottomLine1 = CreateFrame("Frame", "BottomLine1", E.UIParent)
	SY:CenterGradientH(BottomLine1, WorldFrame:GetWidth(), 8, "TOP", barBG, "BOTTOM" , 0, E:Scale(-3))

	local w = 480 + ((E.db.actionbar.bar1.buttonsize - 27) * 12) -- Original size of the bar, but we use bigger buttonsize so we extend the bar a bit (this should be +60px)
	local BottomLine2 = CreateFrame("Frame", "BottomLine2", E.UIParent)
	SY:CenterGradientH(BottomLine2, E:Scale(w), 8, "BOTTOM", barBG, "TOP" , 0, E:Scale(3))

	-- Just incase we need these later
	SY.barBG = barBG
	SY.BottomLine1 = BottomLine1
	SY.BottomLine2 = BottomLine2

	--Create extra panels
	--SY:CreateExtraDataBarPanels() -- Not needed in 9.0, using ElvUI's new custm DTPanels feature instead
end
hooksecurefunc(LO, "Initialize", SY.InitializeLayout)

-- FIX THIS
function SY:SetDataPanelStyle()
	LeftMiniPanel:SetTemplate("Transparent")
	LeftMiniPanel:SetBackdropColor(0, 0, 0, 0)
	LeftMiniPanel:SetBackdropBorderColor(0, 0, 0, 0)
	RightMiniPanel:SetTemplate("Transparent")
	RightMiniPanel:SetBackdropColor(0, 0, 0, 0)
	RightMiniPanel:SetBackdropBorderColor(0, 0, 0, 0)

	if not self.extraPanelsCreated then
		return
	end
end
--hooksecurefunc(LO, "SetDataPanelStyle", SY.SetDataPanelStyle)

function SY:CreateAndModifyChatPanels()
	-- CHAT BACKGROUNDS
	-- Left Chat
	local LeftChat = CreateFrame("Frame", "LeftChat", E.UIParent)
	SY:LeftGradient(LeftChat, E:Scale(370), E:Scale(E.db.chat.panelHeight), "BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 0, E:Scale(80))
	LeftChat:ClearAllPoints()
	LeftChat:SetPoint("BOTTOMLEFT", LeftChatPanel)
	LeftChat:SetPoint("TOPRIGHT", LeftChatPanel, 0, -25)
	LeftChat:SetAlpha(.5)

	-- Right Chat
	local RightChat = CreateFrame("Frame", "RightChat", E.UIParent)
	SY:RightGradient(RightChat, E:Scale(370), E:Scale(E.db.chat.panelHeight), "BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", 0, E:Scale(80))
	RightChat:ClearAllPoints()
	RightChat:SetPoint("BOTTOMRIGHT", RightChatPanel)
	RightChat:SetPoint("TOPLEFT", RightChatPanel, 0, -25)
	RightChat:SetAlpha(.5)

	-- CHATLINES
	-- Left
	local ChatLineLeft1 = CreateFrame("Frame", "ChatLineLeft1", E.UIParent)
	SY:LeftGradient(ChatLineLeft1, LeftChat:GetWidth(), 8, "BOTTOMLEFT", LeftChat, "TOPLEFT")

	local ChatLineLeft2 = CreateFrame("Frame", "ChatLineLeft2", E.UIParent)
	SY:LeftGradient(ChatLineLeft2, LeftChat:GetWidth(), 8, "TOPLEFT", LeftChat, "BOTTOMLEFT")

	-- Right
	local ChatLineRight1 = CreateFrame("Frame", "ChatLineRight1", E.UIParent)
	SY:RightGradient(ChatLineRight1, RightChat:GetWidth(), 8, "BOTTOMRIGHT", RightChat, "TOPRIGHT")

	local ChatLineRight2 = CreateFrame("Frame", "ChatLineRight2", E.UIParent)
	SY:RightGradient(ChatLineRight2, RightChat:GetWidth(), 8, "TOPRIGHT", RightChat, "BOTTOMRIGHT")
end
hooksecurefunc(LO, "CreateChatPanels", SY.CreateAndModifyChatPanels)

--Create extra panels
function SY:CreateExtraDataBarPanels()
	local bline = BottomLine1
	for i = 1, 8 do
		local obj = CreateFrame("Frame", "SynesDataText"..i, E.UIParent)
		obj:SetSize(100, 25)
		
		if i == 1 then
			obj:SetPoint("TOP", bline, "BOTTOM", -420, 0)
		elseif i == 2 then
			obj:SetPoint("TOP", bline, "BOTTOM", -300, 0)
		elseif i == 3 then
			obj:SetPoint("TOP", bline, "BOTTOM", -180, 0)
		elseif i == 4 then
			obj:SetPoint("TOP", bline, "BOTTOM", -60, 0)
		elseif i == 5 then
			obj:SetPoint("TOP", bline, "BOTTOM", 60, 0)
		elseif i == 6 then
			obj:SetPoint("TOP", bline, "BOTTOM", 180, 0)
		elseif i == 7 then
			obj:SetPoint("TOP", bline, "BOTTOM", 300, 0)
		elseif i == 8 then
			obj:SetPoint("TOP", bline, "BOTTOM", 420, 0)
		end

		obj:Hide()
		self["SynesDataText"..i] = obj

		DT:RegisterPanel(obj, 1, "ANCHOR_BOTTOM", 0, 0)
	end

	local lobj = CreateFrame("Frame", "SynesLeftDataText", E.UIParent)
	lobj:SetSize(300, 25)
	lobj:SetPoint("TOP", ChatLineLeft2, "BOTTOM", 0, 0)
	lobj:Hide()
	self["SynesLeftDataText"] = lobj

	DT:RegisterPanel(lobj, 3, "ANCHOR_BOTTOM", 0, 0)

	local robj = CreateFrame("Frame", "SynesRightDataText", E.UIParent)
	robj:SetSize(300, 25)
	robj:SetPoint("TOP", ChatLineRight2, "BOTTOM", 0, 0)
	robj:Hide()
	self["SynesRightDataText"] = robj

	DT:RegisterPanel(robj, 3, "ANCHOR_BOTTOM", 0, 0)

	-- Battleground Datatext Panels with fake Datatexts
	local lbg = CreateFrame("Frame", "SynesLeftBGDataText", E.UIParent)
	lbg:SetSize(300, 25)
	lbg:SetPoint("TOP", ChatLineLeft2, "BOTTOM", 0, 0)
	lbg:SetScript("OnEnter", DT.BattlegroundStats)
	lbg:SetScript("OnLeave", DT.Data_OnLeave)

	for i = 1, 3 do -- Fake DTs
		local dt = lbg:CreateFontString(nil, "OVERLAY")
		dt:SetSize(100, 27)
		dt:SetFont(DTFont, 14, "THINOUTLINE")
		dt:SetJustifyH("CENTER")
		dt:SetJustifyV("MIDDLE")

		lbg[i] = dt
	end
	lbg[1]:SetPoint("CENTER", lbg, "CENTER")
	lbg[2]:SetPoint("RIGHT", lbg[1], "LEFT", -4, 0)
	lbg[3]:SetPoint("LEFT", lbg[1], "RIGHT", 4, 0)

	lbg:Hide()
	self["SynesLeftBGDataText"] = lbg

	local rbg = CreateFrame("Frame", "SynesRightBGDataText", E.UIParent)
	rbg:SetSize(300, 25)
	rbg:SetPoint("TOP", ChatLineRight2, "BOTTOM", 0, 0)
	rbg:SetScript("OnEnter", DT.BattlegroundStats)
	rbg:SetScript("OnLeave", DT.Data_OnLeave)

	for i = 1, 3 do -- Fake DTs
		local dt = rbg:CreateFontString(nil, "OVERLAY")
		dt:SetSize(100, 27)
		dt:SetFont(DTFont, 14, "THINOUTLINE")
		dt:SetJustifyH("CENTER")
		dt:SetJustifyV("MIDDLE")

		rbg[i] = dt
	end
	rbg[1]:SetPoint("CENTER", rbg, "CENTER")
	rbg[2]:SetPoint("RIGHT", rbg[1], "LEFT", -4, 0)
	rbg[3]:SetPoint("LEFT", rbg[1], "RIGHT", 4, 0)

	rbg:Hide()
	self["SynesRightBGDataText"] = rbg

	self.extraPanelsCreated = true
end

function SY:ToggleDataPanels(forcePVP)
	for i = 1, 8 do
		if E.db.SY.datatexts.panels["SynesDataText"..i] ~= "" then
			self["SynesDataText"..i]:Show()
		else
			self["SynesDataText"..i]:Hide()
		end
	end

	local inInstance, instanceType = IsInInstance()
	if (inInstance and (instanceType == "pvp") and E.db.datatexts.battleground) or (forcePVP and E.db.datatexts.battleground) then
	--if (inInstance and (instanceType == "pvp") and E.db.SY.datatexts.battleground) or (forcePVP and E.db.SY.datatexts.battleground) then
		self["SynesLeftBGDataText"]:Show()
		self["SynesRightBGDataText"]:Show()

		self["SynesLeftDataText"]:Hide()
		self["SynesRightDataText"]:Hide()
	else
		if E.db.SY.datatexts.leftChatDatatextPanel then
			self["SynesLeftDataText"]:Show()
		else
			self["SynesLeftDataText"]:Hide()
		end
		if E.db.SY.datatexts.rightChatDatatextPanel then
			self["SynesRightDataText"]:Show()
		else
			self["SynesRightDataText"]:Hide()
		end

		self["SynesLeftBGDataText"]:Hide()
		self["SynesRightBGDataText"]:Hide()
	end
end

--[[
-- Not needed in 9.0, using ElvUI's new custm DTPanels feature instead
local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", function(self, event, ...)
	return self[event] and self[event](self, event, ...)
end)
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

function frame:PLAYER_ENTERING_WORLD(event, isInitialLogin, isReloadingUi)
	SY:ToggleDataPanels()
end
]]