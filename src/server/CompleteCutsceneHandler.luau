-- UPDATE AND VERIFY CUTSCENE STATUS

local References = require(script.Parent.References)

local eventsModule = References.ServerEventsModule
local gameInfoModule = require(script.Parent.GameInfoModule)

--- Set player Data to having completed the intro cutscene
eventsModule.ConnectCompletedIntro(function(player)
	eventsModule.FireSetDataAsync(player, "Cutscenes.Intro", true)
end)

--- Set player Data to having completed this cutscene
eventsModule.ConnectCompletedCutscene(function(player: Player, cutsceneName: string)
	if not table.find(gameInfoModule.CutsceneList, cutsceneName) then
		-- This isn't possible. Kick the player?
		player:Kick("Client attempted to manipulate cutscene data.")
		return
	end

	-- Verify any cutscenes that requires so here

	eventsModule.FireSetDataAsync(player, "Cutscenes." .. cutsceneName, true)
end)
