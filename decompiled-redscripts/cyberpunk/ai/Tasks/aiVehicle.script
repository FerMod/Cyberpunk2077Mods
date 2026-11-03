
public abstract class AIVehicleTaskAbstract extends AIbehaviortaskScript {

  protected final func SendAIEventToMountedVehicle(context: ScriptExecutionContext, eventName: CName) -> Bool {
    let evt: ref<AIEvent>;
    let vehicle: wref<GameObject>;
    if !IsNameValid(eventName) || !VehicleComponent.GetVehicle(ScriptExecutionContext.GetOwner(context).GetGame(), ScriptExecutionContext.GetOwner(context), vehicle) {
      return false;
    };
    evt = new AIEvent();
    evt.name = eventName;
    vehicle.QueueEvent(evt);
    return true;
  }

  protected final func SendAICommandToMountedVehicle(context: ScriptExecutionContext, command: ref<AIVehicleCommand>) -> Bool {
    let evt: ref<AICommandEvent>;
    let vehicle: wref<GameObject>;
    if !IsDefined(command) || !VehicleComponent.GetVehicle(ScriptExecutionContext.GetOwner(context).GetGame(), ScriptExecutionContext.GetOwner(context), vehicle) {
      return false;
    };
    evt = new AICommandEvent();
    evt.command = command;
    vehicle.QueueEvent(evt);
    return true;
  }

  protected final func GetMountedVehicleAIComponent(context: ScriptExecutionContext) -> ref<AIVehicleAgent> {
    let vehicle: wref<VehicleObject>;
    if !VehicleComponent.GetVehicle(ScriptExecutionContext.GetOwner(context).GetGame(), ScriptExecutionContext.GetOwner(context), vehicle) || !vehicle.IsAttached() {
      return null;
    };
    return vehicle.GetAIComponent();
  }

  protected final func InterruptMountedVehicleCommand(context: ScriptExecutionContext, command: ref<AIVehicleCommand>) -> Void {
    this.InterruptVehicleCommand(this.GetMountedVehicleAIComponent(context), command);
  }

  protected final func InterruptVehicleCommand(vehAIComponent: ref<AIComponent>, command: ref<AIVehicleCommand>) -> Void {
    if !IsDefined(command) || !IsDefined(vehAIComponent) {
      return;
    };
    if Equals(command.state, AICommandState.Executing) {
      vehAIComponent.StopExecutingCommand(command, true);
    } else {
      if Equals(command.state, AICommandState.Enqueued) {
        vehAIComponent.CancelCommand(command);
      };
    };
  }

  protected final func InterruptMountedVehicleDriveToPointCommand(context: ScriptExecutionContext) -> Void {
    let vehAIComponent: ref<AIComponent> = this.GetMountedVehicleAIComponent(context);
    if !IsDefined(vehAIComponent) {
      return;
    };
    vehAIComponent.CancelOrInterruptCommand(n"AIVehicleDriveToPointAutonomousCommand", false, true);
  }

  protected final func InterruptMountedVehicleDriveChaseTargetCommand(context: ScriptExecutionContext) -> Void {
    let vehAIComponent: ref<AIComponent> = this.GetMountedVehicleAIComponent(context);
    if !IsDefined(vehAIComponent) {
      return;
    };
    vehAIComponent.CancelOrInterruptCommand(n"AIVehicleChaseCommand", false, true);
  }
}

public class SetAnimWrappersFromMountData extends AIVehicleTaskAbstract {

  protected inline edit let m_mountData: ref<AIArgumentMapping>;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let mountData: ref<MountEventData> = ScriptExecutionContext.GetScriptableMappingValue(context, this.m_mountData) as MountEventData;
    if IsDefined(mountData) {
      VehicleComponent.SetAnimsetOverrideForPassenger(ScriptExecutionContext.GetOwner(context), mountData.mountParentEntityId, mountData.slotName, 1.00);
    };
  }
}

public class EnterVehicle extends AIVehicleTaskAbstract {

  protected func Deactivate(context: ScriptExecutionContext) -> Void {
    if VehicleComponent.IsDriver(ScriptExecutionContext.GetOwner(context).GetGame(), ScriptExecutionContext.GetOwner(context)) {
      this.SendAIEventToMountedVehicle(context, n"DriverReady");
    };
  }
}

public class ExitFromVehicle extends AIVehicleTaskAbstract {

  public edit let useFastExit: Bool;

