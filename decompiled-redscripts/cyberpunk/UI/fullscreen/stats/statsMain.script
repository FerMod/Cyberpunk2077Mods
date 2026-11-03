
public class StatsMainGameController extends gameuiMenuGameController {

  private edit let m_MainViewRoot: inkWidgetRef;

  private edit let m_statsList: inkCompoundRef;

  private edit let m_TooltipsManagerRef: inkWidgetRef;

  private edit let m_levelControllerRef: inkWidgetRef;

  private edit let m_streetCredControllerRef: inkWidgetRef;

  private edit let m_detailListControllerRef: inkWidgetRef;

  private edit let m_statsStreetCredRewardRef: inkWidgetRef;

  private edit let m_statsPlayTimeControllerdRef: inkWidgetRef;

  private edit let m_btnInventory: inkWidgetRef;

  private edit let m_buttonHintsManagerRef: inkWidgetRef;

  private edit let m_rightPanelFluff1: inkWidgetRef;

  private edit let m_rightPanelFluff2: inkWidgetRef;

  private let m_TooltipsManager: wref<gameuiTooltipsManager>;

  private let m_InventoryManager: ref<InventoryDataManagerV2>;

  private let m_player: wref<PlayerPuppet>;

  private let m_healthStatsData: [StatViewData];

  private let m_DPSStatsData: [StatViewData];

  private let m_armorStatsData: [StatViewData];

  private let m_otherStatsData: [StatViewData];

  private let playerStatsBlackboard: wref<IBlackboard>;

  private let currencyListener: ref<CallbackHandle>;

  private let characterCredListener: ref<CallbackHandle>;

  private let characterLevelListener: ref<CallbackHandle>;

  private let characterCurrentXPListener: ref<CallbackHandle>;

  private let characterCredPointsListener: ref<CallbackHandle>;

  private let m_PDS: ref<PlayerDevelopmentSystem>;

  private let m_levelController: wref<StatsProgressController>;

  private let m_streetCredController: wref<StatsProgressController>;

  private let m_detailListController: wref<StatsDetailListController>;

  private let m_statsStreetCredReward: wref<StatsStreetCredReward>;

  private let m_statsPlayTimeController: wref<StatsPlayTimeController>;

  private let m_previousMenuData: ref<PreviousMenuData>;

  private let m_buttonHintsController: wref<ButtonHints>;

  private let m_animProxy: ref<inkAnimProxy>;

