
public class BaseAnimatedDevice extends InteractiveDevice {

  @runtimeProperty("category", "AnimationSetup")
  @default(BaseAnimatedDevice, 2.0f)
  public let m_openingSpeed: Float;

  @runtimeProperty("category", "AnimationSetup")
  @default(BaseAnimatedDevice, 2.0f)
  public let m_closingSpeed: Float;

  protected let m_animationController: ref<AnimationControllerComponent>;

  protected let m_animFeature: ref<AnimFeature_RoadBlock>;

  protected edit let m_animationType: EAnimationType;

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
    EntityRequestComponentsInterface.RequestComponent(ri, n"animController", n"AnimationControllerComponent", false);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_animationController = EntityResolveComponentsInterface.GetComponent(ri, n"animController") as AnimationControllerComponent;
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as BaseAnimatedDeviceController;
  }

  protected func ResolveGameplayState() -> Void {
    super.ResolveGameplayState();
    if Equals(this.m_animationType, EAnimationType.REGULAR) {
      this.m_animFeature = new AnimFeature_RoadBlock();
      this.m_animFeature.initOpen = this.GetDevicePS().IsActive();
    };
    this.ActivateAnimation();
  }

  private const func GetController() -> ref<BaseAnimatedDeviceController> {
    return this.m_controller as BaseAnimatedDeviceController;
  }

  public const func GetDevicePS() -> ref<BaseAnimatedDeviceControllerPS> {
    return this.GetController().GetPS();
  }

  protected cb func OnQuickHackToggleActivate(evt: ref<QuickHackToggleActivate>) -> Bool {
    this.ActivateAnimation();
    this.UpdateDeviceState();
  }

  protected cb func OnActivateDevice(evt: ref<ActivateDevice>) -> Bool {
    this.ActivateAnimation();
    this.UpdateDeviceState();
  }

  protected cb func OnDeactivateDevice(evt: ref<DeactivateDevice>) -> Bool {
    this.ActivateAnimation();
    this.UpdateDeviceState();
  }

  protected func DeactivateDevice() -> Void {
    super.DeactivateDevice();
    this.m_animationController.Toggle(false);
  }

  protected func ActivateDevice() -> Void {
    super.ActivateDevice();
    this.m_animationController.Toggle(true);
  }

  protected func ActivateAnimation() -> Void {
    if Equals(this.m_animationType, EAnimationType.REGULAR) {
      this.Animate();
    } else {
      if Equals(this.m_animationType, EAnimationType.TRANSFORM) {
        this.InvokePlayAnimationEvent();
      };
    };
  }

  protected func Animate() -> Void {
    if this.GetDevicePS().IsActive() {
      this.m_animFeature.isOpening = true;
      this.m_animFeature.duration = this.m_openingSpeed;
    } else {
      this.m_animFeature.isOpening = false;
      this.m_animFeature.duration = this.m_closingSpeed;
    };
    AnimationControllerComponent.ApplyFeature(this, n"Road_block", this.m_animFeature);
  }

  private final func InvokePlayAnimationEvent() -> Void {
    let playEvent: ref<gameTransformAnimationPlayEvent> = new gameTransformAnimationPlayEvent();
    playEvent.looping = false;
    playEvent.timesPlayed = 1u;
    playEvent.timeScale = this.GetTimeScale();
    playEvent.animationName = this.GetCurrentAnimationName();
    this.QueueEvent(playEvent);
    this.OnPlayAnimation();
  }

  protected func GetTimeScale() -> Float {
    if this.GetDevicePS().Randomize() {
      return RandRangeF(0.80, 1.20);
    };
    return 1.00;
  }

  private final func GetCurrentAnimationName() -> CName {
    return this.GetDevicePS().IsActive() ? n"opening" : n"closing";
  }

  protected func OnPlayAnimation() -> Void;

  public const func DeterminGameplayRole() -> EGameplayRole {
    return EGameplayRole.ClearPath;
  }
}
