
public class NumericDisplayController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<NumericDisplayControllerPS> {
    return this.GetBasePS() as NumericDisplayControllerPS;
  }
}

public class NumericDisplayControllerPS extends ScriptableDeviceComponentPS {

  private let m_numberToDisplay: Int32;

  @default(NumericDisplayControllerPS, 0)
  private let m_targetNumber: Int32;

  public final const quest func GetCurrentNumber() -> Int32 {
    return this.m_numberToDisplay;
  }

  public final const quest func TargetReached() -> Bool {
    return this.m_numberToDisplay == this.m_targetNumber;
  }

  protected func GetInkWidgetTweakDBID(const context: script_ref<GetActionsContext>) -> TweakDBID {
    return t"DevicesUIDefinitions.q302_NumericDisplayWidget";
  }

  public const func GetBlackboardDef() -> ref<NumericDisplayBlackboardDef> {
    return GetAllBlackboardDefs().NumericDisplay;
  }

  public func GetQuestActions(out actions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    super.GetQuestActions(actions, context);
    ArrayPush(actions, this.ActionQuestIncreaseNumber());
    ArrayPush(actions, this.ActionQuestDecreaseNumber());
    ArrayPush(actions, this.ActionQuestIdle());
  }

  public final func ActionQuestIncreaseNumber() -> ref<QuestIncreaseNumber> {
    let action: ref<QuestIncreaseNumber> = new QuestIncreaseNumber();
    action.clearanceLevel = 99;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    return action;
  }

  public final func ActionQuestDecreaseNumber() -> ref<QuestDecreaseNumber> {
    let action: ref<QuestDecreaseNumber> = new QuestDecreaseNumber();
    action.clearanceLevel = 99;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    return action;
  }

  public final func ActionQuestIdle() -> ref<QuestIdle> {
    let action: ref<QuestIdle> = new QuestIdle();
    action.clearanceLevel = 99;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    return action;
  }

  protected func GameAttached() -> Void {
    super.GameAttached();
    this.SendNumberToUIBlackboard();
    this.SendDirectionToUIBlackboard(0);
  }

  public final func OnQuestIncreaseNumber(evt: ref<QuestIncreaseNumber>) -> EntityNotificationType {
    this.m_numberToDisplay += 1;
    this.SendNumberToUIBlackboard();
    this.SendDirectionToUIBlackboard(1);
    this.RefreshUI(this.GetBlackboard());
    this.UseNotifier(evt);
    return EntityNotificationType.SendPSChangedEventToEntity;
  }

  public final func OnQuestDecreaseNumber(evt: ref<QuestDecreaseNumber>) -> EntityNotificationType {
    this.m_numberToDisplay -= 1;
    this.SendNumberToUIBlackboard();
    this.SendDirectionToUIBlackboard(-1);
    this.RefreshUI(this.GetBlackboard());
    this.UseNotifier(evt);
    return EntityNotificationType.SendPSChangedEventToEntity;
  }

  public final func OnQuestIdle(evt: ref<QuestIdle>) -> EntityNotificationType {
    this.SendDirectionToUIBlackboard(0);
    this.RefreshUI(this.GetBlackboard());
    this.UseNotifier(evt);
    return EntityNotificationType.SendPSChangedEventToEntity;
  }

  protected final func SendNumberToUIBlackboard() -> Void {
    this.GetBlackboard().SetInt(this.GetBlackboardDef().CurrentNumber, this.GetCurrentNumber(), true);
  }

  protected final func SendDirectionToUIBlackboard(direction: Int32) -> Void {
    this.GetBlackboard().SetInt(this.GetBlackboardDef().Direction, direction, true);
  }
}
