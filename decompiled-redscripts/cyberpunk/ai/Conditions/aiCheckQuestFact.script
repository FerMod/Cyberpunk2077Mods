
public class CheckQuestFact extends AIbehaviorconditionScript {

  public edit let m_questFactName: CName;

  public edit let m_comparedValue: Int32;

  public edit let m_comparator: ECompareOp;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.30));
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let factValue: Int32 = GameInstance.GetQuestsSystem(ScriptExecutionContext.GetOwner(context).GetGame()).GetFact(this.m_questFactName);
    return Cast<AIbehaviorConditionOutcomes>(Compare(this.m_comparator, factValue, this.m_comparedValue));
  }
}
