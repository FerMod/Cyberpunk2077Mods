
public class PuppetAction extends ScriptableDeviceAction {

  public func GetTweakDBChoiceRecord() -> String {
    let interactionIDString: String;
    if IsDefined(this.GetObjectActionRecord()) && IsDefined(this.GetObjectActionRecord().ObjectActionUI()) {
      interactionIDString = this.GetObjectActionRecord().ObjectActionUI().Name();
    };
    return interactionIDString;
  }

  public func GetTweakDBChoiceID() -> TweakDBID {
    let id: TweakDBID;
    if IsDefined(this.GetObjectActionRecord()) && IsDefined(this.GetObjectActionRecord().ObjectActionUI()) {
      id = this.GetObjectActionRecord().ObjectActionUI().GetID();
    };
    return id;
  }

  public const func GetObjectActionRecord() -> wref<ObjectAction_Record> {
    return TweakDBInterface.GetObjectActionRecord(this.m_objectActionID);
  }
}

public class AIQuickHackAction extends PuppetAction {

  public let m_target: wref<GameObject>;

  @default(AIQuickHackAction, true)
  public let m_scaleUploadTime: Bool;

  public let m_HUDData: HUDProgressBarData;

  protected func SetRegenBehavior(gameInstance: GameInstance) -> Void {
    let activationTime: Float;
    let distanceToTarget: Float;
    let multiplier: Float;
    let regenMod: StatPoolModifier;
    let statValue: Float;
    GameInstance.GetStatPoolsSystem(gameInstance).GetModifier(Cast<StatsObjectID>(this.GetRequesterID()), gamedataStatPoolType.QuickHackUpload, gameStatPoolModificationTypes.Regeneration, regenMod);
    if this.m_scaleUploadTime {
      statValue = GameInstance.GetStatsSystem(this.m_target.GetGame()).GetStatValue(Cast<StatsObjectID>(this.m_target.GetEntityID()), gamedataStatType.NPCUploadTime);
      distanceToTarget = Vector4.Distance(this.m_executor.GetWorldPosition(), GameInstance.FindEntityByID(gameInstance, this.m_requesterID).GetWorldPosition());
      multiplier = PowF(1.02, distanceToTarget);
    } else {
      statValue = 1.00;
      multiplier = 1.00;
    };
    activationTime = this.GetActivationTime();
    regenMod.enabled = true;
    regenMod.valuePerSec = 100.00 / (multiplier * activationTime * statValue);
    regenMod.rangeEnd = 100.00;
    GameInstance.GetStatPoolsSystem(gameInstance).RequestSettingModifier(Cast<StatsObjectID>(this.GetRequesterID()), gamedataStatPoolType.QuickHackUpload, gameStatPoolModificationTypes.Regeneration, regenMod);
  }

  private func StartUpload(gameInstance: GameInstance) -> Void {
    let npcToNpcListener: ref<UploadFromNPCToNPCListener>;
    let npcToPlayerListener: ref<UploadFromNPCToPlayerListener>;
    let statMod: ref<gameStatModifierData>;
    let uploadListener: ref<QuickHackUploadListener>;
    let requesterGO: ref<GameObject> = GameInstance.FindEntityByID(gameInstance, this.m_requesterID) as GameObject;
    let statPoolSys: ref<StatPoolsSystem> = GameInstance.GetStatPoolsSystem(gameInstance);
    if requesterGO.IsPlayer() {
      npcToPlayerListener = new UploadFromNPCToPlayerListener();
      npcToPlayerListener.m_npcPuppet = this.m_executor as ScriptedPuppet;
      npcToPlayerListener.m_playerPuppet = requesterGO as ScriptedPuppet;
      npcToPlayerListener.m_HUDData = this.m_HUDData;
      uploadListener = npcToPlayerListener;
    } else {
      npcToNpcListener = new UploadFromNPCToNPCListener();
      npcToNpcListener.m_npcPuppet = this.m_executor as ScriptedPuppet;
      uploadListener = npcToNpcListener;
    };
    uploadListener.m_action = this;
    uploadListener.m_gameInstance = gameInstance;
    statMod = RPGManager.CreateStatModifier(gamedataStatType.QuickHackUpload, gameStatModifierType.Additive, this.GetActivationTime());
    GameInstance.GetStatsSystem(gameInstance).RemoveAllModifiers(Cast<StatsObjectID>(this.m_requesterID), gamedataStatType.QuickHackUpload);
    GameInstance.GetStatsSystem(gameInstance).AddModifier(Cast<StatsObjectID>(this.m_requesterID), statMod);
    statPoolSys.RequestSettingStatPoolValue(Cast<StatsObjectID>(this.m_requesterID), gamedataStatPoolType.QuickHackUpload, 0.00, this.m_executor);
    statPoolSys.RequestRegisteringListener(Cast<StatsObjectID>(this.m_requesterID), gamedataStatPoolType.QuickHackUpload, uploadListener);
    statPoolSys.RequestAddingStatPool(Cast<StatsObjectID>(this.m_requesterID), t"BaseStatPools.BaseQuickHackUpload");
    uploadListener.Initialize();
    this.SetRegenBehavior(gameInstance);
  }

