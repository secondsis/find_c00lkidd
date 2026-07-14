local References = require(script.Parent.References)

local tpFromPart = References.TeleportPartInsideCave
local tpToPart = References.CaveEntrance

-- FOREVER CONNECTION
local cxn = References.TeleportPlayerOnTeleportPartTouch(tpFromPart, tpToPart.CFrame)

return {}