  public edit let tryBlendToWalk: Bool;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let VehDoorRequestEvent: ref<VehicleExternalDoorRequestEvent>;
    let animName: CName;
    let intendedUnmountDirection: vehicleExitDirection;
    let isBike: Bool;
    let ownerPuppet: wref<ScriptedPuppet>;
    let unmountingEvt: ref<VehicleStartedMountingEvent>;
    let validUnmount: vehicleUnmountPosition;
    let workspotSystem: ref<WorkspotGameSystem>;
    let mountInfo: MountingInfo = GameInstance.GetMountingFacility(ScriptExecutionContext.GetOwner(context).GetGame()).GetMountingInfoSingleWithObjects(ScriptExecutionContext.GetOwner(context));
    let slotName: CName = mountInfo.slotId.id;
    let vehicle: wref<VehicleObject> = GameInstance.FindEntityByID(ScriptExecutionContext.GetOwner(context).GetGame(), mountInfo.parentId) as VehicleObject;
    if !vehicle.GetVehiclePS().IsSlotOccupiedByNPC(slotName) {
      return;
    };
    ScriptExecutionContext.SetArgumentScriptable(context, n"ActiveMountRequest", null);
    VehDoorRequestEvent = new VehicleExternalDoorRequestEvent();
    unmountingEvt = new VehicleStartedMountingEvent();
    isBike = vehicle == (vehicle as BikeObject);
    VehDoorRequestEvent.slotName = vehicle.GetBoneNameFromSlot(slotName);
    VehDoorRequestEvent.autoClose = true;
    unmountingEvt.slotID = slotName;
    unmountingEvt.isMounting = false;
    unmountingEvt.character = ScriptExecutionContext.GetOwner(context);
    workspotSystem = GameInstance.GetWorkspotSystem(ScriptExecutionContext.GetOwner(context).GetGame());
    if IsDefined(workspotSystem) {
      ownerPuppet = ScriptExecutionContext.GetOwner(context) as ScriptedPuppet;
      if this.useFastExit || vehicle.IsFlippedOver() {
        workspotSystem.SendFastExitSignal(ScriptExecutionContext.GetOwner(context), true, this.tryBlendToWalk);
      } else {
        if IsDefined(ownerPuppet) && (Equals(ownerPuppet.GetHighLevelStateFromBlackboard(), gamedataNPCHighLevelState.Combat) || Equals(ownerPuppet.GetHighLevelStateFromBlackboard(), gamedataNPCHighLevelState.Alerted)) {
          animName = n"combat";
          if isBike {
            intendedUnmountDirection = RandF() > 0.50 ? vehicleExitDirection.Right : vehicleExitDirection.Left;
            validUnmount = vehicle.CanUnmount(false, ownerPuppet, intendedUnmountDirection);
            animName = Equals(validUnmount.direction, vehicleExitDirection.Right) ? n"combat_opposite" : n"combat";
          };
          workspotSystem.UnmountFromVehicle(vehicle, ScriptExecutionContext.GetOwner(context), false, animName);
        } else {
          animName = n"default";
          if isBike {
            validUnmount = vehicle.CanUnmount(false, ownerPuppet);
            animName = Equals(validUnmount.direction, vehicleExitDirection.Right) ? n"exit_opposite" : n"default";
          };
          workspotSystem.UnmountFromVehicle(vehicle, ScriptExecutionContext.GetOwner(context), false, animName);
        };
      };
    };
    if !vehicle.IsVehicleAccelerateQuickhackActive() && VehicleComponent.IsDriver(ScriptExecutionContext.GetOwner(context).GetGame(), ScriptExecutionContext.GetOwner(context)) {
      this.SendAIEventToMountedVehicle(context, n"NoDriver");
    };
    vehicle.QueueEvent(unmountingEvt);
    vehicle.QueueEvent(VehDoorRequestEvent);
  }
}

public class ApproachVehicleDecorator extends AIVehicleTaskAbstract {

  protected inline edit let m_mountData: ref<AIArgumentMapping>;

  protected inline edit let m_mountRequest: ref<AIArgumentMapping>;

  protected inline edit let m_entryPoint: ref<AIArgumentMapping>;

  private let m_doorOpenRequestSent: Bool;

  private let m_closeDoor: Bool;

  private let mountEventData: ref<MountEventData>;

  private let mountRequestData: ref<MountEventData>;

  private let mountEntryPoint: Vector4;

  private let m_activationTime: EngineTime;

  private let m_runCompanionCheck: Bool;

