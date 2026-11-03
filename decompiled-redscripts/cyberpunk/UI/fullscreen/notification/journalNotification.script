
public native class QuestUpdateNotificationViewData extends GenericNotificationViewData {

  public native let questEntryId: String;

  public native let canBeMerged: Bool;

  public native let animation: CName;

  public native let SMSText: String;

  public native let SMSLocKey: String;

  public let dontRemoveOnRequest: Bool;

  public let entryHash: Int32;

  public let rewardSC: Int32;

  public let rewardXP: Int32;

  @default(QuestUpdateNotificationViewData, EGenericNotificationPriority.Default)
  public let priority: EGenericNotificationPriority;

  public func CanMerge(data: ref<GenericNotificationViewData>) -> Bool {
    let compareTo: ref<QuestUpdateNotificationViewData> = data as QuestUpdateNotificationViewData;
    return compareTo != null && Equals(compareTo.questEntryId, this.questEntryId) && this.canBeMerged && compareTo.canBeMerged;
  }

  public func OnRemoveNotification(data: ref<IScriptable>) -> Bool {
    let requestData: ref<JournalEntryNotificationRemoveRequestData> = data as JournalEntryNotificationRemoveRequestData;
    let requestHash: Int32 = Cast<Int32>(requestData.entryHash);
    return requestData != null && requestHash == this.entryHash && !this.dontRemoveOnRequest;
  }

  public func GetPriority() -> Int32 {
    return EnumInt(this.priority);
  }
}

public native class PhoneMessageNotificationViewData extends QuestUpdateNotificationViewData {

  public native let threadHash: Int32;

  public native let contactHash: Int32;

  public func GetPriority() -> Int32 {
    return 2;
  }

  public func CanMerge(data: ref<GenericNotificationViewData>) -> Bool {
    let compareTo: ref<PhoneMessageNotificationViewData> = data as PhoneMessageNotificationViewData;
    return compareTo != null && this.threadHash == compareTo.threadHash;
  }
}

public class JournalNotificationQueue extends gameuiGenericNotificationGameController {

  @default(JournalNotificationQueue, 6.0f)
  private let m_showDuration: Float;

  @default(JournalNotificationQueue, notification_currency)
  private let m_currencyNotification: CName;

  @default(JournalNotificationQueue, notification_shard)
  private let m_shardNotification: CName;

  @default(JournalNotificationQueue, Item_Received_SMALL)
  private let m_itemNotification: CName;

  @default(JournalNotificationQueue, notification_quest)
  private let m_questNotification: CName;

  @default(JournalNotificationQueue, notification)
  private let m_genericNotification: CName;

  private let m_journalMgr: wref<JournalManager>;

  private let m_newAreablackboard: wref<IBlackboard>;

  private let m_newAreaDef: ref<UI_MapDef>;

  private let m_newAreaID: ref<CallbackHandle>;

  private let m_tutorialBlackboard: wref<IBlackboard>;

  private let m_tutorialDef: ref<UIGameDataDef>;

  private let m_tutorialID: ref<CallbackHandle>;

  private let m_tutorialDataID: ref<CallbackHandle>;

  private let m_isHiddenByTutorial: Bool;

  private let m_customQuestNotificationblackBoardID: ref<CallbackHandle>;

  private let m_customQuestNotificationblackboardDef: ref<UI_CustomQuestNotificationDef>;

  private let m_customQuestNotificationblackboard: wref<IBlackboard>;

  private let m_transactionSystem: wref<TransactionSystem>;

  private let m_playerPuppet: wref<GameObject>;

  private let m_activeVehicleBlackboard: wref<IBlackboard>;

  private let m_mountBBConnectionId: ref<CallbackHandle>;

  private let m_isPlayerMounted: Bool;

  private let blackboard: wref<IBlackboard>;

  private let uiSystemBB: ref<UI_SystemDef>;

  private let uiSystemId: ref<CallbackHandle>;

  private let trackedMappinId: ref<CallbackHandle>;

  private let m_uiSystem: ref<UISystem>;

  private let m_shardTransactionListener: wref<InventoryScriptListener>;

  public func GetShouldSaveState() -> Bool {
    return true;
  }

  public func GetID() -> Int32 {
    return 1;
  }

  protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
    let shardCallback: ref<ShardCollectedInventoryCallback>;
    this.m_journalMgr = GameInstance.GetJournalManager(playerPuppet.GetGame());
    this.m_journalMgr.RegisterScriptCallback(this, n"OnJournalUpdate", gameJournalListenerType.State);
    this.m_journalMgr.RegisterScriptCallback(this, n"OnJournalEntryVisited", gameJournalListenerType.Visited);
    this.m_activeVehicleBlackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_ActiveVehicleData);
    this.m_mountBBConnectionId = this.m_activeVehicleBlackboard.RegisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, this, n"OnPlayerMounted");
    this.m_isPlayerMounted = this.m_activeVehicleBlackboard.GetBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted);
    this.m_playerPuppet = playerPuppet;
    this.m_uiSystem = GameInstance.GetUISystem(playerPuppet.GetGame());
    shardCallback = new ShardCollectedInventoryCallback();
    shardCallback.m_notificationQueue = this;
    shardCallback.m_journalManager = this.m_journalMgr;
    this.m_transactionSystem = GameInstance.GetTransactionSystem(playerPuppet.GetGame());
    this.m_shardTransactionListener = this.m_transactionSystem.RegisterInventoryListener(playerPuppet, shardCallback);
  }

  protected cb func OnPlayerDetach(playerPuppet: ref<GameObject>) -> Bool {
    this.m_journalMgr.UnregisterScriptCallback(this, n"OnJournalUpdate");
    this.m_transactionSystem.UnregisterInventoryListener(playerPuppet, this.m_shardTransactionListener);
    this.m_shardTransactionListener = null;
  }

  protected cb func OnInitialize() -> Bool {
    this.m_newAreaDef = GetAllBlackboardDefs().UI_Map;
    this.m_newAreablackboard = this.GetBlackboardSystem().Get(this.m_newAreaDef);
    this.m_newAreaID = this.m_newAreablackboard.RegisterListenerBool(this.m_newAreaDef.newLocationDiscovered, this, n"OnNewLocationDiscovered");
    this.m_tutorialDef = GetAllBlackboardDefs().UIGameData;
    this.m_tutorialBlackboard = this.GetBlackboardSystem().Get(this.m_tutorialDef);
    this.m_tutorialID = this.m_tutorialBlackboard.RegisterDelayedListenerBool(this.m_tutorialDef.Popup_IsShown, this, n"OnTutorialVisibilityUpdate");
    this.m_tutorialDataID = this.m_tutorialBlackboard.RegisterDelayedListenerVariant(this.m_tutorialDef.Popup_Data, this, n"OnTutorialDataUpdate");
    this.m_customQuestNotificationblackboardDef = GetAllBlackboardDefs().UI_CustomQuestNotification;
    this.m_customQuestNotificationblackboard = this.GetBlackboardSystem().Get(this.m_customQuestNotificationblackboardDef);
    this.m_customQuestNotificationblackBoardID = this.m_customQuestNotificationblackboard.RegisterDelayedListenerVariant(this.m_customQuestNotificationblackboardDef.data, this, n"OnCustomQuestNotificationUpdate");
    this.blackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_System);
    this.uiSystemBB = GetAllBlackboardDefs().UI_System;
    this.uiSystemId = this.blackboard.RegisterDelayedListenerBool(this.uiSystemBB.IsInMenu, this, n"OnMenuUpdate");
    this.trackedMappinId = this.blackboard.RegisterDelayedListenerVariant(this.uiSystemBB.TrackedMappin, this, n"OnTrackedMappinUpdated");
    this.blackboard.SignalBool(this.uiSystemBB.IsInMenu);
    this.SetNotificationPauseWhenHidden(true);
  }

  protected cb func OnUninitialize() -> Bool {
    if IsDefined(this.m_journalMgr) {
      this.m_journalMgr.UnregisterScriptCallback(this, n"OnJournalUpdate");
      this.m_journalMgr.UnregisterScriptCallback(this, n"OnJournalEntryVisited");
    };
    if IsDefined(this.uiSystemBB) {
      this.blackboard.UnregisterDelayedListener(this.uiSystemBB.IsInMenu, this.uiSystemId);
      this.blackboard.UnregisterDelayedListener(this.uiSystemBB.TrackedMappin, this.trackedMappinId);
    };
    if IsDefined(this.m_newAreablackboard) {
      this.m_newAreablackboard.UnregisterListenerBool(this.m_newAreaDef.newLocationDiscovered, this.m_newAreaID);
      this.m_newAreablackboard = null;
    };
    if IsDefined(this.m_customQuestNotificationblackboard) {
      this.m_customQuestNotificationblackboard.UnregisterDelayedListener(this.m_customQuestNotificationblackboardDef.data, this.m_customQuestNotificationblackBoardID);
    };
    this.m_tutorialBlackboard.UnregisterDelayedListener(this.m_tutorialDef.Popup_IsShown, this.m_tutorialID);
    this.m_tutorialBlackboard.UnregisterDelayedListener(this.m_tutorialDef.Popup_Data, this.m_tutorialDataID);
  }

  protected cb func OnPlayerMounted(value: Bool) -> Bool {
    this.m_isPlayerMounted = value;
  }

  protected cb func OnMenuUpdate(value: Bool) -> Bool {
    this.SetNotificationPaused(value);
    this.GetRootWidget().SetVisible(!value);
  }

  protected cb func OnTrackedMappinUpdated(value: Variant) -> Bool {
    let mappinText: String;
    let notificationData: gameuiGenericNotificationData;
    let objectiveText: String;
    let userData: ref<QuestUpdateNotificationViewData>;
    let mappin: wref<IMappin> = FromVariant<ref<IScriptable>>(value) as IMappin;
    if IsDefined(mappin) {
      mappinText = NameToString(MappinUIUtils.MappinToString(mappin.GetVariant()));
      objectiveText = NameToString(MappinUIUtils.MappinToObjectiveString(mappin.GetVariant()));
      userData = new QuestUpdateNotificationViewData();
      userData.title = mappinText;
      userData.text = objectiveText;
      userData.soundEvent = n"QuestNewPopup";
      userData.soundAction = n"OnOpen";
      userData.animation = n"notification_new_activity";
      userData.canBeMerged = false;
      userData.priority = EGenericNotificationPriority.Height;
      notificationData.widgetLibraryItemName = n"notification_new_activity";
      notificationData.notificationData = userData;
      notificationData.time = this.m_showDuration;
      this.AddNewNotificationData(notificationData);
    };
  }

  protected cb func OnTutorialVisibilityUpdate(value: Bool) -> Bool {
    if !value && this.m_isHiddenByTutorial {
      this.m_isHiddenByTutorial = false;
      this.SetNotificationPaused(false);
      this.GetRootWidget().SetVisible(true);
    };
  }

  protected cb func OnTutorialDataUpdate(data: Variant) -> Bool {
    let popupData: PopupData = FromVariant<PopupData>(data);
    this.m_isHiddenByTutorial = popupData.isModal;
    if this.m_isHiddenByTutorial {
      this.SetNotificationPaused(true);
      this.GetRootWidget().SetVisible(false);
    };
  }

  protected cb func OnCustomQuestNotificationUpdate(value: Variant) -> Bool {
    let notificationData: gameuiGenericNotificationData;
    let data: CustomQuestNotificationData = FromVariant<CustomQuestNotificationData>(value);
    let userData: ref<QuestUpdateNotificationViewData> = new QuestUpdateNotificationViewData();
    userData.text = GetLocalizedText(data.desc);
    userData.title = GetLocalizedText(data.header);
    userData.soundEvent = n"QuestUpdatePopup";
    userData.soundAction = n"OnOpen";
    userData.animation = n"notification_quest_completed";
    userData.canBeMerged = true;
    notificationData.time = this.m_showDuration;
    notificationData.widgetLibraryItemName = this.m_questNotification;
    notificationData.notificationData = userData;
    this.AddNewNotificationData(notificationData);
  }

  protected cb func OnNCPDJobDoneEvent(evt: ref<NCPDJobDoneEvent>) -> Bool {
    let notificationData: gameuiGenericNotificationData;
    let userData: ref<QuestUpdateNotificationViewData> = new QuestUpdateNotificationViewData();
    userData.title = "UI-Notifications-QuestCompleted";
    userData.soundEvent = n"OwCompletePopup";
    userData.soundAction = n"OnOpen";
    userData.animation = n"notification_ma_completed";
    userData.canBeMerged = false;
    userData.rewardXP = evt.levelXPAwarded;
    userData.rewardSC = evt.streetCredXPAwarded;
    notificationData.widgetLibraryItemName = n"notification_ma_completed";
    notificationData.notificationData = userData;
    notificationData.time = this.m_showDuration;
    this.AddNewNotificationData(notificationData);
  }

  protected cb func OnNewLocationDiscovered(newLocation: Bool) -> Bool {
    let notificationData: gameuiGenericNotificationData;
    let userData: ref<QuestUpdateNotificationViewData>;
    if newLocation {
      userData = new QuestUpdateNotificationViewData();
      userData.title = this.m_newAreablackboard.GetString(this.m_newAreaDef.currentLocation);
      userData.text = this.m_newAreablackboard.GetString(this.m_newAreaDef.currentLocationEnumName);
      userData.animation = n"notification_LocationAdded";
      userData.soundEvent = n"ui_phone_sms";
      userData.soundAction = n"OnOpen";
      notificationData.time = this.m_showDuration;
      notificationData.widgetLibraryItemName = n"notification_LocationAdded";
      notificationData.notificationData = userData;
      this.AddNewNotificationData(notificationData);
    };
  }

  protected cb func OnJournalEntryVisited(hash: Uint32, className: CName, notifyOption: JournalNotifyOption, changeType: JournalChangeType) -> Bool {
    let request: ref<JournalEntryNotificationRemoveRequestData>;
    if Equals(className, n"gameJournalQuest") {
      request = new JournalEntryNotificationRemoveRequestData();
      request.entryHash = hash;
      this.RemoveNotification(request);
    };
  }

  protected cb func OnJournalUpdate(hash: Uint32, className: CName, notifyOption: JournalNotifyOption, changeType: JournalChangeType) -> Bool {
    let entry: wref<JournalEntry>;
    let entryQuest: wref<JournalQuest>;
    let removeRequest: ref<JournalEntryNotificationRemoveRequestData>;
    let state: gameJournalEntryState;
    let stateFinished: Bool;
    let tarotAddedEvent: ref<TarotCardAdded>;
    let tarotEntry: wref<JournalTarot>;
    switch className {
      case n"gameJournalQuest":
        entry = this.m_journalMgr.GetEntry(hash);
        entryQuest = entry as JournalQuest;
        state = this.m_journalMgr.GetEntryState(entry);
        stateFinished = Equals(state, gameJournalEntryState.Succeeded) || Equals(state, gameJournalEntryState.Failed);
        if Equals(notifyOption, JournalNotifyOption.Notify) && entryQuest != null {
          this.PushQuestNotification(entryQuest, state);
          if stateFinished {
            removeRequest = new JournalEntryNotificationRemoveRequestData();
            removeRequest.entryHash = Cast<Uint32>(this.m_journalMgr.GetEntryHash(entryQuest));
            this.RemoveNotification(removeRequest);
          };
        };
        break;
      case n"gameJournalTarot":
        entry = this.m_journalMgr.GetEntry(hash);
        tarotEntry = entry as JournalTarot;
        tarotAddedEvent = new TarotCardAdded();
        tarotAddedEvent.imagePart = tarotEntry.GetImagePart();
        tarotAddedEvent.cardName = tarotEntry.GetName();
        GameInstance.GetUISystem(this.GetPlayerControlledObject().GetGame()).QueueEvent(tarotAddedEvent);
        break;
      default:
    };
  }

  protected cb func OnCustomNotification(evt: ref<CustomNotificationEvent>) -> Bool {
    this.PushNotification(evt.header, evt.description, this.m_genericNotification, n"notification_quest_completed");
  }

  protected cb func OnHackingRewardNotification(evt: ref<HackingRewardNotificationEvent>) -> Bool {
    this.PushNotification("", evt.m_text, n"notification_hacking_reward", n"notification_hacking_reward", 10.00);
  }

  private final func PushQuestNotification(questEntry: wref<JournalQuest>, state: gameJournalEntryState) -> Void {
    let notificationData: gameuiGenericNotificationData;
    let questAction: ref<TrackQuestNotificationAction>;
    let userData: ref<QuestUpdateNotificationViewData> = new QuestUpdateNotificationViewData();
    userData.entryHash = this.m_journalMgr.GetEntryHash(questEntry);
    userData.questEntryId = questEntry.GetId();
    userData.text = questEntry.GetTitle(this.m_journalMgr);
    userData.canBeMerged = false;
    switch state {
      case gameJournalEntryState.Active:
        userData.title = "UI-Notifications-NewQuest";
        questAction = new TrackQuestNotificationAction();
        questAction.m_questEntry = questEntry;
        questAction.m_journalMgr = this.m_journalMgr;
        userData.action = questAction;
        userData.soundEvent = n"QuestNewPopup";
        userData.soundAction = n"OnOpen";
        userData.animation = n"notification_new_quest_added";
        notificationData.time = this.m_showDuration;
        notificationData.widgetLibraryItemName = n"notification_new_quest_added";
        notificationData.notificationData = userData;
        this.AddNewNotificationData(notificationData);
        break;
      case gameJournalEntryState.Succeeded:
        userData.title = "UI-Notifications-QuestCompleted";
        userData.soundEvent = n"QuestSuccessPopup";
        userData.soundAction = n"OnOpen";
        userData.animation = n"notification_quest_completed";
        userData.dontRemoveOnRequest = true;
        notificationData.time = 12.00;
        notificationData.widgetLibraryItemName = n"notification_quest_completed";
        notificationData.notificationData = userData;
        this.AddNewNotificationData(notificationData);
        break;
      case gameJournalEntryState.Failed:
        userData.title = "LocKey#27566";
        userData.soundEvent = n"QuestFailedPopup";
        userData.soundAction = n"OnOpen";
        userData.animation = n"notification_quest_failed";
        userData.dontRemoveOnRequest = true;
        notificationData.time = this.m_showDuration;
        notificationData.widgetLibraryItemName = n"notification_quest_failed";
        notificationData.notificationData = userData;
        this.AddNewNotificationData(notificationData);
        break;
      default:
        return;
    };
  }

  private final func PushObjectiveQuestNotification(entry: wref<JournalEntry>) -> Void {
    let notificationData: gameuiGenericNotificationData;
    let parentQuestEntry: wref<JournalQuest>;
    let questAction: ref<TrackQuestNotificationAction>;
    let userData: ref<QuestUpdateNotificationViewData>;
    let currentEntry: wref<JournalEntry> = entry;
    while parentQuestEntry == null {
      currentEntry = this.m_journalMgr.GetParentEntry(currentEntry);
      if !IsDefined(currentEntry) {
        return;
      };
      parentQuestEntry = currentEntry as JournalQuest;
    };
    userData = new QuestUpdateNotificationViewData();
    userData.questEntryId = parentQuestEntry.GetId();
    userData.entryHash = this.m_journalMgr.GetEntryHash(parentQuestEntry);
    userData.text = parentQuestEntry.GetTitle(this.m_journalMgr);
    userData.title = "UI-Notifications-QuestUpdated";
    userData.soundEvent = n"QuestUpdatePopup";
    userData.soundAction = n"OnOpen";
    userData.animation = n"notification_quest_updated";
    userData.canBeMerged = true;
    questAction = new TrackQuestNotificationAction();
    questAction.m_questEntry = parentQuestEntry;
    questAction.m_journalMgr = this.m_journalMgr;
    userData.action = questAction;
    notificationData.time = this.m_showDuration;
    notificationData.widgetLibraryItemName = n"notification_quest_updated";
    notificationData.notificationData = userData;
    this.AddNewNotificationData(notificationData);
  }

  private final func PushNotification(const title: script_ref<String>, const text: script_ref<String>, widget: CName, animation: CName, opt action: ref<GenericNotificationBaseAction>, opt duration: Float) -> Void {
    let notificationData: gameuiGenericNotificationData;
    let userData: ref<QuestUpdateNotificationViewData> = new QuestUpdateNotificationViewData();
    userData.title = Deref(title);
    userData.text = Deref(text);
    userData.action = action;
    userData.animation = animation;
    userData.soundEvent = n"QuestUpdatePopup";
    userData.soundAction = n"OnOpen";
    if duration > 0.00 {
      notificationData.time = duration;
      userData.priority = EGenericNotificationPriority.Height;
    } else {
      notificationData.time = this.m_showDuration;
    };
    notificationData.widgetLibraryItemName = widget;
    notificationData.notificationData = userData;
    this.AddNewNotificationData(notificationData);
  }

  public final func PushNotification(entry: ref<JournalOnscreen>) -> Void {
    let notificationData: gameuiGenericNotificationData;
    let userData: ref<ShardCollectedNotificationViewData> = this.GetShardNotificationData(entry);
    notificationData.time = this.m_showDuration;
    notificationData.widgetLibraryItemName = this.m_shardNotification;
    notificationData.notificationData = userData;
    this.AddNewNotificationData(notificationData);
  }

  private final func GetShardNotificationData(entry: ref<JournalOnscreen>) -> ref<ShardCollectedNotificationViewData> {
    let userData: ref<ShardCollectedNotificationViewData> = new ShardCollectedNotificationViewData();
    userData.title = GetLocalizedText("UI-Notifications-ShardCollected") + " " + GetLocalizedText(entry.GetTitle());
    userData.text = entry.GetDescription();
    userData.shardTitle = GetLocalizedText(entry.GetTitle());
    userData.entry = entry;
    userData.m_imageId = entry.GetIconID();
    let shardOpenAction: ref<OpenShardNotificationAction> = new OpenShardNotificationAction();
    shardOpenAction.m_eventDispatcher = this.m_uiSystem;
    userData.action = shardOpenAction;
    userData.soundEvent = n"ShardCollectedPopup";
    userData.soundAction = n"OnLoot";
    return userData;
  }

  public final func PushCrackableNotification(itemID: ItemID, entry: ref<JournalOnscreen>) -> Void {
    let notificationData: gameuiGenericNotificationData;
    let userData: ref<ShardCollectedNotificationViewData> = this.GetShardNotificationData(entry);
    userData.isCrypted = true;
    userData.itemID = itemID;
    notificationData.time = this.m_showDuration;
    notificationData.widgetLibraryItemName = this.m_shardNotification;
    notificationData.notificationData = userData;
    this.AddNewNotificationData(notificationData);
    this.ProcessCrackableShardTutorial();
  }

  public final func ProcessCrackableShardTutorial() -> Void {
    let questSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.GetPlayerControlledObject().GetGame());
    if questSystem.GetFact(n"encoded_shard_tutorial") == 0 && questSystem.GetFact(n"disable_tutorials") == 0 {
      questSystem.SetFact(n"encoded_shard_tutorial", 1);
    };
  }
}

