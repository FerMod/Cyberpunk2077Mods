
public class DelamainTaxiComponent extends ScriptableComponent {

  @default(DelamainTaxiComponent, delamain_taxi_state)
  private edit let m_taxiStateFact: CName;

  @default(DelamainTaxiComponent, delamain_taxi_seat)
  private edit let m_taxiSeatFact: CName;

  private let m_gameInstance: GameInstance;

  private let m_delamainTaxiSystem: wref<DelamainTaxiSystem>;

  private let m_autoDriveSystem: wref<AutoDriveSystem>;

  private let m_currentState: DelamainTaxiState;

  private let m_callbackID: Uint32;

  public let m_vehicleSpeedCallbackID: ref<CallbackHandle>;

  @default(DelamainTaxiComponent, true)
  private let m_isActiveCab: Bool;

  private final func OnGameAttach() -> Void {
    let request: ref<RegisterDelamainTaxiRequest> = new RegisterDelamainTaxiRequest();
    let controllerPS: wref<vehicleControllerPS> = (this.GetEntity() as VehicleObject).GetAccessoryController().GetPS() as vehicleControllerPS;
    controllerPS.SetDoorInteractionState(EVehicleDoor.seat_front_left, VehicleDoorInteractionState.Disabled);
    controllerPS.SetDoorInteractionState(EVehicleDoor.seat_front_right, VehicleDoorInteractionState.Disabled);
    controllerPS.SetDoorInteractionState(EVehicleDoor.seat_back_left, VehicleDoorInteractionState.Available);
    controllerPS.SetDoorInteractionState(EVehicleDoor.seat_back_right, VehicleDoorInteractionState.Available);
    controllerPS.SetDoorInteractionState(EVehicleDoor.trunk, VehicleDoorInteractionState.Disabled);
    controllerPS.SetDoorInteractionState(EVehicleDoor.hood, VehicleDoorInteractionState.Disabled);
    this.m_gameInstance = this.GetOwner().GetGame();
    this.InitState();
    this.m_autoDriveSystem = GameInstance.GetScriptableSystemsContainer(this.m_gameInstance).Get(n"AutoDriveSystem") as AutoDriveSystem;
    this.m_delamainTaxiSystem = GameInstance.GetScriptableSystemsContainer(this.m_gameInstance).Get(n"DelamainTaxiSystem") as DelamainTaxiSystem;
    request.delamainTaxi = this;
    this.m_delamainTaxiSystem.QueueRequest(request);
    this.m_callbackID = GameInstance.GetQuestsSystem(this.m_gameInstance).RegisterEntity(this.m_taxiStateFact, this.GetEntity().GetEntityID());
    this.SetupVehicleSpeedBBListener();
  }

  protected const func GetPS() -> ref<DelamainTaxiComponentPS> {
    return this.GetBasePS() as DelamainTaxiComponentPS;
  }

  private final func OnGameDetach() -> Void {
    if this.m_isActiveCab {
      this.UnregisterCab();
    };
  }

  private final func InitState() -> Void {
    this.m_currentState = this.GetPS().GetState();
    switch this.m_currentState {
      case DelamainTaxiState.None:
        this.SetState(DelamainTaxiState.Spawned);
        break;
      case DelamainTaxiState.Parked:
      case DelamainTaxiState.Spawned:
        this.SetDoorState(true);
        break;
      case DelamainTaxiState.Started:
        this.StartAutoDrive();
        break;
      case DelamainTaxiState.Freeroam:
        this.GoToFreeRoam();
        this.m_isActiveCab = false;
    };
  }

  protected cb func OnFactChanged(evt: ref<FactChangedEvent>) -> Bool {
    if !this.m_isActiveCab {
      return false;
    };
    this.m_currentState = IntEnum<DelamainTaxiState>(GameInstance.GetQuestsSystem(this.m_gameInstance).GetFact(evt.GetFactName()));
    this.GetPS().SetState(this.m_currentState);
    switch this.m_currentState {
      case DelamainTaxiState.Ready:
        GameInstance.GetUISystem(this.m_gameInstance).RequestDelamainTaxiMenu();
        break;
      case DelamainTaxiState.Cancelled:
        this.m_delamainTaxiSystem.QueueRequest(new DelamainTaxiCancelledRequest());
        this.SetHUDHidden(false);
        break;
      case DelamainTaxiState.Freeroam:
        this.GoToFreeRoam();
        this.UnregisterCab();
        break;
      default:
    };
  }

