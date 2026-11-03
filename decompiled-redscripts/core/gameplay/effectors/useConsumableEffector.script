
public class UseConsumableEffector extends Effector {

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    this.ExecuteAction(owner);
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    this.ExecuteAction(owner);
  }

  private final func ExecuteAction(owner: ref<GameObject>) -> Void {
    let action: ref<BaseItemAction>;
    let actionID: TweakDBID;
    let consumableItemId: ItemID = EquipmentSystem.GetData(owner).GetActiveConsumable();
    switch RPGManager.GetItemType(consumableItemId) {
      case gamedataItemType.Cyb_HealingAbility:
        actionID = ItemActionsHelper.GetUseAction(consumableItemId).GetID();
        break;
      default:
        actionID = ItemActionsHelper.GetUseHealChargeAction(consumableItemId).GetID();
    };
    action = ItemActionsHelper.SetupItemAction(owner.GetGame(), owner, RPGManager.GetItemData(owner.GetGame(), owner, consumableItemId), actionID, true);
    action.ProcessRPGAction(owner.GetGame());
  }
}
