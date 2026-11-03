module SelfDestructVehicle

// Sim time when the warning sound last played for this vehicle.
@addField(VehicleObject)
private let m_selfDestructWarningTime: Float;

// Cached settings ref, following the wiki pattern.
@addField(PlayerPuppet)
protected let m_selfDestructSettings: wref<SelfDestructVehicleSettings>;

// ---- Cache settings on attach, register the input action ----
@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
  let result: Bool = wrappedMethod();
  this.m_selfDestructSettings = SelfDestructVehicleSettings.Get(this.GetGame());
  this.RegisterInputListener(this, n"SelfDestructTrigger");
  return result;
}

@wrapMethod(PlayerPuppet)
protected cb func OnDetach() -> Bool {
  this.m_selfDestructSettings = null;
  return wrappedMethod();
}

// ---- Handle the trigger key ----
@wrapMethod(PlayerPuppet)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  if IsDefined(this.m_selfDestructSettings) {
    if action.IsAction(n"SelfDestructTrigger") && action.IsButtonJustPressed() {
      let vehicle: wref<VehicleObject> = this.m_mountedVehicle as VehicleObject;
      if IsDefined(vehicle) && vehicle.IsPlayerDriver() {
        vehicle.TrySelfDestruct();
      }
    }
  }

  return wrappedMethod(action, consumer);
}

// ---- Warning sound + delayed explosion ----
@addMethod(VehicleObject)
public final func TrySelfDestruct() -> Void {
  if this.IsDestroyed() || !this.IsPlayerDriver() {
    return;
  }

  let settings: ref<SelfDestructVehicleSettings> = SelfDestructVehicleSettings.Get(this.GetGame());
  if !IsDefined(settings) {
    return;
  }

  // Play the warning once per self-destruct window, not for every key press.
  let now: Float = EngineTime.ToFloat(GameInstance.GetTimeSystem(this.GetGame()).GetSimTime());
  if this.m_selfDestructWarningTime == 0.0 || now >= this.m_selfDestructWarningTime + settings.playerDelay {
    this.m_selfDestructWarningTime = now;
    GameInstance
      .GetAudioSystem(this.GetGame())
      .PlayOnEmitter(
        n"v_car_explosion_warning_start",
        this.GetEntityID(),
        n"vehicle_engine_emitter"
      );
  }

  GameInstance
    .GetDelaySystem(this.GetGame())
    .DelayEvent(this, new VehicleExplodeEvent(), settings.playerDelay);
}

