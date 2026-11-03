
public class VisualDisplayController extends InventoryItemDisplayController {

  private let m_equipped: Bool;

  public func BindVisualSlot(equipmentArea: gamedataEquipmentArea, itemsAmount: Int32, opt inventoryItemData: InventoryItemData, opt slotIndex: Int32, opt displayContext: ItemDisplayContext) -> Void {
    this.m_equipmentArea = equipmentArea;
    this.m_slotIndex = slotIndex;
    this.SetDisplayContext(displayContext, null);
    this.OnVisualUpdate(inventoryItemData, itemsAmount, false);
    this.RefreshUI();
  }

  public func InvalidateVisualContent(const inventoryItemData: script_ref<InventoryItemData>, itemsAmount: Int32, equipped: Bool) -> Void {
    this.OnVisualUpdate(inventoryItemData, itemsAmount, equipped);
  }

  private final func OnVisualUpdate(const inventoryItemData: script_ref<InventoryItemData>, itemsAmount: Int32, equipped: Bool) -> Void {
    this.m_itemID = InventoryItemData.GetID(inventoryItemData);
    this.m_itemData = Deref(inventoryItemData);
    inkTextRef.SetText(this.m_slotItemsCount, IntToString(itemsAmount));
    inkWidgetRef.SetVisible(this.m_slotItemsCountWrapper, itemsAmount > 0);
    this.m_equipped = equipped;
    this.RefreshUI();
  }

  protected func RefreshUI() -> Void {
    this.UpdateIcon();
    this.UpdateQuantity();
    this.UpdateEquipped();
    this.UpdateIndicators();
    this.UpdateIsNewIndicator();
    this.UpdateLoot();
  }

  protected func ShouldShowEquipped() -> Bool {
    return this.m_equipped;
  }

  public final func SetIconsVisible(visible: Bool) -> Void {
    inkWidgetRef.SetVisible(this.m_itemImage, visible && !InventoryItemData.IsEmpty(this.m_itemData));
    inkWidgetRef.SetVisible(this.m_itemEmptyImage, visible && InventoryItemData.IsEmpty(this.m_itemData));
  }
}
