
public class EquipAction extends BaseItemAction {

  public func CompleteAction(gameInstance: GameInstance) -> Void {
    let obj: wref<GameObject> = this.GetExecutor();
    let req: ref<EquipRequest> = new EquipRequest();
    req.itemID = this.GetItemData().GetID();
    req.owner = obj;
    EquipmentSystem.GetInstance(obj).QueueRequest(req);
  }

  public func IsVisible(const context: script_ref<GetActionsContext>, opt objectActionsCallbackController: wref<gameObjectActionsCallbackController>) -> Bool {
    let obj: wref<GameObject> = this.GetExecutor();
    if IsDefined(obj) {
      return EquipmentSystem.GetInstance(obj).GetPlayerData(obj).IsEquippable(this.GetItemData());
    };
    return true;
  }
}
