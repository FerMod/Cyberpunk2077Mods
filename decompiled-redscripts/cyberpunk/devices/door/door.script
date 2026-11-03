
public class Door extends InteractiveDevice {

  protected let m_animationController: ref<AnimationControllerComponent>;

  protected let m_triggerComponent: ref<TriggerComponent>;

  protected let m_triggerSideOne: ref<TriggerComponent>;

  protected let m_triggerSideTwo: ref<TriggerComponent>;

  protected let m_offMeshConnectionComponent: ref<OffMeshConnectionComponent>;

  protected let m_strongSoloFrame: ref<MeshComponent>;

  protected let m_terminalNetrunner1: ref<MeshComponent>;

  protected let m_terminalNetrunner2: ref<MeshComponent>;

  protected let m_terminalTechie1: ref<MeshComponent>;

  protected let m_terminalTechie2: ref<MeshComponent>;

  protected let m_ledTechie1: ref<gameLightComponent>;

  protected let m_ledTechie2: ref<gameLightComponent>;

  protected let m_ledNetrunner1: ref<gameLightComponent>;

  protected let m_ledNetrunner2: ref<gameLightComponent>;

  protected let m_led1: ref<gameLightComponent>;

  protected let m_led2: ref<gameLightComponent>;

  protected let m_ledHandle1: ref<gameLightComponent>;

  protected let m_ledHandle2: ref<gameLightComponent>;

  protected let m_ledHandle1a: ref<gameLightComponent>;

  protected let m_ledHandle2a: ref<gameLightComponent>;

  protected let m_occluder: ref<IPlacedComponent>;

  protected let m_portalLight1: ref<gameLightComponent>;

  protected let m_portalLight2: ref<gameLightComponent>;

  protected let m_portalLight3: ref<gameLightComponent>;

  protected let m_portalLight4: ref<gameLightComponent>;

  private let m_playerBlocker: ref<ColliderComponent>;

  protected let m_animFeatureDoor: ref<AnimFeatureDoor>;

  private let m_isVisuallyOpened: Bool;

  protected let m_lastDoorSide: Int32;

  protected let m_colors: LedColors;

  protected let m_activeSkillcheckLights: [ref<gameLightComponent>];

  protected let m_allActiveLights: [ref<gameLightComponent>];

  @default(Door, 1.1f)
  private let m_closingAnimationLength: Float;

  @default(Door, 3.0f)
  private let m_automaticCloseDelay: Float;

  protected let m_doorOpeningType: EDoorOpeningType;

  @default(Door, 6.0f)
  private let m_forceOpeningAudioStimRange: Float;

  @default(Door, 0.0f)
  private let m_openingAudioStimRange: Float;

  protected edit let m_animationType: EAnimationType;

  private let m_doorTriggerSide: EDoorTriggerSide;

  protected let m_whoOpened: wref<GameObject>;

  private let m_openedUsingForce: Bool;

  private let m_illegalOpen: Bool;

  private let m_audioForceOpen: Bool;

  private let m_componentName: CName;

  private let m_playerInWorkspot: wref<PlayerPuppet>;

  protected final func UpdateLightByTask() -> Void {
    GameInstance.GetDelaySystem(this.GetGame()).QueueTask(this, null, n"UpdateLightTask", gameScriptTaskExecutionStage.Any);
  }

  protected final func UpdateLightTask(data: ref<ScriptTaskData>) -> Void {
    this.UpdateLight();
  }

  protected func SetAppearance() -> Void {
    GameInstance.GetDelaySystem(this.GetGame()).QueueTask(this, null, n"SetAppearanceTask", gameScriptTaskExecutionStage.Any);
  }

  protected final func SetAppearanceTask(data: ref<ScriptTaskData>) -> Void {
    this.SetSoloAppearance();
    this.SetTechieAppearance();
    this.SetNetrunnerAppearance();
    this.InitializeLight();
    this.UpdateLight();
  }

  private final func EvaluateOffMeshLinks() -> Void {
    GameInstance.GetDelaySystem(this.GetGame()).QueueTask(this, null, n"EvaluateOffMeshLinksTask", gameScriptTaskExecutionStage.Any);
  }

  protected final func EvaluateOffMeshLinksTask(data: ref<ScriptTaskData>) -> Void {
    let ps: ref<DoorControllerPS>;
    if this.m_offMeshConnectionComponent == null {
      return;
    };
    ps = this.GetDevicePS();
    if ps.IsOpen() {
      this.EnableOffMeshConnections(true, true);
    } else {
      if ps.IsDisabled() || ps.IsSealed() || ps.IsUnpowered() {
        this.DisableOffMeshConnections(true, true);
      } else {
        if ps.IsClosed() {
          if !ps.IsLocked() && ps.IsON() {
            this.EnableOffMeshConnections(false, true);
          } else {
            this.DisableOffMeshConnections(false, true);
          };
          if this.HasAnySkillCheckActive() && this.CanPassAnySkillCheck() || this.CanPassAnySkillCheckOnParentTerminal() {
            this.EnableOffMeshConnections(true, false);
          } else {
            if ps.IsDeviceSecured() && ps.IsPlayerAuthorized() {
              this.EnableOffMeshConnections(true, false);
            } else {
              if ps.IsLocked() && ps.canPlayerToggleLockState() {
                this.EnableOffMeshConnections(true, false);
              } else {
                if !ps.IsLocked() && !ps.IsDeviceSecured() && !this.HasAnySkillCheckActive() && ps.IsON() {
                  this.EnableOffMeshConnections(true, false);
                } else {
                  this.DisableOffMeshConnections(true, false);
                };
              };
            };
          };
        };
      };
    };
  }

