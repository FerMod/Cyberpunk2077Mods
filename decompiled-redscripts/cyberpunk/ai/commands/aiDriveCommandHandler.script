
public class AIDriveCommandsDelegate extends ScriptBehaviorDelegate {

  private let useKinematic: Bool;

  private let needDriver: Bool;

  private let splineRef: NodeRef;

  private let secureTimeOut: Float;

  private let forcedStartSpeed: Float;

  private let stopAtPathEnd: Bool;

  private let driveBackwards: Bool;

  private let reverseSpline: Bool;

  private let startFromClosest: Bool;

  private let keepDistanceBool: Bool;

  private let keepDistanceCompanion: wref<GameObject>;

  private let keepDistanceDistance: Float;

  private let rubberBandingBool: Bool;

  private let rubberBandingTargetRef: wref<GameObject>;

  private let rubberBandingTargetForwardOffset: Float;

  private let rubberBandingMinDistance: Float;

  private let rubberBandingMaxDistance: Float;

  private let rubberBandingStopAndWait: Bool;

  private let rubberBandingTeleportToCatchUp: Bool;

  private let rubberBandingStayInFront: Bool;

  private let audioCurvesParam: ref<vehicleAudioCurvesParam>;

  private let allowSimplifiedMovement: Bool;

  private let ignoreTickets: Bool;

  private let disabeStuckDetection: Bool;

  private let aggressiveRammingEnabled: Bool;

  private let useSpeedBasedLookupRange: Bool;

  private let tryDriveAwayFromPlayer: Bool;

  private let targetPosition: Vector3;

  private let maxSpeed: Float;

  private let minSpeed: Float;

  private let clearTrafficOnPath: Bool;

  private let minimumDistanceToTarget: Float;

  private let emergencyPatrol: Bool;

  private let numPatrolLoops: Uint32;

  private let driveDownTheRoadIndefinitely: Bool;

  private let ignoreChaseVehiclesLimit: Bool;

  private let boostDrivingStats: Bool;

  private let m_driveOnSplineCommand: ref<AIVehicleOnSplineCommand>;

  private let useTraffic: Bool;

  private let speedInTraffic: Float;

  private let target: wref<GameObject>;

  private let distanceMin: Float;

  private let distanceMax: Float;

  private let stopWhenTargetReached: Bool;

  private let trafficTryNeighborsForStart: Bool;

  private let trafficTryNeighborsForEnd: Bool;

  private let ignoreNoAIDrivingLanes: Bool;

  private let m_driveFollowCommand: ref<AIVehicleFollowCommand>;

  private let m_driveChaseCommand: ref<AIVehicleChaseCommand>;

  private let m_drivePanicCommand: ref<AIVehiclePanicCommand>;

  private let m_driveToPointAutonomousCommand: ref<AIVehicleDriveToPointAutonomousCommand>;

  private let m_drivePatrolCommand: ref<AIVehicleDrivePatrolCommand>;

  private let nodeRef: NodeRef;

  private let isPlayer: Bool;

  private let forceGreenLights: Bool;

  private let portals: ref<vehiclePortalsList>;

  private let m_driveToNodeCommand: ref<AIVehicleToNodeCommand>;

  private let m_driveRacingCommand: ref<AIVehicleRacingCommand>;

  private let m_driveJoinTrafficCommand: ref<AIVehicleJoinTrafficCommand>;

  public final func DoStartDriveOnSpline(context: ScriptExecutionContext) -> Bool {
    let cmd: ref<AIVehicleOnSplineCommand> = this.m_driveOnSplineCommand;
    this.useKinematic = cmd.useKinematic;
    this.needDriver = cmd.needDriver;
    this.splineRef = cmd.splineRef;
    this.secureTimeOut = cmd.secureTimeOut;
    this.forcedStartSpeed = cmd.forcedStartSpeed;
    this.stopAtPathEnd = cmd.stopAtPathEnd;
    this.driveBackwards = cmd.driveBackwards;
    this.reverseSpline = cmd.reverseSpline;
    this.startFromClosest = cmd.startFromClosest;
    this.keepDistanceBool = cmd.keepDistanceBool;
    this.keepDistanceCompanion = cmd.keepDistanceCompanion;
    this.keepDistanceDistance = cmd.keepDistanceDistance;
    this.rubberBandingBool = cmd.rubberBandingBool;
    this.rubberBandingTargetRef = cmd.rubberBandingTargetRef;
    this.rubberBandingTargetForwardOffset = cmd.rubberBandingTargetForwardOffset;
    this.rubberBandingMinDistance = cmd.rubberBandingMinDistance;
    this.rubberBandingMaxDistance = cmd.rubberBandingMaxDistance;
    this.rubberBandingStopAndWait = cmd.rubberBandingStopAndWait;
    this.rubberBandingTeleportToCatchUp = cmd.rubberBandingTeleportToCatchUp;
    this.rubberBandingStayInFront = cmd.rubberBandingStayInFront;
    this.audioCurvesParam = cmd.audioCurvesParam;
    return true;
  }

