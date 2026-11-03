
public class SpiderbotActivateActivator extends ActionBool {

  public final func SetProperties() -> Void {
    this.actionName = n"SpiderbotActivateActivator";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(this.actionName, true, n"LocKey#388", n"LocKey#388");
  }

  public func GetTweakDBChoiceRecord() -> String {
    return "SpiderbotActivateActivator";
  }

  public final static func IsAvailable(device: ref<ScriptableDeviceComponentPS>) -> Bool {
    if !AIActionHelper.CheckFlatheadStatPoolRequirements(device.GetGameInstance(), "DeviceAction") {
      return false;
    };
    return true;
  }

  public final static func IsClearanceValid(clearance: ref<Clearance>) -> Bool {
    if Clearance.IsInRange(clearance, 2) {
      return true;
    };
    return false;
  }

  public final static func IsContextValid(const context: script_ref<GetActionsContext>) -> Bool {
    if Equals(Deref(context).requestType, gamedeviceRequestType.Remote) {
      return true;
    };
    return false;
  }
}

public class ActivatorController extends MasterController {

  public const func GetPS() -> ref<ActivatorControllerPS> {
    return this.GetBasePS() as ActivatorControllerPS;
  }
}

public class ActivatorControllerPS extends MasterControllerPS {

  @runtimeProperty("category", "AvailableInteractions")
  @default(ActivatorControllerPS, false)
  private let m_hasSpiderbotInteraction: Bool;

  @runtimeProperty("category", "AvailableInteractions")
  private let m_spiderbotInteractionLocationOverride: NodeRef;

  @runtimeProperty("category", "AvailableInteractions")
  @default(ActivatorControllerPS, true)
  private let m_hasSimpleInteraction: Bool;

  @runtimeProperty("category", "InteractionNamesSetup")
  @runtimeProperty("customEditor", "TweakDBGroupInheritance;Interactions.InteractionChoice;Interactions.MountChoice")
  private let m_alternativeInteractionName: TweakDBID;

  @runtimeProperty("category", "InteractionNamesSetup")
  @runtimeProperty("customEditor", "TweakDBGroupInheritance;Interactions.InteractionChoice;Interactions.MountChoice")
  private let m_alternativeSpiderbotInteractionName: TweakDBID;

  @runtimeProperty("category", "InteractionNamesSetup")
  @runtimeProperty("customEditor", "TweakDBGroupInheritance;Interactions.InteractionChoice;Interactions.MountChoice")
  private let m_alternativeQuickHackName: TweakDBID;

  private inline let m_activatorSkillChecks: ref<GenericContainer>;

  @default(ActivatorControllerPS, ToggleActivate)
  private let m_alternativeInteractionString: String;

  protected func GetSkillCheckContainerForSetup() -> ref<BaseSkillCheckContainer> {
    return this.m_activatorSkillChecks;
  }

  protected func GameAttached() -> Void;

  public func GetActions(out outActions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    super.GetActions(outActions, context);
    if this.m_hasSimpleInteraction {
      ArrayPush(outActions, this.ActionToggleActivation(this.m_alternativeInteractionName));
    };
    this.SetActionIllegality(outActions, this.m_illegalActions.regularActions);
    return true;
  }

  protected const func CanCreateAnyQuickHackActions() -> Bool {
    return true;
  }

  protected func GetQuickHackActions(out actions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    let currentAction: ref<ScriptableDeviceAction> = this.ActionToggleActivation(this.m_alternativeQuickHackName);
    currentAction.SetObjectActionID(t"DeviceAction.ToggleStateClassHack");
    ArrayPush(actions, currentAction);
    this.FinalizeGetQuickHackActions(actions, context);
  }

  protected func CanCreateAnySpiderbotActions() -> Bool {
    if this.m_hasSpiderbotInteraction && this.IsPowered() {
      return true;
    };
    return false;
  }

  protected func GetSpiderbotActions(actions: script_ref<[ref<DeviceAction>]>, const context: script_ref<GetActionsContext>) -> Void {
    if this.m_hasSpiderbotInteraction && this.IsPowered() && GameInstance.GetStatsSystem(this.GetGameInstance()).GetStatBoolValue(Cast<StatsObjectID>(GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerMainGameObject().GetEntityID()), gamedataStatType.HasSpiderBotControl) {
      if AIActionHelper.CheckFlatheadStatPoolRequirements(this.GetGameInstance(), "DeviceAction") {
        ArrayPush(Deref(actions), this.ActionSpiderbotActivateActivator(this.m_alternativeSpiderbotInteractionName));
      };
    };
  }

  public func GetQuestActionByName(actionName: CName) -> ref<DeviceAction> {
    let action: ref<DeviceAction> = super.GetQuestActionByName(actionName);
    if action == null {
      switch actionName {
        case n"ForceActivate":
          action = this.ActionQuestForceActivate();
      };
    };
    return action;
  }

  public func GetQuestActions(out actions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    super.GetQuestActions(actions, context);
    ArrayPush(actions, this.ActionQuestForceActivate());
  }

