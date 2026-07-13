local module = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local SoundService = game:GetService("SoundService")
local TextChatService = game:GetService("TextChatService")

-- WHY ARE SPIKES LAGGY?

--[[ MOVESET:
	Slashes (1)
	Rotator (1)
	Hot geysers (1)
	Sweepers (1)
	John Doe-like spikes (1)
	Floor is lava (1)
	Homing Projectile (2)
	Charge Attack (2)
	Floor is lava but with tricks (2)
	Sweeper + Geyser (2)
	Rotator + Homing (2)
	Obby + Slashes (2)
	Bait attacks (3)
	
	
	
	descriptions (yes this is from gpt... im sry guys..)
	Homing Projectile – The boss fires slow-moving orbs that track the nearest player. Players must outrun them or lead them into walls to destroy them.

Charge Attack – The boss locks onto a player, gives a short wind-up (audio/visual cue), and dashes in a straight line. Leaves a damaging trail or shockwave on impact.

Fake Safe Zones – Similar to a “floor is lava” mechanic, but sometimes the highlighted safe zone is a trap and the real safe zone appears a moment later. Forces quick recognition instead of blind reaction.

Sweeper + Geyser – While sweeping blades move across the map, random geyser circles appear to block safe routes.

Rotator + Homing – Rotating blade hazard while the boss also launches a few tracking projectiles.

Obby + Projectile Barrage – While players are doing the “lava rise” obby, the boss throws projectiles to make the climb harder.

Arena Shrink – Walls close in over time, forcing players into a smaller space for the duration of the phase.

Wind - messes up player movement

Bait Attack – The boss fakes a big attack (animation + sound) but cancels into a different attack. (like 1x shooting projectiles and changing direction)

Enraged - At low hp, attacks become faster and more complex
]]

local TweenInfonew = TweenInfo.new
local CFrameAngles = CFrame.Angles
local Vector3new = Vector3.new
local Color3new = Color3.new
local CFramenew = CFrame.new

local BossHealthHandler = require(script.Parent.BossHealthHandler)
local eventsModule = require(script.Parent.SERVER_EVENTS)
local cutsceneModule = require(ReplicatedStorage.Shared.CutsceneModule)
local signalModule = require(ReplicatedStorage.SignalGetter)

local evilRig = ReplicatedStorage.EvilRig
local resumeBattleEvent = ReplicatedStorage.RemoteEvents.ResumeBattle

--[player][part] = lastTick
local debounceMap = {}
local killbrickConnections = {}
local battle_cancelled = false
local lava_attack = false
local lava_deaths = 0
local quickStart = true -- reset this
local noobMode = false

eventsModule.ConnectRemoteSetBattleQuickStart(function(player)
	print("quick started")
	quickStart = true
end)

-- Died too much to lava?
eventsModule.ConnectRemoteSetNoobMode(function(player, lavaDeaths: number)
	lava_deaths = lavaDeaths
	if lavaDeaths >= 2 then
		noobMode = true
	end
end)

Players.PlayerAdded:Connect(function(player)
	debounceMap[player] = {}
end)

Players.PlayerRemoving:Connect(function(player)
	table.remove(debounceMap, table.find(debounceMap, player))
end)

local function TeleportPlayerToArena(player: Player)
	local char = player.Character
	if not char then
		return
	end
	local _, playerSize = char:GetBoundingBox()
	char:PivotTo(CFrame.new(workspace.BattleArena.ArenaTPPart.Position + Vector3.new(0, playerSize.Y / 2, 0)))
end

local function ResetPlayerHP(player: Player)
	local char = player.Character
	if not char then
		return
	end

	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end
	humanoid.Health = humanoid.MaxHealth
end

-- Will be called when the player reaches 0 hp and presses the contibue btn
local function RestartBattle(player: Player)
	-- -- Reset player HP
	-- ResetPlayerHP(player)
	-- -- And Boss HP
	-- -- (BossHealthHandler listens to the event on its own)
	-- -- Teleport them to arena
	-- TeleportPlayerToArena(player)

	-- Just have the player rejoin
	eventsModule.FireTeleportToPlace(player, 78907491464330, {
		["Password"] = "Brombus_" .. tostring(player.UserId % 236 * 100),
		["QuickStart"] = true,
		["LavaDeaths"] = lava_deaths,
	})
end

