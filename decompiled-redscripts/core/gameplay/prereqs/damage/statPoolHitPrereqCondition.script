
public class StatPoolHitPrereqCondition extends BaseHitPrereqCondition {

  public let m_valueToCheck: Float;

  public let m_objectToCheck: CName;

  public let m_comparisonType: EComparisonType;

  public let m_statPoolToCompare: gamedataStatPoolType;

  protected func SetData(recordID: TweakDBID) -> Void {
    this.m_objectToCheck = TweakDBInterface.GetCName(recordID + t".objectToCheck", n"None");
    this.m_valueToCheck = TweakDBInterface.GetFloat(recordID + t".valueToCheck", 0.00);
    let str: String = TweakDBInterface.GetString(recordID + t".statPoolToCompare", "");
    this.m_statPoolToCompare = IntEnum<gamedataStatPoolType>(Cast<Int32>(EnumValueFromString("gamedataStatPoolType", str)));
    str = TweakDBInterface.GetString(recordID + t".comparisonType", "");
    this.m_comparisonType = IntEnum<EComparisonType>(Cast<Int32>(EnumValueFromString("EComparisonType", str)));
    super.SetData(recordID);
  }

  public func Evaluate(hitEvent: ref<gameHitEvent>) -> Bool {
    let result: Bool = this.ComparePoolValues(hitEvent);
    if result {
      result = this.CheckOnlyOncePerShot(hitEvent);
    };
    return this.m_invert ? !result : result;
  }

  private final func ComparePoolValues(hitEvent: ref<gameHitEvent>) -> Bool {
    let poolValue: Float;
    let sps: ref<StatPoolsSystem>;
    let obj: wref<GameObject> = this.GetObjectToCheck(this.m_objectToCheck, hitEvent);
    if !IsDefined(obj) {
      return false;
    };
    sps = GameInstance.GetStatPoolsSystem(obj.GetGame());
    poolValue = sps.GetStatPoolValue(Cast<StatsObjectID>(obj.GetEntityID()), this.m_statPoolToCompare);
    return ProcessCompare(this.m_comparisonType, poolValue, this.m_valueToCheck);
  }
}
