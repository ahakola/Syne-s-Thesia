--[[------------------------------------------------------------------
--	Syne's Thesia, an ElvUI edit by ahak @ tukui.org
--
--	This file contains changes/additions to the ElvUI skinning code
------------------------------------------------------------------]]--
local E, L, V, P, G, _ = unpack(ElvUI) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local S = E:GetModule("Skins")
local SY = E:GetModule("SynesThesia")
local LSM = LibStub("LibSharedMedia-3.0")

local MirrorFont = LSM:Fetch("font", SY.media.uffont)

-- Go with Event-handler since I couldn't find anything nice for hooking...
local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", function(self, event, ...)
	return self[event] and self[event](self, event, ...)
end)

-- Style Mirror Timers in Syne's Edit style
local fixCount = 0
--function frame:PLAYER_ENTERING_WORLD(event, isInitialLogin, isReloadingUi)
function frame:MIRROR_TIMER_START(event, timerName, value, maxValue, scale, paused, timerLabel)
	--SY:Print("UpdateMirrorStyle", MIRRORTIMER_NUMTIMERS) -- Debug

	for i = 1, _G.MIRRORTIMER_NUMTIMERS do
		local mirrorTimer = _G["MirrorTimer"..i]
		if mirrorTimer.TimerText then
			SY:FixFontString(mirrorTimer.TimerText, MirrorFont, 14, "THINOUTLINE")

			fixCount = fixCount + 1
		end
	end

	if fixCount == _G.MIRRORTIMER_NUMTIMERS then
		--SY:Print("Unhooking!", event) -- Debug
		self:UnregisterEvent(event)
	end
end
--frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("MIRROR_TIMER_START")