
public class UIScriptableSystem extends ScriptableSystem {

  private persistent let m_backpackActiveSorting: Int32;

  private persistent let m_backpackActiveFilter: Int32;

  private persistent let m_isBackpackActiveFilterSaved: Bool;

  private persistent let m_vendorPanelPlayerActiveSorting: Int32;

  private persistent let m_vendorPanelVendorActiveSorting: Int32;

  private persistent let m_playerFavouriteItems: [ItemID];

  private persistent let m_newItems: [ItemID];

  private persistent let m_DLCAddedItems: [TweakDBID];

  private persistent let m_newWardrobeSets: [gameWardrobeClothingSetIndex];

  private persistent let m_newWardrobeItems: [ItemID];

  private persistent let m_availableCars: [CName];

  private persistent let m_previousAttributeLevels: [UIScriptableSystemAttributeLevel];

  private persistent let m_comparisionTooltipDisabled: Bool;

  private let m_attachedPlayer: wref<PlayerPuppet>;

  private let m_inventoryListenerCallback: ref<UIScriptableInventoryListenerCallback>;

  private let m_inventoryListener: ref<InventoryScriptListener>;

  private persistent let m_DEV_useNewTooltips: Bool;

  @default(UIScriptableSystem, true)
  private persistent let m_DEV_useLongScanTooltips: Bool;

  private func OnAttach() -> Void {
    this.SetupInstance();
  }

  private func OnRestored(saveVersion: Int32, gameVersion: Int32) -> Void {
    this.SetupInstance();
  }

  private func OnDetach() -> Void {
    GameInstance.GetTransactionSystem(this.m_attachedPlayer.GetGame()).UnregisterInventoryListener(this.m_attachedPlayer, this.m_inventoryListener);
    this.m_inventoryListener = null;
  }

  private final func SetupInstance() -> Void {
    this.m_inventoryListenerCallback = new UIScriptableInventoryListenerCallback();
  }

