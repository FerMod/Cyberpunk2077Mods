
public class ActivatedDeviceController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<ActivatedDeviceControllerPS> {
    return this.GetBasePS() as ActivatedDeviceControllerPS;
  }
}

public class ActivatedDeviceControllerPS extends ScriptableDeviceComponentPS {

  protected persistent let m_animationSetup: ActivatedDeviceAnimSetup;

  protected persistent let m_activatedDeviceSetup: ActivatedDeviceSetup;

  protected let m_spiderbotInteractionLocationOverride: NodeRef;

  @default(ActivatedDeviceControllerPS, -1)
  private persistent let m_industrialArmAnimationOverride: Int32;

  public final func GetActionName() -> CName {
    return this.m_activatedDeviceSetup.m_actionName;
  }

  public final func GetInteractionName() -> TweakDBID {
    return this.m_activatedDeviceSetup.m_alternativeInteractionName;
  }

  public final func GetQuickHackName() -> TweakDBID {
    return this.m_activatedDeviceSetup.m_alternativeQuickHackName;
  }

  public final func ShouldGlitchOnActivation() -> Bool {
    return this.m_activatedDeviceSetup.m_glitchOnActivation;
  }

  public final func GetSpidebotInteractionName() -> TweakDBID {
    return this.m_activatedDeviceSetup.m_alternativeSpiderbotInteractionName;
  }

  public final func GetVFX() -> FxResource {
    return this.m_activatedDeviceSetup.vfxResource;
  }

  public final func GetActivationVFXname() -> CName {
    return this.m_activatedDeviceSetup.activationVFXname;
  }

  public final func GetAttackType() -> TweakDBID {
    return this.m_activatedDeviceSetup.attackType;
  }

  public final func ShouldRadgollOnAttack() -> Bool {
    return this.m_activatedDeviceSetup.m_shouldRagdollOnAttack;
  }

  public final func GetAnimationTime() -> Float {
    return this.m_animationSetup.m_animationTime;
  }

  public final func GetIndustrialArmAnimationOverride() -> Int32 {
    return this.m_industrialArmAnimationOverride;
  }

  public final func GetSpiderbotInteractionLocationOverride() -> NodeRef {
    return this.m_spiderbotInteractionLocationOverride;
  }

  public final const func HasQuickHack() -> Bool {
    return this.m_activatedDeviceSetup.m_hasQuickHack;
  }

  public final const func HasQuickHackDistraction() -> Bool {
    return this.m_activatedDeviceSetup.m_hasQuickHackDistraction;
  }

  public final const func HasSpiderbotInteraction() -> Bool {
    return this.m_activatedDeviceSetup.m_hasSpiderbotInteraction;
  }

  public final const func ShouldActivateTrapOnAreaEnter() -> Bool {
    return this.m_activatedDeviceSetup.m_shouldActivateTrapOnAreaEnter;
  }

  protected func GetSkillCheckContainerForSetup() -> ref<BaseSkillCheckContainer> {
    return this.m_activatedDeviceSetup.m_activatedDeviceSkillChecks;
  }

  protected final func ActionSpiderbotActivateActivator(interactionTDBID: TweakDBID) -> ref<SpiderbotActivateActivator> {
    let action: ref<SpiderbotActivateActivator> = new SpiderbotActivateActivator();
    action.SetUp(this);
    action.AddDeviceName(this.m_deviceName);
    action.CreateInteraction(interactionTDBID);
    return action;
  }

  protected final func ActionQuestToggleAutomaticAttack(toggle: Bool) -> ref<QuestToggleAutomaticAttack> {
    let action: ref<QuestToggleAutomaticAttack> = new QuestToggleAutomaticAttack();
    action.SetUp(this);
    action.AddDeviceName(this.m_deviceName);
    action.SetProperties(toggle);
    return action;
  }

  protected final func ActionQuestSetIndustrialArmAnimationOverride() -> ref<QuestSetIndustrialArmAnimationOverride> {
    let action: ref<QuestSetIndustrialArmAnimationOverride> = new QuestSetIndustrialArmAnimationOverride();
    action.SetUp(this);
    action.AddDeviceName(this.m_deviceName);
    action.SetProperties(-9999);
    return action;
  }

