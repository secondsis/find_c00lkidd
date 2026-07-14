local CollectionService = game:GetService("CollectionService")
local References = require(script.Parent.References)
local eventsModule = References.ServerEventsModule

local Prompts = CollectionService:GetTagged("DoorPrompt")

local function ConnectPromptTrigger(prompt: ProximityPrompt)
	local isWeird = prompt:GetAttribute("Weird")
	local asked = false
	prompt.Triggered:Connect(function(player)
		local item = eventsModule.FireGetItem(player)
		local hasCrowbar = item and item.Name == "Crowbar"

		if hasCrowbar then
			prompt.Enabled = false
			CollectionService:RemoveTag(prompt, "Prompt")
			if isWeird then
				eventsModule.FireRemoteDialogueFunction(player, "WeirdHouseDeath")
			else
				eventsModule.FireRemoteDialogueFunction(player, "HouseDeath")
			end

			-- Explode
			local DoorBoundsValue = prompt:FindFirstChildOfClass("ObjectValue")

			if DoorBoundsValue then
				eventsModule.FireRemoteSpawnClientExplosion(player, DoorBoundsValue.Value:GetBoundingBox().Position)
				DoorBoundsValue.Value.Parent:Destroy()
			end

			prompt:Destroy()
		else
			if isWeird then
				eventsModule.FireRemoteDialogueFunction(player, "WeirdHouseTalk")
				if not asked then
					asked = true
					local monerbag = game:GetService("ServerStorage").Assets.Security_SERVERONLY.Objects.Money_Bag
						:Clone()
					monerbag.Parent = workspace
				end
			else
				eventsModule.FireRemoteDialogueFunction(player, "HouseTalk")
			end
		end
	end)
end

for _, prompt in Prompts do
	ConnectPromptTrigger(prompt)
end

return {}
