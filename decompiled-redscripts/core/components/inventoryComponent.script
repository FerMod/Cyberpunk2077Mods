
public native class InventoryScriptCallback extends IScriptable {

  public native let itemID: ItemID;

  public func OnItemNotification(item: ItemID, itemData: wref<gameItemData>) -> Void;

  public func OnItemAdded(item: ItemID, itemData: wref<gameItemData>, flaggedAsSilent: Bool) -> Void;

  public func OnItemRemoved(item: ItemID, difference: Int32, currentQuantity: Int32) -> Void;

  public func OnItemQuantityChanged(item: ItemID, diff: Int32, total: Uint32, flaggedAsSilent: Bool) -> Void;

  public func OnItemExtracted(item: ItemID) -> Void;

  public func OnPartAdded(item: ItemID, partID: ItemID) -> Void;

  public func OnPartRemoved(partID: ItemID, formerItemID: ItemID) -> Void;
}

public final native class Inventory extends GameComponent {

  public final native func IsAccessible() -> Bool;

  public final native func ReinitializeStatsOnAllItems() -> Bool;

  public final static native func CreateItemData(itemData: ItemModParams, owner: wref<GameObject>) -> ref<gameItemData>;

  public final func IsChoiceAvailable(itemActionRecord: ref<ItemAction_Record>, requester: ref<GameObject>, ownerEntID: EntityID, itemID: ItemID) -> gameinteractionsELootChoiceType {
    let emptyContext: GetActionsContext;
    let itemData: wref<gameItemData> = RPGManager.GetItemData(requester.GetGame(), this.GetEntity() as GameObject, itemID);
    let action: ref<BaseItemAction> = ItemActionsHelper.SetupItemAction(requester.GetGame(), requester, itemData, itemActionRecord.GetID(), false);
    if action.IsVisible(emptyContext) {
      return gameinteractionsELootChoiceType.Available;
    };
    return gameinteractionsELootChoiceType.Invisible;
  }

  protected final cb func OnLootAllEvent(evt: ref<OnLootAllEvent>) -> Bool {
    let gameObject: ref<GameObject> = this.GetEntity() as GameObject;
    GameInstance.GetAudioSystem(gameObject.GetGame()).PlayLootAllSound();
  }

  protected final cb func OnInteractionUsed(evt: ref<InteractionChoiceEvent>) -> Bool {
    let broadcaster: ref<StimBroadcasterComponent>;
    let itemData: wref<gameItemData>;
    let itemQuality: gamedataQuality;
    let gameObject: ref<GameObject> = this.GetEntity() as GameObject;
    let lootActionWrapper: LootChoiceActionWrapper = LootChoiceActionWrapper.Unwrap(evt);
    if LootChoiceActionWrapper.IsValid(lootActionWrapper) {
      if (evt.activator as PlayerPuppet).IsInCombat() && IsDefined(TweakDBInterface.GetConsumableItemRecord(ItemID.GetTDBID(lootActionWrapper.itemId))) {
        return false;
      };
      if LootChoiceActionWrapper.IsIllegal(lootActionWrapper) {
        broadcaster = evt.activator.GetStimBroadcasterComponent();
        if IsDefined(broadcaster) {
          broadcaster.TriggerSingleBroadcast(gameObject, gamedataStimType.IllegalInteraction);
        };
      };
      if RPGManager.ConsumeItem(gameObject, evt) {
        GameInstance.GetAudioSystem(gameObject.GetGame()).PlayItemActionSound(lootActionWrapper.action, RPGManager.GetItemData(gameObject.GetGame(), gameObject, lootActionWrapper.itemId));
        return false;
      };
      itemData = RPGManager.GetItemData(gameObject.GetGame(), gameObject, lootActionWrapper.itemId);
      if Equals(lootActionWrapper.action, n"Learn") {
        ItemActionsHelper.LearnItem(evt.activator, lootActionWrapper.itemId, false);
      } else {
        if Equals(lootActionWrapper.action, n"Loot") {
          itemQuality = RPGManager.GetItemDataQuality(itemData);
          if RPGManager.IsItemIconic(itemData) || Equals(itemQuality, gamedataQuality.Iconic) {
            GameInstance.GetRazerChromaEffectsSystem(gameObject.GetGame()).PlayAnimation(n"TakeItem", false);
          };
        };
      };
      if Equals(LootChoiceActionWrapper.IsHandledByCode(lootActionWrapper), false) {
        GameInstance.GetTransactionSystem(gameObject.GetGame()).RemoveItem(gameObject, lootActionWrapper.itemId, 1);
      };
      GameInstance.GetAudioSystem(gameObject.GetGame()).PlayItemActionSound(lootActionWrapper.action, itemData);
    };
  }
}

