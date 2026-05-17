local module = {}

local References = require(script.Parent.References)

local MissionHandler =
	require(game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("MissionGui"):WaitForChild("MissionHandler"))

-- When player touches a room's respective parts, go tick the box

local RoomParts = {
	LivingRoom = References,
	DownstairsBedroom = References,
	Garage = References,
	FamilyRoom = References,
	["007n7Bedroom"] = References,
	c00lkiddBedrooom = References,
}

function module.ConnectTouchEvents()
	for roomName, roomPart in RoomParts do
		-- Mark off this room when .Touched
		roomPart.Touched:Connect(function()
			MissionHandler.MarkComplete(roomName)
		end)
	end
end

return module
