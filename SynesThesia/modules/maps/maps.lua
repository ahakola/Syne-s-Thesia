--[[--------------------------------------------------------------
--	Syne's Thesia, an ElvUI edit by ahak @ tukui.org
--
--	This file contains changes/additions to the ElvUI Maps
--------------------------------------------------------------]]--
local E, L, V, P, G, _ = unpack(ElvUI) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local WM = E:GetModule("WorldMap")
local MM = E:GetModule("Minimap")
local SY = E:GetModule("SynesThesia")
local LSM = LibStub("LibSharedMedia-3.0")

local font = LSM:Fetch("font", SY.media.font)

-- World Map
--[[
-- Can't get this to hook and I'm too lazy to set up event handler atm
local function UpdateMapStyle(self)
	--SY:Print("UpdateMapStyle", self:GetName()) -- Debug

	SY:FixFontString(CoordsHolder.playerCoords, font, nil, "THINOUTLINE")
	SY:FixFontString(CoordsHolder.mouseCoords, font, nil, "THINOUTLINE")
end
--hooksecurefunc(WM, "Initialize", UpdateMapStyle)
hooksecurefunc(WM, "PositionCoords", UpdateMapStyle)
]]

-- Minimap