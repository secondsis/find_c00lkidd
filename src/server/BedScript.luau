local References = require(script.Parent.References)
local prompt = References.BedPrompt
local eventsModule = References.ServerEventsModule

prompt.Triggered:Once(function(player: Player)
	local notifLabel = eventsModule.FireRemoteGetNotificationLabel(player)
	local newLabel = notifLabel:Clone()
	newLabel.Text = "Are you REALLY sure you want to sleep?"
	newLabel.Parent = notifLabel.Parent
	eventsModule.FireRemotePlaySound(player, game:GetService("SoundService").SFX.notifyRing)
	prompt.ActionText = "Confirm Sleep?"
	prompt.Triggered:Once(function(player)
		prompt.ActionText = "Confirm CONFIRM Sleep?"

		prompt.Triggered:Once(function(player)
			local newLabel2 = notifLabel:Clone()
			newLabel2.Text = "Alright, if you say so."
			newLabel2.Parent = notifLabel.Parent
			eventsModule.FireRemotePlaySound(player, game:GetService("SoundService").SFX.notifyRing)

			task.spawn(function()
				task.wait(3)
				if newLabel2 then
					newLabel2:Destroy()
				end
			end)

			-- Chance for cutscene here?
			-- TODO: Sleep Demon secret ending
			eventsModule.FireRemoteDisableMovementEvent(player, false)
			player:SetAttribute("Ending", "Sleep")
			task.wait(2)
			eventsModule.FireRemoteFadeIn(player, 3)
			task.wait(3)
			eventsModule.FireRemoteEndingEvent(
				player,
				"Ending: Sleep",
				"A classic. But you can't help but feel like you missed the objective."
			)
		end)
	end)

	task.wait(3)
	if newLabel then
		newLabel:Destroy()
	end
end)
