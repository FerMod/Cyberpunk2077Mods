
public class QuickHackableQueueHelper extends IScriptable {

  public final static func PutActionInQuickhackQueue(action: ref<ScriptableDeviceAction>, gameplayRoleComponent: ref<GameplayRoleComponent>, gameInstance: GameInstance, qhIndicatorSlotName: CName, requesterObject: ref<GameObject>) -> Bool {
    let decreaseQhUploadTimeVal: Float;
    let deviceActionQueue: ref<DeviceActionQueue>;
    let firstHackInQueueUploadTimeDecrease: Float;
    let hackedEntityID: EntityID;
    let inQueueVisualData: ref<GameplayRoleMappinData>;
    let isQueuePerkBought: Bool;
    let playerBlackboard: ref<IBlackboard>;
    let playerEntityID: EntityID;
    let putActionInQueue: Bool;
    let statPoolsSystem: ref<StatPoolsSystem>;
    let statSystem: ref<StatsSystem>;
    let currentlyUploadingAction: ref<ScriptableDeviceAction> = requesterObject.GetCurrentlyUploadingAction();
    let player: ref<PlayerPuppet> = action.GetExecutor() as PlayerPuppet;
    if !IsDefined(player) {
      return false;
    };
    if !action.IsQuickHack() {
      return false;
    };
    playerEntityID = player.GetEntityID();
    if action.m_isQueuedAction {
      if IsDefined(currentlyUploadingAction) {
        deviceActionQueue = currentlyUploadingAction.m_deviceActionQueue;
      };
      currentlyUploadingAction = action;
      currentlyUploadingAction.m_deviceActionQueue = deviceActionQueue;
      currentlyUploadingAction.m_isActionQueueingUsed = true;
      requesterObject.SetCurrentlyUploadingAction(currentlyUploadingAction);
      playerBlackboard = GameInstance.GetBlackboardSystem(gameInstance).GetLocalInstanced(playerEntityID, GetAllBlackboardDefs().PlayerStateMachine);
      playerBlackboard.SetVariant(GetAllBlackboardDefs().PlayerStateMachine.CostFreeActionID, ToVariant(currentlyUploadingAction.GetObjectActionID()));
      return false;
    };
    statSystem = GameInstance.GetStatsSystem(gameInstance);
    decreaseQhUploadTimeVal = statSystem.GetStatValue(Cast<StatsObjectID>(playerEntityID), gamedataStatType.QuickHackUploadTimeDecrease);
    if decreaseQhUploadTimeVal > 0.00 {
      action.m_activationTimeReduction = MinF(decreaseQhUploadTimeVal, 1.00);
    };
    statPoolsSystem = GameInstance.GetStatPoolsSystem(gameInstance);
    if !statSystem.GetStatBoolValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.IgnoreAwarenessCostWhenOverclocked) && !StatusEffectSystem.ObjectHasStatusEffectWithTag(requesterObject as ScriptedPuppet, n"CommsNoiseJam") && (player.IsBeingRevealed() && QuickHackableQueueHelper.IsAwarenessBumpingAllowed(requesterObject as ScriptedPuppet) || StatusEffectSystem.ObjectHasStatusEffect(player, t"BaseStatusEffect.ForcedQHUploadAwarenessBumps")) || player.IsBeingRevealed() && action.GetAwarenessCost(gameInstance) < 0.00 {
      QuickHackableQueueHelper.BumpQuickHackUploadStatPoolValue(action, player, gameInstance);
    };
    isQueuePerkBought = QuickHackableQueueHelper.IsQueuePerkBought(player);
    if isQueuePerkBought && (action.CanSkipPayCost(true) || action.CanPayCost(null, true)) {
      if IsDefined(currentlyUploadingAction) && !IsDefined(currentlyUploadingAction.m_deviceActionQueue) {
        currentlyUploadingAction.m_deviceActionQueue = new DeviceActionQueue();
      };
      if IsDefined(currentlyUploadingAction) && IsDefined(currentlyUploadingAction.m_deviceActionQueue) {
        currentlyUploadingAction.m_deviceActionQueue.SetMaxQueueSize(Cast<Int32>(statSystem.GetStatValue(Cast<StatsObjectID>(playerEntityID), gamedataStatType.QuickHackQueueSize)));
      };
      putActionInQueue = IsDefined(currentlyUploadingAction) && !currentlyUploadingAction.m_isInactive && currentlyUploadingAction.m_deviceActionQueue.CanNewActionBeQueued();
      if putActionInQueue && (action.CanSkipPayCost(true) || action.PayCost(true)) {
        decreaseQhUploadTimeVal = statSystem.GetStatValue(Cast<StatsObjectID>(playerEntityID), gamedataStatType.QuickHackQueueUploadTimeDecrease);
        firstHackInQueueUploadTimeDecrease = statSystem.GetStatValue(Cast<StatsObjectID>(playerEntityID), gamedataStatType.FirstHackInQueueUploadTimeDecrease);
        if currentlyUploadingAction.m_deviceActionQueue.GetQueueSize() == 0 && firstHackInQueueUploadTimeDecrease > 0.00 && firstHackInQueueUploadTimeDecrease < 1.00 {
          decreaseQhUploadTimeVal += firstHackInQueueUploadTimeDecrease;
          decreaseQhUploadTimeVal = MinF(decreaseQhUploadTimeVal, 1.00);
        };
        currentlyUploadingAction.m_deviceActionQueue.PutActionInQueue(action, decreaseQhUploadTimeVal);
        if Cast<Bool>(PlayerDevelopmentSystem.GetData(player).IsNewPerkBought(gamedataNewPerkType.Intelligence_Master_Perk_1)) && currentlyUploadingAction.m_deviceActionQueue.GetQueueSize() >= currentlyUploadingAction.m_deviceActionQueue.GetMaxQueueSize() {
          hackedEntityID = gameplayRoleComponent.GetOwner().GetEntityID();
          GameInstance.GetStatusEffectSystem(gameInstance).ApplyStatusEffect(hackedEntityID, t"BaseStatusEffect.Intelligence_Master_Perk_2_Queue_Lock");
          currentlyUploadingAction.m_deviceActionQueue.LockQueue();
        };
        if IsDefined(gameplayRoleComponent) {
          inQueueVisualData = new GameplayRoleMappinData();
          inQueueVisualData.m_progressBarType = EProgressBarType.UPLOAD;
          if IsDefined(action.GetInteractionIcon()) {
            inQueueVisualData.m_textureID = action.GetInteractionIcon().TexturePartID().GetID();
          };
          inQueueVisualData.m_visibleThroughWalls = true;
          gameplayRoleComponent.AddQuickhackMappinToQueue(inQueueVisualData);
        };
        statSystem.AddModifier(Cast<StatsObjectID>(playerEntityID), RPGManager.CreateStatModifier(gamedataStatType.QuickHackQueueCount, gameStatModifierType.Additive, 1.00) as gameConstantStatModifierData);
        QuickhackModule.RequestRefreshQuickhackMenu(gameInstance, currentlyUploadingAction.GetRequesterID());
        return true;
      };
      statPoolsSystem.RequestRemovingStatPool(Cast<StatsObjectID>(action.GetRequesterID()), gamedataStatPoolType.QuickHackUpload);
      QuickHackableQueueHelper.RemoveQuickhackQueue(gameplayRoleComponent, currentlyUploadingAction);
      action.m_isActionQueueingUsed = true;
      requesterObject.SetCurrentlyUploadingAction(action);
      QuickhackModule.RequestRefreshQuickhackMenu(gameInstance, currentlyUploadingAction.GetRequesterID());
    } else {
      if IsDefined(currentlyUploadingAction) {
        currentlyUploadingAction.m_isInactive = true;
        requesterObject.SetCurrentlyUploadingAction(currentlyUploadingAction);
      };
    };
    return false;
  }

  private final static func BumpQuickHackUploadStatPoolValue(action: ref<ScriptableDeviceAction>, player: ref<GameObject>, gameInstance: GameInstance) -> Void {
    let awarenessCost: Float;
    let maxAwarenessValReached: Bool;
    let quickHackUploadVal: Float;
    let statPoolsSystem: ref<StatPoolsSystem> = GameInstance.GetStatPoolsSystem(gameInstance);
    let maxQuickHackUploadVal: Float = 99.90;
    if !statPoolsSystem.HasActiveStatPool(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatPoolType.QuickHackUpload) {
      return;
    };
    awarenessCost = action.GetAwarenessCost(gameInstance);
    quickHackUploadVal = statPoolsSystem.GetStatPoolValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatPoolType.QuickHackUpload, true);
    maxAwarenessValReached = quickHackUploadVal + awarenessCost > maxQuickHackUploadVal;
    if maxAwarenessValReached {
      awarenessCost = MaxF(maxQuickHackUploadVal - quickHackUploadVal, 0.00);
    };
    if awarenessCost != 0.00 {
      statPoolsSystem.RequestChangingStatPoolValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatPoolType.QuickHackUpload, awarenessCost, player, true, true);
    };
    if maxAwarenessValReached {
      statPoolsSystem.RequestSettingStatPoolMaxValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatPoolType.QuickHackUpload, player);
    };
  }

  public final static func IsAwarenessBumpingAllowed(target: ref<ScriptedPuppet>) -> Bool {
    let completedQhHistory: array<ref<ScriptableDeviceAction>>;
    let completionEffects: array<wref<ObjectActionEffect_Record>>;
    let currentlyUploadingAction: ref<ScriptableDeviceAction>;
    let i: Int32;
    let objectActionRecords: array<ref<ObjectAction_Record>>;
    let statusEffect: wref<StatusEffect_Record>;
    if IsDefined(target) && target.IsActionQueueEnabled() {
      completedQhHistory = target.GetCompletedQuickhackActionHistory();
      currentlyUploadingAction = target.GetCurrentlyUploadingAction();
      if IsDefined(currentlyUploadingAction) && !currentlyUploadingAction.m_isInactive {
        ArrayPush(completedQhHistory, currentlyUploadingAction);
        if IsDefined(currentlyUploadingAction.m_deviceActionQueue) {
          currentlyUploadingAction.m_deviceActionQueue.GetAllQueuedActionObjectRecords(objectActionRecords);
          i = 0;
          while i < ArraySize(objectActionRecords) {
            objectActionRecords[i].CompletionEffects(completionEffects);
            i += 1;
          };
        };
      };
      i = 0;
      while i < ArraySize(completedQhHistory) {
        completedQhHistory[i].GetObjectActionRecord().CompletionEffects(completionEffects);
        i += 1;
      };
      i = 0;
      while i < ArraySize(completionEffects) {
        statusEffect = completionEffects[i].StatusEffect();
        if IsDefined(statusEffect) && statusEffect.GameplayTagsContains(n"DisallowsAwarenessBumpInQueue") {
          return false;
        };
        i += 1;
      };
    };
    return true;
  }

  public final static func CheckAndSetInactivityReasonForVehicleActions(actions: [ref<DeviceAction>], scriptableDeviceAction: ref<ScriptableDeviceAction>) -> Bool {
    let action: ref<ScriptableDeviceAction>;
    let actionNames: array<CName>;
    let blockSameQhTypeQueuingOnVehicles: Bool;
    let i: Int32;
    let inactivityReasonIsQuickHacked: String;
    let isFailureSet: Bool;
    let j: Int32;
    if !IsDefined(scriptableDeviceAction) {
      return false;
    };
    inactivityReasonIsQuickHacked = QuickhacksListGameController.EActionInactivityResonToLocalizationString(EActionInactivityReson.IsQuickHacked);
    blockSameQhTypeQueuingOnVehicles = TDB.GetBool(t"NewPerks.Intelligence_Left_Milestone_2.blockSameQhTypeQueuingOnVehicles");
    if blockSameQhTypeQueuingOnVehicles {
      i = 0;
      while i < ArraySize(actions) {
        action = actions[i] as ScriptableDeviceAction;
        if IsDefined(action) && Equals(action.actionName, scriptableDeviceAction.actionName) {
          action.SetInactiveWithReason(false, inactivityReasonIsQuickHacked);
          isFailureSet = true;
        } else {
          if IsDefined(action) && IsDefined(scriptableDeviceAction.m_deviceActionQueue) {
            ArrayClear(actionNames);
            scriptableDeviceAction.m_deviceActionQueue.GetAllQueuedActionNames(actionNames);
            j = 0;
            while j < ArraySize(actionNames) {
              if Equals(action.actionName, actionNames[j]) {
                action.SetInactiveWithReason(false, inactivityReasonIsQuickHacked);
                isFailureSet = true;
              };
              j += 1;
            };
          };
        };
        i += 1;
      };
    } else {
      i = 0;
      while i < ArraySize(actions) {
        action = actions[i] as ScriptableDeviceAction;
        if IsDefined(action) && QuickHackableQueueHelper.SetInactivityReasonForAction(action, action.actionName, scriptableDeviceAction, inactivityReasonIsQuickHacked) {
          isFailureSet = true;
        };
        i += 1;
      };
    };
    return isFailureSet;
  }

  public final static func SetInactivityReasonForAction(scriptableDeviceAction: ref<ScriptableDeviceAction>, actionName: CName, currentlyUploadingAction: ref<ScriptableDeviceAction>, failureExplanation: String) -> Bool {
    let actionNamesInQueue: array<CName>;
    let disallowedActionNames: array<CName>;
    let i: Int32;
    let j: Int32;
    let actionShouldBeAllowed: Bool = true;
    if IsDefined(currentlyUploadingAction) {
      currentlyUploadingAction.m_deviceActionQueue.GetAllQueuedActionNames(actionNamesInQueue);
      DeviceActionQueue.GetAllDisallowedActionNames(disallowedActionNames);
      i = 0;
      while i < ArraySize(disallowedActionNames) {
        if !currentlyUploadingAction.m_isInactive && Equals(actionName, currentlyUploadingAction.GetActionName()) && Equals(currentlyUploadingAction.GetActionName(), disallowedActionNames[i]) {
          actionShouldBeAllowed = false;
          break;
        };
        j = 0;
        while j < ArraySize(actionNamesInQueue) {
          if Equals(actionName, actionNamesInQueue[j]) && Equals(actionNamesInQueue[j], disallowedActionNames[i]) {
            actionShouldBeAllowed = false;
            break;
          };
          j += 1;
        };
        i += 1;
      };
    };
    if NotEquals(failureExplanation, "LocKey#43809") && NotEquals(failureExplanation, "LocKey#43808") || !actionShouldBeAllowed {
      scriptableDeviceAction.SetInactiveWithReason(false, failureExplanation);
      return true;
    };
    return false;
  }

  public final static func IsStatusEffectStackable(statusEffectRecord: ref<StatusEffect_Record>) -> Bool {
    let hasStackableComponent: Bool;
    let i: Int32;
    let package: wref<GameplayLogicPackage_Record>;
    let packages: array<wref<GameplayLogicPackage_Record>>;
    statusEffectRecord.Packages(packages);
    i = 0;
    while i < ArraySize(packages) {
      package = packages[i];
      hasStackableComponent = hasStackableComponent || package.Stackable();
      i += 1;
    };
    return hasStackableComponent;
  }

  public final static func DecreaseQuickHackQueueCount(player: ref<PlayerPuppet>) -> Void {
    let gameInstance: GameInstance;
    let gameStatModifierData: ref<gameConstantStatModifierData>;
    let playerEntityID: EntityID;
    let statSystem: ref<StatsSystem>;
    if !IsDefined(player) {
      return;
    };
    gameInstance = player.GetGame();
    playerEntityID = player.GetEntityID();
    statSystem = GameInstance.GetStatsSystem(gameInstance);
    if statSystem.GetStatValue(Cast<StatsObjectID>(playerEntityID), gamedataStatType.QuickHackQueueCount) <= 1.00 {
      statSystem.RemoveAllModifiers(Cast<StatsObjectID>(playerEntityID), gamedataStatType.QuickHackQueueCount);
    } else {
      gameStatModifierData = RPGManager.CreateStatModifier(gamedataStatType.QuickHackQueueCount, gameStatModifierType.Additive, -1.00) as gameConstantStatModifierData;
      statSystem.AddModifier(Cast<StatsObjectID>(playerEntityID), gameStatModifierData);
    };
  }

  public final static func RemoveQuickhackQueue(gameplayRoleComponent: ref<GameplayRoleComponent>, currentlyUploadingAction: ref<ScriptableDeviceAction>) -> Void {
    let i: Int32;
    let objectActionRecords: array<ref<ObjectAction_Record>>;
    if IsDefined(gameplayRoleComponent) {
      gameplayRoleComponent.ToggleMappin(gamedataMappinVariant.QuickHackVariant, false, false);
    };
    if IsDefined(currentlyUploadingAction) {
      currentlyUploadingAction.m_isTargetDead = true;
      if currentlyUploadingAction.GetExecutor().IsPlayer() && currentlyUploadingAction.m_deviceActionQueue != null {
        currentlyUploadingAction.m_deviceActionQueue.GetAllQueuedActionObjectRecords(objectActionRecords);
        i = 0;
        while i < ArraySize(objectActionRecords) {
          RPGManager.DecrementQuickHackBlackboard(currentlyUploadingAction.GetExecutor().GetGame(), objectActionRecords[i].GetID());
          QuickHackableQueueHelper.DecreaseQuickHackQueueCount(currentlyUploadingAction.GetExecutor() as PlayerPuppet);
          i += 1;
        };
      };
    };
  }

  public final static func PopFromQuickHackQueue(evt: ref<UploadProgramProgressEvent>, gameplayRoleComponent: ref<GameplayRoleComponent>) -> ref<QuickSlotCommandUsed> {
    let action: ref<ScriptableDeviceAction>;
    let hackedEntityID: EntityID;
    let player: ref<PlayerPuppet>;
    let quickSlotCommandUsed: ref<QuickSlotCommandUsed>;
    let setQuickHackAttempt: ref<SetQuickHackAttemptEvent> = new SetQuickHackAttemptEvent();
    let gameInstance: GameInstance = gameplayRoleComponent.GetOwner().GetGame();
    if !IsDefined(evt.deviceActionQueue) {
      setQuickHackAttempt.wasQuickHackAttempt = false;
      GameInstance.GetPersistencySystem(gameInstance).QueuePSEvent(evt.action.GetPersistentID(), evt.action.GetDeviceClassName(), setQuickHackAttempt);
      return null;
    };
    action = evt.deviceActionQueue.PopActionInQueue() as ScriptableDeviceAction;
    if IsDefined(action) {
      action.m_isQueuedAction = true;
      quickSlotCommandUsed = new QuickSlotCommandUsed();
      quickSlotCommandUsed.action = action;
      player = GameInstance.GetPlayerSystem(gameInstance).GetLocalPlayerMainGameObject() as PlayerPuppet;
      QuickHackableQueueHelper.DecreaseQuickHackQueueCount(player);
    } else {
      hackedEntityID = gameplayRoleComponent.GetOwner().GetEntityID();
      GameInstance.GetStatusEffectSystem(gameInstance).RemoveStatusEffect(hackedEntityID, t"BaseStatusEffect.Intelligence_Master_Perk_2_Queue_Lock");
      evt.deviceActionQueue.UnlockQueue();
      setQuickHackAttempt.wasQuickHackAttempt = false;
      GameInstance.GetPersistencySystem(gameInstance).QueuePSEvent(evt.action.GetPersistentID(), evt.action.GetDeviceClassName(), setQuickHackAttempt);
    };
    return quickSlotCommandUsed;
  }

  public final static func IsQueuePerkBought(playerPuppet: ref<PlayerPuppet>) -> Bool {
    return IsDefined(playerPuppet) && PlayerDevelopmentSystem.GetData(playerPuppet).IsNewPerkBought(gamedataNewPerkType.Intelligence_Left_Milestone_2) == 2;
  }

  public final static func IsActionQueueEnabled(currentlyUploadingAction: ref<ScriptableDeviceAction>, playerPuppet: ref<PlayerPuppet>) -> Bool {
    return IsDefined(currentlyUploadingAction) && currentlyUploadingAction.m_isActionQueueingUsed || QuickHackableQueueHelper.IsQueuePerkBought(playerPuppet);
  }

  public final static func IsActionQueueFull(currentlyUploadingAction: ref<ScriptableDeviceAction>) -> Bool {
    return IsDefined(currentlyUploadingAction) && IsDefined(currentlyUploadingAction.m_deviceActionQueue) && currentlyUploadingAction.m_deviceActionQueue.IsActionQueueFull();
  }

  public final static func CanNewActionBeQueued(currentlyUploadingAction: ref<ScriptableDeviceAction>) -> Bool {
    return IsDefined(currentlyUploadingAction) && IsDefined(currentlyUploadingAction.m_deviceActionQueue) && currentlyUploadingAction.m_deviceActionQueue.CanNewActionBeQueued();
  }

  public final static func GetFinisherHealthThresholdIncreaseForQueue(player: ref<GameObject>, target: ref<GameObject>) -> Float {
    let finisherHealthThresholdIncreaseForQueue: Float;
    let qhQueueSize: Int32;
    let statsSystem: ref<StatsSystem>;
    let scriptedPuppet: ref<ScriptedPuppet> = target as ScriptedPuppet;
    if !IsDefined(scriptedPuppet) {
      return 0.00;
    };
    statsSystem = GameInstance.GetStatsSystem(player.GetGame());
    finisherHealthThresholdIncreaseForQueue = statsSystem.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.FinisherHealthThresholdIncreaseForQueue);
    if finisherHealthThresholdIncreaseForQueue > 0.00 {
      qhQueueSize = scriptedPuppet.GetDeviceActionQueueSize();
      return Cast<Float>(qhQueueSize) * finisherHealthThresholdIncreaseForQueue;
    };
    return 0.00;
  }
}

