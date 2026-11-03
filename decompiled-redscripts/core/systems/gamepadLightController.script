
public class GamepadLightScriptableSystem extends ScriptableSystem {

  private persistent let m_controllerCurrentColor: Vector3;

  private let m_controllerStartColor: Vector3;

  private persistent let m_controllerTargetColor: Vector3;

  private persistent let m_currentProgress: Float;

  private persistent let m_useExponentialCurve: Bool;

  private persistent let m_prevTime: Float;

  private persistent let m_currentState: ELightState;

  private persistent let m_prevState: ELightState;

  private persistent let m_timeLimit: Float;

  private let m_currrentId: DelayID;

  private func OnRestored(saveVersion: Int32, gameVersion: Int32) -> Void {
    let lerpEvent: ref<LerpToColorControllerLightRequest>;
    let setEvent: ref<SetControllerLightColorRequest> = new SetControllerLightColorRequest();
    setEvent.red = Cast<Uint8>(this.m_controllerCurrentColor.X);
    setEvent.green = Cast<Uint8>(this.m_controllerCurrentColor.Y);
    setEvent.blue = Cast<Uint8>(this.m_controllerCurrentColor.Z);
    this.OnSetControllerLightColorRequest(setEvent);
    if this.m_currentProgress > 0.01 && this.m_currentProgress < 0.90 {
      lerpEvent = new LerpToColorControllerLightRequest();
      lerpEvent.rgb = this.m_controllerTargetColor;
      lerpEvent.timeToLerp = this.m_timeLimit * (1.00 - this.m_currentProgress);
      lerpEvent.useExponentialCurve = this.m_useExponentialCurve;
      this.OnLerpToColorControllerLightRequest(lerpEvent);
    };
  }

  protected final func OnSetControllerLightColorRequest(evt: ref<SetControllerLightColorRequest>) -> Void {
    let gamepadLightController: ref<GamepadLightController> = GameInstance.GetGamepadLightController(this.GetGameInstance());
    this.m_controllerCurrentColor = new Vector3(Cast<Float>(evt.red), Cast<Float>(evt.green), Cast<Float>(evt.blue));
    gamepadLightController.SetControllerColor(evt.red, evt.green, evt.blue);
  }

  protected final func OnResetControllerLightColorRequest(evt: ref<ResetControllerLightColorRequest>) -> Void {
    this.ChangeState(ELightState.Reset);
    this.m_controllerCurrentColor = new Vector3(0.00, 0.00, 0.00);
    GameInstance.GetGamepadLightController(this.GetGameInstance()).ResetControllerColor();
  }

  protected final func OnLerpToDefaultControllerLightColorRequest(evt: ref<LerpToDefaultControllerLightColorRequest>) -> Void {
    let lerpEvt: ref<LerpToColorControllerLightRequest> = new LerpToColorControllerLightRequest();
    lerpEvt.rgb = new Vector3(0.00, 0.00, 0.00);
    lerpEvt.timeToLerp = 1.00;
    lerpEvt.useExponentialCurve = true;
    this.OnLerpToColorControllerLightRequest(lerpEvt);
  }

  protected final func OnLerpToColorControllerLightRequest(evt: ref<LerpToColorControllerLightRequest>) -> Void {
    let newB: Uint8;
    let newG: Uint8;
    let newR: Uint8;
    let gamepadLightController: ref<GamepadLightController> = GameInstance.GetGamepadLightController(this.GetGameInstance());
    if this.m_currrentId != GetInvalidDelayID() {
      this.m_currrentId = GetInvalidDelayID();
      this.m_controllerCurrentColor = this.m_controllerTargetColor;
      this.m_useExponentialCurve = false;
      newR = Cast<Uint8>(this.m_controllerCurrentColor.X);
      newG = Cast<Uint8>(this.m_controllerCurrentColor.Y);
      newB = Cast<Uint8>(this.m_controllerCurrentColor.Z);
      gamepadLightController.SetControllerColor(newR, newG, newB);
      GameInstance.GetDelaySystem(this.GetGameInstance()).CancelCallback(this.m_currrentId);
    };
    this.m_currentProgress = 0.00;
    this.m_timeLimit = evt.timeToLerp;
    this.m_controllerStartColor = this.m_controllerCurrentColor;
    this.m_controllerTargetColor = evt.rgb;
    this.m_useExponentialCurve = evt.useExponentialCurve;
    this.OnColorLerpTickRequest(null);
  }

