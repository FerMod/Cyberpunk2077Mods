
public class BunkerDoor extends Door {

  @runtimeProperty("category", "Malfunction Sounds")
  @runtimeProperty("customEditor", "AudioEvent")
  private let m_loudAnnouncementOpenSoundName: CName;

  @runtimeProperty("category", "Malfunction Sounds")
  @runtimeProperty("customEditor", "AudioEvent")
  private let m_halfOpenSoundName: CName;

  @runtimeProperty("category", "Malfunction Sounds")
  @runtimeProperty("customEditor", "AudioEvent")
  private let m_glitchingSoundName: CName;

  @runtimeProperty("customEditor", "AudioEvent")
  private let m_fastOpenSoundName: CName;

  public const func GetDevicePS() -> ref<BunkerDoorControllerPS> {
    return this.GetController().GetPS();
  }

  private const func GetController() -> ref<BunkerDoorController> {
    return this.m_controller as BunkerDoorController;
  }

  protected func ResolveGameplayState() -> Void {
    super.ResolveGameplayState();
    this.InitAnimation();
  }

  protected func GetOpeningSpeed() -> Float {
    if this.IsInteractedByNPC() {
      return this.GetDevicePS().GetNpcOpenSpeed();
    };
    return super.GetOpeningSpeed();
  }

  protected func GetOpeningTime() -> Float {
    if this.IsInteractedByNPC() {
      return this.GetDevicePS().GetNpcOpenTime();
    };
    return this.GetDevicePS().GetOpeningTime();
  }

  private final func IsInteractedByNPC() -> Bool {
    return IsDefined(this.m_whoOpened) && !this.m_whoOpened.IsPlayer();
  }

  protected cb func OnSetDoorMalfunctioningType(evt: ref<SetDoorMalfunctioningType>) -> Bool {
    this.GetDevicePS().SetMalfunctioningType(evt.malfunctioningType);
    GameObject.StopSound(this, this.m_glitchingSoundName);
    this.InitAnimation(true);
  }

  private final func InitAnimation(opt reset: Bool) -> Void {
    if this.GetDevicePS().IsMalfunctioningBehaviourActive(EMalfunctioningType.GLITCHING) {
      this.PlayGlitchingAnimation();
    } else {
      if reset {
        GameObject.StopSound(this, this.m_glitchingSoundName);
        this.ResetAnimation();
      };
    };
  }

  private final func PlayGlitchingAnimation() -> Void {
    GameObject.PlaySound(this, this.m_glitchingSoundName);
    this.SetUpAnimation();
    this.m_animFeatureDoor.m_malfunctioning = 3;
    this.DisableOccluder();
    AnimationControllerComponent.ApplyFeature(this, n"door", this.m_animFeatureDoor);
  }

  private final func ResetAnimation() -> Void {
    this.SetUpAnimation();
    AnimationControllerComponent.ApplyFeature(this, n"door", this.m_animFeatureDoor);
  }

  private final func SetUpAnimation() -> Void {
    if !IsDefined(this.m_animFeatureDoor) {
      this.m_animFeatureDoor = new AnimFeatureDoor();
    };
    this.m_animFeatureDoor.m_openingSpeed = 1.00;
    this.m_animFeatureDoor.m_openingType = EnumInt(this.m_doorOpeningType);
    this.m_animFeatureDoor.m_doorSide = this.m_lastDoorSide;
    this.m_animFeatureDoor.m_malfunctioning = 0;
  }

  private final func PlayHalfOpenAnimation() -> Void {
    GameObject.PlaySound(this, this.m_halfOpenSoundName);
    this.SetUpAnimation();
    this.m_animFeatureDoor.m_progress = 0.00;
    this.m_animFeatureDoor.m_malfunctioning = 2;
    AnimationControllerComponent.ApplyFeature(this, n"door", this.m_animFeatureDoor);
  }

