
public class DataTermInkGameController extends DeviceInkGameControllerBase {

  private let m_fcPointsPanel: wref<inkHorizontalPanel>;

  private let m_districtText: wref<inkText>;

  private let m_pointText: wref<inkText>;

  private let m_point: wref<FastTravelPointData>;

  private let m_onFastTravelPointUpdateListener: ref<CallbackHandle>;

  private let m_onToggleHologramListener: ref<CallbackHandle>;

  protected func RegisterBlackboardCallbacks(blackboard: ref<IBlackboard>) -> Void {
    super.RegisterBlackboardCallbacks(blackboard);
    if IsDefined(blackboard) {
      this.m_onFastTravelPointUpdateListener = blackboard.RegisterListenerVariant(this.GetOwner().GetBlackboardDef().fastTravelPoint, this, n"OnFastTravelPointUpdate");
      this.m_onToggleHologramListener = blackboard.RegisterDelayedListenerBool(this.GetOwner().GetBlackboardDef().subwayGateOpen, this, n"OnToggleHologram");
    };
  }

  protected func UnRegisterBlackboardCallbacks(blackboard: ref<IBlackboard>) -> Void {
    super.UnRegisterBlackboardCallbacks(blackboard);
    if IsDefined(blackboard) {
      blackboard.UnregisterListenerVariant(this.GetOwner().GetBlackboardDef().fastTravelPoint, this.m_onFastTravelPointUpdateListener);
      blackboard.UnregisterListenerBool(this.GetOwner().GetBlackboardDef().subwayGateOpen, this.m_onToggleHologramListener);
    };
  }

  protected cb func OnToggleHologram(subwayGateOpen: Bool) -> Bool {
    let deviceState: EDeviceStatus = this.GetDeviceState();
    this.ResolveHologramState(subwayGateOpen, deviceState);
  }

  protected final func ResolveHologramState(shouldBeOpen: Bool, deviceState: EDeviceStatus) -> Void {
    if GameInstance.GetQuestsSystem(this.GetOwner().GetGame()).GetFact(n"watson_prolog_lock") >= 1 || this.GetOwner().IsSubwayGateBroken() {
      return;
    };
    if NotEquals(deviceState, EDeviceStatus.ON) {
      if shouldBeOpen {
        this.PlayLibraryAnimation(n"gate_open_red");
      } else {
        this.PlayLibraryAnimation(n"gate_open_red", this.CreateAnimPlaybackOverrideData());
      };
    } else {
      if shouldBeOpen {
        this.PlayLibraryAnimation(n"gate_open_green");
      } else {
        this.PlayLibraryAnimation(n"gate_open_green", this.CreateAnimPlaybackOverrideData());
      };
    };
  }

  protected final func UpdateSubwayHologramDefaultState(deviceState: EDeviceStatus) -> Void {
    let animSetup: inkAnimOptions;
    let random: Int32 = RandRange(0, 4);
    let ncartLock: Int32 = GameInstance.GetQuestsSystem(this.GetOwner().GetGame()).GetFact(n"watson_prolog_lock");
    if ncartLock <= 0 {
      if !this.GetOwner().IsSubwayGateBroken() {
        switch deviceState {
          case EDeviceStatus.DISABLED:
            this.PlayLibraryAnimation(n"show_red");
            break;
          case EDeviceStatus.UNPOWERED:
            this.PlayLibraryAnimation(n"show_red");
            break;
          case EDeviceStatus.ON:
            this.PlayLibraryAnimation(n"show_green");
            break;
          case EDeviceStatus.OFF:
            this.PlayLibraryAnimation(n"show_red");
        };
      } else {
        animSetup.loopInfinite = true;
        animSetup.loopType = inkanimLoopType.Cycle;
        animSetup.dependsOnTimeDilation = true;
        switch random {
          case 1:
            this.PlayLibraryAnimation(n"pacifica1", animSetup);
            break;
          case 1:
            this.PlayLibraryAnimation(n"pacifica2", animSetup);
            break;
          case 1:
            this.PlayLibraryAnimation(n"pacifica3", animSetup);
        };
      };
    } else {
      animSetup.loopInfinite = true;
      animSetup.loopType = inkanimLoopType.Cycle;
      animSetup.dependsOnTimeDilation = true;
      this.PlayLibraryAnimation(n"show_blockade", animSetup);
    };
  }

