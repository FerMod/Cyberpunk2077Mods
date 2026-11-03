
public class ThrowableKnifeNPC extends BaseProjectile {

  private let m_visualComponent: ref<IComponent>;

  private let m_resourceLibraryComponent: ref<ResourceLibraryComponent>;

  private let m_weapon: wref<WeaponObject>;

  private let m_attack_record: ref<Attack_Record>;

  private let m_explosionRadius: Float;

  private let m_tweakRecord: ref<Grenade_Record>;

  private let m_isActive: Bool;

  private let m_hasHitWater: Bool;

  private let m_projectileStopped: Bool;

  private let m_desiredLifetime: Float;

  private let m_waterHeight: Float;

  private let m_deactivationDepth: Float;

  private let m_waterImpulseRadius: Float;

  private let m_waterImpulseStrength: Float;

  private let m_dbgCurrentLifetime: Float;

  protected let m_projectileCollisionEvaluator: ref<ThrowingMeleeCollisionEvaluator>;

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
    EntityRequestComponentsInterface.RequestComponent(ri, n"MeshComponent", n"IComponent", true);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_visualComponent = EntityResolveComponentsInterface.GetComponent(ri, n"MeshComponent");
    this.m_projectileComponent = EntityResolveComponentsInterface.GetComponent(ri, n"projectileComponent") as ProjectileComponent;
    this.m_resourceLibraryComponent = EntityResolveComponentsInterface.GetComponent(ri, n"ResourceLibrary") as ResourceLibraryComponent;
  }

  public final func GetInitialVelocity(isQuickThrow: Bool) -> Float {
    let initialVelocity: Float;
    let tweakRecord: ref<Grenade_Record> = TweakDBInterface.GetGrenadeRecord(ItemID.GetTDBID(this.GetItemID()));
    if !isQuickThrow {
      initialVelocity = tweakRecord.DeliveryMethod().InitialVelocity();
    } else {
      initialVelocity = tweakRecord.DeliveryMethod().InitialQuickThrowVelocity();
    };
    return initialVelocity;
  }

  public final func GetAccelerationZ() -> Float {
    let tweakRecord: ref<Grenade_Record> = TweakDBInterface.GetGrenadeRecord(ItemID.GetTDBID(this.GetItemID()));
    return tweakRecord.DeliveryMethod().AccelerationZ();
  }

  public final func isFollowingKnife() -> Bool {
    return TweakDBInterface.GetGrenadeRecord(ItemID.GetTDBID(this.GetItemID())).TagsContains(n"following");
  }

  protected cb func OnProjectileInitialize(eventData: ref<gameprojectileSetUpEvent>) -> Bool {
    let attack: ref<IAttack>;
    super.OnProjectileInitialize(eventData);
    this.m_tweakRecord = TweakDBInterface.GetGrenadeRecord(ItemID.GetTDBID(this.GetItemID()));
    this.m_projectileStopped = false;
    this.m_isActive = true;
    this.m_hasHitWater = false;
    this.m_waterHeight = 0.00;
    this.m_deactivationDepth = this.GetProjectileTweakDBFloatParameter("deactivationDepth");
    this.m_waterImpulseRadius = this.GetProjectileTweakDBFloatParameter("waterImpulseRadius");
    this.m_waterImpulseStrength = this.GetProjectileTweakDBFloatParameter("waterImpulseStrength");
    this.m_user = eventData.owner;
    this.m_weapon = eventData.weapon as WeaponObject;
    attack = this.m_weapon.GetCurrentAttack();
    this.m_attack_record = attack.GetRecord();
    this.m_desiredLifetime = TweakDBInterface.GetFloat(t"projectile.npc_throwable_knife_params.lifetime", -1.00);
    this.m_projectileCollisionEvaluator = new ThrowingMeleeCollisionEvaluator();
    this.m_projectileComponent.SetCollisionEvaluator(this.m_projectileCollisionEvaluator);
  }

  protected cb func OnShoot(eventData: ref<gameprojectileShootEvent>) -> Bool {
    let effectBlackboard: ref<worldEffectBlackboard> = new worldEffectBlackboard();
    effectBlackboard.SetValueUnclamped(n"trailFxScale", this.m_projectileComponent.GetTrailVFXScale());
    GameObjectEffectHelper.StartEffectEvent(this, n"trail_chemical", true, effectBlackboard);
    this.Reset();
  }

  protected cb func OnShootTarget(eventData: ref<gameprojectileShootTargetEvent>) -> Bool {
    this.OnShoot(eventData);
  }

  private final func Reset() -> Void {
    this.m_visualComponent.Toggle(true);
    this.InitializeRotation();
    this.m_dbgCurrentLifetime = 0.00;
    this.ReleaseKnifeWithDelay(this.m_desiredLifetime);
  }

  protected cb func OnCollision(eventData: ref<gameprojectileHitEvent>) -> Bool {
    let adHocAnimEvent: ref<AdHocAnimationEvent>;
    let effect: FxResource;
    let effectTransform: WorldTransform;
    let hasHitDrone: Bool;
    let hasHitNPC: Bool;
    let hasHitPlayer: Bool;
    let hitEvent: ref<gameprojectileHitEvent>;
    let hitInstance: gameprojectileHitInstance;
    let i: Int32;
    if !this.m_isActive {
      return false;
    };
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
        if !this.m_hasHitWater || hitInstance.position.Z - this.m_waterHeight > this.m_deactivationDepth {
          if !this.m_projectileStopped {
            hitEvent = new gameprojectileHitEvent();
            ArrayPush(hitEvent.hitInstances, hitInstance);
            this.ProjectileHit(hitEvent);
          };
          if this.m_projectileCollisionEvaluator.ProjectileStopAndStick() {
            this.m_projectileStopped = true;
          };
          hasHitNPC = this.GetObject(hitInstance).IsNPC();
          hasHitDrone = this.GetObject(hitInstance).IsDrone();
          hasHitPlayer = this.GetObject(hitInstance).IsPlayer();
          if !hasHitNPC && !hasHitDrone && !hasHitPlayer {
            this.TriggerSingleStimuli(hitInstance, gamedataStimType.SoundDistraction);
          };
          if hasHitPlayer {
            this.SpawnAttack(this.m_tweakRecord.NpcHitReactionAttack(), 10.00, this.GetWorldPosition());
            this.m_visualComponent.Toggle(false);
            adHocAnimEvent = new AdHocAnimationEvent();
            adHocAnimEvent.animationIndex = 5;
            adHocAnimEvent.animationDuration = 2.33;
            adHocAnimEvent.useBothHands = true;
            adHocAnimEvent.unequipWeapon = false;
            GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerControlledGameObject().QueueEvent(adHocAnimEvent);
          };
        };
        break;
      };
      i += 1;
    };
  }

  protected cb func OnTick(eventData: ref<gameprojectileTickEvent>) -> Bool {
    let currentPosition: Vector4;
    this.m_dbgCurrentLifetime += eventData.deltaTime;
    if this.m_isActive && this.m_hasHitWater {
      currentPosition = this.GetWorldPosition();
      if currentPosition.Z - this.m_waterHeight <= this.m_deactivationDepth {
        this.DeactivateAndSink();
      };
    };
    this.m_projectileComponent.LogDebugVariable(n"Lifetime", FloatToString(this.m_dbgCurrentLifetime));
  }

  private final func InitializeRotation() -> Void {
    let rotationAxis: Vector4 = new Vector4(-1.00, 0.00, 0.00, 0.00);
    let rotationSpeed: Float = 3600.00;
    this.m_projectileComponent.ToggleAxisRotation(true);
    this.m_projectileComponent.AddAxisRotation(rotationAxis, rotationSpeed);
  }

  protected final func SpawnAttack(attackRecord: ref<Attack_Record>, opt range: Float, opt duration: Float, opt hitNormal: Vector4, opt position: Vector4, opt vfxOffset: Vector4) -> ref<EffectInstance> {
    let attackContext: AttackInitContext;
    let effect: ref<EffectInstance>;
    let hitCooldown: Float;
    let statMods: array<ref<gameStatModifierData>>;
    attackContext.record = attackRecord;
    attackContext.instigator = this.m_user;
    attackContext.source = this;
    let attack: ref<Attack_GameEffect> = IAttack.Create(attackContext) as Attack_GameEffect;
    attack.GetStatModList(statMods);
    effect = attack.PrepareAttack(this.m_user);
    if range > 0.00 {
      EffectData.SetFloat(effect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.range, range);
      EffectData.SetFloat(effect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.radius, range);
    };
    if !Vector4.IsZero(position) {
      EffectData.SetVector(effect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.position, position);
    } else {
      EffectData.SetVector(effect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.position, this.GetWorldPosition());
    };
    if duration > 0.00 {
      EffectData.SetFloat(effect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.duration, duration);
    };
    hitCooldown = TweakDBInterface.GetFloat(ItemID.GetTDBID(this.GetItemID()) + t".effectCooldown", 0.00);
    if hitCooldown > 0.00 {
      EffectData.SetFloat(effect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.hitCooldown, hitCooldown);
    };
    if !Vector4.IsZero(hitNormal) {
      EffectData.SetQuat(effect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.rotation, Quaternion.BuildFromDirectionVector(hitNormal, new Vector4(0.00, 0.00, 1.00, 0.00)));
    };
    if !Vector4.IsZero(vfxOffset) {
      EffectData.SetVector(effect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.vfxOffset, vfxOffset);
    };
    EffectData.SetVariant(effect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.attack, ToVariant(attack));
    attack.StartAttack();
    return effect;
  }

  protected final func ReleaseKnife() -> Void {
    let despawnRequest: ref<GrenadeDespawnRequestEvent>;
    this.m_projectileComponent.ClearTrajectories();
    despawnRequest = new GrenadeDespawnRequestEvent();
    this.QueueEvent(despawnRequest);
    this.Release();
  }

  protected final func ReleaseKnifeWithDelay(delay: Float) -> Void {
    let requestEvent: ref<GrenadeReleaseRequestEvent> = new GrenadeReleaseRequestEvent();
    GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(this, requestEvent, delay);
  }

  protected cb func OnReleaseRequestEvent(evt: ref<GrenadeReleaseRequestEvent>) -> Bool {
    this.ReleaseKnife();
  }

  protected cb func OnDespawnRequest(evt: ref<GrenadeDespawnRequestEvent>) -> Bool {
    let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
    transactionSystem.ReleaseItem(this.GetOwner(), this);
  }

  protected final func DeactivateAndSink() -> Void {
    this.m_isActive = false;
    let parabolicTrajectoryParams: ref<ParabolicTrajectoryParams> = ParabolicTrajectoryParams.GetAccelVelParabolicParams(new Vector4(0.00, 0.00, -0.20, 0.00), 0.20, 0.40);
    this.m_projectileComponent.ClearTrajectories();
    this.m_projectileComponent.AddParabolic(parabolicTrajectoryParams);
  }
}

