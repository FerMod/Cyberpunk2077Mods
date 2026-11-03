
public class ConstantStatPoolPrereqListener extends BaseStatPoolPrereqListener {

  protected let m_state: wref<ConstantStatPoolPrereqState>;

  protected cb func OnStatPoolValueReached(oldValue: Float, newValue: Float, percToPoints: Float) -> Bool {
    this.m_state.StatPoolUpdate(oldValue, newValue);
  }

  public func OnStatPoolValueChanged(oldValue: Float, newValue: Float, percToPoints: Float) -> Void {
    if this.m_state.m_listenConstantly {
      this.m_state.StatPoolConstantUpdate(oldValue, newValue, percToPoints);
    };
  }

  public func RegisterState(state: ref<PrereqState>) -> Void {
    this.m_state = state as ConstantStatPoolPrereqState;
  }
}

public class ConstantStatPoolPrereqState extends StatPoolPrereqState {

  public let m_listenConstantly: Bool;

  public final func StatPoolConstantUpdate(oldValue: Float, newValue: Float, percToPoints: Float) -> Void {
    let checkPassed: Bool;
    let currentState: Bool;
    let prereq: ref<ConstantStatPoolPrereq> = this.GetPrereq() as ConstantStatPoolPrereq;
    let valueToCheck: Float = RPGManager.CalculateStatModifiers(prereq.m_valueToCheck, this.m_object.GetGame(), this.m_object, this.m_statsObjID);
    if !prereq.m_comparePercentage {
      newValue *= percToPoints;
    };
    checkPassed = ProcessCompare(prereq.m_comparisonType, newValue, valueToCheck);
    currentState = this.IsFulfilled();
    if NotEquals(currentState, checkPassed) {
      this.OnChanged(checkPassed);
    };
  }

  public func RegisterStatPoolListener(game: GameInstance, statPoolType: gamedataStatPoolType, valueToCheck: Float) -> Void {
    if StatsObjectID.IsDefined(this.m_statsObjID) {
      this.m_statPoolListener = new ConstantStatPoolPrereqListener();
      this.m_statPoolListener.RegisterState(this);
      this.m_statPoolListener.SetValue(valueToCheck);
      GameInstance.GetStatPoolsSystem(game).RequestRegisteringListener(this.m_statsObjID, statPoolType, this.m_statPoolListener);
    };
  }
}

public class ConstantStatPoolPrereq extends StatPoolPrereq {

  protected const func OnRegister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Bool {
    let owner: ref<GameObject> = context as GameObject;
    let castedState: ref<ConstantStatPoolPrereqState> = state as ConstantStatPoolPrereqState;
    castedState.m_object = this.GetObject(owner);
    castedState.m_statsObjID = this.GetStatsObjectID(owner);
    castedState.m_listenConstantly = true;
    castedState.RegisterStatPoolListener(game, this.m_statPoolType, this.GetValueToCheck(castedState));
    return false;
  }
}
