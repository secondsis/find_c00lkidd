local PathAsString = require(script.Parent.PathAsString)
local References = require(script.Parent.References)
local CutsceneService = {}

local eventsModule = References.ServerEventsModule

local clonedMap = nil
local playerOriginalCFrame = nil

--[=[
 Plays a cutscene using cutsceneData
 @param player Player
 @param cutsceneData any
]=]
--[[
cutsceneData = {
    MapFolder = ServerStorage.WhateverFolder,
    BoxTeleportPart = MapFolder.WhateverTPPart,
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

function CutsceneService.PlayCutscene(player: Player, cutsceneData: any)
	-- Prepare the player perspective for cutscene
	CutsceneService.PreparePlayer(player)
	-- (Optionally) Load the map
	clonedMap = CutsceneService.LoadMap(cutsceneData.MapFolder)
	-- Teleport Player
	playerOriginalCFrame = CutsceneService.TeleportPlayerToBox(player, cutsceneData.BoxTeleportPart)

	-- Play Camera, Animations, Dialogue
	CutsceneService.PlaySceneEffects(player, cutsceneData)
	-- Finish and reset
	CutsceneService.CleanUpCutscene(player)
end

function CutsceneService.PreparePlayer(player: Player)
	eventsModule.FireRemotePrepareCutscene(player)
end

function CutsceneService.LoadMap(mapFolder: Folder)
	local mapClone = mapFolder:Clone()
	mapClone.Parent = workspace
	return mapClone
end

function CutsceneService.TeleportPlayerToBox(player: Player, boxTPPart: BasePart)
	if not player.Character or not player.Character.PrimaryPart then
		return nil
	end
	local originalPlayerCFrame = player.Character.PrimaryPart.CFrame
	References.DirectTeleportPlayer(player, boxTPPart.CFrame)
	return originalPlayerCFrame
end

function CutsceneService.PlaySceneEffects(player: Player, cutsceneData: any)
	-- Camera, Animations, Dialogue

	-- Prepare and find the newly cloned animation targets of cutsceneData
	-- Manipulate cutsceneData until it is ready for the client
	-- "ServerStorage.Assets.Security_NONE.Maps.Cutscenes" .SceneName.Target
	-- workspace.SceneName.Target
	local CutsceneAnimationKeyframes = cutsceneData.AnimationKeyframes
	for _, v in CutsceneAnimationKeyframes do
		local animationTarget = v.Target
		local ServerStorageAsset = PathAsString.fetchStringPath(animationTarget) :: string
		-- Replace "ServerStorage.Assets.Security_NONE.Maps.Cutscenes" with "workspace"
		local newPath = "workspace" .. ServerStorageAsset:sub(50)
		local newAsset = PathAsString.fetchAsset(newPath)
		v.Target = newAsset
	end

	-- Client will have access to the new targets
	task.spawn(eventsModule.FireRemotePlayScene, player, cutsceneData)
end

function CutsceneService.CleanUpCutscene(player: Player)
	-- Return player movement, mouse, etc.
	eventsModule.FireRemoteFinishCutscene(player)

	-- Return player position
	References.DirectTeleportPlayer(player, playerOriginalCFrame)

	-- Destroy map
	clonedMap:Destroy()
end

return CutsceneService
