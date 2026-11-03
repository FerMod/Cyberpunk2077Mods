
public class NcartTrainLineListInkController extends NcartTrainInkControllerBase {

  private edit const let m_LinesList: [ncartLineListDef];

  private edit let m_ActiveMetroLineNumberFactName: CName;

  private edit let m_ActiveMetroStationNumberFactName: CName;

  private edit let m_MetroStoppingFactName: CName;

  private edit let m_MetroReverseDirectionFact: CName;

  private let m_root: wref<inkCompoundWidget>;

  private let m_questsSystem: wref<QuestsSystem>;

  private let m_activeStationListenerId: Uint32;

  private let m_activeLineListenerId: Uint32;

  private let m_StopListenerId: Uint32;

  private let m_StationListSetUp: Bool;

  @default(NcartTrainLineListInkController, -1)
  private let m_lastDestination: Int32;

  @default(NcartTrainLineListInkController, -1)
  private let m_currentActiveStation: Int32;

  private let m_activeStationWidget: Int32;

  private edit let m_ncartLogo: inkImageRef;

  private edit let m_ncartLogoDeco: inkImageRef;

  private edit let m_ncartLogoDecoFrame1: inkImageRef;

  private edit let m_ncartLogoDecoFrame2: inkImageRef;

  private edit let m_ncartLogoDecoFrame3: inkImageRef;

  private edit let m_ncartLogoDecoFrame4: inkImageRef;

  private edit let m_line_loop_symbol: inkImageRef;

  private edit let m_ncartDecoAccent1: inkImageRef;

  private edit let m_ncartDecoAccent2: inkImageRef;

  private edit let m_ncartDecoAccent3: inkImageRef;

  private edit let m_ncartDecoAccent4: inkImageRef;

  private edit let m_ncartTextLogo: inkImageRef;

  private edit let m_ncartDirectionArrowsList: inkHorizontalPanelRef;

  private edit let m_ncartLineStationList: inkHorizontalPanelRef;

  private let cachedLine: Uint32;

  protected cb func OnInitialize() -> Bool {
    let ownerObject: ref<GameObject>;
    super.OnInitialize();
    ownerObject = this.GetOwnerEntity() as GameObject;
    this.m_questsSystem = GameInstance.GetQuestsSystem(ownerObject.GetGame());
    this.m_activeStationListenerId = this.m_questsSystem.RegisterListener(this.m_ActiveMetroLineNumberFactName, this, n"OnMetroActiveLineChangeEvent");
    this.m_activeLineListenerId = this.m_questsSystem.RegisterListener(this.m_ActiveMetroStationNumberFactName, this, n"OnMetroActiveStationChangeEvent");
    this.m_StopListenerId = this.m_questsSystem.RegisterListener(this.m_MetroStoppingFactName, this, n"OnMetroArrivingAtStationEvent");
    this.m_root = this.GetRootWidget() as inkCompoundWidget;
    this.UpdateMetroLine(Cast<Uint32>(this.m_questsSystem.GetFact(this.m_ActiveMetroLineNumberFactName)));
  }

  protected cb func OnUninitialize() -> Bool {
    this.m_questsSystem.UnregisterListener(this.m_ActiveMetroStationNumberFactName, this.m_activeStationListenerId);
    this.m_questsSystem.UnregisterListener(this.m_ActiveMetroLineNumberFactName, this.m_activeLineListenerId);
    this.m_questsSystem.UnregisterListener(this.m_MetroStoppingFactName, this.m_activeLineListenerId);
  }

  protected cb func OnMetroActiveLineChangeEvent(factValue: Int32) -> Bool;

  protected cb func OnMetroActiveStationChangeEvent(factValue: Int32) -> Bool;

  protected cb func OnMetroArrivingAtStationEvent(factValue: Int32) -> Bool {
    let activeStation: Int32;
    if factValue == 1 {
      this.SignalTrainStop();
    } else {
      activeStation = this.m_questsSystem.GetFact(this.m_ActiveMetroStationNumberFactName);
      if this.m_currentActiveStation != activeStation {
        this.MarkNextStationOnLine(this.m_questsSystem.GetFact(this.m_ActiveMetroStationNumberFactName));
      };
    };
  }

