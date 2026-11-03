
public class IsNPCInPrevention extends PreventionConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    if AIBehaviorScriptBase.GetPuppet(context).IsPrevention() && !NPCManager.HasTag(ScriptExecutionContext.GetOwner(context).GetRecordID(), n"Scripted_Patrol") {
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class IsNPCInActivePoliceChase extends PreventionConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let prevSpawnSys: ref<PreventionSpawnSystem> = GameInstance.GetPreventionSpawnSystem(ScriptExecutionContext.GetOwner(context).GetGame());
    return Cast<AIbehaviorConditionOutcomes>(NPCManager.HasTag(AIBehaviorScriptBase.GetPuppet(context).GetRecordID(), n"InActivePoliceChase") && !NPCManager.HasTag(AIBehaviorScriptBase.GetPuppet(context).GetRecordID(), n"Scripted_Patrol") && (prevSpawnSys.IsEntityRegistered(ScriptExecutionContext.GetOwner(context).GetEntityID()) || AIBehaviorScriptBase.GetPuppet(context).IsCrowd()));
  }
}

public class IsNPCMaxTac extends PreventionConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(NPCManager.HasTag(AIBehaviorScriptBase.GetPuppet(context).GetRecordID(), n"MaxTac_Prevention") || NPCManager.HasTag(AIBehaviorScriptBase.GetPuppet(context).GetRecordID(), n"MaxTac_NotPrevention"));
  }
}

public class IsPreventionSystemActive extends PreventionConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let IsPreventionActive: Bool = PreventionSystem.IsChasingPlayer(ScriptExecutionContext.GetOwner(context).GetGame());
    return Cast<AIbehaviorConditionOutcomes>(IsPreventionActive);
  }
}

public class IsLastPlayerPositionEmpty extends PreventionConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let vector: Vector4 = ScriptExecutionContext.GetArgumentVector(context, n"In_LastKnownPosition");
    if Vector4.IsXYZZero(vector) {
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class MinimalDistanceToLastKnownPosition extends PreventionConditionAbstract {

  public inline edit let desiredDistanceArgument: ref<AIArgumentMapping>;

  public let desiredDistance: Float;

  public let preventionSystem: ref<PreventionSystem>;

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    this.preventionSystem = GameInstance.GetScriptableSystemsContainer(ScriptExecutionContext.GetOwner(context).GetGame()).Get(n"PreventionSystem") as PreventionSystem;
    this.desiredDistance = FromVariant<Float>(ScriptExecutionContext.GetMappingValue(context, this.desiredDistanceArgument));
    return Cast<AIbehaviorConditionOutcomes>(Vector4.Distance(ScriptExecutionContext.GetOwner(context).GetWorldPosition(), this.preventionSystem.GetLastKnownPlayerPosition()) > this.desiredDistance);
  }
}

public class HasLastKnownPositionChanged extends PreventionConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let preventionSystem: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(ScriptExecutionContext.GetOwner(context).GetGame()).Get(n"PreventionSystem") as PreventionSystem;
    let previousLastKnownPosition: Vector4 = ScriptExecutionContext.GetArgumentVector(context, n"In_LastKnownPosition");
    if Vector4.Distance(previousLastKnownPosition, preventionSystem.GetLastKnownPlayerPosition()) > 30.00 {
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class ShouldWorkSpotPoliceJoinChaseCondition extends PreventionConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let preventionSystem: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(ScriptExecutionContext.GetOwner(context).GetGame()).Get(n"PreventionSystem") as PreventionSystem;
    return Cast<AIbehaviorConditionOutcomes>(preventionSystem.ShouldWorkSpotPoliceJoinChase(ScriptExecutionContext.GetOwner(context) as ScriptedPuppet));
  }
}

public class HasDeescalatedFromCombatWithPlayer extends PreventionConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let agentRegistry: ref<PoliceAgentRegistry> = PreventionSystem.GetAgentRegistry(ScriptExecutionContext.GetOwner(context).GetGame());
    return Cast<AIbehaviorConditionOutcomes>(agentRegistry.HasPoliceRecentlyDeescalated());
  }
}

