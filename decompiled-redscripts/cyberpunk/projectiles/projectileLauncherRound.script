
public class ProjectileLauncherRoundCollisionEvaluator extends gameprojectileScriptCollisionEvaluator {

  private let m_collisionAction: gamedataProjectileOnCollisionAction;

  @default(ProjectileLauncherRoundCollisionEvaluator, false)
  private let m_projectileStopped: Bool;

  @default(ProjectileLauncherRoundCollisionEvaluator, 0)
  private let m_maxBounceCount: Int32;

  @default(ProjectileLauncherRoundCollisionEvaluator, false)
  private let m_projectileBounced: Bool;

  @default(ProjectileLauncherRoundCollisionEvaluator, false)
  private let m_projectileStopAndStick: Bool;

  @default(ProjectileLauncherRoundCollisionEvaluator, false)
  private let m_projectilePierced: Bool;

  public final func SetCollisionAction(collisionAction: gamedataProjectileOnCollisionAction) -> Void {
    this.m_collisionAction = collisionAction;
  }

  public final func SetNumberOfBounces(maxBounceCount: Int32) -> Void {
    this.m_maxBounceCount = maxBounceCount;
  }

  public final func ProjectileStopped() -> Bool {
    return this.m_projectileStopped;
  }

  public final func ProjectileStopAndStick() -> Bool {
    return this.m_projectileStopAndStick;
  }

  public final func ProjectileBounced() -> Bool {
    return this.m_projectileBounced;
  }

  public final func ProjectilePierced() -> Bool {
    return this.m_projectilePierced;
  }

  protected func EvaluateCollision(defaultOnCollisionAction: gameprojectileOnCollisionAction, params: ref<CollisionEvaluatorParams>) -> gameprojectileOnCollisionAction {
    let validBounces: Bool = false;
    if params.isWaterSurface {
      return gameprojectileOnCollisionAction.Stop;
    };
    validBounces = params.numBounces < Cast<Uint32>(this.m_maxBounceCount);
    if Equals(this.m_collisionAction, gamedataProjectileOnCollisionAction.Stop) || !validBounces && Equals(this.m_collisionAction, gamedataProjectileOnCollisionAction.Bounce) {
      this.m_projectileStopped = true;
      return gameprojectileOnCollisionAction.Stop;
    };
    if Equals(this.m_collisionAction, gamedataProjectileOnCollisionAction.Bounce) {
      this.m_projectileBounced = true;
      return gameprojectileOnCollisionAction.Bounce;
    };
    if Equals(this.m_collisionAction, gamedataProjectileOnCollisionAction.Pierce) {
      this.m_projectilePierced = true;
      return gameprojectileOnCollisionAction.Pierce;
    };
    if Equals(this.m_collisionAction, gamedataProjectileOnCollisionAction.StopAndStick) {
      this.m_projectileStopAndStick = true;
      return gameprojectileOnCollisionAction.StopAndStick;
    };
    if Equals(this.m_collisionAction, gamedataProjectileOnCollisionAction.StopAndStickPerpendicular) {
      this.m_projectileStopAndStick = true;
      return gameprojectileOnCollisionAction.StopAndStickPerpendicular;
    };
    return gameprojectileOnCollisionAction.None;
  }
}

public class ProjectileLauncherRound extends ItemObject {

  protected let m_projectileComponent: ref<ProjectileComponent>;

  protected let m_resourceLibraryComponent: ref<ResourceLibraryComponent>;

  protected let m_user: wref<GameObject>;

  protected let m_projectile: wref<GameObject>;

  protected let m_weapon: wref<WeaponObject>;

  protected let m_projectileSpawnPoint: Vector4;

  protected let m_launchMode: gamedataProjectileLaunchMode;

  protected let m_initialLaunchVelocity: Float;

  protected let m_installedProjectile: ItemID;

  protected let m_actionType: ELauncherActionType;

  protected let m_attackRecord: ref<Attack_Record>;

  protected let m_releaseRequestDelayID: DelayID;

  protected let m_detonateRequestDelayID: DelayID;

