
public class DoorSystemController extends BaseNetworkSystemController {

  public const func GetPS() -> ref<DoorSystemControllerPS> {
    return this.GetBasePS() as DoorSystemControllerPS;
  }
}

public class DoorSystemControllerPS extends BaseNetworkSystemControllerPS {

  protected cb func OnInstantiated() -> Bool {
    super.OnInstantiated();
    if !IsStringValid(this.m_deviceName) {
      this.m_deviceName = "Door System";
    };
  }

  protected func Initialize() -> Void {
    super.Initialize();
  }
}
