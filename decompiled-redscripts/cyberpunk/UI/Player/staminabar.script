
public class StaminabarWidgetGameController extends inkHUDGameController {

  private edit let m_staminaControllerRef: inkWidgetRef;

  private edit let m_staminaPercTextPath: inkTextRef;

  private edit let m_staminaStatusTextPath: inkTextRef;

  private let m_bbPSceneTierEventId: ref<CallbackHandle>;

  private let m_bbPStaminaPSMEventId: ref<CallbackHandle>;

  private let m_bbAreaZoneEventId: ref<CallbackHandle>;

  private let m_combatModeListener: ref<CallbackHandle>;

  private let m_staminaController: wref<NameplateBarLogicController>;

  private let m_RootWidget: wref<inkWidget>;

  @default(StaminabarWidgetGameController, 100.f)
  private let m_currentBarValue: Float;

  private let m_currentStatPool: gamedataStatPoolType;

  @default(StaminabarWidgetGameController, GameplayTier.Tier1_FullGameplay)
  private let m_sceneTier: GameplayTier;

  @default(StaminabarWidgetGameController, gamePSMStamina.Rested)
  private let m_staminaState: gamePSMStamina;

  private let m_zoneState: gamePSMZones;

  private let m_staminaPoolListener: ref<StaminaPoolListener>;

  private let m_statsSystem: ref<StatsSystem>;

  @default(StaminabarWidgetGameController, false)
  private let m_forceHidden: Bool;

  private let m_staminaRatioEnterCondition: Float;

  private let m_pulse: ref<PulseAnimation>;

  private let m_playerPuppet: wref<GameObject>;

  protected cb func OnInitialize() -> Bool {
    this.m_RootWidget = this.GetRootWidget();
    this.m_RootWidget.SetVisible(false);
    this.m_staminaController = inkWidgetRef.GetController(this.m_staminaControllerRef) as NameplateBarLogicController;
    this.m_currentStatPool = gamedataStatPoolType.Stamina;
    this.m_staminaPoolListener = new StaminaPoolListener();
    this.m_staminaPoolListener.BindStaminaBar(this);
    this.m_staminaRatioEnterCondition = TweakDBInterface.GetFloat(t"playerStateMachineStamina.exhausted.staminaRatioEnterCondition", 0.00);
    this.CreateAnimations();
    this.EvaluateStaminaBarVisibility();
  }

  protected cb func OnUninitialize() -> Bool {
    if IsDefined(this.m_staminaPoolListener) {
      this.m_staminaPoolListener = null;
    };
  }

  protected cb func OnPlayerAttach(playerGameObject: ref<GameObject>) -> Bool {
    this.m_playerPuppet = playerGameObject;
    this.RegisterPSMListeners(playerGameObject);
    this.m_statsSystem = GameInstance.GetStatsSystem(playerGameObject.GetGame());
    this.m_staminaPoolListener = new StaminaPoolListener();
    this.m_staminaPoolListener.BindStaminaBar(this);
    GameInstance.GetStatPoolsSystem(playerGameObject.GetGame()).RequestRegisteringListener(Cast<StatsObjectID>(playerGameObject.GetEntityID()), gamedataStatPoolType.Stamina, this.m_staminaPoolListener);
    playerGameObject.RegisterInputListener(this, n"HolsterWeapon");
  }

  protected cb func OnPlayerDetach(playerGameObject: ref<GameObject>) -> Bool {
    if IsDefined(this.m_staminaPoolListener) {
      GameInstance.GetStatPoolsSystem(playerGameObject.GetGame()).RequestUnregisteringListener(Cast<StatsObjectID>(playerGameObject.GetEntityID()), gamedataStatPoolType.Stamina, this.m_staminaPoolListener);
      this.m_staminaPoolListener = null;
    };
    this.UnregisterPSMListeners(playerGameObject);
    playerGameObject.UnregisterInputListener(this);
  }

