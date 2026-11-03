
public class Vendor extends IScriptable {

  public let m_gameInstance: GameInstance;

  public let m_vendorObject: wref<GameObject>;

  private persistent let m_tweakID: TweakDBID;

  private persistent let m_lastInteractionTime: Float;

  private persistent let m_stock: [SItemStack];

  private persistent let m_newItems: [TweakDBID];

  private persistent let m_soldItems: ref<SoldItemsCache>;

  @default(Vendor, 1)
  private persistent let m_priceMultiplier: Float;

  private persistent let m_vendorPersistentID: PersistentID;

  @default(Vendor, false)
  private let m_stockInit: Bool;

  @default(Vendor, false)
  private let m_playerHacksInit: Bool;

  @default(Vendor, false)
  private let m_inventoryInit: Bool;

  private let m_isAttached: Bool;

  @default(Vendor, false)
  private let m_inventoryReinitWithPlayerStats: Bool;

  private let m_vendorRecord: wref<Vendor_Record>;

  private let m_playerHacks: [ItemID];

  private final static func ShouldDiscardQualityForNewCWs() -> Bool {
    return true;
  }

  public final func Initialize(gameInstance: GameInstance, vendorID: TweakDBID, vendorObject: ref<GameObject>) -> Void {
    this.m_gameInstance = gameInstance;
    this.m_tweakID = vendorID;
    this.m_vendorObject = vendorObject;
    this.m_vendorRecord = TweakDBInterface.GetVendorRecord(this.m_tweakID);
    this.InitPlayerHacks();
  }

  public final func OnAttach(owner: wref<GameObject>) -> Void {
    let attachedEvent: ref<UIVendorAttachedEvent>;
    let uiSystem: ref<UISystem>;
    this.m_vendorObject = owner;
    this.m_vendorPersistentID = owner.GetPersistentID();
    this.m_vendorRecord = TweakDBInterface.GetVendorRecord(this.m_tweakID);
    this.m_inventoryInit = false;
    this.m_inventoryReinitWithPlayerStats = false;
    this.m_isAttached = true;
    if this.m_soldItems == null {
      this.m_soldItems = new SoldItemsCache();
    };
    uiSystem = GameInstance.GetUISystem(this.m_gameInstance);
    attachedEvent = new UIVendorAttachedEvent();
    attachedEvent.vendorObject = this.m_vendorObject;
    attachedEvent.vendorID = this.m_tweakID;
    uiSystem.QueueEvent(attachedEvent);
  }

  public final func OnDeattach(owner: wref<GameObject>) -> Void {
    this.m_isAttached = false;
    this.m_inventoryInit = false;
    this.m_inventoryReinitWithPlayerStats = false;
  }

  public final func OnRestored(gameInstance: GameInstance, forceReinit: Bool) -> Void {
    this.m_gameInstance = gameInstance;
    this.m_stockInit = ArraySize(this.m_stock) > 0 && !forceReinit;
    this.m_vendorRecord = TweakDBInterface.GetVendorRecord(this.m_tweakID);
  }

  public final func IsAttached() -> Bool {
    return this.m_isAttached;
  }

  public final func GetStock() -> [SItemStack] {
    this.LazyInitStock();
    return this.m_stock;
  }

  private final func LazyInitStock() -> Void {
    if !this.m_stockInit {
      this.InitializeStock();
    };
  }

  private final func InitPlayerHacks() -> Void {
    if Equals(this.GetVendorType(), gamedataVendorType.Tech) || Equals(this.GetVendorType(), gamedataVendorType.SkillTrainer) {
      this.LoadPlayerHacks();
    };
  }

  public final static func GetMaxItemStacksPerVendor(opt useIncreasedLimit: Bool) -> Int32 {
    if useIncreasedLimit {
      return 1000;
    };
    return 40;
  }

  public final func GetVendorPersistentID() -> PersistentID {
    return this.m_vendorPersistentID;
  }

  public final func GetVendorTweakID() -> TweakDBID {
    return this.m_tweakID;
  }

  public final const func GetVendorType() -> gamedataVendorType {
    if !IsDefined(this.m_vendorRecord) || !IsDefined(this.m_vendorRecord.VendorType()) {
      return gamedataVendorType.Invalid;
    };
    return this.m_vendorRecord.VendorType().Type();
  }

  public final func GetVendorRecord() -> ref<Vendor_Record> {
    return this.m_vendorRecord;
  }

  public final func GetVendorObject() -> wref<GameObject> {
    if !IsDefined(this.m_vendorObject) {
      this.m_vendorObject = GameInstance.FindEntityByID(this.m_gameInstance, PersistentID.ExtractEntityID(this.m_vendorPersistentID)) as GameObject;
    };
    return this.m_vendorObject;
  }

  public final const func GetPriceMultiplier() -> Float {
    return this.m_priceMultiplier;
  }

  public final const func GetLastInteractionTime() -> Float {
    return this.m_lastInteractionTime;
  }

  public final const func GetSoldItems() -> ref<SoldItemsCache> {
    return this.m_soldItems;
  }

  public final func GetItemsForSale(checkPlayerCanBuy: Bool) -> [SItemStack] {
    let availableItems: array<SItemStack>;
    let canBuy: Bool;
    let i: Int32;
    let itemStack: SItemStack;
    let tags: array<CName>;
    let craftingSystem: ref<CraftingSystem> = CraftingSystem.GetInstance(this.m_gameInstance);
    let playerCraftBook: ref<CraftBook> = craftingSystem.GetPlayerCraftBook();
    this.LazyInitStock();
    this.FillVendorInventory(true);
    this.LoadPlayerHacks();
    i = 0;
    while i < ArraySize(this.m_stock) {
      itemStack = this.m_stock[i];
      tags = RPGManager.GetItemRecord(itemStack.itemID).Tags();
      if !ArrayContains(tags, n"Cyberware") && !ArrayContains(tags, n"Recipe") && itemStack.itemID != MarketSystem.Money() {
        canBuy = !checkPlayerCanBuy || this.PlayerCanBuy(itemStack);
        if canBuy {
          ArrayPush(availableItems, itemStack);
        };
      } else {
        if ArrayContains(tags, n"Recipe") && !craftingSystem.IsRecipeKnown(ItemID.GetTDBID(itemStack.itemID), playerCraftBook) {
          canBuy = !checkPlayerCanBuy || this.PlayerCanBuy(itemStack);
          if canBuy {
            ArrayPush(availableItems, itemStack);
          };
        };
      };
      i += 1;
    };
    return availableItems;
  }

