
public class EffectNamePresentHitPrereqCondition extends BaseHitPrereqCondition {

  public let m_effectName: CName;

  public func SetData(recordID: TweakDBID) -> Void {
    this.m_effectName = TDB.GetCName(recordID + t".effectName");
    super.SetData(recordID);
  }

  public func Evaluate(hitEvent: ref<gameHitEvent>) -> Bool {
    let attackGameEffectRecord: ref<Attack_GameEffect_Record>;
    let result: Bool;
    let attackDefinition: ref<IAttack> = hitEvent.attackData.GetAttackDefinition();
    if !IsDefined(attackDefinition) {
      return false;
    };
    attackGameEffectRecord = attackDefinition.GetRecord() as Attack_GameEffect_Record;
    if !IsDefined(attackGameEffectRecord) {
      return false;
    };
    result = Equals(attackGameEffectRecord.EffectName(), this.m_effectName);
    if result {
      result = this.CheckOnlyOncePerShot(hitEvent);
    };
    return this.m_invert ? !result : result;
  }
}