public class KurtTakedownKnifeLanded extends AIbehaviorconditionScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let target: wref<GameObject> = GameInstance.GetPlayerSystem(ScriptExecutionContext.GetOwner(context).GetGame()).GetLocalPlayerControlledGameObject();
    let targetAffected: Bool = StatusEffectSystem.ObjectHasStatusEffect(target, t"BaseStatusEffect.KurtTakedownKnifeStatusEffect");
    if IsDefined(target) && target.IsPlayer() {
      return Cast<AIbehaviorConditionOutcomes>(targetAffected);
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class KurtMeleeTakedownCooldownActive extends AIbehaviorconditionScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let target: wref<GameObject> = GameInstance.GetPlayerSystem(ScriptExecutionContext.GetOwner(context).GetGame()).GetLocalPlayerControlledGameObject();
    let targetAffected: Bool = StatusEffectSystem.ObjectHasStatusEffect(target, t"BaseStatusEffect.KurtMeleeTakedownCooldownSE");
    if IsDefined(target) && target.IsPlayer() {
      return Cast<AIbehaviorConditionOutcomes>(targetAffected);
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class ForceKurtStatusEffect extends AIbehaviortaskScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let target: wref<GameObject> = GameInstance.GetPlayerSystem(ScriptExecutionContext.GetOwner(context).GetGame()).GetLocalPlayerControlledGameObject();
    if IsDefined(target) && target.IsPlayer() {
      StatusEffectHelper.ApplyStatusEffect(target, t"BaseStatusEffect.TakedownsUnequipWeapons", 0.00);
    };
  }
}

