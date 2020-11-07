--[[--------------------------------------------------------------------
--	Syne's Thesia, an ElvUI edit by ahak @ tukui.org
--
--	This file contains changes/additions to DataBars in ElvUI
--------------------------------------------------------------------]]--
local E, L, V, P, G = unpack(ElvUI) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local DataBars = E:GetModule("DataBars")
local SY = E:GetModule("SynesThesia")

local barPriorityList = {}
local function UpdateDataBarsStyle(self)
	--SY:Print("UpdateDataBarsStyle") -- Debug

	local azeriteBar = self.azeriteBar -- ElvUI_AzeriteBar
	local repBar = self.repBar -- ElvUI_ReputationBar
	local honorBar = self.honorBar -- ElvUI_HonorBar
	local expBar = self.expBar -- ElvUI_ExperienceBar

	wipe(barPriorityList)

	-- Add these to the priority list in the order of your chosen importance 
	if expBar and expBar:IsShown() then
		table.insert(barPriorityList, expBar)
	end
	if azeriteBar and azeriteBar:IsShown() then
		table.insert(barPriorityList, azeriteBar)
	end
	if repBar and repBar:IsShown() then
		table.insert(barPriorityList, repBar)
	end
	if honorBar and honorBar:IsShown() then
		table.insert(barPriorityList, honorBar)
	end

	-- Anchor based on priority
	for i, bar in ipairs(barPriorityList) do
		bar:ClearAllPoints()
		bar:SetPoint("TOP", Minimap, "BOTTOM", 0, E:Scale((i - 1) * -11))
		--SY:Print("Priority", i, bar:GetName(), E:Scale((i - 1) * -11)) -- Debug

		--bar.text:SetAlpha(.5)
	end
end
hooksecurefunc(DataBars, "Initialize", UpdateDataBarsStyle)
--[[
hooksecurefunc(DataBars, "EnableDisable_AzeriteBar", UpdateDataBarsStyle)
hooksecurefunc(DataBars, "EnableDisable_ReputationBar", UpdateDataBarsStyle)
hooksecurefunc(DataBars, "EnableDisable_HonorBar", UpdateDataBarsStyle)
hooksecurefunc(DataBars, "EnableDisable_ExperienceBar", UpdateDataBarsStyle)
]]
hooksecurefunc(DataBars, "UpdateAll", UpdateDataBarsStyle)

-- Tooltip was blocking the text so no benefit from changing the alpha of the text on hover
--[[
local function DataBar_OnEnter(self)
	--SY:Print("DataBar_OnEnter", self:GetName()) -- Debug
	local text = self.text
	if text then
		E:UIFrameFadeIn(text, .2, .5, 1)
	end
end
hooksecurefunc(DataBars, "AzeriteBar_OnEnter", DataBar_OnEnter)
hooksecurefunc(DataBars, "ReputationBar_OnEnter", DataBar_OnEnter)
hooksecurefunc(DataBars, "HonorBar_OnEnter", DataBar_OnEnter)
hooksecurefunc(DataBars, "ExperienceBar_OnEnter", DataBar_OnEnter)

local function DataBar_OnLeave(self)
	--SY:Print("DataBar_OnEnter", self:GetName()) -- Debug
	local text = self.text
	if text then
		E:UIFrameFadeOut(text, .2, 1, .5)
	end
end
hooksecurefunc(DataBars, "OnLeave", DataBar_OnLeave)
]]