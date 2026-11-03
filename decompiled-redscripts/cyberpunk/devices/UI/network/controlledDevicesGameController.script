
public class ControlledDevicesInkGameController extends inkGameController {

  protected let m_rootWidget: wref<inkCanvas>;

  private let m_devicesStackSlot: wref<inkHorizontalPanel>;

  private let m_currentDeviceText: wref<inkText>;

  protected let m_controlledDevicesWidgetsData: [SWidgetPackage];

  private let m_isDeviceWorking_BBID: ref<CallbackHandle>;

  private let m_activeDevice_BBID: ref<CallbackHandle>;

  private let m_deviceChain_BBID: ref<CallbackHandle>;

  private let m_chainLocked_BBID: ref<CallbackHandle>;

  protected cb func OnInitialize() -> Bool {
    let canActivateOverclock: Bool;
    let rootWidgetMargin: inkMargin;
    this.m_rootWidget = this.GetRootWidget() as inkCanvas;
    this.m_devicesStackSlot = this.GetWidget(n"main_canvas/main_panel/horizontalContainer/devices_stack") as inkHorizontalPanel;
    this.m_currentDeviceText = this.GetWidget(n"main_canvas/main_panel/horizontalContainer/leftFlap/device_text") as inkText;
    this.m_rootWidget.SetVisible(false);
    this.RegisterBlackboardCallbacks();
    this.OnTakeControllOverDevice(this.GetBlackboard().GetVariant(this.GetBlackboardDef().DevicesChain));
    this.OnControlledDeviceChanged(this.GetBlackboard().GetEntityID(this.GetBlackboardDef().ActiveDevice));
    this.OnControlledDeviceWorkStateChanged(this.GetBlackboard().GetBool(this.GetBlackboardDef().IsDeviceWorking));
    canActivateOverclock = QuickHackableHelper.CanActivateOverclockedState(this.GetPlayerControlledObject());
    if canActivateOverclock {
      rootWidgetMargin = this.m_rootWidget.GetMargin();
      rootWidgetMargin.left += 180.00;
      this.m_rootWidget.SetMargin(rootWidgetMargin);
    };
  }

  protected cb func OnUninitialize() -> Bool {
    this.UnRegisterBlackboardCallbacks();
  }

  private final func GetBlackboard() -> ref<IBlackboard> {
    return this.GetBlackboardSystem().Get(this.GetBlackboardDef());
  }

  private final func RegisterBlackboardCallbacks() -> Void {
    this.m_deviceChain_BBID = this.GetBlackboard().RegisterListenerVariant(this.GetBlackboardDef().DevicesChain, this, n"OnTakeControllOverDevice");
    this.m_chainLocked_BBID = this.GetBlackboard().RegisterListenerBool(this.GetBlackboardDef().ChainLocked, this, n"OnDeviceChainLocked");
    this.m_activeDevice_BBID = this.GetBlackboard().RegisterListenerEntityID(this.GetBlackboardDef().ActiveDevice, this, n"OnControlledDeviceChanged");
    this.m_isDeviceWorking_BBID = this.GetBlackboard().RegisterListenerBool(this.GetBlackboardDef().IsDeviceWorking, this, n"OnControlledDeviceWorkStateChanged");
  }

  private final func UnRegisterBlackboardCallbacks() -> Void {
    this.GetBlackboard().UnregisterListenerVariant(GetAllBlackboardDefs().DeviceTakeControl.DevicesChain, this.m_deviceChain_BBID);
    this.GetBlackboard().UnregisterListenerBool(GetAllBlackboardDefs().DeviceTakeControl.ChainLocked, this.m_chainLocked_BBID);
    this.GetBlackboard().UnregisterListenerEntityID(GetAllBlackboardDefs().DeviceTakeControl.ActiveDevice, this.m_activeDevice_BBID);
    this.GetBlackboard().UnregisterListenerBool(GetAllBlackboardDefs().DeviceTakeControl.IsDeviceWorking, this.m_isDeviceWorking_BBID);
  }

