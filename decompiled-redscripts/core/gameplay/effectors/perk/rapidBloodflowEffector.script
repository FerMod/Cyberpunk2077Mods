
public class BloodswellCallback extends DelayCallback {

  private let bloodswellEffector: ref<BloodswellEffector>;

  public final static func Construct(eff: ref<BloodswellEffector>) -> ref<BloodswellCallback> {
    let callback: ref<BloodswellCallback> = new BloodswellCallback();
    callback.bloodswellEffector = eff;
    return callback;
  }
}

public class BloodswellEffectorHealthListener extends ScriptStatPoolsListener {

  public let m_effector: ref<BloodswellEffector>;

  protected cb func OnStatPoolCustomLimitReached(value: Float) -> Bool {
    this.m_effector.OnDeath();
  }
}

public class BloodswellEffectorColdBloodListener extends ScriptStatsListener {

  public let m_effector: ref<BloodswellEffector>;

  public let m_gameInstance: GameInstance;

  public func OnStatChanged(ownerID: StatsObjectID, statType: gamedataStatType, diff: Float, total: Float) -> Void {
    if Equals(statType, gamedataStatType.ColdBloodBuffBonus) {
      if total > 0.00 {
        this.m_effector.ColdbloodAcquired();
      } else {
        if total == 0.00 {
          this.m_effector.ColdBloodSpend();
        };
      };
    };
  }
}

public class BloodswellEffector extends Effector {

  private let m_deathListener: ref<BloodswellEffectorHealthListener>;

  private let m_coldBloodListener: ref<BloodswellEffectorColdBloodListener>;

  private let m_gameInstance: GameInstance;

  private let m_owner: wref<GameObject>;

  private let m_isImmortal: Bool;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_gameInstance = game;
    this.m_deathListener = new BloodswellEffectorHealthListener();
    this.m_deathListener.m_effector = this;
    this.m_coldBloodListener = new BloodswellEffectorColdBloodListener();
    this.m_coldBloodListener.m_effector = this;
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    let statPoolsSystem: ref<StatPoolsSystem> = GameInstance.GetStatPoolsSystem(this.m_gameInstance);
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.m_gameInstance);
    this.m_owner = owner;
    this.m_coldBloodListener.m_gameInstance = this.m_gameInstance;
    statPoolsSystem.RequestRegisteringListener(Cast<StatsObjectID>(this.m_owner.GetEntityID()), gamedataStatPoolType.Health, this.m_deathListener);
    statsSystem.RegisterListener(Cast<StatsObjectID>(this.m_owner.GetEntityID()), this.m_coldBloodListener);
  }

  protected func Uninitialize(game: GameInstance) -> Void {
    let statPoolsSystem: ref<StatPoolsSystem> = GameInstance.GetStatPoolsSystem(this.m_gameInstance);
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.m_gameInstance);
    if this.m_isImmortal {
      GameInstance.GetStatPoolsSystem(this.m_gameInstance).RequestSettingStatPoolValueCustomLimit(Cast<StatsObjectID>(this.m_owner.GetEntityID()), gamedataStatPoolType.Health, 0.00, null);
      this.m_isImmortal = false;
    };
    statPoolsSystem.RequestUnregisteringListener(Cast<StatsObjectID>(this.m_owner.GetEntityID()), gamedataStatPoolType.Health, this.m_deathListener);
    statsSystem.UnregisterListener(Cast<StatsObjectID>(this.m_owner.GetEntityID()), this.m_coldBloodListener);
  }

  public final func ColdbloodAcquired() -> Void {
    if !this.m_isImmortal {
      GameInstance.GetStatPoolsSystem(this.m_gameInstance).RequestSettingStatPoolValueCustomLimit(Cast<StatsObjectID>(this.m_owner.GetEntityID()), gamedataStatPoolType.Health, 0.10, null);
      this.m_isImmortal = true;
    };
  }

  public final func ColdBloodSpend() -> Void {
    if this.m_isImmortal {
      GameInstance.GetStatPoolsSystem(this.m_gameInstance).RequestSettingStatPoolValueCustomLimit(Cast<StatsObjectID>(this.m_owner.GetEntityID()), gamedataStatPoolType.Health, 0.00, null);
      this.m_isImmortal = false;
    };
  }

  public final func OnDeath() -> Void {
    let healthToHeal: Float;
    let maxHealth: Float;
    let statSys: ref<StatsSystem> = GameInstance.GetStatsSystem(this.m_gameInstance);
    let coldbloodStacks: Float = statSys.GetStatValue(Cast<StatsObjectID>(this.m_owner.GetEntityID()), gamedataStatType.ColdBloodBuffBonus);
    if coldbloodStacks == 0.00 {
      return;
    };
    maxHealth = statSys.GetStatValue(Cast<StatsObjectID>(this.m_owner.GetEntityID()), gamedataStatType.Health);
    healthToHeal = maxHealth * 0.10 * coldbloodStacks;
    GameInstance.GetStatPoolsSystem(this.m_gameInstance).RequestChangingStatPoolValue(Cast<StatsObjectID>(this.m_owner.GetEntityID()), gamedataStatPoolType.Health, healthToHeal, this.m_owner, true, false);
    GameInstance.GetStatusEffectSystem(this.m_gameInstance).RemoveStatusEffect(this.m_owner.GetEntityID(), t"BaseStatusEffect.ColdBlood");
    GameInstance.GetStatusEffectSystem(this.m_gameInstance).ApplyStatusEffect(this.m_owner.GetEntityID(), t"BaseStatusEffect.PlayerInvulnerable");
    GameInstance.GetStatusEffectSystem(this.m_gameInstance).ApplyStatusEffect(this.m_owner.GetEntityID(), t"BaseStatusEffect.BloodswellPerkCooldown");
  }
}
