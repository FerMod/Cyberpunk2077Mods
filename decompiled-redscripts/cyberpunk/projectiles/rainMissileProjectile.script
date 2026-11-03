
public class RainMissileProjectile extends BaseProjectile {

  private let m_meshComponent: ref<IComponent>;

  private edit let m_effect: EffectRef;

  private let m_damage: ref<EffectInstance>;

  private let m_owner: wref<GameObject>;

  private let m_weapon: wref<WeaponObject>;

  @default(RainMissileProjectile, 0)
  private let m_countTime: Float;

  private edit let m_startVelocity: Float;

  private edit let m_lifetime: Float;

  @default(RainMissileProjectile, true)
  private let m_alive: Bool;

  @default(RainMissileProjectile, false)
  private let m_arrived: Bool;

  private let m_spawnPosition: Vector4;

  private let m_phase1Duration: Float;

  private edit let m_landIndicatorFX: FxResource;

  private let m_fxInstance: ref<FxInstance>;

  private let m_armingDistance: Float;

  private let m_armed: Bool;

  @default(RainMissileProjectile, false)
  private let m_hasExploded: Bool;

  private let m_missileDBID: TweakDBID;

  private let m_missileAttackRecord: wref<Attack_Record>;

  @default(RainMissileProjectile, -1.f)
  private let m_timeToDestory: Float;

  private let m_initialTargetPosition: Vector4;

  private let m_initialTargetOffset: Vector4;

  private let m_finalTargetPosition: Vector4;

  private let m_finalTargetOffset: Vector4;

  private let m_finalTargetPositionCalculationDelay: Float;

  private let m_targetComponent: wref<IPlacedComponent>;

  private let m_followTargetInPhase2: Bool;

  private let m_puppetBroadphaseHitRadiusSquared: Float;

  private let m_phase: EMissileRainPhase;

  private let m_spiralParams: ref<SpiralControllerParams>;

  private let m_useSpiralParams: Bool;

