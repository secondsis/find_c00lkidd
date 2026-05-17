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
	CameraStartCFrame = CFrame.new(-519.934, 19.72, -1408.226) * CFrame.fromOrientation(-32.099, 0.401, -0.001),
	CameraKeyframes = {
		{
			CFrame = CFrame.new(-519.934, 19.72, -1408.226) * CFrame.fromOrientation(-32.099, 0.401, -0.001),
			TweenInfo = TweenInfo.new(5),
			TimePosition = 0.00,
		},
	},
	AnimationKeyframes = {
		{
			Target = game:GetService("ServerStorage").Assets["Security_NONE"].Maps.Cutscenes.IntroductionDrivingScene.Jeep,
			Animation = "rbxassetid://91437771603580",
			TimePosition = 0.00,
		},
		{
			Target = game:GetService("ServerStorage").Assets["Security_NONE"].Maps.Cutscenes.IntroductionDrivingScene.Jeep,
			Animation = {
				TweenInfo = TweenInfo.new(5),
				TweenType = "CFrame",
				Value = 
			},
            TimePosition = 0.00
		},
	},
	DialogueKeyframes = {},
}

return module
