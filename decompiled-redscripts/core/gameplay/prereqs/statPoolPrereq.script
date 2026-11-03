
public class BaseStatPoolPrereqListener extends CustomValueStatPoolsListener {

  public func RegisterState(state: ref<PrereqState>) -> Void;
}

public class StatPoolPrereqListener extends BaseStatPoolPrereqListener {

  protected let m_state: wref<StatPoolPrereqState>;

  protected cb func OnStatPoolValueReached(oldValue: Float, newValue: Float, percToPoints: Float) -> Bool {
    this.m_state.StatPoolUpdate(oldValue, newValue);
  }

  public func RegisterState(state: ref<PrereqState>) -> Void {
    this.m_state = state as StatPoolPrereqState;
  }

  public func OnStatPoolValueChanged(oldValue: Float, newValue: Float, percToPoints: Float) -> Void {
    if this.m_state.m_statpoolWasMissing {
      this.m_state.m_statpoolWasMissing = false;
      this.m_state.StatPoolUpdate(oldValue, newValue);
    };
  }
}

public class StatPoolPrereqState extends PrereqState {

  public let m_statPoolListener: ref<BaseStatPoolPrereqListener>;

  public let m_statpoolWasMissing: Bool;

  public let m_object: wref<GameObject>;

  public let m_statsObjID: StatsObjectID;

  public func StatPoolUpdate(oldValue: Float, newValue: Float) -> Void {
    let prereq: ref<StatPoolPrereq> = this.GetPrereq() as StatPoolPrereq;
    let valueToCheck: Float = RPGManager.CalculateStatModifiers(prereq.m_valueToCheck, this.m_object.GetGame(), this.m_object, this.m_statsObjID);
    let checkPassed: Bool = ProcessCompare(prereq.m_comparisonType, newValue, valueToCheck);
    this.OnChanged(checkPassed);
  }

  public func RegisterStatPoolListener(game: GameInstance, statPoolType: gamedataStatPoolType, valueToCheck: Float) -> Void {
    if StatsObjectID.IsDefined(this.m_statsObjID) {
      this.m_statPoolListener = new StatPoolPrereqListener();
      this.m_statPoolListener.RegisterState(this);
      this.m_statPoolListener.SetValue(valueToCheck);
      GameInstance.GetStatPoolsSystem(game).RequestRegisteringListener(this.m_statsObjID, statPoolType, this.m_statPoolListener);
    };
  }

  public func UnregisterStatPoolListener(game: GameInstance, statPoolType: gamedataStatPoolType) -> Void {
    if IsDefined(this.m_statPoolListener) {
      GameInstance.GetStatPoolsSystem(game).RequestUnregisteringListener(this.m_statsObjID, statPoolType, this.m_statPoolListener);
    };
    this.m_statPoolListener = null;
  }
}

public class StatPoolPrereq extends IScriptablePrereq {

  public let m_statPoolType: gamedataStatPoolType;

  public let m_valueToCheck: [wref<StatModifier_Record>];

  public let m_comparisonType: EComparisonType;

  public let m_skipOnApply: Bool;

  public let m_comparePercentage: Bool;

  public let m_objToCheck: ObjectToCheck;

  protected final const func GetStatsObjectID(owner: ref<GameObject>) -> StatsObjectID {
    let weapon: ref<WeaponObject>;
    if Equals(this.m_objToCheck, ObjectToCheck.Weapon) {
      weapon = ScriptedPuppet.GetActiveWeapon(owner);
      if !IsDefined(weapon) {
        return new StatsObjectID();
      };
      return weapon.GetItemData().GetStatsObjectID();
    };
    return Cast<StatsObjectID>(owner.GetEntityID());
  }

  protected final const func GetObject(owner: ref<GameObject>) -> ref<GameObject> {
    if Equals(this.m_objToCheck, ObjectToCheck.Weapon) {
      return ScriptedPuppet.GetActiveWeapon(owner);
    };
    return owner;
  }

  protected final const func GetValueToCheck(state: ref<StatPoolPrereqState>) -> Float {
    return RPGManager.CalculateStatModifiers(this.m_valueToCheck, state.m_object.GetGame(), state.m_object, state.m_statsObjID);
  }

  protected const func OnRegister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Bool {
    let owner: ref<GameObject> = context as GameObject;
    let castedState: ref<StatPoolPrereqState> = state as StatPoolPrereqState;
    castedState.m_object = this.GetObject(owner);
    castedState.m_statsObjID = this.GetStatsObjectID(owner);
    castedState.RegisterStatPoolListener(game, this.m_statPoolType, this.GetValueToCheck(castedState));
    return false;
  }

  protected const func OnUnregister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Void {
    let castedState: ref<StatPoolPrereqState> = state as StatPoolPrereqState;
    castedState.UnregisterStatPoolListener(game, this.m_statPoolType);
  }

  protected func Initialize(recordID: TweakDBID) -> Void {
    let objectToCheck: CName;
    let record: ref<StatPoolPrereq_Record> = TweakDBInterface.GetStatPoolPrereqRecord(recordID);
    this.m_statPoolType = IntEnum<gamedataStatPoolType>(Cast<Int32>(EnumValueFromName(n"gamedataStatPoolType", record.StatPoolType())));
    record.ValueToCheck(this.m_valueToCheck);
    this.m_comparisonType = IntEnum<EComparisonType>(Cast<Int32>(EnumValueFromName(n"EComparisonType", record.ComparisonType())));
    this.m_skipOnApply = TweakDBInterface.GetBool(recordID + t".skipOnApply", false);
    this.m_comparePercentage = TweakDBInterface.GetBool(recordID + t".comparePercentage", true);
    objectToCheck = record.ObjectToCheck();
    if Equals(objectToCheck, n"Weapon") {
      this.m_objToCheck = ObjectToCheck.Weapon;
    } else {
      this.m_objToCheck = ObjectToCheck.Player;
    };
  }

  public const func IsFulfilled(game: GameInstance, context: ref<IScriptable>) -> Bool {
    return this.CompareValues(this.GetObject(context as GameObject), this.GetStatsObjectID(context as GameObject), context);
  }

  protected const func OnApplied(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Void {
    let castedState: ref<StatPoolPrereqState>;
    let result: Bool;
    if this.m_skipOnApply {
      return;
    };
    castedState = state as StatPoolPrereqState;
    if GameInstance.GetStatPoolsSystem(game).IsStatPoolAdded(castedState.m_statsObjID, this.m_statPoolType) {
      result = this.CompareValues(castedState.m_object, castedState.m_statsObjID, context);
      castedState.OnChanged(result);
    } else {
      castedState.m_statpoolWasMissing = true;
    };
  }

  protected final const func CompareValues(object: wref<GameObject>, statsObjID: StatsObjectID, context: ref<IScriptable>) -> Bool {
    let currentValue: Float;
    let valueToCheck: Float;
    let owner: wref<GameObject> = context as GameObject;
    if IsDefined(owner) {
      currentValue = GameInstance.GetStatPoolsSystem(owner.GetGame()).GetStatPoolValue(statsObjID, this.m_statPoolType, this.m_comparePercentage);
      valueToCheck = RPGManager.CalculateStatModifiers(this.m_valueToCheck, owner.GetGame(), object, statsObjID);
      return ProcessCompare(this.m_comparisonType, currentValue, valueToCheck);
    };
    return false;
  }
}
