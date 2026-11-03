
public class Reflector extends BlindingLight {

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as ReflectorController;
  }

  public const func GetDevicePS() -> ref<ReflectorControllerPS> {
    return this.GetController().GetPS();
  }

  private const func GetController() -> ref<ReflectorController> {
    return this.m_controller as ReflectorController;
  }

  protected cb func OnDistraction(evt: ref<Distraction>) -> Bool {
    if evt.IsStarted() {
      this.StartDistraction(true);
    } else {
      this.StopDistraction();
    };
    this.RefreshInteraction(gamedeviceRequestType.Direct, GetPlayer(this.GetGame()));
  }
}
