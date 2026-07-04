local cutsceneModule = {}

local tweenService = game:GetService("TweenService")

local originalCamFOV = workspace.CurrentCamera.FieldOfView

-- 0 means visible, 1 means invisible
function cutsceneModule.setModelTransparency(model: Model, transparency: number)
	for i, v in model:GetDescendants() do
		if (v:IsA("BasePart") or v.Name == "face" or v:IsA("Decal")) and v.Name ~= "HumanoidRootPart" then
			if v:GetAttribute("IgnoreTransparencyChange") then
				continue
			end
			v.Transparency = transparency
		end
	end
end

function cutsceneModule.tweenModelTransparency(
	model: Model,
	transparency: number,
	seconds: number,
	exclusions: { string }?
)
	for _, v in model:GetDescendants() do
		if exclusions and table.find(exclusions, v.Name) then
			continue
		end
		if v:IsA("BasePart") or v:IsA("Decal") then
			tweenService:Create(v, TweenInfo.new(seconds), { Transparency = transparency }):Play()
		end
	end
end

-- Also stops player from moving
function cutsceneModule.fadeOutPlayer(player, seconds: number)
	local char = player.Character
	if not char then
		return
	end
	local eventsModule = require(player.PlayerScripts:WaitForChild("Client"):WaitForChild("CLIENT_EVENTS"))
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
function cutsceneModule.fadeInPlayer(player, seconds: number)
	local char = player.Character
	if not char then
		return
	end
	local eventsModule = require(player.PlayerScripts:WaitForChild("Client"):WaitForChild("CLIENT_EVENTS"))
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

function cutsceneModule.changeCamCFrame(player, newCFrame: CFrame)
	local cam = workspace.CurrentCamera
	cam.CameraType = Enum.CameraType.Scriptable
	cam.CFrame = newCFrame
	local eventsModule = require(player.PlayerScripts:WaitForChild("Client"):WaitForChild("CLIENT_EVENTS"))
	eventsModule.FireDisableMovementEvent(false)
end

function cutsceneModule.resetCamOriginal(player)
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
		local eventsModule = require(player.PlayerScripts:WaitForChild("Client"):WaitForChild("CLIENT_EVENTS"))
		eventsModule.FireDisableMovementEvent(true)
	end
end

function cutsceneModule.resetCam(player)
	local eventsModule = require(player.PlayerScripts:WaitForChild("Client"):WaitForChild("CLIENT_EVENTS"))
	eventsModule.FireDisableMovementEvent(true)
end

--[[ 
CLIENT-ONLY, duration in seconds
]]
function cutsceneModule.tweenCamCFrame(
	newCFrame: CFrame,
	duration: number,
	fadePlayer: boolean,
	style: Enum.EasingStyle,
	direction: Enum.EasingDirection
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
		local player = game:GetService("Players").LocalPlayer
		cutsceneModule.fadeOutPlayer(player, 1)
	end
end

-- Only works as intended for first-person
function cutsceneModule.tweenResetCam(player, duration: number, fadePlayer: boolean)
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
		cutsceneModule.fadeInPlayer(player, 1)
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

function cutsceneModule.resetCamZoom(duration: number)
	--local vfxModule = require(replicatedStorage.VFXModule)
	--vfxModule.startFOVRun()
	duration = duration or 0
	cutsceneModule.zoomCam(originalCamFOV, duration)
end

function cutsceneModule.GetAnimationTrackForBody(model: Model, animationId: string): AnimationTrack
	local animation = Instance.new("Animation")
	animation.AnimationId = "rbxassetid://" .. animationId

	local humanoid = model:FindFirstChildOfClass("Humanoid")
	local animator
	if humanoid then
		animator = humanoid:FindFirstChildOfClass("Animator")
		if not animator then
			animator = Instance.new("Animator")
			animator.Parent = humanoid
		end
	else
		local animationController = model:FindFirstChildOfClass("AnimationController")
		if not animationController then
			animationController = Instance.new("AnimationController")
			animationController.Parent = model
		end

		animator = animationController:FindFirstChildOfClass("Animator")
		if not animator then
			animator = Instance.new("Animator")
			animator.Parent = animationController
		end
	end

	if not animator then
		return nil
	end

	local animationTrack = nil

	local succ, err = pcall(function(...)
		animationTrack = animator:LoadAnimation(animation)
	end)

	if err then
		warn(err)
	end

	return animationTrack
end

return cutsceneModule
