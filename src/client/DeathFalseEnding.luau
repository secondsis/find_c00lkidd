task.wait(3)
local player = game:GetService("Players").LocalPlayer
local eventsModule = require(script.Parent.ClientEventsModule)
local char: Model
repeat
	char = player.Character
	task.wait(0.1)
until char

local hum: Humanoid = char:WaitForChild("Humanoid") :: Humanoid

hum.Died:Connect(function()
	if player:GetAttribute("Ending") then
		return
	end
	eventsModule.FireTurnOffMusic()
	task.wait(1)
	eventsModule.FireEndingEvent(
		"dang u died",
		"smartest player ever =>> [insert patrick with water tank on head]", -- alt: ARE WE COOKING GUYS>?<>?
		"http://www.roblox.com/asset/?id=8991722426"
	)
	task.wait(2)
	game:GetService("SoundService").SFX["Cat laughing at you meme"]:Play()
end)
