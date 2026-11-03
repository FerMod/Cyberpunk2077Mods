
public class QuickHackCallElevator extends ActionBool {

  public func GetTweakDBChoiceRecord() -> String {
    if TDBID.IsValid(this.m_objectActionID) {
      return super.GetTweakDBChoiceRecord();
    };
    return "QuickHackCallElevator";
  }
}

public class CallElevator extends ActionBool {

  public let m_destination: Int32;

  public final func SetProperties(destination: Int32) -> Void {
    this.actionName = n"CallElevator";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(n"CallElevator", true, n"LocKey#293", n"LocKey#293");
    this.m_destination = destination;
  }

  public final static func IsDefaultConditionMet(device: ref<ScriptableDeviceComponentPS>, const context: script_ref<GetActionsContext>) -> Bool {
    if CallElevator.IsAvailable(device) && CallElevator.IsClearanceValid(Deref(context).clearance) {
      return true;
    };
    return false;
  }

  public final static func IsAvailable(device: ref<ScriptableDeviceComponentPS>) -> Bool {
    if device.IsDisabled() {
      return false;
    };
    if device.IsUnpowered() {
      return false;
    };
    if !device.IsON() {
      return false;
    };
    return true;
  }

  public final static func IsClearanceValid(clearance: ref<Clearance>) -> Bool {
    if Clearance.IsInRange(clearance, 2) {
      return true;
    };
    return false;
  }

  public func GetTweakDBChoiceRecord() -> String {
    if TDBID.IsValid(this.m_objectActionID) {
      return super.GetTweakDBChoiceRecord();
    };
    return "CallElevator";
  }

  public final func CreateActionWidgetPackage(isElevatorAtThisFloor: Bool) -> Void {
    this.m_actionWidgetPackage.wasInitalized = true;
    this.m_actionWidgetPackage.widgetTweakDBID = this.GetInkWidgetTweakDBID(isElevatorAtThisFloor);
    this.m_actionWidgetPackage.widgetName = "Call Elevator";
    this.m_actionWidgetPackage.displayName = "Call Elevator";
    this.m_actionWidgetPackage.libraryPath = this.GetInkWidgetLibraryPath();
    this.m_actionWidgetPackage.libraryID = this.GetInkWidgetLibraryID();
    this.ResolveActionWidgetTweakDBData();
  }

  public final func GetInkWidgetTweakDBID(isElevatorAtThisFloor: Bool) -> TweakDBID {
    if isElevatorAtThisFloor {
      return t"DevicesUIDefinitions.EnterElevatorActionWidget";
    };
    return t"DevicesUIDefinitions.CallElevatorActionWidget";
  }
}

public struct ElevatorFloorSetup {

  public persistent let m_isHidden: Bool;

  public persistent let m_isInactive: Bool;

  @runtimeProperty("unsavable", "true")
  public persistent let m_floorMarker: NodeRef;

  public edit let m_floorName: String;

  @runtimeProperty("unsavable", "true")
  @runtimeProperty("category", "Localization")
  public persistent let m_floorDisplayName: CName;

  public let m_authorizationTextOverride: String;

  @runtimeProperty("unsavable", "true")
  public persistent const let doorShouldOpenFrontLeftRight: [Bool];

  public final static func GetFloorName(const self: script_ref<ElevatorFloorSetup>) -> String {
    let floorName: String;
    if IsNameValid(Deref(self).m_floorDisplayName) {
      floorName = NameToString(Deref(self).m_floorDisplayName);
    } else {
      floorName = Deref(self).m_floorName;
    };
    return floorName;
  }
}

public class ElevatorFloorTerminalController extends TerminalController {

  public const func GetPS() -> ref<ElevatorFloorTerminalControllerPS> {
    return this.GetBasePS() as ElevatorFloorTerminalControllerPS;
  }
}

public class ElevatorFloorTerminalControllerPS extends TerminalControllerPS {

