
public class CrosshairLogicController_RasetsuHipFire extends inkLogicController {

  @default(CrosshairLogicController_RasetsuHipFire, .8)
  public let offsetLeftRight: Float;

  @default(CrosshairLogicController_RasetsuHipFire, 40.0)
  public let latchVertical: Float;

  public edit let m_topPart: inkWidgetRef;

  public edit let m_bottomPart: inkWidgetRef;

  public edit let m_horiPart: inkWidgetRef;

  public edit let m_vertPart: inkWidgetRef;

  public edit let m_leftPart: inkWidgetRef;

  public edit let m_rightPart: inkWidgetRef;

  public edit let m_targetColorChange: inkWidgetRef;

  public final func ApplyBulletSpread(spread: Vector2) -> Void {
    inkWidgetRef.SetMargin(this.m_leftPart, new inkMargin(-spread.X * this.offsetLeftRight, 0.00, 0.00, 0.00));
    inkWidgetRef.SetMargin(this.m_rightPart, new inkMargin(spread.X * this.offsetLeftRight, 0.00, 0.00, 0.00));
    inkWidgetRef.SetSize(this.m_vertPart, 3.00, spread.Y * 2.00 + this.latchVertical);
    inkWidgetRef.SetSize(this.m_horiPart, spread.X * 2.00, 3.00);
    inkWidgetRef.SetMargin(this.m_topPart, new inkMargin(0.00, -spread.Y, 0.00, 0.00));
    inkWidgetRef.SetMargin(this.m_bottomPart, new inkMargin(0.00, spread.Y, 0.00, 0.00));
  }

  public final func ApplyCrosshairGUIState(state: CName, aimedAtEntity: ref<Entity>) -> Void {
    inkWidgetRef.SetState(this.m_targetColorChange, state);
  }
}

public class CrosshairLogicController_RasetsuAimFire extends inkLogicController {

  public edit let m_chargebarContainer: inkWidgetRef;

  public edit let m_perfectChargeIndicator: inkWidgetRef;

  public let m_chargeBar: wref<ChargebarController>;

  public let m_animPerfectCharge: ref<inkAnimProxy>;

  public final func SetPlayer(player: ref<GameObject>) -> Void {
    this.m_chargeBar = inkWidgetRef.GetController(this.m_chargebarContainer) as ChargebarController;
    if IsDefined(this.m_chargeBar) {
      this.m_chargeBar.OnPlayerAttach(player);
    };
  }

  public final func ResetPlayer(player: ref<GameObject>) -> Void {
    if IsDefined(this.m_chargeBar) {
      this.m_chargeBar.OnPlayerDetach(player);
    };
  }

  public final func ApplyTriggerMode(value: Variant) -> Void {
    if IsDefined(this.m_chargeBar) {
      this.m_chargeBar.OnTriggerModeChanged(value);
    };
  }

  public final func ApplyChargeValue(value: Float) -> Void {
    if IsDefined(this.m_chargeBar) {
      this.m_chargeBar.OnChargeValueChanged(value);
    };
  }

  public final func ApplyPerfectCharge(type: CName) -> Void {
    let animOptions: inkAnimOptions;
    animOptions.loopType = inkanimLoopType.Cycle;
    animOptions.loopInfinite = true;
    if Equals(type, n"perfectChargeCharged") {
      inkWidgetRef.SetVisible(this.m_perfectChargeIndicator, true);
      this.m_animPerfectCharge = this.PlayLibraryAnimation(n"release", animOptions);
    } else {
      if Equals(type, n"perfectChargeShot") {
        if IsDefined(this.m_animPerfectCharge) && this.m_animPerfectCharge.IsPlaying() {
          this.m_animPerfectCharge.Stop();
        };
        inkWidgetRef.SetVisible(this.m_perfectChargeIndicator, false);
        this.PlayLibraryAnimation(n"splash");
      } else {
        if Equals(type, n"perfectChargeFailed") {
          if IsDefined(this.m_animPerfectCharge) && this.m_animPerfectCharge.IsPlaying() {
            this.m_animPerfectCharge.Stop();
          };
          inkWidgetRef.SetVisible(this.m_perfectChargeIndicator, false);
          this.PlayLibraryAnimation(n"miss");
        };
      };
    };
  }
}

public class CrosshairGameController_Rasetsu extends gameuiCrosshairBaseGameController {

  public edit let m_hipFire: inkWidgetRef;

  public edit let m_aimFire: inkWidgetRef;

  public edit let m_showAdsAnimName: CName;

  public edit let m_hideAdsAnimName: CName;

  public edit let m_loopAdsAnimName: CName;

  public edit let m_targetHitAnimationName: CName;

  public edit let m_shootAnimationName: CName;

  public let m_hipFireLogicController: wref<CrosshairLogicController_RasetsuHipFire>;

  public let m_aimFireLogicController: wref<CrosshairLogicController_RasetsuAimFire>;

  public let m_weaponLocalBB: wref<IBlackboard>;

  public let m_uiGameDataBB: wref<IBlackboard>;

