local module = {}

local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")

local eventsModule = require(replicatedStorage.Modules.Client.ClientEventsModule)

local player = game:GetService("Players").LocalPlayer
local cam = workspace.CurrentCamera

local increaseFOVTween = tweenService:Create(cam, TweenInfo.new(0.5), {
	FieldOfView = 120,
})

local resetFOVTween = tweenService:Create(cam, TweenInfo.new(0.5), {
	FieldOfView = 90,
})

local function setRunTrue()
	local char = player.Character
	if not char then
		return
	end

	char:WaitForChild("Animate").SetRunTrue:Invoke()
end

local function setRunFalse()
	local char = player.Character
	if not char then
		return
	end

	char:WaitForChild("Animate").SetRunFalse:Invoke()
end

local runCxn = nil

local function startRunEffects()
	if runCxn then
		return
	end

	local char = player.Character
	while not char do
		task.wait()
		char = player.Character
	end
	local humanoid = char:WaitForChild("Humanoid")

	setRunTrue()

	-- Keep checking if the player is actually moving
	runCxn = runService.RenderStepped:Connect(function(delta)
		if not player:GetAttribute("canSprint") or not (humanoid.MoveDirection.Magnitude > 0) then
			resetFOVTween:Play()
		else
			increaseFOVTween:Play()
		end
	end)
end

local function stopRunEffects()
	resetFOVTween:Play()
	setRunFalse()
	if runCxn then
		runCxn:Disconnect()
		runCxn = nil
	end
end

local function attemptSprinting(isSprinting: boolean)
	if not player:GetAttribute("canSprint") then
		player:SetAttribute("isSprinting", false)
		local humanoid: Humanoid = player.Character:FindFirstChild("Humanoid")
		humanoid.WalkSpeed = 20
		stopRunEffects()
		return
	end

	local humanoid: Humanoid = player.Character:FindFirstChild("Humanoid")

	player:SetAttribute("isSprinting", isSprinting)
	if isSprinting then
		humanoid.WalkSpeed = 40
		startRunEffects()
		return true
	else
		humanoid.WalkSpeed = 20
		stopRunEffects()
	end
end

userInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then
		return
	end

	if input.KeyCode == Enum.KeyCode.LeftShift then
		attemptSprinting(true)
	end
end)

userInputService.InputEnded:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then
		return
	end

	if input.KeyCode == Enum.KeyCode.LeftShift then
		attemptSprinting(false)
	end
end)

local sprintButton: ImageButton = player
	:WaitForChild("PlayerGui")
	:WaitForChild("MobileButtonsGui")
	:WaitForChild("MobileButtons")
	:WaitForChild("SprintButton")

sprintButton.Activated:Connect(function()
	local activated = sprintButton:GetAttribute("activated")
	sprintButton:SetAttribute("activated", not activated)
	if activated then
		attemptSprinting(false)
		sprintButton.Image = sprintButton:GetAttribute("image")
	else
		local sprintSuccess = attemptSprinting(true)
		if sprintSuccess then
			sprintButton.Image = sprintButton:GetAttribute("toggledImage")
		else
			sprintButton.Image = sprintButton:GetAttribute("image")
		end
	end
end)

eventsModule.ConnectSetCanSprintEvent(function(canSprint: boolean)
	player:SetAttribute("canSprint", canSprint)
	if not canSprint then
		player:SetAttribute("isSprinting", false)
		attemptSprinting(false)
		local humanoid: Humanoid = player.Character:FindFirstChild("Humanoid")
		humanoid.WalkSpeed = 20
	end
end)

return module