  private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    if this.m_attachedPlayer != null {
      GameInstance.GetTransactionSystem(this.m_attachedPlayer.GetGame()).UnregisterInventoryListener(this.m_attachedPlayer, this.m_inventoryListener);
    };
    this.m_attachedPlayer = request.owner as PlayerPuppet;
    this.m_inventoryListener = GameInstance.GetTransactionSystem(this.m_attachedPlayer.GetGame()).RegisterInventoryListener(this.m_attachedPlayer, this.m_inventoryListenerCallback);
    this.m_inventoryListenerCallback.AttachScriptableSystem(this.m_attachedPlayer.GetGame());
  }

  public final static func GetInstance(gameInstance: GameInstance) -> ref<UIScriptableSystem> {
    let system: ref<UIScriptableSystem> = GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"UIScriptableSystem") as UIScriptableSystem;
    return system;
  }

  private final func OnSetBackpackSorting(request: ref<UIScriptableSystemSetBackpackSorting>) -> Void {
    this.m_backpackActiveSorting = request.sortMode;
  }

  private final func OnSetBackpackFilter(request: ref<UIScriptableSystemSetBackpackFilter>) -> Void {
    this.m_backpackActiveFilter = request.filterMode;
    this.m_isBackpackActiveFilterSaved = true;
  }

  private final func OnSetVendorPanelVendorSorting(request: ref<UIScriptableSystemSetVendorPanelVendorSorting>) -> Void {
    this.m_vendorPanelVendorActiveSorting = request.sortMode;
  }

  private final func OnSetVendorPanelPlayerSorting(request: ref<UIScriptableSystemSetVendorPanelPlayerSorting>) -> Void {
    this.m_vendorPanelPlayerActiveSorting = request.sortMode;
  }

  private final func OnComparisionTooltipDisabled(request: ref<UIScriptableSystemSetComparisionTooltipDisabled>) -> Void {
    this.m_comparisionTooltipDisabled = request.value;
  }

  private final func OnInventoryItemAdded(request: ref<UIScriptableSystemInventoryAddItem>) -> Void {
    if !ArrayContains(this.m_newItems, request.itemID) {
      ArrayPush(this.m_newItems, request.itemID);
    };
  }

  private final func OnInventoryItemRemoved(request: ref<UIScriptableSystemInventoryRemoveItem>) -> Void {
    if ArrayContains(this.m_newItems, request.itemID) {
      ArrayRemove(this.m_newItems, request.itemID);
    };
  }

  private final func OnInventoryItemInspected(request: ref<UIScriptableSystemInventoryInspectItem>) -> Void {
    if ArrayContains(this.m_newItems, request.itemID) {
      ArrayRemove(this.m_newItems, request.itemID);
    };
  }

  private final func OnDLCAddedItemInspected(request: ref<UIScriptableSystemDLCAddedItemInspected>) -> Void {
    if !ArrayContains(this.m_DLCAddedItems, request.itemTDBID) {
      ArrayPush(this.m_DLCAddedItems, request.itemTDBID);
    };
  }

  private final func OnWardrobeSetAdded(request: ref<UIScriptableSystemWardrobeSetAdded>) -> Void {
    if !ArrayContains(this.m_newWardrobeSets, request.wardrobeSet) {
      ArrayPush(this.m_newWardrobeSets, request.wardrobeSet);
    };
  }

  private final func OnWardrobeSetInspected(request: ref<UIScriptableSystemWardrobeSetInspected>) -> Void {
    if ArrayContains(this.m_newWardrobeSets, request.wardrobeSet) {
      ArrayRemove(this.m_newWardrobeSets, request.wardrobeSet);
    };
  }

  private final func OnWardrobeItemAdded(request: ref<UIScriptableSystemWardrobeAddItem>) -> Void {
    if !ArrayContains(this.m_newWardrobeItems, request.itemID) {
      ArrayPush(this.m_newWardrobeItems, request.itemID);
    };
  }

  private final func OnWardrobeItemInspected(request: ref<UIScriptableSystemWardrobeInspectItem>) -> Void {
    if ArrayContains(this.m_newWardrobeItems, request.itemID) {
      ArrayRemove(this.m_newWardrobeItems, request.itemID);
    };
  }

  private final func OnAvailableCarAdded(request: ref<UIScriptableSystemAddAvailableCar>) -> Void {
    if !ArrayContains(this.m_availableCars, request.carFact) {
      ArrayPush(this.m_availableCars, request.carFact);
    };
  }

  private final func OnSetItemPlayerFavourite(request: ref<UIScriptableSystemSetItemPlayerFavourite>) -> Void {
    if request.favourite {
      if !ArrayContains(this.m_playerFavouriteItems, request.itemID) {
        ArrayPush(this.m_playerFavouriteItems, request.itemID);
      };
    } else {
      ArrayRemove(this.m_playerFavouriteItems, request.itemID);
    };
  }

  private final func OnSetPreviousAttributeLevel(request: ref<UIScriptableSystemSetPreviousAttributeLevel>) -> Void {
    let attributeLevel: UIScriptableSystemAttributeLevel;
    let set: Bool;
    let i: Int32 = 0;
    let limit: Int32 = ArraySize(this.m_previousAttributeLevels);
    while i < limit {
      if Equals(this.m_previousAttributeLevels[i].m_stat, request.stat) {
        this.m_previousAttributeLevels[i].m_level = request.level;
        set = true;
      };
      i += 1;
    };
    if !set {
      attributeLevel.m_stat = request.stat;
      attributeLevel.m_level = request.level;
      ArrayPush(this.m_previousAttributeLevels, attributeLevel);
    };
  }

  private final func On_DEV_ScriptableSystemUseNewTooltips(request: ref<UI_DEV_ScriptableSystemUseNewTooltips>) -> Void {
    this.m_DEV_useNewTooltips = request.value;
  }

  private final func OnEnableScanLongDescription(request: ref<ScanLongDescriptionCall>) -> Void {
    this.m_DEV_useLongScanTooltips = request.isEnabled;
  }

  public final const func GetBackpackActiveSorting(opt defaultValue: Int32) -> Int32 {
    if this.m_backpackActiveSorting == 0 {
      return defaultValue;
    };
    return this.m_backpackActiveSorting;
  }

  public final const func GetBackpackActiveFilter(opt defaultValue: Int32) -> Int32 {
    if !this.m_isBackpackActiveFilterSaved {
      return defaultValue;
    };
    return this.m_backpackActiveFilter;
  }

  public final const func GetVendorPanelVendorActiveSorting(opt defaultValue: Int32) -> Int32 {
    if this.m_vendorPanelVendorActiveSorting == 0 {
      return defaultValue;
    };
    return this.m_vendorPanelVendorActiveSorting;
  }

  public final const func GetVendorPanelPlayerActiveSorting(opt defaultValue: Int32) -> Int32 {
    if this.m_vendorPanelPlayerActiveSorting == 0 {
      return defaultValue;
    };
    return this.m_vendorPanelPlayerActiveSorting;
  }

  public final const func IsInventoryItemNew(itemID: ItemID) -> Bool {
    return ArrayContains(this.m_newItems, itemID);
  }

  public final const func IsWardrobeSetNew(wardrobeSet: gameWardrobeClothingSetIndex) -> Bool {
    return ArrayContains(this.m_newWardrobeSets, wardrobeSet);
  }

  public final const func IsWardrobeItemNew(itemID: ItemID) -> Bool {
    return ArrayContains(this.m_newWardrobeItems, itemID);
  }

  public final const func IsAvailableCarNew(carFact: CName) -> Bool {
    return !ArrayContains(this.m_availableCars, carFact);
  }

  public final const func IsDLCAddedActiveItem(itemTweakDBID: TweakDBID) -> Bool {
    return !ArrayContains(this.m_DLCAddedItems, itemTweakDBID);
  }

  public final const func IsItemPlayerFavourite(itemID: ItemID) -> Bool {
    return ArrayContains(this.m_playerFavouriteItems, itemID);
  }

  public final const func GetPreviousAttributeLevel(stat: gamedataStatType) -> Int32 {
    let i: Int32 = 0;
    let limit: Int32 = ArraySize(this.m_previousAttributeLevels);
    while i < limit {
      if Equals(this.m_previousAttributeLevels[i].m_stat, stat) {
        return this.m_previousAttributeLevels[i].m_level;
      };
      i += 1;
    };
    return -1;
  }

  public final const func IsComparisionTooltipDisabled() -> Bool {
    return this.m_comparisionTooltipDisabled;
  }

  public final const func DEV_IsNewTooltipEnabled() -> Bool {
    return this.m_DEV_useNewTooltips;
  }

  public final const func DEV_IsScanLongTooltipEnabled() -> Bool {
    return this.m_DEV_useLongScanTooltips;
  }
}

