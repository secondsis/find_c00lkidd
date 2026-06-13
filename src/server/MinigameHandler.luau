local module = {}
-- This handles the timer so exploiters cant cheat the time limit

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local eventsModule = require(ReplicatedStorage.ServerEventsModule)
local signalModule = require(ReplicatedStorage.SignalGetter)

local minigameEndedBindableEvent = signalModule.getBindableEvent("MinigameEnded")

--[[
	McDarndolds
	Rig?
	Delusional
	SPEEN
	Escaped
	Drink
	Snack
	Bribe
	Frogs.
	Cola Addiction
	Shedletsky
	Sleep
	NileGreen
]]
local timePerEnding = {
	["McDarndolds"] = 30,
	["Rig?"] = 30,
	["Delusional"] = 100,
	["SPEEN"] = 30,
	["Escaped"] = 30,
	["Drink"] = 30,
	["Snack"] = 30,
	["Bribe"] = 30,
	["Frogs."] = 30,
	["Cola Addiction"] = 30,
	["Shedletsky"] = 30,
	["Sleep"] = 30,
	["NileGreen"] = 30,
}

local updateTimerEvent = ReplicatedStorage.AllClientEvents.UpdateTimer

local function lerpColor(color1: Color3, color2: Color3, t: number)
	return Color3.new(
		color1.R + (color2.R - color1.R) * t,
		color1.G + (color2.G - color1.G) * t,
		color1.B + (color2.B - color1.B) * t
	)
end

local function lerp(number1: number, number2: number, t: number)
	return number1 + (number2 - number1) * (1 - t)
end

local minigameMap = ServerStorage.MinigameMap
local finishedEarly = false

-- ONLY FOR SINGLEPLAYER
local function finishMinigameEarly(ending: string)
	eventsModule.FireResumeBattle()
	for _, player in Players:GetPlayers() do
		eventsModule.FireRemoveItem(player)
		eventsModule.FireAuthorizeAsset(player, ending)
	end

	ReplicatedStorage.AllClientEvents.EndMinigame:FireAllClients(true, ending)
	minigameEndedBindableEvent:Fire()
	task.wait(3)
	local map = workspace:FindFirstChild(minigameMap.Name)
	if map then
		map:Destroy()
	end
end

local function startMinigame(ending: string)
	local newMap = minigameMap:Clone()
	newMap.Parent = workspace
	-- let the transition happen
	task.wait(1)
	-- after transition start
	local startTick = tick()
	local alottedTime = timePerEnding[ending]
	local timeLeft = alottedTime
	local endTick = startTick + alottedTime

	while endTick > tick() do
		task.wait()
		if finishedEarly then
			finishedEarly = false
			return
		end
		local newTimeLeft = math.round(endTick - tick())
		if newTimeLeft ~= timeLeft then
			timeLeft = newTimeLeft
			-- tell clients to change their numbers
			local newTimerColor = lerpColor(Color3.new(1, 0, 0), Color3.new(0, 1, 0), timeLeft / alottedTime)
			local newTimerVolume = lerp(0.05, 0.5, timeLeft / alottedTime)
			updateTimerEvent:FireAllClients(timeLeft, newTimerColor, newTimerVolume)
		end
	end

	if finishedEarly then
		print("wow u got a frame perfect finish before u lost")
		finishedEarly = false
		return
	end
	-- TELEPORT THEM ALL BACK TO ARENA
	--for _, player in Players:GetPlayers() do
	--	local char = player.Character
	--	if not char then return end
	--	char:PivotTo(workspace.BattleArena.ArenaTPPart.CFrame)
	--end

	eventsModule.FireResumeBattle()
	for _, player in Players:GetPlayers() do
		eventsModule.FireRemoteDisablePrompts(player)
		eventsModule.FireRemoveItem(player)
	end

	ReplicatedStorage.AllClientEvents.EndMinigame:FireAllClients()
	minigameEndedBindableEvent:Fire()
	task.wait(3)
	newMap:Destroy()
end

-- ONLY SINGLEPLAYER
local function pauseTimer()
	finishedEarly = true
end

eventsModule.ConnectStartMinigameServerCheck(startMinigame)
eventsModule.ConnectFinishMinigameEarly(finishMinigameEarly)

local signalModule = require(ReplicatedStorage.SignalGetter)
local pauseEvent = signalModule.getBindableEvent("PauseMinigameTimer")

pauseEvent.Event:Connect(pauseTimer)
return module
