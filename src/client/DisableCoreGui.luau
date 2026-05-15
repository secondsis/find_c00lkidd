local starterGui = game:GetService("StarterGui")
local success

repeat
	local attempts = 0

	repeat
		success, _ = pcall(function()
			starterGui:SetCore("ResetButtonCallback", false)
			starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
			starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, true)
		end)
		attempts += 1
		task.wait()
	until success or attempts == 20

	if attempts == 20 then
		warn("Could not load in properly!")
		task.wait(2)
	end
until true

return {}
