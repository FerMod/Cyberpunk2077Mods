
public class BaseHitPrereqCondition extends IScriptable {

  public let m_invert: Bool;

  public let m_onlyOncePerShot: Bool;

  public let m_lastAttackTime: Float;

  public func SetData(recordID: TweakDBID) -> Void {
    this.m_invert = TweakDBInterface.GetBool(recordID + t".invert", false);
    this.m_onlyOncePerShot = TweakDBInterface.GetBool(recordID + t".onlyOncePerShot", false);
  }

  public func Evaluate(hitEvent: ref<gameHitEvent>) -> Bool {
    return false;
  }

  public func OnMissTriggered(missEvent: ref<gameMissEvent>) -> Void;

  protected final func GetObjectToCheck(obj: CName, hitEvent: ref<gameHitEvent>) -> wref<GameObject> {
    switch obj {
      case n"Instigator":
        return hitEvent.attackData.GetInstigator();
      case n"Source":
        return hitEvent.attackData.GetSource();
      case n"Target":
        return hitEvent.target;
      case n"Weapon":
        return hitEvent.attackData.GetWeapon();
      default:
        return null;
    };
  }

  protected final func CheckOnlyOncePerShot(hitEvent: ref<gameHitEvent>) -> Bool {
    let attackTime: Float;
    if !this.m_onlyOncePerShot {
      return true;
    };
    attackTime = hitEvent.attackData.GetAttackTime();
    if attackTime > this.m_lastAttackTime {
      this.m_lastAttackTime = attackTime;
      return true;
    };
    return false;
  }
}
