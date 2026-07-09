local module = {}

local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local eventsModule = require(ReplicatedStorage.Modules.Client.ClientEventsModule)

local tpData = TeleportService:GetLocalPlayerTeleportData()

-- Send tpData for checks, otherwise you will get kicked -- timeout of 30s
eventsModule.FireVerifyTeleport(tpData)

return module
