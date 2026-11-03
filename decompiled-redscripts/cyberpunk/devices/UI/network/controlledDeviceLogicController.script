
public class ControlledDeviceLogicController extends inkLogicController {

  private let m_deviceIcon: wref<inkImage>;

  private let m_nestIcon: wref<inkImage>;

  private let m_activeBg: wref<inkRectangle>;

  protected cb func OnInitialize() -> Bool {
    this.m_deviceIcon = this.GetWidget(n"device_icon") as inkImage;
    this.m_nestIcon = this.GetWidget(n"nest_icon") as inkImage;
    this.m_activeBg = this.GetWidget(n"activeBg") as inkRectangle;
    this.m_deviceIcon.SetVisible(true);
    this.m_nestIcon.SetVisible(false);
    this.m_activeBg.SetVisible(true);
  }

  public func Initialize(gameController: ref<ControlledDevicesInkGameController>, const widgetData: script_ref<SWidgetPackage>) -> Void {
    let customData: ref<ControlledDeviceData> = Deref(widgetData).customData as ControlledDeviceData;
    if IsDefined(customData) && customData.m_isNest {
      this.m_nestIcon.SetVisible(true);
      this.m_deviceIcon.SetVisible(false);
    } else {
      this.m_nestIcon.SetVisible(false);
      this.m_deviceIcon.SetVisible(true);
    };
    if IsDefined(customData) && customData.m_isActive {
      if customData.m_isNest {
        this.m_nestIcon.SetState(n"Active");
      } else {
        this.m_deviceIcon.SetState(n"Active");
      };
      this.m_activeBg.SetState(n"Active");
    } else {
      if customData.m_isNest {
        this.m_nestIcon.SetState(n"Default");
      } else {
        this.m_deviceIcon.SetState(n"Default");
      };
      this.m_activeBg.SetState(n"Default");
    };
  }
}