public class SetLastKnownPosition extends AIbehaviortaskScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let newVehicle: wref<VehicleObject>;
    let threatData: DroppedThreatData;
    let gi: GameInstance = ScriptExecutionContext.GetOwner(context).GetGame();
    let tte: ref<TargetTrackingExtension> = AIBehaviorScriptBase.GetPuppet(context).GetTargetTrackerComponent() as TargetTrackingExtension;
    let preventionSystem: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(gi).Get(n"PreventionSystem") as PreventionSystem;
    if VehicleComponent.GetVehicle(gi, GetPlayer(gi), newVehicle) {
      if newVehicle.GetEntityID() != preventionSystem.GetLastKnownPlayerVehicle().GetEntityID() {
        PreventionSystem.SetLastKnownPlayerVehicle(gi, newVehicle);
      };
    };
    if IsDefined(tte) {
      threatData = tte.GetRecentlyDroppedThreat();
      if IsDefined(threatData.threat) {
        if Vector4.Distance(threatData.position, preventionSystem.GetLastKnownPlayerPosition()) > 30.00 {
          PreventionSystem.SetLastKnownPlayerPosition(gi, threatData.position);
        };
      };
    };
    ScriptExecutionContext.SetArgumentVector(context, n"In_LastKnownPosition", preventionSystem.GetLastKnownPlayerPosition());
  }
}

public class SetLastPlayerPositionByDefault extends AIbehaviortaskScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let preventionSystem: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(ScriptExecutionContext.GetOwner(context).GetGame()).Get(n"PreventionSystem") as PreventionSystem;
    PreventionSystem.SetLastKnownPlayerPosition(ScriptExecutionContext.GetOwner(context).GetGame(), preventionSystem.GetPlayer().GetWorldPosition());
    ScriptExecutionContext.SetArgumentVector(context, n"Out_LastChasePosition", preventionSystem.GetLastKnownPlayerPosition());
  }
}

public class SetPoliceVehicleAsLastKnownPosition extends AIbehaviortaskScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let vehicle: wref<GameObject>;
    if !AIBehaviorScriptBase.GetAIComponent(context).GetAssignedVehicle(ScriptExecutionContext.GetOwner(context).GetGame(), vehicle) {
      return;
    };
    ScriptExecutionContext.SetArgumentVector(context, n"In_PoliceVehicleAsLKP_Failsafe", vehicle.GetWorldPosition());
  }
}

public class IsPlayerInVehicle extends PreventionConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let preventionSystem: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(ScriptExecutionContext.GetOwner(context).GetGame()).Get(n"PreventionSystem") as PreventionSystem;
    let isPlayerInVehicle: Bool = preventionSystem.GetPlayer().GetPlayerStateMachineBlackboard().GetBool(GetAllBlackboardDefs().PlayerStateMachine.MountedToVehicle);
    if isPlayerInVehicle {
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class IsPlayerFarFromLKP extends PreventionConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let preventionSystem: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(ScriptExecutionContext.GetOwner(context).GetGame()).Get(n"PreventionSystem") as PreventionSystem;
    let player: wref<PlayerPuppet> = preventionSystem.GetPlayer();
    return Cast<AIbehaviorConditionOutcomes>(Vector4.DistanceSquared(preventionSystem.GetLastKnownPlayerPosition(), player.GetWorldPosition()) > 10000.00);
  }
}

public class IsPoliceInCombatWithPlayer extends PreventionConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let agentRegistry: ref<PoliceAgentRegistry> = PreventionSystem.GetAgentRegistry(ScriptExecutionContext.GetOwner(context).GetGame());
    return Cast<AIbehaviorConditionOutcomes>(agentRegistry.IsPoliceInCombatWithPalyer());
  }
}

public class IsPoliceUnawareOfThePlayerExactLocationCondition extends PreventionConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let preventionSystem: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(ScriptExecutionContext.GetOwner(context).GetGame()).Get(n"PreventionSystem") as PreventionSystem;
    return Cast<AIbehaviorConditionOutcomes>(preventionSystem.IsPoliceUnawareOfThePlayerExactLocation());
  }
}

public class ManageSirensAndLightsInPoliceCar extends AIbehaviortaskScript {

  public inline edit let turnOnLights: ref<AIArgumentMapping>;

  public inline edit let turnOnSirens: ref<AIArgumentMapping>;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let vehicle: wref<GameObject>;
    let lights: Bool = FromVariant<Bool>(ScriptExecutionContext.GetMappingValue(context, this.turnOnLights));
    let sirens: Bool = FromVariant<Bool>(ScriptExecutionContext.GetMappingValue(context, this.turnOnSirens));
    if ScriptExecutionContext.GetOwner(context).IsPrevention() {
      if VehicleComponent.IsDriver(ScriptExecutionContext.GetOwner(context).GetGame(), ScriptExecutionContext.GetOwner(context)) && VehicleComponent.GetVehicle(ScriptExecutionContext.GetOwner(context).GetGame(), ScriptExecutionContext.GetOwner(context), vehicle) {
        (vehicle as VehicleObject).GetVehicleComponent().ToggleLightsAndSirens(lights, sirens);
      };
    };
  }
}

