
public class ActionsSequencer extends InteractiveMasterDevice {

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as ActionsSequencerController;
  }

  private const func GetController() -> ref<ActionsSequencerController> {
    return this.m_controller as ActionsSequencerController;
  }

  public const func GetDevicePS() -> ref<ActionsSequencerControllerPS> {
    return this.GetController().GetPS();
  }
}