  protected final func OnVehicleSpeedChange(speed: Float) -> Void {
    if speed < 2.00 {
      if Equals(this.m_currentState, DelamainTaxiState.Arrived) || Equals(this.m_currentState, DelamainTaxiState.Parked) || Equals(this.m_currentState, DelamainTaxiState.Cancelled) {
        this.SetDoorState(true);
      };
    };
  }

  protected final const func GetVehicle() -> wref<VehicleObject> {
    return this.GetEntity() as VehicleObject;
  }

  protected final func SetupVehicleSpeedBBListener() -> Void {
    let vehicleDefBlackboard: wref<IBlackboard>;
    if !IsDefined(this.m_vehicleSpeedCallbackID) {
      vehicleDefBlackboard = this.GetVehicle().GetBlackboard();
      this.m_vehicleSpeedCallbackID = vehicleDefBlackboard.RegisterListenerFloat(GetAllBlackboardDefs().Vehicle.SpeedValue, this, n"OnVehicleSpeedChange");
    };
  }

  protected final func UnregisterVehicleSpeedBBListener() -> Void {
    let vehicleDefBlackboard: wref<IBlackboard>;
    if IsDefined(this.m_vehicleSpeedCallbackID) {
      vehicleDefBlackboard = this.GetVehicle().GetBlackboard();
      vehicleDefBlackboard.UnregisterListenerFloat(GetAllBlackboardDefs().Vehicle.SpeedValue, this.m_vehicleSpeedCallbackID);
    };
  }

  protected cb func OnVehicleStartedMountingEvent(evt: ref<VehicleStartedMountingEvent>) -> Bool {
    if evt.character != GetPlayer(this.GetOwner().GetGame()) {
      return false;
    };
    if !this.m_isActiveCab {
      this.QueueExitCabEvent();
      return false;
    };
    if evt.isMounting {
      this.GetVehicle().PhysicsWakeUp();
      switch evt.slotID {
        case n"seat_back_left":
          GameInstance.GetQuestsSystem(this.m_gameInstance).SetFact(this.m_taxiSeatFact, 1);
          break;
        case n"seat_back_right":
          GameInstance.GetQuestsSystem(this.m_gameInstance).SetFact(this.m_taxiSeatFact, 2);
          break;
        default:
          GameInstance.GetQuestsSystem(this.m_gameInstance).SetFact(this.m_taxiSeatFact, 0);
      };
    } else {
      GameInstance.GetQuestsSystem(this.m_gameInstance).SetFact(this.m_taxiSeatFact, 0);
      this.SetHUDHidden(false);
      if Equals(this.m_currentState, DelamainTaxiState.Started) {
        this.m_delamainTaxiSystem.QueueRequest(new PayTravelRequest());
      };
    };
  }

  protected cb func OnVehicleFinishedMountingEvent(evt: ref<VehicleFinishedMountingEvent>) -> Bool {
    if evt.character != GetPlayer(this.GetOwner().GetGame()) {
      return false;
    };
    if evt.isMounting {
      if !this.m_isActiveCab {
        this.QueueExitCabEvent();
        return false;
      };
      this.GetVehicleControllerPS().SetAllowPassengerCameraSwitch(evt.isMounting);
      this.SetDoorState(false);
    } else {
      if Equals(this.m_currentState, DelamainTaxiState.Freeroam) {
        this.GoToFreeRoam();
      };
    };
  }

  private final func GoToFreeRoam() -> Void {
    let command: ref<AIVehicleJoinTrafficCommand> = new AIVehicleJoinTrafficCommand();
    command.needDriver = false;
    command.useKinematic = true;
    this.GetVehicle().GetAIComponent().SendCommand(command);
    this.GetVehicle().GetVehicleComponent().DestroyMappin();
  }

  protected cb func OnVehicleParkedEvent(evt: ref<VehicleParkedEvent>) -> Bool {
    if Equals(this.m_currentState, DelamainTaxiState.Spawned) {
      this.SetState(DelamainTaxiState.Parked);
    };
  }

