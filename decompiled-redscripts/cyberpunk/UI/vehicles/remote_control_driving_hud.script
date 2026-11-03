
public native class RemoteControlDrivingHUDGameController extends inkHUDGameController {

  private edit let m_overlay: inkWidgetRef;

  private edit let m_vehicleManufacturer: inkImageRef;

  private edit let m_containerSignalStrength: inkWidgetRef;

  private edit let m_signalStrengthBarFill: inkWidgetRef;

  private let m_containerSignalStrengthIntroOutroAnimProxy: ref<inkAnimProxy>;

  private let m_weakSignalStrengthAnimProxy: ref<inkAnimProxy>;

  private let m_remoteControlledVehicleDataCallback: ref<CallbackHandle>;

  private let m_remoteControlledVehicleCameraChangedToTPPCallback: ref<CallbackHandle>;

  private let m_remoteControlledVehicle: wref<VehicleObject>;

  private let m_maxRemoteControlDrivingRange: Float;

  private let m_mappinID: NewMappinID;

  protected cb func OnInitialize() -> Bool {
    this.m_maxRemoteControlDrivingRange = TweakDBInterface.GetFloat(t"player.vehicleQuickHacks.maxRange", 0.00);
  }

  protected cb func OnUpdate(dT: Float) -> Bool {
    let currentSignalStrength: Float;
    if inkWidgetRef.IsVisible(this.m_containerSignalStrength) && !this.m_containerSignalStrengthIntroOutroAnimProxy.IsValid() {
      currentSignalStrength = 1.00 - MinF(SqrtF(this.m_remoteControlledVehicle.GetDistanceToPlayerSquared()) / this.m_maxRemoteControlDrivingRange, 1.00);
      inkWidgetRef.SetScale(this.m_signalStrengthBarFill, new Vector2(currentSignalStrength, 1.00));
      if currentSignalStrength > 0.25 {
        if this.m_weakSignalStrengthAnimProxy.IsValid() {
          this.m_weakSignalStrengthAnimProxy.GotoStartAndStop();
          this.m_weakSignalStrengthAnimProxy = null;
        };
      } else {
        if !this.m_weakSignalStrengthAnimProxy.IsValid() {
          this.m_weakSignalStrengthAnimProxy = this.PlayLibraryAnimation(n"signal_strength_blinking");
        };
      };
    };
  }

  protected cb func OnPlayerAttach(player: ref<GameObject>) -> Bool {
    this.m_remoteControlledVehicleCameraChangedToTPPCallback = this.GetPSMBlackboard(player).RegisterListenerBool(GetAllBlackboardDefs().PlayerStateMachine.IsVehicleRemoteControlCameraTPP, this, n"OnPSMRemoteControlledVehicleCameraChangedToTPP");
    this.m_remoteControlledVehicleDataCallback = GameInstance.GetBlackboardSystem(player.GetGame()).Get(GetAllBlackboardDefs().UI_ActiveVehicleData).RegisterListenerVariant(GetAllBlackboardDefs().UI_ActiveVehicleData.RemoteControlledVehicleData, this, n"OnRemoteControlledVehicleChanged", true);
  }

  protected cb func OnPlayerDetach(player: ref<GameObject>) -> Bool {
    if IsDefined(this.m_remoteControlledVehicleCameraChangedToTPPCallback) {
      this.GetPSMBlackboard(player).UnregisterListenerBool(GetAllBlackboardDefs().PlayerStateMachine.IsVehicleRemoteControlCameraTPP, this.m_remoteControlledVehicleCameraChangedToTPPCallback);
    };
    if IsDefined(this.m_remoteControlledVehicleDataCallback) {
      GameInstance.GetBlackboardSystem(player.GetGame()).Get(GetAllBlackboardDefs().UI_ActiveVehicleData).UnregisterListenerVariant(GetAllBlackboardDefs().UI_ActiveVehicleData.RemoteControlledVehicleData, this.m_remoteControlledVehicleDataCallback);
    };
  }

  protected cb func OnPSMRemoteControlledVehicleCameraChangedToTPP(value: Bool) -> Bool {
    GameInstance.GetMappinSystem(this.GetPlayerControlledObject().GetGame()).SetMappinActive(this.m_mappinID, !value);
  }

  protected cb func OnRemoteControlledVehicleChanged(value: Variant) -> Bool {
    let options: inkAnimOptions;
    let progression: Float;
    let record: ref<Vehicle_Record>;
    let data: RemoteControlDrivingUIData = FromVariant<RemoteControlDrivingUIData>(value);
    let player: wref<GameObject> = this.GetPlayerControlledObject();
    let isQuestRemoteControlDriving: Bool = false;
    this.m_remoteControlledVehicle = data.remoteControlledVehicle;
    this.DestroyMappin();
    if IsDefined(this.m_remoteControlledVehicle) {
      isQuestRemoteControlDriving = IsDefined(this.m_remoteControlledVehicle) && this.m_remoteControlledVehicle == GetMountedVehicle(player);
      if !isQuestRemoteControlDriving {
        this.CreateMappin();
        inkWidgetRef.SetVisible(this.m_containerSignalStrength, true);
        this.m_containerSignalStrengthIntroOutroAnimProxy = this.PlayLibraryAnimation(n"connection-intro");
        if VehicleComponent.GetVehicleRecord(this.m_remoteControlledVehicle, record) {
          inkImageRef.SetTexturePart(this.m_vehicleManufacturer, TweakDBInterface.GetUIIconRecord(TDBID.Create("UIIcon." + record.Manufacturer().EnumName())).AtlasPartName());
        };
        GameObjectEffectHelper.StartEffectEvent(player, n"fish_eye");
      };
    } else {
      if this.m_containerSignalStrengthIntroOutroAnimProxy.IsValid() {
        progression = this.m_containerSignalStrengthIntroOutroAnimProxy.GetProgression();
        this.m_containerSignalStrengthIntroOutroAnimProxy.Stop();
        this.m_containerSignalStrengthIntroOutroAnimProxy = null;
        if progression < 1.16 {
          options.fromMarker = n"connection_lost";
        };
      } else {
        if data.isDistanceDisconnect {
          options.fromMarker = n"connection_lost";
        };
      };
      this.m_containerSignalStrengthIntroOutroAnimProxy = this.PlayLibraryAnimation(n"connection-outro", options);
      this.m_containerSignalStrengthIntroOutroAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnConnectionOutroFinished");
      GameObjectEffectHelper.StopEffectEvent(player, n"fish_eye");
    };
    inkWidgetRef.SetVisible(this.m_overlay, this.m_remoteControlledVehicle != null && !isQuestRemoteControlDriving);
  }

  protected cb func OnConnectionOutroFinished(anim: ref<inkAnimProxy>) -> Bool {
    this.m_containerSignalStrengthIntroOutroAnimProxy.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnConnectionOutroFinished");
    this.m_containerSignalStrengthIntroOutroAnimProxy = null;
    inkWidgetRef.SetVisible(this.m_containerSignalStrength, false);
  }

  private final func CreateMappin() -> Void {
    let mappinData: MappinData;
    let mappinSystem: ref<MappinSystem> = GameInstance.GetMappinSystem(this.GetPlayerControlledObject().GetGame());
    mappinData.mappinType = t"Mappins.RemoteControlDrivingMappinDefinition";
    mappinData.variant = gamedataMappinVariant.Zzz10_RemoteControlDrivingVariant;
    mappinData.active = true;
    mappinData.visibleThroughWalls = true;
    this.m_mappinID = mappinSystem.RegisterMappinWithObject(mappinData, this.m_remoteControlledVehicle, n"vehMappin");
  }

  private final func DestroyMappin() -> Void {
    let mappinSystem: ref<MappinSystem>;
    if this.m_mappinID.value != 0u {
      mappinSystem = GameInstance.GetMappinSystem(this.GetPlayerControlledObject().GetGame());
      mappinSystem.UnregisterMappin(this.m_mappinID);
      this.m_mappinID.value = 0u;
    };
  }
}
