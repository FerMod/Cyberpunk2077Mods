
public class FindTeleportPositionForTakedown extends AIbehaviorconditionScript {

  public inline edit let m_target: ref<AIArgumentMapping>;

  public inline edit let m_extents: ref<AIArgumentMapping>;

  public inline edit let m_extentsOffset: ref<AIArgumentMapping>;

  public inline edit let m_workspotRotation: ref<AIArgumentMapping>;

  public inline edit let m_workspotOffset: ref<AIArgumentMapping>;

  public inline edit let m_outPositionArgument: ref<AIArgumentMapping>;

  public inline edit let m_outRotationArgument: ref<AIArgumentMapping>;

  public inline edit let m_outMaybeStairs: ref<AIArgumentMapping>;

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let maybeStairs: Bool;
    let queryDefaultPos: Vector4;
    let targetDirection: Vector4;
    let targetOrientation: Quaternion;
    let teleportPosition: Vector4;
    let teleportRotation: EulerAngles;
    let followTarget: wref<GameObject> = FromVariant<wref<GameObject>>(ScriptExecutionContext.GetMappingValue(context, this.m_target));
    let queryExtents: Vector4 = FromVariant<Vector4>(ScriptExecutionContext.GetMappingValue(context, this.m_extents));
    let extentsOffset: Vector4 = FromVariant<Vector4>(ScriptExecutionContext.GetMappingValue(context, this.m_extentsOffset));
    let workspotOffset: Vector4 = FromVariant<Vector4>(ScriptExecutionContext.GetMappingValue(context, this.m_workspotOffset));
    let workspotRotation: Float = FromVariant<Float>(ScriptExecutionContext.GetMappingValue(context, this.m_workspotRotation));
    let navigationSystem: ref<AINavigationSystem> = GameInstance.GetAINavigationSystem(ScriptExecutionContext.GetOwner(context).GetGame());
    if !IsDefined(navigationSystem) || !IsDefined(followTarget) {
      return AIbehaviorConditionOutcomes.Failure;
    };
    if Vector4.IsZero(queryExtents) {
      queryExtents = new Vector4(0.50, 0.50, 0.50, 0.00);
    };
    targetDirection = ScriptExecutionContext.GetOwner(context).GetWorldPosition() - followTarget.GetWorldPosition();
    targetDirection.Z = 0.00;
    targetDirection = Vector4.Normalize(targetDirection);
    if !Vector4.IsZero(targetDirection) {
      targetOrientation = Quaternion.BuildFromDirectionVector(targetDirection, new Vector4(0.00, 0.00, 1.00, 0.00));
    } else {
      targetOrientation = followTarget.GetWorldOrientation();
    };
    if !this.GetNavmeshPointWithOffset(followTarget, teleportPosition, targetOrientation, new Vector4()) {
      return AIbehaviorConditionOutcomes.False;
    };
    queryDefaultPos = teleportPosition + targetOrientation * extentsOffset;
    if !this.CheckForOverlapAdvanced(context, extentsOffset, queryDefaultPos, queryExtents, teleportPosition, targetOrientation) {
      maybeStairs = this.CheckForStairs(context, teleportPosition);
      teleportPosition = teleportPosition + targetOrientation * workspotOffset;
      teleportRotation = Quaternion.ToEulerAngles(targetOrientation);
      ScriptExecutionContext.SetMappingValue(context, this.m_outPositionArgument, ToVariant(teleportPosition));
      ScriptExecutionContext.SetMappingValue(context, this.m_outRotationArgument, ToVariant(teleportRotation.Yaw + workspotRotation));
      ScriptExecutionContext.SetMappingValue(context, this.m_outMaybeStairs, ToVariant(maybeStairs));
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }

  private final const func GetNavmeshPointWithOffset(const origin: wref<Entity>, out point: Vector4, const rotation: Quaternion, opt offset: Vector4) -> Bool {
    let checkedPosition: Vector4;
    let checkedResults: NavigationFindPointResult;
    let navigationPath: ref<NavigationPath>;
    let navigationSystem: ref<AINavigationSystem>;
    if !IsDefined(origin) {
      return false;
    };
    navigationSystem = GameInstance.GetAINavigationSystem((origin as GameObject).GetGame());
    checkedPosition = origin.GetWorldPosition() + rotation * offset;
    checkedResults = navigationSystem.FindPointInSphereForCharacter(checkedPosition, 0.50, origin);
    if NotEquals(checkedResults.status, worldNavigationRequestStatus.OK) {
      return false;
    };
    navigationPath = navigationSystem.CalculatePathForCharacter(checkedResults.point, checkedPosition, 0.50, origin);
    if ArraySize(navigationPath.path) <= 0 {
      return false;
    };
    point = checkedResults.point;
    return true;
  }

