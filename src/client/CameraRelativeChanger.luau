local module = {}
local eventsModule = require(game:GetService("ReplicatedStorage").Modules.Client.ClientEventsModule)
local controllerModule = require(script.Parent.Parent.PlayerModule.ControlModule.BaseCharacterController)

eventsModule.ConnectSetIsCameraRelative(function(newValue: boolean)
	controllerModule:SetCameraRelative(newValue)
end)
return module
