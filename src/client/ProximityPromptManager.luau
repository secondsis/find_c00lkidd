local collectionService = game:GetService("CollectionService")
local eventsModule = require(script.Parent.ClientEventsModule)

local function disable()
	for _, prompt in collectionService:GetTagged("Prompt") do
		prompt.Enabled = false
	end
end

eventsModule.ConnectDisablePrompts(disable)
eventsModule.ConnectRemoteDisablePrompts(disable)

local function enable()
	for _, prompt in collectionService:GetTagged("Prompt") do
		prompt.Enabled = true
	end
end

eventsModule.ConnectEnablePrompts(enable)
eventsModule.ConnectRemoteEnablePrompts(enable)
