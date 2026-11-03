
public class NewAreaGameController extends inkHUDGameController {

  private edit let m_label: inkTextRef;

  private let m_animationProxy: ref<inkAnimProxy>;

  private let m_data: ref<NewAreaDiscoveredUserData>;

  protected cb func OnInitialize() -> Bool;

  private final func Setup() -> Void;

  private final func PlayIntroAnimation() -> Void {
    this.m_animationProxy = this.PlayLibraryAnimation(n"Outro");
    this.m_animationProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnOutroAnimFinished");
  }

  protected cb func OnOutroAnimFinished(anim: ref<inkAnimProxy>) -> Bool {
    let fakeData: ref<inkGameNotificationData>;
    this.m_data.token.TriggerCallback(fakeData);
  }
}
