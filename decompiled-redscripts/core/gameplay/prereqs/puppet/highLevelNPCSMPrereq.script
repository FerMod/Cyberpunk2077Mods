
public class HighLevelNPCStatePrereq extends NPCStatePrereq {

  public let m_valueToListen: gamedataNPCHighLevelState;

  protected const func OnRegister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Bool {
    let bb: ref<IBlackboard> = (context as ScriptedPuppet).GetPuppetStateBlackboard();
    let castedState: ref<HighLevelNPCStatePrereqState> = state as HighLevelNPCStatePrereqState;
    castedState.m_owner = context as GameObject;
    castedState.m_prevValue = bb.GetInt(GetAllBlackboardDefs().PuppetState.HighLevel);
    castedState.m_listenerInt = bb.RegisterListenerInt(GetAllBlackboardDefs().PuppetState.HighLevel, castedState, n"OnStateUpdate");
    return false;
  }

  protected const func OnUnregister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Void {
    let castedState: ref<HighLevelNPCStatePrereqState> = state as HighLevelNPCStatePrereqState;
    (context as ScriptedPuppet).GetPuppetStateBlackboard().UnregisterListenerInt(GetAllBlackboardDefs().PuppetState.HighLevel, castedState.m_listenerInt);
  }

  public const func IsFulfilled(game: GameInstance, context: ref<IScriptable>) -> Bool {
    let owner: ref<ScriptedPuppet> = context as ScriptedPuppet;
    let bb: ref<IBlackboard> = owner.GetPuppetStateBlackboard();
    let currentState: Int32 = bb.GetInt(GetAllBlackboardDefs().PuppetState.HighLevel);
    return this.Evaluate(owner, currentState, currentState);
  }

  protected func Initialize(recordID: TweakDBID) -> Void {
    super.Initialize(recordID);
    this.m_valueToListen = IntEnum<gamedataNPCHighLevelState>(Cast<Int32>(EnumValueFromString("gamedataNPCHighLevelState", this.GetStateName(recordID))));
  }

  protected const func GetStateToCheck() -> Int32 {
    return EnumInt(this.m_valueToListen);
  }
}

public class CurrentHighLevelNPCStatePrereq extends IScriptablePrereq {

  public let m_valueToCheck: gamedataNPCHighLevelState;

  public let m_invert: Bool;

  protected func Initialize(record: TweakDBID) -> Void {
    let stateName: String = TweakDBInterface.GetString(record + t".stateName", "");
    this.m_valueToCheck = IntEnum<gamedataNPCHighLevelState>(Cast<Int32>(EnumValueFromString("gamedataNPCHighLevelState", stateName)));
    this.m_invert = TweakDBInterface.GetBool(record + t".invert", false);
  }

  protected const func OnApplied(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Void {
    state.OnChanged(this.IsFulfilled(game, context));
  }

  public const func IsFulfilled(game: GameInstance, context: ref<IScriptable>) -> Bool {
    let bb: ref<IBlackboard>;
    let currentPuppetState: gamedataNPCHighLevelState;
    let puppet: wref<ScriptedPuppet> = context as ScriptedPuppet;
    if !IsDefined(puppet) {
      return false;
    };
    bb = puppet.GetPuppetStateBlackboard();
    currentPuppetState = IntEnum<gamedataNPCHighLevelState>(bb.GetInt(GetAllBlackboardDefs().PuppetState.HighLevel));
    if NotEquals(currentPuppetState, this.m_valueToCheck) {
      return this.m_invert ? true : false;
    };
    return this.m_invert ? false : true;
  }
}
