
public class PersonnelSystemController extends DeviceSystemBaseController {

  public const func GetPS() -> ref<PersonnelSystemControllerPS> {
    return this.GetBasePS() as PersonnelSystemControllerPS;
  }
}

public class PersonnelSystemControllerPS extends DeviceSystemBaseControllerPS {

  protected cb func OnInstantiated() -> Bool {
    super.OnInstantiated();
    if !IsStringValid(this.m_deviceName) {
      this.m_deviceName = "Personnel System";
    };
  }

  protected func Initialize() -> Void {
    super.Initialize();
  }
}
