
public class SpatialQueriesHelper extends IScriptable {

  public final static func HasSpaceInFront(const sourceObject: wref<GameObject>, groundClearance: Float, areaWidth: Float, areaLength: Float, areaHeight: Float) -> Bool {
    let hasSpace: Bool = SpatialQueriesHelper.HasSpaceInFront(sourceObject, sourceObject.GetWorldForward(), groundClearance, areaWidth, areaLength, areaHeight);
    return hasSpace;
  }

  public final static func HasSpaceInFront(const sourceObject: wref<GameObject>, queryDirection: Vector4, groundClearance: Float, areaWidth: Float, areaLength: Float, areaHeight: Float) -> Bool {
    let boxDimensions: Vector4;
    let boxOrientation: EulerAngles;
    let fitTestOvelap: TraceResult;
    let overlapSuccessStatic: Bool;
    let overlapSuccessVehicle: Bool;
    queryDirection.Z = 0.00;
    queryDirection = Vector4.Normalize(queryDirection);
    boxDimensions.X = areaWidth * 0.50;
    boxDimensions.Y = areaLength * 0.50;
    boxDimensions.Z = areaHeight * 0.50;
    let queryPosition: Vector4 = sourceObject.GetWorldPosition();
    queryPosition.Z += boxDimensions.Z + groundClearance;
    queryPosition += boxDimensions.Y * queryDirection;
    boxOrientation = Quaternion.ToEulerAngles(Quaternion.BuildFromDirectionVector(queryDirection));
    overlapSuccessStatic = GameInstance.GetSpatialQueriesSystem(sourceObject.GetGame()).Overlap(boxDimensions, queryPosition, boxOrientation, n"Static", fitTestOvelap);
    overlapSuccessVehicle = GameInstance.GetSpatialQueriesSystem(sourceObject.GetGame()).Overlap(boxDimensions, queryPosition, boxOrientation, n"Vehicle", fitTestOvelap);
    return !overlapSuccessStatic && !overlapSuccessVehicle;
  }

  public final static func GetFloorAngle(const sourceObject: wref<GameObject>, out floorAngle: Float) -> Bool {
    let raycastResult: TraceResult;
    let startPosition: Vector4 = sourceObject.GetWorldPosition() + new Vector4(0.00, 0.00, 0.10, 0.00);
    let endPosition: Vector4 = sourceObject.GetWorldPosition() + new Vector4(0.00, 0.00, -0.30, 0.00);
    if GameInstance.GetSpatialQueriesSystem(sourceObject.GetGame()).SyncRaycastByCollisionGroup(startPosition, endPosition, n"Static", raycastResult, true, false) {
      floorAngle = Vector4.GetAngleBetween(Cast<Vector4>(raycastResult.normal), sourceObject.GetWorldUp());
      return true;
    };
    return false;
  }

