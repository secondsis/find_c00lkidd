local cutsceneModule = {}

local tweenService = game:GetService("TweenService")
local eventsModule = require(script.Parent.ClientEventsModule)
local players = game:GetService("Players")
local player = players.LocalPlayer

local originalCamFOV = workspace.CurrentCamera.FieldOfView

-- 0 means visible, 1 means invisible
function cutsceneModule.setModelTransparency(model: Model, transparency: number)
	for _, v in model:GetDescendants() do
		if (v:IsA("BasePart") or v.Name == "face") and v.Name ~= "HumanoidRootPart" then
			v.Transparency = transparency
		end
	end
end

-- Also stops player from moving
function cutsceneModule.fadeOutPlayer(seconds: number)
	local char = player.Character
	if not char then
		return
	end
	eventsModule.FireDisableMovementEvent(false)

	for _, v in pairs(char:GetDescendants()) do
		if v.Name == "Collision" then
			continue
		end
		if v:IsA("BasePart") or v.Name == "face" then
			tweenService:Create(v, TweenInfo.new(seconds), { Transparency = 1 }):Play()
		end
	end
end

-- Also re-enables movement
function cutsceneModule.fadeInPlayer(seconds: number)
	local char = player.Character
	if not char then
		return
	end
	eventsModule.FireDisableMovementEvent(true)
	for _, v in pairs(char:GetDescendants()) do
		if v.Name == "Collision" then
			continue
		end
		if (v:IsA("BasePart") or v.Name == "face") and v.Name ~= "HumanoidRootPart" then
			tweenService:Create(v, TweenInfo.new(seconds), { Transparency = 0 }):Play()
		end
	end
end

function cutsceneModule.changeCamCFrame(newCFrame: CFrame)
	local cam = workspace.CurrentCamera
	cam.CameraType = Enum.CameraType.Scriptable
	cam.CFrame = newCFrame
	eventsModule.FireDisableMovementEvent(false)
end

function cutsceneModule.resetCamOriginal()
	local cam = workspace.CurrentCamera
	cam.CameraType = Enum.CameraType.Custom
	local char = player.Character
	if not char then
		return
	end
	local humanoid = char:FindFirstChild("Humanoid")
	if humanoid then
		cam.CameraSubject = humanoid
		cam.Focus = char.Head.CFrame
		eventsModule.FireDisableMovementEvent(true)
	end
end

function cutsceneModule.resetCam()
	eventsModule.FireResumeCameraEffects()
	eventsModule.FireDisableMovementEvent(true)
end

-- duration in secs
function cutsceneModule.tweenCamCFrame(
	newCFrame: CFrame,
	duration: number,
	fadePlayer: boolean?,
	style: Enum.EasingStyle?,
	direction: Enum.EasingDirection?
)
	fadePlayer = fadePlayer or false
	style = style or Enum.EasingStyle.Sine
	direction = direction or Enum.EasingDirection.Out

	local cam = workspace.CurrentCamera
	cam.CameraType = Enum.CameraType.Scriptable
	local tween = tweenService:Create(cam, TweenInfo.new(duration, style, direction), {
		CFrame = newCFrame,
	})

	tween:Play()

	if fadePlayer then
		cutsceneModule.fadeOutPlayer(1)
	end
end

-- Only works as intended for first-person
function cutsceneModule.tweenResetCam(duration: number, fadePlayer: boolean)
	fadePlayer = fadePlayer or true

	local cam = workspace.CurrentCamera

	local char = player.Character
	local humanoid = char:FindFirstChild("Humanoid")

	if not char and humanoid then
		return
	end

	local tween = tweenService:Create(cam, TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
		CFrame = char.Head.CFrame,
	})

	tween:Play()

	if fadePlayer then
		cutsceneModule.fadeInPlayer(1)
	end

	cam.CameraType = Enum.CameraType.Custom
	cam.CameraSubject = humanoid
	cam.Focus = char.Head.CFrame
end

function cutsceneModule.zoomCam(targetFOV: number, duration: number)
	local cam = workspace.CurrentCamera
	local tween = tweenService:Create(cam, TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
		FieldOfView = targetFOV,
	})
	--local vfxModule = require(replicatedStorage.VFXModule)
	--vfxModule.stopFOVRun()
	tween:Play()
end

function cutsceneModule.resetCamZoom(duration: number?)
	--local vfxModule = require(replicatedStorage.VFXModule)
	--vfxModule.startFOVRun()
	duration = duration or 0
	if not duration then
		return
	end
	cutsceneModule.zoomCam(originalCamFOV, duration)
end

local function getModule()
	return cutsceneModule
end

eventsModule.ConnectGetCutsceneModule(getModule)
eventsModule.ConnectRemoteGetCutsceneModule(getModule)

return cutsceneModule
