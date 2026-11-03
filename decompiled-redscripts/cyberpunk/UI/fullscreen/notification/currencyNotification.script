
public class CurrencyChangeInventoryCallback extends InventoryScriptCallback {

  public let m_notificationQueue: wref<ItemsNotificationQueue>;

  public func OnItemQuantityChanged(item: ItemID, diff: Int32, total: Uint32, flaggedAsSilent: Bool) -> Void {
    if ItemID.IsOfTDBID(item, t"Items.money") && !flaggedAsSilent {
      this.m_notificationQueue.PushCurrencyNotification(diff, total);
    };
  }
}

public native class CurrencyUpdateNotificationViewData extends GenericNotificationViewData {

  public native let diff: Int32;

  public native let total: Uint32;

  public func CanMerge(data: ref<GenericNotificationViewData>) -> Bool {
    let compareTo: ref<CurrencyUpdateNotificationViewData> = data as CurrencyUpdateNotificationViewData;
    if IsDefined(compareTo) {
      this.total = compareTo.total;
      this.diff = this.diff + compareTo.diff;
      return true;
    };
    return false;
  }
}

public class CurrencyNotification extends GenericNotificationController {

  private edit let m_CurrencyUpdateAnimation: CName;

  private edit let m_CurrencyDiff: inkTextRef;

  private edit let m_CurrencyTotal: inkTextRef;

  private edit let m_total_animator: wref<inkTextValueProgressController>;

  private let m_currencyData: ref<CurrencyUpdateNotificationViewData>;

  private let m_animProxy: ref<inkAnimProxy>;

  @default(CurrencyNotification, CurrencyNotificationAnimState.Inactive)
  private let m_animState: CurrencyNotificationAnimState;

  private let blackboard: wref<IBlackboard>;

  private let uiSystemBB: ref<UI_SystemDef>;

  private let uiSystemId: ref<CallbackHandle>;

  protected cb func OnInitialize() -> Bool {
    super.OnInitialize();
    this.blackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_System);
    this.uiSystemBB = GetAllBlackboardDefs().UI_System;
    this.uiSystemId = this.blackboard.RegisterListenerBool(this.uiSystemBB.IsInMenu, this, n"OnMenuUpdate");
    this.RegisterToCallback(n"OnItemChanged", this, n"OnDataUpdate");
  }

  protected cb func OnUninitialize() -> Bool {
    super.OnUninitialize();
    this.blackboard.UnregisterListenerBool(this.uiSystemBB.IsInMenu, this.uiSystemId);
  }

  protected cb func OnDataUpdate() -> Bool {
    this.UpdateData();
  }

  protected cb func OnMenuUpdate(value: Bool) -> Bool {
    this.UpdateData();
  }

  public func SetNotificationData(notificationData: ref<GenericNotificationViewData>) -> Void {
    this.m_currencyData = notificationData as CurrencyUpdateNotificationViewData;
    this.UpdateData();
    super.SetNotificationData(notificationData);
  }

  private final func UpdateData() -> Void {
    let animOptions: inkAnimOptions;
    inkTextRef.SetText(this.m_CurrencyDiff, ToString(this.m_currencyData.diff));
    inkTextRef.SetText(this.m_CurrencyTotal, ToString(this.m_currencyData.total));
    if Equals(this.m_animState, CurrencyNotificationAnimState.Intro) {
      return;
    };
    this.m_total_animator = inkWidgetRef.GetController(this.m_CurrencyTotal) as inkTextValueProgressController;
    this.m_total_animator.SetDelay(3.25);
    this.m_total_animator.SetDuration(1.00);
    this.m_total_animator.SetBaseValue(Cast<Float>(this.m_currencyData.total) - Cast<Float>(this.m_currencyData.diff));
    this.m_total_animator.SetTargetValue(Cast<Float>(this.m_currencyData.total));
    this.m_total_animator.PlaySetAnimation().RegisterToCallback(inkanimEventType.OnFinish, this, n"OnMainAnimationOver");
    if Equals(this.m_animState, CurrencyNotificationAnimState.Inactive) {
      animOptions.toMarker = n"intro_end";
      this.m_animProxy = this.PlayLibraryAnimation(this.m_CurrencyUpdateAnimation, animOptions);
      this.m_animProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnIntoOver");
      this.m_animState = CurrencyNotificationAnimState.Intro;
    } else {
      this.m_animProxy.Stop();
      this.PlayActiveAnim();
    };
  }

  private final func PlayActiveAnim() -> Void {
    let animOptions: inkAnimOptions;
    animOptions.fromMarker = n"intro_end";
    animOptions.toMarker = n"outro_start";
    this.m_animProxy = this.PlayLibraryAnimation(this.m_CurrencyUpdateAnimation, animOptions);
    this.m_animState = CurrencyNotificationAnimState.Active;
  }

  protected cb func OnIntoOver(e: ref<inkAnimProxy>) -> Bool {
    this.PlayActiveAnim();
  }

  protected cb func OnOutroOver(e: ref<inkAnimProxy>) -> Bool {
    this.m_animState = CurrencyNotificationAnimState.Inactive;
    this.m_animProxy = null;
    this.m_total_animator = null;
  }

  protected cb func OnMainAnimationOver(e: ref<inkAnimProxy>) -> Bool {
    let animOptions: inkAnimOptions;
    this.m_animProxy.Stop();
    animOptions.fromMarker = n"outro_start";
    this.m_animProxy = this.PlayLibraryAnimation(this.m_CurrencyUpdateAnimation, animOptions);
    this.m_animProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnOutroOver");
    this.m_animState = CurrencyNotificationAnimState.Outro;
  }
}
