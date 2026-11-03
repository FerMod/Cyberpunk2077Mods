
public class VehiclePreventionHackState extends IScriptable {

  public let m_vehicle: wref<VehicleObject>;

  public let m_vehicleID: EntityID;

  public let m_progressBarProgressSoFar: Float;

  public let m_progressBarProgressStart: Float;

  public let m_hacked: Bool;

  public let m_hackInProgress: Bool;

  public let m_stoppedVehicle: Bool;

  public let m_progressBar: wref<UploadFromNPCToPlayerListener>;

  public let m_appliedHackSpeed: EAppliedTriangulationHackSpeed;

  public final func GetAppliedHackSpeedHack() -> TweakDBID {
    switch this.m_appliedHackSpeed {
      case EAppliedTriangulationHackSpeed.Slow:
        return t"AIQuickHack.PreventionSystemHackerLoop";
      case EAppliedTriangulationHackSpeed.Normal:
        return t"AIQuickHack.PreventionSystemHackerLoop2";
      case EAppliedTriangulationHackSpeed.Fast:
        return t"AIQuickHack.PreventionSystemHackerLoop3";
      case EAppliedTriangulationHackSpeed.NotAssigned:
        return t"AIQuickHack.PreventionSystemHackerLoop";
      default:
        return t"AIQuickHack.PreventionSystemHackerLoop";
    };
  }

  public final func HasAppliedHackSpeed() -> Bool {
    return NotEquals(this.m_appliedHackSpeed, EAppliedTriangulationHackSpeed.NotAssigned);
  }

  public final func GetTimeToHack(instance: GameInstance) -> Float {
    let table: wref<PreventionHeatTable_Record> = PreventionSystem.GetPreventionHeatTableRecord(instance);
    if !IsDefined(table) {
      return 0.00;
    };
    switch this.m_appliedHackSpeed {
      case EAppliedTriangulationHackSpeed.Slow:
        return table.HackLoopTimeToHack();
      case EAppliedTriangulationHackSpeed.Normal:
        return table.HackLoopTimeToHack2();
      case EAppliedTriangulationHackSpeed.Fast:
        return table.HackLoopTimeToHack3();
      case EAppliedTriangulationHackSpeed.NotAssigned:
        return table.HackLoopTimeToHack();
      default:
        return table.HackLoopTimeToHack();
    };
  }

  public final func IncrementHackSpeed() -> Void {
    switch this.m_appliedHackSpeed {
      case EAppliedTriangulationHackSpeed.Slow:
        this.m_appliedHackSpeed = EAppliedTriangulationHackSpeed.Normal;
        break;
      case EAppliedTriangulationHackSpeed.Normal:
        this.m_appliedHackSpeed = EAppliedTriangulationHackSpeed.Fast;
    };
  }
}

public class PreventionSystemHackerLoop extends ScriptableSystem {

  private let m_firstVehicle: wref<VehicleObject>;

  @default(PreventionSystemHackerLoop, EPreventionHackLoopState.IDLE)
  private let m_state: EPreventionHackLoopState;

  private let m_shouldHackLoopBeEnabledOnThisStar: Bool;

  private let m_showingHackingPopUp: Bool;

  private let m_currentVehicle: wref<VehicleObject>;

  private let m_previousVehicle: wref<VehicleObject>;

  private let m_curentHackDelayId: DelayID;

  private let m_futureDelayedUpdateDelayId: DelayID;

  private let m_hackedVehicles: [ref<VehiclePreventionHackState>];

  private let m_otherProgressBar: wref<UploadFromNPCToPlayerListener>;

  private let m_waitingForUpdate: Bool;

  public final static func GetSystemName() -> CName {
    return n"PreventionSystemHackerLoop";
  }

  private final func IsFirstVehicle(vehicle: wref<VehicleObject>) -> Bool {
    return IsDefined(this.m_firstVehicle) && IsDefined(vehicle) && this.m_firstVehicle == vehicle;
  }

  private final static func GetInstance(game: GameInstance) -> ref<PreventionSystemHackerLoop> {
    let instance: ref<PreventionSystemHackerLoop> = GameInstance.GetScriptableSystemsContainer(game).Get(n"PreventionSystemHackerLoop") as PreventionSystemHackerLoop;
    return instance;
  }

