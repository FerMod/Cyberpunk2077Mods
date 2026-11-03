
public class RoboticArmsController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<RoboticArmsControllerPS> {
    return this.GetBasePS() as RoboticArmsControllerPS;
  }
}

public class RoboticArmsControllerPS extends ScriptableDeviceComponentPS {

  protected func GetQuickHackActions(out actions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    ArrayPush(actions, this.ActionQuickHackDistraction());
    this.FinalizeGetQuickHackActions(actions, context);
  }

  protected func ActionQuickHackDistraction() -> ref<QuickHackDistraction> {
    let action: ref<QuickHackDistraction> = super.ActionQuickHackDistraction();
    action.SetDurationValue(this.GetDistractionDuration(action));
    action.SetInactiveWithReason(!this.IsDistracting(), "LocKey#7004");
    return action;
  }

  protected const func CanCreateAnyQuickHackActions() -> Bool {
    return true;
  }
}
