
public class ModifyStatPoolCustomLimitEffector extends Effector {

  public let m_statPoolType: gamedataStatPoolType;

  public let m_value: Float;

  public let m_usePercent: Bool;

  public let m_previousLimit: Float;

  public let m_owner: wref<GameObject>;

  protected func Initialize(recordID: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    let record: ref<ModifyStatPoolCustomLimitEffector_Record> = TweakDBInterface.GetModifyStatPoolCustomLimitEffectorRecord(recordID);
    this.m_statPoolType = record.StatPoolType().StatPoolType();
    this.m_value = record.Value();
    this.m_usePercent = record.UsePercent();
  }

  protected func Uninitialize(game: GameInstance) -> Void {
    this.UninitializeEffector(game);
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    this.ProcessEffector(owner);
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    this.ProcessEffector(owner);
  }

  protected func ActionOff(owner: ref<GameObject>) -> Void {
    this.UninitializeEffector(owner.GetGame());
  }

  private final func ProcessEffector(owner: ref<GameObject>) -> Void {
    let statPoolsSystem: ref<StatPoolsSystem> = GameInstance.GetStatPoolsSystem(owner.GetGame());
    this.m_owner = owner;
    this.m_previousLimit = statPoolsSystem.GetStatPoolValueCustomLimit(Cast<StatsObjectID>(owner.GetEntityID()), this.m_statPoolType, true);
    statPoolsSystem.RequestSettingStatPoolValueCustomLimit(Cast<StatsObjectID>(owner.GetEntityID()), this.m_statPoolType, this.m_value, owner, this.m_usePercent);
  }

  private final func UninitializeEffector(game: GameInstance) -> Void {
    let statPoolsSystem: ref<StatPoolsSystem> = GameInstance.GetStatPoolsSystem(game);
    if IsDefined(this.m_owner) {
      statPoolsSystem.RequestSettingStatPoolValueCustomLimit(Cast<StatsObjectID>(this.m_owner.GetEntityID()), this.m_statPoolType, this.m_previousLimit, this.m_owner, this.m_usePercent);
    };
  }
}
