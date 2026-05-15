local eMod = require(script.Parent.ClientEventsModule)

-- runs when player gets three pins wrong
eMod.ConnectDelusionalScene(function()
	eMod.FireTeleportToDelusion()
end)

return {}
