
public class YaibaShowroomConnectionPage extends inkGameController {

  @default(YaibaShowroomConnectionPage, mq060_muramasa_connected)
  private edit let m_connectionFact: CName;

  private edit let m_connectionButton: inkWidgetRef;

  protected cb func OnInitialize() -> Bool {
    inkWidgetRef.RegisterToCallback(this.m_connectionButton, n"OnRelease", this, n"OnRelease");
  }

  protected cb func OnRelease(e: ref<inkPointerEvent>) -> Bool {
    if e.IsAction(n"click") {
      SetFactValue((this.GetOwnerEntity() as GameObject).GetGame(), this.m_connectionFact, 1);
    };
  }
}
