
public class StartedUsingHealingItemOrCyberwarePrereqState extends PrereqState {

  public let m_listenerInfo: ref<CallbackHandle>;

  protected cb func OnStateUpdate(value: Uint32) -> Bool {
    let prereq: ref<StartedUsingHealingItemOrCyberwarePrereq> = this.GetPrereq() as StartedUsingHealingItemOrCyberwarePrereq;
    let checkPassed: Bool = prereq.Evaluate(value);
    if checkPassed {
      this.OnChangedRepeated(false);
    };
  }
}

public class StartedUsingHealingItemOrCyberwarePrereq extends IScriptablePrereq {

  @default(StartedUsingHealingItemOrCyberwarePrereq, 0)
  public let m_curValue: Uint32;

  public final const func Evaluate(value: Uint32) -> Bool {
    return value != this.m_curValue;
  }

  protected const func OnRegister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Bool {
    let bb: ref<IBlackboard>;
    let castedState: ref<StartedUsingHealingItemOrCyberwarePrereqState>;
    let player: wref<PlayerPuppet> = context as PlayerPuppet;
    if IsDefined(player) {
      bb = GameInstance.GetBlackboardSystem(player.GetGame()).Get(GetAllBlackboardDefs().PlayerPerkData);
      castedState = state as StartedUsingHealingItemOrCyberwarePrereqState;
      castedState.m_listenerInfo = bb.RegisterListenerUint(GetAllBlackboardDefs().PlayerPerkData.StartedUsingHealingItemOrCyberware, castedState, n"OnStateUpdate");
    };
    return false;
  }

  protected const func OnUnregister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Void {
    let bb: ref<IBlackboard>;
    let castedState: ref<StartedUsingHealingItemOrCyberwarePrereqState>;
    let player: wref<PlayerPuppet> = context as PlayerPuppet;
    if IsDefined(player) {
      bb = GameInstance.GetBlackboardSystem(player.GetGame()).Get(GetAllBlackboardDefs().PlayerPerkData);
      castedState = state as StartedUsingHealingItemOrCyberwarePrereqState;
      bb.UnregisterListenerUint(GetAllBlackboardDefs().PlayerPerkData.StartedUsingHealingItemOrCyberware, castedState.m_listenerInfo);
    };
  }
}
