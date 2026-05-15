local References = require(script.Parent.References)

local SoundService = game:GetService("SoundService")
task.wait(2)

local soundEffects = { SoundService.SFX.gubby, SoundService.SFX["Oneshot - HELLO Penguin"] }

local clickDetectors = { References.GubbyToyClickDetector, References.PenguinClickDetector }

local function SetUpClickDetector(clickDetector: ClickDetector, sfx: Sound)
	clickDetector.MouseClick:Connect(function()
		if sfx.Playing then
			sfx.Stopped:Wait()
		end
		sfx:Play()
	end)
end

for i = 1, #soundEffects, 1 do
	SetUpClickDetector(clickDetectors[i], soundEffects[i])
end
