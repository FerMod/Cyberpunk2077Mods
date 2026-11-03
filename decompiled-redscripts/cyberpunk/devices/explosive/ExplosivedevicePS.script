
public class ExplosiveDeviceController extends BasicDistractionDeviceController {

  public const func GetPS() -> ref<ExplosiveDeviceControllerPS> {
    return this.GetBasePS() as ExplosiveDeviceControllerPS;
  }
}

public class ExplosiveDeviceControllerPS extends BasicDistractionDeviceControllerPS {

  protected inline let m_explosiveSkillChecks: ref<EngDemoContainer>;

  @runtimeProperty("category", "Explosive properties")
  @runtimeProperty("tooltip", "The FIRST element in the vfxResourceOnFirstHit array will be used for normal first hit effects, the SECOND element will only be used if the device has a distraction collider and that is what is hit by the player.")
  protected edit const let m_explosionDefinition: [ExplosiveDeviceResourceDefinition];

  @runtimeProperty("category", "Explosive properties")
  protected edit let m_explosiveWithQhacks: Bool;

  @runtimeProperty("category", "Explosive properties")
  @default(ExplosiveDeviceControllerPS, 0f)
  protected let m_HealthDecay: Float;

  @runtimeProperty("category", "Explosive properties")
  @default(ExplosiveDeviceControllerPS, 0.1f)
  protected let m_timeToMeshSwap: Float;

  @runtimeProperty("category", "Explosive properties")
  protected edit let m_shouldDistractionHitVFXIgnoreHitPosition: Bool;

  @runtimeProperty("category", "Explosive properties")
  protected edit let m_canBeDisabledWithQhacks: Bool;

  protected let m_disarmed: Bool;

  private persistent let m_exploded: Bool;

  @runtimeProperty("category", "Tech design")
  @default(ExplosiveDeviceControllerPS, true)
  protected edit let m_provideExplodeAction: Bool;

  @runtimeProperty("category", "Tech design")
  @default(ExplosiveDeviceControllerPS, true)
  protected edit let m_doExplosiveEngineerLogic: Bool;

  protected cb func OnInstantiated() -> Bool {
    super.OnInstantiated();
    if !IsStringValid(this.m_deviceName) {
      this.m_deviceName = "LocKey#42163";
    };
  }

  protected func GetSkillCheckContainerForSetup() -> ref<BaseSkillCheckContainer> {
    return this.m_explosiveSkillChecks;
  }

  protected func GameAttached() -> Void;

  public final func PushPersistentData() -> Void;

  public final func GetExplosionDefinition(index: Int32) -> ExplosiveDeviceResourceDefinition {
    return this.m_explosionDefinition[index];
  }

  public final func GetExplosionDefinitionArray() -> [ExplosiveDeviceResourceDefinition] {
    return this.m_explosionDefinition;
  }

  public final const func IsExplosiveWithQhacks() -> Bool {
    return this.m_explosiveWithQhacks;
  }

  public final func GetHealthDecay() -> Float {
    return this.m_HealthDecay;
  }

  public final func GetTimeToMeshSwap() -> Float {
    return this.m_timeToMeshSwap;
  }

  public final func GetDistractionHitVFXIgnoreHitPosition() -> Bool {
    return this.m_shouldDistractionHitVFXIgnoreHitPosition;
  }

  public final const func IsDisabledWithQhacks() -> Bool {
    return this.m_canBeDisabledWithQhacks;
  }

  public final const quest func IsExploded() -> Bool {
    return this.m_exploded;
  }

  public final func DoExplosiveResolveGameplayLogic() -> Bool {
    if !this.m_doExplosiveEngineerLogic || !this.m_provideExplodeAction {
      return false;
    };
    return true;
  }

  public final func SetExplodedState(state: Bool) -> Void {
    this.m_exploded = state;
    this.SendPSChangedEvent();
  }

  protected final func ActionSpiderbotExplodeExplosiveDevice() -> ref<SpiderbotExplodeExplosiveDevice> {
    let action: ref<SpiderbotExplodeExplosiveDevice> = new SpiderbotExplodeExplosiveDevice();
    action.clearanceLevel = 2;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    action.CreateInteraction();
    return action;
  }

