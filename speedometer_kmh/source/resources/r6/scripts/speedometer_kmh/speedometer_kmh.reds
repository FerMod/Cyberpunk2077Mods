@addField(speedometerLogicController)
private let m_speedometerSettings: ref<UserSettings>;

@addField(speedometerLogicController)
private let m_isMetric: Bool;

@addField(vehicleInteriorUIGameController)
private let m_speedometerSettings: ref<UserSettings>;

@addField(vehicleInteriorUIGameController)
private let m_isMetric: Bool;

@replaceMethod(speedometerLogicController)
public final func OnSpeedValueChanged(speed: Float) -> Void {
  let velocity: Float = AbsF(speed);
  let multiplier: Float = GameInstance.GetStatsDataSystem(this.m_vehicle.GetGame()).GetValueFromCurve(n"vehicle_ui", velocity, n"speed_to_multiplier");
  let floatspeed: Float = velocity * multiplier;
  let displayedSpeed: Int32;
  if !IsDefined(this.m_speedometerSettings) {
    this.m_speedometerSettings = new UserSettings();
    this.m_isMetric = (this.m_speedometerSettings.GetVar(n"/interface", n"SpeedometerUnits") as ConfigVarListString).GetIndex() == 0;
  };
  if speed <= 0.00 {
    displayedSpeed = 0;
  } else if this.m_isMetric {
    // Convert from m/s to km/h
    displayedSpeed = RoundMath(floatspeed * 1.61);
  } else {
    // Already in mph
    displayedSpeed = RoundMath(floatspeed);
  };
  if displayedSpeed != this.m_currentSpeed {
    inkTextRef.SetText(this.m_speedTextWidget, IntToString(displayedSpeed));
    this.m_currentSpeed = displayedSpeed;
  };
}

@replaceMethod(vehicleInteriorUIGameController)
protected cb func OnSpeedValueChanged(speedValue: Float) -> Bool {
  let displayedSpeed: Int32;
  if !IsDefined(this.m_speedometerSettings) {
    this.m_speedometerSettings = new UserSettings();
    this.m_isMetric = (this.m_speedometerSettings.GetVar(n"/interface", n"SpeedometerUnits") as ConfigVarListString).GetIndex() == 0;
  };
  if speedValue <= 0.00 {
    displayedSpeed = 0;
  } else if this.m_isMetric {
    // Convert from m/s to km/h
    displayedSpeed = RoundMath(speedValue * 3.60);
  } else {
    // Convert from m/s to mph
    displayedSpeed = RoundMath(speedValue * 2.24);
  };
  inkTextRef.SetText(this.m_speedTextWidget, IntToString(displayedSpeed));
}
