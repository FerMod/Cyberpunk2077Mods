
public class SurveillanceSystem extends DeviceSystemBase {

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as SurveillanceSystemController;
    super.OnTakeControl(ri);
  }

  protected const func GetController() -> ref<SurveillanceSystemController> {
    return this.m_controller as SurveillanceSystemController;
  }

  public const func GetDevicePS() -> ref<SurveillanceSystemControllerPS> {
    return this.GetController().GetPS();
  }
}
