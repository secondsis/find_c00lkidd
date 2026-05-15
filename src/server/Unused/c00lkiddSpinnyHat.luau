-- UNUSED

-- script.Parent is game:GetService("Workspace").Cave.Inside["c00lkidd_Posed"]

-- local rig = script.Parent
-- --if not rig.Parent or rig.Parent.Name ~= "Killers" then return end

-- local rootPart = rig:WaitForChild("HumanoidRootPart")
-- local propellerHat = rig:WaitForChild("PropellerHat")
-- local propellerHolder = propellerHat:WaitForChild("PropellerHolder")
-- local propeller = propellerHat:WaitForChild("Propeller")
-- propeller.Transparency = 1
-- local propellerClone = propeller:Clone()
-- propellerClone:ClearAllChildren()
-- propellerClone.Transparency = 0
-- propellerClone.Anchored = true
-- propellerClone.Parent = rig

-- --// spinny
-- local currentSpeed = Vector2.new(0)
-- local currentRotation = 0
-- local speedMultiplier = 20

-- while rig and rig.Parent do
-- 	local dt = game["Run Service"].Heartbeat:Wait()
-- 	if rootPart.Velocity.Magnitude > currentSpeed.X then
-- 		currentSpeed = currentSpeed:Lerp(Vector2.new(rootPart.Velocity.Magnitude), 0.2)
-- 	else
-- 		currentSpeed = currentSpeed:Lerp(Vector2.new(), dt / 2)
-- 	end
-- 	currentRotation += currentSpeed.X * speedMultiplier * dt
-- 	propellerClone.CFrame = propellerHolder.CFrame * CFrame.Angles(0, math.rad(currentRotation), 0)
-- end
