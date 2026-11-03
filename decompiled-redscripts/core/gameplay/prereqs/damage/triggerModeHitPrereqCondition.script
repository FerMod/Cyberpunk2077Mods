
public class TriggerModeHitPrereqCondition extends BaseHitPrereqCondition {

  public let m_triggerMode: gamedataTriggerMode;

  public func SetData(recordID: TweakDBID) -> Void {
    this.m_triggerMode = TweakDBInterface.GetTriggerModeRecord(TweakDBInterface.GetForeignKeyDefault(recordID + t".triggerMode")).Type();
    super.SetData(recordID);
  }

  public func Evaluate(hitEvent: ref<gameHitEvent>) -> Bool {
    let result: Bool = true;
    result = Equals(hitEvent.attackData.GetTriggerMode(), this.m_triggerMode);
    return NotEquals(result, this.m_invert);
  }
}
