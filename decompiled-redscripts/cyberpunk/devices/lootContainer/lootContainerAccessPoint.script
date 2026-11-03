
public class LootContainerAccessPoint extends AccessPoint {

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as LootContainerAccessPointController;
  }

  public const func GetDevicePS() -> ref<LootContainerAccessPointControllerPS> {
    return this.GetController().GetPS();
  }

  private const func GetController() -> ref<LootContainerAccessPointController> {
    return this.m_controller as LootContainerAccessPointController;
  }

  public const func DeterminGameplayRole() -> EGameplayRole {
    return EGameplayRole.ControlOtherDevice;
  }
}
