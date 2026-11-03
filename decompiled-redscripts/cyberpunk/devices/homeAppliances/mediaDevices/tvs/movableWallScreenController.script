
public class MovableWallScreenController extends DoorController {

  public const func GetPS() -> ref<MovableWallScreenControllerPS> {
    return this.GetBasePS() as MovableWallScreenControllerPS;
  }
}

public class MovableWallScreenControllerPS extends DoorControllerPS {

  protected cb func OnInstantiated() -> Bool {
    super.OnInstantiated();
    if !IsStringValid(this.m_deviceName) {
      this.m_deviceName = "MovableWallScreen";
    };
  }

  protected func Initialize() -> Void {
    super.Initialize();
  }

  public func GetDeviceIconPath() -> String {
    return "base/gameplay/gui/brushes/devices/icon_tv.widgetbrush";
  }
}
