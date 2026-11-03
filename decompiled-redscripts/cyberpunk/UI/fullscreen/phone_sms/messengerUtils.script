
public class MessengerUtils extends IScriptable {

  public final static func GetCallableAndNonEmptyContacts(journal: ref<JournalManager>) -> [ref<IScriptable>] {
    let contact: ref<ContactData>;
    let contacts: array<ref<IScriptable>> = journal.GetContactDataArray(false, true);
    let i: Int32 = ArraySize(contacts) - 1;
    while i >= 0 {
      contact = contacts[i] as ContactData;
      if contact == null {
      } else {
        if !contact.isCallable && contact.messagesCount == 0 && contact.repliesCount == 0 {
          ArrayErase(contacts, i);
        };
      };
      i -= 1;
    };
    return contacts;
  }

  public final static func GetSimpleContactDataArray(journal: ref<JournalManager>, includeUnknown: Bool, skipEmpty: Bool, includeWithNoUnread: Bool, opt activeDataSync: wref<MessengerContactSyncData>) -> [ref<IScriptable>] {
    let contactDataArray: array<ref<IScriptable>>;
    let contactEntry: wref<JournalContact>;
    let context: JournalRequestContext;
    let entries: array<wref<JournalEntry>>;
    let i: Int32;
    let trackedEntriesHashList: array<Int32>;
    context.stateFilter.active = true;
    journal.GetContacts(context, entries);
    trackedEntriesHashList = MessengerUtils.FetchTrackedQuestCodexLinks(journal, context);
    i = 0;
    while i < ArraySize(entries) {
      contactEntry = entries[i] as JournalContact;
      MessengerUtils.AddContactData(journal, contactDataArray, contactEntry, trackedEntriesHashList, includeUnknown, skipEmpty, includeWithNoUnread, false, activeDataSync);
      i += 1;
    };
    return contactDataArray;
  }

  public final static func GetMessageDataArrayForContact(journal: ref<JournalManager>, concactHash: Int32, includeUnknown: Bool, skipEmpty: Bool, opt activeDataSync: wref<MessengerContactSyncData>) -> [ref<IScriptable>] {
    let contactDataArray: array<ref<IScriptable>>;
    let context: JournalRequestContext;
    let trackedEntriesHashList: array<Int32>;
    context.stateFilter.active = true;
    let contactEntry: wref<JournalContact> = journal.GetEntry(Cast<Uint32>(concactHash)) as JournalContact;
    if contactEntry == null {
      return contactDataArray;
    };
    trackedEntriesHashList = MessengerUtils.FetchTrackedQuestCodexLinks(journal, context);
    MessengerUtils.AddContactData(journal, contactDataArray, contactEntry, trackedEntriesHashList, includeUnknown, skipEmpty, true, true, activeDataSync);
    return contactDataArray;
  }

