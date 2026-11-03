
public class ThrowGrenadeCommandTask extends AIbehaviortaskScript {

  protected inline edit let m_inCommand: ref<AIArgumentMapping>;

  protected let m_currentCommand: wref<AIThrowGrenadeCommand>;

  protected let m_threatPersistenceSource: ref<AIThreatPersistenceSource_Record>;

  protected let m_activationTimeStamp: Float;

  protected let m_commandDuration: Float;

  protected let m_once: Bool;

  protected let m_target: wref<GameObject>;

  protected let m_targetID: EntityID;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviortaskScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let globalRef: GlobalNodeRef;
    let target: wref<GameObject>;
    let aiActionBlackboard: ref<IBlackboard> = AIBehaviorScriptBase.GetPuppet(context).GetAIControllerComponent().GetActionBlackboard();
    let rawCommand: ref<IScriptable> = ScriptExecutionContext.GetScriptableMappingValue(context, this.m_inCommand);
    let typedCommand: ref<AIThrowGrenadeCommand> = rawCommand as AIThrowGrenadeCommand;
    if typedCommand == this.m_currentCommand {
      if IsDefined(this.m_currentCommand) {
        if !AIActionHelper.IsCommandCombatTargetValid(context, n"AIThrowGrenadeCommand") {
          this.StopCommand(context, typedCommand, true);
        } else {
          if EntityID.IsDefined(this.m_targetID) && !IsDefined(this.m_target) {
            this.StopCommand(context, typedCommand, false);
            ScriptExecutionContext.DebugLog(context, n"AIThrowGrenadeCommand", "Canceling command, entity streamed out");
          } else {
            if this.m_commandDuration >= 0.00 && EngineTime.ToFloat(ScriptExecutionContext.GetAITime(context)) > this.m_activationTimeStamp + this.m_commandDuration {
              this.StopCommand(context, typedCommand, true);
              ScriptExecutionContext.DebugLog(context, n"AIThrowGrenadeCommand", "Canceling command, duration expired");
            } else {
              if this.m_once && this.m_activationTimeStamp < aiActionBlackboard.GetFloat(GetAllBlackboardDefs().AIAction.lastGrenadeThrowTimestamp) {
                this.StopCommand(context, typedCommand, true);
                ScriptExecutionContext.DebugLog(context, n"AIThrowGrenadeCommand", "Canceling command, it was set to be executed only once");
              };
            };
          };
        };
      };
      return AIbehaviorUpdateOutcome.IN_PROGRESS;
    };
    this.m_currentCommand = typedCommand;
    this.m_commandDuration = typedCommand.duration;
    this.m_once = typedCommand.once;
    this.m_activationTimeStamp = EngineTime.ToFloat(ScriptExecutionContext.GetAITime(context));
    this.m_threatPersistenceSource = TweakDBInterface.GetAIThreatPersistenceSourceRecord(t"AIThreatPersistenceSource.CommandThrowGrenade");
    if !GetGameObjectFromEntityReference(typedCommand.targetOverridePuppetRef, ScriptExecutionContext.GetOwner(context).GetGame(), target) {
      globalRef = ResolveNodeRef(typedCommand.targetOverrideNodeRef, Cast<GlobalNodeRef>(GlobalNodeID.GetRoot()));
      target = GameInstance.FindEntityByID(AIBehaviorScriptBase.GetGame(context), Cast<EntityID>(globalRef)) as GameObject;
    };
    this.m_target = target;
    this.m_targetID = Cast<EntityID>(globalRef);
    if EntityID.IsDefined(this.m_targetID) && !IsDefined(this.m_target) {
      this.StopCommand(context, typedCommand, false);
      ScriptExecutionContext.DebugLog(context, n"AIThrowGrenadeCommand", "Canceling command, entity streamed out");
    } else {
      if !AIActionHelper.SetCommandCombatTarget(context, target, this.m_commandDuration != 0.00, Cast<Uint32>(this.m_threatPersistenceSource.EnumValue())) {
        this.StopCommand(context, typedCommand, true);
        ScriptExecutionContext.DebugLog(context, n"AIThrowGrenadeCommand", "Canceling command, unable to set CommandCombatTarget");
      };
    };
    return AIbehaviorUpdateOutcome.IN_PROGRESS;
  }

  private final func Deactivate(context: ScriptExecutionContext) -> Void {
    let rawCommand: ref<IScriptable>;
    let typedCommand: ref<AIThrowGrenadeCommand>;
    if !IsDefined(this.m_currentCommand) {
      return;
    };
    rawCommand = ScriptExecutionContext.GetScriptableMappingValue(context, this.m_inCommand);
    typedCommand = rawCommand as AIThrowGrenadeCommand;
    if !IsDefined(typedCommand) {
      this.CancelCommand(context);
    };
  }

  protected final func CancelCommand(context: ScriptExecutionContext) -> Void {
    AIActionHelper.ClearCommandCombatTarget(context, Cast<Uint32>(this.m_threatPersistenceSource.EnumValue()));
    ScriptExecutionContext.SetMappingValue(context, this.m_inCommand, ToVariant(null));
    this.m_activationTimeStamp = 0.00;
    this.m_commandDuration = -1.00;
    this.m_currentCommand = null;
    this.m_target = null;
    this.m_targetID = this.m_target.GetEntityID();
  }

  protected final func StopCommand(context: ScriptExecutionContext, command: ref<AIThrowGrenadeCommand>, success: Bool) -> Void {
    this.CancelCommand(context);
    if IsDefined(command) && Equals(command.state, AICommandState.Executing) {
      AIBehaviorScriptBase.GetPuppet(context).GetAIControllerComponent().StopExecutingCommand(command, success);
    };
  }
}

public class ThrowGrenadeCommandCleanup extends AIbehaviortaskScript {

  protected inline edit let m_inCommand: ref<AIArgumentMapping>;

  private final func Deactivate(context: ScriptExecutionContext) -> Void {
    let threatPersistenceSource: ref<AIThreatPersistenceSource_Record> = TweakDBInterface.GetAIThreatPersistenceSourceRecord(t"AIThreatPersistenceSource.CommandThrowGrenade");
    AIActionHelper.ClearCommandCombatTarget(context, Cast<Uint32>(threatPersistenceSource.EnumValue()));
    ScriptExecutionContext.SetMappingValue(context, this.m_inCommand, ToVariant(null));
  }
}

public class ThrowGrenadeCommandHandler extends AIbehaviortaskScript {

  protected inline edit let m_inCommand: ref<AIArgumentMapping>;

  protected let m_currentCommand: wref<AIThrowGrenadeCommand>;

  private final func Activate(context: ScriptExecutionContext) -> Void {
    this.m_currentCommand = null;
    let rawCommand: ref<IScriptable> = ScriptExecutionContext.GetScriptableMappingValue(context, this.m_inCommand);
    let typedCommand: ref<AIThrowGrenadeCommand> = rawCommand as AIThrowGrenadeCommand;
    if IsDefined(typedCommand) {
      this.m_currentCommand = typedCommand;
    };
    AIbehaviortaskScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let rawCommand: ref<IScriptable> = ScriptExecutionContext.GetScriptableMappingValue(context, this.m_inCommand);
    let typedCommand: ref<AIThrowGrenadeCommand> = rawCommand as AIThrowGrenadeCommand;
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