  private let m_randStartVelocity: Float;

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
    EntityRequestComponentsInterface.RequestComponent(ri, n"MeshComponent", n"IComponent", true);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_meshComponent = EntityResolveComponentsInterface.GetComponent(ri, n"MeshComponent");
    this.m_spiralParams = new SpiralControllerParams();
    this.m_spiralParams.rampUpDistanceStart = 0.40;
    this.m_spiralParams.rampUpDistanceEnd = 1.00;
    this.m_spiralParams.rampDownDistanceStart = 7.50;
    this.m_spiralParams.rampDownDistanceEnd = 5.00;
    this.m_spiralParams.rampDownFactor = 1.00;
    this.m_spiralParams.randomizePhase = true;
  }

  protected cb func OnProjectileInitialize(eventData: ref<gameprojectileSetUpEvent>) -> Bool {
    let missileDB: wref<Attack_Record>;
    let statsSystem: ref<StatsSystem>;
    let velVariance: Float;
    let weaponID: EntityID;
    super.OnProjectileInitialize(eventData);
    this.m_owner = eventData.owner;
    this.m_weapon = eventData.weapon as WeaponObject;
    if IsDefined(this.m_weapon) {
      statsSystem = GameInstance.GetStatsSystem(eventData.weapon.GetGame());
      weaponID = eventData.weapon.GetEntityID();
      this.m_useSpiralParams = statsSystem.GetStatValue(Cast<StatsObjectID>(weaponID), gamedataStatType.SmartGunAddSpiralTrajectory) > 0.00;
      this.m_spiralParams.radius = statsSystem.GetStatValue(Cast<StatsObjectID>(weaponID), gamedataStatType.SmartGunSpiralRadius);
      this.m_spiralParams.cycleTimeMin = statsSystem.GetStatValue(Cast<StatsObjectID>(weaponID), gamedataStatType.SmartGunSpiralCycleTimeMin);
      this.m_spiralParams.cycleTimeMax = statsSystem.GetStatValue(Cast<StatsObjectID>(weaponID), gamedataStatType.SmartGunSpiralCycleTimeMax);
      this.m_spiralParams.randomizeDirection = Cast<Bool>(statsSystem.GetStatValue(Cast<StatsObjectID>(weaponID), gamedataStatType.SmartGunSpiralRandomizeDirection));
      velVariance = statsSystem.GetStatValue(Cast<StatsObjectID>(weaponID), gamedataStatType.SmartGunProjectileVelocityVariance);
      this.m_randStartVelocity = RandRangeF(this.m_startVelocity - this.m_startVelocity * velVariance, this.m_startVelocity + this.m_startVelocity * velVariance);
    } else {
      this.m_spiralParams.enabled = false;
      this.m_spiralParams.radius = 0.01;
      this.m_spiralParams.cycleTimeMin = 0.10;
      this.m_spiralParams.cycleTimeMax = 0.10;
      this.m_randStartVelocity = this.m_startVelocity;
      this.m_useSpiralParams = false;
    };
    missileDB = this.m_weapon.GetAttack(n"RainMissile").GetRecord();
    if TDBID.IsValid(missileDB.GetID()) {
      this.m_missileDBID = missileDB.GetID();
      this.m_missileAttackRecord = missileDB;
    };
    this.m_meshComponent.Toggle(false);
    this.m_timeToDestory = -1.00;
    this.m_hasExploded = false;
    this.m_alive = true;
    this.m_phase = EMissileRainPhase.Init;
    this.m_countTime = 0.00;
    this.m_initialTargetPosition = Vector4.EmptyVector();
    this.m_initialTargetOffset = Vector4.EmptyVector();
    this.m_finalTargetPositionCalculationDelay = 0.00;
    this.m_finalTargetPosition = Vector4.EmptyVector();
    this.m_finalTargetOffset = Vector4.EmptyVector();
    this.m_followTargetInPhase2 = false;
    this.m_arrived = false;
    this.m_armingDistance = AITweakParams.GetFloatFromTweak(this.m_missileDBID, "armingDistance");
    this.m_armed = this.m_armingDistance <= 0.00;
    this.m_puppetBroadphaseHitRadiusSquared = AITweakParams.GetFloatFromTweak(this.m_missileDBID, "puppetBroadphaseHitRadiusSquared");
  }

  private final func StartTrailEffect() -> Void {
    GameObjectEffectHelper.StartEffectEvent(this, n"trail", true);
  }

  private final func StartTrailStartEffect() -> Void {
    GameObjectEffectHelper.StartEffectEvent(this, n"trail_start", true);
  }

  protected cb func OnShoot(eventData: ref<gameprojectileShootEvent>) -> Bool {
    let linearParams: ref<LinearTrajectoryParams>;
    this.m_spawnPosition = eventData.startPoint;
    if this.m_owner.IsPlayer() {
      linearParams = new LinearTrajectoryParams();
      linearParams.startVel = this.m_startVelocity;
      this.m_projectileComponent.SetOnCollisionAction(gameprojectileOnCollisionAction.Stop);
      this.m_projectileComponent.AddLinear(linearParams);
      this.m_projectileComponent.LockOrientation(false);
      this.StartTrailEffect();
    } else {
      this.DelayDestroyBullet();
    };
  }

  protected cb func OnHit(evt: ref<gameHitEvent>) -> Bool {
    this.Explode(evt.hitPosition);
    this.DelayDestroyBullet();
  }

  protected cb func OnShootTarget(eventData: ref<gameprojectileShootTargetEvent>) -> Bool {
    if !IsDefined(this.m_weapon) {
      this.DelayDestroyBullet();
    };
    this.m_targetComponent = eventData.params.trackedTargetComponent;
    this.m_initialTargetPosition = eventData.params.targetPosition;
    this.m_initialTargetOffset = eventData.params.hitPlaneOffset;
    this.m_spawnPosition = eventData.startPoint;
    this.m_followTargetInPhase2 = AITweakParams.GetBoolFromTweak(this.m_missileDBID, "followTargetInPhase2");
    this.m_finalTargetPositionCalculationDelay = AITweakParams.GetFloatFromTweak(this.m_missileDBID, "finalTargetPositionCalculationDelay");
    if this.m_finalTargetPositionCalculationDelay == 0.00 {
      this.CalcFinalTargetPositionAndOffset();
    };
    this.StartPhase1(eventData.startPoint);
  }

  protected cb func OnAcceleratedMovement(eventData: ref<gameprojectileAcceleratedMovementEvent>) -> Bool;

  protected cb func OnLinearMovement(eventData: ref<gameprojectileLinearMovementEvent>) -> Bool {
    let distance: Vector4 = Matrix.GetTranslation(this.m_projectileComponent.GetLocalToWorld()) - eventData.targetPosition;
    GameObject.SetAudioParameter(this, n"RTPC_Height_Difference", distance.Z);
    GameObject.PlaySoundEvent(this, n"Smart_21301_bullet_trail_whistle");
  }

  protected cb func OnTick(eventData: ref<gameprojectileTickEvent>) -> Bool {
    let distanceTravelled: Float;
    this.m_countTime += eventData.deltaTime;
    if !this.m_armed && NotEquals(this.m_phase, EMissileRainPhase.Init) {
      distanceTravelled = Vector4.Distance(this.m_spawnPosition, eventData.position);
      if distanceTravelled > this.m_armingDistance {
        this.m_armed = true;
      };
    };
    if Equals(this.m_phase, EMissileRainPhase.Phase1) {
      if this.m_finalTargetPositionCalculationDelay > 0.00 && this.m_countTime >= this.m_finalTargetPositionCalculationDelay {
        this.CalcFinalTargetPositionAndOffset();
      };
      if this.m_countTime >= this.m_phase1Duration {
        this.StartPhase2();
      };
    };
    if this.m_countTime >= this.m_lifetime {
      this.DestroyBullet();
    };
    if this.m_timeToDestory > 0.00 {
      this.m_timeToDestory -= eventData.deltaTime;
      if this.m_timeToDestory <= 0.00 {
        this.DestroyBullet();
      };
    };
    if this.m_arrived {
      if Equals(this.m_phase, EMissileRainPhase.Phase2) {
        this.Explode(Matrix.GetTranslation(this.m_projectileComponent.GetLocalToWorld()));
        this.DelayDestroyBullet();
      };
      this.m_arrived = false;
    };
  }

  protected cb func OnCollision(eventData: ref<gameprojectileHitEvent>) -> Bool {
    super.OnCollision(eventData);
    this.OnCollideWithEntity(eventData.hitInstances[0].projectilePosition);
  }

  protected cb func OnGameprojectileBroadPhaseHitEvent(eventData: ref<gameprojectileBroadPhaseHitEvent>) -> Bool {
    let owner: wref<GameObject>;
    let hitObject: ref<Entity> = eventData.hitObject;
    let hitPosition: Vector4 = eventData.position;
    if this.m_puppetBroadphaseHitRadiusSquared >= 0.00 && IsDefined(hitObject as ScriptedPuppet) {
      if Vector4.DistanceSquared(hitPosition, hitObject.GetWorldPosition()) > this.m_puppetBroadphaseHitRadiusSquared {
        return false;
      };
    };
    owner = this.m_weapon.GetOwner();
    if IsDefined(owner) && owner == hitObject && !this.m_armed {
      return false;
    };
    this.OnCollideWithEntity(hitPosition);
  }

  private final func OnCollideWithEntity(projectilePosition: Vector4) -> Void {
    this.Explode(projectilePosition);
    this.DelayDestroyBullet();
  }

  protected final func DelayDestroyBullet() -> Void {
    if this.m_timeToDestory < 0.00 {
      this.m_timeToDestory = 0.20;
    };
  }

  private final func DestroyBullet() -> Void {
    if this.m_alive {
      this.m_fxInstance.BreakLoop();
      this.m_alive = false;
      this.m_meshComponent.Toggle(false);
      this.m_projectileComponent.ClearTrajectories();
      this.m_hasExploded = true;
      this.Release();
    };
  }

  private final func Explode(projectilePosition: Vector4) -> Void {
    let aoeData: ProjectileHitAoEData;
    let broadCaster: ref<StimBroadcasterComponent>;
    let explosionAttackRecord: ref<Attack_Record>;
    let investigateData: stimInvestigateData;
    let explodeDuration: Float = 0.20;
    if !this.m_armed {
      this.m_meshComponent.Toggle(false);
      this.DelayDestroyBullet();
      return;
    };
    if !this.m_hasExploded {
      this.m_hasExploded = true;
      this.m_meshComponent.Toggle(false);
      explosionAttackRecord = IAttack.GetExplosiveHitAttack(this.m_missileAttackRecord);
      if IsDefined(explosionAttackRecord) {
        aoeData.source = this.m_user;
        aoeData.instigator = this.m_user;
        aoeData.position = projectilePosition;
        aoeData.radius = AITweakParams.GetFloatFromTweak(this.m_missileDBID, "explosionRadius");
        aoeData.duration = explodeDuration;
        aoeData.attackRecord = explosionAttackRecord;
        aoeData.weapon = this.m_weapon;
        aoeData.enableImpulseFalloff = true;
        ProjectileGameEffectHelper.FillProjectileHitAoEData(aoeData);
        broadCaster = this.GetStimBroadcasterComponent();
        if IsDefined(broadCaster) {
          investigateData.attackInstigator = this.m_user;
          investigateData.attackInstigatorPosition = this.m_user.GetWorldPosition();
          investigateData.revealsInstigatorPosition = true;
          broadCaster.TriggerSingleBroadcast(this, gamedataStimType.Explosion, aoeData.radius + 5.00, investigateData);
        };
        GameInstance.GetAudioSystem(this.GetGame()).PlayShockwave(n"explosion", projectilePosition);
      };
    };
  }

  protected cb func OnFollowSuccess(eventData: ref<gameprojectileFollowEvent>) -> Bool {
    this.m_arrived = true;
  }

  protected final func StartPhase1(targetPos: Vector4) -> Void {
    let forwardOffset: Vector4;
    let lateralOffset: Vector4;
    let orientation: Quaternion;
    let targetDirection: Vector4;
    let followCurveParams: ref<FollowCurveTrajectoryParams> = new FollowCurveTrajectoryParams();
    if NotEquals(EMissileRainPhase.Phase1, this.m_phase) {
      this.m_phase = EMissileRainPhase.Phase1;
      this.m_phase1Duration = RandRangeF(AITweakParams.GetFloatFromTweak(this.m_missileDBID, "p1DurationMin"), AITweakParams.GetFloatFromTweak(this.m_missileDBID, "p1DurationMax"));
      this.m_meshComponent.Toggle(true);
      targetDirection = this.m_initialTargetPosition - this.m_spawnPosition;
      targetDirection.Z = 0.00;
      orientation = Quaternion.BuildFromDirectionVector(targetDirection);
      forwardOffset.Y = RandRangeF(AITweakParams.GetFloatFromTweak(this.m_missileDBID, "p1PositionForwardOffsetMin"), AITweakParams.GetFloatFromTweak(this.m_missileDBID, "p1PositionForwardOffsetMax"));
      forwardOffset = Quaternion.Transform(orientation, forwardOffset);
      forwardOffset.Z = 0.00;
      lateralOffset.X = RandRangeF(-AITweakParams.GetFloatFromTweak(this.m_missileDBID, "p1PositionLateralOffset"), AITweakParams.GetFloatFromTweak(this.m_missileDBID, "p1PositionLateralOffset"));
      lateralOffset = Quaternion.Transform(orientation, lateralOffset);
      lateralOffset.Z = 0.00;
      targetPos += forwardOffset + lateralOffset;
      targetPos.Z += AITweakParams.GetFloatFromTweak(this.m_missileDBID, "p1PositionZOffset");
      this.m_projectileComponent.ClearTrajectories();
      followCurveParams.startVelocity = AITweakParams.GetFloatFromTweak(this.m_missileDBID, "p1StartVelocity");
      followCurveParams.targetPosition = targetPos;
      followCurveParams.bendTimeRatio = AITweakParams.GetFloatFromTweak(this.m_missileDBID, "p1BendTimeRatio");
      followCurveParams.bendFactor = AITweakParams.GetFloatFromTweak(this.m_missileDBID, "p1BendFactor");
      followCurveParams.angleInHitPlane = RandRangeF(AITweakParams.GetFloatFromTweak(this.m_missileDBID, "p1AngleInHitPlaneMin"), AITweakParams.GetFloatFromTweak(this.m_missileDBID, "p1AngleInHitPlaneMax"));
      followCurveParams.angleInVerticalPlane = RandRangeF(-AITweakParams.GetFloatFromTweak(this.m_missileDBID, "p1AngleInVerticalPlane"), AITweakParams.GetFloatFromTweak(this.m_missileDBID, "p1AngleInVerticalPlane"));
      followCurveParams.snapRadius = AITweakParams.GetFloatFromTweak(this.m_missileDBID, "p1SnapRadius");
      followCurveParams.sendFollowEvent = false;
      followCurveParams.startVelocityDirectionCheck = AITweakParams.GetBoolFromTweak(this.m_missileDBID, "startVelocityDirectionCheck", followCurveParams.startVelocityDirectionCheck);
      this.m_projectileComponent.AddFollowCurve(followCurveParams);
      this.m_projectileComponent.SetOnCollisionAction(gameprojectileOnCollisionAction.Stop);
      this.m_spiralParams.enabled = this.m_useSpiralParams;
      this.m_projectileComponent.SetSpiral(this.m_spiralParams);
      this.StartTrailStartEffect();
    };
  }

  protected final func StartPhase2() -> Void {
    let inheritCarSpeed: Bool;
    let p2HardCurve: Bool;
    let vehicleOwner: ref<VehicleObject>;
    let followCurveParams: ref<FollowCurveTrajectoryParams> = new FollowCurveTrajectoryParams();
    this.m_phase = EMissileRainPhase.Phase2;
    if this.m_followTargetInPhase2 && IsDefined(this.m_targetComponent) {
      this.CalcFinalTargetPositionAndOffset();
      followCurveParams.target = this.m_targetComponent.GetEntity() as GameObject;
    } else {
      if this.m_countTime < this.m_finalTargetPositionCalculationDelay || this.m_finalTargetPositionCalculationDelay < 0.00 {
        this.CalcFinalTargetPositionAndOffset();
      };
    };
    this.m_projectileComponent.ClearTrajectories();
    followCurveParams.startVelocity = AITweakParams.GetFloatFromTweak(this.m_missileDBID, "p2StartVelocity");
    inheritCarSpeed = AITweakParams.GetBoolFromTweak(this.m_missileDBID, "inheritVehicleSpeed");
    if inheritCarSpeed && IsDefined(this.m_weapon) {
      vehicleOwner = this.m_weapon.GetOwner() as VehicleObject;
      if IsDefined(vehicleOwner) {
        followCurveParams.startVelocity += vehicleOwner.GetCurrentSpeed();
      };
    };
    followCurveParams.targetPosition = this.m_finalTargetPosition;
    followCurveParams.bendTimeRatio = AITweakParams.GetFloatFromTweak(this.m_missileDBID, "p2BendRation");
    followCurveParams.bendFactor = AITweakParams.GetFloatFromTweak(this.m_missileDBID, "p2BendFactor");
    followCurveParams.angleInHitPlane = RandRangeF(AITweakParams.GetFloatFromTweak(this.m_missileDBID, "p2AngleInHitPlaneMin"), AITweakParams.GetFloatFromTweak(this.m_missileDBID, "p2AngleInHitPlaneMax"));
    followCurveParams.angleInVerticalPlane = RandRangeF(-AITweakParams.GetFloatFromTweak(this.m_missileDBID, "p2AngleInVerticalPlane"), AITweakParams.GetFloatFromTweak(this.m_missileDBID, "p2AngleInVerticalPlane"));
    followCurveParams.shouldRotate = AITweakParams.GetBoolFromTweak(this.m_missileDBID, "p2ShouldRotate");
    followCurveParams.accuracy = 1.00;
    followCurveParams.offset = this.m_finalTargetOffset;
    p2HardCurve = AITweakParams.GetBoolFromTweak(this.m_missileDBID, "p2HardCurve");
    if p2HardCurve {
      followCurveParams.interpolationTimeRatio = AITweakParams.GetFloatFromTweak(this.m_missileDBID, "p2HardCurveInterpolationTimeRatio");
      if followCurveParams.interpolationTimeRatio <= 0.00 {
        followCurveParams.interpolationTimeRatio = 0.05;
      };
      followCurveParams.linearTimeRatio = 0.10;
    };
    followCurveParams.startVelocityDirectionCheck = AITweakParams.GetBoolFromTweak(this.m_missileDBID, "startVelocityDirectionCheck", followCurveParams.startVelocityDirectionCheck);
    this.m_projectileComponent.AddFollowCurve(followCurveParams);
    this.m_spiralParams.enabled = this.m_useSpiralParams;
    this.m_projectileComponent.SetSpiral(this.m_spiralParams);
    this.StartTrailEffect();
  }

  private final func CalcFinalTargetPositionAndOffset() -> Void {
    let directionOffset: Vector4;
    let offset: Float;
    let useTargetOffset: Bool = false;
    this.m_finalTargetOffset = this.m_initialTargetOffset;
    if IsDefined(this.m_targetComponent) {
      this.m_finalTargetPosition = this.m_targetComponent.GetEntity().GetWorldPosition();
      this.m_finalTargetOffset.Z = 0.00;
    } else {
      this.m_finalTargetPosition = this.m_initialTargetPosition;
    };
    useTargetOffset = this.m_targetComponent.IsA(n"gameTargetingComponent") || AITweakParams.GetBoolFromTweak(this.m_missileDBID, "usetargetOffsetWhenUntargeted");
    if useTargetOffset {
      offset = AITweakParams.GetFloatFromTweak(this.m_missileDBID, "targetPositionOffset");
      if offset > 0.00 {
        directionOffset = this.m_spawnPosition - this.m_finalTargetPosition;
        directionOffset = Vector4.Normalize(directionOffset) * offset;
        this.m_finalTargetOffset.X += directionOffset.X;
        this.m_finalTargetOffset.Y += directionOffset.Y;
        this.m_finalTargetOffset.X += RandRangeF(-AITweakParams.GetFloatFromTweak(this.m_missileDBID, "targetPositionXYAdditive"), AITweakParams.GetFloatFromTweak(this.m_missileDBID, "targetPositionXYAdditive"));
        this.m_finalTargetOffset.Y += RandRangeF(-AITweakParams.GetFloatFromTweak(this.m_missileDBID, "targetPositionXYAdditive"), AITweakParams.GetFloatFromTweak(this.m_missileDBID, "targetPositionXYAdditive"));
      };
    };
    if !this.m_followTargetInPhase2 || !IsDefined(this.m_targetComponent) {
      this.m_fxInstance = this.SpawnLandVFXs(this.m_landIndicatorFX, this.m_finalTargetPosition + this.m_finalTargetOffset);
    };
  }
}
