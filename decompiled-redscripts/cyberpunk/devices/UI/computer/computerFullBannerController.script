
public class ComputerFullBannerWidgetController extends ComputerBannerWidgetController {

  @runtimeProperty("category", "Widget Refs")
  protected edit let m_closeButtonWidget: inkWidgetRef;

  public func Initialize(gameController: ref<ComputerInkGameController>, const widgetData: script_ref<SBannerWidgetPackage>) -> Void {
    inkTextRef.SetText(this.m_titleWidget, Deref(widgetData).title);
    inkTextRef.SetText(this.m_textContentWidget, Deref(widgetData).description);
    this.ResolveContent(Deref(widgetData).content);
    this.RegisterCloseButtonCallback(gameController);
    this.m_isInitialized = true;
  }

  protected final func RegisterCloseButtonCallback(gameController: ref<DeviceInkGameControllerBase>) -> Void {
    let controller: ref<DeviceButtonLogicControllerBase>;
    if !this.m_isInitialized {
      if IsDefined(inkWidgetRef.Get(this.m_closeButtonWidget)) {
        inkWidgetRef.RegisterToCallback(this.m_closeButtonWidget, n"OnRelease", gameController, n"OnHideFullBannerCallback");
        controller = inkWidgetRef.GetController(this.m_closeButtonWidget) as DeviceButtonLogicControllerBase;
        if IsDefined(controller) {
          controller.RegisterAudioCallbacks(gameController);
        };
      };
    };
  }
}
