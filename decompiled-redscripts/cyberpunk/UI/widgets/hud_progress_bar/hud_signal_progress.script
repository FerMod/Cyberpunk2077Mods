
public class HUDSignalProgressBarController extends inkHUDGameController {

  private edit let m_bar: inkWidgetRef;

  private edit let m_signalBar: inkWidgetRef;

  private edit let m_completed: inkWidgetRef;

  private edit let m_signalLost: inkWidgetRef;

  private edit let m_percent: inkTextRef;

  private edit let m_signalPercent: inkTextRef;

  private edit let m_signalLabel: inkWidgetRef;

  private edit let m_signalWrapper: inkWidgetRef;

  private edit let m_appearance: CName;

  @default(HUDSignalProgressBarController, warning)
  private edit let m_SignalLostAnimationName: CName;

  @default(HUDSignalProgressBarController, intro)
  private edit let m_IntroAnimationName: CName;

  @default(HUDSignalProgressBarController, outro)
  private edit let m_OutroAnimationName: CName;

  private edit let m_InRangeAnimationName: CName;

  private edit let m_OutOfRangeAnimationName: CName;

  @default(HUDSignalProgressBarController, true)
  private edit let m_addPercentSign: Bool;

  @default(HUDSignalProgressBarController, false)
  private edit let m_handleOnComplete: Bool;

  private let m_rootWidget: wref<inkWidget>;

  private let m_progressBarBB: wref<IBlackboard>;

  private let m_progressBarDef: ref<UI_HUDSignalProgressBarDef>;

  private let m_stateBBID: ref<CallbackHandle>;

  private let m_progressBBID: ref<CallbackHandle>;

  private let m_signalStrengthBBID: ref<CallbackHandle>;

  private let m_orientationBBID: ref<CallbackHandle>;

  private let m_appearanceBBID: ref<CallbackHandle>;

  private let m_data: HUDProgressBarData;

  private let m_OutroAnimation: ref<inkAnimProxy>;

  private let m_SignalLostAnimation: ref<inkAnimProxy>;

  private let m_IntroAnimation: ref<inkAnimProxy>;

  private let m_OrientationAnimation: ref<inkAnimProxy>;

  private let m_alpha_fadein: ref<inkAnimDef>;

  private let m_AnimProxy: ref<inkAnimProxy>;

  private let m_AnimOptions: inkAnimOptions;

  private let alphaInterpolator: ref<inkAnimTransparency>;

  private let tick: Float;

  private let m_isAppearanceMatch: Bool;

  private let m_barSize: Vector2;

  private let m_signalBarSize: Vector2;

  protected cb func OnInitialize() -> Bool {
    this.m_rootWidget = this.GetRootWidget();
    this.m_rootWidget.SetVisible(false);
    this.SetupBB();
    this.m_barSize = inkWidgetRef.GetSize(this.m_bar);
    this.m_signalBarSize = inkWidgetRef.GetSize(this.m_signalBar);
  }

  protected cb func OnUnInitialize() -> Bool {
    this.UnregisterFromBB();
  }

  private final func SetupBB() -> Void {
    this.m_progressBarDef = GetAllBlackboardDefs().UI_HUDSignalProgressBar;
    this.m_progressBarBB = this.GetBlackboardSystem().Get(this.m_progressBarDef);
    if IsDefined(this.m_progressBarBB) {
      this.m_stateBBID = this.m_progressBarBB.RegisterDelayedListenerUint(this.m_progressBarDef.State, this, n"OnStateChanged");
      this.m_progressBBID = this.m_progressBarBB.RegisterDelayedListenerFloat(this.m_progressBarDef.Progress, this, n"OnProgressChanged");
      this.m_signalStrengthBBID = this.m_progressBarBB.RegisterDelayedListenerFloat(this.m_progressBarDef.SignalStrength, this, n"OnSignalStrengthChanged");
      this.m_orientationBBID = this.m_progressBarBB.RegisterDelayedListenerUint(this.m_progressBarDef.Orientation, this, n"OnOrientationChanged");
      this.m_appearanceBBID = this.m_progressBarBB.RegisterListenerName(this.m_progressBarDef.Appearance, this, n"OnAppearanceChanged");
    };
  }

  private final func UnregisterFromBB() -> Void {
    this.m_progressBarBB.UnregisterDelayedListener(this.m_progressBarDef.State, this.m_stateBBID);
    this.m_progressBarBB.UnregisterDelayedListener(this.m_progressBarDef.Progress, this.m_progressBBID);
    this.m_progressBarBB.UnregisterDelayedListener(this.m_progressBarDef.SignalStrength, this.m_signalStrengthBBID);
    this.m_progressBarBB.UnregisterDelayedListener(this.m_progressBarDef.Orientation, this.m_orientationBBID);
    this.m_progressBarBB.UnregisterListenerName(this.m_progressBarDef.Appearance, this.m_appearanceBBID);
  }

  protected cb func OnAppearanceChanged(appearance: CName) -> Bool {
    this.m_isAppearanceMatch = Equals(appearance, this.m_appearance);
  }

