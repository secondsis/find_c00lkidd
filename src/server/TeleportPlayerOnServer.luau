local References = require(script.Parent.References)

local events = References.ServerEventsModule

local locations = {}

local tpParts = {
	["Intro"] = References.TeleportPartIntro,
	["PizzaPlace"] = References.TeleportPartPizzaPlace,
	["c00lHouse"] = References.TeleportPartc00lHouse,
	["HouseMission"] = References.TeleportPartHouseMission,
}

for key, val in tpParts do
	locations[key] = val.CFrame
end

-- Client tells the server to teleport the player but only in certain locations
events.ConnectRemoteTeleportPlayerOnServer(function(player: Player, location: string)
	-- Make sure the character is loaded
	local char = player.Character
	if not char then
		warn("Could not tp player because null character!")
		return
	end

	-- Make sure the Humanoid is loaded
	local hum = char:FindFirstChild("Humanoid")
	if not hum then
		warn("Could not tp player because null humanoid!")
		return
	end

	-- Reset the velocity so the player teleports smoothly
	local characterDescendants = char:GetDescendants()
	for _, v in characterDescendants do
		if not v:IsA("BasePart") then
			continue
		end

		v.AssemblyLinearVelocity = Vector3.new()
		v.AssemblyAngularVelocity = Vector3.new()
	end

	-- Move player
	char:PivotTo(locations[location])
end)

return {}
