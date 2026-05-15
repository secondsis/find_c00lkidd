game.OnClose = function()
	local sound = game:GetService("SoundService").SFX["Bye - Pizza Place"]
	sound:Play()
	sound.Ended:Wait()
end

return {}
