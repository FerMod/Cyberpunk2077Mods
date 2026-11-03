
public class TransmogButtonView extends BaseButtonView {

  private edit let m_container: inkWidgetRef;

  private let m_isActive: Bool;

  public final func SetActive(value: Bool) -> Void {
    if NotEquals(this.m_isActive, value) {
      this.m_isActive = value;
      inkWidgetRef.SetState(this.m_container, value ? n"Active" : n"Default");
    };
  }

  public final func IsActive() -> Bool {
    return this.m_isActive;
  }

  protected cb func OnButtonStateChanged(controller: wref<inkButtonController>, oldState: inkEButtonState, newState: inkEButtonState) -> Bool {
    super.OnButtonStateChanged(controller, oldState, newState);
    if Equals(newState, inkEButtonState.Normal) {
      this.GetRootWidget().SetState(n"DefaultTransmog");
    } else {
      if Equals(newState, inkEButtonState.Hover) {
        this.GetRootWidget().SetState(n"Hover");
      };
    };
  }
}
