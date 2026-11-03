
public class PlatformController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<PlatformControllerPS> {
    return this.GetBasePS() as PlatformControllerPS;
  }
}

public class PlatformControllerPS extends ScriptableDeviceComponentPS {

  @runtimeProperty("unsavable", "true")
  @runtimeProperty("category", "Moving platform Setup")
  @runtimeProperty("tooltip", "Define node refs for your stops.")
  protected persistent const let m_floors: [NodeRef];

  @runtimeProperty("unsavable", "true")
  @runtimeProperty("category", "Moving platform Setup")
  @runtimeProperty("tooltip", "Starting point for your platform. Floors starts from 0.")
  @runtimeProperty("rangeMin", "0")
  protected persistent let m_startingFloor: Int32;

  @runtimeProperty("unsavable", "true")
  @runtimeProperty("category", "Moving platform Setup")
  @runtimeProperty("tooltip", "Speed of moving platform. Default floorIndex is 0.5f.")
  @default(PlatformControllerPS, 0.5f)
  protected persistent let m_speed: Float;

  @runtimeProperty("unsavable", "true")
  @runtimeProperty("category", "Moving platform Setup")
  @runtimeProperty("tooltip", "Thanks to curves you can have controll over moving dynamic. \n base/gameplay/curves/devices/movingplatform.curveset")
  @default(PlatformControllerPS, cosine)
  protected persistent let m_curve: CName;

  private let m_errorMSG: String;

  private persistent let m_nextFloor: Int32;

  private persistent let m_prevFloor: Int32;

  private persistent let m_destinationFloor: Int32;

  private persistent let m_currentFloor: Int32;

  private persistent let m_isPlayerOnPlatform: Bool;

  private persistent let m_isMoving: Bool;

  private persistent let m_paused: Bool;

  private persistent let m_pausingTime: Float;

  protected final func SetNextFloor(floorIndx: Int32) -> Void {
    if floorIndx >= ArraySize(this.m_floors) {
      this.m_nextFloor = ArraySize(this.m_floors) - 1;
      return;
    };
    this.m_nextFloor = floorIndx;
  }

  protected final func SetPrevFloor(floorIndx: Int32) -> Void {
    if floorIndx < 0 {
      this.m_prevFloor = 0;
      return;
    };
    this.m_prevFloor = floorIndx;
  }

  protected final func SetDestination(floorIndx: Int32) -> Void {
    this.m_destinationFloor = Clamp(floorIndx, 0, ArraySize(this.m_floors) - 1);
    this.LinkPlatforms();
  }

  public final func SetCurrentFloor(floorIndx: Int32) -> Void {
    this.m_currentFloor = floorIndx;
    this.LinkPlatforms();
  }

  public final func SetIsMoving(value: Bool) -> Void {
    this.m_isMoving = value;
  }

  public final func SetPlayerOnPlatform(value: Bool) -> EntityNotificationType {
    this.SendPSChangedEvent();
    this.m_isPlayerOnPlatform = value;
    return EntityNotificationType.DoNotNotifyEntity;
  }

  public final func SetPauseTime(time: Float) -> Void {
    this.m_pausingTime = time;
  }

  public final func GetError() -> String {
    return this.m_errorMSG;
  }

  public final func GetSpeed() -> Float {
    return this.m_speed;
  }

  public final func GetCurveName() -> CName {
    return this.m_curve;
  }

  public final func GetFloorNode(floor: Int32) -> NodeRef {
    return this.m_floors[floor];
  }

  public final func GetDestinationNode() -> NodeRef {
    return this.m_floors[this.m_destinationFloor];
  }

  public final func IsPaused() -> Bool {
    return this.m_paused;
  }

  public final func GetResumeTime() -> Float {
    return this.m_pausingTime;
  }

  public final const quest func IsPlayerOnPlatform(isInverted: Bool) -> Bool {
    if isInverted {
      return !this.m_isPlayerOnPlatform;
    };
    return this.m_isPlayerOnPlatform;
  }

  public final const quest func IsMoving(isInverted: Bool) -> Bool {
    if isInverted {
      return !this.m_isMoving;
    };
    return this.m_isMoving;
  }

  public final const quest func IsAtFloor(floor: Int32) -> Bool {
    return this.m_currentFloor == floor;
  }

  protected func Initialize() -> Void {
    super.Initialize();
    if !this.IsInitialized() {
      this.m_destinationFloor = this.m_startingFloor;
      this.m_currentFloor = this.m_startingFloor;
    };
    if this.ValidateFloors() {
      this.LinkPlatforms();
    };
  }

  private final func ValidateFloors() -> Bool {
    let definedFloorsRef: Int32;
    let i: Int32;
    i;
    while i < ArraySize(this.m_floors) {
      if IsNodeRefDefined(this.m_floors[i]) {
        definedFloorsRef += 1;
      };
      if definedFloorsRef >= 2 {
        return true;
      };
      i += 1;
    };
    this.m_errorMSG = "Node ref is empty. Check your controller settings. You need at least 2 definedFloorsRef defined to move your platform.";
    return false;
  }

