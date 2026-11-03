
public class ItemModificationSystem extends ScriptableSystem {

  private let m_blackboard: wref<IBlackboard>;

  private persistent let CYBMETA1695: Bool;

  private func OnAttach() -> Void {
    this.m_blackboard = GameInstance.GetBlackboardSystem(this.GetGameInstance()).Get(GetAllBlackboardDefs().UI_ItemModSystem);
  }

  private func OnRestored(saveVersion: Int32, gameVersion: Int32) -> Void {
    let factVal: Int32 = GetFact(this.GetGameInstance(), n"ClothingModsRemoved");
    if factVal <= 0 && true && saveVersion <= 212 {
      this.RemoveAllModsFromClothing();
      SetFactValue(this.GetGameInstance(), n"ClothingModsRemoved", 1);
    };
    if !this.CYBMETA1695 {
      this.CYBMETA1695();
    };
  }

  private final func InstallItemPart(obj: ref<GameObject>, itemID: ItemID, partItemID: ItemID, opt slotID: TweakDBID) -> Bool {
    let partData: InnerItemData;
    let partInstallRequest: ref<PartInstallRequest>;
    let previousItemType: gamedataItemType;
    let previousPartID: ItemID;
    let result: Bool;
    let ts: ref<TransactionSystem> = GameInstance.GetTransactionSystem(obj.GetGame());
    let itemType: gamedataItemType = RPGManager.GetItemRecord(partItemID).ItemType().Type();
    let itemData: ref<gameItemData> = ts.GetItemData(obj, itemID);
    if !IsDefined(TweakDBInterface.GetAttachmentSlotRecord(slotID)) {
      slotID = EquipmentSystem.GetPlacementSlot(partItemID);
    };
    itemData.GetItemPart(partData, slotID);
    previousPartID = InnerItemData.GetItemID(partData);
    if ItemID.IsValid(previousPartID) {
      this.RemovePartEquipGLPs(obj, previousPartID);
    };
    result = ts.ForcePartInSlot(obj, itemID, partItemID, slotID);
    if Equals(itemType, gamedataItemType.Prt_Program) {
      this.RemoveOtherShards(obj, itemID, partItemID);
    };
    previousItemType = RPGManager.GetItemType(previousPartID);
    if ItemID.IsValid(previousPartID) && (RPGManager.IsWeaponMod(previousPartID) || Equals(previousItemType, gamedataItemType.CyberwareStatsShard) || RPGManager.IsClothingMod(previousPartID)) {
      ts.RemoveItem(obj, previousPartID, 1);
    };
    if result {
      partInstallRequest = new PartInstallRequest();
      partInstallRequest.owner = obj;
      partInstallRequest.itemID = itemID;
      partInstallRequest.partID = partItemID;
      GameInstance.GetScriptableSystemsContainer(this.GetGameInstance()).Get(n"EquipmentSystem").QueueRequest(partInstallRequest);
      GameInstance.GetScriptableSystemsContainer(this.GetGameInstance()).Get(n"UIInventoryScriptableSystem").QueueRequest(partInstallRequest);
    };
    PlayerPuppet.ChacheQuickHackListCleanup(obj as PlayerPuppet);
    return result;
  }

  private final const func RemoveItemPart(obj: ref<GameObject>, itemID: ItemID, slotID: TweakDBID, shouldUpdateEntity: Bool) -> ItemID {
    let emptyItem: ItemID;
    let partData: InnerItemData;
    let partUninstallRequest: ref<PartUninstallRequest>;
    let removedPartID: ItemID;
    let ts: ref<TransactionSystem> = GameInstance.GetTransactionSystem(obj.GetGame());
    let itemData: wref<gameItemData> = ts.GetItemData(obj, itemID);
    if itemData.HasPartInSlot(slotID) {
      itemData.GetItemPart(partData, slotID);
      ts.RemovePart(obj, itemID, slotID, shouldUpdateEntity);
      removedPartID = InnerItemData.GetItemID(partData);
      partUninstallRequest = new PartUninstallRequest();
      partUninstallRequest.owner = obj;
      partUninstallRequest.itemID = itemID;
      partUninstallRequest.partID = removedPartID;
      GameInstance.GetScriptableSystemsContainer(this.GetGameInstance()).Get(n"EquipmentSystem").QueueRequest(partUninstallRequest);
      GameInstance.GetScriptableSystemsContainer(this.GetGameInstance()).Get(n"UIInventoryScriptableSystem").QueueRequest(partUninstallRequest);
      this.SetPingTutorialFact(removedPartID, true, obj);
      PlayerPuppet.ChacheQuickHackListCleanup(obj as PlayerPuppet);
      return removedPartID;
    };
    PlayerPuppet.ChacheQuickHackListCleanup(obj as PlayerPuppet);
    emptyItem = ItemID.None();
    return emptyItem;
  }

