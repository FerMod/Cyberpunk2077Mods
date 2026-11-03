
public class SimpleOnTurnOnPlayEffectDevice extends Device {

  public let m_OnTurnOnEffectName: CName;

  public let m_OnTurnOffEffectName: CName;

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as SimpleOnTurnOnPlayEffectDeviceController;
  }

  private const func GetController() -> ref<SimpleOnTurnOnPlayEffectDeviceController> {
    return this.m_controller as SimpleOnTurnOnPlayEffectDeviceController;
  }

  public const func GetDevicePS() -> ref<SimpleOnTurnOnPlayEffectDeviceControllerPS> {
    return this.GetController().GetPS();
  }

  protected const func ShouldRegisterToHUD() -> Bool {
    return false;
  }

  protected func TurnOnDevice() -> Void {
    super.TurnOnDevice();
    if NotEquals(this.m_OnTurnOnEffectName, n"None") {
      GameObjectEffectHelper.StartEffectEvent(this, this.m_OnTurnOnEffectName);
    };
  }

  protected func TurnOffDevice() -> Void {
    super.TurnOffDevice();
    if NotEquals(this.m_OnTurnOffEffectName, n"None") {
      GameObjectEffectHelper.StartEffectEvent(this, this.m_OnTurnOffEffectName);
    };
  }
}
