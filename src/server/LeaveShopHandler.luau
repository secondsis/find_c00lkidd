local Players = game:GetService("Players")

local References = require(script.Parent.References)
local eventsModule = References.ServerEventsModule
local played = false

References.StoreTriggerPart.Touched:Connect(function(other)
	if played then
		return
	end
	local player = Players:GetPlayerFromCharacter(other.Parent)
	if not player then
		return
	end

	local item = eventsModule.FireGetItem(player)
	if not item then
		return
	end

	local itemName = item.Name

	if itemName == "Slimeball" then
		played = true
		player:SetAttribute("Ending", "Frogs.")
		eventsModule.FireFrogEnding(player)
	elseif itemName == "TurkeyLeg" then
		played = true
		player:SetAttribute("Ending", "Shedletsky")
		eventsModule.FireShedletskyEnding(player)
	end
end)
