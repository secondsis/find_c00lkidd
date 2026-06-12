task.wait(0.5)

-- SERVICES
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local soundService = game:GetService("SoundService")
local tweenService = game:GetService("TweenService")

local eventsModule = require(script.Parent.ClientEventsModule)

local objectValues = replicatedStorage:WaitForChild("Values").ObjectValues

local c00lhouseDetector = objectValues:WaitForChild("c00lhouseDetector")
local caveDetector = objectValues:WaitForChild("CaveDetector")
local shopDetector = objectValues:WaitForChild("ShopDetector")
local restaurantDetector = objectValues:WaitForChild("RestaurantDetector")
local mapDetector = objectValues:WaitForChild("MapDetector")
local introHouseDetector = objectValues:WaitForChild("IntroHouseDetector")

local detectors = {
	c00lhouseDetector,
	caveDetector,
	shopDetector,
	restaurantDetector,
	mapDetector,
	introHouseDetector,
}

local overlapParams = OverlapParams.new()
overlapParams.CollisionGroup = "PlayerDetectors"

local PauseManagers = {
	FirstPersonManager = false,
	SoundAreaManager = false,
	HouseMirrorManager = false,
	SprintingManager = false,
}

local player = players.LocalPlayer

local playerIsIn = {}

for _, detector in detectors do
	playerIsIn[detector.Name] = false
end

-- local function CheckManagers()
-- 	while task.wait(3) do
-- 		print(PauseManagers)
-- 	end
-- end

-- task.spawn(CheckManagers)

-- dont set the tweens to have an area with no music
local function detectPlayerBase(detectorPartValue: ObjectValue, callbackIfPlayer: () -> ())
	local detectorObject = detectorPartValue.Value
	if not detectorObject then
		-- Sometimes the object isn't loaded.
		return false
	end

	local detectorParts
	if detectorObject:IsA("Model") then
		detectorParts = detectorObject:GetDescendants()
	else
		detectorParts = { detectorObject }
	end

	for _, detectorPart in detectorParts do
		-- First, check if player is in range so if it's even possible they can be close.
		local dist = player:DistanceFromCharacter(detectorPart.Position)
		local detectorPartSize = detectorPart.Size

		local maxWidth = math.max(detectorPartSize.X, detectorPartSize.Y, detectorPartSize.Z)
		local checkDist = maxWidth * 1.4143
		if dist > checkDist then
			continue
		end

		local parts = workspace:GetPartBoundsInBox(detectorPart.CFrame, detectorPart.Size, overlapParams)
		for _, v in parts do
			local foundPlayer = players:GetPlayerFromCharacter(v.Parent)
			if foundPlayer and foundPlayer == player then
				if callbackIfPlayer then
					callbackIfPlayer()
				end

				return true
			end
		end
	end
	return false
end

-- Set secondaryUse to true if this is already called in a more frequent detection rate
local function detectPlayer(detectorPartValue: ObjectValue, callbackIfPlayer: () -> (), secondaryUse: boolean?)
	if secondaryUse then
		local foundPlayer = playerIsIn[detectorPartValue.Name]
		if foundPlayer and callbackIfPlayer then
			callbackIfPlayer()
		end

		return foundPlayer
	end
	local foundPlayer = detectPlayerBase(detectorPartValue, callbackIfPlayer)
	playerIsIn[detectorPartValue.Name] = foundPlayer
	return foundPlayer
end

-- Functions

-- First Person Variables/Funcs
--local originalMinZoom = player.CameraMinZoomDistance
--local originalMaxZoom = player.CameraMaxZoomDistance

local lockedInFirst = false

local function lockFirstPerson()
	lockedInFirst = true
	--player.CameraMinZoomDistance = 0.5
	--player.CameraMaxZoomDistance = 0.5
	--player.CameraMode = Enum.CameraMode.LockFirstPerson
	eventsModule.FireSetFirstPerson()

	--UIS.MouseIconEnabled = false
