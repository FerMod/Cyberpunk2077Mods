
public native class DynamicSpawnSystem extends IDynamicSpawnSystem {

  public final native func GetNumberOfSpawnedUnits() -> Int32;

  public final native func IsEntityRegistered(id: EntityID) -> Bool;

  public final native func IsInUnmountingRange(position: Vector3) -> Bool;

  protected final func SpawnRequestFinished(requestResult: DSSSpawnRequestResult) -> Void {
    let aiInjectCombatThreatCommand: ref<AIInjectCombatThreatCommand>;
    let i: Int32;
    let nullArrayOfNames: array<CName>;
    let spawnedObject: ref<GameObject>;
    if !requestResult.success {
      return;
    };
    i = 0;
    while i < ArraySize(requestResult.spawnedObjects) {
      spawnedObject = requestResult.spawnedObjects[i];
      if !spawnedObject.IsPuppet() {
      } else {
        aiInjectCombatThreatCommand = new AIInjectCombatThreatCommand();
        aiInjectCombatThreatCommand.targetPuppetRef = CreateEntityReference("#player", nullArrayOfNames);
        aiInjectCombatThreatCommand.duration = 120.00;
        AIComponent.SendCommand(spawnedObject as ScriptedPuppet, aiInjectCombatThreatCommand);
      };
      i += 1;
    };
  }

  protected final func SpawnCallback(spawnedObject: ref<GameObject>) -> Void {
    let aiCommandEvent: ref<AICommandEvent>;
    let aiVehicleChaseCommand: ref<AIVehicleChaseCommand>;
    let wheeledObject: ref<WheeledObject>;
    let player: ref<GameObject> = GameInstance.GetPlayerSystem(GetGameInstance()).GetLocalPlayerMainGameObject();
    if !IsDefined(spawnedObject) {
      return;
    };
    if spawnedObject.IsPuppet() {
      this.ChangeAttitude(spawnedObject, player, EAIAttitude.AIA_Hostile);
    } else {
      if spawnedObject.IsVehicle() {
        aiVehicleChaseCommand = new AIVehicleChaseCommand();
        aiVehicleChaseCommand.target = player;
        aiVehicleChaseCommand.distanceMin = TweakDBInterface.GetFloat(t"DynamicSpawnSystem.dynamic_vehicles_chase_setup.distanceMin", 3.00);
        aiVehicleChaseCommand.distanceMax = TweakDBInterface.GetFloat(t"DynamicSpawnSystem.dynamic_vehicles_chase_setup.distanceMax", 10.00);
        aiVehicleChaseCommand.forcedStartSpeed = 10.00;
        aiVehicleChaseCommand.ignoreChaseVehiclesLimit = true;
        aiVehicleChaseCommand.boostDrivingStats = true;
        aiCommandEvent = new AICommandEvent();
        aiCommandEvent.command = aiVehicleChaseCommand;
        wheeledObject = spawnedObject as WheeledObject;
        wheeledObject.SetPoliceStrategyDestination(player.GetWorldPosition());
        wheeledObject.QueueEvent(aiCommandEvent);
        wheeledObject.GetAIComponent().SetInitCmd(aiVehicleChaseCommand);
      };
    };
  }

  private final func ChangeAttitude(owner: wref<GameObject>, target: wref<GameObject>, desiredAttitude: EAIAttitude) -> Void {
    let attitudeOwner: ref<AttitudeAgent>;
    let attitudeTarget: ref<AttitudeAgent>;
    if !IsDefined(owner) || !IsDefined(target) {
      return;
    };
    attitudeOwner = owner.GetAttitudeAgent();
    attitudeTarget = target.GetAttitudeAgent();
    if !IsDefined(attitudeOwner) || !IsDefined(attitudeTarget) {
      return;
    };
    attitudeOwner.SetAttitudeGroup(n"hostile");
    attitudeOwner.SetAttitudeTowards(attitudeTarget, desiredAttitude);
  }
}

public class IsNPCInCourier extends AIbehaviorconditionScript {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let dynamicSpawnSystem: ref<DynamicSpawnSystem> = GameInstance.GetDynamicSpawnSystem(ScriptExecutionContext.GetOwner(context).GetGame());
    return Cast<AIbehaviorConditionOutcomes>(dynamicSpawnSystem.IsEntityRegistered(ScriptExecutionContext.GetOwner(context).GetEntityID()));
  }
}
