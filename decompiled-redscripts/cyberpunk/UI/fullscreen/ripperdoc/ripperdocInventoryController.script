
public class RipperdocInventoryController extends inkLogicController {

  private edit let m_virtualGridContainer: inkVirtualCompoundRef;

  private edit let m_scrollBarContainer: inkWidgetRef;

  private edit let m_labelPrefix: inkTextRef;

  private edit let m_labelSuffix: inkTextRef;

  private let m_virtualGrid: wref<inkVirtualGridController>;

  private let m_backpackItemsClassifier: ref<RipperdocInventoryTemplateClassifier>;

  private let m_backpackItemsDataSource: ref<ScriptableDataSource>;

  private let m_backpackItemsDataView: ref<ScriptableDataView>;

  private let m_scrollBar: wref<inkScrollController>;

  private let m_root: wref<inkWidget>;

  private let m_opacityAnimation: ref<inkAnimProxy>;

  private let m_labelPulse: ref<PulseAnimation>;

  private let m_cachedPlayerItems: [ref<RipperdocWrappedUIInventoryItem>];

  private let m_cachedVendorItems: [ref<RipperdocWrappedUIInventoryItem>];

  private let m_cachedArea: gamedataEquipmentArea;

  private let m_openArea: gamedataEquipmentArea;

  private let m_cachedAttribute: gamedataStatType;

  private let m_openAttribute: gamedataStatType;

  private let m_hasCache: Bool;

  private let m_isAreaCache: Bool;

  protected cb func OnUninitialize() -> Bool {
    this.ReleaseVirtualGrid();
  }

  public final func Configure(scripting: wref<UIScriptableSystem>) -> Void {
    this.m_root = this.GetRootWidget();
    this.m_root.SetVisible(true);
    this.m_root.SetOpacity(0.00);
    this.m_scrollBar = inkWidgetRef.GetController(this.m_scrollBarContainer) as inkScrollController;
    this.m_labelPulse = new PulseAnimation();
    this.m_labelPulse.Configure(inkWidgetRef.Get(this.m_labelSuffix), 1.00, 0.05, 1.00);
    this.m_openArea = gamedataEquipmentArea.Invalid;
    this.m_openAttribute = gamedataStatType.Invalid;
    this.SetupVirtualGrid();
  }

  protected final func SetupVirtualGrid() -> Void {
    this.m_virtualGrid = inkWidgetRef.GetControllerByType(this.m_virtualGridContainer, n"inkVirtualGridController") as inkVirtualGridController;
    this.m_backpackItemsClassifier = new RipperdocInventoryTemplateClassifier();
    this.m_backpackItemsDataSource = new ScriptableDataSource();
    this.m_backpackItemsDataView = new ScriptableDataView();
    this.m_backpackItemsDataView.SetSource(this.m_backpackItemsDataSource);
    this.m_virtualGrid.SetClassifier(this.m_backpackItemsClassifier);
    this.m_virtualGrid.SetSource(this.m_backpackItemsDataView);
  }

  public final func ReleaseVirtualGrid() -> Void {
    this.m_virtualGrid.SetClassifier(null);
    this.m_virtualGrid.SetSource(null);
    this.m_backpackItemsDataView.SetSource(null);
    this.m_backpackItemsClassifier = null;
    this.m_backpackItemsDataSource = null;
    this.m_backpackItemsDataView = null;
  }

  private final func PopulateInventory() -> Void {
    let count: Float;
    let list: array<ref<IScriptable>>;
    let i: Int32 = 0;
    let limit: Int32 = ArraySize(this.m_cachedPlayerItems);
    while i < limit {
      if count < 20.00 {
        this.m_cachedPlayerItems[i].Delay = count / 30.00;
        count += 1.00;
      };
      ArrayPush(list, this.m_cachedPlayerItems[i]);
      i += 1;
    };
    i = 0;
    limit = ArraySize(this.m_cachedVendorItems);
    while i < limit {
      if count < 20.00 {
        this.m_cachedVendorItems[i].Delay = count / 30.00;
        count += 1.00;
      };
      ArrayPush(list, this.m_cachedVendorItems[i]);
      i += 1;
    };
    this.m_backpackItemsDataSource.Reset(list);
  }

