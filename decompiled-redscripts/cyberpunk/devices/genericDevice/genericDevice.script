
public struct SDeviceActionData {

  public persistent let hasInteraction: Bool;

  public persistent let hasUI: Bool;

  public persistent let isQuickHack: Bool;

  public persistent let isSpiderbotAction: Bool;

  public let spiderbotLocationOverrideReference: NodeRef;

  public persistent let attachedToSkillCheck: EDeviceChallengeSkill;

  @runtimeProperty("customEditor", "TweakDBGroupInheritance;ActionWidgetDefinition")
  public edit let widgetRecord: TweakDBID;

  @runtimeProperty("customEditor", "TweakDBGroupInheritance;ObjectAction")
  public edit let objectActionRecord: TweakDBID;

  public persistent let currentDisplayName: CName;

  public let interactionRecord: String;

  public final static func GetCurrentDisplayName(const self: script_ref<SDeviceActionData>) -> String {
    return NameToString(Deref(self).currentDisplayName);
  }
}

public struct SDeviceActionBoolData extends SDeviceActionData {

  @runtimeProperty("customEditor", "TweakDBGroupInheritance;Interactions.InteractionChoice;Interactions.MountChoice")
  public persistent let nameOnTrueRecord: TweakDBID;

  public let nameOnTrue: String;

  @runtimeProperty("customEditor", "TweakDBGroupInheritance;Interactions.InteractionChoice;Interactions.MountChoice")
  public persistent let nameOnFalseRecord: TweakDBID;

  public let nameOnFalse: String;

  public final static func GetCurrentDisplayName(const self: script_ref<SDeviceActionBoolData>) -> String {
    return NameToString(Deref(self).currentDisplayName);
  }
}

public struct SDeviceActionCustomData extends SDeviceActionData {

  public persistent let actionID: CName;

  @runtimeProperty("category", "States Availability")
  @default(SDeviceActionCustomData, true)
  public persistent let On: Bool;

  @runtimeProperty("category", "States Availability")
  @default(SDeviceActionCustomData, true)
  public persistent let Off: Bool;

  @runtimeProperty("category", "States Availability")
  @default(SDeviceActionCustomData, false)
  public persistent let Unpowered: Bool;

  @runtimeProperty("customEditor", "TweakDBGroupInheritance;Interactions.InteractionChoice;Interactions.MountChoice")
  public persistent let displayNameRecord: TweakDBID;

  public let displayName: String;

  @default(SDeviceActionCustomData, 3)
  public let customClearance: Int32;

  public persistent let isEnabled: Bool;

  public let disableOnUse: Bool;

  public let RestrictInCombat: Bool;

  public let RestrictIfWanted: Bool;

  public let RestrictDuringPhonecall: Bool;

  public let factToEnableName: CName;

  @runtimeProperty("rangeMax", "5")
  @runtimeProperty("rangeMin", "0")
  public let quickHackCost: Int32;

  public let callbackID: Uint32;

  public final static func GetCurrentDisplayName(const self: script_ref<SDeviceActionCustomData>) -> String {
    return NameToString(Deref(self).currentDisplayName);
  }
}

public class GenericDevice extends InteractiveDevice {

  protected let m_offMeshConnectionComponent: ref<OffMeshConnectionComponent>;

