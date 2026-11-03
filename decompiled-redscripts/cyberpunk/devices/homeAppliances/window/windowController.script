
public class WindowController extends DoorController {

  public const func GetPS() -> ref<WindowControllerPS> {
    return this.GetBasePS() as WindowControllerPS;
  }
}

public class WindowControllerPS extends DoorControllerPS {

  private inline let m_windowSkillChecks: ref<EngDemoContainer>;

  protected cb func OnInstantiated() -> Bool {
    super.OnInstantiated();
    if !IsStringValid(this.m_deviceName) {
      this.m_deviceName = "LocKey#78";
    };
    this.m_doorProperties.m_automaticallyClosesItself = false;
  }

  protected func GetSkillCheckContainerForSetup() -> ref<BaseSkillCheckContainer> {
    return this.m_windowSkillChecks;
  }

  protected func GameAttached() -> Void;

  public func GetDeviceIconPath() -> String {
    return "base/gameplay/gui/brushes/devices/icon_door.widgetbrush";
  }

  protected func OnActionDemolition(evt: ref<ActionDemolition>) -> EntityNotificationType {
    if !evt.WasPassed() {
      return EntityNotificationType.DoNotNotifyEntity;
    };
    super.OnActionDemolition(evt);
    if evt.IsCompleted() {
      this.OnForceOpen(this.ActionForceOpen());
      this.DisableDevice();
    };
    return EntityNotificationType.SendThisEventToEntity;
  }

  protected func GetDeviceIconTweakDBID() -> TweakDBID {
    return t"DeviceIcons.DoorDeviceIcon";
  }

  protected func GetBackgroundTextureTweakDBID() -> TweakDBID {
    return t"DeviceIcons.DoorDeviceBackground";
  }
}
