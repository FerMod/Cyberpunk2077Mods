
public class BasicDistractionDeviceController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<BasicDistractionDeviceControllerPS> {
    return this.GetBasePS() as BasicDistractionDeviceControllerPS;
  }
}

public class BasicDistractionDeviceControllerPS extends ScriptableDeviceComponentPS {

  @runtimeProperty("category", "Distraction properties")
  @default(BasicDistractionDeviceControllerPS, EPlaystyleType.NETRUNNER)
  protected edit let m_distractorType: EPlaystyleType;

  protected inline let m_basicDistractionDeviceSkillChecks: ref<EngDemoContainer>;

  @runtimeProperty("category", "Distraction properties")
  protected edit const let m_effectOnStartNames: [CName];

  @runtimeProperty("category", "Distraction properties")
  @default(BasicDistractionDeviceControllerPS, EAnimationType.TRANSFORM)
  protected edit let m_animationType: EAnimationType;

  @runtimeProperty("category", "Tech design")
  protected edit let m_forceAnimationSystem: Bool;

  @runtimeProperty("category", "Distraction properties")
  @runtimeProperty("customEditor", "TweakDBGroupInheritance;ObjectAction")
  @runtimeProperty("tooltip", "Leave empty if you want to keep the default one")
  public let m_overrideDistractionActionId: TweakDBID;

  protected cb func OnInstantiated() -> Bool {
    super.OnInstantiated();
  }

  protected func Initialize() -> Void {
    super.Initialize();
  }

  protected func GameAttached() -> Void;

  protected func GetSkillCheckContainerForSetup() -> ref<BaseSkillCheckContainer> {
    return this.m_basicDistractionDeviceSkillChecks;
  }

  public final const func GetAnimationType() -> EAnimationType {
    return this.m_animationType;
  }

  public final const func GetForceAnimationSystem() -> Bool {
    return this.m_forceAnimationSystem;
  }

  public final const func GetEffectOnStartNames() -> [CName] {
    return this.m_effectOnStartNames;
  }

  protected func ActionQuickHackDistraction() -> ref<QuickHackDistraction> {
    let action: ref<QuickHackDistraction> = new QuickHackDistraction();
    action.SetUp(this);
    action.SetProperties();
    if TDBID.IsValid(this.m_overrideDistractionActionId) {
      action.SetObjectActionID(this.m_overrideDistractionActionId);
    } else {
      action.SetObjectActionID(t"DeviceAction.MalfunctionClassHack");
    };
    action.AddDeviceName(this.m_deviceName);
    action.SetExecutor(GetPlayer(this.GetGameInstance()));
    action.SetDurationValue(action.GetModifiedDurationTime(this.GetDistractionDuration(action)));
    action.CreateInteraction();
    return action;
  }

  protected final func ActionSpiderbotDistractDevice() -> ref<SpiderbotDistractDevice> {
    let action: ref<SpiderbotDistractDevice> = new SpiderbotDistractDevice();
    action.clearanceLevel = 2;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    action.CreateInteraction();
    return action;
  }

  protected final func ActionSpiderbotDistractDevicePerformed() -> ref<SpiderbotDistractDevicePerformed> {
    let action: ref<SpiderbotDistractDevicePerformed> = new SpiderbotDistractDevicePerformed();
    action.clearanceLevel = 2;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    return action;
  }

  protected func CanCreateAnySpiderbotActions() -> Bool {
    if Equals(this.m_distractorType, EPlaystyleType.TECHIE) {
      return true;
    };
    return false;
  }

  protected func GetSpiderbotActions(actions: script_ref<[ref<DeviceAction>]>, const context: script_ref<GetActionsContext>) -> Void {
    if Equals(this.m_distractorType, EPlaystyleType.NETRUNNER) {
      return;
    };
    if !this.IsDistracting() {
      ArrayPush(Deref(actions), this.ActionSpiderbotDistractDevice());
    };
  }

  protected const func CanCreateAnyQuickHackActions() -> Bool {
    return Equals(this.m_distractorType, EPlaystyleType.NETRUNNER);
  }

  protected func GetQuickHackActions(out actions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    let currentAction: ref<ScriptableDeviceAction>;
    super.GetQuickHackActions(actions, context);
    if Equals(this.m_distractorType, EPlaystyleType.TECHIE) || Equals(this.m_distractorType, EPlaystyleType.NONE) {
      return;
    };
    currentAction = this.ActionQuickHackDistraction();
    currentAction.SetInactiveWithReason(!this.IsDistracting(), "LocKey#7004");
    ArrayPush(actions, currentAction);
    this.FinalizeGetQuickHackActions(actions, context);
  }

  public final func OnSpiderbotDistractExplosiveDevice(evt: ref<SpiderbotDistractDevice>) -> EntityNotificationType {
    this.m_distractExecuted = true;
    let action: ref<ScriptableDeviceAction> = this.ActionSpiderbotDistractDevicePerformed();
    action.SetDurationValue(this.GetDistractionDuration(action));
    this.SendSpiderbotToPerformAction(action, evt.GetExecutor());
    this.UseNotifier(evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  public final func OnSpiderbotDistractExplosiveDevicePerformed(evt: ref<SpiderbotDistractDevicePerformed>) -> EntityNotificationType {
    if evt.IsStarted() {
      this.m_distractExecuted = true;
      evt.SetCanTriggerStim(true);
      this.ExecutePSActionWithDelay(evt, this, evt.GetDurationValue());
    } else {
      this.m_distractExecuted = false;
      evt.SetCanTriggerStim(false);
    };
    this.UseNotifier(evt);
    if !IsFinal() {
    };
    return EntityNotificationType.SendThisEventToEntity;
  }
}

public class SpiderbotDistractDevice extends ActionBool {

  public final func SetProperties() -> Void {
    this.actionName = n"SpiderbotDistractDevice";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(this.actionName, true, n"LocKey#596", n"LocKey#596");
  }

  public func GetTweakDBChoiceRecord() -> String {
    return "SpiderbotDistraction";
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

public class SpiderbotDistractDevicePerformed extends ActionBool {

  public final func SetProperties() -> Void {
    this.actionName = n"SpiderbotDistractDevicePerformed";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(this.actionName, true, n"SpiderbotDistractDevicePerformed", n"SpiderbotDistractDevicePerformed");
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
