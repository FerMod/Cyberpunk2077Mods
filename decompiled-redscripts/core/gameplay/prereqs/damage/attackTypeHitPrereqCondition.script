
public class AttackTypeHitPrereqCondition extends BaseHitPrereqCondition {

  public let m_attackType: gamedataAttackType;

  public func SetData(recordID: TweakDBID) -> Void {
    let str: String = TweakDBInterface.GetString(recordID + t".attackType", "");
    let result: gamedataAttackType = IntEnum<gamedataAttackType>(Cast<Int32>(EnumValueFromString("gamedataAttackType", str)));
    if EnumInt(result) < 0 {
      this.m_attackType = gamedataAttackType.Invalid;
    } else {
      this.m_attackType = result;
    };
    super.SetData(recordID);
  }

  public func Evaluate(hitEvent: ref<gameHitEvent>) -> Bool {
    let result: Bool = Equals(hitEvent.attackData.GetAttackType(), this.m_attackType);
    if result {
      result = this.CheckOnlyOncePerShot(hitEvent);
    };
    return this.m_invert ? !result : result;
  }
}
