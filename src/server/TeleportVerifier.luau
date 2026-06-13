local module = {}

local eventsModule = require(game:GetService("ReplicatedStorage").ServerEventsModule)
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local isStudio = game:GetService("RunService"):IsStudio()

eventsModule.ConnectVerifyTeleport(function(player: Player, tpData: { any })
	if not isStudio then
		if not tpData then
			player:Kick("Teleported to place without verification.")
		end

		local pass = tpData["Password"]
		if not pass then
			player:Kick("Teleported to place without verification.")
		end

		if pass == "Brombus_" .. tostring(player.UserId % 236 * 100) then
			-- Verified
		end
	else
		local verifiedValue = Instance.new("BoolValue")
		verifiedValue.Name = "Verified_" .. tostring(player.UserId)
	end
end)

Players.PlayerRemoving:Connect(function(player)
	-- Remove value
	local verifiedValue = ServerStorage:FindFirstChild("Verified_" .. tostring(player.UserId))

	if verifiedValue then
		verifiedValue:Destroy()
	end
end)

return module
