local eventsModule = require(script.Parent.ClientEventsModule)

local fpv = false
local Camera = workspace.CurrentCamera

----------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------

-- CameraBobbing --

local bobbingModule = {}

local sensitivity = 0.5

local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local character = Player.Character
if not character then
	repeat
		task.wait(0.1)
		character = Player.Character
	until character
end
local Humanoid = character:WaitForChild("Humanoid")
local bobbing = nil
local func1 = 0 -- y axis randomness
local func2 = 0 -- x axis randomness
local func3 = 0 -- sideways dragging when moving camera
local func4 = 0 -- bobbing when walking
local val = 0
local val2 = 0
local int = 5
local int2 = 5

function lerp(a, b, c)
	return a + (b - a) * c
end

local function bobbingFunc(deltaTime)
	deltaTime = deltaTime * 30
	if Humanoid.Health <= 0 then
		bobbing:Disconnect()
		return
	end
	local rootMagnitude = Humanoid.RootPart
			and Vector3.new(Humanoid.RootPart.Velocity.X, 0, Humanoid.RootPart.Velocity.Z).Magnitude
		or 0
	local calcRootMagnitude = math.min(rootMagnitude, 25)
	if deltaTime > 1.5 then
		func1 = 0
		func2 = 0
	else
		func1 = lerp(
			func1,
			math.cos(tick() * 0.5 * math.random(5, 7.5)) * (math.random(2.5, 10) / 100) * deltaTime * sensitivity * 2,
			0.05 * deltaTime
		)
		func2 = lerp(
			func2,
			math.cos(tick() * 0.5 * math.random(2.5, 5)) * (math.random(1, 5) / 100) * deltaTime * sensitivity * 2,
			0.05 * deltaTime
		)
	end

	Camera.CFrame = Camera.CFrame
		* (
			CFrame.fromEulerAnglesXYZ(0, 0, math.rad(func3))
			* CFrame.fromEulerAnglesXYZ(math.rad(func4 * deltaTime), math.rad(val * deltaTime), val2)
			* CFrame.Angles(0, 0, math.rad(func4 * deltaTime * (calcRootMagnitude / 5)))
			* CFrame.fromEulerAnglesXYZ(math.rad(func1), math.rad(func2), math.rad(func2 * 10))
		)
	val2 = math.clamp(
		lerp(
			val2,
			-Camera.CFrame:VectorToObjectSpace(
					(Humanoid.RootPart and Humanoid.RootPart.Velocity or Vector3.new())
						/ math.max(Humanoid.WalkSpeed, 0.01)
				).X
				* 0.02
				* sensitivity,
			0.1 * deltaTime
		),
		-0.12,
		0.1
	)
	func3 = lerp(func3, math.clamp(UserInputService:GetMouseDelta().X, -2.5, 2.5) * sensitivity, 0.25 * deltaTime)
	func4 = lerp(func4, math.sin(tick() * int) / 5 * math.min(1, int2 / 10) * sensitivity * 4, 0.25 * deltaTime)
	if rootMagnitude > 1 then
		val = lerp(val, math.cos(tick() * 0.5 * math.floor(int)) * (int / 200) * sensitivity, 0.25 * deltaTime)
	else
		val = lerp(val, 0, 0.05 * deltaTime)
	end
	if rootMagnitude > 6 then
		int = 10
		int2 = 9
	elseif rootMagnitude > 0.1 then
		int = 6
		int2 = 7
	else
		int2 = 0
	end
end

function bobbingModule.setSensitivity(value: number)
	sensitivity = value
end

function bobbingModule.stopBobbing()
	if not bobbing then
		return
	end

	bobbing:Disconnect()
	bobbing = nil
end

function bobbingModule.startBobbing()
	if bobbing then
		return
	end

	bobbing = RunService.RenderStepped:Connect(bobbingFunc)
end

----------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------

-- CameraVFX --
--- Dependent on CameraBobbing

local camFX = {}

local CanViewBody = true -- whether you see your body
local Sensitivity = 0.2 -- anything higher would make looking up and down harder; recommend anything between 0~1
local Smoothness = 0.05 -- recommend anything between 0~1

local players = game:GetService("Players")

local player = players.LocalPlayer

local Vector2New = Vector2.new
local CFrameNew = CFrame.new
local CFrameAngles = CFrame.Angles
local mathrad = math.rad
local mathabs = math.abs