  private final func UpdateMetroLine(activeLine: Uint32) -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.m_LinesList) {
      if this.m_LinesList[i].m_lineNumber == activeLine {
        inkWidgetRef.SetTintColor(this.m_ncartLogo, this.m_LinesList[i].m_lineColor);
        inkWidgetRef.SetTintColor(this.m_LinesList[i].m_lineSymbolWidget, this.m_LinesList[i].m_lineColor);
        inkWidgetRef.SetOpacity(this.m_LinesList[i].m_lineSymbolWidget, 1.00);
        inkWidgetRef.SetTintColor(this.m_ncartLogoDeco, this.m_LinesList[i].m_lineColor);
        inkWidgetRef.SetTintColor(this.m_ncartLogoDecoFrame1, this.m_LinesList[i].m_lineColor);
        inkWidgetRef.SetTintColor(this.m_ncartLogoDecoFrame2, this.m_LinesList[i].m_lineColor);
        inkWidgetRef.SetTintColor(this.m_ncartLogoDecoFrame3, this.m_LinesList[i].m_lineColor);
        inkWidgetRef.SetTintColor(this.m_ncartLogoDecoFrame4, this.m_LinesList[i].m_lineColor);
        inkWidgetRef.SetTintColor(this.m_ncartDecoAccent1, this.m_LinesList[i].m_lineColor);
        inkWidgetRef.SetTintColor(this.m_ncartDecoAccent2, this.m_LinesList[i].m_lineColor);
        inkWidgetRef.SetTintColor(this.m_ncartDecoAccent3, this.m_LinesList[i].m_lineColor);
        inkWidgetRef.SetTintColor(this.m_ncartDecoAccent4, this.m_LinesList[i].m_lineColor);
        inkWidgetRef.SetTintColor(this.m_ncartTextLogo, this.m_LinesList[i].m_lineColor);
        if Equals(this.m_LinesList[i].m_lineIsLooped, true) {
          inkWidgetRef.SetTintColor(this.m_line_loop_symbol, this.m_LinesList[i].m_lineColor);
          inkWidgetRef.SetOpacity(this.m_line_loop_symbol, 1.00);
        } else {
          inkWidgetRef.SetOpacity(this.m_line_loop_symbol, 0.00);
        };
        this.cachedLine = Cast<Uint32>(i);
      };
      i += 1;
    };
    this.PaintDirectionArrows(Cast<Int32>(this.cachedLine));
    this.m_StationListSetUp = this.PopulateStationList(Cast<Int32>(this.cachedLine));
    if Equals(this.m_StationListSetUp, true) {
      this.MarkNextStationOnLine(this.m_questsSystem.GetFact(this.m_ActiveMetroStationNumberFactName));
    };
  }

  private final func PaintDirectionArrows(line: Int32) -> Void {
    let arrow: wref<inkWidget>;
    let i: Int32;
    if !inkWidgetRef.IsValid(this.m_ncartDirectionArrowsList) {
      return;
    };
    while i < inkCompoundRef.GetNumChildren(this.m_ncartDirectionArrowsList) {
      arrow = inkCompoundRef.GetWidgetByIndex(this.m_ncartDirectionArrowsList, i);
      arrow.SetTintColor(this.m_LinesList[line].m_lineColor);
      i += 1;
    };
    this.PlayDirectionArrows();
  }

  private final func PlayDirectionArrows() -> Void {
    let animSetup: inkAnimOptions;
    animSetup.loopInfinite = true;
    animSetup.loopType = inkanimLoopType.Cycle;
    animSetup.dependsOnTimeDilation = true;
    if Cast<Uint32>(this.m_questsSystem.GetFact(this.m_MetroReverseDirectionFact)) == 0u {
      this.PlayLibraryAnimation(n"direction_right", animSetup);
    } else {
      this.PlayLibraryAnimation(n"direction_left", animSetup);
    };
  }

  private final func PopulateStationList(line: Int32) -> Bool {
    let i: Int32;
    let widget: wref<inkWidget>;
    let lineStationsList: array<ncartStationListDef> = this.m_LinesList[line].m_stationsList;
    if ArraySize(lineStationsList) == 0 {
      return false;
    };
    i = 0;
    while i < ArraySize(lineStationsList) {
      if i == ArraySize(lineStationsList) - 1 {
        widget = this.SpawnFromLocal(inkWidgetRef.Get(this.m_ncartLineStationList), n"station_end");
        widget.SetHAlign(inkEHorizontalAlign.Fill);
        this.PaintStationMarker(widget as inkCompoundWidget, this.m_LinesList[line].m_lineColor, this.GetDistrictColor(this.GetMetroStationDistrict(lineStationsList[i].m_station)));
      } else {
        widget = this.SpawnFromLocal(inkWidgetRef.Get(this.m_ncartLineStationList), n"station");
        widget.SetHAlign(inkEHorizontalAlign.Fill);
        this.PaintStationMarker(widget as inkCompoundWidget, this.m_LinesList[line].m_lineColor, this.GetDistrictColor(this.GetMetroStationDistrict(lineStationsList[i].m_station)));
      };
      i += 1;
    };
    return true;
  }

  private final func PaintStationMarker(widget: wref<inkCompoundWidget>, lineColor: Color, districtColor: Color) -> Void {
    let DistrictBar: wref<inkWidget>;
    let connector: wref<inkWidget>;
    let nameBar: wref<inkWidget>;
    let color: Color = this.m_LinesList[Cast<Int32>(this.cachedLine)].m_lineColor;
    let markshape: wref<inkWidget> = widget.GetWidgetByPath(inkWidgetPath.Build(n"mark", n"mark_shape"));
    if markshape != null {
      markshape.SetTintColor(color);
    };
    connector = widget.GetWidgetByPath(inkWidgetPath.Build(n"connector"));
    if connector != null {
      connector.SetTintColor(color);
    };
    DistrictBar = widget.GetWidgetByPath(inkWidgetPath.Build(n"connector_district"));
    if DistrictBar != null {
      DistrictBar.SetTintColor(districtColor);
    };
    nameBar = widget.GetWidgetByPath(inkWidgetPath.Build(n"StationNameCanvas", n"name_bar_45"));
    if nameBar != null {
      nameBar.SetTintColor(color);
    };
    DistrictBar = widget.GetWidgetByPath(inkWidgetPath.Build(n"StationNameCanvas", n"StationNamePane", n"station_name_box_1"));
    if DistrictBar != null {
      DistrictBar.SetTintColor(color);
    };
    DistrictBar = widget.GetWidgetByPath(inkWidgetPath.Build(n"StationNameCanvas", n"StationNamePane", n"station_name_box_2"));
    if DistrictBar != null {
      DistrictBar.SetTintColor(color);
    };
    DistrictBar = widget.GetWidgetByPath(inkWidgetPath.Build(n"StationNameCanvas", n"StationNamePane", n"station_name_box_3"));
    if DistrictBar != null {
      DistrictBar.SetTintColor(color);
    };
  }

  private final func MarkNextStationOnLine(activeStation: Int32) -> Void {
    let activeStationFound: Bool;
    let newLoop: Bool;
    let stationSetAsNext: Int32;
    let isLooped: Bool = this.m_LinesList[Cast<Int32>(this.cachedLine)].m_lineIsLooped;
    let lineStationsList: array<ncartStationListDef> = this.m_LinesList[Cast<Int32>(this.cachedLine)].m_stationsList;
    let directionReverse: Bool = Cast<Uint32>(this.m_questsSystem.GetFact(this.m_MetroReverseDirectionFact)) > 0u;
    this.m_currentActiveStation = activeStation;
    let i: Int32 = 0;
    while i < ArraySize(lineStationsList) {
      if this.GetMetroStationNumber(lineStationsList[i].m_station) == activeStation {
        if !activeStationFound {
          activeStationFound = true;
          if !directionReverse {
            stationSetAsNext = i + 1;
            this.m_activeStationWidget = i + 1;
          } else {
            stationSetAsNext = i - 1;
            this.m_activeStationWidget = i - 1;
          };
          if isLooped {
            if stationSetAsNext > ArraySize(lineStationsList) - 1 {
              stationSetAsNext = 0;
              this.m_activeStationWidget = 0;
              newLoop = true;
            };
          };
          this.MarkStationActive(stationSetAsNext);
        };
      };
      i += 1;
    };
    if newLoop {
      this.MarkStationInactive(inkCompoundRef.GetWidgetByIndex(this.m_ncartLineStationList, this.m_lastDestination) as inkCompoundWidget, true);
      newLoop = false;
    } else {
      this.MarkStationInactive(inkCompoundRef.GetWidgetByIndex(this.m_ncartLineStationList, this.m_lastDestination) as inkCompoundWidget, false);
    };
    this.m_lastDestination = stationSetAsNext;
    this.m_questsSystem.SetFact(n"ue_metro_next_station", this.GetMetroStationNumber(lineStationsList[stationSetAsNext].m_station));
  }

  private final func MarkStationActive(stationPosition: Int32) -> Void {
    let warningWidget: ref<inkWidget>;
    let widget: ref<inkCompoundWidget> = inkCompoundRef.GetWidgetByIndex(this.m_ncartLineStationList, stationPosition) as inkCompoundWidget;
    let stationName: ref<inkText> = widget.GetWidgetByPath(inkWidgetPath.Build(n"StationNameCanvas", n"StationNamePane", n"StationNameWrapper", n"StatioName")) as inkText;
    let stationNameString: String = this.GetMetroStationLocalizedName(this.m_LinesList[Cast<Int32>(this.cachedLine)].m_stationsList[stationPosition].m_station);
    if IsStringNumber(stationNameString) && !IsStringValid(stationNameString) {
      stationName.SetLocalizedTextString(stationNameString);
    } else {
      stationName.SetText(stationNameString);
    };
    if Equals(this.m_LinesList[Cast<Int32>(this.cachedLine)].m_stationsList[stationPosition].m_station, ENcartStations.PACIFICA_STADIUM) {
      warningWidget = widget.GetWidgetByPath(inkWidgetPath.Build(n"StationNameCanvas", n"StationNamePane", n"StationNameWrapper", n"warningIcon1"));
      warningWidget.SetOpacity(1.00);
      warningWidget = widget.GetWidgetByPath(inkWidgetPath.Build(n"StationNameCanvas", n"StationNamePane", n"StationNameWrapper", n"warningIcon2"));
      warningWidget.SetOpacity(1.00);
    };
    if stationPosition < ArraySize(this.m_LinesList[Cast<Int32>(this.cachedLine)].m_stationsList) - 1 {
      this.PlayLibraryAnimationOnAutoSelectedTargets(n"HighlightStation", widget);
    } else {
      this.PlayLibraryAnimationOnAutoSelectedTargets(n"HighlightStationEnd", widget);
    };
  }

  private final func MarkStationInactive(widget: wref<inkCompoundWidget>, lastStation: Bool) -> Void {
    if !lastStation {
      this.PlayLibraryAnimationOnAutoSelectedTargets(n"HighlightStationRemove", widget);
    } else {
      this.PlayLibraryAnimationOnAutoSelectedTargets(n"HighlightStationRemoveEnd", widget);
    };
  }

  private final func PlayAnimationInReverse() -> inkAnimOptions {
    let playbackOptionsOverrideData: inkAnimOptions;
    let playbackUpdateData: ref<PlaybackOptionsUpdateData>;
    playbackOptionsOverrideData.playReversed = true;
    playbackOptionsOverrideData.loopInfinite = false;
    playbackOptionsOverrideData.loopType = inkanimLoopType.None;
    playbackUpdateData.m_playbackOptions = playbackOptionsOverrideData;
    return playbackOptionsOverrideData;
  }

  private final func SignalTrainStop() -> Void {
    let station: wref<inkCompoundWidget> = inkCompoundRef.GetWidgetByIndex(this.m_ncartLineStationList, this.m_activeStationWidget) as inkCompoundWidget;
    if inkCompoundRef.GetNumChildren(this.m_ncartLineStationList) > this.m_activeStationWidget {
      this.PlayLibraryAnimationOnAutoSelectedTargets(n"TrainStop", station);
    } else {
      this.PlayLibraryAnimationOnAutoSelectedTargets(n"TrainStopEnd", station);
    };
  }
}

