local References = require(script.Parent.References)
local eventsModule = References.ServerEventsModule

References.McDarndoldSpeakerPrompt.Triggered:Connect(function(player)
	player:SetAttribute("Ending", "McDarndold's")
	eventsModule.FireMcDarndold(player)
end)

return {}