  private persistent let m_elevatorFloorSetup: ElevatorFloorSetup;

  private edit let m_hasDirectInteration: Bool;

  protected let m_isElevatorAtThisFloor: Bool;

  protected func GameAttached() -> Void {
    this.EvaluateFloor();
  }

  public final const func GetElevatorFloorSetup() -> ElevatorFloorSetup {
    return this.m_elevatorFloorSetup;
  }

  public final const func GetAuthorizationTextOverride() -> String {
    return this.m_elevatorFloorSetup.m_authorizationTextOverride;
  }

  public final const quest func IsElevatorAtThisFloor() -> Bool {
    return this.m_isElevatorAtThisFloor;
  }

  public final func EvaluateThisFloor() -> Void {
    let devices: array<ref<DeviceComponentPS>>;
    let i: Int32;
    let liftControllerPS: ref<LiftControllerPS>;
    this.GetParents(devices);
    i = 0;
    while i < ArraySize(devices) {
      if IsDefined(devices[i] as LiftControllerPS) {
        liftControllerPS = devices[i] as LiftControllerPS;
        if Equals(liftControllerPS.GetFloorPSID(liftControllerPS.GetActiveFloor()), this.GetID()) {
          this.m_isElevatorAtThisFloor = true;
        };
      };
      i += 1;
    };
  }

  private final func EvaluateFloor() -> Void {
    if !IsNameValid(this.m_elevatorFloorSetup.m_floorDisplayName) {
      this.m_elevatorFloorSetup.m_floorDisplayName = StringToName(this.m_elevatorFloorSetup.m_floorName);
    };
  }

  protected func Initialize() -> Void {
    super.Initialize();
    if !IsStringValid(this.m_deviceName) {
      this.m_deviceName = "LocKey#88";
    };
  }

  protected func GetInkWidgetTweakDBID(const context: script_ref<GetActionsContext>) -> TweakDBID {
    return t"DevicesUIDefinitions.ElevatorFloorDeviceWidget";
  }

  public func GetThumbnailWidgets() -> [SThumbnailWidgetPackage] {
    let devices: array<ref<DeviceComponentPS>>;
    let widgetsData: array<SThumbnailWidgetPackage>;
    this.GetParents(devices);
    ArrayPush(widgetsData, devices[0].GetThumbnailWidget());
    return widgetsData;
  }

  public func GetActions(out outActions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    let scriptableAction: ref<ScriptableDeviceAction>;
    if !this.IsPlayerAuthorized() && !context.ignoresAuthorization {
      ArrayPush(outActions, this.ActionSetExposeQuickHacks());
      scriptableAction = this.ActionAuthorizeUser(this.ShouldForceAuthorizeUser(context));
      scriptableAction.SetDurationValue(0.70);
      ArrayPush(outActions, scriptableAction);
      return false;
    };
    if this.m_hasDirectInteration {
      ArrayPush(outActions, this.ActionCallElevator());
    };
    return super.GetActions(outActions, context);
  }

  protected const func CanCreateAnyQuickHackActions() -> Bool {
    return true;
  }

  protected func GetQuickHackActions(out actions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    let currentAction: ref<ScriptableDeviceAction>;
    if !this.m_isElevatorAtThisFloor {
      currentAction = this.ActionQuickHackCallElevator();
      currentAction.SetObjectActionID(t"DeviceAction.ToggleStateClassHack");
      currentAction.SetInactiveWithReason(ScriptableDeviceAction.IsDefaultConditionMet(this, context), "LocKey#7003");
      ArrayPush(actions, currentAction);
    };
    if !this.IsPlayerAuthorized() {
      currentAction = this.ActionQuickHackAuthorization();
      currentAction.SetObjectActionID(t"DeviceAction.OverrideAttitudeClassHack");
      currentAction.SetInactiveWithReason(ScriptableDeviceAction.IsDefaultConditionMet(this, context), "LocKey#7003");
      ArrayPush(actions, currentAction);
    };
    this.FinalizeGetQuickHackActions(actions, context);
  }

