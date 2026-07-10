local module = {}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local isStudio = RunService:IsStudio()

local eventsModule = require(script.Parent.CLIENT_EVENTS)
local cutsceneModule = require(ReplicatedStorage.Shared.CutsceneModule)

local player = Players.LocalPlayer
local cam = workspace.CurrentCamera

local CFramenew = CFrame.new

-- CAMERA HANDLER
local cameraCxn = nil
local cameraCxn2 = nil

local MINIGAME_QUEUE = {
	"Snack",
	"Bribe",
	"Frogs.",
	"Cola Addiction",
	"Delusional",
	"Drink",
	"Escaped",
	"McDarndolds",
	"SPEEN",
	"Shedletsky_CHICKEN",
	"Sleep",
}

local function fillMinigameQueue()
	local data = TeleportService:GetLocalPlayerTeleportData()
	if data or isStudio then
		local endingsData = data["EndingOrder"]
		MINIGAME_QUEUE = endingsData
	else
		player:Kick("Teleported without verification.")
	end
end

--fillMinigameQueue()

local function minigameCameraMode()
	cam.CameraType = Enum.CameraType.Scriptable

	if not cameraCxn then
		cameraCxn = RunService.Heartbeat:Connect(function(delta)
			local char = player.Character
			if not char then
				return
			end
			local head = char:FindFirstChild("Head")
			if not head then
				return
			end
			cam.CFrame = CFrame.lookAt(head.Position + Vector3.new(0, 50, 50), head.Position)
		end)
	end
end

local function cameraOnPart(camPart: BasePart)
	cam.CameraType = Enum.CameraType.Scriptable

	if not cameraCxn2 then
		cameraCxn2 = RunService.Heartbeat:Connect(function(delta)
			local char = player.Character
			if not char then
				return
			end
			local head = char:FindFirstChild("Head")
			if not head then
				return
			end
			cam.CFrame = CFrame.lookAt(camPart.Position, head.Position)
		end)
	end
end

local function resetCameraMode1(dontResetToCustom: boolean)
	if cameraCxn then
		cameraCxn:Disconnect()
		cameraCxn = nil
	end

	if not dontResetToCustom then
		cam.CameraType = Enum.CameraType.Custom
	end
end

local function resetCameraMode2()
	if cameraCxn2 then
		cameraCxn2:Disconnect()
		cameraCxn2 = nil
	end
end

local function tpPlayer(cf: CFrame)
	local char = player.Character
	if not char then
		return
	end
	char:PivotTo(cf)
end

local lastDetector = nil
-- local detectorCxns = {}
local detectors_ON = false

local function startCameraHandler()
	if detectors_ON then
		return
	end
	detectors_ON = true

	local detectorFolder = workspace:WaitForChild("MinigameMap").Other.Detectors
	detectorFolder:WaitForChild("EnterBloxGoDetector")
	detectorFolder:WaitForChild("EnterCaveDetector")
	detectorFolder:WaitForChild("EnterRestaurantDetector")
	detectorFolder:WaitForChild("EnterRestaurantSideDetector")
	detectorFolder:WaitForChild("ExitBloxGoDetector")
	detectorFolder:WaitForChild("ExitCaveDetector")
	detectorFolder:WaitForChild("ExitRestaurantSideDetector")
	local detectorChildren = detectorFolder:GetChildren()

	for _, detector in detectorChildren do
		if detector:IsA("BasePart") then
			local overlap_params = OverlapParams.new()
			overlap_params.FilterType = Enum.RaycastFilterType.Exclude
			overlap_params.FilterDescendantsInstances = { detector }
			task.spawn(function()
				while true do
					if detectors_ON == false then
						break
					end
					task.wait(0.1)
					-- print("camera handling")
					local parts_detected = workspace:GetPartsInPart(detector, overlap_params)

					for _, other in parts_detected do
						-- if lastDetector == detector.Name then
						-- 	continue
						-- end
						-- lastDetector = detector.Name

						if not other.Parent then
							continue
						end

						local _player = game:GetService("Players"):GetPlayerFromCharacter(other.Parent)
						if not _player then
							continue
						end

						local cameraPartAttribute = detector:GetAttribute("CameraPart")

						if cameraPartAttribute == "None" then
							resetCameraMode2()
							minigameCameraMode()
						else
							local cameraPart = detectorFolder.Parent.Parent.Cameras:FindFirstChild(cameraPartAttribute)
							if not cameraPart then
								warn("Couldn't find camera part!")
								continue
							end

							resetCameraMode1(true)
							cameraOnPart(cameraPart)
						end
					end
				end
			end)

			-- local newCxn = detector.Touched:Connect(function(other)
			-- 	if lastDetector == detector.Name then
			-- 		return
			-- 	end
			-- 	lastDetector = detector.Name

			-- 	if not other.Parent then
			-- 		return
			-- 	end

			-- 	local player = game:GetService("Players"):GetPlayerFromCharacter(other.Parent)
			-- 	if not player then
			-- 		return
			-- 	end

			-- 	local cameraPartAttribute = detector:GetAttribute("CameraPart")

			-- 	if cameraPartAttribute == "None" then
			-- 		resetCameraMode2()
			-- 		minigameCameraMode()
			-- 	else
			-- 		local cameraPart = detectorFolder.Parent.Parent.Cameras:FindFirstChild(cameraPartAttribute)
			-- 		if not cameraPart then
			-- 			warn("Couldn't find camera part!")
			-- 			return
			-- 		end

			-- 		resetCameraMode1(true)
			-- 		cameraOnPart(cameraPart)
			-- 	end
			-- end)

			-- table.insert(detectorCxns, newCxn)
		end
	end
