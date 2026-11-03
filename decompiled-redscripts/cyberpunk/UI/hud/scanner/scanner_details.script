
public class scannerDetailsGameController extends inkHUDGameController {

  private edit let m_scannerCountainer: inkCompoundRef;

  private edit let m_cluesContainer: inkCompoundRef;

  private edit let m_quickhackContainer: inkCompoundRef;

  private edit let m_twintoneContainer: inkCompoundRef;

  private edit let m_toggleDescirptionHackPart: inkWidgetRef;

  private edit let m_toggleDescriptionTwintonePart: inkWidgetRef;

  private edit let m_kiroshiLogo: inkWidgetRef;

  private edit let m_bottomFluff: inkWidgetRef;

  private edit let m_twintoneNoModelAvailable: inkWidgetRef;

  private edit let m_twintoneSaveButtonHints: inkWidgetRef;

  private edit let m_twintoneApplyButtonHints: inkWidgetRef;

  private edit let m_changeTabButtonHints: inkWidgetRef;

  private edit let m_changeTabInlineHint: inkWidgetRef;

  private edit let m_spaceTab01: inkWidgetRef;

  private edit let m_spaceTab02: inkWidgetRef;

  private edit let m_twotabs01BottomLine: inkWidgetRef;

  private edit let m_twotabs02BottomLine: inkWidgetRef;

  private edit let m_threetabs01BottomLine: inkWidgetRef;

  private edit let m_threetabs02BottomLine: inkWidgetRef;

  private edit let m_threetabs03BottomLine: inkWidgetRef;

  private persistent let m_lastOpenTab: ScannerDetailTab;

  private let m_player: wref<GameObject>;

  private let m_scannedObject: wref<GameObject>;

  private let m_scanningState: gameScanningState;

  private let m_scannedObjectType: ScannerObjectType;

  @default(scannerDetailsGameController, ScannerDetailTab.Data)
  private let m_currentTab: ScannerDetailTab;

  private let m_isQuickHackAble: Bool;

  private let m_isQuickHackPanelOpenedOrBlocked: Bool;

  private let m_isQuickHackPanelOpened: Bool;

  private let m_isQuickHackPanelBlocked: Bool;

  private let m_twintoneAvailable: Bool;

  private let m_twintoneApplyAvailable: Bool;

  private let m_twintoneNoModelApplicable: Bool;

  private let m_asyncSpawnRequests: [wref<inkAsyncSpawnRequest>];

  private let m_uiScannedObjectTypeChangedCallbackID: ref<CallbackHandle>;

  private let m_uiScanningStateChangedCallbackID: ref<CallbackHandle>;

  private let m_uiScannedObjectChangedCallbackID: ref<CallbackHandle>;

  private let m_twintoneAvailableCallbackID: ref<CallbackHandle>;

  private let m_twintoneApplyAvailableCallbackID: ref<CallbackHandle>;

  private let m_twintoneNoModelAvailableCallbackID: ref<CallbackHandle>;

  private let m_uiQHPanelOpenedCallbackID: ref<CallbackHandle>;

  private let m_uiQHPanelBlockedCallbackID: ref<CallbackHandle>;

  private let m_uiSystemIsInMenuCallbackID: ref<CallbackHandle>;

  private let m_twintoneFactListenerId: Uint32;

  private let m_possessedByJohnnyFactListenerId: Uint32;

  private let m_introAnimProxy: ref<inkAnimProxy>;

  private let m_outroAnimProxy: ref<inkAnimProxy>;

  private let m_scannerToggleTabOpenAnimProxy: ref<inkAnimProxy>;

  private let m_scannerToggleTabCloseAnimProxy: ref<inkAnimProxy>;

