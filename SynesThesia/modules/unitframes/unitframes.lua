--[[----------------------------------------------------------------
--	Syne's Thesia, an ElvUI edit by ahak @ tukui.org
--
--	This file contains changes/additions to the ElvUI Unitframes
----------------------------------------------------------------]]--
local E, L, V, P, G, _ = unpack(ElvUI) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local UF = E:GetModule("UnitFrames")
local SY = E:GetModule("SynesThesia")
local LSM = LibStub("LibSharedMedia-3.0")
local ElvUF = E.oUF

--Cache global variables
local _G = _G
local pairs = pairs
local twipe = table.wipe

local font1 = LSM:Fetch("font", SY.media.uffont)
local uffontsize = 14
local font2 = LSM:Fetch("font", SY.media.font)
local normTex = LSM:Fetch("statusbar", SY.media.normTex)
local glowTex = LSM:Fetch("statusbar", SY.media.glowTex)
local bubbleTex = LSM:Fetch("statusbar", SY.media.bubbleTex)


--[[--------------------------------------------------------------------
	I use modified CombatText from oUF_Phanx by Phanx
	Original can be found at https://github.com/Phanx/oUF_Phanx

	Syne's Edit used the original oUF_CombatFeedbackText module by Ammo

	This edit adds two new element paraters for advanced users who want/
	need to have the posibility to change the colors used by the
	CombatText-module on per element basis:

	self.CombatText.colors = {             -- default: hardcoded colors
		DEFAULT = { .84, .75, .65 },
		WOUND   = { .69, .31, .31 },
		HEAL    = { .33, .59, .33 },
	}
	self.CombatText.customDefault = true   -- default: false

	Fill the colors-table using same keys as the original CombatText-
	module populates the hardcoded colors-table.

	If a key is missing from colors-table, the module should fallback
	either to the DEFAULT-color of the provided external colors-table or
	the hardcoded color for the missing key.

	customDefault
		true - module tries to use custom DEFAULT-color for missing key.
		false - module tries to use the hardcoded color for missing key.

	In both cases as a last resort, module will default back to
	DEFAULT-color of hardcoded colors.
----------------------------------------------------------------------]]
local _, ns = ...
ns.oUF = E.oUF -- Give CombatText access to oUF
ns.si = function(value) -- Custom function to short values
	return E:ShortValue(value)
end


-- Modified from 'ElvUI CustomTweaks' (version 1.49) by Blazeflack (with contributions from Azilroka and Benik)
local infopanels = {}
local function BuildTable()
	twipe(infopanels)

	for _, unitName in pairs(UF.units) do
		local frameNameUnit = E:StringTitle(unitName)
		frameNameUnit = frameNameUnit:gsub("t(arget)", "T%1")
		
		local unitframe = _G["ElvUF_"..frameNameUnit]
		if unitframe and unitframe.InfoPanel then infopanels[unitframe.InfoPanel] = true end
	end

	for unit, unitgroup in pairs(UF.groupunits) do
		local frameNameUnit = E:StringTitle(unit)
		frameNameUnit = frameNameUnit:gsub("t(arget)", "T%1")
		
		local unitframe = _G["ElvUF_"..frameNameUnit]
		if unitframe and unitframe.InfoPanel then infopanels[unitframe.InfoPanel] = true end
	end

	for _, header in pairs(UF.headers) do
		for i = 1, header:GetNumChildren() do
			local group = select(i, header:GetChildren())
			--group is Tank/Assist Frames, but for Party/Raid we need to go deeper
			for j = 1, group:GetNumChildren() do
				--Party/Raid unitbutton
				local unitbutton = select(j, group:GetChildren())
				if unitbutton.InfoPanel then infopanels[unitbutton.InfoPanel] = true end
			end
		end
	end
end
BuildTable()

function UF:Construct_RaidIcon(frame) -- Copied and modified from ElvUI, because they don't let you change texture of RaidIcons after creating the element
	local tex = frame.RaisedElementParent.TextureParent:CreateTexture(nil, "OVERLAY")
	tex:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
	tex:Size(18)
	tex:Point("CENTER", frame.Health, "TOP", 0, 2)
	--tex.SetTexture = E.noop

	return tex
end

