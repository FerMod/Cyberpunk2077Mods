
public class PlayPauseActionWidgetController extends NextPreviousActionWidgetController {

  @runtimeProperty("category", "Widget Refs")
  protected edit let m_playContainer: inkWidgetRef;

  @default(PlayPauseActionWidgetController, true)
  private let m_isPlaying: Bool;

  public func Initialize(gameController: ref<DeviceInkGameControllerBase>, const widgetData: script_ref<SActionWidgetPackage>) -> Void {
    super.Initialize(gameController, widgetData);
    this.DetermineState();
  }

  public func FinalizeActionExecution(executor: ref<GameObject>, action: ref<DeviceAction>) -> Void {
    let contextAction: ref<TogglePlay> = action as TogglePlay;
    if !contextAction.CanPayCost(executor) {
      this.Decline();
    } else {
      this.TogglePlay(FromVariant<Bool>(contextAction.prop.first));
    };
  }

  public func Reset() -> Void {
    super.Reset();
    this.DetermineState();
  }

  protected final func DetermineState() -> Void {
    if this.m_isPlaying {
      inkWidgetRef.SetVisible(this.m_playContainer, false);
      inkWidgetRef.SetVisible(this.m_defaultContainer, true);
    } else {
      inkWidgetRef.SetVisible(this.m_playContainer, true);
      inkWidgetRef.SetVisible(this.m_defaultContainer, false);
    };
  }

  public final func TogglePlay(value: Bool) -> Void {
    this.m_isPlaying = value;
    this.DetermineState();
  }
}