  protected cb func OnInitialize() -> Bool {
    let bbSys: ref<BlackboardSystem> = this.GetBlackboardSystem();
    let uiBlackboard: wref<IBlackboard> = bbSys.Get(GetAllBlackboardDefs().UI_Scanner);
    let uiQuickSlotsDataBB: wref<IBlackboard> = bbSys.Get(GetAllBlackboardDefs().UI_QuickSlotsData);
    this.GetRootWidget().SetVisible(false);
    inkWidgetRef.SetVisible(this.m_scannerCountainer, false);
    this.AsyncSpawnFromLocal(inkWidgetRef.Get(this.m_quickhackContainer), n"QuickHackDescription");
    this.AsyncSpawnFromLocal(inkWidgetRef.Get(this.m_twintoneContainer), n"TwintoneDescription");
    this.m_uiScanningStateChangedCallbackID = uiBlackboard.RegisterDelayedListenerVariant(GetAllBlackboardDefs().UI_Scanner.CurrentState, this, n"OnScanningStateChanged");
    this.m_uiScannedObjectChangedCallbackID = uiBlackboard.RegisterDelayedListenerEntityID(GetAllBlackboardDefs().UI_Scanner.ScannedObject, this, n"OnScannedObjectChanged");
    this.m_twintoneAvailableCallbackID = uiBlackboard.RegisterDelayedListenerBool(GetAllBlackboardDefs().UI_Scanner.twintoneAvailable, this, n"OnTwintoneAvailabilityChanged");
    this.m_twintoneApplyAvailableCallbackID = uiBlackboard.RegisterDelayedListenerBool(GetAllBlackboardDefs().UI_Scanner.twintoneApplyAvailable, this, n"OnTwintoneApplyAvailabilityChanged");
    this.m_twintoneNoModelAvailableCallbackID = uiBlackboard.RegisterDelayedListenerBool(GetAllBlackboardDefs().UI_Scanner.twintoneNoModelAvailable, this, n"OnTwintoneNoModelAvailableChanged");
    this.m_uiScannedObjectTypeChangedCallbackID = bbSys.Get(GetAllBlackboardDefs().UI_ScannerModules).RegisterDelayedListenerInt(GetAllBlackboardDefs().UI_ScannerModules.ObjectType, this, n"OnScannedObjectTypeChanged");
    this.m_uiQHPanelOpenedCallbackID = uiQuickSlotsDataBB.RegisterDelayedListenerBool(GetAllBlackboardDefs().UI_QuickSlotsData.quickhackPanelOpen, this, n"OnQuickHackPanelOpened");
    this.m_uiQHPanelBlockedCallbackID = uiQuickSlotsDataBB.RegisterDelayedListenerBool(GetAllBlackboardDefs().UI_QuickSlotsData.quickhackPanelBlocked, this, n"OnQuickHackPanelBlocked");
    this.m_uiSystemIsInMenuCallbackID = bbSys.Get(GetAllBlackboardDefs().UI_System).RegisterDelayedListenerBool(GetAllBlackboardDefs().UI_System.IsInMenu, this, n"OnMenuUpdate");
    this.AsyncSpawnFromLocal(inkWidgetRef.Get(this.m_cluesContainer), n"ScannerQuestEntries");
    this.UpdateButtonHint();
    this.UpdateTwintoneNoModelAvailableVisibility();
  }