public class NcartTrainInkControllerBase extends DeviceInkGameControllerBase {

  protected final const func GetDistrictColor(district: ENcartDistricts) -> Color {
    let color: Color;
    switch district {
      case ENcartDistricts.WATSON:
        color = new Color(124u, 35u, 26u, 255u);
        break;
      case ENcartDistricts.CITY_CENTER:
        color = new Color(240u, 236u, 128u, 255u);
        break;
      case ENcartDistricts.JAPAN_TOWN:
        color = new Color(164u, 110u, 38u, 255u);
        break;
      case ENcartDistricts.HEYWOOD:
        color = new Color(11u, 174u, 94u, 255u);
        break;
      case ENcartDistricts.PACIFICA:
        color = new Color(169u, 47u, 122u, 255u);
        break;
      case ENcartDistricts.SANTO_DOMINGO:
        color = new Color(67u, 32u, 143u, 255u);
    };
    return color;
  }

  protected final const func GetDistrictLocalizedName(district: ENcartDistricts) -> String {
    switch district {
      case ENcartDistricts.WATSON:
        return "LocKey#10947";
      case ENcartDistricts.CITY_CENTER:
        return "LocKey#10950";
      case ENcartDistricts.JAPAN_TOWN:
        return "LocKey#10948";
      case ENcartDistricts.HEYWOOD:
        return "LocKey#10945";
      case ENcartDistricts.PACIFICA:
        return "LocKey#10946";
      case ENcartDistricts.SANTO_DOMINGO:
        return "LocKey#10949";
    };
    return "";
  }

