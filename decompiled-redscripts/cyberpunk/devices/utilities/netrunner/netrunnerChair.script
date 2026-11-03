
public class NetrunnerChair extends InteractiveDevice {

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as NetrunnerChairController;
  }

  private const func GetController() -> ref<NetrunnerChairController> {
    return this.m_controller as NetrunnerChairController;
  }

  public const func GetDevicePS() -> ref<NetrunnerChairControllerPS> {
    return this.GetController().GetPS();
  }

  public const func DeterminGameplayRole() -> EGameplayRole {
    return EGameplayRole.ExplodeLethal;
  }
}