  public final func DoEndDriveOnSpline() -> Bool {
    return true;
  }

  public final func DoStartDriveFollow(context: ScriptExecutionContext) -> Bool {
    let cmd: ref<AIVehicleFollowCommand> = this.m_driveFollowCommand;
    this.useKinematic = cmd.useKinematic;
    this.needDriver = cmd.needDriver;
    this.target = cmd.target;
    this.secureTimeOut = cmd.secureTimeOut;
    this.distanceMin = cmd.distanceMin;
    this.distanceMax = cmd.distanceMax;
    this.stopWhenTargetReached = cmd.stopWhenTargetReached;
    this.useTraffic = cmd.useTraffic;
    this.trafficTryNeighborsForStart = cmd.trafficTryNeighborsForStart;
    this.trafficTryNeighborsForEnd = cmd.trafficTryNeighborsForEnd;
    return true;
  }

  public final func DoUpdateDriveFollow(context: ScriptExecutionContext) -> Bool {
    if !IsDefined(this.m_driveFollowCommand) || this.m_driveFollowCommand.target != this.target {
      return false;
    };
    return true;
  }

  public final func DoEndDriveFollow(context: ScriptExecutionContext) -> Bool {
    return true;
  }

  public final func DoStopDriveFollow(context: ScriptExecutionContext) -> Bool {
    if IsDefined(this.m_driveFollowCommand) {
      this.m_driveFollowCommand = null;
    };
    return true;
  }

  public final func DoStartDriveChase(context: ScriptExecutionContext) -> Bool {
    let cmd: ref<AIVehicleChaseCommand> = this.m_driveChaseCommand;
    this.useKinematic = cmd.useKinematic;
    this.needDriver = cmd.needDriver;
    this.target = cmd.target;
    this.distanceMin = cmd.distanceMin;
    this.distanceMax = cmd.distanceMax;
    this.forcedStartSpeed = cmd.forcedStartSpeed;
    this.aggressiveRammingEnabled = cmd.aggressiveRamming;
    this.ignoreChaseVehiclesLimit = cmd.ignoreChaseVehiclesLimit;
    this.boostDrivingStats = cmd.boostDrivingStats;
    return true;
  }

  public final func DoUpdateDriveChase(context: ScriptExecutionContext) -> Bool {
    if !IsDefined(this.m_driveChaseCommand) || this.m_driveChaseCommand.target != this.target {
      return false;
    };
    return true;
  }

  public final static func DoEndDriveChase(context: ScriptExecutionContext) -> Bool {
    return true;
  }

  public final func DoStopDriveChase(context: ScriptExecutionContext) -> Bool {
    if IsDefined(this.m_driveChaseCommand) {
      this.m_driveChaseCommand = null;
    };
    return true;
  }

  public final func DoStartDrivePanic(context: ScriptExecutionContext) -> Bool {
    let cmd: ref<AIVehiclePanicCommand> = this.m_drivePanicCommand;
    this.allowSimplifiedMovement = cmd.allowSimplifiedMovement;
    this.ignoreTickets = cmd.ignoreTickets;
    this.disabeStuckDetection = cmd.disableStuckDetection;
    this.useSpeedBasedLookupRange = cmd.useSpeedBasedLookupRange;
    this.tryDriveAwayFromPlayer = cmd.tryDriveAwayFromPlayer;
    this.needDriver = cmd.needDriver;
    return true;
  }

  public final func DoUpdateDrivePanic(context: ScriptExecutionContext) -> Bool {
    if !IsDefined(this.m_drivePanicCommand) {
      return false;
    };
    return true;
  }

