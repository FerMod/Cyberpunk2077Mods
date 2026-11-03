
public class ForkliftController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<ForkliftControllerPS> {
    return this.GetBasePS() as ForkliftControllerPS;
  }
}

public class ForkliftControllerPS extends ScriptableDeviceComponentPS {

  private persistent let m_forkliftSetup: ForkliftSetup;

  @default(ForkliftControllerPS, false)
  private persistent let m_isUp: Bool;

  public final func GetActionName() -> CName {
    return this.m_forkliftSetup.m_actionActivateName;
  }

  public final func GetLiftingAnimationTime() -> Float {
    return this.m_forkliftSetup.m_liftingAnimationTime;
  }

  public final func IsForkliftUp() -> Bool {
    return this.m_isUp;
  }

  public final func ToggleForkliftPosition() -> Void {
    this.m_isUp = !this.m_isUp;
  }

  public final func ChangeState(newState: EDeviceStatus) -> Void {
    this.SetDeviceState(newState);
  }

  protected func GameAttached() -> Void {
    super.GameAttached();
  }

  public func GetActions(out actions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    super.GetActions(actions, context);
    if !this.IsDistracting() && this.IsON() {
      ArrayPush(actions, this.ActionActivateDevice("Activate"));
    };
    this.SetActionIllegality(actions, this.m_illegalActions.regularActions);
    return true;
  }

  protected const func CanCreateAnyQuickHackActions() -> Bool {
    if this.m_forkliftSetup.m_hasDistractionQuickhack {
      return true;
    };
    return false;
  }

  protected func GetQuickHackActions(out actions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    let currentAction: ref<ScriptableDeviceAction>;
    if !this.IsDistracting() && this.m_forkliftSetup.m_hasDistractionQuickhack {
      currentAction = this.ActionQuickHackDistraction();
      currentAction.SetObjectActionID(t"DeviceAction.MalfunctionClassHack");
      currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
      currentAction.SetInactiveWithReason(this.IsON(), "LocKey#7005");
      ArrayPush(actions, currentAction);
    };
    super.GetQuickHackActions(actions, context);
  }

  protected final func ActionActivateDevice(const interactionName: script_ref<String>) -> ref<ActivateDevice> {
    let action: ref<ActivateDevice> = new ActivateDevice();
    action.clearanceLevel = 2;
    action.SetUp(this);
    action.SetProperties(this.GetActionName());
    action.AddDeviceName(this.m_deviceName);
    action.CreateActionWidgetPackage();
    action.CreateInteraction(Deref(interactionName));
    return action;
  }

  protected func OnActivateDevice(evt: ref<ActivateDevice>) -> EntityNotificationType {
    super.OnActivateDevice(evt);
    this.SetDeviceState(EDeviceStatus.OFF);
    this.ToggleForkliftPosition();
    return EntityNotificationType.SendThisEventToEntity;
  }
}
