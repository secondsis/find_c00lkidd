task.wait(5)

local player = game:GetService("Players").LocalPlayer
if not player.Character then
	player.CharacterAdded:Wait()
end

local humanoid = game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid", math.huge)

local eventsModule = require(script.Parent.ClientEventsModule)

--local shakeIntensity = 2.9  -- Adjust this value to control the intensity of the shake
--local shakeSpeed = 0.1     -- Adjust this value to control the speed of the shake

--[=[
 Visually shakes the camera like an Earthquake
 @param seconds number
 @param shakeIntensity number
 @param shakeSpeed number
]=]
local function shakeCamera(seconds: number, shakeIntensity: number, shakeSpeed: number)
	seconds = seconds or 1
	shakeIntensity = shakeIntensity or 2.9
	shakeSpeed = shakeSpeed or 0.1

	local startTick = tick()

	while startTick + seconds > tick() do
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
			currentTime = currentTime + task.wait()
		end
		humanoid.CameraOffset = originalOffset
		task.wait()
	end
end

eventsModule.ConnectShakeCamera(shakeCamera)
eventsModule.ConnectRemoteShakeCamera(shakeCamera)
