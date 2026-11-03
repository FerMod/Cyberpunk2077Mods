
public class RipperdocMetersBase extends inkLogicController {

  @runtimeProperty("category", "Base")
  protected edit let m_barAnchor: inkWidgetRef;

  @runtimeProperty("category", "Base")
  protected edit let m_hoverArea: inkWidgetRef;

  @runtimeProperty("category", "Base Bars")
  @default(RipperdocMetersArmor, ArmorMeterBar)
  @default(RipperdocMetersCapacity, CapacityMeterBar)
  protected edit let m_barWidgetLibraryName: CName;

  @runtimeProperty("category", "Base Bars")
  @default(RipperdocMetersBase, 12.f)
  protected edit let m_barGapSize: Float;

  @runtimeProperty("category", "Base Bars")
  @runtimeProperty("tooltip", "Magic Number use for slope bars length calculation")
  @default(RipperdocMetersArmor, 0.25f)
  @default(RipperdocMetersCapacity, 0.075f)
  protected edit let m_slopeLengthModifier: Float;

  @runtimeProperty("category", "Base Bars")
  @default(RipperdocMetersBase, 0.3f)
  protected edit let barIntroAnimDuration: Float;

  @runtimeProperty("category", "Base Bars")
  @runtimeProperty("tooltip", "Value use to calculated labels offsets. Need to be updated evetime actual bars properties is changed.")
  @default(RipperdocMetersArmor, 9.f)
  @default(RipperdocMetersCapacity, 9.f)
  protected edit let m_barsHeigh: Float;

  @runtimeProperty("category", "Base Bars")
  @runtimeProperty("tooltip", "Value use to calculated labels offsets. Need to be updated evetime actual bars properties is changed.")
  @default(RipperdocMetersArmor, 9.f)
  @default(RipperdocMetersCapacity, 9.f)
  protected edit let m_barsMargin: Float;

  @runtimeProperty("category", "Base Constants")
  @default(RipperdocMetersBase, 50)
  @default(RipperdocMetersCapacity, 50)
  protected edit const let BAR_COUNT: Int32;

  @runtimeProperty("category", "Base Constants")
  @default(RipperdocMetersBase, 4)
  protected edit const let BAR_SLOPE_COUNT: Int32;

  @runtimeProperty("category", "Base Constants")
  @default(RipperdocMetersBase, 0.3f)
  protected edit const let BAR_ANIM_DURATION: Float;

  @runtimeProperty("category", "Base Constants")
  @default(RipperdocMetersBase, 0.050)
  protected edit const let BAR_DELAY_OFFSET: Float;

  @runtimeProperty("category", "Base Pulse Params")
  @default(RipperdocMetersBase, 1.0f)
  protected edit let m_pulseAnimtopOpacity: Float;

  @runtimeProperty("category", "Base Pulse Params")
  @default(RipperdocMetersBase, 0.2f)
  protected edit let m_pulseAnimbottomOpacity: Float;

  @runtimeProperty("category", "Base Pulse Params")
  @default(RipperdocMetersBase, 0.4f)
  protected edit let m_pulseAnimpulseRate: Float;

  @runtimeProperty("category", "Base Pulse Params")
  @default(RipperdocMetersBase, 0.1f)
  protected edit let m_pulseAnimdelay: Float;

  protected let m_pulseAnimationParams: PulseAnimationParams;

  protected let m_bars: [wref<RipperdocNewMeterBar>];

  protected let m_barGaps: [Int32];

  protected let m_tooltipData: ref<RipperdocBarTooltipTooltipData>;

  protected let m_barIntroAnimDef: ref<inkAnimDef>;

  protected let m_barIntroAnimProxy: ref<inkAnimProxy>;

  protected let m_isIntroPlayed: Bool;

