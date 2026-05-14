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

-- GROCERY STORE
ckGalaxy.ShopSellTNTPrompt = workspace.Important.GroceryStoreObjects.ItemCatalog.Bomb.TNT.TNT.Prompter.ProximityPrompt
ckGalaxy.ShopSellSlimeballPrompt =
	workspace.Important.GroceryStoreObjects.ItemCatalog.Food.Slimeball.Slimeball.Prompter.ProximityPrompt
ckGalaxy.ShopSellCrowbarPrompt =
	workspace.Important.GroceryStoreObjects.ItemCatalog.Crowbar.Crowbar.Crowbar.crowbar.ProximityPrompt
ckGalaxy.ShopSellChipsPrompt = workspace.Important.GroceryStoreObjects.ItemCatalog.Food.Chips.Chips.ProximityPrompt
ckGalaxy.ShopSellColaPackPrompt =
	workspace.Important.GroceryStoreObjects.ItemCatalog.Food.ColaPack.Prompter.ProximityPrompt
ckGalaxy.ShopSellTurkeyLegPrompt =
	workspace.Important.GroceryStoreObjects.ItemCatalog.Food.TurkeyLeg.TurkeyLeg.Handle.ProximityPrompt
ckGalaxy.ShopSellWaterBalloonPrompt =
	workspace.Important.GroceryStoreObjects.ItemCatalog.Balloon.WaterBalloon.WaterBalloon.ProximityPrompt

ckGalaxy.ShopItemInfo = {
	["Chips"] = {
		ProximityPrompt = ckGalaxy.ShopSellChipsPrompt,
		Price = 15,
	},
	["ColaPack"] = {
		ProximityPrompt = ckGalaxy.ShopSellColaPackPrompt,
		Price = 20,
	},
	["Crowbar"] = {
		ProximityPrompt = ckGalaxy.ShopSellCrowbarPrompt,
		Price = 30,
	},
	["Slimeball"] = {
		ProximityPrompt = ckGalaxy.ShopSellSlimeballPrompt,
		Price = 20,
	},
	["TNT"] = {
		ProximityPrompt = ckGalaxy.ShopSellTNTPrompt,
		Price = 100,
	},
	["TurkeyLeg"] = {
		ProximityPrompt = ckGalaxy.ShopSellTurkeyLegPrompt,
		Price = 20,
	},
	["WaterBalloon"] = {
		ProximityPrompt = ckGalaxy.ShopSellWaterBalloonPrompt,
		Price = -1,
	},
}

-- CAVE ROOM
ckGalaxy.GrandDoor = workspace.Cave.Inside.ButtonDoor :: Model
ckGalaxy.HintLabel = workspace.Cave.Inside.CodeObjects.LockImage.SurfaceGui.HintText
ckGalaxy.CaveEntrance = workspace.Cave.Outside.OutsideCaveEntrance.TP_A
ckGalaxy.CaveExit = workspace.Cave.Outside.OutsideCaveEntrance.TP_B

-- HELPER FUNCTIONS

--[=[
 Finds the reference to the Humanoid of the player Character

 This can return Humanoid or nil
 @param player Player
 @return Humanoid
]=]
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

--[=[
 Teleport player function to use from server scripts for simple usage
 @param player Player
 @param newCFrame CFrame
]=]
function ckGalaxy.DirectTeleportPlayer(player: Player, newCFrame: CFrame)
	if not player or not player.Character or not player.Character.PrimaryPart then
		return
	end
	player.Character.PrimaryPart:PivotTo(newCFrame)
end

local playersTeleporting = {}

--[=[
 Teleports any players that touch tpFromPart to tpToCFrame CFrame 
 
 Issue: Creates FOREVER CONNECTION (s) if the script using it does not disconnect themselves

 @param tpFromPart BasePart
 @param tpToCFrame CFrame
 @return RBXScriptConnection
]=]
function ckGalaxy.TeleportPlayerOnTeleportPartTouch(tpFromPart: BasePart, tpToCFrame: CFrame): RBXScriptConnection
	local eventsModule = ckGalaxy.ServerEventsModule

	local connection = tpFromPart.Touched:Connect(function(other)
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
		ckGalaxy.DirectTeleportPlayer(player, tpToCFrame)
		eventsModule.FireRemotePlaySound(player, game:GetService("SoundService").SFX.EnterSfx)

		task.wait(0.5)

		eventsModule.FireRemoteDisableMovementEvent(player, true)
		playersTeleporting[player.UserId] = false
	end)

	return connection
end

--[=[
 Sells a shop item to the player that triggers the item's ProximityPrompt
 
 Issue: Creates FOREVER CONNECTION (s) if the script using it does not disconnect themselves

 @param itemName string
 @return RBXScriptConnection
]=]
function ckGalaxy.ShopSellItemOnPromptTrigger(itemName: string): RBXScriptConnection
	local eventsModule = ckGalaxy.ServerEventsModule

	local prompt = ckGalaxy.ShopItemInfo[itemName].ProximityPrompt

	local connection = prompt.Triggered:Connect(function(player)
		local money = eventsModule.FireGetMoney(player)
		local cost = ckGalaxy.ShopItemInfo[itemName].Price

		if money >= cost then
			local result = eventsModule.FireAddItem(player, itemName)
			if not result then
				eventsModule.FireRemoteNotifyInventoryFull(player)
				return
			end
			eventsModule.FireAddMoney(player, -cost)
			eventsModule.FireRemoteDeleteOnClient(player, prompt.Parent.Parent)
		else
			-- not enough money
			eventsModule.FireRemoteNotifyNotEnoughMoney(player)
			return
		end
	end)

	return connection
end

return ckGalaxy
