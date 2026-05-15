local Players = game:GetService("Players")

-- Initialize attributes of each player
Players.PlayerAdded:Connect(function(player)
	player:SetAttribute("isSprinting", false)
	player:SetAttribute("canSprint", true)
	player:SetAttribute("MouseUnlocked", true)
end)