  protected let m_projectileTrailName: CName;

  protected let m_projectileCollisionEvaluator: ref<ProjectileLauncherRoundCollisionEvaluator>;

  protected let m_isAlive: Bool;

  protected let m_isSinking: Bool;

  protected let m_waterHeight: Float;

  protected let m_deepWaterDepth: Float;

  protected let m_sinkingDetonationDelay: Float;

  protected let m_waterSurfaceImpactImpulseRadius: Float;

  protected let m_waterSurfaceImpactImpulseStrength: Float;

  protected let m_waterDetonationImpulseRadius: Float;

  protected let m_waterDetonationImpulseStrength: Float;

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    EntityRequestComponentsInterface.RequestComponent(ri, n"projectileComponent", n"ProjectileComponent", true);
    EntityRequestComponentsInterface.RequestComponent(ri, n"StimBroadcaster", n"StimBroadcasterComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"MeshComponent", n"IComponent", true);
    EntityRequestComponentsInterface.RequestComponent(ri, n"ResourceLibrary", n"ResourceLibraryComponent", true);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    this.m_projectileComponent = EntityResolveComponentsInterface.GetComponent(ri, n"projectileComponent") as ProjectileComponent;
    this.m_resourceLibraryComponent = EntityResolveComponentsInterface.GetComponent(ri, n"ResourceLibrary") as ResourceLibraryComponent;
  }

  protected cb func OnProjectileInitialize(eventData: ref<gameprojectileSetUpEvent>) -> Bool {
    let broadcaster: ref<StimBroadcasterComponent>;
    let invalidDelayID: DelayID;
    this.m_user = eventData.owner;
    this.m_projectile = eventData.weapon;
    this.m_weapon = this.m_projectile as WeaponObject;
    this.SetCurrentlyInstalledRound();
    this.SetProjectileLauncherAction();
    this.SetCollisionAction();
    this.m_isAlive = true;
    this.m_isSinking = false;
    this.m_waterHeight = 0.00;
    this.m_deepWaterDepth = this.GetFloat("deepWaterDepth");
    this.m_sinkingDetonationDelay = this.GetFloat("sinkingDetonationDelay");
    this.m_waterSurfaceImpactImpulseRadius = this.GetFloat("waterSurfaceImpactImpulseRadius");
    this.m_waterSurfaceImpactImpulseStrength = this.GetFloat("waterSurfaceImpactImpulseStrength");
    this.m_waterDetonationImpulseRadius = this.GetFloat("waterDetonationImpulseRadius");
    this.m_waterDetonationImpulseStrength = this.GetFloat("waterDetonationImpulseStrength");
    invalidDelayID = GetInvalidDelayID();
    if this.m_releaseRequestDelayID != invalidDelayID {
      GameInstance.GetDelaySystem(this.GetGame()).CancelDelay(this.m_releaseRequestDelayID);
      this.m_releaseRequestDelayID = invalidDelayID;
    };
    if this.m_detonateRequestDelayID != invalidDelayID {
      GameInstance.GetDelaySystem(this.GetGame()).CancelDelay(this.m_detonateRequestDelayID);
      this.m_detonateRequestDelayID = invalidDelayID;
    };
    broadcaster = eventData.owner.GetStimBroadcasterComponent();
    if IsDefined(broadcaster) {
      broadcaster.TriggerSingleBroadcast(this, gamedataStimType.WeaponDisplayed);
    };
  }

  protected final func SetCollisionAction() -> Void {
    let collisionAction: CName;
    this.m_projectileCollisionEvaluator = new ProjectileLauncherRoundCollisionEvaluator();
    this.m_projectileComponent.SetCollisionEvaluator(this.m_projectileCollisionEvaluator);
    this.m_projectileComponent.SetEnergyLossFactor(this.GetFloat("energyLossFactor"), this.GetFloat("energyLossFactor"));
    if Equals(this.m_actionType, ELauncherActionType.QuickAction) {
      collisionAction = this.GetCName("collisionAction");
    } else {
      collisionAction = this.GetCName("collisionActionCharged");
    };
    this.m_projectileCollisionEvaluator.SetCollisionAction(this.CollisionActionNameToEnum(collisionAction));
    this.m_projectileCollisionEvaluator.SetNumberOfBounces(this.GetInt("maxBounceCount"));
  }

