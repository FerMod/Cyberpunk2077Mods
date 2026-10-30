
class SpeedometerKmh extends IScriptable {
  private let m_speedometerUnits: ref<ConfigVarListString>;

  public final func isMetric() -> Bool {
    if !IsDefined(this.m_speedometerUnits) {
      let settings: ref<UserSettings> = new UserSettings();
      this.m_speedometerUnits = settings.GetVar(n"/interface", n"SpeedometerUnits") as ConfigVarListString;
    }
    return this.m_speedometerUnits.GetIndex() == 0;
  }

  public final func convertSpeed(speed: Float, metricFactor: Float, imperialFactor: Float) -> Int32 {
    let velocity: Float = AbsF(speed);
    if velocity <= 0.0 {
      return 0;
    }
    if this.isMetric() {
      return RoundMath(velocity * metricFactor);
    }
    return RoundMath(velocity * imperialFactor);
  }
}

@addField(speedometerLogicController)
private let m_speedometerKmh: ref<SpeedometerKmh>;

@addField(vehicleInteriorUIGameController)
private let m_speedometerKmh: ref<SpeedometerKmh>;

@replaceMethod(speedometerLogicController)
public final func OnSpeedValueChanged(speed: Float) -> Void {
  let velocity: Float = AbsF(speed);
  let multiplier: Float = GameInstance
    .GetStatsDataSystem(this.m_vehicle.GetGame())
    .GetValueFromCurve(n"vehicle_ui", velocity, n"speed_to_multiplier");
  let floatspeed: Float = velocity * multiplier;
  let displayedSpeed: Int32;
  if !IsDefined(this.m_speedometerKmh) {
    this.m_speedometerKmh = new SpeedometerKmh();
  }
  displayedSpeed = this.m_speedometerKmh.convertSpeed(floatspeed, 1.61, 1.0);

  // If the speed hasn't changed, don't update the text to avoid unnecessary redraws
  if displayedSpeed == this.m_currentSpeed {
    return;
  }

  inkTextRef.SetText(this.m_speedTextWidget, IntToString(displayedSpeed));
  this.m_currentSpeed = displayedSpeed;
}

@replaceMethod(vehicleInteriorUIGameController)
protected cb func OnSpeedValueChanged(speedValue: Float) -> Bool {
  let velocity: Float = AbsF(speedValue);
  let displayedSpeed: Int32;
  if !IsDefined(this.m_speedometerKmh) {
    this.m_speedometerKmh = new SpeedometerKmh();
  }
  displayedSpeed = this.m_speedometerKmh.convertSpeed(velocity, 3.6, 2.24);

  inkTextRef.SetText(this.m_speedTextWidget, IntToString(displayedSpeed));
}