public native class gameLootObject extends GameObject {

  protected let m_isInIconForcedVisibilityRange: Bool;

  protected let m_activeQualityRangeInteraction: CName;

  @default(gameLootObject, gamedataQuality.Common)
  protected let m_lootQuality: gamedataQuality;

  protected cb func OnInteractionActivated(evt: ref<InteractionActivationEvent>) -> Bool {
    if Equals(evt.layerData.tag, n"auto") {
      GameObject.PlaySoundEvent(evt.activator, n"ui_loot_ammo");
    };
  }

  protected final func IsQualityRangeInteractionLayer(layerTag: CName) -> Bool {
    return Equals(layerTag, n"QualityRange_Short") || Equals(layerTag, n"QualityRange_Medium") || Equals(layerTag, n"QualityRange_Max");
  }

  protected final func SetQualityRangeInteractionLayerState(enable: Bool) -> Void {
    let evt: ref<InteractionSetEnableEvent>;
    if IsNameValid(this.m_activeQualityRangeInteraction) {
      evt = new InteractionSetEnableEvent();
      evt.enable = enable;
      evt.layer = this.m_activeQualityRangeInteraction;
      this.QueueEvent(evt);
    };
  }

  protected final func ResolveQualityRangeInteractionLayer() -> Void {
    let currentLayer: CName;
    if IsNameValid(this.m_activeQualityRangeInteraction) {
      this.SetQualityRangeInteractionLayerState(false);
    };
    if NotEquals(this.m_lootQuality, gamedataQuality.Invalid) && NotEquals(this.m_lootQuality, gamedataQuality.Random) {
      if this.IsQuest() {
        currentLayer = n"QualityRange_Max";
      } else {
        if Equals(this.m_lootQuality, gamedataQuality.Common) {
          currentLayer = n"QualityRange_Short";
        } else {
          if Equals(this.m_lootQuality, gamedataQuality.Uncommon) {
            currentLayer = n"QualityRange_Medium";
          } else {
            if Equals(this.m_lootQuality, gamedataQuality.Rare) {
              currentLayer = n"QualityRange_Medium";
            } else {
              if Equals(this.m_lootQuality, gamedataQuality.Epic) {
                currentLayer = n"QualityRange_Max";
              } else {
                if Equals(this.m_lootQuality, gamedataQuality.Legendary) {
                  currentLayer = n"QualityRange_Max";
                } else {
                  if Equals(this.m_lootQuality, gamedataQuality.Iconic) {
                    currentLayer = n"QualityRange_Max";
                  };
                };
              };
            };
          };
        };
      };
    } else {
      currentLayer = n"None";
    };
    this.m_activeQualityRangeInteraction = currentLayer;
    this.SetQualityRangeInteractionLayerState(true);
  }

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
    EntityRequestComponentsInterface.RequestComponent(ri, n"Collider", n"entColliderComponent", false);
  }

  public const func IsInIconForcedVisibilityRange() -> Bool {
    return this.m_isInIconForcedVisibilityRange;
  }
}

