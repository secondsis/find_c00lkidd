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
}

local function ConnectDialogueOnPromptTrigger(prompt: ProximityPrompt, dialogueName: string)
	prompt.Triggered:Connect(function(player)
		eventsModule.FireRemoteDialogueFunction(player, dialogueName)
	end)
end

for _, dialogueName in DialogueToPromptsDictionary do
	local proximityPrompts = DialogueToPromptsDictionary[dialogueName]
	for _, prompt in proximityPrompts do
		ConnectDialogueOnPromptTrigger(prompt, dialogueName)
	end
end