  public final static func DoEndDrivePanic(context: ScriptExecutionContext) -> Bool {
    return true;
  }

  public final func DoStopDrivePanic(context: ScriptExecutionContext) -> Bool {
    if IsDefined(this.m_drivePanicCommand) {
      this.m_drivePanicCommand = null;
    };
    return true;
  }

  public final func DoStartDriveToPointAutonomousAutodriveInCombat(context: ScriptExecutionContext) -> Bool {
    let vehicle: wref<VehicleObject>;
    let owner: ref<gamePuppet> = ScriptExecutionContext.GetOwner(context);
    let gameInstance: GameInstance = owner.GetGame();
    VehicleComponent.GetVehicle(gameInstance, owner, vehicle);
    this.targetPosition = Cast<Vector3>(vehicle.GetWorldPosition());
    return true;
  }

  public final func DoStartDriveToPointAutonomousAutodrive(context: ScriptExecutionContext) -> Bool {
    let autoDriveSystem: ref<AutoDriveSystem>;
    let vehicle: wref<VehicleObject>;
    let owner: ref<gamePuppet> = ScriptExecutionContext.GetOwner(context);
    let gameInstance: GameInstance = owner.GetGame();
    VehicleComponent.GetVehicle(gameInstance, owner, vehicle);
    autoDriveSystem = GameInstance.GetScriptableSystemsContainer(ScriptExecutionContext.GetOwner(context).GetGame()).Get(n"AutoDriveSystem") as AutoDriveSystem;
    this.targetPosition = autoDriveSystem.GetAutodriveDestination();
    return true;
  }

  public final func DoUpdateDriveToPointAutonomousAutodrive(context: ScriptExecutionContext) -> Bool {
    let autoDriveSystem: ref<AutoDriveSystem>;
    let vehicle: wref<VehicleObject>;
    let owner: ref<gamePuppet> = ScriptExecutionContext.GetOwner(context);
    let gameInstance: GameInstance = owner.GetGame();
    let driveToPointUpdate: ref<DriveToPointAutonomousUpdate> = new DriveToPointAutonomousUpdate();
    VehicleComponent.GetVehicle(gameInstance, owner, vehicle);
    autoDriveSystem = GameInstance.GetScriptableSystemsContainer(ScriptExecutionContext.GetOwner(context).GetGame()).Get(n"AutoDriveSystem") as AutoDriveSystem;
    if NotEquals(this.targetPosition, autoDriveSystem.GetAutodriveDestination()) {
      driveToPointUpdate.targetPosition = Cast<Vector4>(autoDriveSystem.GetAutodriveDestination());
      vehicle.GetAIComponent().SetDriveToPointAutonomousUpdate(driveToPointUpdate);
    };
    return true;
  }

  public final func DoStartDriveToPointAutonomous(context: ScriptExecutionContext) -> Bool {
    let cmd: ref<AIVehicleDriveToPointAutonomousCommand> = this.m_driveToPointAutonomousCommand;
    this.targetPosition = cmd.targetPosition;
    this.maxSpeed = cmd.maxSpeed;
    this.minSpeed = cmd.minSpeed;
    this.clearTrafficOnPath = cmd.clearTrafficOnPath;
    this.minimumDistanceToTarget = cmd.minimumDistanceToTarget;
    this.forcedStartSpeed = cmd.forcedStartSpeed;
    this.driveDownTheRoadIndefinitely = cmd.driveDownTheRoadIndefinitely;
    return true;
  }

  public final func DoUpdateDriveToPointAutonomous(context: ScriptExecutionContext) -> Bool {
    if !IsDefined(this.m_driveToPointAutonomousCommand) {
      return false;
    };
    return true;
  }

  public final static func DoEndDriveToPointAutonomous(context: ScriptExecutionContext) -> Bool {
    return true;
  }

  public final func DoStopDriveToPointAutonomous(context: ScriptExecutionContext) -> Bool {
    if IsDefined(this.m_driveToPointAutonomousCommand) {
      this.m_driveToPointAutonomousCommand = null;
    };
    return true;
  }

  public final func DoStartDrivePatrol(context: ScriptExecutionContext) -> Bool {
    let cmd: ref<AIVehicleDrivePatrolCommand> = this.m_drivePatrolCommand;
    this.maxSpeed = cmd.maxSpeed;
    this.minSpeed = cmd.minSpeed;
    this.clearTrafficOnPath = cmd.clearTrafficOnPath;
    this.emergencyPatrol = cmd.emergencyPatrol;
    this.numPatrolLoops = cmd.numPatrolLoops;
    this.forcedStartSpeed = cmd.forcedStartSpeed;
    return true;
  }

