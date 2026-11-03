
public class AddStatusEffectToAttackEffector extends ModifyAttackEffector {

  public let m_isRandom: Bool;

  public let m_applicationChanceMods: [wref<StatModifier_Record>];

  public let m_statusEffect: SHitStatusEffect;

  public let m_stacks: Float;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_isRandom = TweakDBInterface.GetBool(record + t".isRandom", false);
    TweakDBInterface.GetAddStatusEffectToAttackEffectorRecord(record).ApplicationChance(this.m_applicationChanceMods);
    this.m_statusEffect.id = TweakDBInterface.GetAddStatusEffectToAttackEffectorRecord(record).StatusEffect().GetID();
    this.m_statusEffect.stacks = TweakDBInterface.GetAddStatusEffectToAttackEffectorRecord(record).Stacks();
  }

  protected func Uninitialize(game: GameInstance) -> Void;

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    let applicationChance: Float;
    let rand: Float;
    let hitEvent: ref<gameHitEvent> = this.GetHitEvent();
    if Equals(hitEvent.attackData.GetAttackType(), gamedataAttackType.Effect) {
      return;
    };
    if this.m_isRandom {
      rand = RandF();
      applicationChance = RPGManager.CalculateStatModifiers(this.m_applicationChanceMods, owner.GetGame(), owner, Cast<StatsObjectID>(owner.GetEntityID()));
      if rand <= applicationChance {
        hitEvent.attackData.AddStatusEffect(this.m_statusEffect.id, this.m_statusEffect.stacks);
      };
    } else {
      hitEvent.attackData.AddStatusEffect(this.m_statusEffect.id, this.m_statusEffect.stacks);
    };
  }
}
