local References = require(script.Parent.References)

local eventsModule = References.ServerEventsModule

local DialogueToPromptsDictionary = {
	["RestaurantWallTalk"] = {
		ProximityPrompts = { References.RestaurantWallPrompt },
	},
	["MirrorTalk1"] = {
		ProximityPrompts = {
			References.Mirror1Prompt,
			References.Mirror2Prompt,
		},
	},
	["MissingPoster007n7Talk"] = {
		ProximityPrompts = {
			References.MissingPoster007n7Prompt,
		},
	},
	["RigTalk"] = {
		ProximityPrompts = {
			References.AzraRigPrompt,
			References.EzraRigPrompt,
		},
	},
	["CashierTalk1"] = {
		ProximityPrompts = {
			References.CashierPrompt,
		},
	},
}

-- When triggered, prompt will start a dialogue
local function ConnectDialogueOnPromptTrigger(prompt: ProximityPrompt, dialogueName: string)
	prompt.Triggered:Connect(function(player)
		eventsModule.FireRemoteDialogueFunction(player, dialogueName)
	end)
end

-- For every dialoguePrompt, set up the trigger
for dialogueName, valueArray in DialogueToPromptsDictionary do
	local proximityPrompts = valueArray.ProximityPrompts
	for _, prompt in proximityPrompts do
		ConnectDialogueOnPromptTrigger(prompt, dialogueName)
	end
end

return {}
