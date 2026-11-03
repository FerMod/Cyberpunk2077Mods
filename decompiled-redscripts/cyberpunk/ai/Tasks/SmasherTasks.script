
public class SmasherFindTeleportPositionAroundTarget extends AIbehaviortaskScript {

  public inline edit let m_target: ref<AIArgumentMapping>;

  public inline edit let m_minDistance: Float;

  public inline edit let m_maxDistance: Float;

  public inline edit let m_minDistanceFromLastTeleport: Float;

  public inline edit let m_rotateToTarget: Bool;

  public inline edit let m_checkZLevel: Bool;

  public inline edit let m_maintainLineOfSight: Bool;

  public inline edit let m_teleportInPlayersFOV: Bool;

  public inline edit let m_doPathCheck: Bool;

  public inline edit let m_doWallCheck: Bool;

  public inline edit let m_outPosition: ref<AIArgumentMapping>;

  public inline edit let m_outRotation: ref<AIArgumentMapping>;

  public inline edit let m_outDirection: ref<AIArgumentMapping>;

  @default(SmasherFindTeleportPositionAroundTarget, 0.3f)
  private let c_zLevelTolerance: Float;

  private let m_referenceTarget: wref<GameObject>;

  private let m_fallbackPosition: Vector4;

  private let m_fallbackPositionQuality: Int32;