public class HasShootFromVehicleTicket extends PreventionConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let shootingDuration: Float;
    let shouldStartShooting: Bool;
    let vehicle: wref<VehicleObject>;
    if VehicleComponent.GetVehicle(ScriptExecutionContext.GetOwner(context).GetGame(), ScriptExecutionContext.GetOwner(context), vehicle) {
      shouldStartShooting = true;
      if shouldStartShooting {
        shootingDuration = 10.00;
        ScriptExecutionContext.SetArgumentFloat(context, n"Out_ShootFromVehicleDuration", shootingDuration);
        return Cast<AIbehaviorConditionOutcomes>(!VehicleComponent.IsDriver(ScriptExecutionContext.GetOwner(context).GetGame(), ScriptExecutionContext.GetOwner(context)));
      };
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class IsPlayerInAPoliceCarChaseCondition extends PreventionConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(PreventionSystem.IsPlayerInAPoliceCarChase(ScriptExecutionContext.GetOwner(context).GetGame()));
  }
}

public class IsNPCInVehicle extends PreventionConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(VehicleComponent.IsMountedToVehicle(ScriptExecutionContext.GetOwner(context).GetGame(), ScriptExecutionContext.GetOwner(context)));
  }
}

public class HasNPCVehicleAssigned extends PreventionConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let vehicle: wref<GameObject>;
    return Cast<AIbehaviorConditionOutcomes>(AIBehaviorScriptBase.GetAIComponent(context).GetAssignedVehicle(ScriptExecutionContext.GetOwner(context).GetGame(), vehicle));
  }
}

public class HasPlayerTakenMyVehicle extends PreventionConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let vehicle: wref<GameObject>;
    let vehicleObject: ref<VehicleObject>;
    if !AIBehaviorScriptBase.GetAIComponent(context).GetAssignedVehicle(ScriptExecutionContext.GetOwner(context).GetGame(), vehicle) {
      return AIbehaviorConditionOutcomes.False;
    };
    vehicleObject = vehicle as VehicleObject;
    if IsDefined(vehicleObject) && VehicleComponent.GetDriver(ScriptExecutionContext.GetOwner(context).GetGame(), vehicleObject, vehicle.GetEntityID()).IsPlayer() && ScriptExecutionContext.GetOwner(context).IsPrevention() {
      ScriptExecutionContext.SetArgumentScriptable(context, n"MountRequest", null);
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class NullifyMountRequestBehaviourTask extends AIVehicleTaskAbstract {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    ScriptExecutionContext.SetArgumentScriptable(context, n"MountRequest", null);
  }
}

public class TryQueueEventToMountPoliceToVehicle extends PreventionConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let av: ref<AVObject>;
    let evt: ref<AICommandEvent>;
    let mountCommand: ref<AIMountCommand>;
    let mountData: ref<MountEventData>;
    let slotName: CName;
    let vehicle: wref<GameObject>;
    let vehicleAIComponent: ref<AIVehicleAgent>;
    let vehicleID: EntityID;
    let vehicleObject: ref<WheeledObject>;
    let vehicleSlotID: MountingSlotId;
    let aiComponent: ref<AIHumanComponent> = AIBehaviorScriptBase.GetAIComponent(context);
    if !IsDefined(aiComponent) || !aiComponent.GetAssignedVehicle(ScriptExecutionContext.GetOwner(context).GetGame(), vehicle) {
      return AIbehaviorConditionOutcomes.False;
    };
    if ScriptExecutionContext.GetOwner(context).IsPrevention() && aiComponent.IsAssignedVehicleStuck() {
      return AIbehaviorConditionOutcomes.False;
    };
    if !aiComponent.GetAssignedVehicleData(vehicleID, vehicleSlotID) {
      return AIbehaviorConditionOutcomes.False;
    };
    if VehicleComponent.IsDestroyed(ScriptExecutionContext.GetOwner(context).GetGame(), vehicleID) {
      return AIbehaviorConditionOutcomes.False;
    };
    vehicleObject = vehicle as WheeledObject;
    if vehicleObject.ComputeIsVehicleUpsideDown() || vehicleObject.GetFlatTireIndex() != -1 {
      return AIbehaviorConditionOutcomes.False;
    };
    if VehicleComponent.GetDriver(ScriptExecutionContext.GetOwner(context).GetGame(), vehicleObject, vehicleID).IsPlayer() || vehicleObject.IsVehicleInsideInnerAreaOfAreaSpeedLimiter() {
      return AIbehaviorConditionOutcomes.False;
    };
    if VehicleComponent.IsDriverSeatOccupiedByDeadNPC(ScriptExecutionContext.GetOwner(context).GetGame(), vehicleID) {
      return AIbehaviorConditionOutcomes.False;
    };
    vehicleAIComponent = vehicleObject.GetAIComponent();
    if !IsDefined(vehicleAIComponent) {
      return AIbehaviorConditionOutcomes.False;
    };
    slotName = vehicleObject.GetAIComponent().TryReserveSeatOrFirstAvailable(ScriptExecutionContext.GetOwner(context).GetEntityID(), n"first_available");
    if IsNameValid(slotName) {
      aiComponent.OnSeatReserved(vehicleObject.GetEntityID());
    } else {
      return AIbehaviorConditionOutcomes.False;
    };
    av = vehicle as AVObject;
    if IsDefined(av) {
      return AIbehaviorConditionOutcomes.False;
    };
    mountData = new MountEventData();
    mountData.slotName = slotName;
    mountData.mountParentEntityId = vehicleID;
    mountData.isInstant = false;
    mountData.ignoreHLS = true;
    mountCommand = new AIMountCommand();
    mountCommand.mountData = mountData;
    evt = new AICommandEvent();
    evt.command = mountCommand;
    ScriptExecutionContext.GetOwner(context).QueueEvent(evt);
    return AIbehaviorConditionOutcomes.True;
  }
}

