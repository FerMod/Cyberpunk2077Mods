
public class ElevatorInkGameController extends DeviceInkGameControllerBase {

  @runtimeProperty("category", "Widget Refs")
  private edit let m_verticalPanel: inkVerticalPanelRef;

  @runtimeProperty("category", "Widget Refs")
  private edit let m_currentFloorTextWidget: inkTextRef;

  @runtimeProperty("category", "Widget Refs")
  private edit let m_openCloseButtonWidgets: inkCanvasRef;

  @runtimeProperty("category", "Widget Refs")
  private edit let m_elevatorUpArrowsWidget: inkFlexRef;

  @runtimeProperty("category", "Widget Refs")
  private edit let m_elevatorDownArrowsWidget: inkFlexRef;

  @runtimeProperty("category", "Widget Refs")
  private edit let m_waitingStateWidget: inkCanvasRef;

  @runtimeProperty("category", "Widget Refs")
  private edit let m_dataScanningWidget: inkCanvasRef;

  @runtimeProperty("category", "Widget Refs")
  private edit let m_elevatorStoppedWidget: inkCanvasRef;

  protected let m_isPlayerScanned: Bool;

  protected let m_isPaused: Bool;

  protected let m_isAuthorized: Bool;

  protected let m_animProxy: ref<inkAnimProxy>;

  protected edit const let m_buttonSizes: [Float];

  private let m_onChangeFloorListener: ref<CallbackHandle>;

  private let m_onPlayerScannedListener: ref<CallbackHandle>;

  private let m_onPausedChangeListener: ref<CallbackHandle>;

  protected func SetupWidgets() -> Void {
    if !this.m_isInitialized {
      this.InitializeCurrentFloorName();
    };
  }

  protected final func InitializeCurrentFloorName() -> Void {
    let lift: ref<LiftDevice> = this.GetOwner();
    if IsDefined(lift) {
      this.SetCurrentFloorOnUI(lift.GetBlackboard().GetString(lift.GetBlackboardDef().CurrentFloor));
    };
  }

  public func UpdateActionWidgets(const widgetsData: script_ref<[SActionWidgetPackage]>) -> Void {
    let animOptions: inkAnimOptions;
    let i: Int32;
    let isAuthorized: Bool;
    let isListEmpty: Bool;
    let isMoving: Int32;
    let isOn: Bool;
    let isPowered: Bool;
    let widget: ref<inkWidget>;
    this.HideActionWidgets();
    inkWidgetRef.SetVisible(this.m_elevatorDownArrowsWidget, false);
    inkWidgetRef.SetVisible(this.m_elevatorUpArrowsWidget, false);
    inkWidgetRef.SetVisible(this.m_waitingStateWidget, false);
    inkWidgetRef.SetVisible(this.m_dataScanningWidget, false);
    inkWidgetRef.SetVisible(this.m_elevatorStoppedWidget, false);
    this.m_animProxy.Pause();
    animOptions.loopType = inkanimLoopType.Cycle;
    animOptions.loopInfinite = true;
    if IsDefined(this.GetOwner()) {
      isMoving = this.GetOwner().GetMovingMode();
      isPowered = this.GetOwner().GetDevicePS().IsPowered();
      isOn = this.GetOwner().GetDevicePS().IsON();
      isAuthorized = this.GetOwner().GetDevicePS().IsPlayerAuthorized();
    };
    if this.m_isPaused {
      inkWidgetRef.SetVisible(this.m_elevatorStoppedWidget, true);
      this.m_animProxy = this.PlayLibraryAnimation(n"elevator_stopped", animOptions);
      return;
    };
    if !this.m_isPlayerScanned && isPowered && isOn {
      this.m_isPlayerScanned = this.GetOwner().GetBlackboard().GetBool(GetAllBlackboardDefs().ElevatorDeviceBlackboard.isPlayerScanned);
      if !this.m_isPlayerScanned {
        inkWidgetRef.SetVisible(this.m_dataScanningWidget, true);
        this.m_animProxy = this.PlayLibraryAnimation(n"data_scanning", animOptions);
        return;
      };
    };
    i = 0;
    while i < ArraySize(Deref(widgetsData)) {
      widget = this.GetActionWidget(Deref(widgetsData)[i]);
      if widget == null {
        this.CreateActionWidgetAsync(inkWidgetRef.Get(this.m_verticalPanel), Deref(widgetsData)[i]);
      } else {
        this.RefreshFloor(widget, Deref(widgetsData)[i], i, ArraySize(Deref(widgetsData)));
      };
      i += 1;
    };
    if !isAuthorized {
      (widget.GetController() as DeviceButtonLogicControllerBase).SetButtonSize(100.00, this.m_buttonSizes[0]);
      return;
    };
    isListEmpty = ArraySize(Deref(widgetsData)) == 0;
    if isListEmpty {
      if isMoving > 0 {
        inkWidgetRef.SetVisible(this.m_elevatorUpArrowsWidget, true);
        (inkWidgetRef.GetController(this.m_elevatorUpArrowsWidget) as ElevatorArrowsLogicController).PlayAnimationsArrowsUp();
      } else {
        if isMoving < 0 {
          inkWidgetRef.SetVisible(this.m_elevatorDownArrowsWidget, true);
          (inkWidgetRef.GetController(this.m_elevatorDownArrowsWidget) as ElevatorArrowsLogicController).PlayAnimationsArrowsDown();
        } else {
          if isMoving == 0 {
            this.HideActionWidgets();
            inkWidgetRef.SetVisible(this.m_waitingStateWidget, true);
            this.m_animProxy = this.PlayLibraryAnimation(n"waiting_for_elevator", animOptions);
          };
        };
      };
    };
  }

