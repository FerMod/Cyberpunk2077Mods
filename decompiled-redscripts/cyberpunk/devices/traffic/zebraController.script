
public class TrafficZebraController extends TrafficLightController {

  public const func GetPS() -> ref<TrafficZebraControllerPS> {
    return this.GetBasePS() as TrafficZebraControllerPS;
  }
}

public class TrafficZebraControllerPS extends TrafficLightControllerPS {

  protected cb func OnInstantiated() -> Bool {
    super.OnInstantiated();
    if !IsStringValid(this.m_deviceName) {
      this.m_deviceName = "Gameplay-Devices-DisplayNames-Zebra";
    };
  }

  protected func Initialize() -> Void {
    super.Initialize();
  }

  protected func GameAttached() -> Void {
    super.GameAttached();
  }
}