public class MessengerNotification extends GenericNotificationController {

  private edit let m_messageText: inkTextRef;

  private edit let m_avatar: inkImageRef;

  private edit let m_descriptionText: inkTextRef;

  private edit let m_mappinIcon: inkImageRef;

  private edit let m_envelopIcon: inkWidgetRef;

  private let m_interactionsBlackboard: wref<IBlackboard>;

  private let m_deviceBlackboard: wref<IBlackboard>;

  public let m_contactsActiveCallback: ref<CallbackHandle>;

  private let m_messageData: ref<PhoneMessageNotificationViewData>;

  private let m_animProxy: ref<inkAnimProxy>;

  @default(MessengerNotification, 40)
  private let m_textSizeLimit: Int32;

  private let m_journalMgr: wref<JournalManager>;

  private let m_mappinSystem: wref<MappinSystem>;

  protected cb func OnInitialize() -> Bool {
    super.OnInitialize();
    this.m_interactionsBlackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UIInteractions);
    this.m_deviceBlackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_ComDevice);
    this.m_contactsActiveCallback = this.m_deviceBlackboard.RegisterDelayedListenerBool(GetAllBlackboardDefs().UI_ComDevice.ContactsActive, this, n"OnContactsActive");
    this.RegisterToCallback(n"OnNotificationPaused", this, n"OnNotificationPaused");
    this.RegisterToCallback(n"OnNotificationResumed", this, n"OnNotificationResumed");
  }

  protected cb func OnUninitialize() -> Bool {
    this.m_deviceBlackboard.UnregisterDelayedListener(GetAllBlackboardDefs().UI_ComDevice.ContactsActive, this.m_contactsActiveCallback);
    this.UnregisterFromCallback(n"OnNotificationPaused", this, n"OnNotificationPaused");
    this.UnregisterFromCallback(n"OnNotificationResumed", this, n"OnNotificationResumed");
    super.OnUninitialize();
  }

  protected cb func OnContactsActive(value: Bool) -> Bool {
    this.GetRootWidget().SetVisible(!value);
    if !value {
      this.OnNotificationResumed();
    } else {
      this.OnNotificationPaused();
    };
  }

  public func SetNotificationData(notificationData: ref<GenericNotificationViewData>) -> Void {
    let attachmentHash: Uint32;
    let contactEntry: wref<JournalContact>;
    let fitToContent: Bool;
    let mappinActive: Bool;
    let mappinEvent: ref<QuestMappinHighlightEvent>;
    let mappinInfoDisplayed: Bool;
    let mappinPhase: gamedataMappinPhase;
    let mappinPhaseInt: Uint16;
    let mappinVariant: gamedataMappinVariant;
    let mappinVariantInt: Uint16;
    let messageEntry: wref<JournalPhoneMessage>;
    let playbackOptions: inkAnimOptions;
    let poiHash: Uint32;
    let smsText: String;
    let texturePart: CName;
    if IsDefined(this.m_animProxy) {
      this.m_animProxy.Stop();
      this.m_animProxy = null;
    };
    this.m_customInputActionName = n"None";
    mappinInfoDisplayed = false;
    this.m_messageData = notificationData as PhoneMessageNotificationViewData;
    if IsDefined(this.m_messageData) {
      this.m_journalMgr = GameInstance.GetJournalManager(this.GetPlayerControlledObject().GetGame());
      this.m_mappinSystem = GameInstance.GetMappinSystem(this.GetPlayerControlledObject().GetGame());
      playbackOptions.toMarker = n"OutroStart";
      smsText = NotEquals(this.m_messageData.SMSLocKey, "") ? GetLocalizedText(this.m_messageData.SMSLocKey) : this.m_messageData.SMSText;
      inkTextRef.SetText(this.m_messageText, smsText);
      fitToContent = StrLen(smsText) < this.m_textSizeLimit;
      inkWidgetRef.SetFitToContent(this.m_messageText, fitToContent);
      contactEntry = this.m_journalMgr.GetEntry(Cast<Uint32>(this.m_messageData.contactHash)) as JournalContact;
      messageEntry = this.m_journalMgr.GetEntry(Cast<Uint32>(this.m_messageData.entryHash)) as JournalPhoneMessage;
      InkImageUtils.RequestAvatarOrUnknown(this, this.m_avatar, contactEntry.GetAvatarID(this.m_journalMgr));
      attachmentHash = messageEntry.GetAttachmentPathHash();
      if attachmentHash > 0u {
        poiHash = this.m_journalMgr.GetPointOfInterestMappinHashFromQuestHash(attachmentHash);
      };
      if this.m_mappinSystem.GetPointOfInterestMappinSavedState(poiHash, mappinPhaseInt, mappinVariantInt, mappinActive) {
        mappinVariant = IntEnum<gamedataMappinVariant>(Cast<Uint32>(mappinVariantInt));
        mappinPhase = IntEnum<gamedataMappinPhase>(Cast<Uint32>(mappinPhaseInt));
        if NotEquals(mappinPhase, gamedataMappinPhase.UndiscoveredPhase) && NotEquals(mappinPhase, gamedataMappinPhase.CompletedPhase) {
          texturePart = MappinUIUtils.MappinToTexturePart(mappinVariant, mappinPhase);
          inkImageRef.SetTexturePart(this.m_mappinIcon, texturePart);
          inkTextRef.SetLocalizedTextScript(this.m_descriptionText, MappinUIUtils.MappinToString(mappinVariant, gamedataMappinPhase.DefaultPhase));
          inkWidgetRef.SetVisible(this.m_mappinIcon, true);
          inkWidgetRef.SetVisible(this.m_envelopIcon, false);
          mappinEvent = new QuestMappinHighlightEvent();
          mappinEvent.m_hash = attachmentHash;
          this.QueueBroadcastEvent(mappinEvent);
          mappinInfoDisplayed = true;
        };
      };
      if !mappinInfoDisplayed {
        inkTextRef.SetLocalizedTextScript(this.m_descriptionText, n"Story-base-gameplay-gui-widgets-notifications-quest_update-_localizationString9");
        inkWidgetRef.SetVisible(this.m_mappinIcon, false);
        inkWidgetRef.SetVisible(this.m_envelopIcon, true);
      };
      this.m_animProxy = this.PlayLibraryAnimation(this.m_messageData.animation, playbackOptions);
      this.m_animProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnNotificationShown");
      this.m_customInputActionName = n"NotificationOpenSMS";
    };
    super.SetNotificationData(notificationData);
  }

  protected cb func OnNotificationPaused() -> Bool {
    if IsDefined(this.m_animProxy) {
      this.m_animProxy.Pause();
    };
    super.OnNotificationPaused();
  }

  protected cb func OnNotificationResumed() -> Bool {
    if IsDefined(this.m_animProxy) {
      this.m_animProxy.Resume();
    };
    super.OnNotificationResumed();
  }

  protected cb func OnNotificationShown(anim: ref<inkAnimProxy>) -> Bool {
    this.SetNotificationShown();
  }

  private final const func GetNetworkBlackboardDef() -> ref<NetworkBlackboardDef> {
    return GetAllBlackboardDefs().NetworkBlackboard;
  }

  private final const func GetNetworkBlackboard() -> ref<IBlackboard> {
    return GameInstance.GetBlackboardSystem(GetGameInstance()).Get(this.GetNetworkBlackboardDef());
  }

  private func OnActionTriggered() -> Void {
    let linkStatus: EPersonalLinkConnectionStatus = IntEnum<EPersonalLinkConnectionStatus>(this.GetNetworkBlackboard().GetInt(this.GetNetworkBlackboardDef().PersonalLinkStatus));
    if NotEquals(linkStatus, EPersonalLinkConnectionStatus.CONNECTING) {
      this.SetNotificationShown();
    };
  }

  private final func SetNotificationShown() -> Void {
    this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UIGameData).SetInt(GetAllBlackboardDefs().UIGameData.NotificationJournalHash, this.m_messageData.entryHash);
  }
}

