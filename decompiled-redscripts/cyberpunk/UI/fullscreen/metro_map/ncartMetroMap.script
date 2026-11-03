
public class NcartMetroMapController extends CustomAnimationsHudGameController {

  private edit let m_playerMarkerPane: inkWidgetRef;

  private edit const let m_playerCurrentPositionReferences: [metroMapPlayerPositionReferences];

  private let m_questsSystem: ref<QuestsSystem>;

  private let m_selectedDestinationButtonListner: Uint32;

  private let m_selectionMenuShouldBeActiveListener: Uint32;

  private let m_previousAnimatioNumber: Int32;

  private let m_directionAnimProxy: ref<inkAnimProxy>;

  private let m_startupAnimProxy: ref<inkAnimProxy>;

  private let m_playerPostionMarkerAnimProxy: ref<inkAnimProxy>;

  private let m_mapOpen: Bool;

  @default(NcartMetroMapController, 0.04f)
  private const let LineOffOpacity: Float;

  @default(NcartMetroMapController, 0.55f)
  private const let LineOnOpacity: Float;

  protected cb func OnInitialize() -> Bool {
    let ownerObject: ref<GameObject>;
    super.OnInitialize();
    ownerObject = this.GetOwnerEntity() as GameObject;
    this.m_questsSystem = GameInstance.GetQuestsSystem(ownerObject.GetGame());
    this.m_selectionMenuShouldBeActiveListener = this.m_questsSystem.RegisterListener(n"ue_metro_enable_line_section_ui", this, n"OnMetroMapControlFactChangeEvent");
    this.m_root = this.GetRootWidget() as inkCompoundWidget;
  }

  protected cb func OnMetroMapControlFactChangeEvent(factValue: Int32) -> Bool {
    if factValue > 0 {
      this.m_startupAnimProxy = this.PlayLibraryAnimation(n"startup");
      this.m_startupAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnStartupAnimationDone");
      this.UpdateAvialableLines();
      this.m_mapOpen = true;
    } else {
      if this.m_mapOpen {
        this.UpdatePlayerLocationMarker(false);
        this.HideDirectionPanes();
        this.SwitchActiveButton(0);
        this.m_directionAnimProxy.Stop();
        this.m_previousAnimatioNumber = 0;
        this.PlayLibraryAnimation(n"close");
        this.m_questsSystem.UnregisterListener(n"ue_metro_station_highlight", this.m_selectedDestinationButtonListner);
        this.m_mapOpen = false;
      };
    };
  }

  protected cb func OnStartupAnimationDone(proxy: ref<inkAnimProxy>) -> Bool {
    let factValue: Int32 = this.m_questsSystem.GetFact(n"ue_metro_station_highlight");
    if factValue > 0 {
      this.SwitchActiveButton(factValue);
    };
    this.UpdatePlayerLocationMarker(true);
    this.m_startupAnimProxy.UnregisterFromAllCallbacks(inkanimEventType.OnFinish);
    this.m_selectedDestinationButtonListner = this.m_questsSystem.RegisterListener(n"ue_metro_station_highlight", this, n"OnMetroMapSelectionChangedEvent");
  }

  protected cb func OnMetroMapSelectionChangedEvent(factValue: Int32) -> Bool {
    this.SwitchActiveButton(factValue);
  }

  private final func ProcessButtonAnimation(buttonNumber: Int32, animSetup: inkAnimOptions) -> Void {
    switch buttonNumber {
      case 1:
        this.PlayLibraryAnimation(n"SelectA1", animSetup);
        break;
      case 2:
        this.PlayLibraryAnimation(n"SelectA2", animSetup);
        break;
      case 3:
        this.PlayLibraryAnimation(n"SelectB1", animSetup);
        break;
      case 4:
        this.PlayLibraryAnimation(n"SelectB2", animSetup);
        break;
      case 5:
        this.PlayLibraryAnimation(n"SelectC1", animSetup);
        break;
      case 6:
        this.PlayLibraryAnimation(n"SelectC2", animSetup);
        break;
      case 7:
        this.PlayLibraryAnimation(n"SelectD", animSetup);
        break;
      case 8:
        this.PlayLibraryAnimation(n"SelectD", animSetup);
        break;
      case 9:
        this.PlayLibraryAnimation(n"SelectE1", animSetup);
        break;
      case 10:
        this.PlayLibraryAnimation(n"SelectE2", animSetup);
    };
  }

