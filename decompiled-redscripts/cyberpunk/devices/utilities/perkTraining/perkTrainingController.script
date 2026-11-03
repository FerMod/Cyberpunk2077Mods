
public class PerkTrainingControllerPS extends ScriptableDeviceComponentPS {

  @runtimeProperty("customEditor", "TweakDBGroupInheritance;Interactions.None")
  private edit let m_interactionTweakDBID: TweakDBID;

  private edit let m_loopTime: Float;

  private edit let m_jackinStartTime: Float;

  protected edit let m_isCorePerk: Bool;

  private persistent let m_perkGranted: Bool;

  private persistent let m_wasDetected: Bool;

  public final func WasDetected() -> Bool {
    return this.m_wasDetected;
  }

  public final func SetDeviceAsDetected() -> Void {
    this.m_wasDetected = true;
  }

  public final const func IsPerkGranted() -> Bool {
    return this.m_perkGranted;
  }

  public final func GetLoopTime() -> Float {
    return this.m_loopTime;
  }

  public func GetActions(out actions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    let action: ref<TogglePersonalLink>;
    if this.ShouldExposePersonalLinkAction() {
      action = this.ActionTogglePersonalLink(context.processInitiatorObject);
      action.SetDurationValue(this.m_jackinStartTime);
      action.CreateInteraction(this.m_interactionTweakDBID);
      ArrayPush(actions, action);
      return true;
    };
    return false;
  }

  protected func IsPersonalLinkActionIllegal() -> Bool {
    return false;
  }

  protected const func ShouldExposePersonalLinkAction() -> Bool {
    return !this.IsPerkGranted() && Equals(this.GetPersonalLinkStatus(), EPersonalLinkConnectionStatus.NOT_CONNECTED);
  }

  protected func ResolvePersonalLinkConnection(evt: ref<TogglePersonalLink>, abortOperations: Bool) -> Void {
    if this.IsPersonalLinkConnected() {
      this.StartConnectionLoopCountdown(evt);
    };
  }

  private final func StartConnectionLoopCountdown(evt: ref<TogglePersonalLink>) -> Void {
    let connectionEndedEvent: ref<ConnectionEndedEvent> = new ConnectionEndedEvent();
    connectionEndedEvent.SetTogglePersonalLinkAction(evt);
    this.QueuePSEventWithDelay(this.GetID(), this.GetClassName(), connectionEndedEvent, this.m_loopTime);
  }

  private final func OnConnectionEnded(evt: ref<ConnectionEndedEvent>) -> EntityNotificationType {
    this.TryGrantPerk();
    this.DisconnectPersonalLink(evt.GetTogglePersonalLinkAction());
    return EntityNotificationType.SendThisEventToEntity;
  }

  public final func TryGrantPerk() -> Void {
    let currentEspionageLevel: Int32;
    let playerDevelopmentData: ref<PlayerDevelopmentData>;
    if !this.IsPerkGranted() {
      playerDevelopmentData = PlayerDevelopmentSystem.GetData(GetPlayer(this.GetGameInstance()));
      currentEspionageLevel = playerDevelopmentData.GetProficiencyLevel(gamedataProficiencyType.Espionage);
      if this.m_isCorePerk {
        playerDevelopmentData.SetLevel(gamedataProficiencyType.Espionage, currentEspionageLevel + 3, telemetryLevelGainReason.Gameplay);
      } else {
        playerDevelopmentData.SetLevel(gamedataProficiencyType.Espionage, currentEspionageLevel + 1, telemetryLevelGainReason.Gameplay);
      };
      this.m_perkGranted = true;
    };
  }
}

public class ConnectionEndedEvent extends Event {

  private let m_togglePersonalLinkAction: ref<TogglePersonalLink>;

  public final func GetTogglePersonalLinkAction() -> ref<TogglePersonalLink> {
    return this.m_togglePersonalLinkAction;
  }

  public final func SetTogglePersonalLinkAction(togglePersonalLinkAction: ref<TogglePersonalLink>) -> Void {
    this.m_togglePersonalLinkAction = togglePersonalLinkAction;
  }
}
