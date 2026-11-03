
public class VirtualMasterDevicePS extends ScriptableDeviceComponentPS {

  public let m_owner: ref<IScriptable>;

  public let m_globalActions: [ref<DeviceAction>];

  protected persistent let m_context: GetActionsContext;

  public let m_connectedDevices: [ref<DeviceComponentPS>];

  public func InitializeVirtualDevice() -> Void {
    this.SetDeviceState(EDeviceStatus.ON);
    this.Initialize();
  }

  protected func DoCustomShit(const devices: script_ref<[ref<DeviceComponentPS>]>, on: Bool) -> Void;

  protected func GetGlobalActions(actions: script_ref<[ref<DeviceAction>]>) -> Void;
}