-- holy circus hot potato
eventsModule.ConnectRemotePlayerDeath(function(player)
	print("Got signal player died!")
	-- camera cframe {3.665, -84.16, -161.031}, {-4.5, 89.817, 0}
	--just keep the death box always there
	-- When player dies, teleport their camera to the death box (if it doesn't load, then youll just have to put a playerbox too for it)
	-- Upon clicking the continue btn, player will spawn immediately back into the arena. Evil Rig may comment on this sometimes.

	-- battle_cancelled = true

	-- cutsceneModule.changeCamCFrame(
	-- 	player,
	-- 	CFramenew(3.665, -84.16, -161.031) * CFrame.fromOrientation(math.rad(-4.5), math.rad(90), 0)
	-- )

	-- Fire it back for the client to handle the gui stuff
	-- eventsModule.FireRemotePlayerDeath(player)
	if lava_attack then
		lava_deaths += 1
	end

	battle_cancelled = true
end)

eventsModule.ConnectRemoteRestartBattle(RestartBattle)

-- local function battleWait(seconds: number): boolean
-- 	local startTick = tick()
-- 	while startTick + seconds > tick() do
-- 		if battle_cancelled then
-- 			return true
-- 		end
-- 		task.wait()
-- 	end
-- 	return false
-- end

local function damagePlayer(player: Player, part)
	local char = player.Character
	if not char then
		return false
	end
	--prob couldve done findfirstoftype or whatevs (ok did it)
	local humanoid: Humanoid = char:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return false
	end
	local success, msg = pcall(function()
		assert(humanoid:IsA("Humanoid"))
	end)

	if not success then
		player:Kick("Player is faking the Humanoid. If this was a mistake, message the developer.")
	end

	local ignoreInvincibility = part:GetAttribute("IgnoreInvincibility")
	local invincible = player:GetAttribute("Invincible")
	if invincible and not ignoreInvincibility then
		return false
	end

	local lastDamageTick = debounceMap[player][part] or 0
	local cooldown = part:GetAttribute("DamageCooldown") or 1

	local now = tick()

	if now - lastDamageTick >= cooldown then
		local amount = part:GetAttribute("DamageAmount") or 10
		humanoid:TakeDamage(amount)
		debounceMap[player][part] = now
		return true
	else
		return false
	end
end

local function addKillbrickConnection(newKillbrick: BasePart)
	if newKillbrick:IsA("BasePart") and newKillbrick:IsDescendantOf(workspace) then
		killbrickConnections[newKillbrick] = newKillbrick.Touched:Connect(function(other)
			if other.Name ~= "HumanoidRootPart" then
				return
			end
			if other.Parent then
				local player = Players:GetPlayerFromCharacter(other.Parent)
				if player then
					damagePlayer(player, newKillbrick)
				end
			end
		end)
	end
end

local function removeKillbrickConnection(killbrick: BasePart)
	if killbrickConnections[killbrick] then
		killbrickConnections[killbrick]:Disconnect()
		table.remove(killbrickConnections, table.find(killbrickConnections, killbrick))
	end
end

local function getRandomPlayer()
	local playerList = Players:GetPlayers()
	if not playerList or #playerList == 0 then
		return nil
	end
	return playerList[math.random(#playerList)]
end

local killbrickFolder = ServerStorage.Killbricks.Killbricks

local rotator = killbrickFolder.Rotator

local sweeperFolder = killbrickFolder.Sweepers:GetChildren()

local function rotatorAttack()
	local newRotator = rotator:Clone()
	newRotator.Parent = workspace
	TweenService:Create(newRotator.Rotator, TweenInfonew(1), {
		Transparency = 0,
	}):Play()
	TweenService:Create(newRotator.Blade, TweenInfonew(1), {
		Transparency = 0,
	}):Play()

	task.wait(1)

	addKillbrickConnection(newRotator.Blade)

	local cxn
	cxn = RunService.PostSimulation:Connect(function(delta)
		newRotator.Rotator.CFrame *= CFrameAngles(math.pi / 4 * delta, 0, 0)
	end)

	task.wait(9.5)
	-- if battleWait(9.5) then
	-- 	return true
	-- end

	removeKillbrickConnection(newRotator.Blade)
	TweenService:Create(newRotator.Rotator, TweenInfonew(1), {
		Transparency = 1,
	}):Play()
	TweenService:Create(newRotator.Blade, TweenInfonew(1), {
		Transparency = 1,
	}):Play()
	task.wait(1)
	-- if battleWait(1) then
	-- 	return true
	-- end

	cxn:Disconnect()
	newRotator:Destroy()
	return false
end

-- No return. Attacks are handled per frame.
local function sweeperAttack(level: number)
	local sweeperAmount = 1
	local speed = 100

	if level == 1 then
		sweeperAmount = 1
		speed = 100
	elseif level == 2 then
		sweeperAmount = 2
		speed = 150
	end

	for i = 1, sweeperAmount do
		task.wait(0.2)
		-- Pick a sweeper
		local sweeper = sweeperFolder[math.random(#sweeperFolder)]:Clone()
		sweeper.Parent = workspace
		addKillbrickConnection(sweeper)
		local direction: Vector3 = sweeper:GetAttribute("direction")
		local axis
		if direction.Z ~= 0 then
			axis = "Z"
		elseif direction.Y ~= 0 then
			axis = "Y"
		else
			axis = "X"
		end

		local sweeperStartPos = sweeper.Position[axis]
		local cxn
		cxn = RunService.PostSimulation:Connect(function(delta)
			sweeper.CFrame += direction * delta * speed
			if
				(direction[axis] > 0 and sweeperStartPos + direction[axis] * 400 < sweeper.Position[axis])
				or (direction[axis] < 0 and sweeperStartPos + direction[axis] * 400 > sweeper.Position[axis])
				-- or battle_cancelled
			then
				cxn:Disconnect()
				removeKillbrickConnection(sweeper)
				if sweeper then
					sweeper:Destroy()
				end
				return
			end
		end)
	end
end

local geyserWarning = killbrickFolder.GeyserWarning

local function geyserAttack(level: number)
	local amount = 100
	if level == 1 then
		amount = 100
	elseif level == 2 then
		amount = 200
	end

	local function geyserErupt(newGeyser: BasePart)
		local geyserTween = TweenService:Create(newGeyser, TweenInfonew(1), {
			Transparency = 0,
		})
		geyserTween:Play()
		task.wait(1)
		local startTick = tick()
		while startTick + 0.5 > tick() do
			newGeyser.Color = Color3new(1, 0, 0)
			newGeyser.warning:Play()
			task.wait(0.1)
			newGeyser.Color = Color3new(1, 85 / 255, 0)
			newGeyser.warning:Play()
			task.wait(0.1)
		end
		newGeyser.Transparency = 1
		print(newGeyser.Name)

		CollectionService:AddTag(newGeyser.Hitbox, "Killbrick")
		addKillbrickConnection(newGeyser.Hitbox)
		newGeyser.Flame.volcano:Play()
		--newGeyser.Flame.Main.CFrame = CFramenew(Vector3.zero)
		for _, emitter in newGeyser.Flame.Main:GetChildren() do
			if emitter:IsA("ParticleEmitter") then
				emitter.Enabled = true
			end
		end
		task.wait(6)
		-- battleWait(6)
		removeKillbrickConnection(newGeyser.Hitbox)
		newGeyser:Destroy()
		return
	end

	for i = 1, amount do
		local newGeyser = geyserWarning:Clone()
		local _, _, _, c1, c2, c3, c4, c5, c6, c7, c8, c9 = newGeyser.CFrame:GetComponents()
		-- only in integers, but fine ig
		newGeyser:PivotTo(
			CFramenew(math.random(-174, 136), 778.803, math.random(-149, 159), c1, c2, c3, c4, c5, c6, c7, c8, c9)
		)
		newGeyser.Parent = workspace

		task.spawn(function()
			geyserErupt(newGeyser)
		end)
		task.wait(0.05)
	end
	task.wait(10)
	-- battleWait(10)
end

local lavaPlatform = ServerStorage.Other.Platform
local lavaPart = killbrickFolder.Lava

local function floorIsLavaAttack1(level: number)
	local platformAmount = 50
	local fakes = false
	lava_attack = true

	if level == 1 then
		platformAmount = 50
		fakes = false
	elseif level == 2 then
		platformAmount = 50
		fakes = true
	else
		platformAmount = 30
		fakes = true
	end

	local newLava = lavaPart:Clone()
	local fractureModule = require(ServerScriptService.PartFractureModule)

	local platforms = {}

	for i = 1, platformAmount do
		local isFake = false
		if fakes then
			isFake = math.random() >= 0.75
		end

		local warningTimer = 1
		if fakes then
			warningTimer = 4
		end

		if not isFake then
			local newPlatform = lavaPlatform:Clone()
			table.insert(platforms, newPlatform)
			local platformWarning = newPlatform.PlatformWarning

			local _, _, _, c1, c2, c3, c4, c5, c6, c7, c8, c9 = platformWarning.CFrame:GetComponents()
			platformWarning:PivotTo(
				CFramenew(math.random(-150, 100), 778.803, math.random(-100, 100), c1, c2, c3, c4, c5, c6, c7, c8, c9)
			)

			-- newPlatform.PlatformWarning.Detection.Touched:Connect(function(other)
			-- 	if not other.Parent then
			-- 		return
			-- 	end

			-- 	local player = Players:GetPlayerFromCharacter(other.Parent)
			-- 	if not player then
			-- 		return
			-- 	end
			-- 	local char = player.Character
			-- 	if not char then
			-- 		return
			-- 	end
			-- 	local hrp = char:FindFirstChild("HumanoidRootPart")
			-- 	if not hrp then
			-- 		return
			-- 	end

			-- 	local weldConstraint = Instance.new("WeldConstraint")
			-- 	weldConstraint.Enabled = false
			-- 	weldConstraint.Part0 = newPlatform.PlatformWarning.Detection
			-- 	weldConstraint.Part1 = hrp
			-- 	weldConstraint.Parent = newPlatform.PlatformWarning.Detection
			-- 	task.wait(1)
			-- 	weldConstraint.Enabled = true
			-- end)

			newPlatform.Parent = workspace

			task.spawn(function()
				local platformWarningTween = TweenService:Create(platformWarning, TweenInfonew(3), {
					Transparency = 0,
				})
				platformWarningTween:Play()
				task.wait(3)
				local startTick = tick()
				while startTick + warningTimer > tick() do
					platformWarning.Color = Color3new(0, 85 / 255, 0)
					platformWarning.warning:Play()
					task.wait(0.1)
					platformWarning.Color = Color3new(0, 1, 0)
					platformWarning.warning:Play()
					task.wait(0.1)
				end

				platformWarning.Transparency = 1

				local platformRiseTween = TweenService:Create(platformWarning, TweenInfonew(1), {
					CFrame = platformWarning.CFrame + Vector3.new(0, 60, 0),
				})
				platformWarning.Platform.Transparency = 0
				platformWarning.Platform["grind concrete"]:Play()
				-- platformWarning.Platform.CanCollide = false
				-- platformWarning.Wall.PrismaticConstraint.TargetPosition = 60
				platformRiseTween:Play()
			end)
		else
			local newPlatform = ServerStorage.Other.FakePlatform:Clone()
			table.insert(platforms, newPlatform)
			local platformWarning = newPlatform.PlatformWarning

			local _, _, _, c1, c2, c3, c4, c5, c6, c7, c8, c9 = platformWarning.CFrame:GetComponents()
			platformWarning:PivotTo(
				CFramenew(math.random(-150, 100), 778.803, math.random(-100, 100), c1, c2, c3, c4, c5, c6, c7, c8, c9)
			)
			newPlatform.Parent = workspace

			task.spawn(function()
				local platformWarningTween = TweenService:Create(platformWarning, TweenInfonew(3), {
					Transparency = 0,
				})
				platformWarningTween:Play()
				task.wait(3)
				local startTick = tick()
				while startTick + 2 > tick() do
					platformWarning.Color = Color3new(0, 85 / 255, 0)
					platformWarning.warning:Play()
					task.wait(0.1)
					platformWarning.Color = Color3new(0, 1, 0)
					platformWarning.warning:Play()
					task.wait(0.1)
				end

				--reveal
				platformWarning.Color = Color3new(1, 1, 1)
				platformWarning.SurfaceGui.Enabled = true
				platformWarning.SelectionBox.Visible = true

				task.wait(2)
				platformWarning.Transparency = 1

				local platformRiseTween = TweenService:Create(platformWarning, TweenInfonew(1), {
					CFrame = platformWarning.CFrame + Vector3new(0, 60, 0),
				})
				platformWarning.Platform.Transparency = 0
				platformWarning.Platform["grind concrete"]:Play()
				platformRiseTween:Play()
				platformWarning.SurfaceGui.Enabled = false
				for _, v in platformWarning.Platform:GetChildren() do
					if v:IsA("Decal") then
						v.Transparency = 0
					end
				end

				platformWarning.SelectionBox.Visible = false

				task.wait(2)
				fractureModule.FracturePart(platformWarning.Platform)
			end)
		end
	end

	task.wait(5)
	if fakes then
		task.wait(5)
	end
	newLava.Parent = workspace
	addKillbrickConnection(newLava)
	local lavaRiseTween = TweenService:Create(newLava, TweenInfonew(1), {
		Size = Vector3new(newLava.Size.X, 50, newLava.Size.Z),
	})
	lavaRiseTween:Play()
	task.wait(5)
	-- if battleWait(5) then
	-- 	removeKillbrickConnection(newLava)
	-- 	for _, platform in platforms do
	-- 		platform:Destroy()
	-- 	end
	-- 	return true
	-- end
	TweenService:Create(newLava, TweenInfonew(1), {
		Size = Vector3new(newLava.Size.X, 0, newLava.Size.Z),
	}):Play()
	task.wait(2)
	-- if battleWait(2) then
	-- 	removeKillbrickConnection(newLava)
	-- 	for _, platform in platforms do
	-- 		platform:Destroy()
	-- 	end
	-- 	return true
	-- end
	removeKillbrickConnection(newLava)
	newLava:Destroy()
	lava_attack = false
	for _, platform in platforms do
		platform:Destroy()
	end
end

local function floorIsLavaAttack2()
	lava_attack = true
	local changeStateEvent = signalModule.getRemoteEvent("SetPlayerStateEnabled")
	for _, plr in Players:GetPlayers() do
		changeStateEvent:FireClient(plr, Enum.HumanoidStateType.Jumping, true)
	end
	local newLava = lavaPart:Clone()

	local obbySegment = ServerStorage.Other.ObbySegment:Clone()
	obbySegment.Parent = workspace
	-- Message from Spectre to go on the black clouds because evil rig... rigged it
	local remoteEvents = game:GetService("ReplicatedStorage").RemoteEvents
	local startEvent = remoteEvents.StartItsReign
	startEvent:FireAllClients()

	task.wait(20)
	newLava.Parent = workspace
	addKillbrickConnection(newLava)
	local lavaRiseTween = TweenService:Create(newLava, TweenInfonew(1), {
		Size = Vector3new(newLava.Size.X, 50, newLava.Size.Z),
	})
	lavaRiseTween:Play()
	task.wait(5)
	-- if battleWait(5) then
	-- 	removeKillbrickConnection(newLava)
	-- 	obbySegment:Destroy()
	-- 	newLava:Destroy()
	-- 	for _, plr in Players:GetPlayers() do
	-- 		changeStateEvent:FireClient(plr, Enum.HumanoidStateType.Jumping, false)
	-- 	end
	-- 	return true
	-- end
	TweenService:Create(newLava, TweenInfonew(1), {
		Size = Vector3new(newLava.Size.X, 0, newLava.Size.Z),
	}):Play()
	task.wait(2)
	-- if battleWait(2) then
	-- 	removeKillbrickConnection(newLava)
	-- 	obbySegment:Destroy()
	-- 	newLava:Destroy()
	-- 	for _, plr in Players:GetPlayers() do
	-- 		changeStateEvent:FireClient(plr, Enum.HumanoidStateType.Jumping, false)
	-- 	end
	-- 	return true
	-- end
	removeKillbrickConnection(newLava)
	obbySegment:Destroy()
	newLava:Destroy()
	lava_attack = false
	for _, plr in Players:GetPlayers() do
		changeStateEvent:FireClient(plr, Enum.HumanoidStateType.Jumping, false)
	end
end

local function slashesAttack(level: number, pDuration: number)
	local Duration = pDuration or 15

	local newEvilRig = evilRig:Clone()
	newEvilRig:PivotTo(workspace.BattleArena.MiddleSpawn.CFrame)
	newEvilRig.Parent = workspace
	local slash = ServerStorage.Other.Slash
	local playerList = Players:GetPlayers()
	if not playerList or #playerList == 0 then
		return
	end
	local playerFocus = playerList[math.random(#playerList)]
	local playerSwitchTimer = 0

	local cxn
	cxn = RunService.PostSimulation:Connect(function(delta)
		-- if battle_cancelled then
		-- 	cxn:Disconnect()
		-- 	cxn = nil
		-- 	return
		-- end
		playerSwitchTimer += delta
		if playerSwitchTimer >= 5 then
			playerList = Players:GetPlayers()
			if not playerList or #playerList == 0 then
				cxn:Disconnect()
				cxn = nil
				return
			end
			playerFocus = playerList[math.random(#playerList)]
		end
		if playerFocus.Character and playerFocus.Character:FindFirstChild("HumanoidRootPart") then
			newEvilRig.PrimaryPart.CFrame = CFramenew(
				newEvilRig.PrimaryPart.Position,
				Vector3new(
					playerFocus.Character.HumanoidRootPart.Position.X,
					newEvilRig.PrimaryPart.Position.Y,
					playerFocus.Character.HumanoidRootPart.Position.Z
				)
			)
		else
			playerSwitchTimer = 0
			playerList = Players:GetPlayers()
			if not playerList or #playerList == 0 then
				cxn:Disconnect()
				cxn = nil
				return
			end
			playerFocus = playerList[math.random(#playerList)]
		end
	end)

	local startTick = tick()

	-- make evil rig shoot a slash every few secs
	while startTick + Duration > tick() do
		task.wait(1)
		-- if battleWait(1) then
		-- 	return true
		-- end
		print("slash")
		local newSlash = slash:Clone()
		newSlash:PivotTo(newEvilRig.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(90), 0))
		newSlash.Parent = workspace
		addKillbrickConnection(newSlash.Slash)
		newSlash.Slash.SlashSound:Play()
		local startSlashTick = tick()
		local slashCxn
		slashCxn = RunService.PostSimulation:Connect(function(delta)
			if startSlashTick + 5 <= tick() then
				removeKillbrickConnection(newSlash.Slash)
				slashCxn:Disconnect()
				newSlash:Destroy()
				return
			end
			if newSlash then
				pcall(function()
					newSlash.PrimaryPart.CFrame += newEvilRig.PrimaryPart.CFrame.LookVector * delta * 100
				end)
			end
		end)
	end
	task.wait(6)
	-- if battleWait(6) then
	-- 	cxn:Disconnect()
	-- 	newEvilRig:Destroy()
	-- 	return true
	-- end
	cxn:Disconnect()
	newEvilRig:Destroy()
	task.wait(5)
	-- battleWait(5)
end

local function spikeAttack(level: number)
	local hardMode = false
	if level == 1 then
		hardMode = false
	else
		hardMode = true
	end
	local newEvilRig = evilRig:Clone()
	newEvilRig:PivotTo(workspace.BattleArena.MiddleSpawn.CFrame)
	newEvilRig.Parent = workspace

	local storedSpike = killbrickFolder.Spikes.Spike

	local function raiseSpikes(spikeGroup: Instance)
		for i = 1, #spikeGroup:GetChildren() do
			task.spawn(function()
				local spike = spikeGroup["Spike" .. tostring(i)]
				local warningPart = spike.Spike.Warning
				local warningTween = TweenService:Create(warningPart, TweenInfonew(3), {
					Transparency = 0,
				})
				warningTween:Play()
				task.wait(3)
				local startTick = tick()
				while startTick + 1 > tick() do
					warningPart.Color = Color3new(1, 85 / 255, 0)
					warningPart.warning:Play()
					task.wait(0.1)
					warningPart.Color = Color3new(1, 0, 0)
					warningPart.warning:Play()
					task.wait(0.1)
				end
				warningPart.Transparency = 1
				addKillbrickConnection(spike.Spike.Spike.Part1)
				addKillbrickConnection(spike.Spike.Spike.Part2)
				addKillbrickConnection(spike.Spike.Spike.Part3)
				addKillbrickConnection(spike.Spike.Spike.Part4)

				-- Raise spike
				local spikeSound = spike.Spike.Spike.EmitterPart.SpikeSound
				spikeSound:Play()
				--30.573 up
				TweenService:Create(warningPart, TweenInfonew(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
					CFrame = warningPart.CFrame + Vector3new(0, 30.573, 0),
				}):Play()
				task.spawn(function()
					task.wait(1.2)
					removeKillbrickConnection(spike.Spike.Spike.Part1)
					removeKillbrickConnection(spike.Spike.Spike.Part2)
					removeKillbrickConnection(spike.Spike.Spike.Part3)
					removeKillbrickConnection(spike.Spike.Spike.Part4)
				end)
				task.wait(5)
				-- battleWait(5)
				spikeSound.Parent.SpikeDownSound:Play()
				TweenService:Create(warningPart, TweenInfonew(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
					CFrame = warningPart.CFrame + Vector3new(0, -30.573, 0),
				}):Play()
				task.wait(1)
				-- battleWait(1)

				spike:Destroy()
			end)
			task.wait(0.1)
		end

		task.spawn(function()
			task.wait(12)
			spikeGroup:Destroy()
		end)
	end

	local function spawnSpikesInPattern(patternModel: Model)
		for _, spikeRow in patternModel:GetChildren() do
			for _, spike in spikeRow:GetChildren() do
				local newSpikeCF = spike.PartPlacement.CFrame
				spike.PartPlacement:Destroy()
				local newSpike = storedSpike:Clone()
				newSpike.Warning:PivotTo(newSpikeCF)
				newSpike.Parent = spike
			end
		end
	end

	if hardMode then
		task.spawn(function()
			local spikesModel1 = killbrickFolder.Spikes.Patterns.PlusSpikePattern:Clone()
			spawnSpikesInPattern(spikesModel1)
			spikesModel1.Parent = workspace
			for _, spikeRow in spikesModel1:GetChildren() do
				task.spawn(function()
					raiseSpikes(spikeRow)
				end)
			end
			task.wait(12)
			-- if battleWait(12) then
			-- 	return true
			-- end
			spikesModel1:Destroy()
		end)

		local spikesModel2 = killbrickFolder.Spikes.Patterns.XSpikePattern:Clone()
		spawnSpikesInPattern(spikesModel2)
		spikesModel2.Parent = workspace
		for _, spikeRow in spikesModel2:GetChildren() do
			task.spawn(function()
				raiseSpikes(spikeRow)
			end)
		end
		task.wait(12)
		-- if battleWait(12) then
		-- 	return true
		-- end
		spikesModel2:Destroy()
	elseif math.round(math.random()) == 0 then
		local spikesModel1 = killbrickFolder.Spikes.Patterns.PlusSpikePattern:Clone()
		spawnSpikesInPattern(spikesModel1)
		spikesModel1.Parent = workspace
		for _, spikeRow in spikesModel1:GetChildren() do
			task.spawn(function()
				raiseSpikes(spikeRow)
			end)
		end
		task.wait(12)
		-- if battleWait(12) then
		-- 	return true
		-- end
		spikesModel1:Destroy()
	else
		local spikesModel2 = killbrickFolder.Spikes.Patterns.XSpikePattern:Clone()
		spawnSpikesInPattern(spikesModel2)
		spikesModel2.Parent = workspace
		for _, spikeRow in spikesModel2:GetChildren() do
			task.spawn(function()
				raiseSpikes(spikeRow)
			end)
		end
		task.wait(12)
		-- if battleWait(12) then
		-- 	return true
		-- end
		spikesModel2:Destroy()
	end

	local playerList = Players:GetPlayers()
	if not playerList or #playerList == 0 then
		return
	end
	local playerFocus = playerList[math.random(#playerList)]
	local playerSwitchTimer = 0

	local cxn
	cxn = RunService.PostSimulation:Connect(function(delta)
		playerSwitchTimer += delta
		if playerSwitchTimer >= 5 then
			playerList = Players:GetPlayers()
			if not playerList or #playerList == 0 then
				cxn:Disconnect()
				cxn = nil
				return
			end
			playerFocus = playerList[math.random(#playerList)]
		end
		if playerFocus.Character and playerFocus.Character:FindFirstChild("HumanoidRootPart") then
			newEvilRig.PrimaryPart.CFrame = CFramenew(
				newEvilRig.PrimaryPart.Position,
				Vector3new(
					playerFocus.Character.HumanoidRootPart.Position.X,
					newEvilRig.PrimaryPart.Position.Y,
					playerFocus.Character.HumanoidRootPart.Position.Z
				)
			)
		else
			playerSwitchTimer = 0
			playerList = Players:GetPlayers()
			if not playerList or #playerList == 0 then
				cxn:Disconnect()
				cxn = nil
				return
			end
			playerFocus = playerList[math.random(#playerList)]
		end
	end)
	cxn:Disconnect()
	newEvilRig:Destroy()
end

local function homingProjectileAttack()
	local newEvilRig = evilRig:Clone()
	newEvilRig:PivotTo(workspace.BattleArena.MiddleSpawn.CFrame)
	newEvilRig.Parent = workspace
	local slash = ServerStorage.Other.Rocket
	local playerList = Players:GetPlayers()
	if not playerList or #playerList == 0 then
		return
	end
	local playerFocus = playerList[math.random(#playerList)]
	local playerSwitchTimer = 0

	local cxn
	cxn = RunService.PostSimulation:Connect(function(delta)
		playerSwitchTimer += delta
		if playerSwitchTimer >= 5 then
			playerList = Players:GetPlayers()
			if not playerList or #playerList == 0 then
				cxn:Disconnect()
				cxn = nil
				return
			end
			playerFocus = playerList[math.random(#playerList)]
		end
		if playerFocus.Character and playerFocus.Character:FindFirstChild("HumanoidRootPart") then
			newEvilRig.PrimaryPart.CFrame = CFramenew(
				newEvilRig.PrimaryPart.Position,
				Vector3new(
					playerFocus.Character.HumanoidRootPart.Position.X,
					newEvilRig.PrimaryPart.Position.Y,
					playerFocus.Character.HumanoidRootPart.Position.Z
				)
			)
		else
			playerSwitchTimer = 0
			playerList = Players:GetPlayers()
			if not playerList or #playerList == 0 then
				cxn:Disconnect()
				cxn = nil
				return
			end
			playerFocus = playerList[math.random(#playerList)]
		end
	end)

	local startTick = tick()
	local followTimer = 2

	-- make evil rig shoot a slash every few secs
	while startTick + 60 > tick() do
		task.wait(1)
		-- if battleWait(1) then
		-- 	break
		-- end
		print("homing projectile")
		local newSlash = slash:Clone()
		newSlash:PivotTo(newEvilRig.PrimaryPart.CFrame, playerFocus.Character.HumanoidRootPart.Position)
		newSlash.Parent = workspace
		addKillbrickConnection(newSlash)
		newSlash.Whoosh:Play()

		local startSlashTick = tick()
		local slashCxn
		local ended = false
		slashCxn = RunService.PostSimulation:Connect(function(delta)
			pcall(function()
				local currentLook = newSlash.CFrame.LookVector
				local desiredLook = (playerFocus.Character.HumanoidRootPart.Position - newSlash.Position).Unit
				local angle = math.acos(math.clamp(currentLook:Dot(desiredLook), -1, 1))

				local maxTurn = math.rad(180) * delta
				local newLook
				if angle > maxTurn then
					newLook = (CFrame.fromAxisAngle(currentLook:Cross(desiredLook).Unit, maxTurn) * CFrame.lookAt(
						Vector3.zero,
						currentLook
					)).LookVector
				else
					newLook = desiredLook
				end

				newSlash.CFrame = CFramenew(newSlash.Position, newSlash.Position + newLook)
				newSlash.CFrame += newSlash.CFrame.LookVector * delta * 100
			end)
		end)

		local explodeCxn = newSlash.Touched:Connect(function(other)
			if other.Name ~= "HumanoidRootPart" then
				return
			end
			if not other.Parent then
				return
			end
			local touchedPlayer = Players:GetPlayerFromCharacter(other.Parent)
			if touchedPlayer then
				if slashCxn then
					slashCxn:Disconnect()
				end
				eventsModule.FireRemoteSpawnClientExplosion(playerFocus, newSlash.Position)
				newSlash.Transparency = 1
				for _, emitter in newSlash:GetDescendants() do
					if emitter:IsA("ParticleEmitter") then
						emitter.Enabled = false
					end
				end
				task.wait()
				removeKillbrickConnection(newSlash)
				newSlash:Destroy()
			end
		end)
		task.spawn(function()
			task.wait(5)
			-- battleWait(5)
			if newSlash then
				for _, emitter in newSlash:GetDescendants() do
					if emitter:IsA("ParticleEmitter") then
						emitter.Enabled = false
					end
				end

				if explodeCxn then
					explodeCxn:Disconnect()
				end
				TweenService:Create(newSlash, TweenInfonew(1), {
					Transparency = 1,
				}):Play()
				removeKillbrickConnection(newSlash)
				task.wait(1)
				-- battleWait(1)

				if slashCxn then
					slashCxn:Disconnect()
				end
				if newSlash then
					newSlash:Destroy()
				end
			end
		end)
	end
	task.wait(6)
	-- if battleWait(6) then
	-- 	cxn:Disconnect()
	-- 	newEvilRig:Destroy()
	-- 	return true
	-- end
	cxn:Disconnect()
	newEvilRig:Destroy()
	task.wait(5)
	-- battleWait(5)
	return false
end
local hitSounds = {
	SoundService.SFX["Undertale - Attack hit"],
	SoundService.SFX["Kid saying Ouch.wav"],
}
local function chargeAttack(level: number)
	local baits = false
	if level == 1 or level == 2 then
		baits = false
	elseif level == 3 then
		baits = true
	end

	local hitboxes = {}
	local op = OverlapParams.new()
	local chargeAttackInfoPart = Instance.new("Part")
	chargeAttackInfoPart:SetAttribute("DamageCooldown", 2)
	chargeAttackInfoPart:SetAttribute("DamageAmount", 45)

	local hitboxPrefab = Instance.new("Part")
	hitboxPrefab.CanCollide = false
	hitboxPrefab.CanTouch = false
	hitboxPrefab.Color = Color3new(1, 0, 0)
	hitboxPrefab.Transparency = 0.7
	hitboxPrefab.Material = Enum.Material.Neon

	local function createHitbox(cframe: CFrame, size: Vector3, duration: number, visible: boolean)
		local newHitbox = hitboxPrefab:Clone()
		newHitbox.Size = size
		hitboxPrefab.CFrame = cframe
		table.insert(hitboxes, newHitbox)

		if visible then
			TweenService:Create(newHitbox, TweenInfonew(duration, Enum.EasingStyle.Exponential), {
				Transparency = 1,
			}):Play()
		else
			newHitbox.Transparency = 1
		end

		local hitboxCxn
		hitboxCxn = RunService.Heartbeat:Connect(function()
			if not newHitbox then
				hitboxCxn:Disconnect()
				hitboxCxn = nil
				return
			end
			local gotHit = workspace:GetPartsInPart(newHitbox, op)
			for _, other in gotHit do
				if not other.Parent then
					continue
				end
				local player = Players:GetPlayerFromCharacter(other.Parent)
				if not player then
					continue
				end

				-- hit
				local succ = damagePlayer(player, chargeAttackInfoPart)
				if succ then
					local newSfx = hitSounds[math.random(#hitSounds)]:Clone()
					newSfx.Parent = gotHit[1]
					newSfx:Play()
					task.spawn(function()
						newSfx.Stopped:Wait()
						newSfx:Destroy()
					end)
					-- remove all other hitboxes
					for _, hitbox in hitboxes do
						hitbox:Destroy()
					end
					table.clear(hitboxes)
				end
			end
		end)
		newHitbox.Parent = workspace
		task.wait(duration)
		if hitboxCxn then
			hitboxCxn:Disconnect()
			hitboxCxn = nil
		end
		table.remove(hitboxes, table.find(hitboxes, newHitbox))
		newHitbox:Destroy()
	end

	-- rig moves in a straight line to player like walkspeed override
	local newEvilRig = evilRig:Clone()
	newEvilRig:PivotTo(workspace.BattleArena.MiddleSpawn.CFrame)
	newEvilRig.Parent = workspace

	local playerSwitchTimer = 0
	local playerList = Players:GetPlayers()
	local playerFocus = playerList[math.random(#playerList)]
	local pauseTracking = false

	local cxn
	cxn = RunService.PostSimulation:Connect(function(delta)
		playerSwitchTimer += delta
		if pauseTracking then
			return
		end
		if playerSwitchTimer >= 5 then
			playerList = Players:GetPlayers()
			if not playerList or #playerList == 0 then
				cxn:Disconnect()
				cxn = nil
				return
			end
			playerFocus = playerList[math.random(#playerList)]
		end
		if playerFocus.Character and playerFocus.Character:FindFirstChild("HumanoidRootPart") then
			newEvilRig.PrimaryPart.CFrame = CFramenew(
				newEvilRig.PrimaryPart.Position,
				Vector3new(
					playerFocus.Character.HumanoidRootPart.Position.X,
					newEvilRig.PrimaryPart.Position.Y,
					playerFocus.Character.HumanoidRootPart.Position.Z
				)
			)
		else
			playerSwitchTimer = 0
			playerList = Players:GetPlayers()
			if not playerList or #playerList == 0 then
				cxn:Disconnect()
				cxn = nil
				return
			end
			playerFocus = playerList[math.random(#playerList)]
		end
	end)

	local startTick = tick()
	while startTick + 30 > tick() do
		pauseTracking = true
		task.wait(1)
		-- if battleWait(1) then
		-- 	return true
		-- end
		local rigClone = newEvilRig:Clone()
		for _, v in rigClone:GetDescendants() do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
		-- this doesnt rlly work as a killbrick?
		-- local cloneHrp = rigClone.HumanoidRootPart
		-- CollectionService:AddTag(cloneHrp, "Killbrick")
		-- cloneHrp:SetAttribute("DamageCooldown", 2)
		-- cloneHrp:SetAttribute("DamageAmount", 60)

		cutsceneModule.setModelTransparency(newEvilRig, 1)
		rigClone.Parent = workspace

		-- addKillbrickConnection(cloneHrp)
		if baits and math.round(math.random()) == 0 then
			if not playerFocus then
				playerFocus = getRandomPlayer()
				if not playerFocus then
					return
				end
			end
			rigClone.PrimaryPart.CFrame = CFramenew(
				rigClone.PrimaryPart.Position,
				Vector3new(
					playerFocus.Character.HumanoidRootPart.Position.X,
					newEvilRig.PrimaryPart.Position.Y,
					playerFocus.Character.HumanoidRootPart.Position.Z
				)
			)
		end
		local lastHitboxPos = Vector3.zero
		local function lungeFunc(delta)
			rigClone.PrimaryPart.CFrame += rigClone.PrimaryPart.CFrame.LookVector * delta * 200
			if lastHitboxPos and (lastHitboxPos - rigClone.PrimaryPart.Position).Magnitude > 2.5 then
				createHitbox(rigClone.PrimaryPart.CFrame, Vector3new(5, 5, 10), 0.2, true)
				lastHitboxPos = rigClone.PrimaryPart.Position
			end
		end
		local lungeCxn = RunService.PostSimulation:Connect(function(delta)
			if not rigClone then
				return
			end

			pcall(lungeFunc, delta)
		end)

		-- if battleWait(2) then
		-- 	return true
		-- end
		task.wait(2)
		-- removeKillbrickConnection(cloneHrp)
		lungeCxn:Disconnect()
		lungeCxn = nil
		for _, hitbox in hitboxes do
			hitbox:Destroy()
		end
		table.clear(hitboxes)
		rigClone:Destroy()
		cutsceneModule.setModelTransparency(newEvilRig, 0)
		pauseTracking = false
		task.wait(3)
	end

	task.wait(1)
	cxn:Disconnect()
	newEvilRig:Destroy()
	return false
end

local function sweeperAndRotator()
	print("ROTATOR ATTACK COMING")
	task.spawn(function()
		task.wait(1)
		print("SWEEPER ATTACK COMING")
		if sweeperAttack(2) then
			return true
		end
	end)
	if rotatorAttack() then
		return true
	end
	return false
end

local function sweeperAndGeyser()
	task.spawn(function()
		task.wait(1)
		print("SWEEPER ATTACK COMING")
		sweeperAttack(2)
	end)
	geyserAttack(2)
end

local function spikeAndSlashes(level: number)
	task.spawn(function()
		if spikeAttack(level) then
			return true
		end
	end)
	if slashesAttack(level) then
		return true
	end
	return false
end

local function levelOneAttacks(): boolean
	local attacks = {
		slashesAttack,
		rotatorAttack,
		geyserAttack,
		sweeperAttack,
		spikeAttack,
		floorIsLavaAttack1,
	}

	if noobMode then
		table.remove(attacks, table.find(attacks, floorIsLavaAttack1))
	end

	local lastAttack = nil

	chargeAttack(1)
	chargeAttack(1)
	chargeAttack(1)
	-- task.wait(10)

	-- TextChatService:DisplayBubble(evilRig, "So you can do that, I see...")

	-- for i = 1, 3 do
	-- 	local index = math.random(#attacks)
	-- 	while lastAttack and index == lastAttack do
	-- 		index = math.random(#attacks) -- roll again until its different
	-- 	end
	-- 	attacks[index](1)
	-- 	lastAttack = index
	-- 	-- if attacks[math.random(#attacks)](1) then
	-- 	-- 	return true
	-- 	-- end
	-- 	task.wait(1)
	-- end
	return false
end

local function levelTwoAttacks(): boolean
	local attacks = {
		slashesAttack,
		rotatorAttack,
		geyserAttack,
		sweeperAttack,
		spikeAttack,
		floorIsLavaAttack1,
		chargeAttack,
		sweeperAndGeyser,
	}
	if noobMode then
		table.remove(attacks, table.find(attacks, floorIsLavaAttack1))
	end
	local lastAttack = nil
	for i = 1, 5 do
		local index = math.random(#attacks)
		while lastAttack and index == lastAttack do
			index = math.random(#attacks) -- roll again until its different
		end
		attacks[index](2)
		lastAttack = index

		-- if attacks[math.random(#attacks)](2) then
		-- 	return true
		-- end
		task.wait(1)
	end
	return false
end

local function levelThreeAttacks(): boolean
	local attacks = {
		slashesAttack,
		rotatorAttack,
		geyserAttack,
		sweeperAttack,
		spikeAttack,
		floorIsLavaAttack1,
		chargeAttack,
		sweeperAndGeyser,
		homingProjectileAttack,
		spikeAndSlashes,
	}
	if noobMode then
		table.remove(attacks, table.find(attacks, floorIsLavaAttack1))
	end
	local lastAttack = nil
	for i = 1, 6 do
		local index = math.random(#attacks)
		while lastAttack and index == lastAttack do
			index = math.random(#attacks) -- roll again until its different
		end
		attacks[index](3)
		lastAttack = index
		-- if attacks[math.random(#attacks)](2) then
		-- 	return true
		-- end
		task.wait(1)
	end
	return false
end

local function fireMinigame()
	for _, player in Players:GetPlayers() do
		eventsModule.FireStartMinigame(player)
	end

	eventsModule.FireStartMinigameServerCheck("Snack")
end

local vulnerableRig = nil

local function spawnBossVulnerable()
	vulnerableRig = ServerStorage.EvilRig.EvilRig_Distressed:Clone()

	vulnerableRig:PivotTo(workspace.BattleArena.MiddleSpawn.CFrame)
	local sfx = game:GetService("SoundService").SFX.shield_break:Clone()
	sfx.Parent = vulnerableRig.HumanoidRootPart
	vulnerableRig.Parent = workspace
	sfx:Play()
end

local function removeBossVulnerable()
	if vulnerableRig then
		vulnerableRig:Destroy()
	end
end

local function HANDLE_BATTLE()
	local attackLevel = 1
	local minigameEndedEvent = signalModule.getBindableEvent("MinigameEnded")
	local bossHealthFunc = signalModule.getBindableFunction("GetBossHealth")
	local bossDeathEvent = signalModule.getBindableEvent("BossDeath")
	local battleReadyEvent: RemoteEvent = signalModule.getRemoteEvent("StartBattle")

	if not quickStart then
		local isReady = false
		task.spawn(function()
			battleReadyEvent.OnServerEvent:Wait()
			isReady = true
		end)
		local startTick = tick()
		local timeout = 600 -- 10 mins
		while not isReady do
			task.wait()
			if tick() - startTick > timeout then
				break
			end
		end
	end
	-- If it is quick Start, make sure the player teleports onto the platform that has already risen.

	task.wait(10)
	while true do
		if battle_cancelled then
			return
		end
		if attackLevel == 1 then
			print("LEVEL ONE")
			if levelOneAttacks() then
				return
			end
		elseif attackLevel == 2 then
			print("LEVEL TWO")
			if levelTwoAttacks() then
				return
			end
		else
			print("LEVEL THREE")
			if levelThreeAttacks() then
				return
			end
		end

		if battle_cancelled then
			return
		end
		task.wait(1)
		local hasTrophy = eventsModule.FireGetItem(Players:GetPlayers()[1])
		if not hasTrophy then
			fireMinigame()
			-- wait for minigame to end
			minigameEndedEvent.Event:Wait()
			task.wait(2)
		end

		spawnBossVulnerable()
		local bossDied = false
		local bossDeathCxn = nil
		bossDeathCxn = bossDeathEvent.Event:Connect(function()
			print("BOSS DIED. BATTLE END.")
			bossDied = true
			bossDeathCxn:Disconnect()
			bossDeathCxn = nil
		end)

		task.wait(10)
		if bossDied then
			break
		end
		removeBossVulnerable()
		bossDeathCxn:Disconnect()
		bossDeathCxn = nil

		local bossHP = bossHealthFunc:Invoke()
		if bossHP >= 66 then
			attackLevel = 1
		elseif bossHP >= 33 then
			attackLevel = 2
		else
			attackLevel = 3
		end
	end
end

HANDLE_BATTLE()

return module
