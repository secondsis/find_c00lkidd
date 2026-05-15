local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")

PhysicsService:RegisterCollisionGroup("Player")
PhysicsService:RegisterCollisionGroup("PlayerTorso")
PhysicsService:RegisterCollisionGroup("PlayerDetectors")
PhysicsService:CollisionGroupSetCollidable("PlayerDetectors", "Default", false)
PhysicsService:CollisionGroupSetCollidable("PlayerDetectors", "PlayerDetectors", false)

for _, cgroup in PhysicsService:GetRegisteredCollisionGroups() do
	PhysicsService:CollisionGroupSetCollidable("PlayerTorso", cgroup.name, false)
end

--players.PlayerAdded:Connect(function(player: Player)
--	player.CharacterAdded:Connect(function(char: Model)
--		for _, part in char:GetDescendants() do
--			if part:IsA("BasePart") then
--				part.CollisionGroup = "Player"
--			end
--		end
--	end)
--end)
