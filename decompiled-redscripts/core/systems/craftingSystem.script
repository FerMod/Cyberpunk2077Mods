
public struct ItemAttachments {

  public let itemID: ItemID;

  public let attachmentSlotID: TweakDBID;

  public final static func Create(itemID: ItemID, attachmentSlotID: TweakDBID) -> ItemAttachments {
    let itemAttachment: ItemAttachments;
    itemAttachment.itemID = itemID;
    itemAttachment.attachmentSlotID = attachmentSlotID;
    return itemAttachment;
  }
}

public class CraftingSystem extends ScriptableSystem {

  private let m_lastActionStatus: Bool;

  private persistent let m_playerCraftBook: ref<CraftBook>;

  private let m_callback: ref<CraftingSystemInventoryCallback>;

  private let m_inventoryListener: ref<InventoryScriptListener>;

  private let m_itemIconGender: ItemIconGender;

  private func OnAttach() -> Void {
    if !IsDefined(this.m_playerCraftBook) {
      this.m_playerCraftBook = new CraftBook();
    };
  }

  private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(request.owner.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    this.m_itemIconGender = UIGenderHelper.GetIconGender(player);
    this.m_callback = new CraftingSystemInventoryCallback();
    this.m_callback.player = player;
    this.m_inventoryListener = GameInstance.GetTransactionSystem(player.GetGame()).RegisterInventoryListener(player, this.m_callback);
    if IsDefined(this.m_playerCraftBook) {
      this.m_playerCraftBook.InitializeCraftBookOwner(player);
    };
  }

  private final func OnPlayerDetach(request: ref<PlayerDetachRequest>) -> Void {
    let player: ref<PlayerPuppet> = request.owner as PlayerPuppet;
    GameInstance.GetTransactionSystem(player.GetGame()).UnregisterInventoryListener(player, this.m_inventoryListener);
    this.m_inventoryListener = null;
  }

  private func OnRestored(saveVersion: Int32, gameVersion: Int32) -> Void {
    let factVal: Int32;
    let warningMsg: SimpleScreenMessage;
    warningMsg.isShown = true;
    warningMsg.duration = 20.00;
    warningMsg.message = IntToString(saveVersion);
    GameInstance.GetBlackboardSystem(this.GetGameInstance()).Get(GetAllBlackboardDefs().UI_Notifications).SetVariant(GetAllBlackboardDefs().UI_Notifications.WarningMessage, ToVariant(warningMsg), true);
    factVal = GetFact(this.GetGameInstance(), n"IconicItemsRevampCompleted");
    if factVal <= 0 && true {
      this.ProcessIconicRevampRestoration();
      SetFactValue(this.GetGameInstance(), n"IconicItemsRevampCompleted", 1);
    };
    factVal = GetFact(this.GetGameInstance(), n"AmmoRecipesAdded");
    if factVal <= 0 && true {
      this.AddAmmoRecipes();
      SetFactValue(this.GetGameInstance(), n"AmmoRecipesAdded", 1);
    };
    factVal = GetFact(this.GetGameInstance(), n"RecipesCraftedAmountRestored");
    if factVal <= 0 && true {
      this.m_playerCraftBook.ResetRecipeCraftedAmount();
      SetFactValue(this.GetGameInstance(), n"RecipesCraftedAmountRestored", 1);
    };
    factVal = GetFact(this.GetGameInstance(), n"LegendaryLizzieFixed");
    if factVal <= 0 && true {
      if GameInstance.GetTransactionSystem(this.GetGameInstance()).HasItem(this.m_playerCraftBook.GetOwner(), ItemID.CreateQuery(t"Items.Preset_Omaha_Suzie_Epic")) {
        this.m_playerCraftBook.AddRecipe(t"Items.Preset_Omaha_Suzie_Legendary");
        SetFactValue(this.GetGameInstance(), n"LegendaryLizzieFixed", 1);
      };
    };
    factVal = GetFact(this.GetGameInstance(), n"UncommonKnifeAdded");
    if factVal <= 0 && true {
      this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Uncommon_Knife");
      SetFactValue(this.GetGameInstance(), n"UncommonKnifeAdded", 1);
    };
    factVal = GetFact(this.GetGameInstance(), n"CraftedItemsDynamicBonus");
    if factVal <= 0 && true {
      this.ProcessCraftedItemsPowerBoost();
      SetFactValue(this.GetGameInstance(), n"CraftedItemsDynamicBonus", 1);
    };
    factVal = GetFact(this.GetGameInstance(), n"DLCStashItemsRevamp");
    if factVal <= 0 && true && saveVersion <= 212 {
      this.HideDLCRecipes();
      this.AddDLCBaseRecipes();
      SetFactValue(this.GetGameInstance(), n"DLCStashItemsRevamp", 1);
    };
    factVal = GetFact(this.GetGameInstance(), n"ButchersKnifeRemoved");
    if factVal <= 0 && true {
      this.HideButchersKnifeRecipes();
      this.CompensateForOwnedButchersKnifeRecipes();
      SetFactValue(this.GetGameInstance(), n"ButchersKnifeRemoved", 1);
    };
    factVal = GetFact(this.GetGameInstance(), n"BuckGradScopeFix");
    if factVal <= 0 && true {
      SetFactValue(this.GetGameInstance(), n"BuckGradScopeFix", 1);
    };
    factVal = GetFact(this.GetGameInstance(), n"VendorIconicKnivesSecured");
    if factVal <= 0 && true {
      this.VendorIconicKnivesSecured();
      SetFactValue(this.GetGameInstance(), n"VendorIconicKnivesSecured", 1);
    };
    factVal = GetFact(this.GetGameInstance(), n"MilitaryKatanaReworked");
    if factVal <= 0 && true {
      this.HideMilitaryKatanaRecipes();
      this.CompensateForOwnedMilitaryKatanaRecipes();
      SetFactValue(this.GetGameInstance(), n"MilitaryKatanaReworked", 1);
    };
    factVal = GetFact(this.GetGameInstance(), n"PipeWrenchRemoved");
    if factVal <= 0 && true {
      this.HidePipeWrenchRecipes();
      this.CompensateForOwnedPipeWrenchRecipes();
      SetFactValue(this.GetGameInstance(), n"PipeWrenchRemoved", 1);
    };
    factVal = GetFact(this.GetGameInstance(), n"WeaponAndClothingModsAdjusted");
    if factVal <= 0 && true && saveVersion <= 224 {
      this.ProcessWeaponsAndClothingModsPurge();
      SetFactValue(this.GetGameInstance(), n"WeaponAndClothingModsAdjusted", 1);
    };
    factVal = GetFact(this.GetGameInstance(), n"DeprecatedRecipesHidden");
    if factVal <= 0 && true && saveVersion <= 224 {
      this.CompensateForOwnedCraftableIconics();
      this.HideIconicWeaponsRecipes();
      this.HideDeprecatedCraftingRecipes();
      SetFactValue(this.GetGameInstance(), n"DeprecatedRecipesHidden", 1);
    };
    factVal = GetFact(this.GetGameInstance(), n"StartingCraftbookAdjusted");
    if factVal <= 0 && true {
      this.HideDeprecatedCraftbookRecipes();
      this.AddCraftbookRecipes();
      SetFactValue(this.GetGameInstance(), n"StartingCraftbookAdjusted", 1);
    };
    factVal = GetFact(this.GetGameInstance(), n"WeaponModsAdjusted_201");
    if factVal <= 0 && true {
      this.ProcessWeaponsModsCompensate();
      this.InstallModsToRedesignedItems();
      SetFactValue(this.GetGameInstance(), n"WeaponModsAdjusted_201", 1);
    };
    factVal = GetFact(this.GetGameInstance(), n"Craftbook_201_hotfixes");
    if factVal <= 0 && true {
      this.HideDeprecatedCraftingRecipes();
      this.AddCraftbookRecipes();
      SetFactValue(this.GetGameInstance(), n"Craftbook_201_hotfixes", 1);
    };
    factVal = GetFact(this.GetGameInstance(), n"AmmoRecipesRefreshed");
    if factVal <= 0 && true {
      this.AddAmmoRecipes();
      SetFactValue(this.GetGameInstance(), n"AmmoRecipesRefreshed", 1);
    };
    factVal = GetFact(this.GetGameInstance(), n"GritModsPurged");
    if factVal <= 0 && true && saveVersion <= 257 {
      this.ProcessGritModsPurge();
      SetFactValue(this.GetGameInstance(), n"GritModsPurged", 1);
    };
    factVal = GetFact(this.GetGameInstance(), n"AmmoRecipesRefreshed_UE");
    if factVal <= 0 && true {
      this.AddAmmoRecipes();
      SetFactValue(this.GetGameInstance(), n"AmmoRecipesRefreshed_UE", 1);
    };
    factVal = GetFact(this.GetGameInstance(), n"AmazonGritAttachmentsPurged");
    if factVal <= 0 && true && saveVersion <= 261 {
      this.ProcessAmazonGritAttachmentsPurge();
      SetFactValue(this.GetGameInstance(), n"AmazonGritAttachmentsPurged", 1);
    };
    factVal = GetFact(this.GetGameInstance(), n"BuzzsawPsalmRecipesRetrofixed");
    if factVal <= 0 && true && saveVersion <= 261 {
      this.CompensateMissingBuzzsawPsalmRecipes();
      SetFactValue(this.GetGameInstance(), n"BuzzsawPsalmRecipesRetrofixed", 1);
    };
  }