  protected cb func OnInitialize() -> Bool {
    let playbackOptions: inkAnimOptions;
    let gameInstanace: GameInstance = this.GetPlayerControlledObject().GetGame();
    let gameTime: EngineTime = GameInstance.GetPlaythroughTime(gameInstanace);
    this.m_TooltipsManager = inkWidgetRef.GetControllerByType(this.m_TooltipsManagerRef, n"gameuiTooltipsManager") as gameuiTooltipsManager;
    this.m_levelController = inkWidgetRef.GetControllerByType(this.m_levelControllerRef, n"StatsProgressController") as StatsProgressController;
    this.m_streetCredController = inkWidgetRef.GetControllerByType(this.m_streetCredControllerRef, n"StatsProgressController") as StatsProgressController;
    this.m_detailListController = inkWidgetRef.GetControllerByType(this.m_detailListControllerRef, n"StatsDetailListController") as StatsDetailListController;
    this.m_statsStreetCredReward = inkWidgetRef.GetControllerByType(this.m_statsStreetCredRewardRef, n"StatsStreetCredReward") as StatsStreetCredReward;
    this.m_statsPlayTimeController = inkWidgetRef.GetControllerByType(this.m_statsPlayTimeControllerdRef, n"StatsPlayTimeController") as StatsPlayTimeController;
    this.m_player = GameInstance.GetPlayerSystem(gameInstanace).GetLocalPlayerMainGameObject() as PlayerPuppet;
    this.m_InventoryManager = new InventoryDataManagerV2();
    this.m_InventoryManager.Initialize(this.m_player);
    this.m_InventoryManager.GetPlayerHealthStats(this.m_healthStatsData);
    this.m_InventoryManager.GetPlayerDPSStats(this.m_DPSStatsData);
    this.m_InventoryManager.GetPlayerArmorStats(this.m_armorStatsData);
    this.m_InventoryManager.GetPlayerOtherStats(this.m_otherStatsData);
    this.m_TooltipsManager.Setup();
    inkCompoundRef.RemoveAllChildren(this.m_statsList);
    this.PopulateStats();
    this.m_PDS = GameInstance.GetScriptableSystemsContainer((this.GetOwnerEntity() as GameObject).GetGame()).Get(n"PlayerDevelopmentSystem") as PlayerDevelopmentSystem;
    this.playerStatsBlackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_PlayerStats);
    this.characterLevelListener = this.playerStatsBlackboard.RegisterDelayedListenerInt(GetAllBlackboardDefs().UI_PlayerStats.Level, this, n"OnCharacterLevelUpdated");
    this.playerStatsBlackboard.SignalInt(GetAllBlackboardDefs().UI_PlayerStats.Level);
    this.characterCurrentXPListener = this.playerStatsBlackboard.RegisterDelayedListenerInt(GetAllBlackboardDefs().UI_PlayerStats.CurrentXP, this, n"OnCharacterLevelCurrentXPUpdated");
    this.playerStatsBlackboard.SignalInt(GetAllBlackboardDefs().UI_PlayerStats.CurrentXP);
    this.characterCredListener = this.playerStatsBlackboard.RegisterDelayedListenerInt(GetAllBlackboardDefs().UI_PlayerStats.StreetCredLevel, this, n"OnCharacterStreetCredLevelUpdated");
    this.playerStatsBlackboard.SignalInt(GetAllBlackboardDefs().UI_PlayerStats.StreetCredLevel);
    this.characterCredPointsListener = this.playerStatsBlackboard.RegisterDelayedListenerInt(GetAllBlackboardDefs().UI_PlayerStats.StreetCredPoints, this, n"OnCharacterStreetCredPointsUpdated");
    this.playerStatsBlackboard.SignalInt(GetAllBlackboardDefs().UI_PlayerStats.StreetCredPoints);
    this.m_statsPlayTimeController.Set(EngineTime.ToFloat(gameTime), this.m_PDS.GetLifePath(this.m_player));
    HubMenuUtils.SetMenuHyperlinkData(this.m_btnInventory, HubMenuItems.Inventory, HubMenuItems.None, n"inventory_screen", n"ico_inventory", n"UI-PanelNames-INVENTORY");
    this.m_buttonHintsController = this.SpawnFromExternal(inkWidgetRef.Get(this.m_buttonHintsManagerRef), r"base\\gameplay\\gui\\common\\buttonhints.inkwidget", n"Root").GetController() as ButtonHints;
    this.m_buttonHintsController.AddButtonHint(n"back", GetLocalizedText("Common-Access-Close"));
    this.OnIntro();
    this.PlayLibraryAnimation(n"menu_intro");
    super.OnInitialize();
    playbackOptions.loopType = inkanimLoopType.Cycle;
    playbackOptions.loopInfinite = true;
    playbackOptions.customTimeDilation = 0.20;
    playbackOptions.applyCustomTimeDilation = true;
    this.m_animProxy = this.PlayLibraryAnimation(n"text_wall", playbackOptions);
  }

  protected cb func OnUninitialize() -> Bool {
    this.m_InventoryManager.UnInitialize();
    this.playerStatsBlackboard.UnregisterDelayedListener(GetAllBlackboardDefs().UI_PlayerStats.Level, this.characterLevelListener);
    this.playerStatsBlackboard.UnregisterDelayedListener(GetAllBlackboardDefs().UI_PlayerStats.CurrentXP, this.characterCurrentXPListener);
    this.playerStatsBlackboard.UnregisterDelayedListener(GetAllBlackboardDefs().UI_PlayerStats.StreetCredLevel, this.characterCredListener);
    this.playerStatsBlackboard.UnregisterDelayedListener(GetAllBlackboardDefs().UI_PlayerStats.StreetCredPoints, this.characterCredPointsListener);
    super.OnUninitialize();
  }

  protected cb func OnSetUserData(userData: ref<IScriptable>) -> Bool {
    this.m_previousMenuData = userData as PreviousMenuData;
  }

  protected cb func OnCharacterLevelUpdated(value: Int32) -> Bool {
    this.m_levelController.SetLevel(value);
  }

  protected cb func OnCharacterLevelCurrentXPUpdated(value: Int32) -> Bool {
    let remainingXP: Int32 = this.m_PDS.GetRemainingExpForLevelUp(this.m_player, gamedataProficiencyType.Level);
    this.m_levelController.SetProgress(value, remainingXP + value);
  }

  protected cb func OnCharacterStreetCredLevelUpdated(value: Int32) -> Bool {
    this.m_streetCredController.SetLevel(value);
    this.m_statsStreetCredReward.SetData(SteetCredDataHelper.GetData(), this.m_TooltipsManager, value, 0, "Gameplay-RPG-Skills-StreetCred");
  }

  protected cb func OnCharacterStreetCredPointsUpdated(value: Int32) -> Bool {
    let remainingXP: Int32 = this.m_PDS.GetRemainingExpForLevelUp(this.m_player, gamedataProficiencyType.StreetCred);
    this.m_streetCredController.SetProgress(value, remainingXP + value);
  }

  public final func PopulateStats() -> Void {
    this.AddStat(gamedataStatType.EffectiveDPS, this.m_DPSStatsData);
    this.AddStat(gamedataStatType.Armor, this.m_armorStatsData);
    this.AddStat(gamedataStatType.Health, this.m_healthStatsData);
    this.AddStat(gamedataStatType.Invalid, this.m_otherStatsData);
  }

  private final func AddStat(statType: gamedataStatType, const datalist: script_ref<[StatViewData]>) -> Void {
    let statData: StatViewData;
    let statView: wref<StatsViewController> = this.SpawnFromLocal(inkWidgetRef.Get(this.m_statsList), n"statView").GetControllerByType(n"StatsViewController") as StatsViewController;
    if NotEquals(statType, gamedataStatType.Invalid) {
      statData = this.RequestStat(statType, datalist);
    } else {
      statData.type = gamedataStatType.Invalid;
      statData.statName = "LocKey#49347";
    };
    statView.Setup(statData);
  }

  private final func OnIntro() -> Void;

  private final func RequestStat(stat: gamedataStatType, const datalist: script_ref<[StatViewData]>) -> StatViewData {
    let data: StatViewData;
    let i: Int32 = 0;
    while i < ArraySize(Deref(datalist)) {
      if Equals(Deref(datalist)[i].type, stat) {
        return Deref(datalist)[i];
      };
      i += 1;
    };
    return data;
  }

  protected cb func OnCategoryClicked(evt: ref<CategoryClickedEvent>) -> Bool {
    let detailsData: array<StatViewData>;
    inkWidgetRef.SetVisible(this.m_rightPanelFluff1, false);
    inkWidgetRef.SetVisible(this.m_rightPanelFluff2, false);
    switch evt.statsData.type {
      case gamedataStatType.Health:
        detailsData = this.m_healthStatsData;
        break;
      case gamedataStatType.EffectiveDPS:
        detailsData = this.m_DPSStatsData;
        break;
      case gamedataStatType.Armor:
        detailsData = this.m_armorStatsData;
        break;
      case gamedataStatType.Invalid:
        detailsData = this.m_otherStatsData;
    };
    this.m_detailListController.SetData(evt.statsData, detailsData);
  }
}

