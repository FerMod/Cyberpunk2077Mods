
public class ToggleShow extends ActionBool {

  public final func SetProperties(isShown: Bool) -> Void {
    this.actionName = n"ToggleShow";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(n"Show", isShown, n"LocKey#17833", n"LocKey#17834");
  }
}

public class WallScreenController extends TVController {

  public const func GetPS() -> ref<WallScreenControllerPS> {
    return this.GetBasePS() as WallScreenControllerPS;
  }
}

public class WallScreenControllerPS extends TVControllerPS {

  private persistent let m_isShown: Bool;

  protected cb func OnInstantiated() -> Bool {
    super.OnInstantiated();
    if !IsStringValid(this.m_deviceName) {
      this.m_deviceName = "Gameplay-Devices-DisplayNames-WallScreen";
    };
  }

  protected func Initialize() -> Void {
    super.Initialize();
  }

  private final func ActionToggleShow() -> ref<ToggleShow> {
    let action: ref<ToggleShow> = new ToggleShow();
    action.clearanceLevel = 2;
    action.SetUp(this);
    action.SetProperties(this.m_isShown);
    action.AddDeviceName(this.m_deviceName);
    return action;
  }

  public func GetActions(out actions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    super.GetActions(actions, context);
    if !this.IsUserAuthorized(context.processInitiatorObject.GetEntityID()) {
      return false;
    };
    if Clearance.IsInRange(context.clearance, 2) {
      ArrayPush(actions, this.ActionToggleShow());
    };
    this.SetActionIllegality(actions, this.m_illegalActions.regularActions);
    return true;
  }

  public final func OnToggleShow(evt: ref<ToggleShow>) -> EntityNotificationType {
    this.UseNotifier(evt);
    if this.IsUnpowered() || this.IsDisabled() {
      return EntityNotificationType.DoNotNotifyEntity;
    };
    this.m_isShown = !this.m_isShown;
    return EntityNotificationType.SendThisEventToEntity;
  }

  public final const func IsShown() -> Bool {
    return this.m_isShown;
  }

  public func GetDeviceIconPath() -> String {
    return "";
  }
}
