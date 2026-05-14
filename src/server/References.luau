-- ONE MILLION VARIABLES GO BRRR
-- ckGalaxy as in c00lkidd galaxy wow so funny i know
local ckGalaxy = {}

local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

-- GENERAL
ckGalaxy.ServerEventsModule = require(ServerScriptService.Server.ServerEventsModule)

-- TELEPORTS
ckGalaxy.TeleportPartIntro = workspace.Cutscenes.Intro.e7Home.TPPart
ckGalaxy.TeleportPartPizzaPlace = ServerStorage.Assets.Security_NONE.Maps.Cutscenes.PizzaPlace.TPPart
ckGalaxy.TeleportPartc00lHouse = workspace.Buildings.c00lHouse.SpawnLocation

ckGalaxy.TeleportPartInsideCave = workspace.Cave.Inside.InsideCaveExit.TPBackArea
ckGalaxy.TeleportPartOutsideCave = workspace.Cave.Outside.OutsideCaveEntrance.TPToArea

-- CAVE ROOM
ckGalaxy.GrandDoor = workspace.Cave.Inside.ButtonDoor :: Model
ckGalaxy.HintLabel = workspace.Cave.Inside.CodeObjects.LockImage.SurfaceGui.HintText
ckGalaxy.CaveEntrance = workspace.Cave.Outside.OutsideCaveEntrance.TP_A
ckGalaxy.CaveExit = workspace.Cave.Outside.OutsideCaveEntrance.TP_B

-- HELPER FUNCTIONS

-- This can return Humanoid or nil
function ckGalaxy.GetHumanoid(player: Player)
	local Humanoid = nil
	local _, _ = pcall(function()
		local Character = player.Character
		if Character then
			Humanoid = Character:FindFirstChild("Humanoid")
		end
	end)

	return Humanoid
end

-- Teleport player function to use from server scripts for simple usage
function ckGalaxy.DirectTeleportPlayer(player: Player, newCFrame: CFrame)
	if not player or not player.Character or not player.Character.PrimaryPart then
		return
	end
	player.Character.PrimaryPart:PivotTo(newCFrame)
end

local playersTeleporting = {}
function ckGalaxy.TeleportPlayerOnTeleportPartTouch(tpFromPart: BasePart, tpTo: CFrame)
	local eventsModule = ckGalaxy.ServerEventsModule

	tpFromPart.Touched:Connect(function(other)
		if not other.Parent then
			return
		end
		local player = game:GetService("Players"):GetPlayerFromCharacter(other.Parent)
		if not player then
			return
		end

		if playersTeleporting[player.UserId] then
			return
		end
		playersTeleporting[player.UserId] = true

		eventsModule.FireRemoteTransitionFunction(player, 0.5)
		eventsModule.FireRemoteDisableMovementEvent(player, false)
		ckGalaxy.DirectTeleportPlayer(player, tpTo)
		eventsModule.FireRemotePlaySound(player, game:GetService("SoundService").SFX.EnterSfx)

		task.wait(0.5)

		eventsModule.FireRemoteDisableMovementEvent(player, true)
		playersTeleporting[player.UserId] = false
	end)
end

return ckGalaxy
