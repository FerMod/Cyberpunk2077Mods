
public class ConvertDamageToDoTEffector extends ModifyAttackEffector {

  public let m_DamageToDoTConversion: Float;

  public let m_DotDistributionTime: Float;

  public let m_statMod: ref<gameConstantStatModifierData>;

  public let m_ownerID: EntityID;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_DamageToDoTConversion = TweakDBInterface.GetFloat(record + t".damageConversion", 0.00);
    this.m_DotDistributionTime = TweakDBInterface.GetFloat(record + t".dotDistributionTime", 5.00);
    this.m_statMod = RPGManager.CreateStatModifier(gamedataStatType.AccumulatedDoTDecayRate, gameStatModifierType.Additive, 0.00) as gameConstantStatModifierData;
  }

  protected func Uninitialize(game: GameInstance) -> Void {
    let statSystem: ref<StatsSystem>;
    if IsDefined(this.m_statMod) {
      statSystem = GameInstance.GetStatsSystem(game);
      statSystem.RemoveModifier(Cast<StatsObjectID>(this.m_ownerID), this.m_statMod);
    };
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    this.ProcessAction(owner);
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    this.ProcessAction(owner);
  }

  private final func ProcessAction(owner: ref<GameObject>) -> Void {
    let dotDmgToApply: Float;
    let poolSys: ref<StatPoolsSystem>;
    let statSystem: ref<StatsSystem>;
    let tmpValue: Float;
    let hitEvent: ref<gameHitEvent> = this.GetHitEvent();
    if !IsDefined(hitEvent) {
      return;
    };
    if AttackData.IsDoT(hitEvent.attackData) {
      return;
    };
    tmpValue = hitEvent.attackComputed.GetTotalAttackValue(gamedataStatPoolType.Health);
    dotDmgToApply = tmpValue / (1.00 - this.m_DamageToDoTConversion) - tmpValue;
    if dotDmgToApply > 0.00 {
      this.m_ownerID = owner.GetEntityID();
      poolSys = GameInstance.GetStatPoolsSystem(owner.GetGame());
      tmpValue = poolSys.GetStatPoolValue(Cast<StatsObjectID>(this.m_ownerID), gamedataStatPoolType.AccumulatedDoT, false);
      poolSys.RequestChangingStatPoolValue(Cast<StatsObjectID>(this.m_ownerID), gamedataStatPoolType.AccumulatedDoT, dotDmgToApply, owner, false, false);
      statSystem = GameInstance.GetStatsSystem(owner.GetGame());
      statSystem.RemoveModifier(Cast<StatsObjectID>(this.m_ownerID), this.m_statMod);
      this.m_statMod.value = (tmpValue + dotDmgToApply) / this.m_DotDistributionTime;
      statSystem.AddModifier(Cast<StatsObjectID>(this.m_ownerID), this.m_statMod);
    };
  }
}