end

local function stopCameraHandler()
	-- for _, detectorCxn in detectorCxns do
	-- 	detectorCxn:Disconnect()
	-- end
	-- table.clear(detectorCxns)
	detectors_ON = false
end

local minigameGui = player.PlayerGui:WaitForChild("MinigameGui")
local battleGui = player.PlayerGui:WaitForChild("BattleGui")
local objectiveHandler = require(minigameGui.ObjectiveFrame.ObjectiveHandler)
local timerLabel = minigameGui.TimerFrame.TimerLabel

local timerTween1 =
	TweenService:Create(timerLabel, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, true), {
		Rotation = -5,
	})
local timerTween2 =
	TweenService:Create(timerLabel, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, true), {
		Rotation = 5,
	})

local music = SoundService["ERROR 264"]
local originalMusicVolume = SoundService["ERROR 264"].Volume

local musicLowerTween = TweenService:Create(SoundService["ERROR 264"], TweenInfo.new(1), {
	Volume = originalMusicVolume / 2,
})

local musicResetTween = TweenService:Create(SoundService["ERROR 264"], TweenInfo.new(1), {
	Volume = originalMusicVolume,
})

local timerTick1 = SoundService.ClockTick1
local timerTick2 = SoundService.ClockTick2

local onTick2 = false

local function lowerMusic()
	musicLowerTween:Play()
	musicLowerTween.Completed:Wait()
	music.UnderwaterEffect.Enabled = true
end

local function resetMusic()
	musicResetTween:Play()
	musicResetTween.Completed:Wait()
	music.UnderwaterEffect.Enabled = false
end

local function updateTimer(newAmount: number, timerColor: Color3, timerVolume: number)
	timerLabel.Text = tostring(newAmount) .. "s"
	timerLabel.TextColor3 = timerColor
	if onTick2 then
		timerTick2.Volume = timerVolume
		timerTick2:Play()
	else
		timerTick1.Volume = timerVolume
		timerTick1:Play()
	end
	onTick2 = not onTick2
	timerTween1:Play()
	timerTween1.Completed:Wait()
	timerTween2:Play()
end

local function makeAssetsVisible(assets: { Instance })
	for _, asset in assets do
		if asset:IsA("Model") then
			cutsceneModule.setModelTransparency(asset, 0)
			local customModifier = asset:FindFirstChild("CustomChangeVisibility")
			if customModifier and customModifier:IsA("ModuleScript") then
				local customModule = require(customModifier)
				task.spawn(function()
					customModule.makeAppear()
				end)
			end
		end
	end
end

-- HANDLE OBTAINING TROPHY
local fillWhiteHighlight = workspace.FillWhiteHighlight
local blackColorCorrection = game:GetService("Lighting").BLACK

