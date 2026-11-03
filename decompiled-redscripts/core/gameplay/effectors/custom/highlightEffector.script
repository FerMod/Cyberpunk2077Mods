
public class HighlightEffector extends ContinuousEffector {

  protected let m_owner: wref<GameObject>;

  protected let m_maxDistance: Float;

  protected let m_effectDuraton: Float;

  protected let m_highlightVisible: Bool;

  protected let m_searchFilter: CName;

  protected let m_targetingSet: CName;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_maxDistance = TDB.GetFloat(record + t".maxDistance");
    this.m_effectDuraton = TDB.GetFloat(record + t".delayTime") + 0.10;
    this.m_highlightVisible = TDB.GetBool(record + t".highlightVisible");
    this.m_searchFilter = TDB.GetCName(record + t".searchFilter");
    this.m_targetingSet = TweakDBInterface.GetCName(record + t".targetingSet", n"Frustum");
  }

  protected func ContinuousAction(owner: ref<GameObject>, instigator: ref<GameObject>) -> Void {
    this.m_owner = owner;
    this.ProcessEffector();
  }

  protected final func ProcessEffector() -> Void {
    let searchQuery: TargetSearchQuery;
    switch this.m_searchFilter {
      case n"TechPreviewNPC":
        searchQuery.searchFilter = TSF_And(TSF_Not(TSFMV.Att_Friendly), TSF_Any(IntEnum<TSFMV>(576)), TSF_All(IntEnum<TSFMV>(174082)));
        break;
      case n"Device":
        searchQuery.searchFilter = TSF_And(TSF_All(TSFMV.Obj_Device), TSF_All(TSFMV.St_AliveAndActive), TSF_Any(IntEnum<TSFMV>(576)));
        break;
      case n"Sensor":
        searchQuery.searchFilter = TSF_Any(TSFMV.Obj_Sensor);
        break;
      case n"AccessPoint":
        searchQuery.searchFilter = TSF_Any(TSFMV.Obj_Device);
        break;
      default:
        searchQuery.searchFilter = TSF_EnemyNPC();
    };
    searchQuery.testedSet = IntEnum<TargetingSet>(Cast<Int32>(EnumValueFromName(n"TargetingSet", this.m_targetingSet)));
    searchQuery.includeSecondaryTargets = false;
    searchQuery.maxDistance = this.m_maxDistance;
    searchQuery.filterObjectByDistance = true;
    this.ProcessHighlight(searchQuery);
  }

  private func ProcessHighlight(searchQuery: TargetSearchQuery) -> Void {
    this.RevealAllObjects(this.m_owner, searchQuery);
  }

  protected final func RevealAllObjects(owner: ref<GameObject>, query: TargetSearchQuery) -> Void {
    let i: Int32;
    let size: Int32;
    let target: ref<GameObject>;
    let targets: array<TS_TargetPartInfo>;
    let onlyAP: Bool = Equals(this.m_searchFilter, n"AccessPoint");
    GameInstance.GetTargetingSystem(owner.GetGame()).GetTargetParts(owner, query, targets);
    size = ArraySize(targets);
    i = 0;
    while i < size {
      target = TS_TargetPartInfo.GetComponent(targets[i]).GetEntity() as GameObject;
      if IsDefined(target) && (this.m_highlightVisible || !GameInstance.GetTargetingSystem(owner.GetGame()).IsVisibleTarget(owner, target)) {
        if onlyAP && !target.IsAccessPoint() {
        } else {
          this.RevealObject(owner, target, true, this.m_effectDuraton);
        };
      };
      i += 1;
    };
  }

  protected final func RevealObject(owner: wref<GameObject>, object: wref<GameObject>, reveal: Bool, lifetime: Float) -> Void {
    let puppet: ref<ScriptedPuppet>;
    let revealEvt: ref<RevealObjectEvent>;
    if !IsDefined(object) {
      return;
    };
    puppet = object as ScriptedPuppet;
    if IsDefined(puppet) {
      if puppet.IsBoss() || Equals(puppet.GetNPCType(), gamedataNPCType.Cerberus) || Equals(puppet.GetNPCType(), gamedataNPCType.Chimera) {
        return;
      };
    };
    revealEvt = new RevealObjectEvent();
    revealEvt.reveal = reveal;
    revealEvt.reason.reason = n"highlightEffector";
    revealEvt.reason.sourceEntityId = owner.GetEntityID();
    revealEvt.lifetime = lifetime;
    object.QueueEvent(revealEvt);
  }
}
