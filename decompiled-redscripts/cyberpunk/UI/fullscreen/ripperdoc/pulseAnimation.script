
public class PulseAnimation extends IScriptable {

  public let m_root: wref<inkWidget>;

  public let m_anim: ref<inkAnimProxy>;

  public let m_top: Float;

  public let m_bot: Float;

  public let m_time: Float;

  public let m_delay: Float;

  public final func Configure(root: wref<inkWidget>, topOpacity: Float, bottomOpacity: Float, pulseRate: Float, opt delay: Float) -> Void {
    if this.m_anim != null {
      this.m_anim.Stop();
      this.m_anim = null;
    };
    this.m_root = root;
    this.m_top = topOpacity;
    this.m_bot = bottomOpacity;
    this.m_time = pulseRate;
    this.m_delay = delay;
  }

  public final func Configure(root: wref<inkWidget>, params: PulseAnimationParams) -> Void {
    if this.m_anim != null {
      this.m_anim.Stop();
      this.m_anim = null;
    };
    this.m_root = root;
    this.m_top = params.topOpacity;
    this.m_bot = params.bottomOpacity;
    this.m_time = params.pulseRate;
    this.m_delay = params.delay;
  }

  public func Start(opt singleLoop: Bool) -> Void {
    let animData: ref<inkAnimTransparency>;
    let animDef: ref<inkAnimDef>;
    let animOptions: inkAnimOptions;
    if this.m_anim != null {
      this.m_anim.Stop();
    };
    this.m_root.SetOpacity(this.m_top);
    animData = new inkAnimTransparency();
    animData.SetDuration(this.m_time);
    animData.SetStartTransparency(this.m_top);
    animData.SetEndTransparency(this.m_bot);
    if this.m_delay > 0.00 {
      animData.SetStartDelay(this.m_delay);
    };
    animData.SetType(inkanimInterpolationType.Linear);
    animData.SetMode(inkanimInterpolationMode.EasyInOut);
    animOptions.loopType = inkanimLoopType.PingPong;
    animOptions.loopInfinite = !singleLoop;
    animDef = new inkAnimDef();
    animDef.AddInterpolator(animData);
    this.m_anim = this.m_root.PlayAnimationWithOptions(animDef, animOptions);
  }

  public final func Stop() -> Void {
    let animData: ref<inkAnimTransparency>;
    let animDef: ref<inkAnimDef>;
    let time: Float;
    if this.m_anim != null {
      this.m_anim.Stop();
    };
    time = this.m_root.GetOpacity();
    time = (this.m_top - time) * this.m_time;
    animData = new inkAnimTransparency();
    animData.SetDuration(time);
    animData.SetStartTransparency(this.m_root.GetOpacity());
    animData.SetEndTransparency(this.m_top);
    animData.SetType(inkanimInterpolationType.Quintic);
    animData.SetMode(inkanimInterpolationMode.EasyInOut);
    animDef = new inkAnimDef();
    animDef.AddInterpolator(animData);
    this.m_anim = this.m_root.PlayAnimation(animDef);
  }

  public final func ForceStop() -> Void {
    if this.m_anim != null {
      this.m_anim.Stop();
    };
  }
}

public class PulseScaleAnimation extends PulseAnimation {

  public func Start(opt singleLoop: Bool) -> Void {
    let animData: ref<inkAnimScale>;
    let animDef: ref<inkAnimDef>;
    let animOptions: inkAnimOptions;
    if this.m_anim != null {
      this.m_anim.Stop();
    };
    this.m_root.SetOpacity(this.m_top);
    animData = new inkAnimScale();
    animData.SetDuration(this.m_time);
    animData.SetStartScale(new Vector2(this.m_top, this.m_top));
    animData.SetEndScale(new Vector2(this.m_bot, this.m_bot));
    animData.SetType(inkanimInterpolationType.Linear);
    animData.SetMode(inkanimInterpolationMode.EasyInOut);
    animOptions.loopType = inkanimLoopType.PingPong;
    animOptions.loopInfinite = !singleLoop;
    animDef = new inkAnimDef();
    animDef.AddInterpolator(animData);
    this.m_anim = this.m_root.PlayAnimationWithOptions(animDef, animOptions);
  }
}