  private let m_slotOccupiedTimestamp: Float;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    this.m_doorOpenRequestSent = false;
    this.m_closeDoor = false;
    this.mountEventData = ScriptExecutionContext.GetScriptableMappingValue(context, this.m_mountData) as MountEventData;
    this.mountEntryPoint = FromVariant<Vector4>(ScriptExecutionContext.GetMappingValue(context, this.m_entryPoint));
    this.m_activationTime = ScriptExecutionContext.GetAITime(context);
    this.m_runCompanionCheck = ScriptedPuppet.IsPlayerCompanion(ScriptExecutionContext.GetOwner(context));
    this.m_slotOccupiedTimestamp = -1.00;
  }

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let currentAITime: Float;
    let distToVehicle: Float;
    let seatReservationEvent: ref<VehicleSeatReservationEvent>;
    let vecToVehicle: Vector4;
    let vehicle: wref<VehicleObject>;
    let vehicleID: EntityID;
    let vehicleSlotID: MountingSlotId;
    let hls: gamedataNPCHighLevelState = AIBehaviorScriptBase.GetPuppet(context).GetHighLevelStateFromBlackboard();
    if Equals(hls, gamedataNPCHighLevelState.Alerted) && !AIBehaviorScriptBase.GetPuppet(context).IsPrevention() {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    if !IsDefined(this.mountEventData) {
      if this.m_doorOpenRequestSent {
        this.m_closeDoor = true;
      };
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    this.mountRequestData = ScriptExecutionContext.GetScriptableMappingValue(context, this.m_mountRequest) as MountEventData;
    if this.mountEventData != this.mountRequestData {
      if this.m_doorOpenRequestSent {
        this.m_closeDoor = true;
      };
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    vehicleID = this.mountEventData.mountParentEntityId;
    vehicleSlotID.id = this.mountEventData.slotName;
    if !VehicleComponent.GetVehicleFromID(ScriptExecutionContext.GetOwner(context).GetGame(), vehicleID, vehicle) {
      return AIbehaviorUpdateOutcome.IN_PROGRESS;
    };
    if vehicle.IsDestroyed() {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    if VehicleComponent.IsSlotOccupiedByOtherEntity(ScriptExecutionContext.GetOwner(context).GetGame(), vehicleID, vehicleSlotID, ScriptExecutionContext.GetOwner(context).GetEntityID()) {
      currentAITime = EngineTime.ToFloat(ScriptExecutionContext.GetAITime(context));
      if this.m_slotOccupiedTimestamp < 0.00 {
        this.m_slotOccupiedTimestamp = currentAITime;
      } else {
        if currentAITime - this.m_slotOccupiedTimestamp > 3.00 {
          ScriptExecutionContext.SetArgumentBool(context, n"AllowFailsafeTeleport", false);
          return AIbehaviorUpdateOutcome.FAILURE;
        };
      };
    } else {
      if this.m_slotOccupiedTimestamp >= 0.00 {
        this.m_slotOccupiedTimestamp = -1.00;
      };
    };
    if vehicle.GetBlackboard().GetFloat(GetAllBlackboardDefs().Vehicle.SpeedValue) > 0.50 {
      if this.m_runCompanionCheck && this.UpdateCompanionChecks(context, vehicle, 0.00) {
        ScriptExecutionContext.SetArgumentBool(context, n"_teleportAfterApproach", true);
        return AIbehaviorUpdateOutcome.SUCCESS;
      };
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    if this.m_runCompanionCheck && this.UpdateCompanionChecks(context, vehicle, 1.00) {
      ScriptExecutionContext.SetArgumentBool(context, n"_teleportAfterApproach", true);
      return AIbehaviorUpdateOutcome.SUCCESS;
    };
    if this.m_doorOpenRequestSent {
      return AIbehaviorUpdateOutcome.IN_PROGRESS;
    };
    vecToVehicle = this.mountEntryPoint - ScriptExecutionContext.GetOwner(context).GetWorldPosition();
    distToVehicle = Vector4.Length(vecToVehicle);
    if distToVehicle <= 0.10 {
      seatReservationEvent = new VehicleSeatReservationEvent();
      seatReservationEvent.slotID = vehicleSlotID.id;
      seatReservationEvent.reserve = true;
      GameInstance.GetPersistencySystem(vehicle.GetGame()).QueuePSEvent(vehicle.GetVehiclePS().GetID(), vehicle.GetPSClassName(), seatReservationEvent);
      if VehicleComponent.OpenDoor(vehicle, vehicleSlotID) {
        this.m_doorOpenRequestSent = true;
      };
    };
    return AIbehaviorUpdateOutcome.IN_PROGRESS;
  }

  private final func UpdateCompanionChecks(context: ScriptExecutionContext, ownerVehicle: wref<VehicleObject>, delay: Float) -> Bool {
    let componanion: wref<GameObject>;
    let componanionVehicle: wref<VehicleObject>;
    if ScriptedPuppet.IsPlayerCompanion(ScriptExecutionContext.GetOwner(context), componanion) && VehicleComponent.GetVehicle(ScriptExecutionContext.GetOwner(context).GetGame(), componanion, componanionVehicle) && ownerVehicle == componanionVehicle {
      if this.m_activationTime + delay <= ScriptExecutionContext.GetAITime(context) {
        return true;
      };
    } else {
      this.m_runCompanionCheck = false;
    };
    return false;
  }

  protected func Deactivate(context: ScriptExecutionContext) -> Void {
    let vehicle: wref<VehicleObject>;
    let vehicleID: EntityID;
    let vehicleSlotID: MountingSlotId;
    if !IsDefined(this.mountEventData) || !this.m_closeDoor {
      return;
    };
    vehicleID = this.mountEventData.mountParentEntityId;
    vehicleSlotID.id = this.mountEventData.slotName;
    if VehicleComponent.GetVehicleFromID(ScriptExecutionContext.GetOwner(context).GetGame(), vehicleID, vehicle) {
      VehicleComponent.CloseDoor(vehicle, vehicleSlotID);
    };
  }
}

public class SlotReservationDecorator extends AIVehicleTaskAbstract {

  protected inline edit let m_mountData: ref<AIArgumentMapping>;

  private let mountEventData: ref<MountEventData>;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    this.mountEventData = ScriptExecutionContext.GetScriptableMappingValue(context, this.m_mountData) as MountEventData;
  }

  protected func Deactivate(context: ScriptExecutionContext) -> Void {
    let seatReservationEvent: ref<VehicleSeatReservationEvent>;
    let vehicle: wref<VehicleObject>;
    let vehicleID: EntityID;
    let vehicleSlotID: MountingSlotId;
    if !IsDefined(this.mountEventData) {
      return;
    };
    vehicleID = this.mountEventData.mountParentEntityId;
    vehicleSlotID.id = this.mountEventData.slotName;
    if VehicleComponent.GetVehicleFromID(ScriptExecutionContext.GetOwner(context).GetGame(), vehicleID, vehicle) {
      seatReservationEvent = new VehicleSeatReservationEvent();
      seatReservationEvent.slotID = vehicleSlotID.id;
      seatReservationEvent.reserve = false;
      GameInstance.GetPersistencySystem(vehicle.GetGame()).QueuePSEvent(vehicle.GetVehiclePS().GetID(), vehicle.GetPSClassName(), seatReservationEvent);
    };
  }
}

public class GetOnWindowCombatDecorator extends AIVehicleTaskAbstract {

  public let windowOpenEvent: ref<VehicleExternalWindowRequestEvent>;

  public let mountInfo: MountingInfo;

  public let vehicle: wref<GameObject>;

  public let slotName: CName;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    this.mountInfo = GameInstance.GetMountingFacility(ScriptExecutionContext.GetOwner(context).GetGame()).GetMountingInfoSingleWithObjects(ScriptExecutionContext.GetOwner(context));
    this.vehicle = GameInstance.FindEntityByID(ScriptExecutionContext.GetOwner(context).GetGame(), this.mountInfo.parentId) as GameObject;
    this.slotName = this.mountInfo.slotId.id;
    this.windowOpenEvent = new VehicleExternalWindowRequestEvent();
    this.windowOpenEvent.slotName = this.slotName;
    this.windowOpenEvent.shouldOpen = true;
    this.vehicle.QueueEvent(this.windowOpenEvent);
  }
}

public class InVehicleDecorator extends AIVehicleTaskAbstract {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let activeMountRequest: ref<MountEventData>;
    let request: ref<MountEventData> = ScriptExecutionContext.GetArgumentScriptable(context, n"MountRequest") as MountEventData;
    if request != null {
      activeMountRequest = new MountEventData();
      activeMountRequest.slotName = request.slotName;
      activeMountRequest.mountParentEntityId = request.mountParentEntityId;
      activeMountRequest.mountEventOptions = request.mountEventOptions;
      activeMountRequest.isInstant = true;
    };
    ScriptExecutionContext.SetArgumentScriptable(context, n"ActiveMountRequest", activeMountRequest);
    ScriptExecutionContext.SetArgumentScriptable(context, n"MountRequest", null);
    AIBehaviorScriptBase.GetPuppet(context).GetPuppetStateBlackboard().SetBool(GetAllBlackboardDefs().PuppetState.InPendingBehavior, true);
  }

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let mountInfo: MountingInfo;
    let request: ref<MountEventData> = ScriptExecutionContext.GetArgumentScriptable(context, n"MountRequest") as MountEventData;
    if IsDefined(request) {
      mountInfo = GameInstance.GetMountingFacility(ScriptExecutionContext.GetOwner(context).GetGame()).GetMountingInfoSingleWithObjects(ScriptExecutionContext.GetOwner(context));
      if mountInfo.parentId == request.mountParentEntityId && VehicleComponent.IsSameSlot(mountInfo.slotId.id, request.slotName) {
        ScriptExecutionContext.SetArgumentScriptable(context, n"MountRequest", null);
        ScriptExecutionContext.InvokeBehaviorCallback(context, n"OnMountRequest");
      };
    };
    return AIbehaviorUpdateOutcome.IN_PROGRESS;
  }

  protected func Deactivate(context: ScriptExecutionContext) -> Void {
    if !AIBehaviorScriptBase.GetPuppet(context).GetPuppetStateBlackboard().GetBool(GetAllBlackboardDefs().PuppetState.WorkspotAnimationInProgress) {
      AIBehaviorScriptBase.GetPuppet(context).GetPuppetStateBlackboard().SetBool(GetAllBlackboardDefs().PuppetState.InPendingBehavior, false);
    };
  }
}