  private final func DrawDebugBox(context: ScriptExecutionContext, position: Vector4, extents: Vector4, orientation: Quaternion) -> Void {
    let t: WorldTransform;
    let v0: Vector4;
    let v1: Vector4;
    let v2: Vector4;
    let v3: Vector4;
    let debugVisualizerSystem: ref<DebugVisualizerSystem> = GameInstance.GetDebugVisualizerSystem(ScriptExecutionContext.GetOwner(context).GetGame());
    WorldTransform.SetPosition(t, position);
    WorldTransform.SetOrientation(t, orientation);
    v0 = WorldPosition.ToVector4(WorldTransform.TransformPoint(t, new Vector4(extents.X, -extents.Y, 0.00, 0.00)));
    v1 = WorldPosition.ToVector4(WorldTransform.TransformPoint(t, new Vector4(extents.X, extents.Y, 0.00, 0.00)));
    v2 = WorldPosition.ToVector4(WorldTransform.TransformPoint(t, new Vector4(-extents.X, extents.Y, 0.00, 0.00)));
    v3 = WorldPosition.ToVector4(WorldTransform.TransformPoint(t, new Vector4(-extents.X, -extents.Y, 0.00, 0.00)));
    debugVisualizerSystem.DrawLine3D(v0, v1, new Color(255u, 0u, 0u, 255u), 15.00);
    debugVisualizerSystem.DrawLine3D(v1, v2, new Color(255u, 0u, 0u, 255u), 15.00);
    debugVisualizerSystem.DrawLine3D(v2, v3, new Color(255u, 0u, 0u, 255u), 15.00);
    debugVisualizerSystem.DrawLine3D(v3, v0, new Color(255u, 0u, 0u, 255u), 15.00);
  }

  private final func CheckForOverlapAdvanced(context: ScriptExecutionContext, queryOffset: Vector4, queryDefaultPos: Vector4, queryExtents: Vector4, queryPosition: Vector4, out queryOrientation: Quaternion) -> Bool {
    let isHit: Bool;
    let perpDirection: Vector4;
    let perpOrientation: Quaternion;
    let queryEnd: Vector4;
    let queryFilter: QueryFilter;
    let queryResult: TraceResult;
    let spatialQueriesSystem: ref<SpatialQueriesSystem>;
    let worldNormal: Vector4;
    QueryFilter.AddGroup(queryFilter, n"Static");
    QueryFilter.AddGroup(queryFilter, n"Dynamic");
    QueryFilter.AddGroup(queryFilter, n"Terrain");
    QueryFilter.AddGroup(queryFilter, n"Collider");
    QueryFilter.AddGroup(queryFilter, n"Destructible");
    if !this.CheckForOverlap(context, queryDefaultPos, queryExtents, queryOrientation, queryFilter) {
      return false;
    };
    spatialQueriesSystem = GameInstance.GetSpatialQueriesSystem(ScriptExecutionContext.GetOwner(context).GetGame());
    Quaternion.SetIdentity(perpOrientation);
    Quaternion.SetZRot(perpOrientation, Deg2Rad(35.00));
    perpOrientation = queryOrientation * perpOrientation;
    if !this.CheckForOverlap(context, queryPosition + perpOrientation * queryOffset, queryExtents, perpOrientation, queryFilter) {
      queryOrientation = perpOrientation;
      return false;
    };
    Quaternion.SetIdentity(perpOrientation);
    Quaternion.SetZRot(perpOrientation, Deg2Rad(-35.00));
    perpOrientation = queryOrientation * perpOrientation;
    if !this.CheckForOverlap(context, queryPosition + perpOrientation * queryOffset, queryExtents, perpOrientation, queryFilter) {
      queryOrientation = perpOrientation;
      return false;
    };
    queryEnd = queryPosition + queryOrientation * new Vector4(0.00, queryExtents.Y * 2.00, 0.00, 0.00);
    isHit = spatialQueriesSystem.SyncRaycastByQueryFilter(queryPosition, queryEnd, queryFilter, queryResult);
    if isHit {
      worldNormal = Cast<Vector4>(queryResult.normal);
      worldNormal.Z = 0.00;
      worldNormal = Vector4.Normalize(worldNormal);
      perpDirection = Vector4.Cross(worldNormal, new Vector4(0.00, 0.00, 1.00, 0.00));
      perpOrientation = Quaternion.BuildFromDirectionVector(perpDirection);
      if !this.CheckForOverlap(context, queryPosition + perpOrientation * queryOffset, queryExtents, perpOrientation, queryFilter) {
        queryOrientation = perpOrientation;
        return false;
      };
      perpDirection = -perpDirection;
      perpOrientation = Quaternion.BuildFromDirectionVector(perpDirection);
      if !this.CheckForOverlap(context, queryPosition + perpOrientation * queryOffset, queryExtents, perpOrientation, queryFilter) {
        queryOrientation = perpOrientation;
        return false;
      };
    };
    queryEnd = queryPosition + queryOrientation * new Vector4(0.00, -queryExtents.Y * 2.00, 0.00, 0.00);
    isHit = spatialQueriesSystem.SyncRaycastByQueryFilter(queryPosition, queryEnd, queryFilter, queryResult);
    if isHit {
      worldNormal = Cast<Vector4>(queryResult.normal);
      worldNormal.Z = 0.00;
      worldNormal = Vector4.Normalize(worldNormal);
      perpDirection = Vector4.Cross(worldNormal, new Vector4(0.00, 0.00, 1.00, 0.00));
      perpOrientation = Quaternion.BuildFromDirectionVector(perpDirection);
      if !this.CheckForOverlap(context, queryPosition + perpOrientation * queryOffset, queryExtents, perpOrientation, queryFilter) {
        queryOrientation = perpOrientation;
        return false;
      };
      perpDirection = -perpDirection;
      perpOrientation = Quaternion.BuildFromDirectionVector(perpDirection);
      if !this.CheckForOverlap(context, queryPosition + perpOrientation * queryOffset, queryExtents, perpOrientation, queryFilter) {
        queryOrientation = perpOrientation;
        return false;
      };
    };
    return true;
  }

