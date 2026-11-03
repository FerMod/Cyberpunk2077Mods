
public class ArcadeMachine extends InteractiveDevice {

  @default(ArcadeMachine, ArcadeMachineType.Default)
  @default(PachinkoMachine, ArcadeMachineType.Pachinko)
  protected let m_arcadeMachineType: ArcadeMachineType;

  private let m_isShortGlitchActive: Bool;

  private let m_shortGlitchDelayID: DelayID;

  private let m_currentGameVideo: ResRef;

  protected let m_currentGameAudio: CName;

  protected let m_currentGameAudioStop: CName;

  @default(ArcadeMachine, default)
  private let m_meshAppearanceOn: CName;

  @default(ArcadeMachine, default)
  private let m_meshAppearanceOff: CName;

  private let m_arcadeMinigameComponent: ref<WorkspotResourceComponent>;

  @default(ArcadeMachine, ArcadeMinigame.INVALID)
  protected let m_minigame: ArcadeMinigame;

  private let m_combatStateListener: ref<CallbackHandle>;

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    EntityRequestComponentsInterface.RequestComponent(ri, n"ui", n"worlduiWidgetComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"arcadeMinigamePlayerWorkspot", n"workWorkspotResourceComponent", false);
    super.OnRequestComponents(ri);
  }

  protected cb func OnPersitentStateInitialized(evt: ref<GameAttachedEvent>) -> Bool {
    super.OnPersitentStateInitialized(evt);
    this.Setup();
  }

  public func ResavePersistentData(ps: ref<PersistentState>) -> Bool {
    return false;
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    this.m_uiComponent = EntityResolveComponentsInterface.GetComponent(ri, n"ui") as worlduiWidgetComponent;
    this.m_arcadeMinigameComponent = EntityResolveComponentsInterface.GetComponent(ri, n"arcadeMinigamePlayerWorkspot") as WorkspotResourceComponent;
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as ArcadeMachineController;
  }

  protected func ResolveGameplayState() -> Void {
    super.ResolveGameplayState();
    if this.IsUIdirty() && this.m_isInsideLogicArea {
      this.RefreshUI();
    };
  }

  protected func CreateBlackboard() -> Void {
    this.m_blackboard = IBlackboard.Create(GetAllBlackboardDefs().ArcadeMachineBlackBoard);
  }

  public const func GetBlackboardDef() -> ref<ArcadeMachineBlackboardDef> {
    return this.GetDevicePS().GetBlackboardDef();
  }

  protected const func GetController() -> ref<ArcadeMachineController> {
    return this.m_controller as ArcadeMachineController;
  }

  public const func GetDevicePS() -> ref<ArcadeMachineControllerPS> {
    return this.GetController().GetPS();
  }

  protected func StartGlitching(glitchState: EGlitchState, opt intensity: Float) -> Void {
    let evt: ref<AdvertGlitchEvent>;
    let glitchData: GlitchData;
    glitchData.state = glitchState;
    glitchData.intensity = intensity;
    if intensity == 0.00 {
      intensity = 1.00;
    };
    evt = new AdvertGlitchEvent();
    evt.SetShouldGlitch(intensity);
    this.QueueEvent(evt);
    this.GetBlackboard().SetVariant(this.GetBlackboardDef().GlitchData, ToVariant(glitchData), true);
    this.GetBlackboard().FireCallbacks();
    GameObjectEffectHelper.ActivateEffectAction(this, gamedataFxActionType.Start, n"hack_fx");
  }

  protected func StopGlitching() -> Void {
    let glitchData: GlitchData;
    let evt: ref<AdvertGlitchEvent> = new AdvertGlitchEvent();
    evt.SetShouldGlitch(0.00);
    this.QueueEvent(evt);
    glitchData.state = EGlitchState.NONE;
    this.GetBlackboard().SetVariant(this.GetBlackboardDef().GlitchData, ToVariant(glitchData));
    this.GetBlackboard().FireCallbacks();
    GameObjectEffectHelper.ActivateEffectAction(this, gamedataFxActionType.BreakLoop, n"hack_fx");
  }

  protected cb func OnHitEvent(hit: ref<gameHitEvent>) -> Bool {
    super.OnHitEvent(hit);
    this.StartShortGlitch();
  }

