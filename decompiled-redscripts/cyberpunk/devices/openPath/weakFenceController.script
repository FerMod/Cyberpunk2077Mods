
public class WeakFenceController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<WeakFenceControllerPS> {
    return this.GetBasePS() as WeakFenceControllerPS;
  }
}

public class WeakFenceControllerPS extends ScriptableDeviceComponentPS {

  public inline let m_weakfenceSkillChecks: ref<EngDemoContainer>;

  protected persistent let m_weakFenceSetup: WeakFenceSetup;

  protected func GetSkillCheckContainerForSetup() -> ref<BaseSkillCheckContainer> {
    if !this.m_weakFenceSetup.m_hasGenericInteraction {
      return this.m_weakfenceSkillChecks;
    };
    return null;
  }

  public func GetActions(out actions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    super.GetActions(actions, context);
    if this.m_weakFenceSetup.m_hasGenericInteraction && !this.IsDisabled() {
      ArrayPush(actions, this.ActionActivateDevice("BreakWeakFence"));
    };
    return true;
  }

  protected func ActionEngineering(const context: script_ref<GetActionsContext>) -> ref<ActionEngineering> {
    let action: ref<ActionEngineering> = super.ActionEngineering(context);
    action.ResetCaption();
    action.CreateInteraction(Deref(context).processInitiatorObject, "BreakWeakFence");
    return action;
  }

  public func OnActionEngineering(evt: ref<ActionEngineering>) -> EntityNotificationType {
    if !evt.WasPassed() {
      return EntityNotificationType.DoNotNotifyEntity;
    };
    this.DisableDevice();
    super.OnActionEngineering(evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  protected final func ActionActivateDevice(const interactionName: script_ref<String>) -> ref<ActivateDevice> {
    let action: ref<ActivateDevice> = new ActivateDevice();
    action.clearanceLevel = 2;
    action.SetUp(this);
    action.AddDeviceName(this.m_deviceName);
    action.CreateActionWidgetPackage();
    action.CreateInteraction(Deref(interactionName));
    return action;
  }

  protected func OnActivateDevice(evt: ref<ActivateDevice>) -> EntityNotificationType {
    super.OnActivateDevice(evt);
    this.DisableDevice();
    return EntityNotificationType.SendThisEventToEntity;
  }
}
