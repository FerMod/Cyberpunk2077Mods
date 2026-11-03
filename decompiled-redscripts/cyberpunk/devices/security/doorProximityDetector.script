
public class DoorProximityDetector extends ProximityDetector {

  private let m_triggeredAlarmID: DelayID;

  @default(DoorProximityDetector, 2.0f)
  private let m_blinkInterval: Float;

  private let m_authorizationLevel: ESecurityAccessLevel;

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as DoorProximityDetectorController;
  }

  protected cb func OnGameAttached() -> Bool {
    let secSys: ref<SecuritySystemControllerPS> = this.GetDevicePS().GetSecuritySystem();
    if IsDefined(secSys) && !secSys.IsSystemSafe() && !this.IsPlayerAuthorized() {
      this.TriggerAlarmBehavior(true);
    };
  }

  protected cb func OnDetach() -> Bool {
    this.TriggerAlarmBehavior(false);
  }

  public const func GetDevicePS() -> ref<DoorProximityDetectorControllerPS> {
    return this.GetController().GetPS();
  }

  private const func GetController() -> ref<DoorProximityDetectorController> {
    return this.m_controller as DoorProximityDetectorController;
  }

  protected func TurnOffDevice() -> Void {
    super.TurnOffDevice();
    this.SetAppearanceState(DoorProximityDetectorAppearanceStateType.Off);
  }

  protected func TurnOnDevice() -> Void {
    super.TurnOnDevice();
    this.LockDevice(true);
  }

  protected func LockDevice(shouldLock: Bool) -> Void {
    if shouldLock {
      if this.IsPlayerAuthorized() {
        this.SetAppearanceState(DoorProximityDetectorAppearanceStateType.On);
      } else {
        this.SetAppearanceState(DoorProximityDetectorAppearanceStateType.Bars);
      };
    } else {
      this.SetAppearanceState(DoorProximityDetectorAppearanceStateType.Green);
    };
  }

  private final func IsPlayerAuthorized() -> Bool {
    this.GetDevicePS().IsConnectedToSecuritySystem(this.m_authorizationLevel);
    return this.GetDevicePS().GetSecuritySystem().IsUserAuthorized(this.GetPlayerMainObject().GetEntityID(), this.m_authorizationLevel);
  }

  private final func SetAppearanceState(appearanceState: DoorProximityDetectorAppearanceStateType) -> Void {
    let meshName: CName;
    switch appearanceState {
      case DoorProximityDetectorAppearanceStateType.On:
        meshName = n"on";
        break;
      case DoorProximityDetectorAppearanceStateType.Off:
        meshName = n"off";
        break;
      case DoorProximityDetectorAppearanceStateType.Bars:
        meshName = n"bars";
        break;
      case DoorProximityDetectorAppearanceStateType.Green:
        meshName = n"green";
        break;
      case DoorProximityDetectorAppearanceStateType.Alarm:
        meshName = n"alarm";
        break;
      case DoorProximityDetectorAppearanceStateType.Glitch:
        meshName = n"glitch";
    };
    this.SetMeshAppearance(meshName);
  }

  private final func TriggerAlarmBehavior(yes: Bool) -> Void {
    let alarm: ref<AlarmEvent>;
    let ds: ref<DelaySystem>;
    if this.GetDevicePS().GetSecuritySystem().IsRestarting() {
      this.LockDevice(false);
      return;
    };
    ds = GameInstance.GetDelaySystem(this.GetGame());
    if !IsDefined(ds) {
      return;
    };
    if yes {
      if !this.IsAlarmTriggered() {
        alarm = new AlarmEvent();
        this.m_triggeredAlarmID = ds.DelayEvent(this, alarm, this.m_blinkInterval);
      };
    } else {
      if this.IsAlarmTriggered() {
        this.CancelAlarmCallback();
        this.LockDevice(!this.GetDevicePS().GetSecuritySystem().IsRestarting());
      };
    };
  }

  protected cb func OnSecuritySystemOutput(evt: ref<SecuritySystemOutput>) -> Bool {
    if this.IsDeviceUsable() {
      this.TriggerAlarmBehavior(Equals(evt.GetCachedSecurityState(), ESecuritySystemState.COMBAT));
    };
  }

  private final func IsAlarmTriggered() -> Bool {
    let nullID: DelayID;
    if this.m_triggeredAlarmID == nullID {
      return false;
    };
    return true;
  }

  protected cb func OnAlarmBlink(evt: ref<AlarmEvent>) -> Bool {
    if this.GetDevicePS().GetSecuritySystem().IsRestarting() || this.GetDevicePS().GetSecuritySystem().IsSystemSafe() {
      this.CancelAlarmCallback();
      this.TriggerAlarmBehavior(false);
      this.LockDevice(true);
      return false;
    };
    if evt.isValid {
      this.SetAppearanceState(DoorProximityDetectorAppearanceStateType.Bars);
    } else {
      this.SetAppearanceState(DoorProximityDetectorAppearanceStateType.Alarm);
    };
    evt.isValid = !evt.isValid;
    this.m_triggeredAlarmID = GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(this, evt, this.m_blinkInterval);
  }

  private final func CancelAlarmCallback() -> Void {
    let emptyID: DelayID;
    let ds: ref<DelaySystem> = GameInstance.GetDelaySystem(this.GetGame());
    if !IsDefined(ds) {
      return;
    };
    ds.CancelCallback(this.m_triggeredAlarmID);
    ds.CancelDelay(this.m_triggeredAlarmID);
    this.m_triggeredAlarmID = emptyID;
  }

  protected func StartGlitching(glitchState: EGlitchState, opt intensity: Float) -> Void {
    this.SetAppearanceState(DoorProximityDetectorAppearanceStateType.Glitch);
  }

  protected func StopGlitching() -> Void {
    this.LockDevice(true);
  }
}
