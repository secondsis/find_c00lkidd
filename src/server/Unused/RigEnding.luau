-- UNUSED

local tweenService = game:GetService("TweenService")
local References = require(script.Parent.References)

local eventsModule = References.ServerEventsModule

local prompt = References.RigPrompt

local normalFace = "rbxasset://textures/face.png"
local sadFace = "http://www.roblox.com/asset/?id=1563950166"

local faceDecal = prompt.Parent.Parent.Head.face
local scarySfx = prompt.Parent.Parent.SoundBlock.Scary

local tweenSfxIn = tweenService:Create(scarySfx, TweenInfo.new(1), {
	Volume = scarySfx.Volume,
})
local tweenSfxFade = tweenService:Create(scarySfx, TweenInfo.new(2), {
	Volume = 0.1,
})

scarySfx.Volume = 0

-- TODO: Make this a secret ending / random ending
prompt.Triggered:Connect(function(player)
	prompt.Enabled = false
	faceDecal.Texture = sadFace
	local result = eventsModule.FireRemoteDialogueFunction(
		player,
		"SpawnRigTalk1",
		{ "enableMovementAfter_false", "enablePromptsAfter_false" }
	)
	if not result then
		faceDecal.Texture = normalFace
		prompt.Enabled = true
		return
	end
	task.wait(1)
	eventsModule.FireRemoteTurnOffMusic(player)
	scarySfx:Play()
	tweenSfxIn:Play()
	task.wait(5)
	tweenSfxFade:Play()
	task.wait(2)
	eventsModule.FireRemoteDialogueFunction(
		player,
		"SpawnRigTalk2",
		{ "enableMovementAfter_false", "enablePromptsAfter_false" }
	)
	eventsModule.FireRemoteEndingEvent(player, "Ending: Rig?", "...")
	player:SetAttribute("Ending", "Rig?")
end)
