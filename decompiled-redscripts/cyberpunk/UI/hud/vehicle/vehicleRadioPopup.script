
public class RadioStationsDataView extends ScriptableDataView {

  public func SortItem(left: ref<IScriptable>, right: ref<IScriptable>) -> Bool {
    return true;
  }

  public func FilterItem(data: ref<IScriptable>) -> Bool {
    return true;
  }
}

public class VehicleRadioPopupGameController extends BaseModalListPopupGameController {

  private edit let m_icon: inkImageRef;

  private edit let m_trackName: inkTextRef;

  private edit let m_scrollArea: inkScrollAreaRef;

  private edit let m_scrollControllerWidget: inkWidgetRef;

  @runtimeProperty("category", "Volume")
  private edit let m_radioVolumeSettings: inkWidgetRef;

  @runtimeProperty("category", "Volume")
  @default(VehicleRadioPopupGameController, /audio/volume)
  private edit let m_volumeSettingGroupName: CName;

  @runtimeProperty("category", "Volume")
  @default(VehicleRadioPopupGameController, CarRadioVolume)
  private edit let m_volumeSettingVarName: CName;

  private let m_dataView: ref<RadioStationsDataView>;

  private let m_dataSource: ref<ScriptableDataSource>;

  private let m_quickSlotsManager: wref<QuickSlotsManager>;

  private let m_player: wref<PlayerPuppet>;

  private let m_playerVehicle: wref<VehicleObject>;

  private let m_startupIndex: Uint32;

  private let m_currentRadioId: Int32;

  private let m_selectedItem: wref<RadioStationListItemController>;

  private let m_scrollController: wref<inkScrollController>;

  private let m_canVolumeDown: Bool;

  private let m_canVolumeUp: Bool;

  private let m_radioVolumeSettingsController: wref<RadioVolumeSettingsController>;

  private final func GetVolumeSettingVarName() -> CName {
    if IsDefined(this.m_playerVehicle) {
      return n"CarRadioVolume";
    };
    return n"RadioportVolume";
  }

  private final func GetRadioReceiverTrackName() -> CName {
    if IsDefined(this.m_playerVehicle) {
      return this.m_playerVehicle.GetRadioReceiverTrackName();
    };
    return this.m_player.GetPocketRadio().GetTrackName();
  }

  private final func GetRadioReceiverStationName() -> CName {
    if IsDefined(this.m_playerVehicle) {
      return this.m_playerVehicle.GetRadioReceiverStationName();
    };
    return this.m_player.GetPocketRadio().GetStationName();
  }

  private final func IsRadioReceiverActive() -> Bool {
    if IsDefined(this.m_playerVehicle) {
      return this.m_playerVehicle.IsRadioReceiverActive();
    };
    return this.m_player.GetPocketRadio().IsActive();
  }

  private final func GetRadioReceiverEntityID() -> EntityID {
    if IsDefined(this.m_playerVehicle) {
      return this.m_playerVehicle.GetEntityID();
    };
    return this.m_player.GetEntityID();
  }

  protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
    let playerControlledObject: ref<GameObject>;
    let trackName: CName;
    this.m_player = playerPuppet as PlayerPuppet;
    VehicleComponent.GetVehicle(this.m_player.GetGame(), this.m_player, this.m_playerVehicle);
    super.OnPlayerAttach(playerPuppet);
    this.m_quickSlotsManager = this.m_player.GetQuickSlotsManager();
    this.m_scrollController = inkWidgetRef.GetControllerByType(this.m_scrollControllerWidget, n"inkScrollController") as inkScrollController;
    inkWidgetRef.RegisterToCallback(this.m_scrollArea, n"OnScrollChanged", this, n"OnScrollChanged");
    trackName = this.GetRadioReceiverTrackName();
    this.SetTrackName(trackName);
    playerControlledObject = this.GetPlayerControlledObject();
    playerControlledObject.RegisterInputListener(this, n"radio_volume_down");
    playerControlledObject.RegisterInputListener(this, n"radio_volume_up");
    this.SetupVolumeContorls();
    this.PlaySound(n"Holocall", n"OnPickingUp");
  }

  protected func VirtualListReady() -> Void {
    let radioIndexEvent: ref<RadioStationChangedEvent>;
    this.m_listController.SelectItem(this.m_startupIndex);
    this.m_listController.ScrollToIndex(this.m_startupIndex);
    radioIndexEvent = new RadioStationChangedEvent();
    radioIndexEvent.m_radioIndex = this.m_currentRadioId;
    this.QueueEvent(radioIndexEvent);
  }

  protected cb func OnShowAnimFinished(proxy: ref<inkAnimProxy>) -> Bool {
    this.m_listController.SelectItem(this.m_startupIndex);
    this.m_canPlaySwitchAnimation = true;
  }

  protected cb func OnScrollChanged(value: Vector2) -> Bool {
    this.m_scrollController.UpdateScrollPositionFromScrollArea();
  }

  protected func Select(previous: ref<inkVirtualCompoundItemController>, next: ref<inkVirtualCompoundItemController>) -> Void {
    this.m_selectedItem = next as RadioStationListItemController;
    let data: ref<RadioListItemData> = this.m_selectedItem.GetStationData();
    InkImageUtils.RequestSetImage(this, this.m_icon, data.m_record.Icon().GetID());
  }

  protected func SetupTimeModifierConfig() -> Void {
    this.m_timeDilationProfile = "vehicleRadioMenu";
  }

  protected func SetupVirtualList() -> Void {
    this.m_dataView = new RadioStationsDataView();
    this.m_dataSource = new ScriptableDataSource();
    this.m_dataView.SetSource(this.m_dataSource);
    this.m_listController.SetSource(this.m_dataView);
  }

  protected func CleanVirtualList() -> Void {
    this.m_dataView.SetSource(null);
    this.m_listController.SetSource(null);
    this.m_dataView = null;
    this.m_dataSource = null;
  }

  protected func SetupData() -> Void {
    let i: Int32;
    let radioArraySize: Int32;
    let radioName: CName;
    let stationRecord: ref<RadioStation_Record>;
    this.m_dataSource.Reset(VehiclesManagerDataHelper.GetRadioStations(this.m_playerPuppet));
    this.m_startupIndex = 0u;
    this.m_currentRadioId = -1;
    if this.IsRadioReceiverActive() {
      radioName = this.GetRadioReceiverStationName();
      if IsNameValid(radioName) {
        radioArraySize = Cast<Int32>(this.m_dataSource.GetArraySize());
        i = 0;
        while i < radioArraySize {
          stationRecord = this.m_dataSource.GetItem(Cast<Uint32>(i)) as RadioListItemData.m_record;
          if IsDefined(stationRecord) {
            if Equals(GetLocalizedText(stationRecord.DisplayName()), GetLocalizedTextByKey(radioName)) {
              this.m_startupIndex = Cast<Uint32>(i);
              this.m_currentRadioId = stationRecord.Index();
              break;
            };
          };
          i += 1;
        };
      };
    };
  }

  private final func SetupVolumeContorls() -> Void {
    let settingsGroup: ref<ConfigGroup>;
    let settingsVarName: CName;
    let settings: ref<UserSettings> = this.GetSystemRequestsHandler().GetUserSettings();
    this.m_radioVolumeSettingsController = inkWidgetRef.GetController(this.m_radioVolumeSettings) as RadioVolumeSettingsController;
    settings = this.GetSystemRequestsHandler().GetUserSettings();
    if settings.HasGroup(this.m_volumeSettingGroupName) {
      settingsGroup = settings.GetGroup(this.m_volumeSettingGroupName);
      settingsVarName = this.GetVolumeSettingVarName();
      if settingsGroup.HasVar(settingsVarName) {
        this.m_radioVolumeSettingsController.Setup(settingsGroup.GetVar(settingsVarName), false);
      };
    };
  }

  protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    let actionName: CName = ListenerAction.GetName(action);
    let actionType: gameinputActionType = ListenerAction.GetType(action);
    super.OnAction(action, consumer);
    if Equals(actionName, n"radio_volume_down") && Equals(actionType, gameinputActionType.BUTTON_PRESSED) {
      this.m_canVolumeDown = true;
    };
    if Equals(actionName, n"radio_volume_up") && Equals(actionType, gameinputActionType.BUTTON_PRESSED) {
      this.m_canVolumeUp = true;
    };
    this.AdjustRadioVolumeWithAction(actionName, actionType);
  }

  private final func AdjustRadioVolumeWithAction(actionName: CName, actionType: gameinputActionType) -> Void {
    if Equals(actionType, gameinputActionType.BUTTON_PRESSED) || Equals(actionType, gameinputActionType.REPEAT) {
      if Equals(actionName, n"radio_volume_down") && this.m_canVolumeDown {
        this.m_radioVolumeSettingsController.VolumeDown();
      };
      if Equals(actionName, n"radio_volume_up") && this.m_canVolumeUp {
        this.m_radioVolumeSettingsController.VolumeUp();
      };
    };
  }

  protected cb func OnVehicleRadioSongChanged(evt: ref<VehicleRadioSongChanged>) -> Bool {
    this.SetTrackName(evt.radioSongName);
  }

  protected cb func OnVehicleRadioEvent(evt: ref<UIVehicleRadioEvent>) -> Bool {
    let data: ref<RadioListItemData>;
    let radioIndexEvent: ref<RadioStationChangedEvent>;
    let track: CName = this.GetRadioReceiverTrackName();
    this.SetTrackName(track);
    data = this.m_selectedItem.GetStationData();
    radioIndexEvent = new RadioStationChangedEvent();
    radioIndexEvent.m_radioIndex = data.m_record.Index();
    this.QueueEvent(radioIndexEvent);
  }

  private final func SetTrackName(track: CName) -> Void {
    if IsNameValid(track) && NotEquals(track, n"None") {
      inkTextRef.SetLocalizedText(this.m_trackName, track);
      inkWidgetRef.SetVisible(this.m_trackName, true);
    } else {
      inkWidgetRef.SetVisible(this.m_trackName, false);
    };
  }

  protected func Activate() -> Void {
    let data: ref<RadioListItemData>;
    let radioIndexEvent: ref<RadioStationChangedEvent>;
    if !IsDefined(this.m_selectedItem) {
      return;
    };
    data = this.m_selectedItem.GetStationData();
    if data.m_record.Index() == -1 {
      this.m_quickSlotsManager.SendRadioEvent(false, false, -1);
      inkWidgetRef.SetVisible(this.m_trackName, false);
      radioIndexEvent = new RadioStationChangedEvent();
      radioIndexEvent.m_radioIndex = -1;
      this.QueueEvent(radioIndexEvent);
    } else {
      this.m_quickSlotsManager.SendRadioEvent(true, true, data.m_record.Index());
    };
  }

  protected func OnClose() -> Void {
    let controller: wref<VehicleRadioLogicController> = this.GetRootWidget().GetController() as VehicleRadioLogicController;
    if IsDefined(controller) {
      controller.StopSound();
    };
    this.PlaySound(n"Holocall", n"OnHangUp");
  }
}