  protected final const func GetMetroStationNumber(stationName: ENcartStations) -> Int32 {
    switch stationName {
      case ENcartStations.ARASAKA_WATERFRONT:
        return 1;
      case ENcartStations.LITTLE_CHINA_HOSPITAL:
        return 2;
      case ENcartStations.LITTLE_CHINA_NORTH:
        return 3;
      case ENcartStations.LITTLE_CHINA_SOUTH:
        return 4;
      case ENcartStations.JAPAN_TOWN_NORTH:
        return 5;
      case ENcartStations.JAPAN_TOWN_SOUTH:
        return 6;
      case ENcartStations.DOWNTOWN_NORTH:
        return 7;
      case ENcartStations.ARROYO:
        return 8;
      case ENcartStations.CITY_CENTER:
        return 9;
      case ENcartStations.ARASAKA_TOWER:
        return 10;
      case ENcartStations.WELLSPRINGS:
        return 11;
      case ENcartStations.GLEN_NORTH:
        return 12;
      case ENcartStations.GLEN_SOUTH:
        return 13;
      case ENcartStations.VISTA_DEL_REY:
        return 14;
      case ENcartStations.RANCHO_CORONADO:
        return 15;
      case ENcartStations.LITTLE_CHINA_MEGABUILDING:
        return 16;
      case ENcartStations.CHARTER_HILL:
        return 17;
      case ENcartStations.GLEN_EBUNIKE:
        return 18;
      case ENcartStations.PACIFICA_STADIUM:
        return 19;
    };
    return 0;
  }