  private let m_blackboard: wref<IBlackboard>;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    this.m_referenceTarget = FromVariant<wref<GameObject>>(ScriptExecutionContext.GetMappingValue(context, this.m_target));
    this.m_fallbackPositionQuality = -1;
    this.m_blackboard = (ScriptExecutionContext.GetOwner(context) as ScriptedPuppet).GetAIControllerComponent().GetActionBlackboard();
  }

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let angle: Float;
    let maxAngle: Float;
    let middleDistance: Float;
    let minAngle: Float;
    let navigationPath: ref<NavigationPath>;
    let navigationSystem: ref<AINavigationSystem>;
    let navmeshPosition: Vector4;
    let pointResult: NavigationFindPointResult;
    let targetPosition: Vector4;
    let testSphereRadius: Float;
    let testedPosition: Vector4;
    let wallResult: ref<NavigationFindWallResult>;
    let wallCheckOffset: Vector4 = new Vector4(0.00, 0.00, this.c_zLevelTolerance, 0.00);
    let angleStep: Float = 10.00;
    if !IsDefined(this.m_referenceTarget) || !this.m_referenceTarget.IsAttached() {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    navigationSystem = GameInstance.GetAINavigationSystem(ScriptExecutionContext.GetOwner(context).GetGame());
    if !IsDefined(navigationSystem) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    if this.m_maxDistance <= this.m_minDistance {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    targetPosition = this.m_referenceTarget.GetWorldPosition();
    middleDistance = (this.m_minDistance + this.m_maxDistance) / 2.00;
    testSphereRadius = (this.m_maxDistance - this.m_minDistance) / 2.00;
    minAngle = Cast<Float>(RandRange(0, 360));
    maxAngle = minAngle + 360.00;
    angle = minAngle;
    while angle < maxAngle {
      testedPosition = targetPosition;
      testedPosition.X += CosF(Deg2Rad(angle)) * middleDistance;
      testedPosition.Y += SinF(Deg2Rad(angle)) * middleDistance;
      pointResult = navigationSystem.FindPointInSphereForCharacter(testedPosition, testSphereRadius, ScriptExecutionContext.GetOwner(context));
      if NotEquals(pointResult.status, worldNavigationRequestStatus.OK) {
      } else {
        navmeshPosition = pointResult.point;
        if this.m_doWallCheck {
          wallResult = navigationSystem.FindWallInLineForCharacter(ScriptExecutionContext.GetOwner(context).GetWorldPosition() + wallCheckOffset, navmeshPosition + wallCheckOffset, 0.20, ScriptExecutionContext.GetOwner(context));
          if NotEquals(wallResult.status, worldNavigationRequestStatus.OK) || wallResult.isHit {
          } else {
            if this.m_doPathCheck {
              navigationPath = navigationSystem.CalculatePathForCharacter(targetPosition, navmeshPosition, 0.50, ScriptExecutionContext.GetOwner(context));
              if ArraySize(navigationPath.path) <= 0 {
              } else {
                if this.VerifyPosition(context, navmeshPosition) {
                  this.ProcessSelectedPosition(context, navmeshPosition);
                  return AIbehaviorUpdateOutcome.SUCCESS;
                };
              };
            };
            if this.VerifyPosition(context, navmeshPosition) {
              this.ProcessSelectedPosition(context, navmeshPosition);
              return AIbehaviorUpdateOutcome.SUCCESS;
            };
          };
        };
        if this.m_doPathCheck {
          navigationPath = navigationSystem.CalculatePathForCharacter(targetPosition, navmeshPosition, 0.50, ScriptExecutionContext.GetOwner(context));
          if ArraySize(navigationPath.path) <= 0 {
          } else {
            if this.VerifyPosition(context, navmeshPosition) {
              this.ProcessSelectedPosition(context, navmeshPosition);
              return AIbehaviorUpdateOutcome.SUCCESS;
            };
          };
        };
        if this.VerifyPosition(context, navmeshPosition) {
          this.ProcessSelectedPosition(context, navmeshPosition);
          return AIbehaviorUpdateOutcome.SUCCESS;
        };
      };
      angle += angleStep;
    };
    if this.m_fallbackPositionQuality >= 0 {
      this.ProcessSelectedPosition(context, this.m_fallbackPosition);
      return AIbehaviorUpdateOutcome.SUCCESS;
    };
    return AIbehaviorUpdateOutcome.FAILURE;
  }

  private final func IsInPlayersFOV(context: ScriptExecutionContext, position: Vector4) -> Bool {
    let angleToTarget: Float;
    let cameraFwd: Vector4;
    let cameraPos: Vector4;
    let cameraTransform: Transform;
    let direction: Vector4;
    let cameraSystem: ref<CameraSystem> = GameInstance.GetCameraSystem(ScriptExecutionContext.GetOwner(context).GetGame());
    if !cameraSystem.GetActiveCameraWorldTransform(cameraTransform) {
      return false;
    };
    cameraPos = Transform.GetPosition(cameraTransform);
    cameraFwd = Transform.GetForward(cameraTransform);
    direction = position - cameraPos;
    angleToTarget = Vector4.GetAngleDegAroundAxis(direction, cameraFwd, ScriptExecutionContext.GetOwner(context).GetWorldUp());
    return AbsF(angleToTarget) < 30.00;
  }

  private final func IsTooCloseToLastTeleport(context: ScriptExecutionContext, position: Vector4) -> Bool {
    let lastTeleportPosition: Vector4;
    if !IsDefined(this.m_blackboard) {
      return false;
    };
    lastTeleportPosition = this.m_blackboard.GetVector4(GetAllBlackboardDefs().AIActionBossData.excludedTeleportPosition);
    return Vector4.Distance(lastTeleportPosition, position) < this.m_minDistanceFromLastTeleport;
  }

  private final func VerifyPosition(context: ScriptExecutionContext, position: Vector4) -> Bool {
    let ownerSenseManager: ref<SenseManager>;
    let targetPosition: Vector4;
    let losOffset: Vector4 = new Vector4(0.00, 0.00, 1.80, 0.00);
    this.TryUpdateFallbackPosition(position, 0);
    if this.m_teleportInPlayersFOV && !this.IsInPlayersFOV(context, position) {
      return false;
    };
    this.TryUpdateFallbackPosition(position, 1);
    targetPosition = this.m_referenceTarget.GetWorldPosition();
    ownerSenseManager = GameInstance.GetSenseManager(ScriptExecutionContext.GetOwner(context).GetGame());
    if this.m_maintainLineOfSight && !ownerSenseManager.IsPositionVisible(position + losOffset, targetPosition + losOffset) {
      return false;
    };
    this.TryUpdateFallbackPosition(position, 2);
    if this.m_minDistanceFromLastTeleport > 0.00 && this.IsTooCloseToLastTeleport(context, position) {
      return false;
    };
    this.TryUpdateFallbackPosition(position, 3);
    targetPosition = this.m_referenceTarget.GetWorldPosition();
    if this.m_checkZLevel && AbsF(targetPosition.Z - position.Z) > this.c_zLevelTolerance {
      return false;
    };
    return true;
  }

  private final func TryUpdateFallbackPosition(position: Vector4, quality: Int32) -> Void {
    if quality <= this.m_fallbackPositionQuality {
      return;
    };
    this.m_fallbackPositionQuality = quality;
    this.m_fallbackPosition = position;
  }

  private final func ProcessSelectedPosition(context: ScriptExecutionContext, position: Vector4) -> Void {
    let orientation: EulerAngles;
    let ownerToTargetVector: Vector4;
    let ownerPosition: Vector4 = ScriptExecutionContext.GetOwner(context).GetWorldPosition();
    if this.m_rotateToTarget {
      ownerToTargetVector = position - ownerPosition;
      orientation = Quaternion.ToEulerAngles(Quaternion.BuildFromDirectionVector(ownerToTargetVector));
    };
    ScriptExecutionContext.SetMappingValue(context, this.m_outPosition, ToVariant(position));
    ScriptExecutionContext.SetMappingValue(context, this.m_outRotation, ToVariant(orientation.Yaw));
    ScriptExecutionContext.SetMappingValue(context, this.m_outDirection, ToVariant(position - ownerPosition));
    if IsDefined(this.m_blackboard) {
      this.m_blackboard.SetVector4(GetAllBlackboardDefs().AIActionBossData.excludedTeleportPosition, position);
    };
  }
}

