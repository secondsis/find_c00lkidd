local GuiService = game:GetService("GuiService")
local UIService = game:GetService("UserInputService")
local eventsModule = require(script.Parent.ClientEventsModule)

local Platform

if GuiService:IsTenFootInterface() then
	Platform = "console"
elseif UIService.TouchEnabled and not UIService.MouseEnabled then
	if workspace.CurrentCamera.ViewportSize.Y > 600 then
		Platform = "tablet"
	else
		Platform = "phone"
	end
else
	Platform = "pc"
end

local function getPlatform()
	return Platform
end

eventsModule.ConnectGetPlatform(getPlatform)
eventsModule.ConnectRemoteGetPlatform(getPlatform)

-- Dialogue hints customized here BECAUSE IDK

local dialogueFrame = game:GetService("Players").LocalPlayer.PlayerGui
	:WaitForChild("Dialogues")
	:WaitForChild("DialogueGui")
	:WaitForChild("Frame")
for _, _frame in dialogueFrame:GetChildren() do
	if _frame:IsA("Frame") then
		local skipHint = _frame:FindFirstChild("SkipHint")
		if skipHint then
			if Platform == "pc" then
				skipHint.Text = "Press E to skip"
			elseif Platform == "tablet" or Platform == "phone" then
				skipHint.Text = "Tap to skip"
			else
				skipHint.Text = "Press X to skip"
			end
		end
	end
end
