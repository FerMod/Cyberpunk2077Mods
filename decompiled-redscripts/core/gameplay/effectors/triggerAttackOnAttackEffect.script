
public class TriggerAttackOnAttackEffect extends ModifyAttackEffector {

  public let m_owner: wref<GameObject>;

  public let m_attack: ref<Attack_GameEffect>;

  public let m_attackTDBID: TweakDBID;

  public let m_target: wref<GameObject>;

  public let m_attackPositionSlotName: CName;

  public let m_playerAsInstigator: Bool;

  public let m_triggerHitReaction: Bool;

  public let m_isRandom: Bool;

  public let m_applicationChance: Float;

  public let m_useHitPosition: Bool;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    let effectorRecord: ref<TriggerAttackEffector_Record> = TweakDBInterface.GetTriggerAttackEffectorRecord(record);
    this.m_attackTDBID = effectorRecord.AttackRecord().GetID();
    this.m_attackPositionSlotName = TweakDBInterface.GetCName(record + t".attackPositionSlotName", n"Chest");
    this.m_playerAsInstigator = TweakDBInterface.GetBool(record + t".playerAsInstigator", false);
    this.m_triggerHitReaction = TweakDBInterface.GetBool(record + t".triggerHitReaction", false);
    this.m_isRandom = TweakDBInterface.GetBool(record + t".isRandom", false);
    this.m_applicationChance = TweakDBInterface.GetFloat(record + t".applicationChance", 0.00);
    this.m_useHitPosition = TDB.GetBool(record + t".useHitPosition");
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    let flag: SHitFlag;
    let hitEvent: ref<gameHitEvent>;
    let hitFlags: array<SHitFlag>;
    let instigator: wref<GameObject>;
    let tempArr: array<String> = TweakDBInterface.GetAttackRecord(this.m_attackTDBID).HitFlags();
    let i: Int32 = 0;
    while i < ArraySize(tempArr) {
      flag.flag = IntEnum<hitFlag>(Cast<Int32>(EnumValueFromString("hitFlag", tempArr[i])));
      flag.source = n"Attack";
      ArrayPush(hitFlags, flag);
      i += 1;
    };
    hitEvent = this.GetHitEvent();
    if this.m_playerAsInstigator {
      instigator = GetPlayer(owner.GetGame());
    } else {
      instigator = owner;
    };
    this.m_target = hitEvent.target;
    if this.m_useHitPosition {
      this.m_attack = RPGManager.PrepareGameEffectAttack(owner.GetGame(), instigator, instigator, this.m_attackTDBID, hitEvent.hitPosition, hitFlags);
    } else {
      if !IsDefined(this.m_target) {
        return;
      };
      this.m_attack = RPGManager.PrepareGameEffectAttack(owner.GetGame(), instigator, instigator, this.m_attackTDBID, this.GetAttackPosition(this.m_target), hitFlags, this.m_target);
    };
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    let triggered: Bool = false;
    this.ActionOn(owner);
    if !this.m_isRandom || RandF() <= this.m_applicationChance {
      this.m_attack.StartAttack();
      triggered = true;
    };
    if triggered && this.m_triggerHitReaction {
      AISubActionForceHitReaction_Record_Implementation.SendForcedHitDataToAIBehavior(this.m_target, 4, 0, 3, 2, 0, 0, 0);
    };
  }

  private final func GetAttackPosition(obj: wref<GameObject>) -> Vector4 {
    let slotTransform: WorldTransform;
    let ownerLocation: Vector4 = obj.GetWorldPosition();
    let ownerPuppet: ref<ScriptedPuppet> = obj as ScriptedPuppet;
    if IsDefined(ownerPuppet.GetSlotComponent()) {
      if ownerPuppet.GetSlotComponent().GetSlotTransform(this.m_attackPositionSlotName, slotTransform) {
        ownerLocation = WorldPosition.ToVector4(WorldTransform.GetWorldPosition(slotTransform));
        return ownerLocation;
      };
    };
    return obj.GetWorldPosition();
  }
}