public class UIScriptableInventoryListenerCallback extends InventoryScriptCallback {

  private let m_uiScriptableSystem: wref<UIScriptableSystem>;

  public final func AttachScriptableSystem(gameInstance: GameInstance) -> Void {
    this.m_uiScriptableSystem = UIScriptableSystem.GetInstance(gameInstance);
  }

  public func OnItemAdded(item: ItemID, itemData: wref<gameItemData>, flaggedAsSilent: Bool) -> Void {
    let request: ref<UIScriptableSystemInventoryAddItem> = new UIScriptableSystemInventoryAddItem();
    request.itemID = item;
    this.m_uiScriptableSystem.QueueRequest(request);
  }

  public func OnItemRemoved(item: ItemID, difference: Int32, currentQuantity: Int32) -> Void {
    let request: ref<UIScriptableSystemInventoryRemoveItem> = new UIScriptableSystemInventoryRemoveItem();
    request.itemID = item;
    this.m_uiScriptableSystem.QueueRequest(request);
  }

  public func OnItemExtracted(item: ItemID) -> Void {
    let request: ref<UIScriptableSystemInventoryRemoveItem> = new UIScriptableSystemInventoryRemoveItem();
    request.itemID = item;
    this.m_uiScriptableSystem.QueueRequest(request);
  }
}
