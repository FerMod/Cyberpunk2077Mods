
public class SmartWindow extends Computer {

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as SmartWindowController;
  }

  private const func GetController() -> ref<SmartWindowController> {
    return this.m_controller as SmartWindowController;
  }

  public const func GetDevicePS() -> ref<SmartWindowControllerPS> {
    return this.GetController().GetPS();
  }

  private func InitializeScreenDefinition() -> Void {
    if !TDBID.IsValid(this.m_screenDefinition.screenDefinition) {
      this.m_screenDefinition.screenDefinition = t"DevicesUIDefinitions.SmartWindow_3x4";
    };
    if !TDBID.IsValid(this.m_screenDefinition.style) {
      this.m_screenDefinition.style = t"DevicesUIStyles.None";
    };
  }
}
