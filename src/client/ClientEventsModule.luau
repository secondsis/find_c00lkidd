-- RemoteEvents, BindableEvents, BindableFunctions, etc. (yes, functions too)

export type Events = {
	FireDialogueEvent: (string) -> (),
	ConnectDialogueEvent: ((string) -> ()) -> RBXScriptConnection,
	FireSmoothTransitionFunction: (number) -> (),
	FireDisableMovementEvent: (boolean) -> (),
	ConnectDisableMovementEvent: ((boolean) -> ()) -> RBXScriptConnection,
	ConnectRemoteDisableMovementEvent: ((boolean) -> ()) -> RBXScriptConnection,
	FireSprintEvent: (boolean) -> (),
	ConnectDialogueFunction: ((string) -> ()) -> RBXScriptConnection,
	FireDialogueFunction: (string) -> (),
	FireEnableStartMenu: () -> (),
	FireDisableStartMenu: () -> (),
	FireSkipSceneEvent: () -> (),
	FireDisplaySkipEvent: (string) -> (),
	FireGetDataAsync: (entryName: string) -> any,
	FireAddItem: (itemName: string) -> boolean,
	FireDisableSkipEvent: () -> (),
	FireEndingEvent: (title: string, desc: string, imageURL: string?) -> (),
	FireTurnOffMusic: () -> (),
	FireUpdateMoney: (gained: boolean) -> (),
	FireNotifyNotEnoughMoney: () -> (),
	FireNotifyInventoryFull: () -> (),
	FireDisablePrompts: () -> (),
	FireEnablePrompts: () -> (),
	FireNotifyNoItems: () -> (),
	FireRemoteRemoveItem: () -> (),
	FireSetMainGuiEnabled: (enabled: boolean) -> (),
	FireEnableHouseMirrors: () -> (),
	FireDisableHouseMirrors: () -> (),
	FireRemoteTeleportPlayerOnServer: (location: string) -> (),
	FirePlayVideo: (id: number) -> (),
	FireFadeIn: (seconds: number, color: Color3) -> (),
	FireFadeOut: (seconds: number) -> (),
	FireRemoteGetData: (entryName: string) -> any,
	FireRemoteAwardEndingBadge: (badgeName: string) -> (),
	FireCheckSpeakerName: () -> string,
	FireScaryVibe: () -> (),
	FireOffScaryVibe: () -> (),
	FireShakeCamera: (seconds: number?, shakeIntensity: number?, shakeSpeed: number?) -> (),
	FireTransitionFunction: (seconds: number, color: Color3) -> (),
	FireCompletedCutscene: (cutsceneName: string) -> (),
	FireFetchGameInfo: (gameInfo: string) -> any,
	FireGetNotificationLabel: () -> TextLabel,
	FireViewObjective: (objective: string) -> (),
	FireGetCutsceneModule: (
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
	FirePrepareCutscene: () -> (),
	ConnectRemotePrepareCutscene: () -> (),
	ConnectRemoteFinishCutscene: () -> (),
	FireFinishCutscene: () -> (),
	FireSetFirstPerson: () -> (),
	FireSetThirdPerson: () -> (),
	FireSetBobbing: (enabled: boolean) -> (),
	FirePauseCameraEffects: () -> (),
	FireResumeCameraEffects: () -> (),
	FireGetPlatform: () -> string,
	FireEnableMouseIcon: () -> (),
	FireDisableMouseIcon: () -> (),
	FireResetMouseIcon: (override: boolean, fp: boolean) -> (),
	FireWaitForDialogueFinish: () -> (),
	FireResumeMusic: () -> (),
	FirePauseMusic: () -> (),
	FireManualCheckFirstPersonManager: () -> (),
	FireCloneAssetSecurityNone: (assetPath: string) -> Instance,
}

local events = {} :: Events

local replicatedStorage = game:GetService("ReplicatedStorage")
local remoteEvents = replicatedStorage:WaitForChild("RemoteEvents")

-- Utility to generate fire/connect functions
local function bindEvent(name: string, eventObj)
	local safeName = name:gsub("%W", "") -- Strip special chars just in case

	-- Fire function
	events["Fire" .. safeName] = function(...)
		if eventObj:IsA("BindableEvent") then
			eventObj:Fire(...)
		elseif eventObj:IsA("RemoteEvent") then
			eventObj:FireServer(...)
		elseif eventObj:IsA("RemoteFunction") then
			return eventObj:InvokeServer(...)
		elseif eventObj:IsA("BindableFunction") then
			return eventObj:Invoke(...)
		end
	end

	-- Connect function
	events["Connect" .. safeName] = function(callback)
		if eventObj:IsA("RemoteEvent") then
			return eventObj.OnClientEvent:Connect(callback)
		elseif eventObj:IsA("BindableEvent") then
			return eventObj.Event:Connect(callback)
		elseif eventObj:IsA("RemoteFunction") then
			eventObj.OnClientInvoke = callback
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
