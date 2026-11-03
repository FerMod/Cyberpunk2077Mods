
public class BroadcastStimEffector extends ContinuousEffector {

  public let m_stimType: gamedataStimType;

  public let m_radius: Float;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    let effectorRecord: ref<BroadcastStimEffector_Record> = TweakDBInterface.GetBroadcastStimEffectorRecord(record);
    if IsDefined(effectorRecord) {
      this.m_stimType = effectorRecord.Type().Type();
      this.m_radius = effectorRecord.Radius();
    };
  }

  protected func ContinuousAction(owner: ref<GameObject>, instigator: ref<GameObject>) -> Void {
    StimBroadcasterComponent.BroadcastStim(owner, this.m_stimType, this.m_radius);
  }
}