  protected final func RegisterPSMListeners(playerPuppet: ref<GameObject>) -> Void {
    let playerStateMachineBlackboard: ref<IBlackboard>;
    let playerSMDef: ref<PlayerStateMachineDef> = GetAllBlackboardDefs().PlayerStateMachine;
    if playerPuppet.IsControlledByLocalPeer() {
      playerStateMachineBlackboard = this.GetPSMBlackboard(playerPuppet);
      if IsDefined(playerStateMachineBlackboard) {
        this.m_sceneTier = IntEnum<GameplayTier>(playerStateMachineBlackboard.GetInt(playerSMDef.SceneTier));
        this.m_staminaState = IntEnum<gamePSMStamina>(playerStateMachineBlackboard.GetInt(playerSMDef.Stamina));
        this.m_bbPSceneTierEventId = playerStateMachineBlackboard.RegisterListenerInt(playerSMDef.SceneTier, this, n"OnSceneTierChange");
        this.m_bbPStaminaPSMEventId = playerStateMachineBlackboard.RegisterListenerInt(playerSMDef.Stamina, this, n"OnStaminaPSMChange");
        this.m_bbAreaZoneEventId = playerStateMachineBlackboard.RegisterListenerInt(playerSMDef.Zones, this, n"OnZoneChange");
        this.m_combatModeListener = playerStateMachineBlackboard.RegisterListenerInt(playerSMDef.Combat, this, n"OnCombatStateChanged");
      };
    };
  }

  protected final func UnregisterPSMListeners(playerPuppet: ref<GameObject>) -> Void {
    let playerStateMachineBlackboard: ref<IBlackboard>;
    let playerSMDef: ref<PlayerStateMachineDef> = GetAllBlackboardDefs().PlayerStateMachine;
    if playerPuppet.IsControlledByLocalPeer() {
      playerStateMachineBlackboard = this.GetPSMBlackboard(playerPuppet);
      if IsDefined(playerStateMachineBlackboard) {
        playerStateMachineBlackboard.UnregisterDelayedListener(playerSMDef.SceneTier, this.m_bbPSceneTierEventId);
        playerStateMachineBlackboard.UnregisterDelayedListener(playerSMDef.Stamina, this.m_bbPStaminaPSMEventId);
        playerStateMachineBlackboard.UnregisterDelayedListener(playerSMDef.Zones, this.m_bbAreaZoneEventId);
        playerStateMachineBlackboard.UnregisterDelayedListener(playerSMDef.Combat, this.m_combatModeListener);
      };
    };
  }

  public final func UpdateStaminaValue(oldValue: Float, newValue: Float, percToPoints: Float, statPoolType: gamedataStatPoolType) -> Void {
    this.m_currentBarValue = newValue / 100.00;
    if this.m_currentBarValue <= this.m_staminaRatioEnterCondition {
      if this.m_currentBarValue < 0.20 {
        this.m_pulse.Configure(inkWidgetRef.Get(this.m_staminaControllerRef), 1.00, 0.10, 0.20);
      } else {
        this.m_pulse.Configure(inkWidgetRef.Get(this.m_staminaControllerRef), 1.00, 0.10, this.m_currentBarValue);
      };
      this.m_pulse.Start(false);
    } else {
      if this.m_currentBarValue >= 0.85 {
        this.m_pulse.Stop();
      } else {
        this.m_pulse.Stop();
      };
    };
    this.m_staminaController.SetNameplateBarProgress(this.m_currentBarValue, false);
    inkTextRef.SetTextFromParts(this.m_staminaPercTextPath, IntToString(Cast<Int32>(newValue)), "Common-Characters-Percetage", "");
    this.UpdateStaminaLevelWarningFluffTexts(this.m_staminaState);
    this.EvaluateStaminaBarVisibility();
  }

  protected cb func OnFocusedCoolPerkActive(evt: ref<FocusPerkTriggerd>) -> Bool {
    let playbackOptions: inkAnimOptions;
    if evt.isActive {
      this.PlayLibraryAnimation(n"perk_intro");
      this.m_RootWidget.SetState(n"Focused");
      this.m_RootWidget.SetOpacity(1.00);
    } else {
      this.m_RootWidget.SetState(n"Default");
      playbackOptions.playReversed = true;
      this.PlayLibraryAnimation(n"perk_intro", playbackOptions);
    };
  }

