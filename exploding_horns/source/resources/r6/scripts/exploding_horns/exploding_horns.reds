module ExplodingHorns

@addField(VehicleObject)
private let m_explodingHornsExplosionQueued: Bool = false;

@addMethod(VehicleObject)
public final func ExplodeFromHornIfEnabled() -> Void {
  let settings: ref<ExplodingHornsSettings> = ExplodingHornsSettings.Get(this.GetGame());
  if !IsDefined(settings) {
    return;
  }
  if this.IsDestroyed() || this.m_explodingHornsExplosionQueued {
    return;
  }

  if !this.IsPlayerDriver() {
    return;
  }

  this.m_explodingHornsExplosionQueued = true;

  if this.IsPlayerDriver() {
    GameInstance
      .GetAudioSystem(this.GetGame())
      .PlayOnEmitter(
        n"v_car_explosion_warning_start",
        this.GetEntityID(),
        n"vehicle_engine_emitter"
      );
  }

  let explodeEvent: ref<VehicleExplodeEvent> = new VehicleExplodeEvent();
  GameInstance
    .GetDelaySystem(this.GetGame())
    .DelayEvent(this, explodeEvent, settings.playerDelay);
}

@wrapMethod(VehicleObject)
protected cb func OnTrafficAudioEvent(evt: ref<TrafficAudioEvent>) -> Bool {
  let result: Bool = wrappedMethod(evt);
  if Equals(evt.audioAction, audioTrafficVehicleAudioAction.Horn) || Equals(evt.audioAction, audioTrafficVehicleAudioAction.HornForced) {
    this.ExplodeFromHornIfEnabled();
  }
  return result;
}

@wrapMethod(VehicleComponent)
protected cb func OnVehicleHornProbEvent(evt: ref<VehicleHornProbsEvent>) -> Bool {
  let wasHornOn: Bool = this.m_hornOn;
  let result: Bool = wrappedMethod(evt);
  let vehicle: ref<VehicleObject> = this.GetVehicle();

  if !wasHornOn && this.m_hornOn && IsDefined(vehicle) {
    vehicle.ExplodeFromHornIfEnabled();
  }

  return result;
}

@wrapMethod(VehicleComponent)
private final func ToggleVehicleHorn(state: Bool, opt isPolice: Bool) -> Void {
  wrappedMethod(state, isPolice);

  let vehicle: ref<VehicleObject> = this.GetVehicle();
  if !state || !IsDefined(vehicle) || !vehicle.IsPlayerDriver() {
    return;
  }

  vehicle.ExplodeFromHornIfEnabled();
}

