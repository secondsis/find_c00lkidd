local module = {}

-- One day I will make this server-only :pensive:

local player = game:GetService("Players").LocalPlayer

-- format: {{Name: string, Text: {string}, Speed: number, FontType: Enum.Font, Sfx: string}}
-- MUST have name and text

-- Font and sfx of characters (soon colors)
module.characterStyles = {
	["007e7"] = {
		Sfx = "blip",
		Box = "e7Box",
	},
	["You"] = {
		Sfx = "blip",
		Box = "e7Box",
	},
	["Cashier"] = {
		Sfx = "asriel",
		Box = "CashierBox",
	},
	["007n7"] = {
		Sfx = "blip",
		Box = "e7Box",
	},
	["Evil Rig"] = {
		Sfx = "asgore",
		Box = "CashierBox",
	},
}

module.EvilRigTalk = {
	{
		Name = "Evil Rig",
		Text = {
			"...",
			"It's useless, isn't it?",
			"...",
			"You always find the place.",
			"But don't think you can just get them without a fight.",
			"That's right.",
			"You.",
			"Everything that's happening is because of you. <b>All of you</b>.",
			"I may be a useless default rig, but that doesn't stop me from slowing you down.",
		},
	},
}

module.EvilRigTalk2 = {
	{
		Name = "Evil Rig",
		Text = {
			"...",
			"It's useless, isn't it?",
			"...",
			"I have them, but you will have to pass through me.",
		},
	},
}

module.EvilRigTalk3 = {
	{
		Name = "Evil Rig",
		Text = {
			"I'm only protecting them, don't you understand?",
			"No, of course you don't.",
		},
	},
}

module.EvilRigRandom1 = {
	{
		Name = "Evil Rig",
		Text = {
			"Don't you realize what you are doing?",
		},
	},
}

module.EvilRigRandom2 = {
	{
		Name = "Evil Rig",
		Text = {
			"IT is using you.",
		},
	},
}

module.EvilRigRandom3 = {
	{
		Name = "Evil Rig",
		Text = {
			"Can't you hear me?",
		},
	},
}

module.EvilRigRandom4 = {
	{
		Name = "Evil Rig",
		Text = {
			"I'm just trying to protect them.",
		},
	},
}

module.EvilRigRandom5 = {
	{
		Name = "Evil Rig",
		Text = {
			"People are disappearing.",
		},
	},
}

module.EvilRigRandom6 = {
	{
		Name = "Evil Rig",
		Text = {
			"It's all your fault.",
		},
	},
}

module.EvilRigRandom7 = {
	{
		Name = "Evil Rig",
		Text = {
			'A silent "protagonist"...',
		},
	},
}

module.EvilRigRandom8 = {
	{
		Name = "Evil Rig",
		Text = {
			"I won't hide anymore.",
		},
	},
}

module.EvilRigDeath1 = {
	{
		Name = "Evil Rig",
		Text = {
			"You can't just defeat me. Did you really think whacking trophies at me was going to work?",
			"The longer I can keep you busy, the more time I can give them all.",
			"INITIATE SECOND PHASE!",
			"...",
			"Why isn't this working?",
			"I said, I still have a second phase!",
			"...",
		},
	},
}

module.RockGuyDeath = {
	{
		Name = "Rock",
		Text = {
			"hold on hold on what is that",
		},
	},
}

module.RockGuyBlockingReply1 = {
	{
		Name = "Rock",
		Text = {
			"does it look like i can move bruh",
		},
	},
}

module.RockGuyBlocking = {
	{
		Name = "Rock",
		Text = {
			"where the heck am i",
			"dude why do i hear boss music",
		},
	},
	{
		Name = "/Options",
		Text = {
			"Get out of the way.",
		},
		Results = {
			module.RockGuyBlockingReply1,
		},
	},
}

module.BribeDoorTalkNormal = {
	{
		Name = "Door?",
		Text = {
			"...",
		},
	},
}

module.BribeDoorTalkCrowbar = {
	{
		Name = "Door?",
		Text = {
			"Get that thing away from me.",
			"I SAID GET IT AWAY",
			"TAKE THIS MONEY DANG IT",
		},
	},
}

return module