  private final static func AddContactData(journal: ref<JournalManager>, contactDataArray: script_ref<[ref<IScriptable>]>, contactEntry: ref<JournalContact>, const trackedEntriesHashList: script_ref<[Int32]>, includeUnknown: Bool, skipEmpty: Bool, includeWithNoUnread: Bool, includeWithNoReplies: Bool, opt activeDataSync: wref<MessengerContactSyncData>) -> Void {
    let conversationEntry: wref<JournalPhoneConversation>;
    let conversations: array<wref<JournalEntry>>;
    let conversationsCount: Int32;
    let j: Int32;
    let messagesReceived: array<wref<JournalEntry>>;
    let multiThreadData: ref<ContactData>;
    let playerReplies: array<wref<JournalEntry>>;
    let singleThreadData: ref<ContactData>;
    if includeUnknown || contactEntry.IsKnown(journal) {
      ArrayClear(messagesReceived);
      ArrayClear(playerReplies);
      journal.GetConversations(contactEntry, conversations);
      journal.GetFlattenedMessagesAndChoices(contactEntry, messagesReceived, playerReplies);
      if skipEmpty && ArraySize(messagesReceived) <= 0 && ArraySize(playerReplies) <= 0 {
        return;
      };
      conversationsCount = ArraySize(conversations);
      if conversationsCount > 1 {
        j = 0;
        while j < conversationsCount {
          ArrayClear(messagesReceived);
          ArrayClear(playerReplies);
          conversationEntry = conversations[j] as JournalPhoneConversation;
          journal.GetMessagesAndChoices(conversationEntry, messagesReceived, playerReplies);
          multiThreadData = new ContactData();
          multiThreadData.id = conversationEntry.GetId();
          multiThreadData.hash = journal.GetEntryHash(contactEntry);
          multiThreadData.conversationHash = journal.GetEntryHash(conversationEntry);
          multiThreadData.localizedName = contactEntry.GetLocalizedName(journal);
          multiThreadData.avatarID = contactEntry.GetAvatarID(journal);
          multiThreadData.activeDataSync = activeDataSync;
          multiThreadData.type = MessengerContactType.MultiThread;
          multiThreadData.isCallable = contactEntry.IsCallable(journal);
          multiThreadData.contactId = contactEntry.GetId();
          MessengerUtils.SetTitle(multiThreadData, conversationEntry);
          MessengerUtils.GetContactMessageData(multiThreadData, journal, messagesReceived, playerReplies);
          MessengerUtils.SetTimestamp(multiThreadData, journal, messagesReceived, conversationEntry);
          multiThreadData.questRelated = MessengerUtils.ContainsQuestRelatedMessage(journal, trackedEntriesHashList, messagesReceived);
          if includeWithNoUnread || ArraySize(multiThreadData.unreadMessages) > 0 {
            ArrayPush(Deref(contactDataArray), multiThreadData);
          } else {
            if includeWithNoReplies || multiThreadData.hasQuestImportantReply || multiThreadData.playerCanReply {
              ArrayPush(Deref(contactDataArray), multiThreadData);
            };
          };
          j += 1;
        };
      } else {
        conversationEntry = conversationsCount == 1 ? conversations[0] : null as JournalPhoneConversation;
        singleThreadData = new ContactData();
        singleThreadData.id = contactEntry.GetId();
        singleThreadData.hash = journal.GetEntryHash(contactEntry);
        singleThreadData.conversationHash = MessengerUtils.GetConversationHash(journal, conversationEntry);
        singleThreadData.localizedName = contactEntry.GetLocalizedName(journal);
        singleThreadData.avatarID = contactEntry.GetAvatarID(journal);
        singleThreadData.activeDataSync = activeDataSync;
        singleThreadData.type = MessengerContactType.SingleThread;
        singleThreadData.isCallable = contactEntry.IsCallable(journal);
        singleThreadData.contactId = contactEntry.GetId();
        MessengerUtils.SetTitle(singleThreadData, conversationEntry);
        MessengerUtils.GetContactMessageData(singleThreadData, journal, messagesReceived, playerReplies);
        MessengerUtils.SetTimestamp(singleThreadData, journal, messagesReceived, conversationEntry);
        singleThreadData.questRelated = MessengerUtils.ContainsQuestRelatedMessage(journal, trackedEntriesHashList, messagesReceived);
        if includeWithNoUnread || ArraySize(singleThreadData.unreadMessages) > 0 {
          ArrayPush(Deref(contactDataArray), singleThreadData);
        } else {
          if includeWithNoReplies || singleThreadData.hasQuestImportantReply || singleThreadData.playerCanReply {
            ArrayPush(Deref(contactDataArray), singleThreadData);
          };
        };
      };
    };
  }

  private final static func GetConversationHash(journal: ref<JournalManager>, conversationEntry: wref<JournalPhoneConversation>) -> Int32 {
    if IsDefined(conversationEntry) {
      return journal.GetEntryHash(conversationEntry);
    };
    return 0;
  }

  private final static func SetTitle(out contactData: ref<ContactData>, conversationEntry: wref<JournalPhoneConversation>) -> Void {
    let localizedPreview: String = conversationEntry.GetTitle();
    if IsStringValid(localizedPreview) {
      contactData.hasValidTitle = true;
      contactData.localizedPreview = localizedPreview;
    } else {
      contactData.hasValidTitle = false;
    };
  }

