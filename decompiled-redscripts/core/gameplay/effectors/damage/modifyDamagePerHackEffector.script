
public class ModifyDamagePerHackEffector extends ModifyDamageEffector {

  public let m_countOnlyUnique: Bool;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    super.Initialize(record, game, parentRecord);
    this.m_countOnlyUnique = TweakDBInterface.GetBool(record + t".countOnlyUnique", true);
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    let appliedDoT: array<ref<StatusEffect>>;
    let appliedQH: array<ref<StatusEffect>>;
    let count: Float;
    let finalDmg: Float;
    let hitEvent: ref<gameHitEvent> = this.GetHitEvent();
    if !IsDefined(hitEvent) {
      return;
    };
    GameInstance.GetStatusEffectSystem(owner.GetGame()).GetAppliedEffectsWithTag(hitEvent.target.GetEntityID(), n"Quickhack", appliedQH);
    GameInstance.GetStatusEffectSystem(owner.GetGame()).GetAppliedEffectsWithTag(hitEvent.target.GetEntityID(), n"DoT", appliedDoT);
    this.CountEffects(appliedQH, count);
    this.CountEffects(appliedDoT, count);
    finalDmg = 1.00 + this.m_value * count;
    this.ModifyDamage(hitEvent, this.m_operationType, finalDmg);
  }

  private final func CountEffects(list: [ref<StatusEffect>], out count: Float) -> Void {
    let effectID: TweakDBID;
    let uniqueEffectList: array<TweakDBID>;
    let i: Int32 = 0;
    while i < ArraySize(list) {
      if this.m_countOnlyUnique {
        effectID = list[i].GetRecord().GetID();
        if !ArrayContains(uniqueEffectList, effectID) {
          count += 1.00;
          ArrayPush(uniqueEffectList, effectID);
        };
      } else {
        count += Cast<Float>(list[i].GetStackCount());
      };
      i += 1;
    };
  }
}
