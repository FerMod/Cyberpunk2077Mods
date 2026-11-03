
public class CrossingLightController extends TrafficLightController {

  public const func GetPS() -> ref<CrossingLightControllerPS> {
    return this.GetBasePS() as CrossingLightControllerPS;
  }
}

public class CrossingLightControllerPS extends TrafficLightControllerPS {

  protected let m_crossingLightSFXSetup: CrossingLightSetup;

  protected cb func OnInstantiated() -> Bool {
    super.OnInstantiated();
  }

  protected func Initialize() -> Void {
    super.Initialize();
  }

  protected func GameAttached() -> Void {
    super.GameAttached();
  }

  public final func GetGreenSFX() -> CName {
    return this.m_crossingLightSFXSetup.m_greenLightSFX;
  }

  public final func GetRedSFX() -> CName {
    return this.m_crossingLightSFXSetup.m_redLightSFX;
  }
}
