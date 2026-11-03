
public class hudCarController extends inkHUDGameController {

  private edit let m_SpeedValue: inkTextRef;

  private edit let m_SpeedUnits: inkTextRef;

  private edit const let m_RPMChunks: [inkImageRef];

  private let m_psmBlackboard: wref<IBlackboard>;

  private let m_PSM_BBID: ref<CallbackHandle>;

  private let m_currentZoom: Float;

  private let currentTime: GameTime;

  private let m_activeVehicleUIBlackboard: wref<IBlackboard>;

  private let m_vehicleBBStateConectionId: ref<CallbackHandle>;

  private let m_speedBBConnectionId: ref<CallbackHandle>;

  private let m_gearBBConnectionId: ref<CallbackHandle>;

  private let m_tppBBConnectionId: ref<CallbackHandle>;

  private let m_rpmValueBBConnectionId: ref<CallbackHandle>;

  private let m_leanAngleBBConnectionId: ref<CallbackHandle>;

  private let m_playerStateBBConnectionId: ref<CallbackHandle>;

  private let m_activeChunks: Int32;

  private let m_rpmMaxValue: Float;

  @default(hudCarController, -1)
  private let m_currentSpeed: Int32;

  private let m_activeVehicle: wref<VehicleObject>;

  private let m_driver: Bool;

  protected let m_settings: ref<UserSettings>;

  protected let m_settingsListener: ref<CarSpeedometerSettingsListener>;

  @default(hudCarController, /interface)
  protected let m_groupPath: CName;

  private let m_kmOn: Bool;

  protected cb func OnInitialize() -> Bool {
    this.PlayLibraryAnimation(n"intro");
  }

  protected cb func OnUninitialize() -> Bool;

  protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
    this.m_psmBlackboard = this.GetPSMBlackboard(playerPuppet);
    if IsDefined(this.m_psmBlackboard) {
      this.m_PSM_BBID = this.m_psmBlackboard.RegisterDelayedListenerFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel, this, n"OnZoomChange");
    };
    this.m_activeVehicle = GetMountedVehicle(this.GetPlayerControlledObject());
    this.m_driver = VehicleComponent.IsDriver(this.m_activeVehicle.GetGame(), this.GetPlayerControlledObject());
    if IsDefined(this.m_activeVehicle) && this.m_driver {
      this.GetRootWidget().SetVisible(this.CheckIfInTPP());
      this.RegisterUserSettingsListener();
      this.RegisterToVehicle(true);
      this.Reset();
    } else {
      this.GetRootWidget().SetVisible(false);
    };
  }

  protected cb func OnPlayerDetach(playerPuppet: ref<GameObject>) -> Bool {
    this.m_psmBlackboard.UnregisterDelayedListener(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel, this.m_PSM_BBID);
    if IsDefined(this.m_activeVehicle) {
      this.GetRootWidget().SetVisible(false);
      this.RegisterToVehicle(false);
      this.m_activeVehicle = null;
      this.m_currentSpeed = -1;
    };
  }

  protected cb func OnMountingEvent(evt: ref<MountingEvent>) -> Bool {
    this.m_activeVehicle = GetMountedVehicle(this.GetPlayerControlledObject());
    this.m_driver = VehicleComponent.IsDriver(this.m_activeVehicle.GetGame(), this.GetPlayerControlledObject());
    this.GetRootWidget().SetVisible(false);
    this.RegisterToVehicle(true);
    this.Reset();
  }

  protected cb func OnUnmountingEvent(evt: ref<UnmountingEvent>) -> Bool {
    if !evt.request.mountData.mountEventOptions.silentUnmount {
      this.GetRootWidget().SetVisible(false);
      this.RegisterToVehicle(false);
      this.m_activeVehicle = null;
      this.m_currentSpeed = -1;
    };
  }

  private final func CheckIfInTPP() -> Bool {
    let activeVehicleUIBlackboard: wref<IBlackboard>;
    if this.m_activeVehicle == null {
      return false;
    };
    activeVehicleUIBlackboard = GameInstance.GetBlackboardSystem(this.m_activeVehicle.GetGame()).Get(GetAllBlackboardDefs().UI_ActiveVehicleData);
    return activeVehicleUIBlackboard.GetBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsTPPCameraOn);
  }

  private final func RegisterToVehicle(register: Bool) -> Void {
    let activeVehicleUIBlackboard: wref<IBlackboard>;
    let record: wref<Vehicle_Record>;
    let vehEngineData: wref<VehicleEngineData_Record>;
    let vehicleBlackboard: wref<IBlackboard>;
    let vehicle: ref<VehicleObject> = this.m_activeVehicle;
    if vehicle == null {
      return;
    };
    vehicleBlackboard = vehicle.GetBlackboard();
    if IsDefined(vehicleBlackboard) {
      if register {
        this.m_speedBBConnectionId = vehicleBlackboard.RegisterListenerFloat(GetAllBlackboardDefs().Vehicle.SpeedValue, this, n"OnSpeedValueChanged");
        this.m_gearBBConnectionId = vehicleBlackboard.RegisterListenerInt(GetAllBlackboardDefs().Vehicle.GearValue, this, n"OnGearValueChanged");
        this.m_rpmValueBBConnectionId = vehicleBlackboard.RegisterListenerFloat(GetAllBlackboardDefs().Vehicle.RPMValue, this, n"OnRpmValueChanged");
        record = vehicle.GetRecord();
        vehEngineData = record.VehEngineData();
        this.m_rpmMaxValue = vehEngineData.MaxRPM();
      } else {
        vehicleBlackboard.UnregisterListenerFloat(GetAllBlackboardDefs().Vehicle.SpeedValue, this.m_speedBBConnectionId);
        vehicleBlackboard.UnregisterListenerInt(GetAllBlackboardDefs().Vehicle.GearValue, this.m_gearBBConnectionId);
        vehicleBlackboard.UnregisterListenerFloat(GetAllBlackboardDefs().Vehicle.RPMValue, this.m_rpmValueBBConnectionId);
      };
    };
    activeVehicleUIBlackboard = GameInstance.GetBlackboardSystem(vehicle.GetGame()).Get(GetAllBlackboardDefs().UI_ActiveVehicleData);
    if IsDefined(activeVehicleUIBlackboard) {
      if register {
        this.m_tppBBConnectionId = activeVehicleUIBlackboard.RegisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsTPPCameraOn, this, n"OnCameraModeChanged", true);
      } else {
        activeVehicleUIBlackboard.UnregisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsTPPCameraOn, this.m_tppBBConnectionId);
      };
    };
  }

  protected cb func OnZoomChange(evt: Float) -> Bool {
    this.m_currentZoom = evt;
  }

  protected cb func OnRpmMaxChanged(rpmMax: Float) -> Bool;

  protected cb func OnSpeedValueChanged(speedValue: Float) -> Bool {
    speedValue = AbsF(speedValue);
    let multiplier: Float = GameInstance.GetStatsDataSystem(this.m_activeVehicle.GetGame()).GetValueFromCurve(n"vehicle_ui", speedValue, n"speed_to_multiplier");
    let floatspeed: Float = speedValue * multiplier;
    let speed: Int32 = RoundMath(speedValue * multiplier);
    if speed != this.m_currentSpeed {
      if this.m_kmOn {
        inkTextRef.SetText(this.m_SpeedValue, IntToString(RoundMath(floatspeed * 1.61)));
      } else {
        inkTextRef.SetText(this.m_SpeedValue, IntToString(speed));
      };
      this.m_currentSpeed = speed;
    };
  }

  protected cb func OnGearValueChanged(gearValue: Int32) -> Bool {
    if gearValue == 0 {
    };
  }

  protected cb func OnRpmValueChanged(rpmValue: Float) -> Bool {
    this.drawRPMGaugeFull(rpmValue);
  }

  private final func Reset() -> Void {
    this.OnSpeedValueChanged(0.00);
    this.OnRpmValueChanged(0.00);
  }

  public final func drawRPMGaugeFull(rpmValue: Float) -> Void {
    let level: Float = (rpmValue / this.m_rpmMaxValue * 5000.00) / Cast<Float>(ArraySize(this.m_RPMChunks) * 49);
    let levelInt: Int32 = Cast<Int32>(level);
    if rpmValue > 500.00 && level < 1.00 {
      levelInt = 1;
    };
    this.EvaluateRPMMeterWidget(levelInt);
  }

  private final func EvaluateRPMMeterWidget(currentAmountOfChunks: Int32) -> Void {
    if currentAmountOfChunks == this.m_activeChunks {
      return;
    };
    this.m_activeChunks = currentAmountOfChunks;
    this.UpdateChunkVisibility();
  }

  private final func UpdateChunkVisibility() -> Void {
    let visible: Bool;
    let i: Int32 = 0;
    while i <= ArraySize(this.m_RPMChunks) {
      visible = i < this.m_activeChunks;
      inkWidgetRef.SetVisible(this.m_RPMChunks[i], visible);
      i += 1;
    };
  }

  protected cb func OnLeanAngleChanged(leanAngle: Float) -> Bool;

  protected cb func OnCameraModeChanged(mode: Bool) -> Bool {
    if this.m_driver {
      this.GetRootWidget().SetVisible(mode);
      this.RegisterUserSettingsListener();
    };
  }

  public final func OnVarModified(groupPath: CName, varName: CName, varType: ConfigVarType, reason: ConfigChangeReason) -> Void {
    switch varName {
      case n"SpeedometerUnits":
        this.UpdateMeasurementUnits();
        break;
      default:
    };
  }

  private final func UpdateMeasurementUnits() -> Void {
    let configVar: ref<ConfigVarListString> = this.m_settings.GetVar(this.m_groupPath, n"SpeedometerUnits") as ConfigVarListString;
    this.SetMeasurementUnits(configVar.GetIndex());
  }

  protected func SetMeasurementUnits(value: Int32) -> Void {
    if value == 1 {
      this.m_kmOn = false;
      inkTextRef.SetLocalizedTextScript(this.m_SpeedUnits, "LocKey#95281");
    } else {
      this.m_kmOn = true;
      inkTextRef.SetLocalizedTextScript(this.m_SpeedUnits, "LocKey#95356");
    };
  }

  private final func RegisterUserSettingsListener() -> Void {
    this.m_settings = new UserSettings();
    this.m_settingsListener = new CarSpeedometerSettingsListener();
    this.m_settingsListener.RegisterController(this);
    this.m_settingsListener.Register(this.m_groupPath);
    this.UpdateMeasurementUnits();
  }
}

public class CarSpeedometerSettingsListener extends ConfigVarListener {

  private let m_ctrl: wref<hudCarController>;

  public final func RegisterController(ctrl: ref<hudCarController>) -> Void {
    this.m_ctrl = ctrl;
  }

  public func OnVarModified(groupPath: CName, varName: CName, varType: ConfigVarType, reason: ConfigChangeReason) -> Void {
    this.m_ctrl.OnVarModified(groupPath, varName, varType, reason);
  }
}
