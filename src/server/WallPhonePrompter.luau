local ReplicatedStorage = game:GetService("ReplicatedStorage")
local References = require(script.Parent.References)

local pickUpEvent = ReplicatedStorage.RemoteEvents.Cutscenes.Intro.PickUpPhoneEvent

local prompt = References.WallPhonePrompt

prompt.Triggered:Connect(function(player)
	prompt.Enabled = false
	prompt.MaxActivationDistance = 0
	pickUpEvent:FireClient(player)
end)
