local References = require(script.Parent.References)

local eventsModule = References.ServerEventsModule

local DELUSION_GAME_ID = 81611231604865

eventsModule.ConnectTeleportToDelusion(function(player: Player)
	local password = "Scoobis_" .. tostring(player.UserId / 2)

	eventsModule.FireTeleportToPlace(player, DELUSION_GAME_ID, {
		["Password"] = password,
	})
end)

return {}
