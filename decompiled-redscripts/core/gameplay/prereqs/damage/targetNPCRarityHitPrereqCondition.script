
public class TargetNPCRarityHitPrereqCondition extends BaseHitPrereqCondition {

  public let m_rarity: gamedataNPCRarity;

  public func SetData(recordID: TweakDBID) -> Void {
    let str: String = TweakDBInterface.GetString(recordID + t".rarity", "");
    this.m_rarity = IntEnum<gamedataNPCRarity>(Cast<Int32>(EnumValueFromString("gamedataNPCRarity", str)));
    super.SetData(recordID);
  }

  public func Evaluate(hitEvent: ref<gameHitEvent>) -> Bool {
    let rarity: gamedataNPCRarity;
    let result: Bool;
    let objectToCheck: wref<ScriptedPuppet> = hitEvent.target as ScriptedPuppet;
    if IsDefined(objectToCheck) {
      rarity = objectToCheck.GetNPCRarity();
      result = Equals(rarity, this.m_rarity);
      if result {
        result = this.CheckOnlyOncePerShot(hitEvent);
      };
      return this.m_invert ? !result : result;
    };
    return false;
  }
}
