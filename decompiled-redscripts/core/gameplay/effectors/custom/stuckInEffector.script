
public class StuckInEffector extends ContinuousEffector {

  public let m_maxEnemyDistance: Float;

  public let m_enemyCount: Int32;

  public let m_statusEffectID: TweakDBID;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_maxEnemyDistance = TweakDBInterface.GetFloat(record + t".maxEnemyDistance", 4.00);
    this.m_statusEffectID = TDB.GetForeignKey(record + t".statusEffect");
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    this.ProcessAction(owner);
  }

  protected func ActionOff(owner: ref<GameObject>) -> Void {
    GameInstance.GetStatusEffectSystem(owner.GetGame()).RemoveStatusEffect(owner.GetEntityID(), this.m_statusEffectID, Cast<Uint32>(this.m_enemyCount));
  }

  protected func ContinuousAction(owner: ref<GameObject>, instigator: ref<GameObject>) -> Void {
    this.ProcessAction(owner);
  }

  private final func ProcessAction(owner: ref<GameObject>) -> Void {
    let enemyPartInfoArray: array<TS_TargetPartInfo>;
    let enemySearchQuery: TargetSearchQuery;
    let newEnemyCount: Int32;
    let stackDiff: Int32;
    enemySearchQuery.testedSet = TargetingSet.Complete;
    enemySearchQuery.searchFilter = TSF_And(TSF_All(IntEnum<TSFMV>(174146)), TSF_Not(TSFMV.Obj_Player));
    enemySearchQuery.includeSecondaryTargets = false;
    enemySearchQuery.maxDistance = this.m_maxEnemyDistance;
    enemySearchQuery.filterObjectByDistance = true;
    GameInstance.GetTargetingSystem(owner.GetGame()).GetTargetParts(owner, enemySearchQuery, enemyPartInfoArray);
    newEnemyCount = ArraySize(enemyPartInfoArray);
    if newEnemyCount == this.m_enemyCount {
      return;
    };
    stackDiff = newEnemyCount - this.m_enemyCount;
    this.m_enemyCount = newEnemyCount;
    if stackDiff > 0 {
      GameInstance.GetStatusEffectSystem(owner.GetGame()).ApplyStatusEffect(owner.GetEntityID(), this.m_statusEffectID, TDBID.None(), owner.GetEntityID(), Cast<Uint32>(stackDiff), Vector4.EmptyVector(), false);
    } else {
      GameInstance.GetStatusEffectSystem(owner.GetGame()).RemoveStatusEffect(owner.GetEntityID(), this.m_statusEffectID, Cast<Uint32>(Abs(stackDiff)));
    };
  }
}
