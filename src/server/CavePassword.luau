local SoundService = game:GetService("SoundService")
local ServerStorage = game:GetService("ServerStorage")

local References = require(script.Parent.References)
local ServerEventsModule = References.ServerEventsModule

local model = References.CavePasswordModel
local buttons = model.Buttons:GetChildren()

local sfx = SoundService.SFX

local buttonSfx = sfx["button.wav"]
local correctSfx = sfx["electronicpingshort.wav"]
local incorrectSfx = sfx["incorrect sound effect"]

local doorCodeVal = ServerStorage.DoorCode
local doorModule = require(script.Parent.DoorModule)

local password
repeat
	password = doorCodeVal.Value
	task.wait(0.5)
until password ~= 0
password = tostring(password)

local number = "" --Do not touch

local attempts = 0

--[=[
 Assigns a new string value to `number`.

 Use only this function to change `number`
 @param newNumber string
]=]
local function AssignNumber(newNumber: string)
	number = newNumber
	model.screen.SurfaceGui.TextLabel.Text = number
end

--------------------------------------------------------------buttons

model.Red.ClickDetector.MouseClick:Connect(function() -- CLear button
	model.Red.Color = Color3.new(0.666667, 0, 0)
	AssignNumber("") --Just clears the line
	task.wait(0.2)
	model.Red.Color = Color3.new(1, 0, 0)
end)

model.Green.ClickDetector.MouseClick:Connect(function(player) -- Enter button
	task.spawn(function()
		model.Green.Color = Color3.new(0, 0.666667, 0)
		task.wait(0.2)
		model.Green.Color = Color3.new(0, 1, 0)
	end)

	if number == password then
		correctSfx:Play()
		model.screen.BrickColor = BrickColor.new("Lime green") --changes screen color
		-- Open da door
		doorModule.openDoor()
		task.wait(5)
		model.screen.BrickColor = BrickColor.new("White")

		AssignNumber("") --Just clears the line
	else
		attempts += 1
		if attempts >= 3 and model.Parent.Parent.CodeObjects.KeyImage.Decal.Transparency == 1 then
			ServerEventsModule.FireDelusionalScene(player)
		end
		incorrectSfx:Play()
		model.screen.BrickColor = BrickColor.new("Really red") --changes screen color
		task.wait(1)
		AssignNumber("") --Just clears the line
		model.screen.BrickColor = BrickColor.new("White")
	end
end)

local function buttonPressColor(button)
	buttonSfx:Play()
	button.Color = Color3.new(0.654902, 0.654902, 0.654902)
	task.wait(0.2)
	button.Color = Color3.new(1, 1, 1)
end

local function PressButton(button: BasePart, buttonNumber: number)
	AssignNumber(number .. tostring(buttonNumber))
	buttonPressColor(button)
end

for i, button in buttons do
	button.ClickDetector.MouseClick:Connect(function()
		PressButton(button, i - 1)
	end)
end

-- model.bu0.ClickDetector.MouseClick:Connect(function() --Just buttons, better not to touch
-- 	AssignNumber(number .. "0")
-- 	buttonPressColor(model.bu0)
-- end)

-- model.bu1.ClickDetector.MouseClick:Connect(function()
-- 	AssignNumber(number .. "1")
-- 	buttonPressColor(model.bu1)
-- end)

-- model.bu2.ClickDetector.MouseClick:Connect(function()
-- 	AssignNumber(number .. "0")
-- 	number = number .. "2"
-- 	buttonPressColor(model.bu2)
-- end)

-- model.bu3.ClickDetector.MouseClick:Connect(function()
-- 	AssignNumber(number .. "0")
-- 	number = number .. "3"
-- 	buttonPressColor(model.bu3)
-- end)

-- model.bu4.ClickDetector.MouseClick:Connect(function()
-- 	AssignNumber(number .. "0")
-- 	number = number .. "4"
-- 	buttonPressColor(model.bu4)
-- end)

-- model.bu5.ClickDetector.MouseClick:Connect(function()
-- 	AssignNumber(number .. "0")
-- 	number = number .. "5"
-- 	buttonPressColor(model.bu5)
-- end)

-- model.bu6.ClickDetector.MouseClick:Connect(function()
-- 	AssignNumber(number .. "0")
-- 	number = number .. "6"
-- 	buttonPressColor(model.bu6)
-- end)

-- model.bu7.ClickDetector.MouseClick:Connect(function()
-- 	AssignNumber(number .. "0")
-- 	number = number .. "7"
-- 	buttonPressColor(model.bu7)
-- end)

-- model.bu8.ClickDetector.MouseClick:Connect(function()
-- 	AssignNumber(number .. "0")
-- 	number = number .. "8"
-- 	buttonPressColor(model.bu8)
-- end)

-- model.bu9.ClickDetector.MouseClick:Connect(function()
-- 	AssignNumber(number .. "9")
-- 	buttonPressColor(model.bu9)
-- end)

return {}
