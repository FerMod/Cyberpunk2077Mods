
public class WeaponTypeHitPrereqCondition extends BaseHitPrereqCondition {

  public let m_type: CName;

  public func SetData(recordID: TweakDBID) -> Void {
    this.m_type = TweakDBInterface.GetCName(recordID + t".weaponType", n"None");
    super.SetData(recordID);
  }

  public func Evaluate(hitEvent: ref<gameHitEvent>) -> Bool {
    let result: Bool;
    let objectToCheck: wref<WeaponObject> = hitEvent.attackData.GetWeapon();
    if IsDefined(objectToCheck) {
      switch this.m_type {
        case n"Melee":
          result = objectToCheck.IsMelee();
          break;
        case n"Ranged":
          result = objectToCheck.IsRanged();
          break;
        case n"Shotgun":
          result = objectToCheck.IsShotgun();
          break;
        default:
          return false;
      };
      if result {
        result = this.CheckOnlyOncePerShot(hitEvent);
      };
      return this.m_invert ? !result : result;
    };
    return false;
  }
}
