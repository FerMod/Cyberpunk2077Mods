
public class RootMotionCommandHandler extends AICommandHandlerBase {

  protected inline edit let m_params: ref<AIArgumentMapping>;

  protected func UpdateCommand(context: ScriptExecutionContext, command: ref<AICommand>) -> AIbehaviorUpdateOutcome {
    let typedCommand: ref<AIRootMotionCommand> = command as AIRootMotionCommand;
    if !IsDefined(typedCommand) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    if !IsDefined(this.m_params) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    ScriptExecutionContext.SetMappingValue(context, this.m_params, ToVariant(typedCommand.params));
    return AIbehaviorUpdateOutcome.SUCCESS;
  }
}