public class InVehicleCombatDecorator extends AIVehicleTaskAbstract {

  public let m_targetToChase: wref<GameObject>;

  public let m_vehCommand: ref<AIVehicleChaseCommand>;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviortaskScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
    this.ProcessInitCommands(context);
  }

  private final func ProcessInitCommands(context: ScriptExecutionContext) -> Void {
    let aiComp: ref<AIVehicleAgent>;
    let owner: ref<gamePuppet> = ScriptExecutionContext.GetOwner(context);
    let gameInstance: GameInstance = owner.GetGame();
    if !VehicleComponent.IsDriver(gameInstance, owner) {
      return;
    };
    aiComp = this.GetMountedVehicleAIComponent(context);
    if IsDefined(aiComp) {
      if aiComp.InitCommandIsA(n"AIVehicleChaseCommand") {
        this.m_vehCommand = aiComp.GetInitCmd() as AIVehicleChaseCommand;
        this.m_targetToChase = this.m_vehCommand.target;
      } else {
        this.InterruptVehicleCommand(aiComp, aiComp.GetInitCmd());
      };
      aiComp.SetInitCmd(null);
    };
    this.InterruptMountedVehicleDriveToPointCommand(context);
  }

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let combatTarget: wref<GameObject>;
    let owner: ref<gamePuppet> = ScriptExecutionContext.GetOwner(context);
    let gameInstance: GameInstance = owner.GetGame();
    if VehicleComponent.IsDriver(gameInstance, owner) && VehicleComponent.CanBeDriven(gameInstance, owner.GetEntityID()) {
      combatTarget = ScriptExecutionContext.GetArgumentObject(context, n"CombatTarget");
      if IsDefined(combatTarget) && combatTarget != this.m_targetToChase {
        this.ChaseNewTarget(context, combatTarget);
      };
    };
    return AIbehaviorUpdateOutcome.IN_PROGRESS;
  }

  protected func Deactivate(context: ScriptExecutionContext) -> Void {
    if IsDefined(this.m_targetToChase) && IsDefined(this.m_vehCommand) {
      this.InterruptMountedVehicleCommand(context, this.m_vehCommand);
      this.m_targetToChase = null;
      this.m_vehCommand = null;
    };
  }

  protected final func CreateChaseCommand(newTarget: wref<GameObject>, context: ScriptExecutionContext) -> ref<AIVehicleChaseCommand> {
    let chaseCommand: ref<AIVehicleChaseCommand> = new AIVehicleChaseCommand();
    chaseCommand.target = newTarget;
    chaseCommand.distanceMin = 3.00;
    chaseCommand.distanceMax = 10.00;
    chaseCommand.needDriver = true;
    return chaseCommand;
  }

  protected final func ChaseNewTarget(context: ScriptExecutionContext, newTarget: wref<GameObject>) -> Void {
    this.m_vehCommand = this.CreateChaseCommand(newTarget, context);
    if this.SendAICommandToMountedVehicle(context, this.m_vehCommand) {
      this.m_targetToChase = newTarget;
    };
  }
}

public class InVehicleDriveToPointAutonomousDecorator extends AIVehicleTaskAbstract {

  public let m_vehCommand: ref<AIVehicleDriveToPointAutonomousCommand>;

  protected inline edit let m_targetPosition: ref<AIArgumentMapping>;

  protected inline edit let m_minimumDistanceToTarget: ref<AIArgumentMapping>;

  protected inline edit let m_maxSpeed: ref<AIArgumentMapping>;

  protected inline edit let m_minSpeed: ref<AIArgumentMapping>;

  protected inline edit let m_clearTrafficOnPath: ref<AIArgumentMapping>;

