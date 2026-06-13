local module = {}

local eventsModule = require(game:GetService("ReplicatedStorage").Modules.Client.ClientEventsModule)

eventsModule.ConnectRemotePlaySound(function(sound: Sound)
	sound:Play()
end)

return module
