
public class CraftingLogicController extends CraftingMainLogicController {

  private edit let m_ingredientsWeaponContainer: inkCompoundRef;

  private edit let m_itemPreviewContainer: inkWidgetRef;

  private edit let m_weaponPreviewContainer: inkWidgetRef;

  private edit let m_garmentPreviewContainer: inkWidgetRef;

  private edit let m_perkNotificationContainer: inkWidgetRef;

  private edit let m_perkNotificationText: inkTextRef;

  private let m_itemTooltipController: wref<AGenericTooltipController>;

  private let m_quickHackTooltipController: wref<AGenericTooltipController>;

  private let m_tooltipData: ref<ATooltipData>;

  private let m_ingredientWeaponController: wref<InventoryWeaponDisplayController>;

  private let m_ingredientClothingController: wref<InventoryWeaponDisplayController>;

  private let m_selectedItemGameData: ref<gameItemData>;

  private let m_quantityPickerPopupToken: ref<inkGameNotificationToken>;

  private let m_playerCraftBook: wref<CraftBook>;

  private let m_hasSpawnedQuickHackTooltip: Bool;

  @default(CraftingLogicController, 1)
  private let m_timeUntilReset: Float;

  public func Init(craftingGameController: wref<CraftingMainGameController>) -> Void {
    super.Init(craftingGameController);
    this.m_playerCraftBook = this.m_craftingSystem.GetPlayerCraftBook();
    this.SetCraftingButton("UI-Crafting-CraftItem");
  }

  private final const func IsCurrentSelectedRecipeValid() -> Bool {
    let data: array<ref<IScriptable>> = this.m_dataSource.GetArray();
    let i: Int32 = 0;
    while i < ArraySize(data) {
      if data[i] as RecipeData.id == this.m_selectedRecipe.id {
        return true;
      };
      i += 1;
    };
    return false;
  }

  public func RefreshListViewContent(opt inventoryItemData: InventoryItemData) -> Void {
    this.m_dataSource.Clear();
    this.m_dataSource.Reset(this.GetRecipesList());
    if !this.IsCurrentSelectedRecipeValid() {
      this.m_selectedRecipe = null;
    };
    this.UpdateRecipePreviewPanel(this.m_selectedRecipe);
  }

  protected func SetupIngredientWidgets() -> Void {
    this.AsyncSpawnFromLocal(inkWidgetRef.Get(this.m_ingredientsWeaponContainer), n"ingredientWeapon", this, n"OnWeaponControllerSpawned");
    this.AsyncSpawnFromLocal(inkWidgetRef.Get(this.m_ingredientsListContainer), n"ingredientClothes", this, n"OnClothingControllerSpawned");
    inkWidgetRef.SetVisible(this.m_ingredientsWeaponContainer, false);
    super.SetupIngredientWidgets();
  }

