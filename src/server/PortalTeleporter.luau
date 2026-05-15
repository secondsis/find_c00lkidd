local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local References = require(script.Parent.References)

local END_GAME_ID = 100980384697456

local part = References.CavePortal

part.Touched:Connect(function(other)
	local player = Players:GetPlayerFromCharacter(other.Parent)
	if not player then
		return
	end

	TeleportService:Teleport(END_GAME_ID, player)
end)
