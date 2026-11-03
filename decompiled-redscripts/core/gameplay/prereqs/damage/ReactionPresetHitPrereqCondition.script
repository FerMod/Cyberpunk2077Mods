
public class ReactionPresetHitPrereqCondition extends BaseHitPrereqCondition {

  public let m_reactionPreset: String;

  public func SetData(recordID: TweakDBID) -> Void {
    this.m_reactionPreset = TweakDBInterface.GetString(recordID + t".reactionPreset", "");
    super.SetData(recordID);
  }

  public func Evaluate(hitEvent: ref<gameHitEvent>) -> Bool {
    let result: Bool;
    let objectToCheck: wref<ScriptedPuppet> = hitEvent.target as ScriptedPuppet;
    if !IsDefined(objectToCheck) {
      return false;
    };
    switch this.m_reactionPreset {
      case "Civilian":
        result = objectToCheck.IsCharacterCivilian();
        break;
      case "Police":
        result = objectToCheck.IsCharacterPolice();
        break;
      case "Ganger":
        result = objectToCheck.IsCharacterGanger();
        break;
      default:
        return false;
    };
    if result {
      result = this.CheckOnlyOncePerShot(hitEvent);
    };
    return this.m_invert ? !result : result;
  }
}