public class ReleaseReservedSeat extends AIbehaviortaskScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let aiComponent: ref<AIHumanComponent> = AIBehaviorScriptBase.GetAIComponent(context);
    if IsDefined(aiComponent) {
      aiComponent.ReleaseReservedSeat();
    };
  }
}

public class SetAnimsetOverrideForPassengerNPC extends AIbehaviortaskScript {

  public inline edit let IsNPCMounted: ref<AIArgumentMapping>;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let vehicle: wref<GameObject>;
    let vehicleID: EntityID;
    let vehicleSlotID: MountingSlotId;
    let IsMounted: Bool = FromVariant<Bool>(ScriptExecutionContext.GetMappingValue(context, this.IsNPCMounted));
    if !AIBehaviorScriptBase.GetAIComponent(context).GetAssignedVehicle(ScriptExecutionContext.GetOwner(context).GetGame(), vehicle) {
      return;
    };
    if !AIBehaviorScriptBase.GetAIComponent(context).GetAssignedVehicleData(vehicleID, vehicleSlotID) {
      return;
    };
    VehicleComponent.SetAnimsetOverrideForPassenger(ScriptExecutionContext.GetOwner(context), vehicleID, vehicleSlotID.id, IsMounted ? 1.00 : 0.00);
  }
}

public class CanNPCMountVehicle extends PreventionConditionAbstract {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, 1.00);
  }

  private final func CheckForPolice(context: ScriptExecutionContext) -> Bool {
    let combatSquadInterface: ref<CombatSquadScriptInterface>;
    let vehicle: wref<GameObject>;
    let vehicleID: EntityID;
    let vehicleObject: ref<VehicleObject>;
    let vehicleSlotID: MountingSlotId;
    let registry: ref<PoliceAgentRegistry> = PreventionSystem.GetAgentRegistry(ScriptExecutionContext.GetOwner(context).GetGame());
    let canPoliceMount: Bool = true;
    if !AIBehaviorScriptBase.GetAIComponent(context).GetAssignedVehicle(ScriptExecutionContext.GetOwner(context).GetGame(), vehicle) {
      canPoliceMount = false;
    };
    if !AIBehaviorScriptBase.GetAIComponent(context).GetAssignedVehicleData(vehicleID, vehicleSlotID) {
      canPoliceMount = false;
    };
    if VehicleComponent.IsDestroyed(ScriptExecutionContext.GetOwner(context).GetGame(), vehicleID) {
      canPoliceMount = false;
    };
    if VehicleComponent.IsSlotOccupied(ScriptExecutionContext.GetOwner(context).GetGame(), vehicleID, vehicleSlotID) {
      canPoliceMount = false;
    };
    vehicleObject = vehicle as VehicleObject;
    if !IsDefined(vehicleObject) || vehicleObject.IsVehicleInsideInnerAreaOfAreaSpeedLimiter() {
      canPoliceMount = false;
    };
    if VehicleComponent.GetDriver(ScriptExecutionContext.GetOwner(context).GetGame(), vehicleObject, vehicleID).IsPlayer() {
      canPoliceMount = false;
    };
    if ScriptExecutionContext.GetOwner(context).GetPreventionSystem().IsChasingPlayer() {
      if AISquadHelper.GetCombatSquadInterface(ScriptExecutionContext.GetOwner(context), combatSquadInterface) {
        if NotEquals(AIBehaviorScriptBase.GetPuppet(context).GetHighLevelStateFromBlackboard(), gamedataNPCHighLevelState.Combat) && (combatSquadInterface.GetEnemiesCount() > 0u || registry.IsPoliceInCombatWithPalyer()) {
          canPoliceMount = false;
        };
      };
    };
    if !canPoliceMount {
      VehicleComponent.SetAnimsetOverrideForPassenger(ScriptExecutionContext.GetOwner(context), vehicleID, vehicleSlotID.id, 0.00);
    };
    return canPoliceMount;
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let instantUnmount: ref<AIEvent>;
    let pss: ref<PreventionSpawnSystem> = GameInstance.GetPreventionSpawnSystem(ScriptExecutionContext.GetOwner(context).GetGame());
    if pss.IsEntityRegistered(ScriptExecutionContext.GetOwner(context).GetEntityID()) {
      if !this.CheckForPolice(context) {
        ScriptExecutionContext.SetArgumentScriptable(context, n"MountRequest", null);
        instantUnmount = new AIEvent();
        instantUnmount.name = n"InstantUnmount";
        ScriptExecutionContext.GetOwner(context).QueueEvent(instantUnmount);
        return AIbehaviorConditionOutcomes.False;
      };
    };
    return AIbehaviorConditionOutcomes.True;
  }
}

