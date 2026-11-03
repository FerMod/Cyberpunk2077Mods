
public class RoadBlock extends InteractiveDevice {

  @runtimeProperty("category", "AnimationSetup")
  @default(RoadBlock, 2.0f)
  public let m_openingSpeed: Float;

  private const let m_coverObjectRefs: [NodeRef];

  protected let m_animationController: ref<AnimationControllerComponent>;

  protected let m_offMeshConnection: ref<OffMeshConnectionComponent>;

  private let m_animFeature: ref<AnimFeature_RoadBlock>;

  protected edit let m_animationType: EAnimationType;

  protected let m_forceEnableLink: Bool;

  private let m_globalCoverObjectRefs: [GlobalNodeRef];

  private let m_areGlobalCoverRefsInitialized: Bool;

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
    EntityRequestComponentsInterface.RequestComponent(ri, n"animController", n"AnimationControllerComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"offMeshConnection", n"OffMeshConnectionComponent", false);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_animationController = EntityResolveComponentsInterface.GetComponent(ri, n"animController") as AnimationControllerComponent;
    this.m_offMeshConnection = EntityResolveComponentsInterface.GetComponent(ri, n"offMeshConnection") as OffMeshConnectionComponent;
    if !IsDefined(this.m_animationController) {
    };
    if !IsDefined(this.m_offMeshConnection) {
    };
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as RoadBlockController;
  }

  protected func ResolveGameplayState() -> Void {
    super.ResolveGameplayState();
    this.m_animFeature = new AnimFeature_RoadBlock();
    this.m_animFeature.initOpen = this.GetDevicePS().IsBlocking() ^ this.GetDevicePS().NegateAnim();
    this.UpdateRoadBlockStateImmediate();
  }

  protected cb func OnGameAttached() -> Bool {
    this.TryInitializeGlobalCoverObjectRefs();
    this.RegisterCoverObjects();
    super.OnGameAttached();
  }

  private final func TryInitializeGlobalCoverObjectRefs() -> Void {
    let i: Int32;
    if !this.m_areGlobalCoverRefsInitialized {
      i = 0;
      while i < ArraySize(this.m_coverObjectRefs) {
        ArrayPush(this.m_globalCoverObjectRefs, ResolveNodeRefWithEntityID(this.m_coverObjectRefs[i], this.GetEntityID()));
        i += 1;
      };
      this.m_areGlobalCoverRefsInitialized = true;
    };
  }

  private final func RegisterCoverObjects() -> Void {
    let coverManager: ref<CoverManager> = GameInstance.GetCoverManager(this.GetGame());
    let i: Int32 = 0;
    while i < ArraySize(this.m_globalCoverObjectRefs) {
      coverManager.RegisterCoverPreInstanceData(this.m_globalCoverObjectRefs[i], this.GetDevicePS().IsBlocking());
      i += 1;
    };
  }

  protected cb func OnDetach() -> Bool {
    this.UnregisterCoverObjects();
    super.OnDetach();
  }

  private final func UnregisterCoverObjects() -> Void {
    let coverManager: ref<CoverManager> = GameInstance.GetCoverManager(this.GetGame());
    let i: Int32 = 0;
    while i < ArraySize(this.m_globalCoverObjectRefs) {
      coverManager.UnregisterCoverPreInstanceData(this.m_globalCoverObjectRefs[i]);
      i += 1;
    };
  }

  private const func GetController() -> ref<RoadBlockController> {
    return this.m_controller as RoadBlockController;
  }

  public const func GetDevicePS() -> ref<RoadBlockControllerPS> {
    return this.GetController().GetPS();
  }

  protected cb func OnToggleBlockade(evt: ref<ToggleBlockade>) -> Bool {
    this.UpdateRoadBlockState();
    this.UpdateDeviceState();
  }

  protected cb func OnQuickHackToggleBlockade(evt: ref<QuickHackToggleBlockade>) -> Bool {
    this.UpdateRoadBlockState();
    this.UpdateDeviceState();
  }

  protected cb func OnQuestForceRoadBlockadeActivate(evt: ref<QuestForceRoadBlockadeActivate>) -> Bool {
    this.UpdateRoadBlockState();
    this.UpdateDeviceState();
  }

  protected cb func OnQuestForceRoadBlockadeDeactivate(evt: ref<QuestForceRoadBlockadeDeactivate>) -> Bool {
    this.UpdateRoadBlockState();
    this.UpdateDeviceState();
  }

