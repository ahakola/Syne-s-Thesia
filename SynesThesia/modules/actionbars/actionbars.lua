--[[-----------------------------------------------------------------
--	Syne's Thesia, an ElvUI edit by ahak @ tukui.org
--
--	This file contains changes/additions to the ElvUI Action Bars
-----------------------------------------------------------------]]--
local E, L, V, P, G, _ = unpack(ElvUI) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local AB = E:GetModule("ActionBars")
local TOTEMS = E:GetModule("Totems")
local SY = E:GetModule("SynesThesia")

-- ShiftBar
local function UpdateShiftBarPosition(self)
	--SY:Print("UpdateShiftBarPosition", self:GetName()) -- Debug
	--TukuiShift:SetPoint("TOPRIGHT", ChatLineRight2, "BOTTOMRIGHT", TukuiDB.Scale(-10), TukuiDB.Scale(-5))
	--TukuiShift:SetHeight(TukuiDB.Scale(2*TukuiDB.petbuttonsize))
	--button:SetPoint("BOTTOMRIGHT", TukuiShift, 0, TukuiDB.Scale(TukuiDB.petbuttonsize))
	local extraYOffset = E.db.actionbar.barPet.buttonsize or 28
	ElvUI_StanceBar:ClearAllPoints()
	ElvUI_StanceBar:SetPoint("TOPRIGHT", ChatLineRight2, "BOTTOMRIGHT", E:Scale(-10), E:Scale(-(5 + extraYOffset)))
end
hooksecurefunc(AB, "PositionAndSizeBarShapeShift", UpdateShiftBarPosition)

-- TotemBar
local function UpdateTotemBarPosition(self)
	--SY:Print("UpdateTotemBarPosition", self:GetName(), self.bar:GetName()) -- Debug
	--MultiCastActionBarFrame:SetPoint("BOTTOMRIGHT", TukuiShiftBar, 0, TukuiDB.Scale(TukuiDB.petbuttonsize))
	local bar = self.bar -- ElvUI_TotemBar

	local extraYOffset = E.db.actionbar.barPet.buttonsize or 28
	bar:ClearAllPoints()
	bar:SetPoint("TOPRIGHT", ChatLineRight2, "BOTTOMRIGHT", E:Scale(-6), E:Scale(-(1 + extraYOffset))) -- For some reason this is off by -4px, -4px
end
hooksecurefunc(TOTEMS, "Initialize", UpdateTotemBarPosition)


--ActionBar options
local sw = math.floor(GetScreenWidth() + .5)
local sh = math.floor(GetScreenHeight() + .5)
local function setupActionBars()
	--SY:Print("setupActionBars") -- Debug

	local barBG = SY.barBG
	local height = SY.CalculateBarBGHeight()
	barBG:SetHeight(height)

	if E.db.SY.actionbar.smallbottom then
		E.db.actionbar.bar2.enabled = (E.db.SY.actionbar.bottomrows >= 2)

		E.db.actionbar.bar1.buttons = 12
		E.db.actionbar.bar2.buttons = 12
		E.db.actionbar.bar3.buttons = 12
		E.db.actionbar.bar4.buttons = 12

		SY:SetMoverPosition("ElvAB_1", "BOTTOM", E.UIParent, "BOTTOM", 0, 48)
		SY:SetMoverPosition("ElvAB_2", "BOTTOM", ElvUI_Bar1, "TOP", 0, 4)

		if E.db.SY.actionbar.split then -- Pseudo Split
			E.db.actionbar.bar3.enabled = true
			E.db.actionbar.bar3.buttonsPerRow = 6

			E.db.actionbar.bar4.enabled = true
			E.db.actionbar.bar4.buttonsPerRow = 6

			SY:SetMoverPosition("ElvAB_3", "BOTTOMRIGHT", ElvUI_Bar1, "BOTTOMLEFT", -12, 0)
			SY:SetMoverPosition("ElvAB_4", "BOTTOMLEFT", ElvUI_Bar1, "BOTTOMRIGHT", 12, 0)
		else -- !Splitt
			E.db.actionbar.bar3.enabled = (E.db.SY.actionbar.bottomrows == 3)
			E.db.actionbar.bar3.buttonsPerRow = 12

			E.db.actionbar.bar4.enabled = false
			E.db.actionbar.bar4.buttonsPerRow = 12

			SY:SetMoverPosition("ElvAB_3", "BOTTOM", ElvUI_Bar2, "TOP", 0, 4)
		end

	else
		E.db.actionbar.bar2.enabled = true

		if E.db.SY.actionbar.bottomrows >= 2 then -- 2
			E.db.actionbar.bar3.enabled = true
			E.db.actionbar.bar4.enabled = true
		else -- 1
			E.db.actionbar.bar3.enabled = false
			E.db.actionbar.bar4.enabled = false
		end

		E.db.actionbar.bar1.buttons = 11
		E.db.actionbar.bar2.buttons = 11

		E.db.actionbar.bar3.buttons = 11
		E.db.actionbar.bar3.buttonsPerRow = 12

		E.db.actionbar.bar4.buttons = 11
		E.db.actionbar.bar4.buttonsPerRow = 12

		SY:SetMoverPosition("ElvAB_1", "BOTTOMRIGHT", E.UIParent, "BOTTOM", -2, 48)
		SY:SetMoverPosition("ElvAB_2", "BOTTOMLEFT", E.UIParent, "BOTTOM", 2, 48)
		SY:SetMoverPosition("ElvAB_3", "BOTTOM", ElvUI_Bar1, "TOP", 0, 4)
		SY:SetMoverPosition("ElvAB_4", "BOTTOM", ElvUI_Bar2, "TOP", 0, 4)
	end

	for i = 1, 4 do
		AB:PositionAndSizeBar("bar"..i)
		AB:UpdateButtonSettingsForBar("bar"..i)
	end
	C_Timer.After(0, function() -- Fire on next frame instead of current frame
		for i = 1, 4 do
			AB:PositionAndSizeBar("bar"..i)
			AB:UpdateButtonSettingsForBar("bar"..i)
		end
	end)

	SY:SetMoverPosition("PetAB", "BOTTOM", E.UIParent, "BOTTOM", 0, 58 + height)
	AB:PositionAndSizeBarPet()

	local UFHeight = BottomLine2:GetBottom() + 8 -- From bottom to the bottom of BottomLine2 + the height of BottomLine2, this is the point where the Unitframes should anchor for real
	SY:SetMoverPosition("ElvUF_PlayerMover", "BOTTOMRIGHT", E.UIParent, "BOTTOM", -70, UFHeight + 86) -- BOTTOMRIGHT, BottomLine2, TOP, -70, 86
	SY:SetMoverPosition("ElvUF_FocusMover", "BOTTOM", E.UIParent, "BOTTOM", 0, UFHeight + 86) -- BOTTOM, BottomLine2, TOP, 0, 86
	SY:SetMoverPosition("ElvUF_TargetMover", "BOTTOMLEFT", E.UIParent, "BOTTOM", 70, UFHeight + 86) -- BOTTOMLEFT, BottomLine2, TOP, 70, 86
	--SY:SetMoverPosition("ElvUF_TargetTargetMover", "TOP", ElvUF_TargetMover, "BOTTOMRIGHT", 0, -30)
	--SY:SetMoverPosition("ElvUF_PetMover", "TOP", ElvUF_PlayerMover, "BOTTOMLEFT", 0, -30)
	--SY:SetMoverPosition("ElvUF_FocusTargetMover", "BOTTOM", ElvUF_FocusMover, "TOP", 0, 65)

	ElvUIPetBattleActionBar:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, 48)
