
public static func Cast(value: Int64) -> AIPatrolContinuationPolicy {
  return IntEnum<AIPatrolContinuationPolicy>(Cast<Int32>(value));
}

public class PatrolControllerTask extends AIbehaviortaskScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviortaskScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let pathOverride: ref<AIPatrolPathParameters>;
    let selectedPath: ref<AIPatrolPathParameters>;
    let bbDef: ref<AIPatrolDef> = GetAllBlackboardDefs().AIPatrol;
    let bb: ref<IBlackboard> = AIBehaviorScriptBase.GetPuppet(context).GetAIControllerComponent().GetAIPatrolBlackboard();
    let pathVariant: Variant = bb.GetVariant(bbDef.selectedPath);
    let pathOverrideVariant: Variant = bb.GetVariant(bbDef.patrolPathOverride);
    if IsDefined(pathVariant) {
      selectedPath = FromVariant<ref<AIPatrolPathParameters>>(pathVariant);
    };
    if IsDefined(pathOverrideVariant) {
      pathOverride = FromVariant<ref<AIPatrolPathParameters>>(pathOverrideVariant);
    };
    if IsDefined(pathOverride) && selectedPath != pathOverride {
      selectedPath = pathOverride;
      bb.SetVariant(bbDef.selectedPath, ToVariant(selectedPath));
    };
    return AIbehaviorUpdateOutcome.IN_PROGRESS;
  }
}

public class PatrolCommandHandler extends AIbehaviortaskScript {

  public inline edit let m_inCommand: ref<AIArgumentMapping>;

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let bb: ref<IBlackboard>;
    let bbDef: ref<AIPatrolDef>;
    let pathParams: ref<AIPatrolPathParameters>;
    let rawCommand: ref<IScriptable>;
    let typedCommand: ref<AIPatrolCommand>;
    if !IsDefined(this.m_inCommand) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    rawCommand = ScriptExecutionContext.GetScriptableMappingValue(context, this.m_inCommand);
    typedCommand = rawCommand as AIPatrolCommand;
    if !IsDefined(typedCommand) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    if !IsDefined(typedCommand.pathParams) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    pathParams = typedCommand.pathParams;
    if !ScriptExecutionContext.GetArgumentBool(context, n"PatrolInitialized") && Equals(AIBehaviorScriptBase.GetPuppet(context).GetNPCType(), gamedataNPCType.Drone) {
      DroneComponent.SetLocomotionWrappers(AIBehaviorScriptBase.GetPuppet(context), EnumValueToName(n"moveMovementType", EnumInt(pathParams.movementType)));
      pathParams.movementType = moveMovementType.Walk;
    };
    bbDef = GetAllBlackboardDefs().AIPatrol;
    bb = AIBehaviorScriptBase.GetPuppet(context).GetAIControllerComponent().GetAIPatrolBlackboard();
    bb.SetVariant(bbDef.patrolPathOverride, ToVariant(pathParams));
    bb.SetBool(bbDef.patrolWithWeapon, pathParams.patrolWithWeapon);
    bb.SetVariant(bbDef.patrolAction, ToVariant(pathParams.patrolAction));
    bb.SetBool(bbDef.sprint, Equals(pathParams.movementType, moveMovementType.Sprint));
    ScriptExecutionContext.SetArgumentBool(context, n"PatrolInitialized", true);
    return AIbehaviorUpdateOutcome.SUCCESS;
  }
}

