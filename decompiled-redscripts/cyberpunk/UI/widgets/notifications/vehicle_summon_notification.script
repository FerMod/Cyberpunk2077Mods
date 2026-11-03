
public class VehicleSummonWidgetGameController extends inkHUDGameController {

  private edit let m_vehicleNameLabel: inkTextRef;

  private edit let m_vehicleTypeIcon: inkImageRef;

  private edit let m_vehicleManufactorIcon: inkImageRef;

  private edit let m_distanceLabel: inkTextRef;

  private edit let m_subText: inkTextRef;

  private edit let m_radioStationName: inkTextRef;

  @default(VehicleSummonWidgetGameController, 35)
  private edit let m_loopCounter: Uint32;

  private let m_rootWidget: wref<inkWidget>;

  private let m_player: wref<PlayerPuppet>;

  private let m_vehicle: wref<VehicleObject>;

  private let m_vehicleRecord: ref<Vehicle_Record>;

  private let m_gameInstance: GameInstance;

  private let m_vehicleSummonDataBB: wref<IBlackboard>;

  private let m_mountCallback: ref<CallbackHandle>;

  private let m_vehicleSummonStateCallback: ref<CallbackHandle>;

  private let m_vehiclePurchaseStateCallback: ref<CallbackHandle>;

  private let m_currentAnimation: CName;

  private let m_animationProxy: ref<inkAnimProxy>;

  private let m_animationCounterProxy: ref<inkAnimProxy>;

  protected cb func OnInitialize() -> Bool {
    this.m_rootWidget = this.GetRootWidget();
    this.Reset();
  }

