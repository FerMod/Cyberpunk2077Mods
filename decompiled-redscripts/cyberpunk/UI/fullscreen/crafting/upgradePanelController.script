
public class UpgradingScreenController extends CraftingMainLogicController {

  private edit let m_itemNameUpgrade: inkTextRef;

  private edit let m_arrowComparison: inkWidgetRef;

  private let m_itemTooltipControllerLeft: wref<AGenericTooltipController>;

  private let m_itemTooltipControllerRight: wref<AGenericTooltipController>;

  private let m_tooltipDataLeft: ref<MinimalItemTooltipData>;

  private let m_tooltipDataRight: ref<MinimalItemTooltipData>;

  private let m_WeaponAreas: [gamedataItemType];

  private let m_EquipAreas: [gamedataEquipmentArea];

  @default(UpgradingScreenController, 0.15f)
  private const let DELAYED_TOOLTIP_RIGHT: Float;

  public func Init(craftingGameController: wref<CraftingMainGameController>) -> Void {
    super.Init(craftingGameController);
    this.SetCraftingButton("UI-Crafting-Upgrade");
    this.m_EquipAreas = InventoryDataManagerV2.GetInventoryEquipmentAreas();
    this.m_WeaponAreas = InventoryDataManagerV2.GetInventoryWeaponTypes();
    this.SpawnItemTooltipAsync(inkWidgetRef.Get(this.m_tooltipContainer), this, n"OnItemTooltipSpawnedLeft");
    this.SpawnItemTooltipAsync(inkWidgetRef.Get(this.m_tooltipContainer), this, n"OnItemTooltipSpawnedRight");
    this.m_hasSpawnedTooltip = true;
  }

  public func RefreshListViewContent(opt inventoryItemData: InventoryItemData) -> Void {
    this.m_dataSource.Clear();
    this.m_dataSource.Reset(this.GetUpgradableList());
    if this.IsEmptyData() {
      this.HideContent();
      return;
    };
    if !inventoryItemData.Empty {
      this.UpdateItemPreviewPanel(inventoryItemData);
    } else {
      this.UpdateItemPreviewPanel(this.m_selectedItemData);
    };
  }

  private final func HideContent() -> Void {
    inkWidgetRef.SetVisible(this.m_itemDetailsContainer, false);
    this.m_isCraftable = false;
    inkWidgetRef.SetVisible(this.m_blockedText, !this.m_isCraftable);
    inkWidgetRef.SetVisible(this.m_arrowComparison, this.m_isCraftable);
    inkWidgetRef.SetVisible(this.m_progressBarContainer, this.m_isCraftable);
    inkWidgetRef.SetVisible(this.m_progressButtonContainer, this.m_isCraftable);
    this.m_progressButtonController.SetAvaibility(EProgressBarState.Invisible);
  }

  protected func SetupFilters() -> Void {
    ArrayPush(this.m_filters, 15);
    ArrayPush(this.m_filters, 0);
    ArrayPush(this.m_filters, 1);
    super.SetupFilters();
  }

  protected func UpdateItemPreview(craftableController: ref<CraftableItemLogicController>) -> Void {
    let selectedItem: InventoryItemData;
    this.m_progressButtonController.Reset();
    selectedItem = FromVariant<ref<IScriptable>>(craftableController.GetData()) as ItemCraftingData.inventoryItem;
    this.UpdateItemPreviewPanel(selectedItem);
  }

  private final func UpdateItemPreviewPanel(const selectedItem: script_ref<InventoryItemData>) -> Void {
    let buttonState: EProgressBarState;
    let itemQuality: gamedataQuality = RPGManager.GetItemTierForUpgrades(InventoryItemData.GetGameItemData(selectedItem));
    let isMaxed: Bool = this.IsItemMaxedLevel(itemQuality);
    if Deref(selectedItem).Empty || isMaxed {
      inkWidgetRef.SetVisible(this.m_itemDetailsContainer, false);
      return;
    };
    inkWidgetRef.SetVisible(this.m_itemDetailsContainer, true);
    this.m_selectedItemData = Deref(selectedItem);
    this.m_selectedRecipe = this.m_craftingSystem.GetUpgradeRecipeData(this.m_selectedItemData.ID);
    this.SetupIngredients(this.m_selectedRecipe.ingredients);
    this.m_isCraftable = this.IsUpgradable(this.m_selectedItemData, true);
    this.UpdateTooltipData();
    this.SetItemNames();
    buttonState = this.m_isCraftable ? EProgressBarState.Available : EProgressBarState.Blocked;
    inkWidgetRef.SetVisible(this.m_blockedText, !this.m_isCraftable);
    inkWidgetRef.SetVisible(this.m_arrowComparison, this.m_isCraftable);
    this.m_progressButtonController.SetAvaibility(buttonState);
  }

