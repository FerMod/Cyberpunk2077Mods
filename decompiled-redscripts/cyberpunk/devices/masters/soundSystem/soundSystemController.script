
public class SoundSystemController extends MasterController {

  public const func GetPS() -> ref<SoundSystemControllerPS> {
    return this.GetBasePS() as SoundSystemControllerPS;
  }
}

public class SoundSystemControllerPS extends MasterControllerPS {

  protected let m_defaultAction: Int32;

  protected const let m_soundSystemSettings: [SoundSystemSettings];

  protected let m_currentEvent: ref<ChangeMusicAction>;

  protected let m_cachedEvent: ref<ChangeMusicAction>;

  protected cb func OnInstantiated() -> Bool {
    super.OnInstantiated();
    if !IsStringValid(this.m_deviceName) {
      this.m_deviceName = "Gameplay-Devices-DisplayNames-Switch";
    };
  }

  protected func Initialize() -> Void {
    super.Initialize();
  }

  protected func GameAttached() -> Void {
    if this.m_defaultAction >= ArraySize(this.m_soundSystemSettings) {
      this.m_defaultAction = 0;
    };
    if ArraySize(this.m_soundSystemSettings) > 0 {
      this.m_currentEvent = this.ActionChangeMusic(this.m_soundSystemSettings[this.m_defaultAction]);
      this.RefreshSlaves_Event();
    };
  }

  public func GetActions(out actions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    let i: Int32;
    super.GetActions(actions, context);
    i = 0;
    while i < ArraySize(this.m_soundSystemSettings) {
      if this.IsON() && Equals(context.requestType, gamedeviceRequestType.External) {
        ArrayPush(actions, this.ActionChangeMusic(this.m_soundSystemSettings[i]));
      };
      i += 1;
    };
    this.SetActionIllegality(actions, this.m_illegalActions.regularActions);
    return true;
  }

  protected const func CanCreateAnyQuickHackActions() -> Bool {
    let i: Int32 = 0;
    while i < ArraySize(this.m_soundSystemSettings) {
      if this.m_soundSystemSettings[i].m_canBeUsedAsQuickHack {
        return true;
      };
      i += 1;
    };
    return false;
  }

  protected func GetQuickHackActions(out outActions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    let currentAction: ref<ScriptableDeviceAction>;
    let i: Int32 = 0;
    while i < ArraySize(this.m_soundSystemSettings) {
      if this.m_soundSystemSettings[i].m_canBeUsedAsQuickHack {
        currentAction = this.ActionChangeMusic(this.m_soundSystemSettings[i]);
        currentAction.SetObjectActionID(t"DeviceAction.MalfunctionClassHack");
        ArrayPush(outActions, currentAction);
      };
      i += 1;
    };
    this.FinalizeGetQuickHackActions(outActions, context);
  }

  public func GetQuickHackActionsExternal(out outActions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    this.GetQuickHackActions(outActions, context);
  }

  protected final func ActionChangeMusic(settings: SoundSystemSettings) -> ref<ChangeMusicAction> {
    let action: ref<ChangeMusicAction> = new ChangeMusicAction();
    action.SetUp(this);
    action.SetProperties(settings.m_musicSettings, settings.m_interactionName);
    action.AddDeviceName(this.m_deviceName);
    action.CreateActionWidgetPackage();
    if settings.m_canBeUsedAsQuickHack {
      action.SetInteractionIcon(t"ChoiceCaptionParts.DistractIcon");
      action.CreateInteraction(settings.m_interactionName);
    };
    return action;
  }

  public final func OnChangeMusicAction(evt: ref<ChangeMusicAction>) -> EntityNotificationType {
    this.m_currentEvent = evt;
    this.EvaluateQuickHacksAvailability(evt.m_settings);
    this.RefreshSlaves_Event();
    this.UseNotifier(evt);
    this.NotifyParents_Event();
    return EntityNotificationType.DoNotNotifyEntity;
  }