  protected final const func GetMetroStationLocalizedName(stationName: ENcartStations) -> String {
    switch stationName {
      case ENcartStations.ARASAKA_WATERFRONT:
        return "LocKey#95277";
      case ENcartStations.LITTLE_CHINA_HOSPITAL:
        return "LocKey#95260";
      case ENcartStations.LITTLE_CHINA_NORTH:
        return "LocKey#95261";
      case ENcartStations.LITTLE_CHINA_SOUTH:
        return "LocKey#95262";
      case ENcartStations.JAPAN_TOWN_NORTH:
        return "LocKey#95259";
      case ENcartStations.JAPAN_TOWN_SOUTH:
        return "LocKey#95263";
      case ENcartStations.DOWNTOWN_NORTH:
        return "LocKey#95264";
      case ENcartStations.ARROYO:
        return "LocKey#95265";
      case ENcartStations.CITY_CENTER:
        return "LocKey#95266";
      case ENcartStations.ARASAKA_TOWER:
        return "LocKey#95267";
      case ENcartStations.WELLSPRINGS:
        return "LocKey#95268";
      case ENcartStations.GLEN_NORTH:
        return "LocKey#95269";
      case ENcartStations.GLEN_SOUTH:
        return "LocKey#95270";
      case ENcartStations.VISTA_DEL_REY:
        return "LocKey#95271";
      case ENcartStations.RANCHO_CORONADO:
        return "LocKey#95272";
      case ENcartStations.LITTLE_CHINA_MEGABUILDING:
        return "LocKey#95273";
      case ENcartStations.CHARTER_HILL:
        return "LocKey#95274";
      case ENcartStations.GLEN_EBUNIKE:
        return "LocKey#95275";
      case ENcartStations.PACIFICA_STADIUM:
        return "LocKey#95276";
    };
    return "";
  }

