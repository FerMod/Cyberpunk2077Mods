
public class ICECounterHackEffector extends Effector {

  public let m_quickhackObjectActionID: TweakDBID;

  public let m_quickhackObjectActionRecord: wref<ObjectAction_Record>;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_quickhackObjectActionID = TDB.GetForeignKey(record + t".objectAction");
    this.m_quickhackObjectActionRecord = TweakDBInterface.GetObjectActionRecord(this.m_quickhackObjectActionID);
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    let evt: ref<HackTargetEvent> = new HackTargetEvent();
    let player: wref<GameObject> = GameInstance.GetPlayerSystem(owner.GetGame()).GetLocalPlayerMainGameObject();
    evt.targetID = player.GetEntityID();
    evt.netrunnerID = owner.GetEntityID();
    evt.objectRecord = this.m_quickhackObjectActionRecord;
    evt.settings.HUDData.type = SimpleMessageType.Boss;
    evt.settings.showDirectionalIndicator = false;
    if !GameInstance.GetStatusEffectSystem(owner.GetGame()).HasStatusEffect(evt.targetID, t"AIQuickHackStatusEffect.BeingHacked") {
      player.QueueEvent(evt);
    };
  }
}