  private final func RemoveOtherShards(obj: ref<GameObject>, item: ItemID, shardID: ItemID) -> Void {
    let deckData: ref<gameItemData>;
    let i: Int32;
    let partData: InnerItemData;
    let usedSlots: array<TweakDBID>;
    let ts: ref<TransactionSystem> = GameInstance.GetTransactionSystem(obj.GetGame());
    ts.GetUsedSlotsOnItem(obj, item, usedSlots);
    deckData = ts.GetItemData(obj, item);
    i = 0;
    while i < ArraySize(usedSlots) {
      deckData.GetItemPart(partData, usedSlots[i]);
      if Equals(TweakDBInterface.GetCName(ItemID.GetTDBID(InnerItemData.GetItemID(partData)) + t".shardType", n"None"), TweakDBInterface.GetCName(ItemID.GetTDBID(shardID) + t".shardType", n"None")) && InnerItemData.GetItemID(partData) != shardID {
        this.RemoveItemPart(obj, item, usedSlots[i], false);
      };
      i += 1;
    };
  }

  private final const func SetPingTutorialFact(itemID: ItemID, isUnequip: Bool, obj: ref<GameObject>) -> Void {
    let questSystem: ref<QuestsSystem>;
    let shard: CName = TweakDBInterface.GetCName(ItemID.GetTDBID(itemID) + t".shardType", n"None");
    if Equals(shard, n"Ping") {
      questSystem = GameInstance.GetQuestsSystem(obj.GetGame());
      if isUnequip && questSystem.GetFact(n"ping_installed") == 1 {
        questSystem.SetFact(n"ping_installed", 0);
      } else {
        if questSystem.GetFact(n"ping_installed") == 0 {
          questSystem.SetFact(n"ping_installed", 1);
        };
      };
    };
  }

