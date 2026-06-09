local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local cutsceneModule = require(script.Parent.CutsceneModule)
local eventsModule = require(script.Parent.ClientEventsModule)
local PropertyManipulator = require(script.Parent.PropertyManipulator)
local MissionGui = Players.LocalPlayer.PlayerGui:WaitForChild("MissionGui")
local MissionHandler = require(MissionGui:WaitForChild("MissionHandler"))

local pickUpEvent: RemoteEvent = ReplicatedStorage.RemoteEvents.Cutscenes.Intro.PickUpPhoneEvent

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

local sfxGroup = SoundService.SFX
local pickUpSfx = sfxGroup.phone_pickup
-- local hangUpSfx = sfxGroup.HangUpPhone
local phoneRingSfx = sfxGroup.phoneRing.Value
local markiplierSfx = sfxGroup.MarkiplierGameplay
local engineStartSfx = sfxGroup["car engine start"]
local carEnterSfx = sfxGroup["car door opening"]
local carMoveSfx = sfxGroup["Truck Acceleration"]

local doorBangSfx = sfxGroup.DoorBang

-- local originalPhoneCF = wallPhone.Speaker.CFrame

local phoneTween = TweenService:Create(wallPhone.Speaker, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
	CFrame = wallPhone:WaitForChild("SpeakerPos2").CFrame,
})

local isPlayingIntro = false

local playPhoneAnimation
local playConversation
local endScene

local function PlayPart1_WatchingTV()
	isPlayingIntro = true

	-- Prepare for the cutscene
	eventsModule.FireSmoothTransitionFunction(3)
	eventsModule.FirePrepareCutscene()
	eventsModule.FireRemoteTeleportPlayerOnServer("Intro")

	-- Clone 007e7 to lay on couch

	-- eventsModule.FireCloneAssetSecurityNone("Objects.007e7_Clone1")
	-- local clone1Asset = replicatedStorage.ClonedFolder:WaitForChild("007e7_Clone1")
	-- local clone1 = clone1Asset:Clone()
	-- clone1Asset:Destroy()
	-- clone1.Parent = introFolder

	-- local cloneHumanoid1 = clone1:WaitForChild("Humanoid")
	-- local animator1 = cloneHumanoid1:WaitForChild("Animator")

	-- local layingTrack = animator1:LoadAnimation(cloneHumanoid1.laying)
	-- local gettingUpTrack = animator1:LoadAnimation(cloneHumanoid1.getting_up)
	-- local turningOffTrack = animator1:LoadAnimation(cloneHumanoid1.turning_off)

	-- -- Set the scene: 007e7 is laying on the couch and markiplier is playing on the TV
	-- layingTrack:Play()
	-- markiplierSfx:Play()

	-- Move camera to face the couch
	cutsceneModule.changeCamCFrame(cam1.CFrame)
	task.wait(5)
	--After a bit, the phone will ring
	phoneRingSfx:Play()
	task.wait(2)

	-- 007e7 gets up
	-- layingTrack:Stop()
	-- gettingUpTrack:Play()
	-- gettingUpTrack.Stopped:Wait()
	-- -- 007e7 turns off the TV
	-- turningOffTrack:Play()
	-- -- Right when the remote clicks, stop markipllier
	-- task.wait(24 / 60)
	-- markiplierSfx:Stop()
	-- -- Remote click sound effect
	-- sfxGroup["Television 4 (SFX)"]:Play()
	-- -- Kill markiplier
	-- importantFolder.TVDecal.Value:Destroy()

	task.wait(1)
	-- Transition to controlling 007e7 character
	eventsModule.FireSmoothTransitionFunction(2)
	eventsModule.FireDisableSkipEvent()
	-- cloneHumanoid1.Parent:Destroy()
	cutsceneModule.fadeInPlayer(2.5)
	cutsceneModule.resetCam()
	eventsModule.FireEnableMouseIcon()
end

