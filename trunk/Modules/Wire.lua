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
if GetLocale() == "ruRU" then
	--Because ruRU is silly and has these constants.
	--COPPER_AMOUNT = "%d |4медная монета:медные монеты:медных монет;"; -- Lowest value coin denomination
	--SILVER_AMOUNT = "%d |4серебряная:серебряные:серебряных;"; -- Mid value coin denomination
	--GOLD_AMOUNT = "%d |4золотая:золотые:золотых;"; -- Highest value coin denomination
	g = "^%[%d+з %d+с %d+м%]$"
	s = "^%[%d+с %d+м%]$"
	c = "^%[%d+м%]$"
end
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
			if GetLocale() == "ruRU" then
				self:ruRUonValueChangedFunc(copper)
			else
				SendMailSubjectEditBox:SetText("["..self.core:GetMoneyString(copper).."]")
			end
		else
			SendMailSubjectEditBox:SetText("")
		end
	end
end

if GetLocale == "ruRU" then
	function Postal_Wire:ruRUonValueChangedFunc(money)
		local gold = floor(money / 10000)
		local silver = floor((money - gold * 10000) / 100)
		local copper = mod(money, 100)
		if gold > 0 then
			SendMailSubjectEditBox:SetText(format("[%d+з %d+с %d+м]", gold, silver, copper))
		elseif silver > 0 then
			SendMailSubjectEditBox:SetText(format("[%d+с %d+м]", silver, copper))
		else
			SendMailSubjectEditBox:SetText(format("[%d+м]", copper))
		end
	end
end
