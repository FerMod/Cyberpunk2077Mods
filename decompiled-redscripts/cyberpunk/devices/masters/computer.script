
public class EnableDocumentEvent extends Event {

  public edit let documentType: EDocumentType;

  public edit let documentName: CName;

  public edit let documentAdress: SDocumentAdress;

  @default(EnableDocumentEvent, true)
  public edit let enable: Bool;

  @default(EnableDocumentEvent, false)
  public edit let entireFolder: Bool;

  public final func GetFriendlyDescription() -> String {
    return "Enable Document";
  }
}

public class OpenDocumentEvent extends Event {

  public edit let documentType: EDocumentType;

  public edit let documentName: CName;

  public edit let documentAdress: SDocumentAdress;

  @default(OpenDocumentEvent, true)
  public edit let wakeUp: Bool;

  public let ownerID: EntityID;

  public final func GetFriendlyDescription() -> String {
    return "Open Document";
  }
}

public class GoToMenuEvent extends Event {

  public edit let menuType: EComputerMenuType;

  @default(GoToMenuEvent, true)
  public edit let wakeUp: Bool;

  public let ownerID: EntityID;

  public final func GetFriendlyDescription() -> String {
    return "Go to Menu";
  }
}

public class Computer extends Terminal {

  private let m_bannerUpdateActive: Bool;

  private let m_bannerUpdateID: DelayID;

  private let m_transformX: ref<IPlacedComponent>;

  private let m_transformY: ref<IPlacedComponent>;

  private let m_playerControlData: PlayerControlDeviceData;

  private let m_currentAnimationState: EComputerAnimationState;

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
    EntityRequestComponentsInterface.RequestComponent(ri, n"takeOverX", n"IPlacedComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"takeOverY", n"IPlacedComponent", false);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_transformX = EntityResolveComponentsInterface.GetComponent(ri, n"takeOverX") as IPlacedComponent;
    this.m_transformY = EntityResolveComponentsInterface.GetComponent(ri, n"takeOverY") as IPlacedComponent;
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as ComputerController;
  }

  protected func ResolveGameplayState() -> Void {
    super.ResolveGameplayState();
    this.DetermineActivationState();
  }

  protected func RestoreDeviceState() -> Void {
    super.RestoreDeviceState();
    this.ResolveAnimationState(this.GetDevicePS().GetAnimationState());
  }

  public func ResavePersistentData(ps: ref<PersistentState>) -> Bool {
    return true;
  }

  protected func ShouldAlwasyRefreshUIInLogicAra() -> Bool {
    return false;
  }

  private const func GetController() -> ref<ComputerController> {
    return this.m_controller as ComputerController;
  }

  public const func GetDevicePS() -> ref<ComputerControllerPS> {
    return this.GetController().GetPS();
  }

  public final const func IsInSleepMode() -> Bool {
    return this.GetDevicePS().IsInSleepMode();
  }

  protected func ShouldExitZoomOnAuthorization() -> Bool {
    return false;
  }

  private final func InitializeBanners() -> Void {
    if this.GetDevicePS().HasNewsfeed() {
      this.RequestBannerWidgetsUpdate(this.GetBlackboard());
    };
  }

  private final func ReadFile(fileAdress: SDocumentAdress) -> Void {
    this.GetDevicePS().SetOpenedFileAdress(fileAdress);
  }

  private final func ReadMail(fileAdress: SDocumentAdress) -> Void {
    this.GetDevicePS().SetOpenedMailAdress(fileAdress);
  }

  private final func ClearOpenedFileAdress() -> Void {
    this.GetDevicePS().ClearOpenedFileAdress();
  }

  private final func ClearOpenedMailAdress() -> Void {
    this.GetDevicePS().ClearOpenedMailAdress();
  }

  private final func DecryptFile(fileAdress: SDocumentAdress) -> Void {
    this.GetDevicePS().DecryptFile(fileAdress);
  }

  private final func DecryptMail(fileAdress: SDocumentAdress) -> Void {
    this.GetDevicePS().DecryptMail(fileAdress);
  }

  protected cb func OnSetDocumentState(evt: ref<SetDocumentStateEvent>) -> Bool {
    if Equals(evt.documentType, EDocumentType.MAIL) {
      if evt.isOpened {
        this.ReadMail(evt.documentAdress);
      } else {
        this.ClearOpenedMailAdress();
      };
    } else {
      if Equals(evt.documentType, EDocumentType.FILE) {
        if evt.isOpened {
          this.ReadFile(evt.documentAdress);
        } else {
          this.ClearOpenedFileAdress();
        };
      };
    };
  }

  protected func TurnOffDevice() -> Void {
    super.TurnOffDevice();
  }

  protected func TurnOnDevice() -> Void {
    super.TurnOnDevice();
  }

  protected func CreateBlackboard() -> Void {
    this.m_blackboard = IBlackboard.Create(GetAllBlackboardDefs().ComputerDeviceBlackboard);
  }