public class HasNPCReactiveSignal extends PreventionConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let instantUnmount: ref<AIEvent>;
    let signal: AIGateSignal;
    let signalId: Uint32;
    let vehicle: wref<GameObject>;
    let vehicleID: EntityID;
    let vehicleSlotID: MountingSlotId;
    let pss: ref<PreventionSpawnSystem> = GameInstance.GetPreventionSpawnSystem(ScriptExecutionContext.GetOwner(context).GetGame());
    if pss.IsEntityRegistered(ScriptExecutionContext.GetOwner(context).GetEntityID()) {
      if AIBehaviorScriptBase.GetPuppet(context).GetSignalHandlerComponent().GetHighestPrioritySignal(signal, signalId) {
        if AIGateSignal.HasTag(signal, n"reactive") {
          if AIBehaviorScriptBase.GetAIComponent(context).GetAssignedVehicle(ScriptExecutionContext.GetOwner(context).GetGame(), vehicle) {
            if AIBehaviorScriptBase.GetAIComponent(context).GetAssignedVehicleData(vehicleID, vehicleSlotID) {
              VehicleComponent.SetAnimsetOverrideForPassenger(ScriptExecutionContext.GetOwner(context), vehicleID, vehicleSlotID.id, 0.00);
            };
          };
          ScriptExecutionContext.SetArgumentScriptable(context, n"MountRequest", null);
          instantUnmount = new AIEvent();
          instantUnmount.name = n"InstantUnmount";
          ScriptExecutionContext.GetOwner(context).QueueEvent(instantUnmount);
          return AIbehaviorConditionOutcomes.True;
        };
      };
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class CanVehicleBeDriven extends PreventionConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let vehicle: wref<GameObject>;
    let vehicleID: EntityID;
    let vehicleSlotID: MountingSlotId;
    if AIBehaviorScriptBase.GetAIComponent(context).GetAssignedVehicle(ScriptExecutionContext.GetOwner(context).GetGame(), vehicle) {
      if AIBehaviorScriptBase.GetAIComponent(context).GetAssignedVehicleData(vehicleID, vehicleSlotID) {
        if !VehicleComponent.IsDriver(ScriptExecutionContext.GetOwner(context).GetGame(), ScriptExecutionContext.GetOwner(context).GetEntityID()) {
          if !IsDefined(VehicleComponent.GetDriver(ScriptExecutionContext.GetOwner(context).GetGame(), vehicle as VehicleObject, vehicleID)) || !(vehicle as VehicleObject).GetAIComponent().IsSeatReserved(n"seat_front_left") {
            return AIbehaviorConditionOutcomes.False;
          };
        };
      };
    };
    return AIbehaviorConditionOutcomes.True;
  }
}

public class JoinTrafficInPoliceVehicle extends AIVehicleTaskAbstract {

  public let m_vehicle: wref<VehicleObject>;

