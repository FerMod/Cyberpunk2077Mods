
public class RipperdocFillBar extends inkLogicController {

  private let m_root: wref<inkWidget>;

  private let m_fillStart: Float;

  private let m_fillEnd: Float;

  private let m_maxSize: Vector2;

  private let m_sizeAnimation: ref<inkAnimProxy>;

  private let m_marginAnimation: ref<inkAnimProxy>;

  protected cb func OnInitialize() -> Bool {
    let size: Vector2;
    this.m_root = this.GetRootWidget();
    this.m_maxSize = this.m_root.GetSize();
    size.X = this.m_maxSize.X;
    this.m_root.SetSize(size);
  }

  public final func SetStart(start: Float, opt duration: Float) -> Void {
    this.m_fillStart = ClampF(start, 0.00, 1.00);
    this.AnimateMargin(duration);
  }

  public final func SetEnd(end: Float, opt duration: Float) -> Void {
    this.m_fillStart = ClampF(end, 0.00, 1.00);
    this.AnimateSize(duration);
  }

  private final func AnimateMargin(duration: Float) -> Void {
    let animation: ref<inkAnimDef>;
    let margin: inkMargin;
    let marginInterpolator: ref<inkAnimMargin>;
    if this.m_marginAnimation != null {
      this.m_marginAnimation.Stop();
    };
    margin.bottom = this.m_fillStart * this.m_maxSize.Y;
    if duration == 0.00 {
      this.m_marginAnimation = null;
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
    this.m_marginAnimation = this.m_root.PlayAnimation(animation);
  }

  private final func AnimateSize(duration: Float) -> Void {
    let animation: ref<inkAnimDef>;
    let size: Vector2;
    let sizeInterpolator: ref<inkAnimSize>;
    if this.m_sizeAnimation != null {
      this.m_sizeAnimation.Stop();
    };
    size.X = this.m_maxSize.X;
    size.Y = AbsF(this.m_fillEnd - this.m_fillStart) * this.m_maxSize.Y;
    if duration == 0.00 {
      this.m_sizeAnimation = null;
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
    this.m_sizeAnimation = this.m_root.PlayAnimation(animation);
  }
}
