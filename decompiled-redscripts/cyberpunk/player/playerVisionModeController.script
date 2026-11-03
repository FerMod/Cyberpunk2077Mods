
public class PlayerVisionModeController extends IScriptable {

  private let m_gameplayActiveFlagsRefreshPolicy: PlayerVisionModeControllerRefreshPolicy;

  private let m_blackboardIds: PlayerVisionModeControllerBBIds;

  private let m_blackboardValuesIds: PlayerVisionModeControllerBBValuesIds;

  private let m_blackboardListenersFunctions: PlayerVisionModeControllerBlackboardListenersFunctions;

  private let m_blackboardListeners: PlayerVisionModeControllerBBListeners;

  private let m_gameplayActiveFlags: PlayerVisionModeControllerActiveFlags;

  private let m_inputActionsNames: PlayerVisionModeControllerInputActionsNames;

  private let m_inputListeners: PlayerVisionModeControllerInputListeners;

  private let m_inputActiveFlags: PlayerVisionModeControllerInputActiveFlags;

  private let m_otherVars: PlayerVisionModeControllerOtherVars;

  private let m_owner: wref<GameObject>;

  public final func OnEnablePhotoMode(enable: Bool) -> Void {
    this.m_gameplayActiveFlags.m_isPhotoMode = !enable;
  }

  public final func RegisterOwner(owner: ref<GameObject>) -> Void {
    if this.m_owner != null {
      this.UnregisterBlackboardListeners();
    };
    this.m_owner = owner;
    if owner != null {
      this.InitInputActionsNames();
      this.RegisterInputListeners();
      this.InitPlayerVisionModeControllerRefreshPolicy();
      this.InitBlackboardIds();
      this.InitBlackboardValuesIds();
      this.InitBlackboardFunctions();
      this.RegisterBlackboardListeners();
      this.UpdateNoScanningRestriction();
      this.UpdateBlackboardValues();
    };
  }

  public final func UnregisterOwner() -> Void {
    if this.m_owner == null {
    } else {
      this.UnregisterInputListeners();
      this.UnregisterBlackboardListeners();
    };
    this.m_owner = null;
  }

  public final func OnInvalidateActiveState(evt: ref<PlayerVisionModeControllerInvalidateEvent>) -> Void {
    if NotEquals(this.m_otherVars.m_active, evt.m_active) {
      this.m_otherVars.m_active = evt.m_active;
      if evt.m_active {
        this.ActivateVisionMode();
      } else {
        this.DeactivateVisionMode();
      };
    };
    this.ProcessFlagsRefreshPolicy();
  }

  private final func InitInputActionsNames() -> Void {
    this.m_inputActionsNames.m_buttonHold = n"VisionHold";
    this.m_inputActionsNames.m_buttonToggle = n"VisionToggle";
    this.m_inputActionsNames.m_driverCombatButtonHold = n"DriverCombatVisionHold";
    this.m_inputActionsNames.m_driverCombatButtonActivate = n"DriverCombatControllerActivateVisionHold";
  }

  private final func RegisterInputListeners() -> Void {
    this.m_owner.RegisterInputListener(this, n"VisionHold");
    this.m_owner.RegisterInputListener(this, n"VisionToggle");
    this.m_owner.RegisterInputListener(this, n"DriverCombatVisionHold");
    this.m_owner.RegisterInputListener(this, n"DriverCombatControllerActivateVisionHold");
  }

  private final func InitPlayerVisionModeControllerRefreshPolicy() -> Void {
    this.m_gameplayActiveFlagsRefreshPolicy.m_kerenzikov = PlayerVisionModeControllerRefreshPolicyEnum.Persistent;
    this.m_gameplayActiveFlagsRefreshPolicy.m_restrictedScene = PlayerVisionModeControllerRefreshPolicyEnum.Persistent;
    this.m_gameplayActiveFlagsRefreshPolicy.m_dead = PlayerVisionModeControllerRefreshPolicyEnum.Persistent;
    this.m_gameplayActiveFlagsRefreshPolicy.m_takedown = PlayerVisionModeControllerRefreshPolicyEnum.Persistent;
    this.m_gameplayActiveFlagsRefreshPolicy.m_deviceTakeover = PlayerVisionModeControllerRefreshPolicyEnum.Eventful;
    this.m_gameplayActiveFlagsRefreshPolicy.m_braindanceFPP = PlayerVisionModeControllerRefreshPolicyEnum.Persistent;
    this.m_gameplayActiveFlagsRefreshPolicy.m_braindanceActive = PlayerVisionModeControllerRefreshPolicyEnum.Persistent;
    this.m_gameplayActiveFlagsRefreshPolicy.m_veryHardLanding = PlayerVisionModeControllerRefreshPolicyEnum.Persistent;
    this.m_gameplayActiveFlagsRefreshPolicy.m_noScanningRestriction = PlayerVisionModeControllerRefreshPolicyEnum.Persistent;
    this.m_gameplayActiveFlagsRefreshPolicy.m_isBriefingActive = PlayerVisionModeControllerRefreshPolicyEnum.Persistent;
    this.m_gameplayActiveFlagsRefreshPolicy.m_twintoneOverrideShown = PlayerVisionModeControllerRefreshPolicyEnum.Persistent;
  }

