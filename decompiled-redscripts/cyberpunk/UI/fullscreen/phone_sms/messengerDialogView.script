
public class MessengerDialogViewController extends inkLogicController {

  private edit let m_messagesList: inkCompoundRef;

  private edit let m_choicesList: inkCompoundRef;

  private edit let m_replayFluff: inkCompoundRef;

  private edit let m_typingFluff: inkWidgetRef;

  private edit let m_typingIndicator: inkWidgetRef;

  private let m_messagesListController: wref<JournalEntriesListController>;

  private let m_choicesListController: wref<JournalEntriesListController>;

  private let m_scrollController: wref<inkScrollController>;

  private let m_typingIndicatorController: wref<MessengerTypingIndicator>;

  private let m_journalManager: wref<JournalManager>;

  private let m_playerObject: wref<GameObject>;

  private let m_delaySystem: wref<DelaySystem>;

  private let m_delayedTypingCallbackId: DelayID;

  private let m_replyOptions: [wref<JournalEntry>];

  private let m_messages: [wref<JournalEntry>];

  private let m_parentEntry: wref<JournalEntry>;

  private let m_parentHash: Int32;

  private let m_conversationHash: Int32;

  private let m_contactHash: Int32;

  private let m_typingAnimProxy: ref<inkAnimProxy>;

  private let m_delayTypingAnimProxy: ref<inkAnimProxy>;

  private let m_singleThreadMode: Bool;

  private let m_hasFocus: Bool;

  public let m_audioSystem: wref<AudioSystem>;

  @default(MessengerDialogViewController, 0)
  private let m_minimumTypingDelay: Float;

  private let m_breakingTypingAnimProxy: ref<inkAnimProxy>;

  protected cb func OnInitialize() -> Bool {
    this.m_typingIndicatorController = inkWidgetRef.GetControllerByType(this.m_typingIndicator, n"MessengerTypingIndicator") as MessengerTypingIndicator;
    this.m_messagesListController = inkWidgetRef.GetController(this.m_messagesList) as JournalEntriesListController;
    this.m_choicesListController = inkWidgetRef.GetController(this.m_choicesList) as JournalEntriesListController;
    this.m_scrollController = this.GetRootWidget().GetControllerByType(n"inkScrollController") as inkScrollController;
    this.m_choicesListController.RegisterToCallback(n"OnItemActivated", this, n"OnPlayerReplyActivated");
    inkWidgetRef.SetVisible(this.m_typingFluff, false);
    this.PlayDotsAnimation();
  }

  protected cb func OnUninitialize() -> Bool {
    this.DetachJournalManager();
  }

  public final func AttachJournalManager(journalManager: wref<JournalManager>) -> Void {
    this.m_journalManager = journalManager;
    this.m_journalManager.RegisterScriptCallback(this, n"OnJournalUpdate", gameJournalListenerType.State);
    this.m_journalManager.RegisterScriptCallback(this, n"OnJournalUpdateDelayed", gameJournalListenerType.StateDelay);
  }

  public final func InitDelaySystem(playerObject: wref<GameObject>) -> Void {
    this.m_playerObject = playerObject;
    this.m_delaySystem = GameInstance.GetDelaySystem(this.m_playerObject.GetGame());
    this.m_audioSystem = GameInstance.GetAudioSystem(this.m_playerObject.GetGame());
  }

  public final func DetachJournalManager() -> Void {
    if IsDefined(this.m_journalManager) {
      this.m_journalManager.UnregisterScriptCallback(this, n"OnJournalUpdate");
      this.m_journalManager.UnregisterScriptCallback(this, n"OnJournalUpdateDelayed");
      this.m_journalManager = null;
    };
  }

  public final func ShowDialog(contact: wref<JournalEntry>) -> Void {
    this.ShowDialog(contact, true);
  }

  public final func ShowDialog(contact: wref<JournalEntry>, setVisited: Bool) -> Void {
    this.m_conversationHash = MessengerUtils.FindConversationHash(this.m_journalManager, contact);
    this.m_contactHash = MessengerUtils.FindContactHash(this.m_journalManager, contact);
    this.m_singleThreadMode = false;
    this.m_parentEntry = contact;
    this.m_parentHash = this.m_journalManager.GetEntryHash(this.m_parentEntry);
    ArrayClear(this.m_replyOptions);
    ArrayClear(this.m_messages);
    this.UpdateData(false, setVisited);
  }