  public final func DoUpdateDrivePatrol(context: ScriptExecutionContext) -> Bool {
    if !IsDefined(this.m_drivePatrolCommand) {
      return false;
    };
    return true;
  }

  public final static func DoEndDrivePatrol(context: ScriptExecutionContext) -> Bool {
    return true;
  }

  public final func DoStopDrivePatrol(context: ScriptExecutionContext) -> Bool {
    if IsDefined(this.m_drivePatrolCommand) {
      this.m_drivePatrolCommand = null;
    };
    return true;
  }

  public final func DoStartDriveToNode(context: ScriptExecutionContext) -> Bool {
    let cmd: ref<AIVehicleToNodeCommand> = this.m_driveToNodeCommand;
    this.useKinematic = cmd.useKinematic;
    this.needDriver = cmd.needDriver;
    this.nodeRef = cmd.nodeRef;
    this.stopAtPathEnd = cmd.stopAtPathEnd;
    this.secureTimeOut = cmd.secureTimeOut;
    this.isPlayer = cmd.isPlayer;
    this.useTraffic = cmd.useTraffic;
    this.speedInTraffic = cmd.speedInTraffic;
    this.forceGreenLights = cmd.forceGreenLights;
    this.portals = cmd.portals;
    this.trafficTryNeighborsForStart = cmd.trafficTryNeighborsForStart;
    this.trafficTryNeighborsForEnd = cmd.trafficTryNeighborsForEnd;
    this.ignoreNoAIDrivingLanes = cmd.ignoreNoAIDrivingLanes;
    return true;
  }

  public final func DoEndDriveToNode() -> Bool {
    return true;
  }

  public final func DoStartDriveRacing(context: ScriptExecutionContext) -> Bool {
    let cmd: ref<AIVehicleRacingCommand> = this.m_driveRacingCommand;
    this.useKinematic = cmd.useKinematic;
    this.needDriver = cmd.needDriver;
    this.splineRef = cmd.splineRef;
    this.secureTimeOut = cmd.secureTimeOut;
    this.driveBackwards = cmd.driveBackwards;
    this.reverseSpline = cmd.reverseSpline;
    this.startFromClosest = cmd.startFromClosest;
    this.rubberBandingBool = cmd.rubberBandingBool;
    this.rubberBandingTargetRef = cmd.rubberBandingTargetRef;
    this.rubberBandingTargetForwardOffset = cmd.rubberBandingTargetForwardOffset;
    this.rubberBandingMinDistance = cmd.rubberBandingMinDistance;
    this.rubberBandingMaxDistance = cmd.rubberBandingMaxDistance;
    this.rubberBandingStopAndWait = cmd.rubberBandingStopAndWait;
    this.rubberBandingTeleportToCatchUp = cmd.rubberBandingTeleportToCatchUp;
    this.rubberBandingStayInFront = cmd.rubberBandingStayInFront;
    return true;
  }

  public final func DoEndDriveRacing() -> Bool {
    return true;
  }

  public final func DoStartDriveJoinTraffic(context: ScriptExecutionContext) -> Bool {
    let cmd: ref<AIVehicleJoinTrafficCommand> = this.m_driveJoinTrafficCommand;
    this.useKinematic = cmd.useKinematic;
    this.needDriver = cmd.needDriver;
    return true;
  }

  public final func DoEndDriveJoinTraffic() -> Bool {
    return true;
  }
}

public class AIDriveOnSplineCommandHandler extends AICommandHandlerBase {

  protected inline edit let m_outUseKinematic: ref<AIArgumentMapping>;

  protected inline edit let m_outNeedDriver: ref<AIArgumentMapping>;

  protected inline edit let m_outSpline: ref<AIArgumentMapping>;

  protected inline edit let m_outSecureTimeOut: ref<AIArgumentMapping>;

  protected inline edit let m_outDriveBackwards: ref<AIArgumentMapping>;

  protected inline edit let m_outReverseSpline: ref<AIArgumentMapping>;

  protected inline edit let m_outStartFromClosest: ref<AIArgumentMapping>;

