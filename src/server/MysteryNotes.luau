local References = require(script.Parent.References)

local eventsModule = References.ServerEventsModule

local notes = {
	"I hope these messages get out there. I don't think IT knows about this, thankfully.",
	"If you are wondering who I am, I cannot tell. IT would be alerted.",
	"IT has no name. Some of us call IT The Creation. Some think of IT as a ghostly presence. Personally, I don't see it like that.",
	"Either way, The Creation has no good intentions for us. IT was a mistake. The Creator wrote an algorithm that went rogue. That's what IT really is, to put it simply.",
	"What can you do about IT? If you're reading this, that means you are beyond IT's control or this situation is far worse than I thought. You must convince The Creator to shut IT down. I don't know why they haven't done so already.",
	"I wish I help more, but there is only so much you can do behind a backdoor before you are noticed.",
	"I don't know how to fight IT, but The Creator must know. IT trapped me here along with others. Please help us.",
	"If you know ___e_, tell him I said hi. I-I don't know why this message keeps getting blocked. I think maybe it fouư̷̧̨̡̘̟̭͙̦͖̱̯̤̦̞̳̻ͦͩ̇ͤͬ̓̿̔ͥͫ̔͂̓ͫ̾̅͛ͦ͘͠͠͠ư̢̡͕̻͔͔͈͇͉̻͋̒ͨ̽̆̒̾͊͐̀͞͠ư̭̘̤̝̿ͣ̾__̸͚̖̺̪̈́̀ͩ̓̏ư̧̻̞͈͙͎̠͋ͨ̈́ư͔̫͍ͮͧ̉̿̍̊͢_̷̵̤̘̞͔͎̯̥̦̜́͑́͌ͫ͟͞u̢̪̱̮̲̳̖̍̂̏͟͞_̢̭̠̖̹̳͂̿́ͮ͒̎͜ų̮̟̽̓͑ͨ̆ͩ̔͢͡_ͪ̌ú̸̹̳̱̮͉͍͔̜́ͨ̔ͧͩͤ̄̋͆͊̿̑ͪ̋ͬ͢͝ͅu̴̵̴̢̨̳͇̮̟̟̗ͣ͐ͥ̂͛̈̕͜u̶̠͋̅̉ͥ̚_̡̘̼̖̠̲͔̟͈̪̫͇͇̯͇͖ͣ̂͆́ͨ̋͊͌̌͊̿ͬu̫̥̙ͤ͗ų̴̧͔̳͙̜̥̘̹̭͍͍͌͛̀̍u̹͇̝͚ͮ̅̋ͫͤ̇͘u͇u̧̨̱͉͖͉̪̩̫̬̙͔̯͇̬͇͒̓ͦ̉̆ͣͭ̃̀͋̅̾ͦ͌̇ͤͯͩ͂͜͟͞͞uṳ̢̢̣͓̦͕̃ͨ͆͐̀ͫͯ͐ͨ͢͢͞ứ̧̨͓̙̣͔͔͎̻̫̤̉ͣ̀̍ͦͭ̅ͤ̾ͭͮ̌͢͞͡ȗ̵̸͕̠̜̏ͫ͆͑ͅų̤͔̭̮͚͇̯̻̦̈́̽̏ͣͮ̈̈́̑̐͗̌͑́̚͢_ȕ̧̳͍̥̮̯͔̙͙̹̙̏̍̉ͭ͛̒̋̃́́̕͘͢͞ų͒ͧ",
}

local function getNote(noteNumber: number)
	return notes[noteNumber]
end

eventsModule.ConnectFetchNote(getNote)
