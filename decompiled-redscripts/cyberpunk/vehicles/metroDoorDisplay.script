
public class NcartDoorScreenInkController extends NcartTrainInkControllerBase {

  private edit const let m_LinesList: [ncartDoorScreenLineDataDef];

  private edit let m_ActiveLineFactName: CName;

  private edit let m_NextStationFactName: CName;

  private edit let m_MetroStoppingFactName: CName;

  private let m_root: wref<inkCompoundWidget>;

  private let m_questsSystem: wref<QuestsSystem>;

  private let m_StopListenerId: Uint32;

  private let m_NextStationListenerId: Uint32;

  private let m_gameTimeCallback: ref<CallbackHandle>;

  private edit let m_ncartTextLogo: inkImageRef;

  private edit let m_timeWidget: inkTextRef;

  private edit let m_stationNameWidget: inkTextRef;

  private edit let m_stationStatusWidget: inkTextRef;

  private edit let m_districtNameWidget: inkTextRef;

  private edit let m_stationDistrictBackgroundColor: inkImageRef;

  private edit let m_sun_moon_container: inkWidgetRef;

  private edit let m_weather_sun_widget: inkImageRef;

  private edit let m_weather_moon_widget: inkImageRef;

  private edit let m_weather_cloud_a_widget: inkImageRef;

  private edit let m_weather_cloud_b_widget: inkImageRef;

  private edit let m_weather_rain_widget: inkImageRef;

  private edit let m_speed_display: inkTextRef;

  private edit let m_speed_display_deco_1: inkImageRef;

  private edit let m_speed_display_deco_2: inkImageRef;

  private edit let m_speed_display_deco_3: inkImageRef;

  private edit let m_speed_display_deco_4: inkImageRef;

  private let m_cachedActiveLine: Int32;

  private let m_cachedNextStation: Int32;

  @default(NcartDoorScreenInkController, ENcartDistricts.ERROR)
  private let m_cachedDistrict: ENcartDistricts;

  private let m_updateDistrictName: Bool;

  private let m_ownerObject: wref<VehicleObject>;

  private let m_vehicleBlackboard: wref<IBlackboard>;

  private let m_AnimProxy: ref<inkAnimProxy>;

  private let speedListner: ref<CallbackHandle>;

  private let speedLastValue: Float;

  protected cb func OnInitialize() -> Bool {
    super.OnInitialize();
    this.m_ownerObject = this.GetOwnerEntity() as VehicleObject;
    this.m_questsSystem = GameInstance.GetQuestsSystem(this.m_ownerObject.GetGame());
    this.m_vehicleBlackboard = this.m_ownerObject.GetBlackboard();
    this.m_StopListenerId = this.m_questsSystem.RegisterListener(this.m_MetroStoppingFactName, this, n"OnMetroArrivingAtStationEvent");
    this.m_NextStationListenerId = this.m_questsSystem.RegisterListener(this.m_NextStationFactName, this, n"OnMetroNextStationChangeEvent");
    this.m_root = this.GetRootWidget() as inkCompoundWidget;
    this.m_cachedActiveLine = this.m_questsSystem.GetFact(this.m_ActiveLineFactName);
    this.m_cachedNextStation = this.m_questsSystem.GetFact(this.m_NextStationFactName);
    this.m_cachedDistrict = this.GetMetroStationDistrict(this.GetMetroStationEnumFromNumber(this.m_cachedNextStation));
    if inkWidgetRef.IsValid(this.m_speed_display) {
      this.speedListner = this.m_vehicleBlackboard.RegisterListenerFloat(GetAllBlackboardDefs().Vehicle.SpeedValue, this, n"OnTrainSpeedChanged");
    };
    this.m_updateDistrictName = true;
    this.UpdateMetroLine(this.m_cachedActiveLine);
    this.UpdateWeather();
    this.RegisterBlackBoardCallbacks();
    this.m_vehicleBlackboard.SignalString(GetAllBlackboardDefs().Vehicle.GameTime);
  }