  protected cb func OnUnitialize() -> Bool {
    let bbSys: ref<BlackboardSystem> = this.GetBlackboardSystem();
    let uiBlackboard: wref<IBlackboard> = bbSys.Get(GetAllBlackboardDefs().UI_Scanner);
    let uiScannerChunkBlackboard: wref<IBlackboard> = bbSys.Get(GetAllBlackboardDefs().UI_ScannerModules);
    let uiQuickSlotsDataBB: wref<IBlackboard> = bbSys.Get(GetAllBlackboardDefs().UI_QuickSlotsData);
    if IsDefined(this.m_uiScannedObjectTypeChangedCallbackID) {
      uiScannerChunkBlackboard.UnregisterDelayedListener(GetAllBlackboardDefs().UI_ScannerModules.ObjectType, this.m_uiScannedObjectTypeChangedCallbackID);
    };
    if IsDefined(this.m_uiScannedObjectChangedCallbackID) {
      uiBlackboard.UnregisterDelayedListener(GetAllBlackboardDefs().UI_Scanner.ScannedObject, this.m_uiScannedObjectChangedCallbackID);
    };
    if IsDefined(this.m_twintoneAvailableCallbackID) {
      uiBlackboard.UnregisterDelayedListener(GetAllBlackboardDefs().UI_Scanner.twintoneAvailable, this.m_twintoneAvailableCallbackID);
    };
    if IsDefined(this.m_twintoneApplyAvailableCallbackID) {
      uiBlackboard.UnregisterDelayedListener(GetAllBlackboardDefs().UI_Scanner.twintoneApplyAvailable, this.m_twintoneApplyAvailableCallbackID);
    };
    if IsDefined(this.m_twintoneAvailableCallbackID) {
      uiBlackboard.UnregisterDelayedListener(GetAllBlackboardDefs().UI_Scanner.twintoneNoModelAvailable, this.m_twintoneAvailableCallbackID);
    };
    if IsDefined(this.m_uiScanningStateChangedCallbackID) {
      uiBlackboard.UnregisterDelayedListener(GetAllBlackboardDefs().UI_Scanner.CurrentState, this.m_uiScanningStateChangedCallbackID);
    };
    if IsDefined(this.m_uiQHPanelOpenedCallbackID) {
      uiQuickSlotsDataBB.UnregisterDelayedListener(GetAllBlackboardDefs().UI_QuickSlotsData.quickhackPanelOpen, this.m_uiQHPanelOpenedCallbackID);
    };
    if IsDefined(this.m_uiQHPanelBlockedCallbackID) {
      uiQuickSlotsDataBB.UnregisterDelayedListener(GetAllBlackboardDefs().UI_QuickSlotsData.quickhackPanelBlocked, this.m_uiQHPanelBlockedCallbackID);
    };
    if IsDefined(this.m_uiSystemIsInMenuCallbackID) {
      bbSys.Get(GetAllBlackboardDefs().UI_System).UnregisterDelayedListener(GetAllBlackboardDefs().UI_System.IsInMenu, this.m_uiSystemIsInMenuCallbackID);
    };
    if Cast<Bool>(this.m_twintoneFactListenerId) && IsDefined(this.m_player) {
      GameInstance.GetQuestsSystem(this.m_player.GetGame()).UnregisterListener(n"twintone_scan_disabled", this.m_twintoneFactListenerId);
    };
    if Cast<Bool>(this.m_possessedByJohnnyFactListenerId) && IsDefined(this.m_player) {
      GameInstance.GetQuestsSystem(this.m_player.GetGame()).UnregisterListener(this.GetPlayAsJohnnyFactName(), this.m_possessedByJohnnyFactListenerId);
    };
  }

  protected cb func OnPlayerAttach(player: ref<GameObject>) -> Bool {
    this.m_player = player;
    this.m_twintoneFactListenerId = GameInstance.GetQuestsSystem(this.m_player.GetGame()).RegisterListener(n"twintone_scan_disabled", this, n"OnFactChanged");
    this.m_possessedByJohnnyFactListenerId = GameInstance.GetQuestsSystem(this.m_player.GetGame()).RegisterListener(this.GetPlayAsJohnnyFactName(), this, n"OnFactChanged");
  }

  protected cb func OnScanningStateChanged(value: Variant) -> Bool {
    let isRefreshingLayout: Bool = Equals(this.m_scanningState, gameScanningState.Default) || Equals(this.m_scanningState, gameScanningState.Stopped);
    this.m_scanningState = FromVariant<gameScanningState>(value);
    if isRefreshingLayout {
      this.RefreshLayout();
    };
  }

  protected cb func OnScannedObjectChanged(value: EntityID) -> Bool {
    if EntityID.IsDefined(value) {
      this.m_scannedObject = GameInstance.FindEntityByID(this.m_player.GetGame(), value) as GameObject;
      this.m_isQuickHackAble = this.m_scannedObject.IsQuickHackAble();
      this.ToggleQHTabVisibility();
      this.UpdateKiroshiLogoVisibility();
    } else {
      this.m_scannedObjectType = ScannerObjectType.INVALID;
      this.m_isQuickHackAble = false;
      this.PlayOutroAnimation();
    };
  }

  protected cb func OnScannedObjectTypeChanged(value: Int32) -> Bool {
    this.m_scannedObjectType = IntEnum<ScannerObjectType>(value);
    this.ToggleTwintoneVisibility();
    this.RefreshLayout();
  }

