
public class RoadBlockController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<RoadBlockControllerPS> {
    return this.GetBasePS() as RoadBlockControllerPS;
  }
}

public class RoadBlockControllerPS extends ScriptableDeviceComponentPS {

  protected persistent let m_isBlocking: Bool;

  protected edit let m_negateAnimState: Bool;

  @runtimeProperty("customEditor", "TweakDBGroupInheritance;Interactions.InteractionChoice;Interactions.MountChoice")
  protected let m_nameForBlocking: TweakDBID;

  @runtimeProperty("customEditor", "TweakDBGroupInheritance;Interactions.InteractionChoice;Interactions.MountChoice")
  protected let m_nameForUnblocking: TweakDBID;

  public final const quest func IsBlocking() -> Bool {
    return this.m_isBlocking;
  }

  public final const quest func IsNotBlocking() -> Bool {
    return !this.IsBlocking();
  }

  private final func SetIsBlockingState(isBlocking: Bool) -> Void {
    this.m_isBlocking = isBlocking;
    this.NotifyParents();
  }

  public final const func NegateAnim() -> Bool {
    return this.m_negateAnimState;
  }

  protected func GameAttached() -> Void {
    if this.IsBlocking() {
      this.m_activationState = EActivationState.ACTIVATED;
    } else {
      this.m_activationState = EActivationState.DEACTIVATED;
    };
  }

  public func GetActions(out actions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    super.GetActions(actions, context);
    if ToggleBlockade.IsDefaultConditionMet(this, context) {
      if Equals(context.requestType, gamedeviceRequestType.External) {
        ArrayPush(actions, this.ActionToggleBlockade());
      };
    };
    this.SetActionIllegality(actions, this.m_illegalActions.regularActions);
    return true;
  }

  protected const func CanCreateAnyQuickHackActions() -> Bool {
    return true;
  }

  protected func GetQuickHackActions(out actions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    let currentAction: ref<ScriptableDeviceAction> = this.ActionQuickHackToggleBlockade();
    currentAction.SetObjectActionID(t"DeviceAction.ToggleStateClassHack");
    currentAction.SetInactiveWithReason(ToggleBlockade.IsDefaultConditionMet(this, context), "LocKey#7003");
    ArrayPush(actions, currentAction);
    this.FinalizeGetQuickHackActions(actions, context);
  }

  public func GetQuestActionByName(actionName: CName) -> ref<DeviceAction> {
    let action: ref<DeviceAction> = super.GetQuestActionByName(actionName);
    if action == null {
      switch actionName {
        case n"ForceRoadBlockadeActivate":
          action = this.ActionQuestForceRoadBlockadeActivate();
          break;
        case n"ForceRoadBlockadeDeactivate":
          action = this.ActionQuestForceRoadBlockadeDeactivate();
      };
    };
    return action;
  }

  public func GetQuestActions(out actions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    super.GetQuestActions(actions, context);
    ArrayPush(actions, this.ActionQuestForceRoadBlockadeActivate());
    ArrayPush(actions, this.ActionQuestForceRoadBlockadeDeactivate());
  }

  protected func ActionToggleBlockade() -> ref<ToggleBlockade> {
    let action: ref<ToggleBlockade> = new ToggleBlockade();
    action.clearanceLevel = 2;
    action.SetUp(this);
    action.SetProperties(this.IsBlocking(), this.m_nameForBlocking, this.m_nameForUnblocking);
    action.AddDeviceName(this.GetDeviceName());
    action.CreateInteraction();
    action.CreateActionWidgetPackage();
    return action;
  }

  protected func ActionQuickHackToggleBlockade() -> ref<QuickHackToggleBlockade> {
    let action: ref<QuickHackToggleBlockade> = new QuickHackToggleBlockade();
    action.clearanceLevel = 2;
    action.SetUp(this);
    action.SetProperties(this.IsBlocking(), this.m_nameForBlocking, this.m_nameForUnblocking);
    action.AddDeviceName(this.GetDeviceName());
    if this.IsBlocking() {
      action.CreateInteraction(this.m_nameForBlocking);
    } else {
      action.CreateInteraction(this.m_nameForUnblocking);
    };
    action.CreateActionWidgetPackage();
    return action;
  }

  protected final func ActionQuestForceRoadBlockadeActivate() -> ref<QuestForceRoadBlockadeActivate> {
    let action: ref<QuestForceRoadBlockadeActivate> = new QuestForceRoadBlockadeActivate();
    action.clearanceLevel = 99;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    return action;
  }

  protected final func ActionQuestForceRoadBlockadeDeactivate() -> ref<QuestForceRoadBlockadeDeactivate> {
    let action: ref<QuestForceRoadBlockadeDeactivate> = new QuestForceRoadBlockadeDeactivate();
    action.clearanceLevel = 99;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    return action;
  }

  public final func OnToggleBlockade(evt: ref<ToggleBlockade>) -> EntityNotificationType {
    this.SetIsBlockingState(!this.IsBlocking());
    this.UseNotifier(evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  public final func OnQuickHackToggleBlockadeQuickHackToggleBlockade(evt: ref<QuickHackToggleBlockade>) -> EntityNotificationType {
    this.SetIsBlockingState(!this.IsBlocking());
    this.UseNotifier(evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  public func OnQuestForceRoadBlockadeActivate(evt: ref<QuestForceRoadBlockadeActivate>) -> EntityNotificationType {
    this.SetIsBlockingState(true);
    return EntityNotificationType.SendThisEventToEntity;
  }

  public func OnQuestForceRoadBlockadeDeactivate(evt: ref<QuestForceRoadBlockadeDeactivate>) -> EntityNotificationType {
    this.SetIsBlockingState(false);
    return EntityNotificationType.SendThisEventToEntity;
  }

  protected func OnActivateDevice(evt: ref<ActivateDevice>) -> EntityNotificationType {
    if NotEquals(this.m_activationState, EActivationState.ACTIVATED) && this.IsON() {
      super.OnActivateDevice(evt);
      this.SetIsBlockingState(true);
      return EntityNotificationType.SendThisEventToEntity;
    };
    return EntityNotificationType.DoNotNotifyEntity;
  }

  protected func OnDeactivateDevice(evt: ref<DeactivateDevice>) -> EntityNotificationType {
    if NotEquals(this.m_activationState, EActivationState.DEACTIVATED) && this.IsON() {
      super.OnDeactivateDevice(evt);
      this.SetIsBlockingState(false);
      return EntityNotificationType.SendThisEventToEntity;
    };
    return EntityNotificationType.DoNotNotifyEntity;
  }

  protected func GetDeviceIconTweakDBID() -> TweakDBID {
    return t"DeviceIcons.DoorDeviceIcon";
  }

  protected func GetBackgroundTextureTweakDBID() -> TweakDBID {
    return t"DeviceIcons.DoorDeviceBackground";
  }
}