  public let m_onChargeChangeBBID: ref<CallbackHandle>;

  public let m_onChargeTriggerModeBBID: ref<CallbackHandle>;

  public let m_weaponDataTargetHitBBID: ref<CallbackHandle>;

  public let m_weaponDataShootBBID: ref<CallbackHandle>;

  public let m_targetHitAnimation: ref<inkAnimProxy>;

  public let m_shootAnimation: ref<inkAnimProxy>;

  public let m_visibilityAnimProxy: ref<inkAnimProxy>;

  public let m_rootAnimProxy: ref<inkAnimProxy>;

  @default(CrosshairGameController_Rasetsu, true)
  public let m_isRootVisible: Bool;

  protected cb func OnInitialize() -> Bool {
    super.OnInitialize();
    this.m_uiGameDataBB = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UIGameData);
    this.m_hipFireLogicController = inkWidgetRef.GetController(this.m_hipFire) as CrosshairLogicController_RasetsuHipFire;
    this.m_aimFireLogicController = inkWidgetRef.GetController(this.m_aimFire) as CrosshairLogicController_RasetsuAimFire;
    if IsDefined(this.m_aimFireLogicController) {
      this.m_aimFireLogicController.SetPlayer(this.GetPlayerControlledObject());
    };
    this.RequestProcessFitToViewport();
  }

  protected cb func OnUninitialize() -> Bool {
    if IsDefined(this.m_aimFireLogicController) {
      this.m_aimFireLogicController.ResetPlayer(this.GetPlayerControlledObject());
    };
    super.OnUninitialize();
  }

  protected cb func OnPreIntro() -> Bool {
    let m_uiActiveWeaponBlackboard: wref<IBlackboard>;
    this.m_weaponLocalBB = this.GetWeaponLocalBlackboard();
    if IsDefined(this.m_weaponLocalBB) {
      this.m_onChargeChangeBBID = this.m_weaponLocalBB.RegisterListenerFloat(GetAllBlackboardDefs().Weapon.Charge, this, n"OnChargeChanged");
      this.m_onChargeTriggerModeBBID = this.m_weaponLocalBB.RegisterListenerVariant(GetAllBlackboardDefs().Weapon.TriggerMode, this, n"OnTriggerModeChanged");
    };
    super.OnPreIntro();
    m_uiActiveWeaponBlackboard = this.GetUIActiveWeaponBlackboard();
    if IsDefined(m_uiActiveWeaponBlackboard) {
      this.m_weaponDataTargetHitBBID = m_uiActiveWeaponBlackboard.RegisterDelayedListenerVariant(GetAllBlackboardDefs().UI_ActiveWeaponData.TargetHitEvent, this, n"OnTargetHit");
      this.m_weaponDataShootBBID = m_uiActiveWeaponBlackboard.RegisterDelayedListenerVariant(GetAllBlackboardDefs().UI_ActiveWeaponData.ShootEvent, this, n"OnShoot");
    };
  }

  protected cb func OnPreOutro() -> Bool {
    let m_uiActiveWeaponBlackboard: wref<IBlackboard>;
    if IsDefined(this.m_weaponLocalBB) {
      this.m_weaponLocalBB.UnregisterListenerFloat(GetAllBlackboardDefs().Weapon.Charge, this.m_onChargeChangeBBID);
      this.m_weaponLocalBB.UnregisterListenerVariant(GetAllBlackboardDefs().Weapon.TriggerMode, this.m_onChargeTriggerModeBBID);
    };
    m_uiActiveWeaponBlackboard = this.GetUIActiveWeaponBlackboard();
    if IsDefined(m_uiActiveWeaponBlackboard) {
      m_uiActiveWeaponBlackboard.UnregisterDelayedListener(GetAllBlackboardDefs().UI_ActiveWeaponData.TargetHitEvent, this.m_weaponDataTargetHitBBID);
      m_uiActiveWeaponBlackboard.UnregisterDelayedListener(GetAllBlackboardDefs().UI_ActiveWeaponData.ShootEvent, this.m_weaponDataShootBBID);
    };
    super.OnPreOutro();
  }

  public func GetIntroAnimation(firstEquip: Bool) -> ref<inkAnimProxy> {
    let anim: ref<inkAnimDef> = new inkAnimDef();
    let alphaInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    alphaInterpolator.SetStartTransparency(0.00);
    alphaInterpolator.SetEndTransparency(1.00);
    alphaInterpolator.SetDuration(0.40);
    alphaInterpolator.SetType(inkanimInterpolationType.Linear);
    alphaInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    anim.AddInterpolator(alphaInterpolator);
    return this.m_rootWidget.PlayAnimation(anim);
  }

  public func GetOutroAnimation() -> ref<inkAnimProxy> {
    let anim: ref<inkAnimDef> = new inkAnimDef();
    let alphaInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    alphaInterpolator.SetStartTransparency(1.00);
    alphaInterpolator.SetEndTransparency(0.00);
    alphaInterpolator.SetDuration(0.40);
    alphaInterpolator.SetType(inkanimInterpolationType.Linear);
    alphaInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    anim.AddInterpolator(alphaInterpolator);
    return this.m_rootWidget.PlayAnimation(anim);
  }

  protected cb func OnBulletSpreadChanged(spread: Vector2) -> Bool {
    super.OnBulletSpreadChanged(spread);
    if IsDefined(this.m_hipFireLogicController) {
      this.m_hipFireLogicController.ApplyBulletSpread(spread);
    };
  }

  protected cb func OnChargeChanged(argCharge: Float) -> Bool {
    if IsDefined(this.m_aimFireLogicController) {
      this.m_aimFireLogicController.ApplyChargeValue(argCharge);
    };
  }

  protected cb func OnTriggerModeChanged(triggerMode: Variant) -> Bool {
    if IsDefined(this.m_aimFireLogicController) {
      this.m_aimFireLogicController.ApplyTriggerMode(triggerMode);
    };
  }

  protected func ApplyCrosshairGUIState(state: CName, aimedAtEntity: ref<Entity>) -> Void {
    if IsDefined(this.m_hipFireLogicController) {
      this.m_hipFireLogicController.ApplyCrosshairGUIState(state, aimedAtEntity);
    };
  }

  protected func OnState_HipFire() -> Void {
    this.ApplyWeaponSwayToCamera(false);
    this.ShowRootWidget(true);
    if IsDefined(this.m_visibilityAnimProxy) {
      this.m_visibilityAnimProxy.UnregisterFromAllCallbacks(inkanimEventType.OnFinish);
      this.m_visibilityAnimProxy.Stop();
    };
    this.m_visibilityAnimProxy = this.PlayLibraryAnimation(this.m_hideAdsAnimName);
  }

  protected func OnState_Aim() -> Void {
    this.ApplyWeaponSwayToCamera(true);
    this.ShowRootWidget(true);
    if IsDefined(this.m_visibilityAnimProxy) {
      this.m_visibilityAnimProxy.UnregisterFromAllCallbacks(inkanimEventType.OnFinish);
      this.m_visibilityAnimProxy.Stop();
    };
    this.m_visibilityAnimProxy = this.PlayLibraryAnimation(this.m_showAdsAnimName);
    this.m_visibilityAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnStartLoop");
  }

  protected cb func OnStartLoop(proxy: ref<inkAnimProxy>) -> Bool {
    proxy.UnregisterFromAllCallbacks(inkanimEventType.OnFinish);
    this.PlayLibraryAnimation(this.m_loopAdsAnimName);
  }

  private final func ApplyWeaponSwayToCamera(value: Bool) -> Void {
    this.m_uiGameDataBB.SetBool(GetAllBlackboardDefs().UIGameData.ApplyWeaponSwayToCamera, value);
  }

  private final func ShowRootWidget(isVisible: Bool) -> Void {
    if NotEquals(this.m_isRootVisible, isVisible) {
      this.m_isRootVisible = isVisible;
      this.m_rootWidget.StopAllAnimations();
      if isVisible {
        this.GetIntroAnimation(false);
      } else {
        this.GetOutroAnimation();
      };
    };
  }

  protected func OnState_GrenadeCharging() -> Void {
    this.ApplyWeaponSwayToCamera(false);
    this.ShowRootWidget(false);
  }

  protected func OnState_Reload() -> Void {
    this.ApplyWeaponSwayToCamera(false);
    this.ShowRootWidget(false);
  }

  protected func OnState_Safe() -> Void {
    this.ApplyWeaponSwayToCamera(false);
    this.ShowRootWidget(false);
  }

  protected func OnState_Sprint() -> Void {
    this.ApplyWeaponSwayToCamera(false);
    this.ShowRootWidget(false);
  }

  protected func OnState_Scanning() -> Void {
    this.ApplyWeaponSwayToCamera(false);
    this.ShowRootWidget(false);
  }

  protected func OnState_LeftHandCyberware() -> Void {
    this.ApplyWeaponSwayToCamera(false);
    this.ShowRootWidget(false);
  }

  protected cb func OnPerfectChargeUIEvent(evt: ref<PerfectChargeUIEvent>) -> Bool {
    if IsDefined(this.m_aimFireLogicController) {
      this.m_aimFireLogicController.ApplyPerfectCharge(evt.type);
    };
  }

  protected cb func OnShoot(arg: Variant) -> Bool {
    if IsDefined(this.m_shootAnimation) {
      this.m_shootAnimation.Stop();
    };
    this.m_shootAnimation = this.PlayLibraryAnimation(this.m_shootAnimationName, IronsightDetail.PlaybackCycleOnce());
  }

  protected cb func OnTargetHit(arg: Variant) -> Bool {
    if IsDefined(this.m_targetHitAnimation) {
      this.m_targetHitAnimation.Stop();
    };
    this.m_targetHitAnimation = this.PlayLibraryAnimation(this.m_targetHitAnimationName, IronsightDetail.PlaybackCycleOnce());
  }
}
