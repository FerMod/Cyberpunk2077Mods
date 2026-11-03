
public class HoloDevice extends InteractiveDevice {

  private let m_questFactName: CName;

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    EntityRequestComponentsInterface.RequestComponent(ri, n"ui", n"worlduiWidgetComponent", false);
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    this.m_uiComponent = EntityResolveComponentsInterface.GetComponent(ri, n"ui") as worlduiWidgetComponent;
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as HoloDeviceController;
  }

  protected func ResolveGameplayState() -> Void {
    super.ResolveGameplayState();
    if this.IsUIdirty() && this.m_isInsideLogicArea {
      this.RefreshUI();
    };
  }

  protected cb func OnPlay(evt: ref<TogglePlay>) -> Bool {
    this.UpdateDeviceState();
    this.UpdateFactDB();
    this.UpdateUI();
  }

  private final func UpdateFactDB() -> Void {
    let factValue: Int32;
    if NotEquals(this.m_questFactName, n"None") {
      factValue = 2;
      if this.GetDevicePS().IsPlaying() {
        factValue = 1;
      };
      AddFact(this.GetGame(), this.m_questFactName);
      SetFactValue(this.GetGame(), this.m_questFactName, factValue);
    };
  }

  private final func UpdateUI() -> Void;

  private const func GetController() -> ref<HoloDeviceController> {
    return this.m_controller as HoloDeviceController;
  }

  public const func GetDevicePS() -> ref<HoloDeviceControllerPS> {
    return this.GetController().GetPS();
  }
}