  protected final func SetCurrentlyInstalledRound() -> Bool {
    let i: Int32;
    let partSlots: SPartSlots;
    let projectileLauncherRound: array<SPartSlots> = ItemModificationSystem.GetAllSlots(this.m_user, this.m_weapon.GetItemID());
    if ArraySize(projectileLauncherRound) == 0 {
      return false;
    };
    i = 0;
    while i < ArraySize(projectileLauncherRound) {
      partSlots = projectileLauncherRound[i];
      if Equals(partSlots.status, ESlotState.Taken) && partSlots.slotID == t"AttachmentSlots.ProjectileLauncherRound" {
        this.m_installedProjectile = partSlots.installedPart;
      };
      i += 1;
    };
    return false;
  }

  protected cb func OnShoot(eventData: ref<gameprojectileShootEvent>) -> Bool {
    this.GeneralLaunchSetup(eventData);
    this.LinearLaunch(eventData, this.m_initialLaunchVelocity);
  }

  protected cb func OnShootTarget(eventData: ref<gameprojectileShootTargetEvent>) -> Bool {
    let targetComponent: ref<IPlacedComponent>;
    let targetEntity: wref<Entity>;
    let isFriendlyNPC: Bool = false;
    this.GeneralLaunchSetup(eventData);
    targetComponent = eventData.params.trackedTargetComponent;
    targetEntity = targetComponent.GetEntity();
    isFriendlyNPC = PlayerPuppet.IsTargetFriendlyNPC(this.m_user as PlayerPuppet, targetEntity);
    if Equals(this.m_launchMode, gamedataProjectileLaunchMode.Tracking) && IsDefined(targetComponent) && !isFriendlyNPC {
      this.CurvedLaunchToTarget(eventData, targetComponent);
    } else {
      this.LinearLaunch(eventData, this.m_initialLaunchVelocity);
    };
  }

  protected final func GeneralLaunchSetup(eventData: ref<gameprojectileShootEvent>) -> Void {
    let broadcaster: ref<StimBroadcasterComponent>;
    this.m_projectileSpawnPoint = eventData.startPoint;
    this.SetProjectileLifetime();
    this.SetLaunchModeBasedOnAction();
    this.SetAttackRecordBasedOnAction();
    this.SetLaunchVelocityBasedOnAction();
    this.SetProjectileTrailEffect();
    broadcaster = this.m_user.GetStimBroadcasterComponent();
    if IsDefined(broadcaster) {
      broadcaster.TriggerSingleBroadcast(this, gamedataStimType.IllegalAction);
    };
    this.m_projectileComponent.SetCollisionCooldown(1.00);
  }

  protected final const func WeaponIsCharged() -> Bool {
    let weaponObject: wref<WeaponObject> = GameInstance.GetTransactionSystem(this.m_user.GetGame()).GetItemInSlot(this.m_user, t"AttachmentSlots.WeaponLeft") as WeaponObject;
    return weaponObject.IsCharged();
  }

  protected final func CurvedLaunchToTarget(eventData: ref<gameprojectileShootEvent>, opt targetObject: wref<GameObject>, opt targetComponent: ref<IPlacedComponent>) -> Void {
    let linearTimeRatio: Float = this.GetFloat("linearTimeRatio");
    let interpolationTimeRatio: Float = this.GetFloat("interpolationTimeRatio");
    let returnTimeMargin: Float = this.GetFloat("returnTimeMargin");
    let bendTimeRatio: Float = this.GetFloat("bendTimeRatio");
    let bendFactor: Float = this.GetFloat("bendFactor");
    let halfLeanAngle: Float = this.GetFloat("halfLeanAngle");
    let endLeanAngle: Float = this.GetFloat("endLeanAngle");
    let angleInterpolationDuration: Float = this.GetFloat("angleInterpolationDuration");
    this.CurvedLaunch(eventData, targetObject, targetComponent, this.m_initialLaunchVelocity, linearTimeRatio, interpolationTimeRatio, returnTimeMargin, bendTimeRatio, bendFactor, halfLeanAngle, endLeanAngle, angleInterpolationDuration);
  }