  protected cb func OnScannerTabChangeEvent(evt: ref<ScannerTabChangeEvent>) -> Bool {
    let currentTabIndex: Int32;
    let newTabIndex: Int32;
    let availableTabs: array<ScannerDetailTab> = this.GetAvailablesTabs();
    if !(Equals(this.m_scanningState, gameScanningState.Started) || Equals(this.m_scanningState, gameScanningState.Complete) || Equals(this.m_scanningState, gameScanningState.ShallowComplete)) {
      return false;
    };
    if IsDefined(this.m_outroAnimProxy) && this.m_outroAnimProxy.IsValid() {
      return true;
    };
    currentTabIndex = ArrayFindFirst(availableTabs, this.m_currentTab);
    if currentTabIndex != -1 {
      newTabIndex = (currentTabIndex + 1 + ArraySize(availableTabs)) % ArraySize(availableTabs);
    } else {
      newTabIndex = 0;
    };
    this.SetTab(availableTabs[newTabIndex]);
  }

  private final const func GetAvailablesTabs() -> [ScannerDetailTab] {
    let availableTabs: array<ScannerDetailTab>;
    ArrayPush(availableTabs, ScannerDetailTab.Data);
    if this.m_isQuickHackAble && this.m_isQuickHackPanelOpenedOrBlocked {
      ArrayPush(availableTabs, ScannerDetailTab.Hacking);
    };
    if this.ShouldDisplayTwintoneTab() {
      ArrayPush(availableTabs, ScannerDetailTab.TwinTone);
    };
    return availableTabs;
  }

  protected cb func OnMenuUpdate(value: Bool) -> Bool {
    if !value && IsDefined(this.m_player) && this.m_isQuickHackPanelOpened {
      GameInstance.GetDelaySystem(this.m_player.GetGame()).DelayEventNextFrame(this.m_player, new RefreshQuickhackMenuEvent());
    };
  }

  protected cb func OnQuickHackPanelOpened(value: Bool) -> Bool {
    this.m_isQuickHackPanelOpened = value;
    this.OnQuickHackPanelOpenedOrBlocked();
    this.UpdateButtonHint();
  }

  protected cb func OnQuickHackPanelBlocked(value: Bool) -> Bool {
    this.m_isQuickHackPanelBlocked = value;
    this.OnQuickHackPanelOpenedOrBlocked();
  }

  protected cb func OnQuickHackPanelOpenedOrBlocked() -> Bool {
    let value: Bool = this.m_isQuickHackPanelOpened || this.m_isQuickHackPanelBlocked;
    if Equals(this.m_isQuickHackPanelOpenedOrBlocked, value) {
      return true;
    };
    this.m_isQuickHackPanelOpenedOrBlocked = value;
    if IsDefined(this.m_outroAnimProxy) && this.m_outroAnimProxy.IsValid() && !value {
      return true;
    };
    this.ToggleQHTabVisibility();
    if IsDefined(this.m_introAnimProxy) && this.m_introAnimProxy.IsValid() && value {
      return true;
    };
  }

  private final func RefreshLayout() -> Void {
    let i: Int32;
    this.StopAnimations();
    if NotEquals(HUDManager.GetActiveMode(this.m_player.GetGame()), ActiveMode.FOCUS) {
      this.PlayOutroAnimation();
    };
    if Equals(this.m_scanningState, gameScanningState.Started) || Equals(this.m_scanningState, gameScanningState.Complete) || Equals(this.m_scanningState, gameScanningState.ShallowComplete) {
      this.GetRootWidget().SetVisible(false);
      i = 0;
      while i < ArraySize(this.m_asyncSpawnRequests) {
        this.m_asyncSpawnRequests[i].Cancel();
        i += 1;
      };
      ArrayClear(this.m_asyncSpawnRequests);
      inkCompoundRef.RemoveAllChildren(this.m_scannerCountainer);
      switch this.m_scannedObjectType {
        case ScannerObjectType.PUPPET:
          this.GetRootWidget().SetVisible(true);
          this.AsyncSpawnScannerModule(n"ScannerNPCHeaderWidget");
          this.AsyncSpawnScannerModule(n"ScannerNPCBodyWidget");
          this.AsyncSpawnScannerModule(n"ScannerBountySystemWidget");
          this.AsyncSpawnScannerModule(n"ScannerRequirementsWidget");
          this.AsyncSpawnScannerModule(n"ScannerAbilitiesWidget");
          this.AsyncSpawnScannerModule(n"ScannerResistancesWidget");
          this.AsyncSpawnScannerModule(n"ScannerDeviceDescriptionWidget");
          break;
        case ScannerObjectType.DEVICE:
          this.GetRootWidget().SetVisible(true);
          this.AsyncSpawnScannerModule(n"ScannerDeviceHeaderWidget");
          this.AsyncSpawnScannerModule(n"ScannerVulnerabilitiesWidget");
          this.AsyncSpawnScannerModule(n"ScannerRequirementsWidget");
          this.AsyncSpawnScannerModule(n"ScannerDeviceDescriptionWidget");
          break;
        case ScannerObjectType.VEHICLE:
          this.GetRootWidget().SetVisible(true);
          this.AsyncSpawnScannerModule(n"ScannerVehicleBody");
          this.AsyncSpawnScannerModule(n"ScannerDeviceDescriptionWidget");
          break;
        case ScannerObjectType.GENERIC:
          this.GetRootWidget().SetVisible(true);
          this.AsyncSpawnScannerModule(n"ScannerDeviceHeaderWidget");
          this.AsyncSpawnScannerModule(n"ScannerDeviceDescriptionWidget");
          break;
        default:
          return;
      };
      this.RestoreLastTab();
      inkWidgetRef.SetVisible(this.m_scannerCountainer, !this.m_isQuickHackAble);
      this.m_introAnimProxy = this.PlayLibraryAnimation(n"intro");
      this.m_introAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnScannerDetailsShown");
    } else {
      if Equals(this.m_scanningState, gameScanningState.Default) || Equals(this.m_scanningState, gameScanningState.Stopped) {
        this.PlayOutroAnimation();
      };
    };
  }

