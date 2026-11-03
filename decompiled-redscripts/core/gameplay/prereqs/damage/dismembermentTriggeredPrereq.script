
public class DismembermentTriggeredPrereqState extends PrereqState {

  public let m_owner: wref<GameObject>;

  public let m_listenerInfo: ref<CallbackHandle>;

  protected let m_dismembermentInfo: DismembermentInstigatedInfo;

  protected cb func OnStateUpdate(value: Variant) -> Bool {
    let prereq: ref<DismembermentTriggeredPrereq> = this.GetPrereq() as DismembermentTriggeredPrereq;
    let dismembermentInfo: DismembermentInstigatedInfo = FromVariant<DismembermentInstigatedInfo>(value);
    let checkPassed: Bool = prereq.Evaluate(dismembermentInfo.value);
    if checkPassed {
      this.m_dismembermentInfo = dismembermentInfo;
      this.OnChangedRepeated(false);
    };
  }

  public final func GetDismembermentInfo() -> DismembermentInstigatedInfo {
    return this.m_dismembermentInfo;
  }
}

public class DismembermentTriggeredPrereq extends IScriptablePrereq {

  @default(DismembermentTriggeredPrereq, 0)
  public let m_currValue: Uint32;

  public final const func Evaluate(value: Uint32) -> Bool {
    let checkPassed: Bool = value != this.m_currValue;
    return checkPassed;
  }

  protected const func OnRegister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Bool {
    let bb: ref<IBlackboard>;
    let castedState: ref<DismembermentTriggeredPrereqState> = state as DismembermentTriggeredPrereqState;
    castedState.m_owner = context as GameObject;
    let player: ref<PlayerPuppet> = context as PlayerPuppet;
    if IsDefined(player) {
      bb = GameInstance.GetBlackboardSystem(player.GetGame()).Get(GetAllBlackboardDefs().PlayerPerkData);
      castedState.m_listenerInfo = bb.RegisterListenerVariant(GetAllBlackboardDefs().PlayerPerkData.DismembermentInstigated, castedState, n"OnStateUpdate");
    };
    return false;
  }

  protected const func OnUnregister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Void {
    let bb: ref<IBlackboard>;
    let castedState: ref<DismembermentTriggeredPrereqState>;
    let player: wref<PlayerPuppet> = context as PlayerPuppet;
    if IsDefined(player) {
      bb = GameInstance.GetBlackboardSystem(player.GetGame()).Get(GetAllBlackboardDefs().PlayerPerkData);
      castedState = state as DismembermentTriggeredPrereqState;
      bb.UnregisterListenerVariant(GetAllBlackboardDefs().PlayerPerkData.DismembermentInstigated, castedState.m_listenerInfo);
    };
  }
}
