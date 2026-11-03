
public class TriggerAttackByChanceStatListener extends ScriptStatsListener {

  public let m_effector: wref<TriggerAttackByChanceEffector>;

  public func OnStatChanged(ownerID: StatsObjectID, statType: gamedataStatType, diff: Float, total: Float) -> Void {
    this.m_effector.m_statBasedChance = total;
  }
}

public class TriggerAttackByChanceEffector extends Effector {

  protected let m_attackTDBID: TweakDBID;

  protected let m_selfStatusEffectID: TweakDBID;

  protected let m_chance: Float;

  @default(TriggerAttackByChanceEffector, gamedataStatType.Invalid)
  protected let m_statType: gamedataStatType;

  private let m_ownerID: EntityID;

  private let m_statListener: ref<TriggerAttackByChanceStatListener>;

  public let m_statBasedChance: Float;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    let effectorRecord: ref<TriggerAttackEffector_Record> = TweakDBInterface.GetTriggerAttackEffectorRecord(record);
    this.m_attackTDBID = effectorRecord.AttackRecord().GetID();
    this.m_chance = TDB.GetFloat(record + t".chance");
    let statRecord: ref<Stat_Record> = TweakDBInterface.GetStatRecord(TDB.GetForeignKey(record + t".statForChance"));
    this.m_selfStatusEffectID = TDB.GetForeignKey(record + t".selfStatusEffect");
    if IsDefined(statRecord) {
      this.m_statType = statRecord.StatType();
    };
  }

  protected func Uninitialize(game: GameInstance) -> Void {
    this.UninitializeStatListener(game);
  }

  private final func InitializeStatListener(owner: ref<GameObject>) -> Void {
    let statsSystem: ref<StatsSystem>;
    if !IsDefined(this.m_statListener) {
      this.m_ownerID = owner.GetEntityID();
      this.m_statListener = new TriggerAttackByChanceStatListener();
      this.m_statListener.m_effector = this;
      this.m_statListener.SetStatType(this.m_statType);
      statsSystem = GameInstance.GetStatsSystem(owner.GetGame());
      statsSystem.RegisterListener(Cast<StatsObjectID>(this.m_ownerID), this.m_statListener);
      this.m_statBasedChance = statsSystem.GetStatValue(Cast<StatsObjectID>(this.m_ownerID), this.m_statType);
    };
  }

  private final func UninitializeStatListener(game: GameInstance) -> Void {
    if IsDefined(this.m_statListener) {
      GameInstance.GetStatsSystem(game).UnregisterListener(Cast<StatsObjectID>(this.m_ownerID), this.m_statListener);
      this.m_statListener = null;
    };
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    this.ActionOn(owner);
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    let attack: ref<Attack_GameEffect>;
    let chanceToCheck: Float;
    let flag: SHitFlag;
    let hitFlags: array<SHitFlag>;
    let i: Int32;
    let rand: Float;
    let tempArr: array<String>;
    if NotEquals(this.m_statType, gamedataStatType.Invalid) {
      this.InitializeStatListener(owner);
      chanceToCheck = this.m_statBasedChance;
    } else {
      chanceToCheck = this.m_chance;
    };
    rand = RandF();
    if chanceToCheck >= rand {
      tempArr = TweakDBInterface.GetAttackRecord(this.m_attackTDBID).HitFlags();
      i = 0;
      while i < ArraySize(tempArr) {
        flag.flag = IntEnum<hitFlag>(Cast<Int32>(EnumValueFromString("hitFlag", tempArr[i])));
        flag.source = n"Attack";
        ArrayPush(hitFlags, flag);
        i += 1;
      };
      attack = RPGManager.PrepareGameEffectAttack(owner.GetGame(), owner, owner, this.m_attackTDBID, hitFlags, owner);
      attack.StartAttack();
      if TDBID.IsValid(this.m_selfStatusEffectID) {
        GameInstance.GetStatusEffectSystem(owner.GetGame()).ApplyStatusEffect(owner.GetEntityID(), this.m_selfStatusEffectID);
      };
    };
  }
}