  public final func GetSpiderbotInteractionLocationOverride() -> NodeRef {
    return this.m_spiderbotInteractionLocationOverride;
  }

  public final func ActivateConnectedDevices() -> Void {
    let activateAction: ref<ActivateDevice>;
    let devices: array<ref<DeviceComponentPS>> = this.GetImmediateSlaves();
    this.m_hasSpiderbotInteraction = false;
    let i: Int32 = 0;
    while i < ArraySize(devices) {
      if IsDefined(devices[i] as VentilationAreaControllerPS) {
        this.ExtractActionFromSlave(devices[i], n"ActivateDevice", activateAction);
      } else {
        if IsDefined(devices[i] as AOEAreaControllerPS) {
          this.ExtractActionFromSlave(devices[i], n"ActivateDevice", activateAction);
        } else {
          activateAction = this.ActionActivateDevice();
        };
      };
      if IsDefined(activateAction) {
        this.ExecutePSAction(activateAction, devices[i]);
      };
      i += 1;
    };
  }

  protected func ActionEngineering(const context: script_ref<GetActionsContext>) -> ref<ActionEngineering> {
    let additionalActions: array<ref<DeviceAction>>;
    let action: ref<ActionEngineering> = super.ActionEngineering(context);
    action.clearanceLevel = 2;
    action.SetAvailableOnUnpowered();
    action.CreateInteraction(Deref(context).processInitiatorObject, additionalActions);
    return action;
  }

  protected func ActionDemolition(const context: script_ref<GetActionsContext>) -> ref<ActionDemolition> {
    let action: ref<ActionDemolition>;
    let additionalActions: array<ref<DeviceAction>>;
    ArrayPush(additionalActions, this.ActionToggleActivation());
    action = super.ActionDemolition(context);
    action.SetAvailableOnUnpowered();
    action.CreateInteraction(Deref(context).processInitiatorObject, additionalActions);
    return action;
  }

  public func OnActionDemolition(evt: ref<ActionDemolition>) -> EntityNotificationType {
    if !evt.WasPassed() {
      return EntityNotificationType.DoNotNotifyEntity;
    };
    super.OnActionDemolition(evt);
    if evt.IsCompleted() {
    };
    return EntityNotificationType.DoNotNotifyEntity;
  }

  public func OnActionEngineering(evt: ref<ActionEngineering>) -> EntityNotificationType {
    if !evt.WasPassed() {
      return EntityNotificationType.DoNotNotifyEntity;
    };
    super.OnActionEngineering(evt);
    if evt.IsCompleted() {
      this.DisableDevice();
      this.ActivateConnectedDevices();
      return EntityNotificationType.SendThisEventToEntity;
    };
    return EntityNotificationType.DoNotNotifyEntity;
  }

  protected func ResolveActionHackingCompleted(evt: ref<ActionHacking>) -> Void {
    super.ResolveActionHackingCompleted(evt);
    if NotEquals(evt.GetAttributeCheckType(), EDeviceChallengeSkill.Invalid) {
      this.DisableDevice();
      this.ActivateConnectedDevices();
    };
  }

  protected final func ActionToggleActivation(interactionTDBID: TweakDBID) -> ref<ToggleActivation> {
    let action: ref<ToggleActivation> = new ToggleActivation();
    action.SetUp(this);
    action.SetProperties(this.m_deviceState);
    action.AddDeviceName(this.m_deviceName);
    action.CreateInteraction(this.m_alternativeInteractionString, interactionTDBID);
    return action;
  }

  protected final func ActionSpiderbotActivateActivator(interactionTDBID: TweakDBID) -> ref<SpiderbotActivateActivator> {
    let action: ref<SpiderbotActivateActivator> = new SpiderbotActivateActivator();
    action.SetUp(this);
    action.AddDeviceName(this.m_deviceName);
    action.CreateInteraction(interactionTDBID);
    return action;
  }

  public final func OnSpiderbotActivateActivator(evt: ref<SpiderbotActivateActivator>) -> EntityNotificationType {
    this.m_isSpiderbotInteractionOrdered = true;
    return EntityNotificationType.SendThisEventToEntity;
  }

  public func OnDisassembleDevice(evt: ref<DisassembleDevice>) -> EntityNotificationType {
    this.DisableDevice();
    return super.OnDisassembleDevice(evt);
  }

  public func OnToggleActivation(evt: ref<ToggleActivation>) -> EntityNotificationType {
    this.UseNotifier(evt);
    if this.IsEnabled() {
      this.DisableDevice();
      this.ActivateConnectedDevices();
      this.m_hasSpiderbotInteraction = false;
      return EntityNotificationType.SendThisEventToEntity;
    };
    return EntityNotificationType.DoNotNotifyEntity;
  }

  public func OnQuestForceActivate(evt: ref<QuestForceActivate>) -> EntityNotificationType {
    this.UseNotifier(evt);
    if this.IsEnabled() {
      this.DisableDevice();
      this.ActivateConnectedDevices();
      this.m_hasSpiderbotInteraction = false;
      return EntityNotificationType.SendThisEventToEntity;
    };
    return EntityNotificationType.DoNotNotifyEntity;
  }
}
