
public class LaserDetector extends ProximityDetector {

  private let m_lasers: [ref<MeshComponent>; 2];

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    EntityRequestComponentsInterface.RequestComponent(ri, n"laserBottom", n"MeshComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"laserTop", n"MeshComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, this.m_scanningAreaName, n"gameStaticTriggerAreaComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, this.m_surroundingAreaName, n"gameStaticTriggerAreaComponent", false);
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    this.m_lasers[0] = EntityResolveComponentsInterface.GetComponent(ri, n"laserBottom") as MeshComponent;
    this.m_lasers[1] = EntityResolveComponentsInterface.GetComponent(ri, n"laserTop") as MeshComponent;
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as LaserDetectorController;
  }

  public const func GetDevicePS() -> ref<LaserDetectorControllerPS> {
    return this.GetController().GetPS();
  }

  private const func GetController() -> ref<LaserDetectorController> {
    return this.m_controller as LaserDetectorController;
  }

  protected func TurnOffDevice() -> Void {
    let i: Int32;
    super.TurnOffDevice();
    i = 0;
    while i < ArraySize(this.m_lasers) {
      this.m_lasers[i].Toggle(false);
      i += 1;
    };
  }

  protected func TurnOnDevice() -> Void {
    let i: Int32;
    super.TurnOnDevice();
    i = 0;
    while i < ArraySize(this.m_lasers) {
      this.m_lasers[i].Toggle(true);
      i += 1;
    };
  }

  protected func LockDevice(on: Bool) -> Void {
    this.ChangeLasersColor(!on);
  }

  private final func ChangeLasersColor(toGreen: Bool) -> Void {
    if toGreen {
      this.SetMeshAppearance(n"hologram");
    } else {
      this.SetMeshAppearance(n"hologram_red");
    };
  }
}
