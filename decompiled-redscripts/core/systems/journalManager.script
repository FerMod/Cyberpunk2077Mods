
public final native class JournalManager extends IJournalManager {

  public final native const func GetQuests(context: JournalRequestContext, out entries: [wref<JournalEntry>]) -> Void;

  public final native const func GetMetaQuests(context: JournalRequestContext, out entries: [wref<JournalEntry>]) -> Void;

  public final native const func GetContacts(context: JournalRequestContext, out entries: [wref<JournalEntry>]) -> Void;

  public final native const func GetFlattenedMessagesAndChoices(contactEntry: wref<JournalEntry>, out messages: [wref<JournalEntry>], out choiceEntries: [wref<JournalEntry>]) -> Void;

  public final native const func GetMessagesAndChoices(conversationEntry: wref<JournalEntry>, out messages: [wref<JournalEntry>], out choiceEntries: [wref<JournalEntry>]) -> Void;

  public final native const func GetConversations(contactEntry: wref<JournalEntry>, out conversations: [wref<JournalEntry>]) -> Void;

  public final native const func GetTarots(context: JournalRequestContext, out entries: [wref<JournalEntry>]) -> Void;

  public final native const func GetInternetSites(context: JournalRequestContext, out entries: [wref<JournalEntry>]) -> Void;

  public final native const func GetInternetPages(context: JournalRequestContext, out entries: [wref<JournalEntry>]) -> Void;

  public final native const func GetMainInternetPage(siteEntry: wref<JournalInternetSite>) -> wref<JournalInternetPage>;

  public final native const func GetCodexCategories(context: JournalRequestContext, out entries: [wref<JournalEntry>]) -> Void;

  public final native const func GetOnscreens(context: JournalRequestContext, out entries: [ref<JournalOnscreensStructuredGroup>], opt fallbackGroupName: CName) -> Void;

  public final native const func GetBriefings(context: JournalRequestContext, out entries: [wref<JournalEntry>]) -> Void;

  public final native const func GetChildren(parentEntry: wref<JournalEntry>, filter: JournalRequestStateFilter, out childEntries: [wref<JournalEntry>]) -> Void;

  public final native const func GetRandomChildren(parentEntry: wref<JournalEntry>, filter: JournalRequestStateFilter, childCount: Int32, out childEntries: [wref<JournalEntry>]) -> Void;

  public final native const func GetParentEntry(childEntry: wref<JournalEntry>) -> wref<JournalEntry>;

  public final native const func GetEntry(hash: Uint32) -> wref<JournalEntry>;

  public final native const func GetEntryByString(uniquePath: String, className: String) -> wref<JournalEntry>;

  public final native const func GetEntryState(entry: wref<JournalEntry>) -> gameJournalEntryState;

  public final native const func GetEntryTimestamp(entry: wref<JournalEntry>) -> GameTime;

  public final native const func IsEntryVisited(entry: wref<JournalEntry>) -> Bool;

  public final native func SetEntryVisited(entry: wref<JournalEntry>, value: Bool) -> Void;

  public final native const func IsEp1Entry(entry: wref<JournalEntry>) -> Bool;

  public final native const func GetEntryHash(entry: wref<JournalEntry>) -> Int32;

  public final native const func GetTrackedEntry() -> wref<JournalEntry>;

  public final native const func IsEntryTracked(entry: wref<JournalEntry>) -> Bool;

  public final native func TrackEntry(entry: wref<JournalEntry>) -> Void;

  public final native func TrackPrevNextEntry(next: Bool) -> Void;

  public final native func UntrackEntry() -> Void;

  public final native func ChangeEntryState(uniquePath: String, className: String, state: gameJournalEntryState, notifyOption: JournalNotifyOption) -> Bool;

  public final native func ChangeEntryStateByHash(hash: Uint32, state: gameJournalEntryState, notifyOption: JournalNotifyOption) -> Void;

  public final native const func HasAnyDelayedStateChanges() -> Bool;

  public final native const func GetObjectiveCurrentCounter(entry: wref<JournalQuestObjective>) -> Int32;

  public final native const func GetObjectiveTotalCounter(entry: wref<JournalQuestObjective>) -> Int32;

  public final native const func GetMetaQuestData(metaQuestId: gamedataMetaQuest) -> JournalMetaQuestScriptedData;

  public final native const func GetDistrict(entry: wref<JournalEntry>) -> wref<District_Record>;

  public final native const func GetRecommendedLevel(entry: wref<JournalEntry>) -> Uint32;

  public final native const func GetRecommendedLevelID(entry: wref<JournalEntry>) -> TweakDBID;

  public final native const func GetQuestType(entry: wref<JournalEntry>) -> gameJournalQuestType;

  public final native const func GetIsObjectiveOptional(entry: wref<JournalQuestObjectiveBase>) -> Bool;

  public final native const func TryGetWebsiteData(address: String, context: JournalRequestContext) -> wref<JournalInternetPage>;

  public final native const func GetDistanceToNearestMappin(entry: wref<JournalQuestObjective>, opt filter: JournalRequestStateFilter) -> Float;

  public final native const func GetPointOfInterestMappinHashFromQuestHash(hash: Uint32) -> Uint32;

  public final native func RegisterScriptCallback(obj: ref<IScriptable>, functionName: CName, type: gameJournalListenerType) -> Void;

  public final native func UnregisterScriptCallback(obj: ref<IScriptable>, functionName: CName) -> Void;

  public final native func DebugShowAllPoiMappins() -> Void;

  public final func CreateScriptedQuestFromTemplate(const templateQuestEntryId: script_ref<String>, const uniqueId: script_ref<String>, const title: script_ref<String>) -> Bool {
    return false;
  }

  public final func DeleteScriptedQuest(const templateQuestEntryId: script_ref<String>, const uniqueId: script_ref<String>) -> Bool {
    return false;
  }

  public final func SetScriptedQuestEntryState(const templateQuestEntryId: script_ref<String>, const uniqueId: script_ref<String>, const templatePhaseAndObjectivePath: script_ref<String>, state: gameJournalEntryState, notifyOption: JournalNotifyOption, track: Bool) -> Void;

  public final func SetScriptedQuestObjectiveDescription(const templateQuestEntryId: script_ref<String>, const uniqueId: script_ref<String>, const templatePhaseAndObjectivePath: script_ref<String>, const description: script_ref<String>) -> Bool {
    return false;
  }

  public final func SetScriptedQuestMappinEntityID(const templateQuestEntryId: script_ref<String>, const uniqueId: script_ref<String>, const templatePhaseObjectiveAndMappinPath: script_ref<String>, entityID: EntityID) -> Bool {
    return false;
  }

  public final func SetScriptedQuestMappinSlotName(const templateQuestEntryId: script_ref<String>, const uniqueId: script_ref<String>, const templatePhaseObjectiveAndMappinPath: script_ref<String>, recordID: TweakDBID) -> Bool {
    return false;
  }

  public final func SetScriptedQuestMappinData(const templateQuestEntryId: script_ref<String>, const uniqueId: script_ref<String>, const templatePhaseObjectiveAndMappinPath: script_ref<String>, const mappinData: script_ref<MappinData>) -> Bool {
    return false;
  }

  protected final cb func OnQuestEntryTracked(entry: wref<JournalEntry>) -> Bool {
    if entry == null {
    } else {
      if IsDefined(entry as JournalQuest) {
      } else {
        if IsDefined(entry as JournalQuestObjective) {
        };
      };
    };
  }

  protected final cb func OnQuestEntryUntracked(entry: wref<JournalEntry>) -> Bool {
    if entry == null {
    } else {
      if IsDefined(entry as JournalQuest) {
      } else {
        if IsDefined(entry as JournalQuestObjective) {
        };
      };
    };
  }

  public final func GetContactByMessage(msg: ref<JournalPhoneMessage>) -> wref<JournalContact> {
    let conversationEntry: wref<JournalPhoneConversation> = this.GetParentEntry(msg) as JournalPhoneConversation;
    if IsDefined(conversationEntry) {
      return this.GetParentEntry(conversationEntry) as JournalContact;
    };
    return null;
  }

  public final func GetContactDataArray(includeUnknown: Bool, includeNonCallable: Bool) -> [ref<IScriptable>] {
    let contactData: ref<ContactData>;
    let contactDataArray: array<ref<IScriptable>>;
    let contactEntry: wref<JournalContact>;
    let context: JournalRequestContext;
    let emptyContactData: ref<ContactData>;
    let entries: array<wref<JournalEntry>>;
    let i: Int32;
    let j: Int32;
    let lastMessegeRecived: wref<JournalPhoneMessage>;
    let lastMessegeSent: wref<JournalPhoneChoiceEntry>;
    let messagesReceived: array<wref<JournalEntry>>;
    let playerReplies: array<wref<JournalEntry>>;
    let trackedChildEntriesCount: Int32;
    let trackedChildEntriesHashList: array<Int32>;
    let trackedChildEntriesList: array<wref<JournalEntry>>;
    let trackedChildEntry: wref<JournalQuestCodexLink>;
    let trackedObjective: ref<JournalQuestObjective>;
    context.stateFilter.active = true;
    this.GetContacts(context, entries);
    trackedChildEntriesCount = 0;
    trackedObjective = this.GetTrackedEntry() as JournalQuestObjective;
    if trackedObjective != null {
      this.GetChildren(trackedObjective, context.stateFilter, trackedChildEntriesList);
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
    i = 0;
    while i < ArraySize(entries) {
      contactEntry = entries[i] as JournalContact;
      if IsDefined(contactEntry) {
        if !(includeNonCallable || contactEntry.IsCallable(this)) {
        } else {
          if includeUnknown || contactEntry.IsKnown(this) {
            contactData = new ContactData();
            contactData.id = contactEntry.GetId();
            contactData.hash = this.GetEntryHash(contactEntry);
            contactData.localizedName = contactEntry.GetLocalizedName(this);
            contactData.avatarID = contactEntry.GetAvatarID(this);
            contactData.questRelated = ArrayContains(trackedChildEntriesHashList, contactData.hash);
            contactData.type = MessengerContactType.Contact;
            contactData.isCallable = contactEntry.IsCallable(this);
            contactData.contactId = contactEntry.GetId();
            ArrayClear(messagesReceived);
            ArrayClear(playerReplies);
            this.GetFlattenedMessagesAndChoices(contactEntry, messagesReceived, playerReplies);
            contactData.messagesCount = ArraySize(messagesReceived);
            contactData.repliesCount = ArraySize(playerReplies);
            j = 0;
            while j < ArraySize(messagesReceived) {
              if !this.IsEntryVisited(messagesReceived[j]) {
                ArrayPush(contactData.unreadMessages, this.GetEntryHash(messagesReceived[j]));
              };
              j += 1;
            };
            contactData.playerCanReply = ArraySize(playerReplies) > 0;
            if ArraySize(messagesReceived) > 0 {
              contactData.hasMessages = true;
              lastMessegeRecived = ArrayLast(messagesReceived) as JournalPhoneMessage;
              if IsDefined(lastMessegeRecived) {
                contactData.lastMesssagePreview = lastMessegeRecived.GetText();
                contactData.playerIsLastSender = false;
              } else {
                lastMessegeSent = ArrayLast(messagesReceived) as JournalPhoneChoiceEntry;
                contactData.lastMesssagePreview = lastMessegeSent.GetText();
                contactData.playerIsLastSender = true;
              };
            } else {
              contactData.lastMesssagePreview = "You are now connected.";
            };
            ArrayPush(contactDataArray, contactData);
          };
        };
      } else {
        ArrayPush(contactDataArray, emptyContactData);
      };
      i += 1;
    };
    return contactDataArray;
  }

  public final func IsAttachedToAnyActiveQuest(hash: Int32) -> Bool {
    let childEntries: array<wref<JournalEntry>>;
    let codexLinkEntry: ref<JournalQuestCodexLink>;
    let context: JournalRequestContext;
    let count: Int32;
    let filter: JournalRequestStateFilter;
    let i: Int32;
    let quests: array<wref<JournalEntry>>;
    filter.active = true;
    context.stateFilter = filter;
    this.GetQuests(context, quests);
    count = ArraySize(quests);
    i = 0;
    while i < count {
      QuestLogUtils.UnpackRecursiveWithFilter(this, quests[i] as JournalContainerEntry, filter, childEntries, true);
      i += 1;
    };
    count = ArraySize(childEntries);
    i = 0;
    while i < count {
      codexLinkEntry = childEntries[i] as JournalQuestCodexLink;
      if IsDefined(codexLinkEntry) && Cast<Int32>(codexLinkEntry.GetLinkPathHash()) == hash {
        return true;
      };
      i += 1;
    };
    return false;
  }

  public final func IsAttachedToTrackedObjective(hash: Int32) -> Bool {
    let childEntries: array<wref<JournalEntry>>;
    let count: Int32;
    let filter: JournalRequestStateFilter;
    let i: Int32;
    let trackedChildEntry: ref<JournalQuestCodexLink>;
    filter.active = true;
    let objective: ref<JournalQuestObjective> = this.GetTrackedEntry() as JournalQuestObjective;
    if objective != null {
      this.GetChildren(objective, filter, childEntries);
      count = ArraySize(childEntries);
      i = 0;
      while i < count {
        trackedChildEntry = childEntries[i] as JournalQuestCodexLink;
        if IsDefined(trackedChildEntry) && Cast<Int32>(trackedChildEntry.GetLinkPathHash()) == hash {
          return true;
        };
        i = i + 1;
      };
    };
    return false;
  }
}
