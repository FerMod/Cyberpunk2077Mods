
public class ShardCollectedInventoryCallback extends InventoryScriptCallback {

  public let m_notificationQueue: wref<JournalNotificationQueue>;

  public let m_journalManager: wref<JournalManager>;

  public func OnItemQuantityChanged(item: ItemID, diff: Int32, total: Uint32, flaggedAsSilent: Bool) -> Void {
    let effect: wref<TriggerHackingMinigameEffector_Record>;
    let entryString: String;
    let journalEntry: wref<JournalOnscreen>;
    let journalHash: Int32;
    if diff < 1 {
      return;
    };
    if Equals(RPGManager.GetItemType(item), gamedataItemType.Gen_Readable) {
      entryString = ReadAction.GetJournalEntryFromAction(ItemActionsHelper.GetReadAction(item).GetID());
      journalEntry = this.m_journalManager.GetEntryByString(entryString, "gameJournalOnscreen") as JournalOnscreen;
      journalHash = this.m_journalManager.GetEntryHash(journalEntry);
      if this.m_journalManager.IsAttachedToAnyActiveQuest(journalHash) {
        this.OpenShardPopup(journalEntry, item, false);
      } else {
        this.m_notificationQueue.PushNotification(journalEntry);
      };
    } else {
      if IsDefined(ItemActionsHelper.GetCrackAction(item)) {
        effect = (ItemActionsHelper.GetCrackAction(item) as CrackAction_Record).Effector() as TriggerHackingMinigameEffector_Record;
        if IsDefined(effect) {
          entryString = effect.JournalEntry();
          if IsStringValid(entryString) {
            journalEntry = this.m_journalManager.GetEntryByString(entryString, "gameJournalOnscreen") as JournalOnscreen;
            journalHash = this.m_journalManager.GetEntryHash(journalEntry);
            if this.m_journalManager.IsAttachedToAnyActiveQuest(journalHash) {
              this.OpenShardPopup(journalEntry, item, true);
            } else {
              this.m_notificationQueue.PushCrackableNotification(item, journalEntry);
            };
          };
        };
      };
    };
  }

  private final func OpenShardPopup(entry: ref<JournalOnscreen>, item: ItemID, isCrypted: Bool) -> Void {
    let evt: ref<NotifyShardRead> = new NotifyShardRead();
    evt.title = GetLocalizedText(entry.GetTitle());
    evt.text = entry.GetDescription();
    evt.entry = entry;
    evt.isCrypted = isCrypted;
    evt.itemID = item;
    evt.m_imageId = entry.GetIconID();
    this.m_notificationQueue.QueueBroadcastEvent(evt);
  }
}

public class ShardCollectedNotificationViewData extends GenericNotificationViewData {

  public let entry: ref<JournalOnscreen>;

  public let isCrypted: Bool;

  public let itemID: ItemID;

  public let shardTitle: String;

  public let m_imageId: TweakDBID;

  public func CanMerge(data: ref<GenericNotificationViewData>) -> Bool {
    let compareTo: ref<ShardCollectedNotificationViewData> = data as ShardCollectedNotificationViewData;
    return Equals(compareTo.shardTitle, this.shardTitle);
  }
}

public class ShardCollectedNotification extends GenericNotificationController {

  private edit let m_shardTitle: inkTextRef;

  public let m_bbListenerId: ref<CallbackHandle>;

  private let m_animProxy: ref<inkAnimProxy>;

  protected cb func OnInitialize() -> Bool {
    let playerPuppet: wref<PlayerPuppet>;
    let playerStateMachineBlackboard: ref<IBlackboard>;
    super.OnInitialize();
    playerPuppet = GameInstance.GetPlayerSystem(this.GetPlayerControlledObject().GetGame()).GetLocalPlayerControlledGameObject() as PlayerPuppet;
    playerStateMachineBlackboard = GameInstance.GetBlackboardSystem(this.GetPlayerControlledObject().GetGame()).GetLocalInstanced(playerPuppet.GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    this.m_bbListenerId = playerStateMachineBlackboard.RegisterDelayedListenerBool(GetAllBlackboardDefs().PlayerStateMachine.IsInteractingViaPersonalLink, this, n"OnInteractionUpdate", true);
    this.RegisterToCallback(n"OnNotificationPaused", this, n"OnNotificationPaused");
    this.RegisterToCallback(n"OnNotificationResumed", this, n"OnNotificationResumed");
  }

  protected cb func OnUninitialize() -> Bool {
    let playerPuppet: wref<PlayerPuppet> = GameInstance.GetPlayerSystem(this.GetPlayerControlledObject().GetGame()).GetLocalPlayerControlledGameObject() as PlayerPuppet;
    let playerStateMachineBlackboard: ref<IBlackboard> = GameInstance.GetBlackboardSystem(this.GetPlayerControlledObject().GetGame()).GetLocalInstanced(playerPuppet.GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    playerStateMachineBlackboard.UnregisterListenerBool(GetAllBlackboardDefs().PlayerStateMachine.IsInteractingViaPersonalLink, this.m_bbListenerId);
    this.UnregisterFromCallback(n"OnNotificationPaused", this, n"OnNotificationPaused");
    this.UnregisterFromCallback(n"OnNotificationResumed", this, n"OnNotificationResumed");
    super.OnUninitialize();
  }

  protected cb func OnInteractionUpdate(value: Bool) -> Bool {
    this.m_blockAction = value;
    inkWidgetRef.SetVisible(this.m_actionRef, !this.m_blockAction);
  }

  public func SetNotificationData(notificationData: ref<GenericNotificationViewData>) -> Void {
    let data: ref<ShardCollectedNotificationViewData> = notificationData as ShardCollectedNotificationViewData;
    inkTextRef.SetText(this.m_shardTitle, this.WrapText(data.shardTitle));
    if IsDefined(this.m_animProxy) {
      this.m_animProxy.Stop();
      this.m_animProxy = null;
    };
    this.m_animProxy = this.PlayLibraryAnimation(n"notification_shard");
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

  private final func WrapText(title: String) -> String {
    let maxTextSize: Int32 = 85;
    if StrLen(title) > maxTextSize {
      title = StrLeft(title, maxTextSize);
      title = StrLeft(title, StrFindLast(title, " "));
      title += "(...)";
    };
    return title;
  }
}
