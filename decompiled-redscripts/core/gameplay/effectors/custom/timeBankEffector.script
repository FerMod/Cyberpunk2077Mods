
public class TimeBankOnStatusEffectAppliedListener extends ScriptStatusEffectListener {

  public let m_effector: wref<StatusEffectBasedTimeBankEffector>;

  public func OnStatusEffectApplied(statusEffect: wref<StatusEffect_Record>) -> Void {
    if StatusEffectHelper.HasTag(statusEffect, n"PlayerCyberwareCooldown") {
      this.m_effector.EvaluateCyberwareCooldown(statusEffect.GetID());
    };
  }
}

public class StatusEffectBasedTimeBankEffector extends Effector {

  private let m_player: wref<GameObject>;

  private let m_playerEntityID: EntityID;

  private let m_statusEffectListener: ref<TimeBankOnStatusEffectAppliedListener>;

  private let m_gameInstance: GameInstance;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_gameInstance = game;
    this.m_player = GameInstance.GetPlayerSystem(this.m_gameInstance).GetLocalPlayerControlledGameObject();
    this.m_playerEntityID = this.m_player.GetEntityID();
    GameInstance.GetStatPoolsSystem(this.m_gameInstance).RequestSettingStatPoolValue(Cast<StatsObjectID>(this.m_playerEntityID), gamedataStatPoolType.TimeBank, 100.00, this.m_player);
    this.m_statusEffectListener = new TimeBankOnStatusEffectAppliedListener();
    this.m_statusEffectListener.m_effector = this;
    GameInstance.GetStatusEffectSystem(this.m_gameInstance).RegisterListener(this.m_playerEntityID, this.m_statusEffectListener);
  }

  protected func Uninitialize(game: GameInstance) -> Void {
    this.m_statusEffectListener = null;
  }

  public final func EvaluateCyberwareCooldown(statusEffectID: TweakDBID) -> Void {
    let appliedStatusEffects: array<ref<StatusEffect>>;
    let i: Int32;
    let remainingDuration: Float;
    let spawnEffectEvent: ref<entSpawnEffectEvent>;
    let timeBankVal: Float;
    if IsDefined(this.m_player) {
      GameInstance.GetStatusEffectSystem(this.m_gameInstance).GetAppliedEffectsWithID(this.m_playerEntityID, statusEffectID, appliedStatusEffects);
      i = 0;
      while i < ArraySize(appliedStatusEffects) {
        timeBankVal = GameInstance.GetStatPoolsSystem(this.m_gameInstance).GetStatPoolValue(Cast<StatsObjectID>(this.m_playerEntityID), gamedataStatPoolType.TimeBank, false);
        if timeBankVal <= 0.00 {
          return;
        };
        remainingDuration = appliedStatusEffects[i].GetRemainingDuration();
        if timeBankVal > remainingDuration {
          timeBankVal -= remainingDuration;
          remainingDuration = 0.00;
        } else {
          remainingDuration -= timeBankVal;
          timeBankVal = 0.00;
        };
        GameInstance.GetStatPoolsSystem(this.m_gameInstance).RequestSettingStatPoolValue(Cast<StatsObjectID>(this.m_playerEntityID), gamedataStatPoolType.TimeBank, timeBankVal, this.m_player, false);
        GameInstance.GetStatusEffectSystem(this.m_gameInstance).SetStatusEffectRemainingDuration(this.m_playerEntityID, statusEffectID, remainingDuration);
        spawnEffectEvent = new entSpawnEffectEvent();
        spawnEffectEvent.effectName = n"time_bank";
        this.m_player.QueueEvent(spawnEffectEvent);
        break;
      };
      i += 1;
    } else {
    };
  }
}

public class TimeBankValueListener extends ScriptStatPoolsListener {

  public let m_effector: wref<StatPoolBasedTimeBankEffector>;

  public func OnStatPoolValueChanged(oldValue: Float, newValue: Float, percToPoints: Float) -> Void {
    this.m_effector.m_TimeBankValue = newValue * percToPoints;
  }
}

public class StatPoolValueListener extends ScriptStatPoolsListener {

  public let m_effector: wref<StatPoolBasedTimeBankEffector>;

  public func OnStatPoolValueChanged(oldValue: Float, newValue: Float, percToPoints: Float) -> Void {
    if Equals(this.m_effector.m_statPoolType, gamedataStatPoolType.OpticalCamoCharges) && newValue < 1.00 && newValue > 0.00 {
      this.m_effector.EvaluateStatPoolCooldown();
    };
  }

  protected cb func OnStatPoolMinValueReached(value: Float) -> Bool {
    this.m_effector.EvaluateStatPoolCooldown();
  }
}