local function UpdateInfoPanelStyle(self, ...)
	-- Add Syne's Edit style and Gradients to most of the unitframes
	for infopanel in pairs(infopanels) do
		if infopanel and infopanel:GetObjectType() == "Frame" then
			local parent = infopanel:GetParent()
			local unit = parent.unit -- this can return player etc. also on group and raid frames
			local frameType = parent.unitframeType -- player, target, focus, pet, boss, arena, party, raid...

			local Castbar = parent.Castbar
			local Health = parent.Health
			local Power = parent.Power
			local Name = parent.Name
			local RaidIcon = parent.RaidTargetIndicator
			local LFDRole = parent.GroupRoleIndicator

			--if (unit == "pet" or frameType == "pet") and unit ~= frameType then
			--	SY:Print("Pet?:", unit, frameType)
			--end

			-- Style castbars
			if Castbar then 
				local Time = Castbar.Time
				local Text = Castbar.Text

				-- Change text size
				if frameType == "pet" then
					SY:FixFontString(Time, font1, uffontsize-2, "THINOUTLINE")
					SY:FixFontString(Text, font1, uffontsize-2, "THINOUTLINE")
				elseif frameType == "boss" or frameType == "arena" then
					-- Make this more pretty
					Castbar.Holder:ClearAllPoints()
					Castbar.Holder:SetPoint("TOPLEFT", Health, "LEFT", -1, -5)
					Castbar.Holder:SetPoint("BOTTOMRIGHT", Power, "RIGHT", 1, 2) -- 3)

					SY:FixFontString(Time, font1, 12, "OUTLINE")
					SY:FixFontString(Text, font1, 12, "OUTLINE")
				else
					SY:FixFontString(Time, font1, uffontsize, "OUTLINE")
					SY:FixFontString(Text, font1, uffontsize, "OUTLINE")
				end
			end

			-- Add shadow to the Health values
			if Health.value then
				local Text = Health.value

				if frameType == "raid" or frameType == "raid40" then
					SY:FixFontString(Text, font1, 11*E.db.SY.unitframes.gridscale, "THINOUTLINE") -- This will be shown only in Heal-layout
				else
					SY:FixFontString(Text, font1, uffontsize, "OUTLINE")
				end
			end

			-- Add shadow to the Power values
			if Power.value then
				local Text = Power.value

				SY:FixFontString(Text, font1, uffontsize, "OUTLINE")
			end

			-- Add shadow to the Name
			if Name then
				if frameType == "raid" or frameType == "raid40" then -- Raid and Raid40 don't get shadows, but they get text size change
					if E.db.SY.chosenLayout == "healer" then
						SY:FixFontString(Name, font2, 12*E.db.SY.unitframes.gridscale)
					else
						SY:FixFontString(Name, font2, 14, "THINOUTLINE") -- This was 12 on 'raid' and 13 on 'raid40' for some reason in Syne's Edit? That is too small...
					end
				else
					SY:FixFontString(Name, font1, uffontsize, "OUTLINE")
				end

				if frameType == "targettarget" or frameType == "pet" or frameType == "focus"
				or frameType == "focustarget" or frameType == "boss" or frameType == "arena" then
					-- Also Main Tank and Main Assist gets this
					Name:SetJustifyH("CENTER")
				elseif E.db.SY.chosenLayout == "healer" and frameType == "party" then
					-- Heal-layout: Party & RaidPet is justified on CENTER
					Name:SetJustifyH("CENTER")
				else
					Name:SetJustifyH("LEFT")
				end
			end

			-- Update Icon Styles
			if RaidIcon then -- ElvUI prevents us from just changing the texture unlike in the Nameplates for some reason...
				if not parent.fixedRaidIcons then -- We have to disable RaidIcon, re-construct it with modified constructor and re-enable RaidIcon first.
					parent:DisableElement("RaidTargetIndicator")
					parent.RaidTargetIndicator = UF:Construct_RaidIcon(parent)
					parent:EnableElement("RaidTargetIndicator")
					parent.fixedRaidIcons = true
				end
				-- Now we can set the new texture
				parent.RaidTargetIndicator:SetTexture("Interface\\AddOns\\SynesThesia\\media\\textures\\raidicons.blp") -- thx hankthetank for texture
			end
			if LFDRole then
				if E.db.SY.unitframes.roleIconStyle then -- ElvUI Icons
					parent:RegisterEvent("UNIT_CONNECTION", UF.UpdateRoleIcon)
					LFDRole.Override = UF.UpdateRoleIcon
					LFDRole:SetTexCoord(0, 1, 0, 1)
				else -- Syne's Edit Colors
					parent:UnregisterEvent("UNIT_CONNECTION")
					LFDRole.Override = nil
				end

				LFDRole:SetTexture("Interface\\AddOns\\SynesThesia\\media\\textures\\lfdicons.blp")
				parent:UpdateAllElements("PLAYER_ROLES_ASSIGNED")
			end

			-- Gradients
			local gradientLenght = 0 -- focustarget, targettargettarget, pettarget, focustarget, raid. raid40
			if frameType == "player" or frameType == "target" then
				gradientLenght = 310
				--BuildTable()
			elseif frameType == "targettarget" or frameType == "pet" or frameType == "focus" then
				gradientLenght = 189
			elseif frameType == "party" then
				-- Party-frames get gradient only in Heal-layout
				if E.db.SY.chosenLayout == "healer" then
					gradientLenght = 290
				end
			elseif frameType == "raid" or frameType == "raid40" then
				-- No gradient for these in any layout
			elseif frameType == "boss" or frameType == "arena" then
				gradientLenght = 290
			elseif frameType == "targettargettarget" or frameType == "pettarget" or frameType == "focustarget" then
				-- Ignore these
				SY:CreateShadow(parent)
			else
				SY:Print("!Unit:", unit, frameType)
			end

			-- Create these improvements only once per unitframe
			if gradientLenght > 0 and not infopanel.Gradient then
				local panel = CreateFrame("Frame", nil, infopanel)
				--SY:CenterGradientH(panel, gradientLenght, 8, "CENTER", infopanel, "CENTER" , 0, 0)
				SY:CenterGradientH(panel, gradientLenght, 8, "TOP", infopanel, "BOTTOM" , 0, -5)
				infopanel.Gradient = panel

				SY:CreateShadow(parent)

				if frameType == "player" or frameType == "target" then
					-- Castbar Gradients, there were a typo related to these in Syne's Edit or at least I think so.
					local castpanel = CreateFrame("Frame", nil, parent.Castbar)
					SY:CenterGradientH(castpanel, 400, 13, "CENTER", parent.Castbar)
					castpanel:SetFrameLevel(2)
					--castpanel:SetFrameStrata("MEDIUM")
					infopanel.CastGradient = castpanel

					-- Combat Feedback
					if E.db.SY.unitframes.combatfeedback then
						local CombatFeedbackText
						CombatFeedbackText = SY:SetFontString(Health, font1, uffontsize, "OUTLINE")
						CombatFeedbackText:SetPoint("CENTER", Health, 0, 1)
						CombatFeedbackText.colors = {
							-- Colors from Syne's Edit
							DEFAULT		= { .84, .75, .65 }, -- STANDARD
							WOUND		= { .69, .31, .31 }, -- DAMAGE, CRUSHING, CRITICAL, GLANCING
							HEAL		= { .33, .59, .33 }, -- HEAL, CRITHEAL
							ENERGIZE	= { .31, .45, .63 }, -- ENERGIZE, CRITENERGIZE
							ABSORB		= { .84, .75, .65 }, -- ABSORB
							BLOCK		= { .84, .75, .65 }, -- BLOCK
							--DEFLECT		= { .84, .75, .65 },
							--DODGE		= { .84, .75, .65 },
							--EVADE		= { .84, .75, .65 },
							IMMUNE		= { .84, .75, .65 }, -- IMMUNE
							MISS		= { .84, .75, .65 }, -- MISS
							--RELFECT		= { .84, .75, .65 },
							RESIST		= { .84, .75, .65 }, -- RESIST

						}
						CombatFeedbackText.customDefault = true
						CombatFeedbackText.maxAlpha = .6

						--parent.CombatFeedbackText = CombatFeedbackText
						parent.CombatText = CombatFeedbackText
						parent:EnableElement("CombatText", frameType)
					end
				end
			end

			-- Hide Backdrop
			if frameType ~= "raid" and frameType ~= "raid40" then
				infopanel.backdrop:Hide()
			end

			if frameType == "player" or frameType == "target" then
				if E.db.SY.unitframes.castbarlayout == 1 then -- Castbars inside Unitframe
					infopanel.CastGradient:Hide()
				else
					infopanel.CastGradient:Show()
				end
			end
		end
	end