  private final static func GetCurrentStarState(game: GameInstance) -> EStarState {
    let instance: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(game).Get(n"PreventionSystem") as PreventionSystem;
    return instance.GetStarState();
  }

  public final static func UpdateStarStateUI(game: GameInstance) -> Void {
    let instance: ref<PreventionSystemHackerLoop> = PreventionSystemHackerLoop.GetInstance(game);
    instance.UpdateState();
  }

  public final static func KeepProgressBarAliveAfterCompletion(game: GameInstance) -> Bool {
    let hackedState: ref<VehiclePreventionHackState>;
    let instance: ref<PreventionSystemHackerLoop> = PreventionSystemHackerLoop.GetInstance(game);
    if IsDefined(instance.m_currentVehicle) {
      hackedState = instance.FindVehicleState(instance.m_currentVehicle);
      if hackedState.m_stoppedVehicle {
        return false;
      };
      return hackedState.m_hacked || hackedState.m_hackInProgress;
    };
    return false;
  }

  public final static func ShouldForceUpdateProgressBar(game: GameInstance) -> Bool {
    let hackedState: ref<VehiclePreventionHackState>;
    let instance: ref<PreventionSystemHackerLoop> = PreventionSystemHackerLoop.GetInstance(game);
    if IsDefined(instance.m_currentVehicle) {
      hackedState = instance.FindVehicleState(instance.m_currentVehicle);
      return hackedState.m_hacked || hackedState.m_hackInProgress;
    };
    return false;
  }

  public final static func GetProgressBarForcedValue(game: GameInstance) -> Float {
    let hackedState: ref<VehiclePreventionHackState>;
    let instance: ref<PreventionSystemHackerLoop> = PreventionSystemHackerLoop.GetInstance(game);
    if IsDefined(instance.m_currentVehicle) {
      hackedState = instance.FindVehicleState(instance.m_currentVehicle);
      return hackedState.m_progressBarProgressStart;
    };
    return 0.00;
  }

  public final static func UpdateHackLoopProgressBarValue(game: GameInstance, newValue: Float, progressbar: ref<UploadFromNPCToPlayerListener>) -> Void {
    let hackedState: ref<VehiclePreventionHackState>;
    let instance: ref<PreventionSystemHackerLoop> = PreventionSystemHackerLoop.GetInstance(game);
    if IsDefined(instance.m_currentVehicle) {
      hackedState = instance.FindVehicleState(instance.m_currentVehicle);
      hackedState.m_progressBarProgressSoFar = newValue;
      hackedState.m_progressBar = progressbar;
    };
  }

  public final static func UpdateOtherProgressBarReference(game: GameInstance, progressbar: ref<UploadFromNPCToPlayerListener>) -> Void {
    let instance: ref<PreventionSystemHackerLoop> = PreventionSystemHackerLoop.GetInstance(game);
    instance.m_otherProgressBar = progressbar;
  }

  public final static func AVCanBeSpawned(game: GameInstance) -> Bool {
    let hackedState: ref<VehiclePreventionHackState>;
    let instance: ref<PreventionSystemHackerLoop> = PreventionSystemHackerLoop.GetInstance(game);
    if IsDefined(instance.m_currentVehicle) {
      if instance.m_currentVehicle.IsInAir() {
        return false;
      };
      hackedState = instance.FindVehicleState(instance.m_currentVehicle);
      return hackedState.m_hacked;
    };
    return true;
  }

  public final static func ForceCarToStop(game: GameInstance) -> Void {
    let vehicle: ref<VehiclePreventionHackState>;
    let instance: ref<PreventionSystemHackerLoop> = PreventionSystemHackerLoop.GetInstance(game);
    if !IsDefined(instance.m_currentVehicle) {
      return;
    };
    PoliceRadioScriptSystem.PlayRadio(game, n"maxtac_dispatch_start");
    vehicle = instance.FindVehicleState(instance.m_currentVehicle);
    instance.StopVehicle_Internal(game, vehicle);
  }

  public final static func UpdateHeatLevel(game: GameInstance, shouldHackLoopBeEnabledOnThisStar: Bool) -> Void {
    let instance: ref<PreventionSystemHackerLoop> = PreventionSystemHackerLoop.GetInstance(game);
    instance.m_shouldHackLoopBeEnabledOnThisStar = shouldHackLoopBeEnabledOnThisStar;
    instance.UpdateState();
  }

