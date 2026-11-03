
public class RipperdocFillLabel extends inkLogicController {

  private edit let m_label: inkTextRef;

  private edit let m_useMargin: Bool;

  private let m_root: wref<inkWidget>;

  private let m_labelAnimator: wref<inkTextValueProgressController>;

  private let m_height: Float;

  private let m_startSize: Vector2;

  private let m_positionAnimation: ref<inkAnimProxy>;

  private let m_labelAnimation: ref<inkAnimProxy>;

  private let m_labelValue: Float;

  public final func Configure(height: Float) -> Void {
    this.m_root = this.GetRootWidget();
    this.m_height = height;
    this.m_startSize = this.m_root.GetSize();
    this.m_labelValue = 0.00;
    this.m_labelAnimator = inkWidgetRef.GetController(this.m_label) as inkTextValueProgressController;
  }

  public final func SetLabel(value: Int32, percent: Float, opt duration: Float) -> Void {
    this.AnimateLabel(value, duration * 1.25);
    if this.m_useMargin {
      this.AnimateMargin(ClampF(percent, 0.00, 1.00), duration);
    } else {
      this.AnimateSize(ClampF(percent, 0.00, 1.00), duration);
    };
  }

  public final func AnimateLabel(value: Int32, duration: Float) -> Void {
    if this.m_labelAnimation != null {
      this.m_labelAnimation.Stop();
    };
    if duration == 0.00 {
      this.m_labelAnimation = null;
      inkTextRef.SetText(this.m_label, IntToString(value));
      this.m_labelValue = Cast<Float>(value);
      return;
    };
    this.m_labelAnimator.SetDelay(0.00);
    this.m_labelAnimator.SetDuration(duration);
    this.m_labelAnimator.SetBaseValue(this.m_labelValue);
    this.m_labelValue = Cast<Float>(value);
    this.m_labelAnimator.SetTargetValue(this.m_labelValue);
    this.m_labelAnimation = this.m_labelAnimator.PlaySetAnimation();
  }

  private final func AnimateMargin(percent: Float, duration: Float) -> Void {
    let animation: ref<inkAnimDef>;
    let margin: inkMargin;
    let marginInterpolator: ref<inkAnimMargin>;
    if this.m_positionAnimation != null {
      this.m_positionAnimation.Stop();
    };
    margin.bottom = percent * this.m_height;
    if duration == 0.00 {
      this.m_positionAnimation = null;
      this.m_root.SetMargin(margin);
      return;
    };
    marginInterpolator = new inkAnimMargin();
    marginInterpolator.SetDuration(duration);
    marginInterpolator.SetStartMargin(this.m_root.GetMargin());
    marginInterpolator.SetEndMargin(margin);
    marginInterpolator.SetType(inkanimInterpolationType.Sinusoidal);
    marginInterpolator.SetMode(inkanimInterpolationMode.EasyOut);
    animation = new inkAnimDef();
    animation.AddInterpolator(marginInterpolator);
    this.m_positionAnimation = this.m_root.PlayAnimation(animation);
  }

  private final func AnimateSize(percent: Float, duration: Float) -> Void {
    let animation: ref<inkAnimDef>;
    let size: Vector2;
    let sizeInterpolator: ref<inkAnimSize>;
    if this.m_positionAnimation != null {
      this.m_positionAnimation.Stop();
    };
    size = this.m_root.GetSize();
    size.Y = (1.00 - percent) * this.m_height + this.m_startSize.Y;
    if duration == 0.00 {
      this.m_positionAnimation = null;
      this.m_root.SetSize(size);
      return;
    };
    sizeInterpolator = new inkAnimSize();
    sizeInterpolator.SetDuration(duration);
    sizeInterpolator.SetStartSize(this.m_root.GetSize());
    sizeInterpolator.SetEndSize(size);
    sizeInterpolator.SetType(inkanimInterpolationType.Sinusoidal);
    sizeInterpolator.SetMode(inkanimInterpolationMode.EasyOut);
    animation = new inkAnimDef();
    animation.AddInterpolator(sizeInterpolator);
    this.m_positionAnimation = this.m_root.PlayAnimation(animation);
  }
}
