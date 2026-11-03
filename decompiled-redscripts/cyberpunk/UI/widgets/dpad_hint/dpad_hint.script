
public class HotkeyRadioStatusListener extends ScriptStatusEffectListener {

  public let m_radioWidgetController: wref<HotkeyConsumableWidgetController>;

  public final func Init(radioWidgetController: wref<HotkeyConsumableWidgetController>) -> Void {
    this.m_radioWidgetController = radioWidgetController;
  }

  public func OnStatusEffectApplied(statusEffect: wref<StatusEffect_Record>) -> Void {
    this.m_radioWidgetController.RefreshStatusEffect();
  }

  public func OnStatusEffectRemoved(statusEffect: wref<StatusEffect_Record>) -> Void {
    this.m_radioWidgetController.RefreshStatusEffect();
  }
}

public class HotkeyCustomRadioWidgetController extends gameuiNewPhoneRelatedHUDGameController {

  private edit let m_radioSlot: inkCompoundRef;

  private edit let m_DpadHintLibraryPath: inkWidgetLibraryReference;

  protected cb func OnInitialize() -> Bool {
    this.SpawnFromExternal(inkWidgetRef.Get(this.m_radioSlot), inkWidgetLibraryResource.GetPath(this.m_DpadHintLibraryPath.widgetLibrary), n"radio");
  }
}

public class HotkeyConsumableWidgetController extends gameuiNewPhoneRelatedHUDGameController {

  private edit let m_radioSlot: inkCompoundRef;

  private edit let m_vehicleCustomizationSlot: inkCompoundRef;

  private edit let m_autodriveSlot: inkCompoundRef;

  private edit let m_container: inkCompoundRef;

  private edit let m_DpadHintLibraryPath: inkWidgetLibraryReference;

  private edit let m_autodriveLibraryPath: inkWidgetLibraryReference;

  private let m_IsInDriverCombat: Bool;

  private let m_IsPoliceVehicle: Bool;

  private let m_isRadioBlocked: Bool;

  private let m_isInVehicleScene: Bool;

  private let m_isQuestBlocked: Bool;

  private let m_carHudListenerId: Uint32;

  private let m_statusListener: ref<HotkeyRadioStatusListener>;

  private let m_PlayerEnteredVehicleListener: ref<CallbackHandle>;

  private let m_autodriveToggledListener: ref<CallbackHandle>;

  private let m_containerAnimProxy: ref<inkAnimProxy>;

  @default(HotkeyConsumableWidgetController, true)
  private let m_containerVisibility: Bool;

  protected cb func OnInitialize() -> Bool {
    this.SpawnFromExternal(inkWidgetRef.Get(this.m_radioSlot), inkWidgetLibraryResource.GetPath(this.m_DpadHintLibraryPath.widgetLibrary), n"radio");
    this.SpawnFromExternal(inkWidgetRef.Get(this.m_vehicleCustomizationSlot), inkWidgetLibraryResource.GetPath(this.m_DpadHintLibraryPath.widgetLibrary), n"vehicleVisualCustomization");
    this.SpawnFromExternal(inkWidgetRef.Get(this.m_autodriveSlot), inkWidgetLibraryResource.GetPath(this.m_autodriveLibraryPath.widgetLibrary), n"Root");
    this.SpawnFromExternal(inkWidgetRef.Get(this.m_container), inkWidgetLibraryResource.GetPath(this.m_DpadHintLibraryPath.widgetLibrary), n"consumable");
    this.SpawnFromExternal(inkWidgetRef.Get(this.m_container), inkWidgetLibraryResource.GetPath(this.m_DpadHintLibraryPath.widgetLibrary), n"gadgetVehicle");
    this.SpawnFromExternal(inkWidgetRef.Get(this.m_container), inkWidgetLibraryResource.GetPath(this.m_DpadHintLibraryPath.widgetLibrary), n"cyberware");
  }

