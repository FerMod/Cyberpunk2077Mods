
public native class GenericNotificationViewData extends IScriptable {

  public native let title: String;

  public native let text: String;

  public native let soundEvent: CName;

  public native let soundAction: CName;

  public let action: ref<GenericNotificationBaseAction>;

  public func CanMerge(data: ref<GenericNotificationViewData>) -> Bool {
    return false;
  }

  public func OnRemoveNotification(data: ref<IScriptable>) -> Bool {
    return false;
  }

  public func GetPriority() -> Int32 {
    return 0;
  }
}

public class GenericNotificationController extends gameuiGenericNotificationReceiverGameController {

  protected edit let m_titleRef: inkTextRef;

  protected edit let m_textRef: inkTextRef;

  protected edit let m_actionLabelRef: inkTextRef;

  protected edit let m_actionRef: inkWidgetRef;

  protected let m_paused: Bool;

  protected let m_blockAction: Bool;

  private let translationAnimationCtrl: wref<inkTextReplaceController>;

  private let m_data: ref<GenericNotificationViewData>;

  private let m_player: wref<GameObject>;

  private let m_isInteractive: Bool;

  @default(LevelUpNotification, NotificationOpenLvlup)
  protected let m_customInputActionName: CName;

  protected cb func OnInitialize() -> Bool {
    this.m_player = this.GetPlayerControlledObject();
    this.RegisterToCallback(n"OnNotificationPaused", this, n"OnNotificationPaused");
    this.RegisterToCallback(n"OnNotificationResumed", this, n"OnNotificationResumed");
  }

  protected cb func OnUninitialize() -> Bool {
    this.UnregisterFromCallback(n"OnNotificationPaused", this, n"OnNotificationPaused");
    this.UnregisterFromCallback(n"OnNotificationResumed", this, n"OnNotificationResumed");
    if this.m_isInteractive {
      this.GetPlayerControlledObject().UnregisterInputListener(this);
    };
  }

  protected cb func OnNotificationPaused() -> Bool {
    this.m_paused = true;
  }

  protected cb func OnNotificationResumed() -> Bool {
    this.m_paused = false;
  }

  public func SetNotificationData(notificationData: ref<GenericNotificationViewData>) -> Void {
    this.m_data = notificationData;
    if this.m_data.action != null {
      inkWidgetRef.SetVisible(this.m_actionRef, true);
      inkTextRef.SetText(this.m_actionLabelRef, this.m_data.action.GetLabel());
      this.m_isInteractive = true;
      this.GetPlayerControlledObject().RegisterInputListener(this, this.GetInputActionName());
    } else {
      inkWidgetRef.SetVisible(this.m_actionRef, false);
      this.m_isInteractive = false;
    };
    if inkWidgetRef.IsValid(this.m_titleRef) {
      inkTextRef.SetText(this.m_titleRef, this.m_data.title);
    };
    if inkWidgetRef.IsValid(this.m_textRef) {
      this.translationAnimationCtrl = inkWidgetRef.GetController(this.m_textRef) as inkTextReplaceController;
      if IsDefined(this.translationAnimationCtrl) {
        this.translationAnimationCtrl.SetTargetText(this.m_data.text);
        this.translationAnimationCtrl.PlaySetAnimation();
      } else {
        inkTextRef.SetText(this.m_textRef, this.m_data.text);
      };
    };
    if NotEquals(this.m_data.soundEvent, n"None") && NotEquals(this.m_data.soundAction, n"None") {
      this.PlaySound(this.m_data.soundEvent, this.m_data.soundAction);
    };
  }

  protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    if this.m_paused || this.m_blockAction {
      return false;
    };
    if Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_RELEASED) {
      if this.m_data.action.Execute(this.m_data) {
        this.OnActionTriggered();
      };
    };
  }

  private final func GetInputActionName() -> CName {
    return NotEquals(this.m_customInputActionName, n"None") ? this.m_customInputActionName : n"NotificationOpen";
  }

  private func OnActionTriggered() -> Void;
}