  protected final func GetFloat(const param: script_ref<String>) -> Float {
    return TDB.GetFloat(ItemID.GetTDBID(this.m_installedProjectile) + t"." + TDBID.Create(Deref(param)));
  }

  protected final func GetInt(const param: script_ref<String>) -> Int32 {
    return TDB.GetInt(ItemID.GetTDBID(this.m_installedProjectile) + t"." + TDBID.Create(Deref(param)));
  }

  protected final func GetBool(const param: script_ref<String>) -> Bool {
    return TDB.GetBool(ItemID.GetTDBID(this.m_installedProjectile) + t"." + TDBID.Create(Deref(param)));
  }

  protected final func GetCName(const param: script_ref<String>) -> CName {
    return TDB.GetCName(ItemID.GetTDBID(this.m_installedProjectile) + t"." + TDBID.Create(Deref(param)));
  }

  protected final func GetString(const param: script_ref<String>) -> String {
    return TDB.GetString(ItemID.GetTDBID(this.m_installedProjectile) + t"." + TDBID.Create(Deref(param)));
  }

  protected final func GetVector3(const param: script_ref<String>) -> Vector3 {
    return TDB.GetVector3(ItemID.GetTDBID(this.m_installedProjectile) + t"." + TDBID.Create(Deref(param)));
  }

  protected cb func OnCollision(eventData: ref<gameprojectileHitEvent>) -> Bool {
    let chargeAction: Bool;
    let effect: FxResource;
    let effectTransform: WorldTransform;
    let hitInstance: gameprojectileHitInstance;
    let i: Int32;
    let parabolicTrajectoryParams: ref<ParabolicTrajectoryParams>;
    let targetEntityID: EntityID;
    if !this.m_isAlive {
      return false;
    };
    i = 0;
    while i < ArraySize(eventData.hitInstances) {
      hitInstance = eventData.hitInstances[i];
      if hitInstance.isWaterSurfaceImpact {
        if !this.m_isSinking {
          effect = this.m_resourceLibraryComponent.GetResource(n"splash_effect");
          if FxResource.IsValid(effect) {
            WorldTransform.SetPosition(effectTransform, hitInstance.position);
            GameInstance.GetFxSystem(this.GetGame()).SpawnEffect(effect, effectTransform);
          };
          GameObject.PlaySound(this, n"w_bul_hit_water");
          RenderingSystem.AddWaterImpulse(hitInstance.position, this.m_waterSurfaceImpactImpulseRadius, this.m_waterSurfaceImpactImpulseStrength);
          this.m_isSinking = true;
          this.m_waterHeight = hitInstance.position.Z;
          parabolicTrajectoryParams = ParabolicTrajectoryParams.GetAccelVelParabolicParams(new Vector4(0.00, 0.00, -0.40, 0.00), 0.60, 0.55);
          this.m_projectileComponent.ClearTrajectories();
          this.m_projectileComponent.SetEnergyLossFactor(0.05, 0.05);
          this.m_projectileComponent.AddParabolic(parabolicTrajectoryParams);
          this.CreateDetonationDelayEvent(this.m_sinkingDetonationDelay);
        };
      } else {
        if this.m_isSinking {
          GameInstance.GetDelaySystem(this.GetGame()).CancelDelay(this.m_detonateRequestDelayID);
          this.m_detonateRequestDelayID = GetInvalidDelayID();
          this.ExecuteGameEffect(hitInstance.projectilePosition);
          this.StopProjectile();
          this.Release();
        } else {
          if this.m_projectileCollisionEvaluator.ProjectileStopped() {
            this.StopProjectile();
            this.Release();
          };
          if this.m_projectileCollisionEvaluator.ProjectileStopAndStick() {
            this.StopProjectile();
            this.SetProjectileDetonationTime();
            GameObjectEffectHelper.StartEffectEvent(this, n"detonation_warning", true);
          };
          if !this.m_projectileCollisionEvaluator.ProjectileStopAndStick() {
            this.ExecuteGameEffect(hitInstance.projectilePosition);
            chargeAction = ProjectileHelper.GetPSMBlackboardIntVariable(this.m_user, GetAllBlackboardDefs().PlayerStateMachine.LeftHandCyberware) == 9;
            targetEntityID = hitInstance.hitObject.GetEntityID();
            if chargeAction && EntityID.IsDefined(targetEntityID) && NotEquals(this.m_user.GetAttitudeTowards(this.GetObject(hitInstance)), EAIAttitude.AIA_Friendly) {
              GameInstance.GetStatusEffectSystem(this.GetGame()).ApplyStatusEffect(targetEntityID, t"BaseStatusEffect.Knockdown");
            };
          };
        };
        this.EvaluateStimBroadcasting(this.CollisionStimTypeNameToEnum(this.GetCName("onCollisionStimType")));
        break;
      };
      i += 1;
    };
  }