end
hooksecurefunc(UF, "Update_StatusBars", UpdateInfoPanelStyle)
hooksecurefunc(UF, "CreateAndUpdateUF", UpdateInfoPanelStyle)
hooksecurefunc(UF, "CreateAndUpdateUFGroup", UpdateInfoPanelStyle)
hooksecurefunc(UF, "CreateAndUpdateHeaderGroup", UpdateInfoPanelStyle)
hooksecurefunc(UF, "ForceShow", UpdateInfoPanelStyle)


-- Reposition Raid-frames like in Syne's Edit does it
-- Or not, this is built in in ElvUI
--[[
local RaidMove = CreateFrame("Frame")
RaidMove:RegisterEvent("PLAYER_LOGIN")
RaidMove:RegisterEvent("PARTY_LEADER_CHANGED")
RaidMove:RegisterEvent("GROUP_ROSTER_UPDATE") -- This replaces both RAID_ROSTER_UPDATE and PARTY_MEMBERS_CHANGED
RaidMove:SetScript("OnEvent", function(self)
	if E.db.SY.chosenLayout == "healer" then return end -- Don't reposition Heal-layout

	if InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
	else
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")

		local numraid = GetNumGroupMembers() -- This replaces the old GetNumRaidMembers()
		local numparty = GetNumSubgroupMembers() -- This replaces the old GetNumPartyMembers()

		local y = -350
		if numparty > 0 and numraid == 0 or numraid > 0 and numraid <= 5 then
			y = -399
		elseif numraid > 5 and numraid < 11 then
			y = -350
		elseif numraid > 10 and numraid < 16 then
			y = -280
		elseif numraid > 15 and numraid < 26 then
			y = -172
		end

		SY:SetMoverPosition("ElvUF_RaidMover", "TOPLEFT", E.UIParent, "TOPLEFT", 20, y)
	end
end)
]]


-- Additionals tags for Unitframes
-- Low Mana warning
--[[
	-- This is how it was done in Syne's Edit (had to do some fixing to make it work better in modern version of WoW),
	-- but I ended up replacing it with the stock 'UIFrameFlash' anyway...
	local SetUpAnimGroup = function(self)
		self.anim = self:CreateAnimationGroup("Flash")
		self.anim.fadein = self.anim:CreateAnimation("ALPHA", "FadeIn")
		--self.anim.fadein:SetChange(1)
		self.anim.fadein:SetFromAlpha(0)
		self.anim.fadein:SetToAlpha(1)
		self.anim.fadein:SetOrder(2)

		self.anim.fadeout = self.anim:CreateAnimation("ALPHA", "FadeOut")
		--self.anim.fadeout:SetChange(-1)
		self.anim.fadein:SetFromAlpha(1)
		self.anim.fadein:SetToAlpha(0)
		self.anim.fadeout:SetOrder(1)
	end

	local Flash = function(self, duration)
		if not self.anim then
			SetUpAnimGroup(self)

			self.anim:SetLooping("REPEAT")
		end

		self.anim.fadein:SetDuration(duration)
		self.anim.fadeout:SetDuration(duration)
		self.anim:Play()
	end

	local StopFlash = function(self)
		if self.anim then
			self.anim:Finish()
		end
	end
]]--
local SPELL_POWER_MANA = Enum.PowerType.Mana
local flashFrame = ElvUF_Player.Name
ElvUF.Tags.Events["manaflash"] = "UNIT_POWER_FREQUENT UNIT_MAXPOWER"
ElvUF.Tags.Methods["manaflash"] = function(unit)
	if unit ~= "player" or UnitIsDeadOrGhost("player") or UnitPowerType("player") ~= SPELL_POWER_MANA then
		if UIFrameIsFlashing(flashFrame) then
			UIFrameFlashStop(flashFrame)
		end

		return ""
	end
	--SY:Print("manaflash!", tostring(UIFrameIsFlashing(flashFrame))) -- Debug

	local percMana = UnitPower("player", SPELL_POWER_MANA) / UnitPowerMax("player", SPELL_POWER_MANA) * 100

	if percMana <= E.db.SY.unitframes.lowThreshold then
		if not UIFrameIsFlashing(flashFrame) then
			UIFrameFlash(flashFrame, .3, .3, -1, true, 0, 0)
		end
		
		return "|cffaf5050"..L["LOW MANA"].."|r"
	else
		if UIFrameIsFlashing(flashFrame) then
			UIFrameFlashStop(flashFrame)
		end

		return ""
	end