end

local function lockThirdPerson()
	lockedInFirst = false
	--player.CameraMode = Enum.CameraMode.Classic
	--player.CameraMaxZoomDistance = originalMaxZoom
	--player.CameraMinZoomDistance = originalMinZoom
	eventsModule.FireSetThirdPerson()

	--UIS.MouseIconEnabled = true
end

local function firstPersonCallbackIfPlayer()
	-- Lock in first person
	if not lockedInFirst then
		lockFirstPerson()
	end
	--if not UIS.MouseIconEnabled and player:GetAttribute("MouseIconOverride") then
	--	UIS.MouseIconEnabled = true
	--elseif UIS.MouseIconEnabled and not player:GetAttribute("MouseIconOverride") then
	--	UIS.MouseIconEnabled = false
	--end
end

local function firstPersonManager()
	if detectPlayer(c00lhouseDetector, firstPersonCallbackIfPlayer) then
		return
	end

	if detectPlayer(caveDetector, firstPersonCallbackIfPlayer) then
		return
	end

	if not player:GetAttribute("LockFPOverride") then
		if lockedInFirst then
			lockThirdPerson()
		end
	else
		if not lockedInFirst then
			lockFirstPerson()
		end
	end
end

-- HouseMirror Variables
local mirrorGui = player.PlayerGui:WaitForChild("mirrorGui")

local function enableMirrors()
	if mirrorGui.Enabled then
		return
	end

	eventsModule.FireEnableHouseMirrors()
end

local function disableMirrors()
	if not mirrorGui.Enabled then
		return
	end

	eventsModule.FireDisableHouseMirrors()
end

-- SoundArea Variables
local musicGroup = soundService:WaitForChild("Music")
local shopMusic = musicGroup:WaitForChild("ShopMusic")
local normalMusic = musicGroup:WaitForChild("ChillJazz")
local restaurantMusic = musicGroup:WaitForChild("Convenience Store")

local tweenInfo = TweenInfo.new(1)

local normalMusicIn = tweenService:Create(normalMusic, tweenInfo, {
	Volume = normalMusic.Volume,
})

local normalMusicOut = tweenService:Create(normalMusic, tweenInfo, {
	Volume = 0,
})

local shopMusicIn = tweenService:Create(shopMusic, tweenInfo, {
	Volume = shopMusic.Volume,
})

local shopMusicOut = tweenService:Create(shopMusic, tweenInfo, {
	Volume = 0,
})

local restaurantMusicIn = tweenService:Create(restaurantMusic, tweenInfo, {
	Volume = restaurantMusic.Volume,
})

local restaurantMusicOut = tweenService:Create(restaurantMusic, tweenInfo, {
	Volume = 0,
})

local musicTweens = {
	["Normal"] = { normalMusicIn, normalMusicOut },
	["Shop"] = { shopMusicIn, shopMusicOut },
	["Restaurant"] = { restaurantMusicIn, restaurantMusicOut },
}

local outMusics = {
	normalMusicOut,
	shopMusicOut,
	restaurantMusicOut,
}

local function playOutTweens()
	for _, outTween in outMusics do
		outTween:Play()
	end
end

local function soundAreaCallbackIfPlayer(music: string)
	local tweenIn = musicTweens[music][1]
	local tweenOut = musicTweens[music][2]

	tweenIn:Play()

	for _, outTween in outMusics do
		if outTween ~= tweenOut then
			outTween:Play()
		end
	end
end

local function soundAreaNormalCallbackIfPlayer()
	soundAreaCallbackIfPlayer("Normal")
end

local function soundAreaShopCallbackIfPlayer()
	soundAreaCallbackIfPlayer("Shop")
end

local function soundAreaRestaurantCallbackIfPlayer()
	soundAreaCallbackIfPlayer("Restaurant")
end

-- Sprinting Area Variables/Funcs
local canSprint = true