  private final func StartShortGlitch() -> Void {
    let evt: ref<StopShortGlitchEvent>;
    if this.GetDevicePS().IsGlitching() || this.GetDevicePS().IsDistracting() {
      return;
    };
    if !this.m_isShortGlitchActive {
      evt = new StopShortGlitchEvent();
      this.StartGlitching(EGlitchState.DEFAULT, 1.00);
      this.m_shortGlitchDelayID = GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(this, evt, 0.25);
      this.m_isShortGlitchActive = true;
    };
  }

  protected cb func OnStopShortGlitch(evt: ref<StopShortGlitchEvent>) -> Bool {
    this.m_isShortGlitchActive = false;
    if !this.GetDevicePS().IsGlitching() && !this.GetDevicePS().IsDistracting() {
      this.StopGlitching();
    };
  }

  protected func TurnOnDevice() -> Void {
    super.TurnOnDevice();
    this.TurnOnScreen();
  }

  protected func TurnOffDevice() -> Void {
    super.TurnOffDevice();
    this.TurnOffScreen();
  }

  protected func CutPower() -> Void {
    super.CutPower();
    this.TurnOffScreen();
  }

  protected func TurnOffScreen() -> Void {
    this.m_uiComponent.Toggle(false);
    GameObject.PlaySound(this, this.m_currentGameAudioStop);
    this.SetMeshAppearance(this.m_meshAppearanceOff);
  }

  protected func TurnOnScreen() -> Void {
    this.m_uiComponent.Toggle(true);
    GameObject.PlaySound(this, this.m_currentGameAudio);
    this.SetMeshAppearance(this.m_meshAppearanceOn);
  }

  protected func OnDirectInteractionActive(evt: ref<InteractionActivationEvent>, isInteractionActive: Bool) -> Void {
    let psmBlackboard: ref<IBlackboard> = GameInstance.GetBlackboardSystem(this.GetGame()).GetLocalInstanced(evt.activator.GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    if isInteractionActive {
      this.m_combatStateListener = psmBlackboard.RegisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Combat, this, n"OnCombatStateChanged");
    } else {
      psmBlackboard.UnregisterDelayedListener(GetAllBlackboardDefs().PlayerStateMachine.Combat, this.m_combatStateListener);
    };
  }

  protected cb func OnCombatStateChanged(value: Int32) -> Bool {
    this.DetermineInteractionStateByTask();
  }