  protected final func ExecuteGameEffect(projectilePosition: Vector4) -> Void {
    let aoeData: ProjectileHitAoEData;
    let effect: FxResource;
    let effectPosition: Vector4;
    let effectTransform: WorldTransform;
    let radius: Float;
    let isDeepUnderwater: Bool = false;
    let disableAoEAttackVfx: Bool = false;
    if this.m_isSinking {
      isDeepUnderwater = projectilePosition.Z - this.m_waterHeight <= this.m_deepWaterDepth;
      effect = this.m_resourceLibraryComponent.GetResource(isDeepUnderwater ? n"underwater_explosion_deep" : n"underwater_explosion_shallow");
      if FxResource.IsValid(effect) {
        effectPosition = projectilePosition;
        effectPosition.Z = this.m_waterHeight;
        WorldTransform.SetPosition(effectTransform, effectPosition);
        GameInstance.GetFxSystem(this.GetGame()).SpawnEffect(effect, effectTransform);
      };
      this.AddWaterImpulsesOnDetonation(effectPosition, 4);
      disableAoEAttackVfx = isDeepUnderwater;
    };
    if Equals(this.m_attackRecord.AttackType().Type(), gamedataAttackType.Explosion) {
      radius = this.m_attackRecord.Range();
      if PlayerDevelopmentSystem.GetData(this.m_user).IsNewPerkBought(gamedataNewPerkType.Tech_Left_Milestone_3) >= 2 && PlayerDevelopmentSystem.GetData(this.m_user).IsNewPerkBought(gamedataNewPerkType.Tech_Inbetween_Left_3) == 1 {
        radius *= 1.10;
      };
      aoeData.source = this;
      aoeData.instigator = this.m_user;
      aoeData.position = projectilePosition;
      aoeData.radius = radius;
      aoeData.duration = 0.00;
      aoeData.attackRecord = this.m_attackRecord;
      aoeData.disableVfx = disableAoEAttackVfx;
      ProjectileGameEffectHelper.FillProjectileHitAoEData(aoeData);
    };
    GameObjectEffectHelper.StopEffectEvent(this, n"detonation_warning");
  }

  protected final func AddWaterImpulsesOnDetonation(position: Vector4, numImpulses: Int32) -> Void {
    let i: Int32;
    let impulseRadius: Float = this.m_waterDetonationImpulseRadius * RandRangeF(0.80, 1.20);
    let impulseStrength: Float = this.m_waterDetonationImpulseStrength * RandRangeF(0.10, 1.20);
    RenderingSystem.AddWaterImpulse(position, impulseRadius, impulseStrength);
    i = 0;
    while i < numImpulses - 1 {
      RenderingSystem.AddWaterImpulse(position + Vector4.RandRing(impulseRadius * 0.25, impulseRadius * 0.90), impulseRadius * RandRangeF(0.40, 0.80), impulseStrength);
      i += 1;
    };
  }

