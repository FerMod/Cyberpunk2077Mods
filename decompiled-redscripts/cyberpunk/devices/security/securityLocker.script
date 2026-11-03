
public class SecurityLocker extends InteractiveDevice {

  private let m_cachedEvent: ref<UseSecurityLocker>;

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
    EntityRequestComponentsInterface.RequestComponent(ri, n"inventory", n"gameInventory", true);
    EntityRequestComponentsInterface.RequestComponent(ri, n"ui", n"AdvertisementWidgetComponent", false);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    this.m_uiComponent = EntityResolveComponentsInterface.GetComponent(ri, n"ui") as IWorldWidgetComponent;
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as SecurityLockerController;
  }

  public const func GetDevicePS() -> ref<SecurityLockerControllerPS> {
    return this.GetController().GetPS();
  }

  private const func GetController() -> ref<SecurityLockerController> {
    return this.m_controller as SecurityLockerController;
  }

  protected func CutPower() -> Void {
    super.CutPower();
    this.TurnOffScreen();
  }

  protected func TurnOnDevice() -> Void {
    super.TurnOnDevice();
    this.TurnOnScreen();
  }

  protected func TurnOffDevice() -> Void {
    super.TurnOffDevice();
    this.TurnOffScreen();
  }

  private final func TurnOffScreen() -> Void {
    if this.m_uiComponent != null {
      this.m_uiComponent.Toggle(false);
    };
  }

  private final func TurnOnScreen() -> Void {
    if this.m_uiComponent != null {
      this.m_uiComponent.Toggle(true);
    };
  }

  protected cb func OnUseSecurityLocker(evt: ref<UseSecurityLocker>) -> Bool {
    this.m_cachedEvent = evt;
    if !FromVariant<Bool>(evt.prop.first) {
      this.DisarmUser(evt);
    } else {
      this.ReturnArms(evt);
    };
  }

  protected cb func OnDisarm(evt: ref<Disarm>) -> Bool {
    if this.GetDevicePS().ShouldDisableCyberware() {
      this.ActivateCyberwere(false);
    };
    if this.GetDevicePS().IsPartOfSystem(ESystems.SecuritySystem) {
      this.GetDevicePS().GetSecuritySystem().AuthorizeUser(evt.requester.GetEntityID(), this.GetDevicePS().GetAuthorizationLevel());
    };
  }

  private final func DisarmUser(evt: ref<UseSecurityLocker>) -> Void {
    let disarm: ref<Disarm>;
    if !IsDefined(evt.GetExecutor()) {
      return;
    };
    disarm = new Disarm();
    disarm.requester = this;
    evt.GetExecutor().QueueEvent(disarm);
    GameObject.PlaySoundEvent(this, this.GetDevicePS().GetStoreSFX());
  }

  private final func ReturnArms(evt: ref<UseSecurityLocker>) -> Void {
    let arm: ref<Arm> = new Arm();
    arm.requester = this;
    evt.GetExecutor().QueueEvent(arm);
    if this.GetDevicePS().ShouldDisableCyberware() {
      this.ActivateCyberwere(true);
    };
    GameObject.PlaySoundEvent(this, this.GetDevicePS().GetReturnSFX());
  }

  private final func TransferItems(const items: script_ref<[wref<gameItemData>]>, from: ref<GameObject>, to: ref<GameObject>) -> Void {
    let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
    let i: Int32 = 0;
    while i < ArraySize(Deref(items)) {
      if !IsFinal() {
      };
      transactionSystem.TransferItem(from, to, Deref(items)[i].GetID(), Deref(items)[i].GetQuantity());
      i += 1;
    };
  }

  private final func ActivateCyberwere(activate: Bool) -> Void {
    let noCyberware: TweakDBID = t"GameplayRestriction.SecurityLocker";
    let obj: wref<GameObject> = this.m_cachedEvent.GetExecutor();
    if IsDefined(obj) && TDBID.IsValid(noCyberware) {
      if activate {
        StatusEffectHelper.RemoveStatusEffect(obj, noCyberware);
      } else {
        StatusEffectHelper.ApplyStatusEffect(obj, noCyberware);
      };
      this.GetDevicePS().DisconnectPersonalLink(this.m_cachedEvent);
    };
  }

  public const func DeterminGameplayRole() -> EGameplayRole {
    return EGameplayRole.ServicePoint;
  }
}
