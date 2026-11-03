
public class JukeboxControllerPS extends ScriptableDeviceComponentPS {

  protected let m_jukeboxSetup: JukeboxSetup;

  protected persistent let m_activeStation: Int32;

  @default(JukeboxControllerPS, true)
  protected let m_isPlaying: Bool;

  protected func GameAttached() -> Void {
    this.m_activeStation = EnumInt(this.GetStartingStation());
  }

  private final func GetStartingStation() -> ERadioStationList {
    return this.m_jukeboxSetup.m_randomizeStartingStation ? RadioStationDataProvider.GetRandomStation() : this.m_jukeboxSetup.m_startingStation;
  }

  public func GetActions(out actions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    super.GetActions(actions, context);
    if Equals(context.requestType, gamedeviceRequestType.Remote) {
      return false;
    };
    if TogglePlay.IsDefaultConditionMet(this, context) {
      ArrayPush(actions, this.ActionTogglePlay());
    };
    if NextStation.IsDefaultConditionMet(this, context) {
      ArrayPush(actions, this.ActionPreviousStation());
      ArrayPush(actions, this.ActionNextStation());
    };
    this.SetActionIllegality(actions, this.m_illegalActions.regularActions);
    return true;
  }

  protected const func CanCreateAnyQuickHackActions() -> Bool {
    return true;
  }

  protected func GetQuickHackActions(out actions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    let action: ref<ScriptableDeviceAction> = this.ActionQuickHackDistraction();
    action.SetInactiveWithReason(!this.IsDistracting(), "LocKey#7004");
    ArrayPush(actions, action);
    this.FinalizeGetQuickHackActions(actions, context);
  }

  public final const func GetPaymentRecordID() -> TweakDBID {
    return this.m_jukeboxSetup.m_paymentRecordID;
  }

  protected final func ActionTogglePlay() -> ref<TogglePlay> {
    let action: ref<TogglePlay> = new TogglePlay();
    action.SetUp(this);
    action.SetProperties(!this.m_isPlaying);
    action.AddDeviceName(this.m_deviceName);
    action.CreateActionWidgetPackage();
    return action;
  }

  protected final func ActionPreviousStation() -> ref<PreviousStation> {
    let action: ref<PreviousStation> = new PreviousStation();
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    action.SetExecutor(GetPlayer(this.GetGameInstance()));
    action.SetInkWidgetTweakDBID(t"DevicesUIDefinitions.JukeboxPreviousActionWidget");
    action.CreateActionWidgetPackage();
    if TDBID.IsValid(this.GetPaymentRecordID()) {
      action.SetObjectActionID(this.GetPaymentRecordID());
    };
    return action;
  }

  public final func ActionNextStation() -> ref<NextStation> {
    let action: ref<NextStation> = new NextStation();
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    action.SetExecutor(GetPlayer(this.GetGameInstance()));
    action.SetInkWidgetTweakDBID(t"DevicesUIDefinitions.JukeboxNextActionWidget");
    action.CreateActionWidgetPackage();
    if TDBID.IsValid(this.GetPaymentRecordID()) {
      action.SetObjectActionID(this.GetPaymentRecordID());
    };
    return action;
  }

  protected func ActionQuickHackDistraction() -> ref<QuickHackDistraction> {
    let action: ref<QuickHackDistraction> = super.ActionQuickHackDistraction();
    action.SetDurationValue(this.GetDistractionDuration(action));
    action.SetObjectActionID(t"DeviceAction.MalfunctionClassHack");
    return action;
  }

  public final func GetGlitchSFX() -> CName {
    return this.m_jukeboxSetup.m_glitchSFX;
  }

  public final func IsPlaying() -> Bool {
    return this.m_isPlaying;
  }

  public final func OnTogglePlay(evt: ref<TogglePlay>) -> EntityNotificationType {
    if !this.IsON() {
      return EntityNotificationType.DoNotNotifyEntity;
    };
    this.m_isPlaying = FromVariant<Bool>(evt.prop.first);
    this.UseNotifier(evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  public final func OnNextStation(evt: ref<NextStation>) -> EntityNotificationType {
    if !this.IsON() || !evt.CanPayCost(GetPlayer(this.GetGameInstance())) {
      return EntityNotificationType.DoNotNotifyEntity;
    };
    this.m_activeStation = EnumInt(RadioStationDataProvider.GetNextStationTo(IntEnum<ERadioStationList>(this.m_activeStation)));
    this.m_isPlaying = true;
    this.UseNotifier(evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  public final func OnPreviousStation(evt: ref<PreviousStation>) -> EntityNotificationType {
    if !this.IsON() || !evt.CanPayCost(GetPlayer(this.GetGameInstance())) {
      return EntityNotificationType.DoNotNotifyEntity;
    };
    this.m_activeStation = EnumInt(RadioStationDataProvider.GetPreviousStationTo(IntEnum<ERadioStationList>(this.m_activeStation)));
    this.m_isPlaying = true;
    this.UseNotifier(evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  public func OnQuickHackDistraction(evt: ref<QuickHackDistraction>) -> EntityNotificationType {
    let type: EntityNotificationType = super.OnQuickHackDistraction(evt);
    if Equals(type, EntityNotificationType.DoNotNotifyEntity) {
      return type;
    };
    if evt.IsStarted() {
      if this.IsOFF() {
        this.ExecutePSAction(this.ActionSetDeviceON());
      };
      this.ExecutePSAction(this.ActionNextStation());
    };
    return EntityNotificationType.SendThisEventToEntity;
  }

  protected func GetDeviceIconTweakDBID() -> TweakDBID {
    return t"DeviceIcons.RadioDeviceIcon";
  }

  protected func GetBackgroundTextureTweakDBID() -> TweakDBID {
    return t"DeviceIcons.RadioDeviceBackground";
  }

  public const func GetBlackboardDef() -> ref<JukeboxBlackboardDef> {
    return GetAllBlackboardDefs().JukeboxBlackboard;
  }

  public final func GetRadioStationEventName() -> CName {
    return RadioStationDataProvider.GetStationNameByIndex(this.m_activeStation);
  }
}
