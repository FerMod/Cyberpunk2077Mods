
public class IsPlayerControlsDevicePrereqState extends PrereqState {

  public let m_listenerInfo: ref<CallbackHandle>;

  protected cb func OnStateUpdate(value: EntityID) -> Bool {
    this.OnChanged(EntityID.IsDefined(value));
  }
}

public class IsPlayerControlsDevicePrereq extends IScriptablePrereq {

  protected const func OnRegister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Bool {
    let bb: ref<IBlackboard>;
    let castedState: ref<IsPlayerControlsDevicePrereqState> = state as IsPlayerControlsDevicePrereqState;
    let player: wref<PlayerPuppet> = context as PlayerPuppet;
    if IsDefined(player) {
      bb = GameInstance.GetBlackboardSystem(player.GetGame()).Get(GetAllBlackboardDefs().DeviceTakeControl);
      castedState.m_listenerInfo = bb.RegisterListenerEntityID(GetAllBlackboardDefs().DeviceTakeControl.ActiveDevice, castedState, n"OnStateUpdate");
    };
    return false;
  }

  protected const func OnUnregister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Void {
    let bb: ref<IBlackboard>;
    let castedState: ref<IsPlayerControlsDevicePrereqState>;
    let player: wref<PlayerPuppet> = context as PlayerPuppet;
    if IsDefined(player) {
      bb = GameInstance.GetBlackboardSystem(player.GetGame()).Get(GetAllBlackboardDefs().DeviceTakeControl);
      castedState = state as IsPlayerControlsDevicePrereqState;
      bb.UnregisterListenerEntityID(GetAllBlackboardDefs().DeviceTakeControl.ActiveDevice, castedState.m_listenerInfo);
    };
  }
}