local function PlayPart2_PickUpPhone()
	-- After interacting with phone
	eventsModule.FireSmoothTransitionFunction(3)
	eventsModule.FirePauseCameraEffects()
	-- Make another clone of 007e7 that will pick up the phone
	eventsModule.FireCloneAssetSecurityNone("Objects.007e7_Clone2")
	local clone2Asset = ReplicatedStorage.ClonedFolder:WaitForChild("007e7_Clone2")
	local clone2 = clone2Asset:Clone()
	clone2Asset:Destroy()
	clone2.Parent = introFolder

	local cloneHumanoid2 = clone2:WaitForChild("Humanoid")
	local animator2 = cloneHumanoid2:WaitForChild("Animator")

	walkToTrack = animator2:LoadAnimation(cloneHumanoid2.walkto_phone)
	pickUpTrack = animator2:LoadAnimation(cloneHumanoid2.grab_phone)
	holdTrack = animator2:LoadAnimation(cloneHumanoid2.hold_phone)

	-- When the pickUp animation is finished, play the dialogue
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
	-- Hold the phone
	holdTrack:Play()

	-- Play phone dialogue
	eventsModule.FireDialogueFunction("Introduction_PhoneCall")

	-- Wait for that to finish
	eventsModule.FireWaitForDialogueFinish()

	eventsModule.FireSmoothTransitionFunction(4)
	local DRIVING_SCENE_LENGTH = 30
	-- Go to driving scene
	eventsModule.FireRemotePlayCutscene("IntroductionDrive")

	-- Time the BIG RED SCARY SKY
	task.spawn(function()
		-- dark sky aa scary :(
		local SpectreSky = workspace:WaitForChild("IntroductionDrivingScene"):WaitForChild("SpectreSky")
		local Lighting = game:GetService("Lighting")
		local Sky = Lighting.Sky
		local skyClone = SpectreSky:Clone()
		task.wait(25)
		skyClone.Parent = Lighting
		Sky.Parent = ReplicatedStorage
		task.wait(DRIVING_SCENE_LENGTH - 25)
		Sky.Parent = Lighting
		skyClone:Destroy()
	end)
	-- Time the transition
	task.spawn(function()
		task.wait(DRIVING_SCENE_LENGTH - 1)
		eventsModule.FireSmoothTransitionFunction(5)
	end)

	-- Wait for the scene to end
	local ended = false
	eventsModule.ConnectRemoteFinishCutscene(function()
		ended = true
	end)

	while not ended do
		task.wait()
	end

	-- Then 007e7 arrives at house cutscene ( COMBINE INTO ONE CUTSCENE )
	eventsModule.FireRemotePlayCutscene("IntroductionHouse", {
		KeepMap = true,
	})

	local ended2 = false
	eventsModule.ConnectRemoteFinishCutscene(function()
		ended2 = true
	end)

	while not ended2 do
		task.wait()
	end

	-- Need to keep the house somehow

	-- Then 007e7 searches the house (IntroMission)
	-- When player touches a room's respective parts, go tick the box
	local MapFolder = workspace:WaitForChild("IntroductionEnterHouse")
	local CheckForTouchFolder = MapFolder:WaitForChild("CheckForTouch")

	MapFolder:WaitForChild("007e7"):Destroy()

	local RoomFolders = {
		LivingRoom = CheckForTouchFolder.LivingRoom,
		DownstairsBedroom = CheckForTouchFolder.DownstairsBedroom,
		Garage = CheckForTouchFolder.Garage,
		FamilyRoom = CheckForTouchFolder.FamilyRoom,
		["007n7Bedroom"] = CheckForTouchFolder["007n7Bedroom"],
		c00lkiddBedroom = CheckForTouchFolder.c00lkiddBedroom,
	}

	local function EndPlayerMission()
		-- Turn off mission ui
		MissionGui.Enabled = false

		-- Teleport to normal house
		print("END SCENE")
		coroutine.resume(endScene)

		MapFolder:Destroy()
	end

	local function ConnectTouchEvents()
		local exploredRooms = {}
		for roomName, roomFolder in RoomFolders do
			-- Mark off this room when .Touched -- issue with .Touched not valid member
			for _, roomPart in roomFolder:GetChildren() do
				roomPart.Touched:Connect(function(other)
					if table.find(exploredRooms, roomName) then
						return
					end
					-- Make sure it is the player first
					if not other.Parent then
						return
					end

					if Players:GetPlayerFromCharacter(other.Parent) ~= Players.LocalPlayer then
						return
					end

					MissionHandler.MarkComplete(roomName)
					table.insert(exploredRooms, roomName)

					-- Check if all rooms have been seen
					if #exploredRooms == 6 then
						print("ALL ROOMS DONE")
						EndPlayerMission()
					end
				end)
			end
		end
	end

	local function StartPlayerMission(player: Player)
		-- Turn on UI
		PropertyManipulator.ManipulateProperty(player.PlayerGui:WaitForChild("MissionGui"), "Enabled", true)
		ConnectTouchEvents()

		-- Teleport Player
		eventsModule.FireRemoteTeleportPlayerOnServer("HouseMission")
	end

	-- Begin the MissionUI and room detection
	StartPlayerMission(game:GetService("Players").LocalPlayer)

	-- End the scene overall
	eventsModule.FireSmoothTransitionFunction(2)
end

local function EndScene()
	-- Remove the Intro house
	workspace.Cutscenes.Intro:ClearAllChildren()
	-- Put the player back into the c00lHouse
	eventsModule.FireRemoteTeleportPlayerOnServer("c00lHouse")
	-- Reset cameras
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
