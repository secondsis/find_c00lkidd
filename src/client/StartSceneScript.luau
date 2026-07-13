local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local eventsModule = require(script.Parent.CLIENT_EVENTS)
local cutsceneModule = require(ReplicatedStorage.Shared.CutsceneModule)
local SignalGetter = require(ReplicatedStorage.SignalGetter)

-- stop player from moving
task.spawn(function()
	task.wait(1)
	eventsModule.FireDisableMovementEvent(false)
end)

player.PlayerGui:WaitForChild("TransitionGui").Backup.Visible = true

-- Wait for player to finish loading
do
	local loaded = player:GetAttribute("Loaded")
	while not loaded do
		task.wait()
		loaded = player:GetAttribute("Loaded")
	end
	eventsModule.FireDisableMovementEvent(false)
end
local quickStart = true -- reset this
local tpData = TeleportService:GetLocalPlayerTeleportData()
if tpData then
	if tpData["QuickStart"] then
		quickStart = true
		eventsModule.FireRemoteSetBattleQuickStart()
	end
	if tpData["LavaDeaths"] and tpData["Deaths"] then
		eventsModule.FireRemoteSetNoobMode(tpData["LavaDeaths"], tpData["Deaths"])
	end
end

task.wait(1)
local evilRig = ReplicatedStorage.EvilRig:Clone()
local arenaCenter = workspace.BattleArena:WaitForChild("Center")

