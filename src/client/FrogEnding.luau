task.wait(5)

local rs = game:GetService("ReplicatedStorage")
local eventsModule = require(script.Parent.ClientEventsModule)

eventsModule.ConnectFrogEnding(function()
	local player = game:GetService("Players").LocalPlayer
	eventsModule.FireCloneAssetSecurityNone("Objects.FROGS")
	local frogsAsset = rs.ClonedFolder:WaitForChild("FROGS")
	local frogsClone = frogsAsset:Clone()
	frogsAsset:Destroy()
	player:SetAttribute("LockFPOverride", true)
	eventsModule.FireDisableMovementEvent(false)
	eventsModule.FireTurnOffMusic()
	frogsClone.Parent = workspace
	player.Character:PivotTo(rs.Values.CFrameValues.PlayerShopExit.Value)

	task.wait(5)
	local SFX = game:GetService("SoundService").SFX

	eventsModule.FireRemoteRemoveItem()
	SFX["Grab Item"]:Play()
	task.wait(1)
	local eatSfx = SFX["minecraftEat"]
	eatSfx:Play()
	frogsClone.Slimeball.Ball.Transparency = 0
	frogsClone.Slimeball.Handle.Decal.Transparency = 0
	frogsClone.Slimeball.Part.Decal.Transparency = 0
	frogsClone.EatParticles.ParticleEmitter.Enabled = true
	eatSfx.Ended:Wait()
	frogsClone.Slimeball:Destroy()
	frogsClone.EatParticles:Destroy()

	task.wait(2)
	local tweenService = game:GetService("TweenService")
	local posterTwn = tweenService:Create(frogsClone.MissingFrog.PrimaryPart, TweenInfo.new(2), {
		CFrame = frogsClone.MissingFrog.PrimaryPart.CFrame + Vector3.new(0, 6, 0),
	})

	posterTwn:Play()
	task.wait(3)
	frogsClone.MissingFrog:Destroy()
	SFX["Paper SFX"]:Play()
	-- eventsModule fire add poster
	eventsModule.FireRemoteAddPoster()
	eventsModule.ConnectOnPosterUse(function()
		SFX.Roblox_UI_Paper_Swipe:Play()
		task.wait(2)
		-- upon use of poster, frog pulls out gun
		-- e7 starts talking and is cut off
		eventsModule.FireCloneAssetSecurityNone("Objects.GreenGun")
		local gunAsset = rs.ClonedFolder:WaitForChild("GreenGun")
		local gun = gunAsset:Clone()
		gunAsset:Destroy()
		gun.Parent = workspace
		SFX["Gun Equip 1"]:Play()
		task.wait(1)

		eventsModule.FireDialogueFunction("FrogEnding", {
			"enableMovementAfter_false",
			"fastDialogue_true",
		})

		gun.Attachment2.WorldCFrame = player.Character.PrimaryPart.CFrame
		gun.Beam1.Enabled = true
		gun.Beam2.Enabled = true
		SFX.gun_shoot_06:Play()
		task.wait(0.5)
		eventsModule.FireSpawnClientExplosion(player.Character.PrimaryPart.Position)
		SFX.explosion_classic:Play()
		player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
		task.wait(2)
		eventsModule.FireEndingEvent("Ending: Frogs.", "Something was off about that minecraft slimeball...")
	end)
end)

return {}
