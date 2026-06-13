local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer

local eventsModule = require(ReplicatedStorage.Modules.Client.ClientEventsModule)
local cutsceneModule = require(ReplicatedStorage.Modules.Both.CutsceneModule)

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

	-- Teleport Evil Rig with Portal
	do
		local portalPart = workspace:WaitForChild("PortalEffect")
		local basePortalEffects = {
			portalPart.Main.Portal,
			portalPart.Main.PortalOutline,
			portalPart.Main.PortalSuck,
		}
		local portalExitEffects = {
			portalPart.Main.PortalExitOutline,
			portalPart.Main.PortalInteractionLines,
		}

		-- PORTAL SOUNDS HERE
		for _, fx in basePortalEffects do
			if fx:IsA("ParticleEmitter") then
				fx.Enabled = true
			end
		end

		task.wait(5)

		-- PORTAL EXIT SOUND HERE
		for _, fx in portalExitEffects do
			if fx:IsA("ParticleEmitter") then
				fx.Enabled = true
			end
		end

		evilRig.Parent = workspace

		task.wait(3)

		portalPart:Destroy()
	end

	-- EVIL RIG TALKS
	eventsModule.FireDialogueFunction("EvilRigTalk", { "enableMovementAfter_false", "enablePromptsAfter_false" })

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
	SoundService["ERROR 264"]:Play()
	eventsModule.FireDisableMovementEvent(true)
	eventsModule.FireSetCanSprintEvent(true)
end

fightIntroScene()

return module
