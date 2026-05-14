--[[
	Prefabs include: Trees, Moneys, TrashCans
]]

local collectionService = game:GetService("CollectionService")
local SoundService = game:GetService("SoundService")
local tweenService = game:GetService("TweenService")

local References = require(script.Parent.References)

local eventsModule = References.ServerEventsModule

local color3 = Color3.new

local checker = collectionService:GetTagged("Tree")
while #checker == 0 do
	task.wait(0.1)
	checker = collectionService:GetTagged("Tree")
end

task.wait(1)
local prefabFolder = game:GetService("ServerStorage").CommonPrefabs
local destinationFolder = workspace.Misc.Prefabs

local prefabs = {
	Trees = collectionService:GetTagged("Tree"),
	Moneys = collectionService:GetTagged("Money"),
	TrashCans = collectionService:GetTagged("TrashCan"),
	ThomasDetectors = collectionService:GetTagged("ThomasClickDetector"),
	RainbowLights = collectionService:GetTagged("RainbowLight"),
}

-- Remove any not under workspace
for _, v in prefabs do
	for ii, vv in v do
		if not vv:IsDescendantOf(workspace) then
			table.remove(v, table.find(v, vv))
		end
	end
end

-- GENERATE TREES
local treeFolder = Instance.new("Folder")
treeFolder.Name = "Generated_Trees"
treeFolder.Parent = destinationFolder

for _, treePlaceholder in prefabs.Trees do
	local treePrefab = prefabFolder.Tree:Clone()

	assert(treePlaceholder:IsA("Part"), "Something tagged with Tree was not a Part.")

	treePrefab:PivotTo(treePlaceholder.CFrame)

	treePrefab.Parent = treeFolder
	treePlaceholder:Destroy()
end

-- GENERATE MONEYS
local moneyFolder = Instance.new("Folder")
moneyFolder.Name = "Generated_Moneys"
moneyFolder.Parent = destinationFolder

for i, moneyPlaceholder in prefabs.Moneys do
	local moneyPrefab = prefabFolder.Money:Clone()
	local amount = moneyPlaceholder:GetAttribute("Amount")
	moneyPrefab:SetAttribute("Amount", amount)

	assert(moneyPlaceholder:IsA("Part"), "Something tagged with Money was not a Part.")

	moneyPrefab:PivotTo(moneyPlaceholder.CFrame)

	if moneyPlaceholder.Parent.Name ~= "Moneys" then
		moneyPrefab.Parent = moneyPlaceholder.Parent
	else
		moneyPrefab.Parent = moneyFolder
	end

	moneyPlaceholder:Destroy()
end

-- GENERATE TRASH CANS
local trashCanFolder = Instance.new("Folder")
trashCanFolder.Name = "Generated_TrashCans"
trashCanFolder.Parent = destinationFolder

for i, trashCanPlaceholder in prefabs.TrashCans do
	local trashCanPrefab = prefabFolder.TrashCan:Clone()

	assert(trashCanPlaceholder:IsA("Part"), "Something tagged with TrashCan was not a Part.")

	assert(trashCanPrefab.PrimaryPart, "Trash Can Prefab must have a PrimaryPart")

	trashCanPrefab.Trash.Note.MessagePart.SurfaceGui.TextLabel.Text = trashCanPlaceholder:GetAttribute("message")

	trashCanPrefab:PivotTo(trashCanPlaceholder.CFrame)

	trashCanPrefab.Parent = trashCanFolder
	trashCanPlaceholder:Destroy()
end

for _, thomasDetector in prefabs.ThomasDetectors do
	assert(thomasDetector:IsA("ClickDetector"))

	thomasDetector.MouseClick:Once(function(player: Player)
		local gasterSfx = SoundService.SFX["Gaster Fade"]
		gasterSfx:Play()
		gasterSfx.PlaybackSpeed -= 0.05
		eventsModule.FireSubtractThomas(player)
		local thomasGui = game:GetService("ServerStorage").GUIs.ThomasGui:Clone()
		thomasGui.Parent = player:FindFirstChild("PlayerGui")
		thomasDetector.Parent:Destroy()
	end)
end

for _, light in prefabs.RainbowLights do
	assert(light:IsA("Light"))

	task.spawn(function()
		local lightPos = light.Parent.Position

		local tweenInfo = TweenInfo.new(0.5)

		light.Color = color3(1, 0, 0)

		local tween1 = tweenService:Create(light, tweenInfo, {
			Color = color3(1, 0, 1),
		})

		local tween2 = tweenService:Create(light, tweenInfo, {
			Color = color3(0, 0, 1),
		})

		local tween3 = tweenService:Create(light, tweenInfo, {
			Color = color3(0, 1, 1),
		})

		local tween4 = tweenService:Create(light, tweenInfo, {
			Color = color3(0, 1, 0),
		})

		local tween5 = tweenService:Create(light, tweenInfo, {
			Color = color3(1, 1, 0),
		})

		local tween6 = tweenService:Create(light, tweenInfo, {
			Color = color3(1, 0, 0),
		})

		local tweens = { tween1, tween2, tween3, tween4, tween5, tween6 }

		local player = game:GetService("Players").LocalPlayer

		while not player do
			task.wait(0.5)
			player = game:GetService("Players").LocalPlayer
		end

		while task.wait(1) do
			if player:DistanceFromCharacter(lightPos) < 20 then
				light.Enabled = true
				for _, v in tweens do
					v:Play()
					task.wait(0.5)
				end
			else
				light.Enabled = false
			end
		end
	end)
end