  protected inline edit let m_driveDownTheRoadIndefinitely: ref<AIArgumentMapping>;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let floatValue: Float;
    let vehicle: wref<VehicleObject>;
    let owner: ref<gamePuppet> = ScriptExecutionContext.GetOwner(context);
    let gameInstance: GameInstance = owner.GetGame();
    let driveToPointUpdate: ref<DriveToPointAutonomousUpdate> = new DriveToPointAutonomousUpdate();
    VehicleComponent.GetVehicle(gameInstance, owner, vehicle);
    AIbehaviortaskScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
    this.ProcessInitCommands(context);
    if !VehicleComponent.IsDriver(gameInstance, owner) {
      return;
    };
    if IsDefined(this.m_vehCommand) || VehicleComponent.CanBeDriven(gameInstance, owner.GetEntityID()) {
      driveToPointUpdate.targetPosition = FromVariant<Vector4>(ScriptExecutionContext.GetMappingValue(context, this.m_targetPosition));
      floatValue = FromVariant<Float>(ScriptExecutionContext.GetMappingValue(context, this.m_maxSpeed));
      if floatValue > 0.00 {
        driveToPointUpdate.maxSpeed = floatValue;
      };
      floatValue = FromVariant<Float>(ScriptExecutionContext.GetMappingValue(context, this.m_minSpeed));
      if floatValue > 0.00 {
        driveToPointUpdate.minSpeed = floatValue;
      };
      floatValue = FromVariant<Float>(ScriptExecutionContext.GetMappingValue(context, this.m_minimumDistanceToTarget));
      if floatValue > 0.00 {
        driveToPointUpdate.minimumDistanceToTarget = floatValue;
      };
      if driveToPointUpdate.minSpeed > driveToPointUpdate.maxSpeed {
        driveToPointUpdate.minSpeed = -1.00;
        driveToPointUpdate.maxSpeed = -1.00;
      };
      driveToPointUpdate.clearTrafficOnPath = FromVariant<Bool>(ScriptExecutionContext.GetMappingValue(context, this.m_clearTrafficOnPath));
      driveToPointUpdate.driveDownTheRoadIndefinitely = FromVariant<Bool>(ScriptExecutionContext.GetMappingValue(context, this.m_driveDownTheRoadIndefinitely));
      if IsDefined(this.m_vehCommand) {
        vehicle.GetAIComponent().SetDriveToPointAutonomousUpdate(driveToPointUpdate);
      } else {
        this.m_vehCommand = driveToPointUpdate.CreateCmd();
        this.SendAICommandToMountedVehicle(context, this.m_vehCommand);
      };
    };
  }

  private final func ProcessInitCommands(context: ScriptExecutionContext) -> Void {
    let aiComp: ref<AIVehicleAgent>;
    let owner: ref<gamePuppet> = ScriptExecutionContext.GetOwner(context);
    let gameInstance: GameInstance = owner.GetGame();
    if !VehicleComponent.IsDriver(gameInstance, owner) {
      return;
    };
    aiComp = this.GetMountedVehicleAIComponent(context);
    if IsDefined(aiComp) {
      this.m_vehCommand = this.GetMountedVehicleActiveDriveToPointCommand(context);
      if !IsDefined(this.m_vehCommand) && IsDefined(aiComp.GetInitCmd()) {
        this.InterruptVehicleCommand(aiComp, aiComp.GetInitCmd());
      };
      aiComp.SetInitCmd(null);
    };
  }

  protected final func GetMountedVehicleActiveDriveToPointCommand(context: ScriptExecutionContext) -> ref<AIVehicleDriveToPointAutonomousCommand> {
    let vehAIComponent: ref<AIComponent> = this.GetMountedVehicleAIComponent(context);
    if !IsDefined(vehAIComponent) {
      return null;
    };
    return vehAIComponent.GetEnqueuedOrExecutingCommand(n"AIVehicleDriveToPointAutonomousCommand", false) as AIVehicleDriveToPointAutonomousCommand;
  }

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let owner: ref<gamePuppet> = ScriptExecutionContext.GetOwner(context);
    let gameInstance: GameInstance = owner.GetGame();
    if !VehicleComponent.IsDriver(gameInstance, owner) {
      return AIbehaviorUpdateOutcome.IN_PROGRESS;
    };
    if IsDefined(this.m_vehCommand) {
      if Equals(this.m_vehCommand.state, AICommandState.Success) {
        return AIbehaviorUpdateOutcome.SUCCESS;
      };
      if Equals(this.m_vehCommand.state, AICommandState.Failure) {
        return AIbehaviorUpdateOutcome.FAILURE;
      };
      return AIbehaviorUpdateOutcome.IN_PROGRESS;
    };
    return AIbehaviorUpdateOutcome.FAILURE;
  }

  protected func Deactivate(context: ScriptExecutionContext) -> Void {
    if IsDefined(this.m_vehCommand) {
      this.m_vehCommand = null;
    };
  }
}

public class InVehicleAlertedDecorator extends AIVehicleTaskAbstract {

  protected func Deactivate(context: ScriptExecutionContext) -> Void {
    let aiComp: ref<AIVehicleAgent>;
    let owner: ref<gamePuppet> = ScriptExecutionContext.GetOwner(context);
    let gameInstance: GameInstance = owner.GetGame();
    if !VehicleComponent.IsDriver(gameInstance, owner) {
      return;
    };
    aiComp = this.GetMountedVehicleAIComponent(context);
    if IsDefined(aiComp) {
      aiComp.SetKeepStrategyOnSearch(false);
    };
    this.InterruptMountedVehicleDriveToPointCommand(context);
  }
}

public class SetKeepStrategyOnSearch extends AIVehicleTaskAbstract {

  protected inline edit let m_keep: ref<AIArgumentMapping>;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let aiComp: ref<AIVehicleAgent>;
    let owner: ref<gamePuppet> = ScriptExecutionContext.GetOwner(context);
    let gameInstance: GameInstance = owner.GetGame();
    if !VehicleComponent.IsDriver(gameInstance, owner) {
      return;
    };
    aiComp = this.GetMountedVehicleAIComponent(context);
    if IsDefined(aiComp) {
      aiComp.SetKeepStrategyOnSearch(FromVariant<Bool>(ScriptExecutionContext.GetMappingValue(context, this.m_keep)));
    };
  }
}