  protected inline edit let m_outForcedStartSpeed: ref<AIArgumentMapping>;

  protected inline edit let m_outStopAtPathEnd: ref<AIArgumentMapping>;

  protected inline edit let m_outKeepDistanceBool: ref<AIArgumentMapping>;

  protected inline edit let m_outKeepDistanceCompanion: ref<AIArgumentMapping>;

  protected inline edit let m_outKeepDistanceDistance: ref<AIArgumentMapping>;

  protected inline edit let m_outRubberBandingBool: ref<AIArgumentMapping>;

  protected inline edit let m_outRubberBandingTargetRef: ref<AIArgumentMapping>;

  protected inline edit let m_outRubberBandingTargetForwardOffset: ref<AIArgumentMapping>;

  protected inline edit let m_outRubberBandingMinDistance: ref<AIArgumentMapping>;

  protected inline edit let m_outRubberBandingMaxDistance: ref<AIArgumentMapping>;

  protected inline edit let m_outRubberBandingStopAndWait: ref<AIArgumentMapping>;

  protected inline edit let m_outRubberBandingTeleportToCatchUp: ref<AIArgumentMapping>;

  protected inline edit let m_outRubberBandingStayInFront: ref<AIArgumentMapping>;

  protected inline edit let m_outAudioCurvesParam: ref<AIArgumentMapping>;

  protected func UpdateCommand(context: ScriptExecutionContext, command: ref<AICommand>) -> AIbehaviorUpdateOutcome {
    let typedCommand: ref<AIVehicleOnSplineCommand> = command as AIVehicleOnSplineCommand;
    if !IsDefined(typedCommand) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    ScriptExecutionContext.SetMappingValue(context, this.m_outUseKinematic, ToVariant(typedCommand.useKinematic));
    ScriptExecutionContext.SetMappingValue(context, this.m_outNeedDriver, ToVariant(typedCommand.needDriver));
    ScriptExecutionContext.SetMappingValue(context, this.m_outSpline, ToVariant(typedCommand.splineRef));
    ScriptExecutionContext.SetMappingValue(context, this.m_outSecureTimeOut, ToVariant(typedCommand.secureTimeOut));
    ScriptExecutionContext.SetMappingValue(context, this.m_outDriveBackwards, ToVariant(typedCommand.driveBackwards));
    ScriptExecutionContext.SetMappingValue(context, this.m_outReverseSpline, ToVariant(typedCommand.reverseSpline));
    ScriptExecutionContext.SetMappingValue(context, this.m_outStartFromClosest, ToVariant(typedCommand.startFromClosest));
    ScriptExecutionContext.SetMappingValue(context, this.m_outForcedStartSpeed, ToVariant(typedCommand.forcedStartSpeed));
    ScriptExecutionContext.SetMappingValue(context, this.m_outStopAtPathEnd, ToVariant(typedCommand.stopAtPathEnd));
    ScriptExecutionContext.SetMappingValue(context, this.m_outKeepDistanceBool, ToVariant(typedCommand.keepDistanceBool));
    ScriptExecutionContext.SetMappingValue(context, this.m_outKeepDistanceCompanion, ToVariant(typedCommand.keepDistanceCompanion));
    ScriptExecutionContext.SetMappingValue(context, this.m_outKeepDistanceDistance, ToVariant(typedCommand.keepDistanceDistance));
    ScriptExecutionContext.SetMappingValue(context, this.m_outRubberBandingBool, ToVariant(typedCommand.rubberBandingBool));
    ScriptExecutionContext.SetMappingValue(context, this.m_outRubberBandingTargetRef, ToVariant(typedCommand.rubberBandingTargetRef));
    ScriptExecutionContext.SetMappingValue(context, this.m_outRubberBandingTargetForwardOffset, ToVariant(typedCommand.rubberBandingTargetForwardOffset));
    ScriptExecutionContext.SetMappingValue(context, this.m_outRubberBandingMinDistance, ToVariant(typedCommand.rubberBandingMinDistance));
    ScriptExecutionContext.SetMappingValue(context, this.m_outRubberBandingMaxDistance, ToVariant(typedCommand.rubberBandingMaxDistance));
    ScriptExecutionContext.SetMappingValue(context, this.m_outRubberBandingStopAndWait, ToVariant(typedCommand.rubberBandingStopAndWait));
    ScriptExecutionContext.SetMappingValue(context, this.m_outRubberBandingTeleportToCatchUp, ToVariant(typedCommand.rubberBandingTeleportToCatchUp));
    ScriptExecutionContext.SetMappingValue(context, this.m_outRubberBandingStayInFront, ToVariant(typedCommand.rubberBandingStayInFront));
    ScriptExecutionContext.SetMappingValue(context, this.m_outAudioCurvesParam, ToVariant(typedCommand.audioCurvesParam));
    return AIbehaviorUpdateOutcome.SUCCESS;
  }
}

