
public class Toilet extends InteractiveDevice {

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as ToiletController;
  }

  protected cb func OnFlush(evt: ref<Flush>) -> Bool {
    if evt.IsStarted() {
      GameObject.PlaySoundEvent(this, this.GetDevicePS().GetFlushSFX());
      GameObjectEffectHelper.StartEffectEvent(this, this.GetDevicePS().GetFlushVFX());
    } else {
      GameObjectEffectHelper.StopEffectEvent(this, this.GetDevicePS().GetFlushVFX());
    };
    this.UpdateDeviceState();
  }

  public const func GetDevicePS() -> ref<ToiletControllerPS> {
    return this.GetController().GetPS();
  }

  protected const func GetController() -> ref<ToiletController> {
    return this.m_controller as ToiletController;
  }

  public const func DeterminGameplayRole() -> EGameplayRole {
    return EGameplayRole.GenericRole;
  }
}
