
public class PoliceMessageGameController extends inkHUDGameController {

  private edit let m_messageTextRef: inkTextRef;

  private let m_blackboard: wref<IBlackboard>;

  private let m_blackboardDef: ref<UI_NotificationsDef>;

  private let m_warningMessageCallbackId: ref<CallbackHandle>;

  private let m_simpleMessage: SimpleScreenMessage;

  private let m_root: wref<inkWidget>;

  private let m_animProxy: ref<inkAnimProxy>;

  protected cb func OnInitialize() -> Bool {
    let message: SimpleScreenMessage;
    let msgVariant: Variant;
    this.m_root = this.GetRootWidget();
    this.m_root.SetVisible(false);
    this.m_blackboardDef = GetAllBlackboardDefs().UI_Notifications;
    this.m_blackboard = this.GetBlackboardSystem().Get(this.m_blackboardDef);
    this.m_warningMessageCallbackId = this.m_blackboard.RegisterDelayedListenerVariant(this.m_blackboardDef.WarningMessage, this, n"OnWarningMessageUpdate");
    msgVariant = this.m_blackboard.GetVariant(this.m_blackboardDef.WarningMessage);
    message = FromVariant<SimpleScreenMessage>(msgVariant);
    if IsDefined(msgVariant) && Equals(message.type, SimpleMessageType.Police) {
      this.m_simpleMessage = message;
    };
  }

  protected cb func OnUnitialize() -> Bool {
    this.m_blackboard.UnregisterDelayedListener(this.m_blackboardDef.WarningMessage, this.m_warningMessageCallbackId);
  }

  protected cb func OnWarningMessageUpdate(value: Variant) -> Bool {
    let message: SimpleScreenMessage = FromVariant<SimpleScreenMessage>(value);
    if Equals(message.type, SimpleMessageType.Police) {
      this.m_simpleMessage = message;
      this.UpdateWidgets();
    } else {
      this.m_root.StopAllAnimations();
      if IsDefined(this.m_animProxy) {
        this.m_animProxy.Stop();
      };
      this.m_root.SetVisible(false);
    };
  }

  private final func UpdateWidgets() -> Void {
    this.m_root.StopAllAnimations();
    if this.m_simpleMessage.isShown && NotEquals(this.m_simpleMessage.message, "Lorem Ipsum") && NotEquals(this.m_simpleMessage.message, "") {
      inkTextRef.SetLetterCase(this.m_messageTextRef, textLetterCase.UpperCase);
      inkTextRef.SetText(this.m_messageTextRef, this.m_simpleMessage.message);
      inkTextRef.SetFontSize(this.m_messageTextRef, Cast<Int32>(ProportionalClampF(40.00, 55.00, Cast<Float>(UnicodeLength(inkTextRef.GetText(this.m_messageTextRef))), 37.00, 27.00)));
      GameInstance.GetAudioSystem(this.GetPlayerControlledObject().GetGame()).Play(n"ui_jingle_chip_malfunction");
      if IsDefined(this.m_animProxy) {
        this.m_animProxy.Stop();
      };
      this.m_animProxy = this.PlayLibraryAnimation(n"animation");
      this.m_animProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnFinished");
      this.m_root.SetVisible(true);
    } else {
      if IsDefined(this.m_animProxy) {
        this.m_animProxy.Stop();
      };
      this.m_root.SetVisible(false);
    };
  }

  protected cb func OnFinished(anim: ref<inkAnimProxy>) -> Bool {
    this.m_root.SetVisible(false);
  }
}
