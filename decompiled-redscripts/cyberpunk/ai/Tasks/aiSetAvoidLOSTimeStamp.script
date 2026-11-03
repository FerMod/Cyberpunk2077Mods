
public class SetAvoidLOSTimeStamp extends AIbehaviortaskScript {

  private let m_initialized: Bool;

  private let m_actionBBoard: wref<IBlackboard>;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    if !this.m_initialized {
      this.m_actionBBoard = AIBehaviorScriptBase.GetPuppet(context).GetAIControllerComponent().GetActionBlackboard();
    };
    this.m_actionBBoard.SetFloat(GetAllBlackboardDefs().AIAction.avoidLOSTimeStamp, EngineTime.ToFloat(ScriptExecutionContext.GetAITime(context)));
  }
}

public class ResetAvoidLOSTimeStamp extends AIbehaviortaskScript {

  public edit let m_onDeactivation: Bool;

  private let m_initialized: Bool;

  private let m_actionBBoard: wref<IBlackboard>;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    if !this.m_initialized {
      this.m_actionBBoard = AIBehaviorScriptBase.GetPuppet(context).GetAIControllerComponent().GetActionBlackboard();
    };
    if !this.m_onDeactivation {
      this.m_actionBBoard.SetFloat(GetAllBlackboardDefs().AIAction.avoidLOSTimeStamp, 0.00);
    };
  }

  protected func Deactivate(context: ScriptExecutionContext) -> Void {
    if this.m_onDeactivation {
      this.m_actionBBoard.SetFloat(GetAllBlackboardDefs().AIAction.avoidLOSTimeStamp, 0.00);
    };
  }
}
