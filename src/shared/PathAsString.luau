local module = {}

function module.fetchAsset(assetPath: string)
	local assetParents = string.split(assetPath, ".")

	-- game.Whatever
	local asset = game[table.remove(assetParents, 1)]

	while #assetParents > 0 do
		if not asset then
			return nil
		end
		-- game.[].Whatever
		asset = asset[table.remove(assetParents, 1)]
	end

	if not asset then
		return nil
	end

	return asset
end

function module.fetchStringPath(asset: Instance)
	local resultPathReversed = asset.Name

	while asset.Parent do
		resultPathReversed ..= "." .. asset.Parent.Name
		asset = asset.Parent
	end
	resultPathReversed ..= "." .. asset.Name

	return resultPathReversed:reverse()
end

return module
