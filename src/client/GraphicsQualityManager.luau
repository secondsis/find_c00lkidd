local GameSettings = UserSettings().GameSettings
local startingQuality = GameSettings.SavedQualityLevel
local eventsModule = require(script.Parent.ClientEventsModule)

if startingQuality == Enum.SavedQualitySetting.QualityLevel1 then
	-- Disable the mirror and other stuff
	local returnedValue = eventsModule.FireGraphicsQualityLow(true)
	while not returnedValue do
		task.wait(1)
		returnedValue = eventsModule.FireGraphicsQualityLow(true)
	end
end

GameSettings.Changed:Connect(function(property: string)
	if property == "SavedQualityLevel" then
		if GameSettings.SavedQualityLevel == Enum.SavedQualitySetting.QualityLevel1 then
			eventsModule.FireGraphicsQualityLow(true)
		else
			eventsModule.FireGraphicsQualityLow(false)
		end
	end
end)