  protected cb func OnActivateDevice(evt: ref<ActivateDevice>) -> Bool {
    this.UpdateRoadBlockState();
  }

  protected cb func OnDeactivateDevice(evt: ref<DeactivateDevice>) -> Bool {
    this.UpdateRoadBlockState();
  }

  protected cb func OnPhysicalDestructionEvent(evt: ref<PhysicalDestructionEvent>) -> Bool {
    this.ToggleOffMeshConnection(true);
    this.m_forceEnableLink = true;
  }

  protected func DeactivateDevice() -> Void {
    super.DeactivateDevice();
    this.m_animationController.Toggle(false);
  }

  protected func ActivateDevice() -> Void {
    super.ActivateDevice();
    if IsDefined(this.m_animationController) {
      this.m_animationController.Toggle(true);
    };
  }

  private final func UpdateRoadBlockState() -> Void {
    this.InternalUpdateRoadBlockState(false);
  }

  private final func UpdateRoadBlockStateImmediate() -> Void {
    this.InternalUpdateRoadBlockState(true);
  }

  private final func InternalUpdateRoadBlockState(immediate: Bool) -> Void {
    this.UpdateAnimationState(immediate);
    this.ToggleOffMeshConnection(!this.GetDevicePS().IsBlocking());
    this.UpdateCoverObjectState();
  }

  private final func UpdateCoverObjectState() -> Void {
    if this.GetDevicePS().IsBlocking() {
      this.EnableCoverObjects();
    } else {
      this.DisableCoverObjects();
    };
  }

  private final func EnableCoverObjects() -> Void {
    let coverManager: ref<CoverManager> = GameInstance.GetCoverManager(this.GetGame());
    let i: Int32 = 0;
    while i < ArraySize(this.m_globalCoverObjectRefs) {
      coverManager.SetCoverEnabled(this.m_globalCoverObjectRefs[i]);
      i += 1;
    };
  }

  private final func DisableCoverObjects() -> Void {
    let coverManager: ref<CoverManager> = GameInstance.GetCoverManager(this.GetGame());
    let i: Int32 = 0;
    while i < ArraySize(this.m_globalCoverObjectRefs) {
      coverManager.SetCoverDisabled(this.m_globalCoverObjectRefs[i]);
      i += 1;
    };
  }

  private final func UpdateAnimationState(immediate: Bool) -> Void {
    if Equals(this.m_animationType, EAnimationType.REGULAR) {
      this.Animate(immediate);
    } else {
      if Equals(this.m_animationType, EAnimationType.TRANSFORM) {
        this.TransformAnimate(immediate);
      };
    };
  }

  private final func Animate(immediate: Bool) -> Void {
    this.m_animFeature.duration = this.m_openingSpeed;
    this.m_animFeature.isOpening = this.GetDevicePS().IsBlocking() ^ this.GetDevicePS().NegateAnim();
    if immediate {
      this.m_animFeature.duration /= 1000.00;
    };
    AnimationControllerComponent.ApplyFeature(this, n"Road_block", this.m_animFeature);
  }

  private final func TransformAnimate(immediate: Bool) -> Void {
    let skipEvent: ref<gameTransformAnimationSkipEvent>;
    let playEvent: ref<gameTransformAnimationPlayEvent> = new gameTransformAnimationPlayEvent();
    playEvent.looping = false;
    playEvent.timesPlayed = 1u;
    playEvent.timeScale = 1.00;
    if this.GetDevicePS().IsNotBlocking() {
      playEvent.animationName = n"closing";
    } else {
      playEvent.animationName = n"opening";
    };
    this.QueueEvent(playEvent);
    if immediate {
      skipEvent = new gameTransformAnimationSkipEvent();
      skipEvent.skipToEnd = true;
      skipEvent.animationName = playEvent.animationName;
      this.QueueEvent(skipEvent);
    };
  }

  private final func ToggleOffMeshConnection(toggle: Bool) -> Void {
    if IsDefined(this.m_offMeshConnection) && !this.m_forceEnableLink {
      if toggle {
        this.m_offMeshConnection.EnableOffMeshConnection();
        this.m_offMeshConnection.EnableForPlayer();
      } else {
        this.m_offMeshConnection.DisableOffMeshConnection();
        this.m_offMeshConnection.DisableForPlayer();
      };
    };
  }

  public const func DeterminGameplayRole() -> EGameplayRole {
    return EGameplayRole.ClearPath;
  }
}