public class StatsViewController extends inkLogicController {

  private edit let m_StatLabelRef: inkTextRef;

  private edit let m_StatValueRef: inkTextRef;

  private edit let m_icon: inkImageRef;

  private let m_stat: StatViewData;

  protected cb func OnInitialize() -> Bool {
    this.RegisterToCallback(n"OnHoverOver", this, n"OnButtonClick");
  }

  public final func Setup(const stat: script_ref<StatViewData>) -> Void {
    inkTextRef.SetText(this.m_StatLabelRef, Deref(stat).statName);
    inkTextRef.SetText(this.m_StatValueRef, IntToString(Deref(stat).value));
    this.m_stat = Deref(stat);
    switch Deref(stat).type {
      case gamedataStatType.Health:
        inkImageRef.SetTexturePart(this.m_icon, n"health");
        break;
      case gamedataStatType.EffectiveDPS:
        inkImageRef.SetTexturePart(this.m_icon, n"gun");
        break;
      case gamedataStatType.Armor:
        inkImageRef.SetTexturePart(this.m_icon, n"armor");
        break;
      case gamedataStatType.Invalid:
        inkImageRef.SetTexturePart(this.m_icon, n"other");
        inkWidgetRef.SetVisible(this.m_StatValueRef, false);
    };
  }

