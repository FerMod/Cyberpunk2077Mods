
public class HoloAudioCallLogicController extends inkLogicController {

  private edit let m_AvatarControllerRef: inkWidgetRef;

  private edit let m_Holder: inkWidgetRef;

  private let m_AvatarController: wref<HudPhoneAvatarController>;

  private let m_Owner: wref<GameObject>;

  protected cb func OnInitialize() -> Bool {
    this.Hide();
    this.m_AvatarController = inkWidgetRef.GetController(this.m_AvatarControllerRef) as HudPhoneAvatarController;
    if IsDefined(this.m_AvatarController) {
      this.m_AvatarController.SetHolder(this.m_Holder);
    };
    inkWidgetRef.RegisterToCallback(this.m_AvatarControllerRef, n"OnAvatarControllerHidden", this, n"OnAvatarControllerHidden");
  }

  protected cb func OnUninitialize() -> Bool {
    inkWidgetRef.UnregisterFromCallback(this.m_AvatarControllerRef, n"OnAvatarControllerHidden", this, n"OnAvatarControllerHidden");
  }

  protected cb func OnAvatarControllerHidden(target: wref<inkWidget>) -> Bool {
    this.GetRootWidget().CallCustomCallback(n"OnHoloAudioCallFinished");
  }

  public final func ShowIncomingContact(avatarID: TweakDBID, const contactName: script_ref<String>) -> Void {
    if IsDefined(this.m_AvatarController) {
      this.m_AvatarController.ShowIncomingContact(avatarID, contactName);
    };
  }

  public final func ShowEndCallContact(avatarID: TweakDBID, const contactName: script_ref<String>) -> Void {
    if IsDefined(this.m_AvatarController) {
      this.m_AvatarController.ShowEndCallContact(avatarID, contactName);
    };
  }

  public final func StartAudiocall(avatarID: TweakDBID, const contactName: script_ref<String>, showAvatar: Bool) -> Void {
    if IsDefined(this.m_AvatarController) {
      this.m_AvatarController.StartAudiocall(avatarID, contactName, showAvatar);
    };
  }

  public final func StartHolocall(avatarID: TweakDBID, const contactName: script_ref<String>) -> Void {
    if IsDefined(this.m_AvatarController) {
      this.m_AvatarController.StartHolocall(avatarID, contactName);
    };
  }

  public final func ChangeMinimized(minimized: Bool) -> Void {
    if IsDefined(this.m_AvatarController) {
      this.m_AvatarController.ChangeMinimized(minimized);
    };
  }

  public final func SetStatusText(const statusText: script_ref<String>) -> Void {
    if IsDefined(this.m_AvatarController) {
      this.m_AvatarController.SetStatusText(statusText);
    };
  }

  public final func Show() -> Void {
    this.GetRootWidget().SetVisible(true);
    inkWidgetRef.SetVisible(this.m_Holder, true);
  }

  public final func Hide() -> Void {
    this.GetRootWidget().SetVisible(false);
    inkWidgetRef.SetVisible(this.m_Holder, false);
  }

  public final func Interrupt(value: Bool) -> Void {
    let anim: ref<inkAnimDef> = new inkAnimDef();
    let interop: ref<inkAnimTransparency> = new inkAnimTransparency();
    interop.SetStartTransparency(value ? 1.00 : 0.00);
    interop.SetEndTransparency(value ? 0.00 : 1.00);
    interop.SetDuration(0.20);
    anim.AddInterpolator(interop);
    this.GetRootWidget().PlayAnimation(anim);
    inkWidgetRef.PlayAnimation(this.m_Holder, anim);
    this.ChangeMinimized(value);
  }
}
