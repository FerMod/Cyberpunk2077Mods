
public native class InteractionsHubGameController extends inkHUDGameController {

  private edit const let m_TopInteractionWidgetsLibraries: [inkWidgetLibraryReference];

  private edit let m_TopInteractionsRoot: inkWidgetRef;

  private edit const let m_BotInteractionWidgetsLibraries: [inkWidgetLibraryReference];

  private edit let m_BotInteractionsRoot: inkWidgetRef;

  private edit let m_TooltipsManagerRef: inkWidgetRef;

  private edit let m_TooltipsAnchorPoint: inkWidgetRef;

  private let m_TooltipsManager: wref<gameuiTooltipsManager>;

  public let m_tooltipProvider: wref<TooltipProvider>;

  public final native func SetShowTooltipsTimer(opt time: Float) -> Void;

  public final native func ResetShowTooltipsTimer() -> Void;

  protected cb func OnInitialize() -> Bool {
    let createdWidget: wref<inkWidget>;
    let libraryRef: inkWidgetLibraryReference;
    let i: Int32 = 0;
    let limit: Int32 = ArraySize(this.m_TopInteractionWidgetsLibraries);
    while i < limit {
      libraryRef = this.m_TopInteractionWidgetsLibraries[i];
      createdWidget = this.SpawnFromExternal(inkWidgetRef.Get(this.m_TopInteractionsRoot), inkWidgetLibraryResource.GetPath(libraryRef.widgetLibrary), libraryRef.widgetItem);
      createdWidget.RegisterToCallback(n"OnTooltipRequest", this, n"OnTooltipRequest");
      i += 1;
    };
    i = 0;
    limit = ArraySize(this.m_BotInteractionWidgetsLibraries);
    while i < limit {
      libraryRef = this.m_BotInteractionWidgetsLibraries[i];
      createdWidget = this.SpawnFromExternal(inkWidgetRef.Get(this.m_BotInteractionsRoot), inkWidgetLibraryResource.GetPath(libraryRef.widgetLibrary), libraryRef.widgetItem);
      createdWidget.RegisterToCallback(n"OnTooltipRequest", this, n"OnTooltipRequest");
      i += 1;
    };
    this.m_TooltipsManager = inkWidgetRef.GetControllerByType(this.m_TooltipsManagerRef, n"gameuiTooltipsManager") as gameuiTooltipsManager;
    if IsDefined(this.m_TooltipsManager) {
      this.m_TooltipsManager.Setup(ETooltipsStyle.HUD, false);
    };
  }

  protected cb func OnRefreshTooltipEvent(e: ref<RefreshTooltipEvent>) -> Bool {
    this.m_tooltipProvider = e.widget.GetControllerByType(n"TooltipProvider") as TooltipProvider;
    if IsDefined(this.m_tooltipProvider) && IsDefined(this.m_TooltipsManager) {
      this.m_TooltipsManager.HideTooltips();
      this.m_TooltipsManager.PlayHidingAnimation();
      if this.m_tooltipProvider.IsVisible() {
        this.SetShowTooltipsTimer();
      } else {
        this.ResetShowTooltipsTimer();
      };
    };
  }

  protected cb func OnInvalidateHidden(e: ref<InvalidateTooltipHiddenStateEvent>) -> Bool {
    this.m_tooltipProvider = e.widget.GetControllerByType(n"TooltipProvider") as TooltipProvider;
    if IsDefined(this.m_TooltipsManager) && IsDefined(this.m_tooltipProvider) && !this.m_tooltipProvider.IsVisible() {
      this.ResetShowTooltipsTimer();
      this.m_TooltipsManager.HideTooltips();
      this.m_TooltipsManager.PlayHidingAnimation();
    };
  }

  protected cb func OnTooltipRequest(e: wref<inkWidget>) -> Bool {
    this.m_tooltipProvider = e.GetControllerByType(n"TooltipProvider") as TooltipProvider;
    if IsDefined(this.m_tooltipProvider) && IsDefined(this.m_TooltipsManager) {
      this.m_TooltipsManager.HideTooltips();
      this.m_TooltipsManager.PlayHidingAnimation();
      this.SetShowTooltipsTimer();
    };
  }

  protected cb func OnShowTooltips() -> Bool {
    if IsDefined(this.m_tooltipProvider) && IsDefined(this.m_TooltipsManager) {
      this.m_TooltipsManager.ShowTooltips(this.m_tooltipProvider.GetTooltipsData());
      this.m_TooltipsManager.PlayShowingAnimation();
    };
  }
}