  public final func GetStatType() -> StatViewData {
    return this.m_stat;
  }

  protected cb func OnButtonClick(hoverEvenet: ref<inkPointerEvent>) -> Bool {
    let widget: ref<inkWidget> = hoverEvenet.GetTarget();
    let controller: ref<StatsViewController> = widget.GetController() as StatsViewController;
    let evt: ref<CategoryClickedEvent> = new CategoryClickedEvent();
    evt.statsData = controller.GetStatType();
    this.QueueEvent(evt);
  }

  protected cb func OnUninitialize() -> Bool {
    this.UnregisterFromCallback(n"OnHoverOver", this, n"OnButtonClick");
  }
}

public class StatsDetailViewController extends inkLogicController {

  private edit let m_StatLabelRef: inkTextRef;

  private edit let m_StatValueRef: inkTextRef;

  protected cb func OnInitialize() -> Bool {
    this.GetRootWidget().SetVisible(false);
  }

  public final func Setup(const stat: script_ref<StatViewData>) -> Void {
    inkTextRef.SetText(this.m_StatLabelRef, Deref(stat).statName);
    this.GetRootWidget().SetVisible(true);
    switch Deref(stat).type {
      case gamedataStatType.MaxSpeed:
      case gamedataStatType.AttacksPerSecond:
        inkTextRef.SetText(this.m_StatValueRef, FloatToStringPrec(Deref(stat).valueF, 2));
        break;
      case gamedataStatType.StealthHitDamageBonus:
      case gamedataStatType.BonusRicochetDamage:
      case gamedataStatType.CritDamage:
      case gamedataStatType.CritChance:
        inkTextRef.SetText(this.m_StatValueRef, FloatToStringPrec(Deref(stat).valueF, 2) + "%");
        break;
      case gamedataStatType.EffectiveDPS:
        inkTextRef.SetText(this.m_StatValueRef, FloatToStringPrec(Deref(stat).valueF - ModF(Deref(stat).valueF, 0.10), 1));
        break;
      case gamedataStatType.MemoryRegenRate:
        inkTextRef.SetText(this.m_StatValueRef, FloatToStringPrec(Deref(stat).valueF * 100.00, 0) + "%");
        break;
      case gamedataStatType.BonusQuickHackDamage:
      case gamedataStatType.HeadshotDamageMultiplier:
      case gamedataStatType.MeleeDamagePercentBonus:
      case gamedataStatType.Visibility:
      case gamedataStatType.FallDamageReduction:
      case gamedataStatType.BonusDamageAgainstBosses:
      case gamedataStatType.BonusDamageAgainstRares:
      case gamedataStatType.BonusDamageAgainstElites:
      case gamedataStatType.DamageReductionQuickhacks:
      case gamedataStatType.DamageReductionDamageOverTime:
      case gamedataStatType.MeleeResistance:
      case gamedataStatType.ExplosionResistance:
      case gamedataStatType.StaminaCostReduction:
      case gamedataStatType.ChargeMultiplier:
      case gamedataStatType.IntrinsicQuickHackUploadBonus:
      case gamedataStatType.StaminaRegenRate:
      case gamedataStatType.HealthGeneralRegenRateMult:
      case gamedataStatType.MitigationStrength:
      case gamedataStatType.MitigationChance:
        inkTextRef.SetText(this.m_StatValueRef, IntToString(Deref(stat).value) + "%");
        break;
      default:
        inkTextRef.SetText(this.m_StatValueRef, IntToString(Deref(stat).value));
    };
  }
}

public class StatsDetailListController extends inkLogicController {

  private edit let m_StatLabelRef: inkTextRef;

  private edit let m_statsList: inkCompoundRef;

  protected cb func OnInitialize() -> Bool {
    this.GetRootWidget().SetVisible(false);
  }

