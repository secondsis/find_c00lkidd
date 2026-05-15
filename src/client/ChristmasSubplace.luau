local teleportService = game:GetService("TeleportService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

local CHRISTMAS_SUBPLACE_ID = 96606152723450

local christmasEvent = replicatedStorage:WaitForChild("RemoteEvents").Cutscenes.Christmas.ChristmasEvent

local function tpToThePast()
	teleportService:Teleport(CHRISTMAS_SUBPLACE_ID, players.LocalPlayer, {
		Scenes = "Christmas",
	})
end

christmasEvent.OnClientEvent:Connect(tpToThePast)