  private final static func SetTimestamp(out contactData: ref<ContactData>, journal: ref<JournalManager>, const messagesReceived: script_ref<[wref<JournalEntry>]>, const conversationEntry: wref<JournalPhoneConversation>) -> Void {
    if ArraySize(Deref(messagesReceived)) > 0 {
      contactData.timeStamp = journal.GetEntryTimestamp(ArrayLast(Deref(messagesReceived)));
    } else {
      if IsDefined(conversationEntry) {
        contactData.timeStamp = journal.GetEntryTimestamp(conversationEntry);
      };
    };
  }

  public final static func GetContactMessageData(out contactData: ref<ContactData>, journal: ref<JournalManager>, const messagesReceived: script_ref<[wref<JournalEntry>]>, const playerReplies: script_ref<[wref<JournalEntry>]>) -> Void {
    let choiceEntry: wref<JournalPhoneChoiceEntry>;
    let j: Int32;
    let lastMessegeRecived: wref<JournalPhoneMessage>;
    let lastMessegeSent: wref<JournalPhoneChoiceEntry>;
    contactData.playerCanReply = ArraySize(Deref(playerReplies)) > 0;
    ArrayClear(contactData.unreadMessages);
    j = 0;
    while j < ArraySize(Deref(messagesReceived)) {
      if !journal.IsEntryVisited(Deref(messagesReceived)[j]) {
        ArrayPush(contactData.unreadMessages, journal.GetEntryHash(Deref(messagesReceived)[j]));
      };
      j += 1;
    };
    if ArraySize(Deref(messagesReceived)) > 0 {
      lastMessegeRecived = ArrayLast(Deref(messagesReceived)) as JournalPhoneMessage;
      if IsDefined(lastMessegeRecived) {
        contactData.lastMesssagePreview = lastMessegeRecived.GetText();
        contactData.playerIsLastSender = false;
      } else {
        lastMessegeSent = ArrayLast(Deref(messagesReceived)) as JournalPhoneChoiceEntry;
        contactData.lastMesssagePreview = lastMessegeSent.GetText();
        contactData.playerIsLastSender = true;
      };
    };
    j = 0;
    while j < ArraySize(Deref(playerReplies)) {
      choiceEntry = Deref(playerReplies)[j] as JournalPhoneChoiceEntry;
      if choiceEntry.IsQuestImportant() {
        contactData.hasQuestImportantReply = true;
        break;
      };
      j += 1;
    };
  }

  public final static func RefreshQuestRelatedStatus(out contactData: ref<ContactData>, journal: ref<JournalManager>, const messagesReceived: script_ref<[wref<JournalEntry>]>) -> Void {
    let context: JournalRequestContext;
    context.stateFilter.active = true;
    let trackedEntriesHashList: array<Int32> = MessengerUtils.FetchTrackedQuestCodexLinks(journal, context);
    contactData.questRelated = MessengerUtils.ContainsQuestRelatedMessage(journal, trackedEntriesHashList, messagesReceived);
  }

  public final static func ContainsQuestRelatedMessage(journal: ref<JournalManager>, const trackedEntriesHashList: script_ref<[Int32]>, const messagesReceived: script_ref<[wref<JournalEntry>]>) -> Bool {
    let hash: Int32;
    let j: Int32 = 0;
    while j < ArraySize(Deref(messagesReceived)) {
      hash = journal.GetEntryHash(Deref(messagesReceived)[j]);
      if ArrayContains(Deref(trackedEntriesHashList), hash) {
        return true;
      };
      j += 1;
    };
    return false;
  }

  public final static func HasPhoneObjective(journal: ref<JournalManager>) -> Bool {
    return false;
  }

