
public static func GetIgnoredVisionBlockerTypes(game: GameInstance, objID: StatsObjectID) -> VisionBlockerTypeFlags {
  let flags: VisionBlockerTypeFlags;
  let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(game);
  if statsSystem.GetStatBoolValue(objID, gamedataStatType.CanSeeThroughSmoke) {
    VisionBlockerTypeFlags.SetType(flags, EVisionBlockerType.Smoke, true);
  };
  if statsSystem.GetStatBoolValue(objID, gamedataStatType.CanSeeThroughOpticalCamos) {
    VisionBlockerTypeFlags.SetType(flags, EVisionBlockerType.OpticalCamo, true);
    VisionBlockerTypeFlags.SetType(flags, EVisionBlockerType.OpticalCamoLegendary, true);
  };
  return flags;
}