  protected func ProcessStatusEffects(const actionEffects: script_ref<[wref<ObjectActionEffect_Record>]>, gameInstance: GameInstance) -> Void {
    super.ProcessStatusEffects(actionEffects, gameInstance);
  }
}

public class LinkedStatusEffectListener extends ScriptStatusEffectListener {

  public let instigatorObject: wref<GameObject>;

  public let linkedEffect: TweakDBID;

  public let evt: ref<RemoveLinkedStatusEffectsEvent>;

  public func OnStatusEffectRemoved(statusEffect: wref<StatusEffect_Record>) -> Void;
}

public class PingSquad extends PuppetAction {

  @default(PingSquad, true)
  private let m_shouldForward: Bool;

  public final const func ShouldForward() -> Bool {
    return this.m_shouldForward;
  }

  public final func SetShouldForward(shouldForward: Bool) -> Void {
    this.m_shouldForward = shouldForward;
  }
}

public class AccessBreach extends PuppetAction {

  public let m_attempt: Int32;

  public let m_networkName: String;

  public let m_npcCount: Int32;

  public let m_isRemote: Bool;

  public let m_isSuicide: Bool;

  public final func SetProperties(const networkName: script_ref<String>, npcCount: Int32, attemptsCount: Int32, isRemote: Bool, isSuicide: Bool) -> Void {
    this.m_networkName = Deref(networkName);
    this.m_npcCount = npcCount;
    this.m_attempt = attemptsCount;
    this.m_isRemote = isRemote;
    this.m_isSuicide = isSuicide;
  }

  public final func SetAttemptCount(amount: Int32) -> Void {
    this.m_attempt = amount;
  }

  private func StartUpload(gameInstance: GameInstance) -> Void {
    let breachListener: ref<AccessBreachListener>;
    let statPoolSys: ref<StatPoolsSystem> = GameInstance.GetStatPoolsSystem(gameInstance);
    let statMod: ref<gameStatModifierData> = RPGManager.CreateStatModifier(gamedataStatType.QuickHackUpload, gameStatModifierType.Additive, 1.00);
    GameInstance.GetStatsSystem(gameInstance).RemoveAllModifiers(Cast<StatsObjectID>(this.m_requesterID), gamedataStatType.QuickHackUpload);
    GameInstance.GetStatsSystem(gameInstance).AddModifier(Cast<StatsObjectID>(this.m_requesterID), statMod);
    breachListener = new AccessBreachListener();
    breachListener.m_action = this;
    breachListener.m_gameInstance = gameInstance;
    statPoolSys.RequestRegisteringListener(Cast<StatsObjectID>(this.m_requesterID), gamedataStatPoolType.QuickHackUpload, breachListener);
    statPoolSys.RequestAddingStatPool(Cast<StatsObjectID>(this.m_requesterID), t"BaseStatPools.BaseQuickHackUpload");
  }

  private func CompleteAction(gameInstance: GameInstance) -> Void {
    super.CompleteAction(gameInstance);
    this.GetNetworkBlackboard(gameInstance).SetInt(this.GetNetworkBlackboardDef().DevicesCount, this.m_npcCount);
    this.GetNetworkBlackboard(gameInstance).SetBool(this.GetNetworkBlackboardDef().OfficerBreach, true);
    this.GetNetworkBlackboard(gameInstance).SetBool(this.GetNetworkBlackboardDef().RemoteBreach, this.m_isRemote);
    this.GetNetworkBlackboard(gameInstance).SetBool(this.GetNetworkBlackboardDef().SuicideBreach, this.m_isSuicide);
    this.GetNetworkBlackboard(gameInstance).SetString(this.GetNetworkBlackboardDef().NetworkName, this.m_networkName);
    this.GetNetworkBlackboard(gameInstance).SetEntityID(this.GetNetworkBlackboardDef().DeviceID, this.GetRequesterID());
    this.GetNetworkBlackboard(gameInstance).SetInt(this.GetNetworkBlackboardDef().Attempt, this.m_attempt);
    this.SendNanoWireBreachEventToPSM(n"NanoWireRemoteBreach", true, gameInstance);
  }

  private final func GetNetworkBlackboard(gameInstance: GameInstance) -> ref<IBlackboard> {
    return GameInstance.GetBlackboardSystem(gameInstance).Get(this.GetNetworkBlackboardDef());
  }

  private final func GetNetworkBlackboardDef() -> ref<NetworkBlackboardDef> {
    return GetAllBlackboardDefs().NetworkBlackboard;
  }

  private final func SendNanoWireBreachEventToPSM(id: CName, isActive: Bool, gameInstance: GameInstance) -> Void {
    let psmEvent: ref<PSMPostponedParameterBool> = new PSMPostponedParameterBool();
    psmEvent.id = id;
    psmEvent.value = isActive;
    GameInstance.GetPlayerSystem(gameInstance).GetLocalPlayerMainGameObject().QueueEvent(psmEvent);
  }
}
