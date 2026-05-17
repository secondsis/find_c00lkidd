local module = {}

--[[
cutsceneData = {
    MapFolder = ServerStorage.WhateverFolder,
    BoxTeleportPart = MapFolder.WhateverTPPart,
    CameraKeyframes = {
        {
            CFrame = whatev,
            TweenInfo = TweenInfo.new(wwgareg),
            TimePosition = 0.00
        },
        {
            CFrame = whatev,
            TweenInfo = TweenInfo.new(wwgareg),
            TimePosition = 5.02 -- should be after the previous tween has completed
        },
    },
    AnimationKeyframes = {
        {
            Target = eag,
            Animation = "rbxassetid://91437771603580",
            TimePosition = 0.00 -- Time in seconds
        },
        {

        }
    },
    DialogueKeyframes = {
        {
            DialogueName = "whatever",
            TimePosition = 0.00
        },
        {
            DialogueName = "wae",
            TimePosition = 10.012
        }
    }
}
]]

module.IntroductionDrive = {
	MapFolder = game:GetService("ServerStorage").Assets["Security_NONE"].Maps.Cutscenes.IntroductionDrivingScene,
	BoxTeleportPart = game:GetService("ServerStorage").Assets["Security_NONE"].Maps.Cutscenes.IntroductionDrivingScene.PlayerBox.TPPart,
	CameraKeyframes = {
		{},
	},
	AnimationKeyframes = {
		{
			Target = game:GetService("ServerStorage").Assets["Security_NONE"].Maps.Cutscenes.IntroductionDrivingScene.Jeep,
		},
	},
	DialogueKeyframes = {},
}

return module
