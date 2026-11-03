
public class IgnoreBarbedWirePrereq extends IScriptablePrereq {

  public let m_minStateTime: Float;

  public let m_invert: Bool;

  protected func Initialize(recordID: TweakDBID) -> Void {
    this.m_minStateTime = TweakDBInterface.GetFloat(recordID + t".minStateTime", 0.00);
    this.m_invert = TweakDBInterface.GetBool(recordID + t".invert", false);
  }

  protected const func OnApplied(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Void {
    state.OnChanged(this.IsFulfilled(game, context));
  }

  public const func IsFulfilled(game: GameInstance, context: ref<IScriptable>) -> Bool {
    let stateEnterTime: Float;
    let checkPassed: Bool = false;
    let bb: ref<IBlackboard> = GameInstance.GetBlackboardSystem(game).GetLocalInstanced((context as ScriptedPuppet).GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    if !IsDefined(bb) {
      return false;
    };
    stateEnterTime = bb.GetFloat(GetAllBlackboardDefs().PlayerStateMachine.IgnoreBarbedWireStateEnterTime);
    checkPassed = stateEnterTime > 0.00 && EngineTime.ToFloat(GameInstance.GetSimTime(game)) - stateEnterTime > this.m_minStateTime;
    return NotEquals(checkPassed, this.m_invert);
  }
}
