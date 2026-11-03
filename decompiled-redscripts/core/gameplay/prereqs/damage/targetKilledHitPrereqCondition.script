
public class TargetKilledHitPrereqCondition extends BaseHitPrereqCondition {

  private let m_lastTarget: wref<GameObject>;

  public func Evaluate(hitEvent: ref<gameHitEvent>) -> Bool {
    let result: Bool;
    let target: wref<NPCPuppet> = hitEvent.target as NPCPuppet;
    if !IsDefined(target) || this.m_lastTarget == target {
      return false;
    };
    result = target.WasJustKilledOrDefeated() || target.IsAboutToDieOrDefeated();
    if result {
      this.m_lastTarget = target;
      result = this.CheckOnlyOncePerShot(hitEvent);
    };
    return this.m_invert ? !result : result;
  }
}

public class TargetCanGetKilledByDamagePrereqCondition extends BaseHitPrereqCondition {

  private let m_lastTarget: wref<GameObject>;

  public func Evaluate(hitEvent: ref<gameHitEvent>) -> Bool {
    let damage: Float;
    let result: Bool;
    let targetHealth: Float;
    let targetHealthPercent: Float;
    let targetMaxHealth: Float;
    let target: wref<NPCPuppet> = hitEvent.target as NPCPuppet;
    if !IsDefined(target) || this.m_lastTarget == target {
      return false;
    };
    targetHealthPercent = GameInstance.GetStatPoolsSystem(target.GetGame()).GetStatPoolValue(Cast<StatsObjectID>(hitEvent.target.GetEntityID()), gamedataStatPoolType.Health);
    targetMaxHealth = GameInstance.GetStatsSystem(target.GetGame()).GetStatValue(Cast<StatsObjectID>(hitEvent.target.GetEntityID()), gamedataStatType.Health);
    targetHealth = (targetMaxHealth * targetHealthPercent) / 100.00;
    damage = hitEvent.attackComputed.GetTotalAttackValue(gamedataStatPoolType.Health);
    result = damage > 0.00 && damage >= targetHealth;
    if result {
      this.m_lastTarget = target;
      result = this.CheckOnlyOncePerShot(hitEvent);
    };
    return this.m_invert ? !result : result;
  }
}

public class TargetBreachCanGetKilledByDamagePrereqCondition extends BaseHitPrereqCondition {

  private let m_lastTarget: wref<GameObject>;

  public func Evaluate(hitEvent: ref<gameHitEvent>) -> Bool {
    let breachFinder: ref<BreachFinderComponent>;
    let damage: Float;
    let player: ref<PlayerPuppet>;
    let result: Bool;
    let target: wref<GameObject> = hitEvent.target;
    if !IsDefined(target) || this.m_lastTarget == target {
      return false;
    };
    player = hitEvent.attackData.GetInstigator() as PlayerPuppet;
    if !IsDefined(player) {
      return false;
    };
    breachFinder = player.GetBreachFinderComponent();
    if !IsDefined(breachFinder) {
      return false;
    };
    damage = hitEvent.attackComputed.GetTotalAttackValue(gamedataStatPoolType.Health);
    result = breachFinder.CanTrackedBreachBeKilledByDamage(damage);
    if result {
      this.m_lastTarget = target;
      result = this.CheckOnlyOncePerShot(hitEvent);
    };
    return this.m_invert ? !result : result;
  }
}
