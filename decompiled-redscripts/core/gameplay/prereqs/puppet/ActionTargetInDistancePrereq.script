
public class ActionTargetInDistancePrereq extends IScriptablePrereq {

  public let m_targetRecord: wref<AIActionTarget_Record>;

  public let m_distance: Float;

  @default(ActionTargetInDistancePrereq, gamedataStatType.Invalid)
  public let m_distanceStat: gamedataStatType;

  public let m_invert: Bool;

  protected func Initialize(recordID: TweakDBID) -> Void {
    let prereqRecord: ref<ActionTargetInDistancePrereq_Record> = TweakDBInterface.GetActionTargetInDistancePrereqRecord(recordID);
    let statRecord: ref<Stat_Record> = TweakDBInterface.GetStatRecord(TDB.GetForeignKey(recordID + t".distanceStat"));
    this.m_targetRecord = prereqRecord.Target();
    this.m_distance = prereqRecord.Distance();
    if IsDefined(statRecord) {
      this.m_distanceStat = statRecord.StatType();
    };
    this.m_invert = prereqRecord.Invert();
  }

  protected const func OnApplied(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Void {
    state.OnChanged(this.IsFulfilled(game, context));
  }

  public const func IsFulfilled(game: GameInstance, context: ref<IScriptable>) -> Bool {
    let distSqr: Float;
    let maxDistance: Float;
    let ownerContext: ScriptExecutionContext;
    let player: ref<GameObject>;
    let statsSystem: ref<StatsSystem>;
    let succ: Bool;
    let targetObject: wref<GameObject>;
    let owner: wref<ScriptedPuppet> = context as ScriptedPuppet;
    if !AIHumanComponent.GetScriptContext(owner, ownerContext) {
      return this.m_invert ? true : false;
    };
    if !AIActionTarget.GetObject(ownerContext, this.m_targetRecord, targetObject) {
      return this.m_invert ? true : false;
    };
    if NotEquals(this.m_distanceStat, gamedataStatType.Invalid) {
      statsSystem = GameInstance.GetStatsSystem(owner.GetGame());
      player = GameInstance.GetPlayerSystem(owner.GetGame()).GetLocalPlayerControlledGameObject();
      maxDistance = statsSystem.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), this.m_distanceStat);
    } else {
      maxDistance = this.m_distance;
    };
    if maxDistance < 0.00 {
      return this.m_invert ? true : false;
    };
    distSqr = Vector4.DistanceSquared(owner.GetWorldPosition(), targetObject.GetWorldPosition());
    succ = distSqr < maxDistance * maxDistance;
    return this.m_invert ? !succ : succ;
  }
}
