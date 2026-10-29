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
  this.EnsureSpeedometerSettings();
  displayedSpeed = this.GetDisplayedSpeed(floatspeed, 1.61, 1.00);
  if displayedSpeed != this.m_currentSpeed {
    inkTextRef.SetText(this.m_speedTextWidget, IntToString(displayedSpeed));
    this.m_currentSpeed = displayedSpeed;
  };
}

@replaceMethod(vehicleInteriorUIGameController)
protected cb func OnSpeedValueChanged(speedValue: Float) -> Bool {
  let displayedSpeed: Int32;
  this.EnsureSpeedometerSettings();
  displayedSpeed = this.GetDisplayedSpeed(speedValue, 3.60, 2.24);
  inkTextRef.SetText(this.m_speedTextWidget, IntToString(displayedSpeed));
}

@addMethod(speedometerLogicController)
@addMethod(vehicleInteriorUIGameController)
private final func EnsureSpeedometerSettings() -> Void {
  if !IsDefined(this.m_speedometerSettings) {
    this.m_speedometerSettings = new UserSettings();
  };
  this.m_isMetric = (this.m_speedometerSettings.GetVar(n"/interface", n"SpeedometerUnits") as ConfigVarListString).GetIndex() == 0;
}

@addMethod(speedometerLogicController)
@addMethod(vehicleInteriorUIGameController)
private final func GetDisplayedSpeed(speedValue: Float, metricMultiplier: Float, imperialMultiplier: Float) -> Int32 {
  if speedValue <= 0.00 {
    return 0;
  };
  if this.m_isMetric {
    return RoundMath(speedValue * metricMultiplier);
  };
  return RoundMath(speedValue * imperialMultiplier);
}
