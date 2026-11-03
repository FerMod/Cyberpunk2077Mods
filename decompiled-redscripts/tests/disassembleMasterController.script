
public class DisassembleMasterController extends MasterController {

  public const func GetPS() -> ref<DisassembleMasterControllerPS> {
    return this.GetBasePS() as DisassembleMasterControllerPS;
  }
}

public class DisassembleMasterControllerPS extends MasterControllerPS {

  protected cb func OnInstantiated() -> Bool {
    super.OnInstantiated();
    if !IsStringValid(this.m_deviceName) {
      this.m_deviceName = "Disassemble Master";
    };
  }

  protected func Initialize() -> Void {
    super.Initialize();
  }

  public func GetActions(out outActions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    super.GetActions(outActions, context);
    this.SetActionIllegality(outActions, this.m_illegalActions.regularActions);
    return true;
  }

  public final func RefreshLockOnSlaves() -> Void {
    let locked: ref<ToggleLock>;
    let open: ref<ForceOpen>;
    let devices: array<ref<DeviceComponentPS>> = this.GetImmediateSlaves();
    let i: Int32 = 0;
    while i < ArraySize(devices) {
      this.ExtractActionFromSlave(devices[i], n"ToggleLock", locked);
      if IsDefined(locked) {
        this.GetPersistencySystem().QueuePSDeviceEvent(locked);
      };
      this.ExtractActionFromSlave(devices[i], n"ForceOpen", open);
      if IsDefined(open) {
        this.GetPersistencySystem().QueuePSDeviceEvent(open);
      };
      i += 1;
    };
  }

  public func OnDisassembleDevice(evt: ref<DisassembleDevice>) -> EntityNotificationType {
    this.TurnAuthorizationModuleOFF();
    return super.OnDisassembleDevice(evt);
  }
}
