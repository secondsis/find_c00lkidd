local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
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

-- Wait for player to finish loading
do
	local loaded = player:GetAttribute("Loaded")
	while not loaded do
		task.wait()
		loaded = player:GetAttribute("Loaded")
	end
	eventsModule.FireDisableMovementEvent(false)
end

task.wait(1)
local evilRig = ReplicatedStorage.EvilRig:Clone()
local arenaCenter = workspace.BattleArena:WaitForChild("Center")

local function fightIntroScene()
	---------------------------------------------------------------------------------------
	local portal = workspace:WaitForChild("PortalEffect")
	-- Player falls into world
	while not player.Character do
		task.wait()
	end
	player.Character.Archivable = true
	local playerClone: Model = player.Character:Clone()
	local hum: Humanoid = playerClone:WaitForChild("Humanoid")
	hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

	local ScaleValue = Instance.new("NumberValue")
	ScaleValue.Value = 0.05
	playerClone:ScaleTo(0.05)
	playerClone.HumanoidRootPart.CFrame = portal.CFrame
	playerClone.HumanoidRootPart.Anchored = true

	-- Open up Portal

	local portalScript = require(portal:WaitForChild("PortalController"))
	portalScript.TweenPortalSize(0, 4, 2)
	portalScript.TogglePortal(true)
	task.wait(2)

	-- Player falls out of portal
	playerClone.Parent = workspace

	ScaleValue.Changed:Connect(function(val)
		playerClone:ScaleTo(val)
	end)

	TweenService:Create(ScaleValue, TweenInfo.new(5), {
		Value = 1,
	}):Play()

	TweenService:Create(playerClone.PrimaryPart, TweenInfo.new(5), {
		CFrame = CFrame.new(0.627, 1.804, 0.424) * CFrame.Angles(math.rad(-90), math.rad(-180), 0),
	}):Play()

	--[[ -- Teleport Evil Rig with Portal
	-- do
	-- 	local portalPart = workspace:WaitForChild("PortalEffect")
	-- 	local basePortalEffects = {
	-- 		portalPart.Main.Portal,
	-- 		portalPart.Main.PortalOutline,
	-- 		portalPart.Main.PortalSuck,
	-- 	}
	-- 	local portalExitEffects = {
	-- 		portalPart.Main.PortalExitOutline,
	-- 		portalPart.Main.PortalInteractionLines,
	-- 	}

	-- 	-- PORTAL SOUNDS HERE
	-- 	for _, fx in basePortalEffects do
	-- 		if fx:IsA("ParticleEmitter") then
	-- 			fx.Enabled = true
	-- 		end
	-- 	end

	-- 	task.wait(5)

	-- 	-- PORTAL EXIT SOUND HERE
	-- 	for _, fx in portalExitEffects do
	-- 		if fx:IsA("ParticleEmitter") then
	-- 			fx.Enabled = true
	-- 		end
	-- 	end

	-- 	evilRig.Parent = workspace

	-- 	task.wait(3)

	-- 	portalPart:Destroy()
	-- end]]

	local rigClone = ReplicatedStorage.EvilRig:Clone()
	rigClone.PrimaryPart.CFrame = ReplicatedStorage.Locations.EvilRig["1"].Value
	rigClone.Parent = workspace

	local animator: Animator = rigClone.Humanoid.Animator

	local RigIdleAnimation = Instance.new("Animation")
	RigIdleAnimation.AnimationId = "rbxassetid://99474071827383"
	local RigTalkAnimation = Instance.new("Animation")
	RigTalkAnimation.AnimationId = "rbxassetid://81351761128790"
	local RigIdleAnimationTrack = animator:LoadAnimation(RigIdleAnimation)
	local RigTalkAnimationTrack = animator:LoadAnimation(RigTalkAnimation)

	RigIdleAnimationTrack:Play()

	task.wait(3)

	-- later make it only talk when text is actively moving

	local function RigAnimationCallback(isTalking: boolean)
		if isTalking then
			RigTalkAnimationTrack:Play()
			RigIdleAnimationTrack:Stop()
		else
			RigIdleAnimationTrack:Play()
			RigTalkAnimationTrack:Stop()
		end
	end

	-- EVIL RIG TALKS
	eventsModule.FireDialogueFunction(
		"EvilRigTalk",
		{ "enableMovementAfter_false", "enablePromptsAfter_false" },
		RigAnimationCallback
	)

	---------------------------------------------------------------------------------------

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
	startBattle:FireServer()
	SoundService["ERROR 264"]:Play()
	eventsModule.FireDisableMovementEvent(true)
	eventsModule.FireSetCanSprintEvent(true)
end

fightIntroScene()

return module
