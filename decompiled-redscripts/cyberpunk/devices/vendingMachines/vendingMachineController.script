
public class VendingMachineController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<VendingMachineControllerPS> {
    return this.GetBasePS() as VendingMachineControllerPS;
  }
}

public class VendingMachineControllerPS extends ScriptableDeviceComponentPS {

  private persistent let m_vendingMachineSetup: VendingMachineSetup;

  private let m_vendingMachineSFX: VendingMachineSFX;

  @runtimeProperty("rangeMax", "1.f")
  @runtimeProperty("rangeMin", "0.f")
  @default(VendingMachineControllerPS, 0.05f)
  protected let m_soldOutProbability: Float;

  @default(VendingMachineControllerPS, true)
  protected let m_isReady: Bool;

  protected let m_isSoldOut: Bool;

  @default(VendingMachineControllerPS, 2)
  protected let m_hackCount: Int32;

  private let m_shopStock: [SItemStack];

  protected let m_shopStockInit: Bool;

  protected func LogicReady() -> Void {
    super.LogicReady();
    this.m_shopStockInit = false;
  }

  public func GetTimeToCompletePurchase() -> Float {
    return this.m_vendingMachineSetup.m_timeToCompletePurchase;
  }

  public func GetGlitchStartSFX() -> CName {
    return this.m_vendingMachineSFX.m_glitchingStart;
  }

  public func GetGlitchStopSFX() -> CName {
    return this.m_vendingMachineSFX.m_glitchingStop;
  }

  protected final func GetShopStock() -> [SItemStack] {
    if !this.m_shopStockInit {
      this.m_shopStock = MarketSystem.GetVendorItemsForSale(this.GetOwnerEntityWeak() as GameObject, false);
      this.m_shopStockInit = true;
    };
    return this.m_shopStock;
  }

  public func GetHackedItemCount() -> Int32 {
    return 10;
  }

  public final func IsSoldOut() -> Bool {
    return this.m_isSoldOut;
  }

  protected final func ActionDispenceItemFromVendor(item: ItemID, price: Int32) -> ref<DispenceItemFromVendor> {
    let buttonTextureName: CName = TweakDBInterface.GetConsumableItemRecord(ItemID.GetTDBID(item)).AtlasIcon();
    let action: ref<DispenceItemFromVendor> = new DispenceItemFromVendor();
    action.clearanceLevel = 1;
    action.SetUp(this);
    action.SetProperties(item, price, buttonTextureName);
    action.AddDeviceName(this.m_deviceName);
    action.CreateActionWidgetPackage();
    action.SetDurationValue(this.GetTimeToCompletePurchase());
    return action;
  }

  public func GetActions(out actions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    if !super.GetActions(actions, context) {
      this.m_isReady = false;
      return false;
    };
    this.PushShopStockActions(actions, context);
    this.SetActionIllegality(actions, this.m_illegalActions.regularActions);
    return true;
  }

  protected func PushShopStockActions(actions: script_ref<[ref<DeviceAction>]>, const context: script_ref<GetActionsContext>) -> Void {
    let i: Int32;
    let price: Int32;
    let shopStock: array<SItemStack>;
    if DispenceItemFromVendor.IsDefaultConditionMet(this, context) && this.m_isReady {
      shopStock = this.GetShopStock();
      i = 0;
      while i < ArraySize(shopStock) {
        price = MarketSystem.GetBuyPrice(this.GetOwnerEntityWeak() as GameObject, shopStock[i].itemID);
        ArrayPush(Deref(actions), this.ActionDispenceItemFromVendor(shopStock[i].itemID, price));
        i += 1;
      };
    };
  }

  protected const func CanCreateAnyQuickHackActions() -> Bool {
    return true;
  }

  protected func GetQuickHackActions(out outActions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    let currentAction: ref<ScriptableDeviceAction> = this.ActionGlitchScreen(t"DeviceAction.GlitchScreenSuicide", t"QuickHack.GrenadeHackBase");
    currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
    ArrayPush(outActions, currentAction);
    currentAction = this.ActionGlitchScreen(t"DeviceAction.GlitchScreenBlind", t"QuickHack.BlindHack");
    currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
    ArrayPush(outActions, currentAction);
    currentAction = this.ActionGlitchScreen(t"DeviceAction.GlitchScreenGrenade", t"QuickHack.GrenadeHackBase");
    currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
    ArrayPush(outActions, currentAction);
    if !GlitchScreen.IsDefaultConditionMet(this, context) {
      ScriptableDeviceComponentPS.SetActionsInactiveAll(outActions, "LocKey#7003");
    };
    currentAction = this.ActionQuickHackDistraction();
    currentAction.SetObjectActionID(t"DeviceAction.MalfunctionClassHack");
    currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
    if !ScriptableDeviceAction.IsDefaultConditionMet(this, context) || this.m_hackCount < 1 {
      currentAction.SetInactiveWithReason(false, "LocKey#7003");
    };
    ArrayPush(outActions, currentAction);
    if this.IsGlitching() || this.IsDistracting() {
      ScriptableDeviceComponentPS.SetActionsInactiveAll(outActions, "LocKey#7004");
    };
    if !this.IsON() {
      ScriptableDeviceComponentPS.SetActionsInactiveAll(outActions, "LocKey#7005");
    };
    this.FinalizeGetQuickHackActions(outActions, context);
  }

  public func GetQuestActions(out outActions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    super.GetQuestActions(outActions, context);
  }

  public func OnDispenceItemFromVendor(evt: ref<DispenceItemFromVendor>) -> EntityNotificationType {
    if evt.IsStarted() {
      this.m_isReady = false;
      this.ExecutePSActionWithDelay(evt, this, evt.GetDurationValue());
    } else {
      if RandF() <= this.m_soldOutProbability {
        this.m_isSoldOut = true;
      } else {
        this.m_isReady = true;
      };
    };
    this.UseNotifier(evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  public func OnQuickHackDistraction(evt: ref<QuickHackDistraction>) -> EntityNotificationType {
    if evt.IsStarted() {
      this.m_isReady = false;
      this.m_hackCount -= 1;
      if this.m_hackCount == 0 {
        this.m_isSoldOut = true;
      };
    };
    return super.OnQuickHackDistraction(evt);
  }

  public final func SetIsReady(value: Bool) -> Void {
    this.m_isReady = value;
  }

  public const func GetBlackboardDef() -> ref<VendingMachineDeviceBlackboardDef> {
    return GetAllBlackboardDefs().VendingMachineDeviceBlackboard;
  }
}