  protected cb func OnUninitialize() -> Bool {
    this.m_questsSystem.UnregisterListener(this.m_MetroStoppingFactName, this.m_StopListenerId);
    this.m_questsSystem.UnregisterListener(this.m_NextStationFactName, this.m_NextStationListenerId);
    this.UnregisterBlackBoardCallbacks();
  }

  protected cb func OnMetroNextStationChangeEvent(factValue: Int32) -> Bool {
    this.ChangeNextStationName(factValue);
  }

  protected cb func OnMetroArrivingAtStationEvent(factValue: Int32) -> Bool {
    if factValue == 1 {
      this.TrainStopAnim();
    };
  }

  protected cb func OnTrainSpeedChanged(speed: Float) -> Bool {
    let randomSway: Float;
    this.speedLastValue = speed;
    if speed == this.speedLastValue && speed > 1.00 {
      randomSway = RandRangeF(-0.20, 0.20);
    };
    if speed < 2.00 && speed > 0.00 {
      inkTextRef.SetText(this.m_speed_display, "1.0");
    };
    if speed >= 0.00 {
      inkTextRef.SetText(this.m_speed_display, "0.0");
    };
    inkTextRef.SetText(this.m_speed_display, FloatToStringPrec(speed * 2.60 + randomSway, 1));
  }

  private final func UpdateMetroLine(activeLine: Int32) -> Void {
    let color: Color = this.m_LinesList[activeLine - 1].m_lineColor;
    inkWidgetRef.SetTintColor(this.m_LinesList[activeLine - 1].m_lineSymbolWidget, color);
    inkWidgetRef.SetOpacity(this.m_LinesList[activeLine - 1].m_lineSymbolWidget, 1.00);
    inkWidgetRef.SetTintColor(this.m_ncartTextLogo, color);
    if inkWidgetRef.IsValid(this.m_speed_display) {
      inkWidgetRef.SetTintColor(this.m_speed_display_deco_1, color);
      inkWidgetRef.SetTintColor(this.m_speed_display_deco_2, color);
      inkWidgetRef.SetTintColor(this.m_speed_display_deco_3, color);
      inkWidgetRef.SetTintColor(this.m_speed_display_deco_4, color);
    };
    this.PlayArrowsAnimation();
    this.UpdateDestinationStation(this.m_cachedNextStation);
  }

  private final func UpdateDestinationStation(DestinationStation: Int32) -> Void {
    if this.m_updateDistrictName {
      inkTextRef.SetLocalizedTextString(this.m_districtNameWidget, this.GetDistrictLocalizedName(this.m_cachedDistrict));
      inkWidgetRef.SetTintColor(this.m_stationDistrictBackgroundColor, this.GetDistrictColor(this.m_cachedDistrict));
    };
    inkTextRef.SetLocalizedTextString(this.m_stationNameWidget, this.GetMetroStationLocalizedNameByNumber(DestinationStation));
  }

  private final func UpdateWeather() -> Void {
    let weatherFact: Int32 = this.m_questsSystem.GetFact(n"ue_metro_weather");
    this.UpdateDayNightWeatherIcon();
    switch weatherFact {
      case 1:
        inkWidgetRef.SetOpacity(this.m_sun_moon_container, 1.00);
        break;
      case 2:
        inkWidgetRef.SetOpacity(this.m_sun_moon_container, 1.00);
        inkWidgetRef.SetOpacity(this.m_weather_cloud_a_widget, 1.00);
        break;
      case 3:
        inkWidgetRef.SetOpacity(this.m_weather_cloud_a_widget, 1.00);
        inkWidgetRef.SetOpacity(this.m_weather_cloud_b_widget, 1.00);
        break;
      case 3:
        inkWidgetRef.SetOpacity(this.m_weather_rain_widget, 1.00);
        break;
      default:
        inkWidgetRef.SetOpacity(this.m_weather_cloud_a_widget, 1.00);
        inkWidgetRef.SetOpacity(this.m_weather_cloud_b_widget, 1.00);
    };
  }

