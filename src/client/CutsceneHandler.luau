local TweenService = game:GetService("TweenService")
local eventsModule = require(script.Parent.ClientEventsModule)
local cutsceneModule = require(script.Parent.CutsceneModule)

local player = game:GetService("Players").LocalPlayer
local mainGameGui = player.PlayerGui:WaitForChild("MainGameGui")
local wasMainGuiEnabled = false

--[=[
 Prepares the player for a cutscene: Disables the mouse icon, Pauses camera effects, Disables movement,
 Makes player character invisible
]=]
local function PrepareCutscene()
	eventsModule.FireDisableMouseIcon()
	eventsModule.FirePauseCameraEffects()
	eventsModule.FireDisableMovementEvent(false)
	cutsceneModule.fadeOutPlayer(0)
	-- Disable UI
	wasMainGuiEnabled = mainGameGui.Enabled
	mainGameGui.Enabled = false
end

eventsModule.ConnectPrepareCutscene(PrepareCutscene)
eventsModule.ConnectRemotePrepareCutscene(PrepareCutscene)

--function TweenInfo.new(time: number?, easingStyle: Enum.EasingStyle?, easingDirection: Enum.EasingDirection?, repeatCount: number?, reverses: boolean?, delayTime: number?): TweenInfo
-- A keyframe has a duration, Enum.EasingStyle, Enum.EasingDirection,
-- A keyframe is basically a TweenInfo
--[=[
 [BLOCKING]

 Tweens the camera using keyframes for each segment

 A keyframe has: .TweenInfo (`TweenInfo`), .CFrame (`CFrame`)
 @param keyframes {keyframe}
]=]
local function HandleCamera(keyframes)
	local camera = workspace.CurrentCamera

	for _, keyframe in keyframes do
		local tween = TweenService:Create(camera, keyframe.TweenInfo, {
			CFrame = keyframe.CFrame,
		})

		tween:Play()
		tween.Completed:Wait()
	end
end

local function HandleAnimations(keyframes)
	keyframes = {}
	-- Let's say you want to animate the character and jeep
	-- Need a reference to character and jeep
	--
end

--[=[
 Resets the player's perspective after a cutscene: 
 Enables mouse icon, 
 Resumes camera effects,
 Enables player movement,
 Makes player character visible
]=]
local function CleanUpCutscene()
	eventsModule.FireEnableMouseIcon()
	eventsModule.FireResumeCameraEffects()
	eventsModule.FireDisableMovementEvent(true)
	cutsceneModule.fadeInPlayer(0)
	if wasMainGuiEnabled then
		mainGameGui.Enabled = true
	end
end

-- TODO: Unify the game's usage of cutscene functions
eventsModule.ConnectFinishCutscene(function()
	eventsModule.FireEnableMouseIcon()
	eventsModule.FireResumeCameraEffects()
	eventsModule.FireDisableMovementEvent(true)
	--cutsceneModule.fadeInPlayer(0) -- Cannot change or it might break old parts of game
end)
eventsModule.ConnectRemoteFinishCutscene(CleanUpCutscene)

return {}
