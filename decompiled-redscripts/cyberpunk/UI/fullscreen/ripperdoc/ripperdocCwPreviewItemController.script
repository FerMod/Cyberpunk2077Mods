
public class RipperdocCwPreviewItemController extends inkLogicController {

  private edit let m_itemIcon: inkWidgetRef;

  private edit let m_addIcon: inkWidgetRef;

  private let m_root: wref<inkWidget>;

  protected cb func OnInitialize() -> Bool {
    this.m_root = this.GetRootWidget();
  }

  public final func Configure() -> Void {
    inkWidgetRef.SetVisible(this.m_itemIcon, false);
    inkWidgetRef.SetVisible(this.m_addIcon, false);
  }

  public final func Configure(isStandard: Bool, isVendor: Bool) -> Void {
    inkWidgetRef.SetVisible(this.m_itemIcon, isStandard);
    inkWidgetRef.SetVisible(this.m_addIcon, !isStandard);
    this.m_root.SetState(isVendor ? n"VendorItem" : n"PlayerItem");
  }
}
