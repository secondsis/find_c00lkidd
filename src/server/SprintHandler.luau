local ReplicatedStorage = game:GetService("ReplicatedStorage")

local References = require(script.Parent.References)

local eventsModule = References.ServerEventsModule

local sprintEvent = ReplicatedStorage.RemoteEvents.Controls.SprintEvent

sprintEvent.OnServerEvent:Connect(function(player, enabling: boolean)
	if not player:GetAttribute("canSprint") then
		player:SetAttribute("isSprinting", false)
		local humanoid: Humanoid = player.Character:FindFirstChild("Humanoid")
		humanoid.WalkSpeed = 20
		return
	end

	local humanoid: Humanoid = player.Character:FindFirstChild("Humanoid")

	player:SetAttribute("isSprinting", enabling)
	if enabling then
		humanoid.WalkSpeed = 40
	else
		humanoid.WalkSpeed = 20
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
		humanoid.WalkSpeed = 20
	end
end)
