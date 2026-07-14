local References = require(script.Parent.References)

local tpFromPart = References.TeleportPartOutsideCave
local tpToPart = References.CaveExit

-- FOREVER CONNECTION
local cxn = References.TeleportPlayerOnTeleportPartTouch(tpFromPart, tpToPart.CFrame)

return {}
