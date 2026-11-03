
public class TargetNPCTypeHitPrereqCondition extends BaseHitPrereqCondition {

  public let m_type: gamedataNPCType;

  public func SetData(recordID: TweakDBID) -> Void {
    let str: String = TweakDBInterface.GetString(recordID + t".npcType", "");
    this.m_type = IntEnum<gamedataNPCType>(Cast<Int32>(EnumValueFromString("gamedataNPCType", str)));
    super.SetData(recordID);
  }

  public func Evaluate(hitEvent: ref<gameHitEvent>) -> Bool {
    let result: Bool;
    let objectToCheck: wref<ScriptedPuppet> = hitEvent.target as ScriptedPuppet;
    if IsDefined(objectToCheck) {
      result = Equals(objectToCheck.GetNPCType(), this.m_type);
      if result {
        result = this.CheckOnlyOncePerShot(hitEvent);
      };
      return this.m_invert ? !result : result;
    };
    return false;
  }
}
