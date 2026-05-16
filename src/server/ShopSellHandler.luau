local References = require(script.Parent.References)

local ShopItemInfo = References.ShopItemInfo

--[=[
 Sells a shop item to the player that triggers the item's ProximityPrompt
 
 Issue: Creates FOREVER CONNECTION (s) if the script using it does not disconnect themselves

 @param itemName string
 @return RBXScriptConnection
]=]
local function ShopSellItemOnPromptTrigger(itemName: string): RBXScriptConnection
	local eventsModule = References.ServerEventsModule

	local prompt = ShopItemInfo[itemName].ProximityPrompt

	local connection = prompt.Triggered:Connect(function(player)
		local money = eventsModule.FireGetMoney(player)
		local cost = ShopItemInfo[itemName].Price

		if money >= cost then
			local result = eventsModule.FireAddItem(player, itemName)
			if not result then
				eventsModule.FireRemoteNotifyInventoryFull(player)
				return
			end
			eventsModule.FireAddMoney(player, -cost)
			eventsModule.FireRemoteDeleteOnClient(player, prompt.Parent.Parent)
		else
			-- not enough money
			eventsModule.FireRemoteNotifyNotEnoughMoney(player)
			return
		end
	end)

	return connection
end

-- FOREVER CONNECTION
local cxnList = {}

-- For every item in the shop, set up the prompt trigger connection
for ItemName, valueArray in ShopItemInfo do
	table.insert(cxnList, ShopSellItemOnPromptTrigger(ItemName))
end

return {}
