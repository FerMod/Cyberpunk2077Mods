
public class WeaponVendingMachine extends VendingMachine {

  protected let m_bigAdScreen: wref<IWorldWidgetComponent>;

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
    EntityRequestComponentsInterface.RequestComponent(ri, n"bigAdvertScreen", n"worlduiWidgetComponent", false);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_bigAdScreen = EntityResolveComponentsInterface.GetComponent(ri, n"bigAdvertScreen") as worlduiWidgetComponent;
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as WeaponVendingMachineController;
  }

  public func GetVendorID() -> TweakDBID {
    return this.GetDevicePS().GetVendorTweakID();
  }

  protected func PlayItemFall() -> Void {
    GameObject.PlaySoundEvent(this, this.GetDevicePS().GetGunFallSFX());
  }

  protected func GetJunkItem() -> ItemID {
    return ItemID.FromTDBID(this.GetDevicePS().GetJunkItemID());
  }

  protected func GetProcessingSFX() -> CName {
    return this.GetDevicePS().GetProcessingSFX();
  }

  protected func CreateDispenseRequest(shouldPay: Bool, item: ItemID) -> ref<DispenseRequest> {
    let dispenseRequest: ref<DispenseRequest> = new DispenseRequest();
    dispenseRequest.owner = this;
    dispenseRequest.position = this.RandomizePosition();
    dispenseRequest.shouldPay = shouldPay;
    if ItemID.IsValid(item) {
      dispenseRequest.itemID = ItemID.CreateQuery(ItemID.GetTDBID(item));
    };
    return dispenseRequest;
  }

  protected func TurnOffDevice() -> Void {
    super.TurnOffDevice();
    if IsDefined(this.m_bigAdScreen) {
      this.m_bigAdScreen.Toggle(false);
    };
  }

  protected func TurnOnDevice() -> Void {
    super.TurnOnDevice();
    if IsDefined(this.m_bigAdScreen) {
      this.m_bigAdScreen.Toggle(true);
    };
  }

  protected const func GetController() -> ref<WeaponVendingMachineController> {
    return this.m_controller as WeaponVendingMachineController;
  }

  public const func GetDevicePS() -> ref<WeaponVendingMachineControllerPS> {
    return this.GetController().GetPS();
  }

  public const func DeterminGameplayRole() -> EGameplayRole {
    return EGameplayRole.Distract;
  }
}
