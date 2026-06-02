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
function CutsceneService.PlayCutscene(player: Player, cutsceneData: any, options: any)
	-- Prepare the player perspective for cutscene
	CutsceneService.PreparePlayer(player)

	-- (Optionally) Load the map
	if cutsceneData.MapFolder then
		cutsceneData.MapFolderName = cutsceneData.MapFolder.Name
		clonedMap = CutsceneService.LoadMap(player, cutsceneData.MapFolder)
	end

	-- (Optionally) Teleport Player
	if cutsceneData.TeleportPart then
		playerOriginalCFrame = CutsceneService.TeleportPlayerToBox(player, cutsceneData.TeleportPart)
	end

	-- Play Camera, Animations, Dialogue
	-- Needs to be BLOCKING but likely better to wait for "Done" event and have a timeout! to keep the server running
	-- Make a RemoteEvent and wait for that until a certain point
	CutsceneService.PlaySceneEffects(player, cutsceneData)

	local startTick = tick()
	local isFinished = false
	local function setFinished()
		isFinished = true
	end

	-- Wait for scene to finish
	eventsModule.ConnectRemoteFinishedScene(setFinished)

	local timeout = 1200 -- in seconds (20 minutes)

	while not isFinished do
		task.wait()
		if tick() - startTick > timeout then
			warn("Player " .. player.Name .. " cutscene timeout!")
		end
	end

	-- Finish and reset
	-- Optionally exclude deleting map, etc.
	if options.KeepMap then
		CutsceneService.CleanUpCutscene(player, {
			KeepMap = true,
		})
	else
		CutsceneService.CleanUpCutscene(player)
	end
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
function CutsceneService.LoadMap(_: Player, mapFolder: Folder)
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
	eventsModule.FireRemotePlayScene(player, cutsceneData)
end

--[=[
 Resets everything back to normal
 @param player Player
]=]
function CutsceneService.CleanUpCutscene(player: Player, options)
	-- Return player movement, mouse, etc.
	eventsModule.FireRemoteFinishCutscene(player)

	-- Return player position
	References.DirectTeleportPlayer(player, playerOriginalCFrame)

	-- Destroy map
	if not options or not options.KeepMap then
		clonedMap:Destroy()
	end
end

--[=[
 Ran from the client to play a cutscene, but the client must be verified
 to view the cutscene by the server earlier
 @param player Player
 @param cutsceneName string
]=]
local function RemotePlayCutscene(player: Player, cutsceneName: string, options: any)
	-- Implement a check to verify that the player is allowed to view this
	-- if player:GetAttribute("Cutscenes") == nil or player:GetAttribute("Cutscenes") ~= cutsceneName then
	-- 	warn("Player does not have permission to play this cutscene!")
	-- 	return
	-- end

	-- Play the cutscene
	CutsceneService.PlayCutscene(player, CutsceneDataModule[cutsceneName], options)
end

-- Be able to play cutscene by client request
eventsModule.ConnectRemotePlayCutscene(RemotePlayCutscene)

return CutsceneService
