
public class DoorTerminalMasterInkGameControllerBase extends MasterDeviceInkGameControllerBase {

  protected let m_currentlyActiveDevices: [PersistentID];

  protected func UpdateThumbnailWidgets(const widgetsData: script_ref<[SThumbnailWidgetPackage]>) -> Void {
    let i: Int32;
    let widget: ref<inkWidget>;
    if ArraySize(Deref(widgetsData)) == 1 {
      ArrayPush(this.m_currentlyActiveDevices, Deref(widgetsData)[i].ownerID);
      this.RequestDeviceWidgetsUpdate(this.m_currentlyActiveDevices);
    } else {
      i = 0;
      while i < ArraySize(Deref(widgetsData)) {
        widget = this.GetThumbnailWidget(Deref(widgetsData)[i]);
        if widget == null {
          this.CreateThumbnailWidgetAsync(this.GetRootWidget(), Deref(widgetsData)[i]);
        } else {
          this.InitializeThumbnailWidget(widget, Deref(widgetsData)[i]);
        };
        i += 1;
      };
      this.GoUp();
    };
  }

  protected func UpdateDeviceWidgets(const widgetsData: script_ref<[SDeviceWidgetPackage]>) -> Void {
    let element: SBreadcrumbElementData;
    let i: Int32;
    let widget: ref<inkWidget>;
    super.UpdateDeviceWidgets(widgetsData);
    ArrayClear(this.m_currentlyActiveDevices);
    i = 0;
    while i < ArraySize(Deref(widgetsData)) {
      if !this.IsOwner(Deref(widgetsData)[i].ownerID) {
        ArrayPush(this.m_currentlyActiveDevices, Deref(widgetsData)[i].ownerID);
      };
      widget = this.GetDeviceWidget(Deref(widgetsData)[i]);
      if widget == null {
        this.CreateDeviceWidgetAsync(this.GetRootWidget(), Deref(widgetsData)[i]);
      } else {
        this.InitializeDeviceWidget(widget, Deref(widgetsData)[i]);
      };
      i += 1;
    };
    element = this.GetCurrentBreadcrumbElement();
    if NotEquals(element.elementName, "device") {
      element.elementName = "device";
      this.GoDown(element);
    };
  }

  protected func Refresh(state: EDeviceStatus) -> Void {
    this.SetupWidgets();
    this.RequestDeviceWidgetsUpdate(this.m_currentlyActiveDevices);
    switch state {
      case EDeviceStatus.ON:
        this.TurnOn();
        break;
      case EDeviceStatus.OFF:
        this.TurnOff();
        break;
      case EDeviceStatus.UNPOWERED:
        this.TurnOff();
        break;
      case EDeviceStatus.DISABLED:
        this.TurnOff();
        break;
      default:
    };
    super.Refresh(state);
  }

  protected func ResolveBreadcrumbLevel() -> Void {
    let element: SBreadcrumbElementData = this.GetCurrentBreadcrumbElement();
    if !IsStringValid(element.elementName) {
      this.RequestThumbnailWidgetsUpdate();
    } else {
      if Equals(element.elementName, "device") {
        this.RequestDeviceWidgetsUpdate(this.m_currentlyActiveDevices);
      };
    };
  }

  protected final func TurnOn() -> Void {
    this.m_rootWidget.SetVisible(true);
    this.ResolveBreadcrumbLevel();
  }

  protected final func TurnOff() -> Void {
    this.m_rootWidget.SetVisible(false);
  }
}
