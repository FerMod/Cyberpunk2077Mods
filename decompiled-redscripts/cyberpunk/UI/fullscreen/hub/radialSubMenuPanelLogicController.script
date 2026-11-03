
public class RadialSubMenuPanelLogicController extends PlayerStatsUIHolder {

  private edit let m_levelValue: inkTextRef;

  private edit let m_streetCredLabel: inkTextRef;

  private edit let m_currencyValue: inkTextRef;

  private edit let m_weightValue: inkTextRef;

  private edit let m_subMenuLabel: inkTextRef;

  private edit let m_centralLine: inkWidgetRef;

  private edit let m_levelBarProgress: inkWidgetRef;

  private edit let m_levelBarSpacer: inkWidgetRef;

  private edit let m_streetCredBarProgress: inkWidgetRef;

  private edit let m_streetCredBarSpacer: inkWidgetRef;

  private edit let m_menuselectorWidget: inkWidgetRef;

  private edit let m_subMenuselectorWidget: inkWidgetRef;

  private edit let m_topPanel: inkWidgetRef;

  private edit let m_leftHolder: inkWidgetRef;

  private edit let m_rightHolder: inkWidgetRef;

  private edit let m_lineBarsContainer: inkCompoundRef;

  private edit let m_lineWidget: inkCompoundRef;

  private let m_menusList: [MenuData];

  private let m_menuSelectorCtrl: wref<hubRadialStaticSelectorController>;

  private let m_subMenuActive: Bool;

  private let m_previousLineBar: wref<inkWidget>;

  private let m_IsSetActive: Bool;

  private let m_selectorMode: Bool;

  private let m_menusData: ref<MenuDataBuilder>;

  private let m_curMenuData: MenuData;

  private let m_curSubMenuData: MenuData;

  public let m_hubMenuInstanceID: Uint32;

  protected cb func OnInitialize() -> Bool {
    this.m_menuSelectorCtrl = inkWidgetRef.GetController(this.m_menuselectorWidget) as hubRadialStaticSelectorController;
    this.HideName(false);
    this.SetActive(false);
    inkCompoundRef.RemoveAllChildren(this.m_lineBarsContainer);
    inkWidgetRef.SetVisible(this.m_centralLine, true);
  }

  protected cb func OnUninitialize() -> Bool {
    this.SetActive(false);
  }

  protected cb func OnOpenMenuRequest(evt: ref<OpenMenuRequest>) -> Bool {
    let subData: MenuData;
    if evt.m_hubMenuInstanceID > 0u && evt.m_hubMenuInstanceID != this.m_hubMenuInstanceID {
      return false;
    };
    if NotEquals(evt.m_menuName, n"None") {
      this.m_curMenuData = this.m_menusData.GetData(evt.m_menuName);
    } else {
      this.m_curMenuData = evt.m_eventData;
    };
    inkWidgetRef.SetVisible(this.m_centralLine, false);
    inkWidgetRef.SetVisible(this.m_subMenuLabel, true);
    subData = this.m_curMenuData;
    this.m_curMenuData = this.m_menusData.GetData(this.m_curMenuData.parentIdentifier);
    if subData.identifier != this.m_curSubMenuData.identifier {
      if subData.identifier == -1 {
        inkWidgetRef.SetVisible(this.m_centralLine, true);
        inkWidgetRef.SetVisible(this.m_subMenuLabel, false);
      } else {
        inkTextRef.SetText(this.m_subMenuLabel, subData.label);
        inkWidgetRef.SetVisible(this.m_centralLine, false);
        inkWidgetRef.SetVisible(this.m_subMenuLabel, true);
      };
      this.m_curSubMenuData = subData;
    };
    if !evt.m_internal {
      this.m_menuSelectorCtrl.ScrollTo(this.m_curMenuData);
    };
    this.HideName(false);
  }

  public final func SetHubMenuInstanceID(ID: Uint32) -> Void {
    this.m_hubMenuInstanceID = ID;
  }

  public final func SetMenusData(menuData: ref<MenuDataBuilder>) -> Void {
    this.m_menusData = menuData;
  }

  public final func GetActive() -> Bool {
    return this.m_IsSetActive;
  }

  public final func HideName(val: Bool) -> Void {
    this.m_selectorMode = !val;
    inkWidgetRef.SetVisible(this.m_menuselectorWidget, !val);
    inkWidgetRef.SetVisible(this.m_lineWidget, !val);
    inkWidgetRef.SetVisible(this.m_lineBarsContainer, !val);
  }

  public final func SetRepacerMode() -> Void {
    inkWidgetRef.SetVisible(this.m_leftHolder, false);
    inkWidgetRef.SetVisible(this.m_rightHolder, false);
  }