  private final func InitBlackboardIds() -> Void {
    this.m_blackboardIds.m_kerenzikov = GetAllBlackboardDefs().PlayerStateMachine;
    this.m_blackboardIds.m_restrictedScene = GetAllBlackboardDefs().PlayerStateMachine;
    this.m_blackboardIds.m_dead = GetAllBlackboardDefs().PlayerStateMachine;
    this.m_blackboardIds.m_takedown = GetAllBlackboardDefs().PlayerStateMachine;
    this.m_blackboardIds.m_deviceTakeover = GetAllBlackboardDefs().DeviceTakeControl;
    this.m_blackboardIds.m_braindanceFPP = GetAllBlackboardDefs().Braindance;
    this.m_blackboardIds.m_braindanceActive = GetAllBlackboardDefs().Braindance;
    this.m_blackboardIds.m_veryHardLanding = GetAllBlackboardDefs().PlayerStateMachine;
    this.m_blackboardIds.m_isBriefingActive = GetAllBlackboardDefs().UIGameData;
    this.m_blackboardIds.m_twintoneOverrideShown = GetAllBlackboardDefs().UIGameData;
  }

  private final func InitBlackboardValuesIds() -> Void {
    this.m_blackboardValuesIds.m_kerenzikov = GetAllBlackboardDefs().PlayerStateMachine.Locomotion;
    this.m_blackboardValuesIds.m_restrictedScene = GetAllBlackboardDefs().PlayerStateMachine.HighLevel;
    this.m_blackboardValuesIds.m_dead = GetAllBlackboardDefs().PlayerStateMachine.Vitals;
    this.m_blackboardValuesIds.m_takedown = GetAllBlackboardDefs().PlayerStateMachine.Takedown;
    this.m_blackboardValuesIds.m_deviceTakeover = GetAllBlackboardDefs().DeviceTakeControl.ActiveDevice;
    this.m_blackboardValuesIds.m_braindanceFPP = GetAllBlackboardDefs().Braindance.IsFPP;
    this.m_blackboardValuesIds.m_braindanceActive = GetAllBlackboardDefs().Braindance.IsActive;
    this.m_blackboardValuesIds.m_veryHardLanding = GetAllBlackboardDefs().PlayerStateMachine.Landing;
    this.m_blackboardValuesIds.m_isBriefingActive = GetAllBlackboardDefs().UIGameData.IsBriefingActive;
    this.m_blackboardValuesIds.m_twintoneOverrideShown = GetAllBlackboardDefs().UIGameData.Popup_TwintoneOverride_IsShown;
  }

  private final func InitBlackboardFunctions() -> Void {
    this.m_blackboardListenersFunctions.m_kerenzikov = n"OnKerenzikovChanged";
    this.m_blackboardListenersFunctions.m_restrictedScene = n"OnRestrictedSceneChanged";
    this.m_blackboardListenersFunctions.m_dead = n"OnDeadChanged";
    this.m_blackboardListenersFunctions.m_takedown = n"OnTakedownChanged";
    this.m_blackboardListenersFunctions.m_deviceTakeover = n"OnDeviceTakeoverChanged";
    this.m_blackboardListenersFunctions.m_braindanceFPP = n"OnBraindanceFPPChanged";
    this.m_blackboardListenersFunctions.m_braindanceActive = n"OnBraindanceActiveChanged";
    this.m_blackboardListenersFunctions.m_veryHardLanding = n"OnVeryHardLandingChanged";
    this.m_blackboardListenersFunctions.m_isBriefingActive = n"OnBriefingChange";
    this.m_blackboardListenersFunctions.m_twintoneOverrideShown = n"OnTwintoneChange";
  }

