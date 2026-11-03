
public class DetailedLocomotionPSMPrereqState extends PlayerStateMachinePrereqState {

  private let m_locomotionID: BlackboardID_Int;

  @default(DetailedLocomotionPSMPrereqState, 0)
  private let m_playerAttachedCallbackID: Uint32;

  public final func RegisterPlayerAttachedCallback(locomotionID: BlackboardID_Int, game: GameInstance) -> Void {
    if this.m_playerAttachedCallbackID == 0u {
      this.m_locomotionID = locomotionID;
      this.m_playerAttachedCallbackID = GameInstance.GetPlayerSystem(game).RegisterPlayerPuppetAttachedCallback(this, n"OnPlayerAttachedCallback");
    };
  }

  public final func UnregisterPlayerAttachedCallback(game: GameInstance) -> Void {
    if this.m_playerAttachedCallbackID > 0u {
      GameInstance.GetPlayerSystem(game).UnregisterPlayerPuppetAttachedCallback(this.m_playerAttachedCallbackID);
      this.m_playerAttachedCallbackID = 0u;
    };
  }

  private final func OnPlayerAttachedCallback(playerPuppet: ref<GameObject>) -> Void {
    let bb: ref<IBlackboard>;
    if !IsDefined(this.m_owner) && !IsDefined(this.m_listenerInt) {
      bb = GameInstance.GetBlackboardSystem(playerPuppet.GetGame()).GetLocalInstanced(playerPuppet.GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
      if !IsDefined(bb) {
        return;
      };
      this.m_owner = playerPuppet;
      this.m_listenerInt = bb.RegisterListenerInt(this.m_locomotionID, this, n"OnStateUpdate");
      this.m_prevValue = bb.GetInt(this.m_locomotionID);
    };
  }
}

public class DetailedLocomotionPSMPrereq extends PlayerStateMachinePrereq {

  protected const func OnRegister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Bool {
    let player: ref<GameObject>;
    let bb: ref<IBlackboard> = GameInstance.GetBlackboardSystem(game).GetLocalInstanced((context as ScriptedPuppet).GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    let castedState: ref<DetailedLocomotionPSMPrereqState> = state as DetailedLocomotionPSMPrereqState;
    let locomotionID: BlackboardID_Int = GetAllBlackboardDefs().PlayerStateMachine.LocomotionDetailed;
    if !IsDefined(bb) {
      player = GameInstance.GetPlayerSystem(game).GetLocalPlayerControlledGameObject();
      if IsDefined(player) && player.IsReplacer() {
        castedState.RegisterPlayerAttachedCallback(locomotionID, game);
      };
      return false;
    };
    castedState.m_owner = context as GameObject;
    castedState.m_listenerInt = bb.RegisterListenerInt(locomotionID, castedState, n"OnStateUpdate");
    castedState.m_prevValue = bb.GetInt(locomotionID);
    return false;
  }

  protected const func OnUnregister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Void {
    let castedState: ref<DetailedLocomotionPSMPrereqState> = state as DetailedLocomotionPSMPrereqState;
    let bb: ref<IBlackboard> = GameInstance.GetBlackboardSystem(game).GetLocalInstanced((context as ScriptedPuppet).GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    if IsDefined(bb) {
      bb.UnregisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.LocomotionDetailed, castedState.m_listenerInt);
    };
    castedState.UnregisterPlayerAttachedCallback(game);
  }

  protected const func GetStateMachineEnum() -> String {
    return "gamePSMDetailedLocomotionStates";
  }

  protected const func GetCurrentPSMStateIndex(bb: ref<IBlackboard>) -> Int32 {
    return bb.GetInt(GetAllBlackboardDefs().PlayerStateMachine.LocomotionDetailed);
  }
}