public class KeepStrategyOnSearch extends AIVehicleConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let aiComp: ref<AIVehicleAgent> = this.GetMountedVehicleAIComponent(context);
    return Cast<AIbehaviorConditionOutcomes>(IsDefined(aiComp) && aiComp.KeepStrategyOnSearch());
  }
}

public class InVehicleDrivePatrolDecorator extends AIVehicleTaskAbstract {

  public let m_vehCommand: ref<AIVehicleDrivePatrolCommand>;

  protected inline edit let m_maxSpeed: ref<AIArgumentMapping>;

  protected inline edit let m_minSpeed: ref<AIArgumentMapping>;

  protected inline edit let m_clearTrafficOnPath: ref<AIArgumentMapping>;

  protected inline edit let m_emergencyPatrol: ref<AIArgumentMapping>;

  protected inline edit let m_numPatrolLoops: ref<AIArgumentMapping>;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let floatValue: Float;
    let vehicle: wref<VehicleObject>;
    let owner: ref<gamePuppet> = ScriptExecutionContext.GetOwner(context);
    let gameInstance: GameInstance = owner.GetGame();
    let drivePatrolUpdate: ref<DrivePatrolUpdate> = new DrivePatrolUpdate();
    VehicleComponent.GetVehicle(gameInstance, owner, vehicle);
    AIbehaviortaskScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
    this.ProcessInitCommands(context);
    if !VehicleComponent.IsDriver(gameInstance, owner) {
      return;
    };
    if IsDefined(this.m_vehCommand) || VehicleComponent.CanBeDriven(gameInstance, owner.GetEntityID()) {
      floatValue = FromVariant<Float>(ScriptExecutionContext.GetMappingValue(context, this.m_maxSpeed));
      if floatValue > 0.00 {
        drivePatrolUpdate.maxSpeed = floatValue;
      };
      floatValue = FromVariant<Float>(ScriptExecutionContext.GetMappingValue(context, this.m_minSpeed));
      if floatValue > 0.00 {
        drivePatrolUpdate.minSpeed = floatValue;
      };
      if drivePatrolUpdate.minSpeed > drivePatrolUpdate.maxSpeed {
        drivePatrolUpdate.minSpeed = -1.00;
        drivePatrolUpdate.maxSpeed = -1.00;
      };
      drivePatrolUpdate.clearTrafficOnPath = FromVariant<Bool>(ScriptExecutionContext.GetMappingValue(context, this.m_clearTrafficOnPath));
      drivePatrolUpdate.emergencyPatrol = FromVariant<Bool>(ScriptExecutionContext.GetMappingValue(context, this.m_emergencyPatrol));
      this.m_vehCommand.numPatrolLoops = FromVariant<Uint32>(ScriptExecutionContext.GetMappingValue(context, this.m_numPatrolLoops));
      if IsDefined(this.m_vehCommand) {
        vehicle.GetAIComponent().SetDrivePatrolUpdate(drivePatrolUpdate);
      } else {
        this.m_vehCommand = drivePatrolUpdate.CreateCmd();
        this.SendAICommandToMountedVehicle(context, this.m_vehCommand);
      };
    };
  }

  private final func ProcessInitCommands(context: ScriptExecutionContext) -> Void {
    let aiComp: ref<AIVehicleAgent>;
    let owner: ref<gamePuppet> = ScriptExecutionContext.GetOwner(context);
    let gameInstance: GameInstance = owner.GetGame();
    if !VehicleComponent.IsDriver(gameInstance, owner) {
      return;
    };
    aiComp = this.GetMountedVehicleAIComponent(context);
    if IsDefined(aiComp) {
      this.m_vehCommand = this.GetMountedVehicleActivePatrolCommand(context);
      if !IsDefined(this.m_vehCommand) && IsDefined(aiComp.GetInitCmd()) {
        this.InterruptVehicleCommand(aiComp, aiComp.GetInitCmd());
      };
      aiComp.SetInitCmd(null);
    };
    this.InterruptMountedVehicleDriveToPointCommand(context);
  }

  protected final func GetMountedVehicleActivePatrolCommand(context: ScriptExecutionContext) -> ref<AIVehicleDrivePatrolCommand> {
    let vehAIComponent: ref<AIComponent> = this.GetMountedVehicleAIComponent(context);
    if !IsDefined(vehAIComponent) {
      return null;
    };
    return vehAIComponent.GetEnqueuedOrExecutingCommand(n"AIVehicleDrivePatrolCommand", false) as AIVehicleDrivePatrolCommand;
  }

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let owner: ref<gamePuppet> = ScriptExecutionContext.GetOwner(context);
    let gameInstance: GameInstance = owner.GetGame();
    if !VehicleComponent.IsDriver(gameInstance, owner) {
      return AIbehaviorUpdateOutcome.IN_PROGRESS;
    };
    if IsDefined(this.m_vehCommand) {
      if Equals(this.m_vehCommand.state, AICommandState.Success) {
        return AIbehaviorUpdateOutcome.SUCCESS;
      };
      if Equals(this.m_vehCommand.state, AICommandState.Failure) {
        return AIbehaviorUpdateOutcome.FAILURE;
      };
      return AIbehaviorUpdateOutcome.IN_PROGRESS;
    };
    return AIbehaviorUpdateOutcome.FAILURE;
  }

  protected func Deactivate(context: ScriptExecutionContext) -> Void {
    if IsDefined(this.m_vehCommand) {
      this.InterruptMountedVehicleCommand(context, this.m_vehCommand);
      this.m_vehCommand = null;
    };
  }
}

public class MountAssigendVehicle extends AIVehicleTaskAbstract {

