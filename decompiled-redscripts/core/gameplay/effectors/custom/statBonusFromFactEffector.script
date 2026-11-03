
public class StatBonusFromFactEffector extends Effector {

  public let m_applicationTarget: CName;

  public let m_stat: ref<Stat_Record>;

  public let m_bonusPerStack: Float;

  public let m_fact: CName;

  public let m_modifier: ref<gameConstantStatModifierData>;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_stat = TweakDBInterface.GetStatRecord(TweakDBInterface.GetForeignKeyDefault(record + t".targetStat"));
    this.m_bonusPerStack = TweakDBInterface.GetFloat(record + t".bonusPerStack", 0.00);
    this.m_applicationTarget = TweakDBInterface.GetCName(record + t".applicationTarget", n"None");
    this.m_fact = TweakDBInterface.GetCName(record + t".fact", n"None");
    this.m_modifier = RPGManager.CreateStatModifier(this.m_stat.StatType(), gameStatModifierType.Additive, 0.00) as gameConstantStatModifierData;
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    let stack: Int32;
    let targetID: EntityID;
    if !this.GetApplicationTarget(owner, this.m_applicationTarget, targetID) {
      return;
    };
    stack = GameInstance.GetQuestsSystem(GetGameInstance()).GetFact(this.m_fact);
    this.m_modifier.value = Cast<Float>(stack) * this.m_bonusPerStack;
    GameInstance.GetStatsSystem(owner.GetGame()).AddModifier(Cast<StatsObjectID>(targetID), this.m_modifier);
  }

  protected func ActionOff(owner: ref<GameObject>) -> Void {
    let targetID: EntityID;
    if !this.GetApplicationTarget(owner, this.m_applicationTarget, targetID) {
      return;
    };
    GameInstance.GetStatsSystem(owner.GetGame()).RemoveModifier(Cast<StatsObjectID>(targetID), this.m_modifier);
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    let stack: Int32;
    let targetID: EntityID;
    if !this.GetApplicationTarget(owner, this.m_applicationTarget, targetID) {
      return;
    };
    stack = GameInstance.GetQuestsSystem(GetGameInstance()).GetFact(this.m_fact);
    GameInstance.GetStatsSystem(owner.GetGame()).RemoveModifier(Cast<StatsObjectID>(targetID), this.m_modifier);
    this.m_modifier.value = Cast<Float>(stack) * this.m_bonusPerStack;
    GameInstance.GetStatsSystem(owner.GetGame()).AddModifier(Cast<StatsObjectID>(targetID), this.m_modifier);
  }
}
