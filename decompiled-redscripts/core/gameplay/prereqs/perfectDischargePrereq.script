
public class PerfectDischargePrereqListener extends ScriptStatPoolsListener {

  protected let m_state: wref<PerfectDischargePrereqState>;

  public final func RegisterState(state: ref<PrereqState>) -> Void {
    this.m_state = state as PerfectDischargePrereqState;
  }

  public func OnStatPoolValueChanged(oldValue: Float, newValue: Float, percToPoints: Float) -> Void {
    if IsDefined(this.m_state) {
      this.m_state.StatPoolUpdate(oldValue, newValue);
    };
  }
}

public class PerfectDischargePrereqState extends StatPoolPrereqState {

  public let m_owner: wref<GameObject>;

  public let m_perfectDischargeListener: ref<PerfectDischargePrereqListener>;

  public let m_wasPerfectlyCharged: Bool;

  public func StatPoolUpdate(oldValue: Float, newValue: Float) -> Void {
    let checkPassed: Bool;
    let game: GameInstance;
    let perfectChargeWindow: Float;
    let perfectDischargeWindowEnd: Float;
    let perfectDischargeWindowStart: Float;
    let player: ref<GameObject>;
    let prereq: ref<PerfectDischargePrereq>;
    let weaponObject: ref<WeaponObject>;
    if !IsDefined(this.m_owner) {
      return;
    };
    prereq = this.GetPrereq() as PerfectDischargePrereq;
    weaponObject = ScriptedPuppet.GetActiveWeapon(this.m_owner);
    if !IsDefined(weaponObject) {
      return;
    };
    game = weaponObject.GetGame();
    player = GameInstance.GetPlayerSystem(game).GetLocalPlayerControlledGameObject();
    perfectChargeWindow = GameInstance.GetStatsSystem(game).GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.PerfectChargeWindow);
    perfectDischargeWindowEnd = weaponObject.GetMaxChargeTreshold();
    perfectDischargeWindowStart = ((100.00 - perfectChargeWindow) * perfectDischargeWindowEnd) / 100.00;
    if oldValue == 0.00 || newValue == 0.00 {
      this.m_wasPerfectlyCharged = false;
    };
    checkPassed = newValue >= perfectDischargeWindowStart && newValue < perfectDischargeWindowEnd - 1.00;
    checkPassed = prereq.AddTimeWindow(game, player, checkPassed, this);
    this.OnChanged(checkPassed ^ prereq.m_invert);
  }

  public func RegisterStatPoolListener(game: GameInstance, statPoolType: gamedataStatPoolType, valueToCheck: Float) -> Void {
    if StatsObjectID.IsDefined(this.m_statsObjID) {
      this.m_perfectDischargeListener = new PerfectDischargePrereqListener();
      this.m_perfectDischargeListener.RegisterState(this);
      GameInstance.GetStatPoolsSystem(game).RequestRegisteringListener(this.m_statsObjID, statPoolType, this.m_perfectDischargeListener);
    };
  }

  public func UnregisterStatPoolListener(game: GameInstance, statPoolType: gamedataStatPoolType) -> Void {
    if IsDefined(this.m_perfectDischargeListener) {
      GameInstance.GetStatPoolsSystem(game).RequestUnregisteringListener(this.m_statsObjID, statPoolType, this.m_perfectDischargeListener);
    };
    this.m_perfectDischargeListener = null;
  }
}

public class PerfectDischargePrereq extends StatPoolPrereq {

  public let m_invert: Bool;

  protected const func OnRegister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Bool {
    let castedState: ref<PerfectDischargePrereqState>;
    let weaponObject: ref<WeaponObject> = ScriptedPuppet.GetActiveWeapon(context as GameObject);
    if !IsDefined(weaponObject) {
      return false;
    };
    castedState = state as PerfectDischargePrereqState;
    castedState.m_owner = context as GameObject;
    castedState.m_statsObjID = this.GetStatsObjectID(context as GameObject);
    castedState.RegisterStatPoolListener(game, this.m_statPoolType, this.GetValueToCheck(castedState));
    castedState.m_wasPerfectlyCharged = false;
    return false;
  }

  protected func Initialize(recordID: TweakDBID) -> Void {
    let objectToCheck: CName;
    let record: ref<StatPoolPrereq_Record> = TweakDBInterface.GetStatPoolPrereqRecord(recordID);
    this.m_invert = TweakDBInterface.GetBool(recordID + t".invert", false);
    this.m_statPoolType = gamedataStatPoolType.WeaponCharge;
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
    return this.IsDischargePerfect(game, ScriptedPuppet.GetActiveWeapon(context as GameObject));
  }

  protected const func OnApplied(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Void {
    let castedState: ref<PerfectDischargePrereqState>;
    let result: Bool;
    if this.m_skipOnApply {
      return;
    };
    castedState = state as PerfectDischargePrereqState;
    if GameInstance.GetStatPoolsSystem(game).IsStatPoolAdded(castedState.m_statsObjID, gamedataStatPoolType.WeaponCharge) {
      result = this.IsDischargePerfect(game, ScriptedPuppet.GetActiveWeapon(context as GameObject), castedState);
      castedState.OnChanged(result);
    };
  }

  protected final const func IsDischargePerfect(game: GameInstance, weaponObject: ref<WeaponObject>, opt state: ref<PerfectDischargePrereqState>) -> Bool {
    let chargeVal: Float;
    let isDischargePerfect: Bool;
    let perfectChargeWindow: Float;
    let perfectDischargeWindowEnd: Float;
    let perfectDischargeWindowStart: Float;
    let player: ref<GameObject>;
    let statPoolSystem: ref<StatPoolsSystem> = GameInstance.GetStatPoolsSystem(game);
    if !IsDefined(weaponObject) {
      return false;
    };
    player = GameInstance.GetPlayerSystem(game).GetLocalPlayerControlledGameObject();
    perfectChargeWindow = GameInstance.GetStatsSystem(weaponObject.GetGame()).GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.PerfectChargeWindow);
    chargeVal = statPoolSystem.GetStatPoolValue(Cast<StatsObjectID>(weaponObject.GetEntityID()), gamedataStatPoolType.WeaponCharge, false);
    perfectDischargeWindowEnd = weaponObject.GetMaxChargeTreshold();
    perfectDischargeWindowStart = ((100.00 - perfectChargeWindow) * perfectDischargeWindowEnd) / 100.00;
    isDischargePerfect = chargeVal >= perfectDischargeWindowStart && chargeVal < perfectDischargeWindowEnd - 1.00;
    isDischargePerfect = this.AddTimeWindow(game, player, isDischargePerfect, state);
    return isDischargePerfect ^ this.m_invert;
  }

  public final const func AddTimeWindow(game: GameInstance, player: ref<GameObject>, isDischargePerfect: Bool, state: ref<PerfectDischargePrereqState>) -> Bool {
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(game);
    let canControlFullyChargedWeapon: Bool = statsSystem.GetStatBoolValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.CanControlFullyChargedWeapon);
    if !IsDefined(state) || !canControlFullyChargedWeapon {
      return isDischargePerfect;
    };
    if isDischargePerfect && !state.m_wasPerfectlyCharged {
      state.m_wasPerfectlyCharged = true;
    };
    return state.m_wasPerfectlyCharged;
  }
}
