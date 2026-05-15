local References = require(script.Parent.References)
-- No, not that kind of Rock
-- local SoundService = game:GetService("SoundService")

local eventsModule = References.ServerEventsModule

local prompt = References.TheRockPrompt

-- local explosionSFX = SoundService.SFX.explosion_classic

prompt.Triggered:Connect(function(player)
	prompt.Enabled = false

	-- Check if player has tnt
	local item = eventsModule.FireGetItem(player)
	--eventsModule.FireRemoteGetItem(player)

	if item and item.Name == "TNT" then
		eventsModule.FireRemoteDialogueFunction(player, "RockGuyDeath")
	else
		eventsModule.FireRemoteDialogueFunction(player, "RockGuyBlocking")
	end

	eventsModule.FireRemoteWaitForDialogueFinish(player)

	prompt.Enabled = true

	if item and item.Name == "TNT" then
		eventsModule.FireRemoteSpawnClientExplosion(player, prompt.Parent.Position)
		eventsModule.FireRemoveItem(player)
		eventsModule.FireRemoteDeleteOnClient(player, prompt.Parent.Parent)
	end
end)
