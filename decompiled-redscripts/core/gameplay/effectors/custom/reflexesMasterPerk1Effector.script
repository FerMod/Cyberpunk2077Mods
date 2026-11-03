
public class ReflexesMasterPerk1EffectorListener extends ScriptedDamageSystemListener {

  public let m_owner: ref<ReflexesMasterPerk1Effector>;

  protected func OnHitTriggered(hitEvent: ref<gameHitEvent>) -> Void {
    this.m_owner.StoreHitEvent(hitEvent);
  }

  protected func OnMissTriggered(missEvent: ref<gameMissEvent>) -> Void {
    this.m_owner.ClearHistory();
  }

  protected func OnHitReceived(hitEvent: ref<gameHitEvent>) -> Void;

  protected func OnPipelineProcessed(hitEvent: ref<gameHitEvent>) -> Void;
}

public class ReflexesMasterPerk1Effector extends ModifyAttackEffector {

  private let m_operationType: EMathOperator;

  private let m_value: Float;

  private let m_timeOut: Float;

  private let m_damageHistory: [ref<gameHitEvent>];

  private let m_listener: ref<ReflexesMasterPerk1EffectorListener>;

  private let m_lastTargetID: EntityID;

  public final func StoreHitEvent(hitEvent: ref<gameHitEvent>) -> Void {
    let targetID: EntityID = hitEvent.target.GetEntityID();
    if hitEvent.attackData.HasFlag(hitFlag.ReflexesMasterPerk1) {
      return;
    };
    if !EntityID.IsDefined(this.m_lastTargetID) {
      this.m_lastTargetID = targetID;
    };
    if targetID != this.m_lastTargetID {
      this.ClearHistory();
    } else {
      if ArraySize(this.m_damageHistory) > 0 {
        if hitEvent.attackData.GetAttackTime() - this.m_damageHistory[ArraySize(this.m_damageHistory) - 1].attackData.GetAttackTime() > this.m_timeOut {
          this.ClearHistory();
        };
      };
    };
    this.m_lastTargetID = targetID;
    ArrayPush(this.m_damageHistory, hitEvent);
  }

  public final func ClearHistory() -> Void {
    ArrayClear(this.m_damageHistory);
  }

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    let player: ref<GameObject> = GameInstance.GetPlayerSystem(game).GetLocalPlayerControlledGameObject();
    let str: String = TweakDBInterface.GetString(record + t".operationType", "");
    this.m_operationType = IntEnum<EMathOperator>(Cast<Int32>(EnumValueFromString("EMathOperator", str)));
    this.m_value = TweakDBInterface.GetFloat(record + t".multiplier", 0.00);
    this.m_timeOut = TweakDBInterface.GetFloat(record + t".timeOut", 0.00);
    this.m_listener = new ReflexesMasterPerk1EffectorListener();
    this.m_listener.m_owner = this;
    GameInstance.GetDamageSystem(game).RegisterSyncListener(this.m_listener, player.GetEntityID(), gameDamageCallbackType.HitTriggered, gameDamagePipelineStage.Process, DMGPipelineType.Damage);
    GameInstance.GetDamageSystem(game).RegisterSyncListener(this.m_listener, player.GetEntityID(), gameDamageCallbackType.MissTriggered, gameDamagePipelineStage.Process, DMGPipelineType.Damage);
  }

  protected func Uninitialize(game: GameInstance) -> Void {
    let player: ref<GameObject> = GameInstance.GetPlayerSystem(game).GetLocalPlayerControlledGameObject();
    GameInstance.GetDamageSystem(game).UnregisterSyncListener(this.m_listener, player.GetEntityID(), gameDamageCallbackType.HitTriggered, gameDamagePipelineStage.Process, DMGPipelineType.Damage);
    GameInstance.GetDamageSystem(game).UnregisterSyncListener(this.m_listener, player.GetEntityID(), gameDamageCallbackType.MissTriggered, gameDamagePipelineStage.Process, DMGPipelineType.Damage);
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    let hitEvent: ref<gameHitEvent> = this.GetHitEvent();
    if IsDefined(hitEvent) {
      this.ModifyDamage(hitEvent, this.m_operationType, this.m_value);
    };
    this.ClearHistory();
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    let hitEvent: ref<gameHitEvent> = this.GetHitEvent();
    if IsDefined(hitEvent) {
      this.ModifyDamage(hitEvent, this.m_operationType, this.m_value);
    };
    this.ClearHistory();
  }

  protected final func ModifyDamage(hitEvent: ref<gameHitEvent>, operationType: EMathOperator, value: Float) -> Void {
    let accumulatedDamage: Float = 0.00;
    let i: Int32 = 0;
    while i < ArraySize(this.m_damageHistory) {
      accumulatedDamage += this.m_damageHistory[i].attackComputed.GetTotalAttackValue(gamedataStatPoolType.Health);
      i += 1;
    };
    accumulatedDamage = accumulatedDamage * value;
    switch operationType {
      case EMathOperator.Add:
        hitEvent.attackComputed.AddAttackValue(accumulatedDamage, gamedataDamageType.Physical);
        break;
      case EMathOperator.Subtract:
        hitEvent.attackComputed.AddAttackValue(-accumulatedDamage, gamedataDamageType.Physical);
        break;
      case EMathOperator.Multiply:
        hitEvent.attackComputed.MultAttackValue(accumulatedDamage, gamedataDamageType.Physical);
        break;
      case EMathOperator.Divide:
        hitEvent.attackComputed.MultAttackValue(1.00 / accumulatedDamage, gamedataDamageType.Physical);
        break;
      default:
        return;
    };
    hitEvent.attackData.AddFlag(hitFlag.Special, n"ReflexesMasterPerk1Effector");
    hitEvent.attackData.AddFlag(hitFlag.ReflexesMasterPerk1, n"ReflexesMasterPerk1Effector");
  }
}
