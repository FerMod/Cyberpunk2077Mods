
public class HitIsQuickhackPresentInQueuePrereqCondition extends BaseHitPrereqCondition {

  public let m_hackCategory: wref<HackCategory_Record>;

  public let m_isTheNextQhInQueue: Bool;

  public func SetData(recordID: TweakDBID) -> Void {
    this.m_hackCategory = TweakDBInterface.GetHackCategoryRecord(TweakDBInterface.GetForeignKeyDefault(recordID + t".hackCategory"));
    this.m_isTheNextQhInQueue = TDB.GetBool(recordID + t".isTheNextQhInQueue");
    super.SetData(recordID);
  }

  public func Evaluate(hitEvent: ref<gameHitEvent>) -> Bool {
    let currentlyUploadingAction: ref<ScriptableDeviceAction>;
    let i: Int32;
    let objectActionRecord: ref<ObjectAction_Record>;
    let objectActionRecords: array<ref<ObjectAction_Record>>;
    let result: Bool;
    let target: wref<ScriptedPuppet> = hitEvent.target as ScriptedPuppet;
    if !IsDefined(target) {
      return false;
    };
    currentlyUploadingAction = target.GetCurrentlyUploadingAction();
    if IsDefined(currentlyUploadingAction) && IsDefined(currentlyUploadingAction.m_deviceActionQueue) && !currentlyUploadingAction.m_isInactive {
      ArrayPush(objectActionRecords, currentlyUploadingAction.GetObjectActionRecord());
      currentlyUploadingAction.m_deviceActionQueue.GetAllQueuedActionObjectRecords(objectActionRecords);
      i = 0;
      while i < ArraySize(objectActionRecords) {
        objectActionRecord = objectActionRecords[i];
        if this.m_hackCategory.GetID() == objectActionRecord.HackCategory().GetID() {
          result = true;
          break;
        };
        if this.m_isTheNextQhInQueue {
          break;
        };
        i += 1;
      };
    } else {
      return false;
    };
    if result {
      result = this.CheckOnlyOncePerShot(hitEvent);
    };
    return this.m_invert ? !result : result;
  }
}
