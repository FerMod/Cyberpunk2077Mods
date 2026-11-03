
public class SetCustomShootPosition extends AIbehaviortaskScript {

  private edit let m_offset: Vector3;

  private edit let m_fxOffset: Vector3;

  private edit let m_lockTimer: Float;

  private edit let m_landIndicatorFX: FxResource;

  private edit let m_keepsAcquiring: Bool;

  @default(SetCustomShootPosition, true)
  private edit let m_shootToTheGround: Bool;

  private edit let m_predictionTime: Float;

  private edit let m_waypointTag: CName;

  private let m_refOwner: wref<AIActionTarget_Record>;

  private let m_refAIActionTarget: wref<AIActionTarget_Record>;

  private let m_refCustomWorldPositionTarget: wref<AIActionTarget_Record>;

  private let m_ownerPosition: Vector4;

  private let m_targetPosition: Vector4;

  private let m_direction: Vector4;

  private let m_fxPosition: Vector4;

  private let m_target: wref<GameObject>;

  private let m_owner: wref<GameObject>;

  private let m_fxInstance: ref<FxInstance>;

  private let m_targetAcquired: Bool;

  private let m_startTime: Float;

  private let m_shootPointPosition: Vector4;

  private let m_targetsPosition: [Vector4];

  protected func Activate(context: ScriptExecutionContext) -> Void {
    this.m_owner = ScriptExecutionContext.GetOwner(context) as NPCPuppet;
    this.m_startTime = EngineTime.ToFloat(GameInstance.GetTimeSystem(this.m_owner.GetGame()).GetSimTime());
    this.m_refOwner = TweakDBInterface.GetAIActionTargetRecord(t"AIActionTarget.Owner");
    this.m_refAIActionTarget = TweakDBInterface.GetAIActionTargetRecord(t"AIActionTarget.CombatTarget");
    this.m_refCustomWorldPositionTarget = TweakDBInterface.GetAIActionTargetRecord(t"AIActionTarget.CustomWorldPosition");
    if NotEquals(this.m_waypointTag, n"None") {
      GameInstance.FindWaypointsByTag(ScriptExecutionContext.GetOwner(context).GetGame(), this.m_waypointTag, this.m_targetsPosition);
      this.m_shootPointPosition = this.m_targetsPosition[0];
    };
  }

  private final static func ApplyTargetOffset(out targetPosition: Vector4, ownerPosition: Vector4, offset: Vector3, shootToTheGround: Bool) -> Void {
    let right: Vector4;
    let up: Vector4;
    let forward: Vector4 = targetPosition - ownerPosition;
    if shootToTheGround {
      targetPosition.Z = ownerPosition.Z;
      forward.Z = 0.00;
    };
    forward = Vector4.Normalize(forward);
    if Vector4.IsZero(forward) {
      return;
    };
    right = Vector4.Normalize(Vector4.Cross(forward, new Vector4(0.00, 0.00, 1.00, 0.00)));
    up = Vector4.Normalize(Vector4.Cross(right, forward));
    targetPosition -= right * offset.X;
    targetPosition -= forward * offset.Y;
    targetPosition -= up * offset.Z;
    targetPosition.W = 1.00;
  }

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let currentTime: Float;
    let trackedLocation: TrackedLocation;
    TargetTrackingExtension.GetTrackedLocation(context, this.m_owner, trackedLocation);
    if this.m_keepsAcquiring && this.m_lockTimer > 0.00 {
      currentTime = EngineTime.ToFloat(GameInstance.GetTimeSystem(this.m_owner.GetGame()).GetSimTime());
      if currentTime >= this.m_startTime + this.m_lockTimer {
        this.m_targetAcquired = true;
      };
    };
    if !this.m_targetAcquired {
      AIActionTarget.Get(context, this.m_refAIActionTarget, false, this.m_target, this.m_targetPosition);
      AIActionTarget.Get(context, this.m_refOwner, false, this.m_owner, this.m_ownerPosition);
      this.m_ownerPosition = this.m_owner.GetWorldPosition();
      this.m_targetPosition = this.m_target.GetWorldPosition();
      this.m_fxPosition = this.m_targetPosition;
      SetCustomShootPosition.ApplyTargetOffset(this.m_targetPosition, this.m_ownerPosition, this.m_offset, this.m_shootToTheGround);
      SetCustomShootPosition.ApplyTargetOffset(this.m_fxPosition, this.m_ownerPosition, this.m_fxOffset, this.m_shootToTheGround);
      this.m_targetPosition += trackedLocation.speed * this.m_predictionTime;
      this.m_fxPosition += trackedLocation.speed * this.m_predictionTime;
      if !this.m_keepsAcquiring {
        this.m_targetAcquired = true;
      };
    };
    if NotEquals(this.m_waypointTag, n"None") {
      AIActionTarget.Set(context, this.m_refCustomWorldPositionTarget, this.m_shootPointPosition);
    } else {
      AIActionTarget.Set(context, this.m_refCustomWorldPositionTarget, this.m_targetPosition);
    };
    if FxResource.IsValid(this.m_landIndicatorFX) {
      this.SpawnLandVFXs(context, this.m_landIndicatorFX, this.m_fxPosition);
    };
    return AIbehaviorUpdateOutcome.IN_PROGRESS;
  }

  private final func SpawnLandVFXs(context: ScriptExecutionContext, fx: FxResource, fxposition: Vector4) -> Void {
    let position: WorldPosition;
    let transform: WorldTransform;
    if FxResource.IsValid(fx) {
      WorldPosition.SetVector4(position, fxposition);
      WorldTransform.SetWorldPosition(transform, position);
      this.m_fxInstance = this.CreateFxInstance(context, fx, transform);
    };
  }

  private final func CreateFxInstance(context: ScriptExecutionContext, resource: FxResource, transform: WorldTransform) -> ref<FxInstance> {
    let fxSystem: ref<FxSystem> = GameInstance.GetFxSystem(AIBehaviorScriptBase.GetGame(context));
    let fx: ref<FxInstance> = fxSystem.SpawnEffect(resource, transform);
    return fx;
  }

  protected func Deactivate(context: ScriptExecutionContext) -> Void {
    this.m_targetAcquired = false;
    this.m_fxInstance.BreakLoop();
  }
}