end


--Unitframes options
local sw = math.floor(GetScreenWidth() + .5)
local sh = math.floor(GetScreenHeight() + .5)
local function updateCastBarSetup() -- Embeded/Separated Castbars
	--SY:Print("updateCastBarSetup") -- Debug

	local castbarUnit = { "player", "target" }
	for _, unit in pairs(castbarUnit) do
		if E.db.SY.unitframes.castbarlayout == 1 then -- Castbars inside Unitframe
			E.db.unitframe.units[unit].castbar.width = 250
			E.db.unitframe.units[unit].castbar.height = 12 -- 11
			E.db.unitframe.units[unit].castbar.format = "CURRENTMAX"
			E.db.unitframe.units[unit].castbar.xOffsetText = 5
			E.db.unitframe.units[unit].castbar.yOffsetText = -4
			E.db.unitframe.units[unit].castbar.xOffsetTime = -5
			E.db.unitframe.units[unit].castbar.yOffsetTime = -4
			E.db.unitframe.units[unit].castbar.icon = true
			E.db.unitframe.units[unit].castbar.iconAttached = false
			E.db.unitframe.units[unit].castbar.iconSize = 27
			E.db.unitframe.units[unit].castbar.iconAttachedTo = "Castbar"
			if unit == "player" then
				E.db.unitframe.units[unit].castbar.iconPosition = "LEFT"
				E.db.unitframe.units[unit].castbar.iconXOffset = -8
				E.db.unitframe.units[unit].castbar.iconYOffset = -1

				SY:SetMoverPosition("ElvUF_PlayerCastbarMover", "BOTTOMRIGHT", E.UIParent, "BOTTOM", -70, 224)
			else
				E.db.unitframe.units.target.castbar.iconPosition = "RIGHT"
				E.db.unitframe.units.target.castbar.iconXOffset = 8
				E.db.unitframe.units.target.castbar.iconYOffset = -1

				SY:SetMoverPosition("ElvUF_TargetCastbarMover", "BOTTOMLEFT", E.UIParent, "BOTTOM", 70, 224)
			end
		else -- Separate castbars
			E.db.unitframe.units[unit].castbar.width = 272
			E.db.unitframe.units[unit].castbar.height = 13
			E.db.unitframe.units[unit].castbar.format = "CURRENTMAX"
			E.db.unitframe.units[unit].castbar.xOffsetText = 5
			E.db.unitframe.units[unit].castbar.yOffsetText = -4
			E.db.unitframe.units[unit].castbar.xOffsetTime = -5
			E.db.unitframe.units[unit].castbar.yOffsetTime = -4
			E.db.unitframe.units[unit].castbar.icon = true
			E.db.unitframe.units[unit].castbar.iconAttached = false
			E.db.unitframe.units[unit].castbar.iconSize = 28
			E.db.unitframe.units[unit].castbar.iconAttachedTo = "Castbar"
			if unit == "player" then
				E.db.unitframe.units[unit].castbar.iconPosition = "LEFT"
				E.db.unitframe.units[unit].castbar.iconXOffset = -10
				E.db.unitframe.units[unit].castbar.iconYOffset = 13

				SY:SetMoverPosition("ElvUF_PlayerCastbarMover", E.db.SY.unitframes.playercbpoint, E.UIParent, E.db.SY.unitframes.playercbpoint, E.db.SY.unitframes.playercbX, E.db.SY.unitframes.playercbY)
			else
				E.db.unitframe.units.target.castbar.iconPosition = "RIGHT"
				E.db.unitframe.units.target.castbar.iconXOffset = 10
				E.db.unitframe.units.target.castbar.iconYOffset = -14

				SY:SetMoverPosition("ElvUF_TargetCastbarMover", E.db.SY.unitframes.targetcbpoint, E.UIParent, E.db.SY.unitframes.targetcbpoint, E.db.SY.unitframes.targetcbX, E.db.SY.unitframes.targetcbY)
			end
		end
	end

	UF:CreateAndUpdateUF("player")
	UF:CreateAndUpdateUF("target")
end
local function updateGridVisibility() -- Setup Grid-only for Healing
	if E.db.SY.chosenLayout ~= "healer" then return end
	--SY:Print("updateGridVisibility") -- Debug

	local gridonly = E.db.SY.unitframes.gridonly or false

	E.db.unitframe.units.party.enable = (not gridonly)
	E.db.unitframe.units.raid.visibility = gridonly and "[nogroup] hide;show" or "[@raid6,noexists][nogroup] hide;show";

	UF:CreateAndUpdateHeaderGroup("party")
	UF:CreateAndUpdateHeaderGroup("raid")