  protected final func EvaluateStimBroadcasting(stimToSend: gamedataStimType) -> Void {
    let broadcastRadius: Float = this.GetFloat("onCollisionStimBroadcastRadius");
    let broadcastLifetime: Float = this.GetFloat("onCollisionStimBroadcastLifetime");
    if broadcastRadius > 0.00 {
      if broadcastLifetime > 0.00 {
        this.TriggerActiveStimuliWithLifetime(stimToSend, broadcastLifetime, broadcastRadius);
      } else {
        this.TriggerSingleStimuli(broadcastRadius, stimToSend);
      };
    };
  }

  protected final func CreateCustomTickEventWithDuration(value: Float) -> Void {
    let projectileTick: ref<ProjectileTickEvent> = new ProjectileTickEvent();
    GameInstance.GetDelaySystem(this.GetGame()).TickOnEvent(this, projectileTick, value);
  }

  protected final func CreateDelayEvent(value: Float) -> Void {
    let projectileDelayEvent: ref<ProjectileDelayEvent>;
    if this.m_releaseRequestDelayID == GetInvalidDelayID() {
      projectileDelayEvent = new ProjectileDelayEvent();
      this.m_releaseRequestDelayID = GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(this, projectileDelayEvent, value);
    };
  }

  protected final func CreateDetonationDelayEvent(value: Float) -> Void {
    let projectileDelayEvent: ref<ProjectileLauncherRoundDetonationDelayEvent>;
    if this.m_detonateRequestDelayID == GetInvalidDelayID() {
      projectileDelayEvent = new ProjectileLauncherRoundDetonationDelayEvent();
      this.m_detonateRequestDelayID = GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(this, projectileDelayEvent, value);
    };
  }

  protected cb func OnMaxLifetimeReached(evt: ref<ProjectileDelayEvent>) -> Bool {
    this.Release();
  }

  protected cb func OnMaxDetonationTimeReached(evt: ref<ProjectileLauncherRoundDetonationDelayEvent>) -> Bool {
    let currentPosition: Vector4;
    if this.m_isAlive {
      currentPosition = this.GetWorldPosition();
      this.ExecuteGameEffect(currentPosition);
      this.Release();
    };
  }

  protected cb func OnTick(eventData: ref<gameprojectileTickEvent>) -> Bool;

  protected final func Release() -> Void {
    let invalidDelayID: DelayID;
    let objectPool: ref<ObjectPoolSystem>;
    if this.m_isAlive {
      GameObjectEffectHelper.BreakEffectLoopEvent(this, this.m_projectileTrailName);
      objectPool = GameInstance.GetObjectPoolSystem(this.GetGame());
      objectPool.Release(this);
      invalidDelayID = GetInvalidDelayID();
      if this.m_releaseRequestDelayID != invalidDelayID {
        GameInstance.GetDelaySystem(this.GetGame()).CancelDelay(this.m_releaseRequestDelayID);
      };
      if this.m_detonateRequestDelayID != invalidDelayID {
        GameInstance.GetDelaySystem(this.GetGame()).CancelDelay(this.m_detonateRequestDelayID);
      };
      this.m_isAlive = false;
    };
  }

  protected final func SetProjectileTrailEffect() -> Void {
    switch this.m_attackRecord.DamageType().DamageType() {
      case gamedataDamageType.Physical:
        this.m_projectileTrailName = n"trail";
        break;
      case gamedataDamageType.Thermal:
        this.m_projectileTrailName = n"trail_thermal";
        break;
      case gamedataDamageType.Chemical:
        this.m_projectileTrailName = n"trail_chemical";
        break;
      case gamedataDamageType.Electric:
        this.m_projectileTrailName = n"trail_electric";
        break;
      default:
        this.m_projectileTrailName = n"trail";
    };
    GameObjectEffectHelper.StartEffectEvent(this, this.m_projectileTrailName, true);
  }

  protected final func SetProjectileLifetime() -> Void {
    let lifetime: Float = this.GetFloat("lifetime");
    if lifetime > 0.00 {
      this.CreateDelayEvent(lifetime);
    };
  }