  private let m_result: AIbehaviorUpdateOutcome;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let evt: ref<MountAIEvent>;
    let mountData: ref<MountEventData>;
    let vehicleID: EntityID;
    let vehicleSlotID: MountingSlotId;
    if !AIBehaviorScriptBase.GetAIComponent(context).GetAssignedVehicleData(vehicleID, vehicleSlotID) {
      this.m_result = AIbehaviorUpdateOutcome.FAILURE;
      return;
    };
    if VehicleComponent.IsSlotOccupied(ScriptExecutionContext.GetOwner(context).GetGame(), vehicleID, vehicleSlotID) {
      this.m_result = AIbehaviorUpdateOutcome.FAILURE;
      return;
    };
    mountData = new MountEventData();
    mountData.slotName = vehicleSlotID.id;
    mountData.mountParentEntityId = vehicleID;
    mountData.isInstant = false;
    mountData.ignoreHLS = true;
    evt = new MountAIEvent();
    evt.name = n"Mount";
    evt.data = mountData;
    ScriptExecutionContext.GetOwner(context).QueueEvent(evt);
    this.m_result = AIbehaviorUpdateOutcome.SUCCESS;
  }

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    return this.m_result;
  }
}

public class WaitBeforeExiting extends AIVehicleTaskAbstract {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let mountInfo: MountingInfo = GameInstance.GetMountingFacility(ScriptExecutionContext.GetOwner(context).GetGame()).GetMountingInfoSingleWithObjects(ScriptExecutionContext.GetOwner(context));
    let vehicle: wref<VehicleObject> = GameInstance.FindEntityByID(ScriptExecutionContext.GetOwner(context).GetGame(), mountInfo.parentId) as VehicleObject;
    if !vehicle.IsVehicleAccelerateQuickhackActive() && VehicleComponent.IsDriver(ScriptExecutionContext.GetOwner(context).GetGame(), ScriptExecutionContext.GetOwner(context)) {
      this.SendAIEventToMountedVehicle(context, n"NoDriver");
    };
    AIbehaviortaskScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let vehicle: wref<VehicleObject>;
    let mountInfo: MountingInfo = GameInstance.GetMountingFacility(ScriptExecutionContext.GetOwner(context).GetGame()).GetMountingInfoSingleWithObjects(ScriptExecutionContext.GetOwner(context));
    if !VehicleComponent.GetVehicleFromID(ScriptExecutionContext.GetOwner(context).GetGame(), mountInfo.parentId, vehicle) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    if vehicle.GetCurrentSpeed() < 0.50 {
      if ScriptedPuppet.IsPlayerFollower(ScriptExecutionContext.GetOwner(context)) {
        return AIbehaviorUpdateOutcome.SUCCESS;
      };
      if !vehicle.IsInAir() && !vehicle.IsFlippedOver() {
        return AIbehaviorUpdateOutcome.SUCCESS;
      };
    };
    return AIbehaviorUpdateOutcome.IN_PROGRESS;
  }
}

public abstract class AIVehicleConditionAbstract extends AIbehaviorconditionScript {

  protected final func IsVehicleOccupiedByHostile(context: ScriptExecutionContext, vehicleID: EntityID) -> Bool {
    return VehicleComponent.IsVehicleOccupiedByHostile(vehicleID, ScriptExecutionContext.GetOwner(context));
  }

  protected final func GetMountedVehicleAIComponent(context: ScriptExecutionContext) -> ref<AIVehicleAgent> {
    let vehicle: wref<VehicleObject>;
    if !VehicleComponent.GetVehicle(ScriptExecutionContext.GetOwner(context).GetGame(), ScriptExecutionContext.GetOwner(context), vehicle) || !vehicle.IsAttached() {
      return null;
    };
    return vehicle.GetAIComponent();
  }
}

public class HasVehicleAssigned extends AIVehicleConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(AIBehaviorScriptBase.GetAIComponent(context).HasVehicleAssigned());
  }
}

public class CanMountVehicle extends AIVehicleConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let vehicleID: EntityID;
    let vehicleSlotID: MountingSlotId;
    if !AIBehaviorScriptBase.GetAIComponent(context).GetAssignedVehicleData(vehicleID, vehicleSlotID) {
      return AIbehaviorConditionOutcomes.False;
    };
    if StatusEffectSystem.ObjectHasStatusEffectWithTag(ScriptExecutionContext.GetOwner(context), n"BlockMountVehicle") {
      return AIbehaviorConditionOutcomes.False;
    };
    if VehicleComponent.IsDestroyed(ScriptExecutionContext.GetOwner(context).GetGame(), vehicleID) {
      return AIbehaviorConditionOutcomes.False;
    };
    if VehicleComponent.HasFlatTire(ScriptExecutionContext.GetOwner(context).GetGame(), vehicleID) {
      return AIbehaviorConditionOutcomes.False;
    };
    if VehicleComponent.IsSlotOccupied(ScriptExecutionContext.GetOwner(context).GetGame(), vehicleID, vehicleSlotID) {
      return AIbehaviorConditionOutcomes.False;
    };
    if this.IsVehicleOccupiedByHostile(context, vehicleID) {
      return AIbehaviorConditionOutcomes.False;
    };
    if NotEquals(vehicleSlotID.id, n"seat_front_left") && !VehicleComponent.HasActiveDriverMounted(ScriptExecutionContext.GetOwner(context).GetGame(), vehicleID) {
      return AIbehaviorConditionOutcomes.False;
    };
    return AIbehaviorConditionOutcomes.True;
  }
}

public class DoesVehicleSupportCombat extends AIVehicleConditionAbstract {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.50));
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let vehicleRecord: ref<Vehicle_Record>;
    let vehicleTags: array<CName>;
    if !VehicleComponent.GetVehicleRecord(ScriptExecutionContext.GetOwner(context).GetGame(), ScriptExecutionContext.GetOwner(context), vehicleRecord) {
      return AIbehaviorConditionOutcomes.False;
    };
    vehicleTags = vehicleRecord.Tags();
    if ArraySize(vehicleTags) > 0 && ArrayContains(vehicleTags, n"CombatDisabled") {
      return AIbehaviorConditionOutcomes.False;
    };
    if IsDefined(vehicleRecord.VehDataPackage()) && Equals(vehicleRecord.VehDataPackage().DriverCombat().Type(), gamedataDriverCombatType.Disabled) {
      return AIbehaviorConditionOutcomes.False;
    };
    return AIbehaviorConditionOutcomes.True;
  }
}

