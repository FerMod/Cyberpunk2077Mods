
public native class gameuiHudSafezonesEditorGameController extends gameuiMenuGameController {

  private let m_data: wref<inkGameNotificationData>;

  @default(gameuiHudSafezonesEditorGameController, 400.0f)
  private const let c_adjustment_speed: Float;

  @default(gameuiHudSafezonesEditorGameController, 0.f)
  private const let c_stick_dead_zone: Float;

  public final native func AdjustMargin(adjustment: Vector2) -> Void;

  public final native func SaveSettings() -> Void;

  protected cb func OnInitialize() -> Bool {
    this.m_data = this.GetRootWidget().GetUserData(n"inkGameNotificationData") as inkGameNotificationData;
    this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnRelease");
    this.RegisterToGlobalInputCallback(n"OnPostOnAxis", this, n"OnAxisInput");
  }

  protected cb func OnUninitialize() -> Bool {
    this.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"OnRelease");
    this.UnregisterFromGlobalInputCallback(n"OnPostOnAxis", this, n"OnAxisInput");
  }

  protected cb func OnRelease(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"close_popup") || evt.IsAction(n"proceed") {
      if evt.IsAction(n"proceed") {
        this.SaveSettings();
      };
      this.m_data.token.TriggerCallback(this.m_data);
    };
  }

  protected cb func OnAxisInput(evt: ref<inkPointerEvent>) -> Bool {
    let amount: Float = evt.GetAxisData();
    if AbsF(amount) < this.c_stick_dead_zone {
      return false;
    };
    if evt.IsAction(n"LeftX_Axis") || evt.IsAction(n"DigitX_Axis") {
      this.AdjustMargin(new Vector2(amount * this.c_adjustment_speed * -1.00, 0.00));
    };
  }
}
