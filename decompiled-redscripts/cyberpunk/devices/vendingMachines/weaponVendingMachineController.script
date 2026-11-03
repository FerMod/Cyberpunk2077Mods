
public class WeaponVendingMachineController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<WeaponVendingMachineControllerPS> {
    return this.GetBasePS() as WeaponVendingMachineControllerPS;
  }
}

public class WeaponVendingMachineControllerPS extends VendingMachineControllerPS {

  private persistent let m_weaponVendingMachineSetup: WeaponVendingMachineSetup;

  private let m_weaponVendingMachineSFX: WeaponVendingMachineSFX;

  protected func GetQuickHackActions(out actions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    super.GetQuickHackActions(actions, context);
  }

  public final func GetVendorTweakID() -> TweakDBID {
    return this.m_weaponVendingMachineSetup.m_vendorTweakID;
  }

  public final func GetJunkItemID() -> TweakDBID {
    return this.m_weaponVendingMachineSetup.m_junkItemID;
  }

  public func GetTimeToCompletePurchase() -> Float {
    return this.m_weaponVendingMachineSetup.m_timeToCompletePurchase;
  }

  public final func GetGunFallSFX() -> CName {
    return this.m_weaponVendingMachineSFX.m_gunFalls;
  }

  public final func GetProcessingSFX() -> CName {
    return this.m_weaponVendingMachineSFX.m_processing;
  }

  public func GetGlitchStartSFX() -> CName {
    return this.m_weaponVendingMachineSFX.m_glitchingStart;
  }

  public func GetGlitchStopSFX() -> CName {
    return this.m_weaponVendingMachineSFX.m_glitchingStop;
  }

  public func GetHackedItemCount() -> Int32 {
    return 5;
  }

  protected func PushShopStockActions(actions: script_ref<[ref<DeviceAction>]>, const context: script_ref<GetActionsContext>) -> Void {
    let price: Int32;
    let shopStock: array<SItemStack>;
    if DispenceItemFromVendor.IsDefaultConditionMet(this, context) && this.m_isReady {
      shopStock = this.GetShopStock();
      if ArraySize(shopStock) > 0 {
        price = MarketSystem.GetBuyPrice(this.GetOwnerEntityWeak() as GameObject, shopStock[0].itemID);
        ArrayPush(Deref(actions), this.ActionDispenceItemFromVendor(shopStock[0].itemID, price));
      };
    };
  }
}
