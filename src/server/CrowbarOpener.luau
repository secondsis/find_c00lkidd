local References = require(script.Parent.References)
local FrontDoors = References.FrontDoors

local function ConnectFrontDoorDestroy(frontDoor: Model)
	if not frontDoor.Parent then
		return
	end
	local doors = frontDoor.Parent:GetChildren()
	frontDoor.Destroying:Once(function()
		for _, door in doors do
			if door:GetAttribute("isDoorEnabled") == false then
				door:SetAttribute("isDoorEnabled", true)
			end
		end
	end)
end

for _, door in FrontDoors do
	ConnectFrontDoorDestroy(door)
end

return {}
