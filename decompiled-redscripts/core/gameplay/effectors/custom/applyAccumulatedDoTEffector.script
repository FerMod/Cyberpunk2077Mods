
public class ApplyAccumulatedDoTEffector extends TriggerContinuousAttackEffector {

  protected func ActionOff(owner: ref<GameObject>) -> Void {
    if IsDefined(this.m_attack) {
      this.m_attack.StopAttack();
      this.m_attack = null;
    };
  }
}
