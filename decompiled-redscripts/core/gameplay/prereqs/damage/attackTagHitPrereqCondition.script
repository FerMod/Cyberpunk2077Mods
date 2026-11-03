
public class AttackTagHitPrereqCondition extends BaseHitPrereqCondition {

  public let m_attackTag: CName;

  public func SetData(recordID: TweakDBID) -> Void {
    this.m_attackTag = TweakDBInterface.GetCName(recordID + t".attackTag", n"None");
    super.SetData(recordID);
  }

  public func Evaluate(hitEvent: ref<gameHitEvent>) -> Bool {
    let attackRecord: ref<Attack_GameEffect_Record> = hitEvent.attackData.GetAttackDefinition().GetRecord() as Attack_GameEffect_Record;
    let result: Bool = Equals(attackRecord.AttackTag(), this.m_attackTag);
    return this.m_invert ? !result : result;
  }
}
