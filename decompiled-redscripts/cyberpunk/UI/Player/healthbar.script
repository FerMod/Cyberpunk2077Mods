
public class GodModeStatListener extends ScriptStatsListener {

  public let m_healthbar: wref<healthbarWidgetGameController>;

  public func OnGodModeChanged(ownerID: EntityID, newType: gameGodModeType) -> Void {
    if this.m_healthbar != null {
      this.m_healthbar.UpdateGodModeVisibility();
    };
  }
}

public class HealthbarMemoryStatListener extends ScriptStatsListener {

  public let m_healthbar: wref<healthbarWidgetGameController>;

  public func OnStatChanged(ownerID: StatsObjectID, statType: gamedataStatType, diff: Float, total: Float) -> Void {
    if this.m_healthbar != null {
      this.m_healthbar.UpdateMemoryBarMaxStat(total);
    };
  }
}

public native class healthbarWidgetGameController extends inkHUDGameController {

  private let m_bbPlayerStats: wref<IBlackboard>;

  private let m_bbPlayerEventId: ref<CallbackHandle>;

  private let m_bbMuppetStats: wref<IBlackboard>;

  private let m_bbMuppetEventId: ref<CallbackHandle>;

  private let m_bbRightWeaponInfo: wref<IBlackboard>;

  private let m_bbRightWeaponEventId: ref<CallbackHandle>;

  private let m_bbLeftWeaponInfo: wref<IBlackboard>;

  private let m_bbLeftWeaponEventId: ref<CallbackHandle>;

  private let m_bbAutodrive: wref<IBlackboard>;

  private let m_bbAutodriveEnabledEventId: ref<CallbackHandle>;

  private let m_bbPSceneTierEventId: ref<CallbackHandle>;

  private let m_visionStateBlackboardId: ref<CallbackHandle>;

  private let m_combatModeBlackboardId: ref<CallbackHandle>;

  private let m_bbQuickhacksMemeoryEventId: ref<CallbackHandle>;

  private edit let m_healthBar: inkWidgetRef;

  private edit let m_overshieldBarRef: inkWidgetRef;

  private edit let m_expBar: inkWidgetRef;

  private edit let m_expBarSpacer: inkWidgetRef;

  private edit let m_levelUpArrow: inkWidgetRef;

  private edit let m_levelUpFrame: inkWidgetRef;

  private edit let m_barsLayoutPath: inkCompoundRef;

  private edit let m_buffsHolder: inkCompoundRef;

  private edit let m_invulnerableTextPath: inkTextRef;

  private edit let m_levelTextPath: inkTextRef;

  private edit let m_nextLevelTextPath: inkTextRef;

  private edit let m_healthTextPath: inkTextRef;

  private edit let m_maxHealthTextPath: inkTextRef;

  private edit let m_quickhacksContainer: inkCompoundRef;

  private edit let m_expText: inkTextRef;

  private edit let m_expTextLabel: inkTextRef;

  private edit let m_lostHealthAggregationBar: inkWidgetRef;

  private edit let m_levelUpRectangle: inkWidgetRef;

  private edit let m_damegePreview: inkWidgetRef;

  private edit let m_fullBar: inkWidgetRef;

  private let m_healthController: wref<NameplateBarLogicController>;

  private let m_armorController: wref<ProgressBarSimpleWidgetLogicController>;

  private let m_RootWidget: wref<inkWidget>;

  private let m_buffWidget: wref<inkWidget>;

  private let m_invulnerableText: wref<inkText>;

  private let m_animHideTemp: ref<inkAnimDef>;

  private let m_animShortFade: ref<inkAnimDef>;

  private let m_animLongFade: ref<inkAnimDef>;

  private let m_animHideHPProxy: ref<inkAnimProxy>;

  public let delayAnimation: ref<inkAnimDef>;

  public let animCreated: Bool;

  public let aggregatingActive: Bool;

  public let countingStartHealth: Int32;

  private let m_currentHealth: Int32;

  private let m_previousHealth: Int32;

  private let m_maximumHealth: Int32;

  private let m_quickhacksMemoryPercent: Float;

  @default(healthbarWidgetGameController, 0)
  private let m_currentArmor: Int32;

  @default(healthbarWidgetGameController, 0)
  private let m_maximumArmor: Int32;

  private let m_quickhackBarArray: [wref<inkWidget>];

  private let m_spawnedMemoryCells: Int32;

  private let m_usedQuickhacks: Int32;

  private let m_buffsVisible: Bool;

  @default(healthbarWidgetGameController, true)
  private let m_isUnarmedRightHand: Bool;

  @default(healthbarWidgetGameController, true)
  private let m_isUnarmedLeftHand: Bool;

  private let m_isAutodriveEnabled: Bool;

  private let m_isControllingDevice: Bool;

  private let m_currentVisionPSM: gamePSMVision;

  private let m_combatModePSM: gamePSMCombat;

  private let m_sceneTier: GameplayTier;

  private let m_godModeStatListener: ref<GodModeStatListener>;

  private let m_memoryStatListener: ref<HealthbarMemoryStatListener>;

  private let m_playerStatsBlackboard: wref<IBlackboard>;

  private let characterCurrentXPListener: ref<CallbackHandle>;

  private let m_levelUpBlackboard: wref<IBlackboard>;

  private let playerLevelUpListener: ref<CallbackHandle>;

  private let m_currentLevel: Int32;

  private let m_playerObject: wref<GameObject>;

  private let m_playerDevelopmentSystem: ref<PlayerDevelopmentSystem>;

  private let m_gameInstance: GameInstance;

  private let m_foldingAnimProxy: ref<inkAnimProxy>;

  private let m_memoryFillCells: Float;

  private let m_memoryMaxCells: Int32;

  private let m_pendingRequests: Int32;

  private let m_spawnTokens: [wref<inkAsyncSpawnRequest>];

  private let m_overshieldListener: ref<OvershieldListener>;

  private let m_overshieldBarController: wref<NameplateBarLogicController>;

  private let m_useOevershield: Bool;

  @default(healthbarWidgetGameController, 0)
  private let m_currentOvershieldValue: Int32;

  @default(healthbarWidgetGameController, 0.f)
  private let m_currentOvershieldValuePercent: Float;

  private let m_overclockListener: ref<OverclockListener>;

  @default(healthbarWidgetGameController, false)
  private let m_isInOverclockedState: Bool;

  private let m_pulseBar: ref<PulseAnimation>;

  private let m_pulseText: ref<PulseAnimation>;

  private let m_pulse: ref<PulseAnimation>;

  private let m_healthMemoryJumpAnim: ref<inkAnimProxy>;

  private let m_healthMemoryFlashAnim: ref<inkAnimProxy>;

  public final native func RequestHealthBarVisibilityUpdate() -> Void;

  protected cb func OnInitialize() -> Bool {
    let requestStatsEvent: ref<RequestStatsBB>;
    this.m_playerObject = this.GetOwnerEntity() as GameObject;
    this.m_RootWidget = this.GetRootWidget();
    this.m_buffWidget = this.SpawnFromExternal(inkWidgetRef.Get(this.m_buffsHolder), r"base\\gameplay\\gui\\widgets\\healthbar\\playerbuffbar.inkwidget", n"VertRoot");
    this.m_currentHealth = CeilF(GameInstance.GetStatPoolsSystem(this.m_playerObject.GetGame()).GetStatPoolValue(Cast<StatsObjectID>(GetPlayer(this.m_playerObject.GetGame()).GetEntityID()), gamedataStatPoolType.Health, false));
    this.m_playerDevelopmentSystem = GameInstance.GetScriptableSystemsContainer(this.m_playerObject.GetGame()).Get(n"PlayerDevelopmentSystem") as PlayerDevelopmentSystem;
    this.m_useOevershield = PlayerDevelopmentSystem.GetData(this.m_playerObject).IsNewPerkBoughtAnyLevel(gamedataNewPerkType.Body_Central_Milestone_3);
    this.m_overshieldBarController = inkWidgetRef.GetController(this.m_overshieldBarRef) as NameplateBarLogicController;
    this.m_healthController = inkWidgetRef.GetController(this.m_healthBar) as NameplateBarLogicController;
    this.m_bbPlayerStats = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_PlayerBioMonitor);
    this.m_bbPlayerEventId = this.m_bbPlayerStats.RegisterListenerVariant(GetAllBlackboardDefs().UI_PlayerBioMonitor.PlayerStatsInfo, this, n"OnStatsChanged");
    if this.IsPlayingMultiplayer() {
      this.m_bbMuppetStats = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UIGameData);
      this.m_bbMuppetEventId = this.m_bbMuppetStats.RegisterListenerVariant(GetAllBlackboardDefs().UIGameData.MuppetStats, this, n"OnMuppetUpdate");
    };
    this.m_bbPlayerStats.SignalVariant(GetAllBlackboardDefs().UI_PlayerBioMonitor.PlayerStatsInfo);
    this.m_bbQuickhacksMemeoryEventId = this.m_bbPlayerStats.RegisterDelayedListenerFloat(GetAllBlackboardDefs().UI_PlayerBioMonitor.MemoryPercent, this, n"OnQuickhacksMemoryPercentUpdate");
    this.m_bbRightWeaponInfo = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UIGameData);
    this.m_bbRightWeaponEventId = this.m_bbRightWeaponInfo.RegisterListenerVariant(GetAllBlackboardDefs().UIGameData.RightWeaponRecordID, this, n"OnRightWeaponSwap");
    this.m_bbLeftWeaponInfo = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UIGameData);
    this.m_bbLeftWeaponEventId = this.m_bbLeftWeaponInfo.RegisterListenerVariant(GetAllBlackboardDefs().UIGameData.LeftWeaponRecordID, this, n"OnLeftWeaponSwap");
    this.m_bbAutodrive = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_AutodriveData);
    this.m_bbAutodriveEnabledEventId = this.m_bbAutodrive.RegisterListenerBool(GetAllBlackboardDefs().UI_AutodriveData.AutoDriveEnabled, this, n"OnAutodriveEnabled");
    this.m_bbAutodrive.SignalBool(GetAllBlackboardDefs().UI_AutodriveData.AutoDriveEnabled);
    this.m_playerStatsBlackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_PlayerStats);
    this.characterCurrentXPListener = this.m_playerStatsBlackboard.RegisterListenerInt(GetAllBlackboardDefs().UI_PlayerStats.CurrentXP, this, n"OnCharacterLevelCurrentXPUpdated");
    this.m_playerStatsBlackboard.SignalInt(GetAllBlackboardDefs().UI_PlayerStats.CurrentXP);
    this.AnimateCharacterLevelUpdated(this.m_playerStatsBlackboard.GetInt(GetAllBlackboardDefs().UI_PlayerStats.Level), true);
    this.m_levelUpBlackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_PlayerStats);
    this.playerLevelUpListener = this.m_levelUpBlackboard.RegisterDelayedListenerInt(GetAllBlackboardDefs().UI_PlayerStats.Level, this, n"OnCharacterLevelUpdated");
    this.m_levelUpBlackboard.SignalInt(GetAllBlackboardDefs().UI_PlayerStats.Level);
    this.CreateAnimations();
    this.OnUpdateHealthBarVisibility();
    this.SetupQuickhacksMemoryBar();
    requestStatsEvent = new RequestStatsBB();
    requestStatsEvent.Set(this.m_playerObject);
    this.m_playerDevelopmentSystem.QueueRequest(requestStatsEvent);
    this.m_gameInstance = this.GetPlayerControlledObject().GetGame();
    this.m_pulseBar = new PulseAnimation();
    this.m_pulseText = new PulseAnimation();
    this.m_pulse = new PulseAnimation();
    this.m_pulseBar.Configure(inkWidgetRef.Get(this.m_damegePreview), 1.00, 0.80, 0.30);
    this.m_pulseText.Configure(inkWidgetRef.Get(this.m_maxHealthTextPath), 1.00, 0.10, 0.30);
    this.m_pulse.Configure(inkWidgetRef.Get(this.m_healthBar), 1.00, 0.50, 0.60);
    inkWidgetRef.SetVisible(this.m_damegePreview, false);
  }

  protected cb func OnUninitialize() -> Bool {
    if IsDefined(this.m_bbPlayerStats) {
      this.m_bbPlayerStats.UnregisterListenerVariant(GetAllBlackboardDefs().UI_PlayerBioMonitor.PlayerStatsInfo, this.m_bbPlayerEventId);
      this.m_bbPlayerStats.UnregisterDelayedListener(GetAllBlackboardDefs().UI_PlayerBioMonitor.MemoryPercent, this.m_bbQuickhacksMemeoryEventId);
    };
    if this.IsPlayingMultiplayer() && IsDefined(this.m_bbMuppetStats) {
      this.m_bbMuppetStats.UnregisterListenerVariant(GetAllBlackboardDefs().UIGameData.MuppetStats, this.m_bbMuppetEventId);
    };
    if IsDefined(this.m_bbRightWeaponInfo) {
      this.m_bbRightWeaponInfo.UnregisterListenerVariant(GetAllBlackboardDefs().UIGameData.RightWeaponRecordID, this.m_bbRightWeaponEventId);
    };
    if IsDefined(this.m_bbLeftWeaponInfo) {
      this.m_bbLeftWeaponInfo.UnregisterListenerVariant(GetAllBlackboardDefs().UIGameData.LeftWeaponRecordID, this.m_bbLeftWeaponEventId);
    };
    if IsDefined(this.m_bbAutodrive) {
      this.m_bbAutodrive.UnregisterListenerBool(GetAllBlackboardDefs().UI_AutodriveData.AutoDriveEnabled, this.m_bbAutodriveEnabledEventId);
    };
    if IsDefined(this.m_playerStatsBlackboard) {
      this.m_playerStatsBlackboard.UnregisterListenerInt(GetAllBlackboardDefs().UI_PlayerStats.CurrentXP, this.characterCurrentXPListener);
    };
  }

  protected cb func OnPlayerAttach(playerGameObject: ref<GameObject>) -> Bool {
    let controlledPuppet: wref<gamePuppetBase>;
    let controlledPuppetRecordID: TweakDBID;
    let isOverclockActivated: Bool;
    this.RegisterPSMListeners(playerGameObject);
    this.m_playerObject = playerGameObject;
    if IsDefined(this.m_foldingAnimProxy) {
      this.m_foldingAnimProxy.Stop();
    };
    this.m_foldingAnimProxy = this.PlayLibraryAnimation(n"unfold");
    controlledPuppet = GetPlayer(this.m_gameInstance);
    if controlledPuppet != null {
      controlledPuppetRecordID = controlledPuppet.GetRecordID();
      if controlledPuppetRecordID == t"Character.johnny_replacer" {
        inkWidgetRef.SetVisible(this.m_levelUpRectangle, false);
      } else {
        inkWidgetRef.SetVisible(this.m_levelUpRectangle, true);
        this.m_overshieldListener = new OvershieldListener();
        this.m_overshieldListener.BindHelathBar(this);
        GameInstance.GetStatPoolsSystem(playerGameObject.GetGame()).RequestRegisteringListener(Cast<StatsObjectID>(playerGameObject.GetEntityID()), gamedataStatPoolType.Overshield, this.m_overshieldListener);
        this.EvaluateOvershieldBarVisibility();
        this.m_overclockListener = new OverclockListener();
        this.m_overclockListener.BindHelathBar(this);
        GameInstance.GetStatusEffectSystem(playerGameObject.GetGame()).RegisterListener(playerGameObject.GetEntityID(), this.m_overclockListener);
        isOverclockActivated = QuickHackableHelper.IsOverclockedStateActive(playerGameObject);
        if isOverclockActivated {
          this.GetRootWidget().SetVisible(true);
          this.EvaluateHealthBarVisibility(true);
        };
      };
    } else {
      inkWidgetRef.SetVisible(this.m_levelUpRectangle, true);
    };
  }

  protected cb func OnPlayerDetach(playerGameObject: ref<GameObject>) -> Bool {
    this.UnregisterPSMListeners(playerGameObject);
    if IsDefined(this.m_foldingAnimProxy) {
      this.m_foldingAnimProxy.Stop();
    };
    if IsDefined(this.m_overshieldListener) {
      GameInstance.GetStatPoolsSystem(playerGameObject.GetGame()).RequestUnregisteringListener(Cast<StatsObjectID>(playerGameObject.GetEntityID()), gamedataStatPoolType.Overshield, this.m_overshieldListener);
      this.m_overshieldListener = null;
    };
    if IsDefined(this.m_overclockListener) {
      this.m_overclockListener = null;
    };
    this.m_foldingAnimProxy = this.PlayLibraryAnimation(n"fold");
  }

  protected final func RegisterPSMListeners(playerObject: ref<GameObject>) -> Void {
    let playerStateMachineBlackboard: ref<IBlackboard>;
    let playerSMDef: ref<PlayerStateMachineDef> = GetAllBlackboardDefs().PlayerStateMachine;
    if IsDefined(playerSMDef) {
      playerStateMachineBlackboard = this.GetPSMBlackboard(playerObject);
      if IsDefined(playerStateMachineBlackboard) {
        this.m_visionStateBlackboardId = playerStateMachineBlackboard.RegisterListenerInt(playerSMDef.Vision, this, n"OnPSMVisionStateChanged");
        this.m_bbPSceneTierEventId = playerStateMachineBlackboard.RegisterListenerInt(playerSMDef.SceneTier, this, n"OnSceneTierChange");
        this.m_combatModeBlackboardId = playerStateMachineBlackboard.RegisterListenerInt(playerSMDef.Combat, this, n"OnCombatStateChanged");
        this.m_isControllingDevice = playerStateMachineBlackboard.GetBool(playerSMDef.IsControllingDevice);
        if this.m_isControllingDevice {
          this.GetRootWidget().SetVisible(false);
        };
      };
      this.m_godModeStatListener = new GodModeStatListener();
      this.m_godModeStatListener.m_healthbar = this;
      GameInstance.GetStatsSystem(playerObject.GetGame()).RegisterListener(Cast<StatsObjectID>(playerObject.GetEntityID()), this.m_godModeStatListener);
      this.m_memoryStatListener = new HealthbarMemoryStatListener();
      this.m_memoryStatListener.m_healthbar = this;
      this.m_memoryStatListener.SetStatType(gamedataStatType.Memory);
      GameInstance.GetStatsSystem(playerObject.GetGame()).RegisterListener(Cast<StatsObjectID>(playerObject.GetEntityID()), this.m_memoryStatListener);
    };
  }

  protected final func UnregisterPSMListeners(playerObject: ref<GameObject>) -> Void {
    let playerStateMachineBlackboard: ref<IBlackboard>;
    let playerSMDef: ref<PlayerStateMachineDef> = GetAllBlackboardDefs().PlayerStateMachine;
    if IsDefined(playerSMDef) {
      playerStateMachineBlackboard = this.GetPSMBlackboard(playerObject);
      if IsDefined(playerStateMachineBlackboard) {
        playerStateMachineBlackboard.UnregisterDelayedListener(playerSMDef.Vision, this.m_visionStateBlackboardId);
        playerStateMachineBlackboard.UnregisterDelayedListener(playerSMDef.SceneTier, this.m_bbPSceneTierEventId);
        playerStateMachineBlackboard.UnregisterDelayedListener(playerSMDef.Combat, this.m_combatModeBlackboardId);
        GameInstance.GetStatsSystem(playerObject.GetGame()).UnregisterListener(Cast<StatsObjectID>(playerObject.GetEntityID()), this.m_godModeStatListener);
        this.m_godModeStatListener = null;
        GameInstance.GetStatsSystem(playerObject.GetGame()).UnregisterListener(Cast<StatsObjectID>(playerObject.GetEntityID()), this.m_memoryStatListener);
        this.m_memoryStatListener = null;
      };
    };
  }

  private final func StartDamageFallDelay() -> Void {
    let delayInterpolator: ref<inkAnimScale>;
    let delayProxy: ref<inkAnimProxy>;
    let selfSize: Vector2;
    let size: Vector2;
    let width: Float;
    if !IsDefined(this.delayAnimation) {
      this.delayAnimation = new inkAnimDef();
      delayInterpolator = new inkAnimScale();
      delayInterpolator.SetStartDelay(1.00);
      delayInterpolator.SetDuration(0.00);
      delayInterpolator.SetDirection(inkanimInterpolationDirection.From);
      delayInterpolator.SetType(inkanimInterpolationType.Linear);
      delayInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
      delayInterpolator.SetStartScale(new Vector2(1.00, 1.00));
      this.delayAnimation.AddInterpolator(delayInterpolator);
    };
    if !this.aggregatingActive {
      delayProxy = inkWidgetRef.PlayAnimation(this.m_expText, this.delayAnimation);
      delayProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnDamageAggregationFinished");
      this.aggregatingActive = true;
      this.countingStartHealth = this.m_previousHealth;
      inkWidgetRef.SetScale(this.m_lostHealthAggregationBar, new Vector2(1.00, 1.00));
    };
    size = this.m_healthController.GetFullSize();
    selfSize = inkWidgetRef.GetSize(this.m_lostHealthAggregationBar);
    width = Cast<Float>(this.countingStartHealth - this.m_currentHealth) / Cast<Float>(this.m_maximumHealth) * size.X;
    inkWidgetRef.SetSize(this.m_lostHealthAggregationBar, new Vector2(width, selfSize.Y));
  }

  protected cb func OnDamageAggregationFinished(anim: ref<inkAnimProxy>) -> Bool {
    this.aggregatingActive = false;
    this.PlayLibraryAnimation(n"hide_delay_bar");
  }

  private final func SetHealthProgress(value: Float) -> Void {
    value = ClampF(value, 0.01, 1.00);
    this.m_healthController.SetNameplateBarProgress(value, this.m_previousHealth == this.m_currentHealth);
    this.UpdateCurrentHealthText();
    if this.m_previousHealth > this.m_currentHealth {
      this.StartDamageFallDelay();
    };
  }

  private final func UpdateCurrentHealthText() -> Void {
    inkWidgetRef.SetState(this.m_healthTextPath, this.m_currentOvershieldValue > 0 ? n"Overshield" : n"Default");
    inkTextRef.SetText(this.m_healthTextPath, IntToString(this.m_currentHealth + this.m_currentOvershieldValue));
  }

  protected cb func OnCharacterLevelUpdated(value: Int32) -> Bool {
    this.AnimateCharacterLevelUpdated(value);
  }

  private final func AnimateCharacterLevelUpdated(value: Int32, opt skipAnimation: Bool) -> Void {
    let levelUpProxy: ref<inkAnimProxy>;
    if this.m_currentLevel != value {
      this.m_currentLevel = value;
      inkTextRef.SetText(this.m_nextLevelTextPath, IntToString(this.m_currentLevel));
      if !skipAnimation {
        levelUpProxy = this.PlayLibraryAnimation(n"levelup_animation");
        levelUpProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnLevelUpAnimationFinished");
      } else {
        inkWidgetRef.SetOpacity(this.m_levelUpArrow, 0.00);
        inkWidgetRef.SetOpacity(this.m_levelUpFrame, 0.00);
        this.OnLevelUpAnimationFinished(levelUpProxy);
      };
      this.RequestHealthBarVisibilityUpdate();
    };
  }

  protected cb func OnLevelUpAnimationFinished(anim: ref<inkAnimProxy>) -> Bool {
    inkTextRef.SetText(this.m_levelTextPath, IntToString(this.m_currentLevel));
    this.RequestHealthBarVisibilityUpdate();
  }

  protected cb func OnCharacterLevelCurrentXPUpdated(value: Int32) -> Bool {
    let remainingXP: Int32 = this.m_playerDevelopmentSystem.GetRemainingExpForLevelUp(this.m_playerObject, gamedataProficiencyType.Level);
    let expSum: Int32 = remainingXP + value;
    let progressFloat: Float = Cast<Float>(value) / Cast<Float>(expSum);
    inkTextRef.SetText(this.m_expText, IntToString(value));
    inkTextRef.SetText(this.m_expTextLabel, "LocKey#23263");
    inkWidgetRef.SetSizeCoefficient(this.m_expBar, progressFloat);
    inkWidgetRef.SetSizeCoefficient(this.m_expBarSpacer, 1.00 - progressFloat);
  }

  private final func AdjustRequest() -> Void;

  private final func SetupQuickhacksMemoryBar() -> Void {
    inkCompoundRef.RemoveAllChildren(this.m_quickhacksContainer);
    this.m_spawnedMemoryCells = 0;
    this.m_memoryMaxCells = FloorF(GameInstance.GetStatsSystem((this.GetOwnerEntity() as PlayerPuppet).GetGame()).GetStatValue(Cast<StatsObjectID>(this.GetPlayerControlledObject().GetEntityID()), gamedataStatType.Memory));
    this.m_memoryFillCells = Cast<Float>(this.m_memoryMaxCells);
    this.UpdateQuickhacksMemoryBarSize(this.m_memoryMaxCells);
  }

  private final func UpdateQuickhacksMemoryBarSize(size: Int32) -> Void {
    let i: Int32;
    let requestToken: wref<inkAsyncSpawnRequest>;
    if size > this.m_spawnedMemoryCells {
      i = this.m_spawnedMemoryCells + this.m_pendingRequests;
      while i < size {
        requestToken = this.AsyncSpawnFromLocal(inkWidgetRef.Get(this.m_quickhacksContainer), n"quickhackBar", this, n"OnMemoryBarSpawned");
        ArrayPush(this.m_spawnTokens, requestToken);
        this.m_pendingRequests += 1;
        i += 1;
      };
    } else {
      this.UpdateMemoryBarData();
    };
  }

  protected cb func OnMuppetUpdate(value: Variant) -> Bool {
    let incomingData: PlayerBioMonitor = FromVariant<PlayerBioMonitor>(value);
    this.m_previousHealth = this.m_currentHealth;
    this.m_maximumHealth = incomingData.maximumHealth;
    this.m_currentHealth = incomingData.currentHealth;
    this.m_currentHealth = Clamp(this.m_currentHealth, 0, this.m_maximumHealth);
    this.m_currentArmor = incomingData.currentArmor;
    this.m_maximumArmor = incomingData.maximumArmor;
    this.SetHealthProgress(Cast<Float>(this.m_currentHealth) / Cast<Float>(this.m_maximumHealth));
    this.SetArmorProgress(Cast<Float>(this.m_currentArmor) / Cast<Float>(this.m_maximumArmor), false);
    this.RequestHealthBarVisibilityUpdate();
  }

  protected cb func OnMemoryBarSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
    this.m_spawnedMemoryCells += 1;
    this.m_pendingRequests -= 1;
    ArrayPush(this.m_quickhackBarArray, widget);
    if this.m_pendingRequests <= 0 {
      ArrayClear(this.m_spawnTokens);
      this.UpdateMemoryBarData();
    };
  }

  private final func UpdateMemoryBarData() -> Void {
    let quickhackBar: wref<inkWidget>;
    let quickhackBarController: wref<QuickhackBarController>;
    let fillCellsInt: Int32 = FloorF(this.m_memoryFillCells);
    let i: Int32 = 0;
    while i < ArraySize(this.m_quickhackBarArray) {
      if i >= this.m_memoryMaxCells {
        this.m_quickhackBarArray[i].SetVisible(false);
      } else {
        quickhackBar = this.m_quickhackBarArray[i];
        quickhackBarController = quickhackBar.GetController() as QuickhackBarController;
        if fillCellsInt < this.m_memoryMaxCells {
          if i < fillCellsInt {
            quickhackBarController.SetStatus(1.00);
          } else {
            if i == fillCellsInt {
              quickhackBarController.SetStatus(this.m_memoryFillCells - Cast<Float>(fillCellsInt));
            } else {
              quickhackBarController.SetStatus(0.00);
            };
          };
        } else {
          quickhackBarController.SetStatus(1.00);
        };
        quickhackBar.SetVisible(true);
      };
      i += 1;
    };
    this.RequestHealthBarVisibilityUpdate();
  }

  protected cb func OnQuickhacksMemoryPercentUpdate(value: Float) -> Bool {
    this.m_memoryMaxCells = FloorF(GameInstance.GetStatsSystem((this.GetOwnerEntity() as PlayerPuppet).GetGame()).GetStatValue(Cast<StatsObjectID>(this.GetPlayerControlledObject().GetEntityID()), gamedataStatType.Memory));
    this.m_memoryFillCells = Cast<Float>(this.m_memoryMaxCells) * value * 0.01;
    this.m_usedQuickhacks = this.m_memoryMaxCells - FloorF(this.m_memoryFillCells);
    this.m_quickhacksMemoryPercent = value;
    this.UpdateQuickhacksMemoryBarSize(this.m_memoryMaxCells);
  }

  public final func UpdateMemoryBarMaxStat(maxBars: Float) -> Void {
    this.m_memoryMaxCells = FloorF(maxBars);
    let currentValue: Float = GameInstance.GetStatPoolsSystem((this.GetOwnerEntity() as PlayerPuppet).GetGame()).GetStatPoolValue(Cast<StatsObjectID>(this.GetPlayerControlledObject().GetEntityID()), gamedataStatPoolType.Memory);
    this.m_memoryFillCells = Cast<Float>(this.m_memoryMaxCells) * currentValue * 0.01;
    this.m_usedQuickhacks = this.m_memoryMaxCells - FloorF(this.m_memoryFillCells);
    this.m_quickhacksMemoryPercent = currentValue;
    this.UpdateQuickhacksMemoryBarSize(this.m_memoryMaxCells);
  }

  private final func IsCyberdeckEquipped() -> Bool {
    let itemTags: array<CName>;
    let systemReplacementID: ItemID = EquipmentSystem.GetData(this.GetPlayerControlledObject()).GetActiveItem(gamedataEquipmentArea.SystemReplacementCW);
    let itemRecord: wref<Item_Record> = RPGManager.GetItemRecord(systemReplacementID);
    if IsDefined(itemRecord) {
      itemTags = itemRecord.Tags();
    };
    return ArrayContains(itemTags, n"Cyberdeck");
  }

  private final func SetArmorProgress(normalizedValue: Float, silent: Bool) -> Void;

  protected cb func OnStatsChanged(value: Variant) -> Bool {
    let incomingData: PlayerBioMonitor = FromVariant<PlayerBioMonitor>(value);
    this.m_previousHealth = this.m_currentHealth;
    this.m_maximumHealth = CeilF(GameInstance.GetStatsSystem(this.m_playerObject.GetGame()).GetStatValue(Cast<StatsObjectID>(GetPlayer(this.m_playerObject.GetGame()).GetEntityID()), gamedataStatType.Health));
    this.m_currentHealth = CeilF(GameInstance.GetStatPoolsSystem(this.m_playerObject.GetGame()).GetStatPoolValue(Cast<StatsObjectID>(GetPlayer(this.m_playerObject.GetGame()).GetEntityID()), gamedataStatPoolType.Health, false));
    this.m_currentHealth = Clamp(this.m_currentHealth, 0, this.m_maximumHealth);
    this.m_currentArmor = incomingData.currentArmor;
    this.m_maximumArmor = incomingData.maximumArmor;
    this.SetHealthProgress(Cast<Float>(this.m_currentHealth) / Cast<Float>(this.m_maximumHealth));
    this.SetArmorProgress(Cast<Float>(this.m_currentArmor) / Cast<Float>(this.m_maximumArmor), false);
    this.RequestHealthBarVisibilityUpdate();
  }

  protected cb func OnRightWeaponSwap(value: Variant) -> Bool {
    this.m_isUnarmedRightHand = FromVariant<TweakDBID>(value) == TDBID.None();
    this.RequestHealthBarVisibilityUpdate();
  }

  protected cb func OnLeftWeaponSwap(value: Variant) -> Bool {
    this.m_isUnarmedLeftHand = FromVariant<TweakDBID>(value) == TDBID.None();
    this.RequestHealthBarVisibilityUpdate();
  }

  protected cb func OnAutodriveEnabled(enabled: Bool) -> Bool {
    this.m_isAutodriveEnabled = enabled;
    this.RequestHealthBarVisibilityUpdate();
  }

  private final const func IsUnarmed() -> Bool {
    return this.m_isUnarmedRightHand && this.m_isUnarmedLeftHand;
  }

  public final func UpdateGodModeVisibility() -> Void {
    inkWidgetRef.SetVisible(this.m_invulnerableTextPath, this.HelperHasGodMode());
  }

  private final func ShowOverclockedHealthbar() -> Void {
    if this.m_isInOverclockedState {
      this.GetRootWidget().SetState(n"Overclocked");
      this.m_pulse.Start();
      inkWidgetRef.Get(this.m_fullBar).SetEffectEnabled(inkEffectType.ScanlineWipe, n"ScanlineWipe_0", true);
      inkWidgetRef.SetOpacity(this.m_levelUpArrow, 0.00);
      inkWidgetRef.SetOpacity(this.m_levelUpFrame, 0.00);
    };
  }

  protected cb func OnOverclockDamagePreview(e: ref<OverclockDamagePreview>) -> Bool {
    let animOptions: inkAnimOptions;
    let fullBarSize: Vector2;
    let healthCost: Float;
    if e.IsHovering {
      animOptions.loopInfinite = true;
      animOptions.loopType = inkanimLoopType.Cycle;
      this.m_healthMemoryJumpAnim = this.PlayLibraryAnimation(n"memorySelected", animOptions);
      this.m_pulse.Stop();
      this.m_pulseBar.Start();
      this.m_pulseText.Start();
      QuickHackableHelper.CanPayWithHealthInOverclockedState(this.m_playerObject, e.MemoryCost, healthCost);
      inkTextRef.SetText(this.m_maxHealthTextPath, "-" + IntToString(Cast<Int32>(healthCost)));
      inkWidgetRef.SetVisible(this.m_maxHealthTextPath, true);
      healthCost = healthCost / Cast<Float>(this.m_currentHealth);
      fullBarSize = inkWidgetRef.GetSize(this.m_fullBar);
      inkWidgetRef.SetSize(this.m_damegePreview, new Vector2(healthCost * fullBarSize.X, fullBarSize.Y + 6.00));
      inkWidgetRef.SetVisible(this.m_damegePreview, true);
    } else {
      this.m_healthMemoryJumpAnim.Stop();
      this.m_pulseBar.Stop();
      this.m_pulseText.Stop();
      this.m_pulse.Start();
      inkWidgetRef.SetVisible(this.m_damegePreview, false);
      inkWidgetRef.SetVisible(this.m_maxHealthTextPath, false);
    };
    if e.JustHacked {
      if this.m_healthMemoryFlashAnim.IsPlaying() {
        this.m_healthMemoryFlashAnim.GotoStartAndStop();
      };
      this.m_healthMemoryFlashAnim = this.PlayLibraryAnimation(n"overclock_use");
    };
  }

  protected cb func OnUpdateHealthBarVisibility() -> Bool {
    let isMaxHP: Bool = this.m_currentHealth == this.m_maximumHealth;
    let areQuickhacksUsed: Bool = this.m_usedQuickhacks > 0;
    this.UpdateGodModeVisibility();
    inkWidgetRef.SetVisible(this.m_quickhacksContainer, this.IsCyberdeckEquipped());
    if this.m_isAutodriveEnabled {
      this.HideRequest();
      return true;
    };
    if !this.m_isInOverclockedState {
      inkWidgetRef.Get(this.m_fullBar).SetEffectEnabled(inkEffectType.ScanlineWipe, n"ScanlineWipe_0", false);
      this.GetRootWidget().SetState(n"Default");
      this.m_healthMemoryJumpAnim.Stop();
      this.m_pulseBar.Stop();
      this.m_pulseText.Stop();
      this.m_pulse.Stop();
      if NotEquals(this.m_currentVisionPSM, gamePSMVision.Default) || this.m_isControllingDevice {
        this.HideRequest();
        return true;
      };
    };
    if !isMaxHP || areQuickhacksUsed || Equals(this.m_combatModePSM, gamePSMCombat.InCombat) || this.m_quickhacksMemoryPercent < 100.00 || this.m_buffsVisible || this.m_isInOverclockedState {
      this.ShowRequest();
    } else {
      this.HideRequest();
    };
  }

  private final func HelperHasGodMode() -> Bool {
    let playerObject: ref<GameObject> = this.GetOwnerEntity() as GameObject;
    let godMode: ref<GodModeSystem> = GameInstance.GetGodModeSystem(playerObject.GetGame());
    return godMode.HasGodMode(playerObject.GetEntityID(), gameGodModeType.Invulnerable);
  }

  private final func CreateAnimations() -> Void {
    let animStartDelay: Float = 1.00;
    this.m_animShortFade = new inkAnimDef();
    let fadeInterp: ref<inkAnimTransparency> = new inkAnimTransparency();
    fadeInterp.SetStartDelay(2.00);
    fadeInterp.SetStartTransparency(1.00);
    fadeInterp.SetEndTransparency(0.00);
    fadeInterp.SetDuration(0.35);
    this.m_animShortFade.AddInterpolator(fadeInterp);
    this.m_animLongFade = new inkAnimDef();
    fadeInterp = new inkAnimTransparency();
    fadeInterp.SetStartDelay(10.00);
    fadeInterp.SetStartTransparency(1.00);
    fadeInterp.SetEndTransparency(0.00);
    fadeInterp.SetDuration(0.35);
    this.m_animLongFade.AddInterpolator(fadeInterp);
    this.m_animHideTemp = new inkAnimDef();
    fadeInterp = new inkAnimTransparency();
    fadeInterp.SetStartDelay(animStartDelay + 0.26);
    fadeInterp.SetStartTransparency(1.00);
    fadeInterp.SetEndTransparency(0.00);
    fadeInterp.SetDuration(0.22);
    this.m_animHideTemp.AddInterpolator(fadeInterp);
  }

  public final func UpdateOvershieldValue(newValue: Float, percToPoints: Float) -> Void {
    this.m_currentOvershieldValue = RoundF(newValue * percToPoints);
    this.UpdateCurrentHealthText();
    this.m_currentOvershieldValuePercent = Cast<Float>(this.m_currentOvershieldValue) / Cast<Float>(this.m_maximumHealth);
    this.m_overshieldBarController.SetNameplateBarProgress(this.m_currentOvershieldValuePercent, false);
  }

  public final func EvaluateOvershieldBarVisibility() -> Void {
    this.m_useOevershield = PlayerDevelopmentSystem.GetData(this.m_playerObject).IsNewPerkBoughtAnyLevel(gamedataNewPerkType.Body_Central_Milestone_3);
    if !this.m_useOevershield {
      this.m_currentOvershieldValue = 0;
      this.m_currentOvershieldValuePercent = 0.00;
    };
    inkWidgetRef.SetVisible(this.m_overshieldBarRef, this.m_useOevershield && this.m_currentOvershieldValuePercent > 0.00);
  }

  public final func EvaluateHealthBarVisibility(isInOverclockedState: Bool) -> Void {
    let blackboard: ref<IBlackboard>;
    if IsDefined(this.m_playerObject) {
      blackboard = GameInstance.GetBlackboardSystem(this.m_playerObject.GetGame()).Get(GetAllBlackboardDefs().UI_QuickSlotsData);
      if IsDefined(blackboard) {
        this.m_isInOverclockedState = isInOverclockedState;
        blackboard.SetBool(GetAllBlackboardDefs().UI_QuickSlotsData.quickhackPanelKeepContext, isInOverclockedState);
      };
    };
    this.ShowOverclockedHealthbar();
    this.RequestHealthBarVisibilityUpdate();
  }

  protected cb func OnCombatStateChanged(value: Int32) -> Bool {
    this.m_combatModePSM = IntEnum<gamePSMCombat>(value);
    this.RequestHealthBarVisibilityUpdate();
  }

  protected cb func OnPSMVisionStateChanged(value: Int32) -> Bool {
    this.m_currentVisionPSM = IntEnum<gamePSMVision>(value);
    this.RequestHealthBarVisibilityUpdate();
  }

  protected cb func OnSceneTierChange(argTier: Int32) -> Bool {
    this.m_sceneTier = IntEnum<GameplayTier>(argTier);
    this.RequestHealthBarVisibilityUpdate();
  }

  protected cb func OnBuffListVisibilityChanged(evt: ref<BuffListVisibilityChangedEvent>) -> Bool {
    this.m_buffsVisible = evt.m_hasBuffs;
    this.RequestHealthBarVisibilityUpdate();
  }

  protected cb func OnForceHide() -> Bool {
    this.RequestHealthBarVisibilityUpdate();
  }

  protected cb func OnForceTierVisibility(tierVisibility: Bool) -> Bool {
    this.RequestHealthBarVisibilityUpdate();
  }
}