  public final func ShowArea(playerItems: [ref<RipperdocWrappedUIInventoryItem>], vendorItems: [ref<RipperdocWrappedUIInventoryItem>], area: gamedataEquipmentArea) -> Void {
    this.m_cachedPlayerItems = playerItems;
    this.m_cachedVendorItems = vendorItems;
    this.m_cachedArea = area;
    this.m_isAreaCache = true;
    this.OnShow(null);
  }

  protected cb func OnShow(anim: ref<inkAnimProxy>) -> Bool {
    this.AnimateOpacity(false);
    if this.m_isAreaCache {
      if Equals(this.m_cachedArea, gamedataEquipmentArea.Invalid) {
        inkTextRef.SetText(this.m_labelPrefix, "No Filter Applied");
        inkTextRef.SetText(this.m_labelSuffix, "");
        this.m_labelPulse.Stop();
      } else {
        inkTextRef.SetText(this.m_labelPrefix, "Filtering By: ");
        inkTextRef.SetText(this.m_labelSuffix, TweakDBInterface.GetEquipmentAreaRecord(TDBID.Create("EquipmentArea." + EnumValueToString("gamedataEquipmentArea", Cast<Int64>(EnumInt(this.m_cachedArea))))).LocalizedName());
        this.m_labelPulse.Start();
      };
    } else {
      if Equals(this.m_cachedAttribute, gamedataStatType.Invalid) {
        inkTextRef.SetText(this.m_labelPrefix, "No Filter Applied");
        inkTextRef.SetText(this.m_labelSuffix, "");
        this.m_labelPulse.Stop();
      } else {
        inkTextRef.SetText(this.m_labelPrefix, "Filtering By: ");
        inkTextRef.SetText(this.m_labelSuffix, TweakDBInterface.GetStatRecord(TDBID.Create("BaseStats." + EnumValueToString("gamedataStatType", Cast<Int64>(EnumInt(this.m_cachedAttribute) - Equals(this.m_cachedAttribute, gamedataStatType.Armor) ? 0 : 2)))).LocalizedName());
        this.m_labelPulse.Start();
      };
    };
    this.PopulateInventory();
    if this.m_isAreaCache && NotEquals(this.m_openArea, this.m_cachedArea) || !this.m_isAreaCache && NotEquals(this.m_openAttribute, this.m_cachedAttribute) {
      this.m_scrollBar.SetScrollPosition(0.00);
    };
    this.m_scrollBar.SetScrollPosition(0.00);
    this.m_openArea = this.m_cachedArea;
    this.m_openAttribute = this.m_cachedAttribute;
  }

  public final func Hide() -> Void {
    this.AnimateOpacity(true);
  }

  private final func AnimateOpacity(toHidden: Bool) -> Void {
    let barProgress: ref<inkAnimDef>;
    let opacityInterpolator: ref<inkAnimTransparency>;
    let time: Float;
    let animDuration: Float = 0.43;
    if this.m_opacityAnimation != null {
      this.m_opacityAnimation.Stop();
    };
    time = this.m_root.GetOpacity();
    time = toHidden ? time : 1.00 - time * animDuration;
    opacityInterpolator = new inkAnimTransparency();
    opacityInterpolator.SetDuration(time);
    opacityInterpolator.SetStartTransparency(this.m_root.GetOpacity());
    opacityInterpolator.SetEndTransparency(toHidden ? 0.00 : 1.00);
    opacityInterpolator.SetType(inkanimInterpolationType.Quintic);
    opacityInterpolator.SetMode(inkanimInterpolationMode.EasyInOut);
    barProgress = new inkAnimDef();
    barProgress.AddInterpolator(opacityInterpolator);
    this.m_opacityAnimation = this.m_root.PlayAnimation(barProgress);
  }
}

public class RipperdocWrappedUIInventoryItem extends IScriptable {

  public let InventoryItem: wref<UIInventoryItem>;

  public let Delay: Float;

  public let DisplayContext: ref<ItemDisplayContextData>;

  @default(RipperdocWrappedUIInventoryItem, true)
  public let IsEnoughMoney: Bool;

  public let IsNew: Bool;

  public let IsEquippable: Bool;

