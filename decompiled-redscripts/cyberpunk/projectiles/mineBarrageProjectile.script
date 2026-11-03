
public class MineBarrageProjectile extends BaseProjectile {

  private edit let m_landIndicatorFX: FxResource;

  public let m_fxInstance: ref<FxInstance>;

  public let m_visualComponent: ref<MeshComponent>;

  public let m_onGround: Bool;

  public let m_onGroundTimer: Float;

  public let m_weapon: wref<WeaponObject>;

  public let m_attack_record: ref<Attack_Record>;

  public let m_detonationTimer: Float;

  public let m_explosionRadius: Float;

  public let m_playerPuppet: wref<PlayerPuppet>;

  protected let m_mappinID: NewMappinID;

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_visualComponent = EntityResolveComponentsInterface.GetComponent(ri, n"MeshComponent") as MeshComponent;
  }

  protected cb func OnProjectileInitialize(eventData: ref<gameprojectileSetUpEvent>) -> Bool {
    let attack: ref<IAttack>;
    super.OnProjectileInitialize(eventData);
    this.m_explosionRadius = AITweakParams.GetFloatFromTweak(t"Attacks.MineMissileChimera", "explosionRadius");
    this.m_user = eventData.owner;
    this.m_weapon = eventData.weapon as WeaponObject;
    this.m_detonationTimer = AITweakParams.GetFloatFromTweak(t"Attacks.MineMissileChimera", "detonationTimer");
    attack = this.m_weapon.GetCurrentAttack();
    this.m_attack_record = attack.GetRecord();
    this.m_playerPuppet = GetPlayer(this.GetGame());
    this.m_projectileComponent.LockOrientation(true);
  }

  protected cb func OnTick(eventData: ref<gameprojectileTickEvent>) -> Bool {
    let distanceToPlayer: Float;
    if this.m_onGround {
      distanceToPlayer = Vector4.DistanceSquared(Matrix.GetTranslation(this.m_projectileComponent.GetLocalToWorld()), this.m_playerPuppet.GetWorldPosition());
      this.m_onGroundTimer += eventData.deltaTime;
      if this.m_onGroundTimer >= this.m_detonationTimer || distanceToPlayer <= this.m_explosionRadius {
        this.Explode();
      };
    };
  }

  protected cb func OnShoot(eventData: ref<gameprojectileShootEvent>) -> Bool {
    let grenadeMappinData: MappinData;
    let grenadeMappinScriptData: ref<GrenadeMappinData>;
    this.m_projectileSpawnPoint = eventData.startPoint;
    if this.m_user != null && this.m_mappinID.value == 0u {
      grenadeMappinScriptData = new GrenadeMappinData();
      grenadeMappinScriptData.m_iconID = t"MappinIcons.GrenadeMappin";
      grenadeMappinData.mappinType = t"Mappins.InteractionMappinDefinition";
      grenadeMappinData.variant = gamedataMappinVariant.GrenadeVariant;
      grenadeMappinData.active = true;
      grenadeMappinData.scriptData = grenadeMappinScriptData;
      this.m_mappinID = GameInstance.GetMappinSystem(this.m_user.GetGame()).RegisterGrenadeMappin(grenadeMappinData, this);
    };
  }

  protected cb func OnShootTarget(eventData: ref<gameprojectileShootTargetEvent>) -> Bool {
    let parabolicParams: ref<ParabolicTrajectoryParams> = ParabolicTrajectoryParams.GetAccelTargetAngleParabolicParams(new Vector4(0.00, 0.00, -7.00, 0.00), eventData.params.targetPosition, 30.00);
    this.m_projectileComponent.AddParabolic(parabolicParams);
    this.m_projectileComponent.SetOnCollisionAction(gameprojectileOnCollisionAction.Stop);
    this.m_fxInstance = this.SpawnLandVFXs(this.m_landIndicatorFX, eventData.params.targetPosition);
    this.m_onGround = false;
    this.m_onGroundTimer = 0.00;
    if this.m_weapon.GetItemData().HasTag(n"JurijProjectile") {
      this.OnShoot(eventData);
    };
  }

  protected cb func OnCollision(eventData: ref<gameprojectileHitEvent>) -> Bool {
    let hitInstance: gameprojectileHitInstance;
    let lastHitNormal: Vector4;
    let puppet: ref<ScriptedPuppet>;
    let normal: Vector4 = GameInstance.GetBlackboardSystem(this.GetGame()).Get(GetAllBlackboardDefs().Mines).GetVector4(GetAllBlackboardDefs().Mines.CurrentNormal);
    let rotation: EulerAngles = Vector4.ToRotation(normal);
    this.m_visualComponent.SetLocalOrientation(EulerAngles.ToQuat(rotation));
    hitInstance = eventData.hitInstances[0];
    puppet = hitInstance.hitObject as ScriptedPuppet;
    if !IsDefined(puppet) {
      lastHitNormal = Cast<Vector4>(hitInstance.traceResult.normal);
      if Vector4.GetAngleBetween(lastHitNormal, new Vector4(0.00, 0.00, 1.00, 0.00)) > 35.00 {
        this.Explode();
      };
      this.m_onGround = true;
      this.m_onGroundTimer = 0.00;
    } else {
      this.Explode();
    };
  }

  protected final func ReleaseMappin() -> Void {
    if this.m_mappinID.value != 0u {
      GameInstance.GetMappinSystem(this.m_user.GetGame()).UnregisterMappin(this.m_mappinID);
      this.m_mappinID.value = 0u;
    };
  }

  protected func Explode() -> Void {
    let attackContext: AttackInitContext;
    let flag: SHitFlag;
    let hitFlags: array<SHitFlag>;
    let explosionRange: Float = AITweakParams.GetFloatFromTweak(t"Attacks.MineMissileChimera", "explosionRange");
    let explosionAttackRecord: ref<Attack_Record> = IAttack.GetExplosiveHitAttack(this.m_attack_record);
    attackContext.record = explosionAttackRecord;
    attackContext.instigator = this.m_user;
    attackContext.source = this.m_user;
    attackContext.weapon = this.m_weapon;
    let attack: ref<Attack_GameEffect> = IAttack.Create(attackContext) as Attack_GameEffect;
    let effect: ref<EffectInstance> = attack.PrepareAttack(this.m_user);
    flag.flag = hitFlag.CanDamageSelf;
    flag.source = n"GrenadeDetonation";
    ArrayPush(hitFlags, flag);
    EffectData.SetVariant(effect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.flags, ToVariant(hitFlags));
    EffectData.SetFloat(effect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.range, explosionRange);
    EffectData.SetFloat(effect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.radius, this.m_explosionRadius);
    EffectData.SetVector(effect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.position, this.GetWorldPosition());
    EffectData.SetVariant(effect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.attack, ToVariant(attack));
    attack.StartAttack();
    this.m_projectileComponent.ClearTrajectories();
    this.m_fxInstance.BreakLoop();
    this.SetMeshVisible(false);
    this.Release();
    if this.m_weapon.GetItemData().HasTag(n"JurijProjectile") {
      this.ReleaseMappin();
    };
  }

  protected cb func OnHit(evt: ref<gameHitEvent>) -> Bool {
    let instigatorIsPlayer: Bool = evt.attackData.GetInstigator() == GetPlayer(this.GetGame());
    if instigatorIsPlayer {
      this.Explode();
    };
  }
}