  public const func GetBlackboardDef() -> ref<ComputerDeviceBlackboardDef> {
    return this.GetDevicePS().GetBlackboardDef();
  }

  protected final func StopBannerWidgetsUpdate() -> Void {
    GameInstance.GetDelaySystem(this.GetGame()).CancelDelay(this.m_bannerUpdateID);
    this.m_bannerUpdateActive = false;
  }

  private final func RequestBannerWidgetsUpdate(blackboard: ref<IBlackboard>) -> Void {
    let evt: ref<RequestBannerWidgetUpdateEvent>;
    if this.m_bannerUpdateActive {
      this.StopBannerWidgetsUpdate();
    };
    this.GetDevicePS().RequestBannerWidgetsUpdate(blackboard);
    evt = new RequestBannerWidgetUpdateEvent();
    if !this.m_bannerUpdateActive {
      this.m_bannerUpdateID = GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(this, evt, this.GetDevicePS().GetNewsfeedInterval());
      this.m_bannerUpdateActive = true;
    };
  }

  protected cb func OnToggleOpen(evt: ref<ToggleOpenComputer>) -> Bool {
    this.ResolveAnimationState(this.GetDevicePS().GetAnimationState());
  }

  protected cb func OnCreateFactQuickHack(evt: ref<FactQuickHack>) -> Bool {
    let properties: ComputerQuickHackData = evt.GetFactProperties();
    if Equals(properties.operationType, EMathOperationType.Set) {
      SetFactValue(this.GetGame(), properties.factName, properties.factValue);
    } else {
      AddFact(this.GetGame(), properties.factName, properties.factValue);
    };
  }

  protected cb func OnRequestBannerWidgetUpdate(evt: ref<RequestBannerWidgetUpdateEvent>) -> Bool {
    this.StopBannerWidgetsUpdate();
    this.RequestBannerWidgetsUpdate(this.GetBlackboard());
    this.GetDevicePS().UpdateBanners();
  }

  protected cb func OnRequestDocumentWidgetUpdate(evt: ref<RequestDocumentWidgetUpdateEvent>) -> Bool {
    if Equals(evt.documentType, EDocumentType.FILE) {
      this.GetDevicePS().RequestFileWidgetUpdate(this.GetBlackboard(), evt.documentAdress);
    } else {
      if Equals(evt.documentType, EDocumentType.MAIL) {
        this.GetDevicePS().RequestMailWidgetUpdate(this.GetBlackboard(), evt.documentAdress);
      };
    };
  }

  protected cb func OnRequestDocumentThumbnailWidgetsUpdate(evt: ref<RequestDocumentThumbnailWidgetsUpdateEvent>) -> Bool {
    if Equals(evt.documentType, EDocumentType.FILE) {
      this.GetDevicePS().RequestFileThumbnailWidgetsUpdate(this.GetBlackboard());
    } else {
      if Equals(evt.documentType, EDocumentType.MAIL) {
        this.GetDevicePS().RequestMailThumbnailWidgetsUpdate(this.GetBlackboard());
      };
    };
  }

  protected cb func OnRequestMenuWidgetsUpdate(evt: ref<RequestComputerMenuWidgetsUpdateEvent>) -> Bool {
    this.GetDevicePS().RequestMenuButtonWidgetsUpdate(this.GetBlackboard());
  }

  protected cb func OnRequestMainMenuWidgetsUpdate(evt: ref<RequestComputerMainMenuWidgetsUpdateEvent>) -> Bool {
    this.GetDevicePS().RequestMainMenuButtonWidgetsUpdate(this.GetBlackboard());
  }

  public final const func GetInitialMenuType() -> EComputerMenuType {
    return this.GetDevicePS().GetInitialMenuType();
  }

  public final const func GetHideTopNavigationBar() -> Bool {
    return this.GetDevicePS().GetHideTopNavigationBar();
  }

  public const func DeterminGameplayRole() -> EGameplayRole {
    if this.GetDevicePS().HasAnySlave() {
      return EGameplayRole.ControlOtherDevice;
    };
    return EGameplayRole.GrantInformation;
  }

  private final func DetermineActivationState() -> Void {
    if Equals(this.GetDevicePS().GetActivationState(), EActivationState.ACTIVATED) {
      if Equals(this.GetDevicePS().GetActivatorType(), EToggleActivationTypeComputer.Raise) {
        this.TransformAnimActivate(false);
      };
    } else {
      if Equals(this.GetDevicePS().GetActivationState(), EActivationState.DEACTIVATED) {
        if Equals(this.GetDevicePS().GetActivatorType(), EToggleActivationTypeComputer.Raise) {
          this.TransformAnimActivate(true);
        };
      };
    };
  }

  protected cb func OnActivateDevice(evt: ref<ActivateDevice>) -> Bool {
    if Equals(this.GetDevicePS().GetActivatorType(), EToggleActivationTypeComputer.Raise) {
      this.TransformAnimActivate(false);
    };
  }

