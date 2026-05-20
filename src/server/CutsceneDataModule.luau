local CutsceneDataModule = {}

--[[
cutsceneData = {
    MapFolder = ServerStorage.WhateverFolder,
    TeleportPart = MapFolder.WhateverTPPart,
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

--- Follow the structure above (F12 view file)
CutsceneDataModule.IntroductionDrive = {
	MapFolder = game:GetService("ServerStorage").Assets["Security_NONE"].Maps.Cutscenes.IntroductionDrivingScene,
	TeleportPart = game:GetService("ServerStorage").Assets["Security_NONE"].Maps.Cutscenes.IntroductionDrivingScene.PlayerBox.TPPart,
	CameraStartCFrame = CFrame.new(-519.934, 19.72, -1408.226) * CFrame.Angles(math.rad(-32.099), math.rad(0.401), 0),
	CameraKeyframes = {
		{
			CFrame = CFrame.new(985.983, 19.72, -1408.226) * CFrame.Angles(math.rad(-32.099), math.rad(0.401), 0),
			TweenInfo = {
				Duration = 10,
			},
			TimePosition = 0.00,
		},
	},
	AnimationKeyframes = {
		{
			Target = "game.ServerStorage.Assets.Security_NONE.Maps.Cutscenes.IntroductionDrivingScene.Jeep",
			Animation = "rbxassetid://91437771603580",
			TimePosition = 0.00,
			EndPosition = 10.00,
		},
		{
			-- why does this no work
			Target = "game.ServerStorage.Assets.Security_NONE.Maps.Cutscenes.IntroductionDrivingScene.Jeep.Primary",
			Animation = {
				TweenInfo = {
					Duration = 10,
				},
				TweenType = "CFrame",
				Value = CFrame.new(987.208, 9.2, -1419.397) * CFrame.Angles(0, math.rad(90), 0),
			},
			TimePosition = 0.00,
		},
	},
	DialogueKeyframes = {},
}

-- Entering the House as 007e7 looking for his cousin
CutsceneDataModule.IntroductionHouse = {
	MapFolder = game:GetService("ServerStorage").Assets["Security_NONE"].Maps.Cutscenes.IntroductionEnterHouse,
	TeleportPart = game:GetService("ServerStorage").Assets["Security_NONE"].Maps.Cutscenes.IntroductionEnterHouse.TPPart,
	CameraStartCFrame = CFrame.new(218.318, 8.766 + 171.128, 74.832)
		* CFrame.Angles(math.rad(-20.403), math.rad(-164.618), 0),
	CameraKeyframes = {
		{
			CFrame = CFrame.new(227.856, 8.786 + 171.128, 125.478)
				* CFrame.Angles(math.rad(-17.704), math.rad(7.382), 0),
			TweenInfo = {
				Duration = 0,
			},
			TimePosition = 7.00,
		},
		{
			CFrame = CFrame.new(227.027, 6.156 + 171.128, 117.909)
				* CFrame.Angles(math.rad(-11.405), math.rad(6.182), 0),
			TweenInfo = {
				Duration = 0,
			},
			TimePosition = 7.00,
		},
	},
	AnimationKeyframes = {
		{
			-- Walk to House use the bare map
			Target = "game.ServerStorage.Assets.Security_NONE.Maps.Cutscenes.IntroductionEnterHouse.007e7.HumanoidRootPart",
			Animation = {
				TweenInfo = {
					Duration = 7,
				},
				TweenType = "CFrame",
				Value = CFrame.new(224.625, 3.455 + 171.128, 111.39) * CFrame.Angles(0, math.pi, 0),
			},
			TimePosition = 0.00,
		},
		{
			-- Peek
			Target = "game.ServerStorage.Assets.Security_NONE.Maps.Cutscenes.IntroductionEnterHouse.007e7",
			Animation = "rbxassetid://80412463384009",
			TimePosition = 0.00,
		},
		{
			-- Peek Idle, Waiting out on dialogue
			Target = "game.ServerStorage.Assets.Security_NONE.Maps.Cutscenes.IntroductionEnterHouse.007e7",
			Animation = "rbxassetid://77820894385233",
			TimePosition = 2.65,
		},
		{
			-- Punch door -- need to wait to event to open door
			Target = "game.ServerStorage.Assets.Security_NONE.Maps.Cutscenes.IntroductionEnterHouse.007e7",
			Animation = "rbxassetid://79230738893541",
			TimePosition = 2.65 + 0.15 + 0.4, -- Add how long dialogue takes
		},
		{
			-- Open Door
			Target = "game.ServerStorage.Assets.Security_NONE.Maps.Cutscenes.IntroductionEnterHouse.c00lHouse.Building.ExteriorDoor1.MovingDoorPart.Hinge",
			Animation = {
				TweenInfo = {
					Duration = 28 / 60,
				},
				TweenType = "CFrame",
				Value = CFrame.new(222.068, 4.327 + 171.128, 112.341) * CFrame.Angles(0, math.rad(-142.167), 0),
			},
			TimePosition = 2.65 + 3.1 + 0.55,
		},
		{
			-- Open Door 2
			Target = "game.ServerStorage.Assets.Security_NONE.Maps.Cutscenes.IntroductionEnterHouse.c00lHouse.Building.ExteriorDoor1.MovingDoorPart.Hinge",
			Animation = {
				TweenInfo = {
					Duration = 83 / 60 - 28 / 60,
				},
				TweenType = "CFrame",
				Value = CFrame.new(222.068, 4.327 + 171.128, 112.341) * CFrame.Angles(0, math.rad(-142.167), 0),
			},
			TimePosition = 2.65 + 3.1 + 28 / 60 + 0.55,
		},
		{
			-- Punch door idle until transition
			Target = "game.ServerStorage.Assets.Security_NONE.Maps.Cutscenes.IntroductionEnterHouse.007e7",
			Animation = "rbxassetid://93756319231245",
			TimePosition = 2.65 + 4 + 1 / 6 + 0.55, -- Waiting until transition is over
		},
	},
	DialogueKeyframes = {
		{
			DialogueName = "Introduction_EnterHouse",
			TimePosition = 2.65,
		},
	},
}

return CutsceneDataModule
