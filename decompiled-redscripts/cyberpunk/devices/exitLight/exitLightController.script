
public class ExitLightController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<ExitLightControllerPS> {
    return this.GetBasePS() as ExitLightControllerPS;
  }
}

public class ExitLightControllerPS extends ScriptableDeviceComponentPS {

  protected cb func OnInstantiated() -> Bool {
    super.OnInstantiated();
    if !IsStringValid(this.m_deviceName) {
      this.m_deviceName = "Light";
    };
  }

  protected func Initialize() -> Void {
    super.Initialize();
  }
}
