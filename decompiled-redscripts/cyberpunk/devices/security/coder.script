
public class Coder extends BasicDistractionDevice {

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as CoderController;
  }

  private const func GetController() -> ref<CoderController> {
    return this.m_controller as CoderController;
  }

  public const func GetDevicePS() -> ref<CoderControllerPS> {
    return this.GetController().GetPS();
  }
}
