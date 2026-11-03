
public native class gameuiGenericNotificationGameController extends inkGameController {

  protected native let notificationsRoot: inkCompoundRef;

  public final native func AddNewNotificationData(notification: gameuiGenericNotificationData) -> Void;

  public final native func RemoveNotification(notification: ref<IScriptable>) -> Void;

  public final native func SetNotificationPaused(value: Bool) -> Void;

  public final native func SetNotificationPauseWhenHidden(value: Bool) -> Void;

  public final native func GetBlackBarFullscreenWidgetOffsets() -> Vector2;

  public final native func GetHudSafezoneWidgetOffsets() -> Vector2;

  public final native func MakeSilent(value: Bool) -> Void;

  public final native func RemoveAllQueuedNotifications() -> Void;

  public func GetShouldSaveState() -> Bool {
    return false;
  }

  public func GetID() -> Int32 {
    return 0;
  }

  protected cb func OnMakeNotificationQueueSilent(evt: ref<MakeNotificationQueueSilentEvent>) -> Bool {
    if this.GetID() == EnumInt(evt.m_notificationType) {
      this.MakeSilent(evt.m_makeSilent);
    };
  }

  protected cb func OnCleanupUiNotificationsEvent(evt: ref<CleanupUiNotificationsEvent>) -> Bool {
    this.RemoveAllQueuedNotifications();
  }
}
