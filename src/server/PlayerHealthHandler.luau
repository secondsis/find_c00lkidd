local module = {}
local Players = game:GetService("Players")

local playerHealthMap = {}

Players.PlayerAdded:Connect(function(player)
	playerHealthMap[player] = 100
	player.CharacterAdded:Connect(function(char)
		local hum: Humanoid = char:WaitForChild("Humanoid")
		hum.RequiresNeck = false
		hum.BreakJointsOnDeath = false
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	playerHealthMap[player] = nil
end)
return module
