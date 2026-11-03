
public class NcartTimetableInkGameController extends DeviceInkGameControllerBase {

  private let m_defaultUI: wref<inkCanvas>;

  private let m_mainDisplayWidget: wref<inkVideo>;

  private let m_counterWidget: wref<inkText>;

  private let m_trainImage: wref<inkImage>;

  private let m_cachedLine: Int32;

  private edit let m_lineAIcon: inkImageRef;

  private edit let m_lineBIcon: inkImageRef;

  private edit let m_lineCIcon: inkImageRef;

  private edit let m_lineDIcon: inkImageRef;

  private edit let m_lineEIcon: inkImageRef;

  private let m_onGlitchingStateChangedListener: ref<CallbackHandle>;

  private let m_onTimeToDepartChangedListener: ref<CallbackHandle>;

  private let m_onCurrentLineNumberChangedListener: ref<CallbackHandle>;

  private let m_animProxy: ref<inkAnimProxy>;

  protected cb func OnInitialize() -> Bool {
    super.OnInitialize();
    this.m_cachedLine = this.GetBlackboard().GetInt(this.GetOwner().GetBlackboardDef().NextTrainLine);
    this.UpdateLineIconVisiblity();
    this.SetTrainColor();
    this.ResolvePrologueState();
  }

  protected cb func OnUninitialize() -> Bool {
    super.OnUninitialize();
    this.m_mainDisplayWidget.Stop();
  }

  protected func SetupWidgets() -> Void {
    if !this.m_isInitialized {
      this.m_defaultUI = this.GetWidget(n"default_ui") as inkCanvas;
      this.m_counterWidget = this.GetWidget(n"default_ui/CounterPane/counter_text") as inkText;
      this.m_mainDisplayWidget = this.GetWidget(n"main_display") as inkVideo;
      this.m_trainImage = this.GetWidget(n"default_ui/Train") as inkImage;
      this.m_rootWidget.SetVisible(false);
    };
  }

  public func UpdateActionWidgets(const widgetsData: script_ref<[SActionWidgetPackage]>) -> Void;

  public func Refresh(state: EDeviceStatus) -> Void {
    this.SetupWidgets();
    this.RequestActionWidgetsUpdate();
    switch state {
      case EDeviceStatus.ON:
        this.TurnOn();
        break;
      case EDeviceStatus.OFF:
        this.TurnOff();
        break;
      case EDeviceStatus.UNPOWERED:
        break;
      case EDeviceStatus.DISABLED:
        break;
      default:
    };
    super.Refresh(state);
  }

  protected func RegisterBlackboardCallbacks(blackboard: ref<IBlackboard>) -> Void {
    super.RegisterBlackboardCallbacks(blackboard);
    if IsDefined(blackboard) {
      this.m_onGlitchingStateChangedListener = blackboard.RegisterListenerVariant(this.GetOwner().GetBlackboardDef().GlitchData, this, n"OnGlitchingStateChanged");
      this.m_onTimeToDepartChangedListener = blackboard.RegisterListenerInt(this.GetOwner().GetBlackboardDef().TimeToDepart, this, n"OnTimeToDepartChanged");
    };
  }

  protected func UnRegisterBlackboardCallbacks(blackboard: ref<IBlackboard>) -> Void {
    super.UnRegisterBlackboardCallbacks(blackboard);
    if IsDefined(blackboard) {
      blackboard.UnregisterListenerVariant(this.GetOwner().GetBlackboardDef().GlitchData, this.m_onGlitchingStateChangedListener);
      blackboard.UnregisterListenerInt(this.GetOwner().GetBlackboardDef().TimeToDepart, this.m_onTimeToDepartChangedListener);
    };
  }

  protected func GetOwner() -> ref<NcartTimetable> {
    return this.GetOwnerEntity() as NcartTimetable;
  }

  protected cb func OnActionWidgetsUpdate(value: Variant) -> Bool {
    let widgets: array<SActionWidgetPackage> = FromVariant<array<SActionWidgetPackage>>(value);
    this.UpdateActionWidgets(widgets);
  }

  protected cb func OnTrainArrivalAnimationFinished(proxy: ref<inkAnimProxy>) -> Bool {
    proxy.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnTrainArrivalAnimationFinished");
    this.m_animProxy = this.PlayLibraryAnimation(n"TrainDeparture");
    this.m_animProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnTrainDepartureAnimationFinished");
  }

  protected cb func OnTrainDepartureAnimationFinished(proxy: ref<inkAnimProxy>) -> Bool {
    proxy.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnTrainArrivalAnimationFinished");
    this.m_cachedLine = this.GetBlackboard().GetInt(this.GetOwner().GetBlackboardDef().NextTrainLine);
    this.UpdateLineIconVisiblity();
    this.SetTrainColor();
    this.PlayLibraryAnimation(n"TimerReset");
  }

  protected cb func OnTimeToDepartChanged(value: Int32) -> Bool {
    let textParams: ref<inkTextParams>;
    if value == 5 {
      this.m_animProxy = this.PlayLibraryAnimation(n"TrainArrival");
      this.m_animProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnTrainArrivalAnimationFinished");
    };
    if this.m_counterWidget != null {
      textParams = new inkTextParams();
      textParams.AddTime("TIMER", value);
      this.m_counterWidget.SetLocalizedTextScript("LocKey#48343", textParams);
    };
  }