  protected func PushInactiveInteractionChoice(const context: script_ref<GetActionsContext>, choices: script_ref<[InteractionChoice]>) -> Void {
    let baseAction: ref<CallElevator>;
    let inactiveChoice: InteractionChoice;
    if this.m_hasDirectInteration {
      baseAction = this.ActionCallElevator();
      inactiveChoice.choiceMetaData.tweakDBName = baseAction.GetTweakDBChoiceRecord();
      inactiveChoice.caption = "DEBUG: Reason Unhandled";
      ChoiceTypeWrapper.SetType(inactiveChoice.choiceMetaData.type, gameinteractionsChoiceType.Inactive);
      if !this.IsPlayerAuthorized() {
        inactiveChoice.caption = "[UNAUTHORIZED]";
        ArrayPush(Deref(choices), inactiveChoice);
        return;
      };
    };
  }

  protected func ActionQuickHackCallElevator() -> ref<QuickHackCallElevator> {
    let action: ref<QuickHackCallElevator> = new QuickHackCallElevator();
    action.clearanceLevel = 1;
    action.SetUp(this);
    action.AddDeviceName(this.GetDeviceName());
    action.CreateInteraction();
    return action;
  }

  public final func ActionQuickHackAuthorization() -> ref<QuickHackAuthorization> {
    let action: ref<QuickHackAuthorization> = new QuickHackAuthorization();
    action.clearanceLevel = 2;
    action.SetUp(this);
    action.AddDeviceName(this.m_deviceName);
    action.CreateInteraction();
    return action;
  }

  protected func ActionAuthorizeUser(opt isForced: Bool) -> ref<AuthorizeUser> {
    let action: ref<AuthorizeUser> = new AuthorizeUser();
    action.clearanceLevel = 9;
    action.SetUp(this);
    action.SetProperties(this.GetPasswords(), isForced);
    action.AddDeviceName(this.GetDeviceName());
    action.CreateActionWidgetPackage(n"elevator", this.GetAuthorizationTextOverride());
    return action;
  }

  private final func ActionCallElevator() -> ref<CallElevator> {
    let action: ref<CallElevator> = new CallElevator();
    action.clearanceLevel = 2;
    action.SetUp(this);
    action.SetProperties(0);
    action.AddDeviceName(this.m_deviceName);
    action.CreateInteraction();
    return action;
  }

  public final func OnQuickHackCallElevator(evt: ref<QuickHackCallElevator>) -> EntityNotificationType {
    this.m_authorizationProperties.m_isAuthorizationModuleOn = false;
    this.HackCallElevator();
    this.UseNotifier(evt);
    return EntityNotificationType.DoNotNotifyEntity;
  }

  public final func OnCallElevator(evt: ref<CallElevator>) -> EntityNotificationType {
    if this.IsPlayerAuthorized() {
      this.CallElevator();
      this.UseNotifier(evt);
    };
    return EntityNotificationType.DoNotNotifyEntity;
  }

