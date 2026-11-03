
public abstract class TweakAIActionConditionAbstract extends AIbehaviorconditionScript {

  private let m_actionRecord: wref<AIAction_Record>;

  private let m_actionDebugName: String;

  private final func Initialize(context: ScriptExecutionContext) -> Bool {
    let actionRecord: wref<AIAction_Record>;
    if !this.GetActionRecord(context, this.m_actionDebugName, actionRecord) {
      return false;
    };
    if actionRecord != this.m_actionRecord {
      this.m_actionRecord = actionRecord;
      if this.StartInitCooldowns(context) {
        return false;
      };
    };
    return true;
  }

  private final func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let blackBoard: ref<IBlackboard>;
    if !this.Initialize(context) {
      return AIbehaviorConditionOutcomes.False;
    };
    if IsDefined(this.m_actionRecord.AnimData().AnimVariationSubAction() as AISubActionRandomize_Record) {
      blackBoard = (ScriptExecutionContext.GetOwner(context) as ScriptedPuppet).GetAIControllerComponent().GetActionBlackboard();
      if FromVariant<TweakDBID>(blackBoard.GetVariant(GetAllBlackboardDefs().AIAction.ownerLastAnimVariationAction)) != this.m_actionRecord.GetID() {
        blackBoard.SetVariant(GetAllBlackboardDefs().AIAction.ownerLastAnimVariationAction, ToVariant(TDBID.None()));
        blackBoard.SetBool(GetAllBlackboardDefs().AIAction.ownerCurrentAnimVariationSet, false);
      };
      if AICondition.ActivationCheck(context, this.m_actionRecord) {
        blackBoard.SetVariant(GetAllBlackboardDefs().AIAction.ownerLastAnimVariationAction, ToVariant(this.m_actionRecord.GetID()));
        return AIbehaviorConditionOutcomes.True;
      };
    } else {
      if AICondition.ActivationCheck(context, this.m_actionRecord) {
        return AIbehaviorConditionOutcomes.True;
      };
    };
    return AIbehaviorConditionOutcomes.False;
  }

  private final func Activate(context: ScriptExecutionContext) -> Void;

  private final func Deactivate(context: ScriptExecutionContext) -> Void;

  private final func StartInitCooldowns(const context: ScriptExecutionContext) -> Bool {
    let record: ref<AIActionCooldown_Record>;
    let count: Int32 = this.m_actionRecord.GetInitCooldownsCount();
    let i: Int32 = 0;
    while i < count {
      record = this.m_actionRecord.GetInitCooldownsItem(i);
      AIActionHelper.StartCooldown(ScriptExecutionContext.GetOwner(context), record);
      i += 1;
    };
    return count > 0;
  }

  public func GetDescription(context: ScriptExecutionContext) -> String {
    return this.m_actionDebugName;
  }

  private func GetActionRecord(const context: ScriptExecutionContext, actionDebugName: script_ref<String>, out actionRecord: wref<AIAction_Record>) -> Bool {
    return false;
  }
}
