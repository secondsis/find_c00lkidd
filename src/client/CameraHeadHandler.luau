local RunService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local neck: Motor6D = character:WaitForChild("Torso").Neck
local yOffset = neck.C0.Y
local hrp: BasePart = character:WaitForChild("HumanoidRootPart")

local cam = workspace.CurrentCamera

local CFNew = CFrame.new
local CFAng = CFrame.Angles
local asin = math.asin

RunService.RenderStepped:Connect(function()
	local camDir = hrp.CFrame:ToObjectSpace(cam.CFrame).LookVector

	if neck then
		neck.C0 = CFNew(0, yOffset, 0)
			* CFAng(3 * math.pi / 2, 0, math.pi)
			* CFAng(0, 0, -asin(camDir.x))
			* CFAng(-asin(camDir.y), 0, 0)

		-- Owl neck code WE LOVE OWL NECK im like sooo smort ( no im not 6 7 )
		--if camDir.Z < 0 then
		--	neck.C0 = CFNew(0, yOffset, 0) * CFAng(3 * math.pi/2, 0, math.pi) * CFAng(0, 0, math.pi-asin(camDir.x)) * CFAng(asin(camDir.y), 0,0)
		--else
		--	neck.C0 = CFNew(0, yOffset, 0) * CFAng(3 * math.pi/2, 0, math.pi) * CFAng(0, 0, asin(camDir.x)) * CFAng(asin(camDir.y), 0,0)
		--end
	end
end)

return {}
