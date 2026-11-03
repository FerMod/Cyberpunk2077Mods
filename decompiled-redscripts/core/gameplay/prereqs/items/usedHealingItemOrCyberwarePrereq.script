
public class UsedHealingItemOrCyberwarePrereqState extends PrereqState {

  public let m_listenerInfo: ref<CallbackHandle>;

  protected cb func OnStateUpdate(value: Uint32) -> Bool {
    let prereq: ref<UsedHealingItemOrCyberwarePrereq> = this.GetPrereq() as UsedHealingItemOrCyberwarePrereq;
    let checkPassed: Bool = prereq.Evaluate(value);
    if checkPassed {
      this.OnChangedRepeated(false);
    };
  }
}

public class UsedHealingItemOrCyberwarePrereq extends IScriptablePrereq {

  @default(UsedHealingItemOrCyberwarePrereq, 0)
  public let m_curValue: Uint32;

  public final const func Evaluate(value: Uint32) -> Bool {
    return value != this.m_curValue;
  }

  protected const func OnRegister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Bool {
    let bb: ref<IBlackboard>;
    let castedState: ref<UsedHealingItemOrCyberwarePrereqState>;
    let player: wref<PlayerPuppet> = context as PlayerPuppet;
    if IsDefined(player) {
      bb = GameInstance.GetBlackboardSystem(player.GetGame()).Get(GetAllBlackboardDefs().PlayerPerkData);
      castedState = state as UsedHealingItemOrCyberwarePrereqState;
      castedState.m_listenerInfo = bb.RegisterListenerUint(GetAllBlackboardDefs().PlayerPerkData.UsedHealingItemOrCyberware, castedState, n"OnStateUpdate");
    };
    return false;
  }

  protected const func OnUnregister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Void {
    let bb: ref<IBlackboard>;
    let castedState: ref<UsedHealingItemOrCyberwarePrereqState>;
    let player: wref<PlayerPuppet> = context as PlayerPuppet;
    if IsDefined(player) {
      bb = GameInstance.GetBlackboardSystem(player.GetGame()).Get(GetAllBlackboardDefs().PlayerPerkData);
      castedState = state as UsedHealingItemOrCyberwarePrereqState;
      bb.UnregisterListenerUint(GetAllBlackboardDefs().PlayerPerkData.UsedHealingItemOrCyberware, castedState.m_listenerInfo);
    };
  }
}
