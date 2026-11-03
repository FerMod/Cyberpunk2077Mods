
public class hudTurretController extends inkHUDGameController {

  private edit let healthStatus: inkTextRef;

  private edit let m_MessageText: inkTextRef;

  private edit let m_yawCounter: inkTextRef;

  private edit let m_pitchCounter: inkTextRef;

  private edit let m_pitch: inkCanvasRef;

  private edit let m_yaw: inkCanvasRef;

  private edit let m_turretIcon: inkCanvasRef;

  @default(hudTurretController, -360)
  private let pitch_min: Float;

  @default(hudTurretController, 360)
  private let pitch_max: Float;

  @default(hudTurretController, -640)
  private let yaw_min: Float;

  @default(hudTurretController, 640)
  private let yaw_max: Float;

  private edit let m_ZoomNumber: inkTextRef;

  private edit let m_DistanceNumber: inkTextRef;

  private edit let m_DistanceImageRuler: inkImageRef;

  private edit let m_ZoomMoveBracketL: inkImageRef;

  private edit let m_ZoomMoveBracketR: inkImageRef;

  private let m_bbPlayerStats: wref<IBlackboard>;

  private let m_bbPlayerEventId: ref<CallbackHandle>;

  private let m_currentHealth: Int32;

  private let m_previousHealth: Int32;

  private let m_maximumHealth: Int32;

  private let m_playerObject: wref<GameObject>;

  private let m_playerPuppet: wref<GameObject>;

  private let m_controlledObjectRef: wref<GameObject>;

  private let m_gameInstance: GameInstance;

  private let m_animationProxy: ref<inkAnimProxy>;

  private let m_psmBlackboard: wref<IBlackboard>;

  private let m_PSM_BBID: ref<CallbackHandle>;

  private let zoomDownAnim: ref<inkAnimProxy>;

  private let zoomUpAnim: ref<inkAnimProxy>;

  private let argZoomBuffered: Float;

  private let m_overclockListener: ref<OverclockHudListener>;

  private let m_isOverclockActive: Bool;

  protected cb func OnInitialize() -> Bool {
    let player: ref<GameObject> = this.GetPlayerControlledObject();
    let delayInitialize: ref<DelayedHUDInitializeEvent> = new DelayedHUDInitializeEvent();
    GameInstance.GetDelaySystem(player.GetGame()).DelayEvent(player, delayInitialize, 0.10);
    player.RegisterInputListener(this);
    this.UpdateRulers();
    this.m_overclockListener = new OverclockHudListener();
    this.m_overclockListener.BindHudController(this);
    GameInstance.GetStatusEffectSystem(player.GetGame()).RegisterListener(player.GetEntityID(), this.m_overclockListener);
    this.m_isOverclockActive = QuickHackableHelper.IsOverclockedStateActive(player);
    this.OnOverclockHudEvent(null);
  }

  protected cb func OnUninitialize() -> Bool {
    TakeOverControlSystem.CreateInputHint(this.GetPlayerControlledObject().GetGame(), false);
    SecurityTurret.CreateInputHint(this.GetPlayerControlledObject().GetGame(), false);
    this.m_overclockListener = null;
  }

  protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
    let optionIntro: inkAnimOptions;
    this.m_bbPlayerStats = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_PlayerBioMonitor);
    this.m_bbPlayerEventId = this.m_bbPlayerStats.RegisterListenerVariant(GetAllBlackboardDefs().UI_PlayerBioMonitor.PlayerStatsInfo, this, n"OnStatsChanged");
    this.m_playerObject = playerPuppet;
    this.m_playerPuppet = playerPuppet;
    this.m_gameInstance = this.GetPlayerControlledObject().GetGame();
    this.PlayLibraryAnimation(n"Malfunction");
    optionIntro.executionDelay = 1.50;
    this.PlaySound(n"MiniGame", n"AccessGranted");
    this.PlayLibraryAnimation(n"intro", optionIntro);
    this.PlayAnim(n"intro2", n"OnIntroComplete");
    optionIntro.executionDelay = 2.00;
    this.PlayLibraryAnimation(n"Malfunction_off", optionIntro);
    this.PlayAnim(n"Malfunction_timed", n"OnMalfunction");
    this.UpdateJohnnyThemeOverride(true);
    this.m_psmBlackboard = this.GetPSMBlackboard(playerPuppet);
    if IsDefined(this.m_psmBlackboard) {
      this.m_PSM_BBID = this.m_psmBlackboard.RegisterDelayedListenerFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel, this, n"OnScannerZoom");
    };
  }

  protected cb func OnPlayerDetach(playerPuppet: ref<GameObject>) -> Bool {
    if IsDefined(this.m_bbPlayerStats) {
      this.m_bbPlayerStats.UnregisterListenerVariant(GetAllBlackboardDefs().UI_PlayerBioMonitor.PlayerStatsInfo, this.m_bbPlayerEventId);
    };
    this.PlayLibraryAnimation(n"outro");
    this.UpdateJohnnyThemeOverride(false);
  }

  protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    this.UpdateRulers();
  }

  protected cb func OnMalfunction(anim: ref<inkAnimProxy>) -> Bool {
    let optionIntro: inkAnimOptions;
    let optionMalfunction: inkAnimOptions;
    if GameInstance.GetQuestsSystem(this.m_gameInstance).GetFact(n"q104_turret_broken") == 1 && GameInstance.GetQuestsSystem(this.m_gameInstance).GetFact(n"q104_turret_fixed") == 0 {
      this.PlaySound(n"MiniGame", n"AccessDenied");
      inkTextRef.SetText(this.m_MessageText, "LocKey#11338");
      optionMalfunction.fromMarker = n"intro";
      optionMalfunction.toMarker = n"loop_start";
      this.PlayAnim(n"Malfunction", n"OnMalfunctionLoop", optionMalfunction);
      optionIntro.executionDelay = 28.00;
      this.PlayLibraryAnimation(n"Malfunction_off", optionIntro);
    };
  }

  protected cb func OnMalfunctionLoop(anim: ref<inkAnimProxy>) -> Bool {
    let optionMalfunctionLoop: inkAnimOptions;
    optionMalfunctionLoop.loopInfinite = false;
    optionMalfunctionLoop.loopType = inkanimLoopType.Cycle;
    optionMalfunctionLoop.loopCounter = 65u;
    optionMalfunctionLoop.fromMarker = n"loop_start";
    optionMalfunctionLoop.toMarker = n"loop_end";
    this.PlayAnim(n"Malfunction", n"OnMalfunctionLoopEnd", optionMalfunctionLoop);
  }

  protected cb func OnMalfunctionLoopEnd(anim: ref<inkAnimProxy>) -> Bool {
    let optionMalfunctionLoopEnd: inkAnimOptions;
    optionMalfunctionLoopEnd.fromMarker = n"loop_end";
    this.PlayAnim(n"Malfunction", n"None", optionMalfunctionLoopEnd);
  }

  protected cb func OnIntroComplete(anim: ref<inkAnimProxy>) -> Bool {
    GameInstance.GetAudioSystem(this.GetPlayerControlledObject().GetGame()).Play(n"ui_main_menu_cc_loading");
  }

  protected cb func OnStatsChanged(value: Variant) -> Bool {
    let incomingData: PlayerBioMonitor = FromVariant<PlayerBioMonitor>(value);
    this.m_previousHealth = this.m_currentHealth;
    this.m_maximumHealth = incomingData.maximumHealth;
    this.m_currentHealth = CeilF(GameInstance.GetStatPoolsSystem(this.m_playerObject.GetGame()).GetStatPoolValue(Cast<StatsObjectID>(GetPlayer(this.m_playerObject.GetGame()).GetEntityID()), gamedataStatPoolType.Health, false));
    this.m_currentHealth = Clamp(this.m_currentHealth, 0, this.m_maximumHealth);
    inkTextRef.SetText(this.healthStatus, IntToString(RoundF(Cast<Float>(this.m_currentHealth))) + "/" + IntToString(RoundF(Cast<Float>(this.m_maximumHealth))));
  }

  protected cb func OnOverclockHudEvent(overclockEvent: ref<OverclockHudEvent>) -> Bool {
    if IsDefined(overclockEvent) {
      this.m_isOverclockActive = overclockEvent.m_activated;
    };
    inkWidgetRef.SetVisible(this.m_turretIcon, !this.m_isOverclockActive);
    this.UpdateRequired();
  }

  protected cb func OnDelayedHUDInitializeEvent(evt: ref<DelayedHUDInitializeEvent>) -> Bool {
    TakeOverControlSystem.CreateInputHint(this.GetPlayerControlledObject().GetGame(), true);
    SecurityTurret.CreateInputHint(this.GetPlayerControlledObject().GetGame(), true);
  }

  protected cb func OnScannerZoom(argZoom: Float) -> Bool {
    if argZoom * 2.00 > 2.00 {
      inkTextRef.SetText(this.m_ZoomNumber, FloatToStringPrec(MaxF(1.00, argZoom * 2.00), 1) + "x");
    } else {
      inkTextRef.SetText(this.m_ZoomNumber, FloatToStringPrec(MaxF(1.00, argZoom * 2.00 - 1.00), 1) + "x");
    };
    inkWidgetRef.SetMargin(this.m_ZoomMoveBracketL, new inkMargin(0.00, 0.00, 560.00 - argZoom * 60.00, 0.00));
    inkWidgetRef.SetMargin(this.m_ZoomMoveBracketR, new inkMargin(560.00 - argZoom * 60.00, 0.00, 0.00, 0.00));
    if argZoom < this.argZoomBuffered {
      if (!IsDefined(this.zoomDownAnim) || !this.zoomDownAnim.IsPlaying()) && (!IsDefined(this.zoomUpAnim) || !this.zoomUpAnim.IsPlaying()) {
        this.zoomDownAnim = this.PlayLibraryAnimation(n"zoomDown");
      };
    };
    if argZoom > this.argZoomBuffered {
      if (!IsDefined(this.zoomDownAnim) || !this.zoomDownAnim.IsPlaying()) && (!IsDefined(this.zoomUpAnim) || !this.zoomUpAnim.IsPlaying()) {
        this.zoomUpAnim = this.PlayLibraryAnimation(n"zoomUp");
      };
    };
    this.argZoomBuffered = argZoom;
  }

  public final func PlayAnim(animName: CName, opt callBack: CName, opt animOptions: inkAnimOptions) -> Void {
    if IsDefined(this.m_animationProxy) && this.m_animationProxy.IsPlaying() {
      this.m_animationProxy.Stop(true);
    };
    this.m_animationProxy = this.PlayLibraryAnimation(animName, animOptions);
    if NotEquals(callBack, n"None") {
      this.m_animationProxy.RegisterToCallback(inkanimEventType.OnFinish, this, callBack);
    };
  }

  private final func UpdateJohnnyThemeOverride(value: Bool) -> Void {
    let uiSystem: ref<UISystem>;
    let controlledPuppet: wref<gamePuppetBase> = GetPlayer(this.m_gameInstance);
    if IsDefined(controlledPuppet) && controlledPuppet.IsJohnnyReplacer() {
      uiSystem = GameInstance.GetUISystem(this.m_gameInstance);
      if IsDefined(uiSystem) {
        if value {
          uiSystem.SetGlobalThemeOverride(n"Johnny");
        } else {
          uiSystem.ClearGlobalThemeOverride();
        };
      };
    };
  }

  private final func UpdateRulers() -> Void {
    let m_pitchMargin: Float;
    let m_yawMargin: Float;
    let pitchPt: Float;
    let yawPt: Float;
    this.m_controlledObjectRef = this.m_playerObject.GetTakeOverControlSystem().GetControlledObject();
    let data: CameraRotationData = (this.m_controlledObjectRef as SensorDevice).GetRotationData();
    let euAngles: EulerAngles = (this.m_controlledObjectRef as SensorDevice).GetRotationFromSlotRotation();
    if data.m_maxPitch == 0.00 {
      data.m_maxPitch = 360.00;
    };
    pitchPt = euAngles.Pitch / AbsF(data.m_maxPitch - data.m_minPitch);
    m_pitchMargin = AbsF(this.pitch_max - this.pitch_min) * pitchPt;
    inkWidgetRef.SetMargin(this.m_pitch, 0.00, m_pitchMargin, 0.00, 0.00);
    if data.m_maxYaw == 0.00 {
      data.m_maxYaw = 360.00;
    };
    yawPt = -euAngles.Yaw / AbsF(data.m_maxYaw - data.m_minYaw);
    m_yawMargin = AbsF(this.yaw_max - this.yaw_min) * yawPt;
    inkWidgetRef.SetMargin(this.m_yaw, m_yawMargin, 0.00, 0.00, 0.00);
    inkTextRef.SetText(this.m_yawCounter, ToString(RoundF(-euAngles.Yaw)));
    inkTextRef.SetText(this.m_pitchCounter, ToString(RoundF(-euAngles.Pitch)));
  }

  public final func GetUIActiveWeaponBlackboard() -> ref<IBlackboard> {
    return this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_ActiveWeaponData);
  }
}
