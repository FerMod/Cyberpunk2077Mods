
public class FakePhoneContactItemVirtualController extends PhoneContactItemVirtualController {

  private edit let m_dots: inkWidgetRef;

  protected cb func OnDataChanged(value: Variant) -> Bool {
    this.m_contactData = FromVariant<ref<IScriptable>>(value) as ContactData;
    inkTextRef.SetText(this.m_label, this.m_contactData.localizedName);
    inkWidgetRef.SetVisible(this.m_label, NotEquals(this.m_contactData.localizedName, ""));
    inkTextRef.SetFontStyle(this.m_label, n"Regular");
    inkWidgetRef.SetVisible(this.m_dots, Equals(this.m_contactData.localizedName, ""));
    if IsDefined(this.m_animProxySelection) {
      this.m_animProxySelection.GotoStartAndStop(true);
      this.m_animProxySelection = null;
    };
    this.m_pulse.Stop();
    this.m_root.SetState(n"Disabled");
  }
}

public class PhoneContactItemVirtualController extends inkVirtualCompoundItemController {

  protected edit let m_label: inkTextRef;

  private edit let m_preview: inkTextRef;

  private edit let m_msgCount: inkTextRef;

  private edit let m_msgIndicator: inkWidgetRef;

  private edit let m_questFlag: inkWidgetRef;

  private edit let m_regFlag: inkWidgetRef;

  private edit let m_replyAlertIcon: inkWidgetRef;

  @runtimeProperty("category", "INPUT HINTS")
  private edit let m_callInputHint: inkWidgetRef;

  @runtimeProperty("category", "INPUT HINTS")
  private edit let m_chatInputHint: inkWidgetRef;

  @runtimeProperty("category", "INPUT HINTS")
  private edit let m_separtor: inkWidgetRef;

  protected let m_animProxySelection: ref<inkAnimProxy>;

  private let m_animProxyHide: ref<inkAnimProxy>;

  protected let m_contactData: ref<ContactData>;

  protected let m_pulse: ref<PulseAnimation>;

  private let isQuestImportant: Bool;

  private let isUnread: Bool;

  private let m_isCallingEnabled: Bool;

  protected let m_root: wref<inkWidget>;

  public final func GetContactData() -> ref<ContactData> {
    return this.m_contactData;
  }

  protected cb func OnInitialize() -> Bool {
    this.RegisterToCallback(n"OnSelected", this, n"OnSelected");
    this.RegisterToCallback(n"OnDeselected", this, n"OnDeselected");
    this.m_pulse = new PulseAnimation();
    this.m_pulse.Configure(inkWidgetRef.Get(this.m_questFlag), 1.00, 0.20, 0.60);
    this.m_root = this.GetRootWidget();
  }

  protected cb func OnDataChanged(value: Variant) -> Bool {
    this.m_contactData = FromVariant<ref<IScriptable>>(value) as ContactData;
    inkTextRef.SetText(this.m_label, this.m_contactData.localizedName);
    if this.m_contactData.hasValidTitle {
      inkTextRef.SetText(this.m_preview, this.m_contactData.localizedPreview);
    } else {
      if this.m_contactData.playerIsLastSender {
        inkTextRef.SetText(this.m_preview, GetLocalizedTextByKey(n"UI-Phone-LabelYou") + ": " + GetLocalizedText(this.m_contactData.lastMesssagePreview));
      } else {
        inkTextRef.SetText(this.m_preview, this.m_contactData.lastMesssagePreview);
      };
    };
    this.SetTimeText(this.m_contactData.timeStamp);
    inkWidgetRef.SetVisible(this.m_replyAlertIcon, this.m_contactData.playerCanReply);
    inkWidgetRef.SetVisible(this.m_msgCount, !this.m_contactData.playerCanReply);
    if IsDefined(this.m_animProxySelection) {
      this.m_animProxySelection.GotoStartAndStop(true);
      this.m_animProxySelection = null;
    };
    this.m_pulse.Stop();
    if this.m_contactData.questRelated || this.m_contactData.hasQuestImportantReply {
      inkWidgetRef.SetVisible(this.m_questFlag, true);
      this.m_pulse.Start();
      this.isQuestImportant = true;
    } else {
      inkWidgetRef.SetVisible(this.m_questFlag, false);
      this.isQuestImportant = false;
    };
    inkWidgetRef.SetVisible(this.m_regFlag, !this.isQuestImportant);
    this.m_root.SetState(n"Default");
    inkTextRef.SetFontStyle(this.m_label, n"Medium");
    if NotEquals(this.m_contactData.type, MessengerContactType.Contact) {
      if ArraySize(this.m_contactData.unreadMessages) > 0 {
        this.isUnread = true;
        inkWidgetRef.SetVisible(this.m_msgIndicator, true);
        inkTextRef.SetFontStyle(this.m_preview, n"Medium");
        inkTextRef.SetFontStyle(this.m_label, n"Semi-Bold");
      } else {
        this.isUnread = false;
        inkWidgetRef.SetVisible(this.m_msgIndicator, false);
        this.m_root.SetState(n"Disabled");
        inkTextRef.SetFontStyle(this.m_preview, n"Regular");
        inkTextRef.SetFontStyle(this.m_label, n"Regular");
      };
      if this.m_contactData.playerCanReply {
        this.m_root.SetState(n"Reply");
      };
    };
    if Equals(this.m_contactData.type, MessengerContactType.Contact) && !this.m_contactData.isCallable {
      this.m_root.SetState(n"Disabled");
    };
    if this.isQuestImportant {
      this.m_root.SetState(n"Quest");
    };
    inkWidgetRef.SetVisible(this.m_callInputHint, this.m_contactData.isCallable);
    inkWidgetRef.SetVisible(this.m_chatInputHint, this.m_contactData.hasMessages || this.m_contactData.playerCanReply);
    inkWidgetRef.SetVisible(this.m_separtor, inkWidgetRef.IsVisible(this.m_chatInputHint) && inkWidgetRef.IsVisible(this.m_callInputHint));
  }

