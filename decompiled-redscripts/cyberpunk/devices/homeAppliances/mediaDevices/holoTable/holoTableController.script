
public class HoloTableController extends MediaDeviceController {

  public const func GetPS() -> ref<HoloTableControllerPS> {
    return this.GetBasePS() as HoloTableControllerPS;
  }
}

public class HoloTableControllerPS extends MediaDeviceControllerPS {

  protected cb func OnInstantiated() -> Bool {
    super.OnInstantiated();
    if !IsStringValid(this.m_deviceName) {
      this.m_deviceName = "LocKey#17851";
    };
  }

  protected func Initialize() -> Void {
    super.Initialize();
  }

  public final func SetMeshesAmount(value: Int32) -> Void {
    this.m_amountOfStations = value;
  }

  public func GetActions(out actions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    super.GetActions(actions, context);
    if !this.IsUserAuthorized(context.processInitiatorObject.GetEntityID()) {
      return false;
    };
    if ToggleON.IsDefaultConditionMet(this, context) {
      ArrayPush(actions, this.ActionToggleON());
    };
    this.SetActionIllegality(actions, this.m_illegalActions.regularActions);
    return true;
  }

  protected const func CanCreateAnyQuickHackActions() -> Bool {
    return true;
  }

  protected func GetQuickHackActions(out actions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    let currentAction: ref<ScriptableDeviceAction> = this.ActionQuickHackDistraction();
    currentAction.SetObjectActionID(t"DeviceAction.MalfunctionClassHack");
    currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
    currentAction.SetInactiveWithReason(ScriptableDeviceAction.IsDefaultConditionMet(this, context), "LocKey#7003");
    ArrayPush(actions, currentAction);
    this.FinalizeGetQuickHackActions(actions, context);
  }

  public func OnNextStation(evt: ref<NextStation>) -> EntityNotificationType {
    super.OnNextStation(evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  public func OnPreviousStation(evt: ref<PreviousStation>) -> EntityNotificationType {
    super.OnPreviousStation(evt);
    return EntityNotificationType.SendThisEventToEntity;
  }
}
