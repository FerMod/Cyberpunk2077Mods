
public native class gameuiDriverCombatMountedPowerWeaponCrosshairGameController extends gameuiCrosshairBaseGameController {

  private edit let m_reticleLeft: inkWidgetRef;

  private edit let m_reticleRight: inkWidgetRef;

  @default(gameuiDriverCombatMountedPowerWeaponCrosshairGameController, 3.f)
  private edit let m_reticleStartingRange: Float;

  @default(gameuiDriverCombatMountedPowerWeaponCrosshairGameController, 1.0f)
  private edit let m_defaultOpacity: Float;

  @default(gameuiDriverCombatMountedPowerWeaponCrosshairGameController, 0.2f)
  private edit let m_reducedOpacity: Float;

  private let m_weaponList: [wref<WeaponObject>];

  private let m_isTPP: Bool;

  private let m_uiActiveVehicleDataBlackboard: wref<IBlackboard>;

  private let m_psmCombatStateChangedCallback: ref<CallbackHandle>;

  private let m_uiActiveVehicleCameraChangedCallback: ref<CallbackHandle>;

  protected cb func OnPlayerAttach(player: ref<GameObject>) -> Bool {
    super.OnPlayerAttach(player);
    this.m_uiActiveVehicleDataBlackboard = GameInstance.GetBlackboardSystem(player.GetGame()).Get(GetAllBlackboardDefs().UI_ActiveVehicleData);
    this.m_uiActiveVehicleCameraChangedCallback = this.m_uiActiveVehicleDataBlackboard.RegisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsTPPCameraOn, this, n"OnActiveVehicleCameraChanged", true);
    this.m_psmCombatStateChangedCallback = this.m_psmBlackboard.RegisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Combat, this, n"OnPSMCombatStateChanged", true);
  }

  protected cb func OnPlayerDetach(player: ref<GameObject>) -> Bool {
    super.OnPlayerDetach(player);
    if IsDefined(this.m_uiActiveVehicleCameraChangedCallback) {
      this.m_uiActiveVehicleDataBlackboard.UnregisterListenerBool(GetAllBlackboardDefs().UI_ActiveVehicleData.IsTPPCameraOn, this.m_uiActiveVehicleCameraChangedCallback);
    };
    if IsDefined(this.m_psmCombatStateChangedCallback) {
      this.m_psmBlackboard.UnregisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Combat, this.m_psmCombatStateChangedCallback);
    };
  }

  protected cb func OnActiveVehicleCameraChanged(isTPP: Bool) -> Bool {
    this.m_isTPP = isTPP;
    inkWidgetRef.SetVisible(this.m_reticleLeft, this.m_isTPP);
    inkWidgetRef.SetVisible(this.m_reticleRight, this.m_isTPP);
  }

  protected cb func OnPSMCombatStateChanged(value: Int32) -> Bool {
    let opacity: Float = value == 1 ? this.m_defaultOpacity : this.m_reducedOpacity;
    inkWidgetRef.SetOpacity(this.m_reticleLeft, opacity);
    inkWidgetRef.SetOpacity(this.m_reticleRight, opacity);
  }

  protected cb func OnPreIntro() -> Bool {
    ArrayClear(this.m_weaponList);
    this.TryGetWeaponObjectList();
    super.OnPreIntro();
  }

  protected final func UpdateTranslation(uiScreenResolution: Vector2) -> Void {
    let currentAngle: Float;
    let currentRelativeWorldPosition: Vector4;
    let i: Int32;
    let j: Int32;
    let minAngle: Float;
    let mountedWeaponTargetList: array<gameuiMountedWeaponTarget>;
    let mountedWeaponTargetRelativeWorldPosition: Vector4;
    let position: Vector2;
    let projection: Vector2;
    let ratio: Vector2;
    let reticle: inkWidgetRef;
    let scale: Vector2;
    let uiWidgetResolution: Vector2 = new Vector2(3840.00, 2160.00);
    if this.m_isTPP {
      mountedWeaponTargetList = FromVariant<array<gameuiMountedWeaponTarget>>(this.m_uiActiveVehicleDataBlackboard.GetVariant(GetAllBlackboardDefs().UI_ActiveVehicleData.MountedWeaponsTargets));
      if ArraySize(mountedWeaponTargetList) > 0 {
        ratio.X = uiWidgetResolution.X / uiScreenResolution.X;
        ratio.Y = uiWidgetResolution.Y / uiScreenResolution.Y;
        if ratio.X > ratio.Y {
          scale.X = 1.00;
          scale.Y = ratio.X / ratio.Y;
        } else {
          scale.X = ratio.Y / ratio.X;
          scale.Y = 1.00;
        };
        i = 0;
        while i < ArraySize(mountedWeaponTargetList) {
          reticle = mountedWeaponTargetList[i].weaponIndex == 0 ? this.m_reticleLeft : this.m_reticleRight;
          inkWidgetRef.SetVisible(reticle, false);
          if this.TryGetWeaponObjectList() {
            minAngle = 360.00;
            mountedWeaponTargetRelativeWorldPosition = new Vector4();
            j = 0;
            while j < ArraySize(this.m_weaponList) {
              currentRelativeWorldPosition = mountedWeaponTargetList[i].targetLocation - this.m_weaponList[j].GetWorldPosition();
              currentAngle = Vector4.GetAngleBetween(this.m_weaponList[j].GetWorldForward(), mountedWeaponTargetRelativeWorldPosition);
              if currentAngle < minAngle {
                minAngle = currentAngle;
                mountedWeaponTargetRelativeWorldPosition = currentRelativeWorldPosition;
              };
              j += 1;
            };
            if Vector4.Length(mountedWeaponTargetRelativeWorldPosition) >= this.m_reticleStartingRange {
              inkWidgetRef.SetVisible(reticle, true);
              projection = this.ProjectWorldToScreen(mountedWeaponTargetList[i].targetLocation);
              position.X = uiWidgetResolution.X * 0.50 * projection.X * scale.X;
              position.Y = uiWidgetResolution.Y * 0.50 * projection.Y * -1.00 * scale.Y;
              inkWidgetRef.SetTranslation(reticle, position);
            };
          };
          i += 1;
        };
      };
    };
  }

  public func GetIntroAnimation(firstEquip: Bool) -> ref<inkAnimProxy> {
    let anim: ref<inkAnimDef> = new inkAnimDef();
    let alphaInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    alphaInterpolator.SetStartTransparency(0.00);
    alphaInterpolator.SetEndTransparency(1.00);
    alphaInterpolator.SetDuration(0.25);
    alphaInterpolator.SetType(inkanimInterpolationType.Linear);
    alphaInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    anim.AddInterpolator(alphaInterpolator);
    return this.m_rootWidget.PlayAnimation(anim);
  }

  public func GetOutroAnimation() -> ref<inkAnimProxy> {
    let anim: ref<inkAnimDef> = new inkAnimDef();
    let alphaInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    alphaInterpolator.SetStartTransparency(1.00);
    alphaInterpolator.SetEndTransparency(0.00);
    alphaInterpolator.SetDuration(0.25);
    alphaInterpolator.SetType(inkanimInterpolationType.Linear);
    alphaInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    anim.AddInterpolator(alphaInterpolator);
    return this.m_rootWidget.PlayAnimation(anim);
  }

  protected func OnState_Aim() -> Void {
    this.m_rootWidget.SetVisible(true);
  }

  private final func TryGetWeaponObjectList() -> Bool {
    let vehicle: wref<VehicleObject>;
    if ArraySize(this.m_weaponList) > 0 {
      return true;
    };
    VehicleComponent.GetVehicle(this.m_playerPuppet.GetGame(), this.m_playerPuppet.GetEntityID(), vehicle);
    vehicle.GetActiveWeapons(this.m_weaponList);
    return ArraySize(this.m_weaponList) > 0;
  }
}
