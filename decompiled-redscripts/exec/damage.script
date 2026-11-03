
public static func SwitchPlayerImmortalityMode(const gi: GameInstance, cheat: gamecheatsystemFlag) -> Void {
  let cheatSystem: ref<DebugCheatsSystem> = GameInstance.GetDebugCheatsSystem(gi);
  let player: ref<GameObject> = GetPlayerObject(gi);
  if !IsDefined(cheatSystem) {
    return;
  };
  if cheatSystem.ToggleCheat(player, cheat) {
  };
}

public static func Kill_NonExec(const gi: GameInstance, player: ref<PlayerPuppet>) -> Void {
  let gameEffectInstance: ref<EffectInstance> = GameInstance.GetGameEffectSystem(gi).CreateEffectStatic(n"killAll", n"kill", player);
  EffectData.SetVector(gameEffectInstance.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.position, player.GetWorldPosition());
  EffectData.SetVector(gameEffectInstance.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.forward, player.GetWorldForward());
  EffectData.SetFloat(gameEffectInstance.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.range, 50.00);
  gameEffectInstance.Run();
}

public static func KillAll_NonExec(const gameInstance: GameInstance, player: ref<PlayerPuppet>, opt radiusStr: String) -> Void {
  let gameEffectInstance: ref<EffectInstance>;
  let radius: Float = StringToFloat(radiusStr);
  if FloatIsEqual(radius, 0.00) {
    radius = 20.00;
  };
  gameEffectInstance = GameInstance.GetGameEffectSystem(gameInstance).CreateEffectStatic(n"killAll", n"killAll", player);
  EffectData.SetVector(gameEffectInstance.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.position, player.GetWorldPosition());
  EffectData.SetVector(gameEffectInstance.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.forward, player.GetWorldForward());
  EffectData.SetFloat(gameEffectInstance.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.radius, radius);
  gameEffectInstance.Run();
}
