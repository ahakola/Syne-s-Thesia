--[[----------------------------------------------------------
--	Syne's Thesia, an ElvUI edit by ahak @ tukui.org
--
--	This file contains core functions and updates media
----------------------------------------------------------]]--
local E, L, V, P, G, _ = unpack(ElvUI) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local SY = E:GetModule("SynesThesia")
local M = E:GetModule("Misc")
local LSM = LibStub("LibSharedMedia-3.0")

--Cache global variables
--Lua functions
local _G = _G
local print, select = print, select
local format = string.format
--WoW API / Variables
local C_ChatBubbles_GetAllChatBubbles = C_ChatBubbles.GetAllChatBubbles

--Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS: CHAT_FONT_HEIGHTS, NumberFont_Shadow_Med, WorldFrame

--[[
function SY:Print(msg)
	print('|cff00b3ffSyne\'s Thesia:|r', msg)
end
]]
-- Replaced SY:Print() with better one...
function SY:Print(text, ...)
	if text then
		if text:match("%%[dfqs%d%.]") then
			DEFAULT_CHAT_FRAME:AddMessage("|cff00b3ffSyne\'s Thesia:|r " .. format(text, ...))
		else
			DEFAULT_CHAT_FRAME:AddMessage("|cff00b3ffSyne\'s Thesia:|r " .. strjoin(" ", text, tostringall(...)))
		end
	end
end