  public final func LinkPlatforms() -> Void {
    this.SetNextFloor(this.m_currentFloor + 1);
    this.SetPrevFloor(this.m_currentFloor - 1);
  }

  protected final func OnQuestMoveToFloor(evt: ref<QuestMoveToFloor>) -> EntityNotificationType {
    let floorIndx: Int32;
    let prop: array<ref<DeviceActionProperty>> = evt.GetProperties();
    DeviceActionPropertyFunctions.GetProperty_Int(prop[0], floorIndx);
    this.SetDestination(floorIndx);
    return EntityNotificationType.SendThisEventToEntity;
  }

  protected final func OnQuestMoveToNextFloor(evt: ref<QuestMoveToNextFloor>) -> EntityNotificationType {
    evt.floor = this.GetFloorNode(this.m_nextFloor);
    this.SetDestination(this.m_nextFloor);
    return EntityNotificationType.SendThisEventToEntity;
  }

  protected final func OnQuestMoveToPrevFloor(evt: ref<QuestMoveToPrevFloor>) -> EntityNotificationType {
    evt.floor = this.GetFloorNode(this.m_prevFloor);
    this.SetDestination(this.m_prevFloor);
    return EntityNotificationType.SendThisEventToEntity;
  }

  protected final func OnQuestPause(evt: ref<QuestPause>) -> EntityNotificationType {
    this.m_paused = true;
    return EntityNotificationType.SendThisEventToEntity;
  }

  protected final func OnQuestResume(evt: ref<QuestResume>) -> EntityNotificationType {
    this.m_paused = false;
    evt.pauseTime = this.m_pausingTime;
    return EntityNotificationType.SendThisEventToEntity;
  }

  protected final func OnArrivedAt(evt: ref<ArrivedAt>) -> EntityNotificationType {
    this.SetCurrentFloor(this.m_destinationFloor);
    return EntityNotificationType.DoNotNotifyEntity;
  }

  public func GetActions(out actions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    let result: Bool;
    if !super.GetActions(actions, context) {
      result = false;
    } else {
      if ScriptableDeviceAction.IsDefaultConditionMet(this, context) {
        ArrayPush(actions, this.ActionToggleON());
        ArrayPush(actions, this.ActionMoveToNextFloor());
        ArrayPush(actions, this.ActionMoveToPrevFloor());
        result = true;
      };
    };
    return result;
  }

  public func GetQuestActions(out outActions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    super.GetQuestActions(outActions, context);
    ArrayPush(outActions, this.ActionQuestMoveToFloor());
    ArrayPush(outActions, this.ActionMoveToNextFloor());
    ArrayPush(outActions, this.ActionMoveToPrevFloor());
    ArrayPush(outActions, this.ActionQuestPause());
    ArrayPush(outActions, this.ActionQuestResume());
  }

  public func ActionToggleON() -> ref<ToggleON> {
    let action: ref<ToggleON> = new ToggleON();
    action.clearanceLevel = 5;
    action.SetUp(this);
    action.SetProperties(this.m_deviceState);
    action.AddDeviceName(this.m_deviceName);
    action.CreateActionWidgetPackage();
    return action;
  }

  public final func ActionQuestMoveToFloor() -> ref<QuestMoveToFloor> {
    let action: ref<QuestMoveToFloor> = new QuestMoveToFloor();
    action.clearanceLevel = 99;
    action.SetUp(this);
    action.SetProperties(-9999);
    action.AddDeviceName(this.m_deviceName);
    return action;
  }

  public final func ActionMoveToNextFloor() -> ref<QuestMoveToNextFloor> {
    let action: ref<QuestMoveToNextFloor> = new QuestMoveToNextFloor();
    action.clearanceLevel = 99;
    action.SetUp(this);
    action.SetProperties();
    action.CreateActionWidgetPackage();
    action.AddDeviceName(this.m_deviceName);
    return action;
  }

  public final func ActionMoveToPrevFloor() -> ref<QuestMoveToPrevFloor> {
    let action: ref<QuestMoveToPrevFloor> = new QuestMoveToPrevFloor();
    action.clearanceLevel = 99;
    action.SetUp(this);
    action.SetProperties();
    action.CreateActionWidgetPackage();
    action.AddDeviceName(this.m_deviceName);
    return action;
  }

  public final func ActionQuestPause() -> ref<QuestPause> {
    let action: ref<QuestPause> = new QuestPause();
    action.clearanceLevel = 99;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    return action;
  }

  public final func ActionQuestResume() -> ref<QuestResume> {
    let action: ref<QuestResume> = new QuestResume();
    action.clearanceLevel = 99;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    return action;
  }
}
