
public class DataTermController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<DataTermControllerPS> {
    return this.GetBasePS() as DataTermControllerPS;
  }
}

public class FastTravelDeviceAction extends ActionBool {

  private let m_fastTravelPointData: ref<FastTravelPointData>;

  public final func SetProperties(data: ref<FastTravelPointData>) -> Void {
    this.m_fastTravelPointData = data;
    let displayName: CName = StringToName(TweakDBInterface.GetFastTravelPointRecord(data.GetPointRecord()).DisplayName());
    this.actionName = n"FastTravel";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(n"FastTravel", true, displayName, displayName);
  }

  public final static func IsDefaultConditionMet(device: ref<ScriptableDeviceComponentPS>, const context: script_ref<GetActionsContext>) -> Bool {
    if FastTravelDeviceAction.IsAvailable(device) && FastTravelDeviceAction.IsClearanceValid(Deref(context).clearance) {
      return true;
    };
    return false;
  }

  public final static func IsAvailable(device: ref<ScriptableDeviceComponentPS>) -> Bool {
    if device.IsUnpowered() || device.IsDisabled() {
      return false;
    };
    return true;
  }

  public final static func IsClearanceValid(clearance: ref<Clearance>) -> Bool {
    if Clearance.IsInRange(clearance, 99) {
      return true;
    };
    return false;
  }

  public func CreateActionWidgetPackage(opt actions: [ref<DeviceAction>]) -> Void {
    let widgetName: String = TweakDBInterface.GetFastTravelPointRecord(this.m_fastTravelPointData.GetPointRecord()).DisplayName();
    super.CreateActionWidgetPackage(actions);
    this.m_actionWidgetPackage.widgetName = widgetName;
  }

  public final const func GetFastTravelPointData() -> ref<FastTravelPointData> {
    return this.m_fastTravelPointData;
  }
}

public class OpenWorldMapDeviceAction extends ActionBool {

  private let m_fastTravelPointData: ref<FastTravelPointData>;

  public final func SetProperties() -> Void {
    this.actionName = n"OpenWorldMapDeviceAction";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(n"OpenWorldMapDeviceAction", true, n"LocKey#2057", n"LocKey#2057");
  }

  public final static func IsDefaultConditionMet(device: ref<ScriptableDeviceComponentPS>, const context: script_ref<GetActionsContext>) -> Bool {
    if OpenWorldMapDeviceAction.IsAvailable(device) && OpenWorldMapDeviceAction.IsClearanceValid(Deref(context).clearance) {
      return true;
    };
    return false;
  }

  public final static func IsAvailable(device: ref<ScriptableDeviceComponentPS>) -> Bool {
    if device.IsUnpowered() || device.IsDisabled() {
      return false;
    };
    return true;
  }

  public final static func IsClearanceValid(clearance: ref<Clearance>) -> Bool {
    if Clearance.IsInRange(clearance, 99) {
      return true;
    };
    return false;
  }

  public func GetTweakDBChoiceRecord() -> String {
    return "SellectDestination";
  }
}

public class DataTermControllerPS extends ScriptableDeviceComponentPS {

  private let m_linkedFastTravelPoint: ref<FastTravelPointData>;

  @default(DataTermControllerPS, EFastTravelTriggerType.Manual)
  private edit let m_triggerType: EFastTravelTriggerType;

  @default(DataTermControllerPS, EFastTravelDeviceType.DataTerm)
  private edit let m_fastTravelDeviceType: EFastTravelDeviceType;

  public final const func GetFastravelTriggerType() -> EFastTravelTriggerType {
    return this.m_triggerType;
  }

  public final const func GetFastravelDeviceType() -> EFastTravelDeviceType {
    return this.m_fastTravelDeviceType;
  }

  public func GetActions(out actions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    if !super.GetActions(actions, context) {
      return false;
    };
    if IsDefined(context.processInitiatorObject) && !this.IsUserAuthorized(context.processInitiatorObject.GetEntityID()) {
      return false;
    };
    if Equals(this.GetFastravelTriggerType(), EFastTravelTriggerType.Manual) && NotEquals(this.GetFastravelDeviceType(), EFastTravelDeviceType.SubwayGate) && this.GetFastTravelSystem().IsFastTravelEnabled() {
      ArrayPush(actions, this.ActionOpenWorldMap());
    };
    this.SetActionIllegality(actions, this.m_illegalActions.regularActions);
    return true;
  }

  public const func GetBlackboardDef() -> ref<DataTermDeviceBlackboardDef> {
    return GetAllBlackboardDefs().DataTermDeviceBlackboard;
  }

  protected final func ActionFastTravel(actionData: ref<FastTravelPointData>) -> ref<FastTravelDeviceAction> {
    let action: ref<FastTravelDeviceAction> = new FastTravelDeviceAction();
    action.SetUp(this);
    action.SetProperties(actionData);
    action.AddDeviceName(this.m_deviceName);
    action.CreateActionWidgetPackage();
    return action;
  }

  public func OnFastTravelAction(evt: ref<FastTravelDeviceAction>) -> EntityNotificationType {
    let notifier: ref<ActionNotifier> = new ActionNotifier();
    notifier.SetNone();
    if this.IsUnpowered() || this.IsDisabled() {
      return this.SendActionFailedEvent(evt, evt.GetRequesterID(), "Unpowered or Disabled");
    };
    if !IsFinal() {
    };
    this.Notify(notifier, evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  protected final func ActionOpenWorldMap() -> ref<OpenWorldMapDeviceAction> {
    let action: ref<OpenWorldMapDeviceAction> = new OpenWorldMapDeviceAction();
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    action.CreateActionWidgetPackage();
    action.CreateInteraction();
    return action;
  }

  public func OnOpenWorldMapAction(evt: ref<OpenWorldMapDeviceAction>) -> EntityNotificationType {
    let notifier: ref<ActionNotifier> = new ActionNotifier();
    notifier.SetNone();
    if this.IsUnpowered() || this.IsDisabled() {
      return this.SendActionFailedEvent(evt, evt.GetRequesterID(), "Unpowered or Disabled");
    };
    if !IsFinal() {
    };
    this.Notify(notifier, evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  public final func SetLinkedFastTravelPoint(point: ref<FastTravelPointData>) -> Void {
    this.m_linkedFastTravelPoint = point;
  }

  private final func GetFastTravelSystem() -> ref<FastTravelSystem> {
    return GameInstance.GetScriptableSystemsContainer(this.GetGameInstance()).Get(n"FastTravelSystem") as FastTravelSystem;
  }
}
