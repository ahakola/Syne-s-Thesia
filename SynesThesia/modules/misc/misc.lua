--[[--------------------------------------------------------------------
--	Syne's Thesia, an ElvUI edit by ahak @ tukui.org
--
--	This file contains changes/additions to various elements in ElvUI
--	that didn't warrant its own module
--------------------------------------------------------------------]]--
local E, L, V, P, G = unpack(ElvUI) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local M = E:GetModule("Misc")
--local THREAT = E:GetModule("Threat")
local THREAT = E:GetModule("DataBars")
local S = E:GetModule("Skins")
local SY = E:GetModule("SynesThesia")
local LSM = LibStub("LibSharedMedia-3.0")

local LootFont = LSM:Fetch("font", SY.media.font)
local RollFont = LSM:Fetch("font", SY.media.uffont)
local ThreatFont = LSM:Fetch("font", SY.media.font)

-- Style Loot
local function UpdateLootStyle(self, event, autoloot)
	local lootFrame = _G.ElvLootFrame

	--SY:Print("Loot:", lootFrame and tostring(lootFrame:IsShown()) or "n/a", #lootFrame.slots) -- Debug

	lootFrame.title:SetFont(LootFont, 15, "OUTLINE")
	lootFrame.title:SetPoint("BOTTOMLEFT", lootFrame, "TOPLEFT", 4, 4)

	for i = 1, #lootFrame.slots do
		lootFrame.slots[i].count:SetFont(LootFont, 14, "OUTLINE")
		lootFrame.slots[i].name:SetFont(LootFont, 15, "OUTLINE")
	end
end
hooksecurefunc(M, "LOOT_OPENED", UpdateLootStyle)

-- Style Loot Roll
local function UpdateRollStyle(self, rollId, time)
	local frame = M.RollBars

	for i = 1, #frame do
		-- Change Font
		frame[i].need:SetFont(RollFont, 14, "OUTLINE")
		frame[i].greed:SetFont(RollFont, 14, "OUTLINE")
		frame[i].pass:SetFont(RollFont, 14, "OUTLINE")
		frame[i].disenchant:SetFont(RollFont, 14, "OUTLINE")
		frame[i].fsbind:SetFont(RollFont, 14, "OUTLINE")
		frame[i].fsloot:SetFont(RollFont, 14, "OUTLINE")

		-- Try to reverse the grow direction
		frame[i]:ClearAllPoints()
		frame[i]:SetPoint("BOTTOM", (i > 1) and frame[i - 1] or _G.AlertFrameHolder, "TOP", 0, 4)
	end
end
hooksecurefunc(M, "START_LOOT_ROLL", UpdateRollStyle)


-- Style Threat Bar
local function UpdateThreatPosition(self)
	--SY:Print("UpdateThreatPosition") -- Debug

	--local ThreatBar = self.bar
	local ThreatBar = self.StatusBars.Threat

	ThreatBar:ClearAllPoints()
	ThreatBar:SetPoint("CENTER", BottomLine1)
	ThreatBar:SetParent(BottomLine1)
end
--hooksecurefunc(THREAT, "UpdatePosition", UpdateThreatPosition)
--hooksecurefunc(THREAT, "ThreatBar_Update", UpdateThreatPosition)

local function UpdateThreatStyle(self)
	--SY:Print("UpdateThreatStyle") -- Debug

	--local ThreatBar = self.bar -- ElvUI_ThreatBar
	local ThreatBar = self.StatusBars.Threat

	--ThreatBar:SetFrameLevel(5)
	--[[
	-- Not needed in 9.0
	ThreatBar:ClearAllPoints()
	ThreatBar:SetPoint("CENTER", BottomLine1)
	ThreatBar:SetParent(BottomLine1)
	ThreatBar:SetHeight(6)
	ThreatBar:SetWidth(E:Scale(400))

	SY:FixFontString(ThreatBar.text, ThreatFont, 14, "OUTLINE")
	ThreatBar.text:ClearAllPoints()
	ThreatBar.text:SetPoint("LEFT", ThreatBar, "TOPLEFT", 3, 0)

	ThreatBar.title = SY:SetFontString(ThreatBar, ThreatFont, 14, "OUTLINE")
	ThreatBar.title:SetText(L["Threat on current target:"])
	ThreatBar.title:SetPoint("RIGHT", ThreatBar, "TOPLEFT", -3, 0)
	]]
	
	-- Don't hide behind the Bottom Gradient!
	ThreatBar:Raise()
end
--hooksecurefunc(THREAT, "Initialize", UpdateThreatStyle)
hooksecurefunc(THREAT, "ThreatBar", UpdateThreatStyle)
hooksecurefunc(THREAT, "ThreatBar_Toggle", UpdateThreatStyle)


--[[--------------------------------------------------------------------
--  Source: https://github.com/ViksUI/ViksUI/blob/master/ViksUI/Modules/Misc/Misc.lua
--  ViksUI by Frode Hanssen (Vik)
--  Public Domain (https://www.curseforge.com/project/83550/license)
--  https://www.curseforge.com/wow/addons/viksui
--
--  GnakedGnome by Anthony Eadicicco (Nefarion)
--  MIT license (https://www.wowinterface.com/portal.php?&id=327&pageid=150)
--  https://www.wowinterface.com/downloads/info8291-GnakedGnome.html
--------------------------------------------------------------------]]--

----------------------------------------------------------------------------------------
--	Undress button in dress-up frame (by Nefarion)
----------------------------------------------------------------------------------------
local strip = CreateFrame("Button", "DressUpFrameUndressButton", DressUpFrame, "UIPanelButtonTemplate")
strip:SetText(L["Undress"])
strip:SetWidth(strip:GetTextWidth() + 40)
strip:SetPoint("RIGHT", DressUpFrameResetButton, "LEFT", -2, 0)
strip:RegisterForClicks("AnyUp")
strip:SetScript("OnClick", function(_, button)
	local actor = DressUpFrame.ModelScene:GetPlayerActor()
	if not actor then return end
	if button == "RightButton" then
		actor:UndressSlot(19)
	else
		actor:Undress()
	end
	PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK)
end)

-- Skin Undress-button ElvUI-style
S:HandleButton(strip, true)