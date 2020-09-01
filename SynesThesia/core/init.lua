--[[------------------------------------------------------------
--	Syne's Thesia, an ElvUI edit by ahak @ tukui.org
--
--	This file contains initialization code for Syne'sThesia
------------------------------------------------------------]]--
local E, L, V, P, G, _ = unpack(ElvUI) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local SY = E:NewModule("SynesThesia", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local EP = LibStub("LibElvUIPlugin-1.0")
local addon, ns = ...

--Cache global variables
--Lua functions
local tonumber, pairs = tonumber, pairs
local format = string.format

SY.version = GetAddOnMetadata("SynesThesia", "Version")
SY.versionMinE = 11.00
SY.configs = {}

SY.title = "|cff1784d1Syne\'s|r Thesia"
--SY.title = "|cffc495ddSyne\'s|r Thesia"
SY.name = addon

E.PopupDialogs["SY_WARNINGVERSION"] = {
	text = L["Your version of ElvUI is older than recommended for use with %s. Please update ElvUI at your earliest convenience."],
	button1 = CLOSE,
	timeout = 0,
	whileDead = 1,
	preferredIndex = 3,
}

function SY:InsertOptions()
	--Main GUI group
	E.Options.args.SY = {
		order = 100,
		type = "group",
		name = SY.title,
		childGroups = "tab",
		args = {
			addonHeader = {
				order = 10,
				type = "header",
				name = format(L["%s version %s by Sanex @ Arathor-EU"], SY.title, SY:ColorStr(SY.version)),
			},		
			addonDescription = {
				order = 20,
				type = "description",
				name = format(L["%s is an external edit of ElvUI based on the original Syne's Edit of TukUI."] .. "\n\n", SY.title),
				fontSize = "medium",
			},
			general = {
				order = 30,
				type = "group",
				name = L["Installation"] .. " / " .. L["Credits"],
				args = {
					installHeader = {
						order = 10,
						type = "header",
						name = SY:ColorStr(L["Installation"]),
					},
					installDescription = {
						order = 20,
						type = "description",
						name = format(L["The installation guide should pop up automatically after you have completed the ElvUI installation. Click the button below if you ever wish to run the installation process for %s again."] .. "\n\n", SY.title),
					},
					installButton = {
						order = 30,
						type = "execute",
						name = L["Install"],
						desc = L["Run the installation process."],
						func = function() E:GetModule("PluginInstaller"):Queue(SY.PluginInstaller); E:ToggleOptionsUI(); end,
					},
					layoutDescription = {
						order = 40,
						type = "description",
						name = "\n\n" .. format(L["You can change the layout after install with slash-commands %s for Tank/DPS-layout and %s for Healer-layout."], SY:ColorStr("/dps"), SY:ColorStr("/heal")),
					},
				},
			},
		},
	}
	
	--Insert the rest of the configs
	for _, func in pairs(SY.configs) do func() end
end

function SY:Initialize()
	--Warn about ElvUI version being too low
	if tonumber(E.version) and (tonumber(E.version) < tonumber(SY.versionMinE)) then
		E:StaticPopup_Show("SY_WARNINGVERSION", SY.title)
	end
	
	--Initiate installation process if ElvUI install is complete and SY install has not yet been run
	if E.private.install_complete and E.db.SY.install_version == nil then
		E:GetModule("PluginInstaller"):Queue(SY.PluginInstaller)
	end

	--Updates
	SY:UpdateMedia()
	SY:UpdateBlizzardFonts()
	hooksecurefunc(E, "UpdateMedia", SY.UpdateMedia)
	hooksecurefunc(E, "UpdateBlizzardFonts", SY.UpdateBlizzardFonts) -- Does this even work?
	
	--Register plugin so options are properly inserted when config is loaded
	EP:RegisterPlugin(addon, SY.InsertOptions)

	if E.db.SY.general.recountHack then -- Recount QoL fix
		if IsAddOnLoaded("Recount") then
			SY:Print("Recount QoL Improved")
			Recount.MainWindow:Show()
		end
	end
end

local function InitializeCallback()
	SY:Initialize()
end

E:RegisterModule(SY:GetName(), InitializeCallback)