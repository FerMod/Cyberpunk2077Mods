
public class ExplosiveTriggerDevice extends ExplosiveDevice {

  private let m_meshTrigger: ref<MeshComponent>;

  private let m_trapTrigger: ref<TriggerComponent>;

  @default(ExplosiveTriggerDevice, trapTrigger)
  private let triggerName: CName;

  private let m_surroundingArea: ref<TriggerComponent>;

  @default(ExplosiveTriggerDevice, surroundingArea)
  private let m_surroundingAreaName: CName;

  private let m_soundIsActive: Bool;

  private let m_playerIsInSurroundingArea: Bool;

  private let m_proximityExplosionEventID: DelayID;

  @default(ExplosiveTriggerDevice, false)
  private let m_proximityExplosionEventSent: Bool;

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
    EntityRequestComponentsInterface.RequestComponent(ri, n"meshTrigger", n"MeshComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, this.triggerName, n"gameStaticTriggerAreaComponent", true);
    EntityRequestComponentsInterface.RequestComponent(ri, this.m_surroundingAreaName, n"gameStaticTriggerAreaComponent", true);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    this.m_meshTrigger = EntityResolveComponentsInterface.GetComponent(ri, n"meshTrigger") as MeshComponent;
    this.m_trapTrigger = EntityResolveComponentsInterface.GetComponent(ri, this.triggerName) as TriggerComponent;
    this.m_surroundingArea = EntityResolveComponentsInterface.GetComponent(ri, this.m_surroundingAreaName) as TriggerComponent;
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as ExplosiveDeviceController;
  }

  private const func GetController() -> ref<ExplosiveTriggerDeviceController> {
    return this.m_controller as ExplosiveTriggerDeviceController;
  }

  public const func GetDevicePS() -> ref<ExplosiveTriggerDeviceControllerPS> {
    return this.GetController().GetPS();
  }

  protected cb func OnAreaEnter(evt: ref<AreaEnteredEvent>) -> Bool {
    let whoEntered: EntityID = EntityGameInterface.GetEntity(evt.activator).GetEntityID();
    let puppet: wref<ScriptedPuppet> = EntityGameInterface.GetEntity(evt.activator) as ScriptedPuppet;
    if !this.GetDevicePS().IsON() {
      return false;
    };
    if Equals(GameObject.GetAttitudeTowards(EntityGameInterface.GetEntity(evt.activator) as ScriptedPuppet, GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerControlledGameObject()), EAIAttitude.AIA_Friendly) && this.GetDevicePS().CanPlayerSafePass() {
      return false;
    };
    if ScriptedPuppet.IsPlayerCompanion(EntityGameInterface.GetEntity(evt.activator) as ScriptedPuppet) {
      return false;
    };
    if IsDefined(puppet) && Equals(puppet.GetNPCType(), gamedataNPCType.Drone) {
      return false;
    };
    if Equals(evt.componentName, this.m_surroundingAreaName) {
      this.ReactOnSurroundingArea(whoEntered);
    } else {
      if Equals(evt.componentName, this.triggerName) {
        this.ReactOnTrigger(whoEntered);
      };
    };
  }

  private final func ReactOnSurroundingArea(whoEnteredID: EntityID) -> Void {
    let authLevel: ESecurityAccessLevel;
    let proximityEvt: ref<ExplosiveTriggerDeviceProximityEvent>;
    this.GetDevicePS().IsConnectedToSecuritySystem(authLevel);
    if this.GetDevicePS().GetSecuritySystem().IsUserAuthorized(whoEnteredID, authLevel) {
      return;
    };
    if this.GetDevicePS().IsDisarmed() {
      return;
    };
    if whoEnteredID == this.GetPlayerMainObject().GetEntityID() {
      this.m_playerIsInSurroundingArea = true;
    };
    proximityEvt = new ExplosiveTriggerDeviceProximityEvent();
    proximityEvt.instigator = whoEnteredID;
    this.m_proximityExplosionEventID = GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(this, proximityEvt, 2.00);
    this.m_proximityExplosionEventSent = true;
    GameObject.PlaySoundEvent(this, n"w_gre_mine_activate");
    this.m_soundIsActive = true;
  }

  private final func ReactOnTrigger(whoEnteredID: EntityID) -> Void {
    if this.GetDevicePS().CanPlayerSafePass() && whoEnteredID == this.GetPlayerMainObject().GetEntityID() {
      return;
    };
    if !this.GetDevicePS().CanPlayerSafePass() && whoEnteredID != this.GetPlayerMainObject().GetEntityID() {
      return;
    };
    if this.m_proximityExplosionEventSent {
      GameInstance.GetDelaySystem(this.GetGame()).CancelDelay(this.m_proximityExplosionEventID);
      this.m_proximityExplosionEventSent = false;
    };
    this.StartExplosionPipeline(this);
    GameObject.StopSoundEvent(this, n"w_gre_mine_activate");
    GameObject.PlaySoundEvent(this, n"w_gre_mine_stop");
    this.m_soundIsActive = false;
    this.GetDevicePS().TriggerSecuritySystemNotification(GameInstance.FindEntityByID(this.GetGame(), whoEnteredID) as GameObject, this.GetWorldPosition(), ESecurityNotificationType.ALARM);
  }