public class JournalNotification extends GenericNotificationController {

  protected let m_interactionsBlackboard: wref<IBlackboard>;

  protected let m_bbListenerId: ref<CallbackHandle>;

  protected let m_animProxy: ref<inkAnimProxy>;

  protected let m_questNotificationData: ref<QuestUpdateNotificationViewData>;

  protected cb func OnInitialize() -> Bool {
    super.OnInitialize();
    this.m_interactionsBlackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UIInteractions);
    this.m_bbListenerId = this.m_interactionsBlackboard.RegisterDelayedListenerBool(GetAllBlackboardDefs().UIInteractions.HasScrollableInteraction, this, n"OnInteractionUpdate", true);
    this.m_interactionsBlackboard.SetBool(GetAllBlackboardDefs().UIInteractions.IsQuestNotificationUp, true);
    this.RegisterToCallback(n"OnNotificationPaused", this, n"OnNotificationPaused");
    this.RegisterToCallback(n"OnNotificationResumed", this, n"OnNotificationResumed");
  }

  protected cb func OnUninitialize() -> Bool {
    this.UnregisterFromCallback(n"OnNotificationPaused", this, n"OnNotificationPaused");
    this.UnregisterFromCallback(n"OnNotificationResumed", this, n"OnNotificationResumed");
    this.m_interactionsBlackboard.SetBool(GetAllBlackboardDefs().UIInteractions.IsQuestNotificationUp, false);
    super.OnUninitialize();
    this.m_interactionsBlackboard.UnregisterDelayedListener(GetAllBlackboardDefs().UIInteractions.HasScrollableInteraction, this.m_bbListenerId);
  }

  protected cb func OnInteractionUpdate(value: Bool) -> Bool {
    this.m_blockAction = value;
    inkWidgetRef.SetVisible(this.m_actionRef, !this.m_blockAction);
  }

  public func SetNotificationData(notificationData: ref<GenericNotificationViewData>) -> Void {
    let playbackOptions: inkAnimOptions;
    this.m_questNotificationData = notificationData as QuestUpdateNotificationViewData;
    if IsDefined(this.m_animProxy) {
      this.m_animProxy.Stop();
      this.m_animProxy = null;
    };
    this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UIGameData).SetInt(GetAllBlackboardDefs().UIGameData.NotificationJournalHash, this.m_questNotificationData.entryHash);
    this.m_animProxy = this.PlayLibraryAnimation(this.m_questNotificationData.animation, playbackOptions);
    super.SetNotificationData(notificationData);
  }

  protected cb func OnNotificationPaused() -> Bool {
    if IsDefined(this.m_animProxy) {
      this.m_animProxy.Pause();
    };
    super.OnNotificationPaused();
  }

  protected cb func OnNotificationResumed() -> Bool {
    if IsDefined(this.m_animProxy) {
      this.m_animProxy.Resume();
    };
    super.OnNotificationResumed();
  }
}