  public final func SetData(const categoryData: script_ref<StatViewData>, const detailsData: script_ref<[StatViewData]>) -> Void {
    let i: Int32;
    let statView: wref<StatsDetailViewController>;
    let statViewWidget: wref<inkWidget>;
    this.GetRootWidget().SetVisible(true);
    inkTextRef.SetText(this.m_StatLabelRef, Deref(categoryData).statName);
    inkCompoundRef.RemoveAllChildren(this.m_statsList);
    i = 0;
    while i < ArraySize(Deref(detailsData)) {
      if Deref(detailsData)[i].valueF != 0.00 {
        statViewWidget = this.SpawnFromLocal(inkWidgetRef.Get(this.m_statsList), n"statDetailView");
        statView = statViewWidget.GetControllerByType(n"StatsDetailViewController") as StatsDetailViewController;
        statView.Setup(Deref(detailsData)[i]);
      };
      i += 1;
    };
  }
}

public class StatsPlayTimeController extends inkLogicController {

  private edit let m_playTimeRef: inkTextRef;

  private edit let m_lifePathRef: inkTextRef;

  private edit let m_lifePathIconRef: inkImageRef;

  public final func Set(playTime: Float, lifePath: gamedataLifePath) -> Void {
    let hours: String;
    let minutes: String;
    let hrs: Int32 = RoundF(playTime / 3600.00);
    let mins: Int32 = RoundF((playTime % 3600.00) / 60.00);
    let textParamsRef: ref<inkTextParams> = new inkTextParams();
    textParamsRef.AddNumber("HOURS", hrs);
    textParamsRef.AddNumber("MINUTES", mins);
    hours = hrs > 9 ? "{HOURS}:" : "0{HOURS}:";
    minutes = mins > 9 ? "{MINUTES}" : "0{MINUTES}";
    inkTextRef.SetText(this.m_playTimeRef, hours + minutes);
    inkTextRef.SetTextParameters(this.m_playTimeRef, textParamsRef);
    switch lifePath {
      case gamedataLifePath.Corporate:
        inkTextRef.SetText(this.m_lifePathRef, GetLocalizedText("Gameplay-LifePaths-Corporate"));
        inkImageRef.SetTexturePart(this.m_lifePathIconRef, n"LifepathCorpo");
        break;
      case gamedataLifePath.Nomad:
        inkTextRef.SetText(this.m_lifePathRef, GetLocalizedText("Gameplay-LifePaths-Nomad"));
        inkImageRef.SetTexturePart(this.m_lifePathIconRef, n"LifepathNomad");
        break;
      case gamedataLifePath.StreetKid:
        inkTextRef.SetText(this.m_lifePathRef, GetLocalizedText("Gameplay-LifePaths-Streetkid"));
        inkImageRef.SetTexturePart(this.m_lifePathIconRef, n"LifepathStreetKid");
    };
  }
}

public class SteetCredDataHelper extends IScriptable {

  public final static func GetData() -> [ref<LevelRewardDisplayData>] {
    let data: ref<LevelRewardDisplayData>;
    let dataArray: array<ref<LevelRewardDisplayData>>;
    let i: Int32;
    let records: array<TweakDBID>;
    ArrayPush(records, t"UIMaps.StreetCredMap_Level_5");
    ArrayPush(records, t"UIMaps.StreetCredMap_Level_10");
    ArrayPush(records, t"UIMaps.StreetCredMap_Level_15");
    ArrayPush(records, t"UIMaps.StreetCredMap_Level_20");
    ArrayPush(records, t"UIMaps.StreetCredMap_Level_25");
    ArrayPush(records, t"UIMaps.StreetCredMap_Level_30");
    ArrayPush(records, t"UIMaps.StreetCredMap_Level_35");
    ArrayPush(records, t"UIMaps.StreetCredMap_Level_40");
    ArrayPush(records, t"UIMaps.StreetCredMap_Level_50");
    i = 0;
    while i < ArraySize(records) {
      data = new LevelRewardDisplayData();
      data.level = TweakDBInterface.GetInt(records[i] + t".level", 0);
      data.description = TweakDBInterface.GetString(records[i] + t".desc", "");
      data.icon = TweakDBInterface.GetCName(records[i] + t".icon", n"None");
      ArrayPush(dataArray, data);
      i += 1;
    };
    return dataArray;
  }
}
