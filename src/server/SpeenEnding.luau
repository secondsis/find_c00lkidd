local References = require(script.Parent.References)
local prompt = References.CaveSpeenKidPrompt
local eventsModule = References.ServerEventsModule

prompt.Triggered:Connect(function(player)
	-- Initiate fake c00lkidd cutscene
	prompt.Enabled = false
	player:SetAttribute("Ending", "SPEEN")
	eventsModule.FireFakeKidEvent(player)
end)

return {}