  protected cb func OnDeactivateDevice(evt: ref<DeactivateDevice>) -> Bool {
    if Equals(this.GetDevicePS().GetActivatorType(), EToggleActivationTypeComputer.Raise) {
      this.TransformAnimActivate(true);
    };
  }

  private final func TransformAnimActivate(activate: Bool) -> Void {
    let playEvent: ref<gameTransformAnimationPlayEvent> = new gameTransformAnimationPlayEvent();
    playEvent.looping = false;
    playEvent.timesPlayed = 1u;
    playEvent.timeScale = 1.00;
    if activate {
      playEvent.animationName = n"deactivate";
    } else {
      playEvent.animationName = n"activate";
    };
    this.QueueEvent(playEvent);
  }

  private final func ResolveAnimationState(state: EComputerAnimationState) -> Void {
    let playEvent: ref<gameTransformAnimationPlayEvent>;
    let animSetFactName: CName = this.GetDevicePS().GetAnimationStateFactName();
    if NotEquals(state, this.m_currentAnimationState) {
      playEvent = new gameTransformAnimationPlayEvent();
      if Equals(state, EComputerAnimationState.Opened) {
        playEvent.animationName = n"open";
        if IsNameValid(animSetFactName) {
          SetFactValue(this.GetGame(), animSetFactName, 1);
        };
      } else {
        if Equals(state, EComputerAnimationState.Closed) {
          playEvent.animationName = n"close";
          if IsNameValid(animSetFactName) {
            SetFactValue(this.GetGame(), animSetFactName, 0);
          };
        };
      };
      if IsNameValid(playEvent.animationName) {
        playEvent.looping = false;
        playEvent.timesPlayed = 1u;
        playEvent.timeScale = 1.00;
        this.QueueEvent(playEvent);
      };
      this.m_currentAnimationState = state;
    };
  }

  private func InitializeScreenDefinition() -> Void {
    if !TDBID.IsValid(this.m_screenDefinition.screenDefinition) {
      this.m_screenDefinition.screenDefinition = t"DevicesUIDefinitions.Computer_21x9";
    };
    if !TDBID.IsValid(this.m_screenDefinition.style) {
      this.m_screenDefinition.style = t"DevicesUIStyles.None";
    };
  }

  protected cb func OnGoToMenuEvent(evt: ref<GoToMenuEvent>) -> Bool {
    evt.ownerID = this.GetEntityID();
    if evt.wakeUp {
      this.GetDevicePS().SetIsInSleepMode(false);
    };
    GameInstance.GetUISystem(this.GetGame()).QueueEvent(evt);
  }

  protected cb func OnOpenDocumentEvent(evt: ref<OpenDocumentEvent>) -> Bool {
    evt.ownerID = this.GetEntityID();
    if IsNameValid(evt.documentName) {
      evt.documentAdress = this.GetDevicePS().GetDocumentAdressByName(evt.documentType, evt.documentName);
    };
    if evt.wakeUp {
      this.GetDevicePS().SetIsInSleepMode(false);
    };
    GameInstance.GetUISystem(this.GetGame()).QueueEvent(evt);
  }

  protected cb func OnEnableDocumentEvent(evt: ref<EnableDocumentEvent>) -> Bool {
    if IsNameValid(evt.documentName) {
      this.GetDevicePS().EnableDocumentsByName(evt.documentType, evt.documentName, evt.enable);
    } else {
      if evt.entireFolder {
        this.GetDevicePS().EnableDocumentsInFolder(evt.documentType, evt.documentAdress.folderID, evt.enable);
      } else {
        this.GetDevicePS().EnableDocument(evt.documentType, evt.documentAdress, evt.enable);
      };
    };
  }

  protected cb func OnTCSInputXAxisEvent(evt: ref<TCSInputXAxisEvent>) -> Bool {
    let currentRotation: Quaternion;
    let normalizedFloat: Float;
    super.OnTCSInputXAxisEvent(evt);
    this.m_playerControlData.m_currentYawModifier -= evt.value;
    this.m_playerControlData.m_currentYawModifier = ClampF(this.m_playerControlData.m_currentYawModifier, -90.00, 90.00);
    normalizedFloat = this.m_playerControlData.m_currentYawModifier / 180.00;
    Quaternion.SetZRot(currentRotation, normalizedFloat);
    this.m_transformX.SetLocalOrientation(currentRotation);
  }

  protected cb func OnTCSInputYAxisEvent(evt: ref<TCSInputYAxisEvent>) -> Bool {
    let currentRotation: Quaternion;
    let normalizedFloat: Float;
    super.OnTCSInputYAxisEvent(evt);
    this.m_playerControlData.m_currentPitchModifier -= evt.value;
    this.m_playerControlData.m_currentPitchModifier = ClampF(this.m_playerControlData.m_currentPitchModifier, -90.00, 90.00);
    normalizedFloat = this.m_playerControlData.m_currentPitchModifier / 180.00;
    Quaternion.SetXRot(currentRotation, normalizedFloat);
    this.m_transformY.SetLocalOrientation(currentRotation);
  }
}