  public final static func GetInstance(gameInstance: GameInstance) -> ref<CraftingSystem> {
    let cs: ref<CraftingSystem> = GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"CraftingSystem") as CraftingSystem;
    return cs;
  }

  public final const func GetPlayerCraftBook() -> ref<CraftBook> {
    return this.m_playerCraftBook;
  }

  public final const func GetPlayerCraftableItems() -> [wref<Item_Record>] {
    return this.m_playerCraftBook.GetCraftableItems();
  }

  public final const func GetItemFinalUpgradeCost(itemData: wref<gameItemData>) -> [IngredientData] {
    let i: Int32;
    let ingredients: array<IngredientData>;
    let tempStat: Float;
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGameInstance());
    let upgradeNumber: Float = itemData.GetStatValueByType(gamedataStatType.WasItemUpgraded);
    upgradeNumber += 1.00;
    ingredients = this.GetItemBaseUpgradeCost(itemData.GetItemType(), RPGManager.GetItemTierForUpgrades(itemData));
    i = 0;
    while i < ArraySize(ingredients) {
      ingredients[i].quantity = ingredients[i].quantity;
      ingredients[i].baseQuantity = ingredients[i].quantity;
      i += 1;
    };
    tempStat = statsSystem.GetStatValue(Cast<StatsObjectID>(this.m_playerCraftBook.GetOwner().GetEntityID()), gamedataStatType.UpgradingCostReduction);
    if tempStat > 0.00 {
      i = 0;
      while i < ArraySize(ingredients) {
        ingredients[i].quantity = Cast<Int32>(Cast<Float>(ingredients[i].quantity) * (1.00 - tempStat));
        i += 1;
      };
    };
    return ingredients;
  }

  public final const func GetItemBaseUpgradeCost(itemType: gamedataItemType, quality: gamedataQuality) -> [IngredientData] {
    let baseIngredients: array<IngredientData>;
    let i: Int32;
    let upgradeData: array<wref<RecipeElement_Record>>;
    let record: ref<UpgradingData_Record> = TweakDBInterface.GetUpgradingDataRecord(t"Upgrading." + TDBID.Create(EnumValueToString("gamedataItemType", Cast<Int64>(EnumInt(itemType)))));
    record.Ingredients(upgradeData);
    i = 0;
    while i < ArraySize(upgradeData) {
      ArrayPush(baseIngredients, this.CreateIngredientData(upgradeData[i]));
      i += 1;
    };
    ArrayClear(upgradeData);
    record = TweakDBInterface.GetUpgradingDataRecord(t"Upgrading." + TDBID.Create(EnumValueToString("gamedataQuality", Cast<Int64>(EnumInt(quality)))));
    record.Ingredients(upgradeData);
    i = 0;
    while i < ArraySize(upgradeData) {
      ArrayPush(baseIngredients, this.CreateIngredientData(upgradeData[i]));
      i += 1;
    };
    return baseIngredients;
  }

  public final const func GetItemCraftingCost(itemData: wref<gameItemData>) -> [IngredientData] {
    let itemRecord: wref<Item_Record> = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(itemData.GetID()));
    let baseIngredients: array<IngredientData> = this.GetItemCraftingCost(itemRecord);
    return baseIngredients;
  }

  public final const func GetItemCraftingCost(itemRecord: wref<Item_Record>) -> [IngredientData] {
    let baseIngredients: array<IngredientData>;
    let craftingData: array<wref<RecipeElement_Record>>;
    let record: wref<CraftingPackage_Record> = itemRecord.CraftingData();
    record.CraftingRecipe(craftingData);
    baseIngredients = this.GetItemCraftingCost(itemRecord, craftingData);
    return baseIngredients;
  }

  public final const func GetItemCraftingCost(record: wref<Item_Record>, const craftingData: script_ref<[wref<RecipeElement_Record>]>) -> [IngredientData] {
    let baseIngredients: array<IngredientData>;
    let expectedQuality: gamedataQuality;
    let modifiedQuantity: Int32;
    let tempStat: Float;
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGameInstance());
    let i: Int32 = 0;
    while i < ArraySize(Deref(craftingData)) {
      ArrayPush(baseIngredients, this.CreateIngredientData(Deref(craftingData)[i]));
      i += 1;
    };
    if Equals(record.Quality().Type(), gamedataQuality.Random) {
      expectedQuality = IntEnum<gamedataQuality>(Cast<Int32>(EnumValueFromName(n"gamedataQuality", RPGManager.SetQualityBasedOnLevel(this.m_playerCraftBook.GetOwner()))));
      if expectedQuality >= gamedataQuality.Uncommon {
        ArrayPush(baseIngredients, this.CreateIngredientData(RPGManager.GetCraftingMaterialRecord(gamedataQuality.Uncommon, false), 75));
      };
      if expectedQuality >= gamedataQuality.Rare {
        ArrayPush(baseIngredients, this.CreateIngredientData(RPGManager.GetCraftingMaterialRecord(gamedataQuality.Rare, false), 55));
      };
      if expectedQuality >= gamedataQuality.Epic {
        ArrayPush(baseIngredients, this.CreateIngredientData(RPGManager.GetCraftingMaterialRecord(gamedataQuality.Epic, false), 35));
      };
      if expectedQuality >= gamedataQuality.Legendary {
        ArrayPush(baseIngredients, this.CreateIngredientData(RPGManager.GetCraftingMaterialRecord(gamedataQuality.Legendary, false), 15));
      };
    };
    tempStat = statsSystem.GetStatValue(Cast<StatsObjectID>(this.m_playerCraftBook.GetOwner().GetEntityID()), gamedataStatType.CraftingCostReduction);
    if tempStat > 0.00 {
      i = 0;
      while i < ArraySize(baseIngredients) {
        if baseIngredients[i].quantity > 1 {
          modifiedQuantity = CeilF(Cast<Float>(baseIngredients[i].quantity) * (1.00 - tempStat));
          baseIngredients[i].quantity = modifiedQuantity;
        };
        i += 1;
      };
    };
    return baseIngredients;
  }

  public final const func CanItemBeDisassembled(owner: wref<GameObject>, itemID: ItemID) -> Bool {
    let itemData: wref<gameItemData> = GameInstance.GetTransactionSystem(this.GetGameInstance()).GetItemData(owner, itemID);
    if RPGManager.IsItemEquipped(owner, itemID) && !itemData.HasTag(n"LongLasting") {
      return false;
    };
    return this.CanItemBeDisassembled(itemData);
  }

  public final const func CanItemBeDisassembled(itemData: wref<gameItemData>) -> Bool {
    if IsDefined(itemData) {
      return !itemData.HasTag(n"IconicWeapon") && !itemData.HasTag(n"Quest") && !itemData.HasTag(n"UnequipBlocked") && IsDefined(ItemActionsHelper.GetDisassembleAction(itemData.GetID()));
    };
    return false;
  }

  public final const func CanItemBeCrafted(itemData: wref<gameItemData>) -> Bool {
    let ammoCap: Int32;
    let currentQuantity: Int32;
    let itemRecord: ref<Item_Record>;
    let itemTweakDBID: TweakDBID;
    let resultQuantity: Int32;
    let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGameInstance());
    let requiredIngredients: array<IngredientData> = this.GetItemCraftingCost(itemData);
    let result: Bool = this.HasIngredients(requiredIngredients);
    if result {
      itemTweakDBID = ItemID.GetTDBID(itemData.GetID());
      itemRecord = TweakDBInterface.GetItemRecord(itemTweakDBID);
      if itemRecord.TagsContains(n"Ammo") {
        ammoCap = Cast<Int32>(itemData.GetStatValueByType(gamedataStatType.Quantity));
        currentQuantity = transactionSystem.GetItemQuantity(this.m_playerCraftBook.GetOwner(), itemData.GetID());
        resultQuantity = (ammoCap - currentQuantity) / CraftingSystem.GetAmmoBulletAmount(itemTweakDBID);
        result = resultQuantity > 0;
      };
    };
    return result;
  }

  public final const func CanItemBeCrafted(itemRecord: wref<Item_Record>) -> Bool {
    let quality: gamedataQuality;
    let result: Bool;
    let requiredIngredients: array<IngredientData> = this.GetItemCraftingCost(itemRecord);
    if Equals(itemRecord.ItemType().Type(), gamedataItemType.Prt_Program) || itemRecord.TagsContains(n"ChimeraMod") {
      result = this.HasIngredients(requiredIngredients);
    } else {
      result = this.HasIngredients(requiredIngredients) && this.CanCraftGivenQuality(itemRecord, quality);
    };
    return result;
  }

  public final const func EnoughIngredientsForCrafting(itemData: wref<gameItemData>) -> Bool {
    let requiredIngredients: array<IngredientData> = this.GetItemCraftingCost(itemData);
    let result: Bool = this.HasIngredients(requiredIngredients);
    return result;
  }

  public final const func GetMaxCraftingAmount(itemData: wref<gameItemData>) -> Int32 {
    let ammoCap: Int32;
    let currentQuantity: Int32;
    let itemRecord: ref<Item_Record>;
    let itemTweakDBID: TweakDBID;
    let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGameInstance());
    let requiredIngredients: array<IngredientData> = this.GetItemCraftingCost(itemData);
    let result: Int32 = 10000000;
    let i: Int32 = 0;
    while i < ArraySize(requiredIngredients) {
      currentQuantity = transactionSystem.GetItemQuantityWithDuplicates(this.m_playerCraftBook.GetOwner(), ItemID.CreateQuery(requiredIngredients[i].id.GetID()));
      if currentQuantity > requiredIngredients[i].quantity {
        result = Min(result, currentQuantity / requiredIngredients[i].quantity);
      } else {
        return 0;
      };
      i += 1;
    };
    itemTweakDBID = ItemID.GetTDBID(itemData.GetID());
    itemRecord = TweakDBInterface.GetItemRecord(itemTweakDBID);
    if itemRecord.TagsContains(n"Ammo") {
      currentQuantity = transactionSystem.GetItemQuantity(this.m_playerCraftBook.GetOwner(), itemData.GetID());
      ammoCap = (Cast<Int32>(itemData.GetStatValueByType(gamedataStatType.Quantity)) - currentQuantity) / CraftingSystem.GetAmmoBulletAmount(itemTweakDBID);
      result = Min(ammoCap, result);
    };
    return Max(result, 0);
  }

  public final const func EnoughIngredientsForUpgrading(itemData: wref<gameItemData>) -> Bool {
    let requiredIngredients: array<IngredientData> = this.GetItemFinalUpgradeCost(itemData);
    let result: Bool = this.HasIngredients(requiredIngredients);
    return result;
  }

  public final const func CanItemBeUpgraded(itemData: wref<gameItemData>) -> Bool {
    let requiredIngredients: array<IngredientData>;
    let result: Bool;
    if RPGManager.IsItemMaxTier(itemData) {
      return false;
    };
    requiredIngredients = this.GetItemFinalUpgradeCost(itemData);
    result = this.HasIngredients(requiredIngredients);
    return result;
  }

  public final const func HasIngredients(const required: script_ref<[IngredientData]>) -> Bool {
    let currentQuantity: Int32;
    let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGameInstance());
    let i: Int32 = 0;
    while i < ArraySize(Deref(required)) {
      currentQuantity = transactionSystem.GetItemQuantityWithDuplicates(this.m_playerCraftBook.GetOwner(), ItemID.CreateQuery(Deref(required)[i].id.GetID()));
      if currentQuantity < Deref(required)[i].quantity {
        return false;
      };
      i += 1;
    };
    return true;
  }

  public final const func CanCraftGivenQuality(itemData: wref<gameItemData>, out quality: gamedataQuality) -> Bool {
    let canCraft: Bool;
    let ss: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGameInstance());
    quality = RPGManager.GetItemQuality(itemData.GetStatValueByType(gamedataStatType.Quality));
    let player: wref<PlayerPuppet> = GetPlayer(this.GetGameInstance());
    let playerLevel: Float = ss.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.Level);
    switch quality {
      case gamedataQuality.Uncommon:
        canCraft = playerLevel >= 1.00;
        break;
      case gamedataQuality.Rare:
        canCraft = playerLevel >= 1.00;
        break;
      case gamedataQuality.Epic:
        canCraft = playerLevel >= 1.00;
        break;
      case gamedataQuality.Legendary:
        canCraft = playerLevel >= 1.00;
        break;
      default:
        canCraft = true;
    };
    return canCraft;
  }

  public final const func CanCraftGivenQuality(itemRecord: wref<Item_Record>, out quality: gamedataQuality) -> Bool {
    let canCraft: Bool;
    let ss: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGameInstance());
    quality = itemRecord.Quality().Type();
    let player: wref<PlayerPuppet> = GetPlayer(this.GetGameInstance());
    let playerLevel: Float = ss.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.Level);
    if Equals(quality, gamedataQuality.Random) {
      quality = UIItemsHelper.QualityNameToEnum(RPGManager.SetQualityBasedOnLevel(GetPlayer(this.GetGameInstance())));
    };
    switch quality {
      case gamedataQuality.Uncommon:
        canCraft = playerLevel >= 1.00;
        break;
      case gamedataQuality.Rare:
        canCraft = playerLevel >= 1.00;
        break;
      case gamedataQuality.Epic:
        canCraft = playerLevel >= 1.00;
        break;
      case gamedataQuality.Legendary:
        canCraft = playerLevel >= 1.00;
        break;
      default:
        canCraft = true;
    };
    return canCraft;
  }

  public final const func IsRecipeKnown(recipe: TweakDBID, playerCraftBook: ref<CraftBook>) -> Bool {
    let recipeRecord: wref<ItemRecipe_Record> = TweakDBInterface.GetItemRecipeRecord(recipe);
    let itemToAdd: wref<CraftingResult_Record> = recipeRecord.CraftingResult();
    if playerCraftBook.GetRecipeIndex(itemToAdd.Item().GetID()) >= 0 {
      return true;
    };
    return false;
  }

  private final func OnCraftItemRequest(request: ref<CraftItemRequest>) -> Void {
    let craftedItem: wref<gameItemData> = this.CraftItem(request.target, request.itemRecord, request.amount, request.bulletAmount);
    this.UpdateBlackboard(CraftingCommands.CraftingFinished, craftedItem.GetID());
    if request.itemRecord.TagsContains(n"Tier6Shard") {
      RPGManager.AwardExperienceInstantly(request.target as PlayerPuppet, 300, gamedataProficiencyType.IntelligenceSkill);
    } else {
      if request.itemRecord.TagsContains(n"Tier4Shard") {
        RPGManager.AwardExperienceInstantly(request.target as PlayerPuppet, 125, gamedataProficiencyType.IntelligenceSkill);
      } else {
        if request.itemRecord.TagsContains(n"Tier3Shard") {
          RPGManager.AwardExperienceInstantly(request.target as PlayerPuppet, 80, gamedataProficiencyType.IntelligenceSkill);
        } else {
          if request.itemRecord.TagsContains(n"Tier2Shard") {
            RPGManager.AwardExperienceInstantly(request.target as PlayerPuppet, 50, gamedataProficiencyType.IntelligenceSkill);
          } else {
            if request.itemRecord.TagsContains(n"Tier1Shard") {
              RPGManager.AwardExperienceInstantly(request.target as PlayerPuppet, 30, gamedataProficiencyType.IntelligenceSkill);
            };
          };
        };
      };
    };
  }

  private final func OnDisassembleItemRequest(request: ref<DisassembleItemRequest>) -> Void {
    if this.CanItemBeDisassembled(GetPlayer(this.GetGameInstance()), request.itemID) {
      this.DisassembleItem(request.target, request.itemID, request.amount);
    };
  }

  private final func OnUpgradeItemRequest(request: ref<UpgradeItemRequest>) -> Void {
    this.UpgradeItem(request.owner, request.itemID);
    this.UpdateBlackboard(CraftingCommands.UpgradingFinished, request.itemID);
  }

  private final func OnAddRecipeRequest(request: ref<AddRecipeRequest>) -> Void {
    this.GetPlayerCraftBook().AddRecipe(request.recipe, request.hideOnItemsAdded, request.amount);
  }

  private final func OnHideRecipeRequest(request: ref<HideRecipeRequest>) -> Void {
    this.GetPlayerCraftBook().HideRecipe(request.recipe, true);
  }

  private final func OnShowRecipeRequest(request: ref<ShowRecipeRequest>) -> Void {
    this.GetPlayerCraftBook().HideRecipe(request.recipe, false);
  }

  public final const func GetLastActionStatus() -> Bool {
    return this.m_lastActionStatus;
  }

  private final func CraftItem(target: wref<GameObject>, itemRecord: ref<Item_Record>, amount: Int32, opt ammoBulletAmount: Int32) -> wref<gameItemData> {
    let craftedItemID: ItemID;
    let i: Int32;
    let ingredient: ItemID;
    let ingredientQuality: gamedataQuality;
    let ingredientRecords: array<wref<RecipeElement_Record>>;
    let isAmmo: Bool;
    let itemData: wref<gameItemData>;
    let j: Int32;
    let recipeXP: Int32;
    let requiredIngredients: array<IngredientData>;
    let savedAmount: Int32;
    let savedAmountLocked: Bool;
    let tempStat: Float;
    let xpID: TweakDBID;
    let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGameInstance());
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGameInstance());
    let randF: Float = RandF();
    itemRecord.CraftingData().CraftingRecipe(ingredientRecords);
    requiredIngredients = this.GetItemCraftingCost(itemRecord);
    isAmmo = itemRecord.TagsContains(n"Ammo");
    i = 0;
    while i < ArraySize(requiredIngredients) {
      ingredient = ItemID.CreateQuery(requiredIngredients[i].id.GetID());
      if RPGManager.IsItemWeapon(ingredient) || RPGManager.IsItemClothing(ingredient) || RPGManager.IsItemMisc(ingredient) {
        itemData = transactionSystem.GetItemData(target, ingredient);
        if IsDefined(itemData) && itemData.HasTag(n"Quest") {
          itemData.RemoveDynamicTag(n"Quest");
        };
        this.ClearNonIconicSlots(itemData);
        break;
      };
      i += 1;
    };
    tempStat = statsSystem.GetStatValue(Cast<StatsObjectID>(target.GetEntityID()), gamedataStatType.CraftingMaterialRetrieveChance);
    savedAmount = 0;
    i = 0;
    while i < ArraySize(requiredIngredients) {
      ingredient = ItemID.CreateQuery(requiredIngredients[i].id.GetID());
      if RPGManager.IsItemWeapon(ingredient) || RPGManager.IsItemClothing(ingredient) || RPGManager.IsItemProgram(ingredient) || RPGManager.IsItemGadget(ingredient) {
        randF = 100.00;
      } else {
        if tempStat > 0.00 && !savedAmountLocked {
          j = 0;
          while j < amount {
            if RandF() < tempStat {
              savedAmount += 1;
            };
            j += 1;
          };
          savedAmountLocked = true;
        };
      };
      transactionSystem.RemoveItemByTDBID(target, ItemID.GetTDBID(ingredient), requiredIngredients[i].quantity * (amount - savedAmount), true);
      if randF >= tempStat && (RPGManager.IsItemWeapon(ingredient) || RPGManager.IsItemClothing(ingredient) || RPGManager.IsItemProgram(ingredient)) {
        transactionSystem.RemoveItemByTDBID(target, ItemID.GetTDBID(ingredient), requiredIngredients[i].quantity * amount, true);
      };
      ingredientQuality = RPGManager.GetItemQualityFromRecord(TweakDBInterface.GetItemRecord(requiredIngredients[i].id.GetID()));
      switch ingredientQuality {
        case gamedataQuality.Common:
          xpID = t"Constants.CraftingSystem.commonIngredientXP";
          break;
        case gamedataQuality.Uncommon:
          xpID = t"Constants.CraftingSystem.uncommonIngredientXP";
          break;
        case gamedataQuality.Rare:
          xpID = t"Constants.CraftingSystem.rareIngredientXP";
          break;
        case gamedataQuality.Epic:
          xpID = t"Constants.CraftingSystem.epicIngredientXP";
          break;
        case gamedataQuality.Legendary:
          xpID = t"Constants.CraftingSystem.legendaryIngredientXP";
          break;
        default:
      };
      recipeXP += TweakDBInterface.GetInt(xpID, 0) * requiredIngredients[i].baseQuantity * amount;
      i += 1;
    };
    craftedItemID = ItemID.FromTDBID(itemRecord.GetID());
    transactionSystem.GiveItem(target, craftedItemID, isAmmo ? amount * ammoBulletAmount : amount);
    if Equals(itemRecord.ItemType().Type(), gamedataItemType.Gad_Grenade) || Equals(itemRecord.ItemType().Type(), gamedataItemType.Con_Inhaler) || Equals(itemRecord.ItemType().Type(), gamedataItemType.Con_Injector) || itemRecord.TagsContains(n"CraftableIconic") && !itemRecord.TagsContains(n"Haunted_Gun") {
      this.ProcessProgramCrafting(itemRecord.GetID());
    };
    itemData = transactionSystem.GetItemData(target, craftedItemID);
    this.SetItemLevel(itemData);
    this.MarkItemAsCrafted(itemData);
    this.SendItemCraftedDataTrackingRequest(craftedItemID, amount);
    this.ProcessCraftSkill(Cast<Float>(recipeXP));
    return itemData;
  }

  private final func MarkItemAsCrafted(itemData: wref<gameItemData>) -> Void {
    let statMod: ref<gameStatModifierData> = RPGManager.CreateStatModifier(gamedataStatType.IsItemCrafted, gameStatModifierType.Additive, 1.00);
    GameInstance.GetStatsSystem(this.GetGameInstance()).AddSavedModifier(itemData.GetStatsObjectID(), statMod);
  }

  private final func ClearNonIconicSlots(itemData: wref<gameItemData>) -> Void {
    let i: Int32;
    let partData: InnerItemData;
    let slots: array<TweakDBID>;
    let staticData: wref<Item_Record>;
    let TS: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGameInstance());
    let player: wref<PlayerPuppet> = this.m_playerCraftBook.GetOwner() as PlayerPuppet;
    ArrayClear(slots);
    slots = RPGManager.GetModsSlotIDs(itemData.GetItemType());
    i = 0;
    while i < ArraySize(slots) {
      itemData.GetItemPart(partData, slots[i]);
      staticData = InnerItemData.GetStaticData(partData);
      if IsDefined(staticData) && staticData.TagsContains(n"DummyPart") {
      } else {
        TS.RemovePart(player, itemData.GetID(), slots[i]);
      };
      i += 1;
    };
    ArrayClear(slots);
    slots = RPGManager.GetAttachmentSlotIDs();
    i = 0;
    while i < ArraySize(slots) {
      TS.RemovePart(player, itemData.GetID(), slots[i]);
      i += 1;
    };
  }

  private final func ClearNonIconicSlotsFromWeaponsAndClothes(itemData: wref<gameItemData>) -> Void {
    let i: Int32;
    let slots: array<TweakDBID>;
    let TS: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGameInstance());
    let player: wref<PlayerPuppet> = GetMainPlayer(this.GetGameInstance());
    ArrayClear(slots);
    slots = RPGManager.GetModsSlotIDs(itemData.GetItemType());
    i = 0;
    while i < ArraySize(slots) {
      TS.RemovePart(player, itemData.GetID(), slots[i]);
      i += 1;
    };
    ArrayClear(slots);
    slots = RPGManager.GetAttachmentSlotIDs();
    i = 0;
    while i < ArraySize(slots) {
      TS.RemovePart(player, itemData.GetID(), slots[i]);
      i += 1;
    };
  }

  private final func CompensateForDeprecatedWeaponMods(itemData: wref<gameItemData>) -> Void {
    let statSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGameInstance());
    let TS: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGameInstance());
    let player: wref<PlayerPuppet> = GetMainPlayer(this.GetGameInstance());
    let playerLevel: Float = statSystem.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.PowerLevel);
    if playerLevel < 17.00 {
      TS.GiveItemByItemQuery(player, t"Query.CommonWeaponModsQuery");
    } else {
      if playerLevel < 33.00 {
        TS.GiveItemByItemQuery(player, t"Query.UncommonWeaponModsQuery");
      } else {
        TS.GiveItemByItemQuery(player, t"Query.RareWeaponModsQuery");
      };
    };
  }

  private final func ClearNonIconicSlotsWithoutDummyMods(itemData: wref<gameItemData>) -> Void {
    let i: Int32;
    let partData: InnerItemData;
    let slots: array<TweakDBID>;
    let staticData: wref<Item_Record>;
    let TS: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGameInstance());
    let player: wref<PlayerPuppet> = GetMainPlayer(this.GetGameInstance());
    ArrayClear(slots);
    slots = RPGManager.GetModsSlotIDs(itemData.GetItemType());
    i = 0;
    while i < ArraySize(slots) {
      itemData.GetItemPart(partData, slots[i]);
      staticData = InnerItemData.GetStaticData(partData);
      if IsDefined(staticData) && staticData.TagsContains(n"DummyPart") {
      } else {
        TS.RemovePart(player, itemData.GetID(), slots[i]);
      };
      i += 1;
    };
    ArrayClear(slots);
    slots = RPGManager.GetAttachmentSlotIDs();
    i = 0;
    while i < ArraySize(slots) {
      itemData.GetItemPart(partData, slots[i]);
      staticData = InnerItemData.GetStaticData(partData);
      if IsDefined(staticData) && staticData.TagsContains(n"DummyPart") {
      } else {
        TS.RemovePart(player, itemData.GetID(), slots[i]);
      };
      i += 1;
    };
  }

  public final static func MarkItemAsCrafted(target: wref<GameObject>, itemData: wref<gameItemData>) -> Void {
    let statMod: ref<gameStatModifierData>;
    if Equals(itemData.HasStatData(gamedataStatType.IsItemCrafted), false) {
      statMod = RPGManager.CreateStatModifier(gamedataStatType.IsItemCrafted, gameStatModifierType.Additive, 1.00);
      GameInstance.GetStatsSystem(target.GetGame()).AddSavedModifier(itemData.GetStatsObjectID(), statMod);
    };
  }

  private final func SetItemLevel(itemData: wref<gameItemData>) -> Void {
    let craftingLevelBoost: Float;
    let modifier: ref<gameConstantStatModifierData>;
    let playerPLValue: Float;
    let statMod: ref<gameStatModifierData>;
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGameInstance());
    if Equals(ItemID.GetStructure(itemData.GetID()), gamedataItemStructure.Unique) {
      if !RPGManager.IsItemSingleInstance(itemData) {
        playerPLValue = statsSystem.GetStatValue(Cast<StatsObjectID>(this.m_playerCraftBook.GetOwner().GetEntityID()), gamedataStatType.PowerLevel);
        craftingLevelBoost = this.CalculateCraftingLevelBoost();
        statsSystem.RemoveAllModifiers(itemData.GetStatsObjectID(), gamedataStatType.PowerLevel, true);
        modifier = new gameConstantStatModifierData();
        modifier.modifierType = gameStatModifierType.Additive;
        modifier.statType = gamedataStatType.PowerLevel;
        modifier.value = playerPLValue;
        statsSystem.AddSavedModifier(itemData.GetStatsObjectID(), modifier);
        statsSystem.RemoveAllModifiers(itemData.GetStatsObjectID(), gamedataStatType.ItemLevel, true);
        modifier = new gameConstantStatModifierData();
        modifier.modifierType = gameStatModifierType.Additive;
        modifier.statType = gamedataStatType.ItemLevel;
        modifier.value = playerPLValue * 10.00 - craftingLevelBoost;
        statsSystem.AddSavedModifier(itemData.GetStatsObjectID(), modifier);
        statMod = RPGManager.CreateCombinedStatModifier(gamedataStatType.ItemLevel, gameStatModifierType.Additive, gamedataStatType.WasItemUpgraded, gameCombinedStatOperation.Multiplication, 10.00, gameStatObjectsRelation.Self);
        statsSystem.AddSavedModifier(itemData.GetStatsObjectID(), statMod);
      };
    };
  }

  private final func SetItemQualityBasedOnPlayerSkill(itemData: wref<gameItemData>) -> Void {
    let modifier: ref<gameConstantStatModifierData>;
    let quality: CName;
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGameInstance());
    if Equals(RPGManager.GetItemRecord(itemData.GetID()).Quality().Type(), gamedataQuality.Random) {
      statsSystem.RemoveAllModifiers(itemData.GetStatsObjectID(), gamedataStatType.Quality, true);
      modifier = new gameConstantStatModifierData();
      modifier.modifierType = gameStatModifierType.Additive;
      modifier.statType = gamedataStatType.Quality;
      quality = RPGManager.SetQualityBasedOnLevel(this.m_playerCraftBook.GetOwner());
      modifier.value = RPGManager.ItemQualityNameToValue(quality);
      statsSystem.AddSavedModifier(itemData.GetStatsObjectID(), modifier);
    };
  }

  public final static func SetItemLevel(target: wref<GameObject>, itemData: wref<gameItemData>) -> Void {
    let craftingLevelBoost: Float;
    let modifier: ref<gameConstantStatModifierData>;
    let playerPLValue: Float;
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(target.GetGame());
    if Equals(ItemID.GetStructure(itemData.GetID()), gamedataItemStructure.Unique) {
      if !RPGManager.IsItemSingleInstance(itemData) {
        playerPLValue = statsSystem.GetStatValue(Cast<StatsObjectID>(target.GetEntityID()), gamedataStatType.PowerLevel);
        craftingLevelBoost = statsSystem.GetStatValue(Cast<StatsObjectID>(target.GetEntityID()), gamedataStatType.CraftingItemLevelBoost);
        statsSystem.RemoveAllModifiers(itemData.GetStatsObjectID(), gamedataStatType.PowerLevel, true);
        modifier = new gameConstantStatModifierData();
        modifier.modifierType = gameStatModifierType.Additive;
        modifier.statType = gamedataStatType.PowerLevel;
        modifier.value = playerPLValue;
        statsSystem.AddSavedModifier(itemData.GetStatsObjectID(), modifier);
        statsSystem.RemoveAllModifiers(itemData.GetStatsObjectID(), gamedataStatType.ItemLevel, true);
        modifier = new gameConstantStatModifierData();
        modifier.modifierType = gameStatModifierType.Additive;
        modifier.statType = gamedataStatType.ItemLevel;
        modifier.value = playerPLValue * 10.00 - 5.00 - craftingLevelBoost;
        statsSystem.AddSavedModifier(itemData.GetStatsObjectID(), modifier);
      };
    };
  }

  private final func CalculateCraftingLevelBoost() -> Float {
    let reductionValue: Float = GameInstance.GetStatsSystem(this.GetGameInstance()).GetStatValue(Cast<StatsObjectID>(this.m_playerCraftBook.GetOwner().GetEntityID()), gamedataStatType.CraftingItemLevelBoost);
    reductionValue = 5.00 - reductionValue;
    return reductionValue;
  }

  private final func ProcessProgramCrafting(itemTDBID: TweakDBID) -> Void {
    this.GetPlayerCraftBook().HideRecipe(itemTDBID, true);
  }

  public final const func GetDisassemblyResultItems(target: wref<GameObject>, itemID: ItemID, amount: Int32, restoredAttachments: script_ref<[ItemAttachments]>, opt calledFromUI: Bool) -> [IngredientData] {
    let i: Int32;
    let ingredients: array<wref<RecipeElement_Record>>;
    let isSlaughtomatic: Bool;
    let itemBroken: Bool;
    let itemData: wref<gameItemData>;
    let itemPlus: Float;
    let itemQual: gamedataQuality;
    let newIngrData: IngredientData;
    let outResult: array<IngredientData>;
    let itemType: gamedataItemType = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(itemID)).ItemType().Type();
    let itemCategory: gamedataItemCategory = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(itemID)).ItemCategory().Type();
    let dissResult: wref<DisassemblingResult_Record> = TweakDBInterface.GetDisassemblingResultRecord(t"Crafting." + TDBID.Create(EnumValueToString("gamedataItemType", Cast<Int64>(EnumInt(itemType)))));
    if !IsDefined(dissResult) {
      dissResult = TweakDBInterface.GetDisassemblingResultRecord(t"Crafting.DisassemblingResult_Default");
    };
    dissResult.Ingredients(ingredients);
    itemData = GameInstance.GetTransactionSystem(this.GetGameInstance()).GetItemData(target, itemID);
    itemQual = RPGManager.GetItemQuality(itemData);
    itemBroken = RPGManager.IsItemBroken(itemData);
    itemPlus = RPGManager.GetItemPlus(itemData);
    isSlaughtomatic = itemData.HasTag(n"Slaughtomatic");
    if amount > 0 {
      i = 0;
      while i < ArraySize(ingredients) {
        newIngrData = this.CreateIngredientData(ingredients[i]);
        this.AddIngredientToResult(newIngrData, amount, outResult);
        i += 1;
      };
      itemQual = RPGManager.GetItemQuality(itemData);
      if Equals(itemCategory, gamedataItemCategory.Weapon) && !itemBroken && itemPlus == 0.00 && !isSlaughtomatic {
        if Equals(itemQual, gamedataQuality.Common) {
          newIngrData = this.CreateIngredientData(RPGManager.GetCraftingMaterialRecord(gamedataQuality.Common), 5);
          this.AddIngredientToResult(newIngrData, amount, outResult);
        };
        if Equals(itemQual, gamedataQuality.Uncommon) {
          newIngrData = this.CreateIngredientData(RPGManager.GetCraftingMaterialRecord(gamedataQuality.Uncommon), 5);
          this.AddIngredientToResult(newIngrData, amount, outResult);
        };
        if Equals(itemQual, gamedataQuality.Rare) {
          newIngrData = this.CreateIngredientData(RPGManager.GetCraftingMaterialRecord(gamedataQuality.Rare), 5);
          this.AddIngredientToResult(newIngrData, amount, outResult);
        };
        if Equals(itemQual, gamedataQuality.Epic) {
          newIngrData = this.CreateIngredientData(RPGManager.GetCraftingMaterialRecord(gamedataQuality.Epic), 5);
          this.AddIngredientToResult(newIngrData, amount, outResult);
        };
        if Equals(itemQual, gamedataQuality.Legendary) {
          newIngrData = this.CreateIngredientData(RPGManager.GetCraftingMaterialRecord(gamedataQuality.Legendary), 5);
          this.AddIngredientToResult(newIngrData, amount, outResult);
        };
      };
      if NotEquals(itemType, gamedataItemType.Prt_Program) && !itemBroken && itemPlus == 1.00 && !isSlaughtomatic {
        if Equals(itemQual, gamedataQuality.Common) {
          newIngrData = this.CreateIngredientData(RPGManager.GetCraftingMaterialRecord(gamedataQuality.Common), 7);
          this.AddIngredientToResult(newIngrData, amount, outResult);
        };
        if Equals(itemQual, gamedataQuality.Uncommon) {
          newIngrData = this.CreateIngredientData(RPGManager.GetCraftingMaterialRecord(gamedataQuality.Uncommon), 7);
          this.AddIngredientToResult(newIngrData, amount, outResult);
        };
        if Equals(itemQual, gamedataQuality.Rare) {
          newIngrData = this.CreateIngredientData(RPGManager.GetCraftingMaterialRecord(gamedataQuality.Rare), 7);
          this.AddIngredientToResult(newIngrData, amount, outResult);
        };
        if Equals(itemQual, gamedataQuality.Epic) {
          newIngrData = this.CreateIngredientData(RPGManager.GetCraftingMaterialRecord(gamedataQuality.Epic), 7);
          this.AddIngredientToResult(newIngrData, amount, outResult);
        };
        if Equals(itemQual, gamedataQuality.Legendary) {
          newIngrData = this.CreateIngredientData(RPGManager.GetCraftingMaterialRecord(gamedataQuality.Legendary), 7);
          this.AddIngredientToResult(newIngrData, amount, outResult);
        };
      };
      if NotEquals(itemType, gamedataItemType.Prt_Program) && !itemBroken && itemPlus == 2.00 && !isSlaughtomatic {
        if Equals(itemQual, gamedataQuality.Legendary) {
          newIngrData = this.CreateIngredientData(RPGManager.GetCraftingMaterialRecord(gamedataQuality.Legendary), 15);
          this.AddIngredientToResult(newIngrData, amount, outResult);
        };
      };
      if itemBroken || isSlaughtomatic {
        if Equals(itemQual, gamedataQuality.Common) {
          newIngrData = this.CreateIngredientData(RPGManager.GetCraftingMaterialRecord(gamedataQuality.Common), 1);
          this.AddIngredientToResult(newIngrData, amount, outResult);
        };
      };
      if NotEquals(itemCategory, gamedataItemCategory.Weapon) && NotEquals(itemType, gamedataItemType.Prt_Program) {
        if Equals(itemQual, gamedataQuality.Common) {
          newIngrData = this.CreateIngredientData(RPGManager.GetCraftingMaterialRecord(gamedataQuality.Common), 1);
          this.AddIngredientToResult(newIngrData, amount, outResult);
        };
        if Equals(itemQual, gamedataQuality.Uncommon) {
          newIngrData = this.CreateIngredientData(RPGManager.GetCraftingMaterialRecord(gamedataQuality.Uncommon), 1);
          this.AddIngredientToResult(newIngrData, amount, outResult);
        };
        if Equals(itemQual, gamedataQuality.Rare) {
          newIngrData = this.CreateIngredientData(RPGManager.GetCraftingMaterialRecord(gamedataQuality.Rare), 1);
          this.AddIngredientToResult(newIngrData, amount, outResult);
        };
        if Equals(itemQual, gamedataQuality.Epic) {
          newIngrData = this.CreateIngredientData(RPGManager.GetCraftingMaterialRecord(gamedataQuality.Epic), 1);
          this.AddIngredientToResult(newIngrData, amount, outResult);
        };
        if Equals(itemQual, gamedataQuality.Legendary) {
          newIngrData = this.CreateIngredientData(RPGManager.GetCraftingMaterialRecord(gamedataQuality.Legendary), 1);
          this.AddIngredientToResult(newIngrData, amount, outResult);
        };
      };
      if Equals(itemType, gamedataItemType.Prt_Program) && itemPlus == 0.00 {
        if Equals(itemQual, gamedataQuality.Common) {
          newIngrData = this.CreateIngredientData(RPGManager.GetCraftingMaterialRecord(gamedataQuality.Uncommon, true), 1);
          this.AddIngredientToResult(newIngrData, amount, outResult);
        };
        if Equals(itemQual, gamedataQuality.Uncommon) {
          newIngrData = this.CreateIngredientData(RPGManager.GetCraftingMaterialRecord(gamedataQuality.Uncommon, true), 7);
          this.AddIngredientToResult(newIngrData, amount, outResult);
        };
        if Equals(itemQual, gamedataQuality.Rare) {
          newIngrData = this.CreateIngredientData(RPGManager.GetCraftingMaterialRecord(gamedataQuality.Rare, true), 6);
          this.AddIngredientToResult(newIngrData, amount, outResult);
        };
        if Equals(itemQual, gamedataQuality.Epic) {
          newIngrData = this.CreateIngredientData(RPGManager.GetCraftingMaterialRecord(gamedataQuality.Epic, true), 5);
          this.AddIngredientToResult(newIngrData, amount, outResult);
        };
        if Equals(itemQual, gamedataQuality.Legendary) {
          newIngrData = this.CreateIngredientData(RPGManager.GetCraftingMaterialRecord(gamedataQuality.Legendary, true), 3);
          this.AddIngredientToResult(newIngrData, amount, outResult);
        };
      };
      if Equals(itemType, gamedataItemType.Prt_Program) && itemPlus == 2.00 {
        if Equals(itemQual, gamedataQuality.Legendary) {
          newIngrData = this.CreateIngredientData(RPGManager.GetCraftingMaterialRecord(gamedataQuality.Legendary, true), 20);
          this.AddIngredientToResult(newIngrData, amount, outResult);
        };
      };
      this.ProcessDisassemblingPerks(amount, outResult, itemData, restoredAttachments, calledFromUI);
    };
    return outResult;
  }

  private final const func AddIngredientToResult(ingredient: IngredientData, amountMultiplier: Int32, out outputResult: [IngredientData]) -> Void {
    let i: Int32;
    let quantityIncreased: Bool;
    ingredient.quantity *= amountMultiplier;
    i = 0;
    while i < ArraySize(outputResult) {
      if outputResult[i].id == ingredient.id {
        outputResult[i].quantity += ingredient.quantity;
        quantityIncreased = true;
        break;
      };
      i += 1;
    };
    if !quantityIncreased {
      ArrayPush(outputResult, ingredient);
    };
  }

  private final const func DisassembleItem(target: wref<GameObject>, itemID: ItemID, amount: Int32) -> Void {
    let restoredAttachments: array<ItemAttachments>;
    let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGameInstance());
    let listOfIngredients: array<IngredientData> = this.GetDisassemblyResultItems(target, itemID, amount, restoredAttachments);
    let i: Int32 = 0;
    while i < ArraySize(restoredAttachments) {
      transactionSystem.RemovePart(this.m_playerCraftBook.GetOwner(), itemID, restoredAttachments[i].attachmentSlotID);
      i += 1;
    };
    GameInstance.GetTelemetrySystem(this.GetGameInstance()).LogItemDisassembled(target, itemID);
    transactionSystem.RemoveItem(target, itemID, amount);
    i = 0;
    while i < ArraySize(listOfIngredients) {
      transactionSystem.GiveItem(target, ItemID.FromTDBID(listOfIngredients[i].id.GetID()), listOfIngredients[i].quantity);
      i += 1;
    };
    this.UpdateBlackboard(CraftingCommands.DisassemblingFinished, itemID, listOfIngredients);
  }

  private final func UpgradeItem(owner: wref<GameObject>, itemID: ItemID) -> Void {
    let ingredientQuality: gamedataQuality;
    let mod: ref<gameStatModifierData>;
    let recipeXP: Int32;
    let xpID: TweakDBID;
    let randF: Float = RandF();
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGameInstance());
    let TS: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGameInstance());
    let itemData: wref<gameItemData> = TS.GetItemData(owner, itemID);
    let oldVal: Float = itemData.GetStatValueByType(gamedataStatType.WasItemUpgraded);
    let newVal: Float = oldVal + 1.00;
    let tempStat: Float = statsSystem.GetStatValue(Cast<StatsObjectID>(owner.GetEntityID()), gamedataStatType.UpgradingMaterialRetrieveChance);
    let ingredients: array<IngredientData> = this.GetItemFinalUpgradeCost(itemData);
    let i: Int32 = 0;
    while i < ArraySize(ingredients) {
      if randF >= tempStat {
        TS.RemoveItemByTDBID(owner, ingredients[i].id.GetID(), ingredients[i].quantity, true);
      };
      ingredientQuality = RPGManager.GetItemQualityFromRecord(TweakDBInterface.GetItemRecord(ingredients[i].id.GetID()));
      switch ingredientQuality {
        case gamedataQuality.Common:
          xpID = t"Constants.CraftingSystem.commonIngredientXP";
          break;
        case gamedataQuality.Uncommon:
          xpID = t"Constants.CraftingSystem.uncommonIngredientXP";
          break;
        case gamedataQuality.Rare:
          xpID = t"Constants.CraftingSystem.rareIngredientXP";
          break;
        case gamedataQuality.Epic:
          xpID = t"Constants.CraftingSystem.epicIngredientXP";
          break;
        case gamedataQuality.Legendary:
          xpID = t"Constants.CraftingSystem.legendaryIngredientXP";
          break;
        default:
      };
      recipeXP += TweakDBInterface.GetInt(xpID, 0) * ingredients[i].quantity;
      i += 1;
    };
    statsSystem.RemoveAllModifiers(itemData.GetStatsObjectID(), gamedataStatType.WasItemUpgraded, true);
    mod = RPGManager.CreateStatModifier(gamedataStatType.WasItemUpgraded, gameStatModifierType.Additive, newVal);
    statsSystem.AddSavedModifier(itemData.GetStatsObjectID(), mod);
    this.ProcessCraftSkill(Cast<Float>(recipeXP));
  }

  private final func ProcessUpgradingPerksData(target: wref<GameObject>, itemRecord: ref<Item_Record>) -> Void {
    let randI: Int32;
    let recipe: array<wref<RecipeElement_Record>>;
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGameInstance());
    let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGameInstance());
    let randF: Float = RandF();
    let tempStat: Float = statsSystem.GetStatValue(Cast<StatsObjectID>(target.GetEntityID()), gamedataStatType.UpgradingMaterialRandomGrantChance);
    if randF <= tempStat {
      randI = RandRange(0, ArraySize(recipe) - 1);
      transactionSystem.GiveItemByTDBID(target, recipe[randI].Ingredient().GetID(), 1);
    };
  }

  private final const func CreateIngredientDataOfQuality(amount: Int32, matQuality: gamedataQuality, out disassembleResult: [IngredientData]) -> Void {
    let ingredientData: IngredientData;
    let rand: Float = RandF();
    let num: Int32 = Cast<Int32>(rand * Cast<Float>(amount));
    if num > 0 {
      ingredientData = this.CreateIngredientData(RPGManager.GetCraftingMaterialRecord(matQuality), 1);
      this.AddIngredientToResult(ingredientData, num, disassembleResult);
    };
    if amount - num > 0 {
      ingredientData = this.CreateIngredientData(RPGManager.GetCraftingMaterialRecord(matQuality, true), 1);
      this.AddIngredientToResult(ingredientData, amount - num, disassembleResult);
    };
  }

  private final const func GetSuccessNum(probability: Float, eventsNum: Int32) -> Int32 {
    let i: Int32;
    let num: Int32;
    let rand: Float;
    i;
    while i < eventsNum {
      rand = RandF();
      if rand < probability {
        num += 1;
      };
      i += 1;
    };
    return num;
  }

  private final const func ProcessDisassemblingPerks(amount: Int32, out disassembleResult: [IngredientData], itemData: wref<gameItemData>, restoredAttachments: script_ref<[ItemAttachments]>, opt calledFromUI: Bool) -> Void {
    let i: Int32;
    let innerPart: InnerItemData;
    let innerPartID: ItemID;
    let itemCategory: gamedataItemCategory;
    let matQuality: gamedataQuality;
    let partTags: array<CName>;
    let slotsToCheck: array<TweakDBID>;
    let succNum: Int32;
    let tempArr: array<TweakDBID>;
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGameInstance());
    let tempStat: Float = statsSystem.GetStatValue(Cast<StatsObjectID>(this.m_playerCraftBook.GetOwner().GetEntityID()), gamedataStatType.DisassemblingIngredientsDoubleBonus);
    if tempStat > 0.00 {
      i = 0;
      while i < ArraySize(disassembleResult) {
        disassembleResult[i].quantity = Cast<Int32>(Cast<Float>(disassembleResult[i].quantity) * 1.50);
        i += 1;
      };
    };
    if !calledFromUI {
      tempStat = statsSystem.GetStatValue(Cast<StatsObjectID>(this.m_playerCraftBook.GetOwner().GetEntityID()), gamedataStatType.DisassemblingMaterialQualityObtainChance);
      matQuality = RPGManager.GetItemDataQuality(itemData);
      if NotEquals(matQuality, gamedataQuality.Invalid) {
        succNum = this.GetSuccessNum(tempStat, amount);
        if succNum > 0 {
          this.CreateIngredientDataOfQuality(succNum, matQuality, disassembleResult);
        };
        if matQuality <= gamedataQuality.Epic {
          matQuality = RPGManager.GetBumpedQuality(matQuality);
          succNum = this.GetSuccessNum(tempStat / 4.00, amount);
          if succNum > 0 {
            this.CreateIngredientDataOfQuality(succNum, matQuality, disassembleResult);
          };
        };
      };
    };
    itemCategory = RPGManager.GetItemCategory(itemData.GetID());
    if Equals(itemCategory, gamedataItemCategory.Weapon) {
      slotsToCheck = RPGManager.GetAttachmentSlotIDs();
      tempArr = RPGManager.GetModsSlotIDs(itemData.GetItemType());
      i = 0;
      while i < ArraySize(tempArr) {
        ArrayPush(slotsToCheck, tempArr[i]);
        i += 1;
      };
      i = 0;
      while i < ArraySize(slotsToCheck) {
        itemData.GetItemPart(innerPart, slotsToCheck[i]);
        innerPartID = InnerItemData.GetItemID(innerPart);
        partTags = InnerItemData.GetStaticData(innerPart).Tags();
        if ItemID.IsValid(innerPartID) && ArrayContains(partTags, n"Retrievable") {
          ArrayPush(Deref(restoredAttachments), ItemAttachments.Create(innerPartID, slotsToCheck[i]));
        };
        i += 1;
      };
    };
  }

  private final func ProcessCraftSkill(xpAmount: Float) -> Void {
    RPGManager.AwardXP(this.GetGameInstance(), xpAmount, gamedataProficiencyType.TechnicalAbilitySkill);
  }

  public final const func GetRecipeData(itemRecord: ref<Item_Record>) -> ref<RecipeData> {
    let i: Int32;
    let listOfIngredients: array<IngredientData>;
    let tempListOfIngredients: array<wref<RecipeElement_Record>>;
    let tempRecipeData: ItemRecipe = this.m_playerCraftBook.GetRecipeData(itemRecord.GetID());
    let tempItemCategory: ref<ItemCategory_Record> = itemRecord.ItemCategory();
    let newRecipeData: ref<RecipeData> = new RecipeData();
    newRecipeData.label = GetLocalizedItemNameByCName(itemRecord.DisplayName());
    newRecipeData.icon = itemRecord.IconPath();
    newRecipeData.iconGender = this.m_itemIconGender;
    newRecipeData.description = GetLocalizedItemNameByCName(itemRecord.LocalizedDescription());
    newRecipeData.type = LocKeyToString(tempItemCategory.LocalizedCategory());
    newRecipeData.id = itemRecord;
    newRecipeData.amount = tempRecipeData.amount;
    newRecipeData.quality = itemRecord.Quality().Type();
    itemRecord.CraftingData().CraftingRecipe(tempListOfIngredients);
    i = 0;
    while i < ArraySize(tempListOfIngredients) {
      ArrayPush(listOfIngredients, this.CreateIngredientData(tempListOfIngredients[i]));
      i += 1;
    };
    newRecipeData.ingredients = listOfIngredients;
    return newRecipeData;
  }

  public final const func GetUpgradeRecipeData(itemID: ItemID) -> ref<RecipeData> {
    let itemdata: wref<gameItemData> = GameInstance.GetTransactionSystem(this.GetGameInstance()).GetItemData(GetPlayer(this.GetGameInstance()), itemID);
    let itemRecord: ref<Item_Record> = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(itemID));
    let tempItemCategory: ref<ItemCategory_Record> = itemRecord.ItemCategory();
    let newRecipeData: ref<RecipeData> = new RecipeData();
    newRecipeData.label = GetLocalizedItemNameByCName(itemRecord.DisplayName());
    newRecipeData.icon = itemRecord.IconPath();
    newRecipeData.iconGender = this.m_itemIconGender;
    newRecipeData.description = GetLocalizedItemNameByCName(itemRecord.LocalizedDescription());
    newRecipeData.type = LocKeyToString(tempItemCategory.LocalizedCategory());
    newRecipeData.id = itemRecord;
    newRecipeData.ingredients = this.GetItemFinalUpgradeCost(itemdata);
    return newRecipeData;
  }

  private final const func GetIngredientQuality(const data: script_ref<IngredientData>) -> gamedataQuality {
    let quality: gamedataQuality = RPGManager.GetItemQualityFromRecord(Deref(data).id);
    return quality;
  }

  private final const func CreateIngredientData(ingredientData: ref<RecipeElement_Record>) -> IngredientData {
    let newIngredientData: IngredientData;
    let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGameInstance());
    let itemRecord: wref<Item_Record> = ingredientData.Ingredient();
    newIngredientData.quantity = ingredientData.Amount();
    newIngredientData.baseQuantity = ingredientData.Amount();
    newIngredientData.label = itemRecord.FriendlyName();
    newIngredientData.inventoryQuantity = transactionSystem.GetItemQuantityWithDuplicates(this.m_playerCraftBook.GetOwner(), ItemID.CreateQuery(itemRecord.GetID()));
    newIngredientData.id = itemRecord;
    newIngredientData.icon = itemRecord.IconPath();
    newIngredientData.iconGender = this.m_itemIconGender;
    return newIngredientData;
  }

  private final const func CreateIngredientData(item: ref<Item_Record>, amount: Int32) -> IngredientData {
    let newIngredientData: IngredientData;
    let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGameInstance());
    newIngredientData.quantity = amount;
    newIngredientData.baseQuantity = amount;
    newIngredientData.label = item.FriendlyName();
    newIngredientData.inventoryQuantity = transactionSystem.GetItemQuantityWithDuplicates(this.m_playerCraftBook.GetOwner(), ItemID.CreateQuery(item.GetID()));
    newIngredientData.id = item;
    newIngredientData.icon = item.IconPath();
    newIngredientData.iconGender = this.m_itemIconGender;
    return newIngredientData;
  }

  private final const func UpdateBlackboard(lastCommand: CraftingCommands, opt lastItem: ItemID, opt lastIngredients: [IngredientData]) -> Void {
    let Blackboard: ref<IBlackboard> = GameInstance.GetBlackboardSystem(this.GetGameInstance()).Get(GetAllBlackboardDefs().UI_Crafting);
    if IsDefined(Blackboard) {
      Blackboard.SetVariant(GetAllBlackboardDefs().UI_Crafting.lastCommand, ToVariant(lastCommand), true);
      Blackboard.SetVariant(GetAllBlackboardDefs().UI_Crafting.lastItem, ToVariant(lastItem), true);
      if ArraySize(lastIngredients) > 0 {
        Blackboard.SetVariant(GetAllBlackboardDefs().UI_Crafting.lastIngredients, ToVariant(lastIngredients));
      };
    };
  }

  private final func SendItemCraftedDataTrackingRequest(targetItem: ItemID, amount: Int32) -> Void {
    let request: ref<ItemCraftedDataTrackingRequest> = new ItemCraftedDataTrackingRequest();
    request.targetItem = targetItem;
    request.amount = amount;
    let dataTrackingSystem: ref<DataTrackingSystem> = GameInstance.GetScriptableSystemsContainer(this.GetGameInstance()).Get(n"DataTrackingSystem") as DataTrackingSystem;
    dataTrackingSystem.QueueRequest(request);
  }

  private final func ProcessIconicRevampRestoration() -> Void {
    let TS: ref<TransactionSystem>;
    let i: Int32;
    let itemList: array<wref<gameItemData>>;
    let player: wref<PlayerPuppet> = GetPlayer(this.GetGameInstance());
    if IsDefined(player) {
      TS = GameInstance.GetTransactionSystem(this.GetGameInstance());
      TS.GetItemList(player, itemList);
    };
    i = 0;
    while i < ArraySize(itemList) {
      if RPGManager.IsItemIconic(itemList[i]) && RPGManager.IsItemWeapon(itemList[i].GetID()) {
        this.ClearNonIconicSlots(itemList[i]);
        RPGManager.ProcessOnLootedPackages(player, itemList[i].GetID());
      };
      i += 1;
    };
  }

  private final func ProcessWeaponsAndClothingModsPurge() -> Void {
    let TS: ref<TransactionSystem>;
    let i: Int32;
    let itemList: array<wref<gameItemData>>;
    let player: wref<PlayerPuppet> = GetMainPlayer(this.GetGameInstance());
    if IsDefined(player) {
      TS = GameInstance.GetTransactionSystem(this.GetGameInstance());
      TS.GetItemList(player, itemList);
    };
    i = 0;
    while i < ArraySize(itemList) {
      if RPGManager.IsItemWeapon(itemList[i].GetID()) || RPGManager.IsItemClothing(itemList[i].GetID()) {
        this.ClearNonIconicSlotsFromWeaponsAndClothes(itemList[i]);
      };
      i += 1;
    };
  }

  private final func ProcessWeaponsModsCompensate() -> Void {
    let TS: ref<TransactionSystem>;
    let i: Int32;
    let itemList: array<wref<gameItemData>>;
    let player: wref<PlayerPuppet> = GetMainPlayer(this.GetGameInstance());
    if IsDefined(player) {
      TS = GameInstance.GetTransactionSystem(this.GetGameInstance());
      TS.GetItemList(player, itemList);
    };
    i = 0;
    while i < ArraySize(itemList) {
      if itemList[i].HasTag(n"DeprecatedWeaponMod") && !itemList[i].HasTag(n"DummyWeaponMod") {
        this.CompensateForDeprecatedWeaponMods(itemList[i]);
      };
      i += 1;
    };
  }

  private final func ProcessGritModsPurge() -> Void {
    let TS: ref<TransactionSystem>;
    let i: Int32;
    let itemList: array<wref<gameItemData>>;
    let player: wref<PlayerPuppet> = GetPlayer(this.GetGameInstance());
    if IsDefined(player) {
      TS = GameInstance.GetTransactionSystem(this.GetGameInstance());
      TS.GetItemList(player, itemList);
    };
    i = 0;
    while i < ArraySize(itemList) {
      if itemList[i].HasTag(n"Grit") {
        this.ClearNonIconicSlotsWithoutDummyMods(itemList[i]);
      };
      i += 1;
    };
  }

  private final func ProcessAmazonGritAttachmentsPurge() -> Void {
    let TS: ref<TransactionSystem>;
    let i: Int32;
    let itemList: array<wref<gameItemData>>;
    let player: wref<PlayerPuppet> = GetPlayer(this.GetGameInstance());
    if IsDefined(player) {
      TS = GameInstance.GetTransactionSystem(this.GetGameInstance());
      TS.GetItemList(player, itemList);
    };
    i = 0;
    while i < ArraySize(itemList) {
      if itemList[i].HasTag(n"Grit") && itemList[i].HasTag(n"IconicWeapon") {
        this.ClearNonIconicSlotsWithoutDummyMods(itemList[i]);
      };
      i += 1;
    };
  }

  private final func VendorIconicKnivesSecured() -> Void {
    let TS: ref<TransactionSystem>;
    let i: Int32;
    let itemList: array<wref<gameItemData>>;
    let player: wref<PlayerPuppet> = GetPlayer(this.GetGameInstance());
    if IsDefined(player) {
      TS = GameInstance.GetTransactionSystem(this.GetGameInstance());
      TS.GetItemList(player, itemList);
    };
    i = 0;
    while i < ArraySize(itemList) {
      if itemList[i].HasTag(n"VendorIconicItem") {
        RPGManager.ProcessOnLootedPackages(player, itemList[i].GetID());
      };
      i += 1;
    };
  }

  private final func ProcessCraftedItemsPowerBoost() -> Void {
    let i: Int32;
    let itemList: array<wref<gameItemData>>;
    let statsSystem: ref<StatsSystem>;
    let transactionSystem: ref<TransactionSystem>;
    let player: wref<PlayerPuppet> = GetPlayer(this.GetGameInstance());
    if IsDefined(player) {
      transactionSystem = GameInstance.GetTransactionSystem(this.GetGameInstance());
      statsSystem = GameInstance.GetStatsSystem(this.GetGameInstance());
      transactionSystem.GetItemList(player, itemList);
    };
    i = 0;
    while i < ArraySize(itemList) {
      if RPGManager.IsItemCrafted(itemList[i]) {
        if RPGManager.IsItemWeapon(itemList[i].GetID()) {
          statsSystem.RemoveSavedModifiers(itemList[i].GetStatsObjectID(), gamedataStatType.CraftingBonusWeaponDamage);
          statsSystem.RemoveSavedModifiers(itemList[i].GetStatsObjectID(), gamedataStatType.CanLegendaryCraftedWeaponsBeBoosted);
        } else {
          if RPGManager.IsItemClothing(itemList[i].GetID()) {
            statsSystem.RemoveSavedModifiers(itemList[i].GetStatsObjectID(), gamedataStatType.CraftingBonusArmorValue);
          };
        };
      };
      i += 1;
    };
  }

  private final func AddAmmoRecipes() -> Void {
    this.m_playerCraftBook.AddRecipe(t"Ammo.HandgunAmmo", CraftingSystem.GetAmmoBulletAmount(t"Ammo.HandgunAmmo"));
    this.m_playerCraftBook.AddRecipe(t"Ammo.ShotgunAmmo", CraftingSystem.GetAmmoBulletAmount(t"Ammo.ShotgunAmmo"));
    this.m_playerCraftBook.AddRecipe(t"Ammo.RifleAmmo", CraftingSystem.GetAmmoBulletAmount(t"Ammo.RifleAmmo"));
    this.m_playerCraftBook.AddRecipe(t"Ammo.SniperRifleAmmo", CraftingSystem.GetAmmoBulletAmount(t"Ammo.SniperRifleAmmo"));
  }

  private final func HideDLCRecipes() -> Void {
    this.m_playerCraftBook.HideRecipe(t"Items.Jacket_19_basic_04", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Jacket_19_basic_04_DLC_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Jacket_19_basic_04_DLC_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Jacket_20_basic_01", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Jacket_20_basic_01_DLC_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Jacket_20_basic_01_DLC_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.GOG_DLC_TShirt_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.GOG_DLC_TShirt_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.GOG_DLC_Jacket_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.GOG_DLC_Jacket_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.GOG_Galaxy_TShirt_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.GOG_Galaxy_TShirt_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Katana_GoG_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Katana_GoG_Legendary", true);
  }

  private final func AddDLCBaseRecipes() -> Void {
    if this.m_playerCraftBook.KnowsRecipe(t"Items.Preset_Katana_GoG_Epic") {
      this.m_playerCraftBook.AddRecipe(t"Items.Preset_Katana_GoG_Crafted");
    };
    if this.m_playerCraftBook.KnowsRecipe(t"Items.GOG_DLC_TShirt_Epic") {
      this.m_playerCraftBook.AddRecipe(t"Items.GOG_DLC_TShirt_Crafted");
    };
    if this.m_playerCraftBook.KnowsRecipe(t"Items.GOG_DLC_Jacket_Epic") {
      this.m_playerCraftBook.AddRecipe(t"Items.GOG_DLC_Jacket_Crafted");
    };
    if this.m_playerCraftBook.KnowsRecipe(t"Items.GOG_Galaxy_TShirt_Epic") {
      this.m_playerCraftBook.AddRecipe(t"Items.GOG_Galaxy_TShirt_Crafted");
    };
    if this.m_playerCraftBook.KnowsRecipe(t"Items.Jacket_19_basic_04") {
      this.m_playerCraftBook.AddRecipe(t"Items.Jacket_19_basic_04_Crafted");
    };
    if this.m_playerCraftBook.KnowsRecipe(t"Items.Jacket_20_basic_01") {
      this.m_playerCraftBook.AddRecipe(t"Items.Jacket_20_basic_01_Crafted");
    };
  }

  private final func InstallModsToRedesignedItems() -> Void {
    let i: Int32;
    let itemList: array<wref<gameItemData>>;
    let itemModificationSystem: wref<ItemModificationSystem>;
    let partItemID: ItemID;
    let transactionSystem: ref<TransactionSystem>;
    let player: wref<PlayerPuppet> = GetPlayer(this.GetGameInstance());
    if IsDefined(player) {
      transactionSystem = GameInstance.GetTransactionSystem(this.GetGameInstance());
      transactionSystem.GetItemList(player, itemList);
    };
    itemModificationSystem = GameInstance.GetScriptableSystemsContainer(this.GetGameInstance()).Get(n"ItemModificationSystem") as ItemModificationSystem;
    i = 0;
    while i < ArraySize(itemList) {
      if itemList[i].HasTag(n"Gog_Katana") {
        partItemID = ItemID.FromTDBID(t"Items.GogKatanaWeaponMod");
        transactionSystem.GiveItem(player, partItemID, 1);
        itemModificationSystem.QueueRequest(this.CreateInstallPartRequest_Mod(player, itemList[i], partItemID));
      };
      if itemList[i].HasTag(n"Buck_Grad") {
        partItemID = ItemID.FromTDBID(t"Items.Buck_scope");
        transactionSystem.GiveItem(player, partItemID, 1);
        itemModificationSystem.QueueRequest(this.CreateInstallPartRequest_Attachment(player, itemList[i], partItemID));
      };
      if itemList[i].HasTag(n"Tactician_Headsman") {
        partItemID = ItemID.FromTDBID(t"Items.Headsman_scope");
        transactionSystem.GiveItem(player, partItemID, 1);
        itemModificationSystem.QueueRequest(this.CreateInstallPartRequest_Attachment(player, itemList[i], partItemID));
      };
      if itemList[i].HasTag(n"Sasquatch_Hammer") {
        partItemID = ItemID.FromTDBID(t"Items.Hammer_Sasquatch_Mod");
        transactionSystem.GiveItem(player, partItemID, 1);
        itemModificationSystem.QueueRequest(this.CreateInstallPartRequest_Mod(player, itemList[i], partItemID));
      };
      if itemList[i].HasTag(n"Nekomata_Breakthrough") {
        partItemID = ItemID.FromTDBID(t"Items.Breakthrough_scope");
        transactionSystem.GiveItem(player, partItemID, 1);
        itemModificationSystem.QueueRequest(this.CreateInstallPartRequest_Attachment(player, itemList[i], partItemID));
      };
      if itemList[i].HasTag(n"Competition_Lexington") {
        partItemID = ItemID.FromTDBID(t"Items.Lexington_Shooting_Competition_scope");
        transactionSystem.GiveItem(player, partItemID, 1);
        itemModificationSystem.QueueRequest(this.CreateInstallPartRequest_Attachment(player, itemList[i], partItemID));
      };
      if itemList[i].HasTag(n"Competition_Lexington") {
        partItemID = ItemID.FromTDBID(t"Items.CollectibleIconicWeaponMod");
        transactionSystem.GiveItem(player, partItemID, 1);
        itemModificationSystem.QueueRequest(this.CreateInstallPartRequest_Mod(player, itemList[i], partItemID));
      };
      if itemList[i].HasTag(n"Grad_Panam") {
        partItemID = ItemID.FromTDBID(t"Items.Panam_scope");
        transactionSystem.GiveItem(player, partItemID, 1);
        itemModificationSystem.QueueRequest(this.CreateInstallPartRequest_Attachment(player, itemList[i], partItemID));
      };
      if itemList[i].HasTag(n"ChemResMod") {
        partItemID = ItemID.FromTDBID(t"Items.IntrinsicFabricEnhancer12");
        transactionSystem.GiveItem(player, partItemID, 1);
        itemModificationSystem.QueueRequest(this.CreateInstallPartRequest_Mod(player, itemList[i], partItemID));
      };
      if itemList[i].HasTag(n"ZoomMod") {
        partItemID = ItemID.FromTDBID(t"Items.IntrinsicFabricEnhancer07a");
        transactionSystem.GiveItem(player, partItemID, 1);
        itemModificationSystem.QueueRequest(this.CreateInstallPartRequest_Mod(player, itemList[i], partItemID));
      };
      if itemList[i].HasTag(n"QuickhackUploadMod") {
        partItemID = ItemID.FromTDBID(t"Items.IntrinsicFabricEnhancer10");
        transactionSystem.GiveItem(player, partItemID, 1);
        itemModificationSystem.QueueRequest(this.CreateInstallPartRequest_Mod(player, itemList[i], partItemID));
      };
      if itemList[i].HasTag(n"VisibilityMod") {
        partItemID = ItemID.FromTDBID(t"Items.IntrinsicFabricEnhancer05");
        transactionSystem.GiveItem(player, partItemID, 1);
        itemModificationSystem.QueueRequest(this.CreateInstallPartRequest_Mod(player, itemList[i], partItemID));
      };
      if itemList[i].HasTag(n"MeleeDmgRedMod") {
        partItemID = ItemID.FromTDBID(t"Items.IntrinsicFabricEnhancer09");
        transactionSystem.GiveItem(player, partItemID, 1);
        itemModificationSystem.QueueRequest(this.CreateInstallPartRequest_Mod(player, itemList[i], partItemID));
      };
      if itemList[i].HasTag(n"QuickhackDmgRedMod") {
        partItemID = ItemID.FromTDBID(t"Items.IntrinsicFabricEnhancer11");
        transactionSystem.GiveItem(player, partItemID, 1);
        itemModificationSystem.QueueRequest(this.CreateInstallPartRequest_Mod(player, itemList[i], partItemID));
      };
      if itemList[i].HasTag(n"ArmorMod") {
        partItemID = ItemID.FromTDBID(t"Items.IntrinsicFabricEnhancer01");
        transactionSystem.GiveItem(player, partItemID, 1);
        itemModificationSystem.QueueRequest(this.CreateInstallPartRequest_Mod(player, itemList[i], partItemID));
      };
      if itemList[i].HasTag(n"ReloadMod") {
        partItemID = ItemID.FromTDBID(t"Items.IntrinsicFabricEnhancer08");
        transactionSystem.GiveItem(player, partItemID, 1);
        itemModificationSystem.QueueRequest(this.CreateInstallPartRequest_Mod(player, itemList[i], partItemID));
      };
      i += 1;
    };
  }

  private final func CreateInstallPartRequest_Mod(player: wref<PlayerPuppet>, itemData: wref<gameItemData>, part: ItemID) -> ref<InstallItemPart> {
    let installPartRequest: ref<InstallItemPart>;
    let slotID: TweakDBID;
    switch itemData.GetItemType() {
      case gamedataItemType.Wea_Hammer:
      case gamedataItemType.Wea_Katana:
        slotID = t"AttachmentSlots.IconicMeleeWeaponMod1";
        break;
      case gamedataItemType.Wea_Handgun:
        slotID = t"AttachmentSlots.IconicWeaponModLegendary";
        break;
      case gamedataItemType.Clo_InnerChest:
        slotID = t"AttachmentSlots.InnerChestFabricEnhancer1";
        break;
      case gamedataItemType.Clo_OuterChest:
        slotID = t"AttachmentSlots.OuterChestFabricEnhancer1";
        break;
      case gamedataItemType.Clo_Head:
        slotID = t"AttachmentSlots.HeadFabricEnhancer1";
        break;
      case gamedataItemType.Clo_Face:
        slotID = t"AttachmentSlots.FaceFabricEnhancer1";
        break;
      default:
    };
    installPartRequest = new InstallItemPart();
    installPartRequest.Set(player, itemData.GetID(), part, slotID);
    return installPartRequest;
  }

  private final func CreateInstallPartRequest_Attachment(player: wref<PlayerPuppet>, itemData: wref<gameItemData>, part: ItemID) -> ref<InstallItemPart> {
    let installPartRequest: ref<InstallItemPart>;
    let slotID: TweakDBID;
    switch itemData.GetItemType() {
      case gamedataItemType.Wea_Shotgun:
      case gamedataItemType.Wea_SniperRifle:
      case gamedataItemType.Wea_Handgun:
        slotID = t"AttachmentSlots.Scope";
        break;
      default:
    };
    installPartRequest = new InstallItemPart();
    installPartRequest.Set(player, itemData.GetID(), part, slotID);
    return installPartRequest;
  }

  private final func HideButchersKnifeRecipes() -> Void {
    this.m_playerCraftBook.HideRecipe(t"Items.Craftable_Common_Butchers_Knife", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Craftable_Uncommon_Butchers_Knife", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Craftable_Rare_Butchers_Knife", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Craftable_Epic_Butchers_Knife", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Craftable_Legendary_Butchers_Knife", true);
  }

  private final func CompensateForOwnedButchersKnifeRecipes() -> Void {
    if this.m_playerCraftBook.KnowsRecipe(t"Items.Craftable_Common_Butchers_Knife") {
      this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Common_Knife");
    };
    if this.m_playerCraftBook.KnowsRecipe(t"Items.Craftable_Uncommon_Butchers_Knife") {
      this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Uncommon_Tanto");
    };
    if this.m_playerCraftBook.KnowsRecipe(t"Items.Craftable_Rare_Butchers_Knife") {
      this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Rare_Tanto");
    };
    if this.m_playerCraftBook.KnowsRecipe(t"Items.Craftable_Epic_Butchers_Knife") {
      this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Epic_Knife");
    };
    if this.m_playerCraftBook.KnowsRecipe(t"Items.Craftable_Legendary_Butchers_Knife") {
      this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Legendary_Knife");
    };
  }

  private final func HideMilitaryKatanaRecipes() -> Void {
    this.m_playerCraftBook.HideRecipe(t"Items.Craftable_Common_Katana_Military", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Craftable_Uncommon_Katana_Military", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Craftable_Rare_Katana_Military_1", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Craftable_Epic_Katana_Military", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Craftable_Legendary_Katana_Military", true);
  }

  private final func CompensateForOwnedMilitaryKatanaRecipes() -> Void {
    if this.m_playerCraftBook.KnowsRecipe(t"Items.Craftable_Common_Katana_Military") {
      this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Common_Katana");
    };
    if this.m_playerCraftBook.KnowsRecipe(t"Items.Craftable_Uncommon_Katana_Military") {
      this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Uncommon_Katana");
    };
    if this.m_playerCraftBook.KnowsRecipe(t"Items.Craftable_Rare_Katana_Military_1") {
      this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Rare_Katana");
    };
    if this.m_playerCraftBook.KnowsRecipe(t"Items.Craftable_Epic_Katana_Military") {
      this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Epic_Katana");
    };
    if this.m_playerCraftBook.KnowsRecipe(t"Items.Craftable_Legendary_Katana_Military") {
      this.m_playerCraftBook.AddRecipe(t"Items.Proficiency_Craftable_Legendary_Katana");
    };
  }

  private final func HidePipeWrenchRecipes() -> Void {
    this.m_playerCraftBook.HideRecipe(t"Items.Craftable_Common_Pipe_Wrench", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Craftable_Uncommon_Pipe_Wrench", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Craftable_Rare_Pipe_Wrench", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Craftable_Epic_Pipe_Wrench", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Craftable_Legendary_Pipe_Wrench", true);
  }

  private final func CompensateForOwnedPipeWrenchRecipes() -> Void {
    if this.m_playerCraftBook.KnowsRecipe(t"Items.Craftable_Common_Pipe_Wrench") {
      this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Common_Tire_Iron");
    };
    if this.m_playerCraftBook.KnowsRecipe(t"Items.Craftable_Uncommon_Pipe_Wrench") {
      this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Uncommon_Tire_Iron");
    };
    if this.m_playerCraftBook.KnowsRecipe(t"Items.Craftable_Rare_Pipe_Wrench") {
      this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Rare_Tire_Iron");
    };
    if this.m_playerCraftBook.KnowsRecipe(t"Items.Craftable_Epic_Pipe_Wrench") {
      this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Epic_Tire_Iron");
    };
    if this.m_playerCraftBook.KnowsRecipe(t"Items.Craftable_Legendary_Pipe_Wrench") {
      this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Legendary_Tire_Iron");
    };
  }

  private final func HideIconicWeaponsRecipes() -> Void {
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Baseball_Bat_Denny_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Baseball_Bat_Denny_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Baton_Tinker_Bell_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Baton_Tinker_Bell_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Cane_Fingers_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Cane_Fingers_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Dildo_Stout_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Dildo_Stout_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Katana_Cocktail_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Katana_Cocktail_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Katana_Hiromi_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Katana_Hiromi_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Katana_Takemura_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Katana_Saburo_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Katana_Saburo_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Katana_Surgeon_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Katana_Surgeon_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Katana_Wakako_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Knife_Stinger_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Knife_Stinger_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Neurotoxin_Knife_Iconic_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Neurotoxin_Knife_Iconic_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Punk_Knife_Iconic_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Punk_Knife_Iconic_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Butchers_Knife_Iconic_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Butchers_Knife_Iconic_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Kenshin_Frank_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Kenshin_Royce_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Kenshin_Royce_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Lexington_Wilson_Rare", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Lexington_Wilson_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Lexington_Wilson_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Liberty_Yorinobu_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Liberty_Yorinobu_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Liberty_Dex_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Liberty_Dex_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Liberty_Padre_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Nue_Jackie_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Nue_Jackie_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Nue_Maiko_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Nue_Maiko_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Omaha_Suzie_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Omaha_Suzie_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Yukimura_Kiji_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Burya_Comrade_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Overture_River_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Overture_Kerry_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Overture_Kerry_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Overture_Cassidy_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Nova_Doom_Doom_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Nova_Doom_Doom_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Achilles_Nash_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Achilles_Nash_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Ajax_Moron_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Copperhead_Genesis_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Copperhead_Genesis_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Grad_Panam_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Grad_Panam_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Grad_Buck_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Kolac_Tiny_Mike_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Nekomata_Breakthrough_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Sidewinder_Divided_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Sidewinder_Divided_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Carnage_Mox_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Carnage_Mox_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Carnage_Edgerunners_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Igla_Sovereign_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Tactician_Headsman_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Tactician_Dino_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Pulsar_Buzzsaw_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Pulsar_Buzzsaw_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Saratoga_Maelstrom_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Saratoga_Maelstrom_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Saratoga_Raffen_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Saratoga_Raffen_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Igla_Sovereign", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Pulsar_Buzzsaw", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Nekomata_Breakthrough", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Burya_Comrade", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Copperhead_Genesis", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Ajax_Moron", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Zhuo_Eight_Star", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Dian_Yinglong", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Tactician_Headsman", true);
  }

  private final func HideDeprecatedCraftingRecipes() -> Void {
    this.m_playerCraftBook.HideRecipe(t"Items.Glasses_03_basic_06_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Glasses_01_basic_03_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Glasses_05_basic_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Mask_03_basic_02_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Mask_02_rich_02_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Mask_02_basic_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Tech_02_basic_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Tech_01_basic_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Tech_02_basic_02_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Visor_02_basic_02_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Visor_01_basic_05_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Visor_02_rich_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Boots_09_rich_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Boots_03_basic_02_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Boots_07_basic_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Boots_11_rich_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.CasualShoes_05_basic_03_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.CasualShoes_01_basic_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.CasualShoes_02_basic_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_CasualShoes_07_basic_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.FormalShoes_03_rich_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.FormalShoes_01_rich_02_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_FormalShoes_02_rich_03_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_FormalShoes_02_basic_02_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Balaclava_01_basic_02_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Cap_02_basic_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Cap_03_rich_02_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Cap_06_basic_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Hat_02_rich_02_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Hat_03_basic_02_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Hat_01_rich_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Helmet_03_basic_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Helmet_01_basic_03_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Helmet_04_basic_02_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Scarf_01_rich_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Scarf_03_basic_03_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Scarf_02_rich_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.FormalShirt_01_rich_06_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.FormalShirt_02_basic_03_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_TightJumpsuit_01_rich_02_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Shirt_01_basic_02_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Shirt_03_basic_02_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Shirt_02_basic_02_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.TShirt_01_rich_02_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.TShirt_02_basic_04_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_TShirt_03_rich_03_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Undershirt_03_basic_04_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Undershirt_02_rich_02_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Undershirt_03_basic_03_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.FormalPants_03_rich_02_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.FormalPants_02_rich_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_FormalPants_01_basic_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Pants_04_basic_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Pants_02_basic_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Pants_08_rich_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Pants_13_basic_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Shorts_02_basic_02_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Shorts_01_basic_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Shorts_02_rich_02_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.FormalSkirt_02_rich_03_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.FormalSkirt_01_rich_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_FormalSkirt_02_rich_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Coat_01_basic_03_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Coat_04_rich_02_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Dress_01_rich_03_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.FormalJacket_02_basic_02_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.FormalJacket_04_basic_02_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Jacket_01_rich_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Jacket_17_rich_06_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Jacket_06_basic_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Jumpsuit_02_rich_03_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.LooseShirt_01_rich_02_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_LooseShirt_02_rich_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Vest_13_rich_04_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Vest_20_rich_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Vest_18_basic_01_Crafting", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Preset_Katana_GoG_Crafted", true);
    this.m_playerCraftBook.HideRecipe(t"Items.GOG_DLC_TShirt_Crafted", true);
    this.m_playerCraftBook.HideRecipe(t"Items.GOG_DLC_Jacket_Crafted", true);
    this.m_playerCraftBook.HideRecipe(t"Items.GOG_Galaxy_TShirt_Crafted", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Jacket_19_basic_04_Crafted", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Jacket_20_basic_01_Crafted", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Q005_Johnny_Glasses_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Q005_Johnny_Glasses_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Q005_Johnny_Shirt_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Q005_Johnny_Shirt_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Q005_Johnny_Pants_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Q005_Johnny_Pants_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Q005_Johnny_Shoes_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Q005_Johnny_Shoes_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.SQ031_Samurai_Jacket_Epic", true);
    this.m_playerCraftBook.HideRecipe(t"Items.SQ031_Samurai_Jacket_Legendary", true);
    this.m_playerCraftBook.HideRecipe(t"Items.PhysicalDamageEdge", true);
    this.m_playerCraftBook.HideRecipe(t"Items.ThermalDamageEdge", true);
    this.m_playerCraftBook.HideRecipe(t"Items.ChemicalDamageEdge", true);
    this.m_playerCraftBook.HideRecipe(t"Items.ElectricDamageEdge", true);
    this.m_playerCraftBook.HideRecipe(t"Items.SlowRotor", true);
    this.m_playerCraftBook.HideRecipe(t"Items.FastRotor", true);
    this.m_playerCraftBook.HideRecipe(t"Items.PhysicalDamageCable", true);
    this.m_playerCraftBook.HideRecipe(t"Items.ThermalDamageCable", true);
    this.m_playerCraftBook.HideRecipe(t"Items.ChemicalDamageCable", true);
    this.m_playerCraftBook.HideRecipe(t"Items.ElectricDamageCable", true);
    this.m_playerCraftBook.HideRecipe(t"Items.LowChargedWiresBattery", true);
    this.m_playerCraftBook.HideRecipe(t"Items.MediumChargedWiresBattery", true);
    this.m_playerCraftBook.HideRecipe(t"Items.HighChargedWiresBattery", true);
    this.m_playerCraftBook.HideRecipe(t"Items.ExplosiveDamageRound", true);
    this.m_playerCraftBook.HideRecipe(t"Items.ElectricDamageRound", true);
    this.m_playerCraftBook.HideRecipe(t"Items.ThermalDamageRound", true);
    this.m_playerCraftBook.HideRecipe(t"Items.ChemicalDamageRound", true);
    this.m_playerCraftBook.HideRecipe(t"Items.NeoplasticPlating", true);
    this.m_playerCraftBook.HideRecipe(t"Items.MetalPlating", true);
    this.m_playerCraftBook.HideRecipe(t"Items.TitaniumPlating", true);
    this.m_playerCraftBook.HideRecipe(t"Items.ArmsCyberwareSharedFragment1", true);
    this.m_playerCraftBook.HideRecipe(t"Items.ArmsCyberwareSharedFragment2", true);
    this.m_playerCraftBook.HideRecipe(t"Items.ArmsCyberwareSharedFragment3", true);
    this.m_playerCraftBook.HideRecipe(t"Items.ArmsCyberwareSharedFragment4", true);
    this.m_playerCraftBook.HideRecipe(t"Items.PhysicalDamageKnuckles", true);
    this.m_playerCraftBook.HideRecipe(t"Items.ThermalDamageKnuckles", true);
    this.m_playerCraftBook.HideRecipe(t"Items.ChemicalDamageKnuckles", true);
    this.m_playerCraftBook.HideRecipe(t"Items.ElectricDamageKnuckles", true);
    this.m_playerCraftBook.HideRecipe(t"Items.LowChargedBattery", true);
    this.m_playerCraftBook.HideRecipe(t"Items.MediumChargedBattery", true);
    this.m_playerCraftBook.HideRecipe(t"Items.HighChargedBattery", true);
    this.m_playerCraftBook.HideRecipe(t"Items.KiroshiOpticsFragment1", true);
    this.m_playerCraftBook.HideRecipe(t"Items.KiroshiOpticsFragment2", true);
    this.m_playerCraftBook.HideRecipe(t"Items.KiroshiOpticsFragment3", true);
    this.m_playerCraftBook.HideRecipe(t"Items.KiroshiOpticsFragment4", true);
    this.m_playerCraftBook.HideRecipe(t"Items.KiroshiOpticsFragment5", true);
    this.m_playerCraftBook.HideRecipe(t"Items.SandevistanFragment1", true);
    this.m_playerCraftBook.HideRecipe(t"Items.SandevistanFragment2", true);
    this.m_playerCraftBook.HideRecipe(t"Items.SandevistanFragment3", true);
    this.m_playerCraftBook.HideRecipe(t"Items.SandevistanFragment4", true);
    this.m_playerCraftBook.HideRecipe(t"Items.TygerClawsSandevistanFragment1", true);
    this.m_playerCraftBook.HideRecipe(t"Items.ValentinosSandevistanFragment1", true);
    this.m_playerCraftBook.HideRecipe(t"Items.ArasakaSandevistanFragment1", true);
    this.m_playerCraftBook.HideRecipe(t"Items.BerserkFragment1", true);
    this.m_playerCraftBook.HideRecipe(t"Items.BerserkFragment2", true);
    this.m_playerCraftBook.HideRecipe(t"Items.BerserkFragment3", true);
    this.m_playerCraftBook.HideRecipe(t"Items.BerserkFragment4", true);
    this.m_playerCraftBook.HideRecipe(t"Items.BerserkFragment5", true);
    this.m_playerCraftBook.HideRecipe(t"Items.BerserkFragment6", true);
    this.m_playerCraftBook.HideRecipe(t"Items.BerserkFragment7", true);
    this.m_playerCraftBook.HideRecipe(t"Items.BerserkFragment8", true);
    this.m_playerCraftBook.HideRecipe(t"Items.AnimalsBerserkFragment1", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Craftable_Uncommon_Satara", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Craftable_Uncommon_Nue", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Craftable_Uncommon_Copperhead", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Craftable_Uncommon_Baton_Alpha", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Craftable_Rare_Nova", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Craftable_Rare_Pulsar", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Craftable_Rare_Grad", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Craftable_Rare_Knife", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Craftable_Epic_Yukimura", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Craftable_Epic_Sor22", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Craftable_Epic_Tactician", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Craftable_Epic_Bat", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Craftable_Legendary_Quasar", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Craftable_Legendary_Nekomata", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Craftable_Legendary_Carnage", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Proficiency_Craftable_Legendary_Katana", true);
    this.m_playerCraftBook.HideRecipe(t"Items.SimpleFabricEnhancer01", true);
    this.m_playerCraftBook.HideRecipe(t"Items.SimpleFabricEnhancer02", true);
    this.m_playerCraftBook.HideRecipe(t"Items.SimpleFabricEnhancer03", true);
    this.m_playerCraftBook.HideRecipe(t"Items.SimpleFabricEnhancer04", true);
    this.m_playerCraftBook.HideRecipe(t"Items.SimpleFabricEnhancer05", true);
    this.m_playerCraftBook.HideRecipe(t"Items.PowerfulFabricEnhancer01", true);
    this.m_playerCraftBook.HideRecipe(t"Items.PowerfulFabricEnhancer02", true);
    this.m_playerCraftBook.HideRecipe(t"Items.PowerfulFabricEnhancer03", true);
    this.m_playerCraftBook.HideRecipe(t"Items.PowerfulFabricEnhancer04", true);
    this.m_playerCraftBook.HideRecipe(t"Items.PowerfulFabricEnhancer05", true);
    this.m_playerCraftBook.HideRecipe(t"Items.PowerfulFabricEnhancer06", true);
    this.m_playerCraftBook.HideRecipe(t"Items.PowerfulFabricEnhancer07", true);
    this.m_playerCraftBook.HideRecipe(t"Items.PowerfulFabricEnhancer08", true);
    this.m_playerCraftBook.HideRecipe(t"Items.SimpleWeaponMod01", true);
    this.m_playerCraftBook.HideRecipe(t"Items.SimpleWeaponMod02", true);
    this.m_playerCraftBook.HideRecipe(t"Items.SimpleWeaponMod03", true);
    this.m_playerCraftBook.HideRecipe(t"Items.SimpleWeaponMod04", true);
    this.m_playerCraftBook.HideRecipe(t"Items.OxyBooster", true);
    this.m_playerCraftBook.HideRecipe(t"Items.EMPOverloadProgram", true);
    this.m_playerCraftBook.HideRecipe(t"Items.OverheatProgram", true);
    this.m_playerCraftBook.HideRecipe(t"Items.BlindProgram", true);
    this.m_playerCraftBook.HideRecipe(t"Items.WhistleProgram", true);
    this.m_playerCraftBook.HideRecipe(t"Items.PingProgram", true);
    this.m_playerCraftBook.HideRecipe(t"Items.CommsCallInProgram", true);
    this.m_playerCraftBook.HideRecipe(t"Items.PingLvl3Program", true);
  }

  private final func HideDeprecatedCraftbookRecipes() -> Void {
    this.m_playerCraftBook.HideRecipe(t"Items.GrenadeFragRegular", true);
    this.m_playerCraftBook.HideRecipe(t"Items.GrenadeFlashRegular", true);
    this.m_playerCraftBook.HideRecipe(t"Items.GrenadeEMPRegular", true);
    this.m_playerCraftBook.HideRecipe(t"Items.FirstAidWhiffV0", true);
    this.m_playerCraftBook.HideRecipe(t"Items.BonesMcCoy70V0", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Craftable_Uncommon_Knife", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Craftable_Uncommon_Nekomata", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Craftable_Uncommon_Igla", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Craftable_Uncommon_Nova", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Craftable_Common_Satara", true);
    this.m_playerCraftBook.HideRecipe(t"Items.Craftable_Common_Lexington", true);
  }

  private final func AddCraftbookRecipes() -> Void {
    this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Common_Copperhead");
    this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Common_Sidewinder");
    this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Common_Guillotine");
    this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Common_Pulsar");
    this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Common_Unity");
    this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Common_Nova");
    this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Common_Igla");
    this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Common_Carnage");
    this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Uncommon_Umbra");
    this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Uncommon_Liberty");
    this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Uncommon_Quasar");
    this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Uncommon_Palica");
    this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Uncommon_Satara");
    this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Common_Katana");
    this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Common_Bat");
    this.m_playerCraftBook.AddRecipe(t"Items.Craftable_Common_Knife");
    this.m_playerCraftBook.AddRecipe(t"Items.w_att_scope_short_01_Craftable");
    this.m_playerCraftBook.AddRecipe(t"Items.w_att_scope_short_03_Craftable");
    this.m_playerCraftBook.AddRecipe(t"Items.w_att_scope_short_06_Craftable");
    this.m_playerCraftBook.AddRecipe(t"Items.w_att_scope_long_02_Craftable");
    this.m_playerCraftBook.AddRecipe(t"Items.w_silencer_01_Craftable");
    this.m_playerCraftBook.AddRecipe(t"Items.w_muzzle_brake_01_Craftable");
    this.m_playerCraftBook.AddRecipe(t"Items.w_muzzle_brake_09_Craftable");
    this.m_playerCraftBook.AddRecipe(t"Items.UncommonMaterial1");
    this.m_playerCraftBook.AddRecipe(t"Items.RareMaterial1");
    this.m_playerCraftBook.AddRecipe(t"Items.EpicMaterial1");
    this.m_playerCraftBook.AddRecipe(t"Items.LegendaryMaterial1");
  }

  private final func CompensateForOwnedCraftableIconics() -> Void {
    let ss: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGameInstance());
    let player: wref<PlayerPuppet> = GetMainPlayer(this.GetGameInstance());
    let playerLevel: Float = ss.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.Level);
    if this.m_playerCraftBook.KnowsRecipe(t"Items.Preset_Igla_Sovereign") {
      if playerLevel < 9.00 {
        this.m_playerCraftBook.AddRecipe(t"Items.Common_Igla_Sovereign");
      } else {
        if playerLevel < 17.00 {
          this.m_playerCraftBook.AddRecipe(t"Items.Uncommon_Igla_Sovereign");
        } else {
          if playerLevel < 25.00 {
            this.m_playerCraftBook.AddRecipe(t"Items.Rare_Igla_Sovereign");
          } else {
            if playerLevel < 33.00 {
              this.m_playerCraftBook.AddRecipe(t"Items.Epic_Igla_Sovereign");
            } else {
              this.m_playerCraftBook.AddRecipe(t"Items.Legendary_Igla_Sovereign");
            };
          };
        };
      };
    };
    if this.m_playerCraftBook.KnowsRecipe(t"Items.Preset_Pulsar_Buzzsaw") {
      if playerLevel < 9.00 {
        this.m_playerCraftBook.AddRecipe(t"Items.Common_Pulsar_Buzzsaw");
      } else {
        if playerLevel < 17.00 {
          this.m_playerCraftBook.AddRecipe(t"Items.Uncommon_Pulsar_Buzzsaw");
        } else {
          if playerLevel < 25.00 {
            this.m_playerCraftBook.AddRecipe(t"Items.Rare_Pulsar_Buzzsaw");
          } else {
            if playerLevel < 33.00 {
              this.m_playerCraftBook.AddRecipe(t"Items.Epic_Pulsar_Buzzsaw");
            } else {
              this.m_playerCraftBook.AddRecipe(t"Items.Legendary_Pulsar_Buzzsaw");
            };
          };
        };
      };
    };
    if this.m_playerCraftBook.KnowsRecipe(t"Items.Preset_Nekomata_Breakthrough") {
      if playerLevel < 9.00 {
        this.m_playerCraftBook.AddRecipe(t"Items.Common_Nekomata_Breakthrough");
      } else {
        if playerLevel < 17.00 {
          this.m_playerCraftBook.AddRecipe(t"Items.Uncommon_Nekomata_Breakthrough");
        } else {
          if playerLevel < 25.00 {
            this.m_playerCraftBook.AddRecipe(t"Items.Rare_Nekomata_Breakthrough");
          } else {
            if playerLevel < 33.00 {
              this.m_playerCraftBook.AddRecipe(t"Items.Epic_Nekomata_Breakthrough");
            } else {
              this.m_playerCraftBook.AddRecipe(t"Items.Legendary_Nekomata_Breakthrough");
            };
          };
        };
      };
    };
    if this.m_playerCraftBook.KnowsRecipe(t"Items.Preset_Burya_Comrade") {
      if playerLevel < 9.00 {
        this.m_playerCraftBook.AddRecipe(t"Items.Common_Burya_Comrade");
      } else {
        if playerLevel < 17.00 {
          this.m_playerCraftBook.AddRecipe(t"Items.Uncommon_Burya_Comrade");
        } else {
          if playerLevel < 25.00 {
            this.m_playerCraftBook.AddRecipe(t"Items.Rare_Burya_Comrade");
          } else {
            if playerLevel < 33.00 {
              this.m_playerCraftBook.AddRecipe(t"Items.Epic_Burya_Comrade");
            } else {
              this.m_playerCraftBook.AddRecipe(t"Items.Legendary_Burya_Comrade");
            };
          };
        };
      };
    };
    if this.m_playerCraftBook.KnowsRecipe(t"Items.Preset_Copperhead_Genesis") {
      if playerLevel < 9.00 {
        this.m_playerCraftBook.AddRecipe(t"Items.Common_Copperhead_Genesis");
      } else {
        if playerLevel < 17.00 {
          this.m_playerCraftBook.AddRecipe(t"Items.Uncommon_Copperhead_Genesis");
        } else {
          if playerLevel < 25.00 {
            this.m_playerCraftBook.AddRecipe(t"Items.Rare_Copperhead_Genesis");
          } else {
            if playerLevel < 33.00 {
              this.m_playerCraftBook.AddRecipe(t"Items.Epic_Copperhead_Genesis");
            } else {
              this.m_playerCraftBook.AddRecipe(t"Items.Legendary_Copperhead_Genesis");
            };
          };
        };
      };
    };
    if this.m_playerCraftBook.KnowsRecipe(t"Items.Preset_Ajax_Moron") {
      if playerLevel < 9.00 {
        this.m_playerCraftBook.AddRecipe(t"Items.Common_Ajax_Moron");
      } else {
        if playerLevel < 17.00 {
          this.m_playerCraftBook.AddRecipe(t"Items.Uncommon_Ajax_Moron");
        } else {
          if playerLevel < 25.00 {
            this.m_playerCraftBook.AddRecipe(t"Items.Rare_Ajax_Moron");
          } else {
            if playerLevel < 33.00 {
              this.m_playerCraftBook.AddRecipe(t"Items.Epic_Ajax_Moron");
            } else {
              this.m_playerCraftBook.AddRecipe(t"Items.Legendary_Ajax_Moron");
            };
          };
        };
      };
    };
    if this.m_playerCraftBook.KnowsRecipe(t"Items.Preset_Zhuo_Eight_Star") {
      if playerLevel < 9.00 {
        this.m_playerCraftBook.AddRecipe(t"Items.Common_Zhuo_Eight_Star");
      } else {
        if playerLevel < 17.00 {
          this.m_playerCraftBook.AddRecipe(t"Items.Uncommon_Zhuo_Eight_Star");
        } else {
          if playerLevel < 25.00 {
            this.m_playerCraftBook.AddRecipe(t"Items.Rare_Zhuo_Eight_Star");
          } else {
            if playerLevel < 33.00 {
              this.m_playerCraftBook.AddRecipe(t"Items.Epic_Zhuo_Eight_Star");
            } else {
              this.m_playerCraftBook.AddRecipe(t"Items.Legendary_Zhuo_Eight_Star");
            };
          };
        };
      };
    };
    if this.m_playerCraftBook.KnowsRecipe(t"Items.Preset_Dian_Yinglong") {
      if playerLevel < 9.00 {
        this.m_playerCraftBook.AddRecipe(t"Items.Common_Dian_Yinglong");
      } else {
        if playerLevel < 17.00 {
          this.m_playerCraftBook.AddRecipe(t"Items.Uncommon_Dian_Yinglong");
        } else {
          if playerLevel < 25.00 {
            this.m_playerCraftBook.AddRecipe(t"Items.Rare_Dian_Yinglong");
          } else {
            if playerLevel < 33.00 {
              this.m_playerCraftBook.AddRecipe(t"Items.Epic_Dian_Yinglong");
            } else {
              this.m_playerCraftBook.AddRecipe(t"Items.Legendary_Dian_Yinglong");
            };
          };
        };
      };
    };
    if this.m_playerCraftBook.KnowsRecipe(t"Items.Preset_Tactician_Headsman") {
      if playerLevel < 9.00 {
        this.m_playerCraftBook.AddRecipe(t"Items.Common_Tactician_Headsman");
      } else {
        if playerLevel < 17.00 {
          this.m_playerCraftBook.AddRecipe(t"Items.Uncommon_Tactician_Headsman");
        } else {
          if playerLevel < 25.00 {
            this.m_playerCraftBook.AddRecipe(t"Items.Rare_Tactician_Headsman");
          } else {
            if playerLevel < 33.00 {
              this.m_playerCraftBook.AddRecipe(t"Items.Epic_Tactician_Headsman");
            } else {
              this.m_playerCraftBook.AddRecipe(t"Items.Legendary_Tactician_Headsman");
            };
          };
        };
      };
    };
  }

  private final func CompensateMissingBuzzsawPsalmRecipes() -> Void {
    let ss: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGameInstance());
    let player: wref<PlayerPuppet> = GetMainPlayer(this.GetGameInstance());
    let playerLevel: Float = ss.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.Level);
    if GetFact(this.GetGameInstance(), n"ma_nid_01_finished") >= 1 && !this.m_playerCraftBook.KnowsRecipe(t"Items.Common_Pulsar_Buzzsaw") && !this.m_playerCraftBook.KnowsRecipe(t"Items.Uncommon_Pulsar_Buzzsaw") && !this.m_playerCraftBook.KnowsRecipe(t"Items.Rare_Pulsar_Buzzsaw") && !this.m_playerCraftBook.KnowsRecipe(t"Items.Epic_Pulsar_Buzzsaw") && !this.m_playerCraftBook.KnowsRecipe(t"Items.Legendary_Pulsar_Buzzsaw") {
      if playerLevel < 9.00 {
        this.m_playerCraftBook.AddRecipe(t"Items.Common_Pulsar_Buzzsaw");
      } else {
        if playerLevel < 17.00 {
          this.m_playerCraftBook.AddRecipe(t"Items.Uncommon_Pulsar_Buzzsaw");
        } else {
          if playerLevel < 25.00 {
            this.m_playerCraftBook.AddRecipe(t"Items.Rare_Pulsar_Buzzsaw");
          } else {
            if playerLevel < 33.00 {
              this.m_playerCraftBook.AddRecipe(t"Items.Epic_Pulsar_Buzzsaw");
            } else {
              this.m_playerCraftBook.AddRecipe(t"Items.Legendary_Pulsar_Buzzsaw");
            };
          };
        };
      };
    };
    if GetFact(this.GetGameInstance(), n"ma_nid_02_finished") >= 1 && !this.m_playerCraftBook.KnowsRecipe(t"Items.Common_Copperhead_Genesis") && !this.m_playerCraftBook.KnowsRecipe(t"Items.Uncommon_Copperhead_Genesis") && !this.m_playerCraftBook.KnowsRecipe(t"Items.Rare_Copperhead_Genesis") && !this.m_playerCraftBook.KnowsRecipe(t"Items.Epic_Copperhead_Genesis") && !this.m_playerCraftBook.KnowsRecipe(t"Items.Legendary_Copperhead_Genesis") {
      if playerLevel < 9.00 {
        this.m_playerCraftBook.AddRecipe(t"Items.Common_Copperhead_Genesis");
      } else {
        if playerLevel < 17.00 {
          this.m_playerCraftBook.AddRecipe(t"Items.Uncommon_Copperhead_Genesis");
        } else {
          if playerLevel < 25.00 {
            this.m_playerCraftBook.AddRecipe(t"Items.Rare_Copperhead_Genesis");
          } else {
            if playerLevel < 33.00 {
              this.m_playerCraftBook.AddRecipe(t"Items.Epic_Copperhead_Genesis");
            } else {
              this.m_playerCraftBook.AddRecipe(t"Items.Legendary_Copperhead_Genesis");
            };
          };
        };
      };
    };
  }

  public final static func GetAmmoBulletAmount(ammoId: TweakDBID) -> Int32 {
    let ammoRecipeId: TweakDBID;
    let amount: Int32;
    let craftingResult: wref<CraftingResult_Record>;
    let recipeRecord: wref<ItemRecipe_Record>;
    switch ammoId {
      case t"Ammo.HandgunAmmo":
        ammoRecipeId = t"Ammo.RecipeHandgunAmmo";
        break;
      case t"Ammo.ShotgunAmmo":
        ammoRecipeId = t"Ammo.RecipeShotgunAmmo";
        break;
      case t"Ammo.RifleAmmo":
        ammoRecipeId = t"Ammo.RecipeRifleAmmo";
        break;
      case t"Ammo.SniperRifleAmmo":
        ammoRecipeId = t"Ammo.RecipeSniperRifleAmmo";
    };
    recipeRecord = TweakDBInterface.GetItemRecipeRecord(ammoRecipeId);
    craftingResult = recipeRecord.CraftingResult();
    amount = craftingResult.Amount();
    return amount;
  }
}

