local module = {}

if game:GetService("RunService"):IsServer() then
	warn("Shedletsky module only runs on client.")
end

local eventsModule = require(script.Parent.ClientEventsModule)

local tweenService = game:GetService("TweenService")
local folder = game:GetService("Workspace").Cutscenes.Shedletsky

function module.PlayScene()
	eventsModule.FireDisableMovementEvent(false)
	local plr = game:GetService("Players").LocalPlayer.Character
	eventsModule.FireCloneAssetSecurityNone("Characters.Shedletsky_CHICKEN")
	local shedAsset = game:GetService("ReplicatedStorage").ClonedFolder:WaitForChild("Shedletsky_CHICKEN")
	local shed = shedAsset:Clone()
	shedAsset:Destroy()
	shed.Parent = folder

	plr.PrimaryPart.CFrame = folder.PlayerPos.Value

	plr:SetAttribute("LockFPOverride", true)
	eventsModule.FireTurnOffMusic()
	task.wait(2)
	eventsModule.FireDialogueFunction("ShedletskyEnding1", { "enableMovementAfter_false", "enablePromptsAfter_false" })

	local shedAnimator = shed.Humanoid.Animator
	local shedAnim = Instance.new("Animation")
	shedAnim.AnimationId = "rbxassetid://78795787053217"

	local shedTrack = shedAnimator:LoadAnimation(shedAnim)

	local aura = shed.AuraBall.ParticleEmitter

	eventsModule.FireCloneAssetSecurityNone("Objects.TurkeyLeg")
	local chickenAsset = game:GetService("ReplicatedStorage").ClonedFolder:WaitForChild("TurkeyLeg")
	local chicken = chickenAsset:Clone()
	chickenAsset:Destroy()
	chicken.CFrame = folder.StartTurkeyPos.Value
	chicken.Parent = workspace
	local chickenTwn = tweenService:Create(chicken, TweenInfo.new(71 / 60), {
		CFrame = folder.EndTurkeyPos.Value,
	})

	eventsModule.FireScaryVibe()
	aura.Enabled = true
	shedTrack:Play()
	chickenTwn:Play()
	eventsModule.FireRemoteRemoveItem()

	task.wait(72 / 60)
	aura.Enabled = false
	shed.TurkeyLeg.Transparency = 0
	chicken.Transparency = 1
	chicken:Destroy()
	shedTrack:GetMarkerReachedSignal("eat"):Connect(function()
		game:GetService("SoundService").SFX.minecraftEat:Play()
		shed.EatParticles.ParticleEmitter.Enabled = true
		shedTrack:GetMarkerReachedSignal("stopEat"):Connect(function()
			shed.EatParticles.ParticleEmitter.Enabled = false
			shed.TurkeyLeg:Destroy()
		end)
	end)
	shedTrack.Stopped:Wait()
	eventsModule.FireOffScaryVibe()
	local chickenSounds = game:GetService("SoundService").SFX.ChickenSounds:GetChildren()
	chickenSounds[math.random(#chickenSounds)]:Play()
	eventsModule.FireDialogueFunction("ShedletskyEnding2", { "enableMovementAfter_false", "enablePromptsAfter_false" })
	eventsModule.FireEndingEvent(
		"Ending: Shedletsky",
		"Bro, what do you want. I am eating my double chocolate hersheys! ch icke	n",
		"rbxassetid://14793262780"
	)
	task.wait(1)
	game:GetService("SoundService").SFX["Shedletsky Chicken Hersheys"]:Play()
end

local played = false

eventsModule.ConnectShedletskyEnding(function()
	if played then
		return
	end
	played = true
	module.PlayScene()
end)

return module