  private final func CreateAnimPlaybackOverrideData() -> inkAnimOptions {
    let playbackOptionsOverrideData: inkAnimOptions;
    playbackOptionsOverrideData.playReversed = true;
    playbackOptionsOverrideData.loopInfinite = false;
    playbackOptionsOverrideData.loopType = inkanimLoopType.None;
    return playbackOptionsOverrideData;
  }

  protected func SetupWidgets() -> Void {
    if !this.m_isInitialized {
      this.m_fcPointsPanel = this.GetWidget(n"safeArea\\PointsButtonsPanel") as inkHorizontalPanel;
      this.m_districtText = this.GetWidget(n"safeArea\\district_name_holder\\district_name") as inkText;
      this.m_pointText = this.GetWidget(n"safeArea\\point_name_holder\\point_name") as inkText;
    };
  }

  public func UpdateActionWidgets(const widgetsData: script_ref<[SActionWidgetPackage]>) -> Void {
    let i: Int32;
    let widget: ref<inkWidget>;
    super.UpdateActionWidgets(widgetsData);
    i = 0;
    while i < ArraySize(Deref(widgetsData)) {
      widget = this.GetActionWidget(Deref(widgetsData)[i]);
      if widget == null {
        this.CreateActionWidgetAsync(this.m_fcPointsPanel, Deref(widgetsData)[i]);
      } else {
        this.InitializeActionWidget(widget, Deref(widgetsData)[i]);
      };
      i += 1;
    };
  }

  protected func GetOwner() -> ref<DataTerm> {
    return this.GetOwnerEntity() as DataTerm;
  }

  private final func GetIsSubwayGate() -> Bool {
    return Equals(this.GetOwner().GetDevicePS().GetFastravelDeviceType(), EFastTravelDeviceType.SubwayGate);
  }

  private final func GetFastTravelSystem() -> ref<FastTravelSystem> {
    return GameInstance.GetScriptableSystemsContainer(this.GetOwner().GetGame()).Get(n"FastTravelSystem") as FastTravelSystem;
  }

  public func Refresh(state: EDeviceStatus) -> Void {
    this.SetupWidgets();
    super.Refresh(state);
    switch state {
      case EDeviceStatus.ON:
        this.TurnOn();
        break;
      case EDeviceStatus.OFF:
        this.TurnOff();
        break;
      case EDeviceStatus.UNPOWERED:
        this.TurnOff();
        break;
      case EDeviceStatus.DISABLED:
        this.TurnOff();
        break;
      default:
    };
    if this.GetIsSubwayGate() {
      this.UpdateSubwayHologramDefaultState(state);
      this.m_rootWidget.SetVisible(true);
    };
  }

  protected final func TurnOn() -> Void {
    this.GetRootWidget().SetVisible(true);
    this.RequestActionWidgetsUpdate();
    if this.m_point == null {
      this.m_point = this.GetOwner().GetFastravelPointData();
    };
    this.UpdatePointText();
  }

  protected final func TurnOff() -> Void {
    if !this.GetIsSubwayGate() {
      this.GetRootWidget().SetVisible(false);
    };
  }

  protected cb func OnFastTravelPointUpdate(value: Variant) -> Bool {
    let point: ref<FastTravelPointData> = FromVariant<ref<FastTravelPointData>>(value);
    this.m_point = point;
    this.UpdatePointText();
  }

  private final func UpdatePointText() -> Void {
    let districtName: String;
    let pointName: String;
    if !this.GetFastTravelSystem().IsFastTravelEnabled() {
      pointName = "LocKey#20482";
    } else {
      if this.m_point != null {
        pointName = this.m_point.GetPointDisplayName();
      };
    };
    if this.m_point != null {
      districtName = this.m_point.GetDistrictDisplayName();
    };
    this.m_districtText.SetLocalizedTextScript(districtName);
    this.m_pointText.SetLocalizedTextScript(pointName);
  }

  protected cb func OnActionWidgetSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
    widget.SetInteractive(true);
    super.OnActionWidgetSpawned(widget, userData);
  }
}
