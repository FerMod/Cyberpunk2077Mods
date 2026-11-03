
public class vehicleColorInkController extends inkHUDGameController {

  private let m_vehicle: wref<VehicleObject>;

  private let m_vehicleBlackboard: wref<IBlackboard>;

  private let m_vehiclePS: wref<VehicleComponentPS>;

  private let m_root: wref<inkWidget>;

  private let m_AnimProxy: ref<inkAnimProxy>;

  private let m_GlitchAnimProxy: ref<inkAnimProxy>;

  private let m_SpoilerAnimProxy: ref<inkAnimProxy>;

  private edit let m_primaryColorPane: inkWidgetRef;

  private edit let m_secondaryColorPane: inkWidgetRef;

  private edit const let m_primaryColor: [inkImageRef];

  private edit const let m_secondaryColor: [inkImageRef];

  private edit let m_carPartType: VehicleVisualCustomizationWidgetCarPart;

  private let m_colorModDefinition: ref<CallbackHandle>;

  private let m_cachedPrimaryColor: Color;

  private let m_cachedSecondaryColor: Color;

  private let m_colorSecondaryCodeListener: ref<CallbackHandle>;

  private let m_vehicleCollisionListener: ref<CallbackHandle>;

  private let m_vehicleDamageListener: ref<CallbackHandle>;

  private let m_vehicleModBlockedByDamageListener: ref<CallbackHandle>;

  private let m_vehicleModActiveListener: ref<CallbackHandle>;

  private let m_vehicleTPPCallbackID: ref<CallbackHandle>;

  private let m_vehicleSpeedListener: ref<CallbackHandle>;

  private let m_cachedTemplate: VehicleVisualCustomizationTemplate;

  private let m_moddingBlockedByDamage: Bool;

  private let m_visualCustomizationActive: Bool;

  private let m_spoilerDeployed: Bool;

  private let m_cachedTppView: Bool;

  private let m_fakeUpdateProxy: ref<inkAnimProxy>;

  private let m_damageAnimLoopProxy: ref<inkAnimProxy>;