public class PatrolRoleHandler extends AIbehaviortaskScript {

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let bb: ref<IBlackboard>;
    let bbDef: ref<AIPatrolDef>;
    let pathParams: ref<AIPatrolPathParameters>;
    let patrolRole: ref<AIPatrolRole>;
    let aiComponent: ref<AIHumanComponent> = AIBehaviorScriptBase.GetAIComponent(context);
    if !IsDefined(aiComponent) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    patrolRole = aiComponent.GetCurrentRole() as AIPatrolRole;
    if !IsDefined(patrolRole) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    if !IsDefined(patrolRole.GetPathParams()) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    pathParams = patrolRole.GetPathParams();
    if !ScriptExecutionContext.GetArgumentBool(context, n"PatrolInitialized") && Equals(AIBehaviorScriptBase.GetPuppet(context).GetNPCType(), gamedataNPCType.Drone) {
      DroneComponent.SetLocomotionWrappers(AIBehaviorScriptBase.GetPuppet(context), EnumValueToName(n"moveMovementType", EnumInt(pathParams.movementType)));
      pathParams.movementType = moveMovementType.Walk;
    };
    bbDef = GetAllBlackboardDefs().AIPatrol;
    bb = AIBehaviorScriptBase.GetPuppet(context).GetAIControllerComponent().GetAIPatrolBlackboard();
    bb.SetVariant(bbDef.patrolPathOverride, ToVariant(pathParams));
    bb.SetBool(bbDef.patrolWithWeapon, pathParams.patrolWithWeapon);
    bb.SetVariant(bbDef.patrolAction, ToVariant(pathParams.patrolAction));
    bb.SetBool(bbDef.sprint, Equals(pathParams.movementType, moveMovementType.Sprint));
    ScriptExecutionContext.SetArgumentBool(context, n"PatrolInitialized", true);
    return AIbehaviorUpdateOutcome.SUCCESS;
  }
}

public class PatrolAlertedControllerTask extends AIbehaviortaskScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviortaskScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let pathOverride: ref<AIPatrolPathParameters>;
    let selectedPath: ref<AIPatrolPathParameters>;
    let bbDef: ref<AIAlertedPatrolDef> = GetAllBlackboardDefs().AIAlertedPatrol;
    let bb: ref<IBlackboard> = AIBehaviorScriptBase.GetPuppet(context).GetAIControllerComponent().GetAIAlertedPatrolBlackboard();
    let tmpVariant: Variant = bb.GetVariant(bbDef.selectedPath);
    if IsDefined(tmpVariant) {
      selectedPath = FromVariant<ref<AIPatrolPathParameters>>(tmpVariant);
    };
    tmpVariant = bb.GetVariant(bbDef.patrolPathOverride);
    if IsDefined(tmpVariant) {
      pathOverride = FromVariant<ref<AIPatrolPathParameters>>(tmpVariant);
    };
    if IsDefined(pathOverride) && selectedPath != pathOverride {
      selectedPath = pathOverride;
      bb.SetVariant(bbDef.selectedPath, ToVariant(selectedPath));
    };
    return AIbehaviorUpdateOutcome.IN_PROGRESS;
  }
}

public class PatrolAlertedCommandHandler extends AIbehaviortaskScript {

  public inline edit let m_inCommand: ref<AIArgumentMapping>;

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let bb: ref<IBlackboard>;
    let bbDef: ref<AIAlertedPatrolDef>;
    let pathParams: ref<AIPatrolPathParameters>;
    let rawCommand: ref<IScriptable>;
    let typedCommand: ref<AIPatrolCommand>;
    if !IsDefined(this.m_inCommand) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    rawCommand = ScriptExecutionContext.GetScriptableMappingValue(context, this.m_inCommand);
    typedCommand = rawCommand as AIPatrolCommand;
    if !IsDefined(typedCommand) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    if !IsDefined(typedCommand.alertedPathParams) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    ScriptExecutionContext.SetArgumentFloat(context, n"InfluenceRadius", typedCommand.alertedRadius);
    pathParams = typedCommand.alertedPathParams;
    if !ScriptExecutionContext.GetArgumentBool(context, n"PatrolInitialized") && Equals(AIBehaviorScriptBase.GetPuppet(context).GetNPCType(), gamedataNPCType.Drone) {
      DroneComponent.SetLocomotionWrappers(AIBehaviorScriptBase.GetPuppet(context), EnumValueToName(n"moveMovementType", EnumInt(pathParams.movementType)));
      pathParams.movementType = moveMovementType.Walk;
    };
    bbDef = GetAllBlackboardDefs().AIAlertedPatrol;
    bb = AIBehaviorScriptBase.GetPuppet(context).GetAIControllerComponent().GetAIAlertedPatrolBlackboard();
    bb.SetVariant(bbDef.patrolPathOverride, ToVariant(pathParams));
    bb.SetVariant(bbDef.patrolAction, ToVariant(pathParams.patrolAction));
    bb.SetBool(bbDef.sprint, Equals(pathParams.movementType, moveMovementType.Sprint));
    ScriptExecutionContext.SetArgumentBool(context, n"PatrolInitialized", true);
    return AIbehaviorUpdateOutcome.SUCCESS;
  }
}

