local module = {}

local replicatedStorage = game:GetService("ReplicatedStorage")

local eventsModule = require(replicatedStorage.Modules.Client.ClientEventsModule)

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

eventsModule.ConnectDisableMovementEvent(movementChanger)
eventsModule.ConnectRemoteDisableMovementEvent(movementChanger)

return module
