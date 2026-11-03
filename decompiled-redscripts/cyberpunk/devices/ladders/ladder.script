
public class Ladder extends InteractiveDevice {

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as LadderController;
  }

  protected const func HasAnyDirectInteractionActive() -> Bool {
    return true;
  }

  public const func DeterminGameplayRole() -> EGameplayRole {
    return EGameplayRole.OpenPath;
  }

  private const func GetController() -> ref<LadderController> {
    return this.m_controller as LadderController;
  }

  public const func GetDevicePS() -> ref<LadderControllerPS> {
    return this.GetController().GetPS();
  }
}
