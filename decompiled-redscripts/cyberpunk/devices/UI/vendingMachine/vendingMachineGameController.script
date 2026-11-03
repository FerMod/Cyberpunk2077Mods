
public class VendingMachineInkGameController extends DeviceInkGameControllerBase {

  @runtimeProperty("category", "Widget Refs")
  protected edit let m_ActionsPanel: inkHorizontalPanelRef;

  @runtimeProperty("category", "Widget Refs")
  protected edit let m_ActionsPanel2: inkHorizontalPanelRef;

  @runtimeProperty("category", "Widget Refs")
  protected edit let m_priceText: inkTextRef;

  @runtimeProperty("category", "Widget Refs")
  protected edit let m_noMoneyPanel: inkCompoundRef;

  @runtimeProperty("category", "Widget Refs")
  protected edit let m_soldOutPanel: inkCompoundRef;

  protected let m_state: PaymentStatus;

  protected let m_soldOut: Bool;

  private let m_onUpdateStatusListener: ref<CallbackHandle>;

  private let m_onGlitchingStateChangedListener: ref<CallbackHandle>;

  private let m_onSoldOutListener: ref<CallbackHandle>;

  protected cb func OnInitialize() -> Bool {
    super.OnInitialize();
    inkWidgetRef.SetVisible(this.m_noMoneyPanel, false);
    inkWidgetRef.SetVisible(this.m_soldOutPanel, false);
  }

  protected func RegisterBlackboardCallbacks(blackboard: ref<IBlackboard>) -> Void {
    super.RegisterBlackboardCallbacks(blackboard);
    if IsDefined(blackboard) {
      this.m_onUpdateStatusListener = blackboard.RegisterListenerVariant(this.GetOwner().GetBlackboardDef().ActionStatus, this, n"OnUpdateStatus");
      this.m_onGlitchingStateChangedListener = blackboard.RegisterListenerVariant(this.GetOwner().GetBlackboardDef().GlitchData, this, n"OnGlitchingStateChanged");
      this.m_onSoldOutListener = blackboard.RegisterListenerBool(this.GetOwner().GetBlackboardDef().SoldOut, this, n"OnSoldOut");
    };
  }

  protected func UnRegisterBlackboardCallbacks(blackboard: ref<IBlackboard>) -> Void {
    super.UnRegisterBlackboardCallbacks(blackboard);
    if IsDefined(blackboard) {
      blackboard.UnregisterListenerVariant(this.GetOwner().GetBlackboardDef().ActionStatus, this.m_onUpdateStatusListener);
      blackboard.UnregisterListenerVariant(this.GetOwner().GetBlackboardDef().GlitchData, this.m_onGlitchingStateChangedListener);
      blackboard.UnregisterListenerBool(this.GetOwner().GetBlackboardDef().SoldOut, this.m_onSoldOutListener);
    };
  }

  public func UpdateActionWidgets(const widgetsData: script_ref<[SActionWidgetPackage]>) -> Void {
    let action: ref<DispenceItemFromVendor>;
    let i: Int32;
    let widget: ref<inkWidget>;
    this.HideActionWidgets();
    if !this.m_soldOut {
      inkWidgetRef.SetVisible(this.m_ActionsPanel, true);
      inkWidgetRef.SetVisible(this.m_ActionsPanel2, true);
      inkWidgetRef.SetVisible(this.m_noMoneyPanel, false);
      inkWidgetRef.SetVisible(this.m_soldOutPanel, false);
      i = 0;
      while i < ArraySize(Deref(widgetsData)) {
        widget = this.GetActionWidget(Deref(widgetsData)[i]);
        if widget == null {
          if i <= 2 {
            this.CreateActionWidgetAsync(inkWidgetRef.Get(this.m_ActionsPanel), Deref(widgetsData)[i]);
          } else {
            this.CreateActionWidgetAsync(inkWidgetRef.Get(this.m_ActionsPanel2), Deref(widgetsData)[i]);
          };
        } else {
          this.InitializeActionWidget(widget, Deref(widgetsData)[i]);
        };
        i += 1;
      };
      action = Deref(widgetsData)[0].action as DispenceItemFromVendor;
      this.UpdatePrice(action.GetPrice());
    };
  }

  protected cb func OnSoldOut(value: Bool) -> Bool {
    this.m_soldOut = value;
    if this.m_soldOut {
      inkWidgetRef.SetVisible(this.m_soldOutPanel, true);
      inkWidgetRef.SetVisible(this.m_ActionsPanel, false);
      inkWidgetRef.SetVisible(this.m_ActionsPanel2, false);
      this.TriggerAnimationByName(n"sold_out", EInkAnimationPlaybackOption.PLAY);
    } else {
      inkWidgetRef.SetVisible(this.m_soldOutPanel, false);
      inkWidgetRef.SetVisible(this.m_ActionsPanel, true);
      inkWidgetRef.SetVisible(this.m_ActionsPanel2, true);
    };
  }

  protected cb func OnUpdateStatus(value: Variant) -> Bool;

  protected func ExecuteDeviceActions(controller: ref<DeviceActionWidgetControllerBase>) -> Void {
    let actions: array<wref<DeviceAction>>;
    let buyAction: ref<DispenceItemFromVendor>;
    let executor: wref<GameObject>;
    let i: Int32;
    if controller != null {
      if controller.CanExecuteAction() {
        actions = controller.GetActions();
      };
    };
    executor = GetPlayer(this.GetOwner().GetGame());
    i = 0;
    while i < ArraySize(actions) {
      buyAction = actions[i] as DispenceItemFromVendor;
      if IsDefined(buyAction) && !buyAction.CanPay(executor) {
        inkWidgetRef.SetVisible(this.m_noMoneyPanel, true);
        this.PlayLibraryAnimation(n"no_money");
      } else {
        this.ExecuteAction(actions[i], executor);
        controller.FinalizeActionExecution(executor, actions[i]);
      };
      i += 1;
    };
  }

  protected cb func OnButtonHoverOver(e: ref<inkPointerEvent>) -> Bool {
    let button: ref<ImageActionButtonLogicController> = e.GetCurrentTarget().GetController() as ImageActionButtonLogicController;
    if IsDefined(button) {
      this.UpdatePrice(button.GetPrice());
    };
  }

  private final func UpdatePrice(price: Int32) -> Void {
    let textParams: ref<inkTextParams> = new inkTextParams();
    textParams.AddNumber("COST", price);
    textParams.AddLocalizedString("ED", "LocKey#884");
    inkTextRef.SetLocalizedTextString(this.m_priceText, "LocKey#45350", textParams);
  }

  protected func GetOwner() -> ref<VendingMachine> {
    return this.GetOwnerEntity() as VendingMachine;
  }

  protected func Refresh(state: EDeviceStatus) -> Void {
    this.SetupWidgets();
    switch state {
      case EDeviceStatus.ON:
        this.TurnOn();
        break;
      case EDeviceStatus.OFF:
        this.TurnOff();
        break;
      case EDeviceStatus.UNPOWERED:
        this.TurnOff();
        break;
      case EDeviceStatus.DISABLED:
        this.TurnOff();
        break;
      default:
    };
    super.Refresh(state);
  }

  protected func TurnOn() -> Void {
    this.m_rootWidget.SetVisible(true);
    this.RequestActionWidgetsUpdate();
  }

  protected func TurnOff() -> Void {
    this.m_rootWidget.SetVisible(false);
  }
}
