--[[
	Ending data entries are structured like:
	"Badges.Ending.{endingName}"
]]

local References = require(script.Parent.References)

local dataStoreName = game:GetService("RunService"):IsStudio() and "Test_MainGame_PlayerData_v3"
	or "MainGame_PlayerData_v0"

local orderedDataStoreName = game:GetService("RunService"):IsStudio() and "Test_Donation_PlayerData_v0"
	or "Donation_PlayerData_v0"

if not game:GetService("RunService"):IsStudio() then
	print("Data store: " .. dataStoreName)
end

local DSS = game:GetService("DataStoreService")
local players = game:GetService("Players")

local eventsModule = References.ServerEventsModule

local dataStore = DSS:GetDataStore(dataStoreName)
local donationDataStore = DSS:GetOrderedDataStore(orderedDataStoreName)

local player_data = {}

players.PlayerAdded:Connect(function(player: Player)
	local success, err = pcall(function()
		local data = dataStore:GetAsync("Player_" .. player.UserId)

		-- Initialize new players' data
		if not data then
			data = {
				["Cutscenes.Intro"] = false,
				["JoinedTick"] = tick(),
			}

			dataStore:SetAsync("Player_" .. player.UserId, data)
			-- GIVE WELCOME BADGE
			eventsModule.FireAwardBadge(player, 3646574457098757, "Badges.Other.3646574457098757")
		end

		player_data["Player_" .. player.UserId] = data
		print(data)
	end)

	if err then
		-- Note: Add UI to tell the player to rejoin
		warn(err)
	end

	local success, err = pcall(function()
		local data = donationDataStore:GetAsync("Player_" .. player.UserId)

		-- Initialize new players' data
		if not data then
			data = 0

			donationDataStore:SetAsync("Player_" .. player.UserId, data)
		end
	end)

	if err then
		-- Note: Add UI to tell the player to rejoin
		warn(err)
	end
end)

--players.PlayerRemoving:Connect(function(player)
-- I want to remove the player from the data table in multiplayer
--end)

local function massSetData(player: Player, entryNameList: { string }, values: { any })
	local success, err = pcall(function()
		local oldData = dataStore:GetAsync("Player_" .. player.UserId)

		for i = 1, #entryNameList do
			local entryName = entryNameList[i]
			local value = values[i]

			if oldData[entryName] then
				continue
			end
			oldData[entryName] = value
		end

		dataStore:SetAsync("Player_" .. player.UserId, oldData)
		player_data["Player_" .. player.UserId] = oldData
	end)

	if err then
		warn(err)
	end
end

local function setData(player: Player, entryName: string, value: any)
	local success, err = pcall(function()
		local oldData = dataStore:GetAsync("Player_" .. player.UserId)
		if oldData[entryName] then
			return
		end
		oldData[entryName] = value
		dataStore:SetAsync("Player_" .. player.UserId, oldData)
		player_data["Player_" .. player.UserId] = oldData
	end)

	if err then
		warn(err)
	end
end

local function getData(player: Player): any
	local data
	local success, err = pcall(function()
		local ds = DSS:GetDataStore(dataStoreName)
		data = ds:GetAsync("Player_" .. player.UserId)
	end)
	if not success then
		warn(err)
	end

	return data
end

local function getDataOptimally(player: Player, entryName: string): any
	if not player_data["Player_" .. player.UserId] then
		local success, err = pcall(function()
			local data = dataStore:GetAsync("Player_" .. player.UserId)

			-- Initialize new players' data
			if not data then
				data = {
					["Cutscenes.Intro"] = false,
					["JoinedTick"] = tick(),
				}

				dataStore:SetAsync("Player_" .. player.UserId, data)
				-- GIVE WELCOME BADGE
				eventsModule.FireAwardBadge(player, 3646574457098757, "Badges.Other.3646574457098757")
			end

			player_data["Player_" .. player.UserId] = data
		end)

		if err then
			-- Note: Add UI to tell the player to rejoin
			warn(err)
		end
	end

	if player_data["Player_" .. player.UserId] then
		return player_data["Player_" .. player.UserId][entryName]
	end

	return nil
end

local function setDonationData(player: Player, addedValue: number)
	local success, err = pcall(function()
		local oldData = orderedDataStoreName:GetAsync("Player_" .. player.UserId)

		local newData = oldData + addedValue
		orderedDataStoreName:SetAsync("Player_" .. player.UserId, newData)
	end)

	if err then
		warn(err)
	end
end

eventsModule.ConnectSetDataAsync(setData)
eventsModule.ConnectSetDataMassAsync(massSetData)
eventsModule.ConnectGetDataAsync(getData)

eventsModule.ConnectRemoteGetData(getDataOptimally)
eventsModule.ConnectGetData(getDataOptimally)

--game:BindToClose(function(closeReason)
--	--print(`Closing with reason {closeReason}`)
--	--task.wait(3)
--	--print("Done")
--end)
