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
	local startTick = tick()
	local camera = workspace.CurrentCamera

	for _, keyframe in keyframes do
		local tween = TweenService:Create(camera, keyframe.TweenInfo, {
			CFrame = keyframe.CFrame,
		})
		local timePosition = keyframe.TimePosition

		while tick() - startTick < timePosition do
			task.wait()
		end

		tween:Play()
	end
end

--[[
    AnimationKeyframes = {
        {
            Target = eag,
            Animation = "https://rbxidwhat",
            TimePosition = 0.00 -- Time in seconds
        },
        {

        }
    },
]]
local function HandleAnimations(keyframes)
	local startTick = tick()

	for _, keyframe in keyframes do
		local target = keyframe.Target

		local timePosition = keyframe.TimePosition

		-- Wait until timePosition (Length since start < timePosition)
		while tick() - startTick < timePosition do
			task.wait()
		end

		-- Now at the appropriate timePosition, do the animation
		if type(keyframe.Animation) == "string" then
			-- Treat it as an animationId
			local animationId = keyframe.Animation :: string
			local animation = Instance.new("Animation")
			animation.AnimationId = animationId

			local Animator

			-- Make sure the target has an Animator/AnimationController
			if not target:IsA("Humanoid") and target:FindFirstChildWhichIsA("AnimationController") == nil then
				local AnimationController = Instance.new("AnimationController")

				Animator = Instance.new("Animator")

				Animator.Parent = AnimationController

				AnimationController.Parent = target
			elseif target:IsA("Humanoid") and target:FindFirstChildWhichIsA("Animator") == nil then
				Animator = Instance.new("Animator")
				Animator.Parent = target
			end

			local animationTrack = Animator:LoadAnimation(animation)

			animationTrack:Play()
		else
			-- Treat it as a TweenInfo
			local tween = TweenService:Create(target, keyframe.Animation.TweenInfo, {
				[keyframe.Animation.TweenType] = keyframe.Animation.Value,
			})

			tween:Play()
		end
	end
end

--[[
    DialogueKeyframes = {
        {
            DialogueName = "whatever",
            TimePosition = 0.00
        },
        {
            DialogueName = "wae",
            TimePosition = 10.012
        }
    }
]]
local function HandleDialogue(keyframes)
	local startTick = tick()

	for _, keyframe in keyframes do
		local dialogueName = keyframe.DialogueName
		local timePosition = keyframe.TimePosition

		while tick() - startTick < timePosition do
			task.wait()
		end

		-- Play the dialogue (no player input)
		eventsModule.FireDialogueEvent(dialogueName)
	end
end

local function HandleScene(cutsceneData: any)
	task.spawn(HandleCamera, cutsceneData.CameraKeyframes)
	task.spawn(HandleAnimations, cutsceneData.AnimationKeyframes)
	task.spawn(HandleDialogue, cutsceneData.DialogueKeyframes)
end

eventsModule.ConnectRemotePlayScene(HandleScene)

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