  protected cb func OnPlayerAttach(player: ref<GameObject>) -> Bool {
    super.OnPlayerAttach(player);
    this.SetContainerVisibility(true, true);
    this.RegisterFactVisibilityListeners();
    this.RegisterCarHudListener();
    this.RegisterStatusEffectListeners();
    this.RegisterBlackboardListeners();
    this.RefreshInPoliceVehicle();
    this.RefreshStatusEffect();
    this.RefreshUnlockCarHud();
    this.UpdateVisibility();
  }

  protected cb func OnPlayerDetach(player: ref<GameObject>) -> Bool {
    this.UnregisterBlackboardListeners();
    this.UnregisterCarHudListener();
    this.UnregisterFactVisibilityListeners();
    this.m_statusListener = null;
  }

  private final func RegisterBlackboardListeners() -> Void {
    let psmBB: ref<IBlackboard> = this.GetPSMBlackboard(this.m_player);
    let autodriveBB: ref<IBlackboard> = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_AutodriveData);
    this.m_PlayerEnteredVehicleListener = psmBB.RegisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Vehicle, this, n"OnPlayerEnteredVehicle", true);
    this.m_autodriveToggledListener = autodriveBB.RegisterDelayedListenerBool(GetAllBlackboardDefs().UI_AutodriveData.AutoDriveEnabled, this, n"OnAutodriveToggled");
    this.SetContainerVisibility(!autodriveBB.GetBool(GetAllBlackboardDefs().UI_AutodriveData.AutoDriveEnabled), true);
  }

  private final func RegisterCarHudListener() -> Void {
    this.m_carHudListenerId = GameInstance.GetQuestsSystem(this.m_player.GetGame()).RegisterListener(n"unlock_car_hud_dpad", this, n"OnUnlockCarHud");
  }

  protected cb func OnUnlockCarHud(value: Int32) -> Bool {
    this.RefreshUnlockCarHud();
  }

  protected cb func OnPlayerEnteredVehicle(val: Int32) -> Bool {
    this.RefreshInPoliceVehicle();
  }

  protected cb func OnAutodriveToggled(value: Bool) -> Bool {
    this.SetContainerVisibility(!value, false);
  }

  private final func SetContainerVisibility(visible: Bool, instant: Bool) -> Void {
    let params: inkAnimOptions;
    let progress: Float;
    if Equals(visible, this.m_containerVisibility) {
      return;
    };
    this.m_containerVisibility = visible;
    if instant {
      inkWidgetRef.SetVisible(this.m_container, visible);
      return;
    };
    inkWidgetRef.SetVisible(this.m_container, true);
    params.dependsOnTimeDilation = false;
    if this.m_containerAnimProxy.IsValid() && this.m_containerAnimProxy.IsPlaying() {
      progress = 1.00 - this.m_containerAnimProxy.GetProgression();
      this.m_containerAnimProxy.Stop();
    };
    this.m_containerAnimProxy = this.PlayLibraryAnimation(visible ? n"showContainer" : n"hideContainer", params);
    this.m_containerAnimProxy.SetNormalizedPosition(progress, true);
  }

  private final func RefreshInPoliceVehicle() -> Void {
    this.m_IsPoliceVehicle = this.m_player.IsInPoliceVehicle();
    this.UpdateBlackboard();
  }

  public final func RefreshUnlockCarHud() -> Void {
    this.m_isQuestBlocked = GameInstance.GetQuestsSystem(this.m_player.GetGame()).GetFact(n"unlock_car_hud_dpad") == 0;
    this.UpdateBlackboard();
    this.UpdateVisibility();
    this.ResolveRadioState();
  }

  private final func RegisterStatusEffectListeners() -> Void {
    this.m_statusListener = new HotkeyRadioStatusListener();
    this.m_statusListener.Init(this);
    GameInstance.GetStatusEffectSystem(this.m_player.GetGame()).RegisterListener(this.m_player.GetEntityID(), this.m_statusListener);
  }

  private final func UnregisterCarHudListener() -> Void {
    GameInstance.GetQuestsSystem(this.m_player.GetGame()).UnregisterListener(n"unlock_car_hud_dpad", this.m_carHudListenerId);
  }

  private final func UnregisterBlackboardListeners() -> Void {
    let psmBB: wref<IBlackboard>;
    if IsDefined(this.m_PlayerEnteredVehicleListener) {
      psmBB = this.GetPSMBlackboard(this.m_player);
      psmBB.UnregisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Vehicle, this.m_PlayerEnteredVehicleListener);
    };
    if IsDefined(this.m_autodriveToggledListener) {
      this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_AutodriveData).UnregisterListenerBool(GetAllBlackboardDefs().UI_AutodriveData.AutoDriveEnabled, this.m_autodriveToggledListener);
    };
  }

  public final func RefreshStatusEffect() -> Void {
    this.m_IsInDriverCombat = StatusEffectSystem.ObjectHasStatusEffect(this.m_player, t"BaseStatusEffect.DriverCombat");
    this.m_isRadioBlocked = StatusEffectSystem.ObjectHasStatusEffectWithTag(this.m_player, n"VehicleBlockRadioInput");
    this.m_isInVehicleScene = StatusEffectSystem.ObjectHasStatusEffectWithTag(this.m_player, n"VehicleScene");
    this.UpdateBlackboard();
    this.UpdateRadioVisibility();
    this.UpdateVisibility();
    this.ResolveRadioState();
  }

  private final func UpdateRadioVisibility() -> Void {
    inkWidgetRef.SetVisible(this.m_radioSlot, !this.m_IsInDriverCombat);
  }

  protected final func ResolveRadioState() -> Void {
    if this.IsRadioEnabled() {
      inkWidgetRef.SetState(this.m_radioSlot, n"Default");
    } else {
      inkWidgetRef.SetState(this.m_radioSlot, n"Unavailable");
    };
  }

  private final func IsRadioEnabled() -> Bool {
    return !this.m_IsInDriverCombat && !this.m_IsPoliceVehicle && !this.m_isRadioBlocked && !this.m_isInVehicleScene && !this.m_isQuestBlocked;
  }

  private final func UpdateBlackboard() -> Void {
    this.GetUIBlackboard().SetBool(GetAllBlackboardDefs().UIGameData.Popup_Radio_Enabled, this.IsRadioEnabled());
  }
}

