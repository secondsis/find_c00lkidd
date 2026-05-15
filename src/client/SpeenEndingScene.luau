local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local cutsceneModule = require(script.Parent.CutsceneModule)
local eventsModule = require(script.Parent.ClientEventsModule)
local disableMovementEvent = ReplicatedStorage.RemoteEvents.Controls.DisableMovementEvent

local cameraFolder = workspace:WaitForChild("Cave").Inside.Cameras

local camPart1 = cameraFolder:WaitForChild("camPart1", math.huge)
local camPart2 = cameraFolder:WaitForChild("camPart2")
local camPart3 = cameraFolder:WaitForChild("camPart3")

local rig = cameraFolder.Parent.c00lkidd_Posed
local kidAnimator = rig.Humanoid.Animator
local animation = kidAnimator.Parent.Animation

local animTrack = kidAnimator:LoadAnimation(animation)

local spinSfx = SoundService.SFX.Spin
local speenSfx = SoundService.SFX.SPEEN

eventsModule.ConnectFakeKidEvent(function()
	disableMovementEvent:Fire(false)
	eventsModule.FirePauseCameraEffects()
	eventsModule.FireDisableMouseIcon()
	eventsModule.FireResetMouseIcon(true, false)
	eventsModule.FireSetMainGuiEnabled(false)
	cutsceneModule.tweenCamCFrame(camPart1.CFrame, 2, true)
	eventsModule.FireCloneAssetSecurityNone("Objects.IsThisPoster")
	local posterAsset = ReplicatedStorage.ClonedFolder:WaitForChild("IsThisPoster")
	local newPoster = posterAsset:Clone()
	posterAsset:Destroy()
	newPoster.Parent = workspace

	task.wait(3)
	cutsceneModule.tweenCamCFrame(camPart2.CFrame, 1)
	task.wait(2)
	cutsceneModule.tweenCamCFrame(camPart3.CFrame, 0.5)

	-- kid starts flying up and cam follows
	animTrack:Play()
	task.wait(1)

	cutsceneModule.tweenCamCFrame(
		CFrame.new(camPart3.Position, rig.PrimaryPart.Position + Vector3.new(25, 55, 25)),
		2,
		false,
		Enum.EasingStyle.Exponential
	)

	spinSfx:Play()

	local start = tick()
	while true do
		local delta = game:GetService("RunService").Heartbeat:Wait()
		rig.PrimaryPart.CFrame += Vector3.new(0, 55 / 4 * delta)
		rig.PrimaryPart.CFrame = rig.PrimaryPart.CFrame * CFrame.Angles(0, delta * 360 * 10, 0)
		if start + 4 <= tick() then
			break
		end
	end

	eventsModule.FireEnableMouseIcon()
	eventsModule.FireEndingEvent(
		"Ending: SPEEN",
		"that's just some silly cosplayer, not c00lkidd",
		"http://www.roblox.com/asset/?id=90299905248553"
	)
	task.wait(4)
	speenSfx:Play()
end)

return {}
