local replicatedStorage = game:GetService("ReplicatedStorage")

local eventsModule = require(script.Parent.ClientEventsModule)
local cutsceneModule = require(script.Parent.CutsceneModule)

local function getModule()
	return cutsceneModule
end

eventsModule.ConnectGetCutsceneModule(getModule)
eventsModule.ConnectRemoteGetCutsceneModule(getModule)

-- THIS DOES NOT DO ANYTHING TO CAMERAS.
-- What this DOES do:
-- 		Turns off the mouse icon
--		Disables movement
--		Turns player invisible
eventsModule.ConnectPrepareCutscene(function()
	eventsModule.FireDisableMouseIcon()
	eventsModule.FirePauseCameraEffects()
	eventsModule.FireDisableMovementEvent(false)
	cutsceneModule.fadeOutPlayer(0)
end)

-- If the camera was changed, you must manually set it back.
eventsModule.ConnectFinishCutscene(function()
	eventsModule.FireEnableMouseIcon()
	eventsModule.FireResumeCameraEffects()
	eventsModule.FireDisableMovementEvent(true)
	--cutsceneModule.fadeInPlayer(0)
end)

return {}
