
public class NetrunnerControlPanel extends BasicDistractionDevice {

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as NetrunnerControlPanelController;
  }

  protected cb func OnCreateFactQuickHack(evt: ref<FactQuickHack>) -> Bool {
    let properties: ComputerQuickHackData = evt.GetFactProperties();
    if Equals(properties.operationType, EMathOperationType.Set) {
      SetFactValue(this.GetGame(), properties.factName, properties.factValue);
    } else {
      AddFact(this.GetGame(), properties.factName, properties.factValue);
    };
  }

  private const func GetController() -> ref<NetrunnerControlPanelController> {
    return this.m_controller as NetrunnerControlPanelController;
  }

  public const func GetDevicePS() -> ref<NetrunnerControlPanelControllerPS> {
    return this.GetController().GetPS();
  }
}
