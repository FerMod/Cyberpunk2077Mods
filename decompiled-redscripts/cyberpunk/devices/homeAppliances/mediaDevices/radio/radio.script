
public class Radio extends InteractiveDevice {

  @runtimeProperty("category", "High Pitch Noise Quick Hack Data")
  private inline edit let m_effectAction: ref<ScriptableDeviceAction>;

  @runtimeProperty("category", "High Pitch Noise Quick Hack Data")
  private edit let m_effectRef: EffectRef;

  @runtimeProperty("category", "High Pitch Noise Quick Hack Data")
  private edit let m_statusEffect: TweakDBID;

  @runtimeProperty("category", "Aoe Damage Quick Hack Data")
  @runtimeProperty("customEditor", "TweakDBGroupInheritance;Attacks.DeviceAttack")
  private edit let m_damageType: TweakDBID;

  private let m_startingStation: Int32;

  private let m_isInteractive: Bool;

  private let m_isShortGlitchActive: Bool;

  private let m_shortGlitchDelayID: DelayID;

  private let m_effectInstance: ref<EffectInstance>;

  private let m_targets: [wref<ScriptedPuppet>];

  private let m_vfxInstance: ref<FxInstance>;

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    EntityRequestComponentsInterface.RequestComponent(ri, n"audio", n"soundComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"radio_ui", n"worlduiWidgetComponent", false);
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_uiComponent = EntityResolveComponentsInterface.GetComponent(ri, n"radio_ui") as worlduiWidgetComponent;
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as RadioController;
  }

  protected func ResolveGameplayState() -> Void {
    super.ResolveGameplayState();
    if this.IsUIdirty() && this.m_isInsideLogicArea {
      this.RefreshUI();
    };
  }

  protected cb func OnToggleON(evt: ref<ToggleON>) -> Bool {
    super.OnToggleON(evt);
    this.TriggerArreaEffectDistraction(this.GetDefaultDistractionAreaEffectData(), evt.GetExecutor());
  }

  protected cb func OnTogglePower(evt: ref<TogglePower>) -> Bool {
    super.OnTogglePower(evt);
    this.TriggerArreaEffectDistraction(this.GetDefaultDistractionAreaEffectData(), evt.GetExecutor());
  }

  protected func RestoreDeviceState() -> Void {
    super.RestoreDeviceState();
  }

  public const func GetDevicePS() -> ref<RadioControllerPS> {
    return this.GetController().GetPS();
  }

  protected const func GetController() -> ref<RadioController> {
    return this.m_controller as RadioController;
  }

  private final func PlayGivenStation() -> Void {
    let isMetal: Bool;
    let radioStation: ERadioStationList = this.GetDevicePS().GetActiveRadioStation();
    let stationEventName: CName = RadioStationDataProvider.GetStationName(radioStation);
    GameObject.AudioSwitch(this, n"radio_station", stationEventName, n"radio");
    isMetal = Equals(radioStation, ERadioStationList.METAL);
    this.MetalItUp(isMetal);
  }

  private final func MetalItUp(isMetal: Bool) -> Void {
    if NotEquals(this.GetDevicePS().GetDurabilityType(), EDeviceDurabilityType.INVULNERABLE) {
      if isMetal {
        this.GetDevicePS().SetDurabilityType(EDeviceDurabilityType.INDESTRUCTIBLE);
      } else {
        this.GetDevicePS().SetDurabilityType(EDeviceDurabilityType.DESTRUCTIBLE);
      };
    };
  }

  protected cb func OnNextStation(evt: ref<NextStation>) -> Bool {
    this.PlayGivenStation();
    this.UpdateDeviceState();
    this.RefreshUI();
    this.TriggerArreaEffectDistraction(this.GetDefaultDistractionAreaEffectData(), evt.GetExecutor());
  }

  protected cb func OnPreviousStation(evt: ref<PreviousStation>) -> Bool {
    this.PlayGivenStation();
    this.UpdateDeviceState();
    this.RefreshUI();
    this.TriggerArreaEffectDistraction(this.GetDefaultDistractionAreaEffectData(), evt.GetExecutor());
  }

  protected cb func OnQuestSetChannel(evt: ref<QuestSetChannel>) -> Bool {
    this.PlayGivenStation();
    this.RefreshUI();
  }

