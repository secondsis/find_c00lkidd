local CollectionService = game:GetService("CollectionService")
local References = require(script.Parent.References)
local eventsModule = References.ServerEventsModule

local Prompts = CollectionService:GetTagged("DoorPrompt")

local function ConnectPromptTrigger(prompt: ProximityPrompt)
	prompt.Triggered:Connect(function(player)
		local item = eventsModule.FireGetItem(player)
		local hasCrowbar = item and item.Name == "Crowbar"

		if hasCrowbar then
			prompt.Enabled = false
			CollectionService:RemoveTag(prompt, "Prompt")
			eventsModule.FireRemoteDialogueFunction(player, "HouseDeath")
			-- Explode
			local DoorBoundsValue = prompt:FindFirstChildOfClass("ObjectValue")

			if DoorBoundsValue then
				eventsModule.FireRemoteSpawnClientExplosion(player, DoorBoundsValue.Value:GetBoundingBox().Position)
				DoorBoundsValue.Value.Parent:Destroy()
			end

			prompt:Destroy()
		else
			eventsModule.FireRemoteDialogueFunction(player, "HouseTalk")
		end
	end)
end

for _, prompt in Prompts do
	ConnectPromptTrigger(prompt)
end

return {}
