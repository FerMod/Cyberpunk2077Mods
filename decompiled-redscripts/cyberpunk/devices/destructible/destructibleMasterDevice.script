
public class DestructibleMasterDevice extends InteractiveMasterDevice {

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as DestructibleMasterDeviceController;
  }

  protected cb func OnDetach() -> Bool {
    super.OnDetach();
  }

  protected cb func OnPhysicalDestructionEvent(evt: ref<PhysicalDestructionEvent>) -> Bool {
    this.GetDevicePS().RefreshSlaves_Event();
  }

  protected const func GetController() -> ref<DestructibleMasterDeviceController> {
    return this.m_controller as DestructibleMasterDeviceController;
  }

  public const func GetDevicePS() -> ref<DestructibleMasterDeviceControllerPS> {
    return this.GetController().GetPS();
  }
}
