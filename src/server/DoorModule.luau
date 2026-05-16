local DoorModule = {}

local References = require(script.Parent.References)

local RunService = game:GetService("RunService")

if RunService:IsClient() then
	warn("DoorModule should be ran on the server!")
end

-- RIGHT SIDE
local TweenService = game:GetService("TweenService")

local door = References.GrandDoor

local rightPart = door:WaitForChild("RightEdge")

local openSfx = rightPart.Parent:WaitForChild("open")
local closeSfx = rightPart.Parent:WaitForChild("close")

local rightSideMoveRightTween =
	TweenService:Create(rightPart, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
		CFrame = rightPart.CFrame + Vector3.new(14, 0, 0),
	})

local rightSideMoveLeftTween =
	TweenService:Create(rightPart, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
		CFrame = rightPart.CFrame,
	})

-- LEFT
local leftPart = door:WaitForChild("LeftEdge")

local leftSideMoveRightTween =
	TweenService:Create(leftPart, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
		CFrame = leftPart.CFrame,
	})

local leftSideMoveLeftTween =
	TweenService:Create(leftPart, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
		CFrame = leftPart.CFrame + Vector3.new(-14, 0, 0),
	})

--- Opens the GrandDoor using a Tween and plays an opening SFX
function DoorModule.openDoor()
	openSfx:Play()
	rightSideMoveRightTween:Play()
	leftSideMoveLeftTween:Play()
end

--- Closes the GrandDoor using a Tween, plays a closing SFX, and enables a barrier with collision
function DoorModule.closeDoor()
	door:WaitForChild("ClosedBarrier").CanCollide = true
	closeSfx:Play()
	rightSideMoveLeftTween:Play()
	leftSideMoveRightTween:Play()
end

--- Reveals the Hints in the walls of the cave, Removes the transparency of the Hint TextLabel, etc.
function DoorModule.unlockHints()
	local hintFolder = door.Parent.CodeObjects
	print("Game: Unlocked hints")
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

return DoorModule