  private final func CheckForOverlap(context: ScriptExecutionContext, targetPosition: Vector4, queryDimensions: Vector4, queryOrientation: Quaternion, queryFilter: QueryFilter) -> Bool {
    let queryResult: TraceResult;
    let spatialQueriesSystem: ref<SpatialQueriesSystem> = GameInstance.GetSpatialQueriesSystem(ScriptExecutionContext.GetOwner(context).GetGame());
    let queryExtents: Vector4 = new Vector4(queryDimensions.X * 0.50, queryDimensions.Y * 0.50, queryDimensions.Z * 0.50, queryDimensions.W);
    let queryPosition: Vector4 = targetPosition + new Vector4(0.00, 0.00, 0.10 + queryExtents.Z, 0.00);
    if spatialQueriesSystem.GetDebugPreviewDuration() > 0.00 {
      this.DrawDebugBox(context, queryPosition, queryExtents, queryOrientation);
    };
    return spatialQueriesSystem.OverlapByQueryFilter(queryExtents, queryPosition, queryOrientation, queryFilter, queryResult);
  }

  private final func CheckForStairs(context: ScriptExecutionContext, targetPosition: Vector4) -> Bool {
    let dotFacingTop: Float;
    let queryFilter: QueryFilter;
    let queryResult: TraceResult;
    let spatialQueriesSystem: ref<SpatialQueriesSystem> = GameInstance.GetSpatialQueriesSystem(ScriptExecutionContext.GetOwner(context).GetGame());
    let debugVisualizerSystem: ref<DebugVisualizerSystem> = GameInstance.GetDebugVisualizerSystem(ScriptExecutionContext.GetOwner(context).GetGame());
    let debugPreviewDuration: Float = spatialQueriesSystem.GetDebugPreviewDuration();
    if debugPreviewDuration > 0.00 {
      debugVisualizerSystem.DrawWireSphere(targetPosition, 0.50, new Color(255u, 0u, 0u, 255u), debugPreviewDuration);
    };
    QueryFilter.AddGroup(queryFilter, n"Static");
    QueryFilter.AddGroup(queryFilter, n"Dynamic");
    QueryFilter.AddGroup(queryFilter, n"Terrain");
    QueryFilter.AddGroup(queryFilter, n"Collider");
    QueryFilter.AddGroup(queryFilter, n"Destructible");
    if !spatialQueriesSystem.SyncRaycastByQueryFilter(targetPosition, targetPosition - new Vector4(0.00, 0.00, 1.00, 0.00), queryFilter, queryResult) {
      return false;
    };
    dotFacingTop = Vector4.Dot(Cast<Vector4>(queryResult.normal), new Vector4(0.00, 0.00, 1.00, 0.00));
    if dotFacingTop < 0.00 {
      return false;
    };
    return dotFacingTop < 0.87 && dotFacingTop > 0.82;
  }
}
