
public class LiftDevice extends InteractiveMasterDevice {

  protected const let m_advertismentNames: [CName];

  protected let m_advertisments: [ref<IPlacedComponent>];

  private let m_movingPlatform: ref<MovingPlatform>;

  private let m_floors: [ElevatorFloorSetup];

  protected let QuestSafeguardColliders: [ref<IPlacedComponent>];

  protected let QuestSafeguardColliderNames: [CName];

  protected let m_frontDoorOccluder: ref<IPlacedComponent>;

  protected let m_backDoorOccluder: ref<IPlacedComponent>;

  protected let m_radioMesh: ref<IPlacedComponent>;

  protected let m_radioDestroyed: ref<IPlacedComponent>;

  protected let m_offMeshConnectionComponent: ref<OffMeshConnectionComponent>;

  private let m_isLoadPerformed: Bool;

  private let m_usedFallbackOnce: Bool;

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    let i: Int32;
    EntityRequestComponentsInterface.RequestComponent(ri, n"FrontDoorOccluder", n"IPlacedComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"BackDoorOccluder", n"IPlacedComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"radioMesh", n"IPlacedComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"radioDestroyed", n"IPlacedComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"movingPlatform", n"MovingPlatform", true);
    EntityRequestComponentsInterface.RequestComponent(ri, n"controller", this.m_controllerTypeName, true);
    EntityRequestComponentsInterface.RequestComponent(ri, n"safeguardCollider", n"entColliderComponent", true);
    EntityRequestComponentsInterface.RequestComponent(ri, n"offMeshConnection", n"OffMeshConnectionComponent", true);
    EntityRequestComponentsInterface.RequestComponent(ri, n"ui", n"worlduiWidgetComponent", false);
    i = 0;
    while i < ArraySize(this.m_advertismentNames) {
      EntityRequestComponentsInterface.RequestComponent(ri, this.m_advertismentNames[i], n"IPlacedComponent", false);
      i += 1;
    };
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    let i: Int32;
    this.m_movingPlatform = EntityResolveComponentsInterface.GetComponent(ri, n"movingPlatform") as MovingPlatform;
    this.m_radioMesh = EntityResolveComponentsInterface.GetComponent(ri, n"radioMesh") as IPlacedComponent;
    this.m_radioDestroyed = EntityResolveComponentsInterface.GetComponent(ri, n"radioDestroyed") as IPlacedComponent;
    this.m_frontDoorOccluder = EntityResolveComponentsInterface.GetComponent(ri, n"FrontDoorOccluder") as IPlacedComponent;
    this.m_backDoorOccluder = EntityResolveComponentsInterface.GetComponent(ri, n"BackDoorOccluder") as IPlacedComponent;
    ArrayPush(this.QuestSafeguardColliders, EntityResolveComponentsInterface.GetComponent(ri, n"safeguardCollider") as IPlacedComponent);
    this.m_offMeshConnectionComponent = EntityResolveComponentsInterface.GetComponent(ri, n"offMeshConnection") as OffMeshConnectionComponent;
    this.m_uiComponent = EntityResolveComponentsInterface.GetComponent(ri, n"ui") as worlduiWidgetComponent;
    i = 0;
    while i < ArraySize(this.m_advertismentNames) {
      ArrayPush(this.m_advertisments, EntityResolveComponentsInterface.GetComponent(ri, this.m_advertismentNames[i]) as IPlacedComponent);
      i += 1;
    };
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as LiftController;
  }

  public const func GetDevicePS() -> ref<LiftControllerPS> {
    return this.GetController().GetPS();
  }

  private const func GetController() -> ref<LiftController> {
    return this.m_controller as LiftController;
  }

  public final const func IsPlayerInsideLift() -> Bool {
    return this.GetDevicePS().IsPlayerInsideLift();
  }

  protected func CreateBlackboard() -> Void {
    this.m_blackboard = IBlackboard.Create(GetAllBlackboardDefs().ElevatorDeviceBlackboard);
  }

  public const func GetBlackboardDef() -> ref<ElevatorDeviceBlackboardDef> {
    return this.GetDevicePS().GetBlackboardDef();
  }

  protected func IsDeviceMovableScript() -> Bool {
    return true;
  }

  protected cb func OnGameAttached() -> Bool {
    super.OnGameAttached();
    if !GameInstance.IsRestoringState(this.GetGame()) {
      this.SetMovementState(gamePlatformMovementState.Stopped);
    } else {
      if this.GetDevicePS().IsMoving() {
        if !this.m_wasAnimationFastForwarded {
          this.FastForwardAnimations();
        };
      };
    };
  }

  protected func ResolveGameplayState() -> Void {
    super.ResolveGameplayState();
    if IsDefined(this.m_radioMesh) {
      this.GetDevicePS().SetHasSpeaker(true);
      this.RefreshSpeaker();
    } else {
      this.PlayRadioStation();
    };
    this.RefreshAdsState();
  }

  protected func DetermineInteractionState(opt context: GetActionsContext) -> Void {
    if IsDefined(context.processInitiatorObject as PlayerPuppet) {
      if Equals(context.requestType, gamedeviceRequestType.Direct) {
        this.RefreshFloorsData_Event();
      };
    };
    super.DetermineInteractionState(context);
  }

  protected cb func OnQuestSetLiftSpeed(evt: ref<QuestSetLiftSpeed>) -> Bool {
    let destination: Int32 = this.GetDevicePS().GetTargetFloor();
    if destination != -1 {
      this.SendLiftStartDelayedEvent(destination);
    };
  }

  protected cb func OnInitializeFloorsData(evt: ref<RefreshFloorDataEvent>) -> Bool {
    let activeFloor: Int32 = this.GetDevicePS().GetActiveFloor();
    this.m_floors = this.GetDevicePS().GetFloors();
    GameObject.PlayMetadataEvent(this, n"startMusic");
    GameObject.PlayMetadataEvent(this, n"unmuteMusic");
    if Equals(this.GetDevicePS().GetMovementState(), gamePlatformMovementState.Stopped) {
      this.ScheduleTeleportTo(activeFloor);
    } else {
      if this.GetDevicePS().GetCachedGoToFloorAction() != -1 && this.GetDevicePS().GetCachedGoToFloorAction() != activeFloor {
        this.SendLiftMovementLoadEvent();
        this.TrySetLiftUIData(activeFloor);
        this.m_isLoadPerformed = true;
      };
    };
  }

  protected cb func OnSlaveStateChanged(evt: ref<PSDeviceChangedEvent>) -> Bool {
    this.RefreshFloorsAuthorizationData_Event();
    super.OnSlaveStateChanged(evt);
  }

  protected func UpdateDeviceState(opt isDelayed: Bool) -> Bool {
    if super.UpdateDeviceState(isDelayed) {
      this.RefreshUI(isDelayed);
      this.NotifyFloors();
      this.EvaluateOffMeshLinks();
      return true;
    };
    return false;
  }

  private final func RefreshFloorsData_Event() -> Void {
    let evt: ref<RefreshFloorDataEvent> = new RefreshFloorDataEvent();
    GameInstance.GetPersistencySystem(this.GetGame()).QueuePSEvent(this.GetDevicePS().GetID(), this.GetDevicePS().GetClassName(), evt);
  }

  private final func RefreshFloorsAuthorizationData_Event() -> Void {
    let evt: ref<RefreshFloorAuthorizationDataEvent> = new RefreshFloorAuthorizationDataEvent();
    GameInstance.GetPersistencySystem(this.GetGame()).QueuePSEvent(this.GetDevicePS().GetID(), this.GetDevicePS().GetClassName(), evt);
  }

  protected cb func OnDetach() -> Bool {
    super.OnDetach();
    GameObject.PlayMetadataEvent(this, n"stopMusic");
    this.GetDevicePS().SetStartingFloor(this.GetDevicePS().GetActiveFloor());
    if this.GetDevicePS().IsPlayerInsideLift() {
      this.SetPlayerInsideElevatorBlackboard(false);
      this.SetIsPlayerInsideLift(false);
      this.SetIsPlayerScannedBlackboard(false);
    };
  }

  public final const func GetMovingMode() -> Int32 {
    switch this.GetDevicePS().GetMovementState() {
      case gamePlatformMovementState.Stopped:
        return 0;
      case gamePlatformMovementState.MovingUp:
        return 1;
      case gamePlatformMovementState.MovingDown:
        return -1;
      default:
        return 2;
    };
  }

  protected final func MoveToFloor(starting: Int32, ending: Int32, type: gameMovingPlatformMovementInitializationType, value: Float, opt destName: CName, opt shouldMuteSound: Bool) -> Void {
    if !this.GetDevicePS().IsMoving() {
      if !shouldMuteSound {
        GameObject.PlayMetadataEvent(this, n"startMoving");
      };
      this.SendLiftDepartedEvent(this.GetDevicePS().GetActiveFloor());
      if starting != ending {
        this.UpdateAnimState(false, false, false);
      };
      this.SetIsMovingFromToFloor(starting, ending, value == 0.00);
      this.SendMoveToFloorEvent(starting, ending, type, value, destName);
    };
  }

  protected final func SendMoveToFloorEvent(starting: Int32, ending: Int32, type: gameMovingPlatformMovementInitializationType, value: Float, opt destName: CName) -> Void {
    let moveToEvent: ref<MoveTo> = new MoveTo();
    let dynamicMov: ref<MovingPlatformMovementDynamic> = new MovingPlatformMovementDynamic();
    let ps: ref<LiftControllerPS> = this.GetDevicePS();
    dynamicMov.curveName = ps.GetMovingCurve();
    dynamicMov.SetInitData(type, value);
    dynamicMov.SetDestinationNode(ps.GetFloorMarker(ending));
    moveToEvent.movement = dynamicMov;
    moveToEvent.data = ending;
    moveToEvent.isElevator = true;
    if NotEquals(destName, n"None") {
      moveToEvent.destinationName = destName;
    };
    this.QueueEvent(moveToEvent);
    this.FireExtraFX();
    this.ToggleOccluders(true);
  }

  protected final func FireExtraFX() -> Void {
    let ps: ref<LiftControllerPS> = this.GetDevicePS();
    let fxData: EffectFiringData = ps.GetExtraFX();
    let fxEvent: ref<FireFXEvent> = new FireFXEvent();
    if fxData.m_FXTime > 0.00 {
      fxEvent.vFX = fxData.m_VFX;
      fxEvent.sFX = fxData.m_SFX;
      GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(this, fxEvent, fxData.m_FXTime);
    };
  }

  protected cb func OnFireFXEvent(evt: ref<FireFXEvent>) -> Bool {
    GameObject.PlaySoundEvent(this, evt.sFX);
    GameObjectEffectHelper.StartEffectEvent(this, evt.vFX);
  }

  protected final func PauseMovement() -> Void {
    let timeWhenPaused: Float = this.m_movingPlatform.Pause();
    this.GetDevicePS().SetTimeWhenPaused(timeWhenPaused);
    this.SetMovementState(gamePlatformMovementState.Paused);
    this.SetIsPausedBlackboard(true);
  }

  protected final func UnpauseMovement() -> Void {
    let timeWhenPaused: Float = this.GetDevicePS().GetTimeWhenPaused();
    let movementState: gamePlatformMovementState = this.m_movingPlatform.Unpause(timeWhenPaused);
    this.SetMovementState(movementState);
    this.GetDevicePS().SetTimeWhenPaused(0.00);
    this.SetIsPausedBlackboard(false);
  }

  protected final func StopMovement() -> Void {
    let moveToEvent: ref<MoveTo> = new MoveTo();
    let dynamicMov: ref<MovingPlatformMovementDynamic> = new MovingPlatformMovementDynamic();
    dynamicMov.curveName = n"cosine";
    dynamicMov.SetInitData(gameMovingPlatformMovementInitializationType.Speed, 0.00);
    dynamicMov.SetDestinationNode(this.GetDevicePS().GetFloorMarker(0));
    moveToEvent.movement = dynamicMov;
    moveToEvent.data = 0;
    this.QueueEvent(moveToEvent);
  }

  protected cb func OnGoToFloor(evt: ref<GoToFloor>) -> Bool {
    GameObject.PlayMetadataEvent(this, n"ui_generic_set_14_positive");
    if FromVariant<Int32>(evt.prop.first) != this.GetDevicePS().GetActiveFloor() && !this.GetDevicePS().IsMoving() {
      StatusEffectHelper.ApplyStatusEffect(GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerControlledGameObject(), t"BaseStatusEffect.TemporarilyBlockMovement");
      this.SendLiftStartDelayedEvent(FromVariant<Int32>(evt.prop.first));
    };
  }

  protected final func SendLiftStartDelayedEvent(targetFloorIndex: Int32) -> Void {
    let delayEvent: ref<LiftStartDelayEvent> = new LiftStartDelayEvent();
    delayEvent.targetFloor = targetFloorIndex;
    GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(this, delayEvent, this.GetDevicePS().GetLiftStartingDelay());
    this.GetDevicePS().SetCachedGoToFloorAction(targetFloorIndex);
    this.ToggleSafeguardColliders(true);
    if !this.GetDevicePS().IsMoving() {
      GameObject.PlayMetadataEvent(this, n"startMoving");
      GameObject.PlayMetadataEvent(this, n"floorSelection");
    };
    this.SendLiftDepartedEvent(this.GetDevicePS().GetActiveFloor());
    this.SetIsMovingFromToFloor(this.GetDevicePS().GetActiveFloor(), delayEvent.targetFloor, false);
    this.TrySetLiftUIData(targetFloorIndex);
    this.UpdateAnimState(false, false, false);
  }

  protected final func PlayHandAnimationOnPlayer() -> Void {
    let adHocAnimEvent: ref<AdHocAnimationEvent> = new AdHocAnimationEvent();
    adHocAnimEvent.animationIndex = 3;
    adHocAnimEvent.useBothHands = false;
    adHocAnimEvent.unequipWeapon = false;
    GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerControlledGameObject().QueueEvent(adHocAnimEvent);
  }

  protected cb func OnLiftStartDelayEvent(evt: ref<LiftStartDelayEvent>) -> Bool {
    let activeFloor: Int32 = this.GetDevicePS().GetActiveFloor();
    if this.GetDevicePS().IsLiftTravelTimeOverride() {
      this.SendMoveToFloorEvent(activeFloor, evt.targetFloor, gameMovingPlatformMovementInitializationType.Time, this.GetDevicePS().GetLiftTravelTimeOverride());
    } else {
      this.SendMoveToFloorEvent(activeFloor, evt.targetFloor, gameMovingPlatformMovementInitializationType.Speed, this.GetDevicePS().GetLiftSpeed());
    };
    this.GetDevicePS().SetCachedGoToFloorAction(-1);
  }

  protected cb func OnQuestForceEnabled(evt: ref<QuestForceEnabled>) -> Bool {
    this.RestoreDeviceState();
    this.ActivateDevice();
    this.UpdateDeviceState();
  }

  protected cb func OnQuestGoToFloor(evt: ref<QuestGoToFloor>) -> Bool {
    if FromVariant<Int32>(evt.prop.first) != this.GetDevicePS().GetActiveFloor() && !this.GetDevicePS().IsMoving() {
      this.SendLiftStartDelayedEvent(FromVariant<Int32>(evt.prop.first));
    };
  }

  protected cb func OnQuestForceGoToFloor(evt: ref<QuestForceGoToFloor>) -> Bool {
    if FromVariant<Int32>(evt.prop.first) != this.GetDevicePS().GetActiveFloor() && !this.GetDevicePS().IsMoving() {
      this.SendLiftStartDelayedEvent(FromVariant<Int32>(evt.prop.first));
    };
  }

  protected cb func OnQuestForceTeleportToFloor(evt: ref<QuestForceTeleportToFloor>) -> Bool {
    this.ScheduleTeleportTo(FromVariant<Int32>(evt.prop.first));
  }

  private final func ScheduleTeleportTo(floorIndex: Int32) -> Void {
    let teleportToEvent: ref<TeleportTo> = new TeleportTo();
    this.MoveToFloor(floorIndex, floorIndex, gameMovingPlatformMovementInitializationType.Time, 0.00);
    teleportToEvent.destinationNode = this.GetDevicePS().GetFloorMarker(floorIndex);
    this.QueueEvent(teleportToEvent);
    this.GetDevicePS().SetMovementState(gamePlatformMovementState.Stopped);
    this.TrySetLiftUIData(floorIndex);
  }

  private final func TrySetLiftUIData(floorIndex: Int32) -> Void {
    if floorIndex >= 0 && floorIndex < ArraySize(this.m_floors) {
      this.SendLiftDataToUIBlackboard(ElevatorFloorSetup.GetFloorName(this.m_floors[floorIndex]));
    };
  }

  protected final func MoveToFloor(start: Int32, target: Int32) -> Void {
    if this.GetDevicePS().IsLiftTravelTimeOverride() {
      this.MoveToFloor(start, target, gameMovingPlatformMovementInitializationType.Time, this.GetDevicePS().GetLiftTravelTimeOverride());
    } else {
      this.MoveToFloor(start, target, gameMovingPlatformMovementInitializationType.Speed, this.GetDevicePS().GetLiftSpeed());
    };
  }

  protected cb func OnQuestStopElevator(evt: ref<QuestStopElevator>) -> Bool {
    this.PauseMovement();
    this.RefreshUI();
    GameObject.PlayMetadataEvent(this, n"stopMoving");
  }

  protected cb func OnQuestResumeElevator(evt: ref<QuestResumeElevator>) -> Bool {
    this.UnpauseMovement();
    this.RefreshUI();
    GameObject.PlayMetadataEvent(this, n"startMoving");
  }

  protected cb func OnQuestCloseAllDoors(evt: ref<QuestCloseAllDoors>) -> Bool {
    let shouldOpen: Bool = !FromVariant<Bool>(evt.prop.first);
    this.UpdateAnimState(shouldOpen, shouldOpen, shouldOpen);
    if shouldOpen {
      this.ToggleSafeguardColliders(!shouldOpen);
      this.ToggleOccluders(!shouldOpen);
    };
  }

  protected cb func OnQuestToggleAds(evt: ref<QuestToggleAds>) -> Bool {
    this.RefreshAdsState();
  }

  protected final func RefreshAdsState() -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.m_advertisments) {
      this.m_advertisments[i].Toggle(this.GetDevicePS().IsAdsEnabled());
      i += 1;
    };
  }

  protected cb func OnQuestSetRadioStation(evt: ref<QuestSetRadioStation>) -> Bool {
    this.PlayRadioStation();
  }

  protected cb func OnDisableRadio(evt: ref<QuestDisableRadio>) -> Bool {
    this.PlayRadioStation();
  }

  protected cb func OnCallElevator(evt: ref<CallElevator>) -> Bool {
    let activeFloor: Int32 = this.GetDevicePS().GetActiveFloor();
    let caller: Int32 = evt.m_destination;
    if caller == activeFloor || Equals(ElevatorFloorSetup.GetFloorName(this.m_floors[caller]), ElevatorFloorSetup.GetFloorName(this.m_floors[activeFloor])) {
      this.UpdateAnimState(this.m_floors[activeFloor].doorShouldOpenFrontLeftRight[0], this.m_floors[activeFloor].doorShouldOpenFrontLeftRight[1], this.m_floors[activeFloor].doorShouldOpenFrontLeftRight[2]);
      this.SendArrivedAtFloorEvent(this.GetDevicePS().GetStartingFloor());
      return false;
    };
    this.SendLiftStartDelayedEvent(caller);
  }

  private final func SendArrivedAtFloorEvent(activeFloor: Int32) -> Void {
    let floorID: PersistentID = this.GetDevicePS().GetFloorPSID(activeFloor);
    let evt: ref<LiftArrivedEvent> = new LiftArrivedEvent();
    evt.floor = this.GetDevicePS().GetActiveFloorDisplayName();
    GameInstance.GetPersistencySystem(this.GetGame()).QueuePSEvent(floorID, n"ElevatorFloorTerminalControllerPS", evt);
  }

  private final func SendLiftDepartedEvent(activeFloor: Int32) -> Void {
    let floorID: PersistentID = this.GetDevicePS().GetFloorPSID(activeFloor);
    let evt: ref<LiftDepartedEvent> = new LiftDepartedEvent();
    evt.floor = this.GetDevicePS().GetActiveFloorDisplayName();
    GameInstance.GetPersistencySystem(this.GetGame()).QueuePSEvent(floorID, n"ElevatorFloorTerminalControllerPS", evt);
  }

  private final func NotifyFloors() -> Void {
    let deviceChangedEvent: ref<PSDeviceChangedEvent> = new PSDeviceChangedEvent();
    deviceChangedEvent.persistentID = this.GetDevicePS().GetID();
    deviceChangedEvent.className = this.GetClassName();
    let i: Int32 = 0;
    while i < ArraySize(this.m_floors) {
      this.GetDevicePS().GetPersistencySystem().QueueEntityEvent(this.GetDevicePS().GetFloorID(i), deviceChangedEvent);
      i += 1;
    };
  }

  protected cb func OnLiftSetMovementStateEvent(evt: ref<LiftSetMovementStateEvent>) -> Bool {
    this.NotifyFloors();
  }

  protected cb func OnArrivedAt(evt: ref<ArrivedAt>) -> Bool {
    let activeFloor: Int32;
    this.GetDevicePS().ChangeActiveFloor(evt.data);
    this.SendArrivedAtFloorEvent(evt.data);
    activeFloor = this.GetDevicePS().GetActiveFloor();
    this.SetIsMovingFromToFloor(0, 0, false);
    this.RefreshUI();
    if !this.GetDevicePS().IsAllDoorsClosed() {
      this.UpdateAnimState(this.m_floors[activeFloor].doorShouldOpenFrontLeftRight[0], this.m_floors[activeFloor].doorShouldOpenFrontLeftRight[1], this.m_floors[activeFloor].doorShouldOpenFrontLeftRight[2]);
      this.ToggleSafeguardColliders(false);
      this.ToggleOccluders(false);
    };
    GameObject.PlayMetadataEvent(this, n"destinationFloor");
    GameObject.PlayMetadataEvent(this, n"stopMoving");
    if this.GetDevicePS().GetCachedGoToFloorAction() != -1 && this.GetDevicePS().GetCachedGoToFloorAction() != evt.data && !this.m_isLoadPerformed {
      this.SendLiftMovementLoadEvent();
      return true;
    };
    if this.GetDevicePS().ShouldUseExtraVerification() && !this.m_usedFallbackOnce {
      if !this.VerifyDestination(this.m_floors[activeFloor].m_floorMarker, Matrix.GetTranslation(this.m_movingPlatform.GetLocalToWorld()), this.GetGame(), this.GetDevicePS().GetExtraVerificationErrorMargin()) {
        this.m_usedFallbackOnce = true;
        this.GetDevicePS().SetCachedGoToFloorAction(activeFloor);
        this.SendLiftMovementLoadEvent();
        return true;
      };
    };
  }

  private final const func VerifyDestination(node: NodeRef, currentPos: Vector4, game: GameInstance, errorMargin: Float) -> Bool {
    let distance: Float;
    let mask: Vector4;
    let nodeTransform: Transform;
    let pos1: Vector4;
    let pos2: Vector4;
    let globalRef: GlobalNodeRef = ResolveNodeRefWithEntityID(node, this.GetEntityID());
    GameInstance.GetNodeTransform(game, globalRef, nodeTransform);
    pos1 = Transform.GetPosition(nodeTransform);
    pos2 = currentPos;
    mask = new Vector4(0.00, 0.00, 1.00, 0.00);
    pos1 *= mask;
    pos2 *= mask;
    distance = Vector4.Distance(pos1, pos2);
    if distance > errorMargin {
      return false;
    };
    return true;
  }

  protected cb func OnBeforeArrivedAt(evt: ref<BeforeArrivedAt>) -> Bool {
    GameObject.PlayMetadataEvent(this, n"preStopMoving");
  }

  private final func SetUsesSleepMode(allowSleepState: Bool) -> Void {
    AnimationControllerComponent.SetUsesSleepMode(this, allowSleepState);
  }

  private final func PlayRadioStation() -> Void {
    let stationIndex: Int32;
    if this.GetDevicePS().IsSpeakerDestroyed() {
      GameObject.AudioSwitch(this, n"radio_station", n"station_none", n"radio");
      return;
    };
    stationIndex = this.GetDevicePS().GetActiveRadioStationNumber();
    if stationIndex == -1 {
      GameObject.AudioSwitch(this, n"radio_station", n"station_none", n"radio");
    } else {
      GameObject.AudioSwitch(this, n"radio_station", RadioStationDataProvider.GetStationNameByIndex(stationIndex), n"radio");
    };
  }

  private final func UpdateAnimState(isOpenFront: Bool, isOpenLeft: Bool, isOpenRight: Bool) -> Void {
    let animFeature: ref<AnimFeature_SimpleDevice> = new AnimFeature_SimpleDevice();
    animFeature.isOpen = isOpenFront;
    animFeature.isOpenLeft = isOpenLeft;
    animFeature.isOpenRight = isOpenRight;
    AnimationControllerComponent.ApplyFeature(this, n"ElevatorInnerDoor", animFeature);
    if !this.m_wasAnimationFastForwarded {
      this.FastForwardAnimations();
    };
  }

  protected final func RefreshSpeaker() -> Void {
    this.m_radioMesh.Toggle(!this.GetDevicePS().IsSpeakerDestroyed());
    this.m_radioDestroyed.Toggle(this.GetDevicePS().IsSpeakerDestroyed());
    this.PlayRadioStation();
  }

  protected final func SendLiftDataToUIBlackboard(displayFloor: String, opt force: Bool) -> Void {
    let activeFloor: Int32 = this.GetDevicePS().GetActiveFloor();
    if !IsStringValid(displayFloor) {
      displayFloor = this.GetProperDisplayFloorNumber(activeFloor);
    };
    this.GetBlackboard().SetString(GetAllBlackboardDefs().ElevatorDeviceBlackboard.CurrentFloor, displayFloor, force);
  }

  private final func GetProperDisplayFloorNumber(floor: Int32) -> String {
    let displayFloor: String;
    if floor < 10 {
      displayFloor = "0" + ToString(floor);
    } else {
      displayFloor = ToString(floor);
    };
    return displayFloor;
  }

  protected final func SetMovementState(movementState: gamePlatformMovementState) -> Void {
    let movementStateEvent: ref<LiftSetMovementStateEvent> = new LiftSetMovementStateEvent();
    movementStateEvent.movementState = movementState;
    this.SendEventToDefaultPS(movementStateEvent);
  }

  protected final func SetIsPlayerInsideLift(value: Bool) -> Void {
    let evt: ref<SetIsPlayerInsideLiftEvent> = new SetIsPlayerInsideLiftEvent();
    evt.value = value;
    this.SendEventToDefaultPS(evt);
  }

  protected final func SetIsPausedBlackboard(value: Bool) -> Void {
    this.GetBlackboard().SetBool(GetAllBlackboardDefs().ElevatorDeviceBlackboard.isPaused, value, true);
    this.GetBlackboard().FireCallbacks();
  }

  protected final func SetIsPlayerScannedBlackboard(value: Bool) -> Void {
    let evt: ref<ScanPlayerDelayEvent>;
    let ui_scanningTime: Float;
    if !value {
      this.GetBlackboard().SetBool(GetAllBlackboardDefs().ElevatorDeviceBlackboard.isPlayerScanned, false, true);
      this.GetBlackboard().FireCallbacks();
    } else {
      evt = new ScanPlayerDelayEvent();
      ui_scanningTime = TweakDBInterface.GetFloat(this.GetTweakDBRecord() + t".UI_PlayerScanningTime", 2.00);
      GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(this, evt, ui_scanningTime, true);
    };
  }

  protected final func SendLiftMovementLoadEvent() -> Void {
    let evt: ref<LiftMovementLoadEvent> = new LiftMovementLoadEvent();
    GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(this, evt, 0.40, true);
  }

  protected cb func OnLiftMovementLoadEvent(evt: ref<LiftMovementLoadEvent>) -> Bool {
    this.SendLiftStartDelayedEvent(this.GetDevicePS().GetCachedGoToFloorAction());
    this.GetDevicePS().SetCachedGoToFloorAction(-1);
    this.FastForwardAnimations();
  }

  protected cb func OnScanPlayerDelayEvent(evt: ref<ScanPlayerDelayEvent>) -> Bool {
    if this.GetDevicePS().IsPlayerInsideLift() {
      this.GetBlackboard().SetBool(GetAllBlackboardDefs().ElevatorDeviceBlackboard.isPlayerScanned, true);
      this.GetBlackboard().FireCallbacks();
    };
  }

  private final func SetIsMovingFromToFloor(startingFloor: Int32, destinationFloor: Int32, teleport: Bool) -> Void {
    let isElevatorMoving: Bool;
    let movementStateEvent: ref<LiftSetMovementStateEvent> = new LiftSetMovementStateEvent();
    if teleport {
      movementStateEvent.movementState = gamePlatformMovementState.Stopped;
    } else {
      if startingFloor < destinationFloor {
        movementStateEvent.movementState = gamePlatformMovementState.MovingUp;
        isElevatorMoving = true;
      } else {
        if startingFloor > destinationFloor {
          movementStateEvent.movementState = gamePlatformMovementState.MovingDown;
          isElevatorMoving = true;
        } else {
          movementStateEvent.movementState = gamePlatformMovementState.Stopped;
        };
      };
    };
    if this.GetDevicePS().IsPlayerInsideLift() {
      this.SetPlayerInsideElevatorBlackboard(true, isElevatorMoving);
    };
    this.SendEventToDefaultPS(movementStateEvent);
    this.GetDevicePS().SetMovementState(movementStateEvent.movementState);
    return;
  }

  private func InitializeScreenDefinition() -> Void {
    if !TDBID.IsValid(this.m_screenDefinition.screenDefinition) {
      this.m_screenDefinition.screenDefinition = t"DevicesUIDefinitions.Terminal_9x16";
    };
    if !TDBID.IsValid(this.m_screenDefinition.style) {
      this.m_screenDefinition.style = t"DevicesUIStyles.Zetatech";
    };
  }

  protected cb func OnAreaEnter(trigger: ref<AreaEnteredEvent>) -> Bool {
    let sourceIsPlayer: Bool = (EntityGameInterface.GetEntity(trigger.activator) as GameObject).IsPlayer();
    if sourceIsPlayer {
      this.SetPlayerInsideElevatorBlackboard(true);
      this.SetIsPlayerInsideLift(true);
      this.SetIsPlayerScannedBlackboard(true);
    };
  }

  protected cb func OnAreaExit(trigger: ref<AreaExitedEvent>) -> Bool {
    let sourceIsPlayer: Bool = (EntityGameInterface.GetEntity(trigger.activator) as GameObject).IsPlayer();
    if sourceIsPlayer {
      this.SetPlayerInsideElevatorBlackboard(false);
      this.SetIsPlayerInsideLift(false);
      this.SetIsPlayerScannedBlackboard(false);
    };
  }

  private final func SetPlayerInsideElevatorBlackboard(isInside: Bool, opt isElevatorMoving: Bool) -> Void {
    let blackboardSystem: ref<BlackboardSystem> = GameInstance.GetBlackboardSystem(this.GetGame());
    let blackboard: ref<IBlackboard> = blackboardSystem.GetLocalInstanced(GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerControlledGameObject().GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    blackboard.SetBool(GetAllBlackboardDefs().PlayerStateMachine.IsPlayerInsideElevator, isInside);
    blackboard.SetVariant(GetAllBlackboardDefs().PlayerStateMachine.CurrentElevator, ToVariant(this));
    if !isInside {
      isElevatorMoving = false;
    };
    blackboard.SetBool(GetAllBlackboardDefs().PlayerStateMachine.IsPlayerInsideMovingElevator, isElevatorMoving);
  }

  private final func GetPlayerInsideElevatorBlackboard() -> Bool {
    let blackboardSystem: ref<BlackboardSystem> = GameInstance.GetBlackboardSystem(this.GetGame());
    let blackboard: ref<IBlackboard> = blackboardSystem.GetLocalInstanced(GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerControlledGameObject().GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    return blackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.IsPlayerInsideElevator);
  }

  protected final func ToggleSafeguardColliders(value: Bool) -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.QuestSafeguardColliders) {
      if Equals(this.QuestSafeguardColliders[i].IsEnabled(), value) {
        return;
      };
      this.QuestSafeguardColliders[i].Toggle(value);
      i += 1;
    };
  }

  public final static func IsPlayerInsideElevator(game: GameInstance) -> Bool {
    let blackboard: ref<IBlackboard>;
    let blackboardSystem: ref<BlackboardSystem>;
    if !GameInstance.IsValid(game) {
      return false;
    };
    blackboardSystem = GameInstance.GetBlackboardSystem(game);
    blackboard = blackboardSystem.GetLocalInstanced(GameInstance.GetPlayerSystem(game).GetLocalPlayerControlledGameObject().GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    return blackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.IsPlayerInsideElevator);
  }

  public final static func GetCurrentElevator(game: GameInstance, out elevator: wref<GameObject>) -> Bool {
    let blackboard: ref<IBlackboard>;
    let blackboardSystem: ref<BlackboardSystem>;
    if !GameInstance.IsValid(game) {
      elevator = null;
      return false;
    };
    blackboardSystem = GameInstance.GetBlackboardSystem(game);
    blackboard = blackboardSystem.GetLocalInstanced(GameInstance.GetPlayerSystem(game).GetLocalPlayerControlledGameObject().GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    if blackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.IsPlayerInsideElevator) {
      elevator = FromVariant<wref<GameObject>>(blackboard.GetVariant(GetAllBlackboardDefs().PlayerStateMachine.CurrentElevator));
    };
    if IsDefined(elevator) {
      return true;
    };
    return false;
  }

  protected final func ToggleOccluders(toggle: Bool) -> Void {
    let hasBackDoor: Bool;
    let hasFrontDoor: Bool;
    if IsDefined(this.m_frontDoorOccluder) {
      hasFrontDoor = true;
    };
    if IsDefined(this.m_backDoorOccluder) {
      hasBackDoor = true;
    };
    if toggle {
      if hasFrontDoor {
        this.m_frontDoorOccluder.Toggle(true);
      };
      if hasBackDoor {
        this.m_backDoorOccluder.Toggle(true);
      };
    } else {
      if this.m_floors[this.GetDevicePS().GetActiveFloor()].doorShouldOpenFrontLeftRight[0] {
        if hasFrontDoor {
          this.m_frontDoorOccluder.Toggle(false);
        };
      };
      if this.m_floors[this.GetDevicePS().GetActiveFloor()].doorShouldOpenFrontLeftRight[1] {
        if hasBackDoor {
          this.m_backDoorOccluder.Toggle(false);
        };
      };
    };
  }

  public func OnMaraudersMapDeviceDebug(sink: ref<MaraudersMapDevicesSink>) -> Void {
    let iter: Int32;
    let keycards: array<TweakDBID>;
    let persistentFloors: array<ElevatorFloorSetup>;
    super.OnMaraudersMapDeviceDebug(sink);
    sink.BeginCategory("LIFT DEVICE");
    sink.EndCategory();
    persistentFloors = this.GetDevicePS().GetFloors();
    keycards = this.GetDevicePS().GetKeycards();
    sink.PushString("StartingFloor - ", ToString(this.GetDevicePS().GetStartingFloor()));
    sink.PushString("Movement State - ", ToString(this.GetDevicePS().GetMovementState()));
    sink.PushString("Has Speaker - ", ToString(this.GetDevicePS().HasSpeaker()));
    sink.PushString("Speaker Fact - ", ToString(this.GetDevicePS().GetSpeakerDestroyedQuestFact()));
    iter = 0;
    while iter < ArraySize(persistentFloors) {
      sink.PushString("FloorData ", ToString(iter));
      sink.PushBool("Is Inactive", persistentFloors[iter].m_isInactive);
      sink.PushBool("Is Hidden", persistentFloors[iter].m_isHidden);
      sink.PushString("Floor Name", persistentFloors[iter].m_floorName);
      sink.PushString("Floor Marker", ToString(persistentFloors[iter].m_floorMarker));
      iter = iter + 1;
    };
    sink.PushString("KEYCARDS: ", "");
    iter = 0;
    while iter < ArraySize(keycards) {
      sink.PushString("Keycard" + IntToString(iter) + " ", TDBID.ToStringDEBUG(keycards[iter]));
      iter = iter + 1;
    };
  }

  protected cb func OnHit(evt: ref<gameHitEvent>) -> Bool {
    if this.GetDevicePS().HasSpeaker() && !this.GetDevicePS().IsSpeakerDestroyed() {
      if this.m_radioMesh == evt.hitComponent {
        this.GetDevicePS().SetSpeakerDestroyed(true);
        this.RefreshSpeaker();
        SetFactValue(this.GetGame(), this.GetDevicePS().GetSpeakerDestroyedQuestFact(), 1);
        GameObjectEffectHelper.ActivateEffectAction(this, gamedataFxActionType.Start, this.GetDevicePS().GetSpeakerDestroyedVFX());
      };
    };
  }

  protected cb func OnRefreshPlayerAuthorizationEvent(evt: ref<RefreshPlayerAuthorizationEvent>) -> Bool {
    GameInstance.GetPersistencySystem(this.GetGame()).QueuePSEvent(this.GetDevicePS().GetID(), this.GetDevicePS().GetClassName(), evt);
  }

  private final func EvaluateOffMeshLinks() -> Void {
    let ps: ref<LiftControllerPS>;
    if this.m_offMeshConnectionComponent == null {
      return;
    };
    ps = this.GetDevicePS();
    if ps.IsDisabled() || ps.IsOFF() || ps.IsUnpowered() {
      this.DisableOffMeshConnections();
    } else {
      if ps.IsON() {
        this.EnableOffMeshConnections();
      };
    };
  }

  protected final func EnableOffMeshConnections() -> Void {
    if this.m_offMeshConnectionComponent != null {
      this.m_offMeshConnectionComponent.EnableForPlayer();
    };
  }

  protected final func DisableOffMeshConnections() -> Void {
    if this.m_offMeshConnectionComponent != null {
      this.m_offMeshConnectionComponent.DisableForPlayer();
    };
  }
}