  public final func UpdateStaminaLevelWarningFluffTexts(staminaState: gamePSMStamina) -> Void {
    if Equals(staminaState, gamePSMStamina.Exhausted) {
      inkTextRef.SetText(this.m_staminaStatusTextPath, "LocKey#40314");
    } else {
      inkTextRef.SetText(this.m_staminaStatusTextPath, "LocKey#40311");
    };
  }

  public final func EvaluateStaminaBarVisibility() -> Void {
    switch this.m_sceneTier {
      case GameplayTier.Tier1_FullGameplay:
        this.m_RootWidget.SetVisible(true);
        break;
      default:
        this.m_RootWidget.SetVisible(false);
    };
    if this.ShouldHide() {
      this.m_RootWidget.SetVisible(false);
    } else {
      this.m_RootWidget.SetVisible(true);
    };
    this.m_RootWidget.SetOpacity(1.05 - this.m_currentBarValue);
  }

  private final func ShouldHide() -> Bool {
    let isInCombat: Bool;
    let isInHostileArea: Bool;
    let isMaxBar: Bool;
    let isMultiplayer: Bool;
    if this.m_forceHidden {
      return true;
    };
    isMaxBar = this.m_currentBarValue >= 1.00;
    isMultiplayer = this.IsPlayingMultiplayer();
    isInCombat = this.IsInCombat();
    isInHostileArea = Equals(this.m_zoneState, gamePSMZones.Restricted) || Equals(this.m_zoneState, gamePSMZones.Dangerous);
    return !isInHostileArea && !isInCombat && isMaxBar && !isMultiplayer || Equals(this.m_sceneTier, GameplayTier.Tier4_FPPCinematic) || Equals(this.m_sceneTier, GameplayTier.Tier5_Cinematic);
  }

  private final func IsInCombat() -> Bool {
    let player: ref<PlayerPuppet> = this.GetOwnerEntity() as PlayerPuppet;
    return player.IsInCombat();
  }

  protected cb func OnCombatStateChanged(value: Int32) -> Bool {
    this.EvaluateStaminaBarVisibility();
  }

  private final func CreateAnimations() -> Void {
    this.m_pulse = new PulseAnimation();
  }

  protected cb func OnSceneTierChange(argTier: Int32) -> Bool {
    this.m_sceneTier = IntEnum<GameplayTier>(argTier);
    this.EvaluateStaminaBarVisibility();
  }

  protected cb func OnStaminaPSMChange(arg: Int32) -> Bool {
    this.m_staminaState = IntEnum<gamePSMStamina>(arg);
  }

  protected cb func OnZoneChange(arg: Int32) -> Bool {
    this.m_zoneState = IntEnum<gamePSMZones>(arg);
    this.EvaluateStaminaBarVisibility();
  }

  protected cb func OnForceHide() -> Bool {
    this.EvaluateStaminaBarVisibility();
  }

  protected cb func OnForceTierVisibility(tierVisibility: Bool) -> Bool {
    this.EvaluateStaminaBarVisibility();
  }

  protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    if Equals(ListenerAction.GetName(action), n"HolsterWeapon") && ListenerAction.IsButtonJustPressed(action) {
      this.m_forceHidden = !this.m_forceHidden;
    };
  }

  protected cb func OnReflexesMasterPerk3Triggerd(e: ref<ReflexesMasterPerk3Triggerd>) -> Bool {
    if !FloatIsEqual(this.m_currentBarValue, 1.00) {
      this.PlayLibraryAnimation(n"bonus_regen");
    };
  }
}

public class StaminaPoolListener extends ScriptStatPoolsListener {

  private let m_staminaBar: wref<StaminabarWidgetGameController>;

  public final func BindStaminaBar(bar: wref<StaminabarWidgetGameController>) -> Void {
    this.m_staminaBar = bar;
  }

  public func OnStatPoolValueChanged(oldValue: Float, newValue: Float, percToPoints: Float) -> Void {
    this.m_staminaBar.UpdateStaminaValue(oldValue, newValue, percToPoints, gamedataStatPoolType.Stamina);
  }
}