public class StatPoolBasedTimeBankEffector extends ContinuousEffector {

  public let m_TimeBankValue: Float;

  public let m_maxStatPoolValue: Float;

  public let m_statPoolType: gamedataStatPoolType;

  private let m_player: wref<GameObject>;

  private let m_statPoolSystem: ref<StatPoolsSystem>;

  private let m_TimeBankListener: ref<TimeBankValueListener>;

  private let m_StatPoolListener: ref<StatPoolValueListener>;

  private let m_playerEntityID: EntityID;

  private let m_gameInstance: GameInstance;

  private let m_regenMod: StatPoolModifier;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    let statPoolRecord: ref<StatPool_Record>;
    this.m_gameInstance = game;
    this.m_player = GameInstance.GetPlayerSystem(this.m_gameInstance).GetLocalPlayerControlledGameObject();
    this.m_playerEntityID = this.m_player.GetEntityID();
    this.m_statPoolSystem = GameInstance.GetStatPoolsSystem(this.m_gameInstance);
    this.m_TimeBankListener = new TimeBankValueListener();
    this.m_TimeBankListener.m_effector = this;
    this.m_statPoolSystem.RequestRegisteringListener(Cast<StatsObjectID>(this.m_playerEntityID), gamedataStatPoolType.TimeBank, this.m_TimeBankListener);
    this.m_statPoolSystem.RequestSettingStatPoolValue(Cast<StatsObjectID>(this.m_playerEntityID), gamedataStatPoolType.TimeBank, 100.00, this.m_player);
    statPoolRecord = TweakDBInterface.GetStatPoolRecord(TDB.GetForeignKey(record + t".statPoolType"));
    if IsDefined(statPoolRecord) {
      this.m_statPoolType = statPoolRecord.StatPoolType();
      this.m_StatPoolListener = new StatPoolValueListener();
      this.m_StatPoolListener.m_effector = this;
      this.m_statPoolSystem.RequestRegisteringListener(Cast<StatsObjectID>(this.m_playerEntityID), this.m_statPoolType, this.m_StatPoolListener);
    } else {
      this.m_statPoolType = gamedataStatPoolType.Invalid;
    };
  }

  protected func Uninitialize(game: GameInstance) -> Void {
    this.m_StatPoolListener = null;
    this.m_TimeBankListener = null;
  }

  protected func ContinuousAction(owner: ref<GameObject>, instigator: ref<GameObject>) -> Void {
    if this.m_maxStatPoolValue != this.m_statPoolSystem.GetStatPoolMaxPointValue(Cast<StatsObjectID>(this.m_playerEntityID), this.m_statPoolType) {
      this.m_maxStatPoolValue = this.m_statPoolSystem.GetStatPoolMaxPointValue(Cast<StatsObjectID>(this.m_playerEntityID), this.m_statPoolType);
      this.m_statPoolSystem.GetModifier(Cast<StatsObjectID>(this.m_playerEntityID), this.m_statPoolType, gameStatPoolModificationTypes.Regeneration, this.m_regenMod);
    };
    if this.m_regenMod.valuePerSec == 0.00 {
      this.m_statPoolSystem.GetModifier(Cast<StatsObjectID>(this.m_playerEntityID), this.m_statPoolType, gameStatPoolModificationTypes.Regeneration, this.m_regenMod);
    };
  }

  public final func EvaluateStatPoolCooldown() -> Void {
    let finalStatPoolValue: Float;
    let spawnEffectEvent: ref<entSpawnEffectEvent>;
    let timeBankNewVal: Float;
    if this.m_TimeBankValue <= 0.00 {
      return;
    };
    if this.m_TimeBankValue < this.m_maxStatPoolValue / this.m_regenMod.valuePerSec {
      finalStatPoolValue = this.m_TimeBankValue * this.m_regenMod.valuePerSec;
      timeBankNewVal = 0.00;
    } else {
      finalStatPoolValue = this.m_maxStatPoolValue;
      timeBankNewVal = this.m_TimeBankValue - this.m_maxStatPoolValue / this.m_regenMod.valuePerSec;
    };
    this.m_statPoolSystem.RequestSettingStatPoolValue(Cast<StatsObjectID>(this.m_playerEntityID), this.m_statPoolType, finalStatPoolValue, this.m_player, false);
    this.m_statPoolSystem.RequestSettingStatPoolValue(Cast<StatsObjectID>(this.m_playerEntityID), gamedataStatPoolType.TimeBank, timeBankNewVal, this.m_player, false);
    spawnEffectEvent = new entSpawnEffectEvent();
    spawnEffectEvent.effectName = n"time_bank";
    this.m_player.QueueEvent(spawnEffectEvent);
  }
}
