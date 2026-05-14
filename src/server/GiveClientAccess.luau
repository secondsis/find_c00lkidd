local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local References = require(script.Parent.References)

local eventsModule = References.ServerEventsModule

local assetsFolder = ServerStorage.Assets
local securityNoneFolder = assetsFolder.Security_NONE

local clonedFolder = ReplicatedStorage.ClonedFolder

-- This used to return something but then it just added it to the clonedFolder because variable
-- references don't work across server-client.
local function fetchAsset(player: Player, assetPath: string)
	local assetParents = string.split(assetPath, ".")
	local asset = securityNoneFolder[table.remove(assetParents, 1)]

	while #assetParents > 0 do
		if not asset then
			return nil
		end
		asset = asset[table.remove(assetParents, 1)]
	end

	if not asset then
		return nil
	end

	local newAsset = asset:Clone()
	newAsset.Parent = clonedFolder

	return nil
end

eventsModule.ConnectCloneAssetSecurityNone(fetchAsset)