  protected final func ActionQuickHackActivateDevice(interactionTDBID: TweakDBID) -> ref<ActivateDevice> {
    let action: ref<ActivateDevice> = new ActivateDevice();
    action.clearanceLevel = 2;
    action.SetUp(this);
    action.SetProperties(n"Activate");
    action.AddDeviceName(this.m_deviceName);
    action.CreateInteraction(interactionTDBID);
    return action;
  }

  protected final func ActionActivateDevice(interactionTDBID: TweakDBID) -> ref<ActivateDevice> {
    let action: ref<ActivateDevice> = new ActivateDevice();
    action.clearanceLevel = 2;
    action.SetUp(this);
    action.SetProperties(this.m_activatedDeviceSetup.m_actionName);
    action.AddDeviceName(this.m_deviceName);
    action.CreateActionWidgetPackage();
    if this.m_activatedDeviceSetup.m_hasSimpleInteraction {
      action.CreateInteraction(interactionTDBID);
    };
    return action;
  }

  protected final func ActionQuickHackDistraction(interactionTDBID: TweakDBID) -> ref<QuickHackDistraction> {
    let action: ref<QuickHackDistraction> = new QuickHackDistraction();
    action = this.ActionQuickHackDistraction();
    action.CreateInteraction(interactionTDBID);
    action.SetDurationValue(this.GetDistractionDuration(action));
    return action;
  }

  protected func ActionEngineering(const context: script_ref<GetActionsContext>) -> ref<ActionEngineering> {
    let additionalActions: array<ref<DeviceAction>>;
    let action: ref<ActionEngineering> = super.ActionEngineering(context);
    action.clearanceLevel = 2;
    action.SetAvailableOnUnpowered();
    action.CreateInteraction(Deref(context).processInitiatorObject, additionalActions);
    return action;
  }

  public final func OnSpiderbotActivateActivator(evt: ref<SpiderbotActivateActivator>) -> EntityNotificationType {
    let locationOverrideID: EntityID;
    let locationOverrideNodeRef: GlobalNodeRef;
    let locationOverrideObject: wref<GameObject>;
    this.m_isSpiderbotInteractionOrdered = true;
    let spiderbotOrderDeviceEvent: ref<SpiderbotOrderDeviceEvent> = new SpiderbotOrderDeviceEvent();
    if this.m_activatedDeviceSetup.m_hasSpiderbotInteraction {
      spiderbotOrderDeviceEvent.target = this.GetOwnerEntityWeak() as GameObject;
    } else {
      spiderbotOrderDeviceEvent.target = this.GetNearestViableParent();
    };
    locationOverrideNodeRef = ResolveNodeRefWithEntityID(this.m_spiderbotInteractionLocationOverride, PersistentID.ExtractEntityID(this.GetID()));
    if GlobalNodeRef.IsDefined(locationOverrideNodeRef) {
      locationOverrideID = Cast<EntityID>(locationOverrideNodeRef);
      locationOverrideObject = GameInstance.FindEntityByID(this.GetGameInstance(), locationOverrideID) as GameObject;
      spiderbotOrderDeviceEvent.overrideMovementTarget = locationOverrideObject;
    };
    evt.GetExecutor().QueueEvent(spiderbotOrderDeviceEvent);
    return EntityNotificationType.DoNotNotifyEntity;
  }

