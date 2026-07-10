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

eventsModule.ConnectPlayerDeath(function()
	player.PlayerGui.TransitionGui.Backup.Visible = true
	eventsModule.FireSmoothTransitionFunction(2)
	cutsceneModule.changeCamCFrame(
		player,
		CFrame.new(3.665, -84.16, -161.031) * CFrame.fromOrientation(math.rad(-4.5), math.rad(90), 0)
	)
	toggleDeathGui(true)
	SoundService.SFX.BattleLost:Play()
	task.wait(1)
	player.PlayerGui.TransitionGui.Backup.Visible = false
end)

continueButton.Activated:Connect(function(a0: InputObject, a1: number)
	toggleDeathGui(false)
	eventsModule.FireSmoothTransitionFunction(999)
	eventsModule.FireRemoteRestartBattle()
end)

return module
