local KeyBind = require(game:GetService("ReplicatedStorage").Modules.Client.Keybind)

local dialogueSkipAction = KeyBind.GetAction("inDialogue", "dialogueSkip")
dialogueSkipAction.KeyboardBinding.KeyCode = Enum.KeyCode.E
dialogueSkipAction.GamepadBinding.KeyCode = Enum.KeyCode.ButtonX
