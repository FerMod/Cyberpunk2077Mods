
public class GlitchedTurretController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<GlitchedTurretControllerPS> {
    return this.GetBasePS() as GlitchedTurretControllerPS;
  }
}

public class GlitchedTurretControllerPS extends ScriptableDeviceComponentPS {

  protected cb func OnInstantiated() -> Bool {
    super.OnInstantiated();
    if !IsStringValid(this.m_deviceName) {
      this.m_deviceName = "Gameplay-Devices-DisplayNames-TurretSecurity";
    };
  }

  protected func Initialize() -> Void {
    super.Initialize();
  }

  public func GetQuestActions(out outActions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    super.GetQuestActions(outActions, context);
    ArrayPush(outActions, this.ActionQuestForceGlitch());
  }

  protected final func ActionQuestForceGlitch() -> ref<QuestForceGlitch> {
    let action: ref<QuestForceGlitch> = new QuestForceGlitch();
    action.clearanceLevel = 99;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    return action;
  }

  public func OnQuestForceGlitch(evt: ref<QuestForceGlitch>) -> EntityNotificationType {
    let notifier: ref<ActionNotifier> = new ActionNotifier();
    notifier.SetNone();
    this.Notify(notifier, evt);
    return EntityNotificationType.SendThisEventToEntity;
  }
}

public class QuestForceGlitch extends ActionBool {

  public final func SetProperties() -> Void {
    this.actionName = n"ForceGlitch";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(n"QuestForceGlitch", true, n"QuestForceGlitch", n"QuestForceGlitch");
  }
}
