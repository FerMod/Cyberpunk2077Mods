
public class ImageActionButtonLogicController extends DeviceActionWidgetControllerBase {

  @runtimeProperty("category", "Widget Refs")
  private edit let m_tallImageWidget: inkImageRef;

  protected let m_price: Int32;

  public func Initialize(gameController: ref<DeviceInkGameControllerBase>, const widgetData: script_ref<SActionWidgetPackage>) -> Void {
    let action: ref<DispenceItemFromVendor>;
    super.Initialize(gameController, widgetData);
    action = Deref(widgetData).action as DispenceItemFromVendor;
    if IsDefined(action) {
      inkImageRef.SetTexturePart(this.m_tallImageWidget, action.GetAtlasTexture());
      this.m_price = action.GetPrice();
    };
  }

  public final func GetPrice() -> Int32 {
    return this.m_price;
  }
}
