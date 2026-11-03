
public class SoundSystem extends InteractiveMasterDevice {

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as SoundSystemController;
  }

  private const func GetController() -> ref<SoundSystemController> {
    return this.m_controller as SoundSystemController;
  }

  public const func GetDevicePS() -> ref<SoundSystemControllerPS> {
    return this.GetController().GetPS();
  }
}
