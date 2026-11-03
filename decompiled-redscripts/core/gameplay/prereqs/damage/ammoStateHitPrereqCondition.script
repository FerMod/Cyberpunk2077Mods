
public class AmmoStateHitPrereqCondition extends BaseHitPrereqCondition {

  public let m_valueToListen: EMagazineAmmoState;

  public let m_ratio: Float;

  public let m_comparisonType: EComparisonType;

  public func SetData(recordID: TweakDBID) -> Void {
    let str: String = TweakDBInterface.GetString(recordID + t".ammoState", "");
    this.m_valueToListen = IntEnum<EMagazineAmmoState>(Cast<Int32>(EnumValueFromString("EMagazineAmmoState", str)));
    this.m_ratio = TweakDBInterface.GetFloat(recordID + t".ratioToCompare", 0.00);
    this.m_ratio = ClampF(this.m_ratio, 0.00, 1.00);
    str = TweakDBInterface.GetString(recordID + t".comparisonType", "");
    this.m_comparisonType = IntEnum<EComparisonType>(Cast<Int32>(EnumValueFromString("EComparisonType", str)));
    super.SetData(recordID);
  }

  public func Evaluate(hitEvent: ref<gameHitEvent>) -> Bool {
    let currentAmmo: Uint32;
    let maxAmmo: Uint32;
    let result: Bool;
    let weapon: wref<WeaponObject> = hitEvent.attackData.GetWeapon();
    if IsDefined(weapon) {
      currentAmmo = WeaponObject.GetMagazineAmmoCount(weapon);
    };
    switch this.m_valueToListen {
      case EMagazineAmmoState.FirstBullet:
        maxAmmo = WeaponObject.GetMagazineCapacity(weapon);
        result = currentAmmo >= maxAmmo - 1u;
        break;
      case EMagazineAmmoState.LastBullet:
        result = currentAmmo <= 0u;
        break;
      case EMagazineAmmoState.None:
        maxAmmo = WeaponObject.GetMagazineCapacity(weapon);
        result = ProcessCompare(this.m_comparisonType, Cast<Float>(currentAmmo) / Cast<Float>(maxAmmo), this.m_ratio);
        break;
      default:
        return false;
    };
    if result {
      result = this.CheckOnlyOncePerShot(hitEvent);
    };
    return this.m_invert ? !result : result;
  }
}
