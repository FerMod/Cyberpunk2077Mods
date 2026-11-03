
public class PerkTraining extends InteractiveDevice {

  @runtimeProperty("category", "Progress Bar config")
  private edit let m_progressBarHeaderText: String;

  @runtimeProperty("category", "Progress Bar config")
  private edit let m_progressBarBottomText: String;

  @runtimeProperty("category", "Pulsing FX")
  @runtimeProperty("customEditor", "AudioEvent")
  private edit let m_pulsingEndSoundName: CName;

  private let m_animFeature: ref<AnimFeature_PerkDeviceData>;

  private let m_uiSlots: ref<SlotComponent>;

  protected cb func OnGameAttached() -> Bool {
    super.OnGameAttached();
    this.TryShowMappin();
    this.UpdatePulsingEffects();
    this.SetInitialAnimationState();
  }

  private final func SetInitialAnimationState() -> Void {
    this.m_animFeature.isUsed = this.GetDevicePS().IsPerkGranted();
    AnimationControllerComponent.ApplyFeature(this, n"PerkDeviceData", this.m_animFeature);
  }

  protected cb func OnDetach() -> Bool {
    super.OnDetach();
    GameObjectEffectHelper.StopEffectEvent(this, this.GetLightsEffectName());
  }

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    EntityRequestComponentsInterface.RequestComponent(ri, n"SlotComponent", n"UI_Slots", false);
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_uiSlots = EntityResolveComponentsInterface.GetComponent(ri, n"UI_Slots") as SlotComponent;
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as PerkTrainingController;
    this.m_animFeature = new AnimFeature_PerkDeviceData();
  }

  protected cb func OnAreaEnter(evt: ref<AreaEnteredEvent>) -> Bool {
    if this.IsTriggeredByPlayer(evt) {
      this.GetDevicePS().SetDeviceAsDetected();
      this.TryShowMappin();
    };
  }

  private final func UpdatePulsingEffects() -> Void {
    if !this.GetDevicePS().IsPerkGranted() {
      GameObjectEffectHelper.StartEffectEvent(this, this.GetLightsEffectName());
    } else {
      GameObjectEffectHelper.StopEffectEvent(this, this.GetLightsEffectName());
    };
  }

  private final func GetLightsEffectName() -> CName {
    return n"animated_lights";
  }

  private final func TryShowMappin() -> Void {
    if this.GetDevicePS().WasDetected() && !this.GetDevicePS().IsPerkGranted() {
      this.ShowMappin();
    };
  }

  private final func IsTriggeredByPlayer(evt: ref<TriggerEvent>) -> Bool {
    let obj: ref<GameObject> = EntityGameInterface.GetEntity(evt.activator) as GameObject;
    return obj.IsPlayer();
  }

  private final func ShowMappin() -> Void {
    let request: ref<RegisterPerkDeviceMappinRequest> = new RegisterPerkDeviceMappinRequest();
    request.m_ownerID = this.GetEntityID();
    request.m_position = this.GetSlotPosition();
    this.GetPerkSystem().QueueRequest(request);
  }

  private final func GetSlotPosition() -> Vector4 {
    let worldTransform: WorldTransform;
    this.m_uiSlots.GetSlotTransform(n"roleMappin", worldTransform);
    return WorldPosition.ToVector4(WorldTransform.GetWorldPosition(worldTransform));
  }

  private final const func GetPerkSystem() -> ref<RelicPerkSystem> {
    return GameInstance.GetScriptableSystemsContainer(this.GetGame()).Get(n"RelicPerkSystem") as RelicPerkSystem;
  }

  protected cb func OnConnectionEnded(evt: ref<ConnectionEndedEvent>) -> Bool {
    if this.GetDevicePS().IsPerkGranted() {
      this.HideMappin();
    };
  }

  private final func HideMappin() -> Void {
    let request: ref<SetPerkDeviceAsUsedRequest> = new SetPerkDeviceAsUsedRequest();
    request.m_ownerID = this.GetEntityID();
    this.GetPerkSystem().QueueRequest(request);
  }

  public const func GetDevicePS() -> ref<PerkTrainingControllerPS> {
    return this.GetController().GetPS();
  }

  private const func GetController() -> ref<PerkTrainingController> {
    return this.m_controller as PerkTrainingController;
  }

  public const func DeterminGameplayRole() -> EGameplayRole {
    return EGameplayRole.GenericRole;
  }

  protected cb func OnTogglePersonalLink(evt: ref<TogglePersonalLink>) -> Bool {
    super.OnTogglePersonalLink(evt);
    if this.GetDevicePS().IsPersonalLinkConnected() {
      GameObject.PlaySound(this, this.m_pulsingEndSoundName);
      GameObjectEffectHelper.BreakEffectLoopEvent(this, this.GetLightsEffectName());
      this.StartProgressBar();
    } else {
      if this.GetDevicePS().IsPersonalLinkDisconnecting() {
        this.SetProgressBarActiveState(false);
      };
    };
  }

  protected func InitiatePersonalLinkWorkspot(puppet: ref<GameObject>) -> Void {
    this.EnterWorkspot(puppet, false, n"personalLinkPlayerWorkspot", n"deviceWorkspot");
  }

  private final func StartProgressBar() -> Void {
    this.StartTickEvent();
    this.SetProgressBarTexts();
    this.SetProgressBarActiveState(true);
  }

  private final func StartTickEvent() -> Void {
    let tickEvent: ref<PerkDeviceTickEvent> = new PerkDeviceTickEvent();
    GameInstance.GetDelaySystem(this.GetGame()).TickOnEvent(this, tickEvent, this.GetDevicePS().GetLoopTime());
  }

  protected cb func OnTick(evt: ref<PerkDeviceTickEvent>) -> Bool {
    this.GetProgressBarBlackboard().SetFloat(GetAllBlackboardDefs().UI_HUDProgressBar.Progress, evt.GetProgress());
  }

  private final func SetProgressBarActiveState(isActive: Bool) -> Void {
    this.GetProgressBarBlackboard().SetBool(GetAllBlackboardDefs().UI_HUDProgressBar.Active, isActive);
  }

  private final func SetProgressBarTexts() -> Void {
    this.GetProgressBarBlackboard().SetString(GetAllBlackboardDefs().UI_HUDProgressBar.Header, this.m_progressBarHeaderText);
    this.GetProgressBarBlackboard().SetString(GetAllBlackboardDefs().UI_HUDProgressBar.BottomText, this.m_progressBarBottomText);
  }

  private final func GetProgressBarBlackboard() -> ref<IBlackboard> {
    return GameInstance.GetBlackboardSystem(this.GetGame()).Get(GetAllBlackboardDefs().UI_HUDProgressBar);
  }

  protected func EnterWorkspot(activator: ref<GameObject>, opt freeCamera: Bool, opt componentName: CName, opt deviceData: CName) -> Void {
    let workspotSystem: ref<WorkspotGameSystem> = GameInstance.GetWorkspotSystem(activator.GetGame());
    if activator.IsPlayer() {
      this.m_workspotActivator = activator;
      workspotSystem.PlayInDeviceSimple(this, activator, freeCamera, componentName, deviceData, n"plugin_start", 0.50, WorkspotSlidingBehaviour.PlayAtResourcePosition, this);
    };
  }
}

public class PerkTrainingController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<PerkTrainingControllerPS> {
    return this.GetBasePS() as PerkTrainingControllerPS;
  }
}
