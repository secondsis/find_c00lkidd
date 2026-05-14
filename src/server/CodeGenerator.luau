local ServerStorage = game:GetService("ServerStorage")

local References = require(script.Parent.References)

local hintLabel = References.HintLabel
local doorCodeValue = ServerStorage:WaitForChild("DoorCode")

local code = math.random(1000, 9999)
local translateTable = { "ONE", "TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT", "NINE" }
local strCode = tostring(code)

local translatedCode = ""
for i = 1, strCode:len(), 1 do
	local char = string.sub(strCode, i, i)
	if char == "0" then
		translatedCode ..= "ZERO"
	else
		local charNumber = tonumber(char)
		if charNumber then
			translatedCode ..= translateTable[charNumber]
		end
	end
end

local kairosMap = { 11, 1, 9, 18, 15, 19 }
local encoded_code = ""

for i = 1, #translatedCode do
	local char = string.sub(translatedCode, i, i)

	local byte = string.byte(char)
	local shift = kairosMap[((i - 1) % 6) + 1]
	local shifted_byte = byte + shift
	if shifted_byte > 90 then
		shifted_byte = (shifted_byte - 90) + 64
	end

	encoded_code ..= string.char(shifted_byte)
end

doorCodeValue.Value = code
hintLabel.Text = encoded_code