public final native class gameItemDropObject extends gameLootObject {

  private let m_isEmpty: Bool;

  private let m_isIconic: Bool;

  private let m_hasQuestItems: Bool;

  private let m_spawnedItemID: ItemID;

  public final native const func GetItemEntityID() -> EntityID;

  public final native const func GetItemObject() -> wref<ItemObject>;

  protected final func EvaluateLootQualityByTask() -> Void {
    GameInstance.GetDelaySystem(this.GetGame()).QueueTask(this, null, n"EvaluateLootQualityTask", gameScriptTaskExecutionStage.Any);
  }

  protected final func EvaluateLootQualityTask(data: ref<ScriptTaskData>) -> Void {
    this.EvaluateLootQuality();
  }

  protected final cb func OnGameAttached() -> Bool {
    let scanningBlockedEvt: ref<SetScanningBlockedEvent>;
    super.OnGameAttached();
    if IsDefined(this.m_scanningComponent) {
      scanningBlockedEvt = new SetScanningBlockedEvent();
      scanningBlockedEvt.isBlocked = false;
      this.QueueEvent(scanningBlockedEvt);
    };
    this.ResolveInvotoryContent();
    if this.IsEmpty() {
      this.ToggleLootHighlight(false);
    } else {
      if this.IsQuest() {
        this.ToggleLootHighlight(true);
      };
    };
  }

  private final func ResolveInvotoryContent() -> Void {
    this.m_isEmpty = GameInstance.GetTransactionSystem(this.GetGame()).GetTotalItemQuantity(this) <= 0;
  }

  private final func HasValidLootQuality() -> Bool {
    return NotEquals(this.m_lootQuality, gamedataQuality.Invalid) && NotEquals(this.m_lootQuality, gamedataQuality.Random);
  }

  private final func EvaluateLootQuality() -> Bool {
    let i: Int32;
    let isQuest: Bool;
    let items: array<wref<gameItemData>>;
    let iteratedQuality: gamedataQuality;
    let lastValue: Int32;
    let newValue: Int32;
    let qualityToSet: gamedataQuality;
    let wasChanged: Bool;
    let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
    let cachedQuality: gamedataQuality = this.m_lootQuality;
    let isCurrentlyQuest: Bool = this.IsQuest();
    let isCurrentlyIconic: Bool = this.GetIsIconic();
    this.m_isIconic = false;
    this.m_hasQuestItems = false;
    if transactionSystem.GetItemList(this, items) {
      if ArraySize(items) > 0 {
        qualityToSet = gamedataQuality.Common;
        this.m_isEmpty = false;
      };
      i = 0;
      while i < ArraySize(items) {
        if !this.m_hasQuestItems && items[i].HasTag(n"Quest") {
          this.m_hasQuestItems = true;
        };
        iteratedQuality = RPGManager.GetItemDataQuality(items[i]);
        newValue = UIItemsHelper.QualityEnumToInt(iteratedQuality);
        if newValue > lastValue {
          lastValue = newValue;
          qualityToSet = iteratedQuality;
        };
        this.m_isIconic = this.m_isIconic || RPGManager.IsItemIconic(items[i]);
        i += 1;
      };
      this.m_lootQuality = qualityToSet;
    };
    isQuest = this.IsQuest();
    if NotEquals(isCurrentlyQuest, isQuest) {
      this.ToggleLootHighlight(isQuest);
      if !isQuest {
        this.MarkAsQuest(false);
      };
    };
    wasChanged = NotEquals(this.m_lootQuality, cachedQuality) || NotEquals(isCurrentlyQuest, this.IsQuest()) || NotEquals(isCurrentlyIconic, this.m_isIconic);
    if wasChanged || !IsNameValid(this.m_activeQualityRangeInteraction) {
      this.ResolveQualityRangeInteractionLayer();
    };
    return wasChanged;
  }

  public final const func GetLootQuality() -> gamedataQuality {
    return this.m_lootQuality;
  }

  public final const func GetIsIconic() -> Bool {
    return this.m_isIconic;
  }

  public final const func DeterminGameplayRoleMappinVisuaState(const data: script_ref<SDeviceMappinData>) -> EMappinVisualState {
    if this.IsEmpty() {
      return EMappinVisualState.Inactive;
    };
    return EMappinVisualState.Default;
  }

  public final const func DeterminGameplayRole() -> EGameplayRole {
    return EGameplayRole.Loot;
  }

  public final const func IsQuest() -> Bool {
    return this.m_hasQuestItems || this.m_markAsQuest;
  }

  public final const func IsContainer() -> Bool {
    return !this.IsEmpty();
  }

  private final func ToggleLootHighlight(enable: Bool) -> Void {
    let effectInstance: ref<EffectInstance> = GameInstance.GetGameEffectSystem(this.GetGame()).CreateEffectStatic(n"loot_highlight", n"container_highlight", this);
    EffectData.SetEntity(effectInstance.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.entity, this);
    EffectData.SetBool(effectInstance.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.renderMaterialOverride, false);
    EffectData.SetBool(effectInstance.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.enable, enable);
    effectInstance.Run();
  }

  public final const func GetDefaultHighlight() -> ref<FocusForcedHighlightData> {
    let highlight: ref<FocusForcedHighlightData>;
    let outline: EFocusOutlineType;
    if this.IsEmpty() || this.IsAnyClueEnabled() {
      return null;
    };
    if this.m_scanningComponent.IsBraindanceBlocked() || this.m_scanningComponent.IsPhotoModeBlocked() {
      return null;
    };
    outline = this.GetCurrentOutline();
    highlight = new FocusForcedHighlightData();
    highlight.sourceID = this.GetEntityID();
    highlight.sourceName = this.GetClassName();
    highlight.priority = EPriority.Low;
    highlight.outlineType = outline;
    if Equals(outline, EFocusOutlineType.QUEST) {
      highlight.highlightType = EFocusForcedHighlightType.QUEST;
    } else {
      if Equals(outline, EFocusOutlineType.ITEM) {
        highlight.highlightType = EFocusForcedHighlightType.ITEM;
      } else {
        highlight = null;
      };
    };
    return highlight;
  }

  public final const func GetCurrentOutline() -> EFocusOutlineType {
    let outlineType: EFocusOutlineType;
    if !this.IsEmpty() {
      if this.IsQuest() {
        outlineType = EFocusOutlineType.QUEST;
      } else {
        outlineType = EFocusOutlineType.ITEM;
      };
    } else {
      outlineType = EFocusOutlineType.INVALID;
    };
    return outlineType;
  }

  protected final func OnItemEntitySpawned(entID: EntityID) -> Void {
    this.SetQualityRangeInteractionLayerState(true);
    this.EvaluateLootQualityEvent(entID);
    this.m_spawnedItemID = this.GetItemObject().GetItemID();
    this.RequestHUDRefresh();
  }

  protected final cb func OnInteractionActivated(evt: ref<InteractionActivationEvent>) -> Bool {
    let actorUpdateData: ref<HUDActorUpdateData>;
    super.OnInteractionActivated(evt);
    if Equals(evt.eventType, gameinteractionsEInteractionEventType.EIET_activate) {
      if evt.activator.IsPlayer() {
        if this.IsQualityRangeInteractionLayer(evt.layerData.tag) {
          this.m_isInIconForcedVisibilityRange = true;
          actorUpdateData = new HUDActorUpdateData();
          actorUpdateData.updateIsInIconForcedVisibilityRange = true;
          actorUpdateData.isInIconForcedVisibilityRangeValue = true;
          this.RequestHUDRefresh(actorUpdateData);
        };
      };
    } else {
      if this.IsQualityRangeInteractionLayer(evt.layerData.tag) && evt.activator.IsPlayer() {
        this.m_isInIconForcedVisibilityRange = false;
        actorUpdateData = new HUDActorUpdateData();
        actorUpdateData.updateIsInIconForcedVisibilityRange = true;
        actorUpdateData.isInIconForcedVisibilityRangeValue = false;
        this.RequestHUDRefresh(actorUpdateData);
      };
    };
  }

  public final const func IsEmpty() -> Bool {
    return !EntityID.IsDefined(this.GetItemEntityID()) && this.m_isEmpty;
  }

  public final const func ShouldRegisterToHUD() -> Bool {
    return true;
  }

  protected final cb func OnHUDInstruction(evt: ref<HUDInstruction>) -> Bool {
    if ItemID.IsValid(this.m_spawnedItemID) {
      this.QueueEventForEntityID(this.GetItemEntityID(), evt);
    };
  }

  protected final cb func OnInventoryEmptyEvent(evt: ref<OnInventoryEmptyEvent>) -> Bool {
    GameObjectEffectHelper.StartEffectEvent(this, n"fx_empty");
    this.m_lootQuality = gamedataQuality.Invalid;
    this.m_isEmpty = true;
    this.m_spawnedItemID = ItemID.None();
    GameObject.UntagObject(this);
    this.RegisterToHUDManagerByTask(false);
    if this.IsQuest() {
      this.ToggleLootHighlight(false);
      this.MarkAsQuest(false);
      this.m_hasQuestItems = false;
      this.ResolveQualityRangeInteractionLayer();
    };
  }

  protected final cb func OnInventoryChangedEvent(evt: ref<InventoryChangedEvent>) -> Bool {
    if this.HasValidLootQuality() {
      if this.EvaluateLootQuality() {
        this.RequestHUDRefresh();
      };
    };
  }

  protected final cb func OnItemRemoveddEvent(evt: ref<ItemBeingRemovedEvent>) -> Bool {
    let evtToSend: ref<ItemLootedEvent>;
    if this.HasValidLootQuality() {
      if this.EvaluateLootQuality() {
        this.RequestHUDRefresh();
      };
    };
    if this.m_spawnedItemID == evt.itemID {
      evtToSend = new ItemLootedEvent();
      this.QueueEventForEntityID(this.GetItemEntityID(), evtToSend);
      this.m_spawnedItemID = ItemID.None();
    };
  }

  protected final cb func OnItemAddedEvent(evt: ref<ItemAddedEvent>) -> Bool {
    this.m_isEmpty = false;
    if this.HasValidLootQuality() {
      this.EvaluateLootQuality();
      if this.EvaluateLootQuality() {
        this.RequestHUDRefresh();
      };
    };
  }

  private final func EvaluateLootQualityEvent(target: EntityID) -> Void {
    let evt: ref<gameEvaluateLootQualityEvent>;
    if EntityID.IsDefined(target) {
      evt = new gameEvaluateLootQualityEvent();
      GameInstance.GetPersistencySystem(this.GetGame()).QueueEntityEvent(target, evt);
    };
  }
}
