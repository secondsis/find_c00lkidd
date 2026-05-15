local userInputService = game:GetService("UserInputService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local sprintEvent = replicatedStorage.RemoteEvents.Controls.SprintEvent

local vfxModule = nil
task.spawn(function()
	vfxModule = require(script.Parent.VFXModule)
	vfxModule.startFOVRun()
end)

local player = game:GetService("Players").LocalPlayer

userInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then
		return
	end

	if input.KeyCode == Enum.KeyCode.LeftShift then
		sprintEvent:FireServer(true)
	end
end)

userInputService.InputEnded:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then
		return
	end

	if input.KeyCode == Enum.KeyCode.LeftShift then
		sprintEvent:FireServer(false)
	end
end)

local sprintButton: ImageButton = player
	:WaitForChild("PlayerGui")
	:WaitForChild("MainGameGui")
	:WaitForChild("MobileButtons")
	:WaitForChild("SprintButton")

sprintButton.Activated:Connect(function()
	local activated = sprintButton:GetAttribute("activated")
	sprintButton:SetAttribute("activated", not activated)
	if activated then
		sprintEvent:FireServer(false)
		sprintButton.Image = sprintButton:GetAttribute("image")
	else
		sprintEvent:FireServer(true)
		sprintButton.Image = sprintButton:GetAttribute("toggledImage")
	end
end)
