
public class IsPlayerOnGroundPrereqState extends PrereqState {

  public let m_bbValue: Bool;

  public let m_isOnGroundListener: ref<CallbackHandle>;

  public let m_owner: wref<GameObject>;

  protected cb func OnStateUpdateBool(value: Bool) -> Bool {
    let checkPassed: Bool;
    let prereq: ref<IsPlayerOnGroundPrereq> = this.GetPrereq() as IsPlayerOnGroundPrereq;
    if NotEquals(this.m_bbValue, value) {
      checkPassed = prereq.Evaluate(this.m_owner, value);
      this.OnChanged(checkPassed);
    };
    this.m_bbValue = value;
  }
}

public class IsPlayerOnGroundPrereq extends IScriptablePrereq {

  public let m_invert: Bool;

  protected func Initialize(recordID: TweakDBID) -> Void {
    this.m_invert = TweakDBInterface.GetBool(recordID + t".invert", false);
  }

  protected const func OnRegister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Bool {
    let bb: ref<IBlackboard> = GameInstance.GetBlackboardSystem(game).GetLocalInstanced((context as ScriptedPuppet).GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    let castedState: ref<IsPlayerOnGroundPrereqState> = state as IsPlayerOnGroundPrereqState;
    castedState.m_owner = context as GameObject;
    castedState.m_isOnGroundListener = bb.RegisterListenerBool(GetAllBlackboardDefs().PlayerStateMachine.IsOnGround, castedState, n"OnStateUpdateBool");
    return false;
  }

  protected const func OnUnregister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Void {
    let castedState: ref<IsPlayerOnGroundPrereqState> = state as IsPlayerOnGroundPrereqState;
    let bb: ref<IBlackboard> = GameInstance.GetBlackboardSystem(game).GetLocalInstanced((context as ScriptedPuppet).GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    bb.UnregisterListenerBool(GetAllBlackboardDefs().PlayerStateMachine.IsOnGround, castedState.m_isOnGroundListener);
  }

  public final const func Evaluate(owner: ref<GameObject>, value: Bool) -> Bool {
    return this.m_invert ^ value;
  }
}
