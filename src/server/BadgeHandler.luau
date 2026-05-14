-- SERVICES --
local badgeService = game:GetService("BadgeService")
local Players = game:GetService("Players")

local References = require(script.Parent.References)

local eventsModule = References.ServerEventsModule

-- INSTANCES --
local badgesFolder =
	workspace:WaitForChild("Buildings"):WaitForChild("c00lHouse"):WaitForChild("Shelf"):WaitForChild("Badges")
local storedTrophiesFolder = game:GetService("ServerStorage").Assets.Security_NONE.Objects.Trophies

-- BADGES --

local welcomeBadge = 3646574457098757

local endingBadges = {
	339115340529946, -- Bribe
	2022390322834047, -- Delusional
	3295583737325884, -- Drink
	3743247920329216, -- Escaped
	2106402716583262, -- McDarndolds
	1823937458188978, -- Rig
	524406096422812, -- SPEEN
	3171482526353545, -- Snack
	843061924067335, -- Frogs
	3333272589809621, -- Shedletsky
	2723694795327934, -- Balloon
	2220788171378690, -- Sleep
	872227141172268, -- Cola Addiction
}

local badgeToEnding = {
	[339115340529946] = "Bribe",
	[2022390322834047] = "Delusional",
	[3295583737325884] = "Drink",
	[3743247920329216] = "Escaped",
	[2106402716583262] = "McDarndold's",
	[1823937458188978] = "Rig?",
	[524406096422812] = "SPEEN",
	[3171482526353545] = "Snack",
	[843061924067335] = "Frogs.",
	[3333272589809621] = "Shedletsky",
	[2723694795327934] = "Nile Green",
	[2220788171378690] = "Sleep",
	[872227141172268] = "Cola Addiction",
}

local secretBadges = {
	3958672837203905, -- Bluuworld
}

local otherBadges = {
	3646574457098757, -- Welcome
	3388115204137866, -- Final ending
}

local endingToBadge = {}

for badge, ending in badgeToEnding do
	endingToBadge[ending] = badge
end

local badgeToPart = {}

for _, badge in endingBadges do
	badgeToPart[badge] = storedTrophiesFolder:WaitForChild(badgeToEnding[badge])
end

--[=[
 Checks if the BadgeList contains every ending badge and unlocks hints
 @param badgeOwnList { }
]=]
local function checkAllBadges(badgeOwnList: {})
	if #badgeOwnList == #endingBadges then
		local module = require(script.Parent.DoorModule)
		module.unlockHints()
	end
end

--[=[
 Checks if the BadgeList contains every ending badge and unlocks hints
 @param player { }
]=]
local function AwardBadge(player: Player, badgeId: number, dataStoreEntryName: string)
	badgeService:AwardBadge(player, badgeId)

	-- save that into datastore
	eventsModule.FireSetDataAsync(player, dataStoreEntryName, true)
end

-- Upon player joining, check if they own every ending badge and clone ending trophies into workspace
Players.PlayerAdded:Connect(function(player)
	local badgeOwnList = {}
	for _, badge in endingBadges do
		local badgeData = eventsModule.FireGetData(player, "Badges.Ending." .. badgeToEnding[badge])
		if badgeData then
			table.insert(badgeOwnList, badge)
		end
	end

	for _, v in badgeOwnList do
		local trophyClone = badgeToPart[v]:Clone()
		local m = require(trophyClone.Statue.ModuleScript)
		m.Animate()
		trophyClone.Parent = badgesFolder
	end

	checkAllBadges(badgeOwnList)
end)

-- Run from client to award badges if the client has been given the appropriate Ending attribute
eventsModule.ConnectRemoteAwardEndingBadge(function(player: Player, endingName: string)
	-- Player must have the correct "Ending" attribute
	-- INEFFICIENT/SCUFFED There might be a better way of securely tracking this
	if not player:GetAttribute("Ending") or player:GetAttribute("Ending") ~= endingName then
		return
	end

	-- Checks if Ending has a corresponding badge
	if not endingToBadge[endingName] then
		warn("Badge name does not exist: " .. endingName)
		return
	end

	-- Awards the ending badge to the player
	local success, result = pcall(function()
		return badgeService:AwardBadge(player.UserId, endingToBadge[endingName])
	end)

	-- Warning messages if it doesn't work
	if not success then
		warn("Failed to award badge.")
	end

	if not result then
		warn(player.Name .. " (UID: " .. player.UserId .. ") already has this badge!")
	end

	-- Make an entry in the DataStore in case badges don't work / players can delete their badges
	eventsModule.FireSetDataAsync(player, "Badges.Ending." .. endingName, true)
end)

eventsModule.ConnectAwardBadge(AwardBadge)