public class CraftBook extends IScriptable {

  protected persistent let m_knownRecipes: [ItemRecipe];

  public let m_newRecipes: [TweakDBID];

  public let m_owner: wref<GameObject>;

  public final func InitializeCraftBookOwner(owner: wref<GameObject>) -> Void {
    this.m_owner = owner;
    return;
  }

  public final func InitializeCraftBook(owner: wref<GameObject>, recipes: wref<Craftable_Record>) -> Void {
    let craftItems: array<wref<Item_Record>>;
    let i: Int32;
    recipes.CraftableItem(craftItems);
    i = 0;
    while i < ArraySize(craftItems) {
      if this.GetRecipeIndex(craftItems[i].GetID()) == -1 {
        this.AddRecipe(craftItems[i].GetID());
      };
      i += 1;
    };
    return;
  }

  public final const func GetCraftableItems() -> [wref<Item_Record>] {
    let itemList: array<wref<Item_Record>>;
    let i: Int32 = 0;
    while i < ArraySize(this.m_knownRecipes) {
      if !this.m_knownRecipes[i].isHidden {
        ArrayPush(itemList, TweakDBInterface.GetItemRecord(this.m_knownRecipes[i].targetItem));
      };
      i += 1;
    };
    return itemList;
  }

  public final const func GetRecipeData(Recipe: TweakDBID) -> ItemRecipe {
    let nullRecipe: ItemRecipe;
    let index: Int32 = this.GetRecipeIndex(Recipe);
    if index != -1 {
      return this.m_knownRecipes[index];
    };
    return nullRecipe;
  }