  public final static func UpdatePlayerVehicle(game: GameInstance, currentVehicle: wref<VehicleObject>) -> Void {
    let instance: ref<PreventionSystemHackerLoop> = PreventionSystemHackerLoop.GetInstance(game);
    instance.m_previousVehicle = instance.m_currentVehicle;
    instance.m_currentVehicle = currentVehicle;
    instance.UpdateState();
  }

  private final func FindVehicleState(vehicle: wref<VehicleObject>) -> ref<VehiclePreventionHackState> {
    let data: ref<VehiclePreventionHackState>;
    let tempVehicleID: EntityID;
    let vehicleID: EntityID = vehicle.GetEntityID();
    let i: Int32 = ArraySize(this.m_hackedVehicles) - 1;
    while i >= 0 {
      if !IsDefined(this.m_hackedVehicles[i]) || !IsDefined(this.m_hackedVehicles[i].m_vehicle) {
        ArrayErase(this.m_hackedVehicles, i);
      } else {
        tempVehicleID = this.m_hackedVehicles[i].m_vehicleID;
        if tempVehicleID == vehicleID {
          return this.m_hackedVehicles[i];
        };
      };
      i -= 1;
    };
    data = new VehiclePreventionHackState();
    data.m_vehicleID = vehicleID;
    data.m_vehicle = vehicle;
    ArrayPush(this.m_hackedVehicles, data);
    return data;
  }

  private final func LaunchDelayedStateUpdate(delay: Float) -> Void {
    let evt: ref<PreventionSystemUpdateHackLoopStateEvent>;
    if this.m_waitingForUpdate {
      GameInstance.GetDelaySystem(this.GetGameInstance()).CancelCallback(this.m_futureDelayedUpdateDelayId);
    } else {
      this.m_waitingForUpdate = true;
    };
    evt = new PreventionSystemUpdateHackLoopStateEvent();
    this.m_futureDelayedUpdateDelayId = GameInstance.GetDelaySystem(this.GetGameInstance()).DelayScriptableSystemRequest(n"PreventionSystemHackerLoop", evt, delay);
  }

  private final func UpdateState() -> Void {
    if this.m_waitingForUpdate {
      return;
    };
    switch this.m_state {
      case EPreventionHackLoopState.IDLE:
        this.Idle();
        return;
      case EPreventionHackLoopState.INTRO_RADIO:
        this.IntroRadio();
        break;
      case EPreventionHackLoopState.HACK_LOOP:
        this.HackLoop();
    };
    if !this.m_shouldHackLoopBeEnabledOnThisStar {
      this.m_state = EPreventionHackLoopState.IDLE;
    };
  }

  private final func Idle() -> Void {
    let delay: Float;
    if !IsDefined(this.m_currentVehicle) {
      return;
    };
    if !this.m_shouldHackLoopBeEnabledOnThisStar {
      return;
    };
    this.m_firstVehicle = this.m_currentVehicle;
    this.m_state = EPreventionHackLoopState.INTRO_RADIO;
    delay = PreventionSystem.GetPreventionHeatTableRecord(this.GetGameInstance()).IdleStateTransitionDelay();
    this.LaunchDelayedStateUpdate(delay);
  }

  private final func IntroRadio() -> Void {
    let delay: Float;
    if !IsDefined(this.m_currentVehicle) {
      return;
    };
    if !this.m_shouldHackLoopBeEnabledOnThisStar {
      this.m_state = EPreventionHackLoopState.IDLE;
      return;
    };
    this.m_state = EPreventionHackLoopState.HACK_LOOP;
    PoliceRadioScriptSystem.PlayRadio(this.GetGameInstance(), n"start_hack_vehicle_loop");
    delay = PreventionSystem.GetPreventionHeatTableRecord(this.GetGameInstance()).IntroRadioStateTransitionDelay();
    this.LaunchDelayedStateUpdate(delay);
  }