  private final func AsyncSpawnScannerModule(scannerWidgetLibraryName: CName) -> Void {
    ArrayPush(this.m_asyncSpawnRequests, this.AsyncSpawnFromLocal(inkWidgetRef.Get(this.m_scannerCountainer), scannerWidgetLibraryName));
  }

  private final func StopAnimations() -> Void {
    if IsDefined(this.m_introAnimProxy) && this.m_introAnimProxy.IsValid() {
      this.m_introAnimProxy.UnregisterFromAllCallbacks(inkanimEventType.OnFinish);
      this.m_introAnimProxy.Stop();
      this.m_introAnimProxy = null;
    };
    if IsDefined(this.m_outroAnimProxy) && this.m_outroAnimProxy.IsValid() {
      this.m_outroAnimProxy.UnregisterFromAllCallbacks(inkanimEventType.OnFinish);
      this.m_outroAnimProxy.Stop();
      this.m_outroAnimProxy = null;
    };
  }

  private final func PlayOutroAnimation() -> Void {
    let progress: Float;
    if IsDefined(this.m_introAnimProxy) && this.m_introAnimProxy.IsValid() {
      progress = 1.00 - this.m_introAnimProxy.GetProgression();
      this.m_introAnimProxy.UnregisterFromAllCallbacks(inkanimEventType.OnFinish);
      this.m_introAnimProxy.Stop();
      this.m_introAnimProxy = null;
    };
    if IsDefined(this.m_outroAnimProxy) && this.m_outroAnimProxy.IsValid() {
      return;
    };
    this.m_outroAnimProxy = this.PlayLibraryAnimation(n"outro");
    this.m_outroAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnScannerDetailsHidden");
    if progress > 0.00 {
      this.m_outroAnimProxy.SetNormalizedPosition(progress, true);
    };
  }

  private final func SetTab(scannerDetailTab: ScannerDetailTab, opt isForceSkippingToggleAnimation: Bool) -> Void {
    let closeAnimation: CName;
    let openAnimation: CName;
    let previousTab: ScannerDetailTab = this.m_currentTab;
    this.m_currentTab = scannerDetailTab;
    this.UpdateActiveTab(this.m_currentTab);
    if Equals(previousTab, this.m_currentTab) {
      return;
    };
    if IsDefined(this.m_scannerToggleTabOpenAnimProxy) && this.m_scannerToggleTabOpenAnimProxy.IsValid() {
      this.m_scannerToggleTabOpenAnimProxy.GotoEndAndStop();
    };
    if IsDefined(this.m_scannerToggleTabCloseAnimProxy) && this.m_scannerToggleTabCloseAnimProxy.IsValid() {
      this.m_scannerToggleTabCloseAnimProxy.GotoEndAndStop();
    };
    switch previousTab {
      case ScannerDetailTab.Data:
        closeAnimation = n"tab_data_close";
        break;
      case ScannerDetailTab.Hacking:
        closeAnimation = n"tab_hack_close";
        break;
      case ScannerDetailTab.TwinTone:
        closeAnimation = n"tab_twintone_close";
    };
    switch this.m_currentTab {
      case ScannerDetailTab.Data:
        openAnimation = n"tab_data_open";
        break;
      case ScannerDetailTab.Hacking:
        openAnimation = n"tab_hack_open";
        break;
      case ScannerDetailTab.TwinTone:
        openAnimation = n"tab_twintone_open";
    };
    this.UpdateTabBottomLine();
    this.m_scannerToggleTabOpenAnimProxy = this.PlayLibraryAnimation(openAnimation);
    this.m_scannerToggleTabCloseAnimProxy = this.PlayLibraryAnimation(closeAnimation);
    if isForceSkippingToggleAnimation {
      this.m_scannerToggleTabOpenAnimProxy.GotoEndAndStop();
      this.m_scannerToggleTabCloseAnimProxy.GotoEndAndStop();
    };
    this.UpdateButtonHint();
    this.UpdateTwintoneNoModelAvailableVisibility();
    this.m_lastOpenTab = this.m_currentTab;
  }

