local CutsceneDataModule = {}

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
-- function TweenInfo.new(time: number?, easingStyle: Enum.EasingStyle?, easingDirection: Enum.EasingDirection?, repeatCount: number?, reverses: boolean?, delayTime: number?): TweenInfo
]]

CutsceneDataModule.IntroductionDrive = {
	MapFolder = game:GetService("ServerStorage").Assets["Security_NONE"].Maps.Cutscenes.IntroductionDrivingScene,
	BoxTeleportPart = game:GetService("ServerStorage").Assets["Security_NONE"].Maps.Cutscenes.IntroductionDrivingScene.PlayerBox.TPPart,
	CameraStartCFrame = CFrame.new(-519.934, 19.72, -1408.226) * CFrame.Angles(math.rad(-32.099), math.rad(0.401), 0),
	CameraKeyframes = {
		{
			CFrame = CFrame.new(985.983, 19.72, -1408.226) * CFrame.Angles(math.rad(-32.099), math.rad(0.401), 0),
			TweenInfo = {
				Duration = 60,
			},
			TimePosition = 0.00,
		},
	},
	AnimationKeyframes = {
		{
			Target = "game.ServerStorage.Assets.Security_NONE.Maps.Cutscenes.IntroductionDrivingScene.Jeep",
			Animation = "rbxassetid://91437771603580",
			TimePosition = 0.00,
		},
		{
			Target = "game.ServerStorage.Assets.Security_NONE.Maps.Cutscenes.IntroductionDrivingScene.Jeep.Primary",
			Animation = {
				TweenInfo = {
					Duration = 60,
				},
				TweenType = "CFrame",
				Value = CFrame.new(987.208, 9.2, -1419.397) * CFrame.Angles(0, math.rad(90), 0),
			},
			TimePosition = 0.00,
		},
	},
	DialogueKeyframes = {},
}

return CutsceneDataModule