  protected final func RefreshFloor(widget: ref<inkWidget>, const widgetData: script_ref<SActionWidgetPackage>, floorNumber: Int32, maxFloors: Int32) -> Void {
    this.InitializeActionWidget(widget, widgetData);
    switch maxFloors {
      case 1:
        (widget.GetController() as DeviceButtonLogicControllerBase).SetButtonSize(100.00, this.m_buttonSizes[0]);
        break;
      case 2:
        (widget.GetController() as DeviceButtonLogicControllerBase).SetButtonSize(100.00, this.m_buttonSizes[1]);
        break;
      case 3:
        (widget.GetController() as DeviceButtonLogicControllerBase).SetButtonSize(100.00, this.m_buttonSizes[2]);
        break;
      case 4:
        (widget.GetController() as DeviceButtonLogicControllerBase).SetButtonSize(100.00, this.m_buttonSizes[3]);
        break;
      case 5:
        (widget.GetController() as DeviceButtonLogicControllerBase).SetButtonSize(100.00, this.m_buttonSizes[4]);
    };
    inkCompoundRef.ReorderChild(this.m_verticalPanel, widget, floorNumber);
  }

  protected cb func OnActionWidgetSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
    super.OnActionWidgetSpawned(widget, userData);
    this.Refresh(this.GetOwner().GetDeviceState());
  }

  public final func SetCurrentFloorOnUI(const floorName: script_ref<String>) -> Void {
    inkTextRef.SetLetterCase(this.m_currentFloorTextWidget, textLetterCase.UpperCase);
    inkTextRef.SetLocalizedTextScript(this.m_currentFloorTextWidget, floorName);
  }

  protected func GetOwner() -> ref<LiftDevice> {
    return this.GetOwnerEntity() as LiftDevice;
  }

  protected func RegisterBlackboardCallbacks(blackboard: ref<IBlackboard>) -> Void {
    super.RegisterBlackboardCallbacks(blackboard);
    if IsDefined(blackboard) {
      this.m_onChangeFloorListener = blackboard.RegisterListenerString(this.GetOwner().GetBlackboardDef().CurrentFloor, this, n"OnChangeFloor");
      this.m_onPlayerScannedListener = blackboard.RegisterListenerBool(this.GetOwner().GetBlackboardDef().isPlayerScanned, this, n"OnPlayerScanned");
      this.m_onPausedChangeListener = blackboard.RegisterListenerBool(this.GetOwner().GetBlackboardDef().isPaused, this, n"OnPausedChange");
    };
  }

  protected func UnRegisterBlackboardCallbacks(blackboard: ref<IBlackboard>) -> Void {
    super.UnRegisterBlackboardCallbacks(blackboard);
    if IsDefined(blackboard) {
      blackboard.UnregisterListenerString(this.GetOwner().GetBlackboardDef().CurrentFloor, this.m_onChangeFloorListener);
      blackboard.UnregisterListenerBool(this.GetOwner().GetBlackboardDef().isPlayerScanned, this.m_onPlayerScannedListener);
      blackboard.UnregisterListenerBool(this.GetOwner().GetBlackboardDef().isPaused, this.m_onPausedChangeListener);
    };
  }

  protected cb func OnPlayerScanned(value: Bool) -> Bool {
    if NotEquals(this.m_isPlayerScanned, value) {
      this.m_isPlayerScanned = value;
      this.Refresh(this.GetOwner().GetDeviceState());
    };
  }

  protected cb func OnPausedChange(value: Bool) -> Bool {
    if NotEquals(this.m_isPaused, value) {
      this.m_isPaused = value;
      this.Refresh(this.GetOwner().GetDeviceState());
    };
  }

  protected cb func OnChangeFloor(value: String) -> Bool {
    this.SetCurrentFloorOnUI(value);
  }

  public func Refresh(state: EDeviceStatus) -> Void {
    this.SetupWidgets();
    super.Refresh(state);
    this.RequestActionWidgetsUpdate();
  }
}

public class ElevatorTerminalFakeGameController extends DeviceInkGameControllerBase {

  private edit let m_elevatorTerminalWidget: inkCanvasRef;

  public func Refresh(state: EDeviceStatus) -> Void {
    let widgetPackage: SDeviceWidgetPackage;
    super.Refresh(state);
    (inkWidgetRef.GetController(this.m_elevatorTerminalWidget) as ElevatorTerminalLogicController).Initialize(this, widgetPackage);
  }
}
