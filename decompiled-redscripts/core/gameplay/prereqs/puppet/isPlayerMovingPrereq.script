
public class IsPlayerMovingPrereqState extends PrereqState {

  public let m_owner: wref<GameObject>;

  public let m_isMovingVertically: Bool;

  public let m_listenerVertical: ref<CallbackHandle>;

  public let m_isMovingHorizontally: Bool;

  public let m_listenerHorizontal: ref<CallbackHandle>;

  protected cb func OnVerticalUpdate(isMovingVertically: Bool) -> Bool {
    let checkPassed: Bool;
    let prereq: ref<IsPlayerMovingPrereq> = this.GetPrereq() as IsPlayerMovingPrereq;
    if NotEquals(this.m_isMovingVertically, isMovingVertically) {
      checkPassed = prereq.Evaluate(this.m_owner, isMovingVertically || this.m_isMovingHorizontally);
      this.OnChanged(checkPassed);
    };
    this.m_isMovingVertically = isMovingVertically;
  }

  protected cb func OnHorizontalUpdate(isMovingHorizontally: Bool) -> Bool {
    let checkPassed: Bool;
    let prereq: ref<IsPlayerMovingPrereq> = this.GetPrereq() as IsPlayerMovingPrereq;
    if NotEquals(this.m_isMovingHorizontally, isMovingHorizontally) {
      checkPassed = prereq.Evaluate(this.m_owner, isMovingHorizontally || this.m_isMovingVertically);
      this.OnChanged(checkPassed);
    };
    this.m_isMovingHorizontally = isMovingHorizontally;
  }
}

public class IsPlayerMovingPrereq extends PlayerStateMachinePrereq {

  protected const func OnRegister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Bool {
    let bb: ref<IBlackboard> = GameInstance.GetBlackboardSystem(game).GetLocalInstanced((context as ScriptedPuppet).GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    let castedState: ref<IsPlayerMovingPrereqState> = state as IsPlayerMovingPrereqState;
    castedState.m_owner = context as GameObject;
    castedState.m_listenerHorizontal = bb.RegisterListenerBool(GetAllBlackboardDefs().PlayerStateMachine.IsMovingHorizontally, castedState, n"OnHorizontalUpdate");
    castedState.m_listenerVertical = bb.RegisterListenerBool(GetAllBlackboardDefs().PlayerStateMachine.IsMovingVertically, castedState, n"OnVerticalUpdate");
    return false;
  }

  protected const func OnUnregister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Void {
    let castedState: ref<IsPlayerMovingPrereqState> = state as IsPlayerMovingPrereqState;
    let bb: ref<IBlackboard> = GameInstance.GetBlackboardSystem(game).GetLocalInstanced((context as ScriptedPuppet).GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    bb.UnregisterListenerBool(GetAllBlackboardDefs().PlayerStateMachine.IsMovingHorizontally, castedState.m_listenerHorizontal);
    bb.UnregisterListenerBool(GetAllBlackboardDefs().PlayerStateMachine.IsMovingVertically, castedState.m_listenerVertical);
  }

  protected const func GetStateMachineEnum() -> String {
    return "";
  }

  protected const func GetCurrentPSMStateIndex(bb: ref<IBlackboard>) -> Int32 {
    if bb.GetBool(GetAllBlackboardDefs().PlayerStateMachine.IsMovingHorizontally) || bb.GetBool(GetAllBlackboardDefs().PlayerStateMachine.IsMovingVertically) {
      return 1;
    };
    return 0;
  }

  protected func Initialize(recordID: TweakDBID) -> Void {
    super.Initialize(recordID);
    this.m_valueToListen = TweakDBInterface.GetBool(recordID + t".isMoving", true) ? 1 : 0;
  }

  public final const func Evaluate(owner: ref<GameObject>, value: Bool) -> Bool {
    if this.m_valueToListen == 0 {
      return Equals(value, false);
    };
    if this.m_valueToListen == 1 {
      return Equals(value, true);
    };
    return false;
  }
}
