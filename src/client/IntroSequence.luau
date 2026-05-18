local tweenService = game:GetService("TweenService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local soundService = game:GetService("SoundService")

local cutsceneModule = require(script.Parent.CutsceneModule)
local eventsModule = require(script.Parent.ClientEventsModule)

local pickUpEvent = replicatedStorage.RemoteEvents.Cutscenes.Intro.PickUpPhoneEvent

local introFolder = workspace.Cutscenes.Intro
local importantFolder = introFolder.e7Home.Important

local wallPhone = importantFolder:WaitForChild("Wall Phone")

local walkToTrack
local pickUpTrack
local holdTrack

local cameraFolder = importantFolder.Cameras

local cam1 = cameraFolder:WaitForChild("pos1", math.huge)
local cam2 = cameraFolder:WaitForChild("pos2")

-- local cam3 = replicatedStorage.Values.ObjectValues.MissingPosterCam

local sfxGroup = soundService.SFX
local pickUpSfx = sfxGroup.phone_pickup
-- local hangUpSfx = sfxGroup.HangUpPhone
local phoneRingSfx = sfxGroup.phoneRing.Value
local markiplierSfx = sfxGroup.MarkiplierGameplay

-- local originalPhoneCF = wallPhone.Speaker.CFrame

local phoneTween = tweenService:Create(wallPhone.Speaker, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
	CFrame = wallPhone:WaitForChild("SpeakerPos2").CFrame,
})

local isPlayingIntro = false

local playPhoneAnimation
local playConversation
local endScene

local function PlayPart1_WatchingTV()
	isPlayingIntro = true

	eventsModule.FireSmoothTransitionFunction(3)
	eventsModule.FirePrepareCutscene()

	eventsModule.FireRemoteTeleportPlayerOnServer("Intro")

	-- clone 1
	eventsModule.FireCloneAssetSecurityNone("Objects.007e7_Clone1")
	local clone1Asset = replicatedStorage.ClonedFolder:WaitForChild("007e7_Clone1")
	local clone1 = clone1Asset:Clone()
	clone1Asset:Destroy()
	clone1.Parent = introFolder

	local cloneHumanoid1 = clone1:WaitForChild("Humanoid")
	local animator1 = cloneHumanoid1:WaitForChild("Animator")

	local layingTrack = animator1:LoadAnimation(cloneHumanoid1.laying)
	local gettingUpTrack = animator1:LoadAnimation(cloneHumanoid1.getting_up)
	local turningOffTrack = animator1:LoadAnimation(cloneHumanoid1.turning_off)

	layingTrack:Play()

	-- Camera to couch
	markiplierSfx:Play()
	cutsceneModule.changeCamCFrame(cam1.CFrame)
	task.wait(5)
	phoneRingSfx:Play()
	task.wait(2)
	layingTrack:Stop()
	gettingUpTrack:Play()

	gettingUpTrack.Stopped:Wait()
	turningOffTrack:Play()
	task.wait(24 / 60)
	markiplierSfx:Stop()
	sfxGroup["Television 4 (SFX)"]:Play()
	importantFolder.TVDecal.Value:Destroy()
	task.wait(1)
	eventsModule.FireSmoothTransitionFunction(2)
	eventsModule.FireDisableSkipEvent()
	cloneHumanoid1.Parent:Destroy()
	cutsceneModule.fadeInPlayer(2.5)
	cutsceneModule.resetCam()
	eventsModule.FireEnableMouseIcon()
end

local function PlayPart2_PickUpPhone()
	-- after interacting with phone
	eventsModule.FireSmoothTransitionFunction(3)
	eventsModule.FirePauseCameraEffects()
	eventsModule.FireCloneAssetSecurityNone("Objects.007e7_Clone2")
	local clone2Asset = replicatedStorage.ClonedFolder:WaitForChild("007e7_Clone2")
	local clone2 = clone2Asset:Clone()
	clone2Asset:Destroy()
	clone2.Parent = introFolder

	local cloneHumanoid2 = clone2:WaitForChild("Humanoid")
	local animator2 = cloneHumanoid2:WaitForChild("Animator")

	walkToTrack = animator2:LoadAnimation(cloneHumanoid2.walkto_phone)
	pickUpTrack = animator2:LoadAnimation(cloneHumanoid2.grab_phone)
	holdTrack = animator2:LoadAnimation(cloneHumanoid2.hold_phone)

	pickUpTrack.Stopped:Connect(function()
		coroutine.resume(playConversation)
	end)

	-- Camera to phone
	cutsceneModule.changeCamCFrame(cam2.CFrame)
	cutsceneModule.fadeOutPlayer(0)
	task.wait(1)
	coroutine.resume(playPhoneAnimation)
end

local function PlayPart3_PhoneAnimation()
	walkToTrack:Play()
	walkToTrack.Stopped:Connect(function()
		pickUpTrack:Play()
		phoneTween:Play()
		phoneRingSfx:Stop()
		pickUpSfx:Play()
	end)
end

local function PlayPart4_PhoneConversation()
	holdTrack:Play()

	eventsModule.FireDialogueFunction("Introduction_PhoneCall")

	eventsModule.FireWaitForDialogueFinish()
	eventsModule.FireSmoothTransitionFunction(1)

	-- GO driving scene
	eventsModule.FireRemotePlayCutscene(game:GetService("Players").LocalPlayer, "IntroductionDrive")
	-- Wait for the scene to end
	local ended = false
	eventsModule.ConnectRemoteFinishCutscene(function()
		ended = true
	end)
	while not ended do
		task.wait()
	end

	-- Then 007e7 arrives at house cutscene

	-- Then 007e7 searches the house

	-- End the scene overall
	eventsModule.FireSmoothTransitionFunction(2)
	coroutine.resume(endScene)
end

local function EndScene()
	workspace.Cutscenes.Intro:ClearAllChildren()
	eventsModule.FireRemoteTeleportPlayerOnServer("c00lHouse")
	cutsceneModule.resetCam()
	cutsceneModule.resetCamZoom()
	cutsceneModule.fadeInPlayer(0)
	-- Set data on server
	eventsModule.FireCompletedCutscene("Intro")
	isPlayingIntro = false
end

local startIntroThread = coroutine.create(PlayPart1_WatchingTV)
pickUpEvent.OnClientEvent:Connect(PlayPart2_PickUpPhone)
playPhoneAnimation = coroutine.create(PlayPart3_PhoneAnimation)
playConversation = coroutine.create(PlayPart4_PhoneConversation)
endScene = coroutine.create(EndScene)

local function StartIntroductionScene()
	coroutine.resume(startIntroThread)
end

local function WaitForIntroFinish()
	task.wait()
	while isPlayingIntro do
		task.wait()
	end
end

eventsModule.ConnectStartIntroScene(StartIntroductionScene)
eventsModule.ConnectWaitForIntroEnd(WaitForIntroFinish)

return {}