  private final func RegisterBlackboardListeners() -> Void {
    let blackboardSystem: ref<BlackboardSystem>;
    if this.m_owner != null {
      blackboardSystem = GameInstance.GetBlackboardSystem(this.m_owner.GetGame());
    };
    if blackboardSystem != null {
      this.m_blackboardListeners.m_kerenzikov = blackboardSystem.GetLocalInstanced(this.m_owner.GetEntityID(), this.m_blackboardIds.m_kerenzikov).RegisterListenerInt(this.m_blackboardValuesIds.m_kerenzikov, this, this.m_blackboardListenersFunctions.m_kerenzikov);
      this.m_blackboardListeners.m_restrictedScene = blackboardSystem.GetLocalInstanced(this.m_owner.GetEntityID(), this.m_blackboardIds.m_restrictedScene).RegisterListenerInt(this.m_blackboardValuesIds.m_restrictedScene, this, this.m_blackboardListenersFunctions.m_restrictedScene);
      this.m_blackboardListeners.m_dead = blackboardSystem.GetLocalInstanced(this.m_owner.GetEntityID(), this.m_blackboardIds.m_dead).RegisterListenerInt(this.m_blackboardValuesIds.m_dead, this, this.m_blackboardListenersFunctions.m_dead);
      this.m_blackboardListeners.m_takedown = blackboardSystem.GetLocalInstanced(this.m_owner.GetEntityID(), this.m_blackboardIds.m_takedown).RegisterListenerInt(this.m_blackboardValuesIds.m_takedown, this, this.m_blackboardListenersFunctions.m_takedown);
      this.m_blackboardListeners.m_deviceTakeover = blackboardSystem.Get(this.m_blackboardIds.m_deviceTakeover).RegisterListenerEntityID(this.m_blackboardValuesIds.m_deviceTakeover, this, this.m_blackboardListenersFunctions.m_deviceTakeover);
      this.m_blackboardListeners.m_braindanceFPP = blackboardSystem.Get(this.m_blackboardIds.m_braindanceFPP).RegisterListenerBool(this.m_blackboardValuesIds.m_braindanceFPP, this, this.m_blackboardListenersFunctions.m_braindanceFPP);
      this.m_blackboardListeners.m_braindanceActive = blackboardSystem.Get(this.m_blackboardIds.m_braindanceActive).RegisterListenerBool(this.m_blackboardValuesIds.m_braindanceActive, this, this.m_blackboardListenersFunctions.m_braindanceActive);
      this.m_blackboardListeners.m_veryHardLanding = blackboardSystem.GetLocalInstanced(this.m_owner.GetEntityID(), this.m_blackboardIds.m_veryHardLanding).RegisterListenerInt(this.m_blackboardValuesIds.m_veryHardLanding, this, this.m_blackboardListenersFunctions.m_veryHardLanding);
      this.m_blackboardListeners.m_isBriefingActive = blackboardSystem.Get(this.m_blackboardIds.m_isBriefingActive).RegisterListenerBool(this.m_blackboardValuesIds.m_isBriefingActive, this, this.m_blackboardListenersFunctions.m_isBriefingActive);
      this.m_blackboardListeners.m_twintoneOverrideShown = blackboardSystem.Get(this.m_blackboardIds.m_twintoneOverrideShown).RegisterListenerBool(this.m_blackboardValuesIds.m_twintoneOverrideShown, this, this.m_blackboardListenersFunctions.m_twintoneOverrideShown);
    };
  }

  private final func UnregisterInputListeners() -> Void {
    this.m_owner.UnregisterInputListener(this);
  }

  private final func UnregisterBlackboardListeners() -> Void {
    let blackboardSystem: ref<BlackboardSystem> = GameInstance.GetBlackboardSystem(this.m_owner.GetGame());
    blackboardSystem.Get(this.m_blackboardIds.m_kerenzikov).UnregisterListenerInt(this.m_blackboardValuesIds.m_kerenzikov, this.m_blackboardListeners.m_kerenzikov);
    blackboardSystem.Get(this.m_blackboardIds.m_restrictedScene).UnregisterListenerInt(this.m_blackboardValuesIds.m_restrictedScene, this.m_blackboardListeners.m_restrictedScene);
    blackboardSystem.Get(this.m_blackboardIds.m_dead).UnregisterListenerInt(this.m_blackboardValuesIds.m_dead, this.m_blackboardListeners.m_dead);
    blackboardSystem.Get(this.m_blackboardIds.m_takedown).UnregisterListenerInt(this.m_blackboardValuesIds.m_takedown, this.m_blackboardListeners.m_takedown);
    blackboardSystem.Get(this.m_blackboardIds.m_deviceTakeover).UnregisterListenerEntityID(this.m_blackboardValuesIds.m_deviceTakeover, this.m_blackboardListeners.m_deviceTakeover);
    blackboardSystem.Get(this.m_blackboardIds.m_braindanceFPP).UnregisterListenerBool(this.m_blackboardValuesIds.m_braindanceFPP, this.m_blackboardListeners.m_braindanceFPP);
    blackboardSystem.Get(this.m_blackboardIds.m_braindanceActive).UnregisterListenerBool(this.m_blackboardValuesIds.m_braindanceActive, this.m_blackboardListeners.m_braindanceActive);
    blackboardSystem.Get(this.m_blackboardIds.m_veryHardLanding).UnregisterListenerInt(this.m_blackboardValuesIds.m_veryHardLanding, this.m_blackboardListeners.m_veryHardLanding);
    blackboardSystem.Get(this.m_blackboardIds.m_isBriefingActive).UnregisterListenerBool(this.m_blackboardValuesIds.m_isBriefingActive, this.m_blackboardListeners.m_isBriefingActive);
    blackboardSystem.Get(this.m_blackboardIds.m_twintoneOverrideShown).UnregisterListenerBool(this.m_blackboardValuesIds.m_twintoneOverrideShown, this.m_blackboardListeners.m_twintoneOverrideShown);
  }

