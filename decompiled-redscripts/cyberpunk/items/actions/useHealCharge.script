
public class UseHealChargeAction extends BaseItemAction {

  public func CompleteAction(gameInstance: GameInstance) -> Void {
    let healActionCost: Float;
    super.CompleteAction(gameInstance);
    healActionCost = GameInstance.GetStatsSystem(gameInstance).GetStatValue(Cast<StatsObjectID>(GetPlayer(gameInstance).GetEntityID()), gamedataStatType.HealingItemsRechargeDuration);
    GameInstance.GetStatPoolsSystem(gameInstance).RequestChangingStatPoolValue(Cast<StatsObjectID>(GetPlayer(gameInstance).GetEntityID()), gamedataStatPoolType.HealingItemsCharges, -healActionCost, null, false, false);
    ConsumablesChargesHelper.HotkeyRefresh(gameInstance);
  }

  protected func ProcessStatusEffects(const actionEffects: script_ref<[wref<ObjectActionEffect_Record>]>, gameInstance: GameInstance) -> Void {
    let effectInstigator: TweakDBID;
    let usedConsumableName: gamedataConsumableBaseName;
    let appliedEffects: array<ref<StatusEffect>> = StatusEffectHelper.GetAppliedEffects(this.GetExecutor());
    let newConsumableTDBID: TweakDBID = ItemID.GetTDBID(this.GetItemData().GetID());
    let newConsumableName: gamedataConsumableBaseName = TweakDBInterface.GetConsumableItemRecord(newConsumableTDBID).ConsumableBaseName().Type();
    let i: Int32 = 0;
    while i < ArraySize(appliedEffects) {
      effectInstigator = appliedEffects[i].GetInstigatorStaticDataID();
      usedConsumableName = TweakDBInterface.GetConsumableItemRecord(effectInstigator).ConsumableBaseName().Type();
      if Equals(newConsumableName, usedConsumableName) && Cast<Int32>(appliedEffects[i].GetMaxStacks()) == 1 {
        StatusEffectHelper.RemoveStatusEffect(this.GetExecutor(), appliedEffects[i]);
        break;
      };
      i += 1;
    };
    i = 0;
    while i < ArraySize(Deref(actionEffects)) {
      StatusEffectHelper.ApplyStatusEffect(this.GetExecutor(), Deref(actionEffects)[i].StatusEffect().GetID(), ItemID.GetTDBID(this.GetItemData().GetID()));
      i += 1;
    };
  }
}
