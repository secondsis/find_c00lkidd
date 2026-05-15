--[=[
	Ending data entries are structured like:
	"Badges.Ending.{endingName}"
]=]

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local References = require(script.Parent.References)

local IsStudio = RunService:IsStudio()

local dataStoreName = IsStudio and "Test_MainGame_PlayerData_v3" or "MainGame_PlayerData_v0"

local orderedDataStoreName = IsStudio and "Test_Donation_PlayerData_v0" or "Donation_PlayerData_v0"

if not IsStudio then
	print("Data Store: " .. dataStoreName)
end

local eventsModule = References.ServerEventsModule

local dataStore = DataStoreService:GetDataStore(dataStoreName)
local donationDataStore = DataStoreService:GetOrderedDataStore(orderedDataStoreName)

-- Players' data in this session. Will be saved regularly to DataStore and deleted from table when player leaves
local player_data = {}

-- Upon player joining, initialize their data and donation data
Players.PlayerAdded:Connect(function(player: Player)
	-- Initialize data
	local _, err = pcall(function()
		-- Get Player's data
		local playerGameData = dataStore:GetAsync("Player_" .. player.UserId)

		-- TODO: Have a way to warn the player if their data does not save successfully
		-- playerGameData["LastSessionSaved"] = false

		-- Initialize new players' data
		if not playerGameData then
			playerGameData = {
				["Cutscenes.Intro"] = false,
				["JoinedTick"] = tick(),
			}

			dataStore:SetAsync("Player_" .. player.UserId, playerGameData)
			-- GIVE WELCOME BADGE
			eventsModule.FireAwardBadge(player, 3646574457098757, "Badges.Other.3646574457098757")
		end

		player_data["Player_" .. player.UserId] = playerGameData
		print(playerGameData)
	end)

	if err then
		-- TODO: Add UI to tell the player to rejoin
		warn(err)
	end

	-- Initialize Donation Data
	local _, err2 = pcall(function()
		-- Get Player's donation data
		local playerDonationData = donationDataStore:GetAsync("Player_" .. player.UserId)

		-- Initialize new players' data
		if not playerDonationData then
			playerDonationData = 0

			donationDataStore:SetAsync("Player_" .. player.UserId, playerDonationData)
		end
	end)

	if err2 then
		-- TODO: Add UI to tell the player to rejoin
		warn(err2)
	end
end)

-- TODO: Check if we need this function (I forgot if I already made a player leaving save feature)
-- Players.PlayerRemoving:Connect(function(player)
-- 	local _, err = pcall(function()
-- 		-- Save Player Data
-- 		local playerGameData = player_data[player.UserId]
-- 		dataStore:SetAsync("Player_" .. player.UserId, playerGameData)

-- 		-- Delete player from list
-- 		table.remove(player_data, player.UserId)
-- 	end)

-- 	if err then
-- 		warn(err)
-- 	end
-- end)

--[=[
 Assign values to player's DataStore data in bulk using a list of entries and values

 Note: entries and values MUST be in order corresponding to each other
 @param player Player
 @param entryNameList { string }
 @param values { any }
]=]
local function massSetData(player: Player, entryNameList: { string }, values: { any })
	local _, err = pcall(function()
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

--[=[
 Assign a value to player's DataStore data
 @param player Player
 @param entryName string
 @param value any
]=]
local function setData(player: Player, entryName: string, value: any)
	local _, err = pcall(function()
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

--[=[
 Get ALL of player's data from DataStore

 This sends a new request to DataStore
 @param player Player
 @return any -- The player data
]=]
local function getData(player: Player): any
	local data
	local success, err = pcall(function()
		local ds = DataStoreService:GetDataStore(dataStoreName)
		data = ds:GetAsync("Player_" .. player.UserId)
	end)
	if not success then
		warn(err)
	end

	return data
end
--[=[
 Obtains the value of an entry inside the player's data

 This doesn't request to DataStore and uses table cache
 @param player Player
 @param entryName string
 @param value any
]=]
local function getDataOptimally(player: Player, entryName: string): any
	-- If for some reason the player's data was not fetched
	if not player_data["Player_" .. player.UserId] then
		-- TODO: Add UI to tell the player to rejoin
		warn("Player Data could not be retrieved!")
		return nil
	end

	-- If the player has data

	return player_data["Player_" .. player.UserId][entryName]
end

-- UNUSED FUNCTION
-- local function setDonationData(player: Player, addedValue: number)
-- 	local _, err = pcall(function()
-- 		local oldData = orderedDataStoreName:GetAsync("Player_" .. player.UserId)

-- 		local newData = oldData + addedValue
-- 		orderedDataStoreName:SetAsync("Player_" .. player.UserId, newData)
-- 	end)

-- 	if err then
-- 		warn(err)
-- 	end
-- end

eventsModule.ConnectSetDataAsync(setData)
eventsModule.ConnectSetDataMassAsync(massSetData)
eventsModule.ConnectGetDataAsync(getData)

eventsModule.ConnectRemoteGetData(getDataOptimally)
eventsModule.ConnectGetData(getDataOptimally)

-- TODO: Figure out what to do with data if game shuts down
--game:BindToClose(function(closeReason)
--	--print(`Closing with reason {closeReason}`)
--	--task.wait(3)
--	--print("Done")
--end)