  private final func HackLoop() -> Void {
    let data: ref<VehiclePreventionHackState>;
    let evt: ref<DelayedStopVehicle>;
    if !IsDefined(this.m_currentVehicle) {
      if this.m_showingHackingPopUp {
        if this.m_shouldHackLoopBeEnabledOnThisStar {
          data = this.FindVehicleState(this.m_previousVehicle);
          this.PauseHack(data);
        };
        if this.m_showingHackingPopUp {
          data.m_hackInProgress = false;
          this.InterruptHackingPopUp();
        };
        this.LaunchDelayedStateUpdate(1.00);
      };
      return;
    };
    data = this.FindVehicleState(this.m_currentVehicle);
    if !this.m_shouldHackLoopBeEnabledOnThisStar {
      this.m_state = EPreventionHackLoopState.IDLE;
      data.m_appliedHackSpeed = EAppliedTriangulationHackSpeed.NotAssigned;
      data.m_hackInProgress = false;
      this.AbortHacks();
      this.LaunchDelayedStateUpdate(1.00);
      return;
    };
    if NotEquals(PreventionSystemHackerLoop.GetCurrentStarState(this.GetGameInstance()), EStarState.Active) {
      if this.m_showingHackingPopUp {
        data.IncrementHackSpeed();
        data.m_hackInProgress = false;
        this.AbortHacks();
        this.LaunchDelayedStateUpdate(1.00);
      };
      return;
    };
    if data.m_stoppedVehicle {
      evt = new DelayedStopVehicle();
      evt.state = data;
      GameInstance.GetDelaySystem(this.GetGameInstance()).DelayScriptableSystemRequest(n"PreventionSystemHackerLoop", evt, 1.00);
      return;
    };
    if IsDefined(this.m_otherProgressBar) {
      this.LaunchDelayedStateUpdate(2.00);
      return;
    };
    if data.m_progressBarProgressStart > 0.01 {
      this.UnpauseHack(data);
    };
    if !this.m_showingHackingPopUp {
      this.StartHackTimer(data);
      this.LaunchDelayedStateUpdate(1.00);
    };
  }

  private final func PauseHack(newHack: ref<VehiclePreventionHackState>) -> Void {
    newHack.m_progressBarProgressStart = newHack.m_progressBarProgressSoFar;
    GameInstance.GetDelaySystem(this.GetGameInstance()).CancelCallback(this.m_curentHackDelayId);
  }

  private final func UnpauseHack(newHack: ref<VehiclePreventionHackState>) -> Void {
    newHack.m_progressBarProgressSoFar = newHack.m_progressBarProgressStart;
  }

  private final func AbortHacks() -> Void {
    GameInstance.GetDelaySystem(this.GetGameInstance()).CancelCallback(this.m_curentHackDelayId);
    this.InterruptHackingPopUp();
  }

  private final func HackTimerCallback(data: ref<VehiclePreventionHackState>, delay: Float) -> Void {
    let hackLoopReportPlayerLocationRequest: ref<HackLoopReportPlayerLocationRequest>;
    data.m_hackInProgress = false;
    data.m_hacked = true;
    if this.m_currentVehicle != data.m_vehicle {
      return;
    };
    hackLoopReportPlayerLocationRequest = new HackLoopReportPlayerLocationRequest();
    hackLoopReportPlayerLocationRequest.state = data;
    this.BroadcastPlayerLocationUntilVehicleExit(hackLoopReportPlayerLocationRequest, 0.50);
  }

  private final func IsNearMaxtac() -> Bool {
    let agent: ref<NPCAgent>;
    let i: Int32;
    let maxtacNpcs: array<ref<NPCAgent>>;
    let player: ref<PlayerPuppet>;
    let playerVehicleMaxTacDistance: Float;
    let table: wref<PreventionHeatTable_Record> = PreventionSystem.GetPreventionHeatTableRecord(this.GetGameInstance());
    if !IsDefined(table) {
      return false;
    };
    if PreventionSystem.GetAgentRegistry(this.GetGameInstance()).GetMaxTacNPCCount() > 0 {
      playerVehicleMaxTacDistance = table.HackLoopPlayerVehicleMaxtacDistance();
      playerVehicleMaxTacDistance *= playerVehicleMaxTacDistance;
      maxtacNpcs = PreventionSystem.GetAgentRegistry(this.GetGameInstance()).GetMaxTacNPCList();
      player = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerControlledGameObject() as PlayerPuppet;
      i = 0;
      while i < ArraySize(maxtacNpcs) {
        agent = maxtacNpcs[i];
        if Vector4.DistanceSquared(player.GetWorldPosition(), agent.gameObject.GetWorldPosition()) < playerVehicleMaxTacDistance {
          return true;
        };
        i += 1;
      };
    };
    return false;
  }

