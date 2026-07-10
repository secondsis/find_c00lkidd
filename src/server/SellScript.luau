local module = {}

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local eventsModule = require(script.Parent.SERVER_EVENTS)
local shopItems = require(script.Parent.ShopItemsModule)
local signalModule = require(ReplicatedStorage.SignalGetter)

local function OnPromptTrigger(player, prompt, itemName)
	local money = eventsModule.FireGetMoney(player)
	local cost = shopItems[itemName]

	-- print(money)
	-- print(cost)
	-- print("name: " .. itemName)

	-- ERROR: ServerScriptService.Server.SellScript:12: attempt to compare nil <= number
	if money >= cost then
		-- local result = eventsModule.FireAddItem(player, itemName)
		-- if not result then
		-- 	eventsModule.FireRemoteNotifyInventoryFull(player)
		-- 	return
		-- end
		signalModule.getBindableEvent("PauseMinigameTimer"):Fire()
		eventsModule.FireAddMoney(player, -cost)
		eventsModule.FireRemoteDeleteOnClient(player, prompt)
		eventsModule.FireObtainedTrophyEffect(player, prompt.Parent.Parent, itemName)
		task.wait(5)
		eventsModule.FireFinishMinigameEarly(itemName)
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
		prompt.Triggered:Connect(function(player)
			OnPromptTrigger(player, prompt, itemName)
		end)
	end
end

return module
