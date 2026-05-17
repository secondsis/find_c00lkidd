local PathAsString = require(script.Parent.PathAsString)
local References = require(script.Parent.References)
local CutsceneService = {}

local eventsModule = References.ServerEventsModule

local clonedMap = nil
local playerOriginalCFrame = nil

--[=[
 Plays a cutscene using cutsceneData
 
]=]
--[[
cutsceneData = {
    MapFolder = ServerStorage.WhateverFolder,
    BoxTeleportPart = MapFolder.WhateverTPPart,
    CameraKeyframes = {
        {
            CFrame = whatev,
            TweenInfo = TweenInfo.new(wwgareg)
        },
        {
            CFrame = whatev,
            TweenInfo = TweenInfo.new(wwgareg)
        },
    },
    AnimationKeyframes = {
        {
            Target = eag,
            Animation = "https://rbxidwhat"
        },
        {
            
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

	-- Prepare and find the newly cloned animation targets of cutsceneData
	-- Manipulate cutsceneData until it is ready for the client
	-- "ServerStorage.Assets.Security_NONE.Maps.Cutscenes" .SceneName.Target
	-- workspace.SceneName.Target
	local PathAsString = require(script.Parent.PathAsString)
	local ServerStorageAsset = PathAsString.fetchStringPath()

	-- Play Camera, Animations, Dialogue

	-- Finish and reset
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

function CutsceneService.PlaySceneEffects()
	local startTick = tick()

	-- Camera, Animations, Dialogue
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
