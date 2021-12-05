--[[----------------------------------------------------------
--	Syne's Thesia, an ElvUI edit by ahak @ tukui.org
--
--	This file contains changes/additions to the ElvUI Bags
----------------------------------------------------------]]--
local E, L, V, P, G, _ = unpack(ElvUI) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local B = E:GetModule("Bags")
local SY = E:GetModule("SynesThesia")

-- Didn't use this feature of Syne's Edit back in the days, so I don't have any memories and I'm going on with what I can get from the original source.

local function UpdateBagAndBankPos(self)
	--SY:Print("UpdateBagAndBankPos", self:GetName()) -- Debug

	self.BagFrame:ClearAllPoints() -- ElvUI_ContainerFrame
	self.BagFrame:SetPoint("BOTTOMRIGHT", BottomLine1, "TOPRIGHT", E:Scale(-13), E:Scale(7))
	self.BankFrame:ClearAllPoints() -- ElvUI_BankContainerFrame
	self.BankFrame:SetPoint("BOTTOMLEFT", BottomLine1, "TOPLEFT", E:Scale(13), E:Scale(7))
end

hooksecurefunc(B, "OpenBags", UpdateBagAndBankPos)
hooksecurefunc(B, "OpenBank", UpdateBagAndBankPos)


-- Straight copy from CodeNameBlaze
function ModifyContainerFrame(self, name, isBank)
	local f = _G[name]

	if isBank then
		--Add stack button back to bank
		f.stackButton = CreateFrame("Button", name .. "stackButton", f, BackdropTemplateMixin and "BackdropTemplate");
		f.stackButton:SetSize(16 + E.Border, 16 + E.Border)
		f.stackButton:SetTemplate()
		f.stackButton:SetPoint("RIGHT", f.bagText, "LEFT", -5, E.Border * 2)
		f.stackButton:SetNormalTexture("Interface\\ICONS\\misc_arrowlup")
		f.stackButton:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
		f.stackButton:GetNormalTexture():SetInside()
		f.stackButton:SetPushedTexture("Interface\\ICONS\\misc_arrowlup")
		f.stackButton:GetPushedTexture():SetTexCoord(unpack(E.TexCoords))
		f.stackButton:GetPushedTexture():SetInside()		
		f.stackButton:StyleButton(nil, true)
		f.stackButton.ttText = L["Stack items in bank"]
		f.stackButton.ttText2 = L["Hold Shift:"]
		f.stackButton.ttText2desc = L["Stack items to bags"]
		f.stackButton:SetScript("OnEnter", self.Tooltip_Show)
		f.stackButton:SetScript("OnLeave", self.Tooltip_Hide)
		f.stackButton:SetScript("OnClick", function() 
			if IsShiftKeyDown() then
				B:CommandDecorator(B.Stack, "bank bags")();
			else
				B:CommandDecorator(B.Compress, "bank")();
			end
		end)

		--Reposition the other buttons
		f.reagentToggle:SetPoint("RIGHT", f.stackButton, "LEFT", -5, 0)
	else
		--Add stack button back to bags
		f.stackButton = CreateFrame("Button", name .. "stackButton", f, BackdropTemplateMixin and "BackdropTemplate");
		f.stackButton:SetSize(16 + E.Border, 16 + E.Border)
		f.stackButton:SetTemplate()
		f.stackButton:SetPoint("RIGHT", f.goldText, "LEFT", -5, E.Border * 2)
		f.stackButton:SetNormalTexture("Interface\\ICONS\\misc_arrowlup")
		f.stackButton:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
		f.stackButton:GetNormalTexture():SetInside()
		f.stackButton:SetPushedTexture("Interface\\ICONS\\misc_arrowlup")
		f.stackButton:GetPushedTexture():SetTexCoord(unpack(E.TexCoords))
		f.stackButton:GetPushedTexture():SetInside()		
		f.stackButton:StyleButton(nil, true)
		f.stackButton.ttText = L["Stack items in bags"]
		f.stackButton.ttText2 = L["Hold Shift:"]
		f.stackButton.ttText2desc = L["Stack items to bank"]
		f.stackButton:SetScript("OnEnter", self.Tooltip_Show)
		f.stackButton:SetScript("OnLeave", self.Tooltip_Hide)
		f.stackButton:SetScript("OnClick", function() 
			if IsShiftKeyDown() then
				B:CommandDecorator(B.Stack, "bags bank")();
			else
				B:CommandDecorator(B.Compress, "bags")();
			end
		end)

		--Reposition the other buttons
		f.sortButton:SetPoint("RIGHT", f.stackButton, "LEFT", -5, 0)
	end
end
--hooksecurefunc(B, "ConstructContainerFrame", ModifyContainerFrame) -- ElvUI added this (back) at some point in 9.1.5?