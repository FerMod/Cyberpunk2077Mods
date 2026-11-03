
public native class gameDestructibleSpotsSystem extends worldIDestructibleSpotsSystem {

  protected cb func OnNotifyAboutFracture(localPlayerObj: wref<GameObject>, fracturePos: Vector4) -> Bool {
    let broadcaster: ref<StimBroadcasterComponent>;
    let game: GameInstance;
    let maxDistToPlayerSqr: Float = 100.00;
    let stimRange: Float = 10.00;
    if Vector4.DistanceSquared(localPlayerObj.GetWorldPosition(), fracturePos) > maxDistToPlayerSqr {
      return true;
    };
    broadcaster = localPlayerObj.GetStimBroadcasterComponent();
    if IsDefined(broadcaster) {
      game = localPlayerObj.GetGame();
      if VehicleComponent.IsMountedToVehicle(game, localPlayerObj) {
        broadcaster.TriggerSingleBroadcast(localPlayerObj, gamedataStimType.CrowdIllegalAction, stimRange);
      };
    };
    return true;
  }
}
