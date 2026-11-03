
public class PreventionAgents extends IScriptable {

  private let m_groupName: CName;

  private let m_requsteredAgents: [ref<SPreventionAgentData>];

  public final func CreateGroup(groupName: CName, ps: wref<PersistentState>) -> Void {
    this.m_groupName = groupName;
    this.AddAgent(ps);
  }

  public final const func GetGroupName() -> CName {
    return this.m_groupName;
  }

  public final const func GetAgentsNumber() -> Int32 {
    return ArraySize(this.m_requsteredAgents);
  }

  public final const func GetAgetntByIndex(index: Int32) -> wref<PersistentState> {
    return this.m_requsteredAgents[index].ps;
  }

  public final const func IsAgentalreadyAdded(ps: wref<PersistentState>) -> Bool {
    let i: Int32 = 0;
    while i < ArraySize(this.m_requsteredAgents) {
      if Equals(this.m_requsteredAgents[i].ps.GetID(), ps.GetID()) {
        return true;
      };
      i += 1;
    };
    return false;
  }

  public final const func HasAgents() -> Bool {
    return ArraySize(this.m_requsteredAgents) > 0;
  }

  public final func AddAgent(ps: wref<PersistentState>) -> Void {
    let newData: ref<SPreventionAgentData> = new SPreventionAgentData();
    newData.ps = ps;
    ArrayPush(this.m_requsteredAgents, newData);
  }

  public final func RemoveAgent(ps: wref<PersistentState>) -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.m_requsteredAgents) {
      if Equals(this.m_requsteredAgents[i].ps.GetID(), ps.GetID()) {
        ArrayErase(this.m_requsteredAgents, i);
        break;
      };
      i += 1;
    };
  }
}
