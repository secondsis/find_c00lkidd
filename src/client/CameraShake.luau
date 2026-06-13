local module = {}

local player = game:GetService("Players").LocalPlayer
if not player.Character then
	player.CharacterAdded:Wait()
end

local humanoid = game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid", math.huge)
local camera = workspace.CurrentCamera

local eventsModule = require(game:GetService("ReplicatedStorage").Modules.Client.ClientEventsModule)

--local shakeIntensity = 2.9  -- Adjust this value to control the intensity of the shake
--local shakeSpeed = 0.1     -- Adjust this value to control the speed of the shake

local stop = false

-- Function to shake the camera
local function shakeCamera(seconds: int, shakeIntensity: number, shakeSpeed: number)
	seconds = seconds or 1
	shakeIntensity = shakeIntensity or 2.9
	shakeSpeed = shakeSpeed or 0.1

	local startTick = tick()

	while startTick + seconds > tick() do
		-- Manual stop
		if stop then
			stop = false
			break
		end

		local shakeOffset = Vector3.new(
			math.random(-shakeIntensity, shakeIntensity),
			math.random(-shakeIntensity, shakeIntensity),
			math.random(-shakeIntensity, shakeIntensity)
		)
		local originalOffset = humanoid.CameraOffset
		local currentTime = 0
		local duration = shakeSpeed
		while currentTime < duration do
			local delta = currentTime / duration
			humanoid.CameraOffset = originalOffset + shakeOffset * (1 - delta)
			currentTime = currentTime + wait()
		end
		humanoid.CameraOffset = originalOffset
		task.wait()
	end
end

local function stopCameraShake()
	stop = true
	task.wait(3)
	stop = false
end

eventsModule.ConnectShakeCamera(shakeCamera)
eventsModule.ConnectRemoteShakeCamera(shakeCamera)
eventsModule.ConnectStopCameraShake(stopCameraShake)

return module
