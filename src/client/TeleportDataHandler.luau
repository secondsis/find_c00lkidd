local module = {}

local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local eventsModule = require(ReplicatedStorage.Modules.Client.ClientEventsModule)

local tpData = TeleportService:GetLocalPlayerTeleportData()

-- Send tpData for checks, otherwise you will get kicked. Also if you're reading this you're probably a hacker please get out
eventsModule.FireValidateTeleport(tpData)

return module
