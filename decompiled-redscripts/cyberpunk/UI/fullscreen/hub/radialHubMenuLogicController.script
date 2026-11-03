
public class RadialMenuHubLogicController extends inkLogicController {

  private edit let m_menuObject: inkWidgetRef;

  private edit let m_btnCrafting: inkWidgetRef;

  private edit let m_btnPerks: inkWidgetRef;

  private edit let m_btnStats: inkWidgetRef;

  private edit let m_btnInventory: inkWidgetRef;

  private edit let m_btnBackpack: inkWidgetRef;

  private edit let m_btnCyberware: inkWidgetRef;

  private edit let m_btnMap: inkWidgetRef;

  private edit let m_btnJournal: inkWidgetRef;

  private edit let m_btnPhone: inkWidgetRef;

  private edit let m_btnTarot: inkWidgetRef;

  private edit let m_btnShard: inkWidgetRef;

  private edit let m_btnCodex: inkWidgetRef;

  private edit let m_panelInventory: inkWidgetRef;

  private edit let m_panelMap: inkWidgetRef;

  private edit let m_panelJournal: inkWidgetRef;

  private edit let m_panelCharacter: inkWidgetRef;

  private edit let m_mouseCollider: inkWidgetRef;

  private edit let m_debugText: inkTextRef;

  private let m_menusData: ref<MenuDataBuilder>;

  private let m_tooltipsManager: wref<gameuiTooltipsManager>;

  private edit let m_tooltipsManagerRef: inkWidgetRef;

  private let m_windowSize: Vector2;

  private let m_previousMenuElement: RadialHubMenuElement;

  private let m_hoveredButtons: [Int32];

  private let m_isActive: Bool;

  private let m_timeSkipOpened: Bool;

  private let m_panelHoverOverAnimProxy: ref<inkAnimProxy>;

  private let m_panelHoverOutAnimProxy: ref<inkAnimProxy>;

  protected cb func OnInitialize() -> Bool {
    this.m_tooltipsManager = inkWidgetRef.GetControllerByType(this.m_tooltipsManagerRef, n"gameuiTooltipsManager") as gameuiTooltipsManager;
    this.m_tooltipsManager.Setup(ETooltipsStyle.Menus);
    this.SetHoverPanel(this.m_panelInventory);
    this.SetHoverPanel(this.m_panelJournal);
    this.SetHoverPanel(this.m_panelCharacter);
    this.SetHoverPanel(this.m_panelMap);
    this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnGlobalRelease");
    this.SetActive(true);
  }

  protected cb func OnGlobalRelease(e: ref<inkPointerEvent>) -> Bool {
    if e.IsAction(n"click") && !this.m_timeSkipOpened && this.m_isActive && ArraySize(this.m_hoveredButtons) == 0 {
      this.OpenElement(this.m_previousMenuElement);
    };
  }

  public final func SetWindowSize(size: Vector2) -> Void {
    this.m_windowSize = size;
  }

  public final func SetTimeSkipOpened(value: Bool) -> Void {
    this.m_timeSkipOpened = value;
  }

  public final func SetButtonHoverOver(buttonId: Int32) -> Void {
    ArrayPush(this.m_hoveredButtons, buttonId);
  }

  public final func SetButtonHoverOut(buttonId: Int32) -> Void {
    ArrayRemove(this.m_hoveredButtons, buttonId);
  }

  public final func SetUnhover() -> Void {
    this.SetElementState(this.m_previousMenuElement, n"Default");
    this.PlayHoverAnimation(this.m_panelHoverOutAnimProxy, this.m_previousMenuElement, true);
    this.m_previousMenuElement = RadialHubMenuElement.None;
  }

  public final func SetHover(currentMenuElement: RadialHubMenuElement) -> Void {
    if this.m_timeSkipOpened {
      return;
    };
    if NotEquals(this.m_previousMenuElement, currentMenuElement) {
      this.SetElementState(this.m_previousMenuElement, n"Default");
      this.SetElementState(currentMenuElement, n"CellHover");
      this.PlayHoverAnimation(this.m_panelHoverOutAnimProxy, this.m_previousMenuElement, true);
      this.PlayHoverAnimation(this.m_panelHoverOverAnimProxy, currentMenuElement);
      this.m_previousMenuElement = currentMenuElement;
    };
  }