  protected cb func OnPlayerAttach(player: ref<GameObject>) -> Bool {
    let blackboardSystem: ref<BlackboardSystem> = this.GetBlackboardSystem();
    this.m_gameInstance = player.GetGame();
    this.m_player = player as PlayerPuppet;
    this.m_mountCallback = blackboardSystem.Get(GetAllBlackboardDefs().UI_ActiveVehicleData).RegisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, this, n"OnVehicleMount");
    let mountingInfo: MountingInfo = GameInstance.GetMountingFacility(this.m_player.GetGame()).GetMountingInfoSingleWithObjects(this.m_player);
    this.TryUpdateActiveVehicleData(mountingInfo.parentId);
    this.TryShowVehicleRadioNotification();
    this.m_vehicleSummonDataBB = blackboardSystem.Get(GetAllBlackboardDefs().VehicleSummonData);
    this.m_vehicleSummonStateCallback = this.m_vehicleSummonDataBB.RegisterListenerUint(GetAllBlackboardDefs().VehicleSummonData.SummonState, this, n"OnVehicleSummonStateChanged");
    this.m_vehiclePurchaseStateCallback = blackboardSystem.Get(GetAllBlackboardDefs().VehiclePurchaseData).RegisterListenerVariant(GetAllBlackboardDefs().VehiclePurchaseData.PurchasedVehicleRecordID, this, n"OnVehiclePurchased");
  }

  protected cb func OnPlayerDetach(player: ref<GameObject>) -> Bool {
    let blackboardSystem: ref<BlackboardSystem> = this.GetBlackboardSystem();
    this.m_vehicleSummonDataBB.UnregisterListenerUint(GetAllBlackboardDefs().VehicleSummonData.SummonState, this.m_vehicleSummonStateCallback);
    blackboardSystem.Get(GetAllBlackboardDefs().VehiclePurchaseData).UnregisterListenerVariant(GetAllBlackboardDefs().VehiclePurchaseData.PurchasedVehicleRecordID, this.m_vehiclePurchaseStateCallback);
    blackboardSystem.Get(GetAllBlackboardDefs().UI_ActiveVehicleData).UnregisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsPlayerMounted, this.m_mountCallback);
  }

  protected cb func OnVehicleSummonStateChanged(value: Uint32) -> Bool {
    if value == 1u {
      this.ShowVehicleSummonNotification();
    } else {
      if value == 2u {
        this.ShowVehicleWaitingNotification();
      } else {
        if value == 4u {
          this.PlayAnimation(n"arrived", new inkAnimOptions(), n"OnTimeOut");
        } else {
          this.m_rootWidget.SetVisible(false);
        };
      };
    };
  }

  protected cb func OnVehiclePurchased(value: Variant) -> Bool {
    this.m_rootWidget.SetVisible(true);
    inkWidgetRef.SetVisible(this.m_subText, true);
    this.UpdateVehicleNotificationData(FromVariant<TweakDBID>(value));
    inkTextRef.SetText(this.m_subText, "LocKey#43690");
    this.PlayAnimation(n"OnVehiclePurchase", new inkAnimOptions(), n"OnTimeOut");
  }

  protected cb func OnVehicleMount(value: Bool) -> Bool {
    let mountingInfo: MountingInfo;
    if value {
      mountingInfo = GameInstance.GetMountingFacility(this.m_player.GetGame()).GetMountingInfoSingleWithObjects(this.m_player);
      if this.TryUpdateActiveVehicleData(mountingInfo.parentId) {
        this.m_rootWidget.SetVisible(true);
        this.PlayAnimation(n"OnVehicleEnter", new inkAnimOptions(), n"OnVehicleEnterDone");
      };
    } else {
      this.Reset();
    };
  }

  protected cb func OnVehicleEnterDone(anim: ref<inkAnimProxy>) -> Bool {
    if !this.TryShowVehicleRadioNotification() {
      this.Reset();
    };
  }

  protected cb func OnVehicleRadioSongChanged(evt: ref<VehicleRadioSongChanged>) -> Bool {
    if Equals(this.m_currentAnimation, n"OnVehicleEnter") {
      return true;
    };
    this.TryShowVehicleRadioNotification();
  }

  protected cb func OnIntroFinished(anim: ref<inkAnimProxy>) -> Bool {
    let options: inkAnimOptions;
    options.loopType = inkanimLoopType.PingPong;
    options.loopCounter = this.m_loopCounter;
    this.PlayAnimation(n"loop", options, n"OnTimeOut");
  }

  protected cb func OnEndLoop(anim: ref<inkAnimProxy>) -> Bool {
    this.UpdateDistanceLabel();
  }

  protected cb func OnTimeOut(anim: ref<inkAnimProxy>) -> Bool {
    this.Reset();
  }

  private final func Reset() -> Void {
    this.m_rootWidget.SetVisible(false);
    inkWidgetRef.SetVisible(this.m_radioStationName, false);
    inkWidgetRef.SetVisible(this.m_subText, false);
    inkWidgetRef.SetVisible(this.m_distanceLabel, false);
    this.StopAnimation(true);
  }

  private final func ShowVehicleSummonNotification() -> Void {
    let options: inkAnimOptions;
    if this.IsVehicleDataValid(true) {
      this.m_rootWidget.SetVisible(true);
      this.PlayAnimation(n"intro", new inkAnimOptions(), n"OnIntroFinished");
      this.UpdateDistanceLabel();
      options.loopType = inkanimLoopType.Cycle;
      options.loopCounter = this.m_loopCounter;
      this.m_animationCounterProxy = this.PlayLibraryAnimation(n"counter", options);
      this.m_animationCounterProxy.RegisterToCallback(inkanimEventType.OnEndLoop, this, n"OnEndLoop");
      GameInstance.GetAudioSystem(this.m_gameInstance).Play(n"ui_jingle_car_call");
    };
  }

  private final func ShowVehicleWaitingNotification() -> Void {
    if this.IsVehicleDataValid(false) {
      this.m_rootWidget.SetVisible(true);
      inkWidgetRef.SetVisible(this.m_subText, true);
      inkTextRef.SetText(this.m_subText, GetLocalizedText("LocKey#78044"));
      this.PlayAnimation(n"waiting", new inkAnimOptions(), n"OnTimeOut");
    };
  }

  private final func TryShowVehicleRadioNotification() -> Bool {
    let song: String;
    let station: String;
    if IsDefined(this.m_vehicle) && this.m_vehicle.IsRadioReceiverActive() {
      this.m_rootWidget.SetVisible(true);
      inkWidgetRef.SetVisible(this.m_radioStationName, true);
      inkWidgetRef.SetVisible(this.m_subText, true);
      station = GetLocalizedTextByKey(this.m_vehicle.GetRadioReceiverStationName());
      song = GetLocalizedTextByKey(this.m_vehicle.GetRadioReceiverTrackName());
      inkTextRef.SetText(this.m_radioStationName, station);
      inkTextRef.SetText(this.m_subText, song);
      this.PlayAnimation(n"OnSongChanged", new inkAnimOptions(), n"OnTimeOut");
      return true;
    };
    return false;
  }

  private final func IsVehicleDataValid(opt update: Bool) -> Bool {
    if IsDefined(this.m_vehicle) && !update {
      return true;
    };
    return this.TryUpdateActiveVehicleData(this.m_vehicleSummonDataBB.GetEntityID(GetAllBlackboardDefs().VehicleSummonData.SummonedVehicleEntityID));
  }

  private final func TryUpdateActiveVehicleData(id: EntityID) -> Bool {
    this.m_vehicle = GameInstance.FindEntityByID(this.m_player.GetGame(), id) as VehicleObject;
    if IsDefined(this.m_vehicle) {
      this.UpdateVehicleNotificationData(this.m_vehicle.GetRecordID());
      return true;
    };
    return false;
  }

  private final func UpdateVehicleNotificationData(id: TweakDBID) -> Void {
    let vehicleType: gamedataVehicleType;
    this.m_vehicleRecord = TweakDBInterface.GetVehicleRecord(id);
    if IsDefined(this.m_vehicleRecord) {
      vehicleType = this.m_vehicleRecord.Type().Type();
      if IsDefined(this.m_vehicleRecord.DisplayOverride()) {
        inkImageRef.SetTexturePart(this.m_vehicleTypeIcon, this.m_vehicleRecord.DisplayOverride().Icon());
      } else {
        if Equals(vehicleType, gamedataVehicleType.Bike) {
          inkImageRef.SetTexturePart(this.m_vehicleTypeIcon, n"motorcycle");
        } else {
          inkImageRef.SetTexturePart(this.m_vehicleTypeIcon, n"car");
        };
      };
      inkImageRef.SetTexturePart(this.m_vehicleManufactorIcon, TweakDBInterface.GetUIIconRecord(TDBID.Create("UIIcon." + this.m_vehicleRecord.Manufacturer().EnumName())).AtlasPartName());
      inkTextRef.SetLocalizedTextScript(this.m_vehicleNameLabel, this.m_vehicleRecord.DisplayName());
    };
  }

  private final func UpdateDistanceLabel() -> Void {
    let distance: Int32;
    let params: ref<inkTextParams>;
    if IsDefined(this.m_player) && IsDefined(this.m_vehicle) {
      distance = RoundF(Vector4.Distance(this.m_player.GetWorldPosition(), this.m_vehicle.GetWorldPosition()));
      params = new inkTextParams();
      params.AddMeasurement("distance", Cast<Float>(distance), EMeasurementUnit.Meter);
      params.AddString("unit", GetLocalizedText(NameToString(MeasurementUtils.GetUnitLocalizationKey(UILocalizationHelper.GetSystemBaseUnit()))));
      inkTextRef.SetText(this.m_distanceLabel, "{distance}{unit}", params);
      inkWidgetRef.SetVisible(this.m_distanceLabel, true);
    };
  }

  private final func PlayAnimation(animation: CName, opt options: inkAnimOptions, opt callback: CName) -> Void {
    this.StopAnimation(NotEquals(animation, n"loop"));
    this.m_animationProxy = this.PlayLibraryAnimation(animation, options);
    this.m_currentAnimation = animation;
    if NotEquals(callback, n"None") {
      this.m_animationProxy.RegisterToCallback(inkanimEventType.OnFinish, this, callback);
    };
  }

  private final func StopAnimation(isStoppingBothAnimations: Bool) -> Void {
    if IsDefined(this.m_animationProxy) && this.m_animationProxy.IsValid() {
      this.m_animationProxy.UnregisterFromAllCallbacks(inkanimEventType.OnFinish);
      this.m_animationProxy.GotoEndAndStop();
    };
    this.m_currentAnimation = n"None";
    if isStoppingBothAnimations {
      if IsDefined(this.m_animationCounterProxy) && this.m_animationCounterProxy.IsValid() {
        this.m_animationProxy.UnregisterFromAllCallbacks(inkanimEventType.OnEndLoop);
        this.m_animationCounterProxy.Stop();
      };
    };
  }
}