  private final func SetDoorState(open: Bool) -> Void {
    if open {
      VehicleComponent.OpenDoor(this.GetOwner() as VehicleObject, VehicleComponent.GetBackLeftPassengerSlotID());
      VehicleComponent.OpenDoor(this.GetOwner() as VehicleObject, VehicleComponent.GetBackRightPassengerSlotID());
    } else {
      VehicleComponent.CloseDoor(this.GetOwner() as VehicleObject, VehicleComponent.GetBackLeftPassengerSlotID());
      VehicleComponent.CloseDoor(this.GetOwner() as VehicleObject, VehicleComponent.GetBackRightPassengerSlotID());
    };
  }

  public final func OnDelamainTaxiArrivedEvent() -> Void {
    this.SetState(DelamainTaxiState.Arrived);
    this.SetHUDHidden(false);
    this.m_delamainTaxiSystem.QueueRequest(new PayTravelRequest());
  }

  private final func SetState(state: DelamainTaxiState, opt force: Bool) -> Void {
    if !force && Equals(this.m_currentState, state) {
      return;
    };
    this.m_currentState = state;
    GameInstance.GetQuestsSystem(this.m_gameInstance).SetFact(this.m_taxiStateFact, EnumInt(state));
    this.GetPS().SetState(state);
  }

  private final func SetHUDHidden(hidden: Bool) -> Void {
    let request: ref<SetHUDHiddenRequest> = new SetHUDHiddenRequest();
    request.hidden = hidden;
    this.m_delamainTaxiSystem.QueueRequest(request);
  }

  public final func StartAutoDrive() -> Void {
    let request: ref<EnableAutoDriveRequest> = new EnableAutoDriveRequest();
    request.isDelamain = true;
    this.SetState(DelamainTaxiState.Started);
    this.m_autoDriveSystem.QueueRequest(request);
    this.GetVehicleControllerPS().SetAllowPassengerCameraSwitch(true);
    this.SetHUDHidden(true);
  }

  public final func CancelRide(forceExit: Bool) -> Void {
    if forceExit {
      this.QueueExitCabEvent();
    };
    this.SetState(DelamainTaxiState.Cancelled);
  }

  private final func QueueExitCabEvent() -> Void {
    let evt: ref<ForceExitDelamainEvent> = new ForceExitDelamainEvent();
    let persistentId: PersistentID = CreatePersistentID(this.GetOwner().GetEntityID(), n"controller");
    evt.shouldExit = true;
    GameInstance.GetPersistencySystem(this.GetOwner().GetGame()).QueuePSEvent(persistentId, n"VehicleComponentPS", evt);
  }

  private final func GetVehicleControllerPS() -> ref<vehicleControllerPS> {
    let persistentId: PersistentID = CreatePersistentID(this.GetEntity().GetEntityID(), n"VehicleController");
    let vehicleControllerPS: ref<vehicleControllerPS> = GameInstance.GetPersistencySystem(this.GetVehicle().GetGame()).GetConstAccessToPSObject(persistentId, n"gamevehicleControllerPS") as vehicleControllerPS;
    return vehicleControllerPS;
  }

  private final func UnregisterCab() -> Void {
    let controllerPS: wref<vehicleControllerPS>;
    if !this.m_isActiveCab {
      return;
    };
    this.m_delamainTaxiSystem.QueueRequest(new UnregisterCurrentTaxiRequest());
    GameInstance.GetQuestsSystem(this.m_gameInstance).SetFact(this.m_taxiStateFact, 0);
    GameInstance.GetQuestsSystem(this.m_gameInstance).UnregisterEntity(this.m_taxiStateFact, this.m_callbackID);
    this.SetDoorState(false);
    this.m_isActiveCab = false;
    controllerPS = this.GetVehicle().GetAccessoryController().GetPS() as vehicleControllerPS;
    controllerPS.SetDoorInteractionState(EVehicleDoor.seat_back_left, VehicleDoorInteractionState.Disabled);
    controllerPS.SetDoorInteractionState(EVehicleDoor.seat_back_right, VehicleDoorInteractionState.Disabled);
    this.UnregisterVehicleSpeedBBListener();
  }
}

public class DelamainTaxiComponentPS extends GameComponentPS {

  protected persistent let m_state: Uint32;

  public final const func GetState() -> DelamainTaxiState {
    return IntEnum<DelamainTaxiState>(this.m_state);
  }

  public final func SetState(state: DelamainTaxiState) -> Void {
    this.m_state = EnumInt(state);
  }
}
