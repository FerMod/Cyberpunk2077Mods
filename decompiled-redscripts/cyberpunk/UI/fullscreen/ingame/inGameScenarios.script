
public class StartHubMenuEvent extends Event {

  public let m_initData: ref<HubMenuInitData>;

  public final func SetStartMenu(menuName: CName, opt submenuName: CName, opt userData: ref<IScriptable>) -> Void {
    this.m_initData = new HubMenuInitData();
    this.m_initData.m_menuName = menuName;
    this.m_initData.m_submenuName = submenuName;
    this.m_initData.m_userData = userData;
  }
}

public class MenuScenario_Idle extends inkMenuScenario {

  protected cb func OnEnterScenario(prevScenario: CName, userData: ref<IScriptable>) -> Bool {
    let menuState: wref<inkMenusState> = this.GetMenusState();
    if NotEquals(prevScenario, n"None") {
      menuState.CloseAllMenus();
      menuState.ShowMenus(false);
    };
    this.QueueEvent(new UIInGameNotificationRemoveEvent());
  }

  protected cb func OnBlockHub() -> Bool {
    this.GetMenusState().SetHubMenuBlocked(true);
  }

  protected cb func OnUnlockHub() -> Bool {
    this.GetMenusState().SetHubMenuBlocked(false);
  }

  protected cb func OnLeaveScenario(nextScenario: CName) -> Bool {
    this.QueueEvent(new UIInGameNotificationRemoveEvent());
    this.GetMenusState().ShowMenus(true);
  }

  protected cb func OnOpenPauseMenu() -> Bool {
    this.SwitchToScenario(n"MenuScenario_PauseMenu");
  }

  protected cb func OnOpenHubMenu() -> Bool {
    let notificationEvent: ref<UIInGameNotificationEvent>;
    if !this.GetMenusState().IsHubMenuBlocked() {
      this.SwitchToScenario(n"MenuScenario_HubMenu");
    } else {
      this.QueueEvent(new UIInGameNotificationRemoveEvent());
      notificationEvent = new UIInGameNotificationEvent();
      notificationEvent.m_notificationType = UIInGameNotificationType.CombatRestriction;
      this.QueueEvent(notificationEvent);
    };
  }

  protected cb func OnOpenRadialHubMenu() -> Bool {
    let notificationEvent: ref<UIInGameNotificationEvent>;
    if !this.GetMenusState().IsHubMenuBlocked() {
      this.SwitchToScenario(n"MenuScenario_RadialHubMenu");
    } else {
      this.QueueEvent(new UIInGameNotificationRemoveEvent());
      notificationEvent = new UIInGameNotificationEvent();
      notificationEvent.m_notificationType = UIInGameNotificationType.CombatRestriction;
      this.QueueEvent(notificationEvent);
    };
  }

  protected cb func OnOpenHubMenu_InitData(userData: ref<IScriptable>) -> Bool {
    let notificationEvent: ref<UIInGameNotificationEvent>;
    if !this.GetMenusState().IsHubMenuBlocked() {
      this.SwitchToScenario(n"MenuScenario_HubMenu", userData);
    } else {
      this.QueueEvent(new UIInGameNotificationRemoveEvent());
      notificationEvent = new UIInGameNotificationEvent();
      notificationEvent.m_notificationType = UIInGameNotificationType.CombatRestriction;
      this.QueueEvent(notificationEvent);
    };
  }

  protected cb func OnOpenRadialHubMenu_InitData(userData: ref<IScriptable>) -> Bool {
    let notificationEvent: ref<UIInGameNotificationEvent>;
    if !this.GetMenusState().IsHubMenuBlocked() {
      this.SwitchToScenario(n"MenuScenario_RadialHubMenu", userData);
    } else {
      this.QueueEvent(new UIInGameNotificationRemoveEvent());
      notificationEvent = new UIInGameNotificationEvent();
      notificationEvent.m_notificationType = UIInGameNotificationType.CombatRestriction;
      this.QueueEvent(notificationEvent);
    };
  }

  protected cb func OnNetworkBreachBegin() -> Bool {
    this.SwitchToScenario(n"MenuScenario_NetworkBreach");
  }

  protected cb func OnShowDeathMenu() -> Bool {
    this.SwitchToScenario(n"MenuScenario_DeathMenu");
  }

  protected cb func OnShowStorageMenu() -> Bool {
    this.SwitchToScenario(n"MenuScenario_Storage");
  }

  protected cb func OnOpenFastTravel() -> Bool {
    this.SwitchToScenario(n"MenuScenario_FastTravel");
  }

  protected cb func OnOpenDelamainTaxiMap() -> Bool {
    this.SwitchToScenario(n"MenuScenario_DelamainTaxi");
  }

  protected cb func OnOpenWardrobeMenu(userData: ref<IScriptable>) -> Bool {
    this.SwitchToScenario(n"MenuScenario_Wardrobe", userData);
  }

  protected cb func OnArcadeMinigameBegin(userData: ref<IScriptable>) -> Bool {
    this.SwitchToScenario(n"MenuScenario_ArcadeMinigame", userData);
  }

  protected cb func OnOpenTimeSkip() -> Bool {
    this.SwitchToScenario(n"MenuScenario_TimeSkip");
  }
}

public class MenuScenario_BaseMenu extends inkMenuScenario {

  protected let m_currMenuName: CName;

  protected let m_currUserData: ref<IScriptable>;

  protected let m_currSubMenuName: CName;

  protected let m_prevMenuName: CName;

  protected cb func OnLeaveScenario(nextScenario: CName) -> Bool {
    this.CloseMenu();
  }

