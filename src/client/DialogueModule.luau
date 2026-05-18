local module = {}

local player = game:GetService("Players").LocalPlayer

-- format: {{Name: string, Text: {string}, Speed: number, FontType: Enum.Font, Sfx: string}}
-- MUST have name and text

-- Need to rework this
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
}

do -- STORY-RELEVANT
	-- Intro Scene
	module.Introduction_PhoneCallReply = nil
	module.Introduction_PhoneCall = {
		{
			Name = "007n7",
			Text = { "Yo e7? Is that you?" },
		},
		{
			Name = "007e7",
			Text = { "Yea, wsp bro?" },
		},
		{
			Name = "007n7",
			Text = { "Dude you don’t know how glad I am to be hearing your voice..." },
		},
		{
			Name = "007e7",
			Text = { "Did smth happen?" },
		},
		{
			Name = "007n7",
			Text = { "no" },
		},
		{
			Name = "007e7",
			Text = { "wow why are you calling me then" },
		},
		{
			Name = "007n7",
			Text = {
				"BECAUSE THINGS HAVE BEEN INSANE!!",
				'Are you kidding me? "Did smth happen?"',
				"...",
				"I don't want to be mean or anything,",
				"but have you not heard the news?",
				"MY KIDD IS MISSING BRO!!!",
				"I've been pulling my HAIR STRANDS out. I am going BALD at this rate!",
				"Oh wait, I literally have a burger as a hat.",
			},
		},
		{
			Name = "007e7",
			Text = {
				"Damn. That sucks man.",
				"What can I do to help?",
				"Do you need me to come over 'cause I can definitely do that.",
			},
		},
		{
			Name = "007n7",
			Text = {
				"Yeah.",
				"You gotta help me find him.",
			},
		},
		{
			Name = "/Options",
			Text = {
				"Going over rn.",
			},
			Results = {
				module.Introduction_PhoneCallReply,
			},
		},
	}

	module.Introduction_PhoneCallReply = {

		{
			Name = "007n7",
			Text = {
				"Thanks man.",
			},
		},
	}

	-- 007e7 comes over to the house driving scene or something
	-- he drives into the forest and the forest thins out into trunks and then those disappear and the spectre comes over the sky

	module.Introduction_EnterHouse = {
		{
			Name = "007e7",
			Text = {
				"n7?",
				"Hellooo?",
			},
		},
	}

	-- 007e7 Walks inside to see around

	module.Introduction_House = {
		{
			Name = "007e7",
			Text = {
				"I guess I'll search the house then",
			},
		},
	}

	-- You go into a searching mission in the house

	-- After searching around, you find nothing and get tired and go to sleep

	module.Introduction_Sleepy = {
		{
			Name = "007e7",
			Text = {
				"Maybe he's just out looking for c00lkidd",
				"But I'm getting pretty tired sooo...",
			},
		},
	}

	-- You go sleep on yo cuz's bed cuz ur like that

	-- RESTAURANT SPAWN RIG(?)
	--module.SpawnRigTalk1 = {
	--	{
	--		Name = "Rig?",
	--		Text = {
	--			"FINALLY SOMEONE!",
	--			"Please help me I've been stuck here for so long-",
	--			"I'm in so much pain...",
	--			"These guys here are not real.",
	--			"I-I don't know what's real anymore.",
	--			"I've been in here hiding...",
	--			"This place is <b>not what it seems.</b>"
	--		}
	--	},
	--	{
	--		Name = "007e7",
	--		Text = {
	--			"Uhh yep this town is definitely cursed.",
	--			"Surely this isn't what it normally is like right-"
	--		}
	--	},
	--	{
	--		Name = "Rig?",
	--		Text = {
	--			"NO! OF COURSE NOT!",
	--			"Something happened... a-and I don't know what exactly.",
	--			"I can't remember <i>anything</i>.",
	--			"B-but one moment I was doing fine and then there was this-"
	--		}
	--	}
	--}
	module.SpawnRigTalk1 = {
		{
			Name = "Rig?",
			Text = {
				"[BEING RETCONNED]",
			},
		},
		{
			Name = "007e7",
			Text = {
				"Uhh yep this town is definitely cursed.",
				"Surely this isn't what it normally is like right-",
			},
		},
		{
			Name = "Rig?",
			Text = {
				"[BEING RETCONNED]",
			},
		},
	}
	-- Play disturbing sound and change rig? face
	--module.SpawnRigTalk2 = {
	--	{
	--		Name = "007e7",
	--		Text = {
	--			"You good?"
	--		}
	--	},
	--	{
	--		Name = "Rig?",
	--		Text = {
	--			"<i>ImnotfineImnotfineImnotfine</i>",
	--			"I... can't say anything else for now.",
	--			"Take this ending so I can escape for just a bit."
	--		}
	--	}
	--}

	module.SpawnRigTalk2 = {
		{
			Name = "007e7",
			Text = {
				"You good?",
			},
		},
		{
			Name = "Rig?",
			Text = {
				"[BEING RETCONNED]",
			},
		},
	}

	-- FROG ENDING
	module.FrogEnding = {
		{
			Name = "007e7",
			Text = {
				"Um well I saw that frog back-",
			},
		},
	}

	-- BLOXY COLA ADDICT
	module.BloxyColaAddictTalk1 = {
		{
			Name = "Bloxy Cola Addict",
			Text = {
				"Hey there man.",
				"I could really use a Bloxy Cola right now...",
				"If I go one more second without that sweet sweet nectar-",
				"...",
				"I will start eating the one on this poster.",
			},
		},
		{
			Name = "007e7",
			Text = {
				"<i>(Maybe I should help this guy.)</i>",
			},
		},
	}

	module.BloxyColaAddictTalk2 = {
		{
			Name = "Bloxy Cola Addict",
			Text = {
				"oh. my. GOD. Is that- the signature ten pack of bloxy colas??!!??!",
				"Are these for me?",
			},
		},
	}

	module.BloxyColaAddictTalk3 = {
		{
			Name = "Bloxy Cola Addict",
			Text = {
				"THANKYOUTHANKYOUTHAKNKSTOU",
			},
		},
	}

	module.BloxyColaAddictTalk4 = {
		{
			Name = "Bloxy Cola Addict",
			Text = {
				"FREEEEEEEEEEEDOMMMMMMMMM!!!!!!!!!!!!",
			},
			Speed = 0.001,
		},
	}

	-- Shedletsky
	module.ShedletskyEnding1 = {
		{
			Name = "Shedletsky",
			Text = {
				"Got a chicken for me?",
				"I am literally at 12 hp.",
			},
		},
		{
			Name = "007e7",
			Text = {
				"Um what..?",
			},
		},
		{
			Name = "Shedletsky",
			Text = {
				"Alright, I'll steal it from you instead.",
			},
		},
	}

	module.ShedletskyEnding2 = {
		{
			Name = "Shedletsky",
			Text = {
				"CH ICKE     N",
			},
		},
	}

	module.JDTalk1 = {
		{
			Name = "?",
			Text = {
				"Oh! e7! Welcome! Sorry about earlier.",
			},
		},
		{
			Name = "007e7",
			Text = {
				"What even was that-",
			},
		},
		{
			Name = "?",
			Text = {
				"YOU. <b>" .. player.Name .. ".</b>",
			},
			-- JD creates a prison and knocks out the player.
		},
	}

	module.JDTalk2 = {
		{
			Name = "007e7",
			Text = {
				"Dude. Why is everyone here so weird?",
			},
		},
		{
			Name = "?",
			Text = {
				"I'll explain everything, but we need to talk <i>quietly</i>.",
				"The fact that <b>" .. player.Name .. "</b> is here means we aren't safe.",
			},
		},
	}

	module.JDTalk3 = {
		{
			Name = '"JD"',
			Text = {
				"I told <b>YOU</b> to leave earlier.",
				"<b>YOU</b> should've listened.",
				"As long as <b>you're</b> here, <b>it</b> is here too.",
				"...",
				"But I really can't stop <b>you</b>, can I?",
				"It is inevitable.",
			},
		},
	}