  private final func BroadcastPlayerLocationUntilVehicleExit(request: ref<HackLoopReportPlayerLocationRequest>, delay: Float) -> Void {
    let instance: GameInstance = this.GetGameInstance();
    if !IsDefined(this.m_currentVehicle) || !this.m_shouldHackLoopBeEnabledOnThisStar || this.m_currentVehicle != request.state.m_vehicle || request.state.m_stoppedVehicle {
      PreventionSystem.ForceStarStateToActive(instance, false);
      return;
    };
    if this.IsNearMaxtac() {
      this.StopVehicle_Internal(this.GetGameInstance(), request.state);
      PreventionSystem.ForceStarStateToActive(instance, false);
      return;
    };
    PreventionSystem.SetLastKnownPlayerPosition(instance, this.m_currentVehicle.GetWorldPosition());
    PreventionSystem.ForceStarStateToActive(instance, true);
    GameInstance.GetDelaySystem(instance).DelayScriptableSystemRequest(n"PreventionSystemHackerLoop", request, delay);
  }

  private final func OnHackLoopReportPlayerLocationRequest(request: ref<HackLoopReportPlayerLocationRequest>) -> Void {
    this.BroadcastPlayerLocationUntilVehicleExit(request, 0.50);
  }

  private final func StartHackTimer(data: ref<VehiclePreventionHackState>) -> Void {
    let timeToHack: Float;
    let isInterruptedHack: Bool = data.m_progressBarProgressStart > 0.01;
    let instance: GameInstance = this.GetGameInstance();
    let evt: ref<PreventionSystemPlayerCarHackTimeOutEvent> = new PreventionSystemPlayerCarHackTimeOutEvent();
    evt.state = data;
    if !data.HasAppliedHackSpeed() {
      data.m_appliedHackSpeed = EAppliedTriangulationHackSpeed.Normal;
      if this.IsFirstVehicle(this.m_currentVehicle) {
        data.m_appliedHackSpeed = EAppliedTriangulationHackSpeed.Slow;
      };
      if this.IsNearMaxtac() {
        data.m_appliedHackSpeed = EAppliedTriangulationHackSpeed.Fast;
      };
    };
    this.StartBigHackingPopUp(data);
    timeToHack = data.GetTimeToHack(this.GetGameInstance());
    if isInterruptedHack {
      timeToHack -= data.m_progressBarProgressStart / 100.00 * timeToHack;
    };
    if timeToHack < 0.01 {
      timeToHack = 1.00;
      data.m_progressBarProgressStart = 98.00;
    };
    data.m_hackInProgress = true;
    GameInstance.GetDelaySystem(this.GetGameInstance()).CancelCallback(this.m_curentHackDelayId);
    this.m_curentHackDelayId = GameInstance.GetDelaySystem(instance).DelayScriptableSystemRequest(n"PreventionSystemHackerLoop", evt, timeToHack);
  }

  private final func StartBigHackingPopUp(data: ref<VehiclePreventionHackState>) -> Void {
    let player: ref<GameObject> = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerMainGameObject();
    let evt: ref<HackTargetEvent> = new HackTargetEvent();
    evt.targetID = player.GetEntityID();
    evt.netrunnerID = player.GetEntityID();
    evt.objectRecord = TweakDBInterface.GetObjectActionRecord(data.GetAppliedHackSpeedHack());
    evt.settings.showDirectionalIndicator = false;
    evt.settings.skipBeingHackedSetUp = true;
    if StatusEffectSystem.ObjectHasStatusEffect(player, t"StatusEffect.HackReveal") {
      StatusEffectHelper.RemoveStatusEffect(player, t"AIQuickHackStatusEffect.HackRevealInterrupted");
    } else {
      StatusEffectHelper.RemoveStatusEffect(player, t"AIQuickHackStatusEffect.HackingInterrupted");
    };
    player.QueueEvent(evt);
    this.m_showingHackingPopUp = true;
  }

