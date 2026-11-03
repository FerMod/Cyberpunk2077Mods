
public native class DeathMenuGameController extends gameuiMenuItemListGameController {

  private edit let m_buttonHintsManagerRef: inkWidgetRef;

  private let m_buttonHintsController: wref<ButtonHints>;

  private let m_animIntro: ref<inkAnimProxy>;

  @default(DeathMenuGameController, false)
  private let m_axisInputReceived: Bool;

  @default(DeathMenuGameController, false)
  private let m_dpadInputReceived: Bool;

  protected cb func OnInitialize() -> Bool {
    super.OnInitialize();
    this.m_buttonHintsController = this.SpawnFromExternal(inkWidgetRef.Get(this.m_buttonHintsManagerRef), r"base\\gameplay\\gui\\common\\buttonhints.inkwidget", n"Root").GetController() as ButtonHints;
    this.m_buttonHintsController.AddButtonHint(n"select", GetLocalizedText("UI-UserActions-Select"));
    this.m_menuListController.GetRootWidget().RegisterToCallback(n"OnRelease", this, n"OnListRelease");
    this.m_menuListController.GetRootWidget().RegisterToCallback(n"OnRepeat", this, n"OnListRelease");
    this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnGlobalRelease");
    this.PlaySound(n"DeathMenu", n"OnOpen");
  }

  protected cb func OnUninitialize() -> Bool {
    this.m_menuListController.GetRootWidget().UnregisterFromCallback(n"OnRelease", this, n"OnListRelease");
    this.m_menuListController.GetRootWidget().UnregisterFromCallback(n"OnRepeat", this, n"OnListRelease");
    this.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"OnGlobalRelease");
    this.PlaySound(n"DeathMenu", n"OnClose");
    super.OnUninitialize();
  }

  protected cb func OnSetUserData(userData: ref<IScriptable>) -> Bool {
    let deathMenuData: ref<DeathMenuUserData> = userData as DeathMenuUserData;
    if IsDefined(deathMenuData) && deathMenuData.m_playInitAnimation {
      this.m_animIntro = this.PlayLibraryAnimation(n"intro");
      this.m_animIntro.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnIntroFinished");
    };
  }

  private func ShouldAllowExitGameMenuItem() -> Bool {
    return false;
  }

  private func PopulateMenuItemList() -> Void {
    if this.GetSystemRequestsHandler().HasLastCheckpoint() {
      this.AddMenuItem(GetLocalizedText("UI-ScriptExports-LoadLastSavegame"), PauseMenuAction.QuickLoad);
    };
    this.AddMenuItem(GetLocalizedText("UI-ScriptExports-LoadGame0"), n"OnSwitchToLoadGame");
    this.AddMenuItem(GetLocalizedText("UI-Labels-Settings"), n"OnSwitchToSettings");
    this.AddMenuItem(GetLocalizedText("UI-Labels-ExitToMenu"), PauseMenuAction.ExitToMainMenu);
    this.m_menuListController.Refresh();
  }

  protected cb func OnIntroFinished(proxy: ref<inkAnimProxy>) -> Bool {
    let widgetToSnap: wref<inkWidget>;
    let index: Int32 = -1;
    let player: ref<GameObject> = this.GetPlayerControlledObject();
    let menuEvent: ref<inkMenuInstance_SpawnAddressedEvent> = new inkMenuInstance_SpawnAddressedEvent();
    if !this.m_axisInputReceived {
      if !this.m_dpadInputReceived {
        widgetToSnap = inkCompoundRef.GetWidgetByIndex(this.m_menuList, 0);
      } else {
        index = this.m_menuListController.GetSelectedIndex();
        widgetToSnap = index > -1 && index < this.m_menuListController.Size() ? this.m_menuListController.GetItemAt(index) : inkCompoundRef.GetWidgetByIndex(this.m_menuList, 0);
      };
      this.SetCursorOverWidget(widgetToSnap, index > -1 ? 0.10 : 0.00);
    };
    if IsDefined(player) {
      menuEvent.Init(n"MenuScenario_Idle", n"OnUnlockAll");
      GameInstance.GetUISystem(player.GetGame()).QueueEvent(menuEvent);
    };
  }

  protected func HandleMenuItemActivate(data: ref<PauseMenuListItemData>) -> Bool {
    if super.HandleMenuItemActivate(data) {
      return false;
    };
    switch data.action {
      case PauseMenuAction.QuickLoad:
        GameInstance.GetTelemetrySystem(this.GetPlayerControlledObject().GetGame()).LogLastCheckpointLoaded();
        this.GetSystemRequestsHandler().LoadLastCheckpoint(true);
        return true;
    };
    return false;
  }

  protected cb func OnListRelease(e: ref<inkPointerEvent>) -> Bool {
    if e.IsHandled() {
      return false;
    };
    this.m_menuListController.HandleInput(e, this);
  }

  protected cb func OnGlobalRelease(e: ref<inkPointerEvent>) -> Bool {
    if e.IsAction(n"navigate_up") || e.IsAction(n"navigate_left") || e.IsAction(n"navigate_down") || e.IsAction(n"navigate_right") {
      this.m_dpadInputReceived = true;
    };
  }
}
