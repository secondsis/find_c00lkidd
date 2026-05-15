local Players = game:GetService("Players")

local References = require(script.Parent.References)
local eventsMod = References.ServerEventsModule
local activated = false

local JeepSpawnerPart = References.JeepSpawnerPart

JeepSpawnerPart.Touched:Connect(function(other)
	if activated then
		return
	end

	local player = Players:GetPlayerFromCharacter(other.Parent)
	if not player then
		return
	end
	activated = true
	JeepSpawnerPart.BrickColor = BrickColor.Black()
	eventsMod.FireJeepScene(player)
	player:SetAttribute("Ending", "Escaped")
end)
