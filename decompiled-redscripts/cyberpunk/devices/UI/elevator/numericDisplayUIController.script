
public class NumericDispalyUIController extends DeviceInkGameControllerBase {

  @runtimeProperty("category", "Widget Refs")
  private edit let m_currentNumberTextWidget: inkTextRef;

  @runtimeProperty("category", "Widget Refs")
  private edit let m_upArrowWidget: inkWidgetRef;

  @runtimeProperty("category", "Widget Refs")
  private edit let m_downArrowWidget: inkWidgetRef;

  @runtimeProperty("category", "Animations")
  @default(NumericDispalyUIController, idle)
  private edit let m_idleAnimName: CName;

  @runtimeProperty("category", "Animations")
  @default(NumericDispalyUIController, going_up)
  private edit let m_goingUpAnimName: CName;

  @runtimeProperty("category", "Animations")
  @default(NumericDispalyUIController, going_down)
  private edit let m_goingDownAnimName: CName;

  private let m_idleAnim: ref<inkAnimProxy>;

  private let m_goingDownAnim: ref<inkAnimProxy>;

  private let m_goingUpAnim: ref<inkAnimProxy>;

  private let m_onNumberChangedListener: ref<CallbackHandle>;

  private let m_onDirectionChangedListener: ref<CallbackHandle>;

  protected func SetupWidgets() -> Void {
    super.SetupWidgets();
    if !this.m_isInitialized {
      this.Initialize();
    };
  }

  protected final func Initialize() -> Void {
    let owner: ref<NumericDisplay> = this.GetOwner();
    if IsDefined(owner) {
      this.SetCurrentNumberOnUI(owner.GetBlackboard().GetInt(owner.GetBlackboardDef().CurrentNumber));
      this.PlayDirectionAnim(owner.GetBlackboard().GetInt(owner.GetBlackboardDef().Direction));
    };
  }

  protected final func SetCurrentNumberOnUI(number: Int32) -> Void {
    let numberStr: String = number < 0 ? "-" : "";
    if Abs(number) < 10 {
      numberStr += "0";
    };
    if Abs(number) < 100 {
      numberStr += "0";
    };
    numberStr += IntToString(Abs(number));
    inkTextRef.SetText(this.m_currentNumberTextWidget, numberStr);
  }

  protected func GetOwner() -> ref<NumericDisplay> {
    return this.GetOwnerEntity() as NumericDisplay;
  }

  protected func RegisterBlackboardCallbacks(blackboard: ref<IBlackboard>) -> Void {
    super.RegisterBlackboardCallbacks(blackboard);
    if IsDefined(blackboard) {
      this.m_onNumberChangedListener = blackboard.RegisterListenerInt(this.GetOwner().GetBlackboardDef().CurrentNumber, this, n"OnCurrentNumberChanged", true);
      this.m_onDirectionChangedListener = blackboard.RegisterListenerInt(this.GetOwner().GetBlackboardDef().Direction, this, n"OnDirectionChanged", true);
    };
  }

  protected func UnRegisterBlackboardCallbacks(blackboard: ref<IBlackboard>) -> Void {
    if IsDefined(blackboard) {
      blackboard.UnregisterListenerInt(this.GetOwner().GetBlackboardDef().CurrentNumber, this.m_onNumberChangedListener);
    };
    super.UnRegisterBlackboardCallbacks(blackboard);
  }

  protected cb func OnCurrentNumberChanged(number: Int32) -> Bool {
    this.SetCurrentNumberOnUI(number);
  }

  protected final func StopUpAnim() -> Void {
    if IsDefined(this.m_goingUpAnim) {
      this.m_goingUpAnim.Pause();
      this.m_goingUpAnim = null;
    };
    inkWidgetRef.SetOpacity(this.m_upArrowWidget, 0.00);
  }

  protected final func StopDownAnim() -> Void {
    if IsDefined(this.m_goingDownAnim) {
      this.m_goingDownAnim.Pause();
      this.m_goingDownAnim = null;
    };
    inkWidgetRef.SetOpacity(this.m_downArrowWidget, 0.00);
  }

  protected final func StopIdleAnim() -> Void {
    if IsDefined(this.m_idleAnim) {
      this.m_idleAnim.Stop();
      this.m_idleAnim = null;
    };
  }

  protected final func PlayUpAnim() -> Void {
    this.StopIdleAnim();
    this.StopDownAnim();
    if !(IsDefined(this.m_goingUpAnim) && this.m_goingUpAnim.IsPlaying()) {
      this.m_goingUpAnim = this.PlayLibraryAnimation(this.m_goingUpAnimName, GetAnimOptionsInfiniteLoop(inkanimLoopType.Cycle));
    };
  }

  protected final func PlayDownAnim() -> Void {
    this.StopIdleAnim();
    this.StopUpAnim();
    if !(IsDefined(this.m_goingDownAnim) && this.m_goingDownAnim.IsPlaying()) {
      this.m_goingDownAnim = this.PlayLibraryAnimation(this.m_goingDownAnimName, GetAnimOptionsInfiniteLoop(inkanimLoopType.Cycle));
    };
  }

  protected final func PlayIdleAnim() -> Void {
    this.StopUpAnim();
    this.StopDownAnim();
    if !(IsDefined(this.m_idleAnim) && this.m_idleAnim.IsPlaying()) {
      this.m_idleAnim = this.PlayLibraryAnimation(this.m_idleAnimName, GetAnimOptionsInfiniteLoop(inkanimLoopType.Cycle));
    };
  }

  protected final func PlayDirectionAnim(direction: Int32) -> Void {
    switch direction {
      case -1:
        this.PlayDownAnim();
        break;
      case 0:
        this.PlayIdleAnim();
        break;
      case 1:
        this.PlayUpAnim();
    };
  }

  protected cb func OnDirectionChanged(direction: Int32) -> Bool {
    this.PlayDirectionAnim(direction);
  }
}
