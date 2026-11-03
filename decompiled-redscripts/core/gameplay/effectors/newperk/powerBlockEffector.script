
public class PowerBlockEffector extends ModifyAttackEffector {

  private let m_damageReduction: Float;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_damageReduction = TweakDBInterface.GetFloat(record + t".damageReduction", 0.00);
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    this.ProcessAction(owner);
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    this.ProcessAction(owner);
  }

  private final func ProcessAction(owner: ref<GameObject>) -> Void {
    let hitDirectionInt: Int32;
    let hitEvent: ref<gameHitEvent> = this.GetHitEvent();
    if !IsDefined(hitEvent) {
      return;
    };
    if hitEvent.attackComputed.GetTotalAttackValue(gamedataStatPoolType.Health) > 0.00 {
      hitDirectionInt = GameObject.GetAttackAngleInInt(hitEvent);
      if hitDirectionInt == 4 || hitDirectionInt == 0 {
        hitEvent.attackComputed.MultAttackValue(1.00 - this.m_damageReduction);
      };
    };
  }
}
