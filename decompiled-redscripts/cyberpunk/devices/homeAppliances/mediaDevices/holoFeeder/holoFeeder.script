
public class HoloFeeder extends InteractiveDevice {

  private let m_feederMesh: ref<IPlacedComponent>;

  private let m_feederMesh1: ref<IPlacedComponent>;

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
    EntityRequestComponentsInterface.RequestComponent(ri, n"feeder", n"IPlacedComponent", true);
    EntityRequestComponentsInterface.RequestComponent(ri, n"feeder_1", n"IPlacedComponent", false);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as HoloFeederController;
    this.m_feederMesh = EntityResolveComponentsInterface.GetComponent(ri, n"feeder") as IPlacedComponent;
    this.m_feederMesh1 = EntityResolveComponentsInterface.GetComponent(ri, n"feeder_1") as IPlacedComponent;
  }

  private const func GetController() -> ref<HoloFeederController> {
    return this.m_controller as HoloFeederController;
  }

  public const func GetDevicePS() -> ref<HoloFeederControllerPS> {
    return this.GetController().GetPS();
  }

  protected func CutPower() -> Void {
    this.TurnOff();
  }

  protected func TurnOnDevice() -> Void {
    this.TurnOn();
  }

  protected func TurnOffDevice() -> Void {
    this.TurnOff();
  }

  private final func TurnOn() -> Void {
    this.m_feederMesh.Toggle(true);
    if IsDefined(this.m_feederMesh1) {
      this.m_feederMesh1.Toggle(true);
    };
    GameObject.PlaySoundEvent(this, this.GetDevicePS().GetOnSound());
  }

  private final func TurnOff() -> Void {
    this.m_feederMesh.Toggle(false);
    if IsDefined(this.m_feederMesh1) {
      this.m_feederMesh1.Toggle(false);
    };
    GameObject.PlaySoundEvent(this, this.GetDevicePS().GetOffSound());
  }
}
