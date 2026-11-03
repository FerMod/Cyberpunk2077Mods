
public class InitializeUserScreenGameController extends gameuiMenuGameController {

  private edit let m_backgroundVideo: inkVideoRef;

  private edit let m_breachingContainer: inkCompoundRef;

  private edit let m_progressBar: inkCompoundRef;

  private let m_menuEventDispatcher: wref<inkMenuEventDispatcher>;

  private let m_requestHandler: wref<inkISystemRequestsHandler>;

  private let m_progressBarController: wref<LoadingScreenProgressBarController>;

  protected cb func OnInitialize() -> Bool {
    inkVideoRef.Play(this.m_backgroundVideo);
    this.m_requestHandler = this.GetSystemRequestsHandler();
    this.m_requestHandler.RegisterToCallback(n"OnAdditionalContentDataReloadProgressCallback", this, n"OnAdditionalContentDataReloadProgress");
    this.m_progressBarController = inkWidgetRef.GetController(this.m_progressBar) as LoadingScreenProgressBarController;
    inkWidgetRef.SetVisible(this.m_progressBar, false);
  }

  protected cb func OnUninitialize() -> Bool {
    inkVideoRef.Stop(this.m_backgroundVideo);
    this.m_requestHandler.UnregisterFromCallback(n"OnAdditionalContentDataReloadProgressCallback", this, n"OnAdditionalContentDataReloadProgress");
  }

  protected cb func OnSetMenuEventDispatcher(menuEventDispatcher: wref<inkMenuEventDispatcher>) -> Bool {
    this.m_menuEventDispatcher = menuEventDispatcher;
  }

  protected cb func OnAdditionalContentDataReloadProgress(progress: Float) -> Bool {
    if progress >= 0.00 {
      inkWidgetRef.SetVisible(this.m_breachingContainer, false);
      inkWidgetRef.SetVisible(this.m_progressBar, true);
      this.m_progressBarController.SetSpinnerVisibility(true);
      this.m_progressBarController.SetProgress(progress);
    };
  }
}