end
local function setupMiddleBar()
	--SY:Print("setupMiddleBar") -- Debug

	E.db.actionbar.bar6.enabled = (E.db.SY.actionbar.middlebar)

	SY:SetMoverPosition("ElvAB_6", "CENTER", E.UIParent, "CENTER", E.db.SY.actionbar.mX, E.db.SY.actionbar.mY)

	AB:PositionAndSizeBar("bar6")
	--AB:UpdateButtonSettingsForBar("bar6")
end
local function ABOptions()
	E.Options.args.SY.args.actionbar = {
		order = 200,
		type = "group",
		name = L["ActionBars"],
		args = {
			actionbarHeader = {
				order = 10,
				type = "header",
				name = SY:ColorStr(L["ActionBars"]),
			},
			smallbottom = {
				order = 20,
				type = "toggle",
				name = L["12 Button Rows"],
				desc = L["Enables '12 Button Rows'. Disable to use '22 Button Rows' instead."],
				get = function(info) return E.db.SY.actionbar[ info[#info] ] end,
				set = function(info, value) E.db.SY.actionbar[ info[#info] ] = value; setupActionBars() end,
			},
			bottomrows = {
				order = 30,
				type = "range",
				name = L["Bottom ActionBar Rows"],
				desc = L["Third row is shown only if '12 Button Rows' are Enabled and 'Side ActionBars' are Disabled."],
				min = 1, max = 3, step = 1,
				get = function(info) return E.db.SY.actionbar[ info[#info] ] end,
				set = function(info, value) E.db.SY.actionbar[ info[#info] ] = value; setupActionBars() end,
			},
			split = {
				order = 40,
				type = "toggle",
				name = L["Side ActionBars"],
				desc = L["Enables 6x2 ActionBar on both sides of the bottom ActionBar(s)."],
				get = function(info) return E.db.SY.actionbar[ info[#info] ] end,
				set = function(info, value) E.db.SY.actionbar[ info[#info] ] = value; setupActionBars() end,
			},
			middlebarGroup = {
				order = 50,
				type = "group",
				name = L["Middle Bar"],
				guiInline = true,
				args = {
					middlebar = {
						order = 10,
						type = "toggle",
						name = L["Middle Bar"],
						desc = L["Enables extra ActionBar in the middle of the screen."],
						get = function(info) return E.db.SY.actionbar[ info[#info] ] end,
						set = function(info, value) E.db.SY.actionbar[ info[#info] ] = value; setupMiddleBar() end,
					},
					mX = {
						order = 20,
						type = "range",
						name = L["Middle Bar X-Offset"],
						desc = L["Horizontal offset for 'Middle Bar'."],
						min = -sw/2, max = sw/2, step = 1,
						get = function(info) return E.db.SY.actionbar[ info[#info] ] end,
						set = function(info, value) E.db.SY.actionbar[ info[#info] ] = value; setupMiddleBar() end,
					},
					mY = {
						order = 30,
						type = "range",
						name = L["Middle Bar Y-Offset"],
						desc = L["Vertical offset for 'Middle Bar'."],
						min = -sh/2, max = sh/2, step = 1,
						get = function(info) return E.db.SY.actionbar[ info[#info] ] end,
						set = function(info, value) E.db.SY.actionbar[ info[#info] ] = value; setupMiddleBar() end,
					},
				},
			},
		},
	}
end
SY.configs["actionbars"] = ABOptions