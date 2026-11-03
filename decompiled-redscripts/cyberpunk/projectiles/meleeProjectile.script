
public class MeleeProjectile extends BaseProjectile {

  protected let m_resourceLibraryComponent: ref<ResourceLibraryComponent>;

  protected let m_throwCooldownSE: TweakDBID;

  @default(MeleeProjectile, false)
  protected let m_collided: Bool;

  @default(MeleeProjectile, false)
  protected let m_wasPicked: Bool;

  @default(MeleeProjectile, true)
  protected let m_isActive: Bool;

  @default(MeleeProjectile, false)
  protected let m_hasHitWater: Bool;

  @default(MeleeProjectile, 0.f)
  protected let m_waterHeight: Float;

  @default(MeleeProjectile, -99999.f)
  protected let m_deactivationDepth: Float;

  @default(MeleeProjectile, 0.f)
  protected let m_waterImpulseRadius: Float;

  @default(MeleeProjectile, 0.f)
  protected let m_waterImpulseStrength: Float;

  protected let m_gravitySimulationMult: Float;

  protected let m_weapon: wref<GameObject>;

  private let m_throwingMeleeResourcePoolListener: ref<ThrowingMeleeReloadListener>;

  protected let m_projectileCollisionEvaluator: ref<ThrowingMeleeCollisionEvaluator>;

  protected let m_projectileStopped: Bool;