--Copied from ElvUI
local function RGBToHex(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return format("%02x%02x%02x", r*255, g*255, b*255)
end

function SY:ColorStr(str, r, g, b)
	local hex
	local coloredString
	
	if r and g and b then
		hex = RGBToHex(r, g, b)
	else
		hex = RGBToHex(0, 0.7, 1) --Light blue
	end
	
	coloredString = "|cff"..hex..str.."|r"
	return coloredString
end

function SY:SetMoverPosition(mover, point, anchor, secondaryPoint, x, y)
	if not _G[mover] then return end
	local frame = _G[mover]

	frame:ClearAllPoints()
	frame:SetPoint(point, anchor, secondaryPoint, x, y)
	E:SaveMoverPosition(mover)
end

function SY:UpdateMedia()
	--SY.media.chatbubblecolor = E:GetColorTable(E.db.SY.general.chatbubblecolor)
	
	--Timestamp Colors
	--[[
	local text = E.db.SY.chat.textColor
	local bracket = E.db.SY.chat.bracketColor
	SY.media.HexTextColor = RGBToHex(text.r, text.g, text.b)
	SY.media.HexBracketColor = RGBToHex(bracket.r, bracket.g, bracket.b)
	]]
end

local function SetFont(obj, font, size, style, r, g, b, sr, sg, sb, sox, soy)
	--SY:Print("SetFont:", type(obj), font, size, style, r, g, b, sr, sg, sb, sox, soy) -- Debug
	obj:SetFont(font, size, style)
	if sr and sg and sb then obj:SetShadowColor(sr, sg, sb) end
	if sox and soy then obj:SetShadowOffset(sox, soy) end
	if r and g and b then obj:SetTextColor(r, g, b)
	elseif r then obj:SetAlpha(r) end
end

-- Tirisfal
-- Shifring Sand

SY.raidscale = 1
function SY:UpdateBlizzardFonts()
	--if not E.db.SY or not E.db.SY.chat or not E.db.SY.chat.editFonts then return end

	--[[
	--Prepare fonts
	local EDITBOXFONT = LSM:Fetch("font", E.db.SY.chat.editboxFont)
	local EDITBOXFONTSIZE = E.db.SY.chat.editboxFontSize

	--Change minimum allowed chat font size from 12 to 8
	CHAT_FONT_HEIGHTS = {8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}

	if (not EDITBOXFONT) or (not EDITBOXFONTSIZE) then return end -- UpdateBlizzardFonts() gets called several times during initial login, one of them is a bit too early
	--Change some game fonts and styles
	NumberFont_Shadow_Med:SetFont(EDITBOXFONT, EDITBOXFONTSIZE)
	]]

	local NORMAL	= SY.media.font
	local COMBAT	= SY.media.dmgfont
	local ZONE		= SY.media.zone
	local NUMBER	= SY.media.font	
	local CHAT		= SY.media.chat
	local TIP		= SY.media.tooltip	

	UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = 12
	CHAT_FONT_HEIGHTS = { 12, 13, 14, 15, 16, 17, 18, 19, 20 }

	UNIT_NAME_FONT		= NORMAL
	NAMEPLATE_FONT		= NORMAL
	DAMAGE_TEXT_FONT	= COMBAT
	STANDARD_TEXT_FONT	= NORMAL

	-- Base fonts
	SetFont(GameTooltipHeader,					NORMAL,	15*SY.raidscale, "OUTLINE")
	SetFont(NumberFont_OutlineThick_Mono_Small,	NUMBER,	12, "OUTLINE")
	SetFont(NumberFont_Outline_Huge,			NUMBER,	28, "THICKOUTLINE")
	SetFont(NumberFont_Outline_Large,			NUMBER,	15, "OUTLINE")
	SetFont(NumberFont_Outline_Med,				NUMBER,	13, "OUTLINE")
	SetFont(NumberFont_Shadow_Med,				CHAT,	12)
	SetFont(NumberFont_Shadow_Small,			CHAT,	12)
	SetFont(QuestFont,							TIP,	14)
	SetFont(QuestFont_Large,					NORMAL,	14)
	SetFont(SystemFont_Large,					NORMAL,	15)
	SetFont(SystemFont_Med1,					NORMAL,	12)
	SetFont(SystemFont_Med3,					NORMAL,	13)
	SetFont(SystemFont_OutlineThick_Huge2,		NORMAL,	20, "THICKOUTLINE")
	SetFont(SystemFont_Outline_Small,			NUMBER,	12, "OUTLINE")
	SetFont(SystemFont_Shadow_Large,			NORMAL,	15)
	SetFont(SystemFont_Shadow_Med1,				TIP,	12*SY.raidscale, "OUTLINE")
	SetFont(SystemFont_Shadow_Med3,				NORMAL,	13)
	SetFont(SystemFont_Shadow_Outline_Huge2,	NORMAL,	20, "OUTLINE")
	SetFont(SystemFont_Shadow_Small,			TIP,	11*SY.raidscale, "OUTLINE")
	SetFont(SystemFont_Small,					NORMAL,	12)
	SetFont(SystemFont_Tiny,					NORMAL,	12)
	SetFont(Tooltip_Med,						TIP,	12*SY.raidscale, "OUTLINE")
	SetFont(Tooltip_Small,						TIP,	12*SY.raidscale, "OUTLINE")
	SetFont(CombatTextFont,						COMBAT,	100, "OUTLINE") -- number here just increase the font quality.
	SetFont(SystemFont_Shadow_Huge1,			ZONE,	20, "THINOUTLINE")
	SetFont(ZoneTextString,						ZONE,	32, "OUTLINE")
	SetFont(SubZoneTextString,					ZONE,	25, "OUTLINE")
	SetFont(PVPInfoTextString,					ZONE,	22, "THINOUTLINE")
	SetFont(PVPArenaTextString,					ZONE,	22, "THINOUTLINE")
end

function SY.CalculateBarBGHeight()
	local height = 0
	local buttonSize = E.db.actionbar.bar1.buttonsize or 32
	local buttonSpacing = E.db.actionbar.bar1.buttonspacing or 4
	if E.db.SY.actionbar.smallbottom then
		if E.db.SY.actionbar.bottomrows == 1 then
			height = buttonSize + (buttonSpacing * 2)
		elseif E.db.SY.actionbar.bottomrows == 2 or E.db.SY.actionbar.split then
			height = (buttonSize * 2) + (buttonSpacing * 3)
		else
			height = (buttonSize * 3) + (buttonSpacing * 4)
		end
	else
		if E.db.SY.actionbar.bottomrows == 1 then
			height = buttonSize + (buttonSpacing * 2)
		else
			height = (buttonSize * 2) + (buttonSpacing * 3)
		end
	end

	return height
end

local blankTex = LSM:Fetch("border", SY.media.blank)
function SY:CenterGradientH(f, w, h, a1, p, a2, x, y)
	sh = E:Scale(h)
	sw = E:Scale(w)
	f:SetFrameLevel(1)
	f:SetHeight(sh)
	f:SetWidth(sw)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint(a1, p, a2, x, y)	
	f.bg1 = f:CreateTexture(nil, "BACKGROUND")
	f.bg1:SetPoint("TOPRIGHT", f)
	f.bg1:SetPoint("BOTTOMLEFT", f, "BOTTOM")
	--f.bg1:SetTexture(SY.media.blank)
	f.bg1:SetTexture(blankTex)
	f.bg1:SetGradientAlpha("Horizontal", 0, 0, 0, 1, 0, 0, 0, 0)
	f.bg2 = f:CreateTexture(nil, "BACKGROUND")
	f.bg2:SetPoint("TOPLEFT", f)
	f.bg2:SetPoint("BOTTOMRIGHT", f, "BOTTOM")
	--f.bg2:SetTexture(SY.media.blank)
	f.bg2:SetTexture(blankTex)
	f.bg2:SetGradientAlpha("Horizontal", 0, 0, 0, 0, 0, 0, 0, 1)
end

function SY:CenterGradientV(f, w, h, a1, p, a2, x, y)
	sh = E:Scale(h)
	sw = E:Scale(w)
	f:SetFrameLevel(1)
	f:SetHeight(sh)
	f:SetWidth(sw)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint(a1, p, a2, x, y)	
	f.bg1 = f:CreateTexture(nil, "BACKGROUND")
	f.bg1:SetPoint("TOPRIGHT", f)
	f.bg1:SetPoint("BOTTOMLEFT", f, "LEFT")
	--f.bg1:SetTexture(SY.media.blank)
	f.bg1:SetTexture(blankTex)
	f.bg1:SetGradientAlpha("Vertical",  0, 0, 0, 1, 0, 0, 0, 0)
	f.bg2 = f:CreateTexture(nil, "BACKGROUND")
	f.bg2:SetPoint("BOTTOMRIGHT", f)
	f.bg2:SetPoint("TOPLEFT", f, "LEFT")
	--f.bg2:SetTexture(SY.media.blank)
	f.bg2:SetTexture(blankTex)
	f.bg2:SetGradientAlpha("Vertical", 0, 0, 0, 0, 0, 0, 0, 1)
end

function SY:LeftGradient(f, w, h, a1, p, a2, x, y)
	sh = E:Scale(h)
	sw = E:Scale(w)
	f:SetFrameLevel(1)
	f:SetHeight(sh)
	f:SetWidth(sw)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint(a1, p, a2, x, y)	
	f.bg = f:CreateTexture(nil, "BACKGROUND")
	f.bg:SetAllPoints(f)
	--f.bg:SetTexture(SY.media.blank)
	f.bg:SetTexture(blankTex)
	f.bg:SetGradientAlpha("Horizontal", 0, 0, 0, 1, 0, 0, 0, 0)
end

function SY:RightGradient(f, w, h, a1, p, a2, x, y)
	sh = E:Scale(h)
	sw = E:Scale(w)
	f:SetFrameLevel(1)
	f:SetHeight(sh)
	f:SetWidth(sw)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint(a1, p, a2, x, y)	
	f.bg = f:CreateTexture(nil, "BACKGROUND")
	f.bg:SetAllPoints(f)
	--f.bg:SetTexture(SY.media.blank)
	f.bg:SetTexture(blankTex)
	f.bg:SetGradientAlpha("Horizontal", 0, 0, 0, 0, 0, 0, 0, 1)
end

local glowTex = LSM:Fetch("statusbar", SY.media.glowTex)
function SY:CreateShadow(f)
	if f.shadow then return end -- we seriously don't want to create shadow 2 times in a row on the same frame.
	local shadow = CreateFrame("Frame", nil, f)
	shadow:SetFrameLevel(1)
	shadow:SetFrameStrata(f:GetFrameStrata())
	--[[
	shadow:SetPoint("TOPLEFT", E:Scale(-4), E:Scale(4))
	shadow:SetPoint("BOTTOMLEFT", E:Scale(-4), E:Scale(-4))
	shadow:SetPoint("TOPRIGHT", E:Scale(4), E:Scale(4))
	shadow:SetPoint("BOTTOMRIGHT", E:Scale(4), E:Scale(-4))
	]]
	shadow:SetPoint("TOPLEFT", E:Scale(-3), E:Scale(3))
	shadow:SetPoint("BOTTOMLEFT", E:Scale(-3), E:Scale(-4))
	shadow:SetPoint("TOPRIGHT", E:Scale(3), E:Scale(3))
	shadow:SetPoint("BOTTOMRIGHT", E:Scale(3), E:Scale(-4))
	shadow:SetBackdrop( { 
		edgeFile = glowTex,
		edgeSize = E:Scale(3),
		insets = {
			left = E:Scale(5),
			right = E:Scale(5),
			top = E:Scale(5),
			bottom = E:Scale(5)
		},
	})
	shadow:SetBackdropColor(0, 0, 0, 0)
	shadow:SetBackdropBorderColor(0, 0, 0, 0.5)
	f.shadow = shadow
end

function SY:SetFontString(parent, fontName, fontHeight, fontStyle)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetFont(fontName, fontHeight, fontStyle)
	fs:SetJustifyH("LEFT")
	fs:SetShadowColor(0, 0, 0)
	fs:SetShadowOffset(1.25, -1.25)
	return fs
end

function SY:FixFontString(fontString, fontName, fontHeight, fontStyle)
	if not fontString then return end
	if fontName or fontHeight or fontStyle then
		fontString:SetFont(fontName, fontHeight, fontStyle)
	end
	--fontString:SetJustifyH("LEFT")
	fontString:SetShadowColor(0, 0, 0)
	fontString:SetShadowOffset(1.25, -1.25)
end

function SY:StylePanel(f, w, h, a1, p, a2, x, y)
	sh = E:Scale(h)
	sw = E:Scale(w)
	f:SetFrameLevel(1)
	f:SetHeight(sh)
	f:SetWidth(sw)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint(a1, p, a2, x, y)
	f:SetBackdrop({
		bgFile = blankTex,
		edgeFile = blankTex,
		tile = false, tileSize = 0, edgeSize = 1,
		insets = { left = -1, right = -1, top = -1, bottom = -1 }
	})
	f:SetBackdropColor(unpack(SY.media.backdropcolor))
	f:SetBackdropBorderColor(unpack(SY.media.bordercolor))
end

local function GeneralOptions()
	E.Options.args.SY.args.misc = {
		order = 100,
		type = "group",
		name = L["Miscellaneous"],
		get = function(info) return E.db.SY.general[ info[#info] ] end,
		set = function(info, value) E.db.SY.general[ info[#info] ] = value end,
		args = {
			miscHeader = {
				order = 10,
				type = "header",
				name = SY:ColorStr(L["Miscellaneous"]),
			},
			buffreminder = {
				order = 20,
				type = "toggle",
				name = L["Buff Reminder"],
				desc = L["This is now the new inner fire warning script for all armors/aspects of a class."],
			},
			recountHack = {
				order = 30,
				type = "toggle",
				name = L["Recount fix"],
				desc = L["This hack should fix the problem of Recount not showing up when it should."],
				set = function(info, value)
					E.db.SY.general[ info[#info] ] = value
					if (value) then
						-- Recount QoL
						if IsAddOnLoaded("Recount") then
							Recount.MainWindow:Show()
						end
					end
				end,
			},
			spacer = {
				order = 100,
				type = "description",
				name = "\n\n\n",
			},
			experimentalGroup = {
				order = 110,
				type = "group",
				name = L["Experimental"],
				guiInline = true,
				args = {
					altPlayerDebuffs = {
						order = 10,
						type = "toggle",
						name = L["Experimental 1"],
						desc = L["Experimental 1 Desc"],
					},
					disclaimerDesc = {
						order = 999,
						type = "description",
						name = L["SY_EXPERIMENTAL_DESC"],
					},
				},
			},
		},
	}
end
SY.configs["general"] = GeneralOptions