  public const func GetDeviceStateClass() -> CName {
    return n"DoorReplicatedState";
  }

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
    EntityRequestComponentsInterface.RequestComponent(ri, n"animController", n"AnimationControllerComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"trigger", n"gameStaticTriggerAreaComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"SideOne", n"gameStaticTriggerAreaComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"SideTwo", n"gameStaticTriggerAreaComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"offMeshConnection", n"OffMeshConnectionComponent", true);
    EntityRequestComponentsInterface.RequestComponent(ri, n"solo_frame", n"MeshComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"top_netrunner_side1", n"MeshComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"top_netrunner_side2", n"MeshComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"bottom_techie_side1", n"MeshComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"bottom_techie_side2", n"MeshComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"led_techie_side1", n"gameLightComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"led_techie_side2", n"gameLightComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"led_netrunner_side1", n"gameLightComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"led_netrunner_side2", n"gameLightComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"led_side1", n"gameLightComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"led_side2", n"gameLightComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"led_handle_side1", n"gameLightComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"led_handle_side2", n"gameLightComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"led_handle_2_side1", n"gameLightComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"led_handle_2_side2", n"gameLightComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"occluder", n"IPlacedComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"portal_light", n"gameLightComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"portal_light_2", n"gameLightComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"portal_light_gi", n"gameLightComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"portal_light_gi_2", n"gameLightComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"player_blocker", n"ColliderComponent", false);
  }

  public func OnMaraudersMapDeviceDebug(sink: ref<MaraudersMapDevicesSink>) -> Void {
    let ps: ref<DoorControllerPS>;
    super.OnMaraudersMapDeviceDebug(sink);
    sink.BeginCategory("Door specific");
    ps = this.GetDevicePS();
    sink.EndCategory();
    if ps.IsOpen() {
      sink.PushBool("Are Open", ps.IsOpen());
    };
    if ps.IsLogicallyClosed() {
      sink.PushBool("Are Logically Closed", ps.IsLogicallyClosed());
    };
    if ps.IsLocked() {
      sink.PushBool("Are Locked", ps.IsLocked());
    };
    if ps.IsSealed() {
      sink.PushBool("Are Sealed", ps.IsSealed());
    };
    sink.PushString("Door Type", EnumValueToString("EDoorType", Cast<Int64>(EnumInt(ps.GetDoorType()))));
    sink.PushString("Door Side One", EnumValueToString("EDoorType", Cast<Int64>(EnumInt(ps.GetDoorTypeSideOne()))));
    sink.PushString("Door Side Two", EnumValueToString("EDoorType", Cast<Int64>(EnumInt(ps.GetDoorTypeSideTwo()))));
    sink.PushString("Skillcheck Side", EnumValueToString("EDoorSkillcheckSide", Cast<Int64>(EnumInt(ps.GetDoorSkillcheckSide()))));
    sink.PushBool("Are Closing Automatically", ps.IsClosingAutomatically());
    sink.PushBool("Can Player Toggle Locked State", ps.canPlayerToggleLockState());
    sink.PushBool("IS LIFT DOOR?", ps.IsLiftDoor());
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    this.m_animationController = EntityResolveComponentsInterface.GetComponent(ri, n"animController") as AnimationControllerComponent;
    this.m_triggerComponent = EntityResolveComponentsInterface.GetComponent(ri, n"trigger") as TriggerComponent;
    this.m_triggerSideOne = EntityResolveComponentsInterface.GetComponent(ri, n"SideOne") as TriggerComponent;
    this.m_triggerSideTwo = EntityResolveComponentsInterface.GetComponent(ri, n"SideTwo") as TriggerComponent;
    this.m_offMeshConnectionComponent = EntityResolveComponentsInterface.GetComponent(ri, n"offMeshConnection") as OffMeshConnectionComponent;
    this.m_strongSoloFrame = EntityResolveComponentsInterface.GetComponent(ri, n"solo_frame") as MeshComponent;
    this.m_terminalNetrunner1 = EntityResolveComponentsInterface.GetComponent(ri, n"top_netrunner_side1") as MeshComponent;
    this.m_terminalNetrunner2 = EntityResolveComponentsInterface.GetComponent(ri, n"top_netrunner_side2") as MeshComponent;
    this.m_terminalTechie1 = EntityResolveComponentsInterface.GetComponent(ri, n"bottom_techie_side1") as MeshComponent;
    this.m_terminalTechie2 = EntityResolveComponentsInterface.GetComponent(ri, n"bottom_techie_side2") as MeshComponent;
    this.m_ledTechie1 = EntityResolveComponentsInterface.GetComponent(ri, n"led_techie_side1") as gameLightComponent;
    this.m_ledTechie2 = EntityResolveComponentsInterface.GetComponent(ri, n"led_techie_side2") as gameLightComponent;
    this.m_ledNetrunner1 = EntityResolveComponentsInterface.GetComponent(ri, n"led_netrunner_side1") as gameLightComponent;
    this.m_ledNetrunner2 = EntityResolveComponentsInterface.GetComponent(ri, n"led_netrunner_side2") as gameLightComponent;
    this.m_led1 = EntityResolveComponentsInterface.GetComponent(ri, n"led_side1") as gameLightComponent;
    this.m_led2 = EntityResolveComponentsInterface.GetComponent(ri, n"led_side2") as gameLightComponent;
    this.m_ledHandle1 = EntityResolveComponentsInterface.GetComponent(ri, n"led_handle_side1") as gameLightComponent;
    this.m_ledHandle2 = EntityResolveComponentsInterface.GetComponent(ri, n"led_handle_side2") as gameLightComponent;
    this.m_ledHandle1a = EntityResolveComponentsInterface.GetComponent(ri, n"led_handle_2_side1") as gameLightComponent;
    this.m_ledHandle2a = EntityResolveComponentsInterface.GetComponent(ri, n"led_handle_2_side2") as gameLightComponent;
    this.m_occluder = EntityResolveComponentsInterface.GetComponent(ri, n"occluder") as IPlacedComponent;
    this.m_portalLight1 = EntityResolveComponentsInterface.GetComponent(ri, n"portal_light") as gameLightComponent;
    this.m_portalLight2 = EntityResolveComponentsInterface.GetComponent(ri, n"portal_light_2") as gameLightComponent;
    this.m_portalLight3 = EntityResolveComponentsInterface.GetComponent(ri, n"portal_light_gi") as gameLightComponent;
    this.m_portalLight4 = EntityResolveComponentsInterface.GetComponent(ri, n"portal_light_gi_2") as gameLightComponent;
    this.m_playerBlocker = EntityResolveComponentsInterface.GetComponent(ri, n"player_blocker") as ColliderComponent;
    if this.m_offMeshConnectionComponent == null {
    };
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as DoorController;
  }

  protected cb func OnGameAttached() -> Bool {
    super.OnGameAttached();
    this.CreateLightSettings();
    this.UpdateDeviceState();
  }

  protected func ResolveGameplayState() -> Void {
    this.m_animFeatureDoor = new AnimFeatureDoor();
    this.m_animFeatureDoor.m_openingType = EnumInt(this.m_doorOpeningType);
    super.ResolveGameplayState();
  }

  protected func ResolveIllegalAction(executor: ref<GameObject>, duration: Float) -> Void {
    super.ResolveIllegalAction(executor, duration);
    if this.IsConnectedToSecuritySystem() {
      this.GetDevicePS().TriggerSecuritySystemNotification(executor, this.GetWorldPosition(), ESecurityNotificationType.ILLEGAL_ACTION);
    };
  }

  protected cb func OnDetach() -> Bool {
    super.OnDetach();
  }

  public const func GetDevicePS() -> ref<DoorControllerPS> {
    return this.GetController().GetPS();
  }

  private const func GetController() -> ref<DoorController> {
    return this.m_controller as DoorController;
  }

  protected cb func OnPersitentStateInitialized(evt: ref<GameAttachedEvent>) -> Bool {
    super.OnPersitentStateInitialized(evt);
    this.SetAppearance();
  }

  private final func UpdateLight() -> Void {
    let ps: ref<DoorControllerPS> = this.GetDevicePS();
    if ps.IsSealed() || ps.IsDisabled() {
      this.TurnLightsOff();
    } else {
      if this.RedLightCondition() {
        this.SetColor(this.m_colors.red);
      } else {
        this.SetColor(this.m_colors.green);
      };
    };
    if NotEquals(ps.GetDoorAuthorizationSide(), EDoorSkillcheckSide.BOTH) && (Equals(this.GetDoorTriggerSide(this.GetPlayerEntity()), EDoorTriggerSide.OUTSIDE) || !ps.IsUserAuthorized(ps.GetPlayerEntityID())) {
      this.ChangeHalfLights();
    } else {
      if ps.IsSkillCheckActive() && NotEquals(ps.GetDoorSkillcheckSide(), EDoorSkillcheckSide.BOTH) {
        this.ChangeHalfLights();
      };
    };
  }

  private final func RedLightCondition() -> Bool {
    let ps: ref<DoorControllerPS> = this.GetDevicePS();
    if ps.IsLocked() {
      return true;
    };
    if !ps.IsUserAuthorized(ps.GetPlayerEntityID()) && Equals(ps.GetDoorAuthorizationSide(), EDoorSkillcheckSide.BOTH) {
      return true;
    };
    if ps.IsSkillCheckActive() && Equals(ps.GetDoorSkillcheckSide(), EDoorSkillcheckSide.BOTH) {
      return true;
    };
    if ps.IsUnpowered() || ps.IsOFF() {
      return true;
    };
    return false;
  }

  private final func TurnLightsOff() -> Void {
    gameLightComponent.ChangeLightSettingByRefs(this.m_allActiveLights, this.m_colors.off, 2.00, n"glitch");
  }

  private final func SetColor(lightSettings: ScriptLightSettings) -> Void {
    gameLightComponent.ChangeLightSettingByRefs(this.m_allActiveLights, lightSettings);
  }

  protected cb func OnChangeHalfLights(evt: ref<ChangeHalfLights>) -> Bool {
    gameLightComponent.ChangeLightSettingByRefs(this.m_activeSkillcheckLights, this.m_colors.red);
  }

  private final func ChangeHalfLights() -> Void {
    let evt: ref<ChangeHalfLights> = new ChangeHalfLights();
    this.QueueEvent(evt);
  }

  protected func UpdateDeviceState(opt isDelayed: Bool) -> Bool {
    if super.UpdateDeviceState(isDelayed) {
      if this.IsInitialized() {
        if NotEquals(this.m_isVisuallyOpened, this.GetDevicePS().IsOpen()) {
          this.MoveDoor(this.GetDevicePS().IsOpen(), false);
        };
        this.UpdateLightByTask();
        this.RefreshUI(isDelayed);
        this.EvaluateOffMeshLinks();
      };
      return true;
    };
    return false;
  }

  protected func RestoreDeviceState() -> Void {
    this.MoveDoor(this.GetDevicePS().IsOpen(), true);
    super.RestoreDeviceState();
  }

  protected func ApplyReplicatedState(const state: ref<DeviceReplicatedState>) -> Void {
    let doorState: ref<DoorReplicatedState>;
    super.ApplyReplicatedState(state);
    doorState = state as DoorReplicatedState;
    if NotEquals(doorState.m_isOpen, this.m_isVisuallyOpened) {
      this.MoveDoor(doorState.m_isOpen, doorState.m_wasImmediateChange);
    };
  }

  protected final func AccessGrantedNotification() -> Void {
    let notification: ref<AuthorisationNotificationEvent> = new AuthorisationNotificationEvent();
    notification.type = gameuiAuthorisationNotificationType.AccessGranted;
    let player: ref<PlayerPuppet> = this.GetPlayerMainObject() as PlayerPuppet;
    player.QueueEvent(notification);
  }

  protected cb func OnPay(evt: ref<Pay>) -> Bool {
    this.AccessGrantedNotification();
  }

  protected func DeactivateDevice() -> Void {
    super.DeactivateDevice();
    this.m_animationController.Toggle(false);
  }

  protected func ActivateDevice() -> Void {
    super.ActivateDevice();
    if this.ShouldRegisterToHUD() {
      this.RegisterToHUDManagerByTask(true);
    };
    if IsDefined(this.m_animationController) {
      this.m_animationController.Toggle(true);
    };
  }

  protected cb func OnAreaEnter(evt: ref<AreaEnteredEvent>) -> Bool {
    let activator: ref<GameObject>;
    let approachingEvent: ref<AIApproachingAreaEvent>;
    let authorizedActivator: ref<GameObject>;
    let npcActivator: ref<NPCPuppet>;
    let oppositeArea: ref<TriggerComponent>;
    let ps: ref<DoorControllerPS>;
    if IsClient() {
      super.OnAreaEnter(evt);
      return false;
    };
    activator = EntityGameInterface.GetEntity(evt.activator) as GameObject;
    npcActivator = activator as NPCPuppet;
    ps = this.GetDevicePS();
    super.OnAreaEnter(evt);
    if !this.m_wasVisible {
      this.ResolveGameplayState();
      this.m_wasVisible = true;
    };
    if activator.IsPlayer() {
      if Equals(evt.componentName, n"SideOne") {
        this.SetNewDoorType(ps.GetDoorTypeSideOne());
        ps.SetTriggerSide(EDoorTriggerSide.ONE);
      } else {
        if Equals(evt.componentName, n"SideTwo") {
          this.SetNewDoorType(ps.GetDoorTypeSideTwo());
          ps.SetTriggerSide(EDoorTriggerSide.TWO);
        };
      };
      this.EvaluateOffMeshLinks();
    };
    if NotEquals(evt.componentName, n"trigger") || ps.IsOpen() || ps.IsSealed() {
      return false;
    };
    if activator.IsPlayer() {
      authorizedActivator = this.ClosestAuthorizedActiveEntityNearby();
      if Equals(ps.GetDoorType(), EDoorType.REMOTELY_CONTROLLED) && !ps.IsLiftDoor() {
        return false;
      };
      if ps.IsDeviceSecured() && ps.IsTriggerValid(ps.GetDoorAuthorizationSide()) {
        if authorizedActivator != null && authorizedActivator.IsPlayer() {
          if !ps.WasPlayerAuthorized() {
            this.AccessGrantedNotification();
            ps.UpdatePlayerAuthorization();
          };
          if ps.IsLocked() {
            this.ToggleDoorLockState(authorizedActivator, Equals(ps.GetDoorType(), EDoorType.AUTOMATIC));
          } else {
            if Equals(ps.GetDoorType(), EDoorType.AUTOMATIC) && ps.IsLogicallyClosed() {
              this.ToggleDoorOpeningState(authorizedActivator);
            };
          };
        };
      } else {
        if !ps.IsLiftDoor() && Equals(ps.GetDoorType(), EDoorType.AUTOMATIC) || ps.IsLiftDoorAndAtThisFloor() {
          if ps.IsLogicallyClosed() || authorizedActivator != null {
            if ps.HasAnySkillCheckActive() {
              if !ps.IsTriggerValid(ps.GetDoorSkillcheckSide()) {
                this.ToggleDoorOpeningState(activator);
              };
            } else {
              this.ToggleDoorOpeningState(activator);
            };
          };
        };
      };
    } else {
      if IsDefined(npcActivator) {
        if !ScriptedPuppet.IsActive(activator) {
          return false;
        };
        switch this.GetDoorTriggerSide(npcActivator) {
          case EDoorTriggerSide.ONE:
            oppositeArea = this.m_triggerSideTwo;
            break;
          case EDoorTriggerSide.TWO:
            oppositeArea = this.m_triggerSideOne;
            break;
          default:
            oppositeArea = null;
        };
        if IsDefined(oppositeArea) && ps.IsLogicallyClosed() {
          if !this.m_wasVisible {
            this.m_wasVisible = true;
            this.ResolveGameplayState();
          };
          approachingEvent = new AIApproachingAreaEvent();
          approachingEvent.areaComponent = oppositeArea;
          approachingEvent.responseTarget = this;
          npcActivator.QueueEvent(approachingEvent);
          return true;
        };
      };
    };
    if this.HasValidOpeningToken(EntityGameInterface.GetEntity(evt.activator).GetEntityID()) {
      this.ToggleDoorOpeningState(activator);
    };
  }

  protected cb func OnAreaExit(evt: ref<AreaExitedEvent>) -> Bool {
    let activator: ref<GameObject>;
    let approachingEvent: ref<AIApproachingAreaEvent>;
    let e: ref<DoorTriggerDelayedEvent>;
    let npcActivator: ref<NPCPuppet>;
    let doorPS: ref<DoorControllerPS> = this.GetDevicePS();
    if doorPS.IsLiftDoor() {
      if this.IsPlayerInsideLift() {
        return false;
      };
    };
    doorPS.SetTriggerSide(this.GetDoorTriggerSide(this.GetPlayerEntity()));
    if Equals(evt.componentName, n"trigger") {
      npcActivator = EntityGameInterface.GetEntity(evt.activator) as NPCPuppet;
      if IsDefined(npcActivator) {
        approachingEvent = new AIApproachingAreaEvent();
        approachingEvent.responseTarget = this;
        approachingEvent.isApproachCancellation = true;
        npcActivator.QueueEvent(approachingEvent);
      };
    };
    if NotEquals(evt.componentName, n"trigger") || !doorPS.IsOpen() || !doorPS.IsClosingAutomatically() || !doorPS.IsON() {
      return false;
    };
    activator = EntityGameInterface.GetEntity(evt.activator) as GameObject;
    e = new DoorTriggerDelayedEvent();
    e.activator = activator;
    if IsDefined(EntityGameInterface.GetEntity(evt.activator) as ScriptedPuppet) && !this.IsSomeoneAuthorizedNearby() {
      GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(this, e, this.m_automaticCloseDelay);
    };
  }

  protected final func IsPlayerInsideLift() -> Bool {
    let blackboardSystem: ref<BlackboardSystem> = GameInstance.GetBlackboardSystem(this.GetGame());
    let blackboard: ref<IBlackboard> = blackboardSystem.GetLocalInstanced(GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerControlledGameObject().GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    return blackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.IsPlayerInsideElevator);
  }

  protected cb func OnApproachingAreaResponseEvent(evt: ref<AIApproachingAreaResponseEvent>) -> Bool {
    let sender: ref<GameObject>;
    if evt.isPassingThrough && this.GetDevicePS().IsLogicallyClosed() {
      sender = evt.sender as GameObject;
      if IsDefined(sender) {
        this.ToggleDoorOpeningState(sender);
      };
    };
  }

  private final func GenerateInternalContext(opt activator: ref<GameObject>) -> GetActionsContext {
    return this.GetDevicePS().GenerateContext(gamedeviceRequestType.Internal, Device.GetInteractionClearance(), activator, this.GetEntityID());
  }

  private final func HasValidOpeningToken(id: EntityID) -> Bool {
    let tokensList: array<EntityID> = this.GetDevicePS().GetOpeningTokensList();
    let i: Int32 = 0;
    while i < ArraySize(tokensList) {
      if tokensList[i] == id {
        return true;
      };
      i += 1;
    };
    return false;
  }

  protected cb func OnDoorTriggerDelayedEvent(evt: ref<DoorTriggerDelayedEvent>) -> Bool {
    if !this.IsSomeoneAuthorizedNearby() && this.GetDevicePS().IsOpen() {
      this.CloseDoor();
    };
  }

  protected final func IsSomeoneAuthorizedNearby() -> Bool {
    return this.ClosestAuthorizedActiveEntityNearby() != null;
  }

  protected final func ClosestAuthorizedActiveEntityNearby() -> ref<GameObject> {
    let usersToAuthorize: array<ref<Entity>> = this.m_triggerComponent.GetOverlappingEntities();
    let ps: ref<DoorControllerPS> = this.GetDevicePS();
    let i: Int32 = 0;
    while i < ArraySize(usersToAuthorize) {
      if ScriptedPuppet.IsActive(usersToAuthorize[i] as GameObject) && ps.IsUserAuthorized(usersToAuthorize[i].GetEntityID()) {
        if IsDefined(usersToAuthorize[i] as PlayerPuppet) && ps.IsDeviceSecured() {
          this.RefreshInteraction(gamedeviceRequestType.Direct, GetPlayer(this.GetGame()));
          if ps.IsTriggerValid(ps.GetDoorAuthorizationSide()) {
            this.UpdateDeviceState();
            ps.ResolveSkillchecks();
          };
        };
        this.NotifyParents();
        return usersToAuthorize[i] as GameObject;
      };
      i += 1;
    };
    return null;
  }

  protected cb func OnAuthorizeUser(evt: ref<AuthorizeUser>) -> Bool {
    if this.GetDevicePS().UserAuthorizationAttempt(evt.GetExecutor().GetEntityID(), evt.GetEnteredPassword()) {
      this.AccessGrantedNotification();
    };
    this.UpdateDeviceState();
  }

  protected final func IsSomeoneInTrigger() -> Bool {
    if this.m_triggerComponent.GetNumberOverlappingActivators() == 0 {
      return false;
    };
    return true;
  }

  protected cb func OnForceUnlockAndOpenElevator(evt: ref<ForceUnlockAndOpenElevator>) -> Bool {
    if this.IsSomeoneAuthorizedNearby() {
      this.OpenDoor();
    };
  }

  protected cb func OnToggleOpen(evt: ref<ToggleOpen>) -> Bool {
    if Equals(this.m_doorOpeningType, EDoorOpeningType.HINGED) && Equals(this.GetDevicePS().GetDoorState(), EDoorStatus.OPENED) {
      this.m_doorTriggerSide = this.GetDoorTriggerSide(this.GetPlayerEntity());
    };
    this.m_whoOpened = evt.GetExecutor();
    if evt.IsIllegal() {
      this.m_illegalOpen = true;
    };
    this.UpdateDeviceState();
  }

  protected cb func OnActionDemolition(evt: ref<ActionDemolition>) -> Bool {
    let playerPuppet: ref<ScriptedPuppet>;
    if evt.IsCompleted() {
      return false;
    };
    this.m_whoOpened = evt.GetExecutor();
    this.m_openedUsingForce = true;
    this.m_audioForceOpen = true;
    if evt.IsIllegal() {
      this.m_illegalOpen = true;
    };
    if NotEquals(this.m_animationType, EAnimationType.REGULAR) {
      this.UpdateDeviceState();
      return true;
    };
    playerPuppet = GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerControlledGameObject() as ScriptedPuppet;
    this.m_doorTriggerSide = this.GetDoorTriggerSide(this.GetPlayerEntity());
    this.DisableOccluder();
    if Equals(this.m_doorTriggerSide, EDoorTriggerSide.ONE) {
      this.EnterWorkspot(playerPuppet, false, n"playerWorkspot", n"deviceWorkspot");
    };
    if Equals(this.m_doorTriggerSide, EDoorTriggerSide.TWO) {
      this.EnterWorkspot(playerPuppet, false, n"playerWorkspotFlip", n"deviceWorkspotFlip");
    };
    this.UpdateDeviceState();
  }

  protected cb func OnActionEngineering(evt: ref<ActionEngineering>) -> Bool {
    if !evt.IsCompleted() {
      return false;
    };
    this.m_whoOpened = evt.GetExecutor();
    if evt.IsIllegal() {
      this.m_illegalOpen = true;
    };
    if NotEquals(this.m_animationType, EAnimationType.REGULAR) {
      this.UpdateDeviceState();
      return true;
    };
    this.m_doorTriggerSide = this.GetDoorTriggerSide(this.GetPlayerEntity());
    this.DisableOccluder();
    if Equals(this.m_doorTriggerSide, EDoorTriggerSide.ONE) {
    };
    if Equals(this.m_doorTriggerSide, EDoorTriggerSide.TWO) {
    };
    this.UpdateDeviceState();
  }

  protected cb func OnToggleLock(evt: ref<ToggleLock>) -> Bool {
    this.PlayLockSound(this.GetDevicePS().IsLocked());
    if this.GetDevicePS().IsLocked() && this.GetDevicePS().IsOpen() {
      this.CloseDoor();
    } else {
      if this.IsSomeoneAuthorizedNearby() && this.GetDevicePS().IsLogicallyClosed() && evt.ShouldOpen() {
        this.OpenDoor();
      };
    };
    this.UpdateDeviceState();
  }

  protected cb func OnQuestForceUnlock(evt: ref<QuestForceUnlock>) -> Bool {
    if Equals(this.GetDevicePS().GetDoorType(), EDoorType.AUTOMATIC) && this.IsSomeoneAuthorizedNearby() && this.GetDevicePS().IsLogicallyClosed() {
      this.OpenDoor();
    };
    this.UpdateDeviceState();
  }

  protected cb func OnQuestForceUnseal(evt: ref<QuestForceUnseal>) -> Bool {
    if Equals(this.GetDevicePS().GetDoorType(), EDoorType.AUTOMATIC) && this.IsSomeoneAuthorizedNearby() && this.GetDevicePS().IsLogicallyClosed() {
      this.OpenDoor();
    };
    this.UpdateDeviceState();
  }

  protected cb func OnSealDoor(evt: ref<ToggleSeal>) -> Bool {
    this.UpdateDeviceState();
    if this.GetDevicePS().IsSealed() && this.GetDevicePS().IsOpen() {
      this.CloseDoor();
    } else {
      if this.IsSomeoneAuthorizedNearby() && this.GetDevicePS().IsLogicallyClosed() {
        this.OpenDoor();
      };
    };
  }

  protected cb func OnDoorOpeningToken(evt: ref<DoorOpeningToken>) -> Bool {
    this.UpdateDeviceState();
    if this.IsSomeoneAuthorizedNearby() && this.GetDevicePS().IsLogicallyClosed() {
      this.OpenDoor();
    };
  }

  protected cb func OnSetAuthorizationModuleOFF(evt: ref<SetAuthorizationModuleOFF>) -> Bool {
    this.UpdateDeviceState();
    if this.IsSomeoneAuthorizedNearby() && this.GetDevicePS().IsLogicallyClosed() {
      this.OpenDoor();
    };
  }

  protected cb func OnActivateDevice(evt: ref<ActivateDevice>) -> Bool {
    this.UpdateDeviceState();
  }

  protected cb func OnForceOpen(evt: ref<ForceOpen>) -> Bool {
    this.m_whoOpened = evt.GetExecutor();
    if evt.IsIllegal() {
      this.m_illegalOpen = true;
    };
    this.m_openedUsingForce = true;
    this.UpdateDeviceState();
  }

  protected cb func OnQuestForceClose(evt: ref<QuestForceClose>) -> Bool {
    this.MoveDoor(false, false, evt.GetValue());
  }

  protected cb func OnQuestForceCloseImmediate(evt: ref<QuestForceCloseImmediate>) -> Bool {
    this.EnablePlayerBlocker();
    this.MoveDoor(this.GetDevicePS().IsOpen(), false);
  }

  protected final func EnablePlayerBlocker() -> Void {
    if IsDefined(this.m_playerBlocker) && !this.m_playerBlocker.IsEnabled() {
      this.m_playerBlocker.Toggle(true);
    };
  }

  protected final func DisablePlayerBlocker() -> Void {
    if IsDefined(this.m_playerBlocker) && this.m_playerBlocker.IsEnabled() {
      this.m_playerBlocker.Toggle(false);
    };
  }

  protected cb func OnQuestForceOpenScene(evt: ref<QuestForceOpenScene>) -> Bool {
    this.MoveDoor(this.GetDevicePS().IsOpen(), true);
  }

  protected cb func OnQuestForceCloseScene(evt: ref<QuestForceCloseScene>) -> Bool {
    this.MoveDoor(this.GetDevicePS().IsOpen(), true);
  }

  protected cb func OnQuestForceEnabled(evt: ref<QuestForceEnabled>) -> Bool {
    this.ActivateDevice();
    this.UpdateDeviceState();
  }

  private final func ToggleDoorOpeningState(opt forWhom: EntityID) -> Void {
    let context: GetActionsContext = this.GenerateInternalContext();
    let action: ref<DeviceAction> = this.GetDevicePS().GetActionByName(n"ToggleOpen", context);
    if this.GetDevicePS().IsLogicallyClosed() {
      this.GetDevicePS().DepleteToken(forWhom);
    };
    if IsDefined(action) {
      this.ExecuteAction(action);
    };
  }

  private final func ToggleDoorOpeningState(activator: ref<GameObject>) -> Void {
    this.m_whoOpened = activator;
    let action: ref<DeviceAction> = this.GetDevicePS().ActionToggleOpen();
    if this.GetDevicePS().IsLogicallyClosed() {
      this.GetDevicePS().DepleteToken(activator.GetEntityID());
    };
    if IsDefined(action) {
      this.ExecuteAction(action, activator);
    };
  }

  private final func OpenDoor() -> Void {
    let action: ref<DeviceAction> = this.GetDevicePS().ActionSetOpened();
    if IsDefined(action) {
      this.ExecuteAction(action);
    };
  }

  private final func CloseDoor() -> Void {
    let action: ref<DeviceAction> = this.GetDevicePS().ActionSetClosed();
    if IsDefined(action) {
      this.ExecuteAction(action);
    };
  }

  private final func ToggleDoorLockState(activator: ref<GameObject>, shouldOpen: Bool) -> Void {
    let context: GetActionsContext = this.GenerateInternalContext(activator);
    this.m_whoOpened = context.processInitiatorObject;
    let action: ref<ToggleLock> = this.GetDevicePS().GetActionByName(n"ToggleLock", context) as ToggleLock;
    action.SetShouldOpen(shouldOpen);
    if IsDefined(action) {
      this.ExecuteAction(action);
    };
  }

  protected cb func OnCollision(evt: ref<HitCharacterControllerEvent>) -> Bool {
    this.GetDevicePS().OnDoorCollision();
  }

  private final func MoveDoor(shouldBeOpened: Bool, immediate: Bool, opt movingSpeedMultiplier: Float) -> Bool {
    let broadcaster: ref<StimBroadcasterComponent>;
    let movingTime: Float;
    let reactionData: stimInvestigateData;
    let replicatedState: ref<DoorReplicatedState>;
    let deviceBusy: ref<SetBusyEvent> = new SetBusyEvent();
    let ps: ref<DoorControllerPS> = this.GetDevicePS();
    ps.SetIsBusy(true);
    if movingSpeedMultiplier == 0.00 {
      movingSpeedMultiplier = 1.00;
    };
    movingTime = this.GetOpeningTime() / movingSpeedMultiplier;
    if Equals(this.m_animationType, EAnimationType.REGULAR) {
      this.RefreshAnimOpenDoor(shouldBeOpened, immediate, movingSpeedMultiplier);
    } else {
      this.RefreshTransformAnimOpenDoor(shouldBeOpened, immediate, movingSpeedMultiplier);
    };
    GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(this, deviceBusy, movingTime);
    if !immediate {
      this.PlayDoorMovementSound(shouldBeOpened, this.m_audioForceOpen);
    };
    this.UpdatePortalLights(shouldBeOpened);
    if shouldBeOpened {
      GameInstance.GetAudioSystem(this.GetGame()).OpenAcousticPortal(this);
      this.DisableOccluder();
      this.DisablePlayerBlocker();
    } else {
      GameInstance.GetAudioSystem(this.GetGame()).CloseAcousticPortal(this);
      if immediate {
        this.EnableOccluderInstanly();
      } else {
        this.EnableOccluderWithDelay(movingTime);
        if ps.IsLocked() {
          this.EnablePlayerBlocker();
        };
      };
    };
    if shouldBeOpened && IsDefined(this.m_whoOpened) && this.m_whoOpened.IsPlayer() {
      if this.m_illegalOpen {
        reactionData.illegalAction = true;
        this.m_illegalOpen = false;
      };
      broadcaster = this.GetStimBroadcasterComponent();
      this.TriggerMoveDoorStimBroadcaster(broadcaster, reactionData);
    };
    this.m_openedUsingForce = false;
    this.m_audioForceOpen = false;
    this.m_isVisuallyOpened = shouldBeOpened;
    replicatedState = this.GetServerState() as DoorReplicatedState;
    if IsDefined(replicatedState) {
      replicatedState.m_isOpen = this.m_isVisuallyOpened;
      replicatedState.m_wasImmediateChange = immediate;
    };
    this.UpdateDeviceState();
    this.RefreshInteraction(gamedeviceRequestType.Direct, GetPlayer(this.GetGame()));
    this.NotifyParents();
    return true;
  }

  protected func TriggerMoveDoorStimBroadcaster(broadcaster: ref<StimBroadcasterComponent>, reactionData: stimInvestigateData) -> Void {
    if IsDefined(broadcaster) {
      if this.m_openedUsingForce {
        broadcaster.TriggerSingleBroadcast(this, gamedataStimType.OpeningDoor, this.m_forceOpeningAudioStimRange, reactionData);
      } else {
        broadcaster.AddActiveStimuli(this, gamedataStimType.OpeningDoor, 2.00, this.m_forceOpeningAudioStimRange, reactionData, true);
        broadcaster.TriggerSingleBroadcast(this, gamedataStimType.OpeningDoor, this.m_openingAudioStimRange, reactionData);
      };
    };
  }

  protected func GetOpeningTime() -> Float {
    return this.GetDevicePS().GetOpeningTime();
  }

  protected cb func OnSetBusyEvent(evt: ref<SetBusyEvent>) -> Bool {
    this.GetDevicePS().SetIsBusy(false);
    this.UpdateDeviceState();
    this.RefreshInteraction(gamedeviceRequestType.Direct, GetPlayer(this.GetGame()));
    this.NotifyParents();
  }

  protected final func DisableOccluder() -> Void {
    if IsDefined(this.m_occluder) {
      this.m_occluder.Toggle(false);
    };
  }

  protected final func EnableOccluderWithDelay(delay: Float) -> Void {
    let e: ref<OccluderEnableEvent> = new OccluderEnableEvent();
    GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(this, e, delay);
  }

  protected final func EnableOccluderInstanly() -> Void {
    if IsDefined(this.m_occluder) {
      this.m_occluder.Toggle(true);
    };
  }

  protected cb func OnOccluderEnable(evt: ref<OccluderEnableEvent>) -> Bool {
    if this.GetDevicePS().IsClosed() {
      this.EnableOccluderInstanly();
      this.DisablePlayerBlocker();
    };
  }

  protected final func UpdatePortalLights(on: Bool) -> Void {
    if IsDefined(this.m_portalLight1) && this.m_portalLight1.IsEnabled() {
      this.m_portalLight1.ToggleLight(on);
    };
    if IsDefined(this.m_portalLight2) && this.m_portalLight2.IsEnabled() {
      this.m_portalLight2.ToggleLight(on);
    };
    if IsDefined(this.m_portalLight3) && this.m_portalLight3.IsEnabled() {
      this.m_portalLight3.ToggleLight(on);
    };
    if IsDefined(this.m_portalLight4) && this.m_portalLight4.IsEnabled() {
      this.m_portalLight4.ToggleLight(on);
    };
  }

  protected func EnterWorkspot(activator: ref<GameObject>, opt freeCamera: Bool, opt componentName: CName, opt deviceData: CName) -> Void {
    let workspotSystem: ref<WorkspotGameSystem> = GameInstance.GetWorkspotSystem(activator.GetGame());
    if IsDefined(workspotSystem) && activator.IsPlayer() {
      this.m_workspotActivator = activator;
      this.m_componentName = componentName;
      workspotSystem.PlayInDeviceSimple(this, activator, freeCamera, componentName, deviceData, n"None", 0.50, WorkspotSlidingBehaviour.DontPlayAtResourcePosition, this);
    };
  }

  protected cb func OnPlayInDeviceCallbackEvent(evt: ref<PlayInDeviceCallbackEvent>) -> Bool {
    let playerStateMachineBlackboard: ref<IBlackboard>;
    if evt.wasPlayInDeviceSuccessful {
      this.m_playerInWorkspot = this.m_workspotActivator as PlayerPuppet;
      playerStateMachineBlackboard = GameInstance.GetBlackboardSystem(this.GetGame()).GetLocalInstanced(this.m_playerInWorkspot.GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
      playerStateMachineBlackboard.SetBool(GetAllBlackboardDefs().PlayerStateMachine.IsInteractingWithDevice, true);
      this.m_interaction.Toggle(false);
      if Equals(this.m_componentName, n"playerWorkspot") || Equals(this.m_componentName, n"playerWorkspotFlip") {
        playerStateMachineBlackboard.SetBool(GetAllBlackboardDefs().PlayerStateMachine.IsForceOpeningDoor, true);
      };
    };
  }

  protected cb func OnWorkspotFinished(componentName: CName) -> Bool {
    let playerStateMachineBlackboard: ref<IBlackboard>;
    super.OnWorkspotFinished(componentName);
    this.m_interaction.Toggle(true);
    if IsDefined(this.m_playerInWorkspot) {
      playerStateMachineBlackboard = GameInstance.GetBlackboardSystem(this.GetGame()).GetLocalInstanced(this.m_playerInWorkspot.GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
      playerStateMachineBlackboard.SetBool(GetAllBlackboardDefs().PlayerStateMachine.IsForceOpeningDoor, false);
      this.m_playerInWorkspot = null;
    };
  }

  protected func SetIsDoorInteractionActiveBB(evt: ref<InteractionActivationEvent>, isActive: Bool) -> Void {
    super.SetIsDoorInteractionActiveBB(evt, isActive);
  }

  protected final func PlayLockSound(toLock: Bool) -> Void;

  protected final func PlayDoorSealSound(toSeal: Bool) -> Void {
    if toSeal {
    };
  }

  protected final func PlayDoorMovementSound(shouldBeOpened: Bool, wasOpenedUsingForce: Bool) -> Void {
    if shouldBeOpened {
      if wasOpenedUsingForce {
        GameObject.PlayMetadataEvent(this, n"force_open");
      } else {
        this.PlayOpenDoorSound();
      };
    } else {
      GameObject.PlayMetadataEvent(this, n"close");
    };
  }

  protected func PlayOpenDoorSound() -> Void {
    GameObject.PlayMetadataEvent(this, n"open");
  }

  protected func ExecuteDeviceStateOperation() -> Void {
    let ps: ref<DoorControllerPS>;
    let state: EDoorStatus;
    super.ExecuteDeviceStateOperation();
    ps = this.GetDevicePS();
    state = ps.GetDoorState();
    if ps.GetDeviceOperationsContainer() != null {
      ps.GetDeviceOperationsContainer().EvaluateDoorStateTriggers(state, this);
    };
  }

  private final func RefreshAnimOpenDoor(shouldBeOpened: Bool, immediate: Bool, animSpeedMultiplier: Float) -> Void {
    if !IsDefined(this.m_animFeatureDoor) {
      this.m_animFeatureDoor = new AnimFeatureDoor();
    };
    this.m_animFeatureDoor.m_openingSpeed = this.GetOpeningSpeed() * animSpeedMultiplier;
    this.m_animFeatureDoor.m_malfunctioning = 0;
    if shouldBeOpened && this.m_animFeatureDoor.m_progress == 0.00 {
      this.SetupOpenDoorAnimationFeatures();
    } else {
      if !shouldBeOpened && this.m_animFeatureDoor.m_progress == 1.00 {
        this.m_animFeatureDoor.m_progress = 0.00;
      };
    };
    this.m_animFeatureDoor.m_doorSide = this.m_lastDoorSide;
    if immediate {
      this.m_animFeatureDoor.m_openingSpeed *= 1000.00;
    };
    AnimationControllerComponent.ApplyFeature(this, n"door", this.m_animFeatureDoor);
  }

  protected func SetupOpenDoorAnimationFeatures() -> Void {
    this.m_animFeatureDoor.m_progress = 1.00;
    this.m_lastDoorSide = EnumInt(this.GetDoorTriggerSide(this.GetPlayerEntity()));
  }

  protected func GetOpeningSpeed() -> Float {
    let openingSpeed: Float = this.GetDevicePS().GetOpeningSpeed();
    return openingSpeed == 0.00 ? 1.00 : openingSpeed;
  }

  private final func RefreshTransformAnimOpenDoor(shouldBeOpened: Bool, immediate: Bool, animSpeedMultiplier: Float) -> Void {
    let playEvent: ref<gameTransformAnimationPlayEvent>;
    let resetEvent: ref<gameTransformAnimationResetEvent>;
    let skipEvent: ref<gameTransformAnimationSkipEvent>;
    let openingSpeed: Float = this.GetOpeningSpeed() * animSpeedMultiplier;
    let animName: CName = this.GetProperTransformAnimName();
    if !immediate {
      playEvent = new gameTransformAnimationPlayEvent();
      playEvent.animationName = animName;
      playEvent.looping = false;
      playEvent.timesPlayed = 1u;
      playEvent.timeScale = openingSpeed;
      if shouldBeOpened && !this.m_isVisuallyOpened {
        this.QueueEvent(playEvent);
      } else {
        if !shouldBeOpened && this.m_isVisuallyOpened {
          if Equals(this.m_animationType, EAnimationType.TRANSFORM) {
            playEvent.timeScale = openingSpeed * -1.00;
          };
          this.QueueEvent(playEvent);
        };
      };
    } else {
      if shouldBeOpened {
        skipEvent = new gameTransformAnimationSkipEvent();
        skipEvent.animationName = animName;
        skipEvent.skipToEnd = true;
        skipEvent.forcePlay = true;
        this.QueueEvent(skipEvent);
      } else {
        resetEvent = new gameTransformAnimationResetEvent();
        resetEvent.animationName = animName;
        this.QueueEvent(resetEvent);
      };
    };
  }

  private final func GetProperTransformAnimName() -> CName {
    switch this.m_doorOpeningType {
      case EDoorOpeningType.SLIDING_HORIZONTALLY:
        return n"doorSlideHorizontally";
      case EDoorOpeningType.SLIDING_VERTICALLY:
        return n"doorSlideVertically";
      case EDoorOpeningType.HINGED:
        if Equals(this.m_animationType, EAnimationType.TRANSFORM_TWO_SIDES) && Equals(this.m_doorTriggerSide, EDoorTriggerSide.ONE) {
          return n"doorOpenHingedBack";
        };
        return n"doorOpenHinged";
    };
    return n"None";
  }

  protected final func SetNewDoorType(type: EDoorType) -> Void {
    this.GetDevicePS().SetNewDoorType(type);
  }

  protected cb func OnSetDoorType(evt: ref<SetDoorType>) -> Bool {
    this.GetDevicePS().SetNewDoorType(evt);
  }

  protected cb func OnSetCloseItself(evt: ref<SetCloseItself>) -> Bool {
    this.GetDevicePS().SetCloseItself(evt.automaticallyClosesItself);
  }

  protected cb func OnResetDoorState(evt: ref<ResetDoorState>) -> Bool {
    this.GetDevicePS().ResetToDefault();
  }

  protected final func GetDoorTriggerSide(forEntity: ref<Entity>) -> EDoorTriggerSide {
    if !IsDefined(forEntity) {
      return EDoorTriggerSide.OUTSIDE;
    };
    if this.m_triggerSideOne.IsEntityOverlapping(forEntity) {
      return EDoorTriggerSide.ONE;
    };
    if this.m_triggerSideTwo.IsEntityOverlapping(forEntity) {
      return EDoorTriggerSide.TWO;
    };
    return EDoorTriggerSide.OUTSIDE;
  }

  protected final func GetPlayerEntity() -> ref<Entity> {
    return EntityGameInterface.GetEntity(this.GetPlayerMainObject().GetEntity());
  }

  protected final func CreateLightSettings() -> Void {
    this.m_colors.off.strength = 0.00;
    this.m_colors.off.color = new Color(0u, 0u, 0u, 0u);
    this.m_colors.red.strength = 1.00;
    this.m_colors.red.color = new Color(130u, 0u, 0u, 0u);
    this.m_colors.green.strength = 1.00;
    this.m_colors.green.color = new Color(25u, 135u, 0u, 255u);
  }

  protected func SetSoloAppearance() -> Void {
    if IsDefined(this.m_strongSoloFrame) {
      if this.GetDevicePS().WasDemolitionSkillCheckActive() {
        if this.m_strongSoloFrame.IsEnabled() {
          this.m_strongSoloFrame.Toggle(false);
        };
      } else {
        if !this.m_strongSoloFrame.IsEnabled() {
          this.m_strongSoloFrame.Toggle(true);
        };
      };
    };
  }

  private final func SetTechieAppearance() -> Void {
    if IsDefined(this.m_terminalTechie1) {
      if this.GetDevicePS().WasEngineeringSkillCheckActive() && this.GetDevicePS().IsSideOneActive() {
        if !this.m_terminalTechie1.IsEnabled() {
          this.m_terminalTechie1.Toggle(true);
        };
      } else {
        if this.m_terminalTechie1.IsEnabled() {
          this.m_terminalTechie1.Toggle(false);
        };
        if IsDefined(this.m_ledTechie1) {
          this.m_ledTechie1.Toggle(false);
        };
      };
    };
    if IsDefined(this.m_terminalTechie2) {
      if this.GetDevicePS().WasEngineeringSkillCheckActive() && this.GetDevicePS().IsSideTwoActive() {
        if !this.m_terminalTechie2.IsEnabled() {
          this.m_terminalTechie2.Toggle(true);
        };
      } else {
        if this.m_terminalTechie2.IsEnabled() {
          this.m_terminalTechie2.Toggle(false);
        };
        if IsDefined(this.m_ledTechie2) {
          this.m_ledTechie2.Toggle(false);
        };
      };
    };
  }

  private final func SetNetrunnerAppearance() -> Void {
    if IsDefined(this.m_terminalNetrunner1) {
      if this.IsConnectedToBackdoorDevice() || this.GetDevicePS().ExposeQuickHakcsIfNotConnnectedToAP() {
        if !this.m_terminalNetrunner1.IsEnabled() {
          this.m_terminalNetrunner1.Toggle(true);
        };
      } else {
        if this.m_terminalNetrunner1.IsEnabled() {
          this.m_terminalNetrunner1.Toggle(false);
        };
        if IsDefined(this.m_ledNetrunner1) {
          this.m_ledNetrunner1.Toggle(false);
        };
      };
    };
    if IsDefined(this.m_terminalNetrunner2) {
      if this.IsConnectedToBackdoorDevice() || this.GetDevicePS().ExposeQuickHakcsIfNotConnnectedToAP() {
        if !this.m_terminalNetrunner2.IsEnabled() {
          this.m_terminalNetrunner2.Toggle(true);
        };
      } else {
        if this.m_terminalNetrunner2.IsEnabled() {
          this.m_terminalNetrunner2.Toggle(false);
        };
        if IsDefined(this.m_ledNetrunner2) {
          this.m_ledNetrunner2.Toggle(false);
        };
      };
    };
  }

  protected final func InitializeLight() -> Void {
    if Equals(this.GetDevicePS().GetDoorSkillcheckSide(), EDoorSkillcheckSide.ONE) || Equals(this.GetDevicePS().GetDoorAuthorizationSide(), EDoorSkillcheckSide.ONE) {
      if IsDefined(this.m_terminalTechie1) && this.m_terminalTechie1.IsEnabled() {
        ArrayPush(this.m_activeSkillcheckLights, this.m_ledTechie1);
      };
      if IsDefined(this.m_terminalNetrunner1) && this.m_terminalNetrunner1.IsEnabled() {
        ArrayPush(this.m_activeSkillcheckLights, this.m_ledNetrunner1);
      };
      if IsDefined(this.m_led1) {
        ArrayPush(this.m_activeSkillcheckLights, this.m_led1);
      };
      if IsDefined(this.m_ledHandle1) {
        ArrayPush(this.m_activeSkillcheckLights, this.m_ledHandle1);
      };
      if IsDefined(this.m_ledHandle1a) {
        ArrayPush(this.m_activeSkillcheckLights, this.m_ledHandle1a);
      };
    } else {
      if Equals(this.GetDevicePS().GetDoorSkillcheckSide(), EDoorSkillcheckSide.TWO) || Equals(this.GetDevicePS().GetDoorAuthorizationSide(), EDoorSkillcheckSide.TWO) {
        if IsDefined(this.m_terminalTechie2) && this.m_terminalTechie2.IsEnabled() {
          ArrayPush(this.m_activeSkillcheckLights, this.m_ledTechie2);
        };
        if IsDefined(this.m_terminalNetrunner2) && this.m_terminalNetrunner2.IsEnabled() {
          ArrayPush(this.m_activeSkillcheckLights, this.m_ledNetrunner2);
        };
        if IsDefined(this.m_led2) {
          ArrayPush(this.m_activeSkillcheckLights, this.m_led2);
        };
        if IsDefined(this.m_ledHandle2) {
          ArrayPush(this.m_activeSkillcheckLights, this.m_ledHandle2);
        };
        if IsDefined(this.m_ledHandle2a) {
          ArrayPush(this.m_activeSkillcheckLights, this.m_ledHandle2a);
        };
      };
    };
    this.GetAllActiveLights();
  }

  protected final func GetAllActiveLights() -> Void {
    ArrayPush(this.m_allActiveLights, this.m_led1);
    ArrayPush(this.m_allActiveLights, this.m_led2);
    ArrayPush(this.m_allActiveLights, this.m_ledHandle1);
    ArrayPush(this.m_allActiveLights, this.m_ledHandle2);
    if IsDefined(this.m_ledHandle1a) {
      ArrayPush(this.m_allActiveLights, this.m_ledHandle1a);
    };
    if IsDefined(this.m_ledHandle2a) {
      ArrayPush(this.m_allActiveLights, this.m_ledHandle2a);
    };
    if IsDefined(this.m_terminalTechie1) && this.m_terminalTechie1.IsEnabled() {
      ArrayPush(this.m_allActiveLights, this.m_ledTechie1);
    };
    if IsDefined(this.m_terminalNetrunner1) && this.m_terminalNetrunner1.IsEnabled() {
      ArrayPush(this.m_allActiveLights, this.m_ledNetrunner1);
    };
    if IsDefined(this.m_terminalTechie2) && this.m_terminalTechie2.IsEnabled() {
      ArrayPush(this.m_allActiveLights, this.m_ledTechie2);
    };
    if IsDefined(this.m_terminalNetrunner2) && this.m_terminalNetrunner2.IsEnabled() {
      ArrayPush(this.m_allActiveLights, this.m_ledNetrunner2);
    };
  }

  public const func DeterminGameplayRole() -> EGameplayRole {
    return EGameplayRole.OpenPath;
  }

  public const func DeterminGameplayRoleMappinVisuaState(const data: script_ref<SDeviceMappinData>) -> EMappinVisualState {
    if !this.GetDevicePS().IsDisabled() && this.GetNetworkSystem().QuickHacksExposedByDefault() && this.HasAnyActiveQuickHackVulnerabilities() {
      return EMappinVisualState.Available;
    };
    if !this.HasAnySkillCheckActive() {
      if this.GetDevicePS().IsDeviceSecured() && !this.GetDevicePS().IsPlayerAuthorized() || this.GetDevicePS().IsLocked() && !this.GetDevicePS().canPlayerToggleLockState() {
        if this.CanPassAnySkillCheckOnParentTerminal() {
          return EMappinVisualState.Available;
        };
        return EMappinVisualState.Unavailable;
      };
      return EMappinVisualState.Available;
    };
    if !this.GetDevicePS().IsDisabled() && this.CanPassAnySkillCheckOnParentTerminal() {
      return EMappinVisualState.Available;
    };
    return super.DeterminGameplayRoleMappinVisuaState(data);
  }

  public const func IsActive() -> Bool {
    if this.GetDevicePS().IsSealed() {
      return false;
    };
    return super.IsActive();
  }

  protected func EnableOffMeshConnections(player: Bool, npc: Bool) -> Void {
    if this.m_offMeshConnectionComponent != null {
      if player {
        this.m_offMeshConnectionComponent.EnableForPlayer();
      };
      if npc {
        this.m_offMeshConnectionComponent.EnableOffMeshConnection();
      };
    };
  }

  protected func DisableOffMeshConnections(player: Bool, npc: Bool) -> Void {
    if this.m_offMeshConnectionComponent != null {
      if player {
        this.m_offMeshConnectionComponent.DisableForPlayer();
      };
      if npc {
        this.m_offMeshConnectionComponent.DisableOffMeshConnection();
      };
    };
  }

  protected final const func CanPassAnySkillCheckOnParentTerminal() -> Bool {
    let requester: ref<GameObject> = EntityGameInterface.GetEntity(this.GetEntity()) as GameObject;
    return this.GetDevicePS().CanPassAnySkillCheckOnParentTerminal(requester);
  }

  public final const func GetClosingAnimationLength() -> Float {
    return this.m_closingAnimationLength;
  }

  public final const func GetAnimFeature() -> ref<AnimFeatureDoor> {
    return this.m_animFeatureDoor;
  }

  public const func IsNetrunner() -> Bool {
    if !this.IsCyberdeckEquippedOnPlayer() {
      return false;
    };
    return this.GetDevicePS().IsHackingSkillCheckActive() || (this.IsQuickHacksExposed() && this.GetDevicePS().ExposeQuickHakcsIfNotConnnectedToAP() || this.IsConnectedToBackdoorDevice()) && this.GetDevicePS().HasPlaystyle(EPlaystyle.NETRUNNER) || this.IsActiveBackdoor();
  }

  protected const func HasAnyDirectInteractionActive() -> Bool {
    if this.GetDevicePS().IsDisabled() || this.GetDevicePS().IsSealed() {
      return false;
    };
    return true;
  }
}