  protected final func SetProjectileDetonationTime() -> Void {
    let detonationDelay: Float = this.GetFloat("detonationDelay");
    if detonationDelay > 0.00 {
      this.CreateDetonationDelayEvent(detonationDelay);
    };
  }

  protected final func HasTrajectory() -> Bool {
    return this.m_projectileComponent.IsTrajectoryEmpty();
  }

  protected final func StopProjectile() -> Void {
    this.m_projectileComponent.ClearTrajectories();
  }

  protected final func SpawnVisualEffect(effectName: CName, opt eventTag: CName) -> Void {
    let spawnEffectEvent: ref<entSpawnEffectEvent> = new entSpawnEffectEvent();
    spawnEffectEvent.effectName = effectName;
    spawnEffectEvent.effectInstanceName = eventTag;
    this.QueueEvent(spawnEffectEvent);
  }

  protected final func BreakVisualEffectLoop(effectName: CName) -> Void {
    let evt: ref<entBreakEffectLoopEvent> = new entBreakEffectLoopEvent();
    evt.effectName = effectName;
    this.QueueEvent(evt);
  }

  protected final func KillVisualEffect(effectName: CName) -> Void {
    let evt: ref<entKillEffectEvent> = new entKillEffectEvent();
    evt.effectName = effectName;
    this.QueueEvent(evt);
  }

  protected final func GetObject(const hitInstance: script_ref<gameprojectileHitInstance>) -> wref<GameObject> {
    return ProjectileHitHelper.GetHitObject(hitInstance);
  }

  protected final func GetObjectWorldPosition(object: wref<GameObject>) -> Vector4 {
    return ProjectileTargetingHelper.GetObjectCurrentPosition(object);
  }

  protected final func SetProjectileLauncherAction() -> ELauncherActionType {
    let quickAction: Bool = ProjectileHelper.GetPSMBlackboardIntVariable(this.m_user, GetAllBlackboardDefs().PlayerStateMachine.LeftHandCyberware) == 8;
    let chargeAction: Bool = ProjectileHelper.GetPSMBlackboardIntVariable(this.m_user, GetAllBlackboardDefs().PlayerStateMachine.LeftHandCyberware) == 9;
    if quickAction {
      this.m_actionType = ELauncherActionType.QuickAction;
    } else {
      if chargeAction {
        this.m_actionType = ELauncherActionType.ChargeAction;
      } else {
        this.m_actionType = ELauncherActionType.None;
      };
    };
    return this.m_actionType;
  }

  protected final func SetAttackRecordBasedOnAction() -> Void {
    switch this.m_actionType {
      case ELauncherActionType.QuickAction:
        this.m_attackRecord = TweakDBInterface.GetAttackRecord(TDBID.Create(this.GetString("attack")));
        break;
      case ELauncherActionType.ChargeAction:
        if PlayerDevelopmentSystem.GetData(this.m_user).IsNewPerkBought(gamedataNewPerkType.Espionage_Central_Milestone_1) > 0 && this.WeaponIsCharged() {
          this.m_attackRecord = TweakDBInterface.GetAttackRecord(TDBID.Create(this.GetString("relicAttack")));
        } else {
          this.m_attackRecord = TweakDBInterface.GetAttackRecord(TDBID.Create(this.GetString("secondaryAttack")));
        };
        break;
      default:
    };
  }

  protected final func SetLaunchVelocityBasedOnAction() -> Void {
    switch this.m_actionType {
      case ELauncherActionType.QuickAction:
        this.m_initialLaunchVelocity = this.GetFloat("startVelocity");
        break;
      case ELauncherActionType.ChargeAction:
        this.m_initialLaunchVelocity = this.GetFloat("startVelocityCharged");
        break;
      default:
        this.m_initialLaunchVelocity = -1.00;
    };
  }