  protected let m_isCollidedWithEnemy: Bool;

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
    EntityRequestComponentsInterface.RequestComponent(ri, n"ResourceLibrary", n"ResourceLibraryComponent", true);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_resourceLibraryComponent = EntityResolveComponentsInterface.GetComponent(ri, n"ResourceLibrary") as ResourceLibraryComponent;
  }

  protected cb func OnProjectileInitialize(eventData: ref<gameprojectileSetUpEvent>) -> Bool {
    let statPoolsSystem: ref<StatPoolsSystem>;
    let statsSystem: ref<StatsSystem>;
    let weapon: ref<WeaponObject>;
    super.OnProjectileInitialize(eventData);
    this.m_projectileStopped = false;
    this.m_collided = false;
    this.m_wasPicked = false;
    this.m_isActive = true;
    this.m_hasHitWater = false;
    this.m_isCollidedWithEnemy = false;
    this.m_waterHeight = 0.00;
    this.m_deactivationDepth = this.GetProjectileTweakDBFloatParameter("deactivationDepth");
    this.m_waterImpulseRadius = this.GetProjectileTweakDBFloatParameter("waterImpulseRadius");
    this.m_waterImpulseStrength = this.GetProjectileTweakDBFloatParameter("waterImpulseStrength");
    this.m_projectileCollisionEvaluator = new ThrowingMeleeCollisionEvaluator();
    this.m_projectileComponent.SetCollisionEvaluator(this.m_projectileCollisionEvaluator);
    this.m_weapon = eventData.weapon;
    weapon = this.m_weapon as WeaponObject;
    statsSystem = GameInstance.GetStatsSystem(this.GetGame());
    if IsDefined(weapon) && Equals(RPGManager.GetWeaponEvolution(weapon.GetItemID()), gamedataWeaponEvolution.Throwable) && IsDefined(eventData.owner) && statsSystem.GetStatBoolValue(Cast<StatsObjectID>(eventData.owner.GetEntityID()), gamedataStatType.HasKnifeSharpener) {
      StatusEffectHelper.ApplyStatusEffect(eventData.owner, t"BaseStatusEffect.KnifeSharpenerBuff");
    };
    statPoolsSystem = GameInstance.GetStatPoolsSystem(this.GetGame());
    statPoolsSystem.RequestSettingStatPoolMinValue(Cast<StatsObjectID>(this.m_weapon.GetEntityID()), gamedataStatPoolType.ThrowRecovery, this);
    this.m_gravitySimulationMult = statsSystem.GetStatValue(Cast<StatsObjectID>(this.m_weapon.GetEntityID()), gamedataStatType.MeleeProjectileGravitySimulationMultiplier);
    this.m_throwingMeleeResourcePoolListener = new ThrowingMeleeReloadListener();
    this.m_throwingMeleeResourcePoolListener.Bind(this);
    statPoolsSystem.RequestRegisteringListener(Cast<StatsObjectID>(this.m_weapon.GetEntityID()), gamedataStatPoolType.ThrowRecovery, this.m_throwingMeleeResourcePoolListener);
    GameObject.TagObject(this);
  }

  protected final func SetMeshAppearance(appearance: CName, opt component: CName) -> Void {
    let evt: ref<entAppearanceEvent> = new entAppearanceEvent();
    evt.appearanceName = appearance;
    evt.componentName = component;
    this.QueueEvent(evt);
  }

  protected cb func OnShoot(eventData: ref<gameprojectileShootEvent>) -> Bool {
    this.ExecuteParabolicLaunch(eventData);
  }

  protected cb func OnShootTarget(eventData: ref<gameprojectileShootTargetEvent>) -> Bool {
    let targetComponent: ref<IPlacedComponent>;
    let targetPuppet: ref<ScriptedPuppet>;
    this.GeneralLaunchSetup(eventData);
    this.m_initialLaunchVelocity = this.GetProjectileTweakDBFloatParameter("startVelocity");
    targetComponent = eventData.params.trackedTargetComponent;
    if IsDefined(targetComponent) {
      targetPuppet = targetComponent.GetEntity() as ScriptedPuppet;
      if !GameObject.IsFriendlyTowardsPlayer(targetPuppet) && !targetPuppet.IsCrowd() && targetPuppet.IsActive() {
        this.CurvedLaunchToTarget(eventData, targetComponent.GetEntity() as GameObject, targetComponent);
      } else {
        this.ExecuteParabolicLaunch(eventData);
      };
    } else {
      this.ExecuteParabolicLaunch(eventData);
    };
  }

  protected final func ExecuteParabolicLaunch(eventData: ref<gameprojectileShootEvent>) -> Void {
    let gravitySimulation: Float = this.GetProjectileTweakDBFloatParameter("gravitySimulation") * this.m_gravitySimulationMult;
    let startVelocity: Float = this.GetProjectileTweakDBFloatParameter("startVelocity");
    let energyLossFactorAfterCollision: Float = this.GetProjectileTweakDBFloatParameter("energyLossFactorAfterCollision");
    this.GeneralLaunchSetup(eventData);
    this.ParabolicLaunch(eventData, gravitySimulation, startVelocity, energyLossFactorAfterCollision);
  }

  protected cb func OnTick(eventData: ref<gameprojectileTickEvent>) -> Bool {
    let currentPosition: Vector4;
    if this.m_isActive && this.m_hasHitWater {
      currentPosition = this.GetWorldPosition();
      if currentPosition.Z - this.m_waterHeight <= this.m_deactivationDepth {
        this.DeactivateAndSink();
      };
    };
  }

  protected cb func OnCollision(eventData: ref<gameprojectileHitEvent>) -> Bool {
    let effect: FxResource;
    let effectTransform: WorldTransform;
    let enableInteractionEvent: ref<InteractionSetEnableEvent>;
    let hitEvent: ref<gameprojectileHitEvent>;
    let hitInstance: gameprojectileHitInstance;
    let i: Int32;
    let isObjectNPC: Bool;
    if !this.m_isActive {
      return false;
    };
    super.OnCollision(eventData);
    i = 0;
    while i < ArraySize(eventData.hitInstances) {
      hitInstance = eventData.hitInstances[i];
      if hitInstance.isWaterSurfaceImpact {
        this.m_hasHitWater = true;
        this.m_waterHeight = hitInstance.position.Z;
        effect = this.m_resourceLibraryComponent.GetResource(n"splash_effect");
        if FxResource.IsValid(effect) {
          WorldTransform.SetPosition(effectTransform, hitInstance.position);
          GameInstance.GetFxSystem(this.GetGame()).SpawnEffect(effect, effectTransform);
        };
        RenderingSystem.AddWaterImpulse(hitInstance.position, this.m_waterImpulseRadius, this.m_waterImpulseStrength);
      } else {
        enableInteractionEvent = new InteractionSetEnableEvent();
        enableInteractionEvent.enable = true;
        this.QueueEvent(enableInteractionEvent);
        if !this.m_hasHitWater || hitInstance.position.Z - this.m_waterHeight > this.m_deactivationDepth {
          if !this.m_projectileStopped {
            hitEvent = new gameprojectileHitEvent();
            ArrayPush(hitEvent.hitInstances, hitInstance);
            this.ProjectileHit(hitEvent);
          };
          if this.m_projectileCollisionEvaluator.ProjectileStopAndStick() {
            this.m_projectileStopped = true;
          };
          isObjectNPC = this.GetObject(hitInstance).IsNPC();
          if !(isObjectNPC || this.GetObject(hitInstance).IsDrone()) {
            this.TriggerSingleStimuli(hitInstance, gamedataStimType.SoundDistraction);
          } else {
            this.m_isCollidedWithEnemy = true;
          };
        };
        break;
      };
      i += 1;
    };
  }

  protected cb func OnInteractionActivationEvent(evt: ref<InteractionActivationEvent>) -> Bool {
    GameInstance.GetStatPoolsSystem(this.GetGame()).RequestSettingStatPoolMaxValue(Cast<StatsObjectID>(this.m_weapon.GetEntityID()), gamedataStatPoolType.ThrowRecovery, this);
    if PlayerDevelopmentSystem.GetInstance(evt.activator).IsNewPerkBought(evt.activator, gamedataNewPerkType.Cool_Right_Perk_3_1) == 1 {
      if this.m_isCollidedWithEnemy {
        StatusEffectHelper.ApplyStatusEffect(evt.activator, t"BaseStatusEffect.IncreaseDamageOfNextMeleeAttackWithThrownWeaponSE");
      };
    };
    this.TryToReleaseProjectile();
  }

  public final func TryToReleaseProjectile() -> Void {
    if !this.m_wasPicked {
      this.m_wasPicked = true;
      this.Release();
    };
  }

  protected cb func OnMaxLifetimeReached(evt: ref<ProjectileDelayEvent>) -> Bool {
    this.TryToReleaseProjectile();
  }

  protected final func DeactivateAndSink() -> Void {
    this.m_isActive = false;
    let parabolicTrajectoryParams: ref<ParabolicTrajectoryParams> = ParabolicTrajectoryParams.GetAccelVelParabolicParams(new Vector4(0.00, 0.00, -0.20, 0.00), 0.20, 0.40);
    this.m_projectileComponent.ClearTrajectories();
    this.m_projectileComponent.AddParabolic(parabolicTrajectoryParams);
  }

  public const func GetDefaultHighlight() -> ref<FocusForcedHighlightData> {
    let outline: EFocusOutlineType = this.GetCurrentOutline();
    let highlight: ref<FocusForcedHighlightData> = new FocusForcedHighlightData();
    highlight.sourceID = this.GetEntityID();
    highlight.sourceName = this.GetClassName();
    highlight.priority = EPriority.High;
    highlight.outlineType = outline;
    highlight.patternType = VisionModePatternType.Default;
    highlight.highlightType = EFocusForcedHighlightType.IMPORTANT_INTERACTION;
    return highlight;
  }

  public const func GetCurrentOutline() -> EFocusOutlineType {
    return EFocusOutlineType.IMPORTANT_INTERACTION;
  }
}