  private final func UpdateTabBottomLine() -> Void {
    inkWidgetRef.SetVisible(this.m_twotabs01BottomLine, false);
    inkWidgetRef.SetVisible(this.m_twotabs02BottomLine, false);
    inkWidgetRef.SetVisible(this.m_threetabs01BottomLine, false);
    inkWidgetRef.SetVisible(this.m_threetabs02BottomLine, false);
    inkWidgetRef.SetVisible(this.m_threetabs03BottomLine, false);
    if this.GetNumberOfTabsDiplayed() == 2 {
      if Equals(this.m_currentTab, ScannerDetailTab.Data) {
        inkWidgetRef.SetVisible(this.m_twotabs01BottomLine, true);
      } else {
        inkWidgetRef.SetVisible(this.m_twotabs02BottomLine, true);
      };
    } else {
      if this.GetNumberOfTabsDiplayed() == 3 {
        if Equals(this.m_currentTab, ScannerDetailTab.Data) {
          inkWidgetRef.SetVisible(this.m_threetabs01BottomLine, true);
        } else {
          if Equals(this.m_currentTab, ScannerDetailTab.Hacking) {
            inkWidgetRef.SetVisible(this.m_threetabs02BottomLine, true);
          } else {
            inkWidgetRef.SetVisible(this.m_threetabs03BottomLine, true);
          };
        };
      };
    };
  }