  protected cb func OnAreaExit(evt: ref<AreaExitedEvent>) -> Bool {
    if this.m_proximityExplosionEventSent {
      GameInstance.GetDelaySystem(this.GetGame()).CancelDelay(this.m_proximityExplosionEventID);
      this.m_proximityExplosionEventSent = false;
    };
    if this.m_soundIsActive && !this.GetDevicePS().IsDisarmed() {
      GameObject.StopSoundEvent(this, n"w_gre_mine_activate");
      GameObject.PlaySoundEvent(this, n"w_gre_mine_deactivate");
      this.m_soundIsActive = false;
    };
    if evt.triggerID == this.GetPlayerMainObject().GetEntityID() {
      this.m_playerIsInSurroundingArea = false;
    };
  }

  protected cb func OnExplosiveTriggerDeviceProximityEvent(evt: ref<ExplosiveTriggerDeviceProximityEvent>) -> Bool {
    this.m_proximityExplosionEventSent = false;
    if !this.GetDevicePS().IsDisarmed() && !this.GetDevicePS().IsExploded() {
      this.ReactOnTrigger(evt.instigator);
    };
  }

  protected func ToggleVisibility(visible: Bool) -> Void {
    super.ToggleVisibility(visible);
    this.ToggleTriggerLogic(visible);
  }

  protected final func ToggleTriggerLogic(state: Bool) -> Void {
    this.m_trapTrigger.Toggle(state);
    if !state {
      this.ChangeLasersColor(ExplosiveTriggerDeviceLaserState.DISABLED);
    } else {
      if this.GetDevicePS().CanPlayerSafePass() {
        this.ChangeLasersColor(ExplosiveTriggerDeviceLaserState.GREEN);
      } else {
        this.ChangeLasersColor(ExplosiveTriggerDeviceLaserState.RED);
      };
    };
  }

  protected func TurnOffDevice() -> Void {
    this.ToggleComponents(false);
    GameObject.PlaySoundEvent(this, n"w_gre_mine_deactivate");
    super.TurnOffDevice();
    if this.m_proximityExplosionEventSent {
      GameInstance.GetDelaySystem(this.GetGame()).CancelDelay(this.m_proximityExplosionEventID);
      this.m_proximityExplosionEventSent = false;
    };
  }

  protected func TurnOnDevice() -> Void {
    super.TurnOnDevice();
    this.ToggleComponents(true);
  }

  protected final func ToggleComponents(state: Bool) -> Void {
    this.ToggleTriggerLogic(state);
  }

  private final func ChangeLasersColor(laserState: ExplosiveTriggerDeviceLaserState) -> Void {
    let lightEvent: ref<ChangeLightEvent>;
    let isExploded: Bool = this.GetDevicePS().IsExploded();
    if !isExploded {
      lightEvent = new ChangeLightEvent();
      lightEvent.settings.strength = 1.00;
      lightEvent.time = 0.50;
      if Equals(laserState, ExplosiveTriggerDeviceLaserState.GREEN) {
        GameObjectEffectHelper.StartEffectEvent(this, n"mine_laser_green");
        GameObjectEffectHelper.BreakEffectLoopEvent(this, n"mine_laser_red");
        lightEvent.settings.color = new Color(0u, 255u, 0u, 0u);
      } else {
        if Equals(laserState, ExplosiveTriggerDeviceLaserState.RED) {
          GameObjectEffectHelper.StartEffectEvent(this, n"mine_laser_red");
          GameObjectEffectHelper.BreakEffectLoopEvent(this, n"mine_laser_green");
          lightEvent.settings.color = new Color(255u, 0u, 0u, 0u);
        };
      };
      this.QueueEvent(lightEvent);
    };
    if Equals(laserState, ExplosiveTriggerDeviceLaserState.DISABLED) {
      if isExploded {
        GameObjectEffectHelper.StopEffectEvent(this, n"mine_laser_red");
        GameObjectEffectHelper.StopEffectEvent(this, n"mine_laser_green");
      } else {
        GameObjectEffectHelper.BreakEffectLoopEvent(this, n"mine_laser_red");
        GameObjectEffectHelper.BreakEffectLoopEvent(this, n"mine_laser_green");
      };
      lightEvent.settings.color = new Color(0u, 0u, 0u, 0u);
      this.QueueEvent(lightEvent);
    };
  }

  protected cb func OnSetDeviceAttitude(evt: ref<SetDeviceAttitude>) -> Bool {
    if this.GetDevicePS().CanPlayerSafePass() {
      this.ChangeLasersColor(ExplosiveTriggerDeviceLaserState.GREEN);
      if this.m_soundIsActive && this.m_playerIsInSurroundingArea {
        GameObject.StopSoundEvent(this, n"w_gre_mine_activate");
        GameObject.PlaySoundEvent(this, n"w_gre_mine_deactivate");
        this.m_soundIsActive = false;
      };
    } else {
      this.ChangeLasersColor(ExplosiveTriggerDeviceLaserState.RED);
    };
  }

  protected cb func OnQuestSetPlayerSafePass(evt: ref<QuestSetPlayerSafePass>) -> Bool {
    if this.GetDevicePS().CanPlayerSafePass() {
      this.ChangeLasersColor(ExplosiveTriggerDeviceLaserState.GREEN);
    } else {
      this.ChangeLasersColor(ExplosiveTriggerDeviceLaserState.RED);
    };
  }

  public const func DeterminGameplayRoleMappinVisuaState(const data: script_ref<SDeviceMappinData>) -> EMappinVisualState {
    if this.GetDevicePS().CanPlayerSafePass() || this.GetDevicePS().IsDisarmed() || this.GetDevicePS().IsOFF() {
      return EMappinVisualState.Unavailable;
    };
    return super.DeterminGameplayRoleMappinVisuaState(data);
  }
}
