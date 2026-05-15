local ReplicatedStorage = game:GetService("ReplicatedStorage")

local References = require(script.Parent.References)

local eventsModule = References.ServerEventsModule

local sprintEvent = ReplicatedStorage.RemoteEvents.Controls.SprintEvent

sprintEvent.OnServerEvent:Connect(function(player, enabling: boolean)
	local humanoid: Humanoid = player.Character:FindFirstChild("Humanoid")
	-- Check if the player has sprinting disabled
	if not player:GetAttribute("canSprint") then
		-- Turn off sprinting
		player:SetAttribute("isSprinting", false)
		humanoid.WalkSpeed = References.PlayerWalkSpeed
		return
	end

	-- Set whether player is sprinting, and change the WalkSpeed accordingly
	player:SetAttribute("isSprinting", enabling)
	if enabling then
		humanoid.WalkSpeed = References.PlayerRunSpeed
	else
		humanoid.WalkSpeed = References.PlayerWalkSpeed
	end
end)

eventsModule.ConnectSetCanSprintEvent(function(player: Player, canSprint: boolean)
	player:SetAttribute("canSprint", canSprint)
	if canSprint then
		return
	end

	-- If setting Sprinting to false

	player:SetAttribute("isSprinting", false)
	local humanoid = References.GetHumanoid(player)
	if humanoid then
		humanoid.WalkSpeed = References.PlayerWalkSpeed
	end
end)
