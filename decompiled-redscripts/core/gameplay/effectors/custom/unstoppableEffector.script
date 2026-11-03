
public class UnstoppableEffector extends OvershieldEffectorBase {

  private func SetStatsToModify() -> [ref<gameStatModifierData>] {
    let result: array<ref<gameStatModifierData>>;
    ArrayPush(result, RPGManager.CreateStatModifier(gamedataStatType.KnockdownImmunity, gameStatModifierType.Additive, 1.00));
    ArrayPush(result, RPGManager.CreateStatModifier(gamedataStatType.StunImmunity, gameStatModifierType.Additive, 1.00));
    ArrayPush(result, RPGManager.CreateStatModifier(gamedataStatType.BlindImmunity, gameStatModifierType.Additive, 1.00));
    ArrayPush(result, RPGManager.CreateStatModifier(gamedataStatType.EMPImmunity, gameStatModifierType.Additive, 1.00));
    ArrayPush(result, RPGManager.CreateStatModifier(gamedataStatType.ExhaustionImmunity, gameStatModifierType.Additive, 1.00));
    ArrayPush(result, RPGManager.CreateStatModifier(gamedataStatType.PoisonImmunity, gameStatModifierType.Additive, 1.00));
    return result;
  }
}
