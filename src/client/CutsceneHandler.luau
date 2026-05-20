local TweenService = game:GetService("TweenService")
local eventsModule = require(script.Parent.ClientEventsModule)
local cutsceneModule = require(script.Parent.CutsceneModule)
local PathAsString = require(game:GetService("ReplicatedStorage").Shared.PathAsString)

local player = game:GetService("Players").LocalPlayer
local mainGameGui = player.PlayerGui:WaitForChild("MainGameGui")
local wasMainGuiEnabled = false

local IsCutsceneEffectFinished = {
	Camera = false,
	Animations = false,
	Dialogue = false,
}

--[=[
 Prepares the player for a cutscene: Disables the mouse icon, Pauses camera effects, Disables movement, Disables UI
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

--[=[
 [BLOCKING]

 Tweens the camera using keyframes for each segment

 A keyframe has: .TweenInfo (`TweenInfo`), .CFrame (`CFrame`)
 @param keyframes {keyframe}
]=]
local function HandleCamera(startCFrame, keyframes)
	local startTick = tick()
	local camera = workspace.CurrentCamera
	camera.CFrame = startCFrame
	camera.CameraType = Enum.CameraType.Scriptable

	local cameraTweensFinished = {}

	for _, keyframe in keyframes do
		local duration = keyframe.TweenInfo.Duration or 0
		local easingStyle = keyframe.TweenInfo.EasingStyle or Enum.EasingStyle.Linear
		local easingDirection = keyframe.TweenInfo.EasingDirection or Enum.EasingDirection.InOut
		local repeatCount = keyframe.TweenInfo.RepeatCount or 0
		local reverses = keyframe.TweenInfo.Reverses or false
		local delayTime = keyframe.TweenInfo.DelayTime or 0
		local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection, repeatCount, reverses, delayTime)
		local tween = TweenService:Create(camera, tweenInfo, {
			CFrame = keyframe.CFrame,
		})
		local timePosition = keyframe.TimePosition

		while tick() - startTick < timePosition do
			task.wait()
		end

		cameraTweensFinished[tween] = false
		tween:Play()

		tween.Completed:Connect(function(a0: Enum.PlaybackState)
			cameraTweensFinished[tween] = true
		end)
	end

	local function CheckIfCameraFinished()
		for _, val in cameraTweensFinished do
			if val == false then
				return false
			end
		end
		return true
	end

	while not CheckIfCameraFinished() do
		task.wait()
	end

	IsCutsceneEffectFinished.Camera = true
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

--[=[
 [BLOCKING]

 Plays the Animation or Tween in the order and timePosition given by keyframes
 @param keyframes any
]=]
local function HandleAnimations(keyframes)
	local startTick = tick()
	local areAnimationsFinished = {}

	for _, keyframe in keyframes do
		local target = keyframe.Target

		local timePosition = keyframe.TimePosition

		print(keyframe)

		-- Wait until timePosition (Length since start < timePosition)
		while tick() - startTick < timePosition do
			task.wait()
		end

		-- Now at the appropriate timePosition, do the animation
		if type(keyframe.Animation) == "string" then
			-- Treat it as an animationId
			local animationId = keyframe.Animation :: string
			local animation = Instance.new("Animation")
			animation.Name = "Animation " .. animationId
			animation.AnimationId = animationId

			local Animator = nil

			-- Make sure the target has an Animator/AnimationController

			if not target:IsA("Humanoid") then
				local temp = target:FindFirstChildWhichIsA("AnimationController")
				if temp then
					Animator = temp:FindFirstChildWhichIsA("Animator")
				end

				if not Animator then
					local AnimationController = Instance.new("AnimationController")
					Animator = Instance.new("Animator")
					Animator.Parent = AnimationController
					AnimationController.Parent = target
				end
			else
				Animator = target:FindFirstChildWhichIsA("Animator")
				if not Animator then
					Animator = Instance.new("Animator")
					Animator.Parent = target
					Animator.AnimationPlayed:Connect(function(trask)
						print("Playing " .. animationId)
					end)
				end
			end

			local animationTrack = Animator:LoadAnimation(animation)
			print(target)
			areAnimationsFinished[animationTrack] = false

			-- print("Before: ")
			-- print(Animator:GetPlayingAnimationTracks())

			-- -- Stop all other animations, prevent stacking
			-- for _, track: AnimationTrack in Animator:GetPlayingAnimationTracks() do
			-- 	track:Stop()
			-- end

			-- print("After: ")
			-- print(Animator:GetPlayingAnimationTracks())

			animationTrack:Play()
			animationTrack.Stopped:Connect(function()
				print("finished")
				areAnimationsFinished[animationTrack] = true
			end)

			print(areAnimationsFinished)

			if keyframe.EndPosition then
				print("has end pos")
				task.delay(keyframe.EndPosition - keyframe.TimePosition, function()
					print("stopping animation")
					animationTrack:Stop()
				end)
			else
				-- This prevents the last track from running and idk why

				-- animationTrack.Stopped:Wait()
				-- areAnimationsFinished[animationTrack] = true
			end
		else
			-- TweenInfo except I can't have Tweeninfo in my dictionary somehow
			local duration = keyframe.Animation.TweenInfo.Duration or 0
			local easingStyle = keyframe.Animation.TweenInfo.EasingStyle or Enum.EasingStyle.Linear
			local easingDirection = keyframe.Animation.TweenInfo.EasingDirection or Enum.EasingDirection.InOut
			local repeatCount = keyframe.Animation.TweenInfo.RepeatCount or 0
			local reverses = keyframe.Animation.TweenInfo.Reverses or false
			local delayTime = keyframe.Animation.TweenInfo.DelayTime or 0
			local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection, repeatCount, reverses, delayTime)
			-- Treat it as a TweenInfo
			local tween = TweenService:Create(target, tweenInfo, {
				[keyframe.Animation.TweenType] = keyframe.Animation.Value,
			})

			areAnimationsFinished[tween] = false
			tween:Play()
			tween.Completed:Connect(function(playback: Enum.PlaybackState)
				areAnimationsFinished[tween] = true
			end)

			if keyframe.EndPosition then
				task.delay(tick() - startTick, function()
					tween:Cancel()
				end)
			end
		end
	end

	local function CheckIfAnimationFinished()
		for _, val in areAnimationsFinished do
			if val == false then
				return false
			end
		end
		return true
	end

	while not CheckIfAnimationFinished() do
		task.wait()
	end

	print("Finished animations!")
	IsCutsceneEffectFinished.Animations = true
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
--[=[
 Plays the dialogue in the order and time position given by keyframes
 @param keyframes any
]=]
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
		eventsModule.FireWaitForDialogueFinish()
	end

	IsCutsceneEffectFinished.Dialogue = true
