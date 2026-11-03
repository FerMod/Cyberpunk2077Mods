
public class StatPoolBasedStatusEffectEffectorListener extends ScriptStatPoolsListener {

  public let m_effector: wref<StatPoolBasedStatusEffectEffector>;

  public func OnStatPoolValueChanged(oldValue: Float, newValue: Float, percToPoints: Float) -> Void {
    this.m_effector.UpdateWithStatPoolValue(newValue, percToPoints);
  }
}

public class StatPoolBasedStatusEffectEffector extends Effector {

  private let m_statPool: gamedataStatPoolType;

  private let m_statusEffectID: TweakDBID;

  private let m_statPoolStep: Float;

  private let m_stepUsesPercent: Bool;

  private let m_startingThreshold: Float;

  private let m_thresholdUsesPercent: Bool;

  private let m_minStacks: Int32;

  private let m_maxStacks: Int32;

  private let m_inverted: Bool;

  private let m_roundUpwards: Bool;

  private let m_dontRemoveStacks: Bool;

  private let m_targetOfStatPoolCheck: String;

  private let m_listener: ref<StatPoolBasedStatusEffectEffectorListener>;

  private let m_currentStacks: Int32;

  private let m_realMaxStacks: Int32;

  private let m_statPoolRecordID: TweakDBID;

  private let m_gameInstance: GameInstance;

  private let m_ownerID: EntityID;

  private let m_checkStatPoolOnWeapon: Bool;

