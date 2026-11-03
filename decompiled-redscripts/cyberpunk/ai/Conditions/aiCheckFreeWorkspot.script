
public class CheckFreeWorkspot extends AIbehaviorconditionScript {

  public edit let AIAction: gamedataWorkspotActionType;

  public let workspotObject: wref<GameObject>;

  public let workspotData: ref<WorkspotEntryData>;

  public let globalRef: GlobalNodeRef;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    this.workspotObject = ScriptExecutionContext.GetArgumentObject(context, n"StimTarget");
    this.workspotData = this.workspotObject.GetFreeWorkspotDataForAIAction(this.AIAction);
    this.globalRef = ResolveNodeRef(this.workspotData.workspotRef, Cast<GlobalNodeRef>(GlobalNodeID.GetRoot()));
    if GlobalNodeRef.IsDefined(this.globalRef) {
      this.workspotData.isAvailable = false;
      ScriptExecutionContext.SetArgumentNodeRef(context, n"WorkspotNode", this.workspotData.workspotRef);
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }

  protected func Deactivate(context: ScriptExecutionContext) -> Void {
    if GlobalNodeRef.IsDefined(this.globalRef) {
      this.workspotData.isAvailable = true;
    };
  }
}
