
public class SlotAnimationInProgress extends AIbehaviorconditionScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.10));
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(AIBehaviorScriptBase.GetPuppet(context).GetPuppetStateBlackboard().GetBool(GetAllBlackboardDefs().PuppetState.SlotAnimationInProgress));
  }
}
