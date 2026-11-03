
public class ProgressBarButton extends inkLogicController {

  protected edit let m_craftingFill: inkWidgetRef;

  protected edit let m_craftingLabel: inkTextRef;

  protected edit let m_craftingIconGlyph: inkWidgetRef;

  public let ButtonController: wref<inkButtonController>;

  private let m_progressController: wref<ProgressBarsController>;

  private let m_available: Bool;

  private let m_progress: Float;

  private let m_isLocked: Bool;

  private let m_justFinished: Bool;

  private let m_animProxy: ref<inkAnimProxy>;

  protected cb func OnInitialize() -> Bool {
    this.ButtonController = this.GetControllerByBaseType(n"inkButtonController") as inkButtonController;
    inkWidgetRef.SetScale(this.m_craftingFill, new Vector2(0.00, 1.00));
    if IsDefined(this.ButtonController) {
      this.ButtonController.RegisterToCallback(n"OnHold", this, n"OnCraftingHoldButton");
      this.ButtonController.RegisterToCallback(n"OnRelease", this, n"OnReleaseButton");
      this.ButtonController.RegisterToCallback(n"OnPress", this, n"OnPressButton");
    };
    this.m_progress = 0.00;
  }

  protected cb func OnCraftingHoldButton(evt: ref<inkPointerEvent>) -> Bool {
    this.UpdateCraftProcess(evt);
  }

  public final func UpdateCraftProcess(evt: ref<inkPointerEvent>) -> Void {
    let finishedProccess: ref<ProgressBarFinishedProccess>;
    if this.m_isLocked || !this.m_available {
      return;
    };
    if evt.IsAction(n"craft_item") {
      this.m_progress = evt.GetHoldProgress();
      this.m_progressController.SetBarProgress(this.m_progress);
      inkWidgetRef.SetScale(this.m_craftingFill, new Vector2(this.m_progress, 1.00));
      inkWidgetRef.SetOpacity(this.m_craftingFill, this.m_progress / 2.00);
      if this.m_progress >= 1.00 {
        inkWidgetRef.SetScale(this.m_craftingFill, new Vector2(0.00, 1.00));
        this.m_progressController.SetBarProgress(0.00);
        finishedProccess = new ProgressBarFinishedProccess();
        this.QueueEvent(finishedProccess);
        this.PlaySound(n"Item", n"OnCrafted");
        this.PlayLibraryAnimation(n"craft_complete_feedback");
        this.m_justFinished = true;
        if IsDefined(this.m_animProxy) {
          this.m_animProxy.GotoEndAndStop(true);
          this.m_animProxy = null;
        };
      };
    };
  }

  public final func Reset() -> Void {
    inkWidgetRef.SetScale(this.m_craftingFill, new Vector2(0.00, 1.00));
    this.m_progressController.SetBarProgress(0.00);
    this.m_progress = 0.00;
    if !this.m_justFinished {
      this.m_animProxy.Pause();
      this.m_animProxy = this.PlayLibraryAnimation(n"crafting_button_rollback");
    };
  }

  public final func Start() -> Void {
    if this.m_isLocked || !this.m_available {
      return;
    };
    if IsDefined(this.m_animProxy) {
      this.m_animProxy.Stop(true);
      this.m_animProxy = null;
    };
    this.m_justFinished = false;
    this.m_animProxy = this.PlayLibraryAnimation(n"crafting_button_progress");
  }

  protected cb func OnReleaseButton(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"craft_item") {
      this.Reset();
      this.PlaySound(n"Item", n"OnCraftFailed");
    };
  }

  protected cb func OnPressButton(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"craft_item") {
      this.PlaySound(n"Item", n"OnCraftStarted");
      this.Start();
    };
  }

  public final func SetupProgressButton(const label: script_ref<String>, progressController: wref<ProgressBarsController>) -> Void {
    this.m_progressController = progressController;
    this.m_progressController.SetBarProgress(0.00);
    inkTextRef.SetText(this.m_craftingLabel, Deref(label));
  }

  public final func SetAvaibility(current: EProgressBarState) -> Void {
    let state: CName;
    if Equals(current, EProgressBarState.Invisible) {
      this.GetRootWidget().SetVisible(false);
      inkWidgetRef.SetVisible(this.m_craftingLabel, false);
      return;
    };
    this.GetRootWidget().SetVisible(true);
    inkWidgetRef.SetVisible(this.m_craftingLabel, true);
    if Equals(current, EProgressBarState.Available) {
      state = n"Default";
      this.m_available = true;
    } else {
      state = n"Blocked";
      this.m_available = false;
    };
    this.GetRootWidget().SetState(state);
    this.SetIconGlyph();
  }

  public final func Lock() -> Void {
    this.m_isLocked = true;
  }

  public final func Unlock() -> Void {
    this.m_isLocked = false;
  }

  private final func SetIconGlyph() -> Void {
    let glyph: ref<inkWidget> = inkWidgetRef.Get(this.m_craftingIconGlyph);
    if !IsDefined(glyph) {
      return;
    };
    glyph.SetVisible(this.m_available);
  }

  protected cb func OnUnitialize() -> Bool {
    this.ButtonController.UnregisterFromCallback(n"OnHold", this, n"OnCraftingHoldButton");
    this.ButtonController.UnregisterFromCallback(n"OnRelease", this, n"OnReleaseButton");
  }
}
