
public class JukeboxInkGameController extends DeviceInkGameControllerBase {

  @runtimeProperty("category", "Widget Refs")
  private edit let m_ActionsPanel: inkHorizontalPanelRef;

  @runtimeProperty("category", "Widget Refs")
  private edit let m_PriceText: inkTextRef;

  private let m_playButton: wref<PlayPauseActionWidgetController>;

  private let m_nextButton: wref<NextPreviousActionWidgetController>;

  private let m_previousButton: wref<NextPreviousActionWidgetController>;

  protected func RegisterBlackboardCallbacks(blackboard: ref<IBlackboard>) -> Void {
    super.RegisterBlackboardCallbacks(blackboard);
  }

  public func UpdateActionWidgets(const widgetsData: script_ref<[SActionWidgetPackage]>) -> Void {
    let action: ref<ScriptableDeviceAction>;
    let i: Int32;
    let price: Int32;
    let textParams: ref<inkTextParams>;
    let widget: ref<inkWidget>;
    this.HideActionWidgets();
    inkWidgetRef.SetVisible(this.m_ActionsPanel, true);
    i = 0;
    while i < ArraySize(Deref(widgetsData)) {
      widget = this.GetActionWidget(Deref(widgetsData)[i]);
      if widget == null {
        this.CreateActionWidgetAsync(inkWidgetRef.Get(this.m_ActionsPanel), Deref(widgetsData)[i]);
      } else {
        this.InitializeActionWidget(widget, Deref(widgetsData)[i]);
      };
      if price == 0 {
        action = Deref(widgetsData)[i].action as ScriptableDeviceAction;
        price = action.GetCost();
      };
      i += 1;
    };
    textParams = new inkTextParams();
    textParams.AddNumber("COST", price);
    textParams.AddLocalizedString("ED", "LocKey#884");
    inkTextRef.SetLocalizedTextScript(this.m_PriceText, "LocKey#45350", textParams);
  }

  protected cb func OnActionWidgetSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
    let actionData: ref<ScriptableDeviceAction>;
    let spawnData: ref<AsyncSpawnData>;
    let widgetData: SActionWidgetPackage;
    super.OnActionWidgetSpawned(widget, userData);
    spawnData = userData as AsyncSpawnData;
    widgetData = FromVariant<SActionWidgetPackage>(spawnData.m_widgetData);
    actionData = widgetData.action as ScriptableDeviceAction;
    if IsDefined(actionData as TogglePlay) {
      this.m_playButton = widget.GetController() as PlayPauseActionWidgetController;
    } else {
      if IsDefined(actionData as NextStation) {
        this.m_nextButton = widget.GetController() as NextPreviousActionWidgetController;
      } else {
        if IsDefined(actionData as PreviousStation) {
          this.m_previousButton = widget.GetController() as NextPreviousActionWidgetController;
        };
      };
    };
  }

  protected final func Decline() -> Void {
    this.PlayLibraryAnimation(n"no_money_root");
    this.m_playButton.Decline();
    this.m_nextButton.Decline();
    this.m_previousButton.Decline();
  }

  protected func ExecuteDeviceActions(controller: ref<DeviceActionWidgetControllerBase>) -> Void {
    let action: ref<BaseScriptableAction>;
    let actions: array<wref<DeviceAction>>;
    let executor: wref<GameObject>;
    let i: Int32;
    let nextAction: ref<NextStation>;
    let playAction: ref<TogglePlay>;
    let prevAction: ref<PreviousStation>;
    if controller == null {
      return;
    };
    executor = GetPlayer(this.GetOwner().GetGame());
    if controller.CanExecuteAction() {
      actions = controller.GetActions();
    };
    i = 0;
    while i < ArraySize(actions) {
      this.ExecuteAction(actions[i], executor);
      controller.FinalizeActionExecution(executor, actions[i]);
      action = actions[i] as BaseScriptableAction;
      if !action.CanPayCost(executor) {
        this.Decline();
      } else {
        playAction = actions[i] as TogglePlay;
        if IsDefined(playAction) {
          if FromVariant<Bool>(playAction.prop.first) {
            this.m_nextButton.Reset();
            this.m_previousButton.Reset();
          } else {
            this.m_nextButton.Deactivate();
            this.m_previousButton.Deactivate();
          };
        } else {
          prevAction = actions[i] as PreviousStation;
          nextAction = actions[i] as NextStation;
          if IsDefined(prevAction) || IsDefined(nextAction) {
            this.m_playButton.TogglePlay(true);
          };
        };
      };
      i += 1;
    };
  }

  protected func GetOwner() -> ref<Jukebox> {
    return this.GetOwnerEntity() as Jukebox;
  }

  protected func Refresh(state: EDeviceStatus) -> Void {
    super.Refresh(state);
    this.HideActionWidgets();
    this.RequestActionWidgetsUpdate();
  }
}
