
public class ApartmentScreenInkGameController extends LcdScreenInkGameController {

  protected let m_backgroundFrameWidget: wref<inkImage>;

  public func Refresh(state: EDeviceStatus) -> Void {
    this.m_messegeRecord = this.GetOwner().GetMessageRecord();
    super.Refresh(state);
  }

  protected func SetupWidgets() -> Void {
    if !this.m_isInitialized {
      this.m_defaultUI = this.GetWidget(n"default_ui") as inkCanvas;
      this.m_backgroundFrameWidget = this.GetWidget(n"default_ui/main_content_panel/background_canvas/background_frame") as inkImage;
      this.m_messegeWidget = this.GetWidget(n"default_ui/main_content_panel/messege_text") as inkText;
      this.m_mainDisplayWidget = this.GetWidget(n"main_display") as inkVideo;
      this.m_backgroundWidget = this.GetWidget(n"default_ui/main_content_panel/background_canvas/messege_background") as inkLeafWidget;
      this.m_rootWidget.SetAnchor(inkEAnchor.Fill);
    };
  }

  protected func RegisterBlackboardCallbacks(blackboard: ref<IBlackboard>) -> Void {
    super.RegisterBlackboardCallbacks(blackboard);
  }

  protected func GetOwner() -> ref<ApartmentScreen> {
    return this.GetOwnerEntity() as ApartmentScreen;
  }

  protected func ResolveMessegeRecord(record: wref<ScreenMessageData_Record>) -> Void {
    let textParams: ref<inkTextParams>;
    super.ResolveMessegeRecord(record);
    if this.m_backgroundFrameWidget != null {
      this.m_backgroundFrameWidget.SetTintColor(this.GetColorFromArray(record.BackgroundColor()));
      this.m_backgroundFrameWidget.SetOpacity(record.BackgroundOpacity());
    };
    if Equals(this.GetOwner().GetCurrentRentStatus(), ERentStatus.OVERDUE) && this.GetOwner().ShouldShowOverdueValue() {
      textParams = new inkTextParams();
      textParams.AddNumber("DAYS_COUNT", this.GetOwner().GetCurrentOverdueValue());
      textParams.AddLocalizedString("DAYS", "LocKey#6344");
      this.m_messegeWidget.SetTextParameters(textParams);
    };
  }
}
