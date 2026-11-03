
public class AICommandHandlerBase extends AIbehaviortaskScript {

  protected inline edit let m_inCommand: ref<AIArgumentMapping>;

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let rawCommand: ref<IScriptable>;
    let typedCommand: ref<AICommand>;
    if !IsDefined(this.m_inCommand) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    rawCommand = ScriptExecutionContext.GetScriptableMappingValue(context, this.m_inCommand);
    if !IsDefined(rawCommand) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    typedCommand = rawCommand as AICommand;
    if !IsDefined(typedCommand) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    return this.UpdateCommand(context, typedCommand);
  }

  protected func UpdateCommand(context: ScriptExecutionContext, command: ref<AICommand>) -> AIbehaviorUpdateOutcome {
    return AIbehaviorUpdateOutcome.FAILURE;
  }

  protected final func CheckArgument(argument: ref<AIArgumentMapping>, argName: CName) -> Bool {
    if !IsDefined(argument) {
      return false;
    };
    return true;
  }
}

public class CommandCleanup extends AIbehaviortaskScript {

  protected inline edit let m_inCommand: ref<AIArgumentMapping>;

  private final func Deactivate(context: ScriptExecutionContext) -> Void {
    ScriptExecutionContext.SetMappingValue(context, this.m_inCommand, ToVariant(null));
  }
}

public class CompleteCommand extends AIbehaviortaskScript {

  protected inline edit let m_inCommand: ref<AIArgumentMapping>;

  private final func Deactivate(context: ScriptExecutionContext) -> Void {
    let rawCommand: ref<IScriptable> = ScriptExecutionContext.GetScriptableMappingValue(context, this.m_inCommand);
    let typedCommand: ref<AICommand> = rawCommand as AICommand;
    if IsDefined(typedCommand) && Equals(typedCommand.state, AICommandState.Executing) {
      AIBehaviorScriptBase.GetPuppet(context).GetAIControllerComponent().StopExecutingCommand(typedCommand, true);
    };
  }
}