  private final func UpdateActiveTab(tab: ScannerDetailTab) -> Void {
    let uiBlackboard: wref<IBlackboard> = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_Scanner);
    uiBlackboard.SetVariant(GetAllBlackboardDefs().UI_Scanner.scannerActiveTab, ToVariant(tab), true);
  }

  protected cb func OnTwintoneAvailabilityChanged(value: Bool) -> Bool {
    this.m_twintoneAvailable = value;
    this.UpdateButtonHint();
  }

  protected cb func OnTwintoneApplyAvailabilityChanged(value: Bool) -> Bool {
    this.m_twintoneApplyAvailable = value;
    this.UpdateButtonHint();
  }

  protected cb func OnTwintoneNoModelAvailableChanged(value: Bool) -> Bool {
    this.m_twintoneNoModelApplicable = value;
    this.UpdateTwintoneNoModelAvailableVisibility();
  }

  private final func UpdateButtonHint() -> Void {
    inkWidgetRef.SetVisible(this.m_twintoneSaveButtonHints, Equals(this.m_currentTab, ScannerDetailTab.TwinTone) && this.m_twintoneAvailable);
    inkWidgetRef.SetVisible(this.m_twintoneApplyButtonHints, Equals(this.m_currentTab, ScannerDetailTab.TwinTone) && this.m_twintoneApplyAvailable);
    inkWidgetRef.SetVisible(this.m_changeTabButtonHints, !this.m_isQuickHackPanelOpened && this.GetNumberOfTabsDiplayed() != 1);
    inkWidgetRef.SetVisible(this.m_changeTabInlineHint, this.GetNumberOfTabsDiplayed() != 1);
  }

  private final func UpdateTwintoneNoModelAvailableVisibility() -> Void {
    inkWidgetRef.SetVisible(this.m_twintoneNoModelAvailable, this.m_twintoneNoModelApplicable && Equals(this.m_currentTab, ScannerDetailTab.TwinTone));
    inkWidgetRef.SetVisible(this.m_bottomFluff, !inkWidgetRef.IsVisible(this.m_twintoneNoModelAvailable));
    this.UpdateKiroshiLogoVisibility();
  }

  private final func UpdateKiroshiLogoVisibility() -> Void {
    inkWidgetRef.SetVisible(this.m_kiroshiLogo, GameInstance.GetStatsSystem(this.m_player.GetGame()).GetStatValue(Cast<StatsObjectID>(this.m_player.GetEntityID()), gamedataStatType.HasLinkToBountySystem) > 0.00 && !inkWidgetRef.IsVisible(this.m_twintoneNoModelAvailable));
  }

  private final func OnFactChanged(value: Int32) -> Void {
    this.ToggleTwintoneVisibility();
    this.RefreshLayout();
  }

  private final func ToggleQHTabVisibility() -> Void {
    let tabVisible: Bool = this.m_isQuickHackAble && this.m_isQuickHackPanelOpenedOrBlocked;
    inkWidgetRef.SetVisible(this.m_toggleDescirptionHackPart, tabVisible);
    inkWidgetRef.SetVisible(this.m_spaceTab01, tabVisible);
    this.UpdateTabBottomLine();
    this.UpdateButtonHint();
  }

  private final func ToggleTwintoneVisibility() -> Void {
    let tabVisible: Bool = this.ShouldDisplayTwintoneTab();
    inkWidgetRef.SetVisible(this.m_toggleDescriptionTwintonePart, tabVisible);
    inkWidgetRef.SetVisible(this.m_spaceTab02, tabVisible);
    this.UpdateTabBottomLine();
    this.UpdateButtonHint();
  }

  private final func GetNumberOfTabsDiplayed() -> Int32 {
    let tabsCounter: Int32 = 1;
    if inkWidgetRef.IsVisible(this.m_toggleDescirptionHackPart) {
      tabsCounter += 1;
    };
    if inkWidgetRef.IsVisible(this.m_toggleDescriptionTwintonePart) {
      tabsCounter += 1;
    };
    return tabsCounter;
  }

  private final const func ShouldDisplayTwintoneTab() -> Bool {
    let i: Int32;
    let playerVehicles: array<TweakDBID>;
    if !IsDefined(this.m_player) || Cast<Bool>(GetFact(this.m_player.GetGame(), n"twintone_scan_disabled")) || Cast<Bool>(GetFact(this.m_player.GetGame(), this.GetPlayAsJohnnyFactName())) {
      return false;
    };
    if NotEquals(this.m_scannedObjectType, ScannerObjectType.VEHICLE) || !IsDefined(this.m_scannedObject as VehicleObject) {
      return false;
    };
    playerVehicles = TDB.GetForeignKeyArray(t"Vehicle.vehicle_list.list");
    i = 0;
    while i < ArraySize(playerVehicles) {
      if (this.m_scannedObject as VehicleObject).GetRecord().GetRecordID() == playerVehicles[i] {
        return false;
      };
      i += 1;
    };
    return true;
  }

  private final func RestoreLastTab() -> Void {
    let availableTabs: array<ScannerDetailTab> = this.GetAvailablesTabs();
    if ArrayContains(availableTabs, this.m_lastOpenTab) {
      this.SetTab(this.m_lastOpenTab, true);
    } else {
      this.SetTab(ScannerDetailTab.Data, true);
    };
  }

  protected cb func OnScannerDetailsShown(animationProxy: ref<inkAnimProxy>) -> Bool {
    this.m_introAnimProxy = null;
    inkWidgetRef.SetVisible(this.m_scannerCountainer, true);
    this.RestoreLastTab();
  }

  protected cb func OnScannerDetailsHidden(animationProxy: ref<inkAnimProxy>) -> Bool {
    this.m_outroAnimProxy = null;
    inkWidgetRef.SetVisible(this.m_scannerCountainer, false);
    inkWidgetRef.SetVisible(this.m_toggleDescirptionHackPart, false);
  }

  private final const func GetPlayAsJohnnyFactName() -> CName {
    if !IsDefined(this.m_player) {
      return n"None";
    };
    return StringToName(GameInstance.GetPlayerSystem(this.m_player.GetGame()).GetPossessedByJohnnyFactName());
  }
}
