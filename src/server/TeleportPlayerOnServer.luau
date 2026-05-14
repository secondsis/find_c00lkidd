local References = require(script.Parent.References)

local events = References.ServerEventsModule

local locations = {}

local tpParts = { References.TeleportPartIntro, References.TeleportPartPizzaPlace, References.TeleportPartc00lHouse }

for _, part in tpParts do
	locations[part.Name] = part.Value.CFrame
end

events.ConnectRemoteTeleportPlayerOnServer(function(player: Player, location: string)
	local char = player.Character
	if not char then
		warn("Could not tp player because null character!")
		return
	end

	local hum = char:FindFirstChild("Humanoid")
	if not hum then
		warn("Could not tp player because null humanoid!")
		return
	end

	local characterDescendants = char:GetDescendants()
	for i, v in characterDescendants do
		if not v:IsA("BasePart") then
			continue
		end

		v.AssemblyLinearVelocity = Vector3.new()
		v.AssemblyAngularVelocity = Vector3.new()
	end

	char:PivotTo(locations[location])
end)
