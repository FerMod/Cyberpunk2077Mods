
public class CrafringMaterialItemController extends BaseButtonView {

  protected edit let m_nameText: inkTextRef;

  protected edit let m_quantityText: inkTextRef;

  protected edit let m_quantityChangeText: inkTextRef;

  protected edit let m_icon: inkImageRef;

  protected edit let m_frame: inkWidgetRef;

  protected edit let m_tooltipAnchor: inkWidgetRef;

  protected edit let m_data: ref<CachedCraftingMaterial>;

  private let m_quantity: Int32;

  private let m_hovered: Bool;

  private let m_lastState: CrafringMaterialItemHighlight;

  private let m_shouldBeHighlighted: Bool;

  private let m_useSimpleFromat: Bool;

  private let m_hideIfZero: Bool;

  private let m_isCollapsed: Bool;

  protected cb func OnInitialize() -> Bool {
    super.OnInitialize();
    if IsDefined(this.m_ButtonController) {
      this.m_ButtonController.RegisterToCallback(n"OnButtonClick", this, n"OnButtonClick");
    };
    this.RegisterToCallback(n"OnHoverOver", this, n"OnCraftingMaterialHoverOver");
    this.RegisterToCallback(n"OnHoverOut", this, n"OnCraftingMaterialHoverOut");
  }

  protected cb func OnCraftingMaterialHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    this.m_hovered = true;
    this.SetHighlighted();
  }

  protected cb func OnCraftingMaterialHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    this.m_hovered = false;
    this.SetHighlighted();
  }

  public final func Setup(craftingMaterial: ref<CachedCraftingMaterial>) -> Void {
    this.m_data = craftingMaterial;
    this.RefreshUI();
    this.SetHighlighted(CrafringMaterialItemHighlight.None);
  }

  public final func SetQuantity(quantity: Int32) -> Void {
    inkTextRef.SetText(this.m_quantityText, quantity <= 999 ? IntToString(quantity) : "999+");
    this.m_quantity = quantity;
  }

  public final func RefreshUI() -> Void {
    inkTextRef.SetText(this.m_nameText, this.m_data.m_displayName);
    inkTextRef.SetText(this.m_quantityText, this.m_data.m_quantity <= 999 ? IntToString(this.m_data.m_quantity) : "999+");
    this.m_quantity = this.m_data.m_quantity;
    InkImageUtils.RequestSetImage(this, this.m_icon, this.m_data.m_iconPath);
    if this.m_data.m_quantity <= 0 {
      this.GetRootWidget().SetState(n"Empty");
    };
  }

  public final func SetHighlighted(type: CrafringMaterialItemHighlight, opt quantityChanged: Int32, opt canAfford: Bool) -> Void {
    this.m_lastState = type;
    this.SetHighlighted(quantityChanged);
    if !canAfford {
      this.GetRootWidget().SetState(n"Empty");
    };
  }

  public final func SetHighlighted(opt quantityChanged: Int32) -> Void {
    inkWidgetRef.SetVisible(this.m_frame, NotEquals(this.m_lastState, CrafringMaterialItemHighlight.None));
    this.m_shouldBeHighlighted = quantityChanged != 0;
    inkWidgetRef.SetVisible(this.m_quantityChangeText, this.m_shouldBeHighlighted);
    if quantityChanged == 0 {
      this.GetRootWidget().SetState(n"Default");
    } else {
      this.GetRootWidget().SetState(n"Hover");
    };
    if this.m_useSimpleFromat {
      inkTextRef.SetText(this.m_quantityChangeText, IntToString(quantityChanged));
    } else {
      if Equals(this.m_lastState, CrafringMaterialItemHighlight.Add) {
        inkTextRef.SetText(this.m_quantityChangeText, "(+" + IntToString(quantityChanged) + ")");
      } else {
        inkTextRef.SetText(this.m_quantityChangeText, "(-" + IntToString(quantityChanged) + ")");
      };
    };
  }

  public final func GetCachedCraftingMaterial() -> wref<CachedCraftingMaterial> {
    return this.m_data;
  }

  public final func GetItemID() -> ItemID {
    return this.m_data.m_itemID;
  }

  public final func GetQuantity() -> Int32 {
    return this.m_quantity;
  }

  public final func GetMateialDisplayName() -> String {
    return this.m_data.m_displayName;
  }

  protected cb func OnCraftingMaterialAnimationCompleted(anim: ref<inkAnimProxy>) -> Bool {
    if this.m_shouldBeHighlighted {
      this.GetRootWidget().SetState(n"Default");
      this.GetRootWidget().SetState(n"Hover");
    } else {
      this.GetRootWidget().SetState(n"Hover");
      this.GetRootWidget().SetState(n"Default");
    };
    if this.m_hideIfZero {
      this.GetRootWidget().SetOpacity(0.00);
    };
  }

  public final func PlayAnimation(opt hideIfZero: Bool) -> Void {
    let proxy: ref<inkAnimProxy> = this.PlayLibraryAnimationOnAutoSelectedTargets(n"craftingMaterial_animation", this.GetRootWidget());
    proxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnCraftingMaterialAnimationCompleted");
    this.m_hideIfZero = hideIfZero;
  }

  public final func SetUseSimpleFromat(useSimpleFromat: Bool) -> Void {
    this.m_useSimpleFromat = useSimpleFromat;
  }

  public final func Collapse(collapse: Bool) -> Void {
    let animOptions: inkAnimOptions;
    if collapse && !this.m_isCollapsed {
      this.PlayLibraryAnimationOnAutoSelectedTargets(n"craftingMaterial_collapse", this.GetRootWidget());
      this.m_isCollapsed = true;
    } else {
      if !collapse && this.m_isCollapsed {
        animOptions.playReversed = true;
        this.PlayLibraryAnimationOnAutoSelectedTargets(n"craftingMaterial_collapse", this.GetRootWidget(), animOptions);
        this.m_isCollapsed = false;
      };
    };
  }

  public final func GetTooltipAnchorWidget() -> wref<inkWidget> {
    return inkWidgetRef.Get(this.m_tooltipAnchor);
  }
}
