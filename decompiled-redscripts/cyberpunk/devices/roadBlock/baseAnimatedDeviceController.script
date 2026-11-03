
public class BaseAnimatedDeviceController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<BaseAnimatedDeviceControllerPS> {
    return this.GetBasePS() as BaseAnimatedDeviceControllerPS;
  }
}

public class BaseAnimatedDeviceControllerPS extends ScriptableDeviceComponentPS {

  private persistent let m_isActive: Bool;

  protected let m_hasInteraction: Bool;

  protected let m_randomizeAnimationTime: Bool;

  @runtimeProperty("customEditor", "TweakDBGroupInheritance;Interactions.InteractionChoice;Interactions.MountChoice")
  protected let m_nameForActivation: TweakDBID;

  @runtimeProperty("customEditor", "TweakDBGroupInheritance;Interactions.InteractionChoice;Interactions.MountChoice")
  protected let m_nameForDeactivation: TweakDBID;

  public final const quest func IsActive() -> Bool {
    return this.m_isActive;
  }

  public final const quest func IsNotActive() -> Bool {
    return !this.m_isActive;
  }

  public final const func Randomize() -> Bool {
    return this.m_randomizeAnimationTime;
  }

  protected func GameAttached() -> Void {
    if this.m_isActive {
      this.m_activationState = EActivationState.ACTIVATED;
    } else {
      this.m_activationState = EActivationState.DEACTIVATED;
    };
  }

  public func GetActions(out actions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    super.GetActions(actions, context);
    if this.m_hasInteraction || Equals(context.requestType, gamedeviceRequestType.External) {
      ArrayPush(actions, this.ActionToggleActivate());
    };
    this.SetActionIllegality(actions, this.m_illegalActions.regularActions);
    return true;
  }

  protected const func CanCreateAnyQuickHackActions() -> Bool {
    return true;
  }

  protected func GetQuickHackActions(out actions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    let currentAction: ref<ScriptableDeviceAction> = this.ActionQuickHackToggleActivate();
    currentAction.SetObjectActionID(t"DeviceAction.ToggleStateClassHack");
    ArrayPush(actions, currentAction);
    this.FinalizeGetQuickHackActions(actions, context);
  }

  public func GetQuestActionByName(actionName: CName) -> ref<DeviceAction> {
    let action: ref<DeviceAction> = super.GetQuestActionByName(actionName);
    if action == null {
      switch actionName {
        case n"ForceActivate":
          action = this.ActionQuestForceActivate();
          break;
        case n"ForceDeactivate":
          action = this.ActionQuestForceDeactivate();
      };
    };
    return action;
  }

  public func GetQuestActions(out actions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    super.GetQuestActions(actions, context);
    ArrayPush(actions, this.ActionQuestForceActivate());
    ArrayPush(actions, this.ActionQuestForceDeactivate());
  }

  protected func ActionToggleActivate() -> ref<ToggleActivate> {
    let action: ref<ToggleActivate> = new ToggleActivate();
    action.clearanceLevel = 2;
    action.SetUp(this);
    action.SetProperties(this.IsActive(), this.m_nameForActivation, this.m_nameForDeactivation);
    action.AddDeviceName(this.GetDeviceName());
    action.CreateInteraction();
    action.CreateActionWidgetPackage();
    return action;
  }

  protected func ActionQuickHackToggleActivate() -> ref<QuickHackToggleActivate> {
    let action: ref<QuickHackToggleActivate> = new QuickHackToggleActivate();
    action.clearanceLevel = 2;
    action.SetUp(this);
    action.SetProperties(this.IsActive(), this.m_nameForActivation, this.m_nameForDeactivation);
    action.AddDeviceName(this.GetDeviceName());
    if this.IsActive() {
      action.CreateInteraction(this.m_nameForActivation);
    } else {
      action.CreateInteraction(this.m_nameForDeactivation);
    };
    action.CreateActionWidgetPackage();
    return action;
  }

  public func OnToggleActivate(evt: ref<ToggleActivate>) -> EntityNotificationType {
    super.OnToggleActivate(evt);
    this.SetActiveState(!this.IsActive());
    this.NotifyParents();
    this.UseNotifier(evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  protected final func SetActiveState(isActive: Bool) -> Void {
    this.m_isActive = isActive;
  }

  public final func OnQuickHackToggleActivate(evt: ref<QuickHackToggleActivate>) -> EntityNotificationType {
    this.SetActiveState(!this.IsActive());
    this.m_activationState = this.IsActive() ? EActivationState.ACTIVATED : EActivationState.DEACTIVATED;
    this.NotifyParents();
    this.UseNotifier(evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  protected func OnActivateDevice(evt: ref<ActivateDevice>) -> EntityNotificationType {
    if NotEquals(this.m_activationState, EActivationState.ACTIVATED) && this.IsON() {
      super.OnActivateDevice(evt);
      this.SetActiveState(true);
      this.NotifyParents();
      return EntityNotificationType.SendThisEventToEntity;
    };
    return EntityNotificationType.DoNotNotifyEntity;
  }

  protected func OnDeactivateDevice(evt: ref<DeactivateDevice>) -> EntityNotificationType {
    if NotEquals(this.m_activationState, EActivationState.DEACTIVATED) && this.IsON() {
      super.OnDeactivateDevice(evt);
      this.SetActiveState(false);
      this.NotifyParents();
      return EntityNotificationType.SendThisEventToEntity;
    };
    return EntityNotificationType.DoNotNotifyEntity;
  }
}