  public let m_panicDrivingCmd: ref<AIVehiclePanicCommand>;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let owner: ref<gamePuppet> = ScriptExecutionContext.GetOwner(context);
    let gameInstance: GameInstance = owner.GetGame();
    AIbehaviortaskScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
    if VehicleComponent.IsDriver(gameInstance, owner) {
      this.InterruptMountedVehicleDriveToPointCommand(context);
      this.InterruptMountedVehicleDriveChaseTargetCommand(context);
    };
  }

  private final func SendPanicDriveCommand(context: ScriptExecutionContext) -> Void {
    if !IsDefined(this.m_vehicle) {
      return;
    };
    this.m_panicDrivingCmd = new AIVehiclePanicCommand();
    this.m_panicDrivingCmd.allowSimplifiedMovement = true;
    this.m_panicDrivingCmd.ignoreTickets = true;
    this.m_panicDrivingCmd.useSpeedBasedLookupRange = true;
    this.SendAICommandToMountedVehicle(context, this.m_panicDrivingCmd);
  }

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let owner: ref<gamePuppet> = ScriptExecutionContext.GetOwner(context);
    let gameInstance: GameInstance = owner.GetGame();
    if IsDefined(this.m_vehicle) || VehicleComponent.GetVehicle(ScriptExecutionContext.GetOwner(context).GetGame(), ScriptExecutionContext.GetOwner(context), this.m_vehicle) {
      if this.m_vehicle.HasTrafficSlot() {
        return AIbehaviorUpdateOutcome.IN_PROGRESS;
      };
      if VehicleComponent.IsDriver(gameInstance, owner) {
        if VehicleComponent.CanBeDriven(gameInstance, owner.GetEntityID()) {
          this.SendPanicDriveCommand(context);
          GameInstance.GetPreventionSpawnSystem(ScriptExecutionContext.GetOwner(context).GetGame()).RequestDespawnVehicleAndPassengers(this.m_vehicle);
          return AIbehaviorUpdateOutcome.IN_PROGRESS;
        };
      } else {
        if !VehicleComponent.HasActiveDriverMounted(ScriptExecutionContext.GetOwner(context).GetGame(), this.m_vehicle.GetEntityID()) && !this.m_vehicle.GetAIComponent().IsSeatReserved(n"seat_front_left") {
          return AIbehaviorUpdateOutcome.FAILURE;
        };
      };
      return AIbehaviorUpdateOutcome.IN_PROGRESS;
    };
    return AIbehaviorUpdateOutcome.FAILURE;
  }

  protected func Deactivate(context: ScriptExecutionContext) -> Void {
    if IsDefined(this.m_panicDrivingCmd) {
      this.InterruptMountedVehicleCommand(context, this.m_panicDrivingCmd);
    };
  }
}

public class JoinTrafficOnFoot extends AIVehicleTaskAbstract {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviortaskScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let owner: ref<gamePuppet> = ScriptExecutionContext.GetOwner(context);
    let gameInstance: GameInstance = owner.GetGame();
    let reactionSystem: ref<ReactionSystem> = GameInstance.GetReactionSystem(gameInstance);
    let aiComp: ref<AIHumanComponent> = AIBehaviorScriptBase.GetAIComponent(context);
    if IsDefined(aiComp) {
      aiComp.ReleaseReservedSeat();
    };
    if IsDefined(reactionSystem) {
      if reactionSystem.TryAndJoinTraffic(owner, Cast<Vector3>(GetPlayer(gameInstance).GetWorldPosition()), false) {
        return AIbehaviorUpdateOutcome.SUCCESS;
      };
    };
    return AIbehaviorUpdateOutcome.FAILURE;
  }
}

public class CheckSpawningStrategy extends PreventionConditionAbstract {

  public inline edit let spawningStrategyToCompare: ref<AIArgumentMapping>;

  public let spawningStrategyToCompareAsInt: Int32;

  public let system: ref<PreventionSystem>;

  public let vehicle: wref<VehicleObject>;

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let owner: ref<gamePuppet> = ScriptExecutionContext.GetOwner(context);
    let gameInstance: GameInstance = owner.GetGame();
    this.system = GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"PreventionSystem") as PreventionSystem;
    this.spawningStrategyToCompareAsInt = FromVariant<Int32>(ScriptExecutionContext.GetMappingValue(context, this.spawningStrategyToCompare));
    if VehicleComponent.GetVehicle(owner.GetGame(), owner, this.vehicle) {
      if this.spawningStrategyToCompareAsInt == EnumInt(this.vehicle.GetPoliceStrategy()) {
        return AIbehaviorConditionOutcomes.True;
      };
      return AIbehaviorConditionOutcomes.False;
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class GetPoliceStrategyDestinationTask extends AIbehaviortaskScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let destination: Vector4;
    let vehicle: wref<WheeledObject>;
    let vehicleObject: wref<VehicleObject>;
    let owner: ref<gamePuppet> = ScriptExecutionContext.GetOwner(context);
    let gameInstance: GameInstance = owner.GetGame();
    if !VehicleComponent.GetVehicle(gameInstance, owner, vehicleObject) {
      return;
    };
    vehicle = vehicleObject as WheeledObject;
    destination = Vector4.Vector3To4(vehicle.GetPoliceStrategyDestination());
    if Vector4.IsXYZZero(destination) {
      return;
    };
    ScriptExecutionContext.SetArgumentVector(context, n"In_StrategyDestinationPosition", destination);
  }
}

