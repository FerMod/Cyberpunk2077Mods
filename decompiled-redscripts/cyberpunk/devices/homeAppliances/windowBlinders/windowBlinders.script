
public class WindowBlinders extends InteractiveDevice {

  private let m_animFeature: ref<AnimFeature_SimpleDevice>;

  private let m_workspotSideName: CName;

  protected let m_portalLight: ref<gameLightComponent>;

  protected let m_portalLight2: ref<gameLightComponent>;

  protected let m_portalLight3: ref<gameLightComponent>;

  protected let m_portalLight4: ref<gameLightComponent>;

  protected edit const let m_sideTriggerNames: [CName];

  protected let m_triggerComponents: [ref<TriggerComponent>];

  protected let m_interactionBlockingCollider: ref<IPlacedComponent>;

  public const func GetDeviceStateClass() -> CName {
    return n"WindowBlindersReplicatedState";
  }

  protected func ApplyReplicatedState(const state: ref<DeviceReplicatedState>) -> Void {
    let blindersState: ref<WindowBlindersReplicatedState>;
    super.ApplyReplicatedState(state);
    blindersState = state as WindowBlindersReplicatedState;
    this.ApplyAnimState(blindersState.m_isOpen, blindersState.m_isTilted);
  }

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    let i: Int32;
    super.OnRequestComponents(ri);
    i = 0;
    while i < ArraySize(this.m_sideTriggerNames) {
      EntityRequestComponentsInterface.RequestComponent(ri, this.m_sideTriggerNames[i], n"TriggerComponent", true);
      i += 1;
    };
    EntityRequestComponentsInterface.RequestComponent(ri, n"portal_light", n"gameLightComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"portal_light_2", n"gameLightComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"portal_light_gi", n"gameLightComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"portal_light_gi_2", n"gameLightComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"fullCollider", n"entColliderComponent", false);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    let i: Int32;
    super.OnTakeControl(ri);
    i = 0;
    while i < ArraySize(this.m_sideTriggerNames) {
      ArrayPush(this.m_triggerComponents, EntityResolveComponentsInterface.GetComponent(ri, this.m_sideTriggerNames[i]) as TriggerComponent);
      i += 1;
    };
    this.m_portalLight = EntityResolveComponentsInterface.GetComponent(ri, n"portal_light") as gameLightComponent;
    this.m_portalLight2 = EntityResolveComponentsInterface.GetComponent(ri, n"portal_light_2") as gameLightComponent;
    this.m_portalLight3 = EntityResolveComponentsInterface.GetComponent(ri, n"portal_light_gi") as gameLightComponent;
    this.m_portalLight4 = EntityResolveComponentsInterface.GetComponent(ri, n"portal_light_gi_2") as gameLightComponent;
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as WindowBlindersController;
    this.m_interactionBlockingCollider = EntityResolveComponentsInterface.GetComponent(ri, n"fullCollider") as IPlacedComponent;
  }

  protected func ResolveGameplayState() -> Void {
    super.ResolveGameplayState();
    this.UpdateDeviceState();
  }

  private const func GetController() -> ref<WindowBlindersController> {
    return this.m_controller as WindowBlindersController;
  }

  public const func GetDevicePS() -> ref<WindowBlindersControllerPS> {
    return this.GetController().GetPS();
  }

  protected func UpdateDeviceState(opt isDelayed: Bool) -> Bool {
    if super.UpdateDeviceState(isDelayed) {
      this.UpdateAnimState();
      return true;
    };
    return false;
  }

  protected cb func OnToggleOpen(evt: ref<ToggleOpen>) -> Bool {
    this.UpdateDeviceState();
    GameObject.PlaySoundEvent(this, n"dev_doors_hidden_stop");
  }

  protected cb func OnQuickHackToggleOpen(evt: ref<QuickHackToggleOpen>) -> Bool {
    this.UpdateDeviceState();
    GameObject.PlaySoundEvent(this, n"dev_doors_hidden_stop");
  }

  protected cb func OnToggleTilt(evt: ref<ToggleTiltBlinders>) -> Bool {
    this.UpdateDeviceState();
    GameObject.PlaySoundEvent(this, n"dev_doors_hidden_stop");
  }

  protected cb func OnActionEngineering(evt: ref<ActionEngineering>) -> Bool {
    this.UpdateDeviceState();
  }

  protected cb func OnActionDemolition(evt: ref<ActionDemolition>) -> Bool {
    this.UpdateDeviceState();
    this.EnterWorkspot();
  }

  protected final func EnterWorkspot() -> Void {
    let workspotSystem: ref<WorkspotGameSystem>;
    let playerStateMachineBlackboard: ref<IBlackboard> = GameInstance.GetBlackboardSystem(this.GetGame()).GetLocalInstanced(GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerMainGameObject().GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    playerStateMachineBlackboard.SetBool(GetAllBlackboardDefs().PlayerStateMachine.IsInteractingWithDevice, true);
    workspotSystem = GameInstance.GetWorkspotSystem(this.GetGame());
    this.CheckCurrentSide();
    workspotSystem.PlayInDevice(this, GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerMainGameObject(), n"lockedCamera", n"playerWorkspot" + this.m_workspotSideName, n"deviceWorkspot" + this.m_workspotSideName, n"blinders", 0.50, WorkspotSlidingBehaviour.PlayAtResourcePosition);
  }

  protected cb func OnQuestStatusChange(evt: ref<PSChangedEvent>) -> Bool {
    this.UpdateDeviceState();
    GameObject.PlaySoundEvent(this, n"dev_doors_hidden_stop");
  }

  private final func UpdateAnimState() -> Void {
    let replicatedState: ref<WindowBlindersReplicatedState> = this.GetServerState() as WindowBlindersReplicatedState;
    let ps: ref<WindowBlindersControllerPS> = this.GetDevicePS();
    if IsDefined(replicatedState) {
      replicatedState.m_isOpen = ps.IsOpen();
      replicatedState.m_isTilted = ps.IsTilted();
    };
    this.ApplyAnimState(ps.IsOpen(), ps.IsTilted());
    this.UpdatePortalLights(ps.IsOpen());
    if !this.m_wasAnimationFastForwarded {
      this.FastForwardAnimations();
    };
  }

  private final func UpdatePortalLights(isOpen: Bool) -> Void {
    if IsDefined(this.m_portalLight) && this.m_portalLight.IsEnabled() {
      this.m_portalLight.ToggleLight(isOpen);
    };
    if IsDefined(this.m_portalLight2) && this.m_portalLight2.IsEnabled() {
      this.m_portalLight2.ToggleLight(isOpen);
    };
    if IsDefined(this.m_portalLight3) && this.m_portalLight3.IsEnabled() {
      this.m_portalLight3.ToggleLight(isOpen);
    };
    if IsDefined(this.m_portalLight4) && this.m_portalLight4.IsEnabled() {
      this.m_portalLight4.ToggleLight(isOpen);
    };
    this.m_interactionBlockingCollider.Toggle(!this.GetDevicePS().IsOpen());
  }

  private final func ApplyAnimState(isOpen: Bool, isTilted: Bool) -> Void {
    if !IsDefined(this.m_animFeature) {
      this.m_animFeature = new AnimFeature_SimpleDevice();
    };
    this.m_animFeature.isOpen = isOpen;
    this.m_animFeature.isOpenLeft = isTilted;
    AnimationControllerComponent.ApplyFeature(this, n"DeviceWindowBlinders", this.m_animFeature);
  }

  public const func DeterminGameplayRole() -> EGameplayRole {
    return EGameplayRole.OpenPath;
  }

  protected final func CheckCurrentSide() -> Void {
    let finalName: String;
    let j: Int32;
    let overlappingEntities: array<ref<Entity>>;
    let i: Int32 = 0;
    while i < ArraySize(this.m_triggerComponents) {
      overlappingEntities = this.m_triggerComponents[i].GetOverlappingEntities();
      j = 0;
      while j < ArraySize(overlappingEntities) {
        if (overlappingEntities[j] as GameObject).IsPlayer() {
          finalName = "Side" + ToString(i + 1);
          this.m_workspotSideName = StringToName(finalName);
        };
        j += 1;
      };
      i += 1;
    };
    if Equals(this.m_workspotSideName, n"None") {
      this.m_workspotSideName = n"Side1";
    };
  }
}
