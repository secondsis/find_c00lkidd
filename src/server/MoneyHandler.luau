local module = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local eventsModule = require(ReplicatedStorage.ServerEventsModule)

local playerMoneyList = {}

Players.PlayerAdded:Connect(function(player)
	playerMoneyList[player] = 0
end)

Players.PlayerRemoving:Connect(function(player)
	playerMoneyList[player] = nil
end)

local updateMoneyEvent = ReplicatedStorage.RemoteEvents.RemoteUpdateMoney

local function AddMoney(player: Player, amount: number)
	if playerMoneyList[player] then
		playerMoneyList[player] += amount
		if amount > 0 then
			updateMoneyEvent:FireClient(player, true, playerMoneyList[player])
		else
			updateMoneyEvent:FireClient(player, false, playerMoneyList[player])
		end
	end
end

local function GetMoney(player: Player)
	if playerMoneyList[player] then
		return playerMoneyList[player]
	else
		return 0
	end
end

eventsModule.ConnectAddMoney(AddMoney)
eventsModule.ConnectGetMoney(GetMoney)
return module