end
local function updateGridScale() -- Setup Grid-scale for Healing
	if E.db.SY.chosenLayout ~= "healer" then return end
	--SY:Print("updateGridScale") -- Debug

	local gridscale = E.db.SY.unitframes.gridscale or 1

	E.db.unitframe.units.raid.width = 76 * gridscale
	E.db.unitframe.units.raid.height = 38 * gridscale

	E.db.unitframe.units.raid.raidicon.size = 18 * gridscale
	E.db.unitframe.units.raid.raidicon.yOffset = 9 * gridscale

	E.db.unitframe.units.raid.rdebuffs.size = 22 * gridscale
	E.db.unitframe.units.raid.rdebuffs.fontSize = 9 * gridscale
	E.db.unitframe.units.raid.rdebuffs.yOffset = 26 * gridscale

	E.db.unitframe.units.raid.roleIcon.size = 12 * gridscale

	UF:CreateAndUpdateHeaderGroup("raid")
end
local function updateTargetAuraSetup() -- Target Aura-style
	if E.db.SY.unitframes.altTargetAuras then -- Alternative style
		E.db.unitframe.units.target.buffs.perrow = 1
		E.db.unitframe.units.target.buffs.numrows = 2
		E.db.unitframe.units.target.buffs.sizeOverride = 41
		E.db.unitframe.units.target.buffs.spacing = 3

		E.db.unitframe.units.target.debuffs.perrow = 7
		E.db.unitframe.units.target.debuffs.sizeOverride = 27
		E.db.unitframe.units.target.debuffs.attachTo = "FRAME"
	else -- Original style
		E.db.unitframe.units.target.buffs.perrow = 9
		E.db.unitframe.units.target.buffs.numrows = 1
		E.db.unitframe.units.target.buffs.sizeOverride = 0
		E.db.unitframe.units.target.buffs.spacing = 2

		E.db.unitframe.units.target.debuffs.perrow = 9
		E.db.unitframe.units.target.debuffs.sizeOverride = 0
		E.db.unitframe.units.target.debuffs.attachTo = "BUFFS"
	end

	-- For some reason the icons show up as really small (like 1px x 1px) when setting sizeOverride to 0 if I don't call this twice...
	UF:CreateAndUpdateUF("target")
	C_Timer.After(0, function() -- Fire on next frame instead of current frame
		UF:CreateAndUpdateUF("target")
	end)
end
local function updateRoleIndicators() -- RoleIndicator-style
	local roleIconUnit = { "party", "raid" }
	for _, unit in pairs(roleIconUnit) do
		if E.db.SY.unitframes.roleIconStyle then
			if E.db.SY.chosenLayout ~= "healer" then
				E.db.unitframe.units[unit].roleIcon.enable = true
				E.db.unitframe.units[unit].roleIcon.position = "LEFT"
				E.db.unitframe.units[unit].roleIcon.attachTo = "Health"
				E.db.unitframe.units[unit].roleIcon.xOffset = 0
				E.db.unitframe.units[unit].roleIcon.yOffset = 0
				E.db.unitframe.units[unit].roleIcon.size = 12
				E.db.unitframe.units[unit].roleIcon.tank = true
				E.db.unitframe.units[unit].roleIcon.healer = true
				E.db.unitframe.units[unit].roleIcon.damager = true
			else
				-- For both party and raid
				E.db.unitframe.units[unit].roleIcon.position = "TOPRIGHT"
				E.db.unitframe.units[unit].roleIcon.attachTo = "Frame"
				E.db.unitframe.units[unit].roleIcon.xOffset = -2
				E.db.unitframe.units[unit].roleIcon.yOffset = -2
				E.db.unitframe.units[unit].roleIcon.tank = true
				E.db.unitframe.units[unit].roleIcon.healer = true
				E.db.unitframe.units[unit].roleIcon.damager = true

				E.db.unitframe.units.party.roleIcon.enable = true
				E.db.unitframe.units.party.roleIcon.size = 15

				E.db.unitframe.units.raid.roleIcon.enable = false -- Setup this anyway, incase I change my mind...
				E.db.unitframe.units.raid.roleIcon.size = 12*E.db.SY.unitframes.gridscale
			end
		else
			E.db.unitframe.units[unit].roleIcon.position = "TOPRIGHT"
			E.db.unitframe.units[unit].roleIcon.attachTo = "Health"
			E.db.unitframe.units[unit].roleIcon.xOffset = -2
			E.db.unitframe.units[unit].roleIcon.yOffset = -2
			E.db.unitframe.units[unit].roleIcon.tank = true
			E.db.unitframe.units[unit].roleIcon.healer = true
			E.db.unitframe.units[unit].roleIcon.damager = true

			E.db.unitframe.units.party.roleIcon.enable = true
			E.db.unitframe.units.party.roleIcon.size = 7

			if E.db.SY.chosenLayout ~= "healer" then
				E.db.unitframe.units.raid.roleIcon.enable = true
				E.db.unitframe.units.raid.roleIcon.size = 7
			else
				E.db.unitframe.units.raid.roleIcon.enable = false -- Setup this anyway, incase I change my mind...
				E.db.unitframe.units.raid.roleIcon.size = 7*E.db.SY.unitframes.gridscale
			end
		end
	end

	E.db.unitframe.units.raid40.roleIcon.enable = false

	-- Update to get the changes into play
	UF:CreateAndUpdateHeaderGroup("party")
	UF:CreateAndUpdateHeaderGroup("raid")
	C_Timer.After(0, function() -- Fire on next frame instead of current frame
		UF:CreateAndUpdateHeaderGroup("party")
		UF:CreateAndUpdateHeaderGroup("raid")
	end)