public class DeviceActionQueue extends IScriptable {

  private let m_actionsInQueue: [ref<DeviceAction>];

  @default(DeviceActionQueue, 1)
  private let m_maxQueueSize: Int32;

  @default(DeviceActionQueue, false)
  private let m_locked: Bool;

  public final static func GetAllDisallowedActionNames(out actionNames: [CName]) -> Void {
    actionNames = TDB.GetCNameArray(t"NewPerks.Intelligence_Left_Milestone_2.preventInQueueAgain");
  }

  public final func LockQueue() -> Void {
    this.m_locked = true;
  }

  public final func UnlockQueue() -> Void {
    this.m_locked = false;
  }

  public final func GetMaxQueueSize() -> Int32 {
    return this.m_maxQueueSize;
  }

  public final func SetMaxQueueSize(maxQueueSize: Int32) -> Void {
    if maxQueueSize > 0 {
      this.m_maxQueueSize = maxQueueSize;
    };
  }

  public final func GetQueueSize() -> Int32 {
    return ArraySize(this.m_actionsInQueue);
  }

  public final func GetQueuedActionsTotalCost() -> Int32 {
    let scriptableDeviceAction: ref<ScriptableDeviceAction>;
    let totalCost: Int32;
    let i: Int32 = 0;
    while i < ArraySize(this.m_actionsInQueue) {
      scriptableDeviceAction = this.m_actionsInQueue[i] as ScriptableDeviceAction;
      if IsDefined(scriptableDeviceAction) {
        totalCost += scriptableDeviceAction.GetCost();
      };
      i += 1;
    };
    return totalCost;
  }

