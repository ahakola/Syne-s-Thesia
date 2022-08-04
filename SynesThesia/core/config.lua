--[[------------------------------------------------------------------------
--	Syne's Thesia, an ElvUI edit by ahak @ tukui.org
--
--	This file contains the extra settings added in this edit of ElvUI
--	Positions are set in the install along with tweaks to the healer layout
------------------------------------------------------------------------]]--
local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local SY = E:GetModule("SynesThesia")

--Default options
P["SY"] = {
	["general"] = {
		["buffreminder"] = true,			-- this is now the new innerfire warning script for all armor/aspect class.

		-- My own modifications
		["recountHack"] = true,			-- I have problems with Recount staying hidden with ElvUI+AddOnSkins autohide, this is a hack to fix it.
		["altPlayerDebuffs"] = false,		-- enable alternative-style on player debuffs
		["darkTheme"] = false,				-- dark or light theme
		["dontChangeFonts"] = false,		-- Don't update fonts incase someone wants to use their own fonts
	},
	["unitframes"] = {
		-- general options
		["lowThreshold"] = 20,				-- global low threshold, for low mana warning.
		["combatfeedback"] = true,			-- enable combattext on player and target.

		-- My own modifications
		["roleIconStyle"] = true,			-- enable actual ElvUI style role icons instead of Syne's Edit's role colors
		["altTargetAuras"] = false,			-- enable alternative-style on target buffs/debuffs

		-- castbar
		["castbarlayout"] = 1,				-- 1 for inside unitframes, 2 for a seperate bar
			--castbar positon for layout 2
			["playercbpoint"] = "BOTTOM",	-- anchorpoint for player castbar
			["playercbX"] = 0,				-- X-offset (increase to move it to the right - decrease to move it to the left)
			["playercbY"] = 353,			-- Y-offset (increase to move it up - decrease to move it down)
			["targetcbpoint"] = "BOTTOM",	-- anchorpoint for target castbar
			["targetcbX"] = 0,				-- X-offset (increase to move it to the right - decrease to move it to the left)
			["targetcbY"] = 380,			-- Y-offset (increase to move it up - decrease to move it down)

		-- raid layout
		["gridonly"] = false,				-- enable grid only mode for all healer mode raid layout.
		["gridscale"] = 1,					-- set the healing grid scaling

		-- user-config for layouts
		["dpsLayoutUserConfig"] = "",		-- User-config for DPS-layout
		["healLayoutUserConfig"] = "",		-- User-config for Heal-layout
		["dpsLayoutValidates"] = true,		-- DPS-layout User-config validates
		["healLayoutValidates"] = true,		-- Heal-layout User-config validates
	},
	["actionbar"] = {
		["smallbottom"] = true,				-- 12 buttons bottombar
		["bottomrows"] = 3,					-- numbers of row you want to show at the bottom (select between 1, 2 and 3 --> 3 requires smallbottom = true)
		["split"] = true,					-- split the 3rd actionbar at the bottom  (requires bottomrows = 3)
		["middlebar"] = false,				-- enable a 2x6 bar in the middle of the screen
			["mX"] = 150,					-- X offset for the middlebar
			["mY"] = -50,					-- Y offset for the middlebar
	},
	--[[
	["datatexts"] = {
		["leftChatDatatextPanel"] = true,
		["rightChatDatatextPanel"] = true,
		["panels"] = {
			["SynesDataText1"] = "Guild",
			["SynesDataText2"] = "Friends",
			["SynesDataText3"] = "Quick Join",
			["SynesDataText4"] = "DPS",
			["SynesDataText5"] = "HPS",
			["SynesDataText6"] = "Call to Arms",
			["SynesDataText7"] = "Bags",
			["SynesDataText8"] = "Currencies",
			["SynesLeftDataText"] = {
				["left"] = "Talent/Loot Specialization",
				["middle"] = "Durability",
				["right"] = "BfA Missions",
			},
			["SynesRightDataText"] = {
				["left"] = "System",
				["middle"] = "Time",
				["right"] = "Gold",
			},
		},
	]]
		--[[
		-- 1 to 8 are below the bottomline
		["fps_ms"] = 7,						-- show fps and ms on panels
		["mem"] = 8,						-- show total memory on panels
		["bags"] = 5,						-- show space used in bags on panels
		["gold"] = 4,						-- show your current gold on panels
		["guild"] = 1,						-- show number on guildmate connected on panels
		["dur"] = 3,						-- show your equipment durability on panels.
		["friends"] = 2,					-- show number of friends connected.
		["dps_text"] = 0,					-- show a dps meter on panels
		["hps_text"] = 0,					-- show a heal meter on panels
		["power"] = 0,						-- show your attackpower/spellpower/healpower/rangedattackpower whatever stat is higher gets displayed
		["haste"] = 0,						-- show your haste rating on panels.
		["crit"] = 0,						-- show your crit rating on panels.
		["avd"] = 0,						-- show your current avoidance against the level of the mob your targeting
		["armor"] = 0,						-- show your armor value against the level mob you are currently targeting
		["currency"] = 6,					-- show your tracked currency on panels
		]]
	--},
	["chat"] = {
		-- My own modifications
		["timestampsOnRight"] = true,		-- set timestamps to the right side of the chatframe on loot-frame
	},
}