  private final func OnColorLerpTickRequest(evt: ref<ColorLerpTickRequest>) -> Void {
    let newB: Uint8;
    let newG: Uint8;
    let newR: Uint8;
    let request: ref<ColorLerpTickRequest>;
    let tempProgress: Float;
    let gamepadLightController: ref<GamepadLightController> = GameInstance.GetGamepadLightController(this.GetGameInstance());
    let delta: Float = 0.01;
    if this.m_currentProgress > 1.00 {
      this.m_currrentId = GetInvalidDelayID();
      this.m_controllerCurrentColor = this.m_controllerTargetColor;
      this.m_useExponentialCurve = false;
      newR = Cast<Uint8>(this.m_controllerCurrentColor.X);
      newG = Cast<Uint8>(this.m_controllerCurrentColor.Y);
      newB = Cast<Uint8>(this.m_controllerCurrentColor.Z);
      gamepadLightController.SetControllerColor(newR, newG, newB);
      return;
    };
    if IsDefined(evt) {
      delta = EngineTime.ToFloat(GameInstance.GetSimTime(this.GetGameInstance())) - this.m_prevTime;
    };
    this.m_prevTime = EngineTime.ToFloat(GameInstance.GetSimTime(this.GetGameInstance()));
    this.m_currentProgress += delta / this.m_timeLimit;
    tempProgress = this.m_currentProgress > 1.00 ? 1.00 : this.m_currentProgress < 0.00 ? 0.00 : this.m_currentProgress;
    if this.m_useExponentialCurve {
      this.m_controllerCurrentColor = Vector3.Lerp(this.m_controllerStartColor, this.m_controllerTargetColor, this.ExponentialEaseInAndOut(tempProgress));
    } else {
      this.m_controllerCurrentColor = Vector3.Lerp(this.m_controllerStartColor, this.m_controllerTargetColor, tempProgress);
    };
    newR = Cast<Uint8>(this.m_controllerCurrentColor.X);
    newG = Cast<Uint8>(this.m_controllerCurrentColor.Y);
    newB = Cast<Uint8>(this.m_controllerCurrentColor.Z);
    gamepadLightController.SetControllerColor(newR, newG, newB);
    request = new ColorLerpTickRequest();
    this.m_currrentId = GameInstance.GetDelaySystem(this.GetGameInstance()).DelayScriptableSystemRequest(n"GamepadLightScriptableSystem", request, delta);
  }

  private final func ExponentialEaseInAndOut(x: Float) -> Float {
    let epsilon: Float = 0.00;
    if x > 1.00 {
      x = 1.00;
    };
    if x < 0.00 {
      x = 0.00;
    };
    return AbsF(x) < epsilon ? 0.00 : AbsF(x - 1.00) < epsilon ? 1.00 : x < 0.50 ? PowF(2.00, 20.00 * x - 10.00) / 2.00 : (2.00 - PowF(2.00, -20.00 * x + 10.00)) / 2.00;
  }

  private final func ChangeState(newState: ELightState) -> Bool {
    if Equals(this.m_currentState, newState) {
      return false;
    };
    if Equals(this.m_currentState, ELightState.Reset) || Equals(this.m_currentState, ELightState.DefaultColor) || Equals(newState, ELightState.Quest) {
      this.m_prevState = this.m_currentState;
      this.m_currentState = newState;
      return true;
    };
    if Equals(this.m_currentState, ELightState.Quest) {
      return false;
    };
    if Equals(newState, ELightState.Police) && Equals(this.m_currentState, ELightState.VehicleHealth_VeryLow) {
      return false;
    };
    this.m_prevState = this.m_currentState;
    this.m_currentState = newState;
    return true;
  }

  public final static func UpdatePoliceSiren(gi: GameInstance, heatStage: EPreventionHeatStage) -> Void {
    let siren: ref<PoliceSirenTimerRequest> = new PoliceSirenTimerRequest();
    let gamepadLightScriptableSystem: ref<GamepadLightScriptableSystem> = GameInstance.GetScriptableSystemsContainer(gi).Get(n"GamepadLightScriptableSystem") as GamepadLightScriptableSystem;
    if Equals(heatStage, EPreventionHeatStage.Heat_0) {
      if gamepadLightScriptableSystem.ChangeState(ELightState.DefaultColor) {
        gamepadLightScriptableSystem.OnResetControllerLightColorRequest(null);
      };
      return;
    };
    if !gamepadLightScriptableSystem.ChangeState(ELightState.Police) {
      return;
    };
    siren.red = true;
    siren.fast = true;
    siren.abort = false;
    gamepadLightScriptableSystem.OnPoliceSirenTimerRequest(siren);
  }