  public final func ShowThread(thread: wref<JournalEntry>) -> Void {
    this.ShowThread(thread, true);
  }

  public final func ShowThread(thread: wref<JournalEntry>, setVisited: Bool) -> Void {
    this.m_conversationHash = MessengerUtils.FindConversationHash(this.m_journalManager, thread);
    this.m_contactHash = MessengerUtils.FindContactHash(this.m_journalManager, thread);
    this.m_singleThreadMode = true;
    this.m_parentEntry = thread;
    this.m_parentHash = this.m_journalManager.GetEntryHash(this.m_parentEntry);
    ArrayClear(this.m_replyOptions);
    ArrayClear(this.m_messages);
    this.UpdateData(false, setVisited);
  }

  public final func UpdateData(opt animateLastMessage: Bool) -> Void {
    this.UpdateData(animateLastMessage, true);
  }

  public final func UpdateData(animateLastMessage: Bool, setVisited: Bool) -> Void {
    let countMessages: Int32;
    let lastMessageWidget: wref<inkWidget>;
    let widgetState: CName;
    this.StopDotsAnimation();
    if this.m_singleThreadMode {
      this.m_journalManager.GetMessagesAndChoices(this.m_parentEntry, this.m_messages, this.m_replyOptions);
    } else {
      this.m_journalManager.GetFlattenedMessagesAndChoices(this.m_parentEntry, this.m_messages, this.m_replyOptions);
    };
    inkWidgetRef.SetVisible(this.m_replayFluff, ArraySize(this.m_replyOptions) > 0);
    if setVisited {
      this.SetVisited(this.m_messages);
    };
    this.m_messagesListController.Clear();
    this.m_messagesListController.PushEntries(this.m_messages);
    this.m_choicesListController.Clear();
    this.m_choicesListController.PushEntries(this.m_replyOptions);
    if ArraySize(this.m_replyOptions) > 0 {
      this.SetFocus(this.m_hasFocus);
      this.m_choicesListController.SetSelectedIndex(0);
    };
    countMessages = this.m_messagesListController.Size();
    if countMessages > 0 {
      lastMessageWidget = this.m_messagesListController.GetItemAt(countMessages - 1);
      if IsDefined(lastMessageWidget) {
        widgetState = lastMessageWidget.GetState();
        if Equals(widgetState, n"Player") || Equals(widgetState, n"Quest") {
          this.PlayLibraryAnimationOnAutoSelectedTargets(n"reply_sent", lastMessageWidget);
        } else {
          if animateLastMessage {
            this.PlayLibraryAnimationOnAutoSelectedTargets(n"reply_sent", lastMessageWidget);
          };
        };
      };
    };
    this.m_scrollController.SetScrollPosition(1.00);
  }

  protected cb func OnJournalUpdate(entryHash: Uint32, className: CName, notifyOption: JournalNotifyOption, changeType: JournalChangeType) -> Bool {
    let entity: wref<JournalEntry>;
    let updateEvent: ref<DelayedJournalUpdate>;
    if Equals(className, n"gameJournalPhoneMessage") || Equals(className, n"gameJournalPhoneChoiceGroup") || Equals(className, n"gameJournalPhoneChoiceEntry") {
      updateEvent = new DelayedJournalUpdate();
      updateEvent.m_newMessageSpawned = Equals(className, n"gameJournalPhoneMessage") || Equals(className, n"gameJournalPhoneChoiceEntry");
      updateEvent.m_typing = false;
      entity = this.m_journalManager.GetEntry(entryHash);
      updateEvent.m_conversationHash = MessengerUtils.FindConversationHash(this.m_journalManager, entity);
      updateEvent.m_contactHash = MessengerUtils.FindContactHash(this.m_journalManager, entity);
      this.QueueEvent(updateEvent);
    };
  }