public class QuickhackBarController extends inkLogicController {

  private edit let m_emptyMask: inkWidgetRef;

  private edit let m_empty: inkWidgetRef;

  private edit let m_full: inkWidgetRef;

  public final func SetStatus(value: Float) -> Void {
    if value <= 0.00 {
      inkWidgetRef.SetVisible(this.m_full, false);
      inkWidgetRef.SetVisible(this.m_empty, true);
      inkWidgetRef.SetScale(this.m_emptyMask, new Vector2(1.00, 1.00));
    } else {
      if value >= 1.00 {
        inkWidgetRef.SetVisible(this.m_empty, false);
        inkWidgetRef.SetVisible(this.m_full, true);
      } else {
        inkWidgetRef.SetVisible(this.m_full, true);
        inkWidgetRef.SetVisible(this.m_empty, true);
        inkWidgetRef.SetScale(this.m_emptyMask, new Vector2(1.00, 1.00 - value));
      };
    };
  }
}

public class OvershieldListener extends ScriptStatPoolsListener {

  private let m_healthBar: wref<healthbarWidgetGameController>;

  public final func BindHelathBar(bar: wref<healthbarWidgetGameController>) -> Void {
    this.m_healthBar = bar;
  }

  public func OnStatPoolValueChanged(oldValue: Float, newValue: Float, percToPoints: Float) -> Void {
    if newValue != oldValue {
      this.m_healthBar.UpdateOvershieldValue(newValue, percToPoints);
    };
    this.m_healthBar.EvaluateOvershieldBarVisibility();
  }
}

public class OverclockListener extends ScriptStatusEffectListener {

  private let m_healthBar: wref<healthbarWidgetGameController>;

  public final func BindHelathBar(bar: wref<healthbarWidgetGameController>) -> Void {
    this.m_healthBar = bar;
  }

  public func OnStatusEffectApplied(statusEffect: wref<StatusEffect_Record>) -> Void {
    if statusEffect.GetID() == t"BaseStatusEffect.Intelligence_Central_Milestone_3_Overclock_Buff" {
      this.m_healthBar.EvaluateHealthBarVisibility(true);
    };
  }

  public func OnStatusEffectRemoved(statusEffect: wref<StatusEffect_Record>) -> Void {
    if statusEffect.GetID() == t"BaseStatusEffect.Intelligence_Central_Milestone_3_Overclock_Buff" {
      this.m_healthBar.EvaluateHealthBarVisibility(false);
    };
  }
}
