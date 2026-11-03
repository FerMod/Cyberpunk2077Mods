
public class StatPoolChangeOverTimePrereqListener extends BaseStatPoolPrereqListener {

  protected let m_state: wref<StatPoolChangeOverTimePrereqState>;

  public func OnStatPoolValueChanged(oldValue: Float, newValue: Float, percToPoints: Float) -> Void {
    this.m_state.StatPoolUpdate(oldValue, newValue, percToPoints);
  }

  public func RegisterState(state: ref<PrereqState>) -> Void {
    this.m_state = state as StatPoolChangeOverTimePrereqState;
  }
}

public class StatPoolChangeOverTimePrereqState extends PrereqState {

  public let m_statPoolListener: ref<BaseStatPoolPrereqListener>;

  public let m_ownerID: StatsObjectID;

  public let m_valueToCheck: Float;

  public let m_timeFrame: Float;

  public let m_comparePercentage: Bool;

  public let m_checkGain: Bool;

  public let m_history: [ChangeInfoWithTimeStamp];

  public let m_GameInstance: GameInstance;

  public func StatPoolUpdate(oldValue: Float, newValue: Float, percToPoints: Float) -> Void {
    let changeDelta: Float;
    let checkPassed: Bool;
    let tempInfo: ChangeInfoWithTimeStamp;
    if this.m_checkGain {
      changeDelta = newValue - oldValue;
    } else {
      changeDelta = oldValue - newValue;
    };
    if !this.m_comparePercentage {
      changeDelta = changeDelta * percToPoints;
    };
    if changeDelta > 0.00 {
      tempInfo = new ChangeInfoWithTimeStamp(EngineTime.ToFloat(GameInstance.GetTimeSystem(this.m_GameInstance).GetSimTime()), changeDelta);
      ArrayPush(this.m_history, tempInfo);
      checkPassed = this.CheckHistory();
    };
    this.OnChanged(checkPassed);
  }

  public func RegisterStatPoolListener(game: GameInstance, statPoolType: gamedataStatPoolType, owner: EntityID) -> Void {
    if EntityID.IsDefined(owner) {
      this.m_ownerID = Cast<StatsObjectID>(owner);
      this.m_GameInstance = game;
      this.m_statPoolListener = new StatPoolChangeOverTimePrereqListener();
      this.m_statPoolListener.RegisterState(this);
      GameInstance.GetStatPoolsSystem(this.m_GameInstance).RequestRegisteringListener(this.m_ownerID, statPoolType, this.m_statPoolListener);
    };
  }

  public func UnregisterStatPoolListener(game: GameInstance, statPoolType: gamedataStatPoolType) -> Void {
    if IsDefined(this.m_statPoolListener) {
      GameInstance.GetStatPoolsSystem(game).RequestUnregisteringListener(this.m_ownerID, statPoolType, this.m_statPoolListener);
    };
    this.m_statPoolListener = null;
  }

  private final func CheckHistory() -> Bool {
    let currentInfo: ChangeInfoWithTimeStamp;
    let retVal: Bool;
    let toDelete: array<ChangeInfoWithTimeStamp>;
    let totalChange: Float;
    let currentTimeStamp: Float = EngineTime.ToFloat(GameInstance.GetTimeSystem(this.m_GameInstance).GetSimTime());
    let i: Int32 = ArraySize(this.m_history) - 1;
    while i >= 0 {
      currentInfo = this.m_history[i];
      if currentTimeStamp - currentInfo.TimeStamp < this.m_timeFrame {
        totalChange += currentInfo.Change;
        if totalChange >= this.m_valueToCheck {
          retVal = true;
          ArrayClear(this.m_history);
          return retVal;
        };
      } else {
        ArrayPush(toDelete, currentInfo);
      };
      i -= 1;
    };
    i = 0;
    while i < ArraySize(toDelete) {
      ArrayRemove(this.m_history, toDelete[i]);
      i += 1;
    };
    return retVal;
  }
}

public class StatPoolChangeOverTimePrereq extends IScriptablePrereq {

  public let m_statPoolType: gamedataStatPoolType;

  public let m_timeFrame: Float;

  public let m_valueToCheck: Float;

  public let m_comparePercentage: Bool;

  public let m_checkGain: Bool;

  protected const func OnRegister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Bool {
    let castedState: ref<StatPoolChangeOverTimePrereqState> = state as StatPoolChangeOverTimePrereqState;
    castedState.m_comparePercentage = this.m_comparePercentage;
    castedState.m_checkGain = this.m_checkGain;
    castedState.m_timeFrame = this.m_timeFrame;
    castedState.m_valueToCheck = this.m_valueToCheck;
    let owner: ref<GameObject> = context as GameObject;
    castedState.RegisterStatPoolListener(game, this.m_statPoolType, owner.GetEntityID());
    return false;
  }

  protected const func OnUnregister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Void {
    let castedState: ref<StatPoolChangeOverTimePrereqState> = state as StatPoolChangeOverTimePrereqState;
    castedState.UnregisterStatPoolListener(game, this.m_statPoolType);
  }

  protected func Initialize(record: TweakDBID) -> Void {
    this.m_statPoolType = IntEnum<gamedataStatPoolType>(Cast<Int32>(EnumValueFromName(n"gamedataStatPoolType", TweakDBInterface.GetCName(record + t".statPoolType", n"Health"))));
    this.m_comparePercentage = TweakDBInterface.GetBool(record + t".comparePercentage", true);
    this.m_valueToCheck = TweakDBInterface.GetFloat(record + t".valueToCheck", 50.00);
    this.m_timeFrame = TweakDBInterface.GetFloat(record + t".timeFrame", 3.00);
    this.m_checkGain = TweakDBInterface.GetBool(record + t".checkGain", false);
  }
}