  public final static func IsTargetReachable(owner: ref<GameObject>, target: ref<GameObject>, targetPos: Vector4, depthTestForObstacle: Bool, out isObstacleVaultable: Bool) -> Bool {
    let cameraWorldTransform: Transform;
    let cameraWorldTransformPos: Vector4;
    let geometryDescription: ref<GeometryDescriptionQuery>;
    let geometryDescriptionResult: ref<GeometryDescriptionResult>;
    let heightDifference: Float;
    let isTargetReachable: Bool;
    let maxObstacleExtent: Float;
    let playerPos: Vector4;
    let queryFilter: QueryFilter;
    let refPosition: Vector4;
    let topPointFromPlayer: Vector4;
    let topPointFromTarget: Vector4;
    let vecToTarget: Vector4;
    let scriptedPuppet: ref<ScriptedPuppet> = target as ScriptedPuppet;
    let spatialQueriesSystem: ref<SpatialQueriesSystem> = GameInstance.GetSpatialQueriesSystem(owner.GetGame());
    if !IsDefined(target) || IsDefined(scriptedPuppet) && scriptedPuppet.IsCivilian() {
      return false;
    };
    GameInstance.GetCameraSystem(owner.GetGame()).GetActiveCameraWorldTransform(cameraWorldTransform);
    cameraWorldTransformPos = Transform.GetPosition(cameraWorldTransform);
    QueryFilter.AddGroup(queryFilter, n"Static");
    QueryFilter.AddGroup(queryFilter, n"PlayerBlocker");
    playerPos = owner.GetWorldPosition();
    if Vector4.IsZero(targetPos) {
      targetPos = target.GetWorldPosition();
    };
    if !depthTestForObstacle && targetPos.Z > cameraWorldTransformPos.Z {
      heightDifference = targetPos.Z - cameraWorldTransformPos.Z;
    };
    targetPos.Z += cameraWorldTransformPos.Z - playerPos.Z;
    refPosition = cameraWorldTransformPos;
    refPosition.Z += heightDifference;
    if depthTestForObstacle {
      targetPos.Z -= 0.50;
      refPosition.Z -= 0.50;
    };
    vecToTarget = targetPos - refPosition;
    vecToTarget -= Vector4.Normalize(vecToTarget) * 0.03;
    geometryDescription = new GeometryDescriptionQuery();
    geometryDescription.refPosition = refPosition;
    geometryDescription.refDirection = vecToTarget;
    geometryDescription.filter = queryFilter;
    geometryDescription.primitiveDimension = new Vector4(0.10, 0.10, 0.10, 0.00);
    geometryDescription.primitiveRotation = Quaternion.BuildFromDirectionVector(vecToTarget, Transform.GetUp(cameraWorldTransform));
    geometryDescription.maxDistance = Vector4.Length(vecToTarget);
    geometryDescription.maxExtent = 0.01;
    geometryDescription.probingPrecision = 0.01;
    geometryDescription.probingMaxDistanceDiff = 0.01;
    geometryDescription.probingMaxHeight = 0.30;
    geometryDescription.maxProbes = 1u;
    geometryDescription.AddFlag(worldgeometryDescriptionQueryFlags.DistanceVector);
    if depthTestForObstacle {
      geometryDescription.primitiveDimension.X = 0.30;
      geometryDescription.probingMaxHeight = 0.90;
    };
    geometryDescriptionResult = spatialQueriesSystem.GetGeometryDescriptionSystem().QueryExtents(geometryDescription);
    isTargetReachable = Equals(geometryDescriptionResult.queryStatus, worldgeometryDescriptionQueryStatus.NoGeometry);
    if (!depthTestForObstacle || depthTestForObstacle && isTargetReachable) && (IsDefined(scriptedPuppet) && scriptedPuppet.IsHumanoid() || target.IsTurret()) {
      heightDifference = 0.15;
      targetPos = target.GetWorldPosition();
      targetPos.Z += heightDifference;
      refPosition = playerPos;
      refPosition.Z += heightDifference;
      vecToTarget = targetPos - refPosition;
      geometryDescription.refPosition = refPosition;
      geometryDescription.refDirection = vecToTarget;
      geometryDescription.maxDistance = Vector4.Length(vecToTarget);
      geometryDescription.primitiveDimension.X = 0.10;
      geometryDescription.probingMaxHeight = (cameraWorldTransformPos.Z - playerPos.Z) / 2.00;
      if depthTestForObstacle {
        geometryDescription.AddFlag(worldgeometryDescriptionQueryFlags.TopPoint);
      };
      geometryDescriptionResult = spatialQueriesSystem.GetGeometryDescriptionSystem().QueryExtents(geometryDescription);
      isObstacleVaultable = NotEquals(geometryDescriptionResult.queryStatus, worldgeometryDescriptionQueryStatus.NoGeometry);
      if isObstacleVaultable && depthTestForObstacle {
        topPointFromPlayer = geometryDescriptionResult.topPoint;
        geometryDescription.refPosition = targetPos;
        geometryDescription.refDirection = -vecToTarget;
        geometryDescriptionResult = spatialQueriesSystem.GetGeometryDescriptionSystem().QueryExtents(geometryDescription);
        topPointFromTarget = geometryDescriptionResult.topPoint;
        maxObstacleExtent = TDB.GetFloat(t"playerStateMachineLocomotion.vault.maxExtent");
        isObstacleVaultable = Vector4.Length(topPointFromTarget - topPointFromPlayer) <= maxObstacleExtent;
        return isObstacleVaultable && isTargetReachable;
      };
    };
    return isTargetReachable;
  }
}
