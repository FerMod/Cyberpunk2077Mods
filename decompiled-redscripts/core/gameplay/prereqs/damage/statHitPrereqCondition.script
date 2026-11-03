
public class StatHitPrereqCondition extends BaseHitPrereqCondition {

  public let m_valueToCheck: Float;

  public let m_objectToCheck: CName;

  public let m_comparisonType: EComparisonType;

  public let m_statToCompare: gamedataStatType;

  protected func SetData(recordID: TweakDBID) -> Void {
    this.m_objectToCheck = TweakDBInterface.GetCName(recordID + t".objectToCheck", n"None");
    this.m_valueToCheck = TweakDBInterface.GetFloat(recordID + t".valueToCheck", 0.00);
    let str: String = TweakDBInterface.GetString(recordID + t".statToCompare", "");
    this.m_statToCompare = IntEnum<gamedataStatType>(Cast<Int32>(EnumValueFromString("gamedataStatType", str)));
    str = TweakDBInterface.GetString(recordID + t".comparisonType", "");
    this.m_comparisonType = IntEnum<EComparisonType>(Cast<Int32>(EnumValueFromString("EComparisonType", str)));
    super.SetData(recordID);
  }

  public func Evaluate(hitEvent: ref<gameHitEvent>) -> Bool {
    let result: Bool = this.CompareValues(hitEvent);
    if result {
      result = this.CheckOnlyOncePerShot(hitEvent);
    };
    return this.m_invert ? !result : result;
  }

  private final func CompareValues(hitEvent: ref<gameHitEvent>) -> Bool {
    let ss: ref<StatsSystem>;
    let statValue: Float;
    let obj: wref<GameObject> = this.GetObjectToCheck(this.m_objectToCheck, hitEvent);
    if !IsDefined(obj) {
      return false;
    };
    ss = GameInstance.GetStatsSystem(obj.GetGame());
    statValue = ss.GetStatValue(Cast<StatsObjectID>(obj.GetEntityID()), this.m_statToCompare);
    return ProcessCompare(this.m_comparisonType, statValue, this.m_valueToCheck);
  }
}