  protected final func MoveLabelToBar(labelContainer: inkWidgetRef, bar: ref<RipperdocNewMeterBar>, animProxy: ref<inkAnimProxy>, alignToTop: Bool, instant: Bool) -> Void {
    let animation: ref<inkAnimDef>;
    let marginInterpolator: ref<inkAnimMargin>;
    let newMargin: inkMargin;
    let newTopMargin: Float;
    let oldMargin: inkMargin;
    let verticalDelta: Float;
    let distance: Vector2 = WidgetUtils.WidgetToWidget(inkWidgetRef.Get(labelContainer), bar.GetRootWidget());
    if animProxy != null {
      animProxy.GotoEndAndStop();
    };
    oldMargin = inkWidgetRef.GetMargin(labelContainer);
    newTopMargin = distance.Y;
    if alignToTop {
      newTopMargin -= bar.GetHeight();
    };
    newTopMargin = MaxF(newTopMargin, 0.00);
    newMargin = new inkMargin(oldMargin.left, newTopMargin, oldMargin.right, oldMargin.bottom);
    verticalDelta = AbsF(oldMargin.top - distance.Y);
    if verticalDelta != 0.00 {
      verticalDelta -= bar.GetHeight();
      marginInterpolator = new inkAnimMargin();
      marginInterpolator.SetDuration(instant ? 0.00 : MinF(verticalDelta * 0.10, 0.30));
      marginInterpolator.SetStartMargin(oldMargin);
      marginInterpolator.SetEndMargin(newMargin);
      marginInterpolator.SetType(inkanimInterpolationType.Sinusoidal);
      marginInterpolator.SetMode(inkanimInterpolationMode.EasyOut);
      animation = new inkAnimDef();
      animation.AddInterpolator(marginInterpolator);
      animProxy = inkWidgetRef.PlayAnimation(labelContainer, animation);
      inkWidgetRef.PlayAnimation(labelContainer, animation);
      if !this.m_isIntroPlayed {
        this.m_isIntroPlayed = true;
        animProxy.RegisterToCallback(inkanimEventType.OnStart, this, n"OnIntroAnimationFinished_METER");
      };
    };
  }

  protected final func GetSlopeAnimOffset(index: Int32, originBar: Int32) -> Float {
    return SqrF(Cast<Float>(index - originBar)) * this.m_slopeLengthModifier;
  }

  protected final func SetupBarIntroAnimation() -> Void {
    this.m_barIntroAnimDef = new inkAnimDef();
    let scaleInterpolator: ref<inkAnimScale> = new inkAnimScale();
    scaleInterpolator.SetMode(inkanimInterpolationMode.EasyOut);
    scaleInterpolator.SetType(inkanimInterpolationType.Linear);
    scaleInterpolator.SetStartScale(new Vector2(0.00, 1.00));
    scaleInterpolator.SetEndScale(new Vector2(1.00, 1.00));
    scaleInterpolator.SetDuration(this.barIntroAnimDuration);
    this.m_barIntroAnimDef.AddInterpolator(scaleInterpolator);
  }

  protected final func StartPulse(pulse: ref<PulseAnimation>, params: PulseAnimationParams, target: wref<inkWidget>) -> Void {
    pulse.Configure(target, 1.00, 0.20, 0.40, 0.10);
    pulse.Start(false);
  }

  protected final func StopPulse(pulse: ref<PulseAnimation>) -> Void {
    if IsDefined(pulse) {
      pulse.Stop();
    };
  }

  protected final func SetupPulseAnimParams(topOpacity: Float, bottomOpacity: Float, pulseRate: Float, delay: Float) -> Void {
    this.m_pulseAnimationParams.topOpacity = topOpacity;
    this.m_pulseAnimationParams.bottomOpacity = bottomOpacity;
    this.m_pulseAnimationParams.pulseRate = pulseRate;
    this.m_pulseAnimationParams.delay = delay;
  }

  protected cb func OnBarHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    let barHoverOverEvent: ref<BarHoverOverEvent> = new BarHoverOverEvent();
    barHoverOverEvent.data = this.m_tooltipData;
    this.QueueEvent(barHoverOverEvent);
  }

  protected cb func OnBarHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    let barHoverOutEvent: ref<BarHoverOutEvent> = new BarHoverOutEvent();
    this.QueueEvent(barHoverOutEvent);
  }
}
