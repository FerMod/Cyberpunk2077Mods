
public class HitFlagHitPrereqCondition extends BaseHitPrereqCondition {

  public let m_hitFlag: hitFlag;

  public let m_invertHitFlag: Bool;

  public func SetData(recordID: TweakDBID) -> Void {
    let str: String = TweakDBInterface.GetString(recordID + t".hitFlag", "");
    this.m_hitFlag = IntEnum<hitFlag>(Cast<Int32>(EnumValueFromString("hitFlag", str)));
    this.m_invertHitFlag = TweakDBInterface.GetBool(recordID + t".invertHitFlag", false);
    super.SetData(recordID);
  }

  public func Evaluate(hitEvent: ref<gameHitEvent>) -> Bool {
    let result: Bool = hitEvent.attackData.HasFlag(this.m_hitFlag);
    if this.m_invertHitFlag {
      result = !result;
    };
    if result {
      result = this.CheckOnlyOncePerShot(hitEvent);
    };
    return this.m_invert ? !result : result;
  }
}
