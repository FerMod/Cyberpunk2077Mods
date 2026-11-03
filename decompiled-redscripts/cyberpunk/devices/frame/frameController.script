
public class inkFrameNotificationData extends inkGameNotificationData {

  public let frame: wref<Frame>;

  public let hash: Uint32;

  public let index: Int32;

  public let uv: RectF;

  public let shouldApply: Bool;

  public final func SetAsRemove() -> Void {
    this.hash = 0u;
    this.index = -1;
    this.uv.Left = 0.00;
    this.uv.Right = 1.00;
    this.uv.Top = 0.00;
    this.uv.Bottom = 1.00;
    this.shouldApply = true;
  }
}

public class FrameController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<FrameControllerPS> {
    return this.GetBasePS() as FrameControllerPS;
  }
}

public class FrameControllerPS extends ScriptableDeviceComponentPS {

  public func GetActions(out actions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    if FrameSwitcher.IsPlayerInAcceptableState(this, context) {
      ArrayPush(actions, this.ActionOpen());
    };
    this.SetActionIllegality(actions, this.m_illegalActions.regularActions);
    return true;
  }

  protected final func ActionOpen() -> ref<FrameSwitcher> {
    let action: ref<FrameSwitcher> = new FrameSwitcher();
    action.clearanceLevel = 2;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    action.CreateInteraction();
    return action;
  }

  public final func OnFrameSwitcher(evt: ref<FrameSwitcher>) -> EntityNotificationType {
    this.UseNotifier(evt);
    if evt.IsStarted() {
      this.ExecutePSAction(evt, this);
    };
    return EntityNotificationType.SendThisEventToEntity;
  }

  public final func SetState(state: Bool) -> Void {
    this.SetDeviceState(state ? EDeviceStatus.ON : EDeviceStatus.OFF);
    this.SetInteractionState(state);
  }
}

public class FrameSwitcher extends ActionBool {

  public final func SetProperties() -> Void {
    this.actionName = n"FrameSwitcher";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(this.actionName, true, this.actionName, this.actionName);
  }

  public final static func IsPlayerInAcceptableState(device: ref<ScriptableDeviceComponentPS>, const context: script_ref<GetActionsContext>) -> Bool {
    let playerSMBlackboard: ref<IBlackboard> = FrameSwitcher.GetPlayerStateMachine(Deref(context).processInitiatorObject);
    if playerSMBlackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.Carrying) {
      return false;
    };
    if StatusEffectSystem.ObjectHasStatusEffectWithTag(Deref(context).processInitiatorObject, n"PhoneCall") {
      return false;
    };
    if StatusEffectSystem.ObjectHasStatusEffectWithTag(Deref(context).processInitiatorObject, n"NoWorldInteractions") {
      return false;
    };
    return true;
  }

  public final static func GetPlayerStateMachine(requester: ref<GameObject>) -> ref<IBlackboard> {
    let playerPuppet: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(requester.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    let playerStateMachineBlackboard: ref<IBlackboard> = GameInstance.GetBlackboardSystem(requester.GetGame()).GetLocalInstanced(playerPuppet.GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    return playerStateMachineBlackboard;
  }
}
