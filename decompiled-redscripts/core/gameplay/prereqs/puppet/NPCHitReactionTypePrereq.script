
public class NPCHitReactionTypePrereq extends IScriptablePrereq {

  public let m_hitReactionType: animHitReactionType;

  public let m_timeout: Float;

  public let m_invert: Bool;

  protected func Initialize(recordID: TweakDBID) -> Void {
    let str: String = TweakDBInterface.GetString(recordID + t".hitReactionType", "");
    this.m_hitReactionType = IntEnum<animHitReactionType>(Cast<Int32>(EnumValueFromString("animHitReactionType", str)));
    this.m_timeout = TweakDBInterface.GetFloat(recordID + t".timeout", -1.00);
    this.m_invert = TweakDBInterface.GetBool(recordID + t".invert", false);
  }

  protected const func OnRegister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Bool {
    let castedState: ref<NPCHitReactionTypePrereqState>;
    let puppet: ref<ScriptedPuppet> = context as ScriptedPuppet;
    if IsDefined(puppet) {
      castedState = state as NPCHitReactionTypePrereqState;
      castedState.m_listener = new PuppetListener();
      castedState.m_listener.RegisterOwner(castedState);
      ScriptedPuppet.AddListener(puppet, castedState.m_listener);
      return false;
    };
    return false;
  }

  protected const func OnUnregister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Void {
    let puppet: ref<ScriptedPuppet> = context as ScriptedPuppet;
    let castedState: ref<NPCHitReactionTypePrereqState> = state as NPCHitReactionTypePrereqState;
    if IsDefined(puppet) && IsDefined(castedState.m_listener) {
      ScriptedPuppet.RemoveListener(puppet, castedState.m_listener);
    };
    castedState.m_listener = null;
  }

  protected const func OnApplied(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Void {
    let castedState: ref<NPCHitReactionTypePrereqState>;
    let hitReactionComponent: ref<HitReactionComponent>;
    let puppet: ref<ScriptedPuppet> = context as ScriptedPuppet;
    if !IsDefined(puppet) {
      return;
    };
    hitReactionComponent = puppet.GetHitReactionComponent();
    if !IsDefined(hitReactionComponent) {
      return;
    };
    castedState = state as NPCHitReactionTypePrereqState;
    if IsDefined(castedState.m_listener) {
      castedState.m_listener.OnHitReactionTypeChanged(hitReactionComponent.GetHitReactionData().hitType);
    };
  }

  public const func IsFulfilled(game: GameInstance, context: ref<IScriptable>) -> Bool {
    let hitReactionComponent: ref<HitReactionComponent>;
    let puppet: ref<ScriptedPuppet> = context as ScriptedPuppet;
    if !IsDefined(puppet) {
      return false;
    };
    hitReactionComponent = puppet.GetHitReactionComponent();
    if !IsDefined(hitReactionComponent) {
      return false;
    };
    return this.EvaluateCondition(puppet, hitReactionComponent.GetHitReactionData().hitType);
  }

  public final const func EvaluateCondition(puppet: wref<ScriptedPuppet>, hitType: Int32) -> Bool {
    let arrayElement: NPCHitTypeTimeoutStruct;
    let bb: ref<IBlackboard>;
    let delayArray: array<NPCHitTypeTimeoutStruct>;
    let evt: ref<ResetNPCHitReactionTypePrereqStateEvent>;
    let i: Int32;
    let instanceFound: Bool;
    let result: Bool;
    if hitType != EnumInt(this.m_hitReactionType) {
      result = this.m_invert ? true : false;
    } else {
      result = this.m_invert ? false : true;
    };
    if !result && hitType > 0 && this.m_timeout > 0.00 {
      bb = puppet.GetAIControllerComponent().GetAIPrereqsBlackboard();
      delayArray = FromVariant<array<NPCHitTypeTimeoutStruct>>(bb.GetVariant(GetAllBlackboardDefs().AIPrereqs.npcHitTypeTimeout));
      evt = new ResetNPCHitReactionTypePrereqStateEvent();
      i = 0;
      while i < ArraySize(delayArray) {
        if delayArray[i].delayID != GetInvalidDelayID() {
          GameInstance.GetDelaySystem(puppet.GetGame()).CancelDelay(delayArray[i].delayID);
          delayArray[i].delayID = GetInvalidDelayID();
        };
        if delayArray[i].timeout == this.m_timeout {
          instanceFound = true;
          delayArray[i].delayID = GameInstance.GetDelaySystem(puppet.GetGame()).DelayEvent(puppet, evt, this.m_timeout);
          bb.SetVariant(GetAllBlackboardDefs().AIPrereqs.npcHitTypeTimeout, ToVariant(delayArray), true);
        };
        i += 1;
      };
      if !instanceFound {
        arrayElement.timeout = this.m_timeout;
        arrayElement.delayID = GameInstance.GetDelaySystem(puppet.GetGame()).DelayEvent(puppet, evt, this.m_timeout);
        ArrayPush(delayArray, arrayElement);
        bb.SetVariant(GetAllBlackboardDefs().AIPrereqs.npcHitTypeTimeout, ToVariant(delayArray), true);
      };
    };
    return result;
  }
}
