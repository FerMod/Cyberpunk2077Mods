
public class SniperNestController extends SensorDeviceController {

  public const func GetPS() -> ref<SniperNestControllerPS> {
    return this.GetBasePS() as SniperNestControllerPS;
  }
}

public class SniperNestControllerPS extends SensorDeviceControllerPS {

  @runtimeProperty("category", "Weapon custom override")
  private edit let m_vfxNameOnShoot: CName;

  private persistent let m_isRippedOff: Bool;

  protected cb func OnInstantiated() -> Bool {
    super.OnInstantiated();
    if !IsStringValid(this.m_deviceName) {
      this.m_deviceName = "Gameplay-Devices-DisplayNames-SniperNest";
    };
  }

  protected func Initialize() -> Void {
    super.Initialize();
  }

  protected func GameAttached() -> Void;

  public final func GetRippedOff() -> Bool {
    return this.m_isRippedOff;
  }

  public final func SetRippedOff(value: Bool) -> Void {
    this.m_isRippedOff = value;
  }

  protected func LogicReady() -> Void {
    super.LogicReady();
  }

  protected final func SetDeviceState(state: EDeviceStatus) -> Void {
    super.SetDeviceState(state);
  }

  public final const func GetIsUnderControl() -> Bool {
    return this.m_isControlledByThePlayer;
  }

  public final const func GetVfxNameOnShoot() -> String {
    return ToString(this.m_vfxNameOnShoot);
  }

  protected final func ActionQuestEjectPlayer() -> ref<QuestEjectPlayer> {
    let action: ref<QuestEjectPlayer> = new QuestEjectPlayer();
    action.clearanceLevel = 99;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    return action;
  }

  protected final func ActionQuestEnterPlayer() -> ref<QuestEnterPlayer> {
    let action: ref<QuestEnterPlayer> = new QuestEnterPlayer();
    action.clearanceLevel = 99;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    return action;
  }

  protected final func ActionQuestEnterNoAnimation() -> ref<QuestEnterNoAnimation> {
    let action: ref<QuestEnterNoAnimation> = new QuestEnterNoAnimation();
    action.clearanceLevel = 99;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    return action;
  }

  protected final func ActionQuestExitNoAnimation() -> ref<QuestExitNoAnimation> {
    let action: ref<QuestExitNoAnimation> = new QuestExitNoAnimation();
    action.clearanceLevel = 99;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    return action;
  }

  public final func OnQuestEjectPlayer(evt: ref<QuestEjectPlayer>) -> EntityNotificationType {
    let notifier: ref<ActionNotifier> = new ActionNotifier();
    notifier.SetNone();
    this.Notify(notifier, evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  public final func OnQuestEnterPlayer(evt: ref<QuestEnterPlayer>) -> EntityNotificationType {
    let notifier: ref<ActionNotifier> = new ActionNotifier();
    notifier.SetNone();
    this.Notify(notifier, evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  public final func OnQuestEnterNoAnimation(evt: ref<QuestEnterNoAnimation>) -> EntityNotificationType {
    let notifier: ref<ActionNotifier> = new ActionNotifier();
    notifier.SetNone();
    this.Notify(notifier, evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  public final func OnQuestExitNoAnimation(evt: ref<QuestExitNoAnimation>) -> EntityNotificationType {
    let notifier: ref<ActionNotifier> = new ActionNotifier();
    notifier.SetNone();
    this.Notify(notifier, evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  public func GetActions(out actions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    let currentAction: ref<ScriptableDeviceAction>;
    if !super.GetActions(actions, context) {
      return false;
    };
    currentAction = this.ActionToggleTakeOverControl();
    currentAction.SetInactiveWithReason(this.m_canPlayerTakeOverControl, "LocKey#7006");
    ArrayPush(actions, currentAction);
    this.SetActionIllegality(actions, this.m_illegalActions.regularActions);
    return true;
  }

  public func GetQuestActions(out actions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    super.GetQuestActions(actions, context);
    ArrayPush(actions, this.ActionQuestEjectPlayer());
    ArrayPush(actions, this.ActionQuestEnterPlayer());
    ArrayPush(actions, this.ActionQuestEnterNoAnimation());
  }
}

public class QuestEjectPlayer extends ActionBool {

  public final func SetProperties() -> Void {
    this.actionName = n"EjectPlayer";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(n"QuestEjectPlayer", true, n"QuestEjectPlayer", n"QuestEjectPlayer");
  }
}

public class QuestEnterPlayer extends ActionBool {

  public final func SetProperties() -> Void {
    this.actionName = n"EnterPlayer";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(n"QuestEnterPlayer", true, n"QuestEnterPlayer", n"QuestEnterPlayer");
  }
}

public class QuestEnterNoAnimation extends ActionBool {

  public final func SetProperties() -> Void {
    this.actionName = n"EnterNoAnimation";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(n"QuestEnterNoAnimation", true, n"QuestEnterNoAnimation", n"QuestEnterNoAnimation");
  }
}

public class QuestExitNoAnimation extends ActionBool {

  public final func SetProperties() -> Void {
    this.actionName = n"ExitNoAnimation";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(n"QuestExitNoAnimation", true, n"QuestExitNoAnimation", n"QuestExitNoAnimation");
  }
}