  private final func GetBlackboardDef() -> ref<DeviceTakeControlDef> {
    return GetAllBlackboardDefs().DeviceTakeControl;
  }

  protected final func GetControlledDeviceWidget(id: Int32) -> wref<inkWidget> {
    let widget: wref<inkWidget>;
    if ArraySize(this.m_controlledDevicesWidgetsData) < id {
      if this.m_controlledDevicesWidgetsData[id].widget == null {
        ArrayErase(this.m_controlledDevicesWidgetsData, id);
      } else {
        widget = this.m_controlledDevicesWidgetsData[id].widget;
      };
    };
    return widget;
  }

  protected final func GetControlledDeviceWidget(const widgetData: script_ref<SWidgetPackage>) -> wref<inkWidget> {
    let i: Int32 = 0;
    while i < ArraySize(this.m_controlledDevicesWidgetsData) {
      if Equals(this.m_controlledDevicesWidgetsData[i].ownerID, Deref(widgetData).ownerID) && Equals(this.m_controlledDevicesWidgetsData[i].widgetName, Deref(widgetData).widgetName) && this.m_controlledDevicesWidgetsData[i].widgetTweakDBID == Deref(widgetData).widgetTweakDBID && Equals(this.m_controlledDevicesWidgetsData[i].libraryPath, Deref(widgetData).libraryPath) && Equals(this.m_controlledDevicesWidgetsData[i].libraryID, Deref(widgetData).libraryID) {
        return this.m_controlledDevicesWidgetsData[i].widget;
      };
      i += 1;
    };
    return null;
  }

  protected final func AddControlledDeviceWidget(widget: ref<inkWidget>, widgetData: SWidgetPackage) -> wref<inkWidget> {
    widgetData.widget = widget;
    ArrayPush(this.m_controlledDevicesWidgetsData, widgetData);
    return widgetData.widget;
  }

