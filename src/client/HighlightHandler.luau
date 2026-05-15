-- PROXIMITY PROMPT CONNECTIONS NEVER DISCONNECT. POTENTIAL MEMORY ISSUE HERE.

local collectionService = game:GetService("CollectionService")

local prompts = collectionService:GetTagged("Highlight")
local highlight = workspace.WhiteHighlight

local function hideHighlight()
	highlight.Enabled = false
end

local connectedPrompts = {}

while task.wait(5) do
	local newPrompts = collectionService:GetTagged("Highlight")
	prompts = newPrompts

	for _, prompt in prompts do
		if table.find(connectedPrompts, prompt) then
			continue
		end

		-- Value.Value is used to find what object to highlight
		local adornee = prompt:FindFirstChildOfClass("ObjectValue").Value

		local function showHighlight()
			highlight.Enabled = true
			highlight.Adornee = adornee
		end

		local cxn1 = prompt.PromptShown:Connect(showHighlight)
		local cxn2 = prompt.PromptHidden:Connect(hideHighlight)
		table.insert(connectedPrompts, prompt)
	end
end