  protected cb func OnWeaponControllerSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
    this.m_ingredientWeaponController = widget.GetControllerByType(n"InventoryWeaponDisplayController") as InventoryWeaponDisplayController;
    let buttonController: wref<inkButtonController> = this.m_ingredientWeaponController.GetRootWidget().GetControllerByType(n"inkButtonController") as inkButtonController;
    buttonController.SetEnabled(false);
  }

  protected cb func OnClothingControllerSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
    this.m_ingredientClothingController = widget.GetControllerByType(n"InventoryWeaponDisplayController") as InventoryWeaponDisplayController;
  }

  protected func SetupFilters() -> Void {
    ArrayPush(this.m_filters, 15);
    ArrayPush(this.m_filters, 0);
    ArrayPush(this.m_filters, 1);
    ArrayPush(this.m_filters, 3);
    ArrayPush(this.m_filters, 4);
    ArrayPush(this.m_filters, 6);
    ArrayPush(this.m_filters, 7);
    super.SetupFilters();
  }

  protected func UpdateItemPreview(craftableController: ref<CraftableItemLogicController>) -> Void {
    let selectedRecipe: ref<RecipeData>;
    this.m_progressButtonController.Reset();
    selectedRecipe = FromVariant<ref<IScriptable>>(craftableController.GetData()) as RecipeData;
    this.UpdateRecipePreviewPanel(selectedRecipe);
  }

  private final func UpdateRecipePreviewPanel(selectedRecipe: ref<RecipeData>) -> Void {
    let buttonState: EProgressBarState;
    let isWeapon: Bool;
    let previewEvent: ref<CraftingItemPreviewEvent>;
    this.m_selectedRecipe.isSelected = false;
    if selectedRecipe == null {
      inkWidgetRef.SetVisible(this.m_itemDetailsContainer, false);
      return;
    };
    inkWidgetRef.SetVisible(this.m_itemDetailsContainer, true);
    this.DryMakeItem(selectedRecipe);
    isWeapon = InventoryItemData.IsWeapon(this.m_selectedItemData);
    inkWidgetRef.SetVisible(this.m_weaponPreviewContainer, isWeapon);
    inkWidgetRef.SetVisible(this.m_itemPreviewContainer, !isWeapon);
    if this.m_selectedRecipe.id != selectedRecipe.id {
      previewEvent = new CraftingItemPreviewEvent();
      previewEvent.itemID = isWeapon ? this.m_selectedItemGameData.GetID() : ItemID.None();
      this.QueueEvent(previewEvent);
    };
    this.m_selectedRecipe = selectedRecipe;
    this.m_selectedRecipe.isSelected = true;
    this.SetupIngredients(this.m_craftingSystem.GetItemCraftingCost(this.m_selectedItemGameData), 1);
    this.UpdateTooltipData();
    this.SetQualityHeader();
    this.m_playerCraftBook.SetRecipeInspected(this.m_selectedRecipe.id.GetID());
    this.m_isCraftable = this.m_craftingSystem.CanItemBeCrafted(this.m_selectedItemGameData);
    buttonState = this.m_isCraftable ? EProgressBarState.Available : EProgressBarState.Blocked;
    this.m_progressButtonController.SetAvaibility(buttonState);
    inkWidgetRef.SetVisible(this.m_blockedText, !this.m_isCraftable);
    if !this.m_isCraftable {
      this.SetNotification(false);
    };
  }

  private final func DryMakeItem(selectedRecipe: ref<RecipeData>) -> Void {
    let item: InventoryItemData;
    let itemModParams: ItemModParams;
    let player: wref<PlayerPuppet> = this.m_craftingGameController.GetPlayer();
    let craftedItemID: ItemID = ItemID.FromTDBID(selectedRecipe.id.GetID());
    itemModParams.itemID = craftedItemID;
    itemModParams.quantity = 1;
    let itemData: ref<gameItemData> = Inventory.CreateItemData(itemModParams, player);
    CraftingSystem.SetItemLevel(player, itemData);
    CraftingSystem.MarkItemAsCrafted(player, itemData);
    itemData.SetDynamicTag(n"SkipActivityLog");
    item = this.m_craftingGameController.GetInventoryManager().GetInventoryItemDataForDryItem(itemData);
    this.m_selectedItemGameData = itemData;
    this.m_selectedItemData = item;
  }

  private final func GetMinimalInvetoryItemData() -> ref<MinimalItemTooltipData> {
    let statusManager: ref<UIInventoryItemStatsManager>;
    let data: ref<MinimalItemTooltipData> = this.m_inventoryManager.GetMinimalTooltipDataForInventoryItem(this.m_selectedItemData, false, null, false, false);
    let itemType: gamedataItemType = InventoryItemData.GetItemType(this.m_selectedItemData);
    let itemRecord: wref<Item_Record> = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(InventoryItemData.GetID(this.m_selectedItemData)));
    let itemCategory: gamedataItemCategory = itemRecord.ItemCategory().Type();
    if NotEquals(itemCategory, gamedataItemCategory.Weapon) {
      statusManager = UIInventoryItemStatsManager.FromMinimalItemTooltipDataToTooltipStats(data);
      data.GetStatsManager().SetTooltipsStats(statusManager.TooltipStats);
    };
    if RPGManager.IsScopeAttachment(itemType) || RPGManager.IsMuzzleAttachment(itemType) {
      this.HideMods(data);
    };
    data.ammoCount = GameInstance.GetTransactionSystem(this.m_Game).GetItemQuantity(this.m_Player, InventoryItemData.GetID(this.m_selectedItemData));
    data.displayContext = InventoryTooltipDisplayContext.Crafting;
    return data;
  }

  private final func HideMods(data: ref<MinimalItemTooltipData>) -> Void {
    ArrayClear(data.mods);
  }

  private final func UpdateTooltipData() -> Void {
    let isQuickHack: Bool = this.IsQuickHackItem();
    if isQuickHack {
      if this.m_quickHackTooltipController == null && !this.m_hasSpawnedQuickHackTooltip {
        this.AsyncSpawnFromExternal(inkWidgetRef.Get(this.m_tooltipContainer), r"base\\gameplay\\gui\\common\\tooltip\\programtooltip.inkwidget", n"programTooltip", this, n"OnQuickHackTooltipSpawned");
        this.m_hasSpawnedQuickHackTooltip = true;
        return;
      };
      this.EnableQuickHackTooltip();
      return;
    };
    if this.m_itemTooltipController == null && !this.m_hasSpawnedTooltip {
      this.SpawnItemTooltipAsync(inkWidgetRef.Get(this.m_tooltipContainer), this, n"OnItemTooltipSpawned");
      this.m_hasSpawnedTooltip = true;
      return;
    };
    this.EnableMainTooltip();
  }

  protected cb func OnItemTooltipSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
    this.m_itemTooltipController = widget.GetController() as AGenericTooltipController;
    this.EnableMainTooltip();
  }

  protected cb func OnQuickHackTooltipSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
    this.m_quickHackTooltipController = widget.GetController() as AGenericTooltipController;
    this.EnableQuickHackTooltip();
  }

  private final func EnableQuickHackTooltip() -> Void {
    this.ToggleMainTooltip(false);
    this.ToggleQuickHackTooltip(true);
  }

  private final func EnableMainTooltip() -> Void {
    this.ToggleMainTooltip(true);
    this.ToggleQuickHackTooltip(false);
  }

  private final func ToggleMainTooltip(isEnabled: Bool) -> Void {
    if this.m_itemTooltipController != null {
      this.m_tooltipData = this.GetMinimalInvetoryItemData();
      this.m_itemTooltipController.SetData(this.m_tooltipData);
      this.m_itemTooltipController.GetRootWidget().SetVisible(isEnabled);
    };
  }

  private final func ToggleQuickHackTooltip(isEnabled: Bool) -> Void {
    if this.m_quickHackTooltipController != null {
      this.m_tooltipData = this.GetQuickHackTooltipData(this.m_selectedRecipe, this.m_selectedItemData, this.m_selectedItemGameData);
      this.m_quickHackTooltipController.SetData(this.m_tooltipData);
      this.m_quickHackTooltipController.GetRootWidget().SetVisible(isEnabled);
    };
  }

  private final func SetQualityHeader() -> Void {
    let isIconic: Bool;
    let isPlus: Float;
    let plusLabel: String;
    let quality: gamedataQuality;
    let qualityName: CName;
    let rarityItemType: RarityItemType;
    let rarityLabel: String;
    let iconicLabel: String = GetLocalizedText(UIItemsHelper.QualityToDefaultString(gamedataQuality.Iconic));
    let itemData: wref<gameItemData> = InventoryItemData.GetGameItemData(this.m_selectedItemData);
    if itemData.HasTag(n"ChimeraMod") {
      quality = gamedataQuality.Iconic;
      plusLabel = iconicLabel;
    } else {
      isIconic = RPGManager.IsItemIconic(itemData);
      isPlus = RPGManager.GetItemPlus(itemData);
      quality = this.GetQuality();
      rarityItemType = UIItemsHelper.ItemTypeToRarity(InventoryItemData.GetItemType(this.m_selectedItemData), itemData);
      rarityLabel = GetLocalizedText(UIItemsHelper.QualityToDefaultString(quality, rarityItemType));
      plusLabel = rarityLabel;
      if isPlus >= 2.00 {
        plusLabel += "++";
      } else {
        if isPlus >= 1.00 {
          plusLabel += "+";
        };
      };
      if isIconic {
        plusLabel += " / " + iconicLabel;
      };
    };
    inkTextRef.SetText(this.m_itemQuality, plusLabel);
    qualityName = UIItemsHelper.QualityEnumToName(quality);
    inkWidgetRef.SetState(this.m_itemQuality, qualityName);
    inkTextRef.SetText(this.m_itemName, this.m_selectedRecipe.label);
    inkWidgetRef.SetState(this.m_itemName, qualityName);
  }

  private final func SetNotification(isQuickHack: Bool) -> Void {
    let hasAmmoCap: Bool;
    let hasEnoughIngredients: Bool;
    let levelParams: ref<inkTextParams>;
    let levelRequired: Int32;
    let playerLevel: Float;
    let quality: gamedataQuality;
    if isQuickHack {
      inkTextRef.SetText(this.m_blockedText, "LocKey#78498");
      this.m_notificationType = UIMenuNotificationType.CraftingQuickhack;
      return;
    };
    quality = this.GetQuality();
    levelRequired = CraftingLogicController.GetMinimumLevelRequiredByQuality(quality);
    playerLevel = this.m_craftingGameController.GetPlayerLevel();
    if playerLevel < Cast<Float>(levelRequired) {
      levelParams = new inkTextParams();
      levelParams.AddNumber("int_0", levelRequired);
      inkTextRef.SetText(this.m_blockedText, "LocKey#87105", levelParams);
      this.m_notificationType = UIMenuNotificationType.PlayerReqLevelToLow;
      return;
    };
    hasEnoughIngredients = this.m_craftingSystem.EnoughIngredientsForCrafting(InventoryItemData.GetGameItemData(this.m_selectedItemData));
    if !hasEnoughIngredients {
      inkTextRef.SetText(this.m_blockedText, "LocKey#42797");
      this.m_notificationType = UIMenuNotificationType.CraftingNotEnoughMaterial;
      return;
    };
    hasAmmoCap = this.HasAmmoCap();
    if hasAmmoCap {
      inkTextRef.SetText(this.m_blockedText, "LocKey#81496");
      this.m_notificationType = UIMenuNotificationType.CraftingAmmoCap;
      return;
    };
  }

  private final func HasAmmoCap() -> Bool {
    let itemData: wref<gameItemData> = InventoryItemData.GetGameItemData(this.m_selectedItemData);
    let maxCraftingAmount: Int32 = this.m_craftingSystem.GetMaxCraftingAmount(itemData);
    return maxCraftingAmount == 0;
  }

  private final func GetQuality() -> gamedataQuality {
    let qualityName: CName = InventoryItemData.GetQuality(this.m_selectedItemData);
    return UIItemsHelper.QualityNameToEnum(qualityName);
  }

  private final static func GetMinimumLevelRequiredByQuality(quality: gamedataQuality) -> Int32 {
    switch quality {
      case gamedataQuality.Uncommon:
        return 1;
      case gamedataQuality.Rare:
        return 1;
      case gamedataQuality.Epic:
        return 1;
      case gamedataQuality.Legendary:
        return 1;
      default:
        return 1;
    };
  }

  private final func SetupIngredients(const ingredient: script_ref<[IngredientData]>, itemAmount: Int32) -> Void {
    let controller: wref<IngredientListItemLogicController>;
    let data: IngredientData;
    let i: Int32;
    let isInInventory: Bool;
    let itemData: InventoryItemData;
    let ingredientCount: Int32 = ArraySize(Deref(ingredient));
    inkWidgetRef.SetVisible(this.m_ingredientsWeaponContainer, false);
    this.m_ingredientClothingController.GetRootWidget().SetVisible(false);
    i = 0;
    while i < ingredientCount {
      data = Deref(ingredient)[i];
      itemData = this.GetInventoryItemDataFromRecord(data.id);
      controller = this.m_ingredientsControllerList[i];
      if RPGManager.IsItemWeapon(InventoryItemData.GetID(itemData)) {
        inkWidgetRef.SetVisible(this.m_ingredientsWeaponContainer, true);
        this.m_ingredientWeaponController.Setup(itemData);
        controller.SetUnusedState();
        isInInventory = RPGManager.HasItem(this.m_craftingGameController.GetPlayer(), ItemID.GetTDBID(InventoryItemData.GetID(itemData)));
        this.m_ingredientWeaponController.GetRootWidget().SetState(isInInventory ? n"Default" : n"Unavailable");
      } else {
        if RPGManager.IsItemClothing(InventoryItemData.GetID(itemData)) {
          this.m_ingredientClothingController.GetRootWidget().SetVisible(true);
          this.m_ingredientClothingController.Setup(itemData);
          isInInventory = RPGManager.HasItem(this.m_craftingGameController.GetPlayer(), ItemID.GetTDBID(InventoryItemData.GetID(itemData)));
          this.m_ingredientClothingController.GetRootWidget().SetState(isInInventory ? n"Default" : n"Unavailable");
          controller.SetUnusedState();
        } else {
          controller.SetupData(Deref(ingredient)[i], this.m_tooltipsManager, itemAmount);
        };
      };
      i += 1;
    };
    i = ingredientCount;
    while i < this.m_maxIngredientCount {
      controller = this.m_ingredientsControllerList[i];
      controller.SetUnusedState();
      i += 1;
    };
  }

  protected cb func OnDisplayHoverOver(hoverOverEvent: ref<ItemDisplayHoverOverEvent>) -> Bool {
    let tooltipData: ref<MaterialTooltipData> = new MaterialTooltipData();
    if Equals(hoverOverEvent.display.GetDisplayContext(), ItemDisplayContext.None) {
      tooltipData.Title = GetLocalizedText(InventoryItemData.GetName(hoverOverEvent.itemData));
      this.m_tooltipsManager.ShowTooltipAtWidget(n"materialTooltip", hoverOverEvent.widget, tooltipData, gameuiETooltipPlacement.RightTop, true);
    };
  }

  public func OnChangeTab(isCurrent: Bool) -> Void {
    super.OnChangeTab(isCurrent);
    this.m_quantityPickerPopupToken = null;
    this.m_selectedRecipe = null;
  }

  private final func OpenQuantityPicker(const itemData: script_ref<InventoryItemData>, maxQuantity: Int32) -> Void {
    let data: ref<QuantityPickerPopupData> = new QuantityPickerPopupData();
    data.notificationName = n"base\\gameplay\\gui\\widgets\\notifications\\item_quantity_picker.inkwidget";
    data.isBlocking = true;
    data.useCursor = true;
    data.queueName = n"modal_popup";
    data.maxValue = maxQuantity;
    data.gameItemData = Deref(itemData);
    data.actionType = QuantityPickerActionType.Craft;
    data.sendQuantityChangedEvent = true;
    this.m_quantityPickerPopupToken = this.m_craftingGameController.ShowGameNotification(data);
    if IsDefined(this.m_quantityPickerPopupToken) {
      this.m_quantityPickerPopupToken.RegisterListener(this, n"OnQuantityPickerEvent");
    };
    this.m_buttonHintsController.Hide();
  }

  protected cb func OnQuantityPickerEvent(data: ref<inkGameNotificationData>) -> Bool {
    let closeData: ref<QuantityPickerPopupCloseData> = data as QuantityPickerPopupCloseData;
    let quantityData: ref<PickerChoosenQuantityChangedEvent> = data as PickerChoosenQuantityChangedEvent;
    if closeData != null {
      this.m_quantityPickerPopupToken = null;
      if closeData.choosenQuantity != -1 {
        this.CraftItem(this.m_selectedRecipe, closeData.choosenQuantity);
        this.m_buttonHintsController.Show();
      };
    };
    if quantityData != null {
      this.SetupIngredients(this.m_craftingSystem.GetItemCraftingCost(this.m_selectedItemGameData), quantityData.choosenQuantity);
    };
  }

  protected cb func OnHoldFinished(evt: ref<ProgressBarFinishedProccess>) -> Bool {
    let quantity: Int32;
    if !this.m_isPanelOpen {
      return false;
    };
    this.PlaySound(n"Item", n"OnCrafted");
    this.PlayRumble(RumbleStrength.Heavy, RumbleType.Pulse, RumblePosition.Right);
    if this.m_selectedRecipe.id.TagsContains(n"Consumable") && !this.m_selectedRecipe.id.TagsContains(n"Medical") || this.m_selectedRecipe.id.TagsContains(n"Ammo") || Equals(InventoryItemData.GetItemType(this.m_selectedRecipe.inventoryItem), gamedataItemType.Gen_CraftingMaterial) {
      quantity = this.m_craftingSystem.GetMaxCraftingAmount(InventoryItemData.GetGameItemData(this.m_selectedItemData));
      if this.m_selectedRecipe.id.TagsContains(n"Ammo") && quantity == 0 {
        return false;
      };
      if quantity > 1 {
        this.OpenQuantityPicker(this.m_selectedItemData, quantity);
        return true;
      };
    };
    if this.m_selectedRecipe.id.TagsContains(n"Ammo") {
      this.CraftItem(this.m_selectedRecipe, 1);
    } else {
      this.CraftItem(this.m_selectedRecipe, this.m_selectedRecipe.amount);
    };
  }

  protected func SetItemButtonHintsHoverOver(evt: ref<inkPointerEvent>) -> Void {
    if this.m_isCraftable {
      this.m_buttonHintsController.AddButtonHint(n"craft_item", GetLocalizedText("UI-Crafting-hold_to_craft"));
    };
  }

  private final func GetRecipesList() -> [ref<IScriptable>] {
    let i: Int32;
    let itemRecord: wref<Item_Record>;
    let itemRecordList: array<wref<Item_Record>>;
    let recipeData: ref<RecipeData>;
    let recipeDataList: array<ref<IScriptable>>;
    this.m_playerCraftBook.HideRecipesForOwnedItems();
    itemRecordList = this.m_playerCraftBook.GetCraftableItems();
    i = 0;
    while i < ArraySize(itemRecordList) {
      itemRecord = itemRecordList[i];
      if IsDefined(itemRecord) {
        recipeData = this.m_craftingSystem.GetRecipeData(itemRecord);
        recipeData.isNew = this.m_playerCraftBook.IsRecipeNew(recipeData.id.GetID());
        recipeData.isCraftable = this.m_craftingSystem.CanItemBeCrafted(itemRecord);
        recipeData.inventoryItem = this.m_inventoryManager.GetInventoryItemDataFromItemRecord(recipeData.id);
        InventoryItemData.SetQuality(recipeData.inventoryItem, UIItemsHelper.QualityEnumToName(itemRecord.Quality().Type()));
        this.m_inventoryManager.GetOrCreateInventoryItemSortData(recipeData.inventoryItem, this.m_craftingGameController.GetScriptableSystem());
        ArrayPush(recipeDataList, recipeData);
      };
      i += 1;
    };
    return recipeDataList;
  }

  private final func GetInventoryItemDataFromRecord(itemRecord: ref<Item_Record>) -> InventoryItemData {
    let itemData: InventoryItemData = this.m_inventoryManager.GetInventoryItemDataFromItemRecord(itemRecord);
    this.m_inventoryManager.GetOrCreateInventoryItemSortData(itemData, this.m_craftingGameController.GetScriptableSystem());
    return itemData;
  }

  private final func GetQuickHackTooltipData(recipeData: ref<RecipeData>, inventoryItemData: InventoryItemData, gameData: ref<gameItemData>) -> ref<ATooltipData> {
    let tooltipData: ref<InventoryTooltipData> = InventoryTooltipData.FromRecipeAndItemData(this.m_craftingGameController.GetPlayer().GetGame(), recipeData, inventoryItemData, inventoryItemData, gameData);
    InventoryItemData.SetGameItemData(tooltipData.inventoryItemData, gameData);
    if Equals(InventoryItemData.GetItemType(inventoryItemData), gamedataItemType.Prt_Program) {
      tooltipData.quickhackData = this.m_inventoryManager.GetQuickhackTooltipData(ItemID.GetTDBID(InventoryItemData.GetID(inventoryItemData)));
    };
    return tooltipData;
  }

  private final func IsQuickHackItem() -> Bool {
    return Equals(this.m_selectedItemData.ItemType, gamedataItemType.Prt_Program);
  }

  private final func CraftItem(selectedRecipe: ref<RecipeData>, amount: Int32) -> Void {
    let craftItemRequest: ref<CraftItemRequest>;
    if NotEquals(selectedRecipe.label, "") {
      craftItemRequest = new CraftItemRequest();
      craftItemRequest.target = this.m_craftingGameController.GetPlayer();
      craftItemRequest.itemRecord = selectedRecipe.id;
      craftItemRequest.amount = amount;
      if selectedRecipe.id.TagsContains(n"Ammo") {
        craftItemRequest.bulletAmount = selectedRecipe.amount;
      };
      this.m_craftingSystem.QueueRequest(craftItemRequest);
    };
    if this.m_selectedRecipe.id.TagsContains(n"Medical") || this.m_selectedRecipe.id.TagsContains(n"Grenade") || this.m_selectedRecipe.id.TagsContains(n"CraftableIconic") && !this.m_selectedRecipe.id.TagsContains(n"Haunted_Gun") {
      DelayedReset.CreateAndDispatch(this, this.m_Player, this.m_timeUntilReset);
    };
  }

  public final func ResetViewDelayed() -> Void {
    inkWidgetRef.SetVisible(this.m_itemDetailsContainer, false);
    this.m_selectedRecipe = null;
  }

  protected cb func OnItemDisplayHoverOver(evt: ref<ItemDisplayHoverOverEvent>) -> Bool {
    if !InventoryItemData.IsEmpty(evt.itemData) {
      this.m_playerCraftBook.SetRecipeInspected(ItemID.GetTDBID(InventoryItemData.GetID(evt.itemData)));
    };
  }

  protected cb func OnUninitialize() -> Bool {
    if IsDefined(this.m_selectedItemGameData) {
      this.m_selectedItemGameData = null;
    };
    super.OnUninitialize();
  }
}

public class DelayedReset extends DelayCallback {

  private let m_controller: wref<CraftingLogicController>;

  public final static func CreateAndDispatch(controller: wref<CraftingLogicController>, player: wref<PlayerPuppet>, time: Float) -> Void {
    let callback: ref<DelayedReset> = new DelayedReset();
    callback.m_controller = controller;
    GameInstance.GetDelaySystem(player.GetGame()).DelayCallback(callback, time, false);
  }

  public func Call() -> Void {
    this.m_controller.ResetViewDelayed();
  }
}
