local Players = game:GetService("Players")
local CutsceneDataModule = require(script.Parent.CutsceneDataModule)
local PathAsString = require(game:GetService("ReplicatedStorage").Shared.PathAsString)
local References = require(script.Parent.References)
local CutsceneService = {}

local eventsModule = References.ServerEventsModule

local clonedMap = nil
local playerOriginalCFrame = nil

--[[
cutsceneData = {
    MapFolder = ServerStorage.WhateverFolder,
    TeleportPart = MapFolder.WhateverTPPart,
    CameraKeyframes = {
        {
            CFrame = whatev,
            TweenInfo = TweenInfo.new(wwgareg),
            TimePosition = 0.00
        },
        {
            CFrame = whatev,
            TweenInfo = TweenInfo.new(wwgareg),
            TimePosition = 5.02 -- should be after the previous tween has completed
        },
    },
    AnimationKeyframes = {
        {
            Target = eag,
            Animation = "https://rbxidwhat",
            TimePosition = 0.00 -- Time in seconds
        },
        {

        }
    },
    DialogueKeyframes = {
        {
            DialogueName = "whatever",
            TimePosition = 0.00
        },
        {
            DialogueName = "wae",
            TimePosition = 10.012
        }
    }
}
]]
--[=[
 Plays a cutscene using cutsceneData
 @param player Player
 @param cutsceneData any
]=]
function CutsceneService.PlayCutscene(player: Player, cutsceneData: any)
	print("Preparing Player for cutscene...")
	-- Prepare the player perspective for cutscene
	CutsceneService.PreparePlayer(player)

	print("Loading map...")
	-- (Optionally) Load the map
	if cutsceneData.MapFolder then
		clonedMap = CutsceneService.LoadMap(player, cutsceneData.MapFolder)
	end

	print("Teleporting player...")
	-- (Optionally) Teleport Player
	if cutsceneData.TeleportPart then
		playerOriginalCFrame = CutsceneService.TeleportPlayerToBox(player, cutsceneData.TeleportPart)
	end

	print("Playing cutscene effects...")
	-- Play Camera, Animations, Dialogue
	CutsceneService.PlaySceneEffects(player, cutsceneData)

	print("Cleaning up scene...")
	-- Finish and reset
	CutsceneService.CleanUpCutscene(player)

	print("Done!")
end

-- Client needs to call this

--[=[
 Tells the client to prepare for a cutscene
 @param player Player
]=]
function CutsceneService.PreparePlayer(player: Player)
	eventsModule.FireRemotePrepareCutscene(player)
end

--[=[
 Tells the client to load the map
 @param player Player
 @param mapFolder Folder
]=]
function CutsceneService.LoadMap(player: Player, mapFolder: Folder)
	-- Clone on client
	local mapClone = mapFolder:Clone()
	mapClone.Parent = game:GetService("ReplicatedStorage").ClonedFolder
	return mapClone
end

--[=[
 Teleport player into the player box
 @param player Player
 @param boxTPPart BasePart -- Contains the CFrame of the destination
]=]
function CutsceneService.TeleportPlayerToBox(player: Player, boxTPPart: BasePart)
	if not player.Character or not player.Character.PrimaryPart then
		return nil
	end
	local originalPlayerCFrame = player.Character.PrimaryPart.CFrame
	References.DirectTeleportPlayer(player, boxTPPart.CFrame)
	return originalPlayerCFrame
end

--[=[
 Plays the client's scene effects: camera, animations, dialogue
 @param player Player
 @param cutsceneData any
]=]
function CutsceneService.PlaySceneEffects(player: Player, cutsceneData: any)
	-- Camera, Animations, Dialogue

	-- Prepare and find the newly cloned animation targets of cutsceneData
	-- Manipulate cutsceneData until it is ready for the client
	-- "ServerStorage.Assets.Security_NONE.Maps.Cutscenes" .SceneName.Target
	-- workspace.SceneName.Target
	local function playScene()
		eventsModule.FireRemotePlayScene(player, cutsceneData)
	end
	task.spawn(playScene)
end

--[=[
 Resets everything back to normal
 @param player Player
]=]
function CutsceneService.CleanUpCutscene(player: Player)
	-- Return player movement, mouse, etc.
	eventsModule.FireRemoteFinishCutscene(player)

	-- Return player position
	References.DirectTeleportPlayer(player, playerOriginalCFrame)

	-- Destroy map
	clonedMap:Destroy()
end

local function RemotePlayCutscene(player: Player, cutsceneName: string)
	-- Implement a check to verify that the player is allowed to view this
	if player:GetAttribute("Cutscenes") == nil or player:GetAttribute("Cutscenes") ~= cutsceneName then
		warn("Player does not have permission to play this cutscene!")
		return
	end

	print("confirmed")
	-- Play the cutscene
	CutsceneService.PlayCutscene(player, CutsceneDataModule[cutsceneName])
end

-- Be able to play cutscene by client request
eventsModule.ConnectRemotePlayCutscene(RemotePlayCutscene)

return CutsceneService
