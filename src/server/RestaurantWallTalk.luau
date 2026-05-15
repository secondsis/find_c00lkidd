local References = require(script.Parent.References)

local eventsModule = References.ServerEventsModule

local prompt = References.RestaurantWallPrompt

prompt.Triggered:Connect(function(player)
	eventsModule.FireRemoteDialogueFunction(player, "RestaurantWallTalk")
end)
