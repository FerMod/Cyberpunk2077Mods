
public class FollowerFindTeleportPositionRightBehindTarget extends AIbehaviortaskScript {

  public inline edit let m_target: ref<AIArgumentMapping>;

  public inline edit let m_outPositionArgument: ref<AIArgumentMapping>;

  private let m_lastResultTimestamp: Float;

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let movePoliciesComponent: ref<MovePoliciesComponent>;
    let ratioCurveName: CName;
    let telportPosition: Vector4;
    let followTarget: wref<GameObject> = FromVariant<wref<GameObject>>(ScriptExecutionContext.GetMappingValue(context, this.m_target));
    let navigationSystem: ref<AINavigationSystem> = GameInstance.GetAINavigationSystem(ScriptExecutionContext.GetOwner(context).GetGame());
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
    if !navigationSystem.GetFurthestNavmeshPointBehind(followTarget, 3.00, 1, telportPosition, followTarget.GetWorldForward() * 5.50, true, ratioCurveName) {
      this.m_lastResultTimestamp = EngineTime.ToFloat(ScriptExecutionContext.GetAITime(context));
      return AIbehaviorUpdateOutcome.IN_PROGRESS;
    };
    ScriptExecutionContext.SetMappingValue(context, this.m_outPositionArgument, ToVariant(telportPosition));
    this.m_lastResultTimestamp = EngineTime.ToFloat(ScriptExecutionContext.GetAITime(context));
    return AIbehaviorUpdateOutcome.SUCCESS;
  }
}
