--[[ Postal_Wire: Update Subject Field with Money Amount if blank ]]--

assert( Postal, "Postal not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("Postal")

----------------------------------
--      Module Declaration      --
----------------------------------

Postal_Wire = Postal:NewModule("Wire")
Postal_Wire.revision = tonumber(string.sub("$Revision$", 12, -3))

function Postal_Wire:OnEnable()
	self:SecureHook(SendMailMoney, "onValueChangedFunc")
end

function Postal_Wire:OnDisable()
	-- Disabling modules unregisters all events/hook automatically
end

local g, s, c
g = "^%["..GOLD_AMOUNT.." "..SILVER_AMOUNT.." "..COPPER_AMOUNT.."%]$"
s = "^%["..SILVER_AMOUNT.." "..COPPER_AMOUNT.."%]$"
c = "^%["..COPPER_AMOUNT.."%]$"
g = gsub(g, "%%d", "%%d+")
s = gsub(s, "%%d", "%%d+")
c = gsub(c, "%%d", "%%d+")
function Postal_Wire:onValueChangedFunc()
	local subject = SendMailSubjectEditBox:GetText()
	if subject == ""
	or subject:find(g)
	or subject:find(s)
	or subject:find(c)
	then
		local copper = MoneyInputFrame_GetCopper(SendMailMoney)
		if copper and copper > 0 then
			SendMailSubjectEditBox:SetText("["..self.core:GetMoneyString(copper).."]")
		else
			SendMailSubjectEditBox:SetText("")
		end
	end
end