  private final func VerifyActivation() -> Void {
    let active: Bool;
    let inputActive: Bool = !this.m_inputActiveFlags.m_driverCombatButtonHold && this.m_inputActiveFlags.m_buttonHold || this.m_inputActiveFlags.m_buttonToggle || this.m_inputActiveFlags.m_driverCombatButtonHold && this.m_inputActiveFlags.m_driverCombatButtonActivate;
    let forced: Bool = this.m_gameplayActiveFlags.m_braindanceActive && !this.m_gameplayActiveFlags.m_braindanceFPP || this.m_gameplayActiveFlags.m_twintoneOverrideShown;
    this.m_gameplayActiveFlags.m_hasNotCybereye = !RPGManager.HasStatFlag(this.m_owner, gamedataStatType.HasCybereye);
    this.m_gameplayActiveFlags.m_isPhotoMode = GameInstance.GetPhotoModeSystem(this.m_owner.GetGame()).IsPhotoModeActive();
    let isScannerVisibility: worlduiEntryVisibility = GameInstance.GetUISystem(this.m_owner.GetGame()).GetHudEntryForcedVisibility(n"scanner");
    let isScannerForceHidden: Bool = Equals(isScannerVisibility, worlduiEntryVisibility.ForceHide);
    if !forced && (!inputActive || this.m_gameplayActiveFlags.m_kerenzikov || this.m_gameplayActiveFlags.m_restrictedScene || this.m_gameplayActiveFlags.m_dead || this.m_gameplayActiveFlags.m_takedown || this.m_gameplayActiveFlags.m_deviceTakeover || this.m_gameplayActiveFlags.m_braindanceActive || this.m_gameplayActiveFlags.m_isBriefingActive || this.m_gameplayActiveFlags.m_veryHardLanding || this.m_gameplayActiveFlags.m_noScanningRestriction || this.m_gameplayActiveFlags.m_hasNotCybereye || this.m_gameplayActiveFlags.m_isPhotoMode || isScannerForceHidden) {
      active = false;
    } else {
      active = true;
    };
    this.InvalidateActivationState(active);
  }

  private final func ActivateVisionMode() -> Void {
    GameInstance.GetVisionModeSystem(this.m_owner.GetGame()).GetScanningController().EnterMode(this.m_owner, gameScanningMode.Heavy);
    if !this.m_owner.GetHudManager().IsQuickHackPanelOpened() {
      GameInstance.GetTargetingSystem(this.m_owner.GetGame()).AimSnap(this.m_owner);
    };
    this.SendPSMBoolParameter(n"InterruptSprint", true, gamestateMachineParameterAspect.Temporary);
    this.SendPSMBoolParameter(n"OnInterruptSprintFail_BlockSprintStartOnce", true, gamestateMachineParameterAspect.Conditional);
    this.ApplyFocusModeLocomotionRestriction();
    GameInstance.GetVisionModeSystem(this.m_owner.GetGame()).EnterMode(this.m_owner, gameVisionModeType.Focus);
    this.SetBlackboardIntVariable(GetAllBlackboardDefs().PlayerStateMachine, GetAllBlackboardDefs().PlayerStateMachine.Vision, 1);
    this.SetFocusModeAnimFeature(true);
    this.SetupLockToggleInput();
    this.SetupLockHoldInput();
    GameInstance.GetAudioSystem(this.m_owner.GetGame()).NotifyGameTone(n"Scanning");
    this.m_otherVars.m_enabledByToggle = this.m_inputActiveFlags.m_buttonToggle;
  }

