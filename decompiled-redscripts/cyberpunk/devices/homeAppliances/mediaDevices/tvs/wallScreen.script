
public class WallScreen extends TV {

  private let m_movementPattern: SMovementPattern;

  private let m_factOnFullyOpened: CName;

  private let m_objectMover: ref<ObjectMoverComponent>;

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    EntityRequestComponentsInterface.RequestComponent(ri, n"object_mover", n"ObjectMoverComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"tv", n"PhysicalMeshComponent", false);
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    this.m_objectMover = EntityResolveComponentsInterface.GetComponent(ri, n"object_mover") as ObjectMoverComponent;
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as WallScreenController;
  }

  private const func GetController() -> ref<WallScreenController> {
    return this.m_controller as WallScreenController;
  }

  public const func GetDevicePS() -> ref<WallScreenControllerPS> {
    return this.GetController().GetPS();
  }

  protected cb func OnMovementFinished(movementStatus: ref<ObjectMoverStatus>) -> Bool {
    if Equals(movementStatus.direction, this.m_movementPattern.direction) && IsNameValid(this.m_factOnFullyOpened) {
      SetFactValue(this.GetGame(), this.m_factOnFullyOpened, 1);
    };
    GameObject.PlaySoundEvent(this, n"dev_doors_hidden_stop");
  }

  protected cb func OnToggleSecureShow(evt: ref<ToggleShow>) -> Bool {
    if this.GetDevicePS().IsShown() {
      this.Move();
    } else {
      this.MoveBack();
    };
  }

  private final func Move() -> Void {
    this.UpdateDeviceState();
  }

  private final func MoveBack() -> Void {
    this.UpdateDeviceState();
  }
}