public class RadioStationListItemController extends inkVirtualCompoundItemController {

  private edit let m_label: inkTextRef;

  private edit let m_typeIcon: inkImageRef;

  private edit let m_equilizerIcon: inkHorizontalPanelRef;

  private edit let m_codeTLicon: inkImageRef;

  private let m_stationData: ref<RadioListItemData>;

  @default(RadioStationListItemController, -1)
  private let m_currentRadioStationId: Int32;

  public final func GetStationData() -> ref<RadioListItemData> {
    return this.m_stationData;
  }

  protected cb func OnInitialize() -> Bool {
    this.RegisterToCallback(n"OnSelected", this, n"OnSelected");
    this.RegisterToCallback(n"OnDeselected", this, n"OnDeselected");
  }

  protected cb func OnDataChanged(value: Variant) -> Bool {
    this.m_stationData = FromVariant<ref<IScriptable>>(value) as RadioListItemData;
    inkTextRef.SetText(this.m_label, this.m_stationData.m_record.DisplayName());
    this.UpdateEquializer();
  }

  protected cb func OnSelected(itemController: wref<inkVirtualCompoundItemController>, discreteNav: Bool) -> Bool {
    this.GetRootWidget().SetState(n"Active");
  }

  protected cb func OnDeselected(itemController: wref<inkVirtualCompoundItemController>) -> Bool {
    this.GetRootWidget().SetState(n"Default");
    this.PlaySound(n"Holocall", n"Navigation");
  }

  protected cb func OnRadioStationChangedEvent(evt: ref<RadioStationChangedEvent>) -> Bool {
    this.m_currentRadioStationId = evt.m_radioIndex;
    this.UpdateEquializer();
  }

  private final func UpdateEquializer() -> Void {
    let isCurrentRadioStation: Bool = this.m_currentRadioStationId == this.m_stationData.m_record.Index() && this.m_currentRadioStationId != -1;
    inkWidgetRef.SetVisible(this.m_equilizerIcon, isCurrentRadioStation);
    inkWidgetRef.SetVisible(this.m_codeTLicon, !isCurrentRadioStation);
  }
}

public class VehicleRadioLogicController extends inkLogicController {

  @default(VehicleRadioLogicController, false)
  public let m_isSoundStopped: Bool;

  protected cb func OnUninitialize() -> Bool {
    this.StopSound();
  }

  public final func StopSound() -> Void {
    if !this.m_isSoundStopped {
      this.m_isSoundStopped = true;
      this.PlaySound(n"Holocall", n"Navigation");
    };
  }
}

public class RadioVolumeSettingsController extends SettingsSelectorController {

  private edit let m_value: inkTextRef;

  public func Setup(entry: ref<ConfigVar>, isPreGame: Bool) -> Void {
    let value: ref<ConfigVarInt>;
    super.Setup(entry, isPreGame);
    value = this.m_SettingsEntry as ConfigVarInt;
    inkTextRef.SetText(this.m_value, IntToString(value.GetValue()) + "%");
  }

  public final func VolumeUp() -> Void {
    this.PlaySound(n"Holocall", n"Navigation");
    this.ChangeValue(true);
  }

  public final func VolumeDown() -> Void {
    this.PlaySound(n"Holocall", n"Navigation");
    this.ChangeValue(false);
  }

  private func ChangeValue(forward: Bool) -> Void {
    let congiVar: ref<ConfigVarInt> = this.m_SettingsEntry as ConfigVarInt;
    let step: Int32 = forward ? congiVar.GetStepValue() : -congiVar.GetStepValue();
    let newValue: Int32 = congiVar.GetValue();
    newValue = Clamp(newValue + step, congiVar.GetMinValue(), congiVar.GetMaxValue());
    congiVar.SetValue(newValue);
    inkTextRef.SetText(this.m_value, IntToString(newValue) + "%");
    this.Refresh();
  }
}
