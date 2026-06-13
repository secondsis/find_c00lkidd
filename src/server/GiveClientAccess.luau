local module = {}
local ServerStorage = game:GetService("ServerStorage")

local eventsModule = require(game:GetService("ReplicatedStorage").ServerEventsModule)

local assetsFolder = ServerStorage.Minigame
local endingsFolder = assetsFolder.Endings
local interactableFolder = assetsFolder.Interactables

local cloneFinishEvent = game:GetService("ReplicatedStorage").WaitEvents.AssetCloningFinished

local function fetchAsset(player: Player, ending: string)
	local endingAsset = nil
	for _, endingAssetChild in endingsFolder:GetChildren() do
		if endingAssetChild:GetAttribute("Ending") == ending then
			endingAsset = endingAssetChild
			break
		end
	end

	local interactableAssets = {}
	for _, interactableAssetChild in interactableFolder:GetChildren() do
		local _endings = interactableAssetChild:GetAttribute("Ending")
		local __endings = string.split(_endings, ",")
		if table.find(__endings, ending) then
			table.insert(interactableAssets, interactableAssetChild)
		end
	end

	local newEndingAsset

	if endingAsset then
		newEndingAsset = endingAsset:Clone()
	end
	local newInteractableAssets = {}

	for _, v in interactableAssets do
		if v then
			table.insert(newInteractableAssets, v:Clone())
		end
	end

	local clonedFolder = workspace:FindFirstChild("Assets_Player_" .. tostring(player.UserId))
	if not clonedFolder then
		clonedFolder = Instance.new("Folder")
		clonedFolder.Name = "Assets_Player_" .. tostring(player.UserId)
		clonedFolder.Parent = workspace
	end

	if newEndingAsset then
		newEndingAsset.Parent = clonedFolder
	end

	for _, v in newInteractableAssets do
		if v then
			v.Parent = clonedFolder
		end
	end

	local SellScript = require(script.Parent.SellScript)
	SellScript.UpdatePromptConnections()

	cloneFinishEvent:FireClient(player)
end

local function clearPlayerAssets(player: Player)
	local clonedFolder = workspace:FindFirstChild("Assets_Player_" .. tostring(player.UserId))
	if clonedFolder then
		clonedFolder:Destroy()
	end
end

game:GetService("Players").PlayerRemoving:Connect(function(player)
	clearPlayerAssets(player)
end)

eventsModule.ConnectCloneMinigameAssets(fetchAsset)
eventsModule.ConnectClearMinigameAssets(clearPlayerAssets)
return module
