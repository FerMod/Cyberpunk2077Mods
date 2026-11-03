
public static func DebugNPCs_NonExec(const gi: GameInstance, opt durationStr: String, opt radiusStr: String, opt moveWithPlayerStr: String) -> Void {
  let gameEffectInstance: ref<EffectInstance>;
  let infiniteDuration: Bool;
  let durationFloat: Float = StringToFloat(durationStr);
  let radius: Float = StringToFloat(radiusStr);
  let moveWithPlayer: Bool = StringToBool(moveWithPlayerStr);
  let player: ref<PlayerPuppet> = GetPlayer(gi);
  if FloatIsEqual(radius, 0.00) {
    radius = 20.00;
  };
  if durationFloat < 0.00 {
    SetFactValue(gi, n"cheat_vdb_const", 0);
    GetPlayer(gi).DEBUG_Visualizer.ClearPuppetVisualization();
  } else {
    if moveWithPlayer {
      SetFactValue(gi, n"cheat_vdb_const", 1);
      gameEffectInstance = GameInstance.GetGameEffectSystem(gi).CreateEffectStatic(n"debugStrike", n"vdb_sphere_constant", GetPlayer(gi));
      EffectData.SetBool(gameEffectInstance.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.infiniteDuration, true);
      EffectData.SetVector(gameEffectInstance.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.position, player.GetWorldPosition());
      EffectData.SetFloat(gameEffectInstance.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.radius, radius);
      gameEffectInstance.Run();
    } else {
      infiniteDuration = FloatIsEqual(durationFloat, 0.00);
      gameEffectInstance = GameInstance.GetGameEffectSystem(gi).CreateEffectStatic(n"debugStrike", n"vdb_sphere", GetPlayer(gi));
      EffectData.SetFloat(gameEffectInstance.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.duration, durationFloat);
      EffectData.SetBool(gameEffectInstance.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.infiniteDuration, infiniteDuration);
      EffectData.SetVector(gameEffectInstance.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.position, player.GetWorldPosition());
      EffectData.SetFloat(gameEffectInstance.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.radius, radius);
      gameEffectInstance.Run();
    };
  };
}

public static func ModifierTypeToString(type: gameStatModifierType) -> String {
  let modifierType: String;
  if EnumInt(type) == 0 {
    modifierType = "Additive";
  } else {
    if EnumInt(type) == 1 {
      modifierType = "AdditiveMultiplier";
    } else {
      if EnumInt(type) == 2 {
        modifierType = "Multiplier";
      } else {
        modifierType = "Invalid";
      };
    };
  };
  return modifierType;
}

public static func Debug_WeaponSpread_Set(gameInstance: GameInstance, useCircularDistribution: Bool, useEvenDistribution: Bool, rowCount: Int32, projectilesPerShot: Int32) -> Void {
  let bbSystem: ref<BlackboardSystem> = GameInstance.GetBlackboardSystem(gameInstance);
  let debugBB: ref<IBlackboard> = bbSystem.Get(GetAllBlackboardDefs().DebugData);
  debugBB.SetBool(GetAllBlackboardDefs().DebugData.WeaponSpread_UseEvenDistribution, useEvenDistribution);
  debugBB.SetBool(GetAllBlackboardDefs().DebugData.WeaponSpread_UseCircularSpread, useCircularDistribution);
  debugBB.SetInt(GetAllBlackboardDefs().DebugData.WeaponSpread_EvenDistributionRowCount, rowCount);
  debugBB.SetInt(GetAllBlackboardDefs().DebugData.WeaponSpread_ProjectilesPerShot, projectilesPerShot);
}
