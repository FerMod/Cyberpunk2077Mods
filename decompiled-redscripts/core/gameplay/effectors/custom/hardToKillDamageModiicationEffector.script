
public class HardToKillDamageModificationEffector extends ModifyAttackEffector {

  public let m_criticalHealthThreshold: Float;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_criticalHealthThreshold = TweakDBInterface.GetFloat(record + t".criticalHealthThreshold", 0.00);
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    this.ProcessAction(owner);
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    this.ProcessAction(owner);
  }

  private final func ProcessAction(owner: ref<GameObject>) -> Void {
    let attackdamage: Float;
    let healthPercentage: Float;
    let hitEvent: ref<gameHitEvent> = this.GetHitEvent();
    let poolSys: ref<StatPoolsSystem> = GameInstance.GetStatPoolsSystem(owner.GetGame());
    if !IsDefined(hitEvent) {
      return;
    };
    if AttackData.IsDoT(hitEvent.attackData) {
      return;
    };
    attackdamage = hitEvent.attackComputed.GetTotalAttackValue(gamedataStatPoolType.Health);
    healthPercentage = poolSys.GetStatPoolValue(Cast<StatsObjectID>(owner.GetEntityID()), gamedataStatPoolType.Health);
    if attackdamage > 0.00 && healthPercentage <= this.m_criticalHealthThreshold {
      hitEvent.attackComputed.MultAttackValue(0.00);
      poolSys.RequestChangingStatPoolValue(Cast<StatsObjectID>(owner.GetEntityID()), gamedataStatPoolType.AccumulatedDoT, attackdamage, owner, false, false);
    };
  }
}