  private final func SetTrainColor() -> Void {
    switch this.m_cachedLine {
      case 1:
        this.m_trainImage.SetTintColor(new Color(229u, 25u, 25u, 255u));
        break;
      case 2:
        this.m_trainImage.SetTintColor(new Color(255u, 248u, 0u, 255u));
        break;
      case 3:
        this.m_trainImage.SetTintColor(new Color(18u, 228u, 255u, 255u));
        break;
      case 4:
        this.m_trainImage.SetTintColor(new Color(27u, 233u, 32u, 255u));
        break;
      case 5:
        this.m_trainImage.SetTintColor(new Color(250u, 131u, 0u, 255u));
        break;
      default:
        this.m_trainImage.SetTintColor(new Color(18u, 228u, 255u, 255u));
    };
  }

  private final func ResolvePrologueState() -> Void {
    let prologueFact: Int32 = GameInstance.GetQuestsSystem(this.GetOwner().GetGame()).GetFact(n"watson_prolog_lock");
    if prologueFact > 0 {
      this.m_defaultUI.SetOpacity(0.00);
    } else {
      this.m_defaultUI.SetOpacity(1.00);
    };
  }

  private final func UpdateLineIconVisiblity() -> Void {
    switch this.m_cachedLine {
      case 1:
        inkWidgetRef.SetOpacity(this.m_lineAIcon, 1.00);
        inkWidgetRef.SetOpacity(this.m_lineBIcon, 0.00);
        inkWidgetRef.SetOpacity(this.m_lineCIcon, 0.00);
        inkWidgetRef.SetOpacity(this.m_lineDIcon, 0.00);
        inkWidgetRef.SetOpacity(this.m_lineEIcon, 0.00);
        break;
      case 2:
        inkWidgetRef.SetOpacity(this.m_lineAIcon, 0.00);
        inkWidgetRef.SetOpacity(this.m_lineBIcon, 1.00);
        inkWidgetRef.SetOpacity(this.m_lineCIcon, 0.00);
        inkWidgetRef.SetOpacity(this.m_lineDIcon, 0.00);
        inkWidgetRef.SetOpacity(this.m_lineEIcon, 0.00);
        break;
      case 3:
        inkWidgetRef.SetOpacity(this.m_lineAIcon, 0.00);
        inkWidgetRef.SetOpacity(this.m_lineBIcon, 0.00);
        inkWidgetRef.SetOpacity(this.m_lineCIcon, 1.00);
        inkWidgetRef.SetOpacity(this.m_lineDIcon, 0.00);
        inkWidgetRef.SetOpacity(this.m_lineEIcon, 0.00);
        break;
      case 4:
        inkWidgetRef.SetOpacity(this.m_lineAIcon, 0.00);
        inkWidgetRef.SetOpacity(this.m_lineBIcon, 0.00);
        inkWidgetRef.SetOpacity(this.m_lineCIcon, 0.00);
        inkWidgetRef.SetOpacity(this.m_lineDIcon, 1.00);
        inkWidgetRef.SetOpacity(this.m_lineEIcon, 0.00);
        break;
      case 5:
        inkWidgetRef.SetOpacity(this.m_lineAIcon, 0.00);
        inkWidgetRef.SetOpacity(this.m_lineBIcon, 0.00);
        inkWidgetRef.SetOpacity(this.m_lineCIcon, 0.00);
        inkWidgetRef.SetOpacity(this.m_lineDIcon, 0.00);
        inkWidgetRef.SetOpacity(this.m_lineEIcon, 1.00);
        break;
      default:
        inkWidgetRef.SetOpacity(this.m_lineAIcon, 1.00);
        inkWidgetRef.SetOpacity(this.m_lineBIcon, 0.00);
        inkWidgetRef.SetOpacity(this.m_lineCIcon, 0.00);
        inkWidgetRef.SetOpacity(this.m_lineDIcon, 0.00);
        inkWidgetRef.SetOpacity(this.m_lineEIcon, 0.00);
    };
  }

  private func StartGlitchingScreen(glitchData: GlitchData) -> Void {
    this.StopVideo();
    this.m_defaultUI.SetVisible(false);
    if Equals(glitchData.state, EGlitchState.DEFAULT) {
      this.PlayVideo(r"base\\movies\\misc\\generic_noise_white.bk2", true, n"None");
    } else {
      this.PlayVideo(r"base\\movies\\misc\\distraction_generic.bk2", true, n"None");
    };
  }

  private func StopGlitchingScreen() -> Void {
    this.StopVideo();
    this.m_defaultUI.SetVisible(true);
  }

  public final func PlayVideo(videoPath: ResRef, looped: Bool, audioEvent: CName) -> Void {
    this.m_mainDisplayWidget.SetVideoPath(videoPath);
    this.m_mainDisplayWidget.SetLoop(looped);
    if IsNameValid(audioEvent) {
      this.m_mainDisplayWidget.SetAudioEvent(audioEvent);
    };
    this.m_mainDisplayWidget.Play();
  }

  public final func StopVideo() -> Void {
    this.m_mainDisplayWidget.Stop();
  }

  public final func TurnOff() -> Void {
    this.m_rootWidget.SetVisible(false);
    this.m_mainDisplayWidget.UnregisterFromCallback(n"OnVideoFinished", this, n"OnVideoFinished");
  }

  public final func TurnOn() -> Void {
    this.m_rootWidget.SetVisible(true);
  }
}
