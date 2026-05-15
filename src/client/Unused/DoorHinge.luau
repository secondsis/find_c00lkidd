-- UNUSED

-- I hate how inefficient this is, so I won't use it
-- But basically there are copies of this script on individual door hinges in Workspace
-- You can't see them because Rojo can't sync Workspace scripts

-- local CollectionService = game:GetService("CollectionService")
-- local tweenService = game:GetService("TweenService")

-- local tInfo = TweenInfo.new(0.9, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

-- local DoorHingeParts = CollectionService:GetTagged("DoorHinge")

-- local connections = {}

-- local function ConnectDoorHinge(hingePart: BasePart)
-- 	local open1Tween = tweenService:Create(hingePart, tInfo, {
-- 		CFrame = hingePart.CFrame * CFrame.Angles(0, math.rad(108), 0),
-- 	})

-- 	local open2Tween = tweenService:Create(hingePart, tInfo, {
-- 		CFrame = hingePart.CFrame * CFrame.Angles(0, math.rad(-108), 0),
-- 	})

-- 	local closeTween = tweenService:Create(hingePart, tInfo, {
-- 		CFrame = hingePart.CFrame,
-- 	})

-- 	local sound
-- 	if hingePart.Parent then
-- 		local doorPart = hingePart.Parent:FindFirstChild("DoorPart")
-- 		if doorPart then
-- 			sound = doorPart:FindFirstChild("DoorSound")
-- 		end
-- 	end

-- 	function Open()
-- 		if hingePart:GetAttribute("currentSide") == 1 then
-- 			open1Tween:Play()
-- 		else
-- 			open2Tween:Play()
-- 		end
-- 		task.wait(0.9)
-- 	end

-- 	function Close()
-- 		closeTween:Play()
-- 		task.wait(0.9)
-- 	end

-- 	local cxn = hingePart:GetAttributeChangedSignal("isOpen"):Connect(function()
-- 		local isOpen = hingePart:GetAttribute("isOpen")

-- 		if isOpen then
-- 			Open()
-- 		else
-- 			Close()
-- 		end
-- 	end)

-- 	table.insert(connections, cxn)
-- end

-- local function ConnectAll()
-- 	for _, hingePart in DoorHingeParts do
-- 		ConnectDoorHinge(hingePart)
-- 	end
-- end

-- local function DisconnectAll()
-- 	for _, cxn in connections do
-- 		cxn:Disconnect()
-- 	end
-- end

-- -- FOREVER LOOP
-- -- Need to constantly do this as player loads new door hinges
-- while task.wait(10) do
-- 	DoorHingeParts = CollectionService:GetTagged("DoorHinge")
-- 	DisconnectAll()
-- 	ConnectAll()
-- end
