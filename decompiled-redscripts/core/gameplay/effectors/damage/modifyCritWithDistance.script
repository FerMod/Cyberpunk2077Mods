
public class ModifyCritWithDistance extends ModifyAttackEffector {

  public let m_critChanceBonus: Float;

  public let m_minDistance: Float;

  public let m_maxDistance: Float;

  public let m_improveWithDistance: Bool;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_critChanceBonus = TweakDBInterface.GetFloat(record + t".critChanceBonus", 0.00);
    this.m_minDistance = TweakDBInterface.GetFloat(record + t".minDistance", 0.00);
    this.m_maxDistance = TweakDBInterface.GetFloat(record + t".maxDistance", 0.00);
    this.m_improveWithDistance = TweakDBInterface.GetBool(record + t".improveWithDistance", false);
  }

  protected func Uninitialize(game: GameInstance) -> Void;

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    let adjustedDistance: Float;
    let coveredDistance: Float;
    let critChanceValue: Float;
    let hitEvent: ref<gameHitEvent>;
    let distanceDelta: Float = this.m_maxDistance - this.m_minDistance;
    if distanceDelta < 0.00 {
      return;
    };
    hitEvent = this.GetHitEvent();
    if !IsDefined(hitEvent) {
      return;
    };
    coveredDistance = MinF(Vector4.Distance(hitEvent.attackData.GetAttackPosition(), hitEvent.target.GetWorldPosition()), this.m_maxDistance);
    adjustedDistance = MaxF(coveredDistance - this.m_minDistance, 0.00);
    if this.m_improveWithDistance {
      if coveredDistance < this.m_minDistance {
        return;
      };
      critChanceValue = distanceDelta > 0.00 ? adjustedDistance / distanceDelta * this.m_critChanceBonus : this.m_critChanceBonus;
    } else {
      if coveredDistance >= this.m_maxDistance {
        return;
      };
      critChanceValue = distanceDelta > 0.00 ? this.m_critChanceBonus * (1.00 - adjustedDistance / distanceDelta) : this.m_critChanceBonus;
    };
    hitEvent.attackData.SetAdditionalCritChance(critChanceValue);
  }
}
