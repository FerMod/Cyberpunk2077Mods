
public class DestructibleMasterDeviceController extends MasterController {

  public const func GetPS() -> ref<DestructibleMasterDeviceControllerPS> {
    return this.GetBasePS() as DestructibleMasterDeviceControllerPS;
  }
}

public class DestructibleMasterDeviceControllerPS extends MasterControllerPS {

  protected let m_isDestroyed: Bool;

  protected cb func OnInstantiated() -> Bool {
    super.OnInstantiated();
  }

  protected func Initialize() -> Void {
    super.Initialize();
  }

  protected func GameAttached() -> Void;

  public final const func IsDestroyed() -> Bool {
    return this.m_isDestroyed;
  }

  protected func OnRefreshSlavesEvent(evt: ref<RefreshSlavesEvent>) -> EntityNotificationType {
    this.m_isDestroyed = true;
    this.RefreshSlaves();
    return EntityNotificationType.DoNotNotifyEntity;
  }

  protected final func RefreshSlaves() -> Void {
    let devices: array<ref<DeviceComponentPS>> = this.GetImmediateSlaves();
    let evt: ref<MasterDeviceDestroyed> = this.ActionMasterDeviceDestroyed();
    let i: Int32 = 0;
    while i < ArraySize(devices) {
      if IsDefined(devices[i]) && devices[i].IsAttachedToGame() {
        this.ExecutePSAction(evt, devices[i]);
      };
      i += 1;
    };
  }

  protected final func ActionMasterDeviceDestroyed() -> ref<MasterDeviceDestroyed> {
    let delayEvent: ref<MasterDeviceDestroyed> = new MasterDeviceDestroyed();
    delayEvent.SetUp(this);
    delayEvent.SetProperties();
    delayEvent.AddDeviceName(this.m_deviceName);
    return delayEvent;
  }
}