  public final func OnSpiderbotExplodeExplosiveDevice(evt: ref<SpiderbotExplodeExplosiveDevice>) -> EntityNotificationType {
    this.SendSpiderbotToPerformAction(this.ActionSpiderbotExplodeExplosiveDevicePerformed(), evt.GetExecutor());
    return EntityNotificationType.SendThisEventToEntity;
  }

  protected final func ActionSpiderbotExplodeExplosiveDevicePerformed() -> ref<SpiderbotExplodeExplosiveDevicePerformed> {
    let action: ref<SpiderbotExplodeExplosiveDevicePerformed> = new SpiderbotExplodeExplosiveDevicePerformed();
    action.clearanceLevel = 2;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    return action;
  }

  public final func OnSpiderbotExplodeExplosiveDevicePerformed(evt: ref<SpiderbotExplodeExplosiveDevicePerformed>) -> EntityNotificationType {
    return EntityNotificationType.SendThisEventToEntity;
  }

  protected final func ActionSpiderbotDistractExplosiveDevice() -> ref<SpiderbotDistractExplosiveDevice> {
    let action: ref<SpiderbotDistractExplosiveDevice> = new SpiderbotDistractExplosiveDevice();
    action.clearanceLevel = 2;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    action.CreateInteraction();
    return action;
  }

