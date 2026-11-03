
public class GameplayLightController extends ElectricLightController {

  public const func GetPS() -> ref<GameplayLightControllerPS> {
    return this.GetBasePS() as GameplayLightControllerPS;
  }
}

public class GameplayLightControllerPS extends ElectricLightControllerPS {

  protected cb func OnInstantiated() -> Bool {
    super.OnInstantiated();
  }

  protected func Initialize() -> Void {
    super.Initialize();
  }

  protected func GameAttached() -> Void {
    super.GameAttached();
  }

  protected const func CanCreateAnyQuickHackActions() -> Bool {
    return true;
  }

  protected func GetQuickHackActions(out actions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    let currentAction: ref<ScriptableDeviceAction> = this.ActionQuickHackToggleON();
    currentAction.SetObjectActionID(t"DeviceAction.ToggleStateClassHack");
    currentAction.SetInactiveWithReason(ToggleON.IsDefaultConditionMet(this, context), "LocKey#7003");
    ArrayPush(actions, currentAction);
    currentAction = this.ActionQuickHackDistraction();
    currentAction.SetObjectActionID(t"DeviceAction.MalfunctionClassHack");
    currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
    if !ScriptableDeviceAction.IsDefaultConditionMet(this, context) {
      currentAction.SetInactiveWithReason(false, "LocKey#7003");
    };
    ArrayPush(actions, currentAction);
    this.FinalizeGetQuickHackActions(actions, context);
  }
}
