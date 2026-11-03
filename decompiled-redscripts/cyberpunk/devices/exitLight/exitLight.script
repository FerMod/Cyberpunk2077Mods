
public class ExitLight extends ElectricLight {

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as ExitLightController;
  }

  public const func GetDevicePS() -> ref<ExitLightControllerPS> {
    return this.GetController().GetPS();
  }

  private const func GetController() -> ref<ExitLightController> {
    return this.m_controller as ExitLightController;
  }

  protected cb func OnHitEvent(hit: ref<gameHitEvent>) -> Bool {
    super.OnHitEvent(hit);
  }

  protected func TurnOnDevice() -> Void {
    this.TurnGreen();
  }

  protected func TurnOffDevice() -> Void {
    this.TurnRed();
  }

  protected func ReactToHit(hit: ref<gameHitEvent>) -> Void {
    super.ReactToHit(hit);
  }

  private final func TurnRed() -> Void {
    this.SetMeshAppearance(n"red");
  }

  private final func TurnGreen() -> Void {
    this.SetMeshAppearance(n"green");
  }
}
