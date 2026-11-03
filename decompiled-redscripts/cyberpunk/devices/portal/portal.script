
public class Portal extends InteractiveDevice {

  @runtimeProperty("category", "Portal Setup")
  private let m_exitNode: NodeRef;

  @runtimeProperty("category", "Portal Setup")
  private let m_LinkedPortal: NodeRef;

  protected let m_renderToTextureComponent: wref<IPlacedComponent>;

  protected let m_virtualCameraComponent: wref<IPlacedComponent>;

  protected let m_isInStreamRange: Bool;

  protected let m_isInTeleportRange: Bool;

  protected let m_isOnOtherSide: Bool;

  protected let m_playerBlocker: wref<IPlacedComponent>;

  protected let m_screen: wref<MeshComponent>;

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    EntityRequestComponentsInterface.RequestComponent(ri, n"stream_view_ui", n"worlduiWidgetComponent", true);
    EntityRequestComponentsInterface.RequestComponent(ri, n"render_to_texture_component", n"entRenderToTextureCameraComponent", true);
    EntityRequestComponentsInterface.RequestComponent(ri, n"virtual_camera_portal", n"entVirtualCameraComponent", true);
    EntityRequestComponentsInterface.RequestComponent(ri, n"player_blocker", n"SimpleColliderComponent", true);
    EntityRequestComponentsInterface.RequestComponent(ri, n"stream_video_screen", n"MeshComponent", true);
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    this.m_uiComponent = EntityResolveComponentsInterface.GetComponent(ri, n"stream_view_ui") as worlduiWidgetComponent;
    this.m_renderToTextureComponent = EntityResolveComponentsInterface.GetComponent(ri, n"render_to_texture_component") as IPlacedComponent;
    this.m_virtualCameraComponent = EntityResolveComponentsInterface.GetComponent(ri, n"virtual_camera_portal") as IPlacedComponent;
    this.m_playerBlocker = EntityResolveComponentsInterface.GetComponent(ri, n"player_blocker") as IPlacedComponent;
    this.m_screen = EntityResolveComponentsInterface.GetComponent(ri, n"stream_video_screen") as MeshComponent;
    this.m_playerBlocker.Toggle(false);
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as PortalController;
  }

  protected cb func OnAreaEnter(evt: ref<AreaEnteredEvent>) -> Bool {
    if Equals(evt.componentName, n"other_side") {
      this.m_isOnOtherSide = true;
    } else {
      if Equals(evt.componentName, n"activate_stream") {
        this.m_isInStreamRange = true;
        if !this.m_isInTeleportRange {
          this.m_isOnOtherSide = false;
        };
        if this.GetDevicePS().IsON() {
          this.TurnOnScreen();
        };
      } else {
        if Equals(evt.componentName, n"teleport") {
          this.m_isInTeleportRange = true;
          if !this.m_isOnOtherSide && this.GetDevicePS().IsON() {
            this.TeleportPlayerToLinkedPortal();
          };
        };
      };
    };
  }

  protected cb func OnAreaExit(evt: ref<AreaExitedEvent>) -> Bool {
    if Equals(evt.componentName, n"activate_stream") {
      if this.GetDevicePS().IsON() {
        this.TurnOffScreen();
      };
      this.m_isInStreamRange = false;
    } else {
      if Equals(evt.componentName, n"teleport") {
        this.m_isInTeleportRange = false;
        this.m_isOnOtherSide = false;
      };
    };
  }

  private final func ToggleStream(activate: Bool) -> Void {
    this.m_virtualCameraComponent.Toggle(activate);
    this.m_renderToTextureComponent.Toggle(activate);
    this.TurnOffScreen();
  }

  private final func ToggleStreamOnLinkedPortal(activate: Bool) -> Void {
    let evt: ref<ToggleStreamOnLinkedPortalEvent>;
    let gNodeRef: GlobalNodeRef = ResolveNodeRefWithEntityID(this.m_LinkedPortal, this.GetEntityID());
    if GlobalNodeRef.IsDefined(gNodeRef) {
      this.m_virtualCameraComponent.Toggle(false);
      evt = new ToggleStreamOnLinkedPortalEvent();
      evt.m_activate = activate;
      this.QueueEventForNodeID(gNodeRef, evt);
    };
  }

  protected cb func OnToggleStreamOnLinkedPortal(evt: ref<ToggleStreamOnLinkedPortalEvent>) -> Bool {
    this.ToggleStream(evt.m_activate);
  }

  private final func TeleportToExitNode() -> Void {
    let nodeTransform: Transform;
    let position: Vector4;
    let rotation: EulerAngles;
    let globalRef: GlobalNodeRef = ResolveNodeRefWithEntityID(this.m_exitNode, this.GetEntityID());
    if GlobalNodeRef.IsDefined(globalRef) {
      GameInstance.GetNodeTransform(this.GetGame(), globalRef, nodeTransform);
      position = Transform.GetPosition(nodeTransform);
      rotation = Quaternion.ToEulerAngles(Transform.GetOrientation(nodeTransform));
      GameInstance.GetTeleportationFacility(this.GetGame()).Teleport(GetPlayer(this.GetGame()), position, rotation);
    };
  }

  private final func TeleportPlayerToLinkedPortal() -> Void {
    let evt: ref<TeleportToLinkedPortalEvent>;
    let gNodeRef: GlobalNodeRef = ResolveNodeRefWithEntityID(this.m_LinkedPortal, this.GetEntityID());
    if GlobalNodeRef.IsDefined(gNodeRef) {
      evt = new TeleportToLinkedPortalEvent();
      this.QueueEventForNodeID(gNodeRef, evt);
    };
  }

  protected cb func OnTeleportToLinkedPortalEvent(evt: ref<TeleportToLinkedPortalEvent>) -> Bool {
    this.TeleportToExitNode();
  }

  protected const func GetController() -> ref<ScriptableDeviceComponent> {
    return this.m_controller;
  }

  public const func GetDevicePS() -> ref<ScriptableDeviceComponentPS> {
    return this.GetController().GetPS();
  }

  protected cb func OnLogicReady(evt: ref<SetLogicReadyEvent>) -> Bool {
    super.OnLogicReady(evt);
    if this.IsUIdirty() && this.m_isInsideLogicArea {
      this.RefreshUI();
    };
  }

  protected func CutPower() -> Void {
    super.CutPower();
    this.TurnOffScreen();
  }

  protected func TurnOffDevice() -> Void {
    super.TurnOffDevice();
    this.TurnOffScreen();
  }

  protected func TurnOnDevice() -> Void {
    super.TurnOnDevice();
    this.TurnOnScreen();
  }

  protected func DeactivateDevice() -> Void {
    super.DeactivateDevice();
    this.ToggleLogicLayer(false);
  }

  protected func ActivateDevice() -> Void {
    super.ActivateDevice();
    this.ToggleLogicLayer(true);
  }

  protected final func TurnOffScreen() -> Void {
    this.m_screen.Toggle(false);
    if IsDefined(this.m_uiComponent) {
      this.m_uiComponent.Toggle(false);
    };
    if this.m_isInStreamRange {
      this.ToggleStreamOnLinkedPortal(false);
    };
    this.m_playerBlocker.Toggle(false);
  }

  protected final func TurnOnScreen() -> Void {
    let gNodeRef: GlobalNodeRef;
    if !this.m_isInStreamRange {
      this.m_screen.Toggle(false);
      this.m_uiComponent.Toggle(false);
      return;
    };
    gNodeRef = ResolveNodeRefWithEntityID(this.m_LinkedPortal, this.GetEntityID());
    if !GlobalNodeRef.IsDefined(gNodeRef) {
      this.m_screen.Toggle(false);
      this.m_uiComponent.Toggle(false);
      return;
    };
    if IsDefined(this.m_uiComponent) {
      this.m_screen.Toggle(true);
      this.m_uiComponent.Toggle(true);
    };
    this.ToggleStreamOnLinkedPortal(true);
    this.m_playerBlocker.Toggle(true);
    if this.m_isInTeleportRange && !this.m_isOnOtherSide {
      this.TeleportPlayerToLinkedPortal();
    };
  }
}
