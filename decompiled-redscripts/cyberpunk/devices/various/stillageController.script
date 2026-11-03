
public class ThrowStuff extends ActionBool {

  public final func SetProperties() -> Void {
    this.actionName = n"ThrowStuff";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(this.actionName, true, n"LocKey#227", n"LocKey#227");
  }
}

public class StillageController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<StillageControllerPS> {
    return this.GetBasePS() as StillageControllerPS;
  }
}

public class StillageControllerPS extends ScriptableDeviceComponentPS {

  @default(StillageControllerPS, false)
  private let m_isCleared: Bool;

  public func GetActions(out actions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    if !super.GetActions(actions, context) {
      return false;
    };
    if this.m_isCleared {
      return false;
    };
    if Equals(context.requestType, gamedeviceRequestType.Direct) {
      ArrayPush(actions, this.ActionThrowStuff());
    };
    return true;
  }

  public func GetQuestActionByName(actionName: CName) -> ref<DeviceAction> {
    let action: ref<DeviceAction> = super.GetQuestActionByName(actionName);
    if action == null {
      switch actionName {
        case n"QuestResetDeviceToInitialState":
          action = this.ActionQuestResetDeviceToInitialState();
      };
    };
    return action;
  }

  public func GetQuestActions(out actions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    super.GetQuestActions(actions, context);
    ArrayPush(actions, this.ActionQuestResetDeviceToInitialState());
  }

  protected final const func ActionThrowStuff() -> ref<ThrowStuff> {
    let action: ref<ThrowStuff> = new ThrowStuff();
    action.clearanceLevel = 2;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    action.CreateInteraction();
    action.SetIllegal(true);
    return action;
  }

  protected final func OnThrowStuff(evt: ref<ThrowStuff>) -> EntityNotificationType {
    this.m_isCleared = true;
    this.UseNotifier(evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  protected func OnQuestResetDeviceToInitialState(evt: ref<QuestResetDeviceToInitialState>) -> EntityNotificationType {
    this.m_isCleared = false;
    this.UseNotifier(evt);
    return EntityNotificationType.SendThisEventToEntity;
  }
}
