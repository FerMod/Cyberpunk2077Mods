
public class ServerNodeController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<ServerNodeControllerPS> {
    return this.GetBasePS() as ServerNodeControllerPS;
  }
}

public class ServerNodeControllerPS extends ScriptableDeviceComponentPS {

  @default(ServerNodeControllerPS, CoverState.Closed)
  private persistent let m_coverState: CoverState;

  @default(ServerNodeControllerPS, ServerState.Inactive)
  private persistent let m_serverState: ServerState;

  private persistent let m_destroyedPin: [Int32; 12];

  public final const func GetCoverState() -> CoverState {
    return this.m_coverState;
  }

  public final const func GetServerState() -> ServerState {
    return this.m_serverState;
  }

  public final const func IsPinDestroyed(index: Int32) -> Bool {
    return this.m_destroyedPin[index] == 1;
  }

  public final func SetCoverState(state: CoverState) -> Void {
    this.m_coverState = state;
  }

  public final func SetServerState(state: ServerState) -> Void {
    this.m_serverState = state;
  }

  public final func SetDestroyedPin(pinNum: Int32) -> Void {
    this.m_destroyedPin[pinNum] = 1;
  }

  public func GetQuestActions(out actions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    super.GetQuestActions(actions, context);
    ArrayPush(actions, this.ActionQuestOpen());
    ArrayPush(actions, this.ActionQuestClose());
    ArrayPush(actions, this.ActionQuestExplode());
    ArrayPush(actions, this.ActionQuestStartHacking());
    ArrayPush(actions, this.ActionQuestStopHacking());
  }

  protected const func CanCreateAnyQuickHackActions() -> Bool {
    return true;
  }

  protected func GetQuickHackActions(out actions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    let currentAction: ref<ScriptableDeviceAction> = this.ActionOverloadDevice();
    currentAction.SetObjectActionID(t"DeviceAction.ServerSingleOverloadClassHack");
    currentAction.SetInactiveWithReason(this.IsPowered(), "LocKey#7013");
    ArrayPush(actions, currentAction);
    currentAction = this.ActionServerOverload();
    ArrayPush(actions, currentAction);
    this.FinalizeGetQuickHackActions(actions, context);
  }

  public final func ActionQuestOpen() -> ref<QuestOpen> {
    let action: ref<QuestOpen> = new QuestOpen();
    action.clearanceLevel = 99;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    return action;
  }

  public final func ActionQuestClose() -> ref<QuestClose> {
    let action: ref<QuestClose> = new QuestClose();
    action.clearanceLevel = 99;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    return action;
  }

  public final func ActionQuestExplode() -> ref<QuestExplode> {
    let action: ref<QuestExplode> = new QuestExplode();
    action.clearanceLevel = 99;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    return action;
  }

  public final func ActionQuestStartHacking() -> ref<QuestStartHacking> {
    let action: ref<QuestStartHacking> = new QuestStartHacking();
    action.clearanceLevel = 99;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    return action;
  }

  public final func ActionQuestStopHacking() -> ref<QuestStopHacking> {
    let action: ref<QuestStopHacking> = new QuestStopHacking();
    action.clearanceLevel = 99;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    return action;
  }

  private final func ActionServerOverload() -> ref<ServerOverload> {
    let action: ref<ServerOverload> = new ServerOverload();
    action.clearanceLevel = 99;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    action.SetObjectActionID(t"DeviceAction.ServerOverloadClassHack");
    action.SetInactiveWithReason(this.IsPowered(), "LocKey#7013");
    return action;
  }

  private final func TryUpdateServerState(serverState: ServerState) -> Bool {
    if NotEquals(this.m_deviceState, EDeviceStatus.DISABLED) && NotEquals(this.m_serverState, serverState) {
      this.SetServerState(serverState);
      return true;
    };
    return false;
  }

  private final func TryUpdateCoverState(coverState: CoverState) -> Bool {
    if NotEquals(this.m_deviceState, EDeviceStatus.DISABLED) {
      this.SetCoverState(coverState);
      return true;
    };
    return false;
  }

  private final func GetNotificationBasedOnServerUpdateState(wasStateUpdated: Bool) -> EntityNotificationType {
    return wasStateUpdated ? EntityNotificationType.SendThisEventToEntity : EntityNotificationType.DoNotNotifyEntity;
  }

  private final func TryOpenServer() -> Bool {
    return Equals(this.m_coverState, CoverState.Closed) && this.TryUpdateCoverState(CoverState.Open);
  }

  private final func TryCloseServer() -> Bool {
    return Equals(this.m_coverState, CoverState.Open) && this.TryUpdateCoverState(CoverState.Closed) && this.TryUpdateServerState(ServerState.Inactive);
  }

  public final func TryExplode() -> Bool {
    return this.TryUpdateServerState(ServerState.Destroyed);
  }

  private final func OnQuestOpen(evt: ref<QuestOpen>) -> EntityNotificationType {
    return this.GetNotificationBasedOnServerUpdateState(this.TryOpenServer());
  }

  private final func OnQuestClose(evt: ref<QuestClose>) -> EntityNotificationType {
    return this.GetNotificationBasedOnServerUpdateState(this.TryCloseServer());
  }

  private final func OnQuestExplode(evt: ref<QuestExplode>) -> EntityNotificationType {
    return EntityNotificationType.SendThisEventToEntity;
  }

  private final func OnQuestStartHacking(evt: ref<QuestStartHacking>) -> EntityNotificationType {
    return this.GetNotificationBasedOnServerUpdateState(this.TryUpdateCoverState(CoverState.Open) && this.TryUpdateServerState(ServerState.Active));
  }

  private final func OnQuestStopHacking(evt: ref<QuestStopHacking>) -> EntityNotificationType {
    return this.GetNotificationBasedOnServerUpdateState(this.TryCloseServer());
  }

  protected func OnOverloadDevice(evt: ref<OverloadDevice>) -> EntityNotificationType {
    return EntityNotificationType.SendThisEventToEntity;
  }

  private final func OnServerOverload(evt: ref<ServerOverload>) -> EntityNotificationType {
    return this.GetNotificationBasedOnServerUpdateState(true);
  }
}