  private final func TrainStopAnim() -> Void {
    let animSetup: inkAnimOptions;
    animSetup.loopInfinite = false;
    animSetup.loopType = inkanimLoopType.None;
    animSetup.dependsOnTimeDilation = true;
    this.PlayLibraryAnimation(n"ArrivingAtStation", animSetup);
  }

  private final func PlayArrowsAnimation() -> Void {
    let animSetup: inkAnimOptions;
    animSetup.loopInfinite = true;
    animSetup.loopType = inkanimLoopType.Cycle;
    animSetup.dependsOnTimeDilation = true;
    this.PlayLibraryAnimation(n"ArrowsLoop", animSetup);
  }

  private final func ChangeNextStationName(newStation: Int32) -> Void {
    let animSetup: inkAnimOptions;
    this.m_cachedNextStation = this.m_questsSystem.GetFact(this.m_NextStationFactName);
    let district: ENcartDistricts = this.GetMetroStationDistrict(this.GetMetroStationEnumFromNumber(this.m_cachedNextStation));
    animSetup.loopInfinite = false;
    animSetup.loopType = inkanimLoopType.None;
    animSetup.dependsOnTimeDilation = true;
    this.m_AnimProxy = this.PlayLibraryAnimation(n"HideStationName", animSetup);
    if NotEquals(district, this.m_cachedDistrict) {
      this.m_cachedDistrict = district;
      this.PlayLibraryAnimation(n"HideDistrictPane", animSetup);
      this.m_updateDistrictName = true;
    };
    this.m_AnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnEndAnimLoop");
  }

  protected cb func OnEndAnimLoop(proxy: ref<inkAnimProxy>) -> Bool {
    this.UpdateDestinationStation(this.m_cachedNextStation);
    this.PlayLibraryAnimation(n"ShowNewStationName");
    if this.m_updateDistrictName {
      this.m_updateDistrictName = false;
      this.PlayLibraryAnimation(n"ShowDistrictPane");
    };
    this.m_AnimProxy.UnregisterFromCallback(inkanimEventType.OnEndLoop, this, n"OnEndAnimLoop");
  }

  private final func RegisterBlackBoardCallbacks() -> Void {
    if IsDefined(this.m_vehicleBlackboard) {
      if !IsDefined(this.m_gameTimeCallback) {
        this.m_gameTimeCallback = this.m_vehicleBlackboard.RegisterListenerString(GetAllBlackboardDefs().Vehicle.GameTime, this, n"OnGameTimeChanged");
      };
    };
  }

  private final func UnregisterBlackBoardCallbacks() -> Void {
    if IsDefined(this.m_vehicleBlackboard) {
      this.m_vehicleBlackboard.UnregisterListenerString(GetAllBlackboardDefs().Vehicle.GameTime, this.m_gameTimeCallback);
    };
  }

  private final func UpdateDayNightWeatherIcon() -> Void {
    let time: GameTime = GameInstance.GetTimeSystem(this.m_ownerObject.GetGame()).GetGameTime();
    let sunSet: GameTime = GameTime.MakeGameTime(0, 20, 0, 0);
    let sunRise: GameTime = GameTime.MakeGameTime(0, 5, 0, 0);
    let currTime: GameTime = GameTime.MakeGameTime(0, GameTime.Hours(time), GameTime.Minutes(time), GameTime.Seconds(time));
    if currTime <= sunSet && currTime >= sunRise {
      inkWidgetRef.SetOpacity(this.m_weather_sun_widget, 1.00);
      inkWidgetRef.SetOpacity(this.m_weather_moon_widget, 0.00);
    } else {
      inkWidgetRef.SetOpacity(this.m_weather_sun_widget, 0.00);
      inkWidgetRef.SetOpacity(this.m_weather_moon_widget, 1.00);
    };
  }

  public final func OnGameTimeChanged(time: String) -> Void {
    if inkWidgetRef.IsValid(this.m_timeWidget) {
      inkTextRef.SetText(this.m_timeWidget, time);
      this.UpdateDayNightWeatherIcon();
    };
  }
}