public class AlertedRoleHandler extends AIbehaviortaskScript {

  private let m_pathParamsModified: Bool;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviortaskScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.50));
  }

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let bb: ref<IBlackboard>;
    let bbDef: ref<AIAlertedPatrolDef>;
    let pathParams: ref<AIPatrolPathParameters>;
    let patrolRole: ref<AIPatrolRole>;
    let aiComponent: ref<AIHumanComponent> = AIBehaviorScriptBase.GetAIComponent(context);
    if !IsDefined(aiComponent) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    patrolRole = aiComponent.GetCurrentRole() as AIPatrolRole;
    if !IsDefined(patrolRole) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    ScriptExecutionContext.SetArgumentScriptable(context, n"AlertedSpots", patrolRole.GetAlertedSpots());
    if !IsDefined(patrolRole.GetAlertedPathParams()) && !IsDefined(patrolRole.GetPathParams()) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    ScriptExecutionContext.SetArgumentFloat(context, n"InfluenceRadius", patrolRole.GetAlertedRadius());
    pathParams = patrolRole.GetAlertedPathParams();
    if !IsDefined(pathParams) {
      ScriptExecutionContext.SetArgumentBool(context, n"IgnoreWorkspots", true);
      pathParams = patrolRole.GetPathParams();
      if !(ScriptExecutionContext.GetOwner(context) as ScriptedPuppet).IsBoss() {
        if pathParams.isInfinite {
          pathParams.isInfinite = false;
          pathParams.numberOfLoops = 1u;
          this.m_pathParamsModified = true;
        };
      };
    };
    if !ScriptExecutionContext.GetArgumentBool(context, n"PatrolInitialized") && Equals(AIBehaviorScriptBase.GetPuppet(context).GetNPCType(), gamedataNPCType.Drone) {
      DroneComponent.SetLocomotionWrappers(AIBehaviorScriptBase.GetPuppet(context), EnumValueToName(n"moveMovementType", EnumInt(pathParams.movementType)));
      pathParams.movementType = moveMovementType.Walk;
    };
    pathParams.startFromClosestPoint = true;
    bbDef = GetAllBlackboardDefs().AIAlertedPatrol;
    bb = AIBehaviorScriptBase.GetPuppet(context).GetAIControllerComponent().GetAIAlertedPatrolBlackboard();
    if !IsDefined(bb) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    bb.SetVariant(bbDef.patrolPathOverride, ToVariant(pathParams));
    bb.SetBool(bbDef.forceAlerted, patrolRole.IsForceAlerted());
    if IsDefined(pathParams) {
      bb.SetVariant(bbDef.patrolAction, ToVariant(pathParams.patrolAction));
      bb.SetBool(bbDef.sprint, Equals(pathParams.movementType, moveMovementType.Sprint));
    };
    ScriptExecutionContext.SetArgumentBool(context, n"PatrolInitialized", true);
    return AIbehaviorUpdateOutcome.IN_PROGRESS;
  }

  protected func Deactivate(context: ScriptExecutionContext) -> Void {
    let aiComponent: ref<AIHumanComponent>;
    let pathParams: ref<AIPatrolPathParameters>;
    let patrolRole: ref<AIPatrolRole>;
    if this.m_pathParamsModified {
      aiComponent = AIBehaviorScriptBase.GetAIComponent(context);
      if !IsDefined(aiComponent) {
        return;
      };
      patrolRole = aiComponent.GetCurrentRole() as AIPatrolRole;
      if !IsDefined(patrolRole) {
        return;
      };
      pathParams = patrolRole.GetPathParams();
      if !IsDefined(pathParams) {
        return;
      };
      pathParams.isInfinite = true;
      this.m_pathParamsModified = false;
    };
  }
}