  private final func SetupDirectionWidget(buttonNumber: Int32) -> Void {
    let markerWidget: wref<inkImage>;
    let rootWidget: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let widget: wref<inkCompoundWidget> = rootWidget.GetWidgetByPath(inkWidgetPath.Build(n"DirectionMasks", n"LineAMaskPane")) as inkCompoundWidget;
    if buttonNumber == 1 || buttonNumber == 2 {
      widget.SetOpacity(1.00);
      markerWidget = rootWidget.GetWidgetByPath(inkWidgetPath.Build(n"DirectionMasks", n"LineAMaskPane", n"LineADirectionPoint")) as inkImage;
      markerWidget.SetOpacity(1.00);
    } else {
      widget.SetOpacity(0.00);
    };
    widget = rootWidget.GetWidgetByPath(inkWidgetPath.Build(n"DirectionMasks", n"LineBMaskPane")) as inkCompoundWidget;
    if buttonNumber == 3 || buttonNumber == 4 {
      widget.SetOpacity(1.00);
      markerWidget = rootWidget.GetWidgetByPath(inkWidgetPath.Build(n"DirectionMasks", n"LineBMaskPane", n"LineBDirectionPoint")) as inkImage;
      markerWidget.SetOpacity(1.00);
    } else {
      widget.SetOpacity(0.00);
    };
    widget = rootWidget.GetWidgetByPath(inkWidgetPath.Build(n"DirectionMasks", n"LineCMaskPane")) as inkCompoundWidget;
    if buttonNumber == 5 || buttonNumber == 6 {
      widget.SetOpacity(1.00);
      markerWidget = rootWidget.GetWidgetByPath(inkWidgetPath.Build(n"DirectionMasks", n"LineCMaskPane", n"LineCDirectionPoint")) as inkImage;
      markerWidget.SetOpacity(1.00);
    } else {
      widget.SetOpacity(0.00);
    };
    widget = rootWidget.GetWidgetByPath(inkWidgetPath.Build(n"DirectionMasks", n"LineDMaskPane")) as inkCompoundWidget;
    if buttonNumber == 7 || buttonNumber == 8 {
      widget.SetOpacity(1.00);
      markerWidget = rootWidget.GetWidgetByPath(inkWidgetPath.Build(n"DirectionMasks", n"LineDMaskPane", n"LineDDirectionPoint")) as inkImage;
      markerWidget.SetOpacity(1.00);
    } else {
      widget.SetOpacity(0.00);
    };
    widget = rootWidget.GetWidgetByPath(inkWidgetPath.Build(n"DirectionMasks", n"LineEMaskPane")) as inkCompoundWidget;
    if buttonNumber == 9 || buttonNumber == 10 {
      widget.SetOpacity(1.00);
      markerWidget = rootWidget.GetWidgetByPath(inkWidgetPath.Build(n"DirectionMasks", n"LineEMaskPane", n"LineEDirectionPoint")) as inkImage;
      markerWidget.SetOpacity(1.00);
    } else {
      widget.SetOpacity(0.00);
    };
  }

  private final func HideDirectionPanes() -> Void {
    let rootWidget: ref<inkCompoundWidget> = this.GetRootCompoundWidget();
    let widget: wref<inkCompoundWidget> = rootWidget.GetWidgetByPath(inkWidgetPath.Build(n"DirectionMasks", n"LineAMaskPane")) as inkCompoundWidget;
    widget.SetOpacity(0.00);
    widget = rootWidget.GetWidgetByPath(inkWidgetPath.Build(n"DirectionMasks", n"LineBMaskPane")) as inkCompoundWidget;
    widget.SetOpacity(0.00);
    widget = rootWidget.GetWidgetByPath(inkWidgetPath.Build(n"DirectionMasks", n"LineCMaskPane")) as inkCompoundWidget;
    widget.SetOpacity(0.00);
    widget = rootWidget.GetWidgetByPath(inkWidgetPath.Build(n"DirectionMasks", n"LineDMaskPane")) as inkCompoundWidget;
    widget.SetOpacity(0.00);
    widget = rootWidget.GetWidgetByPath(inkWidgetPath.Build(n"DirectionMasks", n"LineEMaskPane")) as inkCompoundWidget;
    widget.SetOpacity(0.00);
  }