  private final func GetNearestViableParent() -> wref<GameObject> {
    let ancestors: array<ref<DeviceComponentPS>>;
    let currentDistance: Float;
    let currentParent: wref<Entity>;
    let distanceToNearestViableParent: Float;
    let flathead: wref<GameObject>;
    let i: Int32;
    let nearestViableParent: wref<GameObject>;
    this.GetAncestors(ancestors);
    flathead = (GameInstance.GetScriptableSystemsContainer(this.GetGameInstance()).Get(n"SubCharacterSystem") as SubCharacterSystem).GetFlathead();
    i = 0;
    while i < ArraySize(ancestors) {
      if (ancestors[i] as ScriptableDeviceComponentPS).HasAnyAvailableSpiderbotActions() {
        currentParent = ancestors[i].GetOwnerEntityWeak();
        if IsDefined(currentParent) {
          currentDistance = Vector4.Distance(currentParent.GetWorldPosition(), flathead.GetWorldPosition());
          if nearestViableParent == null || currentDistance < distanceToNearestViableParent {
            nearestViableParent = currentParent as GameObject;
            distanceToNearestViableParent = currentDistance;
          };
        };
      };
      i += 1;
    };
    return nearestViableParent;
  }

  public func GetActions(out actions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    if this.IsDisabled() {
      return false;
    };
    super.GetActions(actions, context);
    ArrayPush(actions, this.ActionSetExposeQuickHacks());
    if this.ShouldGlitchOnActivation() && this.IsGlitching() {
      return false;
    };
    ArrayPush(actions, this.ActionActivateDevice(this.GetInteractionName()));
    this.SetActionIllegality(actions, this.m_illegalActions.regularActions);
    return true;
  }

  protected const func CanCreateAnyQuickHackActions() -> Bool {
    if this.IsDisabled() {
      return false;
    };
    if this.HasQuickHack() || this.HasQuickHackDistraction() {
      return true;
    };
    return false;
  }

  protected func GetQuickHackActions(out actions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    let currentAction: ref<ScriptableDeviceAction>;
    if this.IsDisabled() {
      return;
    };
    if this.HasQuickHack() {
      currentAction = this.ActionQuickHackActivateDevice(this.GetQuickHackName());
      currentAction.SetObjectActionID(t"DeviceAction.ToggleStateClassHack");
      ArrayPush(actions, currentAction);
    };
    if this.HasQuickHackDistraction() {
      currentAction = this.ActionQuickHackDistraction(this.GetQuickHackName());
      currentAction.SetObjectActionID(t"DeviceAction.MalfunctionClassHack");
      currentAction.SetInactiveWithReason(!this.IsDistracting(), "LocKey#7004");
      ArrayPush(actions, currentAction);
    };
    this.FinalizeGetQuickHackActions(actions, context);
  }

  protected func CanCreateAnySpiderbotActions() -> Bool {
    let ancestors: array<ref<DeviceComponentPS>>;
    let i: Int32;
    if this.IsDisabled() {
      return false;
    };
    if this.HasSpiderbotInteraction() {
      return true;
    };
    this.GetAncestors(ancestors);
    i = 0;
    while i < ArraySize(ancestors) {
      if (ancestors[i] as ScriptableDeviceComponentPS).HasAnyAvailableSpiderbotActions() {
        return true;
      };
      i += 1;
    };
    return false;
  }

  protected func GetSpiderbotActions(outActions: script_ref<[ref<DeviceAction>]>, const context: script_ref<GetActionsContext>) -> Void {
    let ancestors: array<ref<DeviceComponentPS>>;
    let i: Int32;
    if this.IsDisabled() {
      return;
    };
    this.GetAncestors(ancestors);
    i = 0;
    while i < ArraySize(ancestors) {
      if (ancestors[i] as ScriptableDeviceComponentPS).HasAnyAvailableSpiderbotActions() {
        ArrayPush(Deref(outActions), this.ActionSpiderbotActivateActivator(this.GetSpidebotInteractionName()));
        break;
      };
      i += 1;
    };
    if this.HasSpiderbotInteraction() {
      ArrayPush(Deref(outActions), this.ActionSpiderbotActivateActivator(this.GetSpidebotInteractionName()));
    };
  }