  protected cb func OnBack() -> Bool {
    let menuState: wref<inkMenusState> = this.GetMenusState();
    if NotEquals(this.m_currSubMenuName, n"None") {
      if !menuState.DispatchEvent(this.m_currSubMenuName, n"OnBack") {
        this.CloseSubMenu();
      };
    } else {
      if NotEquals(this.m_currMenuName, n"None") {
        if !menuState.DispatchEvent(this.m_currMenuName, n"OnBack") {
          this.GotoIdleState();
        };
      };
    };
  }

  protected final func OpenMenu(menuName: CName, opt userData: ref<IScriptable>, opt context: ScreenDisplayContext) -> Void {
    this.GetMenusState().OpenMenu(menuName, userData);
    this.SetDisplayContext(context);
  }

  protected final func SwitchMenu(menuName: CName, opt userData: ref<IScriptable>, opt context: ScreenDisplayContext) -> Void {
    let menuState: wref<inkMenusState> = this.GetMenusState();
    if NotEquals(this.m_currMenuName, n"None") {
      menuState.DispatchEvent(this.m_currMenuName, n"OnCloseMenu");
      menuState.CloseMenu(this.m_currMenuName);
    };
    this.m_currMenuName = menuName;
    this.m_currUserData = userData;
    menuState.OpenMenu(this.m_currMenuName, userData);
    this.SetDisplayContext(context);
  }

  private final func SetDisplayContext(context: ScreenDisplayContext) -> Void {
    if NotEquals(context, ScreenDisplayContext.Default) {
      if NotEquals(this.m_currMenuName, n"None") {
        this.GetMenusState().DispatchEvent(this.m_currMenuName, n"OnSetScreenDisplayContext", ScreenDisplayContextData.Make(context));
      };
    };
  }

  protected final func CloseMenu() -> Void {
    let menuState: wref<inkMenusState> = this.GetMenusState();
    if NotEquals(this.m_currMenuName, n"None") {
      menuState.DispatchEvent(this.m_currMenuName, n"OnCloseMenu");
      menuState.CloseMenu(this.m_currMenuName);
      this.m_currMenuName = n"None";
    };
  }

  protected final func OpenSubMenu(menuName: CName, opt userData: ref<IScriptable>) -> Void {
    let menuState: wref<inkMenusState> = this.GetMenusState();
    if NotEquals(this.m_currSubMenuName, n"None") {
      menuState.DispatchEvent(this.m_currSubMenuName, n"OnCloseMenu");
      menuState.CloseMenu(this.m_currSubMenuName);
    };
    this.m_currSubMenuName = menuName;
    menuState.OpenMenu(this.m_currSubMenuName, userData);
  }

  protected final func CloseSubMenu() -> Void {
    let menuState: wref<inkMenusState> = this.GetMenusState();
    if NotEquals(this.m_currSubMenuName, n"None") {
      menuState.DispatchEvent(this.m_currSubMenuName, n"OnCloseMenu");
      menuState.CloseMenu(this.m_currSubMenuName);
      this.m_currSubMenuName = n"None";
    };
  }

  protected final func SetContext(context: ScreenDisplayContext) -> Void {
    let menuState: wref<inkMenusState> = this.GetMenusState();
    if NotEquals(this.m_currSubMenuName, n"None") {
      menuState.DispatchEvent(this.m_currSubMenuName, n"OnCloseMenu");
    };
  }

  protected func GotoIdleState() -> Void {
    this.SwitchToScenario(n"MenuScenario_Idle");
  }
}

public class MenuScenario_CharacterCustomizationMirror extends MenuScenario_BaseMenu {

  private let m_morphMenuUserData: ref<MorphMenuUserData>;

  protected cb func OnEnterScenario(prevScenario: CName, userData: ref<IScriptable>) -> Bool {
    this.m_morphMenuUserData = userData as MorphMenuUserData;
    if IsDefined(this.m_morphMenuUserData) {
      this.m_morphMenuUserData.m_optionsListInitialized = false;
      this.m_morphMenuUserData.m_updatingFinalizedState = true;
    };
    this.m_currMenuName = n"character_customization_scenes";
    this.GetMenusState().OpenMenu(n"character_customization_scenes");
  }

  protected cb func OnCCOPuppetReady() -> Bool {
    this.m_currMenuName = n"character_customization";
    let menuState: wref<inkMenusState> = this.GetMenusState();
    menuState.OpenMenu(n"player_puppet");
    menuState.OpenMenu(n"character_customization", this.m_morphMenuUserData);
  }

  protected cb func OnAccept() -> Bool {
    this.GotoIdleState();
  }

  protected cb func OnBack() -> Bool;

  protected cb func OnCancel() -> Bool {
    this.GotoIdleState();
  }
}

public class ScreenDisplayContextData extends IScriptable {

  public let Context: ScreenDisplayContext;

  public final static func Make(context: ScreenDisplayContext) -> ref<ScreenDisplayContextData> {
    let instance: ref<ScreenDisplayContextData> = new ScreenDisplayContextData();
    instance.Context = context;
    return instance;
  }
}

public abstract class MenuUIUtils extends IScriptable {

  public final static func RequestAutoSave(player: wref<GameObject>, opt delay: Float) -> Void {
    let evt: ref<AutoSaveEvent>;
    if player == null {
      return;
    };
    if delay <= 0.00 {
      GameInstance.GetAutoSaveSystem(player.GetGame()).RequestCheckpoint();
    } else {
      evt = new AutoSaveEvent();
      evt.maxAttempts = 5;
      evt.isForced = true;
      GameInstance.GetDelaySystem(player.GetGame()).DelayEvent(player, evt, delay, false);
    };
  }
}