  protected cb func OnJournalUpdateDelayed(entryHash: Uint32, className: CName, notifyOption: JournalNotifyOption, changeType: JournalChangeType, delay: Float) -> Bool {
    let entity: wref<JournalEntry>;
    let message: ref<JournalPhoneMessage>;
    let updateEvent: ref<DelayedJournalUpdate>;
    if Equals(className, n"gameJournalPhoneMessage") {
      updateEvent = new DelayedJournalUpdate();
      updateEvent.m_newMessageSpawned = false;
      updateEvent.m_entryHash = entryHash;
      updateEvent.m_delay = delay;
      entity = this.m_journalManager.GetEntry(entryHash);
      message = entity as JournalPhoneMessage;
      updateEvent.m_conversationHash = MessengerUtils.FindConversationHash(this.m_journalManager, entity);
      updateEvent.m_contactHash = MessengerUtils.FindContactHash(this.m_journalManager, entity);
      updateEvent.m_typing = NotEquals(message.GetText(), "");
      this.QueueEvent(updateEvent);
    };
  }

  protected cb func OnDelayedJournalUpdate(evt: ref<DelayedJournalUpdate>) -> Bool {
    let sameContact: Bool;
    let sameConversation: Bool;
    if evt.m_delay == 0.00 {
      sameConversation = this.m_conversationHash != 0 ? evt.m_conversationHash == this.m_conversationHash : true;
      sameContact = this.m_contactHash == evt.m_contactHash;
      this.UpdateData(evt.m_newMessageSpawned && sameConversation && sameContact);
      if evt.m_newMessageSpawned {
        this.PlayRumble(RumbleStrength.SuperLight, RumbleType.Pulse, RumblePosition.Left);
        this.m_audioSystem.Play(n"ui_messenger_recieved");
      };
    } else {
      this.TriggerDotsAnimation(evt.m_delay, evt.m_typing, evt.m_entryHash);
    };
  }

  protected cb func OnPlayerReplyActivated(index: Int32, target: ref<ListItemController>) -> Bool {
    this.m_audioSystem.Play(n"ui_messenger_select");
    this.ActivateReply(target);
  }

  private final func GetParentEntryHash(entryHash: Uint32) -> Int32 {
    let entry: ref<JournalEntry> = this.m_journalManager.GetEntry(entryHash);
    let parentEntry: ref<JournalEntry> = this.m_journalManager.GetParentEntry(entry);
    let parentEntryHash: Int32 = this.m_journalManager.GetEntryHash(parentEntry);
    return parentEntryHash;
  }

  public final func ActivateSelectedReplyOption() -> Void {
    let itemWidget: wref<inkWidget>;
    let target: wref<ListItemController>;
    if this.m_choicesListController.Size() > 0 {
      itemWidget = this.m_choicesListController.GetItemAt(this.m_choicesListController.GetSelectedIndex());
      target = itemWidget.GetController() as ListItemController;
      this.ActivateReply(target);
      this.m_audioSystem.Play(n"ui_messenger_select");
      this.PlayRumble(RumbleStrength.SuperLight, RumbleType.Pulse, RumblePosition.Right);
    };
  }

  public final func ScrollMessages(value: Float, isMouseWheel: Bool) -> Void {
    this.m_scrollController.Scroll(value, isMouseWheel);
  }

  public final func NavigateReplyOptions(isUp: Bool) -> Void {
    if this.m_choicesListController.Size() > 0 {
      if isUp {
        this.m_choicesListController.Prior();
      } else {
        this.m_choicesListController.Next();
      };
    };
  }

  public final func HasReplyOptions() -> Bool {
    return ArraySize(this.m_replyOptions) > 0;
  }

