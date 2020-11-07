--[[--------------------------------------------------------------
--	Syne's Thesia, an ElvUI edit by ahak @ tukui.org
--
--	This file contains changes/additions to the ElvUI Datatexts
--------------------------------------------------------------]]--
local E, L, V, P, G, _ = unpack(ElvUI) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local DT = E:GetModule("DataTexts")
local SY = E:GetModule("SynesThesia")

--Cache global variables
--Lua functions
local _G = _G
local pairs, type = pairs, type
--WoW API / Variables
local NONE = NONE

--Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS: LeftMiniPanel, Minimap

--[[
-- Replaced by ElvUI's Custom DTPanels feature in 9.0
function SY:LoadDataTexts()
	local db = E.db.SY.datatexts

	for panelName, panel in pairs(DT.RegisteredPanels) do
		for i = 1, panel.numPoints do
			local pointIndex = DT.PointLocation[i]
			
			--Register Panel to Datatext
			for name, data in pairs(DT.RegisteredDataTexts) do
				for option, value in pairs(db.panels) do
					if value and type(value) == "table" then
						if option == panelName and db.panels[option][pointIndex] and db.panels[option][pointIndex] == name then
							DT:AssignPanelToDataText(panel.dataPanels[pointIndex], data)
						end
					elseif value and type(value) == "string" and value == name then
						if db.panels[option] == name and option == panelName then
							DT:AssignPanelToDataText(panel.dataPanels[pointIndex], data)
						end
					end
				end
			end
		end
	end
end
hooksecurefunc(DT, "LoadDataTexts", SY.LoadDataTexts)


local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", function(self, event, ...)
	return self[event] and self[event](self, event, ...)
end)
frame:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")

-- Update Battleground "Datatexts"
function frame:UPDATE_BATTLEFIELD_SCORE(event)
	--SY:Print("UPDATE_BATTLEFIELD_SCORE") -- Debug

	local r, g, b = E.db.general.valuecolor.r or 254/255, E.db.general.valuecolor.g or 123/255, E.db.general.valuecolor.b or 44/255
	for i = 1, GetNumBattlefieldScores() do
		local name, killingBlows, honorableKills, deaths, honorGained, faction, race, class, classToken, damageDone, healingDone, bgRating, ratingChange, preMatchMMR, mmrChange, talentSpec = GetBattlefieldScore(i)
		if name == E.myname then
			--local val, title

			--if healingDone > damageDone then
			--	val = healingDone
			--	title = _G.SHOW_COMBAT_HEALING
			--else
			--	val = damageDone
			--	title = _G.DAMAGE
			--end

			local lbg = SY.SynesRightBGDataText
			local rbg = SY.SynesRightBGDataText
			lbg[1]:SetFormattedText("%s: %s", _G.HONOR, SY:ColorStr(honorGained, r, g, b)) -- Honor
			lbg[2]:SetFormattedText("%s: %s", _G.DAMAGE, SY:ColorStr(E:ShortValue(damageDone), r, g, b)) -- Damage
			lbg[3]:SetFormattedText("%s: %s", _G.KILLING_BLOWS, SY:ColorStr(killingBlows, r, g, b)) -- Killing Blows
			rbg[1]:SetFormattedText("%s: %s", _G.KILLS, SY:ColorStr(honorableKills, r, g, b)) -- Kills
			rbg[2]:SetFormattedText("%s: %s", _G.DEATHS, SY:ColorStr(deaths, r, g, b)) -- Deaths
			rbg[3]:SetFormattedText("%s: %s", _G.SHOW_COMBAT_HEALING, SY:ColorStr(E:ShortValue(healingDone), r, g, b)) -- Healing

			break
		end
	end
end

-- Test BG Datatexts
local simulatePVP = false
local function DTBG()
	simulatePVP = not simulatePVP
	SY:ToggleDataPanels(simulatePVP)

	local r, g, b = E.db.general.valuecolor.r or 254/255, E.db.general.valuecolor.g or 123/255, E.db.general.valuecolor.b or 44/255
	local lbg = SY.SynesLeftBGDataText
	local rbg = SY.SynesRightBGDataText

	local honorGained = random(0, 1000)
	local damageDone = random(0, 2000000)
	local killingBlows = random(0, 10)
	local honorableKills = random(0, 10)
	local deaths = random(0, 10)
	local healingDone = random(0, 2000000)
	lbg[1]:SetFormattedText("%s: %s", _G.HONOR, SY:ColorStr(honorGained, r, g, b)) -- Honor
	lbg[2]:SetFormattedText("%s: %s", _G.DAMAGE, SY:ColorStr(E:ShortValue(damageDone), r, g, b)) -- Damage
	lbg[3]:SetFormattedText("%s: %s", _G.KILLING_BLOWS, SY:ColorStr(killingBlows, r, g, b)) -- Killing Blows
	rbg[1]:SetFormattedText("%s: %s", _G.KILLS, SY:ColorStr(honorableKills, r, g, b)) -- Kills
	rbg[2]:SetFormattedText("%s: %s", _G.DEATHS, SY:ColorStr(deaths, r, g, b)) -- Deaths
	rbg[3]:SetFormattedText("%s: %s", _G.SHOW_COMBAT_HEALING, SY:ColorStr(E:ShortValue(healingDone), r, g, b)) -- Healing
end
SLASH_DTBG1 = "/dtbg"
SlashCmdList["DTBG"] = DTBG
]]


