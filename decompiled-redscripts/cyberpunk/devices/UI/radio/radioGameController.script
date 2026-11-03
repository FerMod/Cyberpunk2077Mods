
public class RadioInkGameController extends DeviceInkGameControllerBase {

  @runtimeProperty("category", "Widget Refs")
  protected edit let m_stationNameWidget: inkTextRef;

  @runtimeProperty("category", "Widget Refs")
  protected edit let m_stationLogoWidget: inkImageRef;

  public func Refresh(state: EDeviceStatus) -> Void {
    this.SetupWidgets();
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

  protected func GetOwner() -> ref<Radio> {
    return this.GetOwnerEntity() as Radio;
  }

  private final func TurnOff() -> Void {
    inkWidgetRef.SetVisible(this.m_stationNameWidget, false);
    this.m_rootWidget.SetState(n"Off");
    this.TriggerAnimationByName(n"eqLoop2", EInkAnimationPlaybackOption.GO_TO_START);
    this.TriggerAnimationByName(n"eqLoop3", EInkAnimationPlaybackOption.GO_TO_START);
    this.TriggerAnimationByName(n"eqLoop5", EInkAnimationPlaybackOption.GO_TO_START);
    this.TriggerAnimationByName(n"eqLoop7", EInkAnimationPlaybackOption.GO_TO_START);
    inkImageRef.SetTexturePart(this.m_stationLogoWidget, n"no_station");
  }

  private final func TurnOn() -> Void {
    if NotEquals(this.m_cashedState, EDeviceStatus.ON) {
      this.m_rootWidget.SetState(n"Default");
      this.TriggerAnimationByName(n"eqLoop2", EInkAnimationPlaybackOption.PLAY);
      this.TriggerAnimationByName(n"eqLoop3", EInkAnimationPlaybackOption.PLAY);
      this.TriggerAnimationByName(n"eqLoop5", EInkAnimationPlaybackOption.PLAY);
      this.TriggerAnimationByName(n"eqLoop7", EInkAnimationPlaybackOption.PLAY);
      inkWidgetRef.SetVisible(this.m_stationNameWidget, true);
    };
    inkTextRef.SetLocalizedTextScript(this.m_stationNameWidget, this.GetOwner().GetDevicePS().GetActiveStationName());
    this.SetupStationLogo();
  }

  private final func SetupStationLogo() -> Void {
    let texturePart: CName;
    let stationID: ERadioStationList = this.GetOwner().GetDevicePS().GetActiveRadioStation();
    switch stationID {
      case ERadioStationList.DOWNTEMPO:
        texturePart = n"pacific_dreams";
        break;
      case ERadioStationList.AGGRO_INDUSTRIAL:
        texturePart = n"vexElsTrom";
        break;
      case ERadioStationList.GROWL:
        texturePart = n"growl_fm";
        break;
      case ERadioStationList.JAZZ:
        texturePart = n"royal_blue";
        break;
      case ERadioStationList.ELECTRO_INDUSTRIAL:
        texturePart = n"night_fm";
        break;
      case ERadioStationList.MINIMAL_TECHNO:
        texturePart = n"radio_samizdat";
        break;
      case ERadioStationList.METAL:
        texturePart = n"ritual";
        break;
      case ERadioStationList.POP:
        texturePart = n"body_heat";
        break;
      case ERadioStationList.IMPULSE_FM:
        texturePart = n"impulse_999";
        break;
      case ERadioStationList.HIP_HOP:
        texturePart = n"the_dirge";
        break;
      case ERadioStationList.AGGRO_TECHNO:
        texturePart = n"radio_pebkac";
        break;
      case ERadioStationList.LATINO:
        texturePart = n"30_principales";
        break;
      case ERadioStationList.ATTITUDE_ROCK:
        texturePart = n"morro_rock";
        break;
      case ERadioStationList.DARK_STAR:
        texturePart = n"dark_star";
        break;
      default:
        texturePart = n"no_station";
    };
    inkImageRef.SetTexturePart(this.m_stationLogoWidget, texturePart);
  }
}
