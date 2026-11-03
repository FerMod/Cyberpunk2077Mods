
public class ModifyAttackCritChanceEffector extends ModifyAttackEffector {

  public let m_applicationChanceMods: [wref<StatModifier_Record>];

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    TweakDBInterface.GetModifyAttackCritChanceEffectorRecord(record).CritChance(this.m_applicationChanceMods);
  }

  protected func Uninitialize(game: GameInstance) -> Void;

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    let critChance: Float;
    let hitEvent: ref<gameHitEvent> = this.GetHitEvent();
    if !IsDefined(hitEvent) {
      return;
    };
    critChance = RPGManager.CalculateStatModifiers(this.m_applicationChanceMods, owner.GetGame(), owner, Cast<StatsObjectID>(owner.GetEntityID()));
    hitEvent.attackData.SetAdditionalCritChance(critChance);
  }
}