  public final const func GetRecipeIndex(recipe: TweakDBID) -> Int32 {
    let i: Int32 = 0;
    while i < ArraySize(this.m_knownRecipes) {
      if this.m_knownRecipes[i].targetItem == recipe {
        return i;
      };
      i += 1;
    };
    return -1;
  }

  public final const func KnowsRecipe(recipe: TweakDBID) -> Bool {
    let i: Int32 = 0;
    while i < ArraySize(this.m_knownRecipes) {
      if this.m_knownRecipes[i].targetItem == recipe {
        return true;
      };
      i += 1;
    };
    return false;
  }

  public final func HideRecipesForOwnedItems() -> Void {
    let j: Int32;
    let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.m_owner.GetGame());
    let i: Int32 = 0;
    while i < ArraySize(this.m_knownRecipes) {
      if !this.m_knownRecipes[i].isHidden && ArraySize(this.m_knownRecipes[i].hideOnItemsAdded) > 0 {
        j = 0;
        while j < ArraySize(this.m_knownRecipes[i].hideOnItemsAdded) {
          if transactionSystem.HasItem(this.m_owner, this.m_knownRecipes[i].hideOnItemsAdded[j]) {
            this.m_knownRecipes[i].isHidden = true;
            break;
          };
          j += 1;
        };
      };
      i += 1;
    };
  }

  public final func AddRecipe(targetItem: TweakDBID, opt hideOnItemsAdded: [wref<Item_Record>], opt amount: Int32) -> Void {
    let i: Int32;
    let itemID: ItemID;
    let itemRecipe: ItemRecipe;
    let transactionSystem: ref<TransactionSystem>;
    if !TDBID.IsValid(targetItem) {
      return;
    };
    itemRecipe.targetItem = targetItem;
    if amount > 0 && amount != 1 {
      itemRecipe.amount = amount;
    } else {
      itemRecipe.amount = 1;
    };
    if ArraySize(hideOnItemsAdded) > 0 {
      transactionSystem = GameInstance.GetTransactionSystem(this.m_owner.GetGame());
      i = 0;
      while i < ArraySize(hideOnItemsAdded) {
        itemID = ItemID.CreateQuery(hideOnItemsAdded[i].GetID());
        ArrayPush(itemRecipe.hideOnItemsAdded, itemID);
        if transactionSystem.HasItem(this.m_owner, itemID) {
          itemRecipe.isHidden = true;
        };
        i += 1;
      };
    };
    i = this.GetRecipeIndex(targetItem);
    if i != -1 {
      this.m_knownRecipes[i] = itemRecipe;
      return;
    };
    ArrayPush(this.m_knownRecipes, itemRecipe);
    ArrayPush(this.m_newRecipes, itemRecipe.targetItem);
  }

  public final func SetRecipeInspected(itemID: TweakDBID) -> Void {
    if ArrayContains(this.m_newRecipes, itemID) {
      ArrayRemove(this.m_newRecipes, itemID);
    };
  }

  public final func IsRecipeNew(itemID: TweakDBID) -> Bool {
    return ArrayContains(this.m_newRecipes, itemID);
  }

  public final func HideRecipe(recipe: TweakDBID, shouldHide: Bool) -> Bool {
    let index: Int32 = this.GetRecipeIndex(recipe);
    if index != -1 {
      this.m_knownRecipes[index].isHidden = shouldHide;
      return true;
    };
    return false;
  }

  public final const func GetOwner() -> wref<GameObject> {
    return this.m_owner;
  }

  public final func ResetRecipeCraftedAmount() -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.m_knownRecipes) {
      if this.m_knownRecipes[i].amount == 0 {
        this.m_knownRecipes[i].amount = 1;
      };
      i += 1;
    };
  }
}

