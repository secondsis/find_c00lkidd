local References = require(script.Parent.References)

local tpFromPart = References.CaveExit
local tpToPart = References.TeleportPartOutsideCave

-- FOREVER CONNECTION
local cxn = References.TeleportPlayerOnTeleportPartTouch(tpFromPart, tpToPart.CFrame)
