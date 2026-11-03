
public class NumericDisplay extends InteractiveDevice {

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
    EntityRequestComponentsInterface.RequestComponent(ri, n"ui", n"worlduiWidgetComponent", true);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_uiComponent = EntityResolveComponentsInterface.GetComponent(ri, n"ui") as worlduiWidgetComponent;
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as NumericDisplayController;
  }

  protected const func GetController() -> ref<NumericDisplayController> {
    return this.m_controller as NumericDisplayController;
  }

  public const func GetDevicePS() -> ref<NumericDisplayControllerPS> {
    return this.GetController().GetPS();
  }

  protected func CreateBlackboard() -> Void {
    this.m_blackboard = IBlackboard.Create(GetAllBlackboardDefs().NumericDisplay);
  }

  public const func GetBlackboardDef() -> ref<NumericDisplayBlackboardDef> {
    return this.GetDevicePS().GetBlackboardDef();
  }
}
