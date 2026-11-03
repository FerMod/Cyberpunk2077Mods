
public class WeirdTankyPlatingEffector extends ModifyAttackEffector {

  private let m_armorMultiplier: Float;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_armorMultiplier = TweakDBInterface.GetFloat(record + t".armorMultiplier", 0.00);
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    this.ProcessAction(owner);
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    this.ProcessAction(owner);
  }

  private final func ProcessAction(owner: ref<GameObject>) -> Void {
    let armorPoints: Float;
    let damage: Float;
    let effectiveHealthPerArmorPoint: Float;
    let hitDirectionInt: Int32;
    let statsSystem: ref<StatsSystem>;
    let hitEvent: ref<gameHitEvent> = this.GetHitEvent();
    if !IsDefined(hitEvent) {
      return;
    };
    damage = hitEvent.attackComputed.GetTotalAttackValue(gamedataStatPoolType.Health);
    if damage > 0.00 {
      hitDirectionInt = GameObject.GetAttackAngleInInt(hitEvent);
      if hitDirectionInt >= 1 && hitDirectionInt <= 3 {
        statsSystem = GameInstance.GetStatsSystem(hitEvent.target.GetGame());
        armorPoints = statsSystem.GetStatValue(Cast<StatsObjectID>(hitEvent.target.GetEntityID()), gamedataStatType.Armor);
        effectiveHealthPerArmorPoint = GameInstance.GetStatsDataSystem(hitEvent.target.GetGame()).GetArmorEffectivenessValue(hitEvent.target.IsPlayer());
        hitEvent.attackComputed.MultAttackValue(1.00 / (1.00 + armorPoints * effectiveHealthPerArmorPoint * this.m_armorMultiplier));
      };
    };
  }
}
