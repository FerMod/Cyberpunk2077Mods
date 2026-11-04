module SelfDestructVehicle

// True once the self-destruct sequence has been triggered for this vehicle.
@addField(VehicleObject)
private let m_selfDestructTriggered: Bool = false;

// Cached settings ref.
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
        vehicle.TrySelfDestruct(this.m_selfDestructSettings.selfDestructDelay);
      }
    }
  }

  return wrappedMethod(action, consumer);
}

// ---- Warning sound + delayed explosion ----
@addMethod(VehicleObject)
public final func TrySelfDestruct(delay: Float) -> Void {
  if this.IsDestroyed() {
    return;
  }
  if !this.IsPlayerDriver() {
    return;
  }
  if this.m_selfDestructTriggered {
    return;
  }

  this.m_selfDestructTriggered = true;

  GameInstance
    .GetAudioSystem(this.GetGame())
    .PlayOnEmitter(
      n"v_car_explosion_warning_start",
      this.GetEntityID(),
      n"vehicle_engine_emitter"
    );

  GameInstance
    .GetDelaySystem(this.GetGame())
    .DelayEvent(this, new VehicleExplodeEvent(), delay);
}

