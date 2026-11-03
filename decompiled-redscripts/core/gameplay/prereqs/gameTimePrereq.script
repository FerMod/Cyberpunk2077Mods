
public class GameTimePrereqState extends PrereqState {

  public let m_listener: Uint32;

  public let m_repeated: Bool;

  public func UpdatePrereq() -> Void {
    if this.m_repeated {
      this.OnChangedRepeated(false);
    } else {
      this.OnChanged(true);
    };
  }
}

public class GameTimePrereq extends IScriptablePrereq {

  public let m_delay: Float;

  public let m_repeated: Bool;

  @default(GameTimePrereq, gamedataStatType.Invalid)
  private let m_delayFromStat: gamedataStatType;

  protected const func OnRegister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Bool {
    let statVal: Float;
    let delay: Float = this.m_delay;
    let castedState: ref<GameTimePrereqState> = state as GameTimePrereqState;
    let evt: ref<DelayPrereqEvent> = new DelayPrereqEvent();
    evt.m_state = castedState;
    castedState.m_repeated = this.m_repeated;
    if NotEquals(this.m_delayFromStat, gamedataStatType.Invalid) {
      statVal = GameInstance.GetStatsSystem(game).GetStatValue(Cast<StatsObjectID>((context as GameObject).GetEntityID()), this.m_delayFromStat);
      if statVal > 0.00 {
        delay = statVal / TweakDBInterface.GetFloat(t"timeSystem.settings.realTimeMultiplier", 1.00);
      };
    };
    if this.m_repeated {
      castedState.m_listener = GameInstance.GetTimeSystem(game).RegisterDelayedListener(context as GameObject, evt, GameInstance.GetTimeSystem(game).RealTimeSecondsToGameTime(delay), -1, false);
    } else {
      castedState.m_listener = GameInstance.GetTimeSystem(game).RegisterDelayedListener(context as GameObject, evt, GameInstance.GetTimeSystem(game).RealTimeSecondsToGameTime(delay), 1, false);
    };
    return false;
  }

  protected const func OnUnregister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Void {
    GameInstance.GetTimeSystem(game).UnregisterListener(state as GameTimePrereqState.m_listener);
  }

  protected func Initialize(recordID: TweakDBID) -> Void {
    this.m_delay = TweakDBInterface.GetFloat(recordID + t".delay", 0.00);
    this.m_repeated = TweakDBInterface.GetBool(recordID + t".repeated", false);
    let statRecord: ref<Stat_Record> = TweakDBInterface.GetStatRecord(TDB.GetForeignKey(recordID + t".delayFromStat"));
    if IsDefined(statRecord) {
      this.m_delayFromStat = statRecord.StatType();
    };
  }
}
