
public class AIAggressiveReactionPresetCondition extends AIbehaviorconditionScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    if IsDefined(AIBehaviorScriptBase.GetPuppet(context)) {
      return Cast<AIbehaviorConditionOutcomes>(AIBehaviorScriptBase.GetPuppet(context).GetStimReactionComponent().GetReactionPreset().IsAggressive());
    };
    return AIbehaviorConditionOutcomes.False;
  }
}