  private final func UpdateDirectionDisplay(buttonNumber: Int32) -> Void {
    let animSetup: inkAnimOptions;
    animSetup.loopInfinite = true;
    animSetup.loopType = inkanimLoopType.Cycle;
    animSetup.dependsOnTimeDilation = false;
    animSetup.playReversed = false;
    this.m_directionAnimProxy.Stop();
    this.SetupDirectionWidget(buttonNumber);
    switch buttonNumber {
      case 1:
        animSetup.playReversed = true;
        this.m_directionAnimProxy = this.PlayLibraryAnimation(n"LineADirection", animSetup);
        break;
      case 2:
        this.m_directionAnimProxy = this.PlayLibraryAnimation(n"LineADirection", animSetup);
        break;
      case 3:
        this.m_directionAnimProxy = this.PlayLibraryAnimation(n"LineBDirection", animSetup);
        break;
      case 4:
        animSetup.playReversed = true;
        this.m_directionAnimProxy = this.PlayLibraryAnimation(n"LineBDirection", animSetup);
        break;
      case 5:
        animSetup.playReversed = true;
        this.m_directionAnimProxy = this.PlayLibraryAnimation(n"LineCDirection", animSetup);
        break;
      case 6:
        this.m_directionAnimProxy = this.PlayLibraryAnimation(n"LineCDirection", animSetup);
        break;
      case 7:
        this.m_directionAnimProxy = this.PlayLibraryAnimation(n"LineDDirection", animSetup);
        break;
      case 8:
        this.m_directionAnimProxy = this.PlayLibraryAnimation(n"LineDDirection", animSetup);
        break;
      case 9:
        animSetup.playReversed = true;
        this.m_directionAnimProxy = this.PlayLibraryAnimation(n"LineEDirection", animSetup);
        break;
      case 10:
        this.m_directionAnimProxy = this.PlayLibraryAnimation(n"LineEDirection", animSetup);
    };
  }

  private final func SwitchActiveButton(currentButtonFact: Int32) -> Void {
    let animSetup: inkAnimOptions;
    animSetup.loopInfinite = false;
    animSetup.loopType = inkanimLoopType.None;
    animSetup.dependsOnTimeDilation = false;
    if currentButtonFact == 0 {
      animSetup.playReversed = true;
      this.ProcessButtonAnimation(this.m_previousAnimatioNumber, animSetup);
      return;
    };
    if this.m_previousAnimatioNumber > 0 {
      animSetup.playReversed = true;
      this.ProcessButtonAnimation(this.m_previousAnimatioNumber, animSetup);
    };
    animSetup.playReversed = false;
    this.ProcessButtonAnimation(currentButtonFact, animSetup);
    this.UpdateDirectionDisplay(currentButtonFact);
    this.m_previousAnimatioNumber = currentButtonFact;
  }

  private final func UpdatePlayerLocationMarker(show: Bool) -> Void {
    let animSetup: inkAnimOptions;
    let targetWidget: wref<inkWidget>;
    let ownerObject: ref<GameObject> = this.GetOwnerEntity() as GameObject;
    let widget: wref<inkWidget> = inkWidgetRef.Get(this.m_playerMarkerPane);
    let activeMetroStation: Int32 = GameInstance.GetQuestsSystem(ownerObject.GetGame()).GetFact(n"ue_metro_active_station");
    let i: Int32 = 0;
    while i < ArraySize(this.m_playerCurrentPositionReferences) {
      if this.m_playerCurrentPositionReferences[i].m_lineNumber == Cast<Uint32>(activeMetroStation) {
        if show {
          targetWidget = inkWidgetRef.Get(this.m_playerCurrentPositionReferences[i].m_positionRefWidget);
          widget.SetMargin(targetWidget.GetMargin());
          widget.UpdateMargin(-17.00, -8.00, 0.00, 0.00);
          animSetup.loopInfinite = true;
          animSetup.loopType = inkanimLoopType.Cycle;
          this.PlayLibraryAnimation(n"player_marker_show");
          this.m_playerPostionMarkerAnimProxy = this.PlayLibraryAnimation(n"player_marker_loop", animSetup);
        } else {
          animSetup.playReversed = true;
          animSetup.loopInfinite = false;
          animSetup.loopType = inkanimLoopType.None;
          this.m_playerPostionMarkerAnimProxy.Stop();
          this.PlayLibraryAnimation(n"player_marker_show", animSetup);
        };
      };
      i += 1;
    };
  }

