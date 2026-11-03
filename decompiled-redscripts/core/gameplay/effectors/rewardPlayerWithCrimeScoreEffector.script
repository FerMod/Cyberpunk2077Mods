
public class RewardPlayerWithCrimeScoreEffector extends Effector {

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    this.ProcessAction(owner);
  }

  private final func ProcessAction(owner: ref<GameObject>) -> Void {
    PreventionSystem.CreateNewPreventionDamageRequest(owner.GetGame(), owner, -1.00, gamedataAttackType.Hack, 1.00, true);
  }
}
