local Players = game:GetService("Players")

local References = require(script.Parent.References)

local eventsModule = References.ServerEventsModule

local playerMoneyList = {}

-- Initialize player money to 0 upon joining
Players.PlayerAdded:Connect(function(player)
	playerMoneyList[player] = 0
end)

-- Remove player from list upon leaving
Players.PlayerRemoving:Connect(function(player)
	playerMoneyList[player] = nil
end)

--[=[
 Increments the player's money count by `amount`
 @param player Player -- the player receiving money
 @param amount number -- how much to increase the player's money
]=]
local function AddMoney(player: Player, amount: number)
	if playerMoneyList[player] then
		playerMoneyList[player] += amount
		if amount > 0 then
			eventsModule.FireRemoteUpdateMoney(player, true, playerMoneyList[player])
		else
			eventsModule.FireRemoteUpdateMoney(player, false, playerMoneyList[player])
		end
	end
end

--[=[
 Returns how much money the player has
 @param player Player -- the player to check
 @return number -- amount of money
]=]
local function GetMoney(player: Player)
	if playerMoneyList[player] then
		return playerMoneyList[player]
	else
		return 0
	end
end

-- Connect events
eventsModule.ConnectAddMoney(AddMoney)
eventsModule.ConnectGetMoney(GetMoney)
