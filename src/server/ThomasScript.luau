local References = require(script.Parent.References)

local eventsModule = References.ServerEventsModule

local playerThomasList = {}

local function subtractThomas(player: Player)
	if not playerThomasList[player.UserId] then
		playerThomasList[player.UserId] = 7
	end
	playerThomasList[player.UserId] -= 1
end

local function getThomasLeft(player: Player)
	return playerThomasList[player.UserId]
end

eventsModule.ConnectGetThomasLeft(getThomasLeft)
eventsModule.ConnectSubtractThomas(subtractThomas)