  private final func EvaluateQuickHacksAvailability(settings: ref<MusicSettings>) -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.m_soundSystemSettings) {
      if this.m_soundSystemSettings[i].m_musicSettings == settings {
        this.m_soundSystemSettings[i].m_canBeUsedAsQuickHack = false;
      };
      i += 1;
    };
  }

  protected func OnRefreshSlavesEvent(evt: ref<RefreshSlavesEvent>) -> EntityNotificationType {
    if this.IsON() {
      this.RefreshSlaves();
    };
    return EntityNotificationType.DoNotNotifyEntity;
  }

  private final func RefreshSlaves() -> Void {
    let devices: array<ref<DeviceComponentPS>> = this.GetImmediateSlaves();
    let i: Int32 = 0;
    while i < ArraySize(devices) {
      if IsDefined(devices[i] as SpeakerControllerPS) {
        this.ExecutePSAction(this.m_currentEvent, devices[i]);
      };
      i += 1;
    };
  }

  protected final func OnRefreshSlavesState(evt: ref<RefreshSlavesState>) -> EntityNotificationType {
    this.RefreshSlavesState();
    return EntityNotificationType.DoNotNotifyEntity;
  }

  private final func RefreshSlavesState() -> Void {
    let devices: array<ref<DeviceComponentPS>> = this.GetImmediateSlaves();
    let i: Int32 = 0;
    while i < ArraySize(devices) {
      if IsDefined(devices[i] as SpeakerControllerPS) {
        if this.IsON() {
          this.ExecutePSAction(this.ActionSetDeviceON(), devices[i]);
        } else {
          this.ExecutePSAction(this.ActionSetDeviceOFF(), devices[i]);
        };
      };
      i += 1;
    };
  }

  protected func OnSetDeviceON(evt: ref<SetDeviceON>) -> EntityNotificationType {
    super.OnSetDeviceON(evt);
    this.RefreshSlavesState_Event();
    return EntityNotificationType.DoNotNotifyEntity;
  }

  protected func OnSetDeviceOFF(evt: ref<SetDeviceOFF>) -> EntityNotificationType {
    super.OnSetDeviceOFF(evt);
    this.RefreshSlavesState_Event();
    return EntityNotificationType.DoNotNotifyEntity;
  }

  protected func OnQuestForceOFF(evt: ref<QuestForceOFF>) -> EntityNotificationType {
    super.OnQuestForceOFF(evt);
    this.RefreshSlavesState_Event();
    return EntityNotificationType.DoNotNotifyEntity;
  }

  protected func OnQuestForceON(evt: ref<QuestForceON>) -> EntityNotificationType {
    super.OnQuestForceON(evt);
    this.RefreshSlavesState_Event();
    return EntityNotificationType.DoNotNotifyEntity;
  }

  public func OnToggleON(evt: ref<ToggleON>) -> EntityNotificationType {
    super.OnToggleON(evt);
    this.RefreshSlavesState_Event();
    return EntityNotificationType.DoNotNotifyEntity;
  }

  public final func RefreshSlavesState_Event() -> Void {
    let evt: ref<RefreshSlavesState> = new RefreshSlavesState();
    this.GetPersistencySystem().QueuePSEvent(this.GetID(), this.GetClassName(), evt);
  }

  protected func GetDeviceIconTweakDBID() -> TweakDBID {
    return t"DeviceIcons.RadioDeviceIcon";
  }

  protected func GetBackgroundTextureTweakDBID() -> TweakDBID {
    return t"DeviceIcons.RadioDeviceBackground";
  }
}

public abstract class MusicSettings extends IScriptable {

  protected let m_statusEffect: ESoundStatusEffects;

  public func GetSoundName() -> CName {
    return n"station_none";
  }

  public final func GetStatusEffect() -> ESoundStatusEffects {
    return this.m_statusEffect;
  }

  public final func SetStatusEffect(effect: ESoundStatusEffects) -> Void {
    this.m_statusEffect = effect;
  }
}

public class PlayRadio extends MusicSettings {

  protected let m_radioStation: ERadioStationList;

  public final func SetSoundName(soundname: ERadioStationList) -> Void {
    this.m_radioStation = soundname;
  }

  public final func GetStation() -> ERadioStationList {
    return this.m_radioStation;
  }

  public func GetSoundName() -> CName {
    return RadioStationDataProvider.GetStationName(this.GetStation());
  }
}

public class PlaySoundEvent extends MusicSettings {

  @runtimeProperty("customEditor", "AudioEvent")
  protected let soundEvent: CName;

  public func GetSoundName() -> CName {
    return this.soundEvent;
  }

  public final func SetSoundName(soundname: CName) -> Void {
    this.soundEvent = soundname;
  }
}
