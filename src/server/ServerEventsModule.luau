-- RemoteEvents, BindableEvents, BindableFunctions, etc. (yes, functions too)

export type Events = {
	FireRemoteDialogueEvent: (Player, string) -> (),
	ConnectRemoteDisableMovementEvent: ((Player, boolean) -> ()) -> RBXScriptConnection,
	ConnectSetDataAsync: ((Player, string, string, any) -> ()) -> RBXScriptConnection,
	ConnectGetDataAsync: ((Player, string) -> any) -> RBXScriptConnection,
	FireAddItem: (Player, string) -> boolean,
	FireRemoteClientTween: (player: Player, tween: Tween) -> (),
	FireRemoteDialogueFunction: (player: Player, entryName: string) -> (),
	FireRemoteUpdateMoney: (player: Player, gained: boolean) -> (),
	FireRemoteWaitForDialogueFinish: (player: Player) -> (),
	FireRemoteDisablePrompts: (player: Player) -> (),
	FireRemoteEnablePrompts: (player: Player) -> (),
	FireRemoteDeleteOnClient: (player: Player, obj: Instance) -> (),
	FireRemoteNotifyNotEnoughMoney: (player: Player) -> (),
	FireRemoteNotifyInventoryFull: (player: Player) -> (),
	FireRemoteNotifyNoItems: (player: Player) -> (),
	FireRemoveItem: (player: Player) -> (),
	FireRemoteSetMainGuiEnabled: (player: Player, enabled: boolean) -> (),
	FireRemotePlayVideo: (player: Player, id: number) -> (),
	FireRemoteDisableMovementEvent: (player: Player, movementEnabled: boolean) -> (),
	FireRemoteSmoothTransitionFunction: (player: Player, seconds: number, color: Color3) -> (),
	FireRemoteEndingEvent: (player: Player, title: string, desc: string) -> (),
	FireRemoteFadeIn: (player: Player, seconds: number, color: Color3) -> (),
	FireRemoteFadeOut: (player: Player, seconds: number) -> (),
	FireRemoteDisplayImage: (player: Player, url: string, visible: boolean) -> (),
	FireRemotePlaySound: (player: Player, sound: Sound) -> (),
	FireRemoteTurnOffMusic: (player: Player) -> (),
	FireGetData: (player: Player, entryName: string) -> (),
	FireRemoteCheckSpeakerName: (player: Player) -> string,
	FireGetItem: (player: Player) -> Instance,
	FireRemoteScaryVibe: (player: Player) -> (),
	FireRemoteOffScaryVibe: (player: Player) -> (),
	FireRemoteShakeCamera: (player: Player, seconds: number?, shakeIntensity: number?, shakeSpeed: number?) -> (),
	FireSetDataAsync: (player: Player, entryName: string, value: any) -> (),
	FireRemoteTransitionFunction: (player: Player, seconds: number, color: Color3) -> (),
	FireTeleportToPlace: (player: Player, placeId: number, metadata: { [string]: any }, loadingScreen: Instance?) -> (),
	FireRemoteEnableHouseMirrors: (player: Player) -> (),
	FireRemoteDisableHouseMirrors: (player: Player) -> (),
	ConnectCompletedCutscene: ((player: Player, cutsceneName: string) -> ()) -> RBXScriptConnection,
	FireRemoteGetNotificationLabel: (player: Player) -> TextLabel,
	FireRemoteGetCutsceneModule: (
		player: Player
	) -> {
		setModelTransparency: (model: Model, transparency: number) -> (),
		fadeOutPlayer: (seconds: number) -> (),
		fadeInPlayer: (seconds: number) -> (),
		changeCamCFrame: (newCFrame: CFrame) -> (),
		resetCam: () -> (),
		tweenCamCFrame: (
			newCFrame: CFrame,
			duration: number,
			fadePlayer: boolean,
			style: Enum.EasingStyle,
			direction: Enum.EasingDirection
		) -> (),
		tweenResetCam: (duration: number, fadePlayer: boolean) -> (),
		zoomCam: (targetFOV: number, duration: number) -> (),
		resetCamZoom: () -> (),
	},
	FireRemotePauseCameraEffects: (player: Player) -> (),
	FireRemoteResumeCameraEffects: (player: Player) -> (),
	FireRemoteGetPlatform: (player: Player) -> string,
	FireRemoteEnableMouseIcon: (player: Player) -> (),
	FireRemoteDisableMouseIcon: (player: Player) -> (),
	FireRemoteResetMouseIcon: (player: Player) -> (),
	FireRemoteSpawnClientExplosion: (player: Player, pos: Vector3) -> (),
	FireGetMoney: (player: Player) -> (),
	FireAddMoney: (player: Player, amount: number) -> (),
}

local events = {} :: Events

local remoteEvents = game:GetService("ReplicatedStorage").RemoteEvents

-- Utility to generate fire/connect functions
local function bindEvent(name: string, eventObj)
	local safeName = name:gsub("%W", "") -- Strip special chars just in case

	-- Fire function (reqs player as 1st param if remote)
	events["Fire" .. safeName] = function(...)
		if eventObj:IsA("BindableEvent") then
			eventObj:Fire(...)
		elseif eventObj:IsA("RemoteEvent") then
			eventObj:FireClient(...)
		elseif eventObj:IsA("RemoteFunction") then
			return eventObj:InvokeClient(...)
		elseif eventObj:IsA("BindableFunction") then
			return eventObj:Invoke(...)
		end
	end

	-- Connect function
	events["Connect" .. safeName] = function(callback)
		if eventObj:IsA("RemoteEvent") then
			return eventObj.OnServerEvent:Connect(callback)
		elseif eventObj:IsA("BindableEvent") then
			return eventObj.Event:Connect(callback)
		elseif eventObj:IsA("RemoteFunction") then
			eventObj.OnServerInvoke = callback
		elseif eventObj:IsA("BindableFunction") then
			eventObj.OnInvoke = callback
		end
	end
end

-- Recursively find events
local function bindEventsIn(folder)
	for _, child in folder:GetChildren() do
		if child:IsA("Folder") then
			bindEventsIn(child)
		elseif
			child:IsA("RemoteEvent")
			or child:IsA("BindableEvent")
			or child:IsA("RemoteFunction")
			or child:IsA("BindableFunction")
		then
			bindEvent(child.Name, child)
		end
	end
end

bindEventsIn(remoteEvents)

return events
