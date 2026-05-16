local module = {}

function module.StartScene()
	local eventsModule = require(script.Parent.ClientEventsModule)

	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local lighting = game:GetService("Lighting")

	local alarmOn = true
	local sfx = game:GetService("SoundService").SFX
	local alarmSfx = sfx.Alarm
	alarmSfx.Looped = true
	alarmSfx:Play()

	task.spawn(function()
		while alarmOn do
			lighting.RED.Enabled = true
			task.wait(0.75)
			if not alarmOn then
				lighting.RED.Enabled = false
				break
			end
			lighting.RED.Enabled = false
			task.wait(0.75)
			if not alarmOn then
				lighting.RED.Enabled = false
				break
			end
		end
	end)

	local fbiSfx = sfx["FBI OPEN UP"]

	eventsModule.FireTurnOffMusic()
	eventsModule.FireDisableMovementEvent(false)
	fbiSfx:Play()
	task.wait(1.6)
	eventsModule.FireShakeCamera(5)

	local dust = workspace.Buildings["Grocery Store"].Inside:WaitForChild("Roof"):WaitForChild("ParticleEmitter")
	dust.Enabled = true
	fbiSfx.Ended:Wait()
	alarmSfx:Stop()
	alarmOn = false
	lighting.RED.Enabled = false
	dust.Enabled = false

	eventsModule.FireCloneAssetSecurityNone("Maps.Cutscenes.NileGreen")
	local sceneAsset = ReplicatedStorage.ClonedFolder:WaitForChild("NileGreen")

	local sceneCopy = sceneAsset:Clone()
	sceneAsset:Destroy()
	sceneCopy.Parent = workspace.Cutscenes.NileGreenEnding

	local sceneModule = require(sceneCopy.NileGreenScene.NileGreenTable.ModuleScript)
	sceneModule.PlayScene()
end

return module