  protected cb func OnQuestDefaultStation(evt: ref<QuestDefaultStation>) -> Bool {
    this.PlayGivenStation();
    this.RefreshUI();
  }

  protected cb func OnSpiderbotDistraction(evt: ref<SpiderbotDistraction>) -> Bool {
    this.OrderSpiderbot();
  }

  protected cb func OnSpiderbotOrderCompletedEvent(evt: ref<SpiderbotOrderCompletedEvent>) -> Bool {
    this.SendSetIsSpiderbotInteractionOrderedEvent(false);
    GameInstance.GetActivityLogSystem(this.GetGame()).AddLog("SPIDERBOT HAS FINISHED ACTIVATING THE DEVICE ... ");
    this.GetDevicePS().CauseDistraction();
  }

  protected func TurnOnDevice() -> Void {
    super.TurnOnDevice();
    if IsDefined(this.m_uiComponent) {
      this.m_uiComponent.Toggle(true);
    };
    this.PlayGivenStation();
    this.UpdateDeviceState();
    GameObjectEffectHelper.ActivateEffectAction(this, gamedataFxActionType.Start, n"radio_idle");
    this.RefreshUI();
  }

  protected func TurnOffDevice() -> Void {
    super.TurnOffDevice();
    GameObject.AudioSwitch(this, n"radio_station", n"station_none", n"radio");
    this.UpdateDeviceState();
    GameObjectEffectHelper.ActivateEffectAction(this, gamedataFxActionType.BreakLoop, n"radio_idle");
    this.RefreshUI();
  }

  protected func CutPower() -> Void {
    super.CutPower();
    if IsDefined(this.m_uiComponent) {
      this.m_uiComponent.Toggle(false);
    };
    GameObjectEffectHelper.ActivateEffectAction(this, gamedataFxActionType.BreakLoop, n"radio_idle");
    this.UpdateDeviceState();
  }

  protected func DeactivateDevice() -> Void {
    super.DeactivateDevice();
    if IsDefined(this.m_uiComponent) {
      this.m_uiComponent.Toggle(false);
    };
    GameObjectEffectHelper.ActivateEffectAction(this, gamedataFxActionType.Kill, n"radio_idle");
  }

  public const func DeterminGameplayRole() -> EGameplayRole {
    return EGameplayRole.Distract;
  }

  protected func StartGlitching(glitchState: EGlitchState, opt intensity: Float) -> Void {
    let evt: ref<AdvertGlitchEvent>;
    if intensity == 0.00 {
      intensity = 1.00;
    };
    evt = new AdvertGlitchEvent();
    evt.SetShouldGlitch(intensity);
    this.QueueEvent(evt);
    this.UpdateDeviceState();
    GameObject.PlaySound(this, this.GetDevicePS().GetGlitchSFX());
  }

  protected func StopGlitching() -> Void {
    let evt: ref<AdvertGlitchEvent> = new AdvertGlitchEvent();
    evt.SetShouldGlitch(0.00);
    this.QueueEvent(evt);
  }