  protected final func CollisionActionNameToEnum(collisionAction: CName) -> gamedataProjectileOnCollisionAction {
    switch collisionAction {
      case n"Bounce":
        return gamedataProjectileOnCollisionAction.Bounce;
      case n"Pierce":
        return gamedataProjectileOnCollisionAction.Pierce;
      case n"Stop":
        return gamedataProjectileOnCollisionAction.Stop;
      case n"StopAndStick":
        return gamedataProjectileOnCollisionAction.StopAndStick;
      case n"StopAndStickPerpendicular":
        return gamedataProjectileOnCollisionAction.StopAndStickPerpendicular;
      default:
    };
    return gamedataProjectileOnCollisionAction.Invalid;
  }

  protected final func CollisionStimTypeNameToEnum(onCollisionStimType: CName) -> gamedataStimType {
    switch onCollisionStimType {
      case n"Explosion":
        return gamedataStimType.Explosion;
      case n"ProjectileDistraction":
        return gamedataStimType.ProjectileDistraction;
      case n"SoundDistraction":
        return gamedataStimType.SoundDistraction;
      default:
    };
    return gamedataStimType.Invalid;
  }

  protected final func SetLaunchModeBasedOnAction() -> Void {
    switch this.m_actionType {
      case ELauncherActionType.QuickAction:
        this.m_launchMode = this.LaunchModeNameToEnum(this.GetCName("quickActionlaunchMode"));
        break;
      case ELauncherActionType.ChargeAction:
        this.m_launchMode = this.LaunchModeNameToEnum(this.GetCName("chargeActionlaunchMode"));
        break;
      default:
    };
  }

  protected final func LaunchModeNameToEnum(launchModeName: CName) -> gamedataProjectileLaunchMode {
    switch launchModeName {
      case n"Regular":
        return gamedataProjectileLaunchMode.Regular;
      case n"Tracking":
        return gamedataProjectileLaunchMode.Tracking;
      default:
    };
    return gamedataProjectileLaunchMode.Invalid;
  }

  protected final func TriggerSingleStimuli(radius: Float, stimToSend: gamedataStimType) -> Void {
    let investigationData: stimInvestigateData;
    let broadcaster: ref<StimBroadcasterComponent> = this.GetStimBroadcasterComponent();
    if IsDefined(broadcaster) {
      investigationData.attackInstigator = this.m_user;
      broadcaster.TriggerSingleBroadcast(this, stimToSend, radius, investigationData);
    };
  }

  protected final func TriggerActiveStimuliWithLifetime(stimToSend: gamedataStimType, lifetime: Float, radius: Float) -> Void {
    let broadcaster: ref<StimBroadcasterComponent> = this.GetStimBroadcasterComponent();
    if IsDefined(broadcaster) {
      broadcaster.SetSingleActiveStimuli(this, stimToSend, lifetime, radius);
    };
  }

  protected final func LinearLaunch(eventData: ref<gameprojectileShootEvent>, startVelocity: Float) -> Void {
    ProjectileLaunchHelper.SetLinearLaunchTrajectory(this.m_projectileComponent, startVelocity);
  }

  protected final func ParabolicLaunch(eventData: ref<gameprojectileShootEvent>, gravitySimulation: Float, startVelocity: Float, energyLossFactorAfterCollision: Float) -> Void {
    ProjectileLaunchHelper.SetParabolicLaunchTrajectory(this.m_projectileComponent, gravitySimulation, startVelocity, energyLossFactorAfterCollision);
  }

  protected final func CurvedLaunch(eventData: ref<gameprojectileShootEvent>, opt targetObject: wref<GameObject>, opt targetComponent: ref<IPlacedComponent>, startVelocity: Float, linearTimeRatio: Float, interpolationTimeRatio: Float, returnTimeMargin: Float, bendTimeRatio: Float, bendFactor: Float, halfLeanAngle: Float, endLeanAngle: Float, angleInterpolationDuration: Float) -> Void {
    ProjectileLaunchHelper.SetCurvedLaunchTrajectory(this.m_projectileComponent, targetObject, targetComponent, startVelocity, linearTimeRatio, interpolationTimeRatio, returnTimeMargin, bendTimeRatio, bendFactor, halfLeanAngle, endLeanAngle, angleInterpolationDuration);
  }
}