  public final static func HasQuestImportantCalls(journal: ref<JournalManager>) -> Bool {
    let contactEntry: wref<JournalContact>;
    let context: JournalRequestContext;
    let entries: array<wref<JournalEntry>>;
    let hash: Int32;
    let i: Int32;
    context.stateFilter.active = true;
    let trackedChildEntriesHashList: array<Int32> = MessengerUtils.FetchTrackedQuestCodexLinks(journal, context);
    if ArraySize(trackedChildEntriesHashList) == 0 {
      return false;
    };
    journal.GetContacts(context, entries);
    i = 0;
    while i < ArraySize(entries) {
      contactEntry = entries[i] as JournalContact;
      if IsDefined(contactEntry) {
        if !contactEntry.IsCallable(journal) || !contactEntry.IsKnown(journal) {
        } else {
          hash = journal.GetEntryHash(contactEntry);
          if ArrayContains(trackedChildEntriesHashList, hash) {
            return true;
          };
        };
      };
      i += 1;
    };
    return false;
  }

  public final static func HasQuestImportantMessages(journal: ref<JournalManager>) -> Bool {
    let contactEntry: wref<JournalContact>;
    let context: JournalRequestContext;
    let entries: array<wref<JournalEntry>>;
    let i: Int32;
    let messagesReceived: array<wref<JournalEntry>>;
    let playerReplies: array<wref<JournalEntry>>;
    context.stateFilter.active = true;
    let trackedEntriesHashList: array<Int32> = MessengerUtils.FetchTrackedQuestCodexLinks(journal, context);
    if ArraySize(trackedEntriesHashList) == 0 {
      return false;
    };
    journal.GetContacts(context, entries);
    i = 0;
    while i < ArraySize(entries) {
      contactEntry = entries[i] as JournalContact;
      if IsDefined(contactEntry) && contactEntry.IsKnown(journal) {
        ArrayClear(messagesReceived);
        ArrayClear(playerReplies);
        journal.GetFlattenedMessagesAndChoices(contactEntry, messagesReceived, playerReplies);
        if MessengerUtils.ContainsQuestRelatedMessage(journal, trackedEntriesHashList, messagesReceived) {
          return true;
        };
      };
      i += 1;
    };
    return false;
  }

  public final static func FetchTrackedQuestCodexLinks(journal: ref<JournalManager>, context: JournalRequestContext) -> [Int32] {
    let j: Int32;
    let trackedChildEntriesCount: Int32;
    let trackedChildEntriesHashList: array<Int32>;
    let trackedChildEntriesList: array<wref<JournalEntry>>;
    let trackedChildEntry: wref<JournalQuestCodexLink>;
    let trackedObjective: ref<JournalQuestObjective> = journal.GetTrackedEntry() as JournalQuestObjective;
    if trackedObjective != null {
      journal.GetChildren(trackedObjective, context.stateFilter, trackedChildEntriesList);
      trackedChildEntriesCount = ArraySize(trackedChildEntriesList);
      j = 0;
      while j < trackedChildEntriesCount {
        trackedChildEntry = trackedChildEntriesList[j] as JournalQuestCodexLink;
        if IsDefined(trackedChildEntry) {
          ArrayPush(trackedChildEntriesHashList, Cast<Int32>(trackedChildEntry.GetLinkPathHash()));
        };
        j = j + 1;
      };
    };
    return trackedChildEntriesHashList;
  }

  public final static func GetUnreadMessagesCount(journal: ref<JournalManager>, contactEntry: wref<JournalContact>) -> Int32 {
    let messagesReceived: array<wref<JournalEntry>>;
    let playerReplies: array<wref<JournalEntry>>;
    journal.GetFlattenedMessagesAndChoices(contactEntry, messagesReceived, playerReplies);
    return ArraySize(messagesReceived);
  }

  public final static func FindConversationHash(journal: ref<JournalManager>, entry: wref<JournalEntry>) -> Int32 {
    let conversation: ref<JournalPhoneConversation>;
    while entry != null {
      conversation = entry as JournalPhoneConversation;
      if IsDefined(conversation) {
        return journal.GetEntryHash(conversation);
      };
      entry = journal.GetParentEntry(entry);
    };
    return 0;
  }

  public final static func FindContactHash(journal: ref<JournalManager>, entry: wref<JournalEntry>) -> Int32 {
    let contact: ref<JournalContact>;
    while entry != null {
      contact = entry as JournalContact;
      if IsDefined(contact) {
        return journal.GetEntryHash(contact);
      };
      entry = journal.GetParentEntry(entry);
    };
    return 0;
  }
}
