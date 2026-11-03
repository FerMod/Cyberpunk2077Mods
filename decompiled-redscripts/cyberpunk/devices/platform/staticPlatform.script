
public class StaticPlatform extends InteractiveDevice {

  private const let m_componentsToToggleNames: [CName];

  private let m_meshName: CName;

  @runtimeProperty("customEditor", "AudioEvent")
  private let m_sfxOnEnable: CName;

  private let m_componentsToToggle: [ref<IComponent>];

  protected cb func OnGameAttached() -> Bool {
    super.OnGameAttached();
    if this.GetController().GetPS().IsTriggered() {
      this.SetVisualsAsActive();
    };
  }

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    let i: Int32;
    super.OnRequestComponents(ri);
    i = 0;
    while i < ArraySize(this.m_componentsToToggleNames) {
      EntityRequestComponentsInterface.RequestComponent(ri, this.m_componentsToToggleNames[i], n"IComponent", false);
      i += 1;
    };
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    let component: ref<IComponent>;
    let i: Int32;
    super.OnTakeControl(ri);
    i = 0;
    while i < ArraySize(this.m_componentsToToggleNames) {
      component = EntityResolveComponentsInterface.GetComponent(ri, this.m_componentsToToggleNames[i]);
      if IsDefined(component) {
        ArrayPush(this.m_componentsToToggle, component);
      };
      i += 1;
    };
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as StaticPlatformController;
  }

  private const func GetController() -> ref<StaticPlatformController> {
    return this.m_controller as StaticPlatformController;
  }

  protected cb func OnAreaEnter(evt: ref<AreaEnteredEvent>) -> Bool {
    let whoEntered: EntityID = EntityGameInterface.GetEntity(evt.activator).GetEntityID();
    if whoEntered == this.GetPlayerMainObject().GetEntityID() && !this.GetController().GetPS().IsTriggered() {
      this.GetController().GetPS().SetAsTriggered();
      this.SetVisualsAsActive();
      this.PlaySfx();
    };
  }

  private final func SetVisualsAsActive() -> Void {
    this.ActivateComponents();
    this.SetMeshAppearance(this.m_meshName);
  }

  private final func ActivateComponents() -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.m_componentsToToggle) {
      this.m_componentsToToggle[i].Toggle(true);
      i += 1;
    };
  }

  private final func PlaySfx() -> Void {
    GameObject.PlaySound(this, this.m_sfxOnEnable);
  }
}
