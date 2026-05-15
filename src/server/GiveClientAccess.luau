local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local References = require(script.Parent.References)

local eventsModule = References.ServerEventsModule

local assetsFolder = ServerStorage.Assets
local securityNoneFolder = assetsFolder.Security_NONE

local clonedFolder = ReplicatedStorage.ClonedFolder

--[=[
 Clones an object from `ServerStorage.Assets.Security_NONE.[assetPath]` into the client's `ReplicatedStorage.ClonedFolder`
 
 This can be used on the server to clone objects that the client cannot normally access

 `assetPath` should include "." to separate levels of hierarchy

 Issue: Security problem if the server fetches an asset inappropriately, gives access to ALL clients
 @param player Player
 @param assetPath string
]=]
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

return {}
