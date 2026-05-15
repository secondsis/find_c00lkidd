local eventsModule = require(script.Parent.ClientEventsModule)

local prompt = workspace.Buildings.c00lHouse.Furniture["Living Room"].Mirror
	:WaitForChild("Prompter")
	:WaitForChild("ProximityPrompt")
local dialogueNum = 1

local GameSettings = UserSettings().GameSettings

prompt.Triggered:Connect(function(_)
	if GameSettings.SavedQualityLevel == Enum.SavedQualitySetting.QualityLevel1 then
		eventsModule.FireDialogueFunction("RealisticMirrorTalkLowQuality")
		return
	end
	if dialogueNum == 1 then
		eventsModule.FireDialogueFunction("RealisticMirrorTalk1")
		dialogueNum += 1
	else
		eventsModule.FireDialogueEvent("RealisticMirrorTalk2")
		game.CollectionService:RemoveTag(prompt, "Prompt")
		prompt.Enabled = false
	end
end)