  public final func Hide() -> Void {
    if this.m_animProxyHide != null {
      this.m_animProxyHide.UnregisterFromAllCallbacks(inkanimEventType.OnFinish);
      this.m_animProxyHide.GotoStartAndStop(true);
      this.m_animProxyHide = null;
    };
    this.PlayScaleToRemoveAnimation();
    this.m_animProxyHide.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnHideAnimFinished");
  }

  public final func SetCallingEnabled(enabled: Bool) -> Void {
    this.m_isCallingEnabled = enabled;
  }

  public final func Refresh(select: Bool) -> Void {
    this.OnDataChanged(ToVariant(this.m_contactData));
    if select {
      this.OnSelected(null, false);
    };
  }

  protected cb func OnHideAnimFinished(proxy: ref<inkAnimProxy>) -> Bool {
    let evt: ref<PhoneContactHiddenEvent>;
    this.m_animProxyHide.UnregisterFromAllCallbacks(inkanimEventType.OnFinish);
    this.m_animProxyHide.GotoStartAndStop(true);
    this.m_animProxyHide = null;
    evt = new PhoneContactHiddenEvent();
    evt.HiddenItem = this;
    this.QueueEvent(evt);
    this.GetRootWidget().SetVisible(false);
    this.GetRootWidget().SetScale(new Vector2(1.00, 1.00));
  }

  private final func SetTimeText(time: GameTime) -> Void {
    let textParams: ref<inkTextParams> = new inkTextParams();
    inkTextRef.SetText(this.m_msgCount, "{TIME,time,hh:mm}");
    textParams.AddTime("TIME", time);
    inkTextRef.SetTextParameters(this.m_msgCount, textParams);
  }

  protected cb func OnSelected(itemController: wref<inkVirtualCompoundItemController>, discreteNav: Bool) -> Bool {
    let animOptions: inkAnimOptions;
    if IsDefined(this.m_animProxySelection) {
      this.m_animProxySelection.GotoStartAndStop(true);
      this.m_animProxySelection = null;
    };
    animOptions.loopInfinite = true;
    animOptions.loopType = inkanimLoopType.Cycle;
    this.m_animProxySelection = this.PlayLibraryAnimation(n"loopSelected", animOptions);
    this.m_root.SetState(n"Active");
    if NotEquals(this.m_contactData.type, MessengerContactType.Contact) {
      if !this.isUnread {
        this.m_root.SetState(n"DisabledActive");
      };
      if this.m_contactData.playerCanReply {
        this.m_root.SetState(n"ReplyActive");
      };
    };
    if Equals(this.m_contactData.type, MessengerContactType.Contact) && !this.m_contactData.isCallable {
      this.m_root.SetState(n"DisabledActive");
    };
    if this.isQuestImportant {
      this.m_root.SetState(n"QuestActive");
    };
    inkWidgetRef.SetOpacity(this.m_callInputHint, this.m_isCallingEnabled ? 1.00 : 0.30);
  }

  protected cb func OnDeselected(itemController: wref<inkVirtualCompoundItemController>) -> Bool {
    if IsDefined(this.m_animProxySelection) {
      this.m_animProxySelection.GotoStartAndStop(true);
      this.m_animProxySelection = null;
    };
    this.m_root.SetState(n"Default");
    if NotEquals(this.m_contactData.type, MessengerContactType.Contact) {
      if !this.isUnread {
        this.m_root.SetState(n"Disabled");
      };
      if this.m_contactData.playerCanReply {
        this.m_root.SetState(n"Reply");
      };
    };
    if Equals(this.m_contactData.type, MessengerContactType.Contact) && !this.m_contactData.isCallable {
      this.m_root.SetState(n"Disabled");
    };
    if this.isQuestImportant {
      this.m_root.SetState(n"Quest");
    };
  }

  public final func OpenInChat() -> Void {
    if IsDefined(this.m_animProxySelection) {
      this.m_animProxySelection.GotoStartAndStop(true);
      this.m_animProxySelection = null;
    };
    this.m_animProxySelection = this.PlayLibraryAnimation(n"contactSelected");
  }

  public final func PlayScaleToRemoveAnimation() -> Void {
    let animData: ref<inkAnimScale>;
    let animDef: ref<inkAnimDef>;
    if this.m_animProxyHide != null {
      this.m_animProxyHide.Stop();
    };
    animData = new inkAnimScale();
    animData.SetDuration(0.20);
    animData.SetStartDelay(0.25);
    animData.SetStartScale(new Vector2(1.00, 1.00));
    animData.SetEndScale(new Vector2(1.00, 0.00));
    animData.SetType(inkanimInterpolationType.Quintic);
    animData.SetMode(inkanimInterpolationMode.EasyOut);
    animDef = new inkAnimDef();
    animDef.AddInterpolator(animData);
    this.m_animProxyHide = this.GetRootWidget().PlayAnimation(animDef);
  }
}