public class SmasherPlayVFX extends AIbehaviortaskScript {

  private inline edit let m_vfxOffset: Vector3;

  private inline edit let m_vfxResource: FxResource;

  private inline edit let m_fxDirection: ref<AIArgumentMapping>;

  private inline edit let m_attachmentSlotName: CName;

  private inline edit let m_delay: Float;

  private inline edit let m_KillFx: Bool;

  private inline edit let m_effectToKill: CName;

  private let m_owner: wref<GameObject>;

  private let m_vfxInstance: ref<FxInstance>;

  private let m_startTime: Float;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    this.m_owner = ScriptExecutionContext.GetOwner(context) as NPCPuppet;
    this.m_startTime = EngineTime.ToFloat(GameInstance.GetTimeSystem(this.m_owner.GetGame()).GetSimTime());
  }

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let currentTime: Float;
    let fxDirection: Vector4;
    let fxPosition: Vector4;
    if this.m_delay > 0.00 {
      currentTime = EngineTime.ToFloat(GameInstance.GetTimeSystem(this.m_owner.GetGame()).GetSimTime());
      if currentTime < this.m_startTime + this.m_delay {
        return AIbehaviorUpdateOutcome.IN_PROGRESS;
      };
    };
    if !FxResource.IsValid(this.m_vfxResource) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    if IsNameValid(this.m_attachmentSlotName) {
      AIActionHelper.GetTargetSlotPosition(this.m_owner, this.m_attachmentSlotName, fxPosition);
    } else {
      fxPosition = this.m_owner.GetWorldPosition();
    };
    fxPosition += Vector4.Vector3To4(this.m_vfxOffset);
    fxDirection = FromVariant<Vector4>(ScriptExecutionContext.GetMappingValue(context, this.m_fxDirection));
    if this.m_KillFx {
      GameObject.BreakReplicatedEffectLoopEvent(this.m_owner, this.m_effectToKill);
    } else {
      this.SpawnVFX(context, this.m_vfxResource, fxPosition, fxDirection);
    };
    return AIbehaviorUpdateOutcome.SUCCESS;
  }

  private final func SpawnVFX(context: ScriptExecutionContext, fx: FxResource, fxPosition: Vector4, fxDirection: Vector4) -> Void {
    let position: WorldPosition;
    let transform: WorldTransform;
    if FxResource.IsValid(fx) {
      WorldPosition.SetVector4(position, fxPosition);
      WorldTransform.SetWorldPosition(transform, position);
      WorldTransform.SetOrientationFromDir(transform, fxDirection);
      this.m_vfxInstance = this.CreateFxInstance(context, fx, transform);
    };
  }

  private final func CreateFxInstance(context: ScriptExecutionContext, resource: FxResource, transform: WorldTransform) -> ref<FxInstance> {
    let fxSystem: ref<FxSystem> = GameInstance.GetFxSystem(AIBehaviorScriptBase.GetGame(context));
    let fx: ref<FxInstance> = fxSystem.SpawnEffect(resource, transform);
    return fx;
  }

  protected func Deactivate(context: ScriptExecutionContext) -> Void {
    this.m_vfxInstance.BreakLoop();
  }
}
