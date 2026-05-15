local eventsModule = require(script.Parent.ClientEventsModule)

local function playTween(tween: Tween)
	tween:Play()
end

eventsModule.ConnectRemoteClientTween(playTween)

return {}
