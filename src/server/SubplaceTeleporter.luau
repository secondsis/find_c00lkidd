local tpService = game:GetService("TeleportService")

local References = require(script.Parent.References)
local eventsModule = References.ServerEventsModule

local playersInTeleport = {}

local players = game:GetService("Players")

local isInStudio = game["Run Service"]:IsStudio()

-- Please verify on the other server script that this teleport is warranted
if isInStudio then
	eventsModule.ConnectTeleportToPlace(function()
		warn("Studio cannot teleport")
	end)
else
	eventsModule.ConnectTeleportToPlace(
		function(player: Player, placeId: number, metadata: { [string]: any }, loadingScreen: Instance?)
			if playersInTeleport["Player_" .. player.UserId] then
				warn("Please do not spam tp events!")
				return
			end
			playersInTeleport["Player_" .. player.UserId] = true
			repeat
				tpService:Teleport(placeId, player, metadata, loadingScreen)
				task.wait(0.5)
			until players[player] == nil
			playersInTeleport["Player_" .. player.UserId] = false
		end
	)
end

return {}
