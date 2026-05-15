local replicatedStorage = game:GetService("ReplicatedStorage")

local disableMovementEvent = replicatedStorage.RemoteEvents.Controls.DisableMovementEvent
local remoteDisableMovementEvent = replicatedStorage.RemoteEvents.Controls.RemoteDisableMovementEvent

local player = game:GetService("Players").LocalPlayer

local function movementChanger(canMove: boolean)
	local playerModule = player:WaitForChild("PlayerScripts").PlayerModule
	local controls = require(playerModule):GetControls()
	if canMove then
		controls:Enable()
	else
		controls:Disable()
	end
end

disableMovementEvent.Event:Connect(movementChanger)
remoteDisableMovementEvent.OnClientEvent:Connect(movementChanger)
