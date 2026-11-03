
public static func ApplyStatPoolModifier(gi: GameInstance, const statPoolTypeString: script_ref<String>, rangeBegin: Float, rangeEnd: Float, startDelay: Float, valuePerSec: Float, delayOnChange: Bool, statPoolModType: gameStatPoolModificationTypes) -> Void {
  let playerID: StatsObjectID;
  let statPool: gamedataStatPoolType;
  let statPoolModifier: StatPoolModifier;
  let statPoolInt: Int32 = Cast<Int32>(EnumValueFromString("gamedataStatPoolType", statPoolTypeString));
  if statPoolInt == -1 {
    return;
  };
  playerID = Cast<StatsObjectID>(GetPlayer(gi).GetEntityID());
  statPool = IntEnum<gamedataStatPoolType>(statPoolInt);
  statPoolModifier.enabled = true;
  statPoolModifier.rangeBegin = rangeBegin;
  statPoolModifier.rangeEnd = rangeEnd;
  statPoolModifier.startDelay = startDelay;
  statPoolModifier.valuePerSec = valuePerSec;
  statPoolModifier.delayOnChange = delayOnChange;
  GameInstance.GetStatPoolsSystem(gi).RequestSettingModifier(playerID, statPool, statPoolModType, statPoolModifier);
}

public static func SetDefaultStatPoolModifiers(gi: GameInstance, const statPoolTypeString: script_ref<String>, statPoolModType: gameStatPoolModificationTypes) -> Void {
  let playerID: StatsObjectID;
  let statPool: gamedataStatPoolType;
  let statPoolInt: Int32 = Cast<Int32>(EnumValueFromString("gamedataStatPoolType", statPoolTypeString));
  if statPoolInt == -1 {
    return;
  };
  playerID = Cast<StatsObjectID>(GetPlayer(gi).GetEntityID());
  statPool = IntEnum<gamedataStatPoolType>(statPoolInt);
  GameInstance.GetStatPoolsSystem(gi).RequestResetingModifier(playerID, statPool, statPoolModType);
}
