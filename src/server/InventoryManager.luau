local ServerStorage = game:GetService("ServerStorage")

local References = require(script.Parent.References)

local eventsModule = References.ServerEventsModule

--[=[
 Adds the item, `name`, into the player inventory if there is space
 @param player Player
 @param name string -- the Item Name that must match the Tool name in hierarchy
 @return boolean -- if item was added successfully
]=]
local function addItem(player: Player, name: string): boolean
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

--[=[
 Gets a reference to the item in the player's (one-slot) inventory
 @param player Player
 @return Tool? -- returns the player's item otherwise nil
]=]
local function getItem(player): Tool?
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

--[=[
 Destroys the item `Tool` from the player's inventory
 @param player Player
 @return boolean -- if item was deleted successfully, false if no character or no item found
]=]
local function deleteItem(player: Player): boolean
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

--[=[
 "Trashes" the player's item in inventory, fired when player interacts with ProximityPrompt of a Trash Can
 
 Trashing plays a sound effect on the client in addition to destroying their item from the server and client
 @param player Player
]=]
local function trashItem(player)
	local wasDeleted = deleteItem(player)
	if wasDeleted then
		eventsModule.FireRemoteTrashItem(player)
	end
end

--[=[
 "Removes" the player's item in inventory, fired when the game forces the player to remove their item

 Removing does NOT play a sound effect and simply destroys the item from the server and client
 @param player Player
 @param name string -- the Item Name that must match the Tool name in hierarchy
 @return boolean -- if item was added successfully
]=]
local function removeItem(player)
	deleteItem(player)
	eventsModule.FireRemoteRemoveItem(player)
end

-- Connect functions to events

eventsModule.ConnectRemoteTrashItem(trashItem)
eventsModule.ConnectTrashItem(trashItem)

eventsModule.ConnectRemoteRemoveItem(removeItem)
eventsModule.ConnectRemoveItem(removeItem)

eventsModule.ConnectAddItem(addItem)
eventsModule.ConnectRemoteAddItem(addItem)

eventsModule.ConnectGetItem(getItem)
eventsModule.ConnectRemoteGetItem(getItem)

--- Add the MissingFrog poster to the player's inventory specifically for the Frog Ending
--- INEFFICIENT/SCUFFED probably a better way to organize this
-- Add a way to approve of this poster / client giving itself SOME items at SOME times
eventsModule.ConnectRemoteAddPoster(function(player)
	addItem(player, "MissingFrog")
end)

return {}
