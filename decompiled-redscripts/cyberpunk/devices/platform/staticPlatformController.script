
public class StaticPlatformController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<StaticPlatformControllerPS> {
    return this.GetBasePS() as StaticPlatformControllerPS;
  }
}

public class StaticPlatformControllerPS extends ScriptableDeviceComponentPS {

  private persistent let m_isTriggered: Bool;

  public final func IsTriggered() -> Bool {
    return this.m_isTriggered;
  }

  public final func SetAsTriggered() -> Void {
    this.m_isTriggered = true;
  }
}
