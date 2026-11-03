
public class FrameInkGameController extends inkGameController {

  @runtimeProperty("category", "Frame")
  protected edit let m_screenshotWidget: inkImageRef;

  protected edit let m_defaultScreenshotWidget: inkImageRef;

  protected cb func OnInitialize() -> Bool {
    let frame: ref<Frame> = this.GetOwnerEntity() as Frame;
    let e: ref<FrameInitialisation> = new FrameInitialisation();
    if frame != null {
      e.widget = this.GetScreenWidget();
      if e.widget != null {
        frame.QueueEvent(e);
      };
    };
  }

  public final const func GetScreenWidget() -> wref<inkImage> {
    return inkWidgetRef.Get(this.m_screenshotWidget) as inkImage;
  }

  public final const func GetDefaultScreenWidget() -> wref<inkImage> {
    return inkWidgetRef.Get(this.m_defaultScreenshotWidget) as inkImage;
  }

  public final func SetDefaultScreenshot(value: Bool) -> Void {
    inkWidgetRef.SetVisible(this.m_screenshotWidget, !value);
    inkWidgetRef.SetVisible(this.m_defaultScreenshotWidget, value);
  }
}