  public let ItemPrice: Float;

  public let IsBuybackStack: Bool;

  public let AdditionalData: ref<IScriptable>;

  public final static func Make(item: wref<UIInventoryItem>, displayContext: ref<ItemDisplayContextData>, opt additionalData: ref<IScriptable>) -> ref<RipperdocWrappedUIInventoryItem> {
    let instance: ref<RipperdocWrappedUIInventoryItem> = new RipperdocWrappedUIInventoryItem();
    instance.InventoryItem = item;
    instance.DisplayContext = displayContext;
    instance.IsEnoughMoney = true;
    instance.AdditionalData = additionalData;
    return instance;
  }
}

public class RipperdocInventoryItem extends inkVirtualCompoundItemController {

  protected edit let m_root: inkWidgetRef;

  protected let m_data: ref<RipperdocWrappedUIInventoryItem>;

  protected let m_widget: wref<InventoryItemDisplayController>;

  protected cb func OnInitialize() -> Bool {
    this.GetRootWidget().SetVAlign(inkEVerticalAlign.Top);
    this.GetRootWidget().SetHAlign(inkEHorizontalAlign.Left);
    ItemDisplayUtils.SpawnCommonSlotAsync(this, this.m_root, n"itemDisplay", n"OnWidgetSpawned");
    this.RegisterToCallback(n"OnSelected", this, n"OnSelected");
  }

  protected cb func OnWidgetSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
    this.m_widget = widget.GetController() as InventoryItemDisplayController;
    this.SetupData();
  }

  private final func AnimateOpacity() -> Void {
    let barProgress: ref<inkAnimDef>;
    let opacityInterpolator: ref<inkAnimTransparency>;
    let options: inkAnimOptions;
    let animDuration: Float = 0.35;
    if this.m_data.Delay > 0.00 {
      inkWidgetRef.SetOpacity(this.m_root, 0.00);
      opacityInterpolator = new inkAnimTransparency();
      opacityInterpolator.SetDuration(animDuration);
      opacityInterpolator.SetStartTransparency(inkWidgetRef.GetOpacity(this.m_root));
      opacityInterpolator.SetEndTransparency(1.00);
      opacityInterpolator.SetType(inkanimInterpolationType.Quintic);
      opacityInterpolator.SetMode(inkanimInterpolationMode.EasyInOut);
      barProgress = new inkAnimDef();
      barProgress.AddInterpolator(opacityInterpolator);
      options.executionDelay = this.m_data.Delay;
      inkWidgetRef.PlayAnimationWithOptions(this.m_root, barProgress, options);
      this.m_data.Delay = 0.00;
    };
  }

  protected cb func OnDataChanged(value: Variant) -> Bool {
    this.m_data = FromVariant<ref<IScriptable>>(value) as RipperdocWrappedUIInventoryItem;
    this.SetupData();
  }

  private final func SetupData() -> Void {
    if !IsDefined(this.m_data) || !IsDefined(this.m_widget) {
      return;
    };
    this.m_widget.Setup(this.m_data.InventoryItem, this.m_data.DisplayContext, this.m_data.IsEnoughMoney, !this.m_data.DisplayContext.IsVendorItem());
    this.m_widget.SetBuybackStack(this.m_data.IsBuybackStack);
    this.m_widget.SetIsNewOverride(this.m_data.IsNew);
    this.m_widget.SetAdditionalData(this.m_data.AdditionalData);
    this.AnimateOpacity();
  }

  public final func Update() -> Void {
    if IsDefined(this.m_data) {
      this.m_widget.Setup(this.m_data.InventoryItem, this.m_data.DisplayContext, this.m_data.IsEnoughMoney, !this.m_data.DisplayContext.IsVendorItem());
      this.m_widget.SetBuybackStack(this.m_data.IsBuybackStack);
      this.m_widget.SetIsNewOverride(this.m_data.IsNew);
      this.m_widget.SetAdditionalData(this.m_data.AdditionalData);
      this.AnimateOpacity();
    };
  }
}

public class RipperdocInventoryTemplateClassifier extends inkVirtualItemTemplateClassifier {

  public func ClassifyItem(data: Variant) -> Uint32 {
    return 0u;
  }
}