  private final func ActivateReply(target: ref<ListItemController>) -> Void {
    let i: Int32;
    let data: ref<JournalEntryListItemData> = target.GetData() as JournalEntryListItemData;
    let count: Int32 = ArraySize(this.m_replyOptions);
    inkWidgetRef.SetVisible(this.m_replayFluff, count > 0);
    i = 0;
    while i < count {
      if NotEquals(this.m_replyOptions[i].GetId(), data.m_entry.GetId()) {
        this.m_journalManager.SetEntryVisited(this.m_replyOptions[i], true);
        this.m_journalManager.ChangeEntryStateByHash(Cast<Uint32>(this.m_journalManager.GetEntryHash(this.m_replyOptions[i])), gameJournalEntryState.Inactive, JournalNotifyOption.Notify);
      };
      i += 1;
    };
    this.m_journalManager.SetEntryVisited(data.m_entry, true);
    this.m_journalManager.ChangeEntryStateByHash(Cast<Uint32>(this.m_journalManager.GetEntryHash(data.m_entry)), gameJournalEntryState.Succeeded, JournalNotifyOption.Notify);
  }

  public final func SetFocus(focused: Bool) -> Void {
    this.m_hasFocus = focused;
    this.RefreshChoicesFocus();
  }

  private final func RefreshChoicesFocus() -> Void {
    let renderer: wref<MessangerReplyItemRenderer>;
    let widget: wref<inkWidget>;
    let i: Int32 = 0;
    while i < this.m_choicesListController.Size() {
      widget = this.m_choicesListController.GetItemAt(i);
      renderer = widget.GetController() as MessangerReplyItemRenderer;
      if renderer != null {
        renderer.SetActive(this.m_hasFocus);
      };
      i += 1;
    };
  }

  public final func SetCurrentMessagesAsVisited() -> Void {
    this.SetVisited(this.m_messages);
  }

  private final func SetVisited(const records: script_ref<[wref<JournalEntry>]>) -> Void {
    let entry: wref<JournalEntry>;
    let needEvent: Bool;
    let threadReadEvent: ref<MessageThreadReadEvent>;
    let count: Int32 = ArraySize(Deref(records));
    let i: Int32 = 0;
    while i < count {
      entry = Deref(records)[i];
      if !this.m_journalManager.IsEntryVisited(entry) {
        this.m_journalManager.SetEntryVisited(entry, true);
        needEvent = true;
      };
      i += 1;
    };
    if needEvent {
      threadReadEvent = new MessageThreadReadEvent();
      threadReadEvent.m_parentHash = this.m_parentHash;
      this.QueueEvent(threadReadEvent);
    };
  }

  private final func TriggerDotsAnimation(delay: Float, isTyping: Bool, hash: Uint32) -> Void {
    let contact: wref<JournalContact>;
    let conversationEntry: wref<JournalPhoneConversation>;
    let currentTypingDuration: Float;
    let delayedEvent: ref<TypingDelayEvent>;
    let lastMsg: wref<JournalPhoneMessage>;
    let newMsg: wref<JournalPhoneMessage>;
    if IsDefined(this.m_delaySystem) {
      this.m_delaySystem.CancelCallback(this.m_delayedTypingCallbackId);
      lastMsg = ArrayLast(this.m_messages) as JournalPhoneMessage;
      newMsg = this.m_journalManager.GetEntry(hash) as JournalPhoneMessage;
      contact = this.m_journalManager.GetContactByMessage(newMsg);
      conversationEntry = this.m_journalManager.GetParentEntry(newMsg) as JournalPhoneConversation;
      if Equals(newMsg.GetSender(), gameMessageSender.Player) {
        this.m_typingIndicatorController.SetPlayerTypingStyle(true);
      } else {
        this.m_typingIndicatorController.SetPlayerTypingStyle(false, isTyping);
        this.m_typingIndicatorController.SetName(contact.GetLocalizedName(this.m_journalManager));
      };
      if delay > this.m_minimumTypingDelay {
        if NotEquals(lastMsg.GetSender(), newMsg.GetSender()) {
          currentTypingDuration = delay * 0.50;
        } else {
          currentTypingDuration = delay * 0.35 * RandF();
        };
        delayedEvent = new TypingDelayEvent();
        delayedEvent.m_conversationHash = conversationEntry != null ? this.m_journalManager.GetEntryHash(conversationEntry) : -1;
        delayedEvent.m_contactHash = this.m_journalManager.GetEntryHash(contact);
        this.m_delayedTypingCallbackId = this.m_delaySystem.DelayEvent(this.m_playerObject, delayedEvent, currentTypingDuration, false);
      } else {
        this.PlayDotsAnimation();
      };
    };
  }