  public final func OnSpiderbotDistractExplosiveDevice(evt: ref<SpiderbotDistractExplosiveDevice>) -> EntityNotificationType {
    this.m_distractExecuted = true;
    this.SendSpiderbotToPerformAction(this.ActionSpiderbotDistractExplosiveDevicePerformed(), evt.GetExecutor());
    this.UseNotifier(evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  protected final func ActionSpiderbotDistractExplosiveDevicePerformed() -> ref<SpiderbotDistractExplosiveDevicePerformed> {
    let action: ref<SpiderbotDistractExplosiveDevicePerformed> = new SpiderbotDistractExplosiveDevicePerformed();
    action.clearanceLevel = 2;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    return action;
  }

  public final func OnSpiderbotDistractExplosiveDevicePerformed(evt: ref<SpiderbotDistractExplosiveDevicePerformed>) -> EntityNotificationType {
    this.UseNotifier(evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  protected final func ActionQuestForceDetonate() -> ref<QuestForceDetonate> {
    let action: ref<QuestForceDetonate> = new QuestForceDetonate();
    action.clearanceLevel = 2;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    return action;
  }

  public final func OnQuestForceDetonate(evt: ref<QuestForceDetonate>) -> EntityNotificationType {
    return EntityNotificationType.SendThisEventToEntity;
  }

  protected final func ActionForceDetonate() -> ref<ForceDetonate> {
    let action: ref<ForceDetonate> = new ForceDetonate();
    action.clearanceLevel = 2;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    action.CreateActionWidgetPackage();
    return action;
  }

  public final func OnForceDetonate(evt: ref<ForceDetonate>) -> EntityNotificationType {
    this.UseNotifier(evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  protected final func ActionQuickHackExplodeExplosive() -> ref<QuickHackExplodeExplosive> {
    let action: ref<QuickHackExplodeExplosive> = new QuickHackExplodeExplosive();
    action.clearanceLevel = 10;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    action.CreateInteraction();
    return action;
  }

  public final func OnQuickHackExplodeExplosive(evt: ref<QuickHackExplodeExplosive>) -> EntityNotificationType {
    this.ForceDisableDevice();
    this.UseNotifier(evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  protected final func ActionQuickHackDistractExplosive() -> ref<QuickHackDistractExplosive> {
    let action: ref<QuickHackDistractExplosive> = new QuickHackDistractExplosive();
    action.clearanceLevel = 10;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    action.CreateInteraction();
    return action;
  }

  protected func ActionQuickHackToggleON() -> ref<QuickHackToggleON> {
    let action: ref<QuickHackToggleON> = super.ActionQuickHackToggleON();
    if this.IsON() {
      action.CreateInteraction(t"Interactions.Disarm");
    } else {
      action.CreateInteraction(t"Interactions.Arm");
    };
    return action;
  }

  public func GetActions(out actions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    if !super.GetActions(actions, context) {
      return false;
    };
    if this.m_provideExplodeAction {
      ArrayPush(actions, this.ActionForceDetonate());
      this.SetActionIllegality(actions, this.m_illegalActions.regularActions);
    };
    return true;
  }

  public func GetQuestActionByName(actionName: CName) -> ref<DeviceAction> {
    let action: ref<DeviceAction> = super.GetQuestActionByName(actionName);
    if action == null {
      switch actionName {
        case n"ForceDetonate":
          action = this.ActionQuestForceDetonate();
      };
    };
    return action;
  }

  public func GetQuestActions(out actions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    super.GetQuestActions(actions, context);
    ArrayPush(actions, this.ActionQuestForceDetonate());
  }

  protected const func CanCreateAnyQuickHackActions() -> Bool {
    if this.IsExplosiveWithQhacks() {
      return true;
    };
    return false;
  }

  protected func GetQuickHackActions(out actions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    let currentAction: ref<ScriptableDeviceAction>;
    let target: wref<GameObject> = this.GetOwnerEntityWeak() as GameObject;
    super.GetQuickHackActions(actions, context);
    if !this.IsExplosiveWithQhacks() {
      return;
    };
    if IsDefined(target) && !target.IsTurret() && this.IsON() && this.IsDisabledWithQhacks() {
      currentAction = this.ActionQuickHackToggleON();
      currentAction.SetObjectActionID(t"DeviceAction.ToggleStateClassHack");
      ArrayPush(actions, currentAction);
    };
    if this.HasNPCWorkspotKillInteraction() && this.IsSomeoneUsingNPCWorkspot() {
      currentAction = this.ActionOverloadDevice();
      if IsDefined(target) && !target.IsTurret() {
        currentAction.SetObjectActionID(t"DeviceAction.OverloadClassHack");
      } else {
        currentAction.SetObjectActionID(t"DeviceAction.TurretOverloadClassHack");
      };
      currentAction.SetInactiveWithReason(!this.m_wasQuickHacked && this.IsSomeoneUsingNPCWorkspot(), "LocKey#7011");
      ArrayPush(actions, currentAction);
    } else {
      currentAction = this.ActionQuickHackExplodeExplosive();
      if IsDefined(target) && !target.IsTurret() {
        currentAction.SetObjectActionID(t"DeviceAction.OverloadClassHack");
      } else {
        currentAction.SetObjectActionID(t"DeviceAction.TurretOverloadClassHack");
      };
      ArrayPush(actions, currentAction);
    };
    this.FinalizeGetQuickHackActions(actions, context);
  }

  protected func GetDeviceIconTweakDBID() -> TweakDBID {
    return t"DeviceIcons.ExplosionDeviceIcon";
  }

  protected func GetBackgroundTextureTweakDBID() -> TweakDBID {
    return t"DeviceIcons.ExplosionDeviceBackground";
  }

  public func OnActionEngineering(evt: ref<ActionEngineering>) -> EntityNotificationType {
    if !evt.WasPassed() {
      return EntityNotificationType.DoNotNotifyEntity;
    };
    super.OnActionEngineering(evt);
    if evt.IsCompleted() {
      if this.IsON() && this.m_doExplosiveEngineerLogic {
        this.Disarm(evt);
        RPGManager.GiveReward(evt.GetExecutor().GetGame(), t"RPGActionRewards.ExtractPartsSecurityTurret");
        return EntityNotificationType.SendThisEventToEntity;
      };
    };
    return EntityNotificationType.SendThisEventToEntity;
  }

  protected func Disarm(action: ref<ScriptableDeviceAction>) -> Void {
    let actionToSend: ref<ScriptableDeviceAction> = this.ActionToggleON();
    actionToSend.RegisterAsRequester(PersistentID.ExtractEntityID(this.GetID()));
    actionToSend.SetExecutor(action.GetExecutor());
    this.GetPersistencySystem().QueuePSDeviceEvent(actionToSend);
    this.SetBlockSecurityWakeUp(true);
    this.m_disarmed = true;
  }
}

public class SpiderbotExplodeExplosiveDevice extends ActionBool {

  public final func SetProperties() -> Void {
    this.actionName = n"SpiderbotExplodeExplosiveDevice";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(this.actionName, true, n"LocKey#389", n"LocKey#389");
  }

  public func GetTweakDBChoiceRecord() -> String {
    return "SpiderbotExplodeExplosiveDevice";
  }

  public final static func IsAvailable(device: ref<ScriptableDeviceComponentPS>) -> Bool {
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

public class SpiderbotExplodeExplosiveDevicePerformed extends ActionBool {

  public final func SetProperties() -> Void {
    this.actionName = n"SpiderbotExplodeExplosiveDevicePerformed";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(this.actionName, true, n"SpiderbotExplodeExplosiveDevicePerformed", n"SpiderbotExplodeExplosiveDevicePerformed");
  }

  public final static func IsAvailable(device: ref<ScriptableDeviceComponentPS>) -> Bool {
    return true;
  }

  public final static func IsClearanceValid(clearance: ref<Clearance>) -> Bool {
    return true;
  }

  public final static func IsContextValid(const context: script_ref<GetActionsContext>) -> Bool {
    return true;
  }
}

public class SpiderbotDistractExplosiveDevice extends ActionBool {

  public final func SetProperties() -> Void {
    this.actionName = n"SpiderbotDistractExplosiveDevice";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(this.actionName, true, n"LocKey#390", n"LocKey#390");
  }

  public func GetTweakDBChoiceRecord() -> String {
    return "SpiderbotDistractExplosiveDevice";
  }

  public final static func IsAvailable(device: ref<ScriptableDeviceComponentPS>) -> Bool {
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

public class SpiderbotDistractExplosiveDevicePerformed extends ActionBool {

  public final func SetProperties() -> Void {
    this.actionName = n"SpiderbotDistractExplosiveDevicePerformed";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(this.actionName, true, n"SpiderbotDistractExplosiveDevicePerformed", n"SpiderbotDistractExplosiveDevicePerformed");
  }

  public final static func IsAvailable(device: ref<ScriptableDeviceComponentPS>) -> Bool {
    return true;
  }

  public final static func IsClearanceValid(clearance: ref<Clearance>) -> Bool {
    return true;
  }

  public final static func IsContextValid(const context: script_ref<GetActionsContext>) -> Bool {
    return true;
  }
}

public class QuestForceDetonate extends ActionBool {

  public final func SetProperties() -> Void {
    this.actionName = n"ForceDetonate";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(n"QuestForceDetonate", true, n"QuestForceDetonate", n"QuestForceDetonate");
  }
}

public class ForceDetonate extends ActionBool {

  public final func SetProperties() -> Void {
    this.actionName = n"ForceDetonate";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(n"ForceDetonate", true, n"LocKey#17832", n"LocKey#17832");
  }
}

public class QuickHackExplodeExplosive extends ActionBool {

  public func GetBaseCost() -> Int32 {
    if this.m_isQuickHack {
      return super.GetBaseCost();
    };
    return 0;
  }

  public final func SetProperties() -> Void {
    this.actionName = n"QuickHackExplodeExplosive";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(n"QuickHackExplodeExplosive", true, n"LocKey#1607", n"LocKey#1607");
  }
}

public class QuickHackDistractExplosive extends ActionBool {

  public func GetBaseCost() -> Int32 {
    if this.m_isQuickHack {
      return super.GetBaseCost();
    };
    return 0;
  }

  public final func SetProperties() -> Void {
    this.actionName = n"QuickHackDistractExplosive";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(n"QuickHackDistractExplosive", true, n"LocKey#375", n"LocKey#375");
  }
}
