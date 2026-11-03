
public class Crosshair_Melee_Knife extends gameuiCrosshairBaseGameController {

  private edit let m_targetColorChange: inkWidgetRef;

  private edit let m_leftPart: inkWidgetRef;

  private edit let m_rightPart: inkWidgetRef;

  private edit let m_topPart: inkWidgetRef;

  private edit let m_botPart: inkWidgetRef;

  private let m_chargeBar: wref<inkCanvas>;

  private let m_chargeBarFG: wref<inkRectangle>;

  private let m_throwingKnifeResourcePoolListener: ref<ThrowingKnifeResourcePoolListener>;

  private let m_weaponID: EntityID;

  private let m_weaponBBID: ref<CallbackHandle>;

  private let m_meleeWeaponState: gamePSMMeleeWeapon;

  protected let m_animProxy: ref<inkAnimProxy>;

  protected let m_animOptions: inkAnimOptions;

  protected let m_isCrosshairAnimationOpen: Bool;

  private let m_preloaderThinL: wref<inkImage>;

  private let m_preloaderThinR: wref<inkImage>;

  private let m_preloaderThickL: wref<inkImage>;

  private let m_preloaderThickR: wref<inkImage>;

  private let m_preloader: wref<inkCanvas>;

  protected cb func OnInitialize() -> Bool {
    super.OnInitialize();
    this.m_chargeBar = this.GetWidget(n"chargeBar") as inkCanvas;
    this.m_chargeBarFG = this.GetWidget(n"chargeBar/chargeBarFG") as inkRectangle;
    this.m_preloaderThinL = this.GetWidget(n"preloader/thinL/thinL") as inkImage;
    this.m_preloaderThinR = this.GetWidget(n"preloader/thinR/thinR") as inkImage;
    this.m_preloaderThickL = this.GetWidget(n"preloader/thickL/thickL") as inkImage;
    this.m_preloaderThickR = this.GetWidget(n"preloader/thickR/thickR") as inkImage;
    this.m_preloader = this.GetWidget(n"preloader") as inkCanvas;
  }

  protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
    let playerSMBB: ref<IBlackboard> = this.GetPSMBlackboard(playerPuppet);
    this.m_weaponBBID = playerSMBB.RegisterDelayedListenerInt(GetAllBlackboardDefs().PlayerStateMachine.MeleeWeapon, this, n"OnPSMMeleeWeaponStateChanged");
    this.OnPSMMeleeWeaponStateChanged(playerSMBB.GetInt(GetAllBlackboardDefs().PlayerStateMachine.MeleeWeapon));
    this.m_animOptions.loopType = inkanimLoopType.None;
    this.m_animOptions.loopInfinite = false;
  }

  protected cb func OnPlayerDetach(playerPuppet: ref<GameObject>) -> Bool {
    let playerSMBB: ref<IBlackboard>;
    if IsDefined(this.m_weaponBBID) {
      playerSMBB = this.GetPSMBlackboard(playerPuppet);
      playerSMBB.UnregisterDelayedListener(GetAllBlackboardDefs().PlayerStateMachine.MeleeWeapon, this.m_weaponBBID);
    };
  }

  protected cb func OnPSMMeleeWeaponStateChanged(value: Int32) -> Bool {
    let oldState: gamePSMMeleeWeapon = this.m_meleeWeaponState;
    let newState: gamePSMMeleeWeapon = IntEnum<gamePSMMeleeWeapon>(value);
    if NotEquals(oldState, newState) {
      this.m_meleeWeaponState = newState;
      this.UpdateThrowCrosshair();
    };
  }

  protected final func UpdateThrowCrosshair() -> Void {
    if Equals(this.m_meleeWeaponState, gamePSMMeleeWeapon.Targeting) {
      this.GetRootWidget().SetState(n"default");
      if !this.m_isCrosshairAnimationOpen {
        this.m_animProxy = this.PlayLibraryAnimation(n"throw_intro", this.m_animOptions);
        this.m_isCrosshairAnimationOpen = true;
      };
    } else {
      if Equals(this.m_meleeWeaponState, gamePSMMeleeWeapon.ThrowAttack) {
        this.GetRootWidget().SetState(n"knifeReloading");
        if this.m_isCrosshairAnimationOpen {
          this.m_animProxy = this.PlayLibraryAnimation(n"throw_outro", this.m_animOptions);
          this.m_isCrosshairAnimationOpen = false;
        };
      } else {
        this.GetRootWidget().SetState(n"default");
        if this.m_isCrosshairAnimationOpen {
          this.m_animProxy = this.PlayLibraryAnimation(n"throw_outro", this.m_animOptions);
          this.m_isCrosshairAnimationOpen = false;
        };
      };
    };
  }

  protected cb func OnPreIntro() -> Bool {
    let weaponObject: ref<ItemObject> = this.GetWeaponItemObject();
    let playerObject: ref<GameObject> = this.GetOwnerEntity() as GameObject;
    let statPoolsSystem: ref<StatPoolsSystem> = GameInstance.GetStatPoolsSystem(playerObject.GetGame());
    if IsDefined(weaponObject) && IsDefined(statPoolsSystem) {
      this.m_weaponID = weaponObject.GetEntityID();
      if statPoolsSystem.IsStatPoolAdded(Cast<StatsObjectID>(this.m_weaponID), gamedataStatPoolType.ThrowRecovery) {
        this.m_throwingKnifeResourcePoolListener = new ThrowingKnifeResourcePoolListener();
        this.SetReloadBarVisible(false);
        this.m_throwingKnifeResourcePoolListener.Bind(this, false);
        statPoolsSystem.RequestRegisteringListener(Cast<StatsObjectID>(this.m_weaponID), gamedataStatPoolType.ThrowRecovery, this.m_throwingKnifeResourcePoolListener);
      };
    };
    super.OnPreIntro();
  }

  protected cb func OnUninitialize() -> Bool {
    if IsDefined(this.m_throwingKnifeResourcePoolListener) && IsDefined(this.GetPlayerControlledObject()) {
      GameInstance.GetStatPoolsSystem(this.GetPlayerControlledObject().GetGame()).RequestUnregisteringListener(Cast<StatsObjectID>(this.m_weaponID), gamedataStatPoolType.ThrowRecovery, this.m_throwingKnifeResourcePoolListener);
      this.m_throwingKnifeResourcePoolListener = null;
    };
  }

  protected cb func OnPreOutro() -> Bool {
    if IsDefined(this.m_throwingKnifeResourcePoolListener) && IsDefined(this.GetPlayerControlledObject()) {
      GameInstance.GetStatPoolsSystem(this.GetPlayerControlledObject().GetGame()).RequestUnregisteringListener(Cast<StatsObjectID>(this.m_weaponID), gamedataStatPoolType.ThrowRecovery, this.m_throwingKnifeResourcePoolListener);
      this.m_throwingKnifeResourcePoolListener = null;
    };
    super.OnPreOutro();
  }

  public func SetReloadBar(percentage: Float) -> Void {
    this.m_preloaderThinL.SetRotation(percentage * -1.80);
    this.m_preloaderThinR.SetRotation(percentage * 1.80);
    this.m_preloaderThickL.SetRotation(percentage * 1.80);
    this.m_preloaderThickR.SetRotation(percentage * -1.80);
  }

  public func GetIntroAnimation(firstEquip: Bool) -> ref<inkAnimProxy> {
    let anim: ref<inkAnimDef> = new inkAnimDef();
    let alphaInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    alphaInterpolator.SetStartTransparency(0.00);
    alphaInterpolator.SetEndTransparency(1.00);
    alphaInterpolator.SetDuration(0.25);
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
    alphaInterpolator.SetDuration(0.25);
    alphaInterpolator.SetType(inkanimInterpolationType.Linear);
    alphaInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    anim.AddInterpolator(alphaInterpolator);
    return this.m_rootWidget.PlayAnimation(anim);
  }

  protected cb func OnBulletSpreadChanged(spread: Vector2) -> Bool {
    super.OnBulletSpreadChanged(spread);
    inkWidgetRef.SetMargin(this.m_leftPart, new inkMargin(-spread.X, -spread.Y, 0.00, 0.00));
    inkWidgetRef.SetMargin(this.m_rightPart, new inkMargin(spread.X, -spread.X, 0.00, 0.00));
    inkWidgetRef.SetMargin(this.m_topPart, new inkMargin(-spread.X, spread.Y, 0.00, 0.00));
    inkWidgetRef.SetMargin(this.m_botPart, new inkMargin(spread.X, spread.Y, 0.00, 0.00));
  }

  protected func ApplyCrosshairGUIState(state: CName, aimedAtEntity: ref<Entity>) -> Void {
    inkWidgetRef.SetState(this.m_targetColorChange, state);
    inkWidgetRef.SetState(this.m_leftPart, state);
    inkWidgetRef.SetState(this.m_rightPart, state);
    inkWidgetRef.SetState(this.m_topPart, state);
    inkWidgetRef.SetState(this.m_botPart, state);
  }

  public final func PlayReloadBarFadeAnimation(isFadeIn: Bool) -> Void {
    let animOptions: inkAnimOptions;
    animOptions.loopType = inkanimLoopType.None;
    animOptions.loopCounter = 1u;
    if isFadeIn {
      this.m_animProxy = this.PlayLibraryAnimation(n"reload_start", animOptions);
    } else {
      this.m_animProxy.GotoStartAndStop();
      this.m_animProxy = this.PlayLibraryAnimation(n"reload_end", animOptions);
    };
  }

  public final func SetReloadBarVisible(set: Bool) -> Void {
    this.m_preloader.SetVisible(set);
  }

  protected final func ShowCrosshairFromState(show: Bool) -> Void {
    this.GetRootWidget().SetOpacity(show ? 1.00 : 0.00);
  }

  protected func OnState_Safe() -> Void {
    this.ShowCrosshairFromState(true);
  }

  protected func OnState_Scanning() -> Void {
    this.ShowCrosshairFromState(false);
  }

  protected func OnState_GrenadeCharging() -> Void {
    this.ShowCrosshairFromState(false);
  }

  protected func OnState_HipFire() -> Void {
    this.ShowCrosshairFromState(true);
  }

  protected func OnState_Reload() -> Void {
    this.ShowCrosshairFromState(true);
  }

  protected func OnState_Aim() -> Void {
    this.ShowCrosshairFromState(true);
  }

  protected func OnState_Sprint() -> Void {
    this.ShowCrosshairFromState(true);
  }

  protected func OnState_LeftHandCyberware() -> Void {
    this.ShowCrosshairFromState(false);
  }

  public final func GetFadeOutAnimation() -> ref<inkAnimDef> {
    let anim: ref<inkAnimDef> = new inkAnimDef();
    let alphaInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    alphaInterpolator.SetStartTransparency(1.00);
    alphaInterpolator.SetEndTransparency(0.00);
    alphaInterpolator.SetDuration(0.50);
    alphaInterpolator.SetType(inkanimInterpolationType.Sinusoidal);
    alphaInterpolator.SetMode(inkanimInterpolationMode.EasyInOut);
    anim.AddInterpolator(alphaInterpolator);
    return anim;
  }

  public final func GetFadeInAnimation() -> ref<inkAnimDef> {
    let anim: ref<inkAnimDef> = new inkAnimDef();
    let alphaInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    alphaInterpolator.SetStartTransparency(0.00);
    alphaInterpolator.SetEndTransparency(1.00);
    alphaInterpolator.SetDuration(0.15);
    alphaInterpolator.SetType(inkanimInterpolationType.Linear);
    alphaInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    anim.AddInterpolator(alphaInterpolator);
    return anim;
  }
}

