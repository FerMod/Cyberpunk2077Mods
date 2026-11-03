
public class MeleeAttackCommandTask extends AIbehaviortaskScript {

  protected inline edit let m_inCommand: ref<AIArgumentMapping>;

  protected let m_currentCommand: wref<AIMeleeAttackCommand>;

  protected let m_threatPersistenceSource: ref<AIThreatPersistenceSource_Record>;

  protected let m_activationTimeStamp: Float;

  protected let m_commandDuration: Float;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviortaskScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let globalRef: GlobalNodeRef;
    let target: wref<GameObject>;
    let rawCommand: ref<IScriptable> = ScriptExecutionContext.GetScriptableMappingValue(context, this.m_inCommand);
    let typedCommand: ref<AIMeleeAttackCommand> = rawCommand as AIMeleeAttackCommand;
    if typedCommand == this.m_currentCommand {
      if IsDefined(this.m_currentCommand) {
        if !AIActionHelper.IsCommandCombatTargetValid(context, n"AIMeleeAttackCommand") {
          this.CancelCommand(context, typedCommand);
          if IsDefined(typedCommand) && Equals(typedCommand.state, AICommandState.Executing) {
            AIBehaviorScriptBase.GetPuppet(context).GetAIControllerComponent().StopExecutingCommand(typedCommand, true);
          };
        } else {
          if this.m_commandDuration >= 0.00 && EngineTime.ToFloat(ScriptExecutionContext.GetAITime(context)) > this.m_activationTimeStamp + this.m_commandDuration {
            this.CancelCommand(context, typedCommand);
            ScriptExecutionContext.DebugLog(context, n"AIMeleeAttackCommand", "Canceling command, duration expired");
            if IsDefined(typedCommand) {
              AIBehaviorScriptBase.GetPuppet(context).GetAIControllerComponent().StopExecutingCommand(typedCommand, true);
            };
          };
        };
      };
      return AIbehaviorUpdateOutcome.IN_PROGRESS;
    };
    this.m_currentCommand = typedCommand;
    this.m_commandDuration = typedCommand.duration;
    this.m_activationTimeStamp = EngineTime.ToFloat(ScriptExecutionContext.GetAITime(context));
    this.m_threatPersistenceSource = TweakDBInterface.GetAIThreatPersistenceSourceRecord(t"AIThreatPersistenceSource.CommandMeleeAttack");
    if !GetGameObjectFromEntityReference(typedCommand.targetOverridePuppetRef, ScriptExecutionContext.GetOwner(context).GetGame(), target) {
      globalRef = ResolveNodeRef(typedCommand.targetOverrideNodeRef, Cast<GlobalNodeRef>(GlobalNodeID.GetRoot()));
      target = GameInstance.FindEntityByID(AIBehaviorScriptBase.GetGame(context), Cast<EntityID>(globalRef)) as GameObject;
    };
    if !AIActionHelper.SetCommandCombatTarget(context, target, this.m_commandDuration != 0.00, Cast<Uint32>(this.m_threatPersistenceSource.EnumValue())) {
      this.CancelCommand(context, typedCommand);
      ScriptExecutionContext.DebugLog(context, n"AIMeleeAttackCommand", "Canceling command, unable to set CommandCombatTarget");
      if IsDefined(typedCommand) && Equals(typedCommand.state, AICommandState.Executing) {
        AIBehaviorScriptBase.GetPuppet(context).GetAIControllerComponent().StopExecutingCommand(typedCommand, true);
      };
    };
    return AIbehaviorUpdateOutcome.IN_PROGRESS;
  }

  private final func Deactivate(context: ScriptExecutionContext) -> Void {
    let rawCommand: ref<IScriptable>;
    let typedCommand: ref<AIMeleeAttackCommand>;
    if !IsDefined(this.m_currentCommand) {
      return;
    };
    rawCommand = ScriptExecutionContext.GetScriptableMappingValue(context, this.m_inCommand);
    typedCommand = rawCommand as AIMeleeAttackCommand;
    if !IsDefined(typedCommand) {
      this.CancelCommand(context, typedCommand);
    };
  }

  protected final func CancelCommand(context: ScriptExecutionContext, typedCommand: ref<AIMeleeAttackCommand>) -> Void {
    AIActionHelper.ClearCommandCombatTarget(context, Cast<Uint32>(this.m_threatPersistenceSource.EnumValue()));
    ScriptExecutionContext.SetMappingValue(context, this.m_inCommand, ToVariant(null));
    this.m_activationTimeStamp = 0.00;
    this.m_commandDuration = -1.00;
    this.m_currentCommand = null;
  }
}

public class MeleeAttackCommandCleanup extends AIbehaviortaskScript {

  protected inline edit let m_inCommand: ref<AIArgumentMapping>;

  private final func Deactivate(context: ScriptExecutionContext) -> Void {
    let threatPersistenceSource: ref<AIThreatPersistenceSource_Record> = TweakDBInterface.GetAIThreatPersistenceSourceRecord(t"AIThreatPersistenceSource.CommandMeleeAttack");
    AIActionHelper.ClearCommandCombatTarget(context, Cast<Uint32>(threatPersistenceSource.EnumValue()));
    ScriptExecutionContext.SetMappingValue(context, this.m_inCommand, ToVariant(null));
  }
}

public class MeleeAttackCommandHandler extends AIbehaviortaskScript {

  protected inline edit let m_inCommand: ref<AIArgumentMapping>;

  protected let m_currentCommand: wref<AIMeleeAttackCommand>;

  private final func Activate(context: ScriptExecutionContext) -> Void {
    this.m_currentCommand = null;
    let rawCommand: ref<IScriptable> = ScriptExecutionContext.GetScriptableMappingValue(context, this.m_inCommand);
    let typedCommand: ref<AIMeleeAttackCommand> = rawCommand as AIMeleeAttackCommand;
    if IsDefined(typedCommand) {
      this.m_currentCommand = typedCommand;
    };
  }

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let rawCommand: ref<IScriptable> = ScriptExecutionContext.GetScriptableMappingValue(context, this.m_inCommand);
    let typedCommand: ref<AIMeleeAttackCommand> = rawCommand as AIMeleeAttackCommand;
    if !IsDefined(typedCommand) {
      return AIbehaviorUpdateOutcome.IN_PROGRESS;
    };
    if IsDefined(this.m_currentCommand) {
      if typedCommand == this.m_currentCommand {
        return AIbehaviorUpdateOutcome.IN_PROGRESS;
      };
      return AIbehaviorUpdateOutcome.SUCCESS;
    };
    this.m_currentCommand = typedCommand;
    return AIbehaviorUpdateOutcome.SUCCESS;
  }
}
