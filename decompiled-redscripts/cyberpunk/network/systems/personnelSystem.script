
public class PersonnelSystem extends DeviceSystemBase {

  private let m_EnableE3QuickHacks: Bool;

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as PersonnelSystemController;
    super.OnTakeControl(ri);
  }

  protected const func GetController() -> ref<PersonnelSystemController> {
    return this.m_controller as PersonnelSystemController;
  }

  public const func GetDevicePS() -> ref<PersonnelSystemControllerPS> {
    return this.GetController().GetPS();
  }
}