  private let m_ownerWeaponID: EntityID;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_gameInstance = game;
    this.m_statPoolRecordID = TDB.GetForeignKey(record + t".statPool");
    let statPoolRecord: ref<StatPool_Record> = TweakDBInterface.GetStatPoolRecord(this.m_statPoolRecordID);
    if IsDefined(statPoolRecord) {
      this.m_statPool = statPoolRecord.StatPoolType();
    } else {
      this.m_statPool = gamedataStatPoolType.Invalid;
    };
    this.m_statusEffectID = TDB.GetForeignKey(record + t".statusEffect");
    this.m_statPoolStep = TDB.GetFloat(record + t".statPoolStep");
    this.m_stepUsesPercent = TDB.GetBool(record + t".stepUsesPercent");
    this.m_startingThreshold = TDB.GetFloat(record + t".startingThreshold");
    this.m_thresholdUsesPercent = TDB.GetBool(record + t".thresholdUsesPercent");
    this.m_minStacks = Max(TDB.GetInt(record + t".minStacks"), 0);
    this.m_maxStacks = Max(TDB.GetInt(record + t".maxStacks"), 0);
    this.m_inverted = TDB.GetBool(record + t".inverted");
    this.m_roundUpwards = TDB.GetBool(record + t".roundUpwards");
    this.m_dontRemoveStacks = TDB.GetBool(record + t".dontRemoveStacks");
    this.m_targetOfStatPoolCheck = TDB.GetString(record + t".targetOfStatPoolCheck");
    if Equals(this.m_targetOfStatPoolCheck, "Weapon") {
      this.m_checkStatPoolOnWeapon = true;
    };
  }

  protected func Uninitialize(game: GameInstance) -> Void {
    this.Clear();
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    let checkedWeapon: ref<WeaponObject>;
    let statPoolsSystem: ref<StatPoolsSystem>;
    let statusEffectMaxStacks: Int32;
    let statusEffectMaxStacksModifiers: array<wref<StatModifier_Record>>;
    let statusEffectRecord: ref<StatusEffect_Record>;
    let targetOfStatPoolCheckID: EntityID;
    if Equals(this.m_statPool, gamedataStatPoolType.Invalid) {
      return;
    };
    this.m_ownerID = owner.GetEntityID();
    statPoolsSystem = GameInstance.GetStatPoolsSystem(this.m_gameInstance);
    if this.m_checkStatPoolOnWeapon {
      checkedWeapon = GameObject.GetActiveWeapon(owner);
      if !IsDefined(checkedWeapon) {
        return;
      };
      this.m_ownerWeaponID = checkedWeapon.GetEntityID();
      targetOfStatPoolCheckID = this.m_ownerWeaponID;
    } else {
      targetOfStatPoolCheckID = this.m_ownerID;
    };
    if !statPoolsSystem.IsStatPoolAdded(Cast<StatsObjectID>(targetOfStatPoolCheckID), this.m_statPool) {
      statPoolsSystem.RequestAddingStatPool(Cast<StatsObjectID>(targetOfStatPoolCheckID), this.m_statPoolRecordID);
    };
    if !statPoolsSystem.HasActiveStatPool(Cast<StatsObjectID>(targetOfStatPoolCheckID), this.m_statPool) {
      statPoolsSystem.RequestMarkingStatPoolActive(Cast<StatsObjectID>(targetOfStatPoolCheckID), this.m_statPool);
    };
    statusEffectRecord = TweakDBInterface.GetStatusEffectRecord(this.m_statusEffectID);
    if IsDefined(statusEffectRecord) {
      statusEffectRecord.MaxStacksHandle().StatModifiers(statusEffectMaxStacksModifiers);
      statusEffectMaxStacks = FloorF(GameInstance.GetStatsSystem(this.m_gameInstance).CalculateModifierListValue(Cast<StatsObjectID>(this.m_ownerID), statusEffectMaxStacksModifiers));
    };
    if statusEffectMaxStacks == 0 {
      return;
    };
    if statusEffectMaxStacks < 0 || this.m_maxStacks <= 0 {
      this.m_realMaxStacks = Max(statusEffectMaxStacks, this.m_maxStacks);
    } else {
      this.m_realMaxStacks = Min(statusEffectMaxStacks, this.m_maxStacks);
    };
    this.m_listener = new StatPoolBasedStatusEffectEffectorListener();
    this.m_listener.m_effector = this;
    statPoolsSystem.RequestRegisteringListener(Cast<StatsObjectID>(targetOfStatPoolCheckID), this.m_statPool, this.m_listener);
    this.UpdateWithStatPoolValue(statPoolsSystem.GetStatPoolValue(Cast<StatsObjectID>(targetOfStatPoolCheckID), this.m_statPool, true), statPoolsSystem.GetStatPoolMaxPointValue(Cast<StatsObjectID>(targetOfStatPoolCheckID), this.m_statPool) / 100.00);
  }

  protected func ActionOff(owner: ref<GameObject>) -> Void {
    this.Clear();
  }

  public final func UpdateWithStatPoolValue(newPercValue: Float, percToPoints: Float) -> Void {
    let newStacks: Int32;
    let percValueAfterThreshold: Float;
    let stacksChange: Int32;
    let tempStacksValue: Float;
    if this.m_statPoolStep <= 0.00 || percToPoints <= 0.00 || !TDBID.IsValid(this.m_statusEffectID) {
      return;
    };
    if !this.m_inverted {
      percValueAfterThreshold = this.m_thresholdUsesPercent ? newPercValue - this.m_startingThreshold : newPercValue - this.m_startingThreshold / percToPoints;
    } else {
      percValueAfterThreshold = this.m_thresholdUsesPercent ? this.m_startingThreshold - newPercValue : this.m_startingThreshold / percToPoints - newPercValue;
    };
    if percValueAfterThreshold < 0.00 {
      newStacks = 0;
    } else {
      tempStacksValue = this.m_stepUsesPercent ? percValueAfterThreshold / this.m_statPoolStep : percValueAfterThreshold / this.m_statPoolStep * percToPoints;
      if this.m_roundUpwards {
        newStacks = CeilF(tempStacksValue) + this.m_minStacks;
      } else {
        newStacks = FloorF(tempStacksValue) + this.m_minStacks;
      };
    };
    if this.m_realMaxStacks > 0 {
      newStacks = Min(newStacks, this.m_realMaxStacks);
    };
    stacksChange = newStacks - this.m_currentStacks;
    if stacksChange == 0 {
      return;
    };
    this.m_currentStacks = newStacks;
    this.ProcessStacksChange(stacksChange);
  }

  private final func ProcessStacksChange(stacksChange: Int32) -> Void {
    if stacksChange > 0 {
      GameInstance.GetStatusEffectSystem(this.m_gameInstance).ApplyStatusEffect(this.m_ownerID, this.m_statusEffectID, TDBID.None(), this.m_ownerID, Cast<Uint32>(stacksChange), Vector4.EmptyVector(), false);
    } else {
      if !this.m_dontRemoveStacks {
        GameInstance.GetStatusEffectSystem(this.m_gameInstance).RemoveStatusEffect(this.m_ownerID, this.m_statusEffectID, Cast<Uint32>(Abs(stacksChange)));
      };
    };
  }

  private final func Clear() -> Void {
    if Equals(this.m_statPool, gamedataStatPoolType.Invalid) {
      return;
    };
    if IsDefined(this.m_listener) {
      if this.m_checkStatPoolOnWeapon {
        GameInstance.GetStatPoolsSystem(this.m_gameInstance).RequestUnregisteringListener(Cast<StatsObjectID>(this.m_ownerWeaponID), this.m_statPool, this.m_listener);
      } else {
        GameInstance.GetStatPoolsSystem(this.m_gameInstance).RequestUnregisteringListener(Cast<StatsObjectID>(this.m_ownerID), this.m_statPool, this.m_listener);
      };
      this.m_listener = null;
    };
    this.ProcessStacksChange(-this.m_currentStacks);
    this.m_currentStacks = 0;
  }
}
