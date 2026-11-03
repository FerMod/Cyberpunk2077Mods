
public class NetrunnerControlPanelController extends BasicDistractionDeviceController {

  public const func GetPS() -> ref<NetrunnerControlPanelControllerPS> {
    return this.GetBasePS() as NetrunnerControlPanelControllerPS;
  }
}

public class NetrunnerControlPanelControllerPS extends BasicDistractionDeviceControllerPS {

  private let m_factQuickHackSetup: ComputerQuickHackData;

  private persistent let m_quickhackPerformed: Bool;

  protected const func CanCreateAnyQuickHackActions() -> Bool {
    if super.CanCreateAnyQuickHackActions() || IsNameValid(this.m_factQuickHackSetup.factName) && !this.m_quickhackPerformed {
      return true;
    };
    return false;
  }

  protected func GetQuickHackActions(out actions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    let currentAction: ref<ScriptableDeviceAction>;
    if IsNameValid(this.m_factQuickHackSetup.factName) && !this.m_quickhackPerformed {
      currentAction = this.ActionCreateFactQuickHack();
      currentAction.SetObjectActionID(t"DeviceAction.MalfunctionClassHack");
      currentAction.SetInactiveWithReason(!this.IsDistracting(), "LocKey#7004");
      ArrayPush(actions, currentAction);
    };
    super.GetQuickHackActions(actions, context);
  }

  protected final func ActionCreateFactQuickHack() -> ref<FactQuickHack> {
    let action: ref<FactQuickHack> = new FactQuickHack();
    action.SetUp(this);
    action.AddDeviceName(this.m_deviceName);
    action.SetProperties(this.m_factQuickHackSetup);
    if TDBID.IsValid(this.m_factQuickHackSetup.alternativeName) {
      action.CreateInteraction(this.m_factQuickHackSetup.alternativeName);
    } else {
      action.CreateInteraction();
    };
    return action;
  }

  public final func OnCreateFactQuickHack(evt: ref<FactQuickHack>) -> EntityNotificationType {
    this.m_quickhackPerformed = true;
    return EntityNotificationType.SendThisEventToEntity;
  }
}