public class CraftingSystemInventoryCallback extends InventoryScriptCallback {

  public let player: wref<PlayerPuppet>;

  public func OnItemAdded(item: ItemID, itemData: wref<gameItemData>, flaggedAsSilent: Bool) -> Void {
    let addRecipeRequest: ref<AddRecipeRequest>;
    let craftingSystem: ref<CraftingSystem>;
    let itemToAdd: wref<CraftingResult_Record>;
    let recipeRecord: wref<ItemRecipe_Record>;
    if itemData.HasTag(n"Recipe") {
      craftingSystem = GameInstance.GetScriptableSystemsContainer(this.player.GetGame()).Get(n"CraftingSystem") as CraftingSystem;
      recipeRecord = TweakDBInterface.GetItemRecipeRecord(ItemID.GetTDBID(item));
      itemToAdd = recipeRecord.CraftingResult();
      addRecipeRequest = new AddRecipeRequest();
      addRecipeRequest.recipe = itemToAdd.Item().GetID();
      addRecipeRequest.amount = itemToAdd.Amount();
      if recipeRecord.GetHideOnItemsAddedCount() > 0 {
        recipeRecord.HideOnItemsAdded(addRecipeRequest.hideOnItemsAdded);
      };
      craftingSystem.QueueRequest(addRecipeRequest);
    };
  }
}
