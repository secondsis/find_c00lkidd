local module = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local eventsModule = require(ReplicatedStorage.ServerEventsModule)

local assetRequests = {}

game:GetService("Players").PlayerRemoving:Connect(function(player)
	if assetRequests[player] then
		assetRequests[player] = nil
	end
end)

local function authorizeAsset(player, assetName)
	if not assetRequests[player] then
		assetRequests[player] = {}
	end
	table.insert(assetRequests[player], assetName)
end

local function isAssetAuthorized(player, requestedAssetName)
	if assetRequests[player] and table.find(assetRequests[player], requestedAssetName) then
		return true
	else
		return false
	end
end

eventsModule.ConnectGetIsAssetAuthorized(isAssetAuthorized)
eventsModule.ConnectAuthorizeAsset(authorizeAsset)
return module