  private final func PlayHoverAnimation(animProxy: ref<inkAnimProxy>, menuTarget: RadialHubMenuElement, opt playReverse: Bool) -> Void {
    let playbackOptions: inkAnimOptions;
    if IsDefined(animProxy) {
      animProxy.Stop();
      animProxy = null;
    };
    playbackOptions.playReversed = playReverse;
    if Equals(menuTarget, RadialHubMenuElement.Inventory) {
      animProxy = this.PlayLibraryAnimation(n"inventory_hover", playbackOptions);
    } else {
      if Equals(menuTarget, RadialHubMenuElement.Map) {
        animProxy = this.PlayLibraryAnimation(n"map_hover", playbackOptions);
      } else {
        if Equals(menuTarget, RadialHubMenuElement.Character) {
          animProxy = this.PlayLibraryAnimation(n"character_hover", playbackOptions);
        } else {
          if Equals(menuTarget, RadialHubMenuElement.Journal) {
            animProxy = this.PlayLibraryAnimation(n"journal_hover", playbackOptions);
          };
        };
      };
    };
  }

  public final func OpenElement(hubMenuElement: RadialHubMenuElement) -> Void {
    let widget: inkWidgetRef;
    if NotEquals(hubMenuElement, RadialHubMenuElement.None) {
      widget = this.RadialHubMenuElementToWidget(hubMenuElement);
      (inkWidgetRef.GetController(widget) as RadialMenuItemController).RequestMenuSelect();
    };
  }

  private final func SetElementState(hubMenuElement: RadialHubMenuElement, state: CName) -> Void {
    let widget: inkWidgetRef;
    if NotEquals(hubMenuElement, RadialHubMenuElement.None) {
      widget = this.RadialHubMenuElementToWidget(hubMenuElement);
      inkWidgetRef.SetState(widget, state);
    };
  }

  private final func GetRadialHubMenuElementFromAngle(angle: Float) -> RadialHubMenuElement {
    if angle < 45.00 || angle >= 315.00 {
      return RadialHubMenuElement.Journal;
    };
    if angle >= 45.00 && angle < 135.00 {
      return RadialHubMenuElement.Character;
    };
    if angle >= 135.00 && angle < 225.00 {
      return RadialHubMenuElement.Inventory;
    };
    return RadialHubMenuElement.Map;
  }

  private final func RadialHubMenuElementToWidget(hubMenuElement: RadialHubMenuElement) -> inkWidgetRef {
    if Equals(hubMenuElement, RadialHubMenuElement.Journal) {
      return this.m_panelJournal;
    };
    if Equals(hubMenuElement, RadialHubMenuElement.Map) {
      return this.m_panelMap;
    };
    if Equals(hubMenuElement, RadialHubMenuElement.Inventory) {
      return this.m_panelInventory;
    };
    return this.m_panelCharacter;
  }

  private final func WidgetToRadialHubElement(hubMenuElement: wref<inkWidget>) -> RadialHubMenuElement {
    if hubMenuElement == inkWidgetRef.Get(this.m_panelJournal) {
      return RadialHubMenuElement.Journal;
    };
    if hubMenuElement == inkWidgetRef.Get(this.m_panelMap) {
      return RadialHubMenuElement.Map;
    };
    if hubMenuElement == inkWidgetRef.Get(this.m_panelInventory) {
      return RadialHubMenuElement.Inventory;
    };
    if hubMenuElement == inkWidgetRef.Get(this.m_panelCharacter) {
      return RadialHubMenuElement.Character;
    };
    return RadialHubMenuElement.None;
  }

  public final func SetHoverPanel(hoverPanel: inkWidgetRef) -> Void {
    if inkWidgetRef.IsValid(hoverPanel) {
      inkWidgetRef.RegisterToCallback(hoverPanel, n"OnEnter", this, n"OnHoverPanelOver");
      inkWidgetRef.RegisterToCallback(hoverPanel, n"OnLeave", this, n"OnHoverPanelOut");
    };
  }

  protected cb func OnHoverPanelOver(evt: ref<inkPointerEvent>) -> Bool {
    this.SetHover(this.WidgetToRadialHubElement(evt.GetCurrentTarget()));
  }

  protected cb func OnHoverPanelOut(evt: ref<inkPointerEvent>) -> Bool {
    this.SetUnhover();
  }

  protected cb func OnUninitialize() -> Bool {
    this.SetActive(false);
  }

  protected cb func OnOldSelectByCursor(evt: ref<SelectMenuRequest>) -> Bool {
    let openMenuEvt: ref<OpenMenuRequest>;
    let currentMenuItem: ref<MenuItemController> = evt.m_eventData;
    if IsDefined(currentMenuItem) {
      openMenuEvt = new OpenMenuRequest();
      openMenuEvt.m_eventData = currentMenuItem.m_menuData;
      openMenuEvt.m_isMainMenu = true;
      openMenuEvt.m_jumpBack = currentMenuItem.IsHyperlink();
      this.QueueEvent(openMenuEvt);
    };
  }