  protected func TriggerMoveDoorStimBroadcaster(broadcaster: ref<StimBroadcasterComponent>, reactionData: stimInvestigateData) -> Void {
    if IsDefined(broadcaster) {
      if this.GetDevicePS().IsMalfunctioningBehaviourActive(EMalfunctioningType.LOUD_ANNOUNCEMENT) {
        broadcaster.TriggerSingleBroadcast(this, gamedataStimType.OpeningDoor, this.GetDevicePS().GetMalfunctioningStimRange(), reactionData);
      } else {
        super.TriggerMoveDoorStimBroadcaster(broadcaster, reactionData);
      };
    };
  }

  private final func PlayMalfunctionHalfOpen() -> Void {
    let ps: ref<BunkerDoorControllerPS> = this.GetDevicePS();
    this.PlayHalfOpenAnimation();
    this.InvokePsBusyState(ps.GetOpeningTime());
    this.MakeDoorToBeForceOpen(ps.GetOpeningTime());
    this.BroadCastOpeningStim(ps.GetMalfunctioningStimRange());
    ps.SetMalfunctioningType(EMalfunctioningType.NONE);
    this.DisableOccluder();
    this.EnableOccluderWithDelay(ps.GetOpeningTime());
    this.EnablePlayerBlocker();
    this.UpdateDeviceState();
  }

  private final func InvokePsBusyState(time: Float) -> Void {
    let ps: ref<DoorControllerPS> = this.GetDevicePS();
    let deviceBusy: ref<SetBusyEvent> = new SetBusyEvent();
    ps.SetIsBusy(true);
    GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(this, deviceBusy, time);
  }

  private final func MakeDoorToBeForceOpen(delay: Float) -> Void {
    let skillCheck: ref<SetSkillcheckEvent> = new SetSkillcheckEvent();
    let engDemoContainer: ref<EngDemoContainer> = new EngDemoContainer();
    let demolitionCheck: ref<DemolitionSkillCheck> = new DemolitionSkillCheck();
    demolitionCheck.SetDifficulty(EGameplayChallengeLevel.TRIVIAL);
    demolitionCheck.SetIsActive(true);
    engDemoContainer.m_demolitionCheck = demolitionCheck;
    skillCheck.skillcheckContainer = engDemoContainer;
    GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(this, skillCheck, delay);
  }

  private final func BroadCastOpeningStim(range: Float) -> Void {
    let broadcaster: ref<StimBroadcasterComponent>;
    let reactionData: stimInvestigateData;
    if IsDefined(this.m_whoOpened) && this.m_whoOpened.IsPlayer() {
      broadcaster = this.GetStimBroadcasterComponent();
      if IsDefined(broadcaster) {
        broadcaster.TriggerSingleBroadcast(this, gamedataStimType.OpeningDoor, range, reactionData);
      };
    };
  }

  protected cb func OnMalfunctionHalfOpen(evt: ref<MalfunctionHalfOpen>) -> Bool {
    this.PlayMalfunctionHalfOpen();
  }

  protected func PlayOpenDoorSound() -> Void {
    if this.IsInteractedByNPC() {
      GameObject.PlaySound(this, this.m_fastOpenSoundName);
    } else {
      if this.GetDevicePS().IsMalfunctioningBehaviourActive(EMalfunctioningType.LOUD_ANNOUNCEMENT) {
        GameObject.PlaySound(this, this.m_loudAnnouncementOpenSoundName);
      } else {
        super.PlayOpenDoorSound();
      };
    };
  }

  protected func SetupOpenDoorAnimationFeatures() -> Void {
    super.SetupOpenDoorAnimationFeatures();
    if IsDefined(this.m_whoOpened) && this.m_whoOpened.IsPlayer() && this.GetDevicePS().IsMalfunctioningBehaviourActive(EMalfunctioningType.LOUD_ANNOUNCEMENT) {
      this.m_animFeatureDoor.m_malfunctioning = 1;
    };
  }
}
