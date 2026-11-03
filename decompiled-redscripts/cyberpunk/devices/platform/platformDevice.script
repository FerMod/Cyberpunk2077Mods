
public class PlatformDevice extends InteractiveDevice {

  private let m_movingPlatform: ref<MovingPlatform>;

  private let m_offMeshConnection: ref<OffMeshConnectionComponent>;

  public let m_StartAudioEvent: CName;

  public let m_StopAudioEvent: CName;

  public let m_MovingVFX: CName;

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
    EntityRequestComponentsInterface.RequestComponent(ri, n"movingPlatform", n"MovingPlatform", true);
    EntityRequestComponentsInterface.RequestComponent(ri, n"offMeshConnection", n"OffMeshConnectionComponent", true);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    this.m_movingPlatform = EntityResolveComponentsInterface.GetComponent(ri, n"movingPlatform") as MovingPlatform;
    this.m_offMeshConnection = EntityResolveComponentsInterface.GetComponent(ri, n"offMeshConnection") as OffMeshConnectionComponent;
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as PlatformController;
  }

  public func OnMaraudersMapDeviceDebug(sink: ref<MaraudersMapDevicesSink>) -> Void {
    super.OnMaraudersMapDeviceDebug(sink);
    sink.PushString("Error message", this.GetDevicePS().GetError());
  }

  protected const func GetController() -> ref<PlatformController> {
    return this.m_controller as PlatformController;
  }

  public const func GetDevicePS() -> ref<PlatformControllerPS> {
    return this.GetController().GetPS();
  }

  public final const func GetPosition() -> Vector4 {
    return this.GetWorldPosition();
  }

  protected func IsDeviceMovableScript() -> Bool {
    return true;
  }

  protected func ResolveGameplayState() -> Void {
    let markerPos: Vector4;
    let teleportEvent: ref<TeleportTo>;
    let transform: Transform;
    let platfPos: Vector4 = this.GetPosition() + this.m_movingPlatform.GetLocalPosition();
    let destNodeRef: GlobalNodeRef = ResolveNodeRefWithEntityID(this.GetDevicePS().GetDestinationNode(), this.GetEntityID());
    GameInstance.GetNodeTransform(this.GetGame(), destNodeRef, transform);
    markerPos = transform.position;
    if !this.m_movingPlatform.IsMoving() && NotEquals(platfPos, markerPos) && !this.GetDevicePS().IsPaused() {
      teleportEvent = new TeleportTo();
      teleportEvent.destinationNode = this.GetDevicePS().GetDestinationNode();
      this.QueueEvent(teleportEvent);
    };
    super.ResolveGameplayState();
  }

  private final func StartPostProductionEvents() -> Void {
    GameObject.PlaySoundEvent(this, this.m_StartAudioEvent);
    GameObjectEffectHelper.StartEffectEvent(this, this.m_MovingVFX);
  }

  private final func StopPostProductionEvents() -> Void {
    GameObject.PlaySoundEvent(this, this.m_StopAudioEvent);
    GameObjectEffectHelper.StopEffectEvent(this, this.m_MovingVFX);
    GameObject.StopSound(this, this.m_StartAudioEvent);
  }

  protected final func MoveToMarker(destination: NodeRef) -> Void {
    let moveToEvent: ref<MoveTo> = new MoveTo();
    let dynamicMov: ref<MovingPlatformMovementDynamic> = new MovingPlatformMovementDynamic();
    dynamicMov.curveName = this.GetDevicePS().GetCurveName();
    dynamicMov.SetInitData(gameMovingPlatformMovementInitializationType.Speed, this.GetDevicePS().GetSpeed());
    dynamicMov.SetDestinationNode(destination);
    moveToEvent.movement = dynamicMov;
    this.StartPostProductionEvents();
    this.QueueEvent(moveToEvent);
  }

  protected final func Pause() -> Void {
    this.StopPostProductionEvents();
    this.GetDevicePS().SetPauseTime(this.m_movingPlatform.Pause());
  }

  protected final func Resume(time: Float) -> Void {
    this.StartPostProductionEvents();
    this.m_movingPlatform.Unpause(time);
  }

  protected cb func OnArrivedAt(evt: ref<ArrivedAt>) -> Bool {
    this.StopPostProductionEvents();
    this.SendEventToDefaultPS(evt);
  }

  protected cb func OnMovementChange(evt: ref<MovementStateChanged>) -> Bool {
    this.GetDevicePS().SetIsMoving(evt.isMoving);
    this.SendEventToDefaultPS(evt);
  }

  protected cb func OnAreaEnter(evt: ref<AreaEnteredEvent>) -> Bool {
    let activator: wref<GameObject> = EntityGameInterface.GetEntity(evt.activator) as GameObject;
    if activator.IsPlayer() {
      super.OnAreaEnter(evt);
      this.GetDevicePS().SetPlayerOnPlatform(true);
    };
  }

  protected cb func OnAreaExit(evt: ref<AreaExitedEvent>) -> Bool {
    let activator: wref<GameObject> = EntityGameInterface.GetEntity(evt.activator) as GameObject;
    if activator.IsPlayer() {
      super.OnAreaExit(evt);
      this.GetDevicePS().SetPlayerOnPlatform(false);
    };
  }

  protected cb func OnDetach() -> Bool {
    super.OnDetach();
    this.GetDevicePS().SetPlayerOnPlatform(false);
  }

  protected cb func OnQuestMoveToFloor(evt: ref<QuestMoveToFloor>) -> Bool {
    this.MoveToMarker(this.GetDevicePS().GetDestinationNode());
  }

  protected cb func OnTeleport(evt: ref<TeleportTo>) -> Bool {
    this.GetDevicePS().SetIsMoving(false);
  }

  protected cb func OnMoveNext(evt: ref<QuestMoveToNextFloor>) -> Bool {
    this.MoveToMarker(evt.floor);
  }

  protected cb func OnMovePrev(evt: ref<QuestMoveToPrevFloor>) -> Bool {
    this.MoveToMarker(evt.floor);
  }

  protected cb func OnQuestPause(evt: ref<QuestPause>) -> Bool {
    this.Pause();
  }

  protected cb func OnQuestResume(evt: ref<QuestResume>) -> Bool {
    this.Resume(this.GetDevicePS().GetResumeTime());
  }
}