  public final func GetMoney() -> Int32 {
    let transactionSystem: ref<TransactionSystem>;
    this.LazyInitStock();
    this.FillVendorInventory(true);
    transactionSystem = GameInstance.GetTransactionSystem(this.m_gameInstance);
    return transactionSystem.GetItemQuantity(this.m_vendorObject, MarketSystem.Money());
  }

  public final func GetCyberwareForSale(checkPlayerCanBuy: Bool) -> [SItemStack] {
    let availableItems: array<SItemStack>;
    let canBuy: Bool;
    let i: Int32;
    let itemRecord: wref<Item_Record>;
    let tags: array<CName>;
    this.LazyInitStock();
    this.FillVendorInventory(true);
    i = 0;
    while i < ArraySize(this.m_stock) {
      itemRecord = RPGManager.GetItemRecord(this.m_stock[i].itemID);
      tags = itemRecord.Tags();
      if ArrayContains(tags, n"Cyberware") && (itemRecord.UsesVariants() || !GameInstance.GetTransactionSystem(this.m_gameInstance).HasItem(GetPlayer(this.m_gameInstance), ItemID.CreateQuery(ItemID.GetTDBID(this.m_stock[i].itemID)))) {
        canBuy = !checkPlayerCanBuy || this.PlayerCanBuy(this.m_stock[i]);
        if canBuy {
          ArrayPush(availableItems, this.m_stock[i]);
        };
      };
      i += 1;
    };
    return availableItems;
  }

  public final func GetAllStockForSale(checkPlayerCanBuy: Bool) -> [SItemStack] {
    let stockForSale: array<SItemStack>;
    let tempStacks: array<SItemStack> = this.GetItemsForSale(checkPlayerCanBuy);
    let i: Int32 = 0;
    while i < ArraySize(tempStacks) {
      ArrayPush(stockForSale, tempStacks[i]);
      i += 1;
    };
    tempStacks = this.GetCyberwareForSale(checkPlayerCanBuy);
    i = 0;
    while i < ArraySize(tempStacks) {
      ArrayPush(stockForSale, tempStacks[i]);
      i += 1;
    };
    return stockForSale;
  }

  public final func GetItemsPlayerCanSell(allowQuestItems: Bool, excludeEquipped: Bool) -> [SItemStack] {
    let availableItems: array<SItemStack>;
    let i: Int32;
    let itemStack: SItemStack;
    let playerItems: array<wref<gameItemData>>;
    GameInstance.GetTransactionSystem(this.m_gameInstance).GetItemList(GetPlayer(this.m_gameInstance), playerItems);
    i = 0;
    while i < ArraySize(playerItems) {
      if this.PlayerCanSell(playerItems[i].GetID(), allowQuestItems, excludeEquipped) {
        itemStack.itemID = playerItems[i].GetID();
        itemStack.quantity = playerItems[i].GetQuantity();
        ArrayPush(availableItems, itemStack);
      };
      i += 1;
    };
    return availableItems;
  }

  public final func OnVendorMenuOpen() -> Void {
    let questsSystem: ref<QuestsSystem>;
    if this.m_lastInteractionTime == 0.00 && Equals(this.GetVendorType(), gamedataVendorType.RipperDoc) {
      questsSystem = GameInstance.GetQuestsSystem(this.m_gameInstance);
      questsSystem.SetFact(n"number_of_ripperdocs_visited", questsSystem.GetFact(n"number_of_ripperdocs_visited") + 1);
    };
    this.LazyInitStock();
    this.FillVendorInventory(true);
    if !this.m_inventoryReinitWithPlayerStats {
      GameInstance.GetTransactionSystem(this.m_gameInstance).ReinitializeStatsOnEntityItems(this.m_vendorObject);
      this.m_inventoryReinitWithPlayerStats = true;
    };
    this.m_lastInteractionTime = GameInstance.GetTimeSystem(this.m_gameInstance).GetGameTimeStamp();
  }

  public final func SetPriceMultiplier(value: Float) -> Void {
    this.m_priceMultiplier = value;
  }

  public final func SetPersistentID(persistentID: PersistentID) -> Void {
    this.m_vendorPersistentID = persistentID;
  }

  public final const func PlayerCanSell(itemID: ItemID, allowQuestItems: Bool, excludeEquipped: Bool) -> Bool {
    let hasInverseTag: Bool;
    let i: Int32;
    let inverseFilterTags: array<CName>;
    let itemData: wref<gameItemData>;
    let player: wref<GameObject>;
    let filterTags: array<CName> = this.m_vendorRecord.CustomerFilterTags();
    if allowQuestItems {
      ArrayRemove(filterTags, n"Quest");
    };
    inverseFilterTags = this.m_vendorRecord.CustomerInverseFilterTags();
    player = GetPlayer(this.m_gameInstance);
    itemData = GameInstance.GetTransactionSystem(this.m_gameInstance).GetItemData(player, itemID);
    if excludeEquipped && EquipmentSystem.GetInstance(player).IsEquipped(player, itemID) {
      return false;
    };
    if ArraySize(inverseFilterTags) > 0 {
      i = 0;
      while i < ArraySize(inverseFilterTags) {
        if itemData.HasTag(inverseFilterTags[i]) {
          hasInverseTag = true;
          break;
        };
        i += 1;
      };
      if !hasInverseTag {
        return false;
      };
    };
    i = 0;
    while i < ArraySize(filterTags) {
      if itemData.HasTag(filterTags[i]) {
        return false;
      };
      i += 1;
    };
    return true;
  }

