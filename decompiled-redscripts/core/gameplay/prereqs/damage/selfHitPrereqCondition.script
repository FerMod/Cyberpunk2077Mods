
public class SelfHitPrereqCondition extends BaseHitPrereqCondition {

  public func SetData(recordID: TweakDBID) -> Void {
    super.SetData(recordID);
    this.m_invert = TweakDBInterface.GetBool(recordID + t".invert", false);
  }

  public func Evaluate(hitEvent: ref<gameHitEvent>) -> Bool {
    if this.m_invert {
      return hitEvent.attackData.GetInstigator() != hitEvent.target;
    };
    return hitEvent.attackData.GetInstigator() == hitEvent.target;
  }
}