  private final func StartShortGlitch() -> Void {
    let evt: ref<StopShortGlitchEvent>;
    if this.GetDevicePS().IsGlitching() {
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
    if !this.GetDevicePS().IsGlitching() {
      this.StopGlitching();
    };
  }

  protected cb func OnQuickHackHighPitchNoise(evt: ref<QuickHackHighPitchNoise>) -> Bool {
    if evt.IsStarted() {
      this.StartStunEffect();
    } else {
      this.StopStunEffect();
    };
  }

  protected cb func OnQuickHackAoeDamage(evt: ref<QuickHackAoeDamage>) -> Bool {
    this.PlayAoeDamageSFX();
    this.PlayAoeDamageVFX();
    this.ApplyElectricDamage();
    this.Die();
  }

  private final func ApplyElectricDamage() -> Void {
    let attack: ref<Attack_GameEffect> = RPGManager.PrepareGameEffectAttack(this.GetGame(), this, this, this.m_damageType, this.GetAttackPosition());
    if IsDefined(attack) {
      attack.StartAttack();
    };
  }

  private final func GetAttackPosition() -> Vector4 {
    return this.GetAcousticQuerryStartPoint();
  }

  private final func StartStunEffect() -> Void {
    this.StopStunEffect();
    this.CreateGameEffect();
    this.PlayHighPitchNoiseSFX();
    this.PlayHighPitchNoiseVFX();
  }

  private final func StopStunEffect() -> Void {
    this.TryTerminateEffectInstance();
    this.RemoveStatusEffectFromTargets();
    this.ClearTargets();
    this.TryStopVfx();
  }

  private final func TryTerminateEffectInstance() -> Void {
    if IsDefined(this.m_effectInstance) {
      this.m_effectInstance.Terminate();
      this.m_effectInstance = null;
    };
  }

  private final func RemoveStatusEffectFromTargets() -> Void {
    let i: Int32;
    if this.IsStatusEffectValid() {
      i = 0;
      while i < ArraySize(this.m_targets) {
        this.RemoveStatusEffect(this.m_targets[i]);
        i += 1;
      };
    };
  }

  private final func ClearTargets() -> Void {
    ArrayClear(this.m_targets);
  }

  private final func CreateGameEffect() -> Void {
    this.m_effectInstance = GameInstance.GetGameEffectSystem(this.GetGame()).CreateEffect(this.m_effectRef, this);
    EffectData.SetFloat(this.m_effectInstance.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.radius, this.GetDevicePS().GetHighPitchNoiseRadius());
    EffectData.SetVector(this.m_effectInstance.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.position, this.GetAttackPosition());
    this.m_effectInstance.Run();
  }

  private final func PlayHighPitchNoiseSFX() -> Void {
    GameObject.PlaySound(this, this.GetDevicePS().GetHighPitchNoiseSFX());
  }

  private final func PlayAoeDamageSFX() -> Void {
    GameObject.PlaySound(this, this.GetDevicePS().GetAoeDamageSFX());
  }

  private final func PlayHighPitchNoiseVFX() -> Void {
    this.PlayVfx(this.GetDevicePS().GetHighPitchNoiseVFX());
  }

  private final func PlayAoeDamageVFX() -> Void {
    this.PlayVfx(this.GetDevicePS().GetAoeDamageVFX());
  }

  private final func PlayVfx(fxResource: FxResource) -> Void {
    this.TryStopVfx();
    if FxResource.IsValid(fxResource) {
      this.m_vfxInstance = this.CreateFxInstance(fxResource, this.GetCenterWorldTransform());
    };
  }

  private final func GetCenterWorldTransform() -> WorldTransform {
    let position: WorldPosition;
    let transform: WorldTransform;
    WorldPosition.SetVector4(position, this.GetWorldPosition());
    WorldTransform.SetWorldPosition(transform, position);
    return transform;
  }

  private final func TryStopVfx() -> Void {
    if IsDefined(this.m_vfxInstance) {
      this.m_vfxInstance.Kill();
    };
  }

  private final func ApplyStatusEffect(target: wref<GameObject>) -> Void {
    if this.IsStatusEffectValid() {
      StatusEffectHelper.ApplyStatusEffect(target, this.m_statusEffect, this.GetEntityID());
    };
  }

  private final func RemoveStatusEffect(target: wref<GameObject>) -> Void {
    if this.IsStatusEffectValid() {
      StatusEffectHelper.RemoveStatusEffect(target, this.m_statusEffect);
    };
  }

  private final func IsStatusEffectValid() -> Bool {
    return TDBID.IsValid(this.m_statusEffect);
  }

  protected cb func OnTargetAcquired(evt: ref<TargetAcquiredEvent>) -> Bool {
    this.TryAddToTargets(evt.target);
    this.ApplyStatusEffect(evt.target);
  }

  private final func TryAddToTargets(target: wref<ScriptedPuppet>) -> Void {
    if IsDefined(target) && !ArrayContains(this.m_targets, target) {
      ArrayPush(this.m_targets, target);
    };
  }

  protected cb func OnTargetLost(evt: ref<TargetLostEvent>) -> Bool {
    this.RemoveStatusEffect(evt.target);
    this.TryRemoveFromTargets(evt.target);
  }

  private final func TryRemoveFromTargets(target: wref<ScriptedPuppet>) -> Void {
    let i: Int32;
    if IsDefined(target) {
      i = ArrayFindFirst(this.m_targets, target);
      if i >= 0 {
        ArrayErase(this.m_targets, i);
      };
    };
  }
}
