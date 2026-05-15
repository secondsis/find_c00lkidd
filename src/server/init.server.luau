-- MAIN script of Server
print("Server started!")

local ServerModules = script:GetChildren()

require(script.References)

for _, ServerModule in ServerModules do
	if ServerModule:IsA("ModuleScript") then
		require(ServerModule)
	end
end
