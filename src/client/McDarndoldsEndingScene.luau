local ChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local eventsModule = require(script.Parent.ClientEventsModule)

local speaker = workspace.Important.MiscInteractables:WaitForChild("McDarndoldSpeaker")
local speakerRoof = workspace.Buildings.Restaurant.SpeakerWalls:WaitForChild("Roof")
local prompt = speaker:WaitForChild("Part").ProximityPrompt

local sfx = SoundService:WaitForChild("SFX")
local explosionSfx = sfx:WaitForChild("Explosion")
local mouseSfx = sfx.gibberish
local heartSfx = sfx.heartbeat
local mmChezburgerSfx = sfx.MmChezburger
local openChezburgerSfx = sfx.OpenChezburger
local ambience = SoundService:WaitForChild("Ambience").Eerie
local lightingPresets = require(ReplicatedStorage.Shared.LightingPresets)

local eventTriggered: boolean = false

local player = game:GetService("Players").LocalPlayer

local function startSpeaker()
	if eventTriggered then
		return
	end
	eventTriggered = true
	prompt.Enabled = false

	for i, v in speakerRoof.Parent:GetChildren() do
		if v:IsA("BasePart") then
			v.CanCollide = true
		end
	end

	ChatService:DisplayBubble(speaker, "This is McDarndold's, what do you want...")
	task.wait(3)
	mouseSfx:Play()
	mouseSfx.Ended:Wait()
	task.wait(1)
	ChatService:DisplayBubble(speaker, "Huh? Uhhh okay sure...")
	-- you ordered 1k big macs you crazy
	task.wait(2)
	lightingPresets.McDarndolds()
	eventsModule.FireTurnOffMusic()
	-- first person
	eventsModule.FireSetFirstPerson()
	ambience:Play()
	task.wait(5)
	heartSfx:Play()
	heartSfx.Ended:Wait()
	task.wait(1)
	heartSfx:Play()
	heartSfx.Ended:Wait()
	task.wait(5)
	ambience:Stop()
	eventsModule.FireSetThirdPerson()
	lightingPresets.Default()

	eventsModule.FireCloneAssetSecurityNone("Objects.Chezburger")
	local chezburgerAsset = ReplicatedStorage.ClonedFolder:WaitForChild("Chezburger")
	local chezburger = chezburgerAsset:Clone()
	chezburgerAsset:Destroy()

	explosionSfx:Play()
	mmChezburgerSfx:Play()
	openChezburgerSfx:Play()
	-- copy cheeseburgers
	for i = 1, 100, 1 do
		local newBurger = chezburger:Clone()
		newBurger.Position = speakerRoof.Position
			+ Vector3.new(math.random(-9, 9), math.random(-5, -0.5), math.random(-9, 9))
		newBurger.Parent = workspace
	end

	task.wait(5)
	eventsModule.FireEndingEvent("Ending: McDarndold's", "can i haz chezburger plz? (x100)")
end

eventsModule.ConnectMcDarndold(startSpeaker)