  public func OnQuickHackAuthorization(evt: ref<QuickHackAuthorization>) -> EntityNotificationType {
    let notifier: ref<ActionNotifier> = new ActionNotifier();
    notifier.SetNone();
    this.m_authorizationProperties.m_isAuthorizationModuleOn = false;
    this.SendQuickHackAuthorizationToParents();
    this.RefreshUI(this.GetBlackboard());
    if this.IsElevatorAtThisFloor() {
      this.UnlockConnectedDoors();
    };
    if !IsFinal() {
    };
    this.Notify(notifier, evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  protected final func SendQuickHackAuthorizationToParents() -> Void {
    let i: Int32;
    let parents: array<ref<DeviceComponentPS>>;
    let evt: ref<QuickHackAuthorization> = new QuickHackAuthorization();
    this.GetParents(parents);
    i = 0;
    while i < ArraySize(parents) {
      if IsDefined(parents[i] as LiftControllerPS) {
        this.GetPersistencySystem().QueuePSEvent(parents[i].GetID(), parents[i].GetClassName(), evt);
      };
      i += 1;
    };
  }

  public func OnAuthorizeUser(evt: ref<AuthorizeUser>) -> EntityNotificationType {
    if evt.IsStarted() {
      this.ExecutePSActionWithDelay(evt, this, evt.GetDurationValue());
      return EntityNotificationType.DoNotNotifyEntity;
    };
    this.UseNotifier(evt);
    if this.IsPlayerAuthorized() {
      return EntityNotificationType.SendPSChangedEventToEntity;
    };
    return EntityNotificationType.DoNotNotifyEntity;
  }

  public func GetDeviceWidgets() -> [SDeviceWidgetPackage] {
    let devices: array<ref<DeviceComponentPS>>;
    let i: Int32;
    let widgetData: SDeviceWidgetPackage;
    let widgetsData: array<SDeviceWidgetPackage>;
    this.GetParents(devices);
    i = 0;
    while i < ArraySize(devices) {
      if IsDefined(devices[i] as LiftControllerPS) {
        widgetData = devices[i].GetDeviceWidget(this.GenerateContext(gamedeviceRequestType.External, this.GetClearance()));
        ArrayPush(widgetsData, widgetData);
      };
      i += 1;
    };
    return widgetsData;
  }

  public func GetSlaveDeviceWidget(deviceID: PersistentID) -> SDeviceWidgetPackage {
    let devices: array<ref<DeviceComponentPS>>;
    let i: Int32;
    let widgetData: SDeviceWidgetPackage;
    this.GetParents(devices);
    i = 0;
    while i < ArraySize(devices) {
      if IsDefined(devices[i] as LiftControllerPS) {
        widgetData = devices[i].GetDeviceWidget(this.GenerateContext(gamedeviceRequestType.External, this.GetClearance()));
        break;
      };
      i += 1;
    };
    return widgetData;
  }

  public func GetDeviceWidget(const context: script_ref<GetActionsContext>) -> SDeviceWidgetPackage {
    let widgetData: SDeviceWidgetPackage = super.GetDeviceWidget(context);
    widgetData.displayName = ElevatorFloorSetup.GetFloorName(this.m_elevatorFloorSetup);
    return widgetData;
  }

  public final func OnLiftArrived(evt: ref<LiftArrivedEvent>) -> EntityNotificationType {
    this.UnlockConnectedDoors();
    this.m_isElevatorAtThisFloor = true;
    return EntityNotificationType.DoNotNotifyEntity;
  }

  public final func OnLiftDeparted(evt: ref<LiftDepartedEvent>) -> EntityNotificationType {
    this.LockConnectedDoors();
    this.m_isElevatorAtThisFloor = false;
    return EntityNotificationType.DoNotNotifyEntity;
  }

  public final func OnLiftFloorSyncDataEvent(evt: ref<LiftFloorSyncDataEvent>) -> EntityNotificationType {
    this.m_elevatorFloorSetup.m_isHidden = evt.isHidden;
    this.m_elevatorFloorSetup.m_isInactive = evt.isInactive;
    return EntityNotificationType.DoNotNotifyEntity;
  }

  private final func UnlockConnectedDoors() -> Void {
    let LockAction: ref<ForceUnlockAndOpenElevator>;
    let devices: array<ref<DeviceComponentPS>> = this.GetImmediateSlaves();
    let i: Int32 = 0;
    while i < ArraySize(devices) {
      if IsDefined(devices[i] as DoorControllerPS) && this.IsPlayerAuthorized() {
        LockAction = this.ActionForceUnlockAndOpenElevator(devices[i] as DoorControllerPS);
        if IsDefined(LockAction) && ((devices[i] as DoorControllerPS).IsLocked() || (devices[i] as DoorControllerPS).IsClosed()) {
          this.GetPersistencySystem().QueuePSDeviceEvent(LockAction);
        };
      };
      i += 1;
    };
  }

  private final func LockConnectedDoors() -> Void {
    let LockAction: ref<ForceLockElevator>;
    let devices: array<ref<DeviceComponentPS>> = this.GetImmediateSlaves();
    let i: Int32 = 0;
    while i < ArraySize(devices) {
      if IsDefined(devices[i] as DoorControllerPS) {
        LockAction = this.ActionForceLockElevator(devices[i] as DoorControllerPS);
        if IsDefined(LockAction) && !(devices[i] as DoorControllerPS).IsLocked() {
          this.GetPersistencySystem().QueuePSDeviceEvent(LockAction);
        };
      };
      i += 1;
    };
  }

  private final func CallElevator() -> Void {
    let callElevator: ref<CallElevator>;
    let context: GetActionsContext;
    let devices: array<ref<DeviceComponentPS>>;
    let i: Int32;
    context.requestType = gamedeviceRequestType.External;
    context.requestorID = this.GetMyEntityID();
    this.GetParents(devices);
    i = 0;
    while i < ArraySize(devices) {
      if IsDefined(devices[i] as LiftControllerPS) {
        callElevator = (devices[i] as LiftControllerPS).GetActionByName(n"CallElevator", context) as CallElevator;
        if IsDefined(callElevator) {
          this.GetPersistencySystem().QueuePSDeviceEvent(callElevator);
        };
      };
      i += 1;
    };
  }

  public final const func IsLiftMoving() -> Bool {
    let devices: array<ref<DeviceComponentPS>>;
    let i: Int32;
    this.GetParents(devices);
    i = 0;
    while i < ArraySize(devices) {
      if IsDefined(devices[i] as LiftControllerPS) {
        return (devices[i] as LiftControllerPS).IsMoving();
      };
      i += 1;
    };
    return false;
  }

  private final func HackCallElevator() -> Void {
    let callElevator: ref<CallElevator>;
    let context: GetActionsContext;
    let devices: array<ref<DeviceComponentPS>>;
    let i: Int32;
    context.clearance = Clearance.CreateClearance(0, 100);
    context.requestType = gamedeviceRequestType.External;
    context.requestorID = this.GetMyEntityID();
    context.ignoresAuthorization = true;
    this.GetParents(devices);
    i = 0;
    while i < ArraySize(devices) {
      if IsDefined(devices[i] as LiftControllerPS) {
        callElevator = (devices[i] as LiftControllerPS).GetActionByName(n"CallElevator", context) as CallElevator;
        if IsDefined(callElevator) {
          this.GetPersistencySystem().QueuePSDeviceEvent(callElevator);
        };
      };
      i += 1;
    };
  }

  protected final func ActionForceLockElevator(targetDevicePS: ref<PersistentState>) -> ref<ForceLockElevator> {
    let action: ref<ForceLockElevator> = new ForceLockElevator();
    action.clearanceLevel = 5;
    action.SetUp(targetDevicePS);
    action.SetProperties();
    action.AddDeviceName("ElevatorDoor");
    return action;
  }

  protected final func ActionForceUnlockAndOpenElevator(targetDevicePS: ref<PersistentState>) -> ref<ForceUnlockAndOpenElevator> {
    let action: ref<ForceUnlockAndOpenElevator> = new ForceUnlockAndOpenElevator();
    action.clearanceLevel = 5;
    action.SetUp(targetDevicePS);
    action.SetProperties();
    action.AddDeviceName("ElevatorDoor");
    return action;
  }

  public func TurnAuthorizationModuleOFF() -> Void {
    this.m_authorizationProperties.m_isAuthorizationModuleOn = false;
  }
}
