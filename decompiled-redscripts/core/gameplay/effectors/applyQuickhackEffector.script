
public abstract class AbstractApplyQuickhackEffector extends ModifyAttackEffector {

  protected let m_blackboard: wref<IBlackboard>;

  @default(AbstractApplyQuickhackEffector, 0.1f)
  protected let m_applyQuickhackDelayConst: Float;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    let blackboardSystem: ref<BlackboardSystem> = GameInstance.GetBlackboardSystem(game);
    this.m_blackboard = blackboardSystem.GetLocalInstanced(GetPlayer(game).GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    this.ProcessAction(owner);
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    this.ProcessAction(owner);
  }

  protected final func ProcessAction(owner: ref<GameObject>) -> Void {
    let hitAttackData: ref<AttackData>;
    let playerOwnerPuppet: ref<PlayerPuppet>;
    let targetScriptedPuppet: ref<ScriptedPuppet>;
    let hitEvent: ref<gameHitEvent> = this.GetHitEvent();
    if !IsDefined(hitEvent) {
      return;
    };
    hitAttackData = hitEvent.attackData;
    playerOwnerPuppet = hitAttackData.GetInstigator() as PlayerPuppet;
    targetScriptedPuppet = hitEvent.target as ScriptedPuppet;
    return this.ProcessApplyQuickhackAction(hitEvent, playerOwnerPuppet, targetScriptedPuppet);
  }

  protected func ProcessApplyQuickhackAction(hitEvent: ref<gameHitEvent>, playerPuppet: ref<PlayerPuppet>, targetScriptedPuppet: ref<ScriptedPuppet>) -> Void;

  public final func TriggerSpecialQuickHackAttack(playerOwnerPuppet: ref<PlayerPuppet>, quickhackData: ref<QuickhackData>, applyQuickhackDelay: Float) -> Void {
    let quickhackActionID: TweakDBID;
    let specialQuickhackTriggeredEvent: ref<OnSpecialQuickhackTriggeredEvent>;
    if quickhackData == null {
      return;
    };
    specialQuickhackTriggeredEvent = new OnSpecialQuickhackTriggeredEvent();
    specialQuickhackTriggeredEvent.quickhackData = quickhackData;
    quickhackActionID = quickhackData.m_action.GetObjectActionID();
    this.m_blackboard.SetVariant(GetAllBlackboardDefs().PlayerStateMachine.CostFreeActionID, ToVariant(quickhackActionID));
    GameInstance.GetDelaySystem(playerOwnerPuppet.GetGame()).DelayEvent(playerOwnerPuppet, specialQuickhackTriggeredEvent, applyQuickhackDelay);
  }
}

public class ApplyQuickhackEffector extends AbstractApplyQuickhackEffector {

  public let m_quickhackObjectActionID: TweakDBID;

  public let m_quickhackObjectActionRecord: wref<ObjectAction_Record>;

  public let m_MaxUploadChance: Float;

  public let m_uploadTime: Float;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    super.Initialize(record, game, parentRecord);
    this.m_quickhackObjectActionID = TDB.GetForeignKey(record + t".objectAction");
    this.m_quickhackObjectActionRecord = TweakDBInterface.GetObjectActionRecord(this.m_quickhackObjectActionID);
    this.m_MaxUploadChance = TDB.GetFloat(record + t".uploadChance");
    this.m_uploadTime = TDB.GetFloat(record + t".uploadTime");
  }

  protected func ProcessApplyQuickhackAction(hitEvent: ref<gameHitEvent>, playerPuppet: ref<PlayerPuppet>, targetScriptedPuppet: ref<ScriptedPuppet>) -> Void {
    let playerFreeCostActionIDName: TweakDBID;
    let quickhackData: ref<QuickhackData>;
    let randomUploadChanceValue: Float = RandF();
    if randomUploadChanceValue > this.m_MaxUploadChance {
      return;
    };
    playerFreeCostActionIDName = FromVariant<TweakDBID>(this.m_blackboard.GetVariant(GetAllBlackboardDefs().PlayerStateMachine.CostFreeActionID));
    quickhackData = RPGManager.CreateSimpleQuickhackData(playerPuppet, targetScriptedPuppet, this.m_quickhackObjectActionRecord);
    if !IsDefined(quickhackData) || TDBID.IsValid(playerFreeCostActionIDName) {
      return;
    };
    quickhackData.m_uploadTime = this.m_uploadTime == 0.00 ? quickhackData.m_uploadTime : this.m_uploadTime;
    this.TriggerSpecialQuickHackAttack(playerPuppet, quickhackData, this.m_applyQuickhackDelayConst);
  }
}