  protected cb func OnBeginArcadeMinigameUI(evt: ref<BeginArcadeMinigameUI>) -> Bool {
    let isInteractingWithDevice: Bool;
    let psmBlackboard: ref<IBlackboard>;
    let workspotGameSystem: ref<WorkspotGameSystem> = GameInstance.GetWorkspotSystem(this.GetGame());
    if workspotGameSystem.IsActorInWorkspot(evt.GetExecutor()) {
      workspotGameSystem.StopInDevice(evt.GetExecutor());
      isInteractingWithDevice = false;
    } else {
      workspotGameSystem.PlayInDevice(this, evt.GetExecutor(), n"lockedCamera", n"arcadeMinigamePlayerWorkspot", n"arcadeMinigameDeviceWorkspot");
      isInteractingWithDevice = true;
    };
    psmBlackboard = GameInstance.GetBlackboardSystem(this.GetGame()).GetLocalInstanced(evt.GetExecutor().GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    psmBlackboard.SetBool(GetAllBlackboardDefs().PlayerStateMachine.IsInteractingWithDevice, isInteractingWithDevice);
  }

  public const func DeterminGameplayRole() -> EGameplayRole {
    return EGameplayRole.Distract;
  }

  protected func ApplyActiveStatusEffect(target: EntityID, statusEffect: TweakDBID) -> Void {
    if this.IsActiveStatusEffectValid() && this.GetDevicePS().IsGlitching() {
      GameInstance.GetStatusEffectSystem(this.GetGame()).ApplyStatusEffect(target, statusEffect);
    };
  }

  protected func UploadActiveProgramOnNPC(targetID: EntityID) -> Void {
    let evt: ref<ExecutePuppetActionEvent>;
    if this.IsActiveProgramToUploadOnNPCValid() && this.GetDevicePS().IsGlitching() {
      evt = new ExecutePuppetActionEvent();
      evt.actionID = this.GetActiveProgramToUploadOnNPC();
      this.QueueEventForEntityID(targetID, evt);
    };
  }

  private final func Setup() -> Void {
    this.m_currentGameVideo = this.GetDevicePS().GetGameVideoPath();
    if Equals(this.m_arcadeMachineType, ArcadeMachineType.Default) {
      this.SetupMinigame();
    };
  }

  private final func SetupMinigame() -> Void {
    let randValue: Int32 = -1;
    let roachraceMovie1: ResRef = r"base\\movies\\misc\\arcade\\roach_race.bk2";
    let roachraceMovie2: ResRef = r"base\\movies\\misc\\arcade\\roachrace.bk2";
    let roachraceMovie3: ResRef = r"base\\movies\\misc\\arcade\\roach_race_game.bk2";
    let shooterMovie1: ResRef = r"base\\movies\\misc\\arcade\\td_title_screen_press_start.bk2";
    let shooterMovie2: ResRef = r"base\\movies\\misc\\arcade\\retros.bk2";
    let tankMovie: ResRef = r"base\\movies\\misc\\arcade\\hishousai_panzer.bk2";
    let quadracerMovie: ResRef = r"base\\movies\\misc\\arcade\\quadracer.bk2";
    if Equals(this.m_arcadeMachineType, ArcadeMachineType.Pachinko) {
      return;
    };
    if Equals(this.m_minigame, ArcadeMinigame.INVALID) {
      if !ResRef.IsValid(this.m_currentGameVideo) {
        randValue = RandRange(0, 10);
      };
      if randValue == 9 || Equals(this.m_currentGameVideo, quadracerMovie) {
        this.m_minigame = ArcadeMinigame.Quadracer;
      };
      if randValue == 8 || Equals(this.m_currentGameVideo, tankMovie) {
        this.m_minigame = ArcadeMinigame.Tank;
      } else {
        if randValue >= 4 || Equals(this.m_currentGameVideo, roachraceMovie1) || Equals(this.m_currentGameVideo, roachraceMovie2) || Equals(this.m_currentGameVideo, roachraceMovie3) {
          this.m_minigame = ArcadeMinigame.RoachRace;
        } else {
          if randValue >= 0 || Equals(this.m_currentGameVideo, shooterMovie1) || Equals(this.m_currentGameVideo, shooterMovie2) {
            this.m_minigame = ArcadeMinigame.Shooter;
          };
        };
      };
    };
    if Equals(this.m_minigame, ArcadeMinigame.Quadracer) {
      this.m_currentGameVideo = quadracerMovie;
      this.m_currentGameAudio = n"mus_cp_arcade_quadra_START_menu";
      this.m_currentGameAudioStop = n"mus_cp_arcade_quadra_STOP";
      this.m_meshAppearanceOn = n"ap1";
      this.m_meshAppearanceOff = n"ap1_off";
    } else {
      if Equals(this.m_minigame, ArcadeMinigame.RoachRace) {
        this.m_currentGameVideo = roachraceMovie3;
        this.m_currentGameAudio = n"mus_cp_arcade_roach_START_menu";
        this.m_currentGameAudioStop = n"mus_cp_arcade_roach_STOP";
        this.m_meshAppearanceOn = n"ap2";
        this.m_meshAppearanceOff = n"ap2_off";
      } else {
        if Equals(this.m_minigame, ArcadeMinigame.Shooter) {
          this.m_currentGameVideo = shooterMovie1;
          this.m_currentGameAudio = n"mus_cp_arcade_shooter_START_menu";
          this.m_currentGameAudioStop = n"mus_cp_arcade_shooter_STOP";
          this.m_meshAppearanceOn = n"ap3";
          this.m_meshAppearanceOff = n"ap3_off";
        } else {
          if Equals(this.m_minigame, ArcadeMinigame.Tank) {
            this.m_currentGameVideo = tankMovie;
            this.m_currentGameAudio = n"mus_cp_arcade_panzer_START_menu";
            this.m_currentGameAudioStop = n"mus_cp_arcade_panzer_STOP";
            this.m_meshAppearanceOn = n"ap4";
            this.m_meshAppearanceOff = n"ap4_off";
          };
        };
      };
    };
    this.GetDevicePS().SetArcadeMinigame(this.m_minigame);
  }

  public final const func GetArcadeGameVideo() -> ResRef {
    return this.m_currentGameVideo;
  }

  public final const func GetArcadeGameAudio() -> CName {
    return this.m_currentGameAudio;
  }

  public final const func GetArcadeGameAudioStop() -> CName {
    return this.m_currentGameAudioStop;
  }
}