public class ThrowingMeleeCollisionEvaluator extends gameprojectileScriptCollisionEvaluator {

  private let m_projectileStopAndStick: Bool;

  protected func EvaluateCollision(defaultOnCollisionAction: gameprojectileOnCollisionAction, params: ref<CollisionEvaluatorParams>) -> gameprojectileOnCollisionAction {
    if params.isWaterSurface || params.isPiercableSurface || Equals(params.projectilePenetration, n"Any") {
      return gameprojectileOnCollisionAction.Pierce;
    };
    if params.isAutoBounceSurface {
      return params.numBounces < 5u ? gameprojectileOnCollisionAction.Bounce : gameprojectileOnCollisionAction.Pierce;
    };
    this.m_projectileStopAndStick = true;
    return gameprojectileOnCollisionAction.StopAndStick;
  }

  public final func ProjectileStopAndStick() -> Bool {
    return this.m_projectileStopAndStick;
  }
}

public class ThrowingMeleeReloadListener extends ScriptStatPoolsListener {

  private let m_melee: wref<MeleeProjectile>;

  public final func Bind(melee: wref<MeleeProjectile>) -> Void {
    this.m_melee = melee;
  }

  protected cb func OnStatPoolMaxValueReached(value: Float) -> Bool {
    this.m_melee.TryToReleaseProjectile();
  }
}
