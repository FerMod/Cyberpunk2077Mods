
public class PassiveIsPlayerCompanionCondition extends PassiveAutonomousCondition {

  protected let m_roleCbId: Uint32;

  protected final func Activate(context: ScriptExecutionContext) -> Void {
    this.m_roleCbId = ScriptExecutionContext.AddBehaviorCallback(context, n"OnAIRoleChanged", this);
  }

  protected final func Deactivate(context: ScriptExecutionContext) -> Void {
    ScriptExecutionContext.RemoveBehaviorCallback(context, this.m_roleCbId);
  }

  protected final func CalculateValue(context: ScriptExecutionContext) -> Variant {
    if ScriptedPuppet.IsPlayerCompanion(ScriptExecutionContext.GetOwner(context)) {
      return ToVariant(true);
    };
    return ToVariant(false);
  }
}

public class IsFollowTargetInCombat extends AIAutonomousConditions {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let followTarget: ref<GameObject> = ScriptExecutionContext.GetArgumentObject(context, n"FriendlyTarget");
    let combatState: gamePSMCombat = IntEnum<gamePSMCombat>(AIActionChecks.GetPSMBlackbordInt(followTarget as PlayerPuppet, GetAllBlackboardDefs().PlayerStateMachine.Combat));
    return Cast<AIbehaviorConditionOutcomes>(Equals(combatState, gamePSMCombat.InCombat));
  }
}