  public func GetQuestActionByName(actionName: CName) -> ref<DeviceAction> {
    let action: ref<DeviceAction> = super.GetQuestActionByName(actionName);
    if action == null {
      switch actionName {
        case n"ActivateDevice":
          action = this.ActionActivateDevice();
          break;
        case n"QuestEnableAutomaticAttack":
          action = this.ActionQuestToggleAutomaticAttack(true);
          break;
        case n"QuestDisableAutomaticAttack":
          action = this.ActionQuestToggleAutomaticAttack(false);
          break;
        case n"QuestSetIndustrialArmAnimationOverride":
          action = this.ActionQuestSetIndustrialArmAnimationOverride();
      };
    };
    return action;
  }

  public func GetQuestActions(out actions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    super.GetQuestActions(actions, context);
    ArrayPush(actions, this.ActionActivateDevice());
    ArrayPush(actions, this.ActionQuestToggleAutomaticAttack(true));
    ArrayPush(actions, this.ActionQuestToggleAutomaticAttack(false));
    ArrayPush(actions, this.ActionQuestSetIndustrialArmAnimationOverride());
  }

  protected func OnActivateDevice(evt: ref<ActivateDevice>) -> EntityNotificationType {
    super.OnActivateDevice(evt);
    this.UseNotifier(evt);
    if this.IsON() {
      this.SetDeviceState(EDeviceStatus.OFF);
    } else {
      this.SetDeviceState(EDeviceStatus.ON);
    };
    if this.m_activatedDeviceSetup.m_disableOnActivation {
      this.SetDeviceState(EDeviceStatus.DISABLED);
    };
    if this.ShouldGlitchOnActivation() {
      this.m_isGlitching = true;
    };
    return EntityNotificationType.SendThisEventToEntity;
  }

  protected final func OnQuestToggleAutomaticAttack(evt: ref<QuestToggleAutomaticAttack>) -> EntityNotificationType {
    this.UseNotifier(evt);
    this.m_activatedDeviceSetup.m_shouldActivateTrapOnAreaEnter = FromVariant<Bool>(evt.prop.first);
    return EntityNotificationType.DoNotNotifyEntity;
  }

  protected final func OnQuestSetIndustrialArmAnimationOverride(evt: ref<QuestSetIndustrialArmAnimationOverride>) -> EntityNotificationType {
    this.UseNotifier(evt);
    this.m_industrialArmAnimationOverride = FromVariant<Int32>(evt.prop.first);
    return EntityNotificationType.SendThisEventToEntity;
  }

  public func OnActionEngineering(evt: ref<ActionEngineering>) -> EntityNotificationType {
    if !evt.WasPassed() {
      return EntityNotificationType.DoNotNotifyEntity;
    };
    super.OnActionEngineering(evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  public final func ActivateThisDevice() -> Void {
    let activateAction: ref<ActivateDevice> = new ActivateDevice();
    activateAction = this.ActionActivateDevice();
    this.ExecutePSAction(activateAction);
  }

  protected func GetInkWidgetTweakDBID(const context: script_ref<GetActionsContext>) -> TweakDBID {
    if TDBID.IsValid(this.m_activatedDeviceSetup.m_deviceWidgetRecord) {
      return this.m_activatedDeviceSetup.m_deviceWidgetRecord;
    };
    return t"DevicesUIDefinitions.GenericDeviceWidget";
  }

  protected func GetDeviceIconTweakDBID() -> TweakDBID {
    return this.m_activatedDeviceSetup.m_thumbnailIconRecord;
  }
}

public class QuestToggleAutomaticAttack extends ActionBool {

  public final func SetProperties(toggle: Bool) -> Void {
    if toggle {
      this.actionName = n"QuestEnableAutomaticAttack";
      this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(this.actionName, toggle, n"QuestEnableAutomaticAttack", n"QuestDisableAutomaticAttack");
    } else {
      this.actionName = n"QuestDisableAutomaticAttack";
      this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(this.actionName, toggle, n"QuestEnableAutomaticAttack", n"QuestDisableAutomaticAttack");
    };
  }
}

public class QuestSetIndustrialArmAnimationOverride extends ActionInt {

  public final func SetProperties(animation: Int32) -> Void {
    this.actionName = n"QuestSetIndustrialArmAnimationOverride";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Int(n"animNumer", animation);
  }
}
