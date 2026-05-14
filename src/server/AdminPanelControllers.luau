local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local References = require(script.Parent.References)
local ServerEventsModule = References.ServerEventsModule

local GUIs = ServerStorage.GUIs
local scriptComms = ReplicatedStorage.ScriptCommunication

local isStudio = RunService:IsStudio()

local debugPanel = GUIs.DEBUG_COMMANDS
local testerPanel = GUIs.TESTER_GUI

-- Admins
local debugPanel_users = {
	366830535,
}

-- Testers
local testerPanel_users = {
	2005313454, -- NonExiStab
	7382725225, -- Sn0wdAltAltAltAltAlt
	282709817, -- Ilovecats923
	366830535, -- literally me
	1615579823, -- PandaLover050409
	7553620410, -- bubbl3d_matchatea
	1561006600, -- EthanDaPenguin
	2466625671, -- iiNotDre
	1628637263, -- the_awad
	532207735, -- Clyde_aza
	1513986839, -- TTVSirDanDeMan
	3478685169, -- ConfusedInsomniac
	1576661040, -- sayed20303
	1996094716, -- moawre1
}

-- Upon player joining, check if they are an Admin or Tester and give them the appropriate GUI
Players.PlayerAdded:Connect(function(player)
	if isStudio or table.find(debugPanel_users, player.UserId) then
		local playerGui = player:WaitForChild("PlayerGui", 5)
		if playerGui then
			local newPanel = debugPanel:Clone()
			newPanel.Parent = playerGui
		end

		-- honestly bro if u need to access the testerpanel and ur a dev just change the code lol
		return
	end

	if table.find(testerPanel_users, player.UserId) then
		local playerGui = player:WaitForChild("PlayerGui", 5)
		if playerGui then
			local newPanel = testerPanel:Clone()
			newPanel.Parent = playerGui
		end
	end
end)

-- Debug: Adds money to pro admins
scriptComms.RemoteEvents.DeveloperAddMoney.OnServerEvent:Connect(function(player)
	if isStudio or table.find(debugPanel_users, player.UserId) then
		ServerEventsModule.FireAddMoney(player, 999)
	end
end)

-- Debug: Instantly gives door code to pro admins
scriptComms.RemoteEvents.GetDoorCode.OnServerEvent:Connect(function(player)
	if isStudio or table.find(debugPanel_users, player.UserId) then
		print("Debug Door Code: " .. ServerStorage.DoorCode.Value)
	end
end)
