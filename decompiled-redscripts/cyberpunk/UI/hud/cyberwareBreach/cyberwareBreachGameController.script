
public native class gameaiCyberwareBreachGameController extends inkGameController {

  public native let adjustedScreenPosition: Vector2;

  public native let maxHealth: Float;

  public native let currentHealth: Float;

  public native let lastHealth: Float;

  private let m_currentSway: Vector2;

  private edit let m_breachCanvasWRef: inkWidgetRef;

  private edit let m_strokeFgRef: inkBorderRef;

  private edit let m_strokeBgRef: inkBorderRef;

  private edit let m_waveStrokeRef: inkBorderRef;

  private edit let m_fillRef: inkWidgetRef;

  private edit let m_textScaleWidgetRef: inkCompoundRef;

  private edit let m_xTextRef: inkTextRef;

  private edit let m_yTextRef: inkTextRef;

  private edit let m_errorTextRef: inkTextRef;

  @runtimeProperty("category", "Control values")
  @runtimeProperty("tooltip", "Thickness of the border stroke, set dynamically and defined as % of the diamond radius ( 1.0 is 100% )")
  @default(gameaiCyberwareBreachGameController, 0.02f)
  private edit let m_strokeThicknessPercent: Float;

  @runtimeProperty("category", "Control values")
  @default(gameaiCyberwareBreachGameController, 4.f)
  private edit let m_minThickness: Float;

  @runtimeProperty("category", "Control values")
  @default(gameaiCyberwareBreachGameController, 6.f)
  private edit let m_maxThickness: Float;

  @runtimeProperty("category", "Control values")
  @default(gameaiCyberwareBreachGameController, .1f)
  private edit let m_minTextScale: Float;

  @runtimeProperty("category", "Control values")
  @default(gameaiCyberwareBreachGameController, 1.f)
  private edit let m_maxTextScale: Float;

  @runtimeProperty("category", "Control values")
  @runtimeProperty("tooltip", "At what radius value the scale is set to maxTextScale (the lower the further away - 0.23 is very close, 0.07 is about a meter away)")
  @default(gameaiCyberwareBreachGameController, 0.075f)
  private edit let m_maxRadius: Float;

  @default(gameaiCyberwareBreachGameController, 0.018f)
  private let m_minRadiusForFluff: Float;

  private let m_previousAlmostTimeout: Bool;

  private let m_cwBreachCallbackHandle: ref<CallbackHandle>;

  private let m_weaponSwayCallbackHandle: ref<CallbackHandle>;

  private let m_introAnimationProxy: ref<inkAnimProxy>;

  private let m_showAnimationProxy: ref<inkAnimProxy>;

  private let m_timeoutAnimationProxy: ref<inkAnimProxy>;

  public final native func ResetCodeAnims() -> Void;

  public final native func GotoEndAndStopMoveAnim(fireCallback: Bool) -> Void;

  public final native func GotoEndAndStopSizeAnim(fireCallback: Bool) -> Void;

  public final native func BeginMoveAnim(moveSpeed: Float) -> Void;

  public final native func BeginSizeAnim(sizeSpeed: Float) -> Void;

  public final native func GetMoveAnimPercent() -> Float;

  public final native func GetSizeAnimPercent() -> Float;

  public final native func UpdateHealthDepletion() -> Void;

  protected cb func OnInitialize() -> Bool {
    this.RegisterBlackboardCallbacks();
    this.GetRootWidget().SetVisible(false);
    this.PlayLibraryAnimation(n"breach_animation").GotoEndAndStop();
    this.m_previousAlmostTimeout = false;
  }

  protected cb func OnUninitialize() -> Bool {
    this.UnregisterBlackboardCallbacks();
  }

  private final func RegisterBlackboardCallbacks() -> Void {
    let blackboard: ref<IBlackboard> = GameInstance.GetBlackboardSystem((this.GetOwnerEntity() as GameObject).GetGame()).Get(GetAllBlackboardDefs().UIGameData);
    this.m_cwBreachCallbackHandle = blackboard.RegisterDelayedListenerVariant(GetAllBlackboardDefs().UIGameData.BreachUIParams, this, n"OnBreachDataChanged");
    this.m_weaponSwayCallbackHandle = blackboard.RegisterListenerVector2(GetAllBlackboardDefs().UIGameData.NormalizedWeaponSway, this, n"OnSway");
  }

  private final func UnregisterBlackboardCallbacks() -> Void {
    let blackboard: ref<IBlackboard> = GameInstance.GetBlackboardSystem((this.GetOwnerEntity() as GameObject).GetGame()).Get(GetAllBlackboardDefs().UIGameData);
    if IsDefined(this.m_cwBreachCallbackHandle) {
      blackboard.UnregisterDelayedListener(GetAllBlackboardDefs().UIGameData.BreachUIParams, this.m_cwBreachCallbackHandle);
    };
    if IsDefined(this.m_weaponSwayCallbackHandle) {
      blackboard.UnregisterDelayedListener(GetAllBlackboardDefs().UIGameData.NormalizedWeaponSway, this.m_weaponSwayCallbackHandle);
    };
  }

  protected cb func OnBreachDataChanged(value: Variant) -> Bool {
    let newBreach: Bool;
    let parameters: ref<BreachUIParameters> = FromVariant<ref<BreachUIParameters>>(value);
    if !parameters.tracking {
      if IsDefined(this.m_timeoutAnimationProxy) && this.m_timeoutAnimationProxy.IsPlaying() {
        this.m_timeoutAnimationProxy.GotoStartAndStop();
        this.m_timeoutAnimationProxy = null;
      };
      this.GetRootWidget().SetVisible(false);
      return false;
    };
    this.UpdateState(parameters.visible);
    newBreach = Equals(parameters.trackingChange, gameBreachUITrackingChange.StartedNew);
    if newBreach {
      this.StopAllAnimations();
      this.ResetCodeAnims();
      this.PlayShowAnimation();
    };
    this.GetRootWidget().SetVisible(true);
    this.ChangeScreenPosition(parameters.position);
    this.ChangeScreenSize(parameters.radius);
    this.ChangeHealth(parameters.health, parameters.maxHealth, !newBreach);
    this.ChangeFluff(parameters.position, parameters.radius);
    if parameters.almostTimeout && NotEquals(this.m_previousAlmostTimeout, parameters.almostTimeout) {
      this.PlayTimeoutAnimation();
    };
    this.m_previousAlmostTimeout = parameters.almostTimeout;
  }

  protected cb func OnSway(pos: Vector2) -> Bool {
    this.m_currentSway = pos;
  }

  private final func UpdateState(visible: Bool) -> Void {
    this.GetRootWidget().SetState(visible ? n"Default" : n"Invisible");
  }

  private final func ChangeScreenPosition(screenPosition: Vector2) -> Void {
    let translation: Vector2;
    let rootSize: Vector2 = this.GetRootWidget().GetSize();
    translation.X = rootSize.X / 2.00 * screenPosition.X;
    translation.Y = rootSize.Y / 2.00 * screenPosition.Y;
    this.adjustedScreenPosition = new Vector2(screenPosition.X, screenPosition.Y / (rootSize.X / rootSize.Y));
    inkWidgetRef.SetTranslation(this.m_breachCanvasWRef, translation);
  }

  private final func ChangeScreenSize(radius: Float) -> Void {
    let thickness: Float;
    let m_fill: wref<inkWidget> = inkWidgetRef.Get(this.m_fillRef);
    let rootSize: Vector2 = this.GetRootWidget().GetSize();
    let size: Float = rootSize.X * radius;
    inkWidgetRef.SetSize(this.m_breachCanvasWRef, new Vector2(size, size));
    thickness = ClampF(size * this.m_strokeThicknessPercent, this.m_minThickness, this.m_maxThickness);
    inkBorderRef.SetThickness(this.m_strokeFgRef, thickness);
    inkBorderRef.SetThickness(this.m_strokeBgRef, thickness);
    inkBorderRef.SetThickness(this.m_waveStrokeRef, thickness * 2.50);
    m_fill.SetMargin(thickness, thickness, thickness, thickness);
  }

  private final func ChangeHealth(health: Float, givenMaxHealth: Float, opt fireTransition: Bool) -> Void {
    let m_strokeFg: wref<inkWidget> = inkWidgetRef.Get(this.m_strokeFgRef);
    this.lastHealth = this.currentHealth;
    this.currentHealth = health;
    this.maxHealth = givenMaxHealth;
    m_strokeFg.SetEffectParamValue(inkEffectType.RadialWipe, n"RadialWipe_0", n"transition", this.currentHealth / this.maxHealth);
    if fireTransition {
      this.UpdateHealthDepletion();
    };
  }

  private final func ChangeFluff(screenPosition: Vector2, radius: Float) -> Void {
    let fluffValues: Vector2;
    let scale: Float;
    let str: String;
    if radius <= this.m_minRadiusForFluff {
      inkWidgetRef.SetVisible(this.m_xTextRef, false);
      inkWidgetRef.SetVisible(this.m_yTextRef, false);
      inkWidgetRef.SetVisible(this.m_errorTextRef, false);
      return;
    };
    inkWidgetRef.SetVisible(this.m_xTextRef, true);
    inkWidgetRef.SetVisible(this.m_yTextRef, true);
    inkWidgetRef.SetVisible(this.m_errorTextRef, true);
    scale = ClampF(radius / this.m_maxRadius, this.m_minTextScale, this.m_maxTextScale);
    fluffValues.X = ClampF(99.99 * (screenPosition.X + 1.20) / 2.40, 0.00, 99.99);
    fluffValues.Y = ClampF(99.99 * (screenPosition.Y + 1.20) / 2.40, 0.00, 99.99);
    inkWidgetRef.SetScale(this.m_textScaleWidgetRef, new Vector2(scale, scale));
    str = fluffValues.X < 10.00 ? "0" : "";
    str += FloatToStringPrec(fluffValues.X, 2) + fluffValues.X == 0.00 ? ".00" : "";
    inkTextRef.SetText(this.m_xTextRef, str);
    str = fluffValues.Y < 10.00 ? "0" : "";
    str += FloatToStringPrec(fluffValues.Y, 2) + fluffValues.Y == 0.00 ? ".00" : "";
    inkTextRef.SetText(this.m_yTextRef, str);
  }

  private final func InterpolateValues(startValue: Float, endValue: Float, ratio: Float) -> Float {
    return startValue * (1.00 - ratio) + endValue * ratio;
  }

  private final func IsAnyIntroAnimPlaying(ignoreSizeAnim: Bool) -> Bool {
    return this.m_showAnimationProxy.IsPlaying();
  }

  private final func PlayIntroAnimation() -> Void {
    if IsDefined(this.m_introAnimationProxy) && !this.m_introAnimationProxy.IsFinished() {
      this.m_introAnimationProxy.UnregisterFromAllCallbacks(inkanimEventType.OnFinish);
      this.m_introAnimationProxy.Stop();
      this.m_introAnimationProxy = null;
    };
    this.m_introAnimationProxy = this.PlayLibraryAnimation(n"breach_intro");
    this.m_introAnimationProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnIntroAnimationFinished");
  }

  protected cb func OnIntroAnimationFinished(proxy: ref<inkAnimProxy>) -> Bool {
    this.BeginMoveAnim(1.00);
  }

  private final func PlayShowAnimation() -> Void {
    if IsDefined(this.m_showAnimationProxy) && !this.m_showAnimationProxy.IsFinished() {
      this.m_showAnimationProxy.UnregisterFromAllCallbacks(inkanimEventType.OnFinish);
      this.m_showAnimationProxy.Stop();
      this.m_showAnimationProxy = null;
    };
    this.m_showAnimationProxy = this.PlayLibraryAnimation(n"breach_animation");
  }

  protected cb func OnShowAnimationFinished(proxy: ref<inkAnimProxy>) -> Bool {
    this.BeginSizeAnim(3.00);
  }

  private final func PlayTimeoutAnimation() -> Void {
    if IsDefined(this.m_timeoutAnimationProxy) && this.m_timeoutAnimationProxy.IsPlaying() {
      this.m_timeoutAnimationProxy.GotoStartAndStop();
      this.m_timeoutAnimationProxy = null;
    };
    this.m_timeoutAnimationProxy = this.PlayLibraryAnimation(n"breach_timed_out");
  }

  private final func StopAllAnimations() -> Void {
    if IsDefined(this.m_introAnimationProxy) && !this.m_introAnimationProxy.IsFinished() {
      this.m_introAnimationProxy.UnregisterFromAllCallbacks(inkanimEventType.OnFinish);
      this.m_introAnimationProxy.GotoEndAndStop();
      this.m_introAnimationProxy = null;
    };
    if IsDefined(this.m_showAnimationProxy) && !this.m_showAnimationProxy.IsFinished() {
      this.m_showAnimationProxy.UnregisterFromAllCallbacks(inkanimEventType.OnFinish);
      this.m_showAnimationProxy.GotoEndAndStop();
      this.m_showAnimationProxy = null;
    };
    if IsDefined(this.m_timeoutAnimationProxy) && !this.m_timeoutAnimationProxy.IsFinished() {
      this.m_timeoutAnimationProxy.GotoEndAndStop();
      this.m_timeoutAnimationProxy = null;
    };
  }

  protected cb func OnMoveAnimationFinished() -> Bool {
    this.PlayShowAnimation();
  }

  protected cb func OnResizeAnimationFinished() -> Bool;
}
