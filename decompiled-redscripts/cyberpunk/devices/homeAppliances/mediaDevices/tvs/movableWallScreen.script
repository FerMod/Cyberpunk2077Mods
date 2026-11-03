
public class MovableWallScreen extends Door {

  private edit let m_animationLength: Float;

  private let m_animFeature: ref<AnimFeature_SimpleDevice>;

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    EntityRequestComponentsInterface.RequestComponent(ri, n"animController", n"AnimationControllerComponent", false);
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as MovableWallScreenController;
  }

  protected cb func OnGameAttached() -> Bool {
    super.OnGameAttached();
    this.UpdateAnimState();
  }

  private const func GetController() -> ref<MovableWallScreenController> {
    return this.m_controller as MovableWallScreenController;
  }

  public const func GetDevicePS() -> ref<MovableWallScreenControllerPS> {
    return this.GetController().GetPS();
  }

  protected cb func OnToggleOpen(evt: ref<ToggleOpen>) -> Bool {
    if this.GetDevicePS().IsOpen() {
    };
    this.UpdateAnimState();
    this.PlaySounds();
  }

  private final func UpdateAnimState() -> Void {
    if !IsDefined(this.m_animFeature) {
      this.m_animFeature = new AnimFeature_SimpleDevice();
    };
    this.m_animFeature.isOpen = false;
    if this.GetDevicePS().IsOpen() {
      this.m_animFeature.isOpen = true;
    };
    AnimationControllerComponent.ApplyFeature(this, n"DeviceMovableWallScreen", this.m_animFeature);
  }

  private final func PlaySounds() -> Void {
    if this.GetDevicePS().IsOpen() {
      GameObject.PlaySoundEvent(this, n"dev_doors_v_room_secret_open");
    } else {
      GameObject.PlaySoundEvent(this, n"dev_doors_v_room_secret_close");
    };
  }

  protected final func SetQuestFact(factName: CName) -> Void {
    if IsNameValid(factName) {
      SetFactValue(this.GetGame(), factName, 1);
    };
  }

  protected cb func OnSecretOpenAnimationEvent(evt: ref<SecretOpenAnimationEvent>) -> Bool;
}