public class AIDriveFollowCommandHandler extends AICommandHandlerBase {

  protected inline edit let m_outUseKinematic: ref<AIArgumentMapping>;

  protected inline edit let m_outNeedDriver: ref<AIArgumentMapping>;

  protected inline edit let m_outTarget: ref<AIArgumentMapping>;

  protected inline edit let m_outSecureTimeOut: ref<AIArgumentMapping>;

  protected inline edit let m_outDistanceMin: ref<AIArgumentMapping>;

  protected inline edit let m_outDistanceMax: ref<AIArgumentMapping>;

  protected inline edit let m_outStopWhenTargetReached: ref<AIArgumentMapping>;

  protected inline edit let m_outUseTraffic: ref<AIArgumentMapping>;

  protected inline edit let m_outTrafficTryNeighborsForStart: ref<AIArgumentMapping>;

  protected inline edit let m_outTrafficTryNeighborsForEnd: ref<AIArgumentMapping>;

  protected func UpdateCommand(context: ScriptExecutionContext, command: ref<AICommand>) -> AIbehaviorUpdateOutcome {
    let typedCommand: ref<AIVehicleFollowCommand> = command as AIVehicleFollowCommand;
    if !IsDefined(typedCommand) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    ScriptExecutionContext.SetMappingValue(context, this.m_outUseKinematic, ToVariant(typedCommand.useKinematic));
    ScriptExecutionContext.SetMappingValue(context, this.m_outNeedDriver, ToVariant(typedCommand.needDriver));
    ScriptExecutionContext.SetMappingValue(context, this.m_outTarget, ToVariant(typedCommand.target));
    ScriptExecutionContext.SetMappingValue(context, this.m_outSecureTimeOut, ToVariant(typedCommand.secureTimeOut));
    ScriptExecutionContext.SetMappingValue(context, this.m_outDistanceMin, ToVariant(typedCommand.distanceMin));
    ScriptExecutionContext.SetMappingValue(context, this.m_outDistanceMax, ToVariant(typedCommand.distanceMax));
    ScriptExecutionContext.SetMappingValue(context, this.m_outStopWhenTargetReached, ToVariant(typedCommand.stopWhenTargetReached));
    ScriptExecutionContext.SetMappingValue(context, this.m_outUseTraffic, ToVariant(typedCommand.useTraffic));
    ScriptExecutionContext.SetMappingValue(context, this.m_outTrafficTryNeighborsForStart, ToVariant(typedCommand.trafficTryNeighborsForStart));
    ScriptExecutionContext.SetMappingValue(context, this.m_outTrafficTryNeighborsForEnd, ToVariant(typedCommand.trafficTryNeighborsForEnd));
    return AIbehaviorUpdateOutcome.SUCCESS;
  }
}

public class AIDriveToNodeCommandHandler extends AICommandHandlerBase {

  protected inline edit let m_outUseKinematic: ref<AIArgumentMapping>;

  protected inline edit let m_outNeedDriver: ref<AIArgumentMapping>;

  protected inline edit let m_outNodeRef: ref<AIArgumentMapping>;

  protected inline edit let m_outSecureTimeOut: ref<AIArgumentMapping>;

  protected inline edit let m_outIsPlayer: ref<AIArgumentMapping>;

  protected inline edit let m_outUseTraffic: ref<AIArgumentMapping>;

  protected inline edit let m_forceGreenLights: ref<AIArgumentMapping>;

  protected inline edit let m_portals: ref<AIArgumentMapping>;

  protected inline edit let m_outTrafficTryNeighborsForStart: ref<AIArgumentMapping>;

  protected inline edit let m_outTrafficTryNeighborsForEnd: ref<AIArgumentMapping>;

  protected inline edit let m_outIgnoreNoAIDrivingLanes: ref<AIArgumentMapping>;

