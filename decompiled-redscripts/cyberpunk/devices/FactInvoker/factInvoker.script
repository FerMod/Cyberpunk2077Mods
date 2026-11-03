
public class FactInvoker extends InteractiveMasterDevice {

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    EntityRequestComponentsInterface.RequestComponent(ri, n"terminalui", n"worlduiWidgetComponent", false);
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    this.m_uiComponent = EntityResolveComponentsInterface.GetComponent(ri, n"terminalui") as worlduiWidgetComponent;
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as FactInvokerController;
  }

  public const func GetDevicePS() -> ref<FactInvokerControllerPS> {
    return this.GetController().GetPS();
  }

  protected const func GetController() -> ref<FactInvokerController> {
    return this.m_controller as FactInvokerController;
  }

  public func ShouldAlwaysUpdateDeviceWidgets() -> Bool {
    return true;
  }
}
