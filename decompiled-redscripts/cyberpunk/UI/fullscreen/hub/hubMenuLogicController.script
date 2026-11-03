
public class MenuHubLogicController extends inkLogicController {

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

  private edit let m_btnGallery: inkWidgetRef;

  private edit let m_btnCodex: inkWidgetRef;

  private edit let m_panelInventory: inkWidgetRef;

  private edit let m_panelJournal: inkWidgetRef;

  private edit let m_panelCharacter: inkWidgetRef;

  private let m_menusData: ref<MenuDataBuilder>;

  private let m_tooltipsManager: wref<gameuiTooltipsManager>;

  private edit let m_tooltipsManagerRef: inkWidgetRef;

  protected cb func OnInitialize() -> Bool {
    this.m_tooltipsManager = inkWidgetRef.GetControllerByType(this.m_tooltipsManagerRef, n"gameuiTooltipsManager") as gameuiTooltipsManager;
    this.m_tooltipsManager.Setup(ETooltipsStyle.Menus);
    (inkWidgetRef.GetController(this.m_btnInventory) as MenuItemController).SetHoverPanel(this.m_panelInventory);
    (inkWidgetRef.GetController(this.m_btnJournal) as MenuItemController).SetHoverPanel(this.m_panelJournal);
    (inkWidgetRef.GetController(this.m_btnPerks) as MenuItemController).SetHoverPanel(this.m_panelCharacter);
    this.SetActive(true);
  }

  protected cb func OnUninitialize() -> Bool {
    this.SetActive(false);
  }

  protected cb func OnSelectByCursor(evt: ref<SelectMenuRequest>) -> Bool {
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

  public final func SetMenusData(menuData: ref<MenuDataBuilder>, perkPoints: Int32, attrPoints: Int32) -> Void {
    let dataCharacter: MenuData;
    this.m_menusData = menuData;
    HubMenuUtils.SetMenuData(this.m_btnCrafting, this.m_menusData.GetData(1));
    dataCharacter = this.m_menusData.GetData(2);
    dataCharacter.attrFlag = attrPoints > 0;
    dataCharacter.perkFlag = perkPoints > 0;
    dataCharacter.attrText = attrPoints;
    dataCharacter.perkText = perkPoints;
    HubMenuUtils.SetMenuData(this.m_btnPerks, dataCharacter);
    HubMenuUtils.SetMenuData(this.m_btnStats, this.m_menusData.GetData(8));
    HubMenuUtils.SetMenuData(this.m_btnInventory, this.m_menusData.GetData(3));
    HubMenuUtils.SetMenuData(this.m_btnBackpack, this.m_menusData.GetData(9));
    HubMenuUtils.SetMenuData(this.m_btnCyberware, this.m_menusData.GetData(16));
    HubMenuUtils.SetMenuData(this.m_btnMap, this.m_menusData.GetData(4));
    HubMenuUtils.SetMenuData(this.m_btnJournal, this.m_menusData.GetData(5));
    HubMenuUtils.SetMenuData(this.m_btnPhone, this.m_menusData.GetData(6));
    HubMenuUtils.SetMenuData(this.m_btnTarot, this.m_menusData.GetData(14));
    HubMenuUtils.SetMenuData(this.m_btnCodex, this.m_menusData.GetData(11));
    HubMenuUtils.SetMenuData(this.m_btnShard, this.m_menusData.GetData(12));
    HubMenuUtils.SetMenuData(this.m_btnGallery, this.m_menusData.GetData(13));
  }

  public final func SetActive(isActive: Bool) -> Void {
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
