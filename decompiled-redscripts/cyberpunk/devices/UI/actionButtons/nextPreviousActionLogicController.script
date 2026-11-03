
public class NextPreviousActionWidgetController extends DeviceActionWidgetControllerBase {

  @runtimeProperty("category", "Widget Refs")
  protected edit let m_defaultContainer: inkWidgetRef;

  @runtimeProperty("category", "Widget Refs")
  protected edit let m_declineContainer: inkWidgetRef;

  @runtimeProperty("category", "Animations")
  @default(NextPreviousActionWidgetController, no_money)
  protected edit let m_moneyStatusAnimName: CName;

  protected let m_isProcessing: Bool;

  public func Initialize(gameController: ref<DeviceInkGameControllerBase>, const widgetData: script_ref<SActionWidgetPackage>) -> Void {
    super.Initialize(gameController, widgetData);
    inkWidgetRef.SetVisible(this.m_declineContainer, false);
  }

  public func FinalizeActionExecution(executor: ref<GameObject>, action: ref<DeviceAction>) -> Void {
    let contextAction: ref<BaseScriptableAction> = action as BaseScriptableAction;
    if !contextAction.CanPayCost(executor) {
      this.Decline();
    };
  }

  public func Decline() -> Void {
    if !this.m_isProcessing {
      this.m_isProcessing = true;
      this.m_targetWidget.SetInteractive(false);
      this.PlayLibraryAnimation(this.m_moneyStatusAnimName).RegisterToCallback(inkanimEventType.OnFinish, this, n"OnNoMoneyShowed");
    };
  }

  public func Reset() -> Void {
    this.m_isProcessing = false;
    this.m_targetWidget.SetInteractive(true);
    this.m_targetWidget.SetState(n"Default");
  }

  protected cb func OnNoMoneyShowed(e: ref<inkAnimProxy>) -> Bool {
    e.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnNoMoneyShowed");
    this.Reset();
  }

  public final func Deactivate() -> Void {
    this.m_targetWidget.SetInteractive(false);
    this.m_targetWidget.SetState(n"Off");
  }

  public const func CanExecuteAction() -> Bool {
    return super.CanExecuteAction() && !this.m_isProcessing;
  }
}