end
local function UFOptions()
	E.Options.args.SY.args.unitframes = {
		order = 500,
		type = "group",
		name = L["UnitFrames"],
		args = {
			unitframesHeader = {
				order = 10,
				type = "header",
				name = SY:ColorStr(L["UnitFrames"]),
			},
			lowThreshold = {
				order = 20,
				type = "range",
				name = L["Low Mana Threshold"],
				desc = L["Percentage of Mana at which point the flashing 'Low Mana'-text appears on Player unit frame."],
				min = 0, max = 100, step = 1,
				get = function(info) return E.db.SY.unitframes[ info[#info] ] end,
				set = function(info, value) E.db.SY.unitframes[ info[#info] ] = value; UF:CreateAndUpdateUF("player") end,
			},
			combatfeedback = {
				order = 30,
				type = "toggle",
				name = L["Combat Feedback Text (*)"],
				desc = L["Enables 'Combat Feedback Text' on Player and Target unit frames."],
				get = function(info) return E.db.SY.unitframes[ info[#info] ] end,
				set = function(info, value) E.db.SY.unitframes[ info[#info] ] = value; E:StaticPopup_Show("CONFIG_RL") end,
			},
			roleIconStyle = {
				order = 40,
				type = "toggle",
				name = L["Role Icons"],
				desc = L["Enables 'ElvUI Role Icons' instead of 'Syne's Edit Role Colors' on unit frames."],
				get = function(info) return E.db.SY.unitframes[ info[#info] ] end,
				set = function(info, value) E.db.SY.unitframes[ info[#info] ] = value; updateRoleIndicators() end,
			},
			altTargetAuras = {
				order = 50,
				type = "toggle",
				name = L["Alt-style on Target Auras"],
				desc = L["Enables 'Alternative-style' on Target unit frame auras."],
				get = function(info) return E.db.SY.unitframes[ info[#info] ] end,
				set = function(info, value) E.db.SY.unitframes[ info[#info] ] = value; updateTargetAuraSetup() end,
			},
			starDesc = {
				order = 60,
				type = "description",
				name = L["\n\n(*) Requires reloading of the UI for changes to take effect!"],
			},
			castbar = {
				order = 70,
				type = "group",
				name = L["Castbars"],
				guiInline = true,
				get = function(info) return E.db.SY.unitframes[ info[#info] ] end,
				set = function(info, value) E.db.SY.unitframes[ info[#info] ] = value; updateCastBarSetup() end,
				args = {
					castbarlayout = {
						order = 10,
						type = "select",
						name = L["Castbar-layout"],
						desc = L["Embed/Detach Player and Target cast bars to/from unit frames."],
						values = {
							[1] = L["Embedded cast bars"],
							[2] = L["Detached cast bars"],
						},
					},
					spacer = {
						order = 20,
						type = "description",
						name = "",
					},
					playercbpoint = {
						order = 30,
						type = "select",
						name = L["Player cast bar anchor-point"],
						desc = L["Anchor point for detached Player cast bar."],
						values = {
							["CENTER"] = L["Center"],
							["TOP"] = L["Top"],
							["TOPLEFT"] = L["Top Left"],
							["TOPRIGHT"] = L["Top Right"],
							["BOTTOM"] = L["Bottom"],
							["BOTTOMLEFT"] = L["Bottom Left"],
							["BOTTOMRIGHT"] = L["Bottom Right"],
							["LEFT"] = L["Left"],
							["RIGHT"] = L["Right"],
						},
					},
					playercbX = {
						order = 40,
						type = "range",
						name = L["Player cast bar X-Offset"],
						desc = L["Horizontal offset for detached Player cast bar."],
						min = -sw/2, max = sw/2, step = 1,
					},
					playercbY = {
						order = 50,
						type = "range",
						name = L["Player cast bar Y-Offset"],
						desc = L["Vertical offset for detached Player cast bar."],
						min = -sh/2, max = sh/2, step = 1,
					},
					spacer2 = {
						order = 60,
						type = "description",
						name = "",
					},
					targetcbpoint = {
						order = 70,
						type = "select",
						name = L["Target cast bar anchor-point"],
						desc = L["Anchor point for detached Target cast bar."],
						values = {
							["CENTER"] = L["Center"],
							["TOP"] = L["Top"],
							["TOPLEFT"] = L["Top Left"],
							["TOPRIGHT"] = L["Top Right"],
							["BOTTOM"] = L["Bottom"],
							["BOTTOMLEFT"] = L["Bottom Left"],
							["BOTTOMRIGHT"] = L["Bottom Right"],
							["LEFT"] = L["Left"],
							["RIGHT"] = L["Right"],
						},
					},
					targetcbX = {
						order = 80,
						type = "range",
						name = L["Target cast bar X-Offset"],
						desc = L["Horizontal offset for detached Target cast bar."],
						min = -sw/2, max = sw/2, step = 1,
					},
					targetcbY = {
						order = 90,
						type = "range",
						name = L["Target cast bar Y-Offset"],
						desc = L["Vertical offset for detached Target cast bar."],
						min = -sh/2, max = sh/2, step = 1,
					},
				},
			},
			spacer = {
				order = 100,
				type = "description",
				name = "\n\n\n",
			},
			healerHeader = {
				order = 110,
				type = "header",
				name = SY:ColorStr(L["Raid Healer-layout"]),
			},
			healDesc = {
				order = 120,
				type = "description",
				name = L["These settings affect only the Healer-layout!"],
				image = "Interface\\DialogFrame\\UI-Dialog-Icon-AlertNew",
			},
			gridonly = {
				order = 130,
				type = "toggle",
				name = L["Grid only -mode"],
				desc = L["Replace Party frames with Raid grid in all group modes and sizes."],
				get = function(info) return E.db.SY.unitframes[ info[#info] ] end,
				set = function(info, value) E.db.SY.unitframes[ info[#info] ] = value; updateGridVisibility() end,
			},
			gridscale = {
				order = 140,
				type = "range",
				name = L["Grid scale"],
				desc = L["Size scaling factor for Raid grid."],
				min = .75, max = 1.5, step = .01,
				get = function(info) return E.db.SY.unitframes[ info[#info] ] end,
				set = function(info, value) E.db.SY.unitframes[ info[#info] ] = value; updateGridScale() end,
			},
		},
	}
end
SY.configs["unitframes"] = UFOptions

local function UFUserOptions()
	local example = [=[
   E.db.unitframe.units.party.buffs.sizeOverride = 44
   E.db.unitframe.units.party.debuffs.enable = false
   E.db["unitframe"]["units"]["party"]["name"]["text_format"] = "[difficultycolor][level] [namecolor][name:long]"
   SY:SetMoverPosition("ElvUF_PartyMover", "TOPLEFT", E.UIParent, "TOPLEFT", 100, -100)
]=]
	E.Options.args.SY.args.userConfig = {
		order = 600,
		type = "group",
		name = L["Layout User-config"],
		get = function(info) return E.db.SY.unitframes[ info[#info] ] end,
		set = function(info, value) E.db.SY.unitframes[ info[#info] ] = value end,
		validate = function(info, value)
			local func, errorMessage = loadstring(value)
			E.Options.args.SY.args.userConfig.args.userConfigOK.name()
			if func then
				if info[#info] == "dpsLayoutUserConfig" then
					E.db.SY.unitframes.dpsLayoutValidates = true
				else
					E.db.SY.unitframes.healLayoutValidates = true
				end
				--E.Options.args.SY.args.userConfig.args.userConfigOK.name = L["User-configs validate:"] .. " " .. SY:ColorStr(L["OK"], 0, .7, 0)
				return true
			else
				if info[#info] == "dpsLayoutUserConfig" then
					E.db.SY.unitframes.dpsLayoutValidates = false
				else
					E.db.SY.unitframes.healLayoutValidates = false
				end
				--E.Options.args.SY.args.userConfig.args.userConfigOK.name = L["User-configs validate:"] .. " " .. format("%s - %s", SY:ColorStr(L["ERROR"], .7, 0, 0), errorMessage)
				--return "ERROR: " .. errorMessage
				return true -- If we don't validate, the name doesn't change and the ElvUI's buttons at the bottom block the text
			end
		end,
		args = {
			userConfigHeader = {
				order = 10,
				type = "header",
				name = SY:ColorStr(L["Layout User-config"]),
			},
			userConfigDesc = {
				order = 20,
				type = "description",
				name = format(L["%s uses hardcoded settings for group unit frames settings and positioning on layout changes. You can still have almost full control over these features by having your own user-config in these editboxes. On layout change %s will evaluate the content of the selected layouts editbox after applying the hardcoded changes first."], SY.title, SY.title) .. "\n",
			},
			userConfigNBDesc = {
				order = 30,
				type = "description",
				name = format(L["Remember, the layout changes only affects parts of the %s, %s, %s and %s unit frames settings of the UI. All other changes you made to the UI with ElvUI-config won't be touched when changing layouts and can be omitted from these editboxes!"], SY:ColorStr(L["Party"]), SY:ColorStr(L["Raid"]), SY:ColorStr(L["Raid-40"]), SY:ColorStr(L["Raid Pet"])) .. "\n",
				image = "Interface\\DialogFrame\\UI-Dialog-Icon-AlertNew",
			},
			dpsLayoutUserConfig = {
				order = 100,
				type = "input",
				name = L["Tank/DPS-layout"],
				desc = L["These changes are applied to the Tank/DPS-layout after hardcoded settings has been applied."],
				width = "full",
				multiline = 8,
			},
			healLayoutUserConfig = {
				order = 110,
				type = "input",
				name = L["Healer-layout"],
				desc = L["These changes are applied to the Healer-layout after hardcoded settings has been applied."],
				width = "full",
				multiline = 8,
			},
			userConfigOK = {
				order = 120,
				type = "description",
				name = function(info)
					local dpsFunc, dpsError = loadstring(E.db.SY.unitframes.dpsLayoutUserConfig)
					if dpsFunc then
						local healFunc, healError = loadstring(E.db.SY.unitframes.healLayoutUserConfig)
						if healFunc then
							return L["User-configurations validate:"] .. " " .. SY:ColorStr(L["OK"], 0, .7, 0)
						else
							return L["User-configurations validate:"] .. " " .. format("%s (%s): %s", SY:ColorStr(L["ERROR"], .7, 0, 0), L["Healer-layout"], healError)
						end
					else
						return L["User-configurations validate:"] .. " " .. format("%s (%s): %s", SY:ColorStr(L["ERROR"], .7, 0, 0), L["Tank/DPS-layout"], dpsError)
					end
				end,
				--name = L["User-configurations validate:"] .. " " .. SY:ColorStr(L["OK"], 0, .7, 0),
				fontSize = "large",
			},
			spacer = {
				order = 190,
				type = "description",
				name = "\n\n\n",
			},
			userConfigHelpHeader = {
				order = 200,
				type = "header",
				name = SY:ColorStr(L["HOWTO"]),
			},
			userConfigHelpDesc = {
				order = 210,
				type = "description",
				name = format(L["SY_USERCONFIG_HELP"],
					SY:ColorStr("1."),
					SY:ColorStr("2."),
					SY:ColorStr("3."),
					SY:ColorStr("4."),
					SY:ColorStr("SY:SetMoverPosition()"),
					SY:ColorStr(L["Tip:"]),
					SY:ColorStr(":SetPoint()"),
					SY:ColorStr("5."),
					SY:ColorStr("6.")
				),
				fontSize = "medium",
			},
			userConfigHelpExampleDesc = {
				order = 220,
				type = "description",
				name =  format("\n%s\n\n%s\n", SY:ColorStr(L["Example:"]), example),
				fontSize = "medium", --"large",
			},
		},
	}
end
SY.configs["userConfig"] = UFUserOptions


-- Slash-commands to change layouts
local function HEAL() -- switch to heal layout via a command
	SY.HealLayout("healer")

	if E.db.SY and E.db.SY.unitframes and E.db.SY.unitframes.healLayoutUserConfig and E.db.SY.unitframes.healLayoutUserConfig ~= "" then
		if E.db.SY.unitframes.dpsLayoutValidates then
			local userConfig = "local E, L, V, P, G = unpack(ElvUI); local SY = E:GetModule(\"SynesThesia\");" .. E.db.SY.unitframes.healLayoutUserConfig
			--[[
			local func, errorMessage = loadstring(userConfig)
			if func then
				local retOK, ret1 = pcall(func)
				if retOK then
					SY:Print("YK OK")
				else
					SY:Print("ERROR 2:", ret1)
				end
			else
				SY:Print("ERROR 1:", errorMessage)
			end
			]]
			assert(loadstring(userConfig, L["Healer-layout user-config"])) (); -- Evaluate User-config
		else
			SY:Print("%s: %s", SY:ColorStr(L["ERROR"], .7, 0, 0), L["Healer-layout user-config doesn't validate, skipping..."])
		end
	end

	UF:CreateAndUpdateHeaderGroup("party")
	UF:CreateAndUpdateHeaderGroup("raid")
	UF:CreateAndUpdateHeaderGroup("raid40") -- Call this because this is disabled in Heal-layout and enabled in DPS/Tank-layout

	-- We have to call this twice for some reason for all the changes to take effect and the positioning is bit borked
	C_Timer.After(0, function() -- Fire on next frame instead of current frame
		UF:CreateAndUpdateHeaderGroup("party")
		UF:CreateAndUpdateHeaderGroup("raid")
		UF:CreateAndUpdateHeaderGroup("raid40") -- Call this because this is disabled in Heal-layout and enabled in DPS/Tank-layout
	end)
	SY:Print(L["Healer-layout enabled (%s to switch back to Tank/DPS-layout)"], SY:ColorStr("/dps"))

	--DisableAddOn("Tukui_Dps_Layout")
	--EnableAddOn("Tukui_Heal_Layout")
	--ReloadUI()
end
SLASH_HEAL1 = "/heal"
SlashCmdList["HEAL"] = HEAL

local function DPS() -- switch to dps layout via a command
	local currentSpec = GetSpecialization()
	if currentSpec then -- This doesn't really matter, at lest for now since we only check for healer if we check for it all
		local _, _, _, _, _, role = GetSpecializationInfo(currentSpec)
		if role and role == "TANK" then -- "DAMAGER", "TANK", "HEALER"
			SY.DPSLayout("tank")
		else
			SY.DPSLayout("dps")
		end
	else
		SY.DPSLayout("dps")
	end

	if E.db.SY and E.db.SY.unitframes and E.db.SY.unitframes.dpsLayoutUserConfig and E.db.SY.unitframes.dpsLayoutUserConfig ~= "" then
		if E.db.SY.unitframes.dpsLayoutValidates then
			local userConfig = "local E, L, V, P, G = unpack(ElvUI); local SY = E:GetModule(\"SynesThesia\");" .. E.db.SY.unitframes.dpsLayoutUserConfig
			assert(loadstring(userConfig, L["Tank/DPS-layout user-config"])) (); -- Evaluate User-config
		else
			SY:Print("%s: %s", SY:ColorStr(L["ERROR"], .7, 0, 0), L["Tank/DPS-layout user-config doesn't validate, skipping..."])
		end
	end

	--SY.DPSLayout("dps")
	UF:CreateAndUpdateHeaderGroup("party")
	UF:CreateAndUpdateHeaderGroup("raid")
	UF:CreateAndUpdateHeaderGroup("raid40") -- Call this because this is disabled in Heal-layout and enabled in DPS/Tank-layout
	-- We have to call this twice for some reason for all the changes to take effect and the positioning is bit borked
	C_Timer.After(0, function() -- Fire on next frame instead of current frame
		UF:CreateAndUpdateHeaderGroup("party")
		UF:CreateAndUpdateHeaderGroup("raid")
		UF:CreateAndUpdateHeaderGroup("raid40") -- Call this because this is disabled in Heal-layout and enabled in DPS/Tank-layout
	end)
	SY:Print(L["Tank/DPS-layout enabled (%s to switch back to Healer-layout)"], SY:ColorStr("/heal"))

	--DisableAddOn("Tukui_Heal_Layout")
	--EnableAddOn("Tukui_Dps_Layout")
	--ReloadUI()
end
SLASH_DPS1 = "/dps"
SlashCmdList["DPS"] = DPS