  private final func SetupIngredients(const ingredient: script_ref<[IngredientData]>) -> Void {
    let controller: wref<IngredientListItemLogicController>;
    let ingredientCount: Int32 = ArraySize(Deref(ingredient));
    let i: Int32 = 0;
    while i < ingredientCount {
      controller = this.m_ingredientsControllerList[i];
      controller.SetupData(Deref(ingredient)[i], this.m_tooltipsManager, 1);
      i += 1;
    };
    i = ingredientCount;
    while i < this.m_maxIngredientCount {
      controller = this.m_ingredientsControllerList[i];
      controller.SetUnusedState();
      i += 1;
    };
  }

  private final func UpdateTooltipData() -> Void {
    let delayedCall: ref<DelayedTooltipCall> = this.CreateDelayedCall();
    let itemQuality: gamedataQuality = RPGManager.GetItemQuality(InventoryItemData.GetGameItemData(this.m_selectedItemData));
    let isQualityShown: Bool = this.IsQualityShown(itemQuality);
    if this.m_isCraftable || isQualityShown {
      this.UpdateTooltipLeft();
      this.m_DelaySystem.DelayCallback(delayedCall, this.DELAYED_TOOLTIP_RIGHT, false);
      return;
    };
    this.HideTooltips();
  }

  private final func CreateDelayedCall() -> ref<DelayedTooltipCall> {
    let delay: ref<DelayedTooltipCall> = new DelayedTooltipCall();
    delay.m_controller = this;
    return delay;
  }

  private final func UpdateTooltipLeft() -> Void {
    this.m_tooltipDataLeft = this.m_inventoryManager.GetMinimalTooltipDataForInventoryItem(this.m_selectedItemData, false, null, false);
    this.m_tooltipDataLeft.displayContext = InventoryTooltipDisplayContext.Upgrading;
    this.m_itemTooltipControllerLeft.SetData(this.m_tooltipDataLeft);
  }

  public final func UpdateTooltipRightAndShow() -> Void {
    this.ApplyQualityModifier(1.00);
    this.m_tooltipDataRight = this.m_inventoryManager.GetMinimalTooltipDataForInventoryItem(this.m_selectedItemData, false, null, false);
    this.m_tooltipDataRight.isEquipped = false;
    this.m_tooltipDataRight.price = Cast<Float>(RPGManager.CalculateSellPriceItemData(this.m_Game, this.m_Player, InventoryItemData.GetGameItemData(this.m_selectedItemData)));
    this.m_tooltipDataRight.displayContext = InventoryTooltipDisplayContext.Upgrading;
    this.FillBarsComparisonData(this.m_tooltipDataLeft, this.m_tooltipDataRight);
    this.m_itemTooltipControllerRight.SetData(this.m_tooltipDataRight);
    this.ApplyQualityModifier(-1.00);
    this.ShowTooltips();
  }

  private final func ShowTooltips() -> Void {
    if IsDefined(this.m_itemTooltipControllerLeft) {
      this.m_itemTooltipControllerLeft.Show();
    };
    if IsDefined(this.m_itemTooltipControllerRight) {
      this.m_itemTooltipControllerRight.Show();
    };
  }

  private final func HideTooltips() -> Void {
    if IsDefined(this.m_itemTooltipControllerLeft) {
      this.m_itemTooltipControllerLeft.Hide();
    };
    if IsDefined(this.m_itemTooltipControllerRight) {
      this.m_itemTooltipControllerRight.Hide();
    };
  }

  private final func FillBarsComparisonData(tooltipDataLeft: ref<MinimalItemTooltipData>, tooltipDataRight: ref<MinimalItemTooltipData>) -> Void {
    let statsManagerLeft: wref<UIInventoryItemStatsManager> = tooltipDataLeft.GetStatsManager();
    let statsManagerRight: wref<UIInventoryItemStatsManager> = tooltipDataRight.GetStatsManager();
    let weaponBarsLeft: wref<UIInventoryItemWeaponBars> = statsManagerLeft.GetWeaponBars();
    let weaponBarsRight: wref<UIInventoryItemWeaponBars> = statsManagerRight.GetWeaponBars();
    weaponBarsRight.SetComparedBars(weaponBarsLeft);
  }