-- local character = player.Character
-- if not character then
-- 	repeat
-- 		task.wait(0.1)
-- 		character = player.Character
-- 	until character
-- end
local humanoidpart = character:WaitForChild("HumanoidRootPart")

local head = character:WaitForChild("Head")

-- local running = true
local pausedInfo = {
	Paused = false,
	WasFirstPerson = false,
}

---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

local function updatechar(visible: boolean)
	local newTransparency
	if visible then
		newTransparency = 0
	else
		newTransparency = 1
	end

	for _, v in pairs(character:GetChildren()) do
		if v:IsA("BasePart") then
			v.CastShadow = false
		end
		if CanViewBody then
			if v.Name == "Head" then
				v.LocalTransparencyModifier = newTransparency
				--v.CanCollide = false
				local face = v:FindFirstChildOfClass("Decal")
				if face then
					face.LocalTransparencyModifier = newTransparency
				end
				continue
			end
		else
			if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
				v.LocalTransparencyModifier = newTransparency
				--v.CanCollide = false
				continue
			end
		end
		if v:IsA("Accessory") or v:IsA("Hat") then
			v:FindFirstChild("Handle").LocalTransparencyModifier = newTransparency
			--v:FindFirstChild('Handle').CanCollide = false
		end
	end
end

local cxn1 = nil
local cxn2 = nil
local cxn3 = nil

function camFX.setFirstPerson()
	--local CamPos,TargetCamPos = cam.CFrame.Position,cam.CFrame.Position
	if pausedInfo.Paused then
		return
	end
	if cxn1 or cxn2 or cxn3 then
		return
	end
	-- camrz is never used
	local camrx, camry, _ = Camera.CFrame:ToOrientation()
	local AngleX, TargetAngleX = math.deg(camrx), math.deg(camrx)
	local AngleY, TargetAngleY = math.deg(camry), math.deg(camry)
	Camera.CFrame = character.Head.CFrame

	-- running = true

	bobbingModule.setSensitivity(1)
	updatechar(false)

	local col: Part = character:FindFirstChild("Collision")
	if col then
		col.CanCollide = true
	end

	-- MOVES CAMERA ON PC
	cxn1 = UserInputService.InputChanged:Connect(function(inputObject)
		if inputObject.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = Vector2New(inputObject.Delta.x / Sensitivity, inputObject.Delta.y / Sensitivity) * Smoothness

			local X = TargetAngleX - delta.y
			TargetAngleX = (X >= 80 and 80) or (X <= -80 and -80) or X
			TargetAngleY = (TargetAngleY - delta.x) % 360
		end
	end)

	-- MOVES CAMERA ON MOBILE
	cxn2 = UserInputService.TouchMoved:Connect(function(inputObject, gpe)
		if gpe then
			return
		end

		local delta = Vector2New(inputObject.Delta.x / Sensitivity, inputObject.Delta.y / Sensitivity) * Smoothness * 3

		local X = TargetAngleX - delta.y
		TargetAngleX = (X >= 80 and 80) or (X <= -80 and -80) or X
		TargetAngleY = (TargetAngleY - delta.x) % 360
	end)

	cxn3 = RunService.RenderStepped:Connect(function()
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		character.Humanoid.AutoRotate = false
		--CamPos = CamPos + (TargetCamPos - CamPos) *0.28
		AngleX = AngleX + (TargetAngleX - AngleX) * 1
		local dist = TargetAngleY - AngleY
		dist = mathabs(dist) > 180 and dist - (dist / mathabs(dist)) * 360 or dist
		AngleY = (AngleY + dist * 0.35) % 360
		Camera.CameraType = Enum.CameraType.Scriptable

		Camera.CFrame = CFrameNew(head.Position)
			* CFrameAngles(0, mathrad(AngleY), 0)
			* CFrameAngles(mathrad(AngleX), 0, 0)
			* CFrameNew(0, 0.2, 0) -- offset

		humanoidpart.CFrame = CFrameNew(humanoidpart.Position) * CFrameAngles(0, mathrad(AngleY), 0)
		character.Humanoid.AutoRotate = false
		--if running then
		--	UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
		--	character.Humanoid.AutoRotate = false
		--	--CamPos = CamPos + (TargetCamPos - CamPos) *0.28
		--	AngleX = AngleX + (TargetAngleX - AngleX) *1
		--	local dist = TargetAngleY - AngleY
		--	dist = mathabs(dist) > 180 and dist - (dist / mathabs(dist)) * 360 or dist
		--	AngleY = (AngleY + dist *0.35) %360
		--	cam.CameraType = Enum.CameraType.Scriptable

		--	cam.CFrame = CFrameNew(head.Position)
		--		* CFrameAngles(0,mathrad(AngleY),0)
		--		* CFrameAngles(mathrad(AngleX),0,0)
		--		* CFrameNew(0,0.2,0) -- offset

		--	humanoidpart.CFrame = CFrameNew(humanoidpart.Position)*CFrameAngles(0,mathrad(AngleY),0)
		--	character.Humanoid.AutoRotate = false
		--else
		--	UIS.MouseBehavior = Enum.MouseBehavior.Default; character.Humanoid.AutoRotate = true
		--end

		--if (cam.Focus.Position-cam.CFrame.Position).magnitude < 1 then
		--	running = false
		--else
		--	running = true
		--end
	end)
