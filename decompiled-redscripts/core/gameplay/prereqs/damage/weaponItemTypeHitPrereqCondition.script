
public class WeaponItemTypeHitPrereqCondition extends BaseHitPrereqCondition {

  public let m_itemType: gamedataItemType;

  public func SetData(recordID: TweakDBID) -> Void {
    let str: String = TweakDBInterface.GetString(recordID + t".weaponItemType", "");
    this.m_itemType = IntEnum<gamedataItemType>(Cast<Int32>(EnumValueFromString("gamedataItemType", str)));
    super.SetData(recordID);
  }

  public func Evaluate(hitEvent: ref<gameHitEvent>) -> Bool {
    let itemType: gamedataItemType;
    let result: Bool;
    let objectToCheck: wref<WeaponObject> = hitEvent.attackData.GetWeapon();
    if IsDefined(objectToCheck) {
      itemType = WeaponObject.GetWeaponType(objectToCheck.GetItemID());
      result = Equals(itemType, this.m_itemType);
      if result {
        result = this.CheckOnlyOncePerShot(hitEvent);
      };
      return this.m_invert ? !result : result;
    };
    return false;
  }
}