public class ForcePlayerLookat_Kurt extends AIbehaviortaskScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let localAimRequest: AimRequest;
    let target: wref<GameObject> = GameInstance.GetPlayerSystem(ScriptExecutionContext.GetOwner(context).GetGame()).GetLocalPlayerControlledGameObject();
    let lookAtTarget: Vector4 = target.GetWorldPosition() + new Vector4(0.00, 1.00, 0.00, 0.00);
    localAimRequest.lookAtTarget = lookAtTarget;
    localAimRequest.duration = 0.10;
    localAimRequest.easeIn = false;
    localAimRequest.easeOut = false;
    localAimRequest.precision = 0.01;
    localAimRequest.adjustPitch = true;
    localAimRequest.adjustYaw = true;
    localAimRequest.checkRange = false;
    localAimRequest.endOnCameraInputApplied = true;
    localAimRequest.endOnTargetReached = false;
    localAimRequest.processAsInput = true;
    if IsDefined(target) && target.IsPlayer() {
      GameInstance.GetTargetingSystem(ScriptExecutionContext.GetOwner(context).GetGame()).BreakAimSnap(GetPlayer(ScriptExecutionContext.GetOwner(context).GetGame()));
      GameInstance.GetTargetingSystem(ScriptExecutionContext.GetOwner(context).GetGame()).LookAt(GetPlayer(ScriptExecutionContext.GetOwner(context).GetGame()), localAimRequest);
    };
  }
}
