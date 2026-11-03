
public class RipperdocSelectorController extends inkLogicController {

  private edit let m_label: inkTextRef;

  private edit let m_leftArrowAnchor: inkWidgetRef;

  private edit let m_rightArrowAnchor: inkWidgetRef;

  private edit const let m_indicatorAnchors: [inkWidgetRef];

  private let m_leftArrow: wref<inkButtonController>;

  private let m_rightArrow: wref<inkButtonController>;

  private let m_indicatorIndex: Int32;

  private let m_indicatorShowAnim: ref<inkAnimProxy>;

  private let m_indicatorHideAnim: ref<inkAnimProxy>;

  private let m_isInTutorial: Bool;

  private let m_names: [String];

  public final func Configure(names: [String]) -> Void {
    this.m_leftArrow = inkWidgetRef.GetControllerByType(this.m_leftArrowAnchor, n"inkButtonController") as inkButtonController;
    this.m_rightArrow = inkWidgetRef.GetControllerByType(this.m_rightArrowAnchor, n"inkButtonController") as inkButtonController;
    this.m_leftArrow.RegisterToCallback(n"OnButtonStateChanged", this, n"OnLeftArrow");
    this.m_rightArrow.RegisterToCallback(n"OnButtonStateChanged", this, n"OnRightArrow");
    this.m_names = names;
    this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnReleaseInput");
  }

  public final func SetIsInTutorial(isInTutorial: Bool) -> Void {
    this.m_isInTutorial = isInTutorial;
  }

  protected cb func OnUninitialize() -> Bool {
    this.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"OnReleaseInput");
  }

  protected cb func OnReleaseInput(e: ref<inkPointerEvent>) -> Bool {
    if !this.m_isInTutorial {
      if e.IsAction(n"option_switch_prev_settings") {
        this.SwitchIndicator(false);
      } else {
        if e.IsAction(n"option_switch_next_settings") {
          this.SwitchIndicator(true);
        };
      };
    };
  }

  private final func OnLeftArrow(controller: wref<inkButtonController>, oldState: inkEButtonState, newState: inkEButtonState) -> Void {
    if Equals(newState, inkEButtonState.Press) {
      this.SwitchIndicator(false);
    };
  }

  private final func OnRightArrow(controller: wref<inkButtonController>, oldState: inkEButtonState, newState: inkEButtonState) -> Void {
    if Equals(newState, inkEButtonState.Press) {
      this.SwitchIndicator(true);
    };
  }

  public final func Show(index: Int32) -> Void {
    this.SetIndicator(index, true);
  }

  public final func Hide() -> Void {
    this.SetIndicator(this.m_indicatorIndex, false);
  }

  private final func SwitchIndicator(toNext: Bool) -> Void {
    let selectorEvent: ref<RipperdocSelectorChangeEvent>;
    this.SetIndicator(this.m_indicatorIndex, false);
    this.SetIndicator(this.WrapIndex(this.m_indicatorIndex + toNext ? 1 : -1), true);
    selectorEvent = new RipperdocSelectorChangeEvent();
    selectorEvent.Index = this.m_indicatorIndex;
    selectorEvent.SlidingRight = toNext;
    this.QueueEvent(selectorEvent);
  }

  private final func SetIndicator(index: Int32, toActive: Bool) -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.m_indicatorAnchors) {
      inkWidgetRef.Get(this.m_indicatorAnchors[i]).SetState(n"Default");
      i += 1;
    };
    if index >= 0 && index < ArraySize(this.m_indicatorAnchors) {
      if toActive {
        this.m_indicatorIndex = index;
        inkTextRef.SetText(this.m_label, this.m_names[index]);
      };
      inkWidgetRef.Get(this.m_indicatorAnchors[index]).SetState(toActive ? n"Selected" : n"Default");
    };
  }

  private final func WrapIndex(index: Int32) -> Int32 {
    if index >= ArraySize(this.m_indicatorAnchors) {
      return 0;
    };
    if index < 0 {
      return ArraySize(this.m_indicatorAnchors) - 1;
    };
    return index;
  }

  public final func GetIndicatorIndex() -> Int32 {
    return this.m_indicatorIndex;
  }
}
