
public class HoloFeederController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<HoloFeederControllerPS> {
    return this.GetBasePS() as HoloFeederControllerPS;
  }
}

public class HoloFeederControllerPS extends ScriptableDeviceComponentPS {

  @runtimeProperty("category", "SFX")
  @runtimeProperty("customEditor", "AudioEvent")
  protected let m_turnOnSFX: CName;

  @runtimeProperty("category", "SFX")
  @runtimeProperty("customEditor", "AudioEvent")
  protected let m_turnOffSFX: CName;

  protected cb func OnInstantiated() -> Bool {
    super.OnInstantiated();
    if !IsStringValid(this.m_deviceName) {
      this.m_deviceName = "LocKey#95";
    };
  }

  protected func Initialize() -> Void {
    super.Initialize();
  }

  public func GetActions(out actions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    super.GetActions(actions, context);
    if !this.IsUserAuthorized(context.processInitiatorObject.GetEntityID()) {
      return false;
    };
    if ToggleON.IsDefaultConditionMet(this, context) {
      ArrayPush(actions, this.ActionToggleON());
    };
    this.SetActionIllegality(actions, this.m_illegalActions.regularActions);
    return true;
  }

  public final const func GetOnSound() -> CName {
    return this.m_turnOnSFX;
  }

  public final const func GetOffSound() -> CName {
    return this.m_turnOffSFX;
  }
}
