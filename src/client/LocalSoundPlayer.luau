local eventsModule = require(script.Parent.ClientEventsModule)

eventsModule.ConnectRemotePlaySound(function(sound: Sound)
	sound:Play()
end)

return {}
