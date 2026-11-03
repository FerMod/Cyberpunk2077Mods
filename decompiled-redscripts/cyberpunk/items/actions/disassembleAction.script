
public class DisassembleAction extends BaseItemAction {

  public func CompleteAction(gameInstance: GameInstance) -> Void {
    let disassembleRequest: ref<DisassembleItemRequest>;
    let i: Int32;
    if this.GetItemData().HasTag(n"UnequipBlocked") || this.GetItemData().HasTag(n"Quest") {
      return;
    };
    if EquipmentSystem.GetInstance(this.GetExecutor()).IsEquipped(this.GetExecutor(), this.GetItemData().GetID()) {
      return;
    };
    i = 0;
    while i < this.GetRequestQuantity() {
      super.CompleteAction(gameInstance);
      i += 1;
    };
    disassembleRequest = new DisassembleItemRequest();
    disassembleRequest.target = this.GetExecutor();
    disassembleRequest.itemID = this.GetItemData().GetID();
    disassembleRequest.amount = this.GetRequestQuantity();
    CraftingSystem.GetInstance(gameInstance).QueueRequest(disassembleRequest);
  }
}
