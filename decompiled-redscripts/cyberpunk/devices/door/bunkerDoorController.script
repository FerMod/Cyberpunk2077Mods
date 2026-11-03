
public class BunkerDoorController extends DoorController {

  public const func GetPS() -> ref<BunkerDoorControllerPS> {
    return this.GetBasePS() as BunkerDoorControllerPS;
  }
}

public class BunkerDoorControllerPS extends DoorControllerPS {

  @runtimeProperty("category", "Npc Opening Setup")
  @default(BunkerDoorControllerPS, 1f)
  private let m_NpcOpenSpeed: Float;

  @runtimeProperty("category", "Npc Opening Setup")
  @default(BunkerDoorControllerPS, 1f)
  private let m_NpcOpenTime: Float;

  @runtimeProperty("category", "Malfunctioning")
  private persistent let m_malfunctioningType: EMalfunctioningType;

  @runtimeProperty("category", "Malfunctioning")
  @default(BunkerDoorControllerPS, 100)
  private persistent let m_malfunctioningChance: Int32;

  @runtimeProperty("category", "Malfunctioning")
  @default(BunkerDoorControllerPS, 10)
  private let m_malfunctioningStimRange: Float;

  private persistent let m_malfanctioningBehaviourActive: Bool;

  public final const func GetMalfunctioningType() -> EMalfunctioningType {
    return this.m_malfunctioningType;
  }

  public final const func GetMalfunctioningStimRange() -> Float {
    return this.m_malfunctioningStimRange;
  }

  public final const func GetNpcOpenSpeed() -> Float {
    return this.m_NpcOpenSpeed;
  }

  public final const func GetNpcOpenTime() -> Float {
    return this.m_NpcOpenTime;
  }

  public final const func IsMalfunctioningBehaviourActive(type: EMalfunctioningType) -> Bool {
    return Equals(this.GetMalfunctioningType(), type) && this.m_malfanctioningBehaviourActive;
  }

  private final const func ShouldMalfunction() -> Bool {
    return RandRange(0, 100) <= this.m_malfunctioningChance;
  }

  protected func Initialize() -> Void {
    super.Initialize();
    this.ReinitializeMalfunctionBehaviour();
  }

  protected func OnSetIsOpened() -> Void {
    super.OnSetIsOpened();
    this.ReinitializeMalfunctionBehaviour();
  }

  public final func SetMalfunctioningType(type: EMalfunctioningType) -> Void {
    this.m_malfunctioningType = type;
    this.m_malfanctioningBehaviourActive = true;
  }

  private final func ReinitializeMalfunctionBehaviour() -> Void {
    this.m_malfanctioningBehaviourActive = this.ShouldMalfunction();
  }

  public final func OnMalfunctionHalfOpen(evt: ref<MalfunctionHalfOpen>) -> EntityNotificationType {
    let notifier: ref<ActionNotifier> = new ActionNotifier();
    notifier.SetAll();
    if !this.IsMalfunctioningBehaviourActive(EMalfunctioningType.HALF_OPENING) || this.IsDisabled() || this.IsSealed() {
      return this.SendActionFailedEvent(evt, evt.GetRequesterID(), "Sealed or Disabled");
    };
    this.ReinitializeMalfunctionBehaviour();
    this.Notify(notifier, evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  public final func ActionMalfunctionHalfOpen() -> ref<MalfunctionHalfOpen> {
    let action: ref<MalfunctionHalfOpen> = new MalfunctionHalfOpen();
    action.clearanceLevel = 2;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    action.CreateInteraction();
    action.CreateActionWidgetPackage();
    return action;
  }

  protected func GetPlayerToggleOpenAction() -> ref<ToggleOpen> {
    if this.IsMalfunctioningBehaviourActive(EMalfunctioningType.HALF_OPENING) {
      return this.ActionMalfunctionHalfOpen();
    };
    return this.ActionToggleOpen();
  }

  protected func CanAddToggleOpenAction(context: GetActionsContext) -> Bool {
    if this.IsMalfunctioningBehaviourActive(EMalfunctioningType.HALF_OPENING) {
      return MalfunctionHalfOpen.IsDefaultConditionMet(this, context);
    };
    return super.CanAddToggleOpenAction(context);
  }
}

public class MalfunctionHalfOpen extends ToggleOpen {

  public final func SetProperties() -> Void {
    this.actionName = n"Open";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(this.actionName, true, n"LocKey#273", n"LocKey#273");
  }

  public func GetTweakDBChoiceRecord() -> String {
    return "Open";
  }

  public final static func IsDefaultConditionMet(device: ref<BunkerDoorControllerPS>, const context: script_ref<GetActionsContext>) -> Bool {
    return MalfunctionHalfOpen.IsAvailable(device) && MalfunctionHalfOpen.IsClearanceValid(Deref(context).clearance) && Deref(context).processInitiatorObject.IsPlayer();
  }

  public final static func IsAvailable(device: ref<BunkerDoorControllerPS>) -> Bool {
    if !device.IsMalfunctioningBehaviourActive(EMalfunctioningType.HALF_OPENING) {
      return false;
    };
    if device.IsDisabled() {
      return false;
    };
    if device.IsSealed() {
      return false;
    };
    if device.IsOpen() {
      return false;
    };
    return true;
  }

  public final static func IsClearanceValid(clearance: ref<Clearance>) -> Bool {
    return Clearance.IsInRange(clearance, 2);
  }

  public func GetInkWidgetTweakDBID() -> TweakDBID {
    return t"DevicesUIDefinitions.DoorDeviceActionWidget";
  }
}

public class SetDoorMalfunctioningType extends Event {

  public edit let malfunctioningType: EMalfunctioningType;

  public final func GetFriendlyDescription() -> String {
    return "Sets door malfunctioning type";
  }
}
