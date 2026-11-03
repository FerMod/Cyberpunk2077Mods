
public class ModifyDamageEffectorStatListener extends ScriptStatsListener {

  public let m_effector: wref<ModifyDamageEffector>;

  public func OnStatChanged(ownerID: StatsObjectID, statType: gamedataStatType, diff: Float, total: Float) -> Void {
    this.m_effector.m_statBasedValue = total;
  }
}

public class ModifyDamageEffector extends ModifyAttackEffector {

  protected let m_operationType: EMathOperator;

  protected let m_value: Float;

  @default(ModifyDamageEffector, gamedataStatType.Invalid)
  protected let m_statType: gamedataStatType;

  private let m_ownerID: EntityID;

  private let m_statListener: ref<ModifyDamageEffectorStatListener>;

  public let m_statBasedValue: Float;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    let str: String = TDB.GetString(record + t".operationType");
    this.m_operationType = IntEnum<EMathOperator>(Cast<Int32>(EnumValueFromString("EMathOperator", str)));
    this.m_value = TDB.GetFloat(record + t".value");
    let statRecord: ref<Stat_Record> = TweakDBInterface.GetStatRecord(TDB.GetForeignKey(record + t".statForValue"));
    if IsDefined(statRecord) {
      this.m_statType = statRecord.StatType();
      this.InitializeStatListener(game);
    };
  }

  protected func Uninitialize(game: GameInstance) -> Void {
    this.UninitializeStatListener(game);
  }

  private final func InitializeStatListener(game: GameInstance) -> Void {
    let owner: ref<GameObject>;
    let statsSystem: ref<StatsSystem>;
    if Equals(this.m_statType, gamedataStatType.Invalid) {
      return;
    };
    if IsDefined(this.m_statListener) {
      return;
    };
    owner = this.GetOwner();
    if !IsDefined(owner) {
      return;
    };
    this.m_ownerID = owner.GetEntityID();
    this.m_statListener = new ModifyDamageEffectorStatListener();
    this.m_statListener.m_effector = this;
    this.m_statListener.SetStatType(this.m_statType);
    statsSystem = GameInstance.GetStatsSystem(game);
    statsSystem.RegisterListener(Cast<StatsObjectID>(this.m_ownerID), this.m_statListener);
    this.m_statBasedValue = statsSystem.GetStatValue(Cast<StatsObjectID>(this.m_ownerID), this.m_statType);
  }

  private final func UninitializeStatListener(game: GameInstance) -> Void {
    if IsDefined(this.m_statListener) {
      GameInstance.GetStatsSystem(game).UnregisterListener(Cast<StatsObjectID>(this.m_ownerID), this.m_statListener);
      this.m_statListener = null;
    };
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    let valueToUse: Float;
    let hitEvent: ref<gameHitEvent> = this.GetHitEvent();
    if !IsDefined(hitEvent) {
      return;
    };
    if NotEquals(this.m_statType, gamedataStatType.Invalid) {
      valueToUse = this.m_statBasedValue;
    } else {
      valueToUse = this.m_value;
    };
    this.ModifyDamage(hitEvent, this.m_operationType, valueToUse);
  }

  protected final func ModifyDamage(hitEvent: ref<gameHitEvent>, operationType: EMathOperator, value: Float) -> Void {
    switch operationType {
      case EMathOperator.Add:
        hitEvent.attackComputed.AddAttackValue(value);
        break;
      case EMathOperator.Subtract:
        hitEvent.attackComputed.AddAttackValue(-value);
        break;
      case EMathOperator.Multiply:
        hitEvent.attackComputed.MultAttackValue(value);
        break;
      case EMathOperator.Divide:
        hitEvent.attackComputed.MultAttackValue(1.00 / value);
        break;
      default:
        return;
    };
  }
}
