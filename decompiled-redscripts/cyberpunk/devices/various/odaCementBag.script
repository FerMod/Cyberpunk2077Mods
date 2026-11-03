
public class OdaCementBag extends InteractiveDevice {

  private let m_onCooldown: Bool;

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as OdaCementBagController;
  }

  public const func GetDevicePS() -> ref<OdaCementBagControllerPS> {
    return this.GetController().GetPS();
  }

  private const func GetController() -> ref<OdaCementBagController> {
    return this.m_controller as OdaCementBagController;
  }

  protected cb func OnHitEvent(hit: ref<gameHitEvent>) -> Bool {
    let evt: ref<DelayEvent>;
    if !this.m_onCooldown {
      this.m_onCooldown = true;
      this.GetDevicePS().GetDeviceOperationsContainer().Execute(n"cement_cloud_VFX", this);
      this.GetDevicePS().GetDeviceOperationsContainer().Execute(n"cement_status_effect", this);
      evt = new DelayEvent();
      GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(this, evt, this.GetDevicePS().GetCementCooldown());
    };
  }

  protected cb func OnDelayEvent(evt: ref<DelayEvent>) -> Bool {
    this.m_onCooldown = false;
  }

  public const func DeterminGameplayRole() -> EGameplayRole {
    return EGameplayRole.Shoot;
  }

  protected const func HasAnyDirectInteractionActive() -> Bool {
    return true;
  }
}
