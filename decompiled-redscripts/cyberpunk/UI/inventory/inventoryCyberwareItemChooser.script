
public class InventoryCyberwareItemChooser extends InventoryGenericItemChooser {

  protected edit let m_leftSlotsContainer: inkCompoundRef;

  protected edit let m_rightSlotsContainer: inkCompoundRef;

  private let m_itemData: InventoryItemData;

  protected func GetDisplayToSpawn() -> CName {
    return n"itemDisplay";
  }

  protected func GetIntroAnimation() -> CName {
    return n"cyberwareItemChoser_intro";
  }

  protected func GetSlots() -> [ref<InventoryItemAttachments>] {
    return InventoryItemData.GetAttachments(this.m_itemData);
  }

  public func RefreshSelectedItem() -> Void {
    this.ChangeSelectedItem(null);
  }

  public func RequestClose() -> Bool {
    return true;
  }

  protected func RebuildSlots() -> Void {
    let emptyIndex: Int32;
    let i: Int32;
    let slot: ref<InventoryItemDisplayController>;
    let slots: array<ref<InventoryItemAttachments>> = this.GetSlots();
    let numberOfSlots: Int32 = ArraySize(slots);
    while inkCompoundRef.GetNumChildren(this.m_leftSlotsContainer) > numberOfSlots {
      inkCompoundRef.RemoveChildByIndex(this.m_leftSlotsContainer, inkCompoundRef.GetNumChildren(this.m_leftSlotsContainer) - 1);
    };
    while inkCompoundRef.GetNumChildren(this.m_leftSlotsContainer) < numberOfSlots {
      slot = ItemDisplayUtils.SpawnCommonSlotController(this, this.m_leftSlotsContainer, n"itemDisplay") as InventoryItemDisplayController;
      if IsDefined(slot) {
        slot.GetRootWidget().RegisterToCallback(n"OnRelease", this, n"OnItemInventoryClick");
        slot.GetRootWidget().RegisterToCallback(n"OnHoverOver", this, n"OnInventoryItemHoverOver");
        slot.GetRootWidget().RegisterToCallback(n"OnHoverOut", this, n"OnInventoryItemHoverOut");
      } else {
        break;
      };
    };
    i = 0;
    while i < numberOfSlots {
      slot = inkCompoundRef.GetWidgetByIndex(this.m_leftSlotsContainer, i).GetController() as InventoryItemDisplayController;
      if TDBID.IsValid(slots[i].SlotID) {
        if !InventoryItemData.IsEmpty(slots[i].ItemData) {
          InventoryItemData.SetIsEquipped(slots[i].ItemData, true);
        };
        slot.SetParentItem(InventoryItemData.GetGameItemData(this.m_itemData));
        slot.Setup(this.inventoryDataManager, slots[i].ItemData, slots[i].SlotID, ItemDisplayContext.Attachment);
      };
      i += 1;
    };
    if this.selectedItem == null {
      emptyIndex = this.GetFirstEmptySlotIndex(slots);
      if inkCompoundRef.GetNumChildren(this.m_leftSlotsContainer) > 0 && emptyIndex != -1 {
        this.ChangeSelectedItem(inkCompoundRef.GetWidgetByIndex(this.m_leftSlotsContainer, emptyIndex).GetController() as InventoryItemDisplayController);
      } else {
        this.ChangeSelectedItem(null);
      };
    };
  }

  private final func GetFirstEmptySlotIndex(const slots: script_ref<[ref<InventoryItemAttachments>]>) -> Int32 {
    let slot: ref<InventoryItemDisplayController>;
    let slotData: InventoryItemData;
    let i: Int32 = 0;
    while i < ArraySize(Deref(slots)) {
      slot = inkCompoundRef.GetWidgetByIndex(this.m_leftSlotsContainer, i).GetController() as InventoryItemDisplayController;
      slotData = slot.GetItemData();
      if InventoryItemData.IsEmpty(slotData) {
        return i;
      };
      i += 1;
    };
    return 0;
  }

  protected func RefreshMainItem(opt isClothingSetEquipped: Bool, opt clothingSetIndex: Int32, opt showTransmogedIcon: Bool) -> Void {
    let itemID: ItemID;
    let slot: ref<InventoryItemDisplayController>;
    if this.inventoryDataManager.GetNumberOfSlots(this.equipmentArea) < 1 {
      return;
    };
    itemID = this.inventoryDataManager.GetEquippedItemIdInArea(this.equipmentArea, this.slotIndex);
    this.m_itemData = this.inventoryDataManager.GetItemDataFromIDInLoadout(itemID);
    inkCompoundRef.RemoveAllChildren(this.m_itemContainer);
    slot = ItemDisplayUtils.SpawnCommonSlotController(this, this.m_itemContainer, n"itemDisplay") as InventoryItemDisplayController;
    slot.GetRootWidget().RegisterToCallback(n"OnRelease", this, n"OnItemInventoryClick");
    slot.GetRootWidget().RegisterToCallback(n"OnHoverOver", this, n"OnInventoryItemHoverOver");
    slot.GetRootWidget().RegisterToCallback(n"OnHoverOut", this, n"OnInventoryItemHoverOut");
    slot.Bind(this.inventoryDataManager, this.equipmentArea, this.slotIndex, ItemDisplayContext.Ripperdoc);
  }

  public func GetModifiedItemData() -> InventoryItemData {
    return this.m_itemData;
  }

  public func GetModifiedItemID() -> ItemID {
    return InventoryItemData.GetID(this.m_itemData);
  }
}
