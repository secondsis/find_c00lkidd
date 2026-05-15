local References = require(script.Parent.References)
local prompt = References.BloxyColaAddict:WaitForChild("HumanoidRootPart").ProximityPrompt
local eventsModule = References.ServerEventsModule

prompt.Triggered:Connect(function(player)
	local currentItem = eventsModule.FireGetItem(player)
	if not currentItem then
		return
	end
	local itemName = currentItem.Name
	if itemName == "ColaPack" then
		player:SetAttribute("Ending", "Cola Addiction")
	end
end)

return {}