  private final func ApplyQualityModifier(multiplier: Float) -> Void {
    let mod: ref<gameStatModifierData>;
    let itemData: wref<gameItemData> = InventoryItemData.GetGameItemData(this.m_selectedItemData);
    let qualityOld: Float = itemData.GetStatValueByType(gamedataStatType.WasItemUpgraded);
    let qualityNew: Float = qualityOld + 1.00 * multiplier;
    this.m_StatsSystem.RemoveAllModifiers(itemData.GetStatsObjectID(), gamedataStatType.WasItemUpgraded, true);
    mod = RPGManager.CreateStatModifier(gamedataStatType.WasItemUpgraded, gameStatModifierType.Additive, qualityNew);
    this.m_StatsSystem.AddSavedModifier(itemData.GetStatsObjectID(), mod);
  }

  protected cb func OnItemTooltipSpawnedLeft(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
    let tooltipController: ref<AGenericTooltipController> = widget.GetController() as AGenericTooltipController;
    tooltipController.Hide();
    this.m_itemTooltipControllerLeft = tooltipController;
  }

  protected cb func OnItemTooltipSpawnedRight(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
    let tooltipController: ref<AGenericTooltipController> = widget.GetController() as AGenericTooltipController;
    tooltipController.Hide();
    this.m_itemTooltipControllerRight = tooltipController;
  }

  private final func SetItemNames() -> Void {
    let itemQuality: gamedataQuality = RPGManager.GetItemQuality(InventoryItemData.GetGameItemData(this.m_selectedItemData));
    let isShown: Bool = this.IsQualityShown(itemQuality);
    inkWidgetRef.SetVisible(this.m_itemName, isShown);
    inkWidgetRef.SetVisible(this.m_itemNameUpgrade, false);
    inkTextRef.SetText(this.m_itemName, this.m_selectedItemData.Name);
    inkTextRef.SetText(this.m_itemNameUpgrade, this.m_selectedRecipe.label);
  }

  private final func IsQualityShown(itemQuality: gamedataQuality) -> Bool {
    return Equals(itemQuality, gamedataQuality.CommonPlus) || Equals(itemQuality, gamedataQuality.UncommonPlus) || Equals(itemQuality, gamedataQuality.RarePlus) || Equals(itemQuality, gamedataQuality.EpicPlus) || Equals(itemQuality, gamedataQuality.Common) || Equals(itemQuality, gamedataQuality.Uncommon) || Equals(itemQuality, gamedataQuality.Rare) || Equals(itemQuality, gamedataQuality.Epic) || Equals(itemQuality, gamedataQuality.Legendary) || Equals(itemQuality, gamedataQuality.LegendaryPlus);
  }

  private final func IsItemMaxedLevel(itemQuality: gamedataQuality) -> Bool {
    return Equals(itemQuality, gamedataQuality.LegendaryPlusPlus);
  }

  private final func IsLastUpgrade(itemQuality: gamedataQuality) -> Bool {
    return Equals(itemQuality, gamedataQuality.LegendaryPlus);
  }

  private final func SetItemQualities() -> Void {
    let qualityUpgradeType: gamedataQuality = RPGManager.GetNextItemQuality(InventoryItemData.GetGameItemData(this.m_selectedItemData));
    let qualityUpgradeName: CName = UIItemsHelper.QualityEnumToName(qualityUpgradeType);
    let qualityNormalName: CName = this.m_selectedItemData.Quality;
    inkWidgetRef.SetState(this.m_itemName, qualityNormalName);
    inkWidgetRef.SetState(this.m_itemNameUpgrade, qualityUpgradeName);
  }

  protected cb func OnHoldFinished(evt: ref<ProgressBarFinishedProccess>) -> Bool {
    if !this.m_isPanelOpen {
      return false;
    };
    this.UpgradeItem(this.m_selectedItemData);
    this.PlaySound(n"Item", n"OnCrafted");
    this.PlayRumble(RumbleStrength.Heavy, RumbleType.Pulse, RumblePosition.Right);
  }

  protected func SetItemButtonHintsHoverOver(evt: ref<inkPointerEvent>) -> Void {
    if this.m_isCraftable {
      this.m_buttonHintsController.AddButtonHint(n"craft_item", GetLocalizedText("UI-Crafting-hold_to_upgrade"));
    };
  }

