local module = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")

local signalModule = require(ReplicatedStorage.SignalGetter)
local updateBossHealthEvent = signalModule.getRemoteEvent("UpdateBossHealth")
local damageBossEvent = signalModule.getBindableEvent("DamageBoss")
local getBossHealthFunc = signalModule.getBindableFunction("GetBossHealth")
local bossDeathEvent = signalModule.getBindableEvent("BossDeath")

local MAX_BOSS_HEALTH = 100

local BOSS_HEALTH = MAX_BOSS_HEALTH

local NUM_ENDINGS = 12

-- Make it impossible to kill the boss until the player gets the last trophy
local damagePerAttack = BOSS_HEALTH / NUM_ENDINGS

local debounce = false

local function damageBoss()
	if debounce then
		return
	end
	debounce = true

	BOSS_HEALTH -= damagePerAttack
	-- make health updates
	updateBossHealthEvent:FireAllClients(BOSS_HEALTH)
	if BOSS_HEALTH <= 0 then
		bossDeathEvent:Fire()
	end

	task.wait(5)
	debounce = false
end

damageBossEvent.Event:Connect(damageBoss)
getBossHealthFunc.OnInvoke = function()
	return BOSS_HEALTH
end

local function ResetBossHealth()
	BOSS_HEALTH = MAX_BOSS_HEALTH
	updateBossHealthEvent:FireAllClients(BOSS_HEALTH)
end

local eventsModule = require(script.Parent.SERVER_EVENTS)
eventsModule.ConnectRemoteRestartBattle(ResetBossHealth)

return module
