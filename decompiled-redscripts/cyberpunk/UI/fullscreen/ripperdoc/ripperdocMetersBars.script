
public class RipperdocNewMeterBar extends inkLogicController {

  private edit let m_bar: inkWidgetRef;

  private edit let m_overchargeHighlight: inkWidgetRef;

  private let m_root: wref<inkWidget>;

  private let m_sizeAnimation: ref<inkAnimProxy>;

  private let m_meterWidth: Float;

  private let m_pulse: ref<PulseAnimation>;

  protected cb func OnInitialize() -> Bool {
    inkWidgetRef.SetVisible(this.m_overchargeHighlight, false);
    this.m_root = this.GetRootWidget();
  }

  public final func SetState(state: CName) -> Void {
    inkWidgetRef.SetState(this.m_bar, state);
    if inkWidgetRef.IsValid(this.m_overchargeHighlight) {
      if Equals(state, n"Unsafe_Default") || Equals(state, n"Unsafe_Add") || Equals(state, n"Unsafe_Remove") || Equals(state, n"Unsafe_Locked") || Equals(state, n"Unsafe_Unlocekd") {
        inkWidgetRef.SetState(this.m_overchargeHighlight, state);
        inkWidgetRef.SetVisible(this.m_overchargeHighlight, true);
      } else {
        inkWidgetRef.SetState(this.m_overchargeHighlight, n"Default");
        inkWidgetRef.SetVisible(this.m_overchargeHighlight, false);
      };
    };
  }

  public final func SetSizeAnimation(size: Float, sizeOffset: Float, delay: Float, duration: Float) -> Void {
    let animation: ref<inkAnimDef>;
    let endScale: Vector2;
    let marginInterpolator: ref<inkAnimScale>;
    let options: inkAnimOptions;
    let startScale: Vector2;
    if this.m_sizeAnimation != null {
      this.m_sizeAnimation.Stop();
    };
    startScale = inkWidgetRef.GetScale(this.m_bar);
    endScale.X = size + sizeOffset;
    endScale.Y = 1.00;
    animation = new inkAnimDef();
    marginInterpolator = new inkAnimScale();
    marginInterpolator.SetType(inkanimInterpolationType.Quintic);
    marginInterpolator.SetMode(inkanimInterpolationMode.EasyOut);
    marginInterpolator.SetDuration(duration);
    marginInterpolator.SetUseRelativeDuration(true);
    marginInterpolator.SetStartScale(startScale);
    marginInterpolator.SetEndScale(endScale);
    animation.AddInterpolator(marginInterpolator);
    options.executionDelay = MaxF(delay, 0.00);
    this.m_sizeAnimation = inkWidgetRef.PlayAnimationWithOptions(this.m_bar, animation, options);
  }

  public final func SetSize(size: Float) -> Void {
    let endScale: Vector2;
    endScale.X = size;
    endScale.Y = 1.00;
    inkWidgetRef.SetScale(this.m_bar, endScale);
  }

  public final func StartPulse(params: PulseAnimationParams) -> Void {
    if IsDefined(this.m_pulse) {
      this.m_pulse.ForceStop();
    };
    this.m_pulse = new PulseAnimation();
    this.m_pulse.Configure(inkWidgetRef.Get(this.m_bar), params);
    this.m_pulse.Start(false);
  }

  public final func StopPulse() -> Void {
    inkWidgetRef.StopAllAnimations(this.m_bar);
  }

  public final func GetHeight() -> Float {
    let size: Vector2 = inkWidgetRef.GetSize(this.m_bar);
    return size.Y;
  }

  public final func GetMargin(margin: String) -> Float {
    let margins: inkMargin = this.m_root.GetMargin();
    switch margin {
      case "left":
        return margins.left;
      case "top":
        return margins.top;
      case "right":
        return margins.right;
      case "bottom":
        return margins.bottom;
      default:
        return 0.00;
    };
  }
}
