
public class LimfaticNanoChargeSystemEffector extends ContinuousEffector {

  public let m_maxDistance: Float;

  public let m_statusEffectID: TweakDBID;

  public let m_ownerID: EntityID;

  public let m_statusEffectIsApplied: Bool;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_maxDistance = TDB.GetFloat(record + t".maxDistance");
    let statusEffectRecord: ref<StatusEffect_Record> = TweakDBInterface.GetStatusEffectRecord(TDB.GetForeignKey(record + t".statusEffect"));
    if IsDefined(statusEffectRecord) {
      this.m_statusEffectID = statusEffectRecord.GetID();
    };
  }

  protected func Uninitialize(game: GameInstance) -> Void {
    if this.m_statusEffectIsApplied {
      GameInstance.GetStatusEffectSystem(game).RemoveStatusEffect(this.m_ownerID, this.m_statusEffectID);
      this.m_statusEffectIsApplied = false;
    };
  }

  protected func ContinuousAction(owner: ref<GameObject>, instigator: ref<GameObject>) -> Void {
    this.m_ownerID = owner.GetEntityID();
    this.ProcessEffector(owner);
  }

  private final func ProcessEffector(owner: ref<GameObject>) -> Void {
    let searchQuery: TargetSearchQuery;
    let targets: array<TS_TargetPartInfo>;
    if !TDBID.IsValid(this.m_statusEffectID) {
      return;
    };
    searchQuery.testedSet = TargetingSet.Complete;
    searchQuery.searchFilter = TSF_EnemyNPC();
    searchQuery.includeSecondaryTargets = false;
    searchQuery.maxDistance = this.m_maxDistance;
    searchQuery.filterObjectByDistance = true;
    GameInstance.GetTargetingSystem(owner.GetGame()).GetTargetParts(owner, searchQuery, targets);
    if ArraySize(targets) > 0 {
      if this.m_statusEffectIsApplied {
        StatusEffectHelper.RemoveStatusEffect(owner, this.m_statusEffectID);
        this.m_statusEffectIsApplied = false;
      };
    } else {
      if !this.m_statusEffectIsApplied {
        StatusEffectHelper.ApplyStatusEffect(owner, this.m_statusEffectID);
        this.m_statusEffectIsApplied = true;
      };
    };
  }
}
