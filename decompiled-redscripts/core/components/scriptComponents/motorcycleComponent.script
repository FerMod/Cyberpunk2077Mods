
public class MotorcycleComponent extends VehicleComponent {

  protected cb func OnVehicleParkedEvent(evt: ref<VehicleParkedEvent>) -> Bool {
    if evt.park {
      this.ParkBike();
    } else {
      this.UnParkBike();
    };
  }

  protected cb func OnMountingEvent(evt: ref<MountingEvent>) -> Bool {
    super.OnMountingEvent(evt);
    this.WakeUpBike();
  }

  private final func WakeUpBike() -> Void {
    this.GetVehicle().PhysicsWakeUp();
    this.UnParkBike();
    this.PickUpBike();
  }

  protected cb func OnUnmountingEvent(evt: ref<UnmountingEvent>) -> Bool {
    super.OnUnmountingEvent(evt);
    this.StopBike();
  }

  private final func StopBike() -> Void {
    let knockOverBike: ref<KnockOverBikeEvent>;
    let currentSpeed: Float = this.GetVehicle().GetCurrentSpeed();
    if currentSpeed >= 3.00 {
      knockOverBike = new KnockOverBikeEvent();
      this.GetVehicle().QueueEvent(knockOverBike);
    } else {
      this.ParkBike();
    };
  }

  protected cb func OnRemoteControlEvent(evt: ref<VehicleRemoteControlEvent>) -> Bool {
    let playerPuppet: ref<PlayerPuppet>;
    super.OnRemoteControlEvent(evt);
    if evt.remoteControl {
      this.WakeUpBike();
      playerPuppet = GameInstance.GetPlayerSystem(this.GetVehicle().GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
      if playerPuppet.CheckIsStandingOnVehicle(this.GetVehicle().GetEntityID()) {
        this.GetVehicle().SetVehicleRemoteControlled(false, false, true);
      };
    } else {
      this.StopBike();
    };
  }

  protected cb func OnToggleBrokenTireEvent(evt: ref<VehicleToggleBrokenTireEvent>) -> Bool {
    let currentSpeed: Float;
    let recordID: TweakDBID;
    let vehicleDataPackage: wref<VehicleDataPackage_Record>;
    let vehicleRecord: ref<Vehicle_Record>;
    super.OnToggleBrokenTireEvent(evt);
    recordID = this.GetVehicle().GetRecordID();
    vehicleRecord = TweakDBInterface.GetVehicleRecord(recordID);
    vehicleDataPackage = vehicleRecord.VehDataPackage();
    currentSpeed = Vector4.Length(this.GetVehicle().GetLinearVelocity());
    if evt.tireIndex == 0u && Equals(evt.toggle, true) && currentSpeed > 5.00 {
      this.HandleBikeCollisionReaction(MinF(currentSpeed, vehicleDataPackage.KnockOffForce()) + 1.00, Vector4.Normalize(this.GetVehicle().GetLinearVelocity()));
    };
  }

  private final func ParkBike() -> Void {
    let currentTiltAngle: Float = (this.GetVehicle() as BikeObject).GetCustomTargetTilt();
    let record: wref<Vehicle_Record> = this.GetVehicle().GetRecord();
    let vehicleDataPackage: wref<VehicleDataPackage_Record> = record.VehDataPackage();
    let desiredTiltAngle: Float = vehicleDataPackage.ParkingAngle();
    if !(this.GetVehicle() as BikeObject).IsTiltControlEnabled() {
      return;
    };
    if currentTiltAngle == 0.00 && !VehicleComponent.IsVehicleOccupied(this.GetVehicle().GetGame(), this.GetVehicle()) {
      (this.GetVehicle() as BikeObject).SetCustomTargetTilt(desiredTiltAngle);
      AnimationControllerComponent.PushEvent(this.GetVehicle(), n"toPark");
      AnimationControllerComponent.PushEvent(this.GetVehicle(), n"readyModeEnd");
      this.GetVehicle().PhysicsWakeUp();
    };
  }

  private final func UnParkBike() -> Void {
    (this.GetVehicle() as BikeObject).SetCustomTargetTilt(0.00);
    AnimationControllerComponent.PushEvent(this.GetVehicle(), n"unPark");
  }

  private final func PickUpBike() -> Void {
    if !(this.GetVehicle() as BikeObject).IsTiltControlEnabled() {
      (this.GetVehicle() as BikeObject).EnableTiltControl(true);
    };
  }

  protected cb func OnKnockOverBikeEvent(evt: ref<KnockOverBikeEvent>) -> Bool {
    let bikeImpulseEvent: ref<PhysicalImpulseEvent>;
    let tempVec4: Vector4;
    if evt.forceKnockdown {
      if (this.GetVehicle() as BikeObject).IsTiltControlEnabled() {
        this.UnParkBike();
        (this.GetVehicle() as BikeObject).EnableTiltControl(false);
      };
    } else {
      if !VehicleComponent.IsVehicleOccupied(this.GetVehicle().GetGame(), this.GetVehicle()) {
        if (this.GetVehicle() as BikeObject).IsTiltControlEnabled() {
          this.UnParkBike();
          (this.GetVehicle() as BikeObject).EnableTiltControl(false);
        };
      };
    };
    if evt.applyDirectionalForce {
      bikeImpulseEvent = new PhysicalImpulseEvent();
      bikeImpulseEvent.radius = 1.00;
      tempVec4 = this.GetVehicle().GetWorldPosition();
      bikeImpulseEvent.worldPosition.X = tempVec4.X;
      bikeImpulseEvent.worldPosition.Y = tempVec4.Y;
      bikeImpulseEvent.worldPosition.Z = tempVec4.Z + 0.50;
      tempVec4 = WorldTransform.GetRight(this.GetVehicle().GetWorldTransform());
      tempVec4 *= this.GetVehicle().GetTotalMass() * 3.80;
      bikeImpulseEvent.worldImpulse = Vector4.Vector4To3(tempVec4);
      this.GetVehicle().QueueEvent(bikeImpulseEvent);
    };
  }
}
