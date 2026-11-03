
public class RoadBlockTrapController extends MasterController {

  public const func GetPS() -> ref<RoadBlockTrapControllerPS> {
    return this.GetBasePS() as RoadBlockTrapControllerPS;
  }
}

public class RoadBlockTrapControllerPS extends MasterControllerPS {

  protected func Initialize() -> Void {
    super.Initialize();
  }

  protected func OnRefreshSlavesEvent(evt: ref<RefreshSlavesEvent>) -> EntityNotificationType {
    this.RefreshSlaves();
    return EntityNotificationType.DoNotNotifyEntity;
  }

  public final func RefreshSlaves() -> Void {
    let i: Int32;
    let devices: array<ref<DeviceComponentPS>> = this.GetImmediateSlaves();
    let action: ref<ActivateDevice> = this.ActionActivateDevice();
    if this.IsActivated() {
      i = 0;
      while i < ArraySize(devices) {
        if IsDefined(devices[i] as RoadBlockControllerPS) {
          action.RegisterAsRequester(PersistentID.ExtractEntityID(this.GetID()));
          this.ExecutePSAction(action, devices[i]);
        };
        i = i + 1;
      };
      this.m_activationState = EActivationState.DEACTIVATED;
    };
  }

  protected func GetDeviceIconTweakDBID() -> TweakDBID {
    return t"DeviceIcons.DoorDeviceIcon";
  }

  protected func GetBackgroundTextureTweakDBID() -> TweakDBID {
    return t"DeviceIcons.DoorDeviceBackground";
  }
}
