
public class PachinkoMachineController extends ArcadeMachineController {

  public const func GetPS() -> ref<PachinkoMachineControllerPS> {
    return this.GetBasePS() as PachinkoMachineControllerPS;
  }
}

public class PachinkoMachineControllerPS extends ArcadeMachineControllerPS {

  protected const func CanCreateAnyQuickHackActions() -> Bool {
    return true;
  }

  protected func GetQuickHackActions(out actions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    let currentAction: ref<ScriptableDeviceAction> = this.ActionQuickHackDistraction();
    currentAction.SetObjectActionID(t"DeviceAction.MalfunctionClassHack");
    currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
    currentAction.SetInactiveWithReason(ScriptableDeviceAction.IsDefaultConditionMet(this, context), "LocKey#7003");
    ArrayPush(actions, currentAction);
    if this.IsGlitching() || this.IsDistracting() {
      ScriptableDeviceComponentPS.SetActionsInactiveAll(actions, "LocKey#7004");
    };
    this.FinalizeGetQuickHackActions(actions, context);
  }
}
