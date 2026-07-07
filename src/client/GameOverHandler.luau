local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local eventsModule = require(script.Parent.CLIENT_EVENTS)
local cutsceneModule = require(ReplicatedStorage.Shared.CutsceneModule)
local SignalGetter = require(ReplicatedStorage.SignalGetter)

local deathGui = player.PlayerGui:WaitForChild("GameOverGui")
local continueButton: TextButton = deathGui.Frame.TextButton

local function toggleDeathGui(enabled: boolean)
	deathGui.Enabled = enabled
end

eventsModule.ConnectRemotePlayerDeath(function()
	toggleDeathGui(true)
end)

continueButton.Activated:Connect(function(a0: InputObject, a1: number)
	toggleDeathGui(false)
	eventsModule.FireRemoteRestartBattle()
end)

return module
