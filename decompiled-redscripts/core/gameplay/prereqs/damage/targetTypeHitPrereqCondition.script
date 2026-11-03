
public class TargetTypeHitPrereqCondition extends BaseHitPrereqCondition {

  public let m_targetType: CName;

  public func SetData(recordID: TweakDBID) -> Void {
    this.m_targetType = TweakDBInterface.GetCName(recordID + t".targetType", n"None");
    super.SetData(recordID);
  }

  public func Evaluate(hitEvent: ref<gameHitEvent>) -> Bool {
    let result: Bool;
    switch this.m_targetType {
      case n"Player":
        result = IsDefined(hitEvent.target as PlayerPuppet);
        break;
      case n"Puppet":
        result = IsDefined(hitEvent.target as ScriptedPuppet);
        break;
      case n"Vehicle":
        result = IsDefined(hitEvent.target as VehicleObject);
        break;
      default:
        return false;
    };
    if result {
      result = this.CheckOnlyOncePerShot(hitEvent);
    };
    return this.m_invert ? !result : result;
  }
}
