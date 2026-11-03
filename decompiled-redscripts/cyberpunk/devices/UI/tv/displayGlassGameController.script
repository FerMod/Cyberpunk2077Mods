
public class DisplayGlassInkGameController extends DeviceInkGameControllerBase {

  public final func TurnOn() -> Void {
    if this.GetOwner().GetDevicePS().IsTinted() {
      this.m_rootWidget.SetVisible(true);
    };
  }

  public final func TurnOff() -> Void {
    this.m_rootWidget.SetVisible(false);
  }

  public func Refresh(state: EDeviceStatus) -> Void {
    this.SetupWidgets();
    switch state {
      case EDeviceStatus.ON:
        this.TurnOn();
        break;
      case EDeviceStatus.OFF:
        this.TurnOff();
        break;
      case EDeviceStatus.UNPOWERED:
        break;
      case EDeviceStatus.DISABLED:
        break;
      default:
    };
    super.Refresh(state);
  }

  protected func GetOwner() -> ref<DisplayGlass> {
    return this.GetOwnerEntity() as DisplayGlass;
  }
}
