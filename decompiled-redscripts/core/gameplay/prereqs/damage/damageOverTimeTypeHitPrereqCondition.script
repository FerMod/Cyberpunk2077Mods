
public class DamageOverTimeTypeHitPrereqCondition extends BaseHitPrereqCondition {

  public let m_dotType: gamedataStatusEffectType;

  public func SetData(recordID: TweakDBID) -> Void {
    let str: String = TweakDBInterface.GetString(recordID + t".dotType", "");
    this.m_dotType = IntEnum<gamedataStatusEffectType>(Cast<Int32>(EnumValueFromString("gamedataStatusEffectType", str)));
    super.SetData(recordID);
  }

  public func Evaluate(hitEvent: ref<gameHitEvent>) -> Bool {
    let attackRecord: ref<Attack_GameEffect_Record>;
    let attackTag: CName;
    let result: Bool;
    if Equals(hitEvent.attackData.GetAttackType(), gamedataAttackType.Effect) {
      attackRecord = hitEvent.attackData.GetAttackDefinition().GetRecord() as Attack_GameEffect_Record;
      if IsDefined(attackRecord) {
        attackTag = attackRecord.AttackTag();
      };
      result = Equals(IntEnum<gamedataStatusEffectType>(Cast<Int32>(EnumValueFromName(n"gamedataStatusEffectType", attackTag))), this.m_dotType);
      if result {
        result = this.CheckOnlyOncePerShot(hitEvent);
      };
      return this.m_invert ? !result : result;
    };
    return false;
  }
}
