
public class SecuritySystem extends DeviceSystemBase {

  private let m_savedOutputCache: [OutputValidationDataStruct];

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as SecuritySystemController;
  }

  public const func GetDefaultHighlight() -> ref<FocusForcedHighlightData> {
    return null;
  }

  public const func GetDevicePS() -> ref<SecuritySystemControllerPS> {
    return this.GetController().GetPS();
  }

  private const func GetController() -> ref<SecuritySystemController> {
    return this.m_controller as SecuritySystemController;
  }

  protected cb func OnSlaveStateChanged(evt: ref<PSDeviceChangedEvent>) -> Bool {
    return false;
  }

  protected cb func OnQuestIllegalActionNotification(evt: ref<QuestIllegalActionNotification>) -> Bool {
    this.GetDevicePS().QuestIllegalActionNotification(evt);
  }

  protected cb func OnQuestCombatActionNotification(evt: ref<QuestCombatActionNotification>) -> Bool {
    this.GetDevicePS().QuestCombatActionNotification(evt);
  }

  protected cb func OnSetSecuritySystemState(evt: ref<SetSecuritySystemState>) -> Bool {
    this.GetDevicePS().QuestChangeSecuritySystemState(evt);
  }

  protected cb func OnQuestAuthorizePlayer(evt: ref<AuthorizePlayerInSecuritySystem>) -> Bool {
    this.GetDevicePS().QuestAuthorizePlayer(evt);
  }

  protected cb func OnQuestBlackListPlayer(evt: ref<BlacklistPlayer>) -> Bool {
    this.GetDevicePS().QuestBlacklistPlayer(evt);
  }

  protected cb func OnQuestExclusiveQuestControl(evt: ref<SuppressSecuritySystemStateChange>) -> Bool {
    this.GetDevicePS().QuestSuppressSecuritySystem(evt);
  }

  protected cb func OnQuestChangeSecuritySystemAttitudeGroup(evt: ref<QuestChangeSecuritySystemAttitudeGroup>) -> Bool {
    this.GetDevicePS().QuestChangeSecuritySystemAttitudeGroup(evt);
  }

  public func OnMaraudersMapDeviceDebug(sink: ref<MaraudersMapDevicesSink>) -> Void;
}