public class CheckHeatStage extends PreventionConditionAbstract {

  public inline edit let heatStageToCompare: ref<AIArgumentMapping>;

  public let heatStageToCompareAsInteger: Int32;

  public let currentHeatStageAsInteger: Int32;

  public let system: ref<PreventionSystem>;

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    this.system = GameInstance.GetScriptableSystemsContainer(ScriptExecutionContext.GetOwner(context).GetGame()).Get(n"PreventionSystem") as PreventionSystem;
    this.heatStageToCompareAsInteger = FromVariant<Int32>(ScriptExecutionContext.GetMappingValue(context, this.heatStageToCompare));
    this.currentHeatStageAsInteger = EnumInt(this.system.GetHeatStage());
    if this.currentHeatStageAsInteger == this.heatStageToCompareAsInteger {
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class SetNPCSensesMainPresetPrevention extends SetNPCSensesMainPreset {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let vehicleID: EntityID;
    if NPCManager.HasTag(ScriptExecutionContext.GetOwner(context).GetRecordID(), n"Scripted_Patrol_inVehicle") && VehicleComponent.GetVehicleID(ScriptExecutionContext.GetOwner(context).GetGame(), ScriptExecutionContext.GetOwner(context), vehicleID) {
      SenseComponent.RequestMainPresetChange(ScriptExecutionContext.GetOwner(context), "Scripted_Prevention_Patrol_InVehicle");
    } else {
      SenseComponent.RequestMainPresetChange(ScriptExecutionContext.GetOwner(context), this.newSensesPresetName);
    };
  }
}

public class ShouldNPCRetreatFromMaxTacEncounter extends PreventionConditionAbstract {

  public let agentRegistry: ref<PoliceAgentRegistry>;

  public let threatLocation: TrackedLocation;

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    this.agentRegistry = PreventionSystem.GetAgentRegistry(ScriptExecutionContext.GetOwner(context).GetGame());
    let prevSys: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(ScriptExecutionContext.GetOwner(context).GetGame()).Get(n"PreventionSystem") as PreventionSystem;
    let puppet: ref<ScriptedPuppet> = AIBehaviorScriptBase.GetPuppet(context);
    if prevSys.ShouldPreventionUnitsRetreat() {
      if !puppet.IsPrevention() {
        return AIbehaviorConditionOutcomes.False;
      };
      if !this.agentRegistry.IsPoliceInCombatWithPalyer() {
        return AIbehaviorConditionOutcomes.False;
      };
      if NPCManager.HasTag(puppet.GetRecordID(), n"MaxTac_Prevention") || NPCManager.HasTag(puppet.GetRecordID(), n"MaxTac_NotPrevention") {
        return AIbehaviorConditionOutcomes.False;
      };
      if !AISquadHelper.GetThreatLocationFromSquad(puppet, GetPlayer(puppet.GetGame()), this.threatLocation) {
        return AIbehaviorConditionOutcomes.False;
      };
      if Vector4.Distance(puppet.GetWorldPosition(), this.threatLocation.lastKnown.position) > 70.00 {
        return AIbehaviorConditionOutcomes.False;
      };
      if this.agentRegistry.DistanceSquaredToTClosestMaxTacAgent(prevSys.GetPlayer().GetWorldPosition()) > 2500.00 {
        return AIbehaviorConditionOutcomes.False;
      };
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class IsAVSpawned extends PreventionConditionAbstract {

  public let agentRegistry: ref<PoliceAgentRegistry>;

  public let prevSys: ref<PreventionSystem>;

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    this.prevSys = GameInstance.GetScriptableSystemsContainer(ScriptExecutionContext.GetOwner(context).GetGame()).Get(n"PreventionSystem") as PreventionSystem;
    return Cast<AIbehaviorConditionOutcomes>(this.prevSys.ShouldPreventionUnitsRetreat());
  }
}

public class ShouldRetreatBehaviorStop extends PreventionConditionAbstract {