public class HotkeysWidgetController extends gameuiNewPhoneRelatedHUDGameController {

  private edit let m_phoneSlot: inkCompoundRef;

  private edit let m_carSlot: inkCompoundRef;

  private edit let m_radioSlot: inkCompoundRef;

  private edit let m_dpadHintsPanel: inkCompoundRef;

  private edit let m_phone: wref<inkWidget>;

  private edit let m_car: wref<inkWidget>;

  private edit let m_radio: wref<inkWidget>;

  private edit let m_consumables: wref<inkWidget>;

  private edit let m_gadgets: wref<inkWidget>;

  private edit let m_cyberware: wref<inkWidget>;

  private edit let m_leeroy: wref<inkWidget>;

  private edit let m_timeBank: wref<inkWidget>;

  private let m_berserkEnabledBBId: ref<CallbackHandle>;

  protected cb func OnInitialize() -> Bool {
    if this.isNewPhoneEnabled {
      this.m_car = this.SpawnFromLocal(inkWidgetRef.Get(this.m_carSlot), n"vehicle");
      this.m_radio = this.SpawnFromLocal(inkWidgetRef.Get(this.m_radioSlot), n"radio");
      this.m_consumables = this.SpawnFromLocal(inkWidgetRef.Get(this.m_dpadHintsPanel), n"consumable");
      this.m_gadgets = this.SpawnFromLocal(inkWidgetRef.Get(this.m_dpadHintsPanel), n"gadget");
    } else {
      this.m_phone = this.SpawnFromLocal(inkWidgetRef.Get(this.m_phoneSlot), n"DPAD_DOWN");
      this.m_car = this.SpawnFromLocal(inkWidgetRef.Get(this.m_carSlot), n"DPAD_RIGHT");
      this.m_consumables = this.SpawnFromLocal(inkWidgetRef.Get(this.m_dpadHintsPanel), n"DPAD_UP");
      this.m_gadgets = this.SpawnFromLocal(inkWidgetRef.Get(this.m_dpadHintsPanel), n"RB");
    };
    this.m_cyberware = this.SpawnFromLocal(inkWidgetRef.Get(this.m_dpadHintsPanel), n"cyberware");
    this.m_leeroy = this.SpawnFromLocal(inkWidgetRef.Get(this.m_dpadHintsPanel), n"leeroy");
    this.m_timeBank = this.SpawnFromLocal(inkWidgetRef.Get(this.m_dpadHintsPanel), n"timeBank");
    this.m_consumables.SetName(n"consumable");
    this.m_gadgets.SetName(n"gadget");
    this.m_cyberware.SetName(n"cyberware");
    this.m_leeroy.SetName(n"leeroy");
    this.m_timeBank.SetName(n"timeBank");
  }