public class IsPlayerCompanion extends AIAutonomousConditions {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    if ScriptedPuppet.IsPlayerCompanion(ScriptExecutionContext.GetOwner(context)) {
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class IsFriendlyToPlayer extends AIAutonomousConditions {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    if Equals(GameObject.GetAttitudeBetween(ScriptExecutionContext.GetOwner(context), GameInstance.GetPlayerSystem(ScriptExecutionContext.GetOwner(context).GetGame()).GetLocalPlayerMainGameObject()), EAIAttitude.AIA_Friendly) {
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class FollowerFindTeleportPositionAroundTarget extends AIbehaviortaskScript {

  public inline edit let m_target: ref<AIArgumentMapping>;

  public inline edit let m_outPositionArgument: ref<AIArgumentMapping>;

  private let m_lastResultTimestamp: Float;

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let followTarget: wref<GameObject>;
    let movePoliciesComponent: ref<MovePoliciesComponent>;
    let navigationSystem: ref<AINavigationSystem>;
    let ratioCurveName: CName;
    let telportPosition: Vector4;
    if this.m_lastResultTimestamp > 0.00 {
      if EngineTime.ToFloat(ScriptExecutionContext.GetAITime(context)) < this.m_lastResultTimestamp + 0.50 {
        return AIbehaviorUpdateOutcome.IN_PROGRESS;
      };
      this.m_lastResultTimestamp = 0.00;
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    followTarget = FromVariant<wref<GameObject>>(ScriptExecutionContext.GetMappingValue(context, this.m_target));
    if !IsDefined(followTarget) || !followTarget.IsAttached() {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    navigationSystem = GameInstance.GetAINavigationSystem(ScriptExecutionContext.GetOwner(context).GetGame());
    if !IsDefined(navigationSystem) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    if !navigationSystem.IsPointOnNavmesh(ScriptExecutionContext.GetOwner(context), followTarget.GetWorldPosition()) {
      this.m_lastResultTimestamp = EngineTime.ToFloat(ScriptExecutionContext.GetAITime(context));
      return AIbehaviorUpdateOutcome.IN_PROGRESS;
    };
    movePoliciesComponent = (ScriptExecutionContext.GetOwner(context) as ScriptedPuppet).GetMovePolicesComponent();
    if IsDefined(movePoliciesComponent) && IsDefined(movePoliciesComponent.GetTopPolicies()) {
      ratioCurveName = movePoliciesComponent.GetTopPolicies().GetMaxPathLengthToDirectDistanceRatioCurve();
    };
    if !navigationSystem.GetFurthestNavmeshPointBehind(followTarget, 3.00, 4, telportPosition, -followTarget.GetWorldForward() * 1.50, true, ratioCurveName) {
      this.m_lastResultTimestamp = EngineTime.ToFloat(ScriptExecutionContext.GetAITime(context));
      return AIbehaviorUpdateOutcome.IN_PROGRESS;
    };
    ScriptExecutionContext.SetMappingValue(context, this.m_outPositionArgument, ToVariant(telportPosition));
    this.m_lastResultTimestamp = EngineTime.ToFloat(ScriptExecutionContext.GetAITime(context));
    return AIbehaviorUpdateOutcome.SUCCESS;
  }
}

public class AIFollowerTakedownCommandHandler extends AIbehaviortaskScript {

  public inline edit let m_inCommand: ref<AIArgumentMapping>;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviortaskScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let rawCommand: ref<IScriptable>;
    let target: wref<GameObject>;
    let targetEntityIds: array<EntityID>;
    let typedCommand: ref<AIFollowerTakedownCommand>;
    if !IsDefined(this.m_inCommand) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    rawCommand = ScriptExecutionContext.GetScriptableMappingValue(context, this.m_inCommand);
    typedCommand = rawCommand as AIFollowerTakedownCommand;
    if !IsDefined(typedCommand) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    if IsDefined(typedCommand.target) {
      target = typedCommand.target;
    } else {
      GetFixedEntityIdsFromEntityReference(typedCommand.targetRef, ScriptExecutionContext.GetOwner(context).GetGame(), targetEntityIds);
      if !this.SelectBestTarget(context, targetEntityIds, target) {
        target = ScriptExecutionContext.PuppetRefToObject(context, typedCommand.targetRef);
        if IsDefined(target) && (!ScriptedPuppet.IsActive(target) || ScriptedPuppet.IsBeingGrappled(target)) {
          target = null;
        };
      };
    };
    if !IsDefined(target) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    if ScriptExecutionContext.GetArgumentObject(context, n"CombatTarget") != target {
      ScriptExecutionContext.SetArgumentObject(context, n"CombatTarget", target);
    };
    NPCPuppet.ChangeHighLevelState(ScriptExecutionContext.GetOwner(context), gamedataNPCHighLevelState.Stealth);
    return AIbehaviorUpdateOutcome.IN_PROGRESS;
  }

  private final func Deactivate(context: ScriptExecutionContext) -> Void {
    let rawCommand: ref<IScriptable> = ScriptExecutionContext.GetScriptableMappingValue(context, this.m_inCommand);
    let takedownCommand: ref<AIFollowerTakedownCommand> = rawCommand as AIFollowerTakedownCommand;
    let aiComponent: ref<AIHumanComponent> = AIBehaviorScriptBase.GetPuppet(context).GetAIControllerComponent();
    if IsDefined(takedownCommand) {
      aiComponent.StopExecutingCommand(takedownCommand, true);
    };
    ScriptExecutionContext.SetArgumentObject(context, n"CombatTarget", null);
    ScriptExecutionContext.SetMappingValue(context, this.m_inCommand, ToVariant(null));
  }

  private final func SelectBestTarget(context: ScriptExecutionContext, const targetEntityIds: script_ref<[EntityID]>, out target: wref<GameObject>) -> Bool {
    let distToTarget: Float;
    let i: Int32;
    let selectedTargetIndex: Int32;
    let shortestDistance: Float;
    let validTargets: array<ref<GameObject>>;
    if ArraySize(Deref(targetEntityIds)) == 0 {
      return false;
    };
    i = 0;
    while i < ArraySize(Deref(targetEntityIds)) {
      target = GameInstance.FindEntityByID(ScriptExecutionContext.GetOwner(context).GetGame(), Deref(targetEntityIds)[i]) as GameObject;
      if IsDefined(target) && ScriptedPuppet.IsActive(target) && !ScriptedPuppet.IsBeingGrappled(target) {
        ArrayPush(validTargets, target);
      };
      i += 1;
    };
    selectedTargetIndex = -1;
    i = 0;
    while i < ArraySize(validTargets) {
      distToTarget = Vector4.Distance(ScriptExecutionContext.GetOwner(context).GetWorldPosition(), validTargets[i].GetWorldPosition());
      if i == 0 || distToTarget < shortestDistance {
        shortestDistance = distToTarget;
        selectedTargetIndex = i;
      };
      i += 1;
    };
    if selectedTargetIndex >= 0 {
      target = validTargets[selectedTargetIndex];
      return target != null;
    };
    target = null;
    return false;
  }
}

public class AIFollowerTakedownCommandDelegate extends ScriptBehaviorDelegate {

  public inline edit let m_inCommand: ref<AIArgumentMapping>;

  public let approachBeforeTakedown: Bool;

  public let doNotTeleportIfTargetIsVisible: Bool;

  public final func OnActivate(context: ScriptExecutionContext) -> Bool {
    let rawCommand: ref<IScriptable>;
    let typedCommand: ref<AIFollowerTakedownCommand>;
    if IsDefined(this.m_inCommand) {
      rawCommand = ScriptExecutionContext.GetScriptableMappingValue(context, this.m_inCommand);
      typedCommand = rawCommand as AIFollowerTakedownCommand;
    };
    if IsDefined(typedCommand) {
      this.approachBeforeTakedown = typedCommand.approachBeforeTakedown;
      this.doNotTeleportIfTargetIsVisible = typedCommand.doNotTeleportIfTargetIsVisible;
    };
    return true;
  }

  public final func OnDeactivate(context: ScriptExecutionContext) -> Bool {
    return true;
  }
}

public class AIFollowerInterpolateFollowingSpeed extends AIbehaviortaskScript {

  @runtimeProperty("customEditor", "TweakDBGroupInheritance;AIActionCondition")
  public edit let m_enterCondition: TweakDBID;

  @runtimeProperty("customEditor", "TweakDBGroupInheritance;AIActionCondition")
  public edit let m_exitCondition: TweakDBID;

  public edit let m_minInterpolationDistanceToDestination: Float;

  public edit let m_maxInterpolationDistanceToDestination: Float;

  public edit let m_maxTimeDilation: Float;

  private let m_enterConditionInstance: wref<AIActionCondition_Record>;

  private let m_exitConditionInstace: wref<AIActionCondition_Record>;

  private let m_isActive: Bool;

  @default(AIFollowerInterpolateFollowingSpeed, Following)
  private let m_reason: CName;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    this.m_enterConditionInstance = TweakDBInterface.GetAIActionConditionRecord(this.m_enterCondition);
    this.m_exitConditionInstace = TweakDBInterface.GetAIActionConditionRecord(this.m_exitCondition);
    this.m_isActive = false;
    AIbehaviortaskScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  private final func MakeActive(context: ScriptExecutionContext) -> Void {
    this.m_isActive = true;
  }

  private final func MakeInactive(context: ScriptExecutionContext) -> Void {
    this.m_isActive = false;
    if ScriptExecutionContext.GetOwner(context).HasIndividualTimeDilation(this.m_reason) {
      ScriptExecutionContext.GetOwner(context).UnsetIndividualTimeDilation(n"KereznikovDodgeEaseOut");
    };
  }

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let alpha: Float;
    let distance: Float;
    let movePoliciesComponent: ref<MovePoliciesComponent>;
    if this.m_isActive && AICondition.CheckActionCondition(context, this.m_exitConditionInstace) {
      this.MakeInactive(context);
    } else {
      if !this.m_isActive && AICondition.CheckActionCondition(context, this.m_enterConditionInstance) {
        this.MakeActive(context);
      };
    };
    if this.m_isActive {
      if !ScriptExecutionContext.GetOwner(context).HasIndividualTimeDilation() || ScriptExecutionContext.GetOwner(context).HasIndividualTimeDilation(this.m_reason) {
        movePoliciesComponent = (ScriptExecutionContext.GetOwner(context) as ScriptedPuppet).GetMovePolicesComponent();
        distance = movePoliciesComponent.GetDistanceToDestination();
        if ScriptedPuppet.IsPlayerCompanion(ScriptExecutionContext.GetOwner(context)) {
          distance += Vector4.Distance(GameInstance.GetPlayerSystem(ScriptExecutionContext.GetOwner(context).GetGame()).GetLocalPlayerControlledGameObject().GetWorldPosition(), movePoliciesComponent.GetDestination());
        };
        alpha = (distance - this.m_minInterpolationDistanceToDestination) / (this.m_maxInterpolationDistanceToDestination - this.m_minInterpolationDistanceToDestination);
        alpha = ClampF(alpha, 0.00, 1.00);
        ScriptExecutionContext.GetOwner(context).SetIndividualTimeDilation(this.m_reason, 1.00 + alpha * (this.m_maxTimeDilation - 1.00), -1.00, n"None", n"None");
      };
    };
    return AIbehaviorUpdateOutcome.IN_PROGRESS;
  }

  private final func Deactivate(context: ScriptExecutionContext) -> Void {
    this.MakeInactive(context);
  }
}

public class AIFollowerBeforeTakedown extends AIbehaviortaskScript {

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let combatTarget: wref<GameObject> = ScriptExecutionContext.GetArgumentObject(context, n"CombatTarget");
    if !IsDefined(combatTarget) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    if !ScriptedPuppet.IsActive(combatTarget) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    if ScriptedPuppet.IsBeingGrappled(combatTarget) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    TakedownUtils.SetTargetBodyType(ScriptExecutionContext.GetOwner(context), combatTarget, true);
    TakedownUtils.SetTargetBodyType(combatTarget, ScriptExecutionContext.GetOwner(context), true);
    return AIbehaviorUpdateOutcome.SUCCESS;
  }
}
