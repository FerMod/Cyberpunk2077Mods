
public final native class BreachFinderComponent extends IComponent {

  public let m_owner: wref<GameObject>;

  public let m_audioSystem: ref<AudioSystem>;

  public let m_statsSystem: ref<StatsSystem>;

  public let m_hitCount: Int32;

  @default(BreachFinderComponent, false)
  public let m_almostTimeout: Bool;

  public let m_breachDurationMin: Float;

  public let m_breachDurationMax: Float;

  public let m_breachDurationIncreasePerStreak: Float;

  public let m_breachDurationIncreaseForAnyStreak: Float;

  public let m_breachDurationIncreaseOnFirstLookat: Float;

  public let m_breachDurationIncreaseOnFirstHit: Float;

  public let m_breachCooldownMin: Float;

  public let m_breachCooldownMax: Float;

  public let m_breachCooldownDecreasePerStreak: Float;

  public let m_onBreachDestroyedAttackRecord: ref<Attack_GameEffect_Record>;

  public let m_onBreachDestroyedHealthToDamage: Float;

  public let m_onBreachDestroyedHealthToDamageBoss: Float;

  @default(BreachFinderComponent, 0.f)
  public let m_desiredBreachDuration: Float;

  @default(BreachFinderComponent, 0.f)
  public let m_cooldownAfterBreach: Float;

  public final native func IsTrackedBreachHit(hitEvent: ref<gameHitEvent>, isMeleeAttack: Bool, isBulletExplosion: Bool) -> Bool;

  public final native func OnTrackedBreachDamaged(damage: Float) -> Void;

  public final native func CanTrackedBreachBeKilledByDamage(damage: Float) -> Bool;

  public final native func GetTrackedBreachComponent() -> wref<BreachComponent>;

  public final native func GetTrackedBreachPuppet() -> wref<gamePuppet>;

  public final func Init(owner: wref<GameObject>) -> Void {
    this.m_owner = owner;
    this.m_audioSystem = GameInstance.GetAudioSystem(this.m_owner.GetGame());
    this.m_statsSystem = GameInstance.GetStatsSystem(this.m_owner.GetGame());
    this.m_breachDurationMin = TweakDBInterface.GetFloat(t"NewPerks.CyberwareBreachParams.breachDurationMin", 5.00);
    this.m_breachDurationMax = TweakDBInterface.GetFloat(t"NewPerks.CyberwareBreachParams.breachDurationMax", 6.00);
    this.m_breachDurationIncreasePerStreak = TweakDBInterface.GetFloat(t"NewPerks.CyberwareBreachParams.breachDurationIncreasePerStreak", 10.00);
    this.m_breachDurationIncreaseForAnyStreak = TweakDBInterface.GetFloat(t"NewPerks.CyberwareBreachParams.breachDurationIncreaseForAnyStreak", 2.00);
    this.m_breachDurationIncreaseOnFirstLookat = TweakDBInterface.GetFloat(t"NewPerks.CyberwareBreachParams.breachDurationIncreaseOnFirstLookat", 4.00);
    this.m_breachDurationIncreaseOnFirstHit = TweakDBInterface.GetFloat(t"NewPerks.CyberwareBreachParams.breachDurationIncreaseOnFirstHit", 4.00);
    this.m_breachCooldownMin = TweakDBInterface.GetFloat(t"NewPerks.CyberwareBreachParams.breachCooldownMin", 7.00);
    this.m_breachCooldownMax = TweakDBInterface.GetFloat(t"NewPerks.CyberwareBreachParams.breachCooldownMax", 15.00);
    this.m_breachCooldownDecreasePerStreak = TweakDBInterface.GetFloat(t"NewPerks.CyberwareBreachParams.breachCooldownDecreasePerStreak", 10.00);
    this.m_onBreachDestroyedAttackRecord = TweakDBInterface.GetAttack_GameEffectRecord(t"Attacks.BreachEMPExplosion");
    this.m_onBreachDestroyedHealthToDamage = TweakDBInterface.GetFloat(t"NewPerks.CyberwareBreachParams.explosionDamageHealthPercentage", 100.00);
    this.m_onBreachDestroyedHealthToDamageBoss = TweakDBInterface.GetFloat(t"NewPerks.CyberwareBreachParams.explosionDamageHealthPercentageBoss", 100.00);
  }

  public final func GetBreachStreak() -> Float {
    let streak: Float = this.m_statsSystem.GetStatValue(Cast<StatsObjectID>(this.m_owner.GetEntityID()), gamedataStatType.BreachStreakBuffBonus);
    if streak < 5.00 {
      return streak;
    };
    return 2.00 * streak;
  }

  public final static func TryProcessBreachHit(hitEvent: ref<gameHitEvent>, isHeadshot: Bool, opt checkOnly: Bool) -> Bool {
    let breachFinder: ref<BreachFinderComponent>;
    let player: ref<PlayerPuppet>;
    let isRanged: Bool = AttackData.IsRangedOrDirectOrThrown(hitEvent.attackData.GetAttackType());
    let isMelee: Bool = AttackData.IsMelee(hitEvent.attackData.GetAttackType()) || AttackData.IsWhip(hitEvent.attackData.GetAttackType());
    if !isMelee && !isRanged {
      return false;
    };
    if isHeadshot {
      return false;
    };
    if !IsDefined(hitEvent.attackData.GetWeapon()) && !hitEvent.attackData.HasFlag(hitFlag.WasBulletDeflected) {
      return false;
    };
    player = hitEvent.attackData.GetInstigator() as PlayerPuppet;
    if !IsDefined(player) {
      return false;
    };
    breachFinder = player.GetBreachFinderComponent();
    if !IsDefined(breachFinder) {
      return false;
    };
    if !breachFinder.IsTrackedBreachHit(hitEvent, isMelee, hitEvent.attackData.HasFlag(hitFlag.BulletExplosion)) {
      return false;
    };
    if !checkOnly {
      breachFinder.ProcessBreachHit(hitEvent);
    };
    return true;
  }

  private final func ProcessBreachHit(hitEvent: ref<gameHitEvent>) -> Void {
    hitEvent.attackData.AddFlag(hitFlag.CriticalHit, n"ProcessBreachHit");
    hitEvent.attackData.AddFlag(hitFlag.WeakspotHit, n"ProcessBreachHit");
    hitEvent.attackData.AddFlag(hitFlag.BreachHit, n"ProcessBreachHit");
    if !hitEvent.projectionPipeline {
      this.m_hitCount += 1;
      if this.m_hitCount == 1 {
        this.OnFirstBreachHit();
      };
    };
  }

  public final func OnFirstBreachLookat() -> Void {
    if !this.m_almostTimeout {
      this.m_desiredBreachDuration += this.m_breachDurationIncreaseOnFirstLookat;
    };
  }

  private final func OnFirstBreachHit() -> Void {
    if !this.m_almostTimeout {
      this.m_desiredBreachDuration += this.m_breachDurationIncreaseOnFirstHit;
    };
  }

  protected final cb func OnDamageDealt(evt: ref<gameTargetDamageEvent>) -> Bool {
    if !evt.attackData.HasFlag(hitFlag.BreachHit) || !IsDefined(evt.target) || evt.damage <= 0.00 {
      return false;
    };
    this.OnTrackedBreachDamaged(evt.damage);
  }

  public final func OnBreachDestroyed() -> Void {
    let breachComponent: ref<BreachComponent> = this.GetTrackedBreachComponent();
    let breachPuppet: ref<NPCPuppet> = this.GetTrackedBreachPuppet() as NPCPuppet;
    if IsDefined(breachComponent) && IsDefined(breachPuppet) && IsDefined(this.m_owner) {
      this.SpawnFinalAttack(this.m_owner, this.m_onBreachDestroyedAttackRecord, breachComponent, breachPuppet);
    };
    if PlayerDevelopmentSystem.GetData(this.m_owner).IsNewPerkBought(gamedataNewPerkType.Espionage_Right_Perk_1_1) > 0 {
      StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"BaseStatusEffect.CyberwareBreachStreak", this.m_owner.GetEntityID());
    };
    this.m_hitCount = 0;
  }

  private final func SpawnFinalAttack(instigator: wref<GameObject>, attackRecord: ref<Attack_GameEffect_Record>, breach: ref<BreachComponent>, puppet: ref<NPCPuppet>) -> Void {
    let attack: ref<Attack_GameEffect>;
    let attackContext: AttackInitContext;
    let breachMaxHealthToDamage: Float;
    let effect: ref<EffectInstance>;
    let statMods: array<ref<gameStatModifierData>>;
    let position: Vector4 = breach.GetPosition();
    let breachMaxHealth: Float = breach.GetMaxHealth();
    if breachMaxHealth <= 0.00 {
      return;
    };
    breachMaxHealthToDamage = Equals(puppet.GetNPCRarity(), gamedataNPCRarity.Boss) || Equals(puppet.GetNPCRarity(), gamedataNPCRarity.MaxTac) ? this.m_onBreachDestroyedHealthToDamageBoss : this.m_onBreachDestroyedHealthToDamage;
    attackContext.record = attackRecord;
    attackContext.instigator = instigator;
    attackContext.source = instigator;
    attack = IAttack.Create(attackContext) as Attack_GameEffect;
    attack.AddStatModifier(RPGManager.CreateStatModifier(gamedataStatType.ElectricDamage, gameStatModifierType.Additive, (breachMaxHealth * breachMaxHealthToDamage) / 100.00));
    attack.GetStatModList(statMods);
    effect = attack.PrepareAttack(instigator);
    EffectData.SetFloat(effect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.range, attackRecord.Range());
    EffectData.SetFloat(effect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.radius, attackRecord.Range());
    EffectData.SetVector(effect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.position, position);
    EffectData.SetVariant(effect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.attack, ToVariant(attack));
    EffectData.SetVariant(effect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.attackStatModList, ToVariant(statMods));
    attack.StartAttack();
    this.m_audioSystem.PlayShockwave(TDB.GetCName(t"rumble.world.heavy_slow"), position);
  }

  public final func OnStartedTrackingBreach() -> Void {
    let streak: Float = this.GetBreachStreak();
    this.m_desiredBreachDuration = (1.00 + (streak * this.m_breachDurationIncreasePerStreak) / 100.00) * RandRangeF(this.m_breachDurationMin, this.m_breachDurationMax);
    if streak > 0.00 {
      this.m_desiredBreachDuration += this.m_breachDurationIncreaseForAnyStreak;
    };
    this.m_hitCount = 0;
    this.m_almostTimeout = false;
    GameObject.PlaySoundEvent(this.m_owner, n"ui_gmpl_perk_cw_breach");
  }

  public final func OnStoppedTrackingBreach() -> Void {
    this.m_cooldownAfterBreach = (1.00 - (this.GetBreachStreak() * this.m_breachCooldownDecreasePerStreak) / 100.00) * RandRangeF(this.m_breachCooldownMin, this.m_breachCooldownMax);
    this.m_cooldownAfterBreach = MaxF(this.m_cooldownAfterBreach, 0.50);
  }

  public final func ShouldStartTrackingBreach(timeSinceLastBreach: Float) -> Bool {
    return timeSinceLastBreach >= this.m_cooldownAfterBreach;
  }

  public final func GetCooldownAfterBreach() -> Float {
    return this.m_cooldownAfterBreach;
  }

  public final func ShouldStopTrackingBreach(currentBreachDuration: Float) -> Bool {
    return currentBreachDuration >= this.m_desiredBreachDuration;
  }

  public final func IsAlmostBreachTimeout(currentBreachDuration: Float) -> Bool {
    this.m_almostTimeout = currentBreachDuration + 0.95 >= this.m_desiredBreachDuration;
    return this.m_almostTimeout;
  }

  public final func GetDesiredBreachDuration() -> Float {
    return this.m_desiredBreachDuration;
  }
}