public class ThrowingKnifeResourcePoolListener extends ScriptStatPoolsListener {

  private let m_Crosshair: wref<Crosshair_Melee_Knife>;

  private let m_shouldDisplayBar: Bool;

  private let evt: ref<ThrowingKnifeReloadFinishedCrosshairEvent>;

  public final func Bind(crosshair: wref<Crosshair_Melee_Knife>, shouldDisplayBar: Bool) -> Void {
    this.m_Crosshair = crosshair;
    this.m_shouldDisplayBar = false;
  }

  public func OnStatPoolValueChanged(oldValue: Float, newValue: Float, percToPoints: Float) -> Void {
    if AbsF(newValue) - oldValue < 2.00 {
      this.m_Crosshair.SetReloadBar(newValue);
    } else {
      this.m_Crosshair.PlayReloadBarFadeAnimation(false);
    };
    if !this.m_shouldDisplayBar && newValue <= 99.00 {
      this.m_Crosshair.SetReloadBarVisible(true);
      this.m_Crosshair.PlayReloadBarFadeAnimation(true);
      this.m_shouldDisplayBar = true;
    };
  }

  protected cb func OnStatPoolMaxValueReached(value: Float) -> Bool {
    this.m_shouldDisplayBar = false;
    this.m_Crosshair.PlayReloadBarFadeAnimation(false);
  }

  protected cb func OnStatPoolMinValueReached(value: Float) -> Bool {
    this.m_shouldDisplayBar = true;
    this.m_Crosshair.PlayReloadBarFadeAnimation(true);
    this.m_Crosshair.SetReloadBar(value);
    this.m_Crosshair.SetReloadBarVisible(true);
  }
}
