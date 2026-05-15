local eventsModule = require(script.Parent.ClientEventsModule)

eventsModule.ConnectRemoteDeleteOnClient(function(obj: Instance)
	if obj then
		obj:Destroy()
	end
end)

return {}
