local module = {}

local replicatedStorage = game:GetService("ReplicatedStorage")
local eventsModule = require(replicatedStorage.Modules.Client.ClientEventsModule)

eventsModule.ConnectRemoteDeleteOnClient(function(obj: Instance)
	if obj then
		obj:Destroy()
	end
end)

return module
