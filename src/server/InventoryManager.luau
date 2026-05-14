local ServerStorage = game:GetService("ServerStorage")

local References = require(script.Parent.References)

local eventsModule = References.ServerEventsModule

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

	eventsModule.FireRemoteAddItem(player, name)

	local tool = ServerStorage.Assets.Security_NONE.Tools[name]:Clone()
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
		eventsModule.FireRemoteNotifyNoItems(player)
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
eventsModule.ConnectRemoteAddItem(addItem)

eventsModule.ConnectGetItem(getItem)
eventsModule.ConnectRemoteGetItem(getItem)

eventsModule.ConnectRemoteAddPoster(function(player)
	addItem(player, "MissingFrog")
end)
