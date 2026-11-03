
public class ModifyDamageWithDistance extends ModifyDamageEffector {

  public let m_percentMult: Float;

  public let m_minDistance: Float;

  public let m_maxDistance: Float;

  public let m_improveWithDistance: Bool;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    super.Initialize(record, game, parentRecord);
    this.m_percentMult = TweakDBInterface.GetFloat(record + t".percentMult", 0.00);
    this.m_minDistance = TweakDBInterface.GetFloat(record + t".minDistance", 0.00);
    this.m_maxDistance = TweakDBInterface.GetFloat(record + t".maxDistance", 0.00);
    this.m_improveWithDistance = TweakDBInterface.GetBool(record + t".improveWithDistance", false);
  }

  protected func Uninitialize(game: GameInstance) -> Void;

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    let adjustedDistance: Float;
    let coveredDistance: Float;
    let hitEvent: ref<gameHitEvent>;
    let distanceDelta: Float = this.m_maxDistance - this.m_minDistance;
    if distanceDelta < 0.00 {
      return;
    };
    hitEvent = this.GetHitEvent();
    if !IsDefined(hitEvent) {
      return;
    };
    if AttackData.IsEffect(hitEvent.attackData.GetAttackType()) || AttackData.IsDoT(hitEvent.attackData) {
      return;
    };
    coveredDistance = MinF(Vector4.Distance(hitEvent.attackData.GetAttackPosition(), hitEvent.target.GetWorldPosition()), this.m_maxDistance);
    adjustedDistance = MaxF(coveredDistance - this.m_minDistance, 0.00);
    if this.m_improveWithDistance {
      if coveredDistance < this.m_minDistance {
        return;
      };
      this.m_value = distanceDelta > 0.00 ? 1.00 - adjustedDistance / distanceDelta * (1.00 - this.m_percentMult) : this.m_percentMult;
    } else {
      if coveredDistance >= this.m_maxDistance {
        return;
      };
      this.m_value = distanceDelta > 0.00 ? this.m_percentMult - adjustedDistance / distanceDelta * (this.m_percentMult - 1.00) : this.m_percentMult;
    };
    this.ModifyDamage(hitEvent, this.m_operationType, this.m_value);
  }
}
