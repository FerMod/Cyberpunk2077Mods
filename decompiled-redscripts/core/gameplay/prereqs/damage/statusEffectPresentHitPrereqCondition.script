
public class StatusEffectPresentHitPrereqCondition extends BaseHitPrereqCondition {

  public let m_checkType: gamedataCheckType;

  public let m_statusEffectParam: CName;

  public let m_tag: CName;

  @default(StatusEffectPresentHitPrereqCondition, Target)
  public let m_objectToCheck: CName;

  public func SetData(recordID: TweakDBID) -> Void {
    this.m_statusEffectParam = TweakDBInterface.GetCName(recordID + t".statusEffect", n"None");
    this.m_checkType = TweakDBInterface.GetCheckTypeRecord(TweakDBInterface.GetForeignKeyDefault(recordID + t".checkType")).Type();
    this.m_tag = TweakDBInterface.GetCName(recordID + t".tagToCheck", n"None");
    this.m_objectToCheck = TweakDBInterface.GetCName(recordID + t".objectToCheck", n"None");
    super.SetData(recordID);
  }

  public func Evaluate(hitEvent: ref<gameHitEvent>) -> Bool {
    let result: Bool;
    let statusEffectType: gamedataStatusEffectType;
    let objectToCheck: wref<gamePuppet> = this.GetObjectToCheck(this.m_objectToCheck, hitEvent) as gamePuppet;
    if IsDefined(objectToCheck) {
      switch this.m_checkType {
        case gamedataCheckType.Tag:
          result = StatusEffectSystem.ObjectHasStatusEffectWithTag(objectToCheck, this.m_tag);
          break;
        case gamedataCheckType.Type:
          statusEffectType = IntEnum<gamedataStatusEffectType>(Cast<Int32>(EnumValueFromName(n"gamedataStatusEffectType", this.m_statusEffectParam)));
          result = StatusEffectSystem.ObjectHasStatusEffectOfType(objectToCheck, statusEffectType);
          break;
        case gamedataCheckType.Record:
          result = StatusEffectSystem.ObjectHasStatusEffect(objectToCheck, TDBID.Create("BaseStatusEffect." + NameToString(this.m_statusEffectParam)));
          break;
        default:
          return false;
      };
    };
    if result {
      result = this.CheckOnlyOncePerShot(hitEvent);
    };
    return this.m_invert ? !result : result;
  }
}
