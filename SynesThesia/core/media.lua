--[[---------------------------------------------------------
--	Syne's Thesia, an ElvUI edit by ahak @ tukui.org
--
--	This file contains the code that registers media
---------------------------------------------------------]]--
local E, L, V, P, G, _ = unpack(ElvUI) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local SY = E:GetModule("SynesThesia")
local LSM = LibStub("LibSharedMedia-3.0")

local function RegisterFont(name, file)
	LSM:Register("font", name, "Interface\\AddOns\\SynesThesia\\media\\fonts\\" .. file)
end

local function RegisterSound(name, file)
	LSM:Register("sound", name, "Interface\\AddOns\\SynesThesia\\media\\sounds\\" .. file)
end

local function RegisterStatusbar(name, file)
	LSM:Register("statusbar", name, "Interface\\AddOns\\SynesThesia\\media\\textures\\" .. file)
end

local function RegisterBorder(name, file)
	LSM:Register("border", name, "Interface\\AddOns\\SynesThesia\\media\\textures\\" .. file)
end

RegisterFont("Agency FB Bold", "Agency.ttf")
RegisterFont("Defused Extended Bold", "defused.ttf")
--RegisterFont("BigNoodleTitling", "uf_font.ttf") -- The OG font
RegisterFont("BigNoodleTitling", "uf_font2.ttf") -- Same as above, but this should be better because I guess it supports Cyrilic characters based on the name of the font?

--RegisterSound("whisper", "whisper.mp3")
--RegisterSound("warning", "warning.mp3")

RegisterStatusbar("normTex", "normTex.tga")
RegisterStatusbar("glowTex", "glowTex.tga")
RegisterStatusbar("bubbleTex", "bubbleTex.tga")
RegisterStatusbar("blank", "blank.tga")
RegisterStatusbar("button_hover", "button_hover.tga")

RegisterBorder("blank", "blank.tga")

SY.media = {
	-- fonts ((ENGLISH, FRENCH, GERMAN, SPANISH))
	["font"] = "BigNoodleTitling", -- general font of tukui
	["uffont"] = "BigNoodleTitling", -- general font of unitframes
	["chat"] = "Agency FB Bold", -- general font of chat
	["tooltip"] = "Agency FB Bold", -- general font of tooltips / etc
	["zone"] = "Defused Extended Bold", -- zone font
	["dmgfont"] = "Defused Extended Bold", -- general font of dmg / sct
	
	-- textures
	["normTex"] = "normTex", -- texture used for tukui healthbar/powerbar/etc
	["glowTex"] = "glowTex", -- the glow text around some frame.
	["bubbleTex"] = "bubbleTex", -- unitframes combo points
	["blank"] = "blank", -- the main texture for all borders/panels
	["bordercolor"] = { .2, .2, .2, 1 }, -- border color of tukui panels
	["altbordercolor"] = { .2, .2, .2, 1 }, -- alternative border color, mainly for unitframes text panels.
	["backdropcolor"] = { .02, .02, .02, 1 }, -- background color of tukui panels
	["buttonhover"] = "button_hover",

	-- sound
	--["whisper"] = whisper.mp3,
	--["warning"] = warning.mp3,
}