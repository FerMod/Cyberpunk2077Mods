
public class HorizontalLineTrace extends AIbehaviorconditionScript {

  public inline edit let m_source: ref<AIArgumentMapping>;

  public inline edit let m_target: ref<AIArgumentMapping>;

  public inline edit let m_offset: ref<AIArgumentMapping>;

  public inline edit let m_length: ref<AIArgumentMapping>;

  public inline edit let m_azimuth: ref<AIArgumentMapping>;

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let sourceOrientation: Quaternion;
    let sourcePosition: Vector4;
    let targetDirection: Vector4;
    let targetPosition: Vector4;
    let traceAngles: EulerAngles;
    let traceOrientation: Quaternion;
    let tracePosition: Vector4;
    let sourceIsOwner: Bool = false;
    let source: wref<GameObject> = FromVariant<wref<GameObject>>(ScriptExecutionContext.GetMappingValue(context, this.m_source));
    let target: wref<GameObject> = FromVariant<wref<GameObject>>(ScriptExecutionContext.GetMappingValue(context, this.m_target));
    let traceOffset: Vector4 = FromVariant<Vector4>(ScriptExecutionContext.GetMappingValue(context, this.m_offset));
    let traceLength: Float = FromVariant<Float>(ScriptExecutionContext.GetMappingValue(context, this.m_length));
    let traceAzimuth: Float = FromVariant<Float>(ScriptExecutionContext.GetMappingValue(context, this.m_azimuth));
    if IsDefined(source) {
      sourcePosition = source.GetWorldPosition();
      sourceOrientation = source.GetWorldOrientation();
    } else {
      if Equals(this.m_source.GetArgumentType(), AIArgumentType.Vector) {
        sourcePosition = FromVariant<Vector4>(ScriptExecutionContext.GetMappingValue(context, this.m_source));
      } else {
        sourcePosition = ScriptExecutionContext.GetOwner(context).GetWorldPosition();
        sourceOrientation = ScriptExecutionContext.GetOwner(context).GetWorldOrientation();
        sourceIsOwner = true;
      };
    };
    targetPosition = sourcePosition;
    if IsDefined(target) {
      targetPosition = target.GetWorldPosition();
    } else {
      if Equals(this.m_target.GetArgumentType(), AIArgumentType.Vector) {
        targetPosition = FromVariant<Vector4>(ScriptExecutionContext.GetMappingValue(context, this.m_target));
      } else {
        if Equals(this.m_target.GetArgumentType(), AIArgumentType.Object) && !sourceIsOwner {
          targetPosition = ScriptExecutionContext.GetOwner(context).GetWorldPosition();
        };
      };
    };
    if Vector4.Distance(sourcePosition, targetPosition) > 0.00 {
      targetDirection = targetPosition - sourcePosition;
      targetDirection.Z = 0.00;
      Vector4.Normalize(targetDirection);
      if !Vector4.IsZero(targetDirection) {
        sourceOrientation = Quaternion.BuildFromDirectionVector(targetDirection, new Vector4(0.00, 0.00, 1.00, 0.00));
      };
      if traceLength == 0.00 {
        traceLength = Vector4.Distance(sourcePosition, targetPosition);
      };
    };
    if traceLength == 0.00 {
      return AIbehaviorConditionOutcomes.False;
    };
    traceAngles.Yaw = traceAzimuth;
    traceOrientation = sourceOrientation * EulerAngles.ToQuat(traceAngles);
    tracePosition = sourcePosition + traceOrientation * traceOffset;
    if this.LineTrace(context, tracePosition, traceOrientation, traceLength) {
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }

  private final func LineTrace(context: ScriptExecutionContext, queryPosition: Vector4, queryOrientation: Quaternion, queryLength: Float) -> Bool {
    let queryEnd: Vector4;
    let queryFilter: QueryFilter;
    let queryResult: TraceResult;
    let spatialQueriesSystem: ref<SpatialQueriesSystem>;
    QueryFilter.AddGroup(queryFilter, n"Static");
    QueryFilter.AddGroup(queryFilter, n"Dynamic");
    QueryFilter.AddGroup(queryFilter, n"Terrain");
    QueryFilter.AddGroup(queryFilter, n"Collider");
    QueryFilter.AddGroup(queryFilter, n"Destructible");
    spatialQueriesSystem = GameInstance.GetSpatialQueriesSystem(ScriptExecutionContext.GetOwner(context).GetGame());
    queryEnd = queryPosition + queryOrientation * new Vector4(0.00, queryLength, 0.00, 0.00);
    return spatialQueriesSystem.SyncRaycastByQueryFilter(queryPosition, queryEnd, queryFilter, queryResult);
  }
}
