
public class DeviceActionWidgetControllerBase extends DeviceButtonLogicControllerBase {

  protected let m_actions: [wref<DeviceAction>];

  protected let m_actionData: ref<ResolveActionData>;

  protected let m_isInactive: Bool;

  public func Initialize(gameController: ref<DeviceInkGameControllerBase>, const widgetData: script_ref<SActionWidgetPackage>) -> Void {
    let action: ref<ScriptableDeviceAction>;
    let i: Int32;
    ArrayClear(this.m_actions);
    if Equals(Deref(widgetData).wasInitalized, false) {
      return;
    };
    this.AddAction(Deref(widgetData).action);
    i = 0;
    while i < ArraySize(Deref(widgetData).dependendActions) {
      this.AddAction(Deref(widgetData).dependendActions[i]);
      i += 1;
    };
    inkTextRef.SetLocalizedTextScript(this.m_displayNameWidget, Deref(widgetData).displayName);
    if TDBID.IsValid(Deref(widgetData).iconTextureID) {
      this.SetTexture(this.m_iconWidget, Deref(widgetData).iconTextureID);
    } else {
      if inkWidgetRef.Get(this.m_iconWidget) != null {
        inkImageRef.SetTexturePart(this.m_iconWidget, Deref(widgetData).iconID);
      };
    };
    action = Deref(widgetData).action as ScriptableDeviceAction;
    if IsDefined(action) {
      this.m_isInactive = action.IsInactive();
    };
    this.RegisterDeviceActionCallback(gameController);
    this.ResolveWidgetState(Deref(widgetData).widgetState);
    this.m_isInitialized = true;
  }

  public func ClearButtonActions() -> Void {
    ArrayClear(this.m_actions);
  }

  protected final func RegisterDeviceActionCallback(gameController: ref<DeviceInkGameControllerBase>) -> Void {
    if !this.m_isInitialized {
      this.m_targetWidget.RegisterToCallback(n"OnRelease", gameController, n"OnDeviceActionCallback");
      this.m_targetWidget.RegisterToCallback(n"OnExecuteButtonAction", gameController, n"OnExecuteButtonAction");
      this.RegisterAudioCallbacks(gameController);
    };
  }

  public final func SetActions(const actions: script_ref<[wref<DeviceAction>]>) -> Void {
    this.m_actions = Deref(actions);
  }

  public final func AddAction(action: wref<DeviceAction>) -> Void {
    if !ArrayContains(this.m_actions, action) {
      ArrayPush(this.m_actions, action);
    };
  }

  public final func RemoveAction(action: wref<DeviceAction>) -> Void {
    ArrayRemove(this.m_actions, action);
  }

  public final func GetActions() -> [wref<DeviceAction>] {
    return this.m_actions;
  }

  protected func ResolveAction(const widgetData: script_ref<SActionWidgetPackage>) -> Void;

  public func FinalizeActionExecution(executor: ref<GameObject>, action: ref<DeviceAction>) -> Void;

  public const func CanExecuteAction() -> Bool {
    return !this.m_isInactive;
  }

  protected func ResolveWidgetState(state: EWidgetState) -> Void {
    if this.m_isInactive {
      if IsDefined(this.m_targetWidget) {
        this.m_targetWidget.SetState(n"Inactive");
        this.m_targetWidget.SetInteractive(false);
      };
    } else {
      if IsDefined(this.m_targetWidget) {
        this.m_targetWidget.SetState(n"Default");
        this.m_targetWidget.SetInteractive(true);
      };
    };
    if Equals(state, EWidgetState.ON) {
      if IsDefined(inkWidgetRef.Get(this.m_toggleSwitchWidget)) {
        inkWidgetRef.SetScale(this.m_toggleSwitchWidget, new Vector2(1.00, 1.00));
      };
    } else {
      if Equals(state, EWidgetState.OFF) {
        if IsDefined(inkWidgetRef.Get(this.m_toggleSwitchWidget)) {
          inkWidgetRef.SetScale(this.m_toggleSwitchWidget, new Vector2(-1.00, -1.00));
        };
      };
    };
  }
}
