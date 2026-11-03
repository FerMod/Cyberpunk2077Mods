
public class SmokeMachineController extends BasicDistractionDeviceController {

  public const func GetPS() -> ref<SmokeMachineControllerPS> {
    return this.GetBasePS() as SmokeMachineControllerPS;
  }
}

public class SmokeMachineControllerPS extends BasicDistractionDeviceControllerPS {

  protected cb func OnInstantiated() -> Bool {
    super.OnInstantiated();
  }

  protected func Initialize() -> Void {
    super.Initialize();
  }

  protected const func CanCreateAnyQuickHackActions() -> Bool {
    return true;
  }

  protected func GetQuickHackActions(out actions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    let currentAction: ref<ScriptableDeviceAction> = this.ActionOverloadDevice();
    currentAction.SetObjectActionID(t"DeviceAction.OverloadClassHack");
    ArrayPush(actions, currentAction);
    super.GetQuickHackActions(actions, context);
  }

  protected func ActionOverloadDevice() -> ref<OverloadDevice> {
    let action: ref<OverloadDevice> = new OverloadDevice();
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    action.CreateInteraction("ObscureVision");
    action.SetDurationValue(5.00);
    return action;
  }

  protected func OnOverloadDevice(evt: ref<OverloadDevice>) -> EntityNotificationType {
    if evt.IsStarted() {
      this.ExecutePSActionWithDelay(evt, this, evt.GetDurationValue());
      this.ForceDisableDevice();
    };
    this.UseNotifier(evt);
    return EntityNotificationType.SendThisEventToEntity;
  }
}
