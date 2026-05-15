local ReplicatedStorage = game:GetService("ReplicatedStorage")
local events = require(script.Parent.ClientEventsModule)
local soundService = game:GetService("SoundService")

local engineStartSfx = soundService.SFX["car engine start"]
local carEnterSfx = soundService.SFX["car door opening"]
local carMoveSfx = soundService.SFX["Truck Acceleration"]
local carCrashSfx = soundService.SFX["car crash wario"]
local player = game:GetService("Players").LocalPlayer

local function playJeepScene()
	local carAnim = Instance.new("Animation")
	carAnim.AnimationId = "rbxassetid://109231063595633"

	events.FireDisableMovementEvent(false)
	events.FireSmoothTransitionFunction(2)
	events.FireTurnOffMusic()

	events.FireCloneAssetSecurityNone("Objects.Jeep_Animatable")
	local jeepAsset = ReplicatedStorage.ClonedFolder:WaitForChild("Jeep_Animatable")
	local jeep = jeepAsset:Clone()
	jeepAsset:Destroy()

	local animator = jeep:WaitForChild("AnimationController"):WaitForChild("Animator")
	jeep.Parent = workspace

	local weld = Instance.new("Weld")
	weld.C0 = CFrame.new(0, 2, 0)
	weld.Part0 = jeep.VehicleSeat
	weld.Part1 = player.Character:FindFirstChild("HumanoidRootPart")
	weld.Parent = jeep.VehicleSeat

	local hum: Humanoid = player.Character:FindFirstChild("Humanoid")
	hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
	hum.Sit = true

	carEnterSfx:Play()
	task.wait(1)
	engineStartSfx:Play()
	task.wait(1)

	local carAnimTrack = animator:LoadAnimation(carAnim)

	task.wait(1)
	carAnimTrack:Play()
	carMoveSfx:Play()
	carAnimTrack:GetMarkerReachedSignal("end"):Wait()
	task.wait(1)
	events.FireEndingEvent("Ending: Escaped", "I feel like you missed the point...")
	carMoveSfx:Stop()
	carCrashSfx:Play()
end

events.ConnectJeepScene(playJeepScene)

return {}
