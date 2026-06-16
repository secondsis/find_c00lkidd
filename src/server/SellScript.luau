local module = {}

local CollectionService = game:GetService("CollectionService")

local eventsModule = require(game:GetService("ReplicatedStorage").ServerEventsModule)
local shopItems = require(game:GetService("ServerScriptService").Server.ShopItemsModule)

local function OnPromptTrigger(player, prompt, itemName)
	local money = eventsModule.FireGetMoney(player)
	local cost = shopItems[itemName]

	-- ERROR: ServerScriptService.Server.SellScript:12: attempt to compare nil <= number
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
end

function module.UpdatePromptConnections()
	local Prompts = CollectionService:GetTagged("SellPrompt")
	for _, prompt in Prompts do
		if not prompt:IsDescendantOf(workspace) then
			continue
		end

		local itemName = prompt.Parent.Parent.Name
		prompt.Triggered:Connect(OnPromptTrigger, prompt, itemName)
	end
end

return module