  private final func OnPoliceSirenTimerRequest(siren: ref<PoliceSirenTimerRequest>) -> Void {
    let lerp: ref<LerpToColorControllerLightRequest> = new LerpToColorControllerLightRequest();
    let preventionSystem: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(this.GetGameInstance()).Get(n"PreventionSystem") as PreventionSystem;
    siren.red = !siren.red;
    siren.abort = NotEquals(this.m_currentState, ELightState.Police);
    siren.fast = !preventionSystem.IsPoliceUnawareOfThePlayerExactLocation();
    if siren.abort {
      this.OnResetControllerLightColorRequest(null);
      return;
    };
    lerp.timeToLerp = 0.30;
    lerp.rgb = siren.red ? new Vector3(255.00, 0.00, 0.00) : new Vector3(0.00, 0.00, 255.00);
    lerp.useExponentialCurve = true;
    this.OnLerpToColorControllerLightRequest(lerp);
    GameInstance.GetDelaySystem(this.GetGameInstance()).DelayScriptableSystemRequest(n"GamepadLightScriptableSystem", siren, siren.fast ? 0.31 : 0.62);
  }

  public final static func TriggerVehicleExplosionWarningSiren(gi: GameInstance) -> Void {
    let request: ref<VehicleAboutToExplodeTimerRequest>;
    let gamepadLightScriptableSystem: ref<GamepadLightScriptableSystem> = GameInstance.GetScriptableSystemsContainer(gi).Get(n"GamepadLightScriptableSystem") as GamepadLightScriptableSystem;
    if !gamepadLightScriptableSystem.ChangeState(ELightState.VehicleHealth_Low) {
      return;
    };
    request = new VehicleAboutToExplodeTimerRequest();
    request.red = true;
    request.speed = 0.30;
    gamepadLightScriptableSystem.OnVehicleAboutToExplodeTimerRequest(request);
  }

  private final func OnVehicleAboutToExplodeTimerRequest(eminentExplosion: ref<VehicleAboutToExplodeTimerRequest>) -> Void {
    let playerVehicle: wref<VehicleObject>;
    let vehicleDamage: Int32;
    let preventionSystem: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(this.GetGameInstance()).Get(n"PreventionSystem") as PreventionSystem;
    let lerp: ref<LerpToColorControllerLightRequest> = new LerpToColorControllerLightRequest();
    let player: ref<PlayerPuppet> = GetPlayer(this.GetGameInstance());
    VehicleComponent.GetVehicle(player.GetGame(), player.GetEntityID(), playerVehicle);
    eminentExplosion.red = !eminentExplosion.red;
    if eminentExplosion.red && eminentExplosion.speed > 0.10 {
      eminentExplosion.speed -= 0.09;
    };
    if IsDefined(playerVehicle) {
      vehicleDamage = playerVehicle.GetBlackboard().GetInt(GetAllBlackboardDefs().Vehicle.DamageState);
      eminentExplosion.abort = vehicleDamage < 2;
    } else {
      eminentExplosion.abort = true;
    };
    if eminentExplosion.abort {
      this.OnResetControllerLightColorRequest(null);
      GamepadLightScriptableSystem.UpdatePoliceSiren(this.GetGameInstance(), preventionSystem.GetHeatStage());
      return;
    };
    lerp.timeToLerp = eminentExplosion.speed;
    lerp.rgb = eminentExplosion.red ? new Vector3(255.00, 0.00, 0.00) : new Vector3(0.00, 0.00, 0.00);
    lerp.useExponentialCurve = true;
    this.OnLerpToColorControllerLightRequest(lerp);
    GameInstance.GetDelaySystem(this.GetGameInstance()).DelayScriptableSystemRequest(n"GamepadLightScriptableSystem", eminentExplosion, Cast<Bool>(eminentExplosion.speed) ? 0.30 : 0.10);
  }
}
