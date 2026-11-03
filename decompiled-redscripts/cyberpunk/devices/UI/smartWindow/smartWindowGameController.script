
public class SmartWindowInkGameController extends ComputerInkGameController {

  protected cb func OnInitialize() -> Bool {
    super.OnInitialize();
  }

  protected func GetOwner() -> ref<SmartWindow> {
    return this.GetOwnerEntity() as SmartWindow;
  }

  protected func InitializeMainLayout() -> Void {
    if !TDBID.IsValid(this.m_layoutID) {
      this.m_layoutID = t"DevicesUIDefinitions.SmartWindowLayoutWidget";
    };
    super.InitializeMainLayout();
  }

  public func Refresh(state: EDeviceStatus) -> Void {
    if Equals(state, this.m_cashedState) {
      return;
    };
    super.Refresh(state);
  }

  protected func TurnOn() -> Void {
    this.m_rootWidget.SetVisible(true);
    this.RequestActionWidgetsUpdate();
    this.ShowMails();
    this.ShowNewsfeed();
    this.ShowDevices();
  }

  protected func TurnOff() -> Void {
    this.m_rootWidget.SetVisible(false);
    this.m_devicesMenuInitialized = false;
  }

  public func GetMainLayoutController() -> ref<SmartWindowMainLayoutWidgetController> {
    return this.m_mainLayout.GetController() as SmartWindowMainLayoutWidgetController;
  }

  public func UpdateMailsWidgets(widgetsData: [SDocumentWidgetPackage]) -> Void {
    let i: Int32 = 0;
    while i < ArraySize(widgetsData) {
      widgetsData[i].placement = EWidgetPlacementType.FLOATING;
      i += 1;
    };
    this.InitializeMails(widgetsData);
  }

  public func UpdateFilesWidgets(widgetsData: [SDocumentWidgetPackage]) -> Void {
    let i: Int32 = 0;
    while i < ArraySize(widgetsData) {
      widgetsData[i].placement = EWidgetPlacementType.FLOATING;
      i += 1;
    };
    this.InitializeFiles(widgetsData);
  }
}
