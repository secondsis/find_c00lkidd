local module = {}
local ServerStorage = game:GetService("ServerStorage")
local eventsModule = require(game:GetService("ReplicatedStorage").ServerEventsModule)

local function addItem(player, name: string)
	local backpackItems = player.Backpack:GetChildren()
	local char = player.Character
	if not char then
		return false
	end
	local currentItem = char:FindFirstChildOfClass("Tool")
	if currentItem or #backpackItems >= 1 then
		-- can only have one item
		eventsModule.FireRemoteNotifyInventoryFull(player)
		return false
	end

	local tool = ServerStorage.Tools[name]:Clone()
	if tool:GetAttribute("Trophy") then
		eventsModule.FireRemoteAddItem(player, name, true)
	else
		eventsModule.FireRemoteAddItem(player, name)
	end

	tool.Parent = player.Backpack
	return true
end

local function getItem(player)
	local backpackItems = player.Backpack:GetChildren()
	local char = player.Character
	if not char then
		return nil
	end
	local currentItem = char:FindFirstChildOfClass("Tool")
	if currentItem == nil and #backpackItems == 0 then
		return nil
	end
	return currentItem or backpackItems[1]
end

local function deleteItem(player: Player)
	local backpackItems = player.Backpack:GetChildren()
	local char = player.Character
	if not char then
		return false
	end

	local currentItem = char:FindFirstChildOfClass("Tool")
	if currentItem == nil and #backpackItems == 0 then
		--eventsModule.FireRemoteNotifyNoItems(player)
		return false
	end

	if currentItem then
		currentItem:Destroy()
	else
		backpackItems[1]:Destroy()
	end
	return true
end

local function trashItem(player)
	local wasDeleted = deleteItem(player)
	if wasDeleted then
		eventsModule.FireRemoteTrashItem(player)
	end
end

local function removeItem(player)
	deleteItem(player)
	eventsModule.FireRemoteRemoveItem(player)
end

eventsModule.ConnectRemoteTrashItem(trashItem)
eventsModule.ConnectTrashItem(trashItem)

eventsModule.ConnectRemoteRemoveItem(removeItem)
eventsModule.ConnectRemoveItem(removeItem)

eventsModule.ConnectAddItem(addItem)
eventsModule.ConnectRemoteAddItem(function(player, name)
	local isAuthorized = eventsModule.FireGetIsAssetAuthorized(player, name)
	if isAuthorized then
		addItem(player, name)
	end
end)

eventsModule.ConnectGetItem(getItem)
eventsModule.ConnectRemoteGetItem(getItem)
return module