  protected cb func OnSelectByCursor(evt: ref<RadialSelectMenuRequest>) -> Bool {
    let openMenuEvt: ref<OpenMenuRequest>;
    let currentMenuItem: ref<RadialMenuItemController> = evt.m_eventData;
    if IsDefined(currentMenuItem) {
      openMenuEvt = new OpenMenuRequest();
      openMenuEvt.m_eventData = currentMenuItem.m_menuData;
      openMenuEvt.m_isMainMenu = true;
      openMenuEvt.m_jumpBack = currentMenuItem.IsHyperlink();
      this.QueueEvent(openMenuEvt);
    };
  }

  public final func SetMenusData(menuData: ref<MenuDataBuilder>, tarotIsBlocked: Bool, mapIsBlocked: Bool, perkPoints: Int32, attrPoints: Int32) -> Void {
    let dataCharacter: MenuData;
    let dataMap: MenuData;
    let dataTarot: MenuData;
    this.m_menusData = menuData;
    HubMenuUtils.SetRadialMenuData(this.m_btnCrafting, this.m_menusData.GetData(1));
    dataCharacter = this.m_menusData.GetData(2);
    dataCharacter.attrFlag = attrPoints > 0;
    dataCharacter.perkFlag = perkPoints > 0;
    dataCharacter.attrText = attrPoints;
    dataCharacter.perkText = perkPoints;
    dataTarot = this.m_menusData.GetData(14);
    if tarotIsBlocked {
      dataTarot.disabled = true;
    };
    dataMap = this.m_menusData.GetData(4);
    if mapIsBlocked {
      dataMap.disabled = true;
    };
    HubMenuUtils.SetRadialMenuData(this.m_panelInventory, this.m_menusData.GetData(3));
    HubMenuUtils.SetRadialMenuData(this.m_panelMap, dataMap);
    HubMenuUtils.SetRadialMenuData(this.m_panelJournal, this.m_menusData.GetData(5));
    HubMenuUtils.SetRadialMenuData(this.m_panelCharacter, dataCharacter);
    HubMenuUtils.SetRadialMenuData(this.m_btnPerks, dataCharacter);
    HubMenuUtils.SetRadialMenuData(this.m_btnStats, this.m_menusData.GetData(8));
    HubMenuUtils.SetRadialMenuData(this.m_btnInventory, this.m_menusData.GetData(3));
    HubMenuUtils.SetRadialMenuData(this.m_btnBackpack, this.m_menusData.GetData(9));
    HubMenuUtils.SetRadialMenuData(this.m_btnCyberware, this.m_menusData.GetData(16));
    HubMenuUtils.SetRadialMenuData(this.m_btnMap, this.m_menusData.GetData(4));
    HubMenuUtils.SetRadialMenuData(this.m_btnJournal, this.m_menusData.GetData(5));
    HubMenuUtils.SetRadialMenuData(this.m_btnPhone, this.m_menusData.GetData(6));
    HubMenuUtils.SetRadialMenuData(this.m_btnTarot, dataTarot);
    HubMenuUtils.SetRadialMenuData(this.m_btnCodex, this.m_menusData.GetData(11));
    HubMenuUtils.SetRadialMenuData(this.m_btnShard, this.m_menusData.GetData(12));
  }

  public final func SetActive(isActive: Bool) -> Void {
    this.m_isActive = isActive;
    inkWidgetRef.SetVisible(this.m_menuObject, isActive);
    if isActive {
      this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnSelectByButton");
    } else {
      this.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"OnSelectByButton");
    };
  }

  public final func SelectMenuExternally(menuName: CName, opt submenuName: CName, opt userData: ref<IScriptable>) -> Void {
    let evtMenuData: MenuData;
    let subMenuData: array<MenuData>;
    let evt: ref<OpenMenuRequest> = new OpenMenuRequest();
    evt.m_menuName = menuName;
    if IsDefined(userData) {
      evt.m_eventData.userData = userData;
      evt.m_eventData.m_overrideDefaultUserData = true;
      if IsNameValid(submenuName) {
        evtMenuData.userData = userData;
        ArrayPush(subMenuData, evtMenuData);
        evt.m_eventData.subMenus = subMenuData;
        evt.m_eventData.m_overrideSubMenuUserData = true;
      };
    };
    evt.m_submenuName = submenuName;
    evt.m_isMainMenu = true;
    this.QueueEvent(evt);
  }
}