  public final func SetActive(isActive: Bool, opt hideSubmenu: Bool) -> Void {
    this.m_IsSetActive = isActive;
    inkWidgetRef.SetVisible(this.m_topPanel, isActive);
    inkWidgetRef.SetVisible(this.m_subMenuselectorWidget, !hideSubmenu);
    this.m_subMenuActive = !hideSubmenu;
    if isActive {
      this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnButtonRelease");
      this.RegisterToGlobalInputCallback(n"OnPostOnAxis", this, n"OnButtonRelease");
      this.m_menuSelectorCtrl.RegisterToCallback(n"OnSelectionChanged", this, n"OnMenuChanged");
    } else {
      this.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"OnButtonRelease");
      this.UnregisterFromGlobalInputCallback(n"OnPostOnAxis", this, n"OnButtonRelease");
      this.m_menuSelectorCtrl.UnregisterFromCallback(n"OnSelectionChanged", this, n"OnMenuChanged");
    };
  }

  protected cb func OnButtonRelease(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsHandled() {
      return false;
    };
    if evt.IsAction(n"prior_menu") && this.m_selectorMode {
      this.PlaySound(n"TabButton", n"OnPress");
      this.m_menuSelectorCtrl.Prior();
      evt.Handle();
    } else {
      if evt.IsAction(n"next_menu") && this.m_selectorMode {
        this.PlaySound(n"TabButton", n"OnPress");
        this.m_menuSelectorCtrl.Next();
        evt.Handle();
      } else {
        return false;
      };
    };
  }

  protected cb func OnMenuChanged(index: Int32, value: String) -> Bool {
    if ArraySize(this.m_menusList) <= 0 {
      return false;
    };
    this.HideName(false);
  }

  public final func OpenModsTabExternal(request: ref<CyberwareTabModsRequest>) -> Void {
    let evt: ref<OpenMenuRequest> = new OpenMenuRequest();
    evt.m_eventData = this.m_menusData.GetData(3);
    evt.m_eventData.userData = request.wrapper;
    evt.m_eventData.m_overrideDefaultUserData = true;
    evt.m_isMainMenu = false;
    evt.m_jumpBack = true;
    this.QueueEvent(evt);
  }

  public final func AddMenus(const selectedMenu: script_ref<MenuData>, const menuDataArray: script_ref<[MenuData]>, opt subMenuData: MenuData, opt forceRefreshLines: Bool) -> Void {
    let i: Int32;
    if ArraySize(Deref(menuDataArray)) <= 0 {
      return;
    };
    ArrayClear(this.m_menusList);
    i = 0;
    while i < ArraySize(Deref(menuDataArray)) {
      if !Deref(menuDataArray)[i].disabled {
        ArrayPush(this.m_menusList, Deref(menuDataArray)[i]);
      };
      i += 1;
    };
    this.m_menuSelectorCtrl.SetupMenu(this.m_menusList, Deref(selectedMenu).identifier);
  }

  public final func HandleCharacterLevelUpdated(value: Int32) -> Void {
    inkTextRef.SetText(this.m_levelValue, ToString(value));
  }

  public final func HandleCharacterLevelCurrentXPUpdated(value: Int32, remainingXP: Int32) -> Void {
    let percentageValue: Float = Cast<Float>(value) / Cast<Float>(remainingXP + value);
    inkWidgetRef.SetSizeCoefficient(this.m_levelBarProgress, percentageValue);
    inkWidgetRef.SetSizeCoefficient(this.m_levelBarSpacer, 1.00 - percentageValue);
  }

  public final func HandleCharacterStreetCredLevelUpdated(value: Int32) -> Void {
    inkTextRef.SetText(this.m_streetCredLabel, ToString(value));
  }

  public final func HandleCharacterStreetCredPointsUpdated(value: Int32, remainingXP: Int32) -> Void {
    let percentageValue: Float = Cast<Float>(value) / Cast<Float>(remainingXP + value);
    inkWidgetRef.SetSizeCoefficient(this.m_streetCredBarProgress, percentageValue);
    inkWidgetRef.SetSizeCoefficient(this.m_streetCredBarSpacer, 1.00 - percentageValue);
  }

  public final func HandlePlayerMaxWeightUpdated(value: Int32, curInventoryWeight: Float) -> Void {
    inkTextRef.SetText(this.m_weightValue, ToString(Cast<Int32>(curInventoryWeight)) + "/" + ToString(value));
  }

  public final func HandlePlayerWeightUpdated(value: Float, maxWeight: Int32) -> Void {
    inkTextRef.SetText(this.m_weightValue, ToString(Cast<Int32>(value)) + "/" + ToString(maxWeight));
  }

  public func HandleCharacterCurrencyUpdated(value: Int32) -> Void {
    inkTextRef.SetText(this.m_currencyValue, ToString(value));
  }
}
