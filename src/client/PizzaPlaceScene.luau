local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local eventsModule = require(script.Parent.ClientEventsModule)

local player = players.LocalPlayer

local carSceneEvent = replicatedStorage.RemoteEvents.Cutscenes.PizzaPlace.CarSceneEvent

-- Scene-related
local soundService = game:GetService("SoundService")

local sceneFolder = workspace:WaitForChild("Cutscenes").WorkAtAPizzaPlace

local smackSfx = soundService.SFX.smack
local carSfx = soundService.Ambience["Car idle"]

local cutsceneModule = require(script.Parent.CutsceneModule)
local lightingModule = require(replicatedStorage.Shared.LightingPresets)

local function playScene()
	local char = player.Character
	if not char then
		return
	end
	eventsModule.FireCloneAssetSecurityNone("Maps.Cutscenes.PizzaPlace")
	local storedFolder = replicatedStorage.ClonedFolder:WaitForChild("PizzaPlace")
	local storedCam = storedFolder.Cam.camPart

	for _, v in storedFolder.Replicate:GetChildren() do
		local newInstance = v:Clone()
		newInstance.Parent = sceneFolder
	end

	eventsModule.FireSmoothTransitionFunction(3)
	eventsModule.FireRemoteTeleportPlayerOnServer("PizzaPlace")
	lightingModule.PizzaScene()
	eventsModule.FirePrepareCutscene()

	cutsceneModule.changeCamCFrame(storedCam.CFrame)

	task.wait(3)
	local chatBubble = sceneFolder:WaitForChild("007n7").Head.BillboardGui
	local positions: { BasePart } = storedFolder.c00lkiddPositions:GetChildren()
	local rig: Model = sceneFolder["c00lkidd little"]
	local map = sceneFolder:WaitForChild("pizza place map 1")
	local stop = false

	task.spawn(function()
		local runService = game:GetService("RunService")
		local total = 0
		local heartbeatConnection: RBXScriptConnection
		heartbeatConnection = runService.Heartbeat:Connect(function(delta)
			local amt = 20 * delta
			map:TranslateBy(Vector3.new(0, 0, amt))
			total += amt
			if total >= 250 then
				stop = true
				heartbeatConnection:Disconnect()
			end
		end)
	end)

	task.spawn(function()
		local start = tick()
		while task.wait(1) do
			if start + 10 <= tick() then
				chatBubble.Enabled = true
			end
		end
	end)

	carSfx:Play()

	while task.wait(0.05) do
		local randCFrame = positions[math.random(1, #positions)].CFrame
		if not rig.PrimaryPart then
			continue
		end
		rig.PrimaryPart.CFrame = randCFrame
		smackSfx:Play()
		if stop then
			break
		end
	end
	carSfx:Stop()
	eventsModule.FireSmoothTransitionFunction(2)
	eventsModule.FireRemoteTeleportPlayerOnServer("c00lHouse")
	lightingModule.Default()
	eventsModule.FireFinishCutscene()
	task.wait()

	for _, v in sceneFolder:GetChildren() do
		v:Destroy()
	end
end

carSceneEvent.OnClientEvent:Connect(playScene)

return {}
