local module = {}

local eventsModule = require(game:GetService("ReplicatedStorage").ServerEventsModule)
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local isStudio = game:GetService("RunService"):IsStudio()

Players.PlayerAdded:Connect(function(player: Player)
	local function IsPlayerVerified(player: Player)
		return ServerStorage:FindFirstChild("Verified_" .. tostring(player.UserId))
	end

	local joinTick = tick()
	local timeout = 30

	while joinTick + timeout > tick() do
		if IsPlayerVerified(player) then
			print("verified player!")
			return
		end
		task.wait(0.1)
	end
	player:Kick("Teleported to place without verification.")
end)

-- I will actually find a more secure way of verifying teleports eventually... trust
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
			print("Verified Teleport")

			local verifiedValue = Instance.new("BoolValue")
			verifiedValue.Name = "Verified_" .. tostring(player.UserId)
			verifiedValue.Parent = ServerStorage
		else
			player:Kick("Teleported to place without verification.")
		end
	else
		local verifiedValue = Instance.new("BoolValue")
		verifiedValue.Name = "Verified_" .. tostring(player.UserId)
		verifiedValue.Parent = ServerStorage
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