--Datatext Options
local function DatatextOptions()
	E.Options.args.SY.args.datatexts = {
		order = 400,
		type = "group",
		name = L["Datatexts"],
		args = {
			datatextsHeader = {
				order = 10,
				type = "header",
				name = SY:ColorStr(L["Datatexts"]),
			},
			notify = {
				order = 20,
				type = "description",
				name = format(L["Use the ElvUI's own %s -> %s to config DataTexts!"], SY:ColorStr(L["DataTexts"]), SY:ColorStr(L["Panels"])),
			},
		},
	}
--[[
			panels = {
				order = 20,
				type = "group",
				name = L["Bottom Gradient Datatexts"],
				guiInline = true,
				args = {},
			},
		},
	}
	local datatexts = {}
	for name, _ in pairs(DT.RegisteredDataTexts) do
		datatexts[name] = name
	end
	datatexts[""] = NONE
]]	
	
--[[
	local table = E.Options.args.SY.args.config.args.datatexts.args.panels.args
	local i = 0
	for pointLoc, tab in pairs(P.SY.datatexts.panels) do
		i = i + 1
		if not _G[pointLoc] then table[pointLoc] = nil; return; end
		if type(tab) == "table" then
			table[pointLoc] = {
				type = "group",
				args = {},
				name = L[pointLoc] or pointLoc,
				guiInline = true,
				order = i,
			}			
			for option, value in pairs(tab) do
				table[pointLoc].args[option] = {
					type = "select",
					name = L[option] or option:upper(),
					values = datatexts,
					get = function(info) return E.db.SY.datatexts.panels[pointLoc][ info[#info] ] end,
					set = function(info, value) E.db.SY.datatexts.panels[pointLoc][ info[#info] ] = value; DT:LoadDataTexts() end,									
				}
			end
		elseif type(tab) == "string" then
			table[pointLoc] = {
				type = "select",
				name = L[pointLoc] or pointLoc,
				values = datatexts,
				get = function(info) return E.db.SY.datatexts.panels[pointLoc] end,
				set = function(info, value) E.db.SY.datatexts.panels[pointLoc] = value; DT:LoadDataTexts() end,
			}						
		end
	end
]]
--[[
	local table = E.Options.args.SY.args.datatexts.args
	local i = 2
	for pointLoc, tab in pairs(P.SY.datatexts.panels) do
		i = i + 1
		if not _G[pointLoc] then table[pointLoc] = nil; return; end
		if type(tab) == "table" then
			table[pointLoc] = {
				type = "group",
				args = {},
				name = L[pointLoc] or pointLoc,
				guiInline = true,
				order = 20 + i * 10,
			}			
			for option, value in pairs(tab) do
				table[pointLoc].args[option] = {
					type = "select",
					name = L[option] or option:upper(),
					values = datatexts,
					get = function(info) return E.db.SY.datatexts.panels[pointLoc][ info[#info] ] end,
					set = function(info, value) E.db.SY.datatexts.panels[pointLoc][ info[#info] ] = value; DT:LoadDataTexts() end,									
				}
			end
		elseif type(tab) == "string" then
			table.panels.args[pointLoc] = {
				type = "select",
				name = L[pointLoc] or pointLoc,
				values = datatexts,
				get = function(info) return E.db.SY.datatexts.panels[pointLoc] end,
				set = function(info, value) E.db.SY.datatexts.panels[pointLoc] = value; DT:LoadDataTexts() end,
			}						
		end
	end
]]
end
SY.configs["datatexts"] = DatatextOptions