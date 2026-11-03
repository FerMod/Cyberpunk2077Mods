
public abstract final native class WardrobeSystem extends IWardrobeSystem {

  public final native func GetStoredItemID(item: TweakDBID) -> ItemID;

  public final native func StoreUniqueItemID(itemID: ItemID) -> Bool;

  public final native func GetStoredItemIDs() -> [ItemID];

  public final native func GetFilteredStoredItemIDs(equipmentArea: gamedataEquipmentArea) -> [ItemID];

  public final native func GetFilteredInventoryItemsData(equipmentArea: gamedataEquipmentArea, inventoryItemDataV2: ref<IScriptable>) -> [InventoryItemData];

  public final native func IsItemBlacklisted(itemID: ItemID) -> Bool;

  public final native func PushBackClothingSet(clothingSet: ref<ClothingSet>) -> Void;

  public final native func DeleteClothingSet(setIndex: gameWardrobeClothingSetIndex) -> Void;

  public final native func GetClothingSets() -> [ref<ClothingSet>];

  public final native func SetActiveClothingSetIndex(slotIndex: gameWardrobeClothingSetIndex) -> Void;

  public final native func GetActiveClothingSetIndex() -> gameWardrobeClothingSetIndex;

  public final native func GetActiveClothingSet() -> ref<ClothingSet>;

  public final func StoreUniqueItemIDAndMarkNew(gameInstance: GameInstance, itemID: ItemID) -> Bool {
    let success: Bool = this.StoreUniqueItemID(itemID);
    if success {
      WardrobeSystem.SendWardrobeAddItemRequest(gameInstance, itemID);
    };
    return success;
  }

  public final static func WardrobeClothingSetIndexToNumber(slotIndex: gameWardrobeClothingSetIndex) -> Int32 {
    switch slotIndex {
      case gameWardrobeClothingSetIndex.Slot1:
        return 0;
      case gameWardrobeClothingSetIndex.Slot2:
        return 1;
      case gameWardrobeClothingSetIndex.Slot3:
        return 2;
      case gameWardrobeClothingSetIndex.Slot4:
        return 3;
      case gameWardrobeClothingSetIndex.Slot5:
        return 4;
      case gameWardrobeClothingSetIndex.Slot6:
        return 5;
      case gameWardrobeClothingSetIndex.Slot7:
        return 6;
      default:
        return -1;
    };
    return -1;
  }

  public final static func NumberToWardrobeClothingSetIndex(number: Int32) -> gameWardrobeClothingSetIndex {
    switch number {
      case 0:
        return gameWardrobeClothingSetIndex.Slot1;
      case 1:
        return gameWardrobeClothingSetIndex.Slot2;
      case 2:
        return gameWardrobeClothingSetIndex.Slot3;
      case 3:
        return gameWardrobeClothingSetIndex.Slot4;
      case 4:
        return gameWardrobeClothingSetIndex.Slot5;
      case 5:
        return gameWardrobeClothingSetIndex.Slot6;
      case 6:
        return gameWardrobeClothingSetIndex.Slot7;
      default:
        return gameWardrobeClothingSetIndex.INVALID;
    };
    return gameWardrobeClothingSetIndex.INVALID;
  }

  public final static func SendWardrobeAddItemRequest(gameInstance: GameInstance, itemID: ItemID) -> Void {
    let request: ref<UIScriptableSystemWardrobeAddItem> = new UIScriptableSystemWardrobeAddItem();
    request.itemID = itemID;
    UIScriptableSystem.GetInstance(gameInstance).QueueRequest(request);
  }

  public final static func SendWardrobeInspectItemRequest(gameInstance: GameInstance, itemID: ItemID) -> Void {
    let request: ref<UIScriptableSystemWardrobeInspectItem> = new UIScriptableSystemWardrobeInspectItem();
    request.itemID = itemID;
    UIScriptableSystem.GetInstance(gameInstance).QueueRequest(request);
  }
}