  protected cb func OnPlayerAttach(player: ref<GameObject>) -> Bool {
    super.OnPlayerAttach(player);
    this.RegisterFactVisibilityListeners();
    this.RegisterBlackboardListeners();
    this.UpdateVisibility();
    this.HandleBerserkActive(StatusEffectSystem.ObjectHasStatusEffectWithTag(this.m_player, n"BerserkBuff"));
  }

  protected cb func OnPlayerDetach(player: ref<GameObject>) -> Bool {
    this.UnregisterFactVisibilityListeners();
    this.UnregisterBlackboardListeners();
  }

  private final func RegisterBlackboardListeners() -> Void {
    let blackboardSystem: ref<BlackboardSystem> = this.GetBlackboardSystem();
    let uiGameBlackboard: wref<IBlackboard> = blackboardSystem.Get(GetAllBlackboardDefs().UIGameData);
    this.m_berserkEnabledBBId = uiGameBlackboard.RegisterDelayedListenerBool(GetAllBlackboardDefs().UIGameData.BerserkActive, this, n"OnBerserkActive");
    this.RegisterCommonBlackboardListeners();
  }

  private final func UnregisterBlackboardListeners() -> Void {
    let blackboardSystem: ref<BlackboardSystem> = this.GetBlackboardSystem();
    let uiGameBlackboard: wref<IBlackboard> = blackboardSystem.Get(GetAllBlackboardDefs().UIGameData);
    if IsDefined(this.m_berserkEnabledBBId) {
      uiGameBlackboard.UnregisterListenerBool(GetAllBlackboardDefs().UIGameData.BerserkActive, this.m_berserkEnabledBBId);
    };
    this.UnregisterCommonBlackboardListeners();
  }

  protected func IsDerivedHUDVisible() -> Bool {
    return !this.m_isRemoteControllingVehicle || this.CanUseOverclock();
  }

  protected cb func OnBerserkActive(value: Bool) -> Bool {
    this.HandleBerserkActive(value);
  }

  private final func HandleBerserkActive(isBerserkActive: Bool) -> Void {
    if isBerserkActive {
      this.m_car.SetVisible(false);
      this.m_radio.SetVisible(false);
      this.m_consumables.SetVisible(false);
      this.m_gadgets.SetVisible(false);
    } else {
      this.m_car.SetVisible(true);
      this.m_radio.SetVisible(true);
      this.SendBlackboardHotkeyUpdates();
    };
  }

  private final func SendBlackboardHotkeyUpdates() -> Void {
    let uiHotkeyBlackboard: wref<IBlackboard> = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_Hotkeys);
    if IsDefined(uiHotkeyBlackboard) {
      uiHotkeyBlackboard.SetVariant(GetAllBlackboardDefs().UI_Hotkeys.ModifiedHotkey, ToVariant(EHotkey.DPAD_UP), true);
      uiHotkeyBlackboard.SetVariant(GetAllBlackboardDefs().UI_Hotkeys.ModifiedHotkey, ToVariant(EHotkey.RB), true);
    };
  }
}
