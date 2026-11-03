
public class RoboticArms extends InteractiveDevice {

  @runtimeProperty("category", "SFX")
  @runtimeProperty("customEditor", "AudioEvent")
  public let m_workSFX: CName;

  @runtimeProperty("category", "SFX")
  @runtimeProperty("customEditor", "AudioEvent")
  public let m_distractSFX: CName;

  private let m_animationController: ref<AnimationControllerComponent>;

  private let m_animFeature: ref<AnimFeature_RoboticArm>;

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    EntityRequestComponentsInterface.RequestComponent(ri, n"audio", n"soundComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"animController", n"AnimationControllerComponent", false);
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_animationController = EntityResolveComponentsInterface.GetComponent(ri, n"animController") as AnimationControllerComponent;
    if !IsDefined(this.m_animationController) {
    };
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as RoboticArmsController;
  }

  public const func DeterminGameplayRole() -> EGameplayRole {
    return EGameplayRole.Distract;
  }

  protected func ResolveGameplayState() -> Void {
    super.ResolveGameplayState();
    this.m_animFeature = new AnimFeature_RoboticArm();
    this.SetWorkState();
  }

  protected cb func OnQuickHackDistraction(evt: ref<QuickHackDistraction>) -> Bool {
    if evt.IsStarted() {
      this.SetDistractState();
    } else {
      this.SetWorkState();
    };
  }

  private final func SetDistractState() -> Void {
    this.StopWorkSFX();
    this.PlayDistractSFX();
    this.SetAnimationState(RoboticArmStateType.Distract);
  }

  private final func SetWorkState() -> Void {
    this.StopDistractSFX();
    this.PlayWorkSFX();
    this.SetAnimationState(RoboticArmStateType.Work);
  }

  private final func SetAnimationState(state: RoboticArmStateType) -> Void {
    this.m_animFeature.state = EnumInt(state);
    AnimationControllerComponent.ApplyFeature(this, n"Robotic_arm", this.m_animFeature);
  }

  private final func PlayWorkSFX() -> Void {
    GameObject.PlaySound(this, this.m_workSFX);
  }

  private final func StopWorkSFX() -> Void {
    GameObject.StopSound(this, this.m_workSFX);
  }

  private final func PlayDistractSFX() -> Void {
    GameObject.PlaySound(this, this.m_distractSFX);
  }

  private final func StopDistractSFX() -> Void {
    GameObject.StopSound(this, this.m_distractSFX);
  }
}
