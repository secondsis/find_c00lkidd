local module = {}

local eventsModule = require(game:GetService("ReplicatedStorage").ServerEventsModule)

local ArenaCenter = workspace.BattleArena.Center

local position = ArenaCenter.Position
local TweenService = game:GetService("TweenService")

eventsModule.ConnectRaiseArena(function(player, quickStart)
	if quickStart then
		ArenaCenter.CFrame = CFrame.new(position + Vector3.new(0, 1000, 0))

		local _, playerSize = player.Character:GetBoundingBox()
		player.Character:PivotTo(
			CFrame.new(workspace.BattleArena.ArenaTPPart.Position + Vector3.new(0, playerSize.Y / 2, 0))
		)
		return
	end

	TweenService:Create(ArenaCenter, TweenInfo.new(5), {
		CFrame = CFrame.new(position + Vector3.new(0, 1000, 0)),
	}):Play()

	repeat
		task.wait()
	until ArenaCenter.Position.Y > position.Y + 1000 - 10

	local _, playerSize = player.Character:GetBoundingBox()

	game:GetService("ReplicatedStorage").WaitEvents.ArenaRiseFinished:FireClient(player)
	player.Character:PivotTo(
		CFrame.new(workspace.BattleArena.ArenaTPPart.Position + Vector3.new(0, playerSize.Y / 2, 0))
	)
end)

return module
