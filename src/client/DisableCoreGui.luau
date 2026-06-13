local module = {}

local starterGui = game:GetService("StarterGui")
local success, err

local attempts = 0

repeat
	success, err = pcall(function()
		starterGui:SetCore("ResetButtonCallback", false)
		starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
		starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, true)
	end)
	attempts += 1
	task.wait()
until success or attempts == 20

if attempts == 20 then
	warn("Could not load in properly!")
end

return module
