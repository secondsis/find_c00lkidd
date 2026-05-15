local References = require(script.Parent.References)
task.wait(2)
local CatPianoClickDetector = References.CatPianoClickDetector
local sfxes = CatPianoClickDetector.Parent.sounds:GetChildren()

CatPianoClickDetector.MouseClick:Connect(function()
	for i = 1, #sfxes do
		if sfxes[i].Playing then
			sfxes[i].Stopped:Wait()
			break
		end
	end

	sfxes[math.random(#sfxes)]:Play()
end)

return {}
