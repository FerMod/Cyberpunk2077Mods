
public class HitStatusEffectPresentPrereqState extends GenericHitPrereqState {

  public func Evaluate(hitEvent: ref<gameHitEvent>) -> Bool {
    let castedPrereq: ref<HitStatusEffectPresentPrereq>;
    let statusEffectType: gamedataStatusEffectType;
    let target: wref<ScriptedPuppet> = hitEvent.target as ScriptedPuppet;
    if !IsDefined(target) {
      return false;
    };
    castedPrereq = this.GetPrereq() as HitStatusEffectPresentPrereq;
    switch castedPrereq.m_checkType {
      case gamedataCheckType.Tag:
        return StatusEffectSystem.ObjectHasStatusEffectWithTag(target, castedPrereq.m_tag);
      case gamedataCheckType.Type:
        statusEffectType = IntEnum<gamedataStatusEffectType>(Cast<Int32>(EnumValueFromString("gamedataStatusEffectType", castedPrereq.m_statusEffectParam)));
        return StatusEffectSystem.ObjectHasStatusEffectOfType(target, statusEffectType);
      case gamedataCheckType.Record:
        return StatusEffectSystem.ObjectHasStatusEffect(target, TDBID.Create("BaseStatusEffect." + castedPrereq.m_statusEffectParam));
      default:
        return false;
    };
  }
}

public class HitStatusEffectPresentPrereq extends GenericHitPrereq {

  public let m_checkType: gamedataCheckType;

  public let m_statusEffectParam: String;

  public let m_tag: CName;

  protected func Initialize(recordID: TweakDBID) -> Void {
    this.m_statusEffectParam = TweakDBInterface.GetString(recordID + t".statusEffect", "");
    this.m_checkType = TweakDBInterface.GetCheckTypeRecord(TweakDBInterface.GetForeignKeyDefault(recordID + t".checkType")).Type();
    this.m_tag = TweakDBInterface.GetCName(recordID + t".tagToCheck", n"None");
  }
}