public class NewLocationNotification extends JournalNotification {

  private edit let districtName: inkTextRef;

  private edit let districtIcon: inkImageRef;

  private edit let districtFluffIcon: inkImageRef;

  protected cb func OnInitialize() -> Bool {
    super.OnInitialize();
    this.RegisterToCallback(n"OnNotificationPaused", this, n"OnNotificationPaused");
    this.RegisterToCallback(n"OnNotificationResumed", this, n"OnNotificationResumed");
  }

  protected cb func OnUninitialize() -> Bool {
    this.UnregisterFromCallback(n"OnNotificationPaused", this, n"OnNotificationPaused");
    this.UnregisterFromCallback(n"OnNotificationResumed", this, n"OnNotificationResumed");
    super.OnUninitialize();
  }

  protected cb func OnInteractionUpdate(value: Bool) -> Bool {
    this.m_blockAction = value;
    inkWidgetRef.SetVisible(this.m_actionRef, !this.m_blockAction);
  }

  public func SetNotificationData(notificationData: ref<GenericNotificationViewData>) -> Void {
    let iconRecord: ref<UIIcon_Record>;
    let playbackOptions: inkAnimOptions;
    this.m_questNotificationData = notificationData as QuestUpdateNotificationViewData;
    if IsDefined(this.m_animProxy) {
      this.m_animProxy.Stop();
      this.m_animProxy = null;
    };
    inkTextRef.SetText(this.districtName, this.m_questNotificationData.title);
    if Equals(this.m_questNotificationData.title, "LocKey#94398") {
      inkImageRef.SetTexturePart(this.districtIcon, n"ico_district_westbrook_large");
      inkImageRef.SetTexturePart(this.districtFluffIcon, n"ico_district_westbrook_large");
    } else {
      iconRecord = TweakDBInterface.GetUIIconRecord(TDBID.Create("UIIcon." + this.m_questNotificationData.text));
      inkImageRef.SetTexturePart(this.districtIcon, iconRecord.AtlasPartName());
      inkImageRef.SetTexturePart(this.districtFluffIcon, iconRecord.AtlasPartName());
    };
    this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UIGameData).SetInt(GetAllBlackboardDefs().UIGameData.NotificationJournalHash, this.m_questNotificationData.entryHash);
    this.m_animProxy = this.PlayLibraryAnimation(this.m_questNotificationData.animation, playbackOptions);
    super.SetNotificationData(notificationData);
  }

  protected cb func OnNotificationPaused() -> Bool {
    if IsDefined(this.m_animProxy) {
      this.m_animProxy.Pause();
    };
    super.OnNotificationPaused();
  }

  protected cb func OnNotificationResumed() -> Bool {
    if IsDefined(this.m_animProxy) {
      this.m_animProxy.Resume();
    };
    super.OnNotificationResumed();
  }
}

