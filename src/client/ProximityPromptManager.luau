local module = {}

local collectionService = game:GetService("CollectionService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local eventsModule = require(replicatedStorage.Modules.Client.ClientEventsModule)

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

return module