  protected final const func GetMetroStationDistrict(stationName: ENcartStations) -> ENcartDistricts {
    switch stationName {
      case ENcartStations.ARASAKA_WATERFRONT:
        return ENcartDistricts.WATSON;
      case ENcartStations.LITTLE_CHINA_HOSPITAL:
        return ENcartDistricts.WATSON;
      case ENcartStations.LITTLE_CHINA_NORTH:
        return ENcartDistricts.WATSON;
      case ENcartStations.LITTLE_CHINA_SOUTH:
        return ENcartDistricts.WATSON;
      case ENcartStations.JAPAN_TOWN_NORTH:
        return ENcartDistricts.JAPAN_TOWN;
      case ENcartStations.JAPAN_TOWN_SOUTH:
        return ENcartDistricts.JAPAN_TOWN;
      case ENcartStations.DOWNTOWN_NORTH:
        return ENcartDistricts.CITY_CENTER;
      case ENcartStations.ARROYO:
        return ENcartDistricts.SANTO_DOMINGO;
      case ENcartStations.CITY_CENTER:
        return ENcartDistricts.CITY_CENTER;
      case ENcartStations.ARASAKA_TOWER:
        return ENcartDistricts.CITY_CENTER;
      case ENcartStations.WELLSPRINGS:
        return ENcartDistricts.HEYWOOD;
      case ENcartStations.GLEN_NORTH:
        return ENcartDistricts.HEYWOOD;
      case ENcartStations.GLEN_SOUTH:
        return ENcartDistricts.HEYWOOD;
      case ENcartStations.VISTA_DEL_REY:
        return ENcartDistricts.HEYWOOD;
      case ENcartStations.RANCHO_CORONADO:
        return ENcartDistricts.SANTO_DOMINGO;
      case ENcartStations.LITTLE_CHINA_MEGABUILDING:
        return ENcartDistricts.WATSON;
      case ENcartStations.CHARTER_HILL:
        return ENcartDistricts.HEYWOOD;
      case ENcartStations.GLEN_EBUNIKE:
        return ENcartDistricts.HEYWOOD;
      case ENcartStations.PACIFICA_STADIUM:
        return ENcartDistricts.PACIFICA;
    };
    return ENcartDistricts.WATSON;
  }

  protected final const func GetMetroStationEnumFromNumber(stationNumber: Int32) -> ENcartStations {
    switch stationNumber {
      case 1:
        return ENcartStations.ARASAKA_WATERFRONT;
      case 2:
        return ENcartStations.LITTLE_CHINA_HOSPITAL;
      case 3:
        return ENcartStations.LITTLE_CHINA_NORTH;
      case 4:
        return ENcartStations.LITTLE_CHINA_SOUTH;
      case 5:
        return ENcartStations.JAPAN_TOWN_NORTH;
      case 6:
        return ENcartStations.JAPAN_TOWN_SOUTH;
      case 7:
        return ENcartStations.DOWNTOWN_NORTH;
      case 8:
        return ENcartStations.ARROYO;
      case 9:
        return ENcartStations.CITY_CENTER;
      case 10:
        return ENcartStations.ARASAKA_TOWER;
      case 11:
        return ENcartStations.WELLSPRINGS;
      case 12:
        return ENcartStations.GLEN_NORTH;
      case 13:
        return ENcartStations.GLEN_SOUTH;
      case 14:
        return ENcartStations.VISTA_DEL_REY;
      case 15:
        return ENcartStations.RANCHO_CORONADO;
      case 16:
        return ENcartStations.LITTLE_CHINA_MEGABUILDING;
      case 17:
        return ENcartStations.CHARTER_HILL;
      case 18:
        return ENcartStations.GLEN_EBUNIKE;
      case 19:
        return ENcartStations.PACIFICA_STADIUM;
    };
    return ENcartStations.NONE;
  }

  protected final const func GetMetroStationLocalizedNameByNumber(stationNumber: Int32) -> String {
    switch stationNumber {
      case 1:
        return "LocKey#95277";
      case 2:
        return "LocKey#95260";
      case 3:
        return "LocKey#95261";
      case 4:
        return "LocKey#95262";
      case 5:
        return "LocKey#95259";
      case 6:
        return "LocKey#95263";
      case 7:
        return "LocKey#95264";
      case 8:
        return "LocKey#95265";
      case 9:
        return "LocKey#95266";
      case 10:
        return "LocKey#95267";
      case 11:
        return "LocKey#95268";
      case 12:
        return "LocKey#95269";
      case 13:
        return "LocKey#95270";
      case 14:
        return "LocKey#95271";
      case 15:
        return "LocKey#95272";
      case 16:
        return "LocKey#95273";
      case 17:
        return "LocKey#95274";
      case 18:
        return "LocKey#95275";
      case 19:
        return "LocKey#95276";
    };
    return "";
  }
}