local function fightIntroScene()
	---------------------------------------------------------------------------------------

	-- Clear scene with black screen
	eventsModule.FireSmoothTransitionFunction(3)
	cutsceneModule.fadeOutPlayer(player, 0)

	local IntroFolder = ReplicatedStorage.IntroFolder

	local portal = IntroFolder:WaitForChild("PortalEffect")
	-- Player falls into world
	while not player.Character do
		task.wait()
	end

	player.Character.Archivable = true
	player.Character:PivotTo(workspace.TPPart_Spawn.CFrame)
	local playerClone: Model = player.Character:Clone()
	playerClone.Name = "PlayerClone"
	local hum: Humanoid = playerClone:WaitForChild("Humanoid")
	hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

	local ScaleValue = Instance.new("NumberValue")
	ScaleValue.Value = 0.05
	playerClone:ScaleTo(0.05)
	playerClone.HumanoidRootPart.CFrame = portal.CFrame + Vector3.new(0, 0.5, 0)
	playerClone.HumanoidRootPart.Anchored = true

	-- Scene preperations done

	task.wait(1.5)
	player.PlayerGui.TransitionGui.Backup.Visible = false

	-- Set Camera Position
	local cam = workspace.CurrentCamera
	local oldCamType = cam.CameraType
	cam.CameraType = Enum.CameraType.Scriptable
	workspace.CurrentCamera:PivotTo(
		CFrame.new(-19.833, 11.618, -0.481) * CFrame.fromOrientation(math.rad(-15.602), math.rad(-90.199), 0)
	)

	-- Open up Portal

	local current_portal = portal:Clone()
	current_portal.Parent = workspace

	SoundService.SFX.portal_open:Play()

	local portalScript = require(current_portal:WaitForChild("PortalController"))
	portalScript.TweenPortalSize(0, 4, 2)
	portalScript.TogglePortal(true)
	task.wait(2)

	cutsceneModule.setModelTransparency(playerClone, 0)

	-- Player falls out of portal
	playerClone.Parent = workspace

	ScaleValue.Changed:Connect(function(val)
		playerClone:ScaleTo(val)
	end)

	TweenService:Create(ScaleValue, TweenInfo.new(0.5), {
		Value = 1,
	}):Play()

	local playerFallTrack = cutsceneModule.GetAnimationTrackForBody(playerClone, "76975347644327")
	playerFallTrack:Play()

	local playerGetupTrack = cutsceneModule.GetAnimationTrackForBody(playerClone, "107546687685215")

	task.wait(playerFallTrack.Length - 0.1)

	SoundService.cardboard_box_impact_soft1:Play()
	playerFallTrack.Stopped:Wait()

	task.spawn(function()
		portalScript.TweenPortalSize(4, 0, 2)
		task.wait(2)
		portalScript.TogglePortal(false)
	end)

	playerGetupTrack:Play()
	task.wait(playerGetupTrack.Length - 0.05)
	playerGetupTrack:AdjustSpeed(0)

	eventsModule.FireSmoothTransitionFunction(3)
	SoundService.SFX["splat.wav"]:Play()
	playerClone:Destroy()
	cutsceneModule.fadeInPlayer(player, 1)
	cam.CameraType = oldCamType

	-- Rig Appears
	local rigClone = ReplicatedStorage.EvilRig:Clone()
	rigClone.PrimaryPart.CFrame = ReplicatedStorage.Locations.EvilRig["1"].Value

	local animator: Animator = rigClone.Humanoid.Animator

	local RigIdleAnimation = Instance.new("Animation")
	RigIdleAnimation.AnimationId = "rbxassetid://99474071827383"
	local RigTalkAnimation = Instance.new("Animation")
	RigTalkAnimation.AnimationId = "rbxassetid://81351761128790"
	local RigIdleAnimationTrack = animator:LoadAnimation(RigIdleAnimation)
	local RigTalkAnimationTrack = animator:LoadAnimation(RigTalkAnimation)

	-- dude i have NO idea why this fixes the issue with the animation not working
	-- roblox is so weird
	RigTalkAnimationTrack:Play()
	RigTalkAnimationTrack:Stop()

	RigIdleAnimationTrack:Play()

	task.wait(1.5)

	-- Teleport Effect

	task.spawn(function()
		rigClone.HumanoidRootPart.StarParticleAttachment.star.Enabled = true
		task.wait(1)
		rigClone.HumanoidRootPart.StarParticleAttachment.star.Enabled = false
	end)
	SoundService.SFX.magic_swoosh:Play()
	cutsceneModule.setModelTransparency(rigClone, 1)

	rigClone.Parent = workspace
	cutsceneModule.tweenModelTransparency(rigClone, 0, 5)

	task.wait(3)

	local function RigAnimationCallback(isTalking: boolean)
		if isTalking then
			RigTalkAnimationTrack:Play()
			RigIdleAnimationTrack:Stop()
		else
			RigIdleAnimationTrack:Play()
			RigTalkAnimationTrack:Stop()
		end
	end
	task.spawn(function()
		print("task spawned")
		local startTick = tick()
		local timeout = 120
		while task.wait() do
			local currLine = eventsModule.FireCheckCurrentDialogueLine()
			if currLine == "I have [THEM], but I would advise to turn back from this path." then
				-- Make the two appear
				SoundService.SFX.magic_poof:Play()
				local theTwoClone = ReplicatedStorage.TheTwo:Clone()
				theTwoClone.Parent = workspace
				break
			end

			if startTick + timeout < tick() then
				print("timed out")
				break
			end
		end
	end)
	-- EVIL RIG TALKS
	eventsModule.FireDialogueFunction("EvilRigTalk", { "enableMovementAfter_false", "enablePromptsAfter_false" }, {
		{ Name = "Evil Rig", AnimCallback = RigAnimationCallback },
	})

	-- After the talk
	---------------------------------------------------------------------------------------

	-- Remove Rig
	cutsceneModule.tweenModelTransparency(evilRig, 1, 1)

	-- RAISE THE ARENA UP
	eventsModule.FireRaiseArena()
	SoundService["Rock Sliding"]:Play()

	eventsModule.FireShakeCamera(999)

	ReplicatedStorage.WaitEvents.ArenaRiseFinished.OnClientEvent:Wait()
	eventsModule.FireStopCameraShake()
	SoundService["Rock Sliding"]:Stop()

	-- Start battle
	eventsModule.FireEnterBattleGui()
	local startBattle = SignalGetter.getRemoteEvent("StartBattle")
	eventsModule.FireToggleDash(true)
	startBattle:FireServer()
	SoundService["ERROR 264"]:Play()
	eventsModule.FireDisableMovementEvent(true)
	eventsModule.FireSetCanSprintEvent(true)
end

local function quickStartFight()
	-- Clear scene with black screen
	eventsModule.FireSmoothTransitionFunction(3)

	task.wait(1.5)
	player.PlayerGui.TransitionGui.Backup.Visible = false

	-- After the talk
	---------------------------------------------------------------------------------------

	-- RAISE THE ARENA UP
	eventsModule.FireRaiseArena(true)

	task.wait(1.5)
	-- Start battle
	eventsModule.FireEnterBattleGui()
	local startBattle = SignalGetter.getRemoteEvent("StartBattle")
	eventsModule.FireToggleDash(true)
	startBattle:FireServer()
	SoundService["ERROR 264"]:Play()
	eventsModule.FireDisableMovementEvent(true)
	eventsModule.FireSetCanSprintEvent(true)
end

local function StopMusic()
	SoundService["ERROR 264"]:Stop()
end

eventsModule.ConnectPlayerDeath(StopMusic)
eventsModule.ConnectRemoteBossDeath(StopMusic)

if not quickStart then
	fightIntroScene()
else
	quickStartFight()
end

return module