  protected func UpdateCommand(context: ScriptExecutionContext, command: ref<AICommand>) -> AIbehaviorUpdateOutcome {
    let typedCommand: ref<AIVehicleToNodeCommand> = command as AIVehicleToNodeCommand;
    if !IsDefined(typedCommand) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    ScriptExecutionContext.SetMappingValue(context, this.m_outUseKinematic, ToVariant(typedCommand.useKinematic));
    ScriptExecutionContext.SetMappingValue(context, this.m_outNeedDriver, ToVariant(typedCommand.needDriver));
    ScriptExecutionContext.SetMappingValue(context, this.m_outNodeRef, ToVariant(typedCommand.nodeRef));
    ScriptExecutionContext.SetMappingValue(context, this.m_outSecureTimeOut, ToVariant(typedCommand.secureTimeOut));
    ScriptExecutionContext.SetMappingValue(context, this.m_outIsPlayer, ToVariant(typedCommand.isPlayer));
    ScriptExecutionContext.SetMappingValue(context, this.m_outUseTraffic, ToVariant(typedCommand.useTraffic));
    ScriptExecutionContext.SetMappingValue(context, this.m_forceGreenLights, ToVariant(typedCommand.forceGreenLights));
    ScriptExecutionContext.SetMappingValue(context, this.m_portals, ToVariant(typedCommand.portals));
    ScriptExecutionContext.SetMappingValue(context, this.m_outTrafficTryNeighborsForStart, ToVariant(typedCommand.trafficTryNeighborsForStart));
    ScriptExecutionContext.SetMappingValue(context, this.m_outTrafficTryNeighborsForEnd, ToVariant(typedCommand.trafficTryNeighborsForEnd));
    ScriptExecutionContext.SetMappingValue(context, this.m_outIgnoreNoAIDrivingLanes, ToVariant(typedCommand.ignoreNoAIDrivingLanes));
    return AIbehaviorUpdateOutcome.SUCCESS;
  }
}

public class AIDriveRacingCommandHandler extends AICommandHandlerBase {

  protected inline edit let m_outUseKinematic: ref<AIArgumentMapping>;

  protected inline edit let m_outNeedDriver: ref<AIArgumentMapping>;

  protected inline edit let m_outSpline: ref<AIArgumentMapping>;

  protected inline edit let m_outSecureTimeOut: ref<AIArgumentMapping>;

  protected inline edit let m_outDriveBackwards: ref<AIArgumentMapping>;

  protected inline edit let m_outReverseSpline: ref<AIArgumentMapping>;

  protected inline edit let m_outStartFromClosest: ref<AIArgumentMapping>;

  protected inline edit let m_outRubberBandingBool: ref<AIArgumentMapping>;

  protected inline edit let m_outRubberBandingTargetRef: ref<AIArgumentMapping>;

  protected inline edit let m_outRubberBandingTargetForwardOffset: ref<AIArgumentMapping>;

  protected inline edit let m_outRubberBandingMinDistance: ref<AIArgumentMapping>;

  protected inline edit let m_outRubberBandingMaxDistance: ref<AIArgumentMapping>;

  protected inline edit let m_outRubberBandingStopAndWait: ref<AIArgumentMapping>;

  protected inline edit let m_outRubberBandingTeleportToCatchUp: ref<AIArgumentMapping>;

  protected inline edit let m_outRubberBandingStayInFront: ref<AIArgumentMapping>;