  private final func ForceCloseProgressBar(vehicle: ref<VehicleObject>) -> Bool {
    let data: ref<VehiclePreventionHackState>;
    if IsDefined(vehicle) {
      data = this.FindVehicleState(vehicle);
      if IsDefined(data.m_progressBar) {
        data.m_progressBar.ForceClose();
        return true;
      };
    };
    return false;
  }

  private final func InterruptHackingPopUp() -> Void {
    let player: ref<GameObject> = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerMainGameObject();
    if !this.ForceCloseProgressBar(this.m_currentVehicle) {
      this.ForceCloseProgressBar(this.m_previousVehicle);
    };
    if StatusEffectSystem.ObjectHasStatusEffect(player, t"StatusEffect.HackReveal") {
      StatusEffectHelper.ApplyStatusEffect(player, t"AIQuickHackStatusEffect.HackRevealInterrupted");
    } else {
      StatusEffectHelper.ApplyStatusEffect(player, t"AIQuickHackStatusEffect.HackingInterrupted");
    };
    this.m_showingHackingPopUp = false;
  }

  private final func StopVehicle(state: ref<VehiclePreventionHackState>, delay: Float) -> Void {
    let instance: GameInstance = this.GetGameInstance();
    let evt: ref<PreventionSystemPlayerCarHackFinishedEvent> = new PreventionSystemPlayerCarHackFinishedEvent();
    state.m_vehicle.ForceBrakesUntilStoppedOrFor(delay);
    evt.state = state;
    GameInstance.GetDelaySystem(instance).DelayScriptableSystemRequest(n"PreventionSystemHackerLoop", evt, delay);
  }

  private final func OnDelayedStopVehicle(request: ref<DelayedStopVehicle>) -> Void {
    this.StopVehicle(request.state, PreventionSystem.GetPreventionHeatTableRecord(this.GetGameInstance()).HackLoopDurationInGoodSpot());
  }

  private final func OnPreventionSystemPlayerCarHackFinishedEvent(request: ref<PreventionSystemPlayerCarHackFinishedEvent>) -> Void {
    GameObjectEffectHelper.StopEffectEvent(request.state.m_vehicle, n"immobilized");
    request.state.m_hacked = false;
    this.UpdateState();
  }

  private final func OnPreventionSystemPlayerCarHackTimeOutEvent(request: ref<PreventionSystemPlayerCarHackTimeOutEvent>) -> Void {
    let duration: Float = PreventionSystem.GetPreventionHeatTableRecord(this.GetGameInstance()).HackLoopHackDuration();
    this.HackTimerCallback(request.state, duration);
  }

  private final func OnPreventionSystemUpdateHackLoopStateEvent(request: ref<PreventionSystemUpdateHackLoopStateEvent>) -> Void {
    this.m_waitingForUpdate = false;
    this.UpdateState();
  }

  private final func StopVehicle_Internal(game: GameInstance, data: ref<VehiclePreventionHackState>) -> Void {
    data.m_stoppedVehicle = true;
    GameObjectEffectHelper.StartEffectEvent(data.m_vehicle, n"immobilized");
    this.ForceCloseProgressBar(data.m_vehicle);
    this.StopVehicle(data, PreventionSystem.GetPreventionHeatTableRecord(game).HackLoopDurationInGoodSpot());
    GameObjectEffectHelper.StartEffectEvent(data.m_vehicle, n"immobilized");
    this.DelayForceAboutToExplodeState(data, 5.00);
  }

  private final func DelayForceAboutToExplodeState(state: ref<VehiclePreventionHackState>, delay: Float) -> Void {
    let evt: ref<DelayedForceAboutToExplodeStateRequest> = new DelayedForceAboutToExplodeStateRequest();
    let instance: GameInstance = this.GetGameInstance();
    evt.state = state;
    GameInstance.GetDelaySystem(instance).DelayScriptableSystemRequest(n"PreventionSystemHackerLoop", evt, delay);
  }

  private final func OnDelayedForceAboutToExplodeState(request: ref<DelayedForceAboutToExplodeStateRequest>) -> Void {
    request.state.m_vehicle.GetVehicleComponent().ForceAboutToExplodeState();
  }
}
