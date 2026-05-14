local Players = game:GetService("Players")

local References = require(script.Parent.References)

local eventsModule = References.ServerEventsModule

local playerMoneyList = {}

Players.PlayerAdded:Connect(function(player)
	playerMoneyList[player] = 0
end)

Players.PlayerRemoving:Connect(function(player)
	playerMoneyList[player] = nil
end)

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

local function GetMoney(player: Player)
	if playerMoneyList[player] then
		return playerMoneyList[player]
	else
		return 0
	end
end

eventsModule.ConnectAddMoney(AddMoney)
eventsModule.ConnectGetMoney(GetMoney)
