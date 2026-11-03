
public class CleaningMachine extends BasicDistractionDevice {

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as CleaningMachineController;
  }

  private const func GetController() -> ref<CleaningMachineController> {
    return this.m_controller as CleaningMachineController;
  }

  public const func GetDevicePS() -> ref<CleaningMachineControllerPS> {
    return this.GetController().GetPS();
  }
}
