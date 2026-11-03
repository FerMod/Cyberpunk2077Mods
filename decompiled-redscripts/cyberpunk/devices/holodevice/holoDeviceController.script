
public class HoloDeviceController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<HoloDeviceControllerPS> {
    return this.GetBasePS() as HoloDeviceControllerPS;
  }
}

public class HoloDeviceControllerPS extends ScriptableDeviceComponentPS {

  private persistent let m_isPlaying: Bool;

  protected cb func OnInstantiated() -> Bool {
    super.OnInstantiated();
    if !IsStringValid(this.m_deviceName) {
      this.m_deviceName = "LocKey#222";
    };
  }

  protected func Initialize() -> Void {
    super.Initialize();
  }

  protected func ActionTogglePlay() -> ref<TogglePlay> {
    let action: ref<TogglePlay> = new TogglePlay();
    action.clearanceLevel = 2;
    action.SetUp(this);
    action.SetProperties(this.m_isPlaying);
    action.AddDeviceName(this.m_deviceName);
    return action;
  }

  public func GetActions(out actions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    super.GetActions(actions, context);
    if !this.IsUserAuthorized(context.processInitiatorObject.GetEntityID()) {
      return false;
    };
    if TogglePlay.IsDefaultConditionMet(this, context) {
      ArrayPush(actions, this.ActionTogglePlay());
    };
    this.SetActionIllegality(actions, this.m_illegalActions.regularActions);
    return true;
  }

  public final func OnPlay(evt: ref<TogglePlay>) -> EntityNotificationType {
    if this.IsUnpowered() || this.IsDisabled() {
      return this.SendActionFailedEvent(evt, evt.GetRequesterID(), "Disabled or Unpowered");
    };
    this.m_isPlaying = !this.m_isPlaying;
    evt.prop.first = ToVariant(this.m_isPlaying);
    this.UseNotifier(evt);
    if !IsFinal() {
    };
    return EntityNotificationType.SendThisEventToEntity;
  }

  public const func GetClearance() -> ref<Clearance> {
    return Clearance.CreateClearance(2, 2);
  }

  public final func IsPlaying() -> Bool {
    return this.m_isPlaying;
  }
}