public class NCPDJobDoneNotification extends JournalNotification {

  private edit let m_NCPD_Reward: inkWidgetRef;

  private edit let m_NCPD_XP_RewardText: inkTextRef;

  private edit let m_NCPD_SC_RewardText: inkTextRef;

  protected cb func OnInitialize() -> Bool {
    super.OnInitialize();
    this.RegisterToCallback(n"OnNotificationPaused", this, n"OnNotificationPaused");
    this.RegisterToCallback(n"OnNotificationResumed", this, n"OnNotificationResumed");
  }

  protected cb func OnUninitialize() -> Bool {
    this.UnregisterFromCallback(n"OnNotificationPaused", this, n"OnNotificationPaused");
    this.UnregisterFromCallback(n"OnNotificationResumed", this, n"OnNotificationResumed");
    super.OnUninitialize();
  }

  protected cb func OnInteractionUpdate(value: Bool) -> Bool {
    this.m_blockAction = value;
    inkWidgetRef.SetVisible(this.m_actionRef, !this.m_blockAction);
  }

  public func SetNotificationData(notificationData: ref<GenericNotificationViewData>) -> Void {
    let playbackOptions: inkAnimOptions;
    this.m_questNotificationData = notificationData as QuestUpdateNotificationViewData;
    if IsDefined(this.m_animProxy) {
      this.m_animProxy.Stop();
      this.m_animProxy = null;
    };
    inkTextRef.SetText(this.m_NCPD_XP_RewardText, IntToString(this.m_questNotificationData.rewardXP));
    inkTextRef.SetText(this.m_NCPD_SC_RewardText, IntToString(this.m_questNotificationData.rewardSC));
    inkWidgetRef.SetVisible(this.m_NCPD_Reward, this.m_questNotificationData.rewardXP > 0 || this.m_questNotificationData.rewardSC > 0);
    this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UIGameData).SetInt(GetAllBlackboardDefs().UIGameData.NotificationJournalHash, this.m_questNotificationData.entryHash);
    this.m_animProxy = this.PlayLibraryAnimation(this.m_questNotificationData.animation, playbackOptions);
    super.SetNotificationData(notificationData);
  }

  protected cb func OnNotificationPaused() -> Bool {
    if IsDefined(this.m_animProxy) {
      this.m_animProxy.Pause();
    };
    super.OnNotificationPaused();
  }

  protected cb func OnNotificationResumed() -> Bool {
    if IsDefined(this.m_animProxy) {
      this.m_animProxy.Resume();
    };
    super.OnNotificationResumed();
  }
}
