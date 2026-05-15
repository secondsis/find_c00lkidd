local musicGroupChildren = game:GetService("SoundService"):WaitForChild("Music"):GetChildren()

local eventsModule = require(script.Parent.ClientEventsModule)

-- Mute every music, but keep them all running so their time positions are changing
local function startMusic()
	for _, v in musicGroupChildren do
		if v:IsA("Sound") then
			v.Volume = 0
			v:Play()
		end
	end
end

eventsModule.ConnectStartMusic(startMusic)

-- Stop all music
local function turnOffMusic()
	for _, v in musicGroupChildren do
		if v:IsA("Sound") then
			v:Stop()
		end
	end
end

eventsModule.ConnectTurnOffMusic(turnOffMusic)
eventsModule.ConnectRemoteTurnOffMusic(turnOffMusic)

local paused = false
local saved_TimePositions = {}

-- Pause and save the music's time position
local function pauseMusic()
	if paused then
		return
	end
	paused = true
	for _, v in musicGroupChildren do
		if v:IsA("Sound") then
			table.insert(saved_TimePositions, v.TimePosition)
			v:Stop()
		end
	end
end

-- Resume Music at the previously saved time position
local function resumeMusic()
	if not paused then
		return
	end

	for i, v in musicGroupChildren do
		if v:IsA("Sound") then
			v.TimePosition = saved_TimePositions[i]
			v:Play()
		end
	end

	table.clear(saved_TimePositions)

	paused = false
end

eventsModule.ConnectPauseMusic(pauseMusic)
eventsModule.ConnectResumeMusic(resumeMusic)

return {}