local endingGetSfx = SoundService.SFX.EndingGetSfx
local battleReturnSfx = SoundService.SFX.BattleReturnWithTrophySfx

eventsModule.ConnectObtainedTrophyEffect(function(object: Model, modelName: string, extra)
	print("trophy obtained effect")
	eventsModule.FireDisableMovementEvent(false)
	local char = player.Character
	if not char then
		return
	end
	local head = char:WaitForChild("Head")
	local objectPosition
	if object == nil then
		objectPosition = extra
	else
		objectPosition = object:GetBoundingBox().Position
	end
	stopCameraHandler()
	resetCameraMode1(true)
	resetCameraMode2()
	workspace.CurrentCamera.CFrame = CFrame.new(head.Position, objectPosition)
	if object then
		fillWhiteHighlight.Adornee = object
		fillWhiteHighlight.Enabled = true
	end

	blackColorCorrection.Enabled = true
	music.Volume = 0
	task.wait(2)
	local trophyModel: Model = ReplicatedStorage.TrophyModels[modelName]:Clone()
	trophyModel:PivotTo(CFramenew(objectPosition, head.Position))
	trophyModel.Parent = workspace.MinigameMap

	fillWhiteHighlight.Adornee = trophyModel
	fillWhiteHighlight.Enabled = true

	if object then
		object:Destroy()
	end
	endingGetSfx:Play()
end)

local function stopObtainedTrophyEffect()
	fillWhiteHighlight.Enabled = false
	blackColorCorrection.Enabled = false
end

-- START MINIGAME MAIN
local function startMinigame()
	onTick2 = false
	local endingToGet = table.remove(MINIGAME_QUEUE, 1)
	-- local endingToGet = "Snack"
	task.spawn(lowerMusic)

	-- make only that ending appear on the map
	eventsModule.FireCloneMinigameAssets(endingToGet)
	local waitCloneFinishEvent = ReplicatedStorage.WaitEvents.AssetCloningFinished
	waitCloneFinishEvent.OnClientEvent:Wait()

	local minigameFolder = workspace:WaitForChild("MinigameMap")

	-- make sure they are visible for the player
	local minigameAssetsFolder = workspace:WaitForChild("Assets_Player_" .. tostring(player.UserId))

	eventsModule.FireExitBattleGui()
	eventsModule.FireSmoothTransitionFunction(2)
	eventsModule.FireSetIsCameraRelative(false)
	minigameCameraMode()

	-- tp player to that cframe
	tpPlayer(ReplicatedStorage.Values.MinigameCFrame.Value)

	-- gui to show player which ending to get
	minigameGui.Enabled = true
	battleGui.Enabled = false
	startCameraHandler()
	task.wait(0.5)
	objectiveHandler.ViewObjective("Get the " .. endingToGet .. " ending")
	makeAssetsVisible(minigameAssetsFolder:GetChildren())
end

local function endMinigame(succeeded: boolean, ending: string)
	print("end minigame")
	stopCameraHandler()
	resetMusic()
	eventsModule.FireEndDialogue()
	eventsModule.FireDisableMovementEvent(false)
	eventsModule.FireSmoothTransitionFunction(2)
	stopObtainedTrophyEffect()
	minigameGui.Enabled = false
	eventsModule.FireEnterBattleGui()
	eventsModule.FireSetIsCameraRelative(true)
	eventsModule.FireClearMinigameAssets()
	resetCameraMode1()
	resetCameraMode2()
	local char = player.Character
	if not char then
		return
	end
	char:PivotTo(ReplicatedStorage.Values.ArenaCFrame.Value)
	if succeeded then
		task.wait(1)
		battleReturnSfx:Play()
		-- add the item to inventory, only if authorized
		eventsModule.FireRemoteAddItem(ending)

		eventsModule.FireDisableMovementEvent(true)
	else
		eventsModule.FireDisableMovementEvent(true)
	end
end

eventsModule.ConnectStartMinigame(startMinigame)
ReplicatedStorage.AllClientEvents.EndMinigame.OnClientEvent:Connect(endMinigame)
ReplicatedStorage.AllClientEvents.UpdateTimer.OnClientEvent:Connect(updateTimer)

return module
