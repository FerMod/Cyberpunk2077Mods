
public class MonoWireQuickHackApplyEffector extends AbstractApplyQuickhackEffector {

  public let m_hasSpreadWindowBeenOpened: Bool;

  public let m_targetsToSpreadQuickhack: [ref<MonowireSpreadableNPC>];

  public let m_timeOfPossibleSpread: Float;

  @default(MonoWireQuickHackApplyEffector, 0.1f)
  public let m_spreadWindowTime: Float;

  public let m_spreadCallbackID: DelayID;

  protected func ProcessApplyQuickhackAction(hitEvent: ref<gameHitEvent>, playerPuppet: ref<PlayerPuppet>, targetScriptedPuppet: ref<ScriptedPuppet>) -> Void {
    let hasSpreadablePerkPurchased: Bool;
    let hitAttackData: ref<AttackData> = hitEvent.attackData;
    let playerFreeCostActionIDName: TweakDBID = FromVariant<TweakDBID>(this.m_blackboard.GetVariant(GetAllBlackboardDefs().PlayerStateMachine.CostFreeActionID));
    let weaponCharge: Float = hitAttackData.GetWeaponCharge();
    if AttackData.IsStrongMelee(hitAttackData.GetAttackType()) && !TDBID.IsValid(playerFreeCostActionIDName) && weaponCharge >= 0.80 {
      this.SpawnFXs(hitEvent, targetScriptedPuppet, true);
      this.ProcessStrongAttack(playerPuppet, targetScriptedPuppet, hitAttackData.GetWeapon());
      return;
    };
    hasSpreadablePerkPurchased = RPGManager.HasStatFlag(playerPuppet, gamedataStatType.CanSpreadMonoWireQuickhack);
    if hasSpreadablePerkPurchased && AttackData.IsLightMelee(hitAttackData.GetAttackType()) {
      this.ProcessNormalAttack(playerPuppet, targetScriptedPuppet, hitAttackData.GetAttackTime(), hitEvent);
    };
  }

  public final func SpawnFXs(hitEvent: ref<gameHitEvent>, npcPuppet: ref<ScriptedPuppet>, isStrongImpact: Bool) -> Void {
    let hitShapeData: HitShapeData;
    let position: WorldPosition;
    let transform: WorldTransform;
    let effect: FxResource = isStrongImpact ? npcPuppet.GetFxResourceByKey(n"monowire_relictree_impact") : npcPuppet.GetFxResourceByKey(n"monowire_relictree_light_impact");
    if FxResource.IsValid(effect) {
      if ArraySize(hitEvent.hitRepresentationResult.hitShapes) > 0 {
        hitShapeData = hitEvent.hitRepresentationResult.hitShapes[0];
      };
      WorldPosition.SetVector4(position, hitShapeData.result.hitPositionEnter);
      WorldTransform.SetWorldPosition(transform, position);
      GameInstance.GetFxSystem(npcPuppet.GetGame()).SpawnEffect(effect, transform);
    };
  }

  private final func ProcessStrongAttack(playerOwnerPuppet: ref<PlayerPuppet>, targetScriptedPuppet: ref<ScriptedPuppet>, weaponObject: ref<WeaponObject>) -> Void {
    let monoWireQuickhackContagiousTargetCallback: ref<OnMonowireQuickhackContagiousTargetStatusAppliedCallback>;
    let quickhackUploadTime: Float;
    let monowireQuickhackData: ref<QuickhackData> = RPGManager.GetMonoWireQuickHackData(playerOwnerPuppet, targetScriptedPuppet, weaponObject);
    if !IsDefined(monowireQuickhackData) {
      return;
    };
    monowireQuickhackData.m_action.m_IsAppliedByMonowire = true;
    this.TriggerSpecialQuickHackAttack(playerOwnerPuppet, monowireQuickhackData, this.m_applyQuickhackDelayConst);
    if RPGManager.HasStatFlag(playerOwnerPuppet, gamedataStatType.CanSpreadMonoWireQuickhack) {
      quickhackUploadTime = monowireQuickhackData.m_uploadTime;
      monoWireQuickhackContagiousTargetCallback = OnMonowireQuickhackContagiousTargetStatusAppliedCallback.Create(targetScriptedPuppet);
      GameInstance.GetDelaySystem(playerOwnerPuppet.GetGame()).DelayCallback(monoWireQuickhackContagiousTargetCallback, quickhackUploadTime + this.m_applyQuickhackDelayConst);
      this.m_blackboard.SetVariant(GetAllBlackboardDefs().PlayerStateMachine.MeleeSpreadableQuickhackActionID, ToVariant(monowireQuickhackData.m_action.GetObjectActionID()));
    };
  }

  private final func ProcessNormalAttack(playerOwnerPuppet: ref<PlayerPuppet>, targetScriptedPuppet: ref<ScriptedPuppet>, attackTime: Float, hitEvent: ref<gameHitEvent>) -> Void {
    let newSpreadableNPC: ref<MonowireSpreadableNPC>;
    let onSpreadWindowCallback: ref<OnMonowireWindowToSpreadQuickhackCallback>;
    let spreadableQuickhackActionID: TweakDBID = FromVariant<TweakDBID>(this.m_blackboard.GetVariant(GetAllBlackboardDefs().PlayerStateMachine.MeleeSpreadableQuickhackActionID));
    if spreadableQuickhackActionID == TDBID.None() {
      return;
    };
    if !this.m_hasSpreadWindowBeenOpened && this.m_timeOfPossibleSpread == 0.00 {
      this.m_timeOfPossibleSpread = attackTime;
      onSpreadWindowCallback = OnMonowireWindowToSpreadQuickhackCallback.Create(this, playerOwnerPuppet);
      this.m_spreadCallbackID = GameInstance.GetDelaySystem(playerOwnerPuppet.GetGame()).DelayCallback(onSpreadWindowCallback, this.m_spreadWindowTime);
      this.m_hasSpreadWindowBeenOpened = true;
    };
    if StatusEffectSystem.ObjectHasStatusEffect(targetScriptedPuppet, t"BaseStatusEffect.MonoWireQuickhackContagiousHittableTarget") && !ScriptedPuppet.IsAlive(targetScriptedPuppet) {
      GameInstance.GetDelaySystem(playerOwnerPuppet.GetGame()).CancelCallback(this.m_spreadCallbackID);
      this.ClearSpreadAttack();
      return;
    };
    if attackTime != this.m_timeOfPossibleSpread {
      GameInstance.GetDelaySystem(playerOwnerPuppet.GetGame()).CancelCallback(this.m_spreadCallbackID);
      this.ClearSpreadAttack();
      this.ProcessNormalAttack(playerOwnerPuppet, targetScriptedPuppet, attackTime, hitEvent);
      return;
    };
    newSpreadableNPC = new MonowireSpreadableNPC();
    newSpreadableNPC.m_NPCPuppet = targetScriptedPuppet as NPCPuppet;
    newSpreadableNPC.m_HitEvent = hitEvent;
    ArrayPush(this.m_targetsToSpreadQuickhack, newSpreadableNPC);
  }

  public final func ClearSpreadAttack() -> Void {
    this.m_hasSpreadWindowBeenOpened = false;
    ArrayClear(this.m_targetsToSpreadQuickhack);
    this.m_timeOfPossibleSpread = 0.00;
  }

  protected func ActionOff(owner: ref<GameObject>) -> Void {
    this.ClearSpreadAttack();
  }
}
