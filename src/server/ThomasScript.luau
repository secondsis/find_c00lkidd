local References = require(script.Parent.References)

local eventsModule = References.ServerEventsModule

local playerThomasList = {}

--[=[
 Subtracts a Thomas Remaining from a player, and keeps track between players
 @param player -- The player who found a Thomas
]=]
local function subtractThomas(player: Player)
	if not playerThomasList[player.UserId] then
		playerThomasList[player.UserId] = 7
	end
	playerThomasList[player.UserId] -= 1
	if playerThomasList[player.UserId] == 0 then
		player:SetAttribute("Ending", "Thomas")
		eventsModule.FireRemoteEndingEvent(
			player,
			"Ending: Thomas",
			"why does this cursed version of thomas exist (yes it's the tank engine)"
		)
	end
end

--[=[
 Returns the number of Thomas Remaining
 @param player -- The player to check
 @return number
]=]
local function getThomasLeft(player: Player)
	return playerThomasList[player.UserId]
end

-- Connect to remotes
eventsModule.ConnectGetThomasLeft(getThomasLeft)
eventsModule.ConnectSubtractThomas(subtractThomas)

return {}
