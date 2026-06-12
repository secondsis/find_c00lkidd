local SoundService = game:GetService("SoundService")
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
				Duration = 30,
			},
			TimePosition = 0.00,
		},
	},
	AnimationKeyframes = {
		{
			Target = "game.ServerStorage.Assets.Security_NONE.Maps.Cutscenes.IntroductionDrivingScene.Jeep",
			Animation = "rbxassetid://91437771603580",
			TimePosition = 0.00,
			EndPosition = 30.00,
		},
		{
			-- why does this no work
			Target = "game.ServerStorage.Assets.Security_NONE.Maps.Cutscenes.IntroductionDrivingScene.Jeep.Primary",
			Animation = {
				TweenInfo = {
					Duration = 30,
				},
				TweenType = "CFrame",
				Value = CFrame.new(987.208, 9.2, -1419.397) * CFrame.Angles(0, math.rad(90), 0),
			},
			TimePosition = 0.00,
		},
	},
	DialogueKeyframes = {},
	AudioKeyframes = {
		{
			Audio = SoundService.SFX["car door opening"],
			TimePosition = 0.00,
		},
		{
			Audio = SoundService.SFX["car engine start"],
			TimePosition = 1.00,
		},
		{
			Audio = SoundService.SFX["Truck Acceleration"],
			TimePosition = 2.00,
			EndPosition = 25.00,
		},
		{
			Audio = SoundService.SFX["ear-ring"],
			TimePosition = 27.00,
		},
	},
}

-- Entering the House as 007e7 looking for his cousin
CutsceneDataModule.IntroductionHouse = {
	MapFolder = game:GetService("ServerStorage").Assets["Security_NONE"].Maps.Cutscenes.IntroductionEnterHouse,
	TeleportPart = game:GetService("ServerStorage").Assets["Security_NONE"].Maps.Cutscenes.IntroductionEnterHouse.TPPart,
	CameraStartCFrame = CFrame.new(218.318, 8.766 + 171.128, 74.832)
		* CFrame.fromOrientation(math.rad(-20.403), math.rad(-164.618), 0),
	CameraKeyframes = {
		{
			CFrame = CFrame.new(224.63, 181.206, 80.883) * CFrame.Angles(math.rad(-14.059), math.rad(-179.198), 0),
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
					Duration = 5,
				},
				TweenType = "CFrame",
				Value = CFrame.new(224.625, 3.455 + 171.128, 111.39) * CFrame.Angles(0, math.pi, 0),
			},
			TimePosition = 0.00,
		},
		{
			-- Walking animation
			Target = "game.ServerStorage.Assets.Security_NONE.Maps.Cutscenes.IntroductionEnterHouse.007e7.Humanoid",
			Animation = "rbxassetid://106993552854913",
			TimePosition = 0.00,
			EndPosition = 5,
		},
		{
			-- Peek
			Target = "game.ServerStorage.Assets.Security_NONE.Maps.Cutscenes.IntroductionEnterHouse.007e7.Humanoid",
			Animation = "rbxassetid://80412463384009",
			WaitForPreviousEnd = true,
		},
		{
			-- Peek Idle, Waiting out on dialogue
			Target = "game.ServerStorage.Assets.Security_NONE.Maps.Cutscenes.IntroductionEnterHouse.007e7.Humanoid",
			Animation = "rbxassetid://77820894385233",
			WaitForPreviousEnd = true,
			EndPosition = 5 + 2.65 + 5, -- This should end 2 + 39/60 instead of 2.65
		},
		{
			-- Punch door -- need to wait to event to open door
			Target = "game.ServerStorage.Assets.Security_NONE.Maps.Cutscenes.IntroductionEnterHouse.007e7.Humanoid",
			Animation = "rbxassetid://135495793432694",
			WaitForPreviousEnd = true,
			-- OnEvent = {
			-- 	EventName = "Open",
			-- 	Callback = function()

			-- 	end
			-- }
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
			WaitForPreviousEvent = "OpenDoor",
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
			TimePosition = 5 + 2.65 + 4.99 + 3.1 + 28 / 60,
		},
		{
			-- Punch door idle until transition
			Target = "game.ServerStorage.Assets.Security_NONE.Maps.Cutscenes.IntroductionEnterHouse.007e7.Humanoid",
			Animation = "rbxassetid://93756319231245",
			WaitForEnd = "rbxassetid://135495793432694",
			EndPosition = 5 + 2.65 + 4.99 + 4 + 1 / 6 + 3, -- Waiting for a bit for player to absorb
		},
	},
	DialogueKeyframes = {
		{
			DialogueName = "Introduction_EnterHouse",
			TimePosition = 5 + 2.65,
		},
	},
	AudioKeyframes = {
		{
			Audio = SoundService.SFX.DoorBang,
			TimePosition = 5 + 2.65 + 4.99 + 3.1 + 28 / 60,
		},
	},
}

CutsceneDataModule.IntroductionSleep = {
	CameraStartCFrame = CFrame.new(233.759, 191.773, 118.205)
		* CFrame.fromOrientation(math.rad(-31.202), math.rad(93.207), 0),
	AnimationKeyframes = {
		-- {
		-- 	Target = "game.ServerStorage.Assets.Security_NONE.Maps.Cutscenes.IntroductionEnterHouse.Clone007e7.HumanoidRootPart",
		-- 	Animation = "rbxassetid://115026270646237",
		-- 	TimePosition = 12,
		-- },
	},
	DialogueKeyframes = {
		{
			DialogueName = "Introduction_Sleepy",
			TimePosition = 6,
		},
	},
	AudioKeyframes = {
		{
			Audio = SoundService.SFX.CrashSFX,
			TimePosition = 13.5,
		},
	},
}

return CutsceneDataModule
