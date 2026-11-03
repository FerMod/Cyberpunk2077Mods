
public class DistrictPrereq extends IScriptablePrereq {

  private let m_district: wref<District_Record>;

  protected func Initialize(recordID: TweakDBID) -> Void {
    let record: ref<DistrictPrereq_Record> = TweakDBInterface.GetDistrictPrereqRecord(recordID);
    this.m_district = record.District();
  }

  public const func IsFulfilled(game: GameInstance, context: ref<IScriptable>) -> Bool {
    let ps: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(game).Get(n"PreventionSystem") as PreventionSystem;
    return ps.GetCurrentDistrict().GetDistrictID() == this.m_district.GetRecordID();
  }
}