  protected cb func OnInitialize() -> Bool {
    let activeVehicleUIBlackboard: wref<IBlackboard>;
    let bbSys: ref<BlackboardSystem>;
    this.m_root = this.GetRootWidget();
    this.m_vehicle = this.GetOwnerEntity() as VehicleObject;
    this.m_vehiclePS = this.m_vehicle.GetVehiclePS();
    this.m_vehicleBlackboard = this.m_vehicle.GetBlackboard();
    this.m_visualCustomizationActive = this.m_vehiclePS.GetIsVehicleVisualCustomizationActive();
    this.m_moddingBlockedByDamage = this.m_vehiclePS.GetIsVehicleVisualCustomizationBlockedByDamage();
    if this.m_visualCustomizationActive && this.m_vehicle.IsPlayerMounted() {
      this.RestoreVisualCustomization();
    };
    if !IsDefined(this.m_vehicleCollisionListener) {
      this.m_vehicleCollisionListener = this.m_vehicleBlackboard.RegisterListenerBool(GetAllBlackboardDefs().Vehicle.Collision, this, n"OnVehicleCollision");
    };
    if !IsDefined(this.m_vehicleModBlockedByDamageListener) {
      this.m_vehicleModBlockedByDamageListener = this.m_vehicleBlackboard.RegisterListenerBool(GetAllBlackboardDefs().Vehicle.VehicleCustomizationBlockedByDamage, this, n"OnVehicleCustomizationBlockedByDamage");
    };
    if !IsDefined(this.m_vehicleModActiveListener) {
      this.m_vehicleModActiveListener = this.m_vehicleBlackboard.RegisterListenerBool(GetAllBlackboardDefs().Vehicle.VehicleCustomizationActive, this, n"OnVehicleVisualCustomizationActive");
    };
    if !IsDefined(this.m_vehicleTPPCallbackID) {
      bbSys = GameInstance.GetBlackboardSystem(this.m_vehicle.GetGame());
      activeVehicleUIBlackboard = bbSys.Get(GetAllBlackboardDefs().UI_ActiveVehicleData);
      this.m_vehicleTPPCallbackID = activeVehicleUIBlackboard.RegisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsTPPCameraOn, this, n"OnVehicleCameraChange");
    };
    if !IsDefined(this.m_vehicleSpeedListener) {
      this.m_vehicleSpeedListener = this.m_vehicleBlackboard.RegisterListenerFloat(GetAllBlackboardDefs().Vehicle.SpeedValue, this, n"OnVehicleSpeedChange");
    };
  }

  protected cb func OnUninitialize() -> Bool {
    let activeVehicleUIBlackboard: wref<IBlackboard>;
    let bbSys: ref<BlackboardSystem>;
    this.m_vehicleBlackboard.UnregisterListenerInt(GetAllBlackboardDefs().Vehicle.DamageState, this.m_vehicleDamageListener);
    this.m_vehicleBlackboard.UnregisterListenerInt(GetAllBlackboardDefs().Vehicle.DamageState, this.m_vehicleCollisionListener);
    this.m_vehicleBlackboard.UnregisterListenerBool(GetAllBlackboardDefs().Vehicle.VehicleCustomizationBlockedByDamage, this.m_vehicleModBlockedByDamageListener);
    this.m_vehicleBlackboard.UnregisterListenerBool(GetAllBlackboardDefs().Vehicle.VehicleCustomizationActive, this.m_vehicleModActiveListener);
    this.m_vehicleBlackboard.UnregisterListenerFloat(GetAllBlackboardDefs().Vehicle.SpeedValue, this.m_vehicleSpeedListener);
    bbSys = GameInstance.GetBlackboardSystem(this.m_vehicle.GetGame());
    activeVehicleUIBlackboard = bbSys.Get(GetAllBlackboardDefs().UI_ActiveVehicleData);
    activeVehicleUIBlackboard.UnregisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsTPPCameraOn, this.m_vehicleTPPCallbackID);
    this.m_damageAnimLoopProxy.Stop();
  }

  protected cb func OnVehicleVisualCustomizationActive(value: Bool) -> Bool {
    let isRequestInstant: Bool = this.m_vehicleBlackboard.GetBool(GetAllBlackboardDefs().Vehicle.VehicleCustomizationInstant);
    this.m_visualCustomizationActive = value;
    this.m_cachedTemplate = this.m_vehiclePS.GetVehicleVisualCustomizationTemplate();
    if value {
      if !isRequestInstant {
        this.ProcessColorsUpdates();
      } else {
        this.RestoreVisualCustomization();
      };
    } else {
      if !this.m_moddingBlockedByDamage {
        this.PlayLibraryAnimation(n"Reset");
      };
    };
  }

  private final func RestoreVisualCustomization() -> Void {
    let isRequestInstant: Bool = this.m_vehicleBlackboard.GetBool(GetAllBlackboardDefs().Vehicle.VehicleCustomizationInstant);
    this.m_cachedTemplate = this.m_vehiclePS.GetVehicleVisualCustomizationTemplate();
    if this.m_vehiclePS.GetIsVehicleVisualCustomizationBlockedByDamage() {
      return;
    };
    this.m_cachedPrimaryColor = GenericTemplatePersistentData.GetPrimaryColor(this.m_cachedTemplate.genericData);
    this.m_cachedSecondaryColor = GenericTemplatePersistentData.GetSecondaryColor(this.m_cachedTemplate.genericData);
    if !isRequestInstant {
      this.ProcessColorsUpdates();
    } else {
      this.ApplyColors(false);
    };
  }

  private final func ProcessColorsUpdates() -> Void {
    if Equals(this.m_moddingBlockedByDamage, true) {
      return;
    };
    this.m_cachedPrimaryColor = GenericTemplatePersistentData.GetPrimaryColor(this.m_cachedTemplate.genericData);
    this.m_cachedSecondaryColor = GenericTemplatePersistentData.GetSecondaryColor(this.m_cachedTemplate.genericData);
    this.ApplyColors(false);
  }

  private final func HandleGlitch(opt val: Int32) -> Void {
    if Equals(this.m_moddingBlockedByDamage, true) {
      return;
    };
    if this.m_GlitchAnimProxy.IsPlaying() {
      this.m_GlitchAnimProxy.Stop(true);
    };
    this.m_GlitchAnimProxy = this.PlayLibraryAnimation(n"Glitch");
  }

  protected cb func OnVehicleDamageState(val: Int32) -> Bool {
    this.HandleGlitch();
  }

  protected cb func OnVehicleCollision(val: Bool) -> Bool {
    this.HandleGlitch();
  }

  protected cb func OnVehicleCustomizationBlockedByDamage(val: Bool) -> Bool {
    let animOptions: inkAnimOptions;
    if val {
      if !this.m_moddingBlockedByDamage {
        this.m_damageAnimLoopProxy = this.PlayLibraryAnimation(n"DamageDisable", animOptions);
        this.m_moddingBlockedByDamage = true;
        animOptions.loopType = inkanimLoopType.Cycle;
        animOptions.loopInfinite = false;
        animOptions.loopCounter = 1u;
      };
    };
  }

  private final func ApplyColors(opt instant: Bool) -> Void {
    let animExecutionDelay: Float;
    let animOptions: inkAnimOptions;
    let i: Int32;
    let j: Int32;
    while i < ArraySize(this.m_primaryColor) {
      inkWidgetRef.SetTintColor(this.m_primaryColor[i], this.m_cachedPrimaryColor);
      i += 1;
    };
    while j < ArraySize(this.m_secondaryColor) {
      inkWidgetRef.SetTintColor(this.m_secondaryColor[j], this.m_cachedSecondaryColor);
      j += 1;
    };
    if !instant {
      animExecutionDelay = this.m_vehicleBlackboard.GetFloat(GetAllBlackboardDefs().Vehicle.VehicleCustomizationWidgetDelay);
      if animExecutionDelay > 0.60 {
        animExecutionDelay = 0.00;
      };
      animOptions.executionDelay = animExecutionDelay;
      this.m_AnimProxy = this.PlayLibraryAnimation(n"SwitchColor", animOptions);
      this.m_vehicleBlackboard.SetFloat(GetAllBlackboardDefs().Vehicle.VehicleCustomizationWidgetDelay, animExecutionDelay + 0.15);
    };
  }

  protected cb func OnVehicleCameraChange(tppCamera: Bool) -> Bool {
    if NotEquals(tppCamera, this.m_cachedTppView) {
      this.m_cachedTppView = tppCamera;
      this.ApplyColors(true);
    };
  }

  protected cb func OnSpolierAnimationEnd(proxy: ref<inkAnimProxy>) -> Bool {
    this.m_SpoilerAnimProxy.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnSpolierAnimationEnd");
    this.ApplyColors(true);
    this.GetRootWidget().SetVisible(false);
  }

  protected cb func OnVehicleSpeedChange(speed: Float) -> Bool {
    switch this.m_carPartType {
      case VehicleVisualCustomizationWidgetCarPart.SpoilerHidden:
        if speed > 20.00 && !this.m_spoilerDeployed {
          this.ApplyColors(true);
          this.GetRootWidget().SetVisible(true);
          this.m_spoilerDeployed = true;
          return true;
        };
        if speed < 15.00 && this.m_spoilerDeployed {
          this.m_spoilerDeployed = false;
          this.m_SpoilerAnimProxy = this.PlayLibraryAnimation(n"SpoilerDelay");
          this.m_SpoilerAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnSpolierAnimationEnd");
          return true;
        };
        if speed == 0.00 && !this.m_spoilerDeployed {
          this.GetRootWidget().SetVisible(false);
          this.m_spoilerDeployed = false;
          this.ApplyColors(true);
          return true;
        };
    };
  }
}