end

function camFX.setThirdPerson()
	if pausedInfo.Paused then
		return
	end

	if cxn1 then
		cxn1:Disconnect()
		cxn1 = nil
	end
	if cxn2 then
		cxn2:Disconnect()
		cxn2 = nil
	end
	if cxn3 then
		cxn3:Disconnect()
		cxn3 = nil
	end

	-- bring transparency back
	updatechar(true)
	local col: Part = character:FindFirstChild("Collision")
	if col then
		col.CanCollide = false
	end

	bobbingModule.setSensitivity(0.5)

	Camera.CFrame = character.Head.CFrame
	Camera.CameraType = Enum.CameraType.Custom
	Camera.Focus = character.Head.CFrame
	character.Humanoid.AutoRotate = true
	UserInputService.MouseBehavior = Enum.MouseBehavior.Default
end

function camFX.PauseEffects()
	pausedInfo.Paused = true
	bobbingModule.stopBobbing()

	pausedInfo.WasFirstPerson = false

	if cxn1 then
		cxn1:Disconnect()
		cxn1 = nil
		pausedInfo.WasFirstPerson = true
	end
	if cxn2 then
		cxn2:Disconnect()
		cxn2 = nil
		pausedInfo.WasFirstPerson = true
	end
	if cxn3 then
		cxn3:Disconnect()
		cxn3 = nil
		pausedInfo.WasFirstPerson = true
	end

	UserInputService.MouseBehavior = Enum.MouseBehavior.Default
end

function camFX.ResumeEffects()
	pausedInfo.Paused = false
	bobbingModule.startBobbing()
	-- tell area manager to do another check
	eventsModule.FireManualCheckFirstPersonManager()
	--if pausedInfo.WasFirstPerson then
	--	module.setFirstPerson()
	--else
	--	module.setThirdPerson()
	--end
end

----------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------

-- CameraVFXHandler --
--- Dependent on CameraBobbing and CameraVFX

local function setFirstPerson()
	fpv = true

	player:SetAttribute("FirstPerson", true)
	eventsModule.FireResetMouseIcon()
	camFX.setFirstPerson()
end

local function setThirdPerson()
	fpv = false
	player:SetAttribute("FirstPerson", false)
	eventsModule.FireResetMouseIcon()
	camFX.setThirdPerson()
end

local function startBobbing()
	bobbingModule.startBobbing()
end

local function stopBobbing()
	bobbingModule.stopBobbing()
end

-- idk if i will use this
-- UNUSED
-- local function changePOV()
-- 	if fpv then
-- 		setThirdPerson()
-- 	else
-- 		setFirstPerson()
-- 	end
-- end

-- used for cutscenes
local function pauseCameraEffects()
	camFX.PauseEffects()
end

local function resumeCameraEffects()
	camFX.ResumeEffects()
end

eventsModule.ConnectSetFirstPerson(setFirstPerson)
eventsModule.ConnectSetThirdPerson(setThirdPerson)

eventsModule.ConnectSetBobbing(function(enabled: boolean)
	if enabled then
		startBobbing()
	else
		stopBobbing()
	end
end)

eventsModule.ConnectPauseCameraEffects(pauseCameraEffects)
eventsModule.ConnectRemotePauseCameraEffects(pauseCameraEffects)
eventsModule.ConnectResumeCameraEffects(resumeCameraEffects)
eventsModule.ConnectRemoteResumeCameraEffects(resumeCameraEffects)
