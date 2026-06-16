local module = {}

local TweenService = game:GetService("TweenService")

local player = game:GetService("Players").LocalPlayer

local portalCFrame = workspace:WaitForChild("PortalEffect").CFrame

task.wait(3)

while game:GetService("Players").LocalPlayer.Character == nil do
	task.wait()
end

player.Character.Archivable = true
local playerClone: Model = player.Character:Clone()

local ScaleValue = Instance.new("NumberValue")
ScaleValue.Value = 0.05
playerClone:ScaleTo(0.05)
playerClone.HumanoidRootPart.CFrame = portalCFrame
playerClone.HumanoidRootPart.Anchored = true

playerClone.Parent = workspace

ScaleValue.Changed:Connect(function(val)
	playerClone:ScaleTo(val)
end)

TweenService:Create(ScaleValue, TweenInfo.new(5), {
	Value = 1,
}):Play()

TweenService:Create(playerClone.HumanoidRootPart, TweenInfo.new(5), {
	CFrame = CFrame.new(0.627, 1.804, 0.424) * CFrame.Angles(math.rad(-90), math.rad(-180), 0),
}):Play()

return module
