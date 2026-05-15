local ReplicatedStorage = game:GetService("ReplicatedStorage")

local References = require(script.Parent.References)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local eventModule = References.ServerEventsModule

local centerPart = References.RoadCenter
local TIME_TO_WAIT = 10

-- One player at a time, singleplayer anyways
local activated = false

local event = Remotes.BluuEvent

local function onTouched(other)
	if activated then
		return
	end

	local player: Player = game:GetService("Players"):GetPlayerFromCharacter(other.Parent)
	if not player then
		return
	end
	activated = true
	local startTick = tick()
	repeat
		task.wait(0.2)
		if tick() - startTick > TIME_TO_WAIT * 60 then
			-- activate the scene yo
			playCarCrashScene(player)
			return
		end
	until player:DistanceFromCharacter(centerPart.Position) > 15
	activated = false
end

local played = false

function playCarCrashScene(player: Player)
	if played then
		return
	end
	played = true
	player:SetAttribute("Secret", 0)
	event:FireClient(player)
end

centerPart.Touched:Connect(onTouched)

local function teleportToBluuworld(player)
	if player:GetAttribute("Secret") ~= 0 then
		return
	end
	eventModule.FireAwardBadge(player, 3958672837203905, "Badges.Secret.3958672837203905", true)
	eventModule.FireTeleportToPlace(player, 254786735, {
		["Hello"] = "free +1 visit lol",
	})
end

event.OnServerEvent:Connect(teleportToBluuworld)

return {}