  protected final func HideControlledDeviceWidgets() -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.m_controlledDevicesWidgetsData) {
      if this.m_controlledDevicesWidgetsData[i].widget != null {
        this.m_controlledDevicesWidgetsData[i].widget.SetVisible(false);
      };
      i += 1;
    };
  }

  protected final func InitializeControlledDeviceWidget(widget: ref<inkWidget>, const widgetData: script_ref<SWidgetPackage>) -> Void {
    let customData: ref<ControlledDeviceData>;
    let controller: ref<ControlledDeviceLogicController> = widget.GetController() as ControlledDeviceLogicController;
    if controller != null {
      if Equals(Deref(widgetData).ownerIDClassName, n"SniperNestControllerPS") {
        customData = Deref(widgetData).customData as ControlledDeviceData;
        customData.m_isNest = true;
      };
      controller.Initialize(this, widgetData);
    };
    widget.SetVisible(true);
  }

  public func UpdateControlledDevicesWidgets(const widgetsData: script_ref<[SWidgetPackage]>) -> Void {
    let customData: ref<ControlledDeviceData>;
    let i: Int32;
    let widget: ref<inkWidget>;
    let widgetUserData: ref<SWidgetPackageWrapper>;
    this.HideControlledDeviceWidgets();
    i = 0;
    while i < ArraySize(Deref(widgetsData)) {
      customData = Deref(widgetsData)[i].customData as ControlledDeviceData;
      if IsDefined(customData) && customData.m_isActive {
        this.m_currentDeviceText.SetText(Deref(widgetsData)[i].displayName);
      };
      widget = this.GetControlledDeviceWidget(Deref(widgetsData)[i]);
      if widget == null {
        widgetUserData = new SWidgetPackageWrapper();
        widgetUserData.WidgetPackage = Deref(widgetsData)[i];
        if this.HasExternalLibrary(Deref(widgetsData)[i].libraryPath, Deref(widgetsData)[i].libraryID) {
          this.AsyncSpawnFromExternal(this.m_devicesStackSlot, Deref(widgetsData)[i].libraryPath, Deref(widgetsData)[i].libraryID, this, n"OnDeviceSpawned", widgetUserData);
        } else {
          this.AsyncSpawnFromLocal(this.m_devicesStackSlot, Deref(widgetsData)[i].libraryID, this, n"OnDeviceSpawned", widgetUserData);
        };
      } else {
        this.InitializeControlledDeviceWidget(widget, Deref(widgetsData)[i]);
      };
      i += 1;
    };
  }

  protected cb func OnDeviceSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
    let widgetUserData: ref<SWidgetPackageWrapper> = userData as SWidgetPackageWrapper;
    if widget != null {
      this.AddControlledDeviceWidget(widget, widgetUserData.WidgetPackage);
      this.InitializeControlledDeviceWidget(widget, widgetUserData.WidgetPackage);
    };
  }

  private final func ClearControlledDevicesStack() -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.m_controlledDevicesWidgetsData) {
      this.m_devicesStackSlot.RemoveChild(this.m_controlledDevicesWidgetsData[i].widget);
      i += 1;
    };
    ArrayClear(this.m_controlledDevicesWidgetsData);
  }

  private final func CreateSwitchCameraHint(isVisible: Bool) -> Void {
    let data: InputHintData;
    let psmBlackboard: ref<IBlackboard> = this.GetBlackboardSystem().GetLocalInstanced(this.GetPlayerControlledObject().GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    psmBlackboard.SetBool(GetAllBlackboardDefs().PlayerStateMachine.IsControllingCamera, isVisible);
    data.action = n"SwitchDeviceNext";
    data.source = n"ControlledDevicesChain";
    data.localizedLabel = "LocKey#52035";
    data.sortingPriority = 3;
    SendInputHintData(this.GetPlayerControlledObject().GetGame(), isVisible, data);
    data.action = n"SwitchDevicePrevious";
    data.source = n"ControlledDevicesChain";
    data.localizedLabel = "LocKey#52036";
    data.sortingPriority = 4;
    SendInputHintData(this.GetPlayerControlledObject().GetGame(), isVisible, data);
  }

  private final func SetRootVisibility(isVisible: Bool) -> Void {
    if isVisible {
      if !this.GetBlackboard().GetBool(this.GetBlackboardDef().ChainLocked) {
        this.m_rootWidget.SetVisible(isVisible);
        this.CreateSwitchCameraHint(isVisible);
      };
    } else {
      this.m_rootWidget.SetVisible(isVisible);
      this.CreateSwitchCameraHint(isVisible);
    };
  }

  protected cb func OnTakeControllOverDevice(value: Variant) -> Bool {
    let widgets: array<SWidgetPackage> = FromVariant<array<SWidgetPackage>>(value);
    if ArraySize(widgets) <= 1 {
      this.SetRootVisibility(false);
      this.ClearControlledDevicesStack();
    } else {
      this.SetRootVisibility(true);
      this.UpdateControlledDevicesWidgets(widgets);
    };
  }

  protected cb func OnDeviceChainLocked(value: Bool) -> Bool {
    if value {
      this.SetRootVisibility(false);
    } else {
      this.SetRootVisibility(true);
    };
  }

  protected cb func OnControlledDeviceChanged(value: EntityID) -> Bool {
    let customData: ref<ControlledDeviceData>;
    let i: Int32 = 0;
    while i < ArraySize(this.m_controlledDevicesWidgetsData) {
      customData = new ControlledDeviceData();
      if PersistentID.ExtractEntityID(this.m_controlledDevicesWidgetsData[i].ownerID) == value {
        customData.m_isActive = true;
        this.m_currentDeviceText.SetText(this.m_controlledDevicesWidgetsData[i].displayName);
      } else {
        customData.m_isActive = false;
      };
      this.m_controlledDevicesWidgetsData[i].customData = customData;
      this.InitializeControlledDeviceWidget(this.m_controlledDevicesWidgetsData[i].widget, this.m_controlledDevicesWidgetsData[i]);
      i += 1;
    };
  }

  protected cb func OnControlledDeviceWorkStateChanged(value: Bool) -> Bool;
}
