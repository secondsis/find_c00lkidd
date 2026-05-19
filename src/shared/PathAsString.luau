local module = {}

--[=[
 Gets the asset Instance from the assetPath string where "." separate items
 @param assetPath string
 @return Instance
]=]
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

--[=[
 Gets the string path of an instance
 @param asset Instance
 @return string
]=]
function module.fetchStringPath(asset: Instance)
	local resultPathReversed: string = asset.Name

	while asset.Parent do
		resultPathReversed ..= "." .. asset.Parent.Name
		asset = asset.Parent
	end

	-- Creating error invalid argument #1 to split because.. resultPathReversed is nil?
	local pathTable: { string } = string.split(resultPathReversed, ".")
	local result = table.remove(pathTable, #pathTable)

	for _ = #pathTable - 1, 0, -1 do
		local nextInstance = table.remove(pathTable, #pathTable)
		result ..= "." .. nextInstance
	end

	return result
end

return module
