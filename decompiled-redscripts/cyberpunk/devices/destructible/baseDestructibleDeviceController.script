
public class BaseDestructibleController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<BaseDestructibleControllerPS> {
    return this.GetBasePS() as BaseDestructibleControllerPS;
  }
}

public class BaseDestructibleControllerPS extends ScriptableDeviceComponentPS {

  @default(BaseDestructibleControllerPS, false)
  protected let m_destroyed: Bool;

  protected cb func OnInstantiated() -> Bool {
    super.OnInstantiated();
    if !IsStringValid(this.m_deviceName) {
      this.m_deviceName = "LocKey#127";
    };
  }

  protected func Initialize() -> Void {
    super.Initialize();
  }

  protected func GameAttached() -> Void {
    super.GameAttached();
    if this.IsDisabled() && !this.m_destroyed {
      this.ForceEnableDevice();
    };
  }

  public final func OnMasterDeviceDestroyed(evt: ref<MasterDeviceDestroyed>) -> EntityNotificationType {
    if !this.IsDisabled() {
      this.ForceDisableDevice();
    };
    this.UseNotifier(evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  public final func IsMasterDestroyed() -> Bool {
    let i: Int32;
    let master: ref<DestructibleMasterDeviceControllerPS>;
    let masters: array<ref<DeviceComponentPS>>;
    this.GetParents(masters);
    i = 0;
    while i < ArraySize(masters) {
      master = masters[i] as DestructibleMasterDeviceControllerPS;
      if IsDefined(master) {
        return master.IsDestroyed();
      };
      i += 1;
    };
    return false;
  }

  public final func SetDestroyed() -> Void {
    this.m_destroyed = true;
  }

  public final func IsDestroyed() -> Bool {
    return this.m_destroyed;
  }
}