end

--[=[
 Handles the client's end of the cutscene: camera, animations, dialogue
 @param cutsceneData any
]=]
local function HandleScene(cutsceneData: any)
	local newMap = game:GetService("ReplicatedStorage").ClonedFolder:WaitForChild(cutsceneData.MapFolderName)
	newMap.Parent = game:GetService("Workspace")
	-- Destroy after use
	--game:GetService("ReplicatedStorage").ClonedFolder:GetChildren()[1]:Destroy()
	cutsceneData.MapFolder = newMap

	local CutsceneAnimationKeyframes = cutsceneData.AnimationKeyframes
	for _, v in CutsceneAnimationKeyframes do
		local animationTarget = v.Target :: string
		--local ServerStorageAsset = PathAsString.fetchStringPath(animationTarget) :: string
		-- Replace "game.ServerStorage.Assets.Security_NONE.Maps.Cutscenes" with "workspace"
		local newPath = "workspace" .. animationTarget:sub(55)
		local newAsset = PathAsString.fetchAsset(newPath)
		v.Target = newAsset
	end

	-- Reset dictionary
	for key, _ in IsCutsceneEffectFinished do
		IsCutsceneEffectFinished[key] = false
	end

	-- Stop the first person from activating
	eventsModule.FirePauseAllAreaManagers()

	task.spawn(HandleCamera, cutsceneData.CameraStartCFrame, cutsceneData.CameraKeyframes)
	task.spawn(HandleAnimations, cutsceneData.AnimationKeyframes)
	task.spawn(HandleDialogue, cutsceneData.DialogueKeyframes)

	-- Wait until all of them are done
	while
		not (
			IsCutsceneEffectFinished.Animations
			and IsCutsceneEffectFinished.Camera
			and IsCutsceneEffectFinished.Dialogue
		)
	do
		task.wait()
	end

	-- Tell the server that this cutscene is over
	eventsModule.FireRemoteFinishedScene()
	eventsModule.FireResumeAllAreaManagers()
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

-- TODO: Unify the game's usage of cutscene functions (Nile scene, Fake Kid, others i frogt)
eventsModule.ConnectFinishCutscene(function()
	eventsModule.FireEnableMouseIcon()
	eventsModule.FireResumeCameraEffects()
	eventsModule.FireDisableMovementEvent(true)
	--cutsceneModule.fadeInPlayer(0) -- Cannot change or it might break old parts of game
end)
eventsModule.ConnectRemoteFinishCutscene(CleanUpCutscene)

return {}
