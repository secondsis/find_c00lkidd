local module = {}

local replicatedStorage = game:GetService("ReplicatedStorage")
local soundService = game:GetService("SoundService")
local eventsModule = require(replicatedStorage.Modules.Client.ClientEventsModule)

local explosionSFX = soundService.SFX.explosion_classic
local explosion = Instance.new("Explosion")
explosion.DestroyJointRadiusPercent = 0
explosion.BlastRadius = 0

local function spawnExplosion(pos: Vector3)
	local copy = explosion:Clone()
	copy.Position = pos
	copy.Parent = workspace
	explosionSFX:Play()
end

eventsModule.ConnectSpawnExplosion(spawnExplosion)
eventsModule.ConnectRemoteSpawnClientExplosion(spawnExplosion)

return module
