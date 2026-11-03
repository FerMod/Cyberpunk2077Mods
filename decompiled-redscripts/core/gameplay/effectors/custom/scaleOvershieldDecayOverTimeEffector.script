
public class OvershieldMinValueListener extends ScriptStatPoolsListener {

  public let m_effector: wref<ScaleOvershieldDecayOverTimeEffector>;

  protected cb func OnStatPoolMinValueReached(value: Float) -> Bool {
    if IsDefined(this.m_effector) {
      this.m_effector.MarkForReset();
    };
  }
}

public class ScaleOvershieldDecayOverTimeEffector extends ContinuousEffector {

  public let m_effectApplied: Bool;

  public let m_decayModifier: ref<gameStatModifierData>;

  public let m_owner: wref<GameObject>;

  public let m_overshieldListener: ref<OvershieldMinValueListener>;

  public let m_delayTime: Float;

  public let m_elapsedTime: Float;

  public let m_bValue: Float;

  public let m_kInitValue: Float;

  public let m_kValue: Float;

  public let m_maxDecay: Float;

  public let m_maxValueApplied: Bool;

  public let m_markedForReset: Bool;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_effectApplied = false;
    this.m_maxValueApplied = false;
    this.m_markedForReset = false;
    this.m_elapsedTime = 0.00;
    this.m_bValue = TweakDBInterface.GetFloat(record + t".b", 2.00);
    this.m_kInitValue = TweakDBInterface.GetFloat(record + t".kInit", -1.00);
    this.m_kValue = TweakDBInterface.GetFloat(record + t".k", 2.00);
    this.m_maxDecay = TweakDBInterface.GetFloat(record + t".maxDecay", 200.00);
    this.m_delayTime = TweakDBInterface.GetFloat(record + t".delayTime", 0.50);
  }

  public final func MarkForReset() -> Void {
    this.m_markedForReset = true;
  }

  protected final func ResetDecayModifier() -> Void {
    this.RemoveModifier();
    this.m_effectApplied = false;
    this.m_maxValueApplied = false;
    this.m_markedForReset = false;
  }

  protected final func AddModifier() -> Void {
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.m_owner.GetGame());
    let decayAmount: Float = PowF(this.m_bValue, this.m_kInitValue + this.m_kValue * this.m_elapsedTime);
    if decayAmount < 1.00 {
      return;
    };
    if decayAmount >= this.m_maxDecay {
      decayAmount = this.m_maxDecay;
      this.m_maxValueApplied = true;
    };
    this.m_decayModifier = RPGManager.CreateStatModifier(gamedataStatType.OvershieldDecayRate, gameStatModifierType.Additive, decayAmount);
    statsSystem.AddModifier(Cast<StatsObjectID>(this.m_owner.GetEntityID()), this.m_decayModifier);
  }

  protected final func RemoveModifier() -> Void {
    let statsSystem: ref<StatsSystem>;
    if IsDefined(this.m_decayModifier) {
      statsSystem = GameInstance.GetStatsSystem(this.m_owner.GetGame());
      statsSystem.RemoveModifier(Cast<StatsObjectID>(this.m_owner.GetEntityID()), this.m_decayModifier);
      this.m_decayModifier = null;
    };
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    this.m_owner = owner;
    this.m_overshieldListener = new OvershieldMinValueListener();
    this.m_overshieldListener.m_effector = this;
    GameInstance.GetStatPoolsSystem(owner.GetGame()).RequestRegisteringListener(Cast<StatsObjectID>(this.m_owner.GetEntityID()), gamedataStatPoolType.Overshield, this.m_overshieldListener);
  }

  protected func ActionOff(owner: ref<GameObject>) -> Void {
    GameInstance.GetStatPoolsSystem(owner.GetGame()).RequestUnregisteringListener(Cast<StatsObjectID>(owner.GetEntityID()), gamedataStatPoolType.Overshield, this.m_overshieldListener);
    this.m_overshieldListener = null;
  }

  protected func ContinuousAction(owner: ref<GameObject>, instigator: ref<GameObject>) -> Void {
    let currentOvershieldPercent: Float;
    let overshieldThresholdPercent: Float;
    let statPoolSys: ref<StatPoolsSystem> = GameInstance.GetStatPoolsSystem(owner.GetGame());
    let statsSys: ref<StatsSystem> = GameInstance.GetStatsSystem(owner.GetGame());
    if this.m_markedForReset {
      this.ResetDecayModifier();
    };
    if statPoolSys.IsStatPoolModificationDelayed(Cast<StatsObjectID>(owner.GetEntityID()), gamedataStatPoolType.Overshield) {
      return;
    };
    overshieldThresholdPercent = statsSys.GetStatValue(Cast<StatsObjectID>(owner.GetEntityID()), gamedataStatType.OvershieldDecayStartThreshold);
    currentOvershieldPercent = statPoolSys.GetStatPoolValue(Cast<StatsObjectID>(owner.GetEntityID()), gamedataStatPoolType.Overshield);
    if this.m_effectApplied {
      if overshieldThresholdPercent >= currentOvershieldPercent {
        this.RemoveModifier();
        this.m_elapsedTime = 0.00;
        this.m_effectApplied = false;
      } else {
        if !this.m_maxValueApplied {
          this.m_elapsedTime += this.m_delayTime;
          this.RemoveModifier();
          this.AddModifier();
        };
      };
    } else {
      if currentOvershieldPercent > overshieldThresholdPercent {
        this.m_elapsedTime = 0.00;
        this.AddModifier();
        this.m_effectApplied = true;
      };
    };
  }
}
