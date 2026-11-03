
public class SetAttackHitTypeEffector extends ModifyAttackEffector {

  public let m_hitType: gameuiHitType;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_hitType = IntEnum<gameuiHitType>(Cast<Int32>(EnumValueFromName(n"gameuiHitType", TweakDBInterface.GetSetAttackHitTypeEffectorRecord(record).HitType())));
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    let hitEvent: ref<gameHitEvent> = this.GetHitEvent();
    if !IsDefined(hitEvent) {
      return;
    };
    hitEvent.attackData.SetHitType(this.m_hitType);
  }
}