public class CheckCurrentWorkspotTag extends AIbehaviorconditionScript {

  public inline edit let m_tag: ref<AIArgumentMapping>;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.50));
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>((ScriptExecutionContext.GetOwner(context) as ScriptedPuppet).HasWorkspotTag(FromVariant<CName>(ScriptExecutionContext.GetMappingValue(context, this.m_tag))));
  }
}

public class GetCurrentPatrolSpotActionPath extends AIbehaviortaskScript {

  public inline edit let m_outPathArgument: ref<AIArgumentMapping>;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let currentPatrolActionPath: CName;
    let currentWorkspotTags: array<CName> = (ScriptExecutionContext.GetOwner(context) as ScriptedPuppet).GetCurrentWorkspotTags();
    if ArraySize(currentWorkspotTags) < 2 {
      return;
    };
    currentPatrolActionPath = currentWorkspotTags[1];
    ScriptExecutionContext.SetMappingValue(context, this.m_outPathArgument, ToVariant(currentPatrolActionPath));
  }
}

public class HasPatrolAction extends AIbehaviorconditionScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let patrolAction: TweakDBID = FromVariant<TweakDBID>(AIBehaviorScriptBase.GetPuppet(context).GetAIControllerComponent().GetAIPatrolBlackboard().GetVariant(GetAllBlackboardDefs().AIPatrol.patrolAction));
    if TDBID.IsValid(patrolAction) {
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class SendPatrolEndSignal extends AIbehaviortaskScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let puppet: wref<ScriptedPuppet> = ScriptExecutionContext.GetOwner(context) as ScriptedPuppet;
    if !IsDefined(puppet) {
      return;
    };
    ScriptedPuppet.SendActionSignal(puppet, n"PatrolEnded", 0.10);
  }
}

public class ShouldContinuePatrolFromNextControlPoint extends AIbehaviorconditionScript {

  public inline edit let m_patrolContinuationPolicy: ref<AIArgumentMapping>;

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let continuationPolicy: AIPatrolContinuationPolicy = Cast<AIPatrolContinuationPolicy>(FromVariant<Int64>(ScriptExecutionContext.GetMappingValue(context, this.m_patrolContinuationPolicy)));
    return Cast<AIbehaviorConditionOutcomes>(Equals(continuationPolicy, AIPatrolContinuationPolicy.FromNextControlPoint));
  }
}

public class ShouldContinuePatrolFromClosestPoint extends AIbehaviorconditionScript {

  public inline edit let m_patrolContinuationPolicy: ref<AIArgumentMapping>;

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let continuationPolicy: AIPatrolContinuationPolicy = Cast<AIPatrolContinuationPolicy>(FromVariant<Int64>(ScriptExecutionContext.GetMappingValue(context, this.m_patrolContinuationPolicy)));
    return Cast<AIbehaviorConditionOutcomes>(Equals(continuationPolicy, AIPatrolContinuationPolicy.FromClosestPoint));
  }
}

public class ShouldContinuePatrolFromBeginning extends AIbehaviorconditionScript {

  public inline edit let m_patrolContinuationPolicy: ref<AIArgumentMapping>;

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let continuationPolicy: AIPatrolContinuationPolicy = Cast<AIPatrolContinuationPolicy>(FromVariant<Int64>(ScriptExecutionContext.GetMappingValue(context, this.m_patrolContinuationPolicy)));
    return Cast<AIbehaviorConditionOutcomes>(Equals(continuationPolicy, AIPatrolContinuationPolicy.FromBeginning));
  }
}

public class IsPatrolProgressValid extends AIbehaviorconditionScript {

  public inline edit let m_patrolProgress: ref<AIArgumentMapping>;

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let patrolProgress: ref<PatrolSplineProgress> = ScriptExecutionContext.GetScriptableMappingValue(context, this.m_patrolProgress) as PatrolSplineProgress;
    return Cast<AIbehaviorConditionOutcomes>(IsDefined(patrolProgress) && patrolProgress.IsControlPointIndexValid());
  }
}
