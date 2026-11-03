
public class MoneyLabelController extends inkTextValueProgressController {

  private let m_animation: ref<inkAnimProxy>;

  private let m_currentMoney: Float;

  private let m_pulse: ref<PulseAnimation>;

  protected cb func OnInitialize() -> Bool {
    this.m_pulse = new PulseAnimation();
    this.m_pulse.Configure(this.GetRootWidget(), 1.00, 0.50, 0.30);
  }

  public final func SetMoney(newValue: Int32, opt delay: Float, opt duration: Float) -> Void {
    if this.m_animation != null {
      this.m_animation.Stop();
    };
    if duration <= 0.00 {
      duration = 0.01;
    };
    this.m_pulse.Start(false);
    this.SetDelay(delay);
    this.SetDuration(duration);
    this.SetBaseValue(this.m_currentMoney);
    this.m_currentMoney = Cast<Float>(newValue);
    this.SetTargetValue(this.m_currentMoney);
    this.m_animation = this.PlaySetAnimation();
    this.m_animation.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnMainAnimationOver");
  }

  protected cb func OnMainAnimationOver(e: ref<inkAnimProxy>) -> Bool {
    this.m_pulse.Stop();
  }
}
