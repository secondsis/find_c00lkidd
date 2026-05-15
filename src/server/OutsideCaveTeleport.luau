local References = require(script.Parent.References)

local tpFromPart = References.CaveEntrance
local tpToPart = References.TeleportPartInsideCave

-- FOREVER CONNECTION
local cxn = References.TeleportPlayerOnTeleportPartTouch(tpFromPart, tpToPart.CFrame)

return {}
