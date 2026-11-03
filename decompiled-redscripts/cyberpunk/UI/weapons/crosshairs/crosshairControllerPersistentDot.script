
public class PersistentDotSettingsListener extends ConfigVarListener {

  private let m_controller: wref<CrosshairGameControllerPersistentDot>;

  public final func RegisterController(controller: ref<CrosshairGameControllerPersistentDot>) -> Void {
    this.m_controller = controller;
  }

  public func OnVarModified(groupPath: CName, varName: CName, varType: ConfigVarType, reason: ConfigChangeReason) -> Void {
    this.m_controller.OnVarModified(groupPath, varName, varType, reason);
  }
}

public class CrosshairGameControllerPersistentDot extends inkHUDGameController {

  private let m_settings: ref<UserSettings>;

  private let m_settingsListener: ref<PersistentDotSettingsListener>;

  @default(CrosshairGameControllerPersistentDot, /accessibility/interface)
  private let m_groupPath: CName;

  private let m_isAiming: Bool;

  private let m_psmUpperBodyStateCallback: ref<CallbackHandle>;

  protected cb func OnInitialize() -> Bool {
    this.m_settings = this.GetSystemRequestsHandler().GetUserSettings();
    this.m_settingsListener = new PersistentDotSettingsListener();
    this.m_settingsListener.RegisterController(this);
    this.m_settingsListener.Register(this.m_groupPath);
    this.UpdateRootVisibility();
  }

  protected cb func OnPlayerAttach(player: ref<GameObject>) -> Bool {
    let psmBlackboard: ref<IBlackboard> = this.GetPSMBlackboard(player);
    this.m_psmUpperBodyStateCallback = psmBlackboard.RegisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.UpperBody, this, n"OnPSMUpperBodyStateChanged");
  }

  protected cb func OnPlayerDetach(player: ref<GameObject>) -> Bool {
    let psmBlackboard: ref<IBlackboard> = this.GetPSMBlackboard(player);
    if IsDefined(this.m_psmUpperBodyStateCallback) {
      psmBlackboard.UnregisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.UpperBody, this.m_psmUpperBodyStateCallback);
    };
  }

  protected cb func OnPSMUpperBodyStateChanged(value: Int32) -> Bool {
    this.m_isAiming = value == 6;
    this.UpdateRootVisibility();
  }

  public final func OnVarModified(groupPath: CName, varName: CName, varType: ConfigVarType, reason: ConfigChangeReason) -> Void {
    if Equals(varName, n"PersistentCenterDot") {
      this.UpdateRootVisibility();
    };
  }

  private final func UpdateRootVisibility() -> Void {
    let configVar: ref<ConfigVarBool> = this.m_settings.GetVar(this.m_groupPath, n"PersistentCenterDot") as ConfigVarBool;
    this.GetRootWidget().SetVisible(configVar.GetValue() && !this.m_isAiming);
  }
}
