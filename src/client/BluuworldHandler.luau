task.wait(30)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local eventsModule = require(script.Parent.ClientEventsModule)
local event = Remotes.BluuEvent
local player = Players.LocalPlayer
local played = false

local function playCrash()
	if played then
		return
	end
	played = true
	eventsModule.FireTransitionFunction(999)
	eventsModule.FireDisableMovementEvent(false)
	eventsModule.FireTurnOffMusic()
	SoundService.SFX["Car Tire Screeching"]:Play()
	local honkSfx = SoundService.SFX["Goofy ahh car horn that i constantly laugh at i ca"]
	honkSfx:Play()
	task.wait(1)
	SoundService.SFX["Bazinga crash"]:Play()
	honkSfx.Ended:Wait()

	-- get server to tp
	event:FireServer()
end

event.OnClientEvent:Once(function()
	-- hit the player with a red car

	eventsModule.FireCloneAssetSecurityNone("Objects.RedCar")
	local carAsset = ReplicatedStorage.ClonedFolder:WaitForChild("RedCar")
	local car = carAsset:Clone()
	carAsset:Destroy()
	car[" SoundAttachment"]["car engine loop"].Script.Enabled = true
	car.Parent = workspace
	task.wait(1)

	local speed = 100
	local vec = Vector3.new

	local cxn
	cxn = RunService.Heartbeat:Connect(function(delta)
		car.PrimaryPart.CFrame += car.PrimaryPart.CFrame.LookVector * delta * speed
		local char = player.Character
		if not char then
			return
		end
		local playerPos = char.PrimaryPart.Position
		car.PrimaryPart.CFrame =
			CFrame.lookAt(car.PrimaryPart.Position, vec(playerPos.X, car.PrimaryPart.Position.Y, playerPos.Z))

		local dist = player:DistanceFromCharacter(car.PrimaryPart.Position)
		if dist < 15 then
			playCrash()
			cxn:Disconnect()
			return
		end
	end)

	-- add black bars that move down, lower fov
end)

return {}
