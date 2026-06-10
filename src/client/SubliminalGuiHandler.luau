local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local gui = Players.LocalPlayer.PlayerGui:WaitForChild("SubliminalGui")
local TextLabel: TextLabel = gui.Frame.TextLabel
TextLabel.Text = ""

local module = {}

local function WaitOrTouch(seconds: number)
	local skip = false

	local cxn1 = UserInputService.TouchEnded:Connect(function(a0: InputObject, a1: boolean)
		print("skipped by touch")
		skip = true
	end)

	local cxn2 = UserInputService.InputEnded:Connect(function(inputObject: InputObject, a1: boolean)
		if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
			print("skipped by mouse")
			skip = true
		end
	end)

	local startTick = tick()
	local duration = 3
	while tick() < startTick + duration do
		if skip then
			break
		end

		task.wait()
	end
	cxn1:Disconnect()
	cxn2:Disconnect()
	cxn1 = nil
	cxn2 = nil
end

function module.PlaySubliminalText()
	gui.Enabled = true
	TextLabel.Text = "Wake up."
	WaitOrTouch(3)
	TextLabel.Text = "You are not alone."
	WaitOrTouch(3)
	TextLabel.Text = "Collect the endings and escape."
	WaitOrTouch(3)
	gui.Enabled = false
end

return module
