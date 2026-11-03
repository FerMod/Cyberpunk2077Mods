
public class WeaponEvolutionHitPrereqCondition extends BaseHitPrereqCondition {

  public let m_weaponEvolution: gamedataWeaponEvolution;

  public func SetData(recordID: TweakDBID) -> Void {
    let str: String = TweakDBInterface.GetString(recordID + t".weaponEvolution", "");
    let result: gamedataWeaponEvolution = IntEnum<gamedataWeaponEvolution>(Cast<Int32>(EnumValueFromString("gamedataWeaponEvolution", str)));
    if EnumInt(result) < 0 {
      this.m_weaponEvolution = gamedataWeaponEvolution.Invalid;
    } else {
      this.m_weaponEvolution = result;
    };
    super.SetData(recordID);
  }

  public func Evaluate(hitEvent: ref<gameHitEvent>) -> Bool {
    let evolution: gamedataWeaponEvolution;
    let result: Bool;
    let objectToCheck: wref<WeaponObject> = hitEvent.attackData.GetWeapon();
    if IsDefined(objectToCheck) {
      evolution = RPGManager.GetWeaponEvolution(objectToCheck.GetItemID());
      result = Equals(evolution, this.m_weaponEvolution);
      if result {
        result = this.CheckOnlyOncePerShot(hitEvent);
      };
      return this.m_invert ? !result : result;
    };
    return false;
  }
}