  public let agentRegistry: ref<PoliceAgentRegistry>;

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    this.agentRegistry = PreventionSystem.GetAgentRegistry(ScriptExecutionContext.GetOwner(context).GetGame());
    return Cast<AIbehaviorConditionOutcomes>(this.agentRegistry.GetMaxTacNPCCount() < 1 || !this.agentRegistry.IsPoliceInCombatWithPalyer() || this.agentRegistry.DistanceSquaredToTClosestMaxTacAgent(GetPlayer(ScriptExecutionContext.GetOwner(context).GetGame()).GetWorldPosition()) > 2500.00);
  }
}

public class HasVehicleAnyCommand extends PreventionConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let vehicleObject: wref<VehicleObject>;
    let owner: ref<gamePuppet> = ScriptExecutionContext.GetOwner(context);
    let gameInstance: GameInstance = owner.GetGame();
    if VehicleComponent.GetVehicle(gameInstance, owner, vehicleObject) {
      if VehicleComponent.IsExecutingAnyCommand(gameInstance, vehicleObject) {
        return AIbehaviorConditionOutcomes.True;
      };
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class IntervalCaller extends DelayCallback {

  public let m_preventionSystem: wref<PreventionSystem>;

  public let m_request: ref<ScriptableSystemRequest>;

  private let m_intervalSeconds: Float;

  private let m_selfDelayID: DelayID;

  public final static func Create(preventionSystem: wref<PreventionSystem>) -> ref<IntervalCaller> {
    let created: ref<IntervalCaller> = new IntervalCaller();
    created.m_preventionSystem = preventionSystem;
    created.m_selfDelayID = GetInvalidDelayID();
    return created;
  }

  public final func IsRunning() -> Bool {
    return this.m_selfDelayID != GetInvalidDelayID();
  }

  public final func Start(intervalSeconds: Float, request: ref<ScriptableSystemRequest>) -> Void {
    this.m_intervalSeconds = intervalSeconds;
    this.m_request = request;
    this.Cancel();
    this.StartInternal();
  }

  private final func StartInternal() -> Void {
    this.m_selfDelayID = GameInstance.GetDelaySystem(this.m_preventionSystem.GetGame()).DelayCallback(this, this.m_intervalSeconds);
  }

  public final func Cancel() -> Void {
    if !this.IsRunning() {
      return;
    };
    GameInstance.GetDelaySystem(this.m_preventionSystem.GetGame()).CancelCallback(this.m_selfDelayID);
    this.m_selfDelayID = GetInvalidDelayID();
  }

  protected func Call() -> Void {
    this.m_preventionSystem.QueueRequest(this.m_request);
    this.StartInternal();
  }
}

public class IsAssignedVehicleAV extends PreventionConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let assignedVehicleID: EntityID;
    let vehicleObject: wref<VehicleObject>;
    let puppet: ref<ScriptedPuppet> = AIBehaviorScriptBase.GetPuppet(context);
    let gameInstance: GameInstance = puppet.GetGame();
    if IsDefined(puppet) {
      assignedVehicleID = puppet.GetAIControllerComponent().GetAssignedVehicleId();
      vehicleObject = GameInstance.FindEntityByID(gameInstance, assignedVehicleID) as VehicleObject;
      if IsDefined(vehicleObject) && vehicleObject == (vehicleObject as AVObject) {
        return AIbehaviorConditionOutcomes.True;
      };
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class CanShootToTargretFromMountedGuns extends PreventionConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let targetPosition: Vector4;
    let toTargetVector: Vector4;
    let vehicleObject: wref<VehicleObject>;
    let vehiclePosition: Vector4;
    let target: wref<GameObject> = ScriptExecutionContext.GetArgumentObject(context, n"CombatTarget");
    if VehicleComponent.GetVehicle(ScriptExecutionContext.GetOwner(context).GetGame(), ScriptExecutionContext.GetOwner(context), vehicleObject) {
      targetPosition = target.GetWorldPosition();
      vehiclePosition = vehicleObject.GetWorldPosition();
      toTargetVector = targetPosition - vehiclePosition;
      if Vector4.GetAngleBetween(vehicleObject.GetWorldForward(), toTargetVector) < 30.00 {
        return AIbehaviorConditionOutcomes.True;
      };
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class VehicleHasWindowsRollDown extends PreventionConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let vehDataPackage: wref<VehicleDataPackage_Record>;
    let vehicleObject: wref<VehicleObject>;
    if VehicleComponent.GetVehicle(ScriptExecutionContext.GetOwner(context).GetGame(), ScriptExecutionContext.GetOwner(context), vehicleObject) {
      VehicleComponent.GetVehicleDataPackage(vehicleObject.GetGame(), vehicleObject, vehDataPackage);
      return Cast<AIbehaviorConditionOutcomes>(vehDataPackage.WindowsRollDown());
    };
    return AIbehaviorConditionOutcomes.False;
  }
}
