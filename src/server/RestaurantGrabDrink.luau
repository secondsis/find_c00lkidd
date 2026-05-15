local References = require(script.Parent.References)
local events = References.ServerEventsModule

local prompt = References.GrabDrinkPrompt
local pickedUp = false

prompt.Triggered:Connect(function(player)
	-- Upon drinking the bottle, you explode or something
	-- use forsaken animations or something
	local succ = events.FireAddItem(player, "Drink")
	if succ and not pickedUp then
		pickedUp = true
		prompt.Parent.Parent:Destroy()
	end
end)
