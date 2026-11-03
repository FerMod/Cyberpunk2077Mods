
public class ModifyStatPoolValueEffector extends HitEventEffector {

  public let m_statPoolUpdates: [wref<StatPoolUpdate_Record>];

  public let m_usePercent: Bool;

  public let m_applicationTarget: CName;

  public let m_setValue: Bool;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    let statPoolrecord: ref<ModifyStatPoolValueEffector_Record> = TweakDBInterface.GetModifyStatPoolValueEffectorRecord(record);
    statPoolrecord.StatPoolUpdates(this.m_statPoolUpdates);
    this.m_usePercent = statPoolrecord.UsePercent();
    this.m_applicationTarget = statPoolrecord.ApplicationTarget();
    this.m_setValue = statPoolrecord.SetValue();
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    this.ProcessEffector(owner);
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    this.ProcessEffector(owner);
  }

  protected final func ProcessEffector(owner: ref<GameObject>) -> Void {
    let applicationTargetID: EntityID;
    let i: Int32;
    let poolSys: ref<StatPoolsSystem>;
    let statPoolType: gamedataStatPoolType;
    let statPoolValue: Float;
    if !this.GetApplicationTarget(owner, this.m_applicationTarget, applicationTargetID) {
      return;
    };
    poolSys = GameInstance.GetStatPoolsSystem(owner.GetGame());
    i = 0;
    while i < ArraySize(this.m_statPoolUpdates) {
      statPoolType = this.m_statPoolUpdates[i].StatPoolType().StatPoolType();
      statPoolValue = this.GetStatPoolValue(owner, this.m_statPoolUpdates[i], applicationTargetID);
      if this.m_setValue {
        poolSys.RequestSettingStatPoolValue(Cast<StatsObjectID>(applicationTargetID), statPoolType, statPoolValue, owner, this.m_usePercent);
      } else {
        poolSys.RequestChangingStatPoolValue(Cast<StatsObjectID>(applicationTargetID), statPoolType, statPoolValue, owner, false, this.m_usePercent);
      };
      i += 1;
    };
  }

  protected func GetStatPoolValue(owner: ref<GameObject>, record: wref<StatPoolUpdate_Record>, applicationTargetID: EntityID) -> Float {
    let statModifiers: array<wref<StatModifier_Record>>;
    let statPoolValue: Float = record.StatPoolValue();
    if record.GetStatModifiersCount() > 0 {
      ArrayClear(statModifiers);
      record.StatModifiers(statModifiers);
      statPoolValue = GameInstance.GetStatsSystem(owner.GetGame()).CalculateModifierListValue(Cast<StatsObjectID>(applicationTargetID), statModifiers);
    };
    return statPoolValue;
  }
}

public class ModifyStatPoolValuePerHitEffector extends ModifyStatPoolValueEffector {

  public let m_damageScaleFactor: Float;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    super.Initialize(record, game, parentRecord);
    this.m_damageScaleFactor = TweakDBInterface.GetFloat(record + t".damageScaleFactor", 0.00);
  }

  protected func GetStatPoolValue(owner: ref<GameObject>, record: wref<StatPoolUpdate_Record>, applicationTargetID: EntityID) -> Float {
    let targetMaxHealth: Float;
    let totalAttackPerc: Float;
    let totalAttackValue: Float;
    let statPoolValue: Float = super.GetStatPoolValue(owner, record, applicationTargetID);
    let hitEvent: ref<gameHitEvent> = this.GetHitEvent();
    if IsDefined(hitEvent) {
      totalAttackValue = hitEvent.attackComputed.GetTotalAttackValue(gamedataStatPoolType.Health);
      targetMaxHealth = GameInstance.GetStatPoolsSystem(owner.GetGame()).GetStatPoolMaxPointValue(Cast<StatsObjectID>(hitEvent.target.GetEntityID()), gamedataStatPoolType.Health);
      totalAttackPerc = (100.00 * totalAttackValue) / targetMaxHealth;
      statPoolValue += totalAttackPerc * this.m_damageScaleFactor;
    };
    return statPoolValue;
  }
}
