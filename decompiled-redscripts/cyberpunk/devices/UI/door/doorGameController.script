
public class DoorInkGameController extends DeviceInkGameControllerBase {

  private let m_doorStaturTextWidget: wref<inkText>;

  protected func SetupWidgets() -> Void {
    if !this.m_isInitialized {
      this.m_doorStaturTextWidget = this.GetWidget(n"statusTextPanel\\status_text") as inkText;
    };
  }

  public func UpdateActionWidgets(const widgetsData: script_ref<[SActionWidgetPackage]>) -> Void;

  public func Refresh(state: EDeviceStatus) -> Void {
    this.SetupWidgets();
    this.m_doorStaturTextWidget.SetText(this.GetOwner().GetDevicePS().GetDeviceStatus());
    super.Refresh(state);
  }

  protected func RegisterBlackboardCallbacks(blackboard: ref<IBlackboard>) -> Void {
    super.RegisterBlackboardCallbacks(blackboard);
  }

  protected func GetOwner() -> ref<Door> {
    return this.GetOwnerEntity() as Door;
  }
}