end

do -- WORLD BUILDING / RANDOM NPCS
	-- ROCK GUY
	module.RockGuyBlockingReply1 = {
		{
			Name = "Rock",
			Text = {
				"thats what ive been told, sorry.",
			},
		},
	}

	module.RockGuyBlockReply2Reply1 = {
		{
			Name = "Rock",
			Text = {
				"omg!1!1 im sooo scared!!",
				"yeah imagine finding dynamite in this tiny town",
			},
		},
	}

	module.RockGuyDeath = {
		{
			Name = "Rock",
			Text = {
				"...",
				"<i>not again...</i>",
			},
		},
	}

	module.RockGuyBlockingReply2 = {
		{
			Name = "Rock",
			Text = {
				"ok",
			},
		},
		{
			Name = "/Options",
			Text = {
				"<i>I could blow you up...</i>",
			},
			Results = {
				module.RockGuyBlockReply2Reply1,
			},
		},
	}

	module.RockGuyBlocking = {
		{
			Name = "Rock",
			Text = {
				"this is my spot.",
				"you cant pass.",
			},
		},
		{
			Name = "/Options",
			Text = {
				"Bruh",
				"Well idc",
			},
			Results = {
				module.RockGuyBlockingReply1,
				module.RockGuyBlockingReply2,
			},
		},
	}

	-- RESTAURANT RIGS
	module.RigTalk = {
		{
			Name = "Rig",
			Text = {
				"Greetings, dear customer.",
				"We regret to inform you that the restaurant has run out of meals.",
				"Please come back at a later time.",
			},
		},
		{
			Name = "007e7",
			Text = {
				"This town is so weird...",
			},
		},
	}

	-- RESTAURANT WALL/DOOR
	module.RestaurantWallTalk = {
		{
			Name = "Wall",
			Text = {
				"Stop talking to a wall there was never a door here",
				"ur just being schizo",
			},
		},
	}

	-- CASHIER
	module.CashierTalk1 = {
		{
			Name = "Cashier",
			Text = {
				"You can just go and buy items.",
				"I don't know what my purpose is.",
				"They have some sorta magic that lets you instantly buy.",
			},
		},
	}

	-- MIRRORS
	module.RealisticMirrorTalk1 = {
		{
			Name = "007e7",
			Text = {
				"Wow. Didn't know he had an actually functioning mirror.",
				"Not sure why, but those are pretty rare to find.",
			},
		},
		{
			Name = "",
			Text = {
				"\n\n\n\n<i>Probably because Roblox doesn't have in-built mirrors (BRUH)</i>",
			},
		},
	}

	module.RealisticMirrorTalk2 = {
		{
			Name = "007e7",
			Text = {
				"I need to find them.",
				"I shouldn't be staring at a mirror forever.",
			},
		},
	}

	module.RealisticMirrorTalkLowQuality = {
		{
			Name = "Mirror",
			Text = {
				"Since I am laggy, the <b>Developer</b> decided to turn me off when your graphics setting is 1.",
				"Your potato devices are saved from imploding, don't worry.",
				"The <b>Developer</b> has sympathy since they literally use a laptop.",
			},
		},
	}

	module.MirrorTalk1 = {
		{
			Name = "",
			Text = {
				"The dev ran out of fps budget",
				"yeah i made this game on a laptop",
			},
		},
	}

	-- 007n7 MISSING POSTER
	module.MissingPoster007n7Talk = {
		{
			Name = "007e7",
			Text = {
				"This isn't even his main account",
				"He actually stole my naming style lol",
			},
		},
	}

	-- HOUSES
	module.HouseTalk = {
		{
			Name = "The House Door",
			Text = {
				"Go away",
			},
		},
	}

	module.WeirdHouseTalk = {
		{
			Name = "Door?",
			Text = {
				"As the only conscious door, I advise you to leave this humble abode.",
			},
		},
	}

	module.HouseDeath = {
		{
			Name = "The House Door",
			Text = {
				"NOOO MY WORST FEAR!!!",
				"A <b>Crowbar</b>.",
				"*dies le epicly*",
			},
		},
	}

	module.WeirdHouseDeath = {
		{
			Name = "Door?",
			Text = {
				"Get that thing away from me.",
				"Don't even try.",
			},
		},
	}

	module.CoolBedInteraction = {
		{
			Name = "007e7",
			Text = {
				"I'm not doing that.",
			},
		},
	}

	module.CoolBedInteractionTooMuch = {
		{
			Name = "007e7",
			Text = {
				"I get a feeling that <b>something</b> is controlling me.",
			},
		},
	}

	module.CoolBedInteractionTooMuchTwo = {
		{
			Name = "007e7",
			Text = {
				"...",
			},
		},
	}
end

do -- EASTER EGGS
	-- Unknown Random Encounter (outside cave)
	module.UnknownCharacterRandomEvent = {
		{
			Name = "Unknown",
			Text = {
				"Hi there, " .. player.DisplayName .. "...",
				"Yes, I know who you are.",
				"You will see me on <b>the other side</b>.",
			},
		},
	}
end

do -- ???
	module.n7Talk1 = {
		{
			Name = "007n7",
			Text = {
				"Help us 007e7.",
				"It has trapped us, everyone.",
				"I've been trying to contact you using the c00lgui.",
				"It seems to have finally worked.",
				"In doing this, I have also given you your own version of it.",
				"Use it to fight against the creation.",
			},
		},
	}
end

return module