public class IsNPCDriver extends AIVehicleConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    if !VehicleComponent.IsDriver(ScriptExecutionContext.GetOwner(context).GetGame(), ScriptExecutionContext.GetOwner(context)) {
      return AIbehaviorConditionOutcomes.False;
    };
    return AIbehaviorConditionOutcomes.True;
  }
}

public class IsNPCAloneInVehicle extends AIVehicleConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let vehicleID: EntityID;
    if !VehicleComponent.GetVehicleID(ScriptExecutionContext.GetOwner(context).GetGame(), ScriptExecutionContext.GetOwner(context), vehicleID) {
      return AIbehaviorConditionOutcomes.False;
    };
    if !VehicleComponent.HasOnlyOneActivePassenger(ScriptExecutionContext.GetOwner(context).GetGame(), vehicleID) {
      return AIbehaviorConditionOutcomes.False;
    };
    return AIbehaviorConditionOutcomes.True;
  }
}

public class IsDriverActive extends AIVehicleConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let vehicleID: EntityID;
    if !VehicleComponent.GetVehicleID(ScriptExecutionContext.GetOwner(context).GetGame(), ScriptExecutionContext.GetOwner(context), vehicleID) {
      return AIbehaviorConditionOutcomes.False;
    };
    if !VehicleComponent.HasActiveDriverMounted(ScriptExecutionContext.GetOwner(context).GetGame(), vehicleID) {
      return AIbehaviorConditionOutcomes.False;
    };
    return AIbehaviorConditionOutcomes.True;
  }
}

public class HasNewMountRequest extends AIVehicleConditionAbstract {

  protected inline edit let m_mountRequest: ref<AIArgumentMapping>;

  protected edit let m_checkOnlyInstant: Bool;

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let mountInfo: MountingInfo;
    let mountRequestData: ref<MountEventData> = ScriptExecutionContext.GetScriptableMappingValue(context, this.m_mountRequest) as MountEventData;
    if !IsDefined(mountRequestData) {
      return AIbehaviorConditionOutcomes.False;
    };
    if this.m_checkOnlyInstant && !mountRequestData.isInstant {
      return AIbehaviorConditionOutcomes.False;
    };
    mountInfo = GameInstance.GetMountingFacility(ScriptExecutionContext.GetOwner(context).GetGame()).GetMountingInfoSingleWithObjects(ScriptExecutionContext.GetOwner(context));
    if mountInfo.parentId != mountRequestData.mountParentEntityId {
      return AIbehaviorConditionOutcomes.True;
    };
    if !VehicleComponent.IsSameSlot(mountInfo.slotId.id, mountRequestData.slotName) {
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class ShouldExitVehicle extends AIVehicleConditionAbstract {

  protected let m_bb: wref<IBlackboard>;

  protected let m_mf: ref<IMountingFacility>;

  protected let m_initialized: Bool;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.25));
    if !this.m_initialized {
      this.m_bb = AIBehaviorScriptBase.GetPuppet(context).GetPuppetStateBlackboard();
      this.m_mf = GameInstance.GetMountingFacility(ScriptExecutionContext.GetOwner(context).GetGame());
      this.m_initialized = true;
    };
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let mountInfo: MountingInfo;
    if this.m_bb.GetBool(GetAllBlackboardDefs().PuppetState.WorkspotAnimationInProgress) {
      return AIbehaviorConditionOutcomes.False;
    };
    mountInfo = this.m_mf.GetMountingInfoSingleWithObjects(ScriptExecutionContext.GetOwner(context));
    if this.IsVehicleOccupiedByHostile(context, mountInfo.parentId) {
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class StepOutOfVehicle extends AIbehaviortaskScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let evt: ref<AIEvent>;
    let vehicle: wref<GameObject>;
    let vehicleID: EntityID;
    if VehicleComponent.GetVehicleID(ScriptExecutionContext.GetOwner(context).GetGame(), ScriptExecutionContext.GetOwner(context), vehicleID) {
      if ScriptExecutionContext.GetOwner(context).IsPrevention() {
        if VehicleComponent.GetVehicle(ScriptExecutionContext.GetOwner(context).GetGame(), ScriptExecutionContext.GetOwner(context), vehicle) {
          (vehicle as VehicleObject).GetVehicleComponent().ToggleLightsAndSirens(true, false);
        };
      };
      evt = new AIEvent();
      evt.name = n"ExitVehicle";
      VehicleComponent.QueueEventToAllPassengers(ScriptExecutionContext.GetOwner(context).GetGame(), vehicleID, evt);
    };
  }
}

public class IsInVehicle extends AIVehicleConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let vehicleID: EntityID;
    if !VehicleComponent.GetVehicleID(ScriptExecutionContext.GetOwner(context).GetGame(), ScriptExecutionContext.GetOwner(context), vehicleID) {
      return AIbehaviorConditionOutcomes.False;
    };
    return AIbehaviorConditionOutcomes.True;
  }
}

public class InArmedVehicle extends AIbehaviorconditionScript {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let vehicle: wref<VehicleObject>;
    if VehicleComponent.GetVehicle(ScriptExecutionContext.GetOwner(context).GetGame(), ScriptExecutionContext.GetOwner(context).GetEntityID(), vehicle) {
      if vehicle.IsArmedVehicle() {
        return AIbehaviorConditionOutcomes.True;
      };
    };
    return AIbehaviorConditionOutcomes.False;
  }
}