  public final func GetAllQueuedActionNames(out actionNames: [CName]) -> Bool {
    let i: Int32 = 0;
    while i < ArraySize(this.m_actionsInQueue) {
      ArrayPush(actionNames, this.m_actionsInQueue[i].actionName);
      i += 1;
    };
    return this.HasActionInQueue();
  }

  public final func GetAllQueuedActionObjectRecords(out objectActionRecords: [ref<ObjectAction_Record>]) -> Bool {
    let action: ref<ScriptableDeviceAction>;
    let i: Int32 = 0;
    while i < ArraySize(this.m_actionsInQueue) {
      action = this.m_actionsInQueue[i] as ScriptableDeviceAction;
      if IsDefined(action) {
        ArrayPush(objectActionRecords, action.GetObjectActionRecord());
      };
      i += 1;
    };
    return this.HasActionInQueue();
  }

  public final func IsQhQueueUploadInProgress() -> Bool {
    let action: ref<ScriptableDeviceAction>;
    let statPoolsSystem: ref<StatPoolsSystem>;
    let uploadVal: Float;
    if ArraySize(this.m_actionsInQueue) > 0 {
      if this.m_actionsInQueue[0] == null && !this.m_actionsInQueue[0].IsA(n"ScriptableDeviceAction") {
        return false;
      };
      action = this.m_actionsInQueue[0] as ScriptableDeviceAction;
      if IsDefined(action) {
        statPoolsSystem = GameInstance.GetStatPoolsSystem(action.GetExecutor().GetGame());
        uploadVal = statPoolsSystem.GetStatPoolValue(Cast<StatsObjectID>(action.GetRequesterID()), gamedataStatPoolType.QuickHackUpload);
        return uploadVal > 0.00 && uploadVal < 100.00;
      };
    };
    return true;
  }

