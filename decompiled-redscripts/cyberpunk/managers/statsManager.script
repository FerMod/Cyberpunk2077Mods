
public class StatsManager extends IScriptable {

  public let m_playerGodModeModifierData: ref<gameStatModifierData>;

  public final static func GetObjectDPS(obj: ref<GameObject>) -> DPSPackage {
    let dmgVal: Float;
    let newPackage: DPSPackage;
    let objectID: StatsObjectID = Cast<StatsObjectID>(obj.GetEntityID());
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(obj.GetGame());
    let i: Int32 = 0;
    while i < 4 {
      dmgVal = statsSystem.GetStatValue(objectID, statsSystem.GetStatType(IntEnum<gamedataDamageType>(i)));
      if dmgVal > 0.00 {
        newPackage.value = dmgVal;
        newPackage.type = IntEnum<gamedataDamageType>(i);
        return newPackage;
      };
      i += 1;
    };
    return newPackage;
  }
}