  private final func GetUpgradableList() -> [ref<IScriptable>] {
    let i: Int32;
    let itemArrayHolder: array<ref<IScriptable>>;
    this.m_inventoryManager.MarkToRebuild();
    i = 0;
    while i < ArraySize(this.m_WeaponAreas) {
      this.FillInventoryData(this.m_inventoryManager.GetPlayerIconicWeaponsByType(this.m_WeaponAreas[i]), itemArrayHolder);
      i += 1;
    };
    return itemArrayHolder;
  }

  private final func UpgradeItem(const selectedItemData: script_ref<InventoryItemData>) -> Void {
    let itemQuality: gamedataQuality = RPGManager.GetItemTierForUpgrades(InventoryItemData.GetGameItemData(this.m_selectedItemData));
    let isEmpty: Bool = this.IsEmptyData();
    let isLastUpgrade: Bool = this.IsLastUpgrade(itemQuality);
    let upgradeItemRequest: ref<UpgradeItemRequest> = new UpgradeItemRequest();
    upgradeItemRequest.owner = this.m_craftingGameController.GetPlayer();
    upgradeItemRequest.itemID = Deref(selectedItemData).ID;
    this.m_craftingSystem.QueueRequest(upgradeItemRequest);
    if isLastUpgrade && !isEmpty {
      this.DispatchSelectDelayed(0u);
    };
  }

  public func OnChangeTab(isCurrent: Bool) -> Void {
    super.OnChangeTab(isCurrent);
    this.m_selectedRecipe = null;
  }

  private final func FillInventoryData(const itemDataHolder: script_ref<[InventoryItemData]>, itemArrayHolder: script_ref<[ref<IScriptable>]>) -> Void {
    let itemData: ref<gameItemData>;
    let itemWrapper: ref<ItemCraftingData>;
    let i: Int32 = 0;
    while i < ArraySize(Deref(itemDataHolder)) {
      itemWrapper = new ItemCraftingData();
      itemWrapper.inventoryItem = Deref(itemDataHolder)[i];
      itemData = InventoryItemData.GetGameItemData(Deref(itemDataHolder)[i]);
      itemWrapper.isUpgradable = this.IsUpgradable(Deref(itemDataHolder)[i], false);
      itemWrapper.isNew = this.m_craftingGameController.GetScriptableSystem().IsInventoryItemNew(Deref(itemDataHolder)[i].ID);
      if !RPGManager.IsItemMaxTier(itemData) {
        ArrayPush(Deref(itemArrayHolder), itemWrapper);
      };
      this.m_inventoryManager.GetOrCreateInventoryItemSortData(itemWrapper.inventoryItem, this.m_craftingGameController.GetScriptableSystem());
      i += 1;
    };
  }

  private final func IsUpgradable(const item: script_ref<InventoryItemData>, sendNotification: Bool) -> Bool {
    let levelParams: ref<inkTextParams>;
    let playerDevelopmentData: ref<PlayerDevelopmentData> = PlayerDevelopmentSystem.GetData(this.m_craftingGameController.GetPlayer());
    let pl_level: Int32 = playerDevelopmentData.GetProficiencyLevel(gamedataProficiencyType.Level);
    let it_level: Int32 = 1;
    let canUpgrade: Bool = this.m_craftingSystem.CanItemBeUpgraded(InventoryItemData.GetGameItemData(item)) && pl_level >= it_level;
    let isItemMaxTier: Bool = RPGManager.IsItemMaxTier(InventoryItemData.GetGameItemData(item));
    if sendNotification && !canUpgrade {
      if pl_level < it_level {
        levelParams = new inkTextParams();
        levelParams.AddNumber("int_0", it_level);
        inkTextRef.SetText(this.m_blockedText, "LocKey#78455", levelParams);
        this.m_notificationType = UIMenuNotificationType.UpgradingLevelToLow;
      } else {
        if !this.m_craftingSystem.EnoughIngredientsForUpgrading(InventoryItemData.GetGameItemData(item)) {
          inkTextRef.SetText(this.m_blockedText, "LocKey#42797");
          this.m_notificationType = UIMenuNotificationType.CraftingNotEnoughMaterial;
        } else {
          if isItemMaxTier {
            this.m_notificationType = UIMenuNotificationType.InventoryActionBlocked;
          };
        };
      };
    };
    return canUpgrade;
  }
}

public class DelayedTooltipCall extends DelayCallback {

  public let m_controller: wref<UpgradingScreenController>;

  public func Call() -> Void {
    if IsDefined(this.m_controller) {
      this.m_controller.UpdateTooltipRightAndShow();
    };
  }
}
