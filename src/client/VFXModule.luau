local module = {}

local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local replicatedStorage = game:GetService("ReplicatedStorage")

if runService:IsServer() then
	warn("VFXModule can only be ran on the client!")
end

local player = game:GetService("Players").LocalPlayer
local cam = workspace.CurrentCamera
local runAnim = replicatedStorage.Animations.player_running

local increaseFOVTween = tweenService:Create(cam, TweenInfo.new(0.5), {
	FieldOfView = 100,
})

local resetFOVTween = tweenService:Create(cam, TweenInfo.new(0.5), {
	FieldOfView = 70,
})

local function setRunTrue()
	local char = player.Character
	if not char then
		return
	end

	char:WaitForChild("AnimateV4").SetRunTrue:Invoke()
end

local function setRunFalse()
	local char = player.Character
	if not char then
		return
	end

	char:WaitForChild("AnimateV4").SetRunFalse:Invoke()
end

local loadedAnim
local runCxn

function module.startFOVRun()
	if runCxn then
		return
	end

	local humanoid = nil
	while humanoid == nil do
		task.wait(0.5)
		local char = player.Character
		if not char then
			continue
		end
		humanoid = char:FindFirstChild("Humanoid")
	end

	player.AttributeChanged:Connect(function(attribute: string)
		if attribute ~= "isSprinting" then
			return
		end

		local isSprinting = player:GetAttribute("isSprinting")
		if not isSprinting then
			resetFOVTween:Play()
			setRunFalse()
			if runCxn then
				runCxn:Disconnect()
				runCxn = nil
			end
			return
		end

		setRunTrue()

		-- isSprinting was JUST set to true.
		if not runCxn then
			runCxn = runService.RenderStepped:Connect(function(delta)
				if not player:GetAttribute("canSprint") or not (humanoid.MoveDirection.Magnitude > 0) then
					resetFOVTween:Play()
				else
					increaseFOVTween:Play()
				end
			end)
		end
	end)
end

function module.stopFOVRun()
	if not runCxn then
		return
	end
	runCxn:Disconnect()
	runCxn = nil
end

return module
