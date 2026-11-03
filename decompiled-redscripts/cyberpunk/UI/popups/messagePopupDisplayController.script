
public class MessagePopupDisplayController extends inkLogicController {

  protected edit let m_title: inkTextRef;

  protected edit let m_message: inkTextRef;

  protected edit let m_image: inkImageRef;

  public final func SetData(const data: script_ref<PopupData>, opt settings: PopupSettings) -> Void {
    inkTextRef.SetText(this.m_title, Deref(data).title);
    inkTextRef.SetText(this.m_message, Deref(data).message);
    if TDBID.IsValid(Deref(data).iconID) {
      inkWidgetRef.SetVisible(this.m_image, true);
      InkImageUtils.RequestSetImage(this, this.m_image, Deref(data).iconID);
    } else {
      inkWidgetRef.SetVisible(this.m_image, false);
    };
  }
}
