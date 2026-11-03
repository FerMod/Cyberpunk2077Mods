
public native class MechanicalImpactComponent extends IComponent {

  @default(MechanicalImpactComponent, 10000.f)
  private let c_impulseMagThreshold: Float;

  protected cb func OnMechanicalComponentImpactEvent(evt: ref<MechanicalComponentImpactEvent>) -> Bool {
    let filteredImpactPoint: ImpactPointData;
    let filteredInstigator: ref<GameObject>;
    let otherVehicleObject: ref<VehicleObject> = evt.otherEntity as VehicleObject;
    if IsDefined(otherVehicleObject) && this.FilterOutVehicleImpact(evt.impactPoints, otherVehicleObject, filteredImpactPoint, filteredInstigator) {
      this.ProcessVehicleImpact(otherVehicleObject, filteredInstigator, filteredImpactPoint);
    };
  }

  private final func FilterOutVehicleImpact(const impactPoints: script_ref<[ImpactPointData]>, const vehicleObject: ref<VehicleObject>, outImpactPoint: script_ref<ImpactPointData>, outInstigator: script_ref<ref<GameObject>>) -> Bool {
    let currentImpactPoint: ImpactPointData;
    let i: Int32;
    let instigator: ref<GameObject>;
    let ownerPuppet: ref<NPCPuppet> = this.GetEntity() as NPCPuppet;
    if !IsDefined(ownerPuppet) {
      return false;
    };
    instigator = VehicleComponent.GetDriver(ownerPuppet.GetGame(), vehicleObject, vehicleObject.GetEntityID());
    if vehicleObject.IsVehicleAccelerateQuickhackActive() {
      instigator = GameInstance.GetPlayerSystem(ownerPuppet.GetGame()).GetLocalPlayerControlledGameObject();
    };
    if !instigator.IsPlayerControlled() {
      return false;
    };
    i = 0;
    while i < ArraySize(Deref(impactPoints)) {
      currentImpactPoint = Deref(impactPoints)[i];
      if currentImpactPoint.impulseMagnitude < this.c_impulseMagThreshold {
      } else {
        outImpactPoint = currentImpactPoint;
        outInstigator = instigator;
        return true;
      };
      i += 1;
    };
    return false;
  }

  private final func ProcessVehicleImpact(vehicleObject: ref<VehicleObject>, const instigator: wref<GameObject>, const impactPoint: script_ref<ImpactPointData>) -> Void {
    let vehicleHitEvent: ref<gameVehicleHitEvent>;
    let ownerPuppet: ref<NPCPuppet> = this.GetEntity() as NPCPuppet;
    if !IsDefined(ownerPuppet) {
      return;
    };
    vehicleHitEvent = new gameVehicleHitEvent();
    vehicleHitEvent.preyVelocity = ownerPuppet.GetVelocity();
    vehicleHitEvent.vehicleVelocity = Deref(impactPoint).worldNormal * Vector4.Length(vehicleObject.GetLinearVelocity());
    vehicleHitEvent.target = ownerPuppet;
    vehicleHitEvent.hitPosition = WorldPosition.ToVector4(Deref(impactPoint).worldPosition);
    vehicleHitEvent.hitDirection = Deref(impactPoint).worldNormal;
    vehicleHitEvent.attackData = new AttackData();
    vehicleHitEvent.attackData.SetInstigator(instigator);
    vehicleHitEvent.attackData.SetSource(vehicleObject);
    ownerPuppet.QueueEvent(vehicleHitEvent);
  }
}
