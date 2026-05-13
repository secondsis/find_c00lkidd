local module = {}

local References = require(script.Parent.References)

local RunService = game:GetService("RunService")

if RunService:IsClient() then
	warn("DoorModule should be ran on the server!")
end

-- RIGHT SIDE
local tweenService = game:GetService("TweenService")

local door = References.GrandDoor

local rightPart = door:WaitForChild("RightEdge")

local openSfx = rightPart.Parent:WaitForChild("open")
local closeSfx = rightPart.Parent:WaitForChild("close")

local rightSideMoveRightTween =
	tweenService:Create(rightPart, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
		CFrame = rightPart.CFrame + Vector3.new(14, 0, 0),
	})

local rightSideMoveLeftTween =
	tweenService:Create(rightPart, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
		CFrame = rightPart.CFrame,
	})

-- LEFT
local leftPart = door:WaitForChild("LeftEdge")

local leftSideMoveRightTween =
	tweenService:Create(leftPart, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
		CFrame = leftPart.CFrame,
	})

local leftSideMoveLeftTween =
	tweenService:Create(leftPart, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
		CFrame = leftPart.CFrame + Vector3.new(-14, 0, 0),
	})

local barrier = door:WaitForChild("ClosedBarrier")

function module.openDoor()
	openSfx:Play()
	rightSideMoveRightTween:Play()
	leftSideMoveLeftTween:Play()
end

function module.closeDoor()
	barrier.CanCollide = true
	closeSfx:Play()
	rightSideMoveLeftTween:Play()
	leftSideMoveRightTween:Play()
end

function module.unlockHints()
	local hintFolder = door.Parent.CodeObjects
	print("unlocked hints")
	for _, obj in hintFolder:GetDescendants() do
		if obj.Name == "KeyImage" or obj.Name == "LockImage" then
			continue
		end
		if obj:IsA("BasePart") or obj:IsA("Decal") then
			obj.Transparency = 0
		elseif obj:IsA("TextLabel") then
			obj.TextTransparency = 0
		end
	end
	door.GlitchPart:Destroy()
end

return module
