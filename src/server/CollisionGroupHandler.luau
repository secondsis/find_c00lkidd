local module = {}
local PhysicsService = game:GetService("PhysicsService")

PhysicsService:RegisterCollisionGroup("Arena")
PhysicsService:RegisterCollisionGroup("Player")
PhysicsService:RegisterCollisionGroup("PlayerBox")
PhysicsService:RegisterCollisionGroup("PlayerTorso")
PhysicsService:RegisterCollisionGroup("DashingPlayer")
PhysicsService:RegisterCollisionGroup("Dashable")

PhysicsService:CollisionGroupSetCollidable("DashingPlayer", "Dashable", false)

for _, group in PhysicsService:GetRegisteredCollisionGroups() do
	PhysicsService:CollisionGroupSetCollidable("PlayerTorso", group.name, false)
	if group.name ~= "Player" and group.name ~= "PlayerBox" then
		PhysicsService:CollisionGroupSetCollidable("PlayerBox", group.name, false)
	end
end

game:GetService("Players").PlayerAdded:Connect(function(player)
	player.CharacterAppearanceLoaded:Connect(function(char)
		local hrp = char:WaitForChild("HumanoidRootPart", 60)
		if not hrp then
			player:Kick("Slow loading. Show developer this message and any relevant info.")
		end
		hrp.CanCollide = true
		task.wait(2)
		if char then
			for _, part in char:GetDescendants() do
				if part:IsA("BasePart") then
					if part.Name == "Torso" then
						part.CollisionGroup = "PlayerTorso"
						-- this doesnt do anything, but might as well try
						part.CanCollide = false
						continue
					end
					part.CollisionGroup = "Player"
					if part ~= hrp then
						part.CanCollide = false
					end
				end
			end
		end
	end)
end)
return module
