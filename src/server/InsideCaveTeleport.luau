local References = require(script.Parent.References)

local tpFromPart = References.CaveExit
local tpToPart = References.TeleportPartOutsideCave

References.TeleportPlayerOnTeleportPartTouch(tpFromPart, tpToPart.CFrame)
