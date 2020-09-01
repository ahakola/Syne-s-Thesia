--[[----------------------------------------------------------------
--	Syne's Thesia, an ElvUI edit by ahak @ tukui.org
--
--  Buff Reminder lifted and slightly edited from Syne's Edit
--  Eternal WiP and probably should be totally rewritten.
----------------------------------------------------------------]]--
local E, L, V, P, G, _ = unpack(ElvUI) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local SY = E:GetModule("SynesThesia")

--if (not E.db) or (not E.db.SY) or (not E.db.SY.general) or (E.db.SY.general.buffreminder ~= true) then return end
local remindbuffs = { -- I will populate this with more up to date information later (maybe)
	PRIEST = {
		21562, -- Power Word: Fortitude
		--588, -- inner fire
		--73413, -- inner will
	},
	HUNTER = {
		--13165, -- hawk
		--5118, -- cheetah
		--13159, -- pack
		--20043, -- wild
		--82661, -- fox
	},
	MAGE = {
		1459, -- Arcane Intellect
		--7302, -- frost armor
		--6117, -- mage armor
		--30482, -- molten armor
	},
	WARLOCK = {
		285933, -- Demon Armor
		--28176, -- fel armor
		--687, -- demon armor
	},
	SHAMAN = {
		--52127, -- water shield
		--324, -- lightning shield
		--974, -- earth shield
	},
	WARRIOR = {
		--469, -- commanding Shout
		--6673, -- battle Shout
	},
	DEATHKNIGHT = {
		--57330, -- horn of winter
		--31634, -- strength of earth totem
		--6673, -- battle Shout
		--93435, -- roar of courage (hunter pet)
	},
}

-- Nasty stuff below. Don't touch.
local class = E.myclass
local buffs = remindbuffs[class]

--SY:Print("Buffs:", class, buffs and #buffs or "n/a") -- Debug

if (buffs and buffs[1]) then
	local function OnEvent(self, event)
		--SY:Print("OnEvent", event) -- Debug
		if (event == "PLAYER_LOGIN" or event == "LEARNED_SPELL_IN_TAB") then
			for i, buff in pairs(buffs) do
				local name = GetSpellInfo(buff)
				local usable, nomana = IsUsableSpell(name)
				if (usable or nomana) then
					--if E.myclass == "PRIEST" then 
					--	self.icon:SetTexture([[\Interface\AddOns\SynesThesia\media\textures\innerarmor]])
					--else
						self.icon:SetTexture(select(3, GetSpellInfo(buff)))
					--end
					break
				end
			end
			if (not self.icon:GetTexture() and event == "PLAYER_LOGIN") then
				self:UnregisterAllEvents()
				self:RegisterEvent("LEARNED_SPELL_IN_TAB")
				return
			elseif (self.icon:GetTexture() and event == "LEARNED_SPELL_IN_TAB") then
				self:UnregisterAllEvents()
				--self:RegisterEvent("UNIT_AURA")
				frame:RegisterUnitEvent("UNIT_AURA", "player")
				self:RegisterEvent("PLAYER_LOGIN")
				self:RegisterEvent("PLAYER_REGEN_ENABLED")
				self:RegisterEvent("PLAYER_REGEN_DISABLED")
			end
		end

		-- Return at this point if this feature isn't enabled, since I'm too busy to make proper toggle for this now
		if (not E.db) or (not E.db.SY) or (not E.db.SY.general) or (E.db.SY.general.buffreminder ~= true) then return end

		if (UnitAffectingCombat("player") and not UnitInVehicle("player")) then
			for i, buff in pairs(buffs) do
				local name = GetSpellInfo(buff)
				--[[if (name and UnitBuff("player", name)) then
					self:Hide()
					return
				end]]
				if name then
					for i = 1, 40 do
						local bname = UnitBuff("player", i)
						if bname == name then
							self:Hide()
							return
						end
					end
				end
			end
			self:Show()
		else
			self:Hide()
		end
	end
	
	local frame = CreateFrame("Frame", _, UIParent)
	
	frame.icon = frame:CreateTexture(nil, "OVERLAY")
	frame.icon:SetPoint("CENTER")
	--if E.myclass ~= "PRIEST" then
		SY:StylePanel(frame, E:Scale(40), E:Scale(40), "CENTER", UIParent, "CENTER", 0, E:Scale(200))
		frame.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		frame.icon:SetWidth(E:Scale(36))
		frame.icon:SetHeight(E:Scale(36))
	--else
	--	SY:StylePanel(frame, E:Scale(96), E:Scale(192), "CENTER", UIParent, "CENTER", 0, E:Scale(200))
	--	frame.icon:SetWidth(E:Scale(96))
	--	frame.icon:SetHeight(E:Scale(192))
	--	frame:SetBackdropColor(0, 0, 0, 0)
	--	frame:SetBackdropBorderColor(0, 0, 0, 0)
	--end
	frame:Hide()
	
	--frame:RegisterEvent("UNIT_AURA")
	frame:RegisterUnitEvent("UNIT_AURA", "player")
	frame:RegisterEvent("PLAYER_LOGIN")
	frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	--frame:RegisterEvent("UNIT_ENTERING_VEHICLE")
	--frame:RegisterEvent("UNIT_ENTERED_VEHICLE")
	--frame:RegisterEvent("UNIT_EXITING_VEHICLE")
	--frame:RegisterEvent("UNIT_EXITED_VEHICLE")
	frame:RegisterUnitEvent("UNIT_ENTERING_VEHICLE", "player")
	frame:RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "player")
	frame:RegisterUnitEvent("UNIT_EXITING_VEHICLE", "player")
	frame:RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player")
	
	frame:SetScript("OnEvent", OnEvent)
end