--Credit code, copied from ElvUI and modified
local DONATOR_STRING = ""
local CODING_STRING = ""
local TESTER_STRING = ""
local LINE_BREAK = "\n"
local DONATORS = {}
local TESTERS = {}
local CODING = {
	"Syne (Syne's Edit)", -- TukUI.org
	"Blazeflack (CodeNameBlaze and ElvUI CustomTweaks)", -- https://www.tukui.org/addons.php?id=2 & TukUI.org
	"Phanx (CombatText from oUF_Phanx)", -- https://github.com/phanx-wow/oUF_Phanx/blob/master/Elements/CombatText.lua
	"Vik & Nefarion (Undress-button)", -- https://github.com/ViksUI/ViksUI/blob/master/ViksUI/Modules/Misc/Misc.lua, check SynesThesia\modules\misc\misc.lua for more info
}
local tsort = table.sort
--tsort(DONATORS, function(a,b) return a < b end) --Alphabetize
for _, donatorName in pairs(DONATORS) do
	DONATOR_STRING = DONATOR_STRING..LINE_BREAK..donatorName
end

--tsort(CODING, function(a,b) return a < b end) --Alphabetize
for _, devName in pairs(CODING) do
	CODING_STRING = CODING_STRING..LINE_BREAK..devName
end

--tsort(TESTERS, function(a,b) return a < b end) --Alphabetize
for _, testerName in pairs(TESTERS) do
	TESTER_STRING = TESTER_STRING..LINE_BREAK..testerName
end

local BONUS_STRING = "I would also like to give special thanks to:\n- Hard working and inspiring creators of TukUI and ElvUI.\n- All those whose code I have taken look at and soaked inspiration from over the years.\n- Everyone who has helped me directly or indirectly to improve my skills over the years by providing nice coding tips and practices or even full code snippets over the years at TukUI-, WoWInterface- and CurseForge-forums."

local function Credits()
	E.Options.args.SY.args.general.args.spacer = {
		order = 100,
		type = "description",
		name = "\n\n\n",
	}
	E.Options.args.SY.args.general.args.creditsHeader = {
		order = 110,
		type = "header",
		name = SY:ColorStr(L["Credits"]),
	}
	E.Options.args.SY.args.general.args.creditsDescription = {
		order = 120,
		type = "description",
		name = L["SY_CREDITS"] .. "\n\n" .. SY:ColorStr(L["Coding:"]) .. CODING_STRING .. "\n\n" .. SY:ColorStr(L["Testing:"]) .. TESTER_STRING .. "\n\n" .. SY:ColorStr(L["Donations:"]) .. DONATOR_STRING .. "\n\n" .. BONUS_STRING,
	}
end
SY.configs["credits"] = Credits