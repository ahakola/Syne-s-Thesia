--[[--------------------------------------------------------------
--	Syne's Thesia, an ElvUI edit by ahak @ tukui.org
--
--	This file contains changes/additions to the ElvUI Tooltips
--------------------------------------------------------------]]--
local E, L, V, P, G, _ = unpack(ElvUI) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local TT = E:GetModule("Tooltip")
local SY = E:GetModule("SynesThesia")

-- Reposition Tooltip StatusBar Text like in Syne's Edit
local function UpdateTooltipStyle(self, tt, value)
	if tt.text then
		--SY:Print("TT:", value or "n/a", tt:GetName()) -- Debug
		--tt.text:SetPoint("CENTER", tt, 0, 6)
		tt.text:SetPoint("CENTER", tt, 0, 5) -- This is more accurate according to my own Screenshots from the Era
	end
end

hooksecurefunc(TT, "GameTooltipStatusBar_OnValueChanged", UpdateTooltipStyle)
--hooksecurefunc(TT, "GameTooltip_SetDefaultAnchor", UpdateTooltipStyle)