  public final func CanNewActionBeQueued() -> Bool {
    if !this.IsQhQueueUploadInProgress() {
      return false;
    };
    return !this.m_locked && ArraySize(this.m_actionsInQueue) < this.m_maxQueueSize;
  }

  public final func HasActionInQueue() -> Bool {
    return ArraySize(this.m_actionsInQueue) > 0;
  }

  public final func IsActionQueueFull() -> Bool {
    if !this.IsQhQueueUploadInProgress() {
      return false;
    };
    return !this.CanNewActionBeQueued() || ArraySize(this.m_actionsInQueue) == this.m_maxQueueSize;
  }

  private final func DecreaseUploadTime(deviceAction: ref<ScriptableDeviceAction>, decreaseQhUploadTimeVal: Float) -> Void {
    if decreaseQhUploadTimeVal < 0.00 {
      return;
    };
    decreaseQhUploadTimeVal += decreaseQhUploadTimeVal * Cast<Float>(ArraySize(this.m_actionsInQueue));
    decreaseQhUploadTimeVal = MinF(decreaseQhUploadTimeVal, 0.99);
    deviceAction.m_activationTimeReduction = decreaseQhUploadTimeVal;
  }

  public final func PutActionInQueue(deviceAction: ref<ScriptableDeviceAction>, decreaseQhUploadTimeVal: Float) -> Bool {
    if this.IsActionQueueFull() {
      return false;
    };
    this.DecreaseUploadTime(deviceAction, decreaseQhUploadTimeVal);
    ArrayPush(this.m_actionsInQueue, deviceAction);
    return true;
  }

  public final func PopActionInQueue() -> ref<DeviceAction> {
    let deviceAction: ref<DeviceAction>;
    if !this.HasActionInQueue() {
      return null;
    };
    deviceAction = this.m_actionsInQueue[0];
    ArrayErase(this.m_actionsInQueue, 0);
    return deviceAction;
  }
}