  protected cb func OnStateChanged(state: Uint32) -> Bool {
    let enumState: ProximityProgressBarState;
    if this.m_isAppearanceMatch {
      enumState = IntEnum<ProximityProgressBarState>(state);
      if Equals(enumState, ProximityProgressBarState.Active) {
        this.Show();
      } else {
        if Equals(enumState, ProximityProgressBarState.Complete) {
          if this.m_handleOnComplete {
            this.Completed();
          } else {
            inkWidgetRef.SetVisible(this.m_signalLabel, false);
            inkWidgetRef.SetVisible(this.m_signalWrapper, false);
          };
        } else {
          if Equals(enumState, ProximityProgressBarState.Inactive) {
            this.Hide();
          };
        };
      };
    };
  }

  protected cb func OnProgressChanged(progress: Float) -> Bool {
    if this.m_isAppearanceMatch {
      this.UpdateTimerProgress(progress);
    };
  }

  protected cb func OnSignalStrengthChanged(signalStrength: Float) -> Bool {
    if this.m_isAppearanceMatch {
      this.UpdateSignalProgress(signalStrength);
    };
  }

  protected cb func OnOrientationChanged(orientation: Uint32) -> Bool {
    let enumOrientation: ProximityProgressBarOrientation;
    if this.m_isAppearanceMatch {
      enumOrientation = IntEnum<ProximityProgressBarOrientation>(orientation);
      if Equals(enumOrientation, ProximityProgressBarOrientation.InRange) {
        this.InRange();
      } else {
        if Equals(enumOrientation, ProximityProgressBarOrientation.OutOfRange) {
          this.OutOfRange();
        };
      };
    };
  }

  public final func UpdateTimerProgress(value: Float) -> Void {
    let str: String;
    inkWidgetRef.SetSize(this.m_bar, new Vector2(value * this.m_barSize.X, this.m_barSize.Y));
    str = FloatToStringPrec(value * 100.00, 0);
    if this.m_addPercentSign {
      str = str + "%";
    };
    inkTextRef.SetText(this.m_percent, str);
  }

  public final func UpdateSignalProgress(value: Float) -> Void {
    let str: String;
    inkWidgetRef.SetSize(this.m_signalBar, new Vector2(value * this.m_signalBarSize.X, this.m_signalBarSize.Y));
    str = FloatToStringPrec(value * 100.00, 0);
    if this.m_addPercentSign {
      str = str + "%";
    };
    inkTextRef.SetText(this.m_signalPercent, str);
  }

  private final func SignalLost(val: Bool) -> Void {
    if val {
      if !this.m_SignalLostAnimation.IsPlaying() && NotEquals(this.m_SignalLostAnimationName, n"None") {
        this.m_SignalLostAnimation = this.PlayLibraryAnimation(this.m_SignalLostAnimationName);
      };
    } else {
      if this.m_SignalLostAnimation.IsPlaying() {
        this.m_SignalLostAnimation.Stop();
      };
    };
  }

  private final func InRange() -> Void {
    if IsDefined(this.m_OrientationAnimation) {
      this.m_OrientationAnimation.Stop();
    };
    if NotEquals(this.m_InRangeAnimationName, n"None") {
      this.m_OrientationAnimation = this.PlayLibraryAnimation(this.m_InRangeAnimationName);
    };
  }

  private final func OutOfRange() -> Void {
    if IsDefined(this.m_OrientationAnimation) {
      this.m_OrientationAnimation.Stop();
    };
    if NotEquals(this.m_OutOfRangeAnimationName, n"None") {
      this.m_OrientationAnimation = this.PlayLibraryAnimation(this.m_OutOfRangeAnimationName);
    };
  }

  private final func Show() -> Void {
    this.m_rootWidget.SetVisible(true);
    inkWidgetRef.SetVisible(this.m_signalLabel, true);
    inkWidgetRef.SetVisible(this.m_signalWrapper, true);
    if IsDefined(this.m_IntroAnimation) {
      this.m_IntroAnimation.Stop();
    };
    if IsDefined(this.m_OutroAnimation) {
      this.m_OutroAnimation.Stop();
    };
    if NotEquals(this.m_IntroAnimationName, n"None") {
      this.m_IntroAnimation = this.PlayLibraryAnimation(this.m_IntroAnimationName);
    };
  }

  private final func Completed() -> Void {
    this.m_rootWidget.SetVisible(true);
    if IsDefined(this.m_IntroAnimation) {
      this.m_IntroAnimation.Stop();
    };
    if IsDefined(this.m_OutroAnimation) {
      this.m_OutroAnimation.Stop();
    };
    if NotEquals(this.m_OutroAnimationName, n"None") {
      this.m_OutroAnimation = this.PlayLibraryAnimation(this.m_OutroAnimationName);
      this.m_OutroAnimation.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnHide");
    };
  }

  protected cb func OnHide(proxy: ref<inkAnimProxy>) -> Bool {
    this.m_rootWidget.SetVisible(false);
    proxy.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnHide");
  }

  private final func Hide() -> Void {
    this.m_rootWidget.SetVisible(false);
  }
}
