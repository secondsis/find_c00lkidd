local References = require(script.Parent.References)
task.wait(2)

local sfx = game:GetService("SoundService").SFX.gubby
local gubbyToyClickDetector = References.GubbyToyClickDetector

gubbyToyClickDetector.MouseClick:Connect(function()
	if sfx.Playing then
		sfx.Stopped:Wait()
	end
	sfx:Play()
end)
