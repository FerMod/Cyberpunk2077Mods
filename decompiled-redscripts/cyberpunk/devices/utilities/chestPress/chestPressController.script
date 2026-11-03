
public class ChestPressController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<ChestPressControllerPS> {
    return this.GetBasePS() as ChestPressControllerPS;
  }
}

public class ChestPressControllerPS extends ScriptableDeviceComponentPS {

  protected inline let m_chestPressSkillChecks: ref<EngDemoContainer>;

  private let m_factOnQHack: CName;

  private let m_wasWeighHacked: Bool;

  protected func GameAttached() -> Void;

  protected func GetSkillCheckContainerForSetup() -> ref<BaseSkillCheckContainer> {
    return this.m_chestPressSkillChecks;
  }

  public final func PushPersistentData() -> Void;

  public final func GetFactOnQHack() -> CName {
    return this.m_factOnQHack;
  }

  protected final func ActionChestPressWeightHack() -> ref<ChestPressWeightHack> {
    let action: ref<ChestPressWeightHack> = new ChestPressWeightHack();
    action.clearanceLevel = 2;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    action.CreateInteraction();
    return action;
  }

  protected final func ActionE3Hack_QuestPlayAnimationWeightLift() -> ref<E3Hack_QuestPlayAnimationWeightLift> {
    let action: ref<E3Hack_QuestPlayAnimationWeightLift> = new E3Hack_QuestPlayAnimationWeightLift();
    action.clearanceLevel = 99;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    return action;
  }

  protected final func ActionE3Hack_QuestPlayAnimationKillNPC() -> ref<E3Hack_QuestPlayAnimationKillNPC> {
    let action: ref<E3Hack_QuestPlayAnimationKillNPC> = new E3Hack_QuestPlayAnimationKillNPC();
    action.clearanceLevel = 99;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    return action;
  }

  protected const func CanCreateAnyQuickHackActions() -> Bool {
    return true;
  }

  protected func GetQuickHackActions(out actions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    let currentAction: ref<ScriptableDeviceAction> = this.ActionChestPressWeightHack();
    currentAction.SetObjectActionID(t"DeviceAction.OverloadClassHack");
    currentAction.SetInactiveWithReason(!this.m_wasWeighHacked, "LocKey#7004");
    ArrayPush(actions, currentAction);
    this.FinalizeGetQuickHackActions(actions, context);
  }

  public func GetQuestActionByName(actionName: CName) -> ref<DeviceAction> {
    let action: ref<DeviceAction> = super.GetQuestActionByName(actionName);
    if action == null {
      switch actionName {
        case n"E3Hack_QuestPlayAnimationWeightLift":
          action = this.ActionE3Hack_QuestPlayAnimationWeightLift();
          break;
        case n"E3Hack_QuestPlayAnimationKillNPC":
          action = this.ActionE3Hack_QuestPlayAnimationKillNPC();
      };
    };
    return action;
  }

  protected func GetQuestActions(out outActions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    super.GetQuestActions(outActions, context);
    ArrayPush(outActions, this.ActionE3Hack_QuestPlayAnimationWeightLift());
    ArrayPush(outActions, this.ActionE3Hack_QuestPlayAnimationKillNPC());
  }

  private final func OnChestPressWeightHack(evt: ref<ChestPressWeightHack>) -> EntityNotificationType {
    this.m_wasWeighHacked = true;
    this.UseNotifier(evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  private final func OnE3Hack_QuestPlayAnimationWeightLift(evt: ref<E3Hack_QuestPlayAnimationWeightLift>) -> EntityNotificationType {
    return EntityNotificationType.SendThisEventToEntity;
  }

  private final func OnE3Hack_QuestPlayAnimationKillNPC(evt: ref<E3Hack_QuestPlayAnimationKillNPC>) -> EntityNotificationType {
    return EntityNotificationType.SendThisEventToEntity;
  }
}

public class ChestPressWeightHack extends ActionBool {

  public final func SetProperties() -> Void {
    this.actionName = n"ChestPressWeightHack";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(this.actionName, true, n"LocKey#600", n"LocKey#600");
  }

  public const func GetInteractionIcon() -> wref<ChoiceCaptionIconPart_Record> {
    return TweakDBInterface.GetChoiceCaptionIconPartRecord(t"ChoiceCaptionParts.DistractIcon");
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

public class E3Hack_QuestPlayAnimationWeightLift extends ActionBool {

  public final func SetProperties() -> Void {
    this.actionName = n"E3Hack_QuestPlayAnimationWeightLift";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(this.actionName, true, n"E3Hack_QuestPlayAnimationWeightLift", n"E3Hack_QuestPlayAnimationWeightLift");
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

public class E3Hack_QuestPlayAnimationKillNPC extends ActionBool {

  public final func SetProperties() -> Void {
    this.actionName = n"E3Hack_QuestPlayAnimationKillNPC";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(this.actionName, true, n"E3Hack_QuestPlayAnimationKillNPC", n"E3Hack_QuestPlayAnimationKillNPC");
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
