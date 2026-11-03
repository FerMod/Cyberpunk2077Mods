
public class StatPoolComparisonHitPrereqCondition extends BaseHitPrereqCondition {

  public let m_comparisonSource: CName;

  public let m_comparisonTarget: CName;

  public let m_comparisonType: EComparisonType;

  public let m_statPoolToCompare: gamedataStatPoolType;

  protected func SetData(recordID: TweakDBID) -> Void {
    this.m_comparisonSource = TweakDBInterface.GetCName(recordID + t".comparisonSource", n"None");
    this.m_comparisonTarget = TweakDBInterface.GetCName(recordID + t".comparisonTarget", n"None");
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
    let sourcePoolValue: Float;
    let sps: ref<StatPoolsSystem>;
    let targetPoolValue: Float;
    let source: wref<GameObject> = this.GetObjectToCheck(this.m_comparisonSource, hitEvent);
    let target: wref<GameObject> = this.GetObjectToCheck(this.m_comparisonTarget, hitEvent);
    if !IsDefined(source) || !IsDefined(target) {
      return false;
    };
    sps = GameInstance.GetStatPoolsSystem(source.GetGame());
    sourcePoolValue = sps.GetStatPoolValue(Cast<StatsObjectID>(source.GetEntityID()), this.m_statPoolToCompare);
    targetPoolValue = sps.GetStatPoolValue(Cast<StatsObjectID>(target.GetEntityID()), this.m_statPoolToCompare);
    return ProcessCompare(this.m_comparisonType, sourcePoolValue, targetPoolValue);
  }
}
