
public class IceMachineInkGameController extends DeviceInkGameControllerBase {

  @runtimeProperty("category", "Widget Refs")
  private edit let m_buttonContainer: inkWidgetRef;

  @runtimeProperty("category", "Widget Refs")
  private edit let m_soldOutText: inkTextRef;

  public func UpdateActionWidgets(const widgetsData: script_ref<[SActionWidgetPackage]>) -> Void {
    let i: Int32;
    let widget: ref<inkWidget>;
    this.HideActionWidgets();
    inkWidgetRef.SetVisible(this.m_buttonContainer, true);
    inkWidgetRef.SetVisible(this.m_soldOutText, false);
    if ArraySize(Deref(widgetsData)) > 0 {
      i = 0;
      while i < ArraySize(Deref(widgetsData)) {
        widget = this.GetActionWidget(Deref(widgetsData)[i]);
        if widget == null {
          this.CreateActionWidgetAsync(inkWidgetRef.Get(this.m_buttonContainer), Deref(widgetsData)[i]);
        } else {
          this.InitializeActionWidget(widget, Deref(widgetsData)[i]);
        };
        i += 1;
      };
    } else {
      inkWidgetRef.SetVisible(this.m_soldOutText, true);
    };
  }

  protected func GetOwner() -> ref<IceMachine> {
    return this.GetOwnerEntity() as IceMachine;
  }

  protected func Refresh(state: EDeviceStatus) -> Void {
    this.SetupWidgets();
    super.Refresh(state);
    this.HideActionWidgets();
    this.RequestActionWidgetsUpdate();
  }
}
