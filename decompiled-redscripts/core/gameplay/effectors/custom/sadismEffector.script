
public class SadismEffector extends Effector {

  public let m_healingItemChargeRestorePercentage: Float;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_healingItemChargeRestorePercentage = TweakDBInterface.GetFloat(record + t".healingItemChargeRestorePercentage", 0.00);
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    this.ProcessAction(owner);
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    this.ProcessAction(owner);
  }

  private final func ProcessAction(owner: ref<GameObject>) -> Void {
    let healingItemsRechargeDuration: Float;
    let healingItemsRechargeTotal: Float;
    let statPoolsSystem: ref<StatPoolsSystem> = GameInstance.GetStatPoolsSystem(owner.GetGame());
    if statPoolsSystem.GetStatPoolValue(Cast<StatsObjectID>(owner.GetEntityID()), gamedataStatPoolType.Overshield, false) <= 0.00 {
      return;
    };
    healingItemsRechargeDuration = GameInstance.GetStatsSystem(owner.GetGame()).GetStatValue(Cast<StatsObjectID>(owner.GetEntityID()), gamedataStatType.HealingItemsRechargeDuration);
    healingItemsRechargeTotal = statPoolsSystem.GetStatPoolValue(Cast<StatsObjectID>(owner.GetEntityID()), gamedataStatPoolType.HealingItemsCharges, false);
    healingItemsRechargeTotal += healingItemsRechargeDuration * this.m_healingItemChargeRestorePercentage;
    statPoolsSystem.RequestSettingStatPoolValue(Cast<StatsObjectID>(owner.GetEntityID()), gamedataStatPoolType.HealingItemsCharges, healingItemsRechargeTotal, owner, false);
  }
}
