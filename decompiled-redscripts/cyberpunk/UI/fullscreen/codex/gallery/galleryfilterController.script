
public class GalleryFilterController extends inkLogicController {

  protected edit let m_icon: inkImageRef;

  protected edit let m_text: inkTextRef;

  protected edit let m_filterRootWidget: inkWidgetRef;

  private let m_filterType: inkGameScreenshotSortMode;

  private let m_labelKey: CName;

  private let m_tooltipsManager: wref<gameuiTooltipsManager>;

  private let m_active: Bool;

  private let m_hovered: Bool;

  protected cb func OnInitialize() -> Bool {
    this.RegisterToCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.RegisterToCallback(n"OnHoverOut", this, n"OnHoverOut");
  }

  protected cb func OnUninitialize() -> Bool {
    this.UnregisterFromCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.UnregisterFromCallback(n"OnHoverOut", this, n"OnHoverOut");
  }

  protected cb func OnHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    let tooltipData: ref<MessageTooltipData> = new MessageTooltipData();
    tooltipData.Title = GetLocalizedTextByKey(this.m_labelKey);
    this.m_tooltipsManager.ShowTooltipAtWidget(0, evt.GetTarget(), tooltipData, gameuiETooltipPlacement.RightTop, true);
    this.m_hovered = true;
    if !this.m_active {
      this.GetRootWidget().SetState(n"Hover");
    };
  }

  protected cb func OnHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    this.m_hovered = false;
    if !this.m_active {
      this.GetRootWidget().SetState(n"Default");
      this.m_tooltipsManager.HideTooltips();
    };
  }

  public final func Setup(filterType: inkGameScreenshotSortMode, iconName: CName, labelKey: CName, tooltipsManager: wref<gameuiTooltipsManager>) -> Void {
    this.m_filterType = filterType;
    inkImageRef.SetTexturePart(this.m_icon, iconName);
    this.m_labelKey = labelKey;
    this.m_tooltipsManager = tooltipsManager;
  }

  public final func GetFilterType() -> inkGameScreenshotSortMode {
    return this.m_filterType;
  }

  public final func SetFilterType(filterType: inkGameScreenshotSortMode) -> Void {
    this.m_filterType = filterType;
  }

  public final func SetActive(value: Bool) -> Void {
    this.m_active = value;
    this.GetRootWidget().SetState(value ? n"Active" : n"Default");
    this.m_tooltipsManager.HideTooltips();
    if !value && this.m_hovered {
      this.GetRootWidget().SetState(n"Hover");
    };
  }

  public final func IsActive() -> Bool {
    return this.m_active;
  }
}
