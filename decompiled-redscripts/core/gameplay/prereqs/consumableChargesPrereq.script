
public class ConsumableChargesPrereqListener extends ScriptStatPoolsListener {

  protected let m_state: wref<ConsumableChargesPrereqState>;

  public final func RegisterState(state: ref<PrereqState>) -> Void {
    this.m_state = state as ConsumableChargesPrereqState;
  }

  public func OnStatPoolValueChanged(oldValue: Float, newValue: Float, percToPoints: Float) -> Void {
    this.m_state.StatPoolUpdate(oldValue, newValue);
  }
}

public class ConsumableChargesPrereqState extends PrereqState {

  public let m_owner: wref<PlayerPuppet>;

  public let m_statPoolListener: ref<ConsumableChargesPrereqListener>;

  public let m_object: wref<GameObject>;

  public let m_statsObjID: StatsObjectID;

  public final func StatPoolUpdate(oldValue: Float, newValue: Float) -> Void {
    let prereq: ref<StatPoolPrereq> = this.GetPrereq() as StatPoolPrereq;
    let valueToCheck: Float = RPGManager.CalculateStatModifiers(prereq.m_valueToCheck, this.m_owner.GetGame(), this.m_object, this.m_statsObjID);
    let currentCharges: Float = Cast<Float>(this.m_owner.GetHealingItemCharges());
    let checkPassed: Bool = ProcessCompare(prereq.m_comparisonType, currentCharges, valueToCheck);
    this.OnChanged(checkPassed);
  }

  public final func RegisterStatPoolListener(game: GameInstance, statPoolType: gamedataStatPoolType, valueToCheck: Float) -> Void {
    if StatsObjectID.IsDefined(this.m_statsObjID) {
      this.m_statPoolListener = new ConsumableChargesPrereqListener();
      this.m_statPoolListener.RegisterState(this);
      GameInstance.GetStatPoolsSystem(game).RequestRegisteringListener(this.m_statsObjID, statPoolType, this.m_statPoolListener);
    };
  }

  public func UnregisterStatPoolListener(game: GameInstance, statPoolType: gamedataStatPoolType) -> Void {
    if IsDefined(this.m_statPoolListener) {
      GameInstance.GetStatPoolsSystem(game).RequestUnregisteringListener(this.m_statsObjID, statPoolType, this.m_statPoolListener);
    };
    this.m_statPoolListener = null;
  }
}

public class ConsumableChargesPrereq extends StatPoolPrereq {

  protected const func OnRegister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Bool {
    let owner: ref<PlayerPuppet> = context as PlayerPuppet;
    let castedState: ref<ConsumableChargesPrereqState> = state as ConsumableChargesPrereqState;
    let valueToCheck: Float = RPGManager.CalculateStatModifiers(this.m_valueToCheck, owner.GetGame(), castedState.m_object, castedState.m_statsObjID);
    castedState.m_owner = owner;
    castedState.m_statsObjID = this.GetStatsObjectID(owner);
    castedState.RegisterStatPoolListener(game, this.m_statPoolType, valueToCheck);
    return false;
  }
}