  protected func UpdateCommand(context: ScriptExecutionContext, command: ref<AICommand>) -> AIbehaviorUpdateOutcome {
    let typedCommand: ref<AIVehicleRacingCommand> = command as AIVehicleRacingCommand;
    if !IsDefined(typedCommand) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    ScriptExecutionContext.SetMappingValue(context, this.m_outUseKinematic, ToVariant(typedCommand.useKinematic));
    ScriptExecutionContext.SetMappingValue(context, this.m_outNeedDriver, ToVariant(typedCommand.needDriver));
    ScriptExecutionContext.SetMappingValue(context, this.m_outSpline, ToVariant(typedCommand.splineRef));
    ScriptExecutionContext.SetMappingValue(context, this.m_outSecureTimeOut, ToVariant(typedCommand.secureTimeOut));
    ScriptExecutionContext.SetMappingValue(context, this.m_outDriveBackwards, ToVariant(typedCommand.driveBackwards));
    ScriptExecutionContext.SetMappingValue(context, this.m_outReverseSpline, ToVariant(typedCommand.reverseSpline));
    ScriptExecutionContext.SetMappingValue(context, this.m_outStartFromClosest, ToVariant(typedCommand.startFromClosest));
    ScriptExecutionContext.SetMappingValue(context, this.m_outRubberBandingBool, ToVariant(typedCommand.rubberBandingBool));
    ScriptExecutionContext.SetMappingValue(context, this.m_outRubberBandingTargetRef, ToVariant(typedCommand.rubberBandingTargetRef));
    ScriptExecutionContext.SetMappingValue(context, this.m_outRubberBandingTargetForwardOffset, ToVariant(typedCommand.rubberBandingTargetForwardOffset));
    ScriptExecutionContext.SetMappingValue(context, this.m_outRubberBandingMinDistance, ToVariant(typedCommand.rubberBandingMinDistance));
    ScriptExecutionContext.SetMappingValue(context, this.m_outRubberBandingMaxDistance, ToVariant(typedCommand.rubberBandingMaxDistance));
    ScriptExecutionContext.SetMappingValue(context, this.m_outRubberBandingStopAndWait, ToVariant(typedCommand.rubberBandingStopAndWait));
    ScriptExecutionContext.SetMappingValue(context, this.m_outRubberBandingTeleportToCatchUp, ToVariant(typedCommand.rubberBandingTeleportToCatchUp));
    ScriptExecutionContext.SetMappingValue(context, this.m_outRubberBandingStayInFront, ToVariant(typedCommand.rubberBandingStayInFront));
    return AIbehaviorUpdateOutcome.SUCCESS;
  }
}

public class AIDrivePanicCommandHandler extends AICommandHandlerBase {

  protected inline edit let m_outAllowSimplifiedMovement: ref<AIArgumentMapping>;

  protected inline edit let m_outIgnoreTickets: ref<AIArgumentMapping>;

  protected inline edit let m_outDisableStuckDetection: ref<AIArgumentMapping>;

  protected inline edit let m_outUseSpeedBasedLookupRange: ref<AIArgumentMapping>;

  protected inline edit let m_outTryDriveAwayFromPlayer: ref<AIArgumentMapping>;

  protected func UpdateCommand(context: ScriptExecutionContext, command: ref<AICommand>) -> AIbehaviorUpdateOutcome {
    let typedCommand: ref<AIVehiclePanicCommand> = command as AIVehiclePanicCommand;
    if !IsDefined(typedCommand) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    ScriptExecutionContext.SetMappingValue(context, this.m_outAllowSimplifiedMovement, ToVariant(typedCommand.allowSimplifiedMovement));
    ScriptExecutionContext.SetMappingValue(context, this.m_outIgnoreTickets, ToVariant(typedCommand.ignoreTickets));
    ScriptExecutionContext.SetMappingValue(context, this.m_outDisableStuckDetection, ToVariant(typedCommand.disableStuckDetection));
    ScriptExecutionContext.SetMappingValue(context, this.m_outUseSpeedBasedLookupRange, ToVariant(typedCommand.useSpeedBasedLookupRange));
    ScriptExecutionContext.SetMappingValue(context, this.m_outTryDriveAwayFromPlayer, ToVariant(typedCommand.tryDriveAwayFromPlayer));
    return AIbehaviorUpdateOutcome.SUCCESS;
  }
}

public class AIDriveJoinTrafficCommandHandler extends AICommandHandlerBase {

  protected inline edit let m_outUseKinematic: ref<AIArgumentMapping>;

  protected inline edit let m_outNeedDriver: ref<AIArgumentMapping>;

  protected func UpdateCommand(context: ScriptExecutionContext, command: ref<AICommand>) -> AIbehaviorUpdateOutcome {
    let typedCommand: ref<AIVehicleJoinTrafficCommand> = command as AIVehicleJoinTrafficCommand;
    if !IsDefined(typedCommand) {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    ScriptExecutionContext.SetMappingValue(context, this.m_outUseKinematic, ToVariant(typedCommand.useKinematic));
    ScriptExecutionContext.SetMappingValue(context, this.m_outNeedDriver, ToVariant(typedCommand.needDriver));
    return AIbehaviorUpdateOutcome.SUCCESS;
  }
}
