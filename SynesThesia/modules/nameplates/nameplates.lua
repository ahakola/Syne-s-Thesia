--[[--------------------------------------------------------------
--	Syne's Thesia, an ElvUI edit by ahak @ tukui.org
--
--	This file contains changes/additions to the ElvUI Nameplates
--------------------------------------------------------------]]--
local E, L, V, P, G, _ = unpack(ElvUI) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local NP = E:GetModule("NamePlates")
local SY = E:GetModule("SynesThesia")

local function _fixedTagPosition(position) -- Additional anchoring positions
	if position == "RIGHT" then
		return "RIGHT"
	else
		return E.InversePoints[position]
	end
end

-- Add Syne's Edit style to some of the Nameplate elements
local function UpdateNameplateStyle(self, nameplate)
	local db = NP.db.units[nameplate.frameType]
	--SY:Print("UpdateNameplateStyle:", nameplate:GetName() or "n/a", nameplate.frameType) -- Debug

	if nameplate.Health and nameplate.Health.Text then
		SY:FixFontString(nameplate.Health.Text)
	end

	if nameplate.Name then
		SY:FixFontString(nameplate.Name)
	end

	if nameplate.Level then
		SY:FixFontString(nameplate.Level)

		if db and db.level then
			-- Anchor to RIGHT
			--SY:Print("Anchor RIGHT:", _fixedTagPosition(db.level.position), db.level.parent, db.level.position, db.level.xOffset, db.level.yOffset) -- Debug
			nameplate.Level:ClearAllPoints()
			nameplate.Level:Point(_fixedTagPosition(db.level.position), db.level.parent == "Nameplate" and nameplate or nameplate[db.level.parent], db.level.position, db.level.xOffset, db.level.yOffset)
		end
	end
	
	if nameplate.Castbar then
		if nameplate.Castbar.Time then
			SY:FixFontString(nameplate.Castbar.Time)

			nameplate.Castbar.Time:ClearAllPoints()
			nameplate.Castbar.Time:Point("RIGHT", nameplate.Castbar, "LEFT", -2, 0)
		end
		if nameplate.Castbar.Text then
			SY:FixFontString(nameplate.Castbar.Text)

			nameplate.Castbar.Text:ClearAllPoints()
			nameplate.Castbar.Text:Point("TOP", nameplate.Castbar, "BOTTOM", 0, -1)
		end
	end

	if nameplate.RaidTargetIndicator then -- This was surprisingly easy after the Unitframes...
		nameplate.RaidTargetIndicator:SetTexture("Interface\\AddOns\\SynesThesia\\media\\textures\\raidicons.blp") -- thx hankthetank for texture
	end
end
hooksecurefunc(NP, "StylePlate", UpdateNameplateStyle)
hooksecurefunc(NP, "UpdatePlate", UpdateNameplateStyle)