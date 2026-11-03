
public class RetractableAd extends BaseAnimatedDevice {

  protected let m_offMeshConnection: ref<OffMeshConnectionComponent>;

  protected let m_areaComponent: ref<TriggerComponent>;

  protected let m_advUiComponent: ref<IComponent>;

  protected let m_isPartOfTheTrap: Bool;

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
    EntityRequestComponentsInterface.RequestComponent(ri, n"offMeshConnection", n"OffMeshConnectionComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"ui", n"AdvertisementWidgetComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"area", n"TriggerComponent", false);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_offMeshConnection = EntityResolveComponentsInterface.GetComponent(ri, n"offMeshConnection") as OffMeshConnectionComponent;
    this.m_advUiComponent = EntityResolveComponentsInterface.GetComponent(ri, n"ui");
    this.m_areaComponent = EntityResolveComponentsInterface.GetComponent(ri, n"area") as TriggerComponent;
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as RetractableAdController;
  }

  protected cb func OnActivateDevice(evt: ref<ActivateDevice>) -> Bool {
    super.OnActivateDevice(evt);
    if this.GetDevicePS().IsConnected() {
      this.m_isPartOfTheTrap = true;
    };
  }

  protected func ActivateAnimation() -> Void {
    let count: array<ref<Entity>> = this.GetEntitiesInArea();
    if this.GetDevicePS().IsActive() && ArraySize(count) > 0 {
      this.ApplyImpulse(count);
    };
    super.ActivateAnimation();
  }

  protected func OnPlayAnimation() -> Void {
    if this.GetDevicePS().IsNotActive() {
      this.m_gameplayRoleComponent.ToggleMappin(gamedataMappinVariant.HazardWarningVariant, false);
      this.ToggleOffMeshConnection(true);
      this.ToggleLights(false);
    } else {
      this.m_gameplayRoleComponent.ToggleMappin(gamedataMappinVariant.HazardWarningVariant, true, true);
      this.ToggleOffMeshConnection(false);
      this.ToggleLights(true);
    };
  }

  protected func GetTimeScale() -> Float {
    if this.m_isPartOfTheTrap {
      return 0.70;
    };
    return super.GetTimeScale();
  }

  protected final func ToggleOffMeshConnection(toggle: Bool) -> Void {
    if IsDefined(this.m_offMeshConnection) {
      if toggle {
        this.m_offMeshConnection.EnableOffMeshConnection();
        this.m_offMeshConnection.EnableForPlayer();
      } else {
        this.m_offMeshConnection.DisableOffMeshConnection();
        this.m_offMeshConnection.DisableForPlayer();
      };
    };
  }

  protected final func ToggleLights(toggle: Bool) -> Void {
    let lightEvent: ref<ToggleLightEvent> = new ToggleLightEvent();
    lightEvent.toggle = toggle;
    this.QueueEvent(lightEvent);
  }

  protected cb func OnPhysicalDestructionEvent(evt: ref<PhysicalDestructionEvent>) -> Bool {
    if Equals(evt.componentName, n"destructible_glass") && evt.levelOfDestruction == 1u {
      this.m_gameplayRoleComponent.ToggleMappin(gamedataMappinVariant.HazardWarningVariant, false);
      this.DisableTrap();
    } else {
      this.GetDevicePS().ForceDisableDevice();
    };
  }

  protected final func DisableTrap() -> Void {
    let trap: ref<RoadBlockTrapControllerPS>;
    if this.GetDevicePS().IsConnected() {
      trap = this.GetDevicePS().GetTrapController();
      trap.ForceDisableDevice();
    };
  }

  public final const func GetEntitiesInArea() -> [ref<Entity>] {
    return this.m_areaComponent.GetOverlappingEntities();
  }

  protected func StartGlitching(glitchState: EGlitchState, opt intensity: Float) -> Void {
    let evt: ref<AdvertGlitchEvent> = new AdvertGlitchEvent();
    evt.SetShouldGlitch(1.00);
    this.QueueEvent(evt);
    this.UpdateDeviceState();
  }

  protected func StopGlitching() -> Void {
    let evt: ref<AdvertGlitchEvent> = new AdvertGlitchEvent();
    evt.SetShouldGlitch(0.00);
    this.QueueEvent(evt);
  }

  private final func ApplyImpulse(const activators: script_ref<[ref<Entity>]>) -> Void {
    let activatorPosition: Vector4;
    let deviceForward: Vector4;
    let devicePosition: Vector4;
    let direction: Vector4;
    let ev: ref<PSMImpulse>;
    let i: Int32;
    let impulsMultiplier: Float;
    let impulseInLocalSpace: Vector4;
    if this.m_isPartOfTheTrap {
      return;
    };
    devicePosition = this.GetWorldPosition();
    deviceForward = this.GetWorldForward();
    impulsMultiplier = TDB.GetFloat(t"player.externalImpules.bilboard");
    i = 0;
    while i < ArraySize(Deref(activators)) {
      ev = new PSMImpulse();
      ev.id = n"impulse";
      activatorPosition = Deref(activators)[i].GetWorldPosition();
      direction = activatorPosition - devicePosition;
      if Vector4.Dot(direction, deviceForward) < 0.00 {
        deviceForward = -deviceForward;
      };
      impulseInLocalSpace = deviceForward * impulsMultiplier;
      ev.impulse = impulseInLocalSpace;
      Deref(activators)[i].QueueEvent(ev);
      i += 1;
    };
  }

  protected cb func OnAreaEnter(evt: ref<AreaEnteredEvent>) -> Bool {
    let activator: wref<GameObject>;
    if this.GetDevicePS().IsDisabled() || this.GetDevicePS().IsUnpowered() {
      return false;
    };
    activator = EntityGameInterface.GetEntity(evt.activator) as GameObject;
    if activator.IsPlayer() && this.GetDevicePS().IsActivated() && Equals(evt.componentName, n"areaTop") {
      GameInstance.GetPersistencySystem(this.GetGame()).QueuePSEvent(this.GetDevicePS().GetID(), this.GetDevicePS().GetClassName(), this.GetDevicePS().ActionDeactivateDevice());
    };
  }

  private const func GetController() -> ref<RetractableAdController> {
    return this.m_controller as RetractableAdController;
  }

  public const func GetDevicePS() -> ref<RetractableAdControllerPS> {
    return this.GetController().GetPS();
  }
}