  private final const func PlayerCanBuy(itemStack: script_ref<SItemStack>) -> Bool {
    let availablePrereq: wref<IPrereq_Record>;
    let filterTags: array<CName>;
    let i: Int32;
    let idToCheck: ItemID;
    let isInInventory: Bool;
    let isInStash: Bool;
    let itemData: wref<gameItemData>;
    let player: ref<GameObject>;
    let playerItems: array<wref<gameItemData>>;
    let tags: array<CName>;
    let tags2: array<CName>;
    let viewPrereqs: array<wref<IPrereq_Record>>;
    let vendorWare: wref<VendorWare_Record> = TweakDBInterface.GetVendorWareRecord(Deref(itemStack).vendorItemID);
    if !IsDefined(vendorWare) {
      return true;
    };
    idToCheck = Deref(itemStack).itemID;
    player = GetPlayer(this.m_gameInstance);
    vendorWare.GenerationPrereqs(viewPrereqs);
    if RPGManager.CheckPrereqs(viewPrereqs, player) {
      filterTags = this.m_vendorRecord.VendorFilterTags();
      itemData = GameInstance.GetTransactionSystem(this.m_gameInstance).GetItemData(this.m_vendorObject, idToCheck);
      availablePrereq = vendorWare.AvailabilityPrereq();
      if IsDefined(availablePrereq) {
        Deref(itemStack).isAvailable = RPGManager.CheckPrereq(availablePrereq, player);
      };
      i = 0;
      while i < ArraySize(filterTags) {
        if IsDefined(itemData) && itemData.HasTag(filterTags[i]) {
          return false;
        };
        i += 1;
      };
      tags = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(idToCheck)).Tags();
      if ArrayContains(tags, n"IconicWeapon") {
        GameInstance.GetTransactionSystem(this.m_gameInstance).GetItemList(player, playerItems);
        i = 0;
        while i < ArraySize(playerItems) {
          tags2 = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(playerItems[i].GetID())).Tags();
          if !ArrayContains(tags2, n"IconicWeapon") {
          } else {
            if playerItems[i].GetID() == idToCheck {
              isInInventory = true;
              break;
            };
            if ItemID.GetTDBID(playerItems[i].GetID()) == ItemID.GetTDBID(itemData.GetID()) {
              isInInventory = true;
              break;
            };
          };
          i += 1;
        };
        isInStash = Stash.IsInStash(player, itemData.GetID());
        if isInInventory || isInStash {
          return false;
        };
      } else {
        if ArrayContains(tags, n"SoftwareShard") {
          i = 0;
          while i < ArraySize(this.m_playerHacks) {
            if ItemID.GetTDBID(this.m_playerHacks[i]) == ItemID.GetTDBID(idToCheck) {
              return false;
            };
            i += 1;
          };
        } else {
          if ArrayContains(tags, n"Grenade") {
            return this.CompareWithPlayerGrenadesQuality(itemStack);
          };
          if ArrayContains(tags, n"Medical") {
            return this.CompareWithPlayerHealingItemsQuality(itemStack);
          };
        };
      };
      return true;
    };
    return false;
  }

  private final const func CompareWithPlayerGrenadesQuality(itemStack: script_ref<SItemStack>) -> Bool {
    let bestGrenadeQuality: Int32;
    let currentGrenadeQuality: Int32;
    let i: Int32;
    let playerItems: array<wref<gameItemData>>;
    let qualityRecord: ref<Quality_Record>;
    let tags: array<CName> = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(Deref(itemStack).itemID)).Tags();
    let player: ref<GameObject> = GetPlayer(this.m_gameInstance);
    let tag: CName = ConsumablesChargesHelper.GetConsumableTag(tags);
    GameInstance.GetTransactionSystem(this.m_gameInstance).GetItemListByTag(player, tag, playerItems);
    i = 0;
    while i < ArraySize(playerItems) {
      qualityRecord = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(playerItems[i].GetID())).Quality();
      currentGrenadeQuality = qualityRecord.Value();
      if currentGrenadeQuality > bestGrenadeQuality {
        bestGrenadeQuality = currentGrenadeQuality;
      };
      i += 1;
    };
    return bestGrenadeQuality < TweakDBInterface.GetItemRecord(ItemID.GetTDBID(Deref(itemStack).itemID)).Quality().Value();
  }

  private final const func CompareWithPlayerHealingItemsQuality(itemStack: script_ref<SItemStack>) -> Bool {
    let bestHealingItemQuality: Int32;
    let currentHealingItemQuality: Int32;
    let i: Int32;
    let playerItems: array<wref<gameItemData>>;
    let qualityRecord: ref<Quality_Record>;
    let tag: CName;
    let tags: array<CName> = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(Deref(itemStack).itemID)).Tags();
    let player: ref<GameObject> = GetPlayer(this.m_gameInstance);
    if ArrayContains(tags, n"Injector") {
      tag = n"Injector";
    } else {
      if ArrayContains(tags, n"Inhaler") {
        tag = n"Inhaler";
      };
    };
    GameInstance.GetTransactionSystem(this.m_gameInstance).GetItemListByTag(player, tag, playerItems);
    i = 0;
    while i < ArraySize(playerItems) {
      qualityRecord = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(playerItems[i].GetID())).Quality();
      currentHealingItemQuality = qualityRecord.Value();
      if currentHealingItemQuality > bestHealingItemQuality {
        bestHealingItemQuality = currentHealingItemQuality;
      };
      i += 1;
    };
    return bestHealingItemQuality < TweakDBInterface.GetItemRecord(ItemID.GetTDBID(Deref(itemStack).itemID)).Quality().Value();
  }

  private final func FillVendorInventory(allowRegeneration: Bool) -> Void {
    let currentMaxTier: Float;
    let exclucedItemTags: array<CName>;
    let forceQuality: CName;
    let i: Int32;
    let itemData: wref<gameItemData>;
    let itemLevel: Float;
    let itemRecord: wref<Item_Record>;
    let maxTierMod: ref<gameStatModifierData>;
    let noPlusModBelowMax: ref<gameStatModifierData>;
    let noPlusModMax: ref<gameStatModifierData>;
    let ownerNPC: ref<NPCPuppet>;
    let playerPowerLevel: Float;
    let powerLevelMod: ref<gameStatModifierData>;
    let prevInvItemList: array<wref<gameItemData>>;
    let purchasedMod: ref<gameStatModifierData>;
    let statsSystem: ref<StatsSystem>;
    let transactionSystem: ref<TransactionSystem>;
    let vendorObject: wref<GameObject> = this.GetVendorObject();
    if allowRegeneration && this.ShouldRegenerateStock() {
      this.RegenerateStock();
    } else {
      if this.m_inventoryInit {
        return;
      };
    };
    ownerNPC = vendorObject as NPCPuppet;
    if IsDefined(ownerNPC) {
      if !ScriptedPuppet.IsActive(ownerNPC) {
        return;
      };
    };
    this.m_inventoryInit = true;
    this.m_inventoryReinitWithPlayerStats = false;
    ArrayPush(exclucedItemTags, n"Prop");
    GameInstance.GetTransactionSystem(this.m_gameInstance).GetItemListExcludingTags(vendorObject, exclucedItemTags, prevInvItemList);
    i = 0;
    while i < ArraySize(prevInvItemList) {
      GameInstance.GetTransactionSystem(this.m_gameInstance).RemoveItem(vendorObject, prevInvItemList[i].GetID(), prevInvItemList[i].GetQuantity());
      i += 1;
    };
    if IsDefined(vendorObject) && IsDefined(this.m_vendorRecord) && IsDefined(this.m_vendorRecord.VendorType()) && NotEquals(this.m_vendorRecord.VendorType().Type(), gamedataVendorType.VendingMachine) {
      transactionSystem = GameInstance.GetTransactionSystem(vendorObject.GetGame());
      statsSystem = GameInstance.GetStatsSystem(vendorObject.GetGame());
      i = 0;
      while i < ArraySize(this.m_stock) {
        itemRecord = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(this.m_stock[i].itemID));
        transactionSystem.GiveItem(vendorObject, this.m_stock[i].itemID, this.m_stock[i].quantity, itemRecord.Tags());
        itemData = transactionSystem.GetItemData(vendorObject, this.m_stock[i].itemID);
        if !itemRecord.IsSingleInstance() && !itemData.HasTag(n"Cyberware") {
          playerPowerLevel = statsSystem.GetStatValue(Cast<StatsObjectID>(GetPlayer(this.m_gameInstance).GetEntityID()), gamedataStatType.PowerLevel);
          if itemData.HasStatData(gamedataStatType.IsItemCrafted) {
            itemLevel = itemData.GetStatValueByType(gamedataStatType.PowerLevel);
          } else {
            if itemData.GetStatValueByType(gamedataStatType.LootLevel) != 0.00 {
              itemLevel = 0.00;
            } else {
              if itemData.HasTag(n"IconicWeapon") {
                itemLevel = GameInstance.GetStatsDataSystem(vendorObject.GetGame()).GetValueFromCurve(n"quality_curves", playerPowerLevel, n"iconic_level_at_vendor_to_player_level");
              } else {
                itemLevel = playerPowerLevel;
              };
            };
          };
          statsSystem.RemoveAllModifiers(itemData.GetStatsObjectID(), gamedataStatType.PowerLevel, true);
          powerLevelMod = RPGManager.CreateStatModifier(gamedataStatType.PowerLevel, gameStatModifierType.Additive, itemLevel);
          statsSystem.AddSavedModifier(itemData.GetStatsObjectID(), powerLevelMod);
          currentMaxTier = statsSystem.GetStatValue(Cast<StatsObjectID>(GetPlayer(this.m_gameInstance).GetEntityID()), gamedataStatType.MaxQuality);
          maxTierMod = RPGManager.CreateStatModifier(gamedataStatType.MaxQualityWhenLooted, gameStatModifierType.Additive, currentMaxTier);
          statsSystem.AddSavedModifier(itemData.GetStatsObjectID(), maxTierMod);
          noPlusModMax = RPGManager.CreateStatModifier(gamedataStatType.RollForPlusOnMaxQuality, gameStatModifierType.Multiplier, 0.00);
          statsSystem.AddSavedModifier(itemData.GetStatsObjectID(), noPlusModMax);
          noPlusModBelowMax = RPGManager.CreateStatModifier(gamedataStatType.RollForPlusBelowMaxQuality, gameStatModifierType.Multiplier, 0.00);
          statsSystem.AddSavedModifier(itemData.GetStatsObjectID(), noPlusModBelowMax);
          purchasedMod = RPGManager.CreateStatModifier(gamedataStatType.ItemPurchasedAtVendor, gameStatModifierType.Additive, 1.00);
          statsSystem.AddSavedModifier(itemData.GetStatsObjectID(), purchasedMod);
          forceQuality = TweakDBInterface.GetCName(this.m_stock[i].vendorItemID + t".forceQuality", n"None");
          if IsNameValid(forceQuality) {
            RPGManager.ForceItemTier(vendorObject, itemData, forceQuality);
          };
        };
        if itemData.HasTag(n"skillbook") {
          purchasedMod = RPGManager.CreateStatModifier(gamedataStatType.ItemPurchasedAtVendor, gameStatModifierType.Additive, 1.00);
          statsSystem.AddSavedModifier(itemData.GetStatsObjectID(), purchasedMod);
        };
        i += 1;
      };
    };
  }

  private final func InitializeStock() -> Void {
    let i: Int32;
    let itemPool: array<wref<VendorItem_Record>>;
    let queryPool: array<wref<VendorItemQuery_Record>>;
    let tweakID: TweakDBID;
    let player: ref<PlayerPuppet> = GetPlayer(this.m_gameInstance);
    this.m_stockInit = true;
    ArrayClear(this.m_stock);
    this.m_vendorRecord.ItemStock(itemPool);
    this.m_vendorRecord.ItemQueries(queryPool);
    i = 0;
    while i < ArraySize(itemPool) {
      this.CreateStacksFromVendorItem(this.m_stock, itemPool[i], player);
      i += 1;
    };
    i = 0;
    while i < ArraySize(queryPool) {
      this.CreateStacksFromVendorItemQuery(this.m_stock, queryPool[i], player);
      i += 1;
    };
    i = 0;
    while i < ArraySize(this.m_stock) {
      tweakID = ItemID.GetTDBID(this.m_stock[i].itemID);
      if !ArrayContains(this.m_newItems, tweakID) {
        ArrayPush(this.m_newItems, tweakID);
      };
      i += 1;
    };
  }

  private final func LoadPlayerHacks() -> Void {
    let i: Int32;
    let playerHacks: array<ItemID>;
    let playerHacksGameData: array<wref<gameItemData>>;
    let player: ref<GameObject> = GetPlayer(this.m_gameInstance);
    GameInstance.GetTransactionSystem(this.m_gameInstance).GetItemListByTag(player, n"SoftwareShard", playerHacksGameData);
    playerHacks = PlayerPuppet.GetPlayerQuickHackInCyberDeck(player as PlayerPuppet);
    i = 0;
    while i < ArraySize(playerHacksGameData) {
      ArrayPush(playerHacks, playerHacksGameData[i].GetID());
      i += 1;
    };
    this.m_playerHacks = playerHacks;
  }

  private final func RegenerateStock() -> Void {
    let availableIndexes: array<Int32>;
    let i: Int32;
    let itemPool: array<wref<VendorItem_Record>>;
    let itemPoolIndex: Int32;
    let itemPoolSize: Int32;
    let itemStacks: array<SItemStack>;
    let j: Int32;
    let newStock: array<SItemStack>;
    let queryPool: array<wref<VendorItemQuery_Record>>;
    let randIndex: Int32;
    let stockLimit: Int32;
    let player: ref<PlayerPuppet> = GetPlayer(this.m_gameInstance);
    this.LazyInitStock();
    this.m_vendorRecord.ItemStock(itemPool);
    this.m_vendorRecord.ItemQueries(queryPool);
    i = 0;
    while i < ArraySize(this.m_stock) {
      if !this.ShouldRegenerateItem(ItemID.GetTDBID(this.m_stock[i].itemID)) {
        ArrayPush(newStock, this.m_stock[i]);
      };
      i += 1;
    };
    stockLimit = 40;
    stockLimit = 1000;
    this.CreateDynamicStockFromPlayerProgression(newStock, GetPlayer(this.m_gameInstance));
    i = ArraySize(itemPool) - 1;
    while i >= 0 {
      if this.AlwaysInStock(itemPool[i].Item().GetID()) {
        this.CreateStacksFromVendorItem(newStock, itemPool[i], player);
        ArrayErase(itemPool, i);
      };
      i -= 1;
    };
    itemPoolSize = ArraySize(itemPool) + ArraySize(queryPool);
    i = 0;
    while i < itemPoolSize {
      ArrayPush(availableIndexes, i);
      i += 1;
    };
    if itemPoolSize > 0 {
      i = 0;
      while i < itemPoolSize && ArraySize(newStock) < stockLimit {
        ArrayClear(itemStacks);
        randIndex = RandRange(0, ArraySize(availableIndexes));
        itemPoolIndex = availableIndexes[randIndex];
        ArrayErase(availableIndexes, randIndex);
        if itemPoolIndex >= ArraySize(itemPool) {
          itemPoolIndex -= ArraySize(itemPool);
          this.CreateStacksFromVendorItemQuery(itemStacks, queryPool[itemPoolIndex], player);
        } else {
          this.CreateStacksFromVendorItem(itemStacks, itemPool[itemPoolIndex], player);
        };
        if ArraySize(itemStacks) > 0 {
          j = 0;
          while j < ArraySize(itemStacks) && ArraySize(newStock) < stockLimit {
            if this.ShouldRegenerateItem(ItemID.GetTDBID(itemStacks[j].itemID)) {
              ArrayPush(newStock, itemStacks[j]);
            };
            j += 1;
          };
        };
        i += 1;
      };
    };
    this.UpdateNewItems(newStock);
    this.m_stock = newStock;
  }

  private final func UpdateNewItems(const newStock: script_ref<[SItemStack]>) -> Void {
    let cyberwareType: CName;
    let itemTweakDBID: TweakDBID;
    let j: Int32;
    let matchFound: Bool;
    let oldCWs: array<CName>;
    let i: Int32 = 0;
    while i < ArraySize(this.m_newItems) {
      matchFound = false;
      j = 0;
      while j < ArraySize(Deref(newStock)) {
        if this.m_newItems[i] == Deref(newStock)[j].itemID {
          matchFound = true;
          break;
        };
        j += 1;
      };
      if matchFound {
        i += 1;
      } else {
        ArrayErase(this.m_newItems, i);
      };
    };
    i = 0;
    while i < ArraySize(this.m_stock) {
      cyberwareType = TweakDBInterface.GetCName(ItemID.GetTDBID(Deref(newStock)[i].itemID) + t".cyberwareType", n"None");
      if NotEquals(cyberwareType, n"None") {
        ArrayPush(oldCWs, cyberwareType);
      };
      i += 1;
    };
    i = 0;
    while i < ArraySize(Deref(newStock)) {
      matchFound = false;
      itemTweakDBID = ItemID.GetTDBID(Deref(newStock)[i].itemID);
      cyberwareType = TweakDBInterface.GetCName(itemTweakDBID + t".cyberwareType", n"None");
      if true && NotEquals(cyberwareType, n"None") {
        j = 0;
        while j < ArraySize(oldCWs) {
          if Equals(oldCWs[j], cyberwareType) {
            matchFound = true;
            break;
          };
          j += 1;
        };
      } else {
        j = 0;
        while j < ArraySize(this.m_stock) {
          if ItemID.GetTDBID(this.m_stock[j].itemID) == itemTweakDBID {
            matchFound = true;
            break;
          };
          j += 1;
        };
      };
      if !matchFound && !ArrayContains(this.m_newItems, itemTweakDBID) {
        ArrayPush(this.m_newItems, itemTweakDBID);
      };
      i += 1;
    };
  }

  private final func CalculateQuantityForStack(vendorWare: ref<VendorWare_Record>, player: ref<PlayerPuppet>) -> Int32 {
    let quantityMods: array<wref<StatModifier_Record>>;
    let quantity: Int32 = 1;
    vendorWare.Quantity(quantityMods);
    if ArraySize(quantityMods) > 0 {
      quantity = RoundF(RPGManager.CalculateStatModifiers(quantityMods, this.m_gameInstance, player, Cast<StatsObjectID>(IsDefined(this.m_vendorObject) ? this.m_vendorObject.GetEntityID() : new EntityID())));
      ArrayClear(quantityMods);
    };
    return quantity;
  }

  private final func InitSingleItemStack(out itemStack: SItemStack, itemRecord: ref<Item_Record>, itemID: ItemID) -> Void {
    let randomPowerLevel: Float;
    if !itemRecord.TagsContains(n"Quest") {
      randomPowerLevel = MathHelper.RandFromNormalDist(GameInstance.GetStatsSystem(this.m_gameInstance).GetStatValue(Cast<StatsObjectID>(GetPlayer(this.m_gameInstance).GetEntityID()), gamedataStatType.PowerLevel), 1.00);
      itemStack.powerLevel = RoundF(randomPowerLevel * 100.00);
    };
    if itemRecord.UsesVariants() {
      itemStack.itemID = ItemID.FromTDBID(itemRecord.GetID());
    } else {
      itemStack.itemID = itemID;
    };
  }

  private final func CreateStacksFromVendorItemQuery(out outputStack: [SItemStack], vendorItemQuery: wref<VendorItemQuery_Record>, player: ref<PlayerPuppet>) -> Void {
    let excludedItems: array<TweakDBID>;
    let i: Int32;
    let itemID: ItemID;
    let itemRecord: ref<Item_Record>;
    let itemStack: SItemStack;
    let j: Int32;
    let quantity: Int32;
    let queryResults: array<ref<Item_Record>>;
    if vendorItemQuery.UniquesOnly() {
      i = 0;
      while i < ArraySize(outputStack) {
        ArrayPush(excludedItems, ItemID.GetTDBID(outputStack[i].itemID));
        i += 1;
      };
    };
    itemStack.vendorItemID = vendorItemQuery.GetID();
    itemStack.requirement = RPGManager.GetVendorWareRequirement(this.m_gameInstance, vendorItemQuery, Cast<StatsObjectID>(itemStack.itemID));
    GameInstance.GetTransactionSystem(this.m_gameInstance).RunItemArrayQuery(queryResults, vendorItemQuery.Query().GetID(), excludedItems, vendorItemQuery.UniquesOnly(), player);
    i = 0;
    while i < ArraySize(queryResults) {
      quantity = this.CalculateQuantityForStack(vendorItemQuery, player);
      if quantity < 1 {
      } else {
        itemRecord = queryResults[i];
        itemID = ItemID.FromTDBID(itemRecord.GetID());
        if !itemRecord.IsSingleInstance() {
          quantity = vendorItemQuery.UniquesOnly() ? 1 : quantity;
          j = 0;
          while j < quantity {
            this.InitSingleItemStack(itemStack, itemRecord, itemID);
            ArrayPush(outputStack, itemStack);
            j += 1;
          };
        } else {
          itemStack.quantity = quantity;
          itemStack.itemID = itemID;
          ArrayPush(outputStack, itemStack);
        };
      };
      i += 1;
    };
  }

  private final func CreateStacksFromVendorItem(out outputStacks: [SItemStack], vendorItem: wref<VendorItem_Record>, player: ref<PlayerPuppet>) -> Void {
    let i: Int32;
    let itemStack: SItemStack;
    let itemRecord: ref<Item_Record> = TweakDBInterface.GetItemRecord(vendorItem.Item().GetID());
    let itemID: ItemID = ItemID.FromTDBID(vendorItem.Item().GetID());
    let quantity: Int32 = this.CalculateQuantityForStack(vendorItem, player);
    if quantity > 0 {
      itemStack.vendorItemID = vendorItem.GetID();
      itemStack.requirement = RPGManager.GetVendorWareRequirement(this.m_gameInstance, vendorItem, Cast<StatsObjectID>(itemStack.itemID));
      if !itemRecord.IsSingleInstance() {
        i = 0;
        while i < quantity {
          this.InitSingleItemStack(itemStack, itemRecord, itemID);
          ArrayPush(outputStacks, itemStack);
          i += 1;
        };
      } else {
        itemStack.quantity = quantity;
        itemStack.itemID = itemID;
        ArrayPush(outputStacks, itemStack);
      };
    };
  }

  private final func CreateDynamicStockFromPlayerProgression(out outputStacks: [SItemStack], player: wref<GameObject>) -> Void {
    let i: Int32;
    let vendorItems: array<wref<VendorItem_Record>>;
    let PDS: ref<PlayerDevelopmentSystem> = PlayerDevelopmentSystem.GetInstance(player);
    let dominatingProficiency: gamedataProficiencyType = PDS.GetDominatingCombatProficiency(player);
    let vendorType: gamedataVendorType = this.GetVendorType();
    let recordID: TweakDBID = TDBID.Create("Vendors." + EnumValueToString("gamedataProficiencyType", Cast<Int64>(EnumInt(dominatingProficiency))) + EnumValueToString("gamedataVendorType", Cast<Int64>(EnumInt(vendorType))));
    if IsDefined(TweakDBInterface.GetVendorProgressionBasedStockRecord(recordID)) {
      TweakDBInterface.GetVendorProgressionBasedStockRecord(recordID).Items(vendorItems);
    };
    i = 0;
    while i < ArraySize(vendorItems) {
      this.CreateStacksFromVendorItem(outputStacks, vendorItems[i], player as PlayerPuppet);
      i += 1;
    };
  }

  protected func ShouldRegenerateStock() -> Bool {
    let currentTime: Float;
    let regenTime: Float = this.m_vendorRecord.InGameTimeToRestock();
    if regenTime <= 0.00 {
      regenTime = 259200.00;
    };
    if this.m_lastInteractionTime != 0.00 {
      currentTime = GameInstance.GetTimeSystem(this.m_gameInstance).GetGameTimeStamp();
      return currentTime - this.m_lastInteractionTime > regenTime;
    };
    return false;
  }

  private final func ShouldRegenerateItem(itemTDBID: TweakDBID) -> Bool {
    let tags: array<CName> = TweakDBInterface.GetItemRecord(itemTDBID).Tags();
    if ArrayContains(tags, n"OnlyOnceInStore") {
      return false;
    };
    return !ArrayContains(tags, n"Quest");
  }

  private final func AlwaysInStock(itemTDBID: TweakDBID) -> Bool {
    let tags: array<CName> = TweakDBInterface.GetItemRecord(itemTDBID).Tags();
    return ArrayContains(tags, n"Currency") || ArrayContains(tags, n"Ammo");
  }

  public final func SellItemToVendor(const itemStack: script_ref<SItemStack>, requestId: Int32) -> Void {
    let itemsStack: array<SItemStack>;
    ArrayPush(itemsStack, Deref(itemStack));
    this.SellItemsToVendor(itemsStack, requestId);
  }

  public final func SellItemsToVendor(const itemsStack: script_ref<[SItemStack]>, requestId: Int32) -> Void {
    let itemData: wref<gameItemData>;
    let itemTransaction: SItemTransaction;
    let moneyStack: SItemStack;
    let uiSystem: ref<UISystem> = GameInstance.GetUISystem(this.m_gameInstance);
    let playerPuppet: ref<PlayerPuppet> = GetPlayer(this.m_gameInstance);
    let itemsSoldEvent: ref<UIVendorItemsSoldEvent> = new UIVendorItemsSoldEvent();
    itemsSoldEvent.requestID = requestId;
    let i: Int32 = 0;
    let limit: Int32 = ArraySize(Deref(itemsStack));
    while i < limit {
      itemTransaction.itemStack = Deref(itemsStack)[i];
      itemData = GameInstance.GetTransactionSystem(this.m_gameInstance).GetItemData(playerPuppet, itemTransaction.itemStack.itemID);
      RPGManager.ReturnRetrievableWeaponMods(itemData, playerPuppet);
      itemTransaction.pricePerItem = RPGManager.CalculateSellPrice(this.m_vendorObject.GetGame(), this.m_vendorObject, itemTransaction.itemStack.itemID);
      if this.PerformItemTransfer(this.m_vendorObject, playerPuppet, itemTransaction) {
        this.AddItemsToStock(itemTransaction.itemStack);
        moneyStack.itemID = MarketSystem.Money();
        moneyStack.quantity = itemTransaction.pricePerItem * itemTransaction.itemStack.quantity;
        this.RemoveItemsFromStock(moneyStack);
        if this.m_soldItems == null {
          this.m_soldItems = new SoldItemsCache();
        };
        this.m_soldItems.AddItem(itemTransaction.itemStack.itemID, Deref(itemsStack)[i].quantity, itemTransaction.pricePerItem);
        ArrayPush(itemsSoldEvent.itemsID, itemTransaction.itemStack.itemID);
        ArrayPush(itemsSoldEvent.quantity, Deref(itemsStack)[i].quantity);
      };
      i += 1;
    };
    uiSystem.QueueEvent(itemsSoldEvent);
  }

  public final func BuyItemFromVendor(const itemStack: script_ref<SItemStack>, requestId: Int32) -> Void {
    let itemsStack: array<SItemStack>;
    ArrayPush(itemsStack, Deref(itemStack));
    this.BuyItemsFromVendor(itemsStack, requestId);
  }

  public final func BuyItemsFromVendor(const itemsStack: script_ref<[SItemStack]>, requestId: Int32) -> Void {
    let itemTransaction: SItemTransaction;
    let moneyStack: SItemStack;
    let uiSystem: ref<UISystem> = GameInstance.GetUISystem(this.m_gameInstance);
    let playerPuppet: ref<PlayerPuppet> = GetPlayer(this.m_gameInstance);
    let itemsBoughtEvent: ref<UIVendorItemsBoughtEvent> = new UIVendorItemsBoughtEvent();
    itemsBoughtEvent.requestID = requestId;
    let i: Int32 = 0;
    let limit: Int32 = ArraySize(Deref(itemsStack));
    while i < limit {
      if !Deref(itemsStack)[i].isAvailable {
      } else {
        itemTransaction.itemStack = Deref(itemsStack)[i];
        itemTransaction.pricePerItem = MarketSystem.GetBuyPrice(this.m_vendorObject, Deref(itemsStack)[i].itemID);
        if this.PerformItemTransfer(playerPuppet, this.m_vendorObject, itemTransaction) {
          this.RemoveItemsFromStock(itemTransaction.itemStack);
          moneyStack.itemID = MarketSystem.Money();
          moneyStack.quantity = itemTransaction.pricePerItem * itemTransaction.itemStack.quantity;
          this.AddItemsToStock(moneyStack);
          this.m_soldItems.RemoveItem(Deref(itemsStack)[i].itemID, Deref(itemsStack)[i].quantity);
          ArrayPush(itemsBoughtEvent.itemsID, Deref(itemsStack)[i].itemID);
          ArrayPush(itemsBoughtEvent.quantity, Deref(itemsStack)[i].quantity);
        };
      };
      i += 1;
    };
    uiSystem.QueueEvent(itemsBoughtEvent);
  }

  public final func BuybackItemFromVendor(const itemStack: script_ref<SItemStack>, requestId: Int32) -> Void {
    let itemsStack: array<SItemStack>;
    ArrayPush(itemsStack, Deref(itemStack));
    this.BuybackItemsFromVendor(itemsStack, requestId);
  }

  public final func BuybackItemsFromVendor(const itemsStack: script_ref<[SItemStack]>, requestId: Int32) -> Void {
    let itemTransaction: SItemTransaction;
    let moneyStack: SItemStack;
    let uiSystem: ref<UISystem> = GameInstance.GetUISystem(this.m_gameInstance);
    let playerPuppet: ref<PlayerPuppet> = GetPlayer(this.m_gameInstance);
    let itemsBoughtEvent: ref<UIVendorItemsBoughtEvent> = new UIVendorItemsBoughtEvent();
    itemsBoughtEvent.requestID = requestId;
    let i: Int32 = 0;
    let limit: Int32 = ArraySize(Deref(itemsStack));
    while i < limit {
      if !Deref(itemsStack)[i].isAvailable {
      } else {
        itemTransaction.itemStack = Deref(itemsStack)[i];
        itemTransaction.pricePerItem = RPGManager.CalculateSellPrice(this.m_vendorObject.GetGame(), this.m_vendorObject, Deref(itemsStack)[i].itemID);
        if this.PerformItemTransfer(playerPuppet, this.m_vendorObject, itemTransaction) {
          this.RemoveItemsFromStock(itemTransaction.itemStack);
          moneyStack.itemID = MarketSystem.Money();
          moneyStack.quantity = itemTransaction.pricePerItem * itemTransaction.itemStack.quantity;
          this.AddItemsToStock(moneyStack);
          this.m_soldItems.RemoveItem(Deref(itemsStack)[i].itemID, Deref(itemsStack)[i].quantity);
          ArrayPush(itemsBoughtEvent.itemsID, Deref(itemsStack)[i].itemID);
          ArrayPush(itemsBoughtEvent.quantity, Deref(itemsStack)[i].quantity);
        };
      };
      i += 1;
    };
    uiSystem.QueueEvent(itemsBoughtEvent);
  }

  public final func DispenseItemFromVendor(position: Vector4, opt itemID: ItemID) -> Void {
    let itemStack: SItemStack;
    this.LazyInitStock();
    if ArraySize(this.m_stock) > 0 {
      if !ItemID.IsValid(itemID) {
        itemID = this.GetRandomStockItem();
      };
      itemStack.itemID = itemID;
      if this.RemoveItemsFromStock(itemStack) {
        GameInstance.GetTransactionSystem(this.m_gameInstance).GiveItem(this.m_vendorObject, itemID, 1);
        GameInstance.GetLootManager(this.m_gameInstance).SpawnItemDrop(this.m_vendorObject, itemID, position);
      };
    };
  }

  public final func DispenseItemStackFromVendor(position: Vector4, itemID: ItemID, amount: Int32, opt bypassStock: Bool) -> Void {
    let dropInstructions: array<DropInstruction>;
    let itemStack: SItemStack;
    if !ItemID.IsValid(itemID) || amount <= 0 {
      return;
    };
    this.LazyInitStock();
    if ArraySize(this.m_stock) > 0 {
      itemStack.itemID = itemID;
      itemStack.quantity = amount;
      if this.RemoveItemsFromStock(itemStack) || bypassStock {
        ArrayPush(dropInstructions, DropInstruction.Create(itemID, amount));
        GameInstance.GetTransactionSystem(this.m_gameInstance).GiveItem(this.m_vendorObject, itemID, amount);
        GameInstance.GetLootManager(this.m_gameInstance).SpawnItemDropOfManyItems(this.m_vendorObject, dropInstructions, position);
      };
    };
  }

  private final func GetRandomStockItem() -> ItemID {
    let i: Int32;
    let j: Int32;
    let weightedList: array<ItemID>;
    this.LazyInitStock();
    i = 0;
    while i < ArraySize(this.m_stock) {
      j = 0;
      while j < this.m_stock[i].quantity {
        ArrayPush(weightedList, this.m_stock[i].itemID);
        j += 1;
      };
      i += 1;
    };
    return weightedList[RandRange(0, ArraySize(weightedList))];
  }

  private final func PerformItemTransfer(buyer: wref<GameObject>, seller: wref<GameObject>, const itemTransaction: script_ref<SItemTransaction>) -> Bool {
    let blackBoard: ref<IBlackboard>;
    let buyerHasEnoughMoney: Bool;
    let buyerMoney: Int32;
    let sellerHasEnoughItems: Bool;
    let sellerItemQuantity: Int32;
    let totalPrice: Int32;
    let transactionSystem: ref<TransactionSystem>;
    let uiSystem: ref<UISystem>;
    let vendorNotification: ref<UIMenuNotificationEvent>;
    this.FillVendorInventory(false);
    this.m_lastInteractionTime = GameInstance.GetTimeSystem(this.m_gameInstance).GetGameTimeStamp();
    blackBoard = GameInstance.GetBlackboardSystem(buyer.GetGame()).Get(GetAllBlackboardDefs().UI_Vendor);
    transactionSystem = GameInstance.GetTransactionSystem(this.m_gameInstance);
    totalPrice = Deref(itemTransaction).pricePerItem * Deref(itemTransaction).itemStack.quantity;
    buyerMoney = transactionSystem.GetItemQuantity(buyer, MarketSystem.Money());
    sellerItemQuantity = transactionSystem.GetItemQuantity(seller, Deref(itemTransaction).itemStack.itemID);
    buyerHasEnoughMoney = buyerMoney >= totalPrice;
    sellerHasEnoughItems = sellerItemQuantity >= Deref(itemTransaction).itemStack.quantity;
    if sellerItemQuantity == 0 {
      return false;
    };
    if !buyerHasEnoughMoney {
      vendorNotification = new UIMenuNotificationEvent();
      if buyer.IsPlayer() {
        vendorNotification.m_notificationType = UIMenuNotificationType.VNotEnoughMoney;
      } else {
        vendorNotification.m_notificationType = UIMenuNotificationType.VendorNotEnoughMoney;
      };
      uiSystem = GameInstance.GetUISystem(this.m_gameInstance);
      uiSystem.QueueEvent(vendorNotification);
      return false;
    };
    GameInstance.GetTelemetrySystem(buyer.GetGame()).LogItemTransaction(buyer, seller, Deref(itemTransaction).itemStack.itemID, Cast<Uint32>(Deref(itemTransaction).pricePerItem), Cast<Uint32>(Deref(itemTransaction).itemStack.quantity), Cast<Uint32>(totalPrice));
    if !sellerHasEnoughItems {
      transactionSystem.GiveItem(seller, Deref(itemTransaction).itemStack.itemID, Deref(itemTransaction).itemStack.quantity - sellerItemQuantity);
    };
    transactionSystem.TransferItem(seller, buyer, Deref(itemTransaction).itemStack.itemID, Deref(itemTransaction).itemStack.quantity, Deref(itemTransaction).itemStack.dynamicTags);
    transactionSystem.TransferItem(buyer, seller, MarketSystem.Money(), totalPrice, true);
    blackBoard.SignalVariant(GetAllBlackboardDefs().UI_Vendor.VendorData);
    return true;
  }

  public final func AddItemsToStock(const itemStack: script_ref<SItemStack>) -> Void {
    let itemIndex: Int32 = this.GetItemIndex(Deref(itemStack).itemID);
    if itemIndex != -1 {
      this.m_stock[itemIndex].quantity += Deref(itemStack).quantity;
    } else {
      ArrayPush(this.m_stock, Deref(itemStack));
    };
  }

  private final func RemoveItemsFromStock(const itemStack: script_ref<SItemStack>) -> Bool {
    let currentQuantity: Int32;
    let newQuantity: Int32;
    let itemIndex: Int32 = this.GetItemIndex(Deref(itemStack).itemID);
    if itemIndex == -1 {
      return false;
    };
    currentQuantity = this.m_stock[itemIndex].quantity;
    newQuantity = currentQuantity - Deref(itemStack).quantity;
    if newQuantity <= 0 {
      ArrayErase(this.m_stock, itemIndex);
    } else {
      this.m_stock[itemIndex].quantity = newQuantity;
    };
    return true;
  }

  private final func GetItemIndex(itemID: ItemID) -> Int32 {
    let i: Int32;
    this.LazyInitStock();
    i = 0;
    while i < ArraySize(this.m_stock) {
      if this.m_stock[i].itemID == itemID {
        return i;
      };
      i += 1;
    };
    return -1;
  }

  public final func RemoveItemIDFromStock(itemID: ItemID) -> Bool {
    let itemIndex: Int32 = this.GetItemIndex(itemID);
    if itemIndex == -1 {
      return false;
    };
    ArrayErase(this.m_stock, itemIndex);
    return true;
  }

  public final func ItemInspected(itemTDBID: TweakDBID) -> Void {
    let i: Int32;
    let cyberwareType: CName = TweakDBInterface.GetCName(itemTDBID + t".cyberwareType", n"None");
    if true && NotEquals(cyberwareType, n"None") {
      i = 0;
      while i < ArraySize(this.m_newItems) {
        if Equals(cyberwareType, TweakDBInterface.GetCName(this.m_newItems[i] + t".cyberwareType", n"None")) {
          ArrayErase(this.m_newItems, i);
        } else {
          i += 1;
        };
      };
    } else {
      ArrayRemove(this.m_newItems, itemTDBID);
    };
  }

  public final func IsNewItem(itemTDBID: TweakDBID) -> Bool {
    return ArrayContains(this.m_newItems, itemTDBID);
  }

  public final func GetNewItems() -> [TweakDBID] {
    return this.m_newItems;
  }

  public final func DoesEquipAreaContainNewItems(area: gamedataEquipmentArea, checkPlayerCanBuy: Bool) -> Bool {
    let areaMatch: Bool;
    let i: Int32;
    let j: Int32;
    let stockForSale: array<SItemStack>;
    if checkPlayerCanBuy {
      stockForSale = this.GetAllStockForSale(true);
    };
    i = 0;
    while i < ArraySize(this.m_newItems) {
      areaMatch = Equals(TweakDBInterface.GetItemRecord(this.m_newItems[i]).EquipArea().Type(), area);
      if checkPlayerCanBuy {
        j = 0;
        while j < ArraySize(stockForSale) {
          if ItemID.GetTDBID(stockForSale[j].itemID) == this.m_newItems[i] && areaMatch {
            return true;
          };
          j += 1;
        };
      } else {
        if areaMatch {
          return true;
        };
      };
      i += 1;
    };
    return false;
  }
}
