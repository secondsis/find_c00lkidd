local tweenService = game:GetService("TweenService")

local rig = game:GetService("Workspace").Important.NPCs.BloxyColaAddict

local prompt = rig:WaitForChild("HumanoidRootPart").ProximityPrompt

local animator = rig.Humanoid.Animator

local idleAnim = Instance.new("Animation")
idleAnim.AnimationId = "rbxassetid://108814395230579"

local talkAnim = Instance.new("Animation")
talkAnim.AnimationId = "rbxassetid://81962985718047"

local idleTrack = animator:LoadAnimation(idleAnim)

local talkTrack = animator:LoadAnimation(talkAnim)

idleTrack:Play()

local eventsModule = require(script.Parent.ClientEventsModule)

local resetTwn = tweenService:Create(rig.HumanoidRootPart, TweenInfo.new(0.5), {
	CFrame = rig.HumanoidRootPart.CFrame,
})

prompt.Triggered:Connect(function(player)
	local playerPos = player.Character.PrimaryPart.Position
	local lookAtCF = CFrame.new(
		rig.HumanoidRootPart.Position,
		Vector3.new(playerPos.X, rig.HumanoidRootPart.Position.Y, playerPos.Z)
	)

	local twn = tweenService:Create(rig.HumanoidRootPart, TweenInfo.new(0.5), {
		CFrame = lookAtCF,
	})
	twn:Play()
	task.wait(0.5)
	talkTrack:Play()
	local endActivated = false
	if player:GetAttribute("Ending") and player:GetAttribute("Ending") == "Cola Addiction" then
		eventsModule.FireDialogueEvent(
			"BloxyColaAddictTalk2",
			{ "fastDialogue", "enableMovementAfter_false", "enablePromptsAfter_false" }
		)
		endActivated = true
	else
		eventsModule.FireDialogueEvent("BloxyColaAddictTalk1")
	end

	while task.wait(0.1) do
		local name = eventsModule.FireCheckSpeakerName(player)
		if name ~= "Bloxy Cola Addict" then
			talkTrack:Stop()
			idleTrack:Play()
			break
		end
	end
	if endActivated then
		local playerNodAnim = Instance.new("Animation")
		playerNodAnim.AnimationId = "rbxassetid://76983502764531"
		local playerAnimator = player.Character.Humanoid:FindFirstChild("Animator")
		if not playerAnimator then
			playerAnimator = Instance.new("Animator")
			playerAnimator.Parent = player.Character.Humanoid
		end

		local playerNodTrack = playerAnimator:LoadAnimation(playerNodAnim)
		playerNodTrack:Play()
		-- nod
		task.wait(1)
		talkTrack:Stop()
		idleTrack:Stop()
		local drinkAnim = Instance.new("Animation")
		drinkAnim.AnimationId = "rbxassetid://123898257933414"
		local drinkTrack = animator:LoadAnimation(drinkAnim)
		eventsModule.FireRemoteRemoveItem()
		eventsModule.FireDialogueFunction(
			"BloxyColaAddictTalk3",
			{ "fastDialogue", "enableMovementAfter_false", "enablePromptsAfter_false" }
		)

		local bloxy = rig["Bloxy Cola"].Handle
		bloxy.Transparency = 0
		for i = 1, 10 do
			local sound = rig.Head["HQ Bloxy Cola Equip Sound"]:Clone()
			sound.Parent = rig.Head
			sound:Play()
			drinkTrack:Play()
			task.wait(0.1)
			if i ~= 10 then
				drinkTrack:Stop()
			end
		end

		for _ = 1, 10 do
			local sound = rig.Head["HQ Bloxy Cola Drink Sound"]:Clone()
			sound.Parent = rig.Head
			sound:Play()
			task.wait(0.1)
		end
		task.wait(4)
		drinkTrack:Stop()
		bloxy:Destroy()
		local tposeAnim = Instance.new("Animation")
		tposeAnim.AnimationId = "rbxassetid://89117014003189"
		local tposeTrack = animator:LoadAnimation(tposeAnim)
		tposeTrack:Play()
		eventsModule.FireDialogueEvent(
			"BloxyColaAddictTalk4",
			{ "fastDialogue", "enableMovementAfter_false", "enablePromptsAfter_false" }
		)
		local offset = Instance.new("Vector3Value")
		offset.Value = Vector3.new()
		local twn = tweenService:Create(offset, TweenInfo.new(20, Enum.EasingStyle.Exponential), {
			Value = Vector3.new(0, 200, 0),
		})
		local offset2 = Instance.new("Vector3Value")
		local vec = Vector3.new
		offset2.Value = vec()
		local ogCF = rig.HumanoidRootPart.CFrame
		game:GetService("RunService").Heartbeat:Connect(function()
			offset2.Value = vec(math.random(), 0, math.random())
			rig.HumanoidRootPart.CFrame = ogCF + offset.Value + offset2.Value
		end)
		task.wait(2)
		task.spawn(function()
			rig.Emitter.Smoke.Enabled = true
			task.wait(1)
			rig.Emitter.Smoke.Enabled = false
		end)
		twn:Play()
		game:GetService("SoundService").SFX["Launching rocket.wav"]:Play()
		task.wait(3)
		eventsModule.FireEndingEvent(
			"Ending: Cola Addiction",
			"These guys are so addicted to bloxy cola like it's IV fluid.",
			"rbxassetid://101150352148849"
		)
		return
	end

	resetTwn:Play()
end)

return {}
