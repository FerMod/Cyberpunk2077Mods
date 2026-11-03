
public class PlayerElevationPrereqState extends PrereqState {

  public let m_minElevationValue: Float;

  public let m_maxElevationValue: Float;

  public let m_minElevationListener: ref<CallbackHandle>;

  public let m_maxElevationListener: ref<CallbackHandle>;

  public let m_owner: wref<GameObject>;

  protected cb func OnMinElevationUpdateFloat(value: Float) -> Bool {
    let checkPassed: Bool;
    let prereq: ref<PlayerElevationPrereq> = this.GetPrereq() as PlayerElevationPrereq;
    if this.m_minElevationValue != value {
      checkPassed = prereq.Evaluate(this.m_owner, this.m_minElevationValue, this.m_maxElevationValue);
      this.OnChanged(checkPassed);
    };
    this.m_minElevationValue = value;
  }

  protected cb func OnMaxElevationUpdateFloat(value: Float) -> Bool {
    let checkPassed: Bool;
    let prereq: ref<PlayerElevationPrereq> = this.GetPrereq() as PlayerElevationPrereq;
    if this.m_maxElevationValue != value {
      checkPassed = prereq.Evaluate(this.m_owner, this.m_minElevationValue, this.m_maxElevationValue);
      this.OnChanged(checkPassed);
    };
    this.m_maxElevationValue = value;
  }
}

public class PlayerElevationPrereq extends IScriptablePrereq {

  public let m_elevationThreshold: Float;

  protected func Initialize(recordID: TweakDBID) -> Void {
    this.m_elevationThreshold = TDB.GetFloat(recordID + t".elevationThreshold");
  }

  protected const func OnRegister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Bool {
    let bb: ref<IBlackboard> = GameInstance.GetBlackboardSystem(game).GetLocalInstanced((context as ScriptedPuppet).GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    let castedState: ref<PlayerElevationPrereqState> = state as PlayerElevationPrereqState;
    castedState.m_owner = context as GameObject;
    castedState.m_minElevationListener = bb.RegisterListenerFloat(GetAllBlackboardDefs().PlayerStateMachine.MinElevation, castedState, n"OnMinElevationUpdateFloat");
    castedState.m_maxElevationListener = bb.RegisterListenerFloat(GetAllBlackboardDefs().PlayerStateMachine.MaxElevation, castedState, n"OnMaxElevationUpdateFloat");
    return false;
  }

  protected const func OnUnregister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Void {
    let castedState: ref<PlayerElevationPrereqState> = state as PlayerElevationPrereqState;
    let bb: ref<IBlackboard> = GameInstance.GetBlackboardSystem(game).GetLocalInstanced((context as ScriptedPuppet).GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    bb.UnregisterListenerFloat(GetAllBlackboardDefs().PlayerStateMachine.MinElevation, castedState.m_minElevationListener);
    bb.UnregisterListenerFloat(GetAllBlackboardDefs().PlayerStateMachine.MaxElevation, castedState.m_maxElevationListener);
  }

  public final const func Evaluate(owner: ref<GameObject>, minElevationVal: Float, maxElevationVal: Float) -> Bool {
    return AbsF(minElevationVal) > this.m_elevationThreshold || AbsF(maxElevationVal) > this.m_elevationThreshold;
  }
}