  public final func PlayDotsAnimation() -> Void {
    let playbackOptions: inkAnimOptions;
    playbackOptions.loopInfinite = true;
    playbackOptions.loopType = inkanimLoopType.Cycle;
    this.m_typingAnimProxy = this.PlayLibraryAnimation(n"TypigDots", playbackOptions);
    inkWidgetRef.SetVisible(this.m_typingFluff, true);
    this.m_audioSystem.Play(n"ui_messenger_typing");
  }

  private final func StopDotsAnimation() -> Void {
    if IsDefined(this.m_typingAnimProxy) {
      this.m_typingAnimProxy.Stop();
    };
    if IsDefined(this.m_delaySystem) {
      this.m_delaySystem.CancelCallback(this.m_delayedTypingCallbackId);
    };
    inkWidgetRef.SetVisible(this.m_typingFluff, false);
  }

  protected cb func OnBreakingTypingShown(proxy: ref<inkAnimProxy>) -> Bool {
    let anim: ref<inkAnimDef>;
    let interop: ref<inkAnimTransparency>;
    if IsDefined(this.m_breakingTypingAnimProxy) {
      this.m_breakingTypingAnimProxy.Stop();
    };
    anim = new inkAnimDef();
    interop = new inkAnimTransparency();
    interop.SetStartTransparency(1.00);
    interop.SetEndTransparency(1.00);
    interop.SetDuration(1.50);
    anim.AddInterpolator(interop);
    this.m_breakingTypingAnimProxy = inkWidgetRef.PlayAnimation(this.m_typingFluff, anim);
    this.m_breakingTypingAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnBreakingTypingHiden");
    inkWidgetRef.SetOpacity(this.m_typingFluff, 1.00);
  }

  protected cb func OnBreakingTypingHiden(proxy: ref<inkAnimProxy>) -> Bool {
    let anim: ref<inkAnimDef> = new inkAnimDef();
    let interop: ref<inkAnimTransparency> = new inkAnimTransparency();
    interop.SetStartTransparency(1.00);
    interop.SetEndTransparency(1.00);
    interop.SetDuration(0.50);
    anim.AddInterpolator(interop);
    this.m_breakingTypingAnimProxy = inkWidgetRef.PlayAnimation(this.m_typingFluff, anim);
    this.m_breakingTypingAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnBreakingTypingFinal");
    inkWidgetRef.SetOpacity(this.m_typingFluff, 0.00);
  }

  protected cb func OnBreakingTypingFinal(proxy: ref<inkAnimProxy>) -> Bool {
    inkWidgetRef.SetOpacity(this.m_typingFluff, 1.00);
  }
}

public class MessengerTypingIndicator extends inkLogicController {

  private edit let m_container: inkWidgetRef;

  private edit let m_nameText: inkTextRef;

  private let m_textParams: ref<inkTextParams>;

  protected cb func OnInitialize() -> Bool;

  public final func SetName(const contactName: script_ref<String>) -> Void {
    if !IsDefined(this.m_textParams) {
      this.m_textParams = new inkTextParams();
      this.m_textParams.AddString("contact_name", GetLocalizedText(contactName));
      inkTextRef.SetLocalizedText(this.m_nameText, n"UI-Phone-isTyping", this.m_textParams);
    } else {
      this.m_textParams.UpdateString("contact_name", GetLocalizedText(contactName));
    };
  }

  public final func SetPlayerTypingStyle(isPlayer: Bool, opt isTyping: Bool) -> Void {
    if isPlayer {
      inkWidgetRef.SetState(this.m_container, n"Player");
      inkWidgetRef.SetHAlign(this.m_container, inkEHorizontalAlign.Right);
      inkWidgetRef.SetVisible(this.m_nameText, false);
    } else {
      inkWidgetRef.SetState(this.m_container, n"Default");
      inkWidgetRef.SetHAlign(this.m_container, inkEHorizontalAlign.Left);
      inkWidgetRef.SetVisible(this.m_nameText, isTyping);
    };
  }
}
