local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

local References = require(script.Parent.References)
local eventsModule = References.ServerEventsModule

local gameId = 94246194215637

-- Fetch the code to the reserved Server
local reserveCode
local _, err = pcall(function()
	reserveCode = TeleportService:ReserveServer(gameId)
end)

if err and not RunService:IsStudio() then
	-- TODO: Tell player about problem rejoining
	warn("PROBLEM REJOINING\nSHOW DEVELOPER THIS: " .. err)
end

-- Teleport the player into the reserved server of the game
local function rejoin(player: Player)
	TeleportService:TeleportToPrivateServer(gameId, reserveCode, { player }, nil, { ["QuickStart"] = true })
end

eventsModule.ConnectRejoinEvent(rejoin)

return {}
