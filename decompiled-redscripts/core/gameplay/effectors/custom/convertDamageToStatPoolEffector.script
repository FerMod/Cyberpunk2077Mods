
public class ConvertDamageToStatPoolEffector extends HitEventEffector {

  private let m_statPoolType: gamedataStatPoolType;

  private let m_operationType: EMathOperator;

  private let m_value: Float;

  protected func Initialize(recordID: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    let record: ref<ConvertDamageToStatPoolEffector_Record> = TweakDBInterface.GetConvertDamageToStatPoolEffectorRecord(recordID);
    this.m_statPoolType = record.StatPoolType().StatPoolType();
    this.m_operationType = IntEnum<EMathOperator>(Cast<Int32>(EnumValueFromName(n"EMathOperator", record.OpSymbol())));
    this.m_value = record.Value();
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    this.ProcessAction(owner);
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    this.ProcessAction(owner);
  }

  private final func ProcessAction(owner: ref<GameObject>) -> Void {
    let statPoolsSystem: ref<StatPoolsSystem> = GameInstance.GetStatPoolsSystem(owner.GetGame());
    let hitEvent: ref<gameHitEvent> = this.GetHitEvent();
    let damageScaled: Float = hitEvent.attackComputed.GetTotalAttackValue(gamedataStatPoolType.Health) * this.m_value;
    let calculatedValue: Float = 0.00;
    switch this.m_operationType {
      case EMathOperator.Add:
        calculatedValue = statPoolsSystem.GetStatPoolValue(Cast<StatsObjectID>(owner.GetEntityID()), this.m_statPoolType, false) + damageScaled;
        break;
      case EMathOperator.Subtract:
        calculatedValue = statPoolsSystem.GetStatPoolValue(Cast<StatsObjectID>(owner.GetEntityID()), this.m_statPoolType, false) - damageScaled;
        break;
      case EMathOperator.Multiply:
        calculatedValue = statPoolsSystem.GetStatPoolValue(Cast<StatsObjectID>(owner.GetEntityID()), this.m_statPoolType, false) * damageScaled;
        break;
      case EMathOperator.Divide:
        calculatedValue = statPoolsSystem.GetStatPoolValue(Cast<StatsObjectID>(owner.GetEntityID()), this.m_statPoolType, false) / damageScaled;
        break;
      default:
        return;
    };
    statPoolsSystem.RequestSettingStatPoolValue(Cast<StatsObjectID>(owner.GetEntityID()), this.m_statPoolType, calculatedValue, owner, false);
  }
}
