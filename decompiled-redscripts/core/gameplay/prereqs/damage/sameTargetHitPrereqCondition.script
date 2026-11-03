
public class SameTargetHitPrereqCondition extends BaseHitPrereqCondition {

  public let m_previousTarget: wref<GameObject>;

  public let m_previousSource: wref<GameObject>;

  public let m_previousWeapon: wref<WeaponObject>;

  public func Evaluate(hitEvent: ref<gameHitEvent>) -> Bool {
    let checkPassed: Bool;
    let attackType: gamedataAttackType = hitEvent.attackData.GetAttackType();
    if !hitEvent.target.IsActive() && NotEquals(attackType, gamedataAttackType.Effect) {
      return true;
    };
    if (!IsDefined(this.m_previousTarget) || !IsDefined(this.m_previousSource) || !IsDefined(this.m_previousWeapon)) && NotEquals(attackType, gamedataAttackType.Effect) {
      this.m_previousTarget = hitEvent.target;
      this.m_previousSource = hitEvent.attackData.GetSource();
      this.m_previousWeapon = hitEvent.attackData.GetWeapon();
      return false;
    };
    checkPassed = this.m_previousTarget == hitEvent.target && this.m_previousSource == hitEvent.attackData.GetSource() && this.m_previousWeapon == hitEvent.attackData.GetWeapon();
    if !checkPassed && NotEquals(attackType, gamedataAttackType.Effect) {
      this.m_previousTarget = hitEvent.target;
      this.m_previousSource = hitEvent.attackData.GetSource();
      this.m_previousWeapon = hitEvent.attackData.GetWeapon();
    };
    if checkPassed && NotEquals(attackType, gamedataAttackType.Effect) {
      checkPassed = this.CheckOnlyOncePerShot(hitEvent);
    };
    return this.m_invert ? !checkPassed : checkPassed;
  }
}
