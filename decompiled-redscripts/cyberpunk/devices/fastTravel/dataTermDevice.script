
public class DataTerm extends InteractiveDevice {

  @runtimeProperty("category", "Fast Travel")
  private inline let m_linkedFastTravelPoint: ref<FastTravelPointData>;

  @runtimeProperty("category", "Fast Travel")
  private let m_exitNode: NodeRef;

  @runtimeProperty("category", "Subway")
  private let m_metroAnimationNode: NodeRef;

  @runtimeProperty("category", "Subway")
  private let m_SubwayGateBroken: Bool;

  private let m_fastTravelComponent: ref<FastTravelComponent>;

  private let m_lockColiderComponent: ref<IPlacedComponent>;

  private let m_mappinID: NewMappinID;

  private let m_isShortGlitchActive: Bool;

  private let m_shortGlitchDelayID: DelayID;

  private let m_hologramMeshGreen: ref<IPlacedComponent>;

  private let m_hologramMeshRed: ref<IPlacedComponent>;

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    EntityRequestComponentsInterface.RequestComponent(ri, n"dataTerm_ui", n"worlduiWidgetComponent", true);
    EntityRequestComponentsInterface.RequestComponent(ri, n"fastTravel", n"FastTravelComponent", true);
    EntityRequestComponentsInterface.RequestComponent(ri, n"lock", n"IPlacedComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"gate_holo_green", n"IPlacedComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"gate_holo_red", n"IPlacedComponent", false);
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    this.m_uiComponent = EntityResolveComponentsInterface.GetComponent(ri, n"dataTerm_ui") as worlduiWidgetComponent;
    this.m_fastTravelComponent = EntityResolveComponentsInterface.GetComponent(ri, n"fastTravel") as FastTravelComponent;
    this.m_lockColiderComponent = EntityResolveComponentsInterface.GetComponent(ri, n"lock") as IPlacedComponent;
    this.m_hologramMeshGreen = EntityResolveComponentsInterface.GetComponent(ri, n"gate_holo_green") as IPlacedComponent;
    this.m_hologramMeshRed = EntityResolveComponentsInterface.GetComponent(ri, n"gate_holo_red") as IPlacedComponent;
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as DataTermController;
  }

  protected func ResolveGameplayState() -> Void {
    super.ResolveGameplayState();
    this.GetDevicePS().SetLinkedFastTravelPoint(this.m_linkedFastTravelPoint);
    this.ResolveGateApperance();
    this.RegisterFastTravelPoints();
  }

  protected cb func OnGameAttached() -> Bool {
    super.OnGameAttached();
    if this.GetFastTravelSystem().HasFastTravelPoint(this.m_linkedFastTravelPoint) {
      this.RegisterMappin();
    };
    this.ProcessSubwayGateNPCPresence(false);
  }

  protected cb func OnDetach() -> Bool {
    super.OnDetach();
    this.UnregisterMappin();
  }

  protected func CreateBlackboard() -> Void {
    this.m_blackboard = IBlackboard.Create(GetAllBlackboardDefs().DataTermDeviceBlackboard);
  }

  protected const func IsReadyForUI() -> Bool {
    return this.m_isVisible || Equals(this.GetFastravelDeviceType(), EFastTravelDeviceType.SubwayGate);
  }

  public const func GetBlackboardDef() -> ref<DataTermDeviceBlackboardDef> {
    return this.GetDevicePS().GetBlackboardDef();
  }

  protected const func GetController() -> ref<DataTermController> {
    return this.m_controller as DataTermController;
  }

  public const func GetDevicePS() -> ref<DataTermControllerPS> {
    return this.GetController().GetPS();
  }

  protected cb func OnLogicReady(evt: ref<SetLogicReadyEvent>) -> Bool {
    super.OnLogicReady(evt);
    if this.IsUIdirty() && this.m_isInsideLogicArea || Equals(this.GetFastravelDeviceType(), EFastTravelDeviceType.SubwayGate) {
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
    this.UnregisterMappin();
  }

  protected func ActivateDevice() -> Void {
    super.ActivateDevice();
    this.ToggleLogicLayer(true);
  }

  protected final func TurnOffScreen() -> Void {
    let operationsContainer: ref<DeviceOperationsContainer>;
    if IsDefined(this.m_uiComponent) {
      if Equals(this.GetFastravelDeviceType(), EFastTravelDeviceType.SubwayGate) {
        return;
      };
      this.m_uiComponent.Toggle(false);
    };
    operationsContainer = this.GetDevicePS().GetDeviceOperationsContainer();
    if IsDefined(operationsContainer) {
      operationsContainer.Execute(n"hide_holo", this);
    };
  }

  protected final func TurnOnScreen() -> Void {
    let operationsContainer: ref<DeviceOperationsContainer>;
    if IsDefined(this.m_uiComponent) {
      this.m_uiComponent.Toggle(true);
    };
    operationsContainer = this.GetDevicePS().GetDeviceOperationsContainer();
    if IsDefined(operationsContainer) {
      operationsContainer.Execute(n"show_holo", this);
    };
  }

  protected cb func OnInteractionActivated(evt: ref<InteractionActivationEvent>) -> Bool {
    super.OnInteractionActivated(evt);
    if Equals(evt.eventType, gameinteractionsEInteractionEventType.EIET_activate) {
      if Equals(evt.layerData.tag, n"LogicArea") {
        this.RegisterFastTravelPoints();
      };
    };
  }

  protected cb func OnAreaEnter(evt: ref<AreaEnteredEvent>) -> Bool {
    let activator: ref<GameObject>;
    if Equals(evt.componentName, n"fastTravelArea") {
      if NotEquals(this.GetDevicePS().GetFastravelTriggerType(), EFastTravelTriggerType.Auto) {
        return false;
      };
      if this.m_linkedFastTravelPoint == null || IsDefined(this.m_linkedFastTravelPoint) && !this.m_linkedFastTravelPoint.IsValid() {
        return false;
      };
      if this.GetFastTravelSystem().IsFastTravelEnabledOnMap() {
        return false;
      };
      activator = EntityGameInterface.GetEntity(evt.activator) as GameObject;
      if activator.IsPlayer() {
        this.RequestFastTravelMenu();
        this.TeleportToExitNode(activator);
      };
    } else {
      if Equals(evt.componentName, n"SubwayGateArea") && Equals(this.GetFastravelDeviceType(), EFastTravelDeviceType.SubwayGate) {
        activator = EntityGameInterface.GetEntity(evt.activator) as GameObject;
        if (activator as ScriptedPuppet).IsCrowd() {
          this.ProcessSubwayGateNPCPresence(true);
        } else {
          if activator.IsPlayer() && Equals(this.GetDeviceState(), EDeviceStatus.ON) {
            if this.m_linkedFastTravelPoint == null || IsDefined(this.m_linkedFastTravelPoint) && !this.m_linkedFastTravelPoint.IsValid() {
              return false;
            };
            if this.GetFastTravelSystem().IsFastTravelEnabledOnMap() {
              return false;
            };
            SetFactValue(this.GetGame(), n"ue_metro_display_options", 1);
            this.SendThisSubwayGateToFastTravelSystem();
            this.PrepareMetroAnimEntityPosition();
          };
        };
      };
    };
  }

  private final func SendThisSubwayGateToFastTravelSystem() -> Void {
    let blackboard: ref<IBlackboard> = GameInstance.GetBlackboardSystem(this.GetGame()).Get(GetAllBlackboardDefs().FastTRavelSystem);
    if blackboard != null {
      blackboard.SetEntityID(GetAllBlackboardDefs().FastTRavelSystem.LastSubwayGateUsed, this.GetEntityID());
    };
  }

  protected cb func OnAreaExit(evt: ref<AreaExitedEvent>) -> Bool {
    let activator: ref<GameObject>;
    if Equals(evt.componentName, n"SubwayGateArea") {
      activator = EntityGameInterface.GetEntity(evt.activator) as GameObject;
      if (activator as ScriptedPuppet).IsCivilian() || (activator as ScriptedPuppet).IsCrowd() {
        this.ProcessSubwayGateNPCPresence(false);
      } else {
        if activator.IsPlayer() {
          SetFactValue(this.GetGame(), n"ue_metro_display_options", 0);
        };
      };
    };
  }

  protected cb func OnChangeSubwayGateStateEvent(evt: ref<ChangeSubwayGateStateEvent>) -> Bool {
    if Equals(evt.open, true) {
      this.OpenSubwayGate();
    } else {
      this.CloseSubwayGate();
    };
  }

  public final func OpenSubwayGate() -> Void {
    if Equals(this.GetFastravelDeviceType(), EFastTravelDeviceType.SubwayGate) && !this.IsSubwayGateOpen() {
      this.GetDevicePS().GetDeviceOperationsContainer().Execute(n"UnlockGate", this);
      this.GetBlackboard().SetBool(GetAllBlackboardDefs().DataTermDeviceBlackboard.subwayGateOpen, true, true);
    };
  }

  public final func CloseSubwayGate() -> Void {
    if Equals(this.GetFastravelDeviceType(), EFastTravelDeviceType.SubwayGate) && this.IsSubwayGateOpen() {
      this.GetDevicePS().GetDeviceOperationsContainer().Execute(n"LockGate", this);
      this.GetBlackboard().SetBool(GetAllBlackboardDefs().DataTermDeviceBlackboard.subwayGateOpen, false, true);
    };
  }

  private final func ProcessSubwayGateNPCPresence(increase: Bool) -> Void {
    let NPCsPresentNumber: Int32 = this.GetBlackboard().GetInt(GetAllBlackboardDefs().DataTermDeviceBlackboard.passengerCount);
    if increase {
      NPCsPresentNumber += 1;
    } else {
      NPCsPresentNumber -= 1;
    };
    if NPCsPresentNumber <= 0 {
      NPCsPresentNumber = 0;
      if this.IsSubwayGateOpen() {
        this.GetDevicePS().GetDeviceOperationsContainer().Execute(n"LockGate", this);
        this.GetBlackboard().SetBool(GetAllBlackboardDefs().DataTermDeviceBlackboard.subwayGateOpen, false, true);
      };
    } else {
      if !this.IsSubwayGateOpen() {
        this.GetDevicePS().GetDeviceOperationsContainer().Execute(n"UnlockGate", this);
        this.GetBlackboard().SetBool(GetAllBlackboardDefs().DataTermDeviceBlackboard.subwayGateOpen, true, true);
      };
    };
    this.GetBlackboard().SetInt(GetAllBlackboardDefs().DataTermDeviceBlackboard.passengerCount, NPCsPresentNumber, true);
  }

  private final func PrepareMetroAnimEntityPosition() -> Bool {
    let position: Vector4;
    let rotation: Quaternion;
    let entityID: EntityID = Cast<EntityID>(ResolveNodeRefWithEntityID(this.m_metroAnimationNode, this.GetEntityID()));
    if Equals(EntityID.IsDefined(entityID), true) {
      position = this.GetWorldPosition();
      rotation = this.GetWorldOrientation();
      GameInstance.GetTeleportationFacility(this.GetGame()).Teleport(GameInstance.FindEntityByID(this.GetGame(), entityID) as GameObject, position, Quaternion.ToEulerAngles(rotation));
      return true;
    };
    return false;
  }

  public final const func IsSubwayGateBroken() -> Bool {
    return this.m_SubwayGateBroken;
  }

  private final const func IsSubwayGateOpen() -> Bool {
    return this.GetBlackboard().GetBool(GetAllBlackboardDefs().DataTermDeviceBlackboard.subwayGateOpen);
  }

  private final const func AreCharacterPresentAtSubwayGate() -> Bool {
    return this.GetBlackboard().GetInt(GetAllBlackboardDefs().DataTermDeviceBlackboard.passengerCount) > 0;
  }

  private final func TeleportToExitNode(activator: ref<GameObject>) -> Void {
    let nodeTransform: Transform;
    let position: Vector4;
    let rotation: EulerAngles;
    let globalRef: GlobalNodeRef = ResolveNodeRefWithEntityID(this.m_exitNode, this.GetEntityID());
    if GlobalNodeRef.IsDefined(globalRef) {
      GameInstance.GetNodeTransform(this.GetGame(), globalRef, nodeTransform);
      position = Transform.GetPosition(nodeTransform);
      rotation = Quaternion.ToEulerAngles(Transform.GetOrientation(nodeTransform));
      GameInstance.GetTeleportationFacility(this.GetGame()).Teleport(activator, position, rotation);
    } else {
      GameInstance.GetTeleportationFacility(this.GetGame()).TeleportToNode(activator, this.m_linkedFastTravelPoint.GetMarkerRef());
    };
  }

  public final const func GetFastravelDeviceType() -> EFastTravelDeviceType {
    return this.GetDevicePS().GetFastravelDeviceType();
  }

  private final func ResolveGateApperance() -> Void {
    let deviceState: EDeviceStatus;
    if Equals(this.GetFastravelDeviceType(), EFastTravelDeviceType.SubwayGate) {
      if !this.GetFastTravelSystem().IsFastTravelEnabled() {
        if IsDefined(this.m_lockColiderComponent) && Equals(this.GetDevicePS().GetFastravelTriggerType(), EFastTravelTriggerType.Auto) {
          this.m_lockColiderComponent.Toggle(true);
        };
      } else {
        if IsDefined(this.m_lockColiderComponent) && Equals(this.GetDevicePS().GetFastravelTriggerType(), EFastTravelTriggerType.Auto) {
          this.m_lockColiderComponent.Toggle(false);
        };
      };
      deviceState = this.GetDevicePS().GetDeviceState();
      if Equals(deviceState, EDeviceStatus.ON) {
        this.m_hologramMeshGreen.Toggle(true);
        this.m_hologramMeshRed.Toggle(false);
      } else {
        this.m_hologramMeshGreen.Toggle(false);
        this.m_hologramMeshRed.Toggle(true);
      };
    };
  }

  private final func IsMappinRegistered() -> Bool {
    let invalidID: NewMappinID;
    return NotEquals(this.m_mappinID, invalidID);
  }

  private final func RegisterMappin() -> Void {
    let mappinData: MappinData;
    if this.GetDevicePS().IsDisabled() {
      return;
    };
    if !this.m_linkedFastTravelPoint.ShouldShowMappinInWorld() {
      return;
    };
    if !this.IsMappinRegistered() {
      mappinData.mappinType = t"Mappins.FastTravelDynamicMappin";
      if this.m_linkedFastTravelPoint.IsSubway() {
        mappinData.variant = gamedataMappinVariant.Zzz17_NCARTVariant;
      } else {
        mappinData.variant = gamedataMappinVariant.FastTravelVariant;
      };
      mappinData.visibleThroughWalls = false;
      this.m_mappinID = this.GetMappinSystem().RegisterMappinWithObject(mappinData, this, n"poi_mappin");
    };
  }

  private final func UnregisterMappin() -> Void {
    let invalidID: NewMappinID;
    if !this.m_linkedFastTravelPoint.ShouldShowMappinInWorld() {
      return;
    };
    if this.IsMappinRegistered() {
      this.GetMappinSystem().UnregisterMappin(this.m_mappinID);
      this.m_mappinID = invalidID;
    };
  }

  private final func GetMappinSystem() -> ref<MappinSystem> {
    return GameInstance.GetMappinSystem(this.GetGame());
  }

  private final func RegisterFastTravelPoints() -> Void {
    let evt: ref<RegisterFastTravelPointsEvent>;
    if this.GetDevicePS().IsDisabled() {
      return;
    };
    evt = new RegisterFastTravelPointsEvent();
    ArrayPush(evt.fastTravelNodes, this.m_linkedFastTravelPoint);
    this.QueueEvent(evt);
    this.RegisterMappin();
  }

  protected cb func OnFastTravelPointsUpdated(evt: ref<FastTravelPointsUpdated>) -> Bool {
    let invalidID: NewMappinID;
    if evt.updateTrackingAlternative && NotEquals(this.m_linkedFastTravelPoint.mappinID, invalidID) {
      this.GetMappinSystem().SetMappinTrackingAlternative(this.m_linkedFastTravelPoint.mappinID, this.m_mappinID);
    };
    this.GetBlackboard().SetVariant(GetAllBlackboardDefs().DataTermDeviceBlackboard.fastTravelPoint, ToVariant(this.m_linkedFastTravelPoint), true);
    this.DetermineInteractionStateByTask();
    this.RefreshUI();
    this.ResolveGateApperance();
  }

  protected cb func OnOpenWorldMapAction(evt: ref<OpenWorldMapDeviceAction>) -> Bool {
    this.RequestFastTravelMenu();
  }

  private final func RequestFastTravelMenu() -> Void {
    this.UpdateFastTravelPointRecord();
    GameInstance.GetUISystem(this.GetGame()).RequestFastTravelMenu();
  }

  private final func UpdateFastTravelPointRecord() -> Void {
    let request: ref<UpdateFastTravelPointRecordRequest> = new UpdateFastTravelPointRecordRequest();
    if this.m_linkedFastTravelPoint != null {
      request.markerRef = this.m_linkedFastTravelPoint.GetMarkerRef();
    };
    this.GetFastTravelSystem().QueueRequest(request);
  }

  public const func DeterminGameplayRole() -> EGameplayRole {
    return EGameplayRole.FastTravel;
  }

  public const func IsGameplayRoleValid(role: EGameplayRole) -> Bool {
    if !super.IsGameplayRoleValid(role) {
      return false;
    };
    if this.m_linkedFastTravelPoint != null && this.m_linkedFastTravelPoint.IsValid() {
      return true;
    };
    return false;
  }

  public const func IsFastTravelPoint() -> Bool {
    return true;
  }

  protected cb func OnHitEvent(hit: ref<gameHitEvent>) -> Bool {
    super.OnHitEvent(hit);
    this.StartShortGlitch();
  }

  protected func StartGlitching(glitchState: EGlitchState, opt intensity: Float) -> Void {
    let evt: ref<AdvertGlitchEvent>;
    if intensity == 0.00 {
      intensity = 1.00;
    };
    evt = new AdvertGlitchEvent();
    evt.SetShouldGlitch(1.00);
    this.QueueEvent(evt);
  }

  protected func StopGlitching() -> Void {
    let evt: ref<AdvertGlitchEvent> = new AdvertGlitchEvent();
    evt.SetShouldGlitch(0.00);
    this.QueueEvent(evt);
  }

  private final func StartShortGlitch() -> Void {
    let evt: ref<StopShortGlitchEvent>;
    if this.GetDevicePS().IsGlitching() {
      return;
    };
    if !this.m_isShortGlitchActive {
      evt = new StopShortGlitchEvent();
      this.StartGlitching(EGlitchState.DEFAULT, 1.00);
      this.m_shortGlitchDelayID = GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(this, evt, 0.25);
      this.m_isShortGlitchActive = true;
    };
  }

  protected cb func OnStopShortGlitch(evt: ref<StopShortGlitchEvent>) -> Bool {
    this.m_isShortGlitchActive = false;
    if !this.GetDevicePS().IsGlitching() {
      this.StopGlitching();
    };
  }

  public final const func GetFastravelPointData() -> ref<FastTravelPointData> {
    return this.m_linkedFastTravelPoint;
  }
}
