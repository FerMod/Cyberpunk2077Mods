
public class EngagementScreenGameController extends gameuiMenuGameController {

  private edit let m_backgroundVideo: inkVideoRef;

  private edit let m_proceedConfirmationContainer: inkCompoundRef;

  private edit let m_progressBar: inkCompoundRef;

  private edit let m_pressKeyWidget: inkWidgetRef;

  private edit let m_breachingWidget: inkWidgetRef;

  private let m_menuEventDispatcher: wref<inkMenuEventDispatcher>;

  private let m_requestHandler: wref<inkISystemRequestsHandler>;

  private let m_progressBarController: wref<LoadingScreenProgressBarController>;

  @default(EngagementScreenGameController, false)
  private let m_breachingEnabled: Bool;

  protected cb func OnInitialize() -> Bool {
    inkVideoRef.Play(this.m_backgroundVideo);
    this.m_requestHandler = this.GetSystemRequestsHandler();
    this.m_requestHandler.RegisterToCallback(n"OnAdditionalContentDataReloadProgressCallback", this, n"OnAdditionalContentDataReloadProgress");
    this.m_requestHandler.RegisterToCallback(n"OnToggleBreachingCallback", this, n"OnToggleBreachingCallback");
    this.m_progressBarController = inkWidgetRef.GetController(this.m_progressBar) as LoadingScreenProgressBarController;
    inkWidgetRef.SetVisible(this.m_progressBar, false);
    inkWidgetRef.SetVisible(this.m_breachingWidget, false);
  }

  protected cb func OnUninitialize() -> Bool {
    inkVideoRef.Stop(this.m_backgroundVideo);
    this.m_requestHandler.UnregisterFromCallback(n"OnAdditionalContentDataReloadProgressCallback", this, n"OnAdditionalContentDataReloadProgress");
    this.m_requestHandler.UnregisterFromCallback(n"OnToggleBreachingCallback", this, n"OnToggleBreachingCallback");
  }

  protected cb func OnSetMenuEventDispatcher(menuEventDispatcher: wref<inkMenuEventDispatcher>) -> Bool {
    this.m_menuEventDispatcher = menuEventDispatcher;
  }

  protected cb func OnAdditionalContentDataReloadProgress(progress: Float) -> Bool {
    if progress >= 0.00 {
      inkWidgetRef.SetVisible(this.m_proceedConfirmationContainer, false);
      inkWidgetRef.SetVisible(this.m_progressBar, true);
      this.m_progressBarController.SetSpinnerVisibility(true);
      this.m_progressBarController.SetProgress(progress);
    };
  }

  protected cb func OnToggleBreachingCallback(enabled: Bool) -> Bool {
    this.m_breachingEnabled = enabled;
    inkWidgetRef.SetVisible(this.m_pressKeyWidget, !this.m_breachingEnabled);
    inkWidgetRef.SetVisible(this.m_breachingWidget, this.m_breachingEnabled);
  }
}
