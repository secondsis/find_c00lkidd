local eventsModule = require(script.Parent.ClientEventsModule)

local scaryOn = false

local function turnScary()
	scaryOn = true
	local heartbeat = game:GetService("SoundService").SFX.heartbeat
	game:GetService("Lighting").RED.Enabled = true
	eventsModule.FireTurnOffMusic()
	while scaryOn do
		heartbeat:Play()
		heartbeat.Ended:Wait()
	end
end

local function offScary()
	scaryOn = false
	game:GetService("Lighting").RED.Enabled = false
end

eventsModule.ConnectScaryVibe(turnScary)
eventsModule.ConnectRemoteScaryVibe(turnScary)
eventsModule.ConnectOffScaryVibe(offScary)
eventsModule.ConnectRemoteOffScaryVibe(offScary)

return {}
