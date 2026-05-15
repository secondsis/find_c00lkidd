-- ONLY MEANT FOR SINGLEPLAYER / INEFFICIENT SCUFED HECK
local References = require(script.Parent.References)

local eventsModule = References.ServerEventsModule

local totalThomases = 7

local function subtractThomas()
	totalThomases -= 1
end

local function getThomasLeft()
	return totalThomases
end

eventsModule.ConnectGetThomasLeft(getThomasLeft)
eventsModule.ConnectSubtractThomas(subtractThomas)
