-- MAIN script of client

local Players = game:GetService("Players")
local player = Players.LocalPlayer

print(player.Name .. "'s client has started!")

local ClientModules = script:GetChildren()

for _, clientModule in ClientModules do
	if clientModule:IsA("ModuleScript") then
		task.spawn(function()
			require(clientModule)
		end)
	end
end
