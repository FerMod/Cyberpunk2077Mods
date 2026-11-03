
public class ConsecutiveHitsPrereqCondition extends BaseHitPrereqCondition {

  private let m_timeOut: Float;

  private let m_consecutiveHitsRequired: Int32;

  private let m_uniqueTarget: Bool;

  @default(ConsecutiveHitsPrereqCondition, 0)
  private let m_consecutiveHits: Int32;

  private let m_lastTargetID: EntityID;

  @default(ConsecutiveHitsPrereqCondition, -1.0f)
  private let m_lastHitTime: Float;

  public func SetData(recordID: TweakDBID) -> Void {
    super.SetData(recordID);
    this.m_timeOut = TweakDBInterface.GetFloat(recordID + t".timeOut", 0.00);
    this.m_consecutiveHitsRequired = TweakDBInterface.GetInt(recordID + t".consecutiveHitsRequired", 1);
    this.m_uniqueTarget = TweakDBInterface.GetBool(recordID + t".uniqueTarget", false);
  }

  public func Evaluate(hitEvent: ref<gameHitEvent>) -> Bool {
    let result: Bool = false;
    let targetID: EntityID = hitEvent.target.GetEntityID();
    let attackTime: Float = hitEvent.attackData.GetAttackTime();
    if this.m_lastHitTime == -1.00 {
      this.m_lastHitTime = attackTime;
    };
    if attackTime - this.m_lastHitTime > this.m_timeOut {
      this.m_consecutiveHits = 0;
    };
    if !EntityID.IsDefined(this.m_lastTargetID) {
      this.m_lastTargetID = targetID;
    };
    if this.m_uniqueTarget {
      if targetID == this.m_lastTargetID {
        this.m_consecutiveHits += 1;
      } else {
        this.m_consecutiveHits = 1;
      };
    } else {
      this.m_consecutiveHits += 1;
    };
    this.m_lastTargetID = targetID;
    this.m_lastHitTime = attackTime;
    result = this.m_consecutiveHits % this.m_consecutiveHitsRequired == 0;
    return NotEquals(result, this.m_invert);
  }

  public func OnMissTriggered(missEvent: ref<gameMissEvent>) -> Void {
    this.m_consecutiveHits = 0;
    this.m_lastHitTime = -1.00;
    this.m_lastTargetID = EMPTY_ENTITY_ID();
  }
}