  private final func UpdateAvialableLines() -> Void {
    let LineContainerWidget: wref<inkWidget>;
    let ShowLineA: Bool;
    let ShowLineB: Bool;
    let ShowLineC: Bool;
    let ShowLineD: Bool;
    let ShowLineE: Bool;
    let station14Widget: wref<inkWidget>;
    let buttonWidget: wref<inkWidget> = this.m_root.GetWidgetByPath(inkWidgetPath.Build(n"ButtonHolder", n"ButtonFlex", n"ButtonPane", n"ButtonLineA1")) as inkCompoundWidget;
    if Cast<Bool>(this.m_questsSystem.GetFact(n"ue_metro_show_line_a1")) {
      buttonWidget.SetVisible(true);
      ShowLineA = true;
    } else {
      buttonWidget.SetVisible(false);
    };
    buttonWidget = this.m_root.GetWidgetByPath(inkWidgetPath.Build(n"ButtonHolder", n"ButtonFlex", n"ButtonPane", n"ButtonLineA2")) as inkCompoundWidget;
    if Cast<Bool>(this.m_questsSystem.GetFact(n"ue_metro_show_line_a2")) {
      buttonWidget.SetVisible(true);
      ShowLineA = true;
    } else {
      buttonWidget.SetVisible(false);
    };
    buttonWidget = this.m_root.GetWidgetByPath(inkWidgetPath.Build(n"ButtonHolder", n"ButtonFlex", n"ButtonPane", n"ButtonLineB1")) as inkCompoundWidget;
    if Cast<Bool>(this.m_questsSystem.GetFact(n"ue_metro_show_line_b1")) {
      buttonWidget.SetVisible(true);
      ShowLineB = true;
    } else {
      buttonWidget.SetVisible(false);
    };
    buttonWidget = this.m_root.GetWidgetByPath(inkWidgetPath.Build(n"ButtonHolder", n"ButtonFlex", n"ButtonPane", n"ButtonLineB2")) as inkCompoundWidget;
    if Cast<Bool>(this.m_questsSystem.GetFact(n"ue_metro_show_line_b2")) {
      buttonWidget.SetVisible(true);
      ShowLineB = true;
    } else {
      buttonWidget.SetVisible(false);
    };
    buttonWidget = this.m_root.GetWidgetByPath(inkWidgetPath.Build(n"ButtonHolder", n"ButtonFlex", n"ButtonPane", n"ButtonLineC1")) as inkCompoundWidget;
    if Cast<Bool>(this.m_questsSystem.GetFact(n"ue_metro_show_line_c1")) {
      buttonWidget.SetVisible(true);
      ShowLineC = true;
    } else {
      buttonWidget.SetVisible(false);
    };
    buttonWidget = this.m_root.GetWidgetByPath(inkWidgetPath.Build(n"ButtonHolder", n"ButtonFlex", n"ButtonPane", n"ButtonLineC2")) as inkCompoundWidget;
    if Cast<Bool>(this.m_questsSystem.GetFact(n"ue_metro_show_line_c2")) {
      buttonWidget.SetVisible(true);
      ShowLineC = true;
    } else {
      buttonWidget.SetVisible(false);
    };
    buttonWidget = this.m_root.GetWidgetByPath(inkWidgetPath.Build(n"ButtonHolder", n"ButtonFlex", n"ButtonPane", n"ButtonLineD")) as inkCompoundWidget;
    if Cast<Bool>(this.m_questsSystem.GetFact(n"ue_metro_show_line_d1")) {
      buttonWidget.SetVisible(true);
      ShowLineD = true;
    } else {
      buttonWidget.SetVisible(false);
    };
    buttonWidget = this.m_root.GetWidgetByPath(inkWidgetPath.Build(n"ButtonHolder", n"ButtonFlex", n"ButtonPane", n"ButtonLineD")) as inkCompoundWidget;
    if Cast<Bool>(this.m_questsSystem.GetFact(n"ue_metro_show_line_d2")) || ShowLineD {
      buttonWidget.SetVisible(true);
      ShowLineD = true;
    } else {
      buttonWidget.SetVisible(false);
    };
    buttonWidget = this.m_root.GetWidgetByPath(inkWidgetPath.Build(n"ButtonHolder", n"ButtonFlex", n"ButtonPane", n"ButtonLineE1")) as inkCompoundWidget;
    if Cast<Bool>(this.m_questsSystem.GetFact(n"ue_metro_show_line_e1")) {
      buttonWidget.SetVisible(true);
      ShowLineE = true;
    } else {
      buttonWidget.SetVisible(false);
    };
    buttonWidget = this.m_root.GetWidgetByPath(inkWidgetPath.Build(n"ButtonHolder", n"ButtonFlex", n"ButtonPane", n"ButtonLineE2")) as inkCompoundWidget;
    if Cast<Bool>(this.m_questsSystem.GetFact(n"ue_metro_show_line_e2")) {
      buttonWidget.SetVisible(true);
      ShowLineE = true;
    } else {
      buttonWidget.SetVisible(false);
    };
    LineContainerWidget = this.m_root.GetWidgetByPath(inkWidgetPath.Build(n"MapHolder", n"MainMap", n"LineAContainer")) as inkCompoundWidget;
    station14Widget = this.m_root.GetWidgetByPath(inkWidgetPath.Build(n"MapHolder", n"MainMap", n"Station14Dots", n"Line_A_Station_14")) as inkCompoundWidget;
    if ShowLineA {
      LineContainerWidget.SetOpacity(this.LineOnOpacity);
      station14Widget.SetOpacity(this.LineOnOpacity);
    } else {
      LineContainerWidget.SetOpacity(this.LineOffOpacity);
      station14Widget.SetOpacity(this.LineOffOpacity);
    };
    LineContainerWidget = this.m_root.GetWidgetByPath(inkWidgetPath.Build(n"MapHolder", n"MainMap", n"LineBContainer")) as inkCompoundWidget;
    if ShowLineB {
      LineContainerWidget.SetOpacity(this.LineOnOpacity);
    } else {
      LineContainerWidget.SetOpacity(this.LineOffOpacity);
    };
    LineContainerWidget = this.m_root.GetWidgetByPath(inkWidgetPath.Build(n"MapHolder", n"MainMap", n"LineCContainer")) as inkCompoundWidget;
    station14Widget = this.m_root.GetWidgetByPath(inkWidgetPath.Build(n"MapHolder", n"MainMap", n"Station14Dots", n"Line_C_Station_14")) as inkCompoundWidget;
    if ShowLineC {
      LineContainerWidget.SetOpacity(this.LineOnOpacity);
      station14Widget.SetOpacity(this.LineOnOpacity);
    } else {
      LineContainerWidget.SetOpacity(this.LineOffOpacity);
      station14Widget.SetOpacity(this.LineOffOpacity);
    };
    LineContainerWidget = this.m_root.GetWidgetByPath(inkWidgetPath.Build(n"MapHolder", n"MainMap", n"LineDContainer")) as inkCompoundWidget;
    station14Widget = this.m_root.GetWidgetByPath(inkWidgetPath.Build(n"MapHolder", n"MainMap", n"Station14Dots", n"Line_D_Station_14")) as inkCompoundWidget;
    if ShowLineD {
      LineContainerWidget.SetOpacity(this.LineOnOpacity);
      station14Widget.SetOpacity(this.LineOnOpacity);
    } else {
      LineContainerWidget.SetOpacity(this.LineOffOpacity);
      station14Widget.SetOpacity(this.LineOffOpacity);
    };
    LineContainerWidget = this.m_root.GetWidgetByPath(inkWidgetPath.Build(n"MapHolder", n"MainMap", n"LineEContainer")) as inkCompoundWidget;
    station14Widget = this.m_root.GetWidgetByPath(inkWidgetPath.Build(n"MapHolder", n"MainMap", n"Station14Dots", n"Line_E_Station_14")) as inkCompoundWidget;
    if ShowLineE {
      LineContainerWidget.SetOpacity(this.LineOnOpacity);
      station14Widget.SetOpacity(this.LineOnOpacity);
    } else {
      LineContainerWidget.SetOpacity(this.LineOffOpacity);
      station14Widget.SetOpacity(this.LineOffOpacity);
    };
  }
}
