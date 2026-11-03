
public class DropPointTerminalInkGameController extends DeviceInkGameControllerBase {

  private edit let m_sellAction: inkWidgetRef;

  private edit let m_statusText: inkTextRef;

  private let m_onGlitchingStateChangedListener: ref<CallbackHandle>;

  protected func SetupWidgets() -> Void {
    if !this.m_isInitialized {
      this.m_rootWidget.SetVisible(false);
    };
  }

  public func UpdateActionWidgets(const widgetsData: script_ref<[SActionWidgetPackage]>) -> Void {
    let widget: ref<inkWidget>;
    let i: Int32 = 0;
    while i < ArraySize(Deref(widgetsData)) {
      if Equals(Deref(widgetsData)[i].wasInitalized, true) {
        widget = this.GetActionWidget(Deref(widgetsData)[i]);
        if widget == null {
          widget = this.AddActionWidget(inkWidgetRef.Get(this.m_sellAction), Deref(widgetsData)[i]);
        };
        this.InitializeActionWidget(widget, Deref(widgetsData)[i]);
      };
      i += 1;
    };
  }

  public func Refresh(state: EDeviceStatus) -> Void {
    this.SetupWidgets();
    this.RequestActionWidgetsUpdate();
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

  protected func RegisterBlackboardCallbacks(blackboard: ref<IBlackboard>) -> Void {
    super.RegisterBlackboardCallbacks(blackboard);
    if IsDefined(blackboard) {
      this.m_onGlitchingStateChangedListener = blackboard.RegisterListenerVariant(this.GetOwner().GetBlackboardDef().GlitchData, this, n"OnGlitchingStateChanged");
    };
  }

  protected func UnRegisterBlackboardCallbacks(blackboard: ref<IBlackboard>) -> Void {
    super.UnRegisterBlackboardCallbacks(blackboard);
    if IsDefined(blackboard) {
      blackboard.UnregisterListenerVariant(this.GetOwner().GetBlackboardDef().GlitchData, this.m_onGlitchingStateChangedListener);
    };
  }

  protected cb func OnActionWidgetSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
    widget.SetInteractive(true);
    super.OnActionWidgetSpawned(widget, userData);
  }

  protected func GetOwner() -> ref<DropPoint> {
    return this.GetOwnerEntity() as DropPoint;
  }

  private func StopGlitchingScreen() -> Void {
    this.Refresh(this.GetOwner().GetDeviceState());
  }

  public final func TurnOff() -> Void {
    this.m_rootWidget.SetVisible(false);
  }

  public final func TurnOn() -> Void {
    this.m_rootWidget.SetVisible(true);
    if !this.GetOwner().GetDropPointSystem().IsEnabled() {
      inkTextRef.SetLocalizedTextScript(this.m_statusText, "LocKey#20482");
      this.m_rootWidget.SetState(n"Inactive");
      inkWidgetRef.SetInteractive(this.m_sellAction, false);
    } else {
      inkTextRef.SetLocalizedTextScript(this.m_statusText, "LocKey#42350");
      this.m_rootWidget.SetState(n"Default");
      inkWidgetRef.SetInteractive(this.m_sellAction, true);
    };
  }
}
