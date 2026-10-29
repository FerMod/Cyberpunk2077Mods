@addField(speedometerLogicController)
private let m_speedometerSettings: ref<UserSettings>;

@addField(vehicleInteriorUIGameController)
private let m_speedometerSettings: ref<UserSettings>;

@replaceMethod(speedometerLogicController)
public final func OnSpeedValueChanged(speed: Float) -> Void {
  let velocity: Float = AbsF(speed);
  let multiplier: Float = GameInstance.GetStatsDataSystem(this.m_vehicle.GetGame()).GetValueFromCurve(n"vehicle_ui", velocity, n"speed_to_multiplier");
  let floatspeed: Float = velocity * multiplier;
  let displayedSpeed: Int32 = RoundMath(floatspeed);
  let units: ref<ConfigVarListString>;
  if !IsDefined(this.m_speedometerSettings) {
    this.m_speedometerSettings = new UserSettings();
  };
  units = this.m_speedometerSettings.GetVar(n"/interface", n"SpeedometerUnits") as ConfigVarListString;
  if units.GetIndex() == 0 {
    displayedSpeed = RoundMath(floatspeed * 1.61);
  };
  if displayedSpeed != this.m_currentSpeed {
    inkTextRef.SetText(this.m_speedTextWidget, IntToString(displayedSpeed));
    this.m_currentSpeed = displayedSpeed;
  };
}

@replaceMethod(vehicleInteriorUIGameController)
protected cb func OnSpeedValueChanged(speedValue: Float) -> Bool {
  let units: ref<ConfigVarListString>;
  let displayedSpeed: Int32;
  if speedValue < 0.00 {
    displayedSpeed = 0;
  } else {
    if !IsDefined(this.m_speedometerSettings) {
      this.m_speedometerSettings = new UserSettings();
    };
    units = this.m_speedometerSettings.GetVar(n"/interface", n"SpeedometerUnits") as ConfigVarListString;
    if units.GetIndex() == 0 {
      displayedSpeed = RoundMath(speedValue * 3.60);
    } else {
      displayedSpeed = RoundMath(speedValue * 2.24);
    };
  };
  inkTextRef.SetText(this.m_speedTextWidget, IntToString(displayedSpeed));
}
