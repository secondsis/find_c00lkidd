local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

local Doors = CollectionService:GetTagged("IntroDoor")

local function HandleDoor(Door)
	local sound = Door.MovingDoorPart.DoorPart.DoorSound

	local animationRunning = false
	local IfReturning = false
	local CurrentSide = -1

	local lastAction = tick()

	local hingePart = Door.MovingDoorPart.Hinge
	local doorPart = Door.MovingDoorPart.DoorPart

	local isDoorEnabled = Door:GetAttribute("isDoorEnabled")

	local function Open()
		IfReturning = true
		sound.TimePosition = 0.05
		sound:Play()

		hingePart:SetAttribute("currentSide", CurrentSide)
		hingePart:SetAttribute("isOpen", true)

		task.wait(0.9)
	end

	local function Close()
		IfReturning = false
		sound.TimePosition = 2.5
		sound:Play()

		hingePart:SetAttribute("isOpen", false)

		task.wait(0.9)
	end

	local function side1Touched(other)
		if not other.Parent then
			return
		end

		if not Players:GetPlayerFromCharacter(other.Parent) then
			return
		end

		if animationRunning == false then
			animationRunning = true

			if IfReturning == false then
				CurrentSide = 1
				Open()
			else
				Close()
			end
			lastAction = tick()
			task.wait(0.5)
			sound:Stop()
			animationRunning = false

			task.wait(3)
			if tick() - lastAction >= 3 and animationRunning == false then
				animationRunning = true
				Close()
				animationRunning = false
			end
		end
	end

	local function side2Touched(other)
		if not other.Parent then
			return
		end

		if not Players:GetPlayerFromCharacter(other.Parent) then
			return
		end

		if animationRunning == false then
			animationRunning = true

			if IfReturning == false then
				CurrentSide = -1
				Open()
			else
				Close()
			end
			lastAction = tick()
			task.wait(0.5)
			sound:Stop()
			animationRunning = false

			task.wait(3)
			if tick() - lastAction >= 3 and animationRunning == false then
				animationRunning = true
				Close()
				animationRunning = false
			end
		end
	end

	local cxn1 = nil
	local cxn2 = nil

	local function enableDoor()
		if not cxn1 and not cxn2 then
			doorPart.CanCollide = false

			cxn1 = Door.Side1.Touched:Connect(side1Touched)
			cxn2 = Door.Side2.Touched:Connect(side2Touched)
		end
	end

	local function disableDoor()
		if cxn1 or cxn2 then
			doorPart.CanCollide = true

			cxn1:Disconnect()
			cxn1 = nil
			cxn2:Disconnect()
			cxn2 = nil
		end
	end

	if isDoorEnabled then
		enableDoor()
	else
		doorPart.CanCollide = true
	end

	-- Always check if this changes
	Door:GetAttributeChangedSignal("isDoorEnabled"):Connect(function()
		local newisEnabled = Door:GetAttribute("isDoorEnabled")

		if newisEnabled then
			enableDoor()
		else
			disableDoor()
		end
	end)
end

local function UpdateDoors()
	Doors = CollectionService:GetTagged("IntroDoor")
	for _, door in Doors do
		if door:IsDescendantOf(workspace) then
			table.remove(Doors, table.find(Doors, door))
		end
	end
	for _, door in Doors do
		HandleDoor(door)
	end
end

UpdateDoors()

return {}
