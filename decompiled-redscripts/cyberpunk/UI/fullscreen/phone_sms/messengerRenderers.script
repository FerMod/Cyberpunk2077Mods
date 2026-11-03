
public class MessangerReplyItemRenderer extends JournalEntryListItemController {

  private let m_selectedState: Bool;

  private let m_isQuestImportant: Bool;

  private let m_isActive: Bool;

  @default(MessangerReplyItemRenderer, Default)
  private edit let m_stateDefault: CName;

  @default(MessangerReplyItemRenderer, Selected)
  private edit let m_stateSelected: CName;

  @default(MessangerReplyItemRenderer, Quest)
  private edit let m_stateQuestDefault: CName;

  @default(MessangerReplyItemRenderer, QuestSelected)
  private edit let m_stateQuestSelected: CName;

  @default(MessangerReplyItemRenderer, Disabled)
  private edit let m_stateDisabled: CName;

  protected cb func OnInitialize() -> Bool {
    this.RegisterToCallback(n"OnSelected", this, n"OnSelected");
    this.RegisterToCallback(n"OnDeselected", this, n"OnDeselected");
    this.RegisterToCallback(n"OnButtonStateChanged", this, n"OnButtonStateChanged");
  }

  protected cb func OnUninitialize() -> Bool {
    this.UnregisterFromCallback(n"OnSelected", this, n"OnSelected");
    this.UnregisterFromCallback(n"OnDeselected", this, n"OnDeselected");
    this.UnregisterFromCallback(n"OnButtonStateChanged", this, n"OnButtonStateChanged");
  }

  protected cb func OnButtonStateChanged(controller: wref<inkButtonController>, oldState: inkEButtonState, newState: inkEButtonState) -> Bool {
    if Equals(oldState, inkEButtonState.Normal) && Equals(newState, inkEButtonState.Hover) {
      this.SetSelected(true);
    } else {
      if Equals(oldState, inkEButtonState.Hover) && NotEquals(newState, inkEButtonState.Hover) {
        this.SetSelected(false);
      };
    };
  }

  protected cb func OnSelected(parent: wref<ListItemController>) -> Bool {
    if !this.m_selectedState {
      this.m_selectedState = !this.m_selectedState;
      this.AnimateSelection();
    };
  }

  protected cb func OnDeselected(parent: wref<ListItemController>) -> Bool {
    if this.m_selectedState {
      this.m_selectedState = !this.m_selectedState;
      this.AnimateSelection();
    };
  }

  protected func OnJournalEntryUpdated(entry: wref<JournalEntry>, extraData: ref<IScriptable>) -> Void {
    let choiceEntry: wref<JournalPhoneChoiceEntry> = entry as JournalPhoneChoiceEntry;
    inkTextRef.SetText(this.m_labelPathRef, choiceEntry.GetText());
    this.m_isQuestImportant = choiceEntry.IsQuestImportant();
    this.AnimateSelection();
  }

  public final func AnimateSelection() -> Void {
    if !this.m_isActive {
      this.GetRootWidget().SetState(this.m_stateDisabled);
    } else {
      if this.m_selectedState {
        this.GetRootWidget().SetState(this.m_isQuestImportant ? this.m_stateQuestSelected : this.m_stateSelected);
        this.PlayLibraryAnimation(n"Send_Indicator_intro");
      } else {
        this.GetRootWidget().SetState(this.m_isQuestImportant ? this.m_stateQuestDefault : this.m_stateDefault);
      };
    };
  }

  public final func SetActive(active: Bool) -> Void {
    this.m_isActive = active;
    this.AnimateSelection();
  }
}

public class MessangerItemRenderer extends JournalEntryListItemController {

  private edit let m_image: inkImageRef;

  private edit let m_container: inkWidgetRef;

  private edit let m_MessageBubbleBG: inkImageRef;

  private edit let m_MessageBubbleFG: inkImageRef;

  private edit let m_ReplyBubbleBG: inkImageRef;

  private edit let m_ReplyBubbleFG: inkImageRef;

  @default(MessangerItemRenderer, Default)
  private edit let m_stateMessage: CName;

  @default(MessangerItemRenderer, Player)
  private edit let m_statePlayerReply: CName;

  @default(MessangerItemRenderer, Quest)
  private edit let m_stateQuestReply: CName;

  private let m_imageId: TweakDBID;

  protected func OnJournalEntryUpdated(entry: wref<JournalEntry>, extraData: ref<IScriptable>) -> Void {
    let choiceEntry: wref<JournalPhoneChoiceEntry>;
    let contact: ref<ContactData>;
    let message: wref<JournalPhoneMessage>;
    let txt: String;
    let type: MessageViewType;
    inkWidgetRef.SetVisible(this.m_image, false);
    message = entry as JournalPhoneMessage;
    contact = extraData as ContactData;
    if IsDefined(message) {
      txt = message.GetText();
      type = Equals(message.GetSender(), gameMessageSender.NPC) ? MessageViewType.Received : MessageViewType.Sent;
      this.SetMessageView(txt, type, contact.localizedName);
      this.m_imageId = message.GetImageID();
      if message.IsQuestImportant() {
        this.GetRootWidget().SetState(this.m_stateQuestReply);
      };
      if TDBID.IsValid(this.m_imageId) {
        inkWidgetRef.SetVisible(this.m_image, true);
        InkImageUtils.RequestSetImage(this, this.m_image, this.m_imageId);
      } else {
        inkWidgetRef.SetVisible(this.m_image, false);
      };
    } else {
      choiceEntry = entry as JournalPhoneChoiceEntry;
      if IsDefined(choiceEntry) {
        txt = choiceEntry.GetText();
        this.SetMessageView(txt, MessageViewType.Sent, "");
        if choiceEntry.IsQuestImportant() {
          this.GetRootWidget().SetState(this.m_stateQuestReply);
        };
      };
    };
  }

  private final func SetMessageView(const txt: script_ref<String>, type: MessageViewType, const contactName: script_ref<String>) -> Void {
    let isMessage: Bool;
    inkTextRef.SetText(this.m_labelPathRef, Deref(txt));
    isMessage = Equals(type, MessageViewType.Received);
    inkWidgetRef.SetVisible(this.m_MessageBubbleBG, isMessage);
    inkWidgetRef.SetVisible(this.m_MessageBubbleFG, isMessage);
    inkWidgetRef.SetVisible(this.m_ReplyBubbleBG, !isMessage);
    inkWidgetRef.SetVisible(this.m_ReplyBubbleFG, !isMessage);
    if isMessage {
      this.GetRootWidget().SetState(this.m_stateMessage);
      inkWidgetRef.SetHAlign(this.m_container, inkEHorizontalAlign.Left);
    } else {
      this.GetRootWidget().SetState(this.m_statePlayerReply);
      inkWidgetRef.SetHAlign(this.m_container, inkEHorizontalAlign.Right);
    };
  }
}