  private final func RemovePartEquipGLPs(obj: wref<GameObject>, itemID: ItemID) -> Void {
    let glpSys: ref<GameplayLogicPackageSystem>;
    let i: Int32;
    let packages: array<wref<GameplayLogicPackage_Record>>;
    let itemRecord: ref<Item_Record> = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(itemID));
    itemRecord.OnEquip(packages);
    glpSys = GameInstance.GetGameplayLogicPackageSystem(obj.GetGame());
    i = 0;
    while i < ArraySize(packages) {
      glpSys.RemovePackage(obj, packages[i].GetID());
      i += 1;
    };
  }

  private final func SwapItemPart(obj: ref<GameObject>, itemID: ItemID, partItemID: ItemID, slotID: TweakDBID) -> Bool {
    if !ItemModificationSystem.IsBasePart(obj, itemID, slotID) {
      this.RemoveItemPart(obj, itemID, slotID, false);
    } else {
      return false;
    };
    return this.InstallItemPart(obj, itemID, partItemID, slotID);
  }

  public final static func IsBasePart(obj: ref<GameObject>, itemID: ItemID, slotID: TweakDBID) -> Bool {
    let i: Int32;
    let part: InnerItemData;
    let partRecord: ref<Item_Record>;
    let tags: array<CName>;
    let ts: ref<TransactionSystem> = GameInstance.GetTransactionSystem(obj.GetGame());
    let itemData: wref<gameItemData> = ts.GetItemData(obj, itemID);
    itemData.GetItemPart(part, slotID);
    partRecord = InnerItemData.GetStaticData(part);
    tags = partRecord.Tags();
    i = 0;
    while i < ArraySize(tags) {
      if Equals(tags[i], n"parentPart") {
        return true;
      };
      i += 1;
    };
    return false;
  }

  public final static func IsItemSlotTaken(obj: ref<GameObject>, itemID: ItemID, slotID: TweakDBID) -> Bool {
    let ts: ref<TransactionSystem> = GameInstance.GetTransactionSystem(obj.GetGame());
    let itemData: wref<gameItemData> = ts.GetItemData(obj, itemID);
    return itemData.HasPartInSlot(slotID);
  }

  public final static func GetAllSlots(obj: ref<GameObject>, item: ItemID) -> [SPartSlots] {
    let allParts: array<SPartSlots>;
    let emptySlots: array<TweakDBID>;
    let i: Int32;
    let installableItems: array<ItemID>;
    let itemData: ref<gameItemData>;
    let part: SPartSlots;
    let partData: InnerItemData;
    let usedSlots: array<TweakDBID>;
    let ts: ref<TransactionSystem> = GameInstance.GetTransactionSystem(obj.GetGame());
    ts.GetEmptySlotsOnItem(obj, item, emptySlots);
    ts.GetUsedSlotsOnItem(obj, item, usedSlots);
    itemData = ts.GetItemData(obj, item);
    ts.GetItemsInstallableInSlot(obj, item, t"AttachmentSlots.FabricEnhancer2", installableItems);
    i = 0;
    while i < ArraySize(usedSlots) {
      itemData.GetItemPart(partData, usedSlots[i]);
      part.status = ESlotState.Taken;
      part.slotID = usedSlots[i];
      part.installedPart = InnerItemData.GetItemID(partData);
      part.innerItemData = partData;
      ArrayPush(allParts, part);
      i += 1;
    };
    i = 0;
    while i < ArraySize(emptySlots) {
      part.status = ESlotState.Empty;
      part.slotID = emptySlots[i];
      part.installedPart = ItemID.None();
      ArrayPush(allParts, part);
      i += 1;
    };
    return allParts;
  }

  public final static func GetAllSlotsFromItemData(itemData: wref<gameItemData>) -> [SPartSlots] {
    let allParts: array<SPartSlots>;
    let emptySlots: array<TweakDBID>;
    let i: Int32;
    let part: SPartSlots;
    let partData: InnerItemData;
    let usedSlots: array<TweakDBID>;
    itemData.GetEmptySlotsOnItem(emptySlots);
    itemData.GetUsedSlotsOnItem(usedSlots);
    i = 0;
    while i < ArraySize(usedSlots) {
      itemData.GetItemPart(partData, usedSlots[i]);
      part.status = ESlotState.Taken;
      part.slotID = usedSlots[i];
      part.installedPart = InnerItemData.GetItemID(partData);
      part.innerItemData = partData;
      ArrayPush(allParts, part);
      i += 1;
    };
    i = 0;
    while i < ArraySize(emptySlots) {
      itemData.GetItemPart(partData, emptySlots[i]);
      part.status = ESlotState.Empty;
      part.slotID = emptySlots[i];
      part.installedPart = ItemID.None();
      part.innerItemData = partData;
      ArrayPush(allParts, part);
      i += 1;
    };
    return allParts;
  }

  public final static func GetSlotsForCyberdeckFromItemData(itemData: wref<gameItemData>) -> [SPartSlots] {
    let allParts: array<SPartSlots>;
    let emptySlots: array<TweakDBID>;
    let i: Int32;
    let part: SPartSlots;
    let partData: InnerItemData;
    itemData.GetEmptySlotsOnItem(emptySlots);
    i = 0;
    while i < ArraySize(emptySlots) {
      itemData.GetItemPart(partData, emptySlots[i]);
      part.status = ESlotState.Empty;
      part.slotID = emptySlots[i];
      part.installedPart = ItemID.None();
      part.innerItemData = partData;
      ArrayPush(allParts, part);
      i += 1;
    };
    return allParts;
  }

  private final static func GetattachementFromBlueprint(blueprintRecord: wref<ItemBlueprintElement_Record>, out attachments: [wref<AttachmentSlot_Record>]) -> Void {
    let childElements: array<wref<ItemBlueprintElement_Record>>;
    let i: Int32;
    ArrayPush(attachments, blueprintRecord.Slot());
    blueprintRecord.ChildElements(childElements);
    i = 0;
    while i < ArraySize(childElements) {
      ItemModificationSystem.GetattachementFromBlueprint(childElements[i], attachments);
      i += 1;
    };
  }

  public final static func HasThisShardInstalled(obj: ref<GameObject>, cyberdeckID: ItemID, shardID: ItemID) -> Bool {
    let deckData: ref<gameItemData>;
    let i: Int32;
    let partData: InnerItemData;
    let ts: ref<TransactionSystem>;
    let usedSlots: array<TweakDBID>;
    if Equals(TweakDBInterface.GetCName(ItemID.GetTDBID(shardID) + t".shardType", n"None"), n"None") {
      return false;
    };
    ts = GameInstance.GetTransactionSystem(obj.GetGame());
    ts.GetUsedSlotsOnItem(obj, cyberdeckID, usedSlots);
    deckData = ts.GetItemData(obj, cyberdeckID);
    i = 0;
    while i < ArraySize(usedSlots) {
      deckData.GetItemPart(partData, usedSlots[i]);
      if InnerItemData.GetItemID(partData) == shardID {
        return true;
      };
      i += 1;
    };
    return false;
  }

  private final func RemoveAllModsFromClothing() -> Void {
    let currentItem: ItemID;
    let i: Int32;
    let itemList: array<wref<gameItemData>>;
    let j: Int32;
    let transactionSystem: ref<TransactionSystem>;
    let usedSlots: array<TweakDBID>;
    let gi: GameInstance = this.GetGameInstance();
    let player: wref<PlayerPuppet> = GetPlayer(gi);
    if IsDefined(player) {
      transactionSystem = GameInstance.GetTransactionSystem(gi);
      transactionSystem.GetItemList(player, itemList);
      i = 0;
      while i < ArraySize(itemList) {
        currentItem = itemList[i].GetID();
        if RPGManager.IsItemClothing(currentItem) {
          ArrayClear(usedSlots);
          transactionSystem.GetUsedSlotsOnItem(player, currentItem, usedSlots);
          j = 0;
          while j < ArraySize(usedSlots) {
            this.RemoveItemPart(player, currentItem, usedSlots[j], false);
            j += 1;
          };
        };
        i += 1;
      };
    };
  }

  private final func SendCallback() -> Void {
    this.m_blackboard.SetVariant(GetAllBlackboardDefs().UI_ItemModSystem.ItemModSystemUpdated, ToVariant(true), true);
  }

  private final func OnInstallItemPart(request: ref<InstallItemPart>) -> Void {
    if this.InstallItemPart(request.obj, request.baseItem, request.partToInstall, request.slotID) {
      this.SendCallback();
    };
  }

  private final func OnRemoveItemPart(request: ref<RemoveItemPart>) -> Void {
    this.RemoveItemPart(request.obj, request.baseItem, request.slotToEmpty, true);
    this.SendCallback();
  }

  private final func OnSwapItemPart(request: ref<SwapItemPart>) -> Void {
    this.SwapItemPart(request.obj, request.baseItem, request.partToInstall, request.slotID);
    this.SendCallback();
  }

  private final func CYBMETA1695() -> Void {
    let items: array<wref<gameItemData>>;
    let ts: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGameInstance());
    let mainPlayer: ref<GameObject> = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerMainGameObject();
    if !IsDefined(ts) || !IsDefined(mainPlayer) {
      return;
    };
    ts.GetItemList(mainPlayer, items);
    this.RemoveRedundantScopesFromAchillesRifles(items);
    this.CYBMETA1695 = true;
  }

  public final const func RemoveRedundantScopesFromAchillesRifles(items: [wref<gameItemData>]) -> Void {
    let achilleses: array<ItemID>;
    let i: Int32;
    let k: Int32;
    let weaponParts: array<InnerItemData>;
    let scopeTDBID: TweakDBID = t"AttachmentSlots.Scope";
    let mainPlayer: ref<GameObject> = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerMainGameObject();
    if !IsDefined(mainPlayer) {
      return;
    };
    i = 0;
    while i < ArraySize(items) {
      if Equals(items[i].GetName(), n"w_rifle_precision_militech_achilles") {
        items[i].GetItemParts(weaponParts);
        k = 0;
        while k < ArraySize(weaponParts) {
          if InnerItemData.GetSlotID(weaponParts[k]) == scopeTDBID {
            ArrayPush(achilleses, items[i].GetID());
          };
          k += 1;
        };
      };
      i += 1;
    };
    i = 0;
    while i < ArraySize(achilleses) {
      this.RemoveItemPart(mainPlayer, achilleses[i], scopeTDBID, true);
      i += 1;
    };
  }
}