  private let m_currentSpiderbotAction: ref<CustomDeviceAction>;

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
    EntityRequestComponentsInterface.RequestComponent(ri, n"offMeshConnection", n"OffMeshConnectionComponent", false);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_offMeshConnectionComponent = EntityResolveComponentsInterface.GetComponent(ri, n"offMeshConnection") as OffMeshConnectionComponent;
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as GenericDeviceController;
  }

  protected func ResolveGameplayState() -> Void {
    super.ResolveGameplayState();
    this.InitializeQuestDBCallbacks();
    this.RestoreCustomActionOperations();
  }

  protected cb func OnDetach() -> Bool {
    super.OnDetach();
    this.UnInitializeQuestDBCallbacks();
  }

  protected cb func OnCustomAction(evt: ref<CustomDeviceAction>) -> Bool {
    let locationOverride: ref<GameObject>;
    let locationOverrideGlobalRef: GlobalNodeRef;
    let locationOverrideID: EntityID;
    let locationOverrideRef: NodeRef;
    if evt.IsSpiderbotAction() {
      locationOverrideRef = evt.GetSpiderbotLocationOverrideReference();
      locationOverrideGlobalRef = ResolveNodeRefWithEntityID(locationOverrideRef, this.GetEntityID());
      if GlobalNodeRef.IsDefined(locationOverrideGlobalRef) {
        locationOverrideID = Cast<EntityID>(locationOverrideGlobalRef);
        locationOverride = GameInstance.FindEntityByID(this.GetGame(), locationOverrideID) as GameObject;
        this.SendSpiderbotOrderEvent(evt.GetExecutor(), locationOverride);
      } else {
        this.SendSpiderbotOrderEvent(evt.GetExecutor());
      };
      this.SaveCurrentSpiderbotAction(evt);
    } else {
      this.ResolveCustomAction(evt.GetActionName());
    };
    this.UpdateDeviceState();
  }

  protected cb func OnQuestToggleCustomAction(evt: ref<QuestToggleCustomAction>) -> Bool {
    this.UpdateDeviceState();
  }

  protected cb func OnToggleCustomActionEvent(evt: ref<ToggleCustomActionEvent>) -> Bool {
    this.UpdateDeviceState();
  }

  protected cb func OnQuestCustomAction(evt: ref<QuestCustomAction>) -> Bool {
    let action: ref<DeviceAction>;
    let actionName: CName;
    let context: GetActionsContext = this.GetDevicePS().GenerateContext(gamedeviceRequestType.Internal, this.GetDevicePS().GetTotalClearanceValue(), null, this.GetEntityID());
    if IsNameValid(FromVariant<CName>(evt.prop.first)) {
      actionName = FromVariant<CName>(evt.prop.first);
      action = this.GetDevicePS().GetActionByName(actionName, context);
      if action != null {
        this.ExecuteAction(action);
      };
    };
  }

  protected cb func OnActivateDevice(evt: ref<ActivateDevice>) -> Bool {
    this.GetDevicePS().GetDeviceOperationsContainer().EvaluateActivatorTriggers(this);
  }

  private final func InitializeQuestDBCallbacks() -> Void {
    if this.GetDevicePS().GetDeviceOperationsContainer() != null {
      this.GetDevicePS().InitializeQuestDBCallbacksForCustomActions();
    };
  }

  private final func UnInitializeQuestDBCallbacks() -> Void {
    if this.GetDevicePS().GetDeviceOperationsContainer() != null {
      this.GetDevicePS().UnInitializeQuestDBCallbacksForCustomActions();
    };
  }

  public const func GetDevicePS() -> ref<GenericDeviceControllerPS> {
    return this.GetController().GetPS();
  }

  private const func GetController() -> ref<GenericDeviceController> {
    return this.m_controller as GenericDeviceController;
  }

  protected cb func OnFactChanged(evt: ref<FactChangedEvent>) -> Bool {
    let factName: CName;
    super.OnFactChanged(evt);
    factName = evt.GetFactName();
    if this.GetDevicePS().GetDeviceOperationsContainer() != null {
      if this.GetDevicePS().ResolveFactOnCustomAction(factName) {
        this.UpdateDeviceState();
        if this.IsReadyForUI() {
          this.RefreshUI();
        };
        if this.GetDevicePS().HasActiveContext(gamedeviceRequestType.Direct) {
          this.RefreshInteraction(gamedeviceRequestType.Direct, GetPlayer(this.GetGame()));
        };
      };
    };
  }

  private final func ResolveCustomAction(actionID: CName) -> Void {
    if this.GetDevicePS().GetDeviceOperationsContainer() != null {
      this.GetDevicePS().GetDeviceOperationsContainer().EvaluateCustomActionTriggers(actionID, this);
    };
  }

  private final func RestoreCustomActionOperations() -> Void {
    let customActionsIDs: array<CName>;
    let i: Int32;
    if this.GetDevicePS().GetDeviceOperationsContainer() == null {
      return;
    };
    customActionsIDs = this.GetDevicePS().GetPerformedCustomActionsStorage();
    i = 0;
    while i < ArraySize(customActionsIDs) {
      this.GetDevicePS().GetDeviceOperationsContainer().RestoreCustomActionOperations(customActionsIDs[i], this);
      i += 1;
    };
  }

  protected final func SendSpiderbotOrderEvent(player: ref<GameObject>, opt locationOverride: ref<GameObject>) -> Void {
    let spiderbotOrderDeviceEvent: ref<SpiderbotOrderDeviceEvent>;
    this.SendSetIsSpiderbotInteractionOrderedEvent(true);
    spiderbotOrderDeviceEvent = new SpiderbotOrderDeviceEvent();
    spiderbotOrderDeviceEvent.target = this;
    if IsDefined(locationOverride) {
      spiderbotOrderDeviceEvent.overrideMovementTarget = locationOverride;
    };
    player.QueueEvent(spiderbotOrderDeviceEvent);
  }

  protected final func SaveCurrentSpiderbotAction(evt: ref<CustomDeviceAction>) -> Void {
    this.m_currentSpiderbotAction = evt;
  }

  protected cb func OnSpiderbotOrderCompletedEvent(evt: ref<SpiderbotOrderCompletedEvent>) -> Bool {
    this.SendSetIsSpiderbotInteractionOrderedEvent(false);
    GameInstance.GetActivityLogSystem(this.GetGame()).AddLog("SPIDERBOT HAS FINISHED USING GENERIC DEVICE " + this.GetDisplayName());
    this.ResolveCustomAction(this.m_currentSpiderbotAction.GetActionName());
    this.UpdateDeviceState();
  }

  public const func DeterminGameplayRole() -> EGameplayRole {
    let controller: ref<GenericDeviceControllerPS> = this.GetDevicePS();
    if IsDefined(controller) && IsDefined(controller.GetDeviceOperationsContainer()) {
      if controller.GetDeviceOperationsContainer().HasOperation(n"ApplyDamageDeviceOperation") {
        return EGameplayRole.ExplodeLethal;
      };
    };
    if this.HasAnyDistractions() {
      return EGameplayRole.Distract;
    };
    return super.DeterminGameplayRole();
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
}
