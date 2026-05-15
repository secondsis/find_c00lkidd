local Players = game:GetService("Players")

local References = require(script.Parent.References)
local part = References.CaveDoorCloser
local doorModule = require(script.Parent.DoorModule)

local cxn: RBXScriptConnection

cxn = part.Touched:Connect(function(other)
	local player = Players:GetPlayerFromCharacter(other.Parent)
	if not player then
		return
	end
	cxn:Disconnect()
	doorModule.closeDoor()
end)
