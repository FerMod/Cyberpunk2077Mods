
public class IceMachine extends VendingMachine {

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as IceMachineController;
  }

  public func GetVendorID() -> TweakDBID {
    return this.GetDevicePS().GetVendorTweakID();
  }

  protected func StopGlitching() -> Void {
    super.StopGlitching();
  }

  protected cb func OnDispenceItemFromVendor(evt: ref<DispenceItemFromVendor>) -> Bool {
    let i: Int32;
    let time: Float;
    if evt.IsStarted() {
      GameObject.PlaySoundEvent(this, this.GetDevicePS().GetProcessingSFX());
    } else {
      i = 0;
      while i < 5 {
        time += Cast<Float>(i) / 5.00;
        this.DelayVendingMachineEvent(time, true, true, evt.GetItemID());
        i += 1;
      };
      this.RefreshUI();
    };
  }

  protected cb func OnVendingMachineFinishedEvent(evt: ref<VendingMachineFinishedEvent>) -> Bool {
    if evt.isReady {
      this.GetDevicePS().SetIsReady(true);
    };
    this.DispenseItems(this.CreateDispenseRequest(!evt.isFree, evt.itemID));
    this.PlayItemFall();
    this.RefreshUI();
    this.GetDevicePS().GetDeviceOperationsContainer().Execute(n"ice_effect", this);
  }

  protected func HackedEffect() -> Void {
    let i: Int32 = 0;
    while i < this.GetDevicePS().GetHackedItemCount() {
      this.DelayVendingMachineEvent(Cast<Float>(i) / 5.00, true, false);
      i += 1;
    };
  }

  protected func PlayItemFall() -> Void {
    GameObject.PlaySoundEvent(this, this.GetDevicePS().GetIceFallSFX());
  }

  public const func GetDevicePS() -> ref<IceMachineControllerPS> {
    return this.GetController().GetPS();
  }

  private const func GetController() -> ref<IceMachineController> {
    return this.m_controller as IceMachineController;
  }

  public const func DeterminGameplayRole() -> EGameplayRole {
    return EGameplayRole.Distract;
  }
}
