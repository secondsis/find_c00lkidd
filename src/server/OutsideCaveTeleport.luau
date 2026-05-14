local References = require(script.Parent.References)

local tpFromPart = References.CaveEntrance
local tpToPart = References.TeleportPartInsideCave

References.TeleportPlayerOnTeleportPartTouch(tpFromPart, tpToPart.CFrame)