  private final func DeactivateVisionMode() -> Void {
    GameInstance.GetVisionModeSystem(this.m_owner.GetGame()).EnterMode(this.m_owner, gameVisionModeType.Default);
    GameInstance.GetVisionModeSystem(this.m_owner.GetGame()).GetScanningController().EnterMode(this.m_owner, gameScanningMode.Inactive);
    this.SetBlackboardIntVariable(GetAllBlackboardDefs().PlayerStateMachine, GetAllBlackboardDefs().PlayerStateMachine.Vision, 0);
    this.SendPSMBoolParameter(n"VisionToggled", false, gamestateMachineParameterAspect.Temporary);
    this.SendPSMBoolParameter(n"ReevaluateAiming", true, gamestateMachineParameterAspect.Temporary);
    this.SendPSMBoolParameter(n"OnInterruptSprintFail_BlockSprintStartOnce", false, gamestateMachineParameterAspect.Conditional);
    this.SetFocusModeAnimFeature(false);
    this.SetupLockToggleInput();
    GameInstance.GetAudioSystem(this.m_owner.GetGame()).NotifyGameTone(n"NotScanning");
    GameInstance.GetTargetingSystem(this.m_owner.GetGame()).BreakAimSnap(this.m_owner);
    this.RemoveFocusModeLocomotionRestriction();
    this.m_otherVars.m_enabledByToggle = false;
    this.m_otherVars.m_toggledDuringHold = false;
  }

  private final func ProcessFlagsRefreshPolicy() -> Void {
    if Equals(this.m_gameplayActiveFlagsRefreshPolicy.m_kerenzikov, PlayerVisionModeControllerRefreshPolicyEnum.Eventful) {
      this.m_gameplayActiveFlags.m_kerenzikov = false;
    };
    if Equals(this.m_gameplayActiveFlagsRefreshPolicy.m_restrictedScene, PlayerVisionModeControllerRefreshPolicyEnum.Eventful) {
      this.m_gameplayActiveFlags.m_restrictedScene = false;
    };
    if Equals(this.m_gameplayActiveFlagsRefreshPolicy.m_dead, PlayerVisionModeControllerRefreshPolicyEnum.Eventful) {
      this.m_gameplayActiveFlags.m_dead = false;
    };
    if Equals(this.m_gameplayActiveFlagsRefreshPolicy.m_takedown, PlayerVisionModeControllerRefreshPolicyEnum.Eventful) {
      this.m_gameplayActiveFlags.m_takedown = false;
    };
    if Equals(this.m_gameplayActiveFlagsRefreshPolicy.m_deviceTakeover, PlayerVisionModeControllerRefreshPolicyEnum.Eventful) {
      this.m_gameplayActiveFlags.m_deviceTakeover = false;
    };
    if Equals(this.m_gameplayActiveFlagsRefreshPolicy.m_braindanceFPP, PlayerVisionModeControllerRefreshPolicyEnum.Eventful) {
      this.m_gameplayActiveFlags.m_braindanceFPP = false;
    };
    if Equals(this.m_gameplayActiveFlagsRefreshPolicy.m_braindanceActive, PlayerVisionModeControllerRefreshPolicyEnum.Eventful) {
      this.m_gameplayActiveFlags.m_braindanceActive = false;
    };
    if Equals(this.m_gameplayActiveFlagsRefreshPolicy.m_veryHardLanding, PlayerVisionModeControllerRefreshPolicyEnum.Eventful) {
      this.m_gameplayActiveFlags.m_veryHardLanding = false;
    };
    if Equals(this.m_gameplayActiveFlagsRefreshPolicy.m_noScanningRestriction, PlayerVisionModeControllerRefreshPolicyEnum.Eventful) {
      this.m_gameplayActiveFlags.m_noScanningRestriction = false;
    };
    if Equals(this.m_gameplayActiveFlagsRefreshPolicy.m_isBriefingActive, PlayerVisionModeControllerRefreshPolicyEnum.Eventful) {
      this.m_gameplayActiveFlags.m_isBriefingActive = false;
    };
    if Equals(this.m_gameplayActiveFlagsRefreshPolicy.m_twintoneOverrideShown, PlayerVisionModeControllerRefreshPolicyEnum.Eventful) {
      this.m_gameplayActiveFlags.m_twintoneOverrideShown = false;
    };
  }

  protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    let evt: ref<ToggleNewPlayerFlashlightEvent>;
    let time: Float = EngineTime.ToFloat(GameInstance.GetEngineTime(this.m_owner.GetGame()));
    if Equals(ListenerAction.GetName(action), this.m_inputActionsNames.m_buttonToggle) {
      if ListenerAction.GetValue(action) > 0.00 {
        if this.m_otherVars.m_enabledByToggle {
          this.m_inputActiveFlags.m_buttonToggle = !this.m_inputActiveFlags.m_buttonToggle;
        } else {
          this.m_inputActiveFlags.m_buttonToggle = !this.m_inputActiveFlags.m_buttonToggle;
        };
        if this.m_inputActiveFlags.m_buttonToggle && this.m_inputActiveFlags.m_buttonHold {
          this.m_otherVars.m_toggledDuringHold = true;
        };
      };
      this.VerifyActivation();
    } else {
      if Equals(ListenerAction.GetName(action), this.m_inputActionsNames.m_buttonHold) {
        if !IsFinal() {
          if ListenerAction.IsButtonJustPressed(action) {
            this.m_otherVars.m_buttonHoldPressTime = time;
            if time >= this.m_otherVars.m_buttonHoldTapTime + 0.20 {
              this.m_otherVars.m_buttonHoldTapCount = 0;
            };
            if this.m_otherVars.m_buttonHoldTapCount % 2 == 1 {
              evt = new ToggleNewPlayerFlashlightEvent();
              GetPlayer(this.m_owner.GetGame()).QueueEvent(evt);
              return true;
            };
          } else {
            if ListenerAction.IsButtonJustReleased(action) && time < this.m_otherVars.m_buttonHoldPressTime + 0.20 {
              this.m_otherVars.m_buttonHoldTapTime = time;
              this.m_otherVars.m_buttonHoldTapCount += 1;
            };
          };
        };
        if ListenerAction.GetValue(action) > 0.00 {
          this.m_inputActiveFlags.m_buttonHold = true;
          this.m_otherVars.m_toggledDuringHold = false;
        } else {
          this.m_inputActiveFlags.m_buttonHold = false;
          if !this.m_otherVars.m_toggledDuringHold {
            this.m_inputActiveFlags.m_buttonToggle = false;
          };
        };
        this.VerifyActivation();
      } else {
        if Equals(ListenerAction.GetName(action), this.m_inputActionsNames.m_driverCombatButtonHold) {
          if Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_PRESSED) {
            if this.IsPlayerInDriverCombat() {
              this.m_inputActiveFlags.m_driverCombatButtonHold = true;
            };
          } else {
            if Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_RELEASED) {
              this.m_inputActiveFlags.m_driverCombatButtonHold = false;
              this.m_inputActiveFlags.m_driverCombatButtonActivate = false;
            };
          };
          this.VerifyActivation();
        } else {
          if Equals(ListenerAction.GetName(action), this.m_inputActionsNames.m_driverCombatButtonActivate) {
            if ListenerAction.IsButtonJustPressed(action) {
              if this.m_inputActiveFlags.m_driverCombatButtonHold {
                this.m_inputActiveFlags.m_driverCombatButtonActivate = true;
              };
            };
            this.VerifyActivation();
          };
        };
      };
    };
  }

  public final func ForceInputOff() -> Void {
    this.m_inputActiveFlags.m_buttonToggle = false;
    this.m_inputActiveFlags.m_buttonHold = false;
    this.m_inputActiveFlags.m_driverCombatButtonHold = false;
    this.m_inputActiveFlags.m_driverCombatButtonActivate = false;
    this.VerifyActivation();
  }

  protected cb func OnKerenzikovChanged(value: Int32) -> Bool {
    if value == 3 {
      this.m_gameplayActiveFlags.m_kerenzikov = true;
    } else {
      this.m_gameplayActiveFlags.m_kerenzikov = false;
    };
    this.VerifyActivation();
  }

  protected cb func OnRestrictedSceneChanged(value: Int32) -> Bool {
    if value >= 4 && value <= 5 {
      this.m_gameplayActiveFlags.m_restrictedScene = true;
    } else {
      this.m_gameplayActiveFlags.m_restrictedScene = false;
    };
    this.VerifyActivation();
  }

  protected cb func OnDeadChanged(value: Int32) -> Bool {
    if value == 1 {
      this.m_gameplayActiveFlags.m_dead = true;
    } else {
      this.m_gameplayActiveFlags.m_dead = false;
    };
    this.VerifyActivation();
  }

  protected cb func OnTakedownChanged(value: Int32) -> Bool {
    if value == 4 {
      this.m_gameplayActiveFlags.m_takedown = true;
    } else {
      this.m_gameplayActiveFlags.m_takedown = false;
    };
    this.VerifyActivation();
  }

  protected cb func OnDeviceTakeoverChanged(value: EntityID) -> Bool {
    let empty: EntityID;
    if value != empty {
      this.m_gameplayActiveFlags.m_deviceTakeover = true;
    } else {
      this.m_gameplayActiveFlags.m_deviceTakeover = false;
    };
    this.VerifyActivation();
  }

  protected cb func OnBraindanceFPPChanged(value: Bool) -> Bool {
    this.m_gameplayActiveFlags.m_braindanceFPP = value;
    this.VerifyActivation();
  }

  protected cb func OnBraindanceActiveChanged(value: Bool) -> Bool {
    this.m_gameplayActiveFlags.m_braindanceActive = value;
    this.VerifyActivation();
  }

  protected cb func OnBriefingChange(value: Bool) -> Bool {
    this.m_gameplayActiveFlags.m_isBriefingActive = value;
    this.VerifyActivation();
  }

  protected cb func OnTwintoneChange(value: Bool) -> Bool {
    this.m_gameplayActiveFlags.m_twintoneOverrideShown = value;
    this.VerifyActivation();
  }

  protected cb func OnVeryHardLandingChanged(value: Int32) -> Bool {
    if value == 3 {
      this.m_gameplayActiveFlags.m_veryHardLanding = true;
    } else {
      this.m_gameplayActiveFlags.m_veryHardLanding = false;
    };
    this.VerifyActivation();
  }

  public final func UpdateNoScanningRestriction() -> Void {
    let hasNoScanningRestriction: Bool = StatusEffectSystem.ObjectHasStatusEffectWithTag(this.m_owner, n"NoScanning");
    if NotEquals(hasNoScanningRestriction, this.m_gameplayActiveFlags.m_noScanningRestriction) {
      this.m_gameplayActiveFlags.m_noScanningRestriction = hasNoScanningRestriction;
      this.VerifyActivation();
    };
  }

  private final func UpdateBlackboardValues() -> Void {
    let empty: EntityID;
    let blackboardSystem: ref<BlackboardSystem> = GameInstance.GetBlackboardSystem(this.m_owner.GetGame());
    this.m_gameplayActiveFlags.m_kerenzikov = Cast<Bool>(blackboardSystem.Get(this.m_blackboardIds.m_kerenzikov).GetInt(this.m_blackboardValuesIds.m_kerenzikov));
    this.m_gameplayActiveFlags.m_restrictedScene = Cast<Bool>(blackboardSystem.Get(this.m_blackboardIds.m_restrictedScene).GetInt(this.m_blackboardValuesIds.m_restrictedScene));
    this.m_gameplayActiveFlags.m_dead = Cast<Bool>(blackboardSystem.Get(this.m_blackboardIds.m_dead).GetInt(this.m_blackboardValuesIds.m_dead));
    this.m_gameplayActiveFlags.m_takedown = Cast<Bool>(blackboardSystem.Get(this.m_blackboardIds.m_takedown).GetInt(this.m_blackboardValuesIds.m_takedown));
    this.m_gameplayActiveFlags.m_braindanceFPP = blackboardSystem.Get(this.m_blackboardIds.m_braindanceFPP).GetBool(this.m_blackboardValuesIds.m_braindanceFPP);
    this.m_gameplayActiveFlags.m_braindanceActive = blackboardSystem.Get(this.m_blackboardIds.m_braindanceActive).GetBool(this.m_blackboardValuesIds.m_braindanceActive);
    this.m_gameplayActiveFlags.m_veryHardLanding = Cast<Bool>(blackboardSystem.Get(this.m_blackboardIds.m_veryHardLanding).GetInt(this.m_blackboardValuesIds.m_veryHardLanding));
    this.m_gameplayActiveFlags.m_isBriefingActive = blackboardSystem.Get(this.m_blackboardIds.m_isBriefingActive).GetBool(this.m_blackboardValuesIds.m_isBriefingActive);
    this.m_gameplayActiveFlags.m_twintoneOverrideShown = blackboardSystem.Get(this.m_blackboardIds.m_twintoneOverrideShown).GetBool(this.m_blackboardValuesIds.m_twintoneOverrideShown);
    let takeoverDevice: EntityID = blackboardSystem.Get(this.m_blackboardIds.m_deviceTakeover).GetEntityID(this.m_blackboardValuesIds.m_deviceTakeover);
    if takeoverDevice != empty {
      this.m_gameplayActiveFlags.m_deviceTakeover = true;
    } else {
      this.m_gameplayActiveFlags.m_deviceTakeover = false;
    };
  }

  private final func InvalidateActivationState(active: Bool) -> Void {
    let invalidateEvent: ref<PlayerVisionModeControllerInvalidateEvent> = new PlayerVisionModeControllerInvalidateEvent();
    invalidateEvent.m_active = active;
    this.m_owner.QueueEvent(invalidateEvent);
  }

  private final func ApplyFocusModeLocomotionRestriction() -> Void {
    StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"GameplayRestriction.FocusModeLocomotion");
  }

  private final func SetBlackboardIntVariable(definition: ref<BlackboardDefinition>, id: BlackboardID_Int, value: Int32) -> Void {
    let blackboardSystem: ref<BlackboardSystem> = GameInstance.GetBlackboardSystem(this.m_owner.GetGame());
    let blackboard: ref<IBlackboard> = blackboardSystem.GetLocalInstanced(this.m_owner.GetEntityID(), definition);
    if IsDefined(blackboard) {
      blackboard.SetInt(id, value);
    };
  }

  private final func IsPlayerInDriverCombat() -> Bool {
    let blackboardSystem: ref<BlackboardSystem> = GameInstance.GetBlackboardSystem(this.m_owner.GetGame());
    let blackboard: ref<IBlackboard> = blackboardSystem.GetLocalInstanced(this.m_owner.GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    let currentState: Int32 = blackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Vehicle);
    if currentState == 6 {
      return true;
    };
    return false;
  }

  private final func SetFocusModeAnimFeature(newState: Bool) -> Void {
    let animFeature: ref<AnimFeature_FocusMode> = new AnimFeature_FocusMode();
    animFeature.isFocusModeActive = newState;
    AnimationControllerComponent.ApplyFeature(this.m_owner, n"FocusMode", animFeature);
  }

  protected final const func SetupLockToggleInput() -> Void {
    this.SendPSMBoolParameter(n"lockToggleInput", this.m_inputActiveFlags.m_buttonToggle, gamestateMachineParameterAspect.Permanent);
    this.SendPSMBoolParameter(n"lockToggleInput", this.m_inputActiveFlags.m_driverCombatButtonActivate, gamestateMachineParameterAspect.Permanent);
  }

  protected final const func SetupLockHoldInput() -> Void {
    this.SendPSMBoolParameter(n"lockHoldInput", this.m_inputActiveFlags.m_buttonHold, gamestateMachineParameterAspect.Permanent);
    this.SendPSMBoolParameter(n"lockHoldInput", this.m_inputActiveFlags.m_driverCombatButtonHold, gamestateMachineParameterAspect.Permanent);
  }

  protected final const func SendPSMBoolParameter(id: CName, value: Bool, aspect: gamestateMachineParameterAspect) -> Void {
    let psmEvent: ref<PSMPostponedParameterBool> = new PSMPostponedParameterBool();
    psmEvent.id = id;
    psmEvent.value = value;
    psmEvent.aspect = aspect;
    this.m_owner.QueueEvent(psmEvent);
  }

  private final func GetVisionAimSnapParams() -> AimRequest {
    let aimSnapParams: AimRequest;
    aimSnapParams.duration = 0.25;
    aimSnapParams.adjustPitch = true;
    aimSnapParams.adjustYaw = true;
    aimSnapParams.endOnAimingStopped = true;
    aimSnapParams.endOnCameraInputApplied = true;
    aimSnapParams.precision = 0.10;
    aimSnapParams.easeIn = true;
    aimSnapParams.easeOut = true;
    aimSnapParams.checkRange = true;
    aimSnapParams.processAsInput = true;
    aimSnapParams.bodyPartsTracking = true;
    aimSnapParams.bptMaxDot = 0.50;
    aimSnapParams.bptMaxSwitches = -1.00;
    aimSnapParams.bptMinInputMag = 0.50;
    aimSnapParams.bptMinResetInputMag = 0.10;
    return aimSnapParams;
  }

  private final func RemoveFocusModeLocomotionRestriction() -> Void {
    StatusEffectHelper.RemoveStatusEffect(this.m_owner, t"GameplayRestriction.FocusModeLocomotion");
  }

  private final func HasMeleeWeaponEquipped() -> Bool {
    let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.m_owner.GetGame());
    let weapon: ref<WeaponObject> = transactionSystem.GetItemInSlot(this.m_owner, t"AttachmentSlots.WeaponRight") as WeaponObject;
    if IsDefined(weapon) {
      if transactionSystem.HasTag(this.m_owner, n"MeleeWeapon", weapon.GetItemID()) {
        return true;
      };
    };
    return false;
  }
}
