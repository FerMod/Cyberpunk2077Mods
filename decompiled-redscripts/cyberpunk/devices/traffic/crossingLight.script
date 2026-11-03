
public class CrossingLight extends TrafficLight {

  protected let m_audioLightIsGreen: Bool;

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as CrossingLightController;
  }

  private const func GetController() -> ref<CrossingLightController> {
    return this.m_controller as CrossingLightController;
  }

  public const func GetDevicePS() -> ref<CrossingLightControllerPS> {
    return this.GetController().GetPS();
  }

  protected func CommenceChangeToRed() -> Void {
    this.HandleRedLight(true);
    this.StartBlinking();
  }

  protected func CommenceChangeToGreen() -> Void {
    this.StartBlinking();
    this.HandleRedLight(true);
  }

  protected func CompleteLightChangeSequence() -> Void {
    this.StopBlinking();
    if Equals(this.m_lightState, worldTrafficLightColor.RED) {
      this.HandleRedLight(true);
      this.PlayTrafficNotificationSound(worldTrafficLightColor.RED);
    } else {
      if Equals(this.m_lightState, worldTrafficLightColor.GREEN) {
        this.HandleGreenLight(true);
        this.PlayTrafficNotificationSound(worldTrafficLightColor.GREEN);
      };
    };
  }

  protected final func PlayTrafficNotificationSound(status: worldTrafficLightColor) -> Void {
    if Equals(status, worldTrafficLightColor.RED) && this.m_audioLightIsGreen {
      GameObject.PlaySoundEvent(this, this.GetDevicePS().GetRedSFX());
      this.m_audioLightIsGreen = false;
    } else {
      if Equals(status, worldTrafficLightColor.GREEN) && !this.m_audioLightIsGreen {
        GameObject.PlaySoundEvent(this, this.GetDevicePS().GetGreenSFX());
        this.m_audioLightIsGreen = true;
      };
    };
  }

  private final func StartBlinking() -> Void {
    let evt: ref<ChangeCurveEvent> = new ChangeCurveEvent();
    evt.time = 1.00;
    evt.curve = n"blink_01";
    evt.loop = true;
    this.QueueEvent(evt);
  }

  private final func StopBlinking() -> Void {
    let evt: ref<ChangeCurveEvent> = new ChangeCurveEvent();
    evt.time = 1.00;
    evt.curve = n"None";
    evt.loop = false;
    this.QueueEvent(evt);
  }
}