local function enableSprinting()
	canSprint = true
	eventsModule.FireSetCanSprintEvent(true)
end

local function disableSprinting()
	canSprint = false
	eventsModule.FireSetCanSprintEvent(false)
end

local function sprintingAreaCallbackIfPlayer()
	if canSprint then
		disableSprinting()
	end
end

local function PauseAreaManager(manager: string)
	PauseManagers[manager] = true
end

local function ResumeAreaManager(manager: string)
	PauseManagers[manager] = false
end

local function PauseAllAreaManagers()
	for name, _ in PauseManagers do
		PauseManagers[name] = true
	end
end

local function ResumeAllAreaManagers()
	for name, _ in PauseManagers do
		PauseManagers[name] = false
	end
end

--- Detects first person every .2 sec
local function FirstPersonManagerRunner()
	while task.wait(0.1) do
		repeat
			task.wait(0.2)

			-- FIRST PERSON MANAGER
			task.spawn(firstPersonManager)

		until PauseManagers["FirstPersonManager"]
	end
end

local function SoundAreaManagerRunner()
	while task.wait(0.1) do
		repeat
			task.wait(0.5)
			if detectPlayer(c00lhouseDetector, playOutTweens, true) then
				continue
			end

			if detectPlayer(caveDetector, playOutTweens, true) then
				continue
			end

			if detectPlayer(shopDetector, soundAreaShopCallbackIfPlayer) then
				continue
			end

			if detectPlayer(restaurantDetector, soundAreaRestaurantCallbackIfPlayer) then
				continue
			end

			if detectPlayer(mapDetector, soundAreaNormalCallbackIfPlayer) then
				continue
			end
		until PauseManagers["SoundAreaManager"]
	end
end

local function SprintingAreaManagerRunner()
	while task.wait(0.1) do
		repeat
			task.wait(0.5)
			-- SPRINTING AREA MANAGER

			-- These are the areas where sprinting is disabled.

			if detectPlayer(introHouseDetector, sprintingAreaCallbackIfPlayer) then
				continue
			end
			if detectPlayer(c00lhouseDetector, sprintingAreaCallbackIfPlayer, true) then
				continue
			end
			if detectPlayer(caveDetector, sprintingAreaCallbackIfPlayer, true) then
				continue
			end

			if not canSprint then
				enableSprinting()
			end

		until PauseManagers["SprintingManager"]
	end
end

local function HouseMirrorManagerRunner()
	while task.wait(0.1) do
		repeat
			task.wait(1)

			-- HOUSE MIRROR AREA MANAGER
			if detectPlayer(c00lhouseDetector, nil, true) then
				enableMirrors()
			else
				disableMirrors()
			end
		until PauseManagers["HouseMirrorManager"]
	end
end

local function manualFirstPersonManager()
	local function callback()
		eventsModule.FireSetFirstPerson()
	end
	if detectPlayer(c00lhouseDetector, callback) then
		return
	end

	if detectPlayer(caveDetector, callback) then
		return
	end

	if not player:GetAttribute("LockFPOverride") then
		eventsModule.FireSetThirdPerson()
	else
		eventsModule.FireSetFirstPerson()
	end
end

local module = {}

function module.RunAllManagers()
	task.spawn(FirstPersonManagerRunner)
	task.spawn(SoundAreaManagerRunner)
	task.spawn(SprintingAreaManagerRunner)
	task.spawn(HouseMirrorManagerRunner)
end

eventsModule.ConnectManualCheckFirstPersonManager(manualFirstPersonManager)
eventsModule.ConnectPauseAreaManager(PauseAreaManager)
eventsModule.ConnectResumeAreaManager(ResumeAreaManager)
eventsModule.ConnectPauseAllAreaManagers(PauseAllAreaManagers)
eventsModule.ConnectResumeAllAreaManagers(ResumeAllAreaManagers)

module.RunAllManagers()

return module
