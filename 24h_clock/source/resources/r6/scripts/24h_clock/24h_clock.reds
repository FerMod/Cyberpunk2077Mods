
public struct Clock24hUtils {
  // Shared formatter for all HUD, menu, and vehicle clocks.
  public final static func Format(gameTime: GameTime) -> String {
    let hours: Int32 = GameTime.Hours(gameTime);
    let minutes: Int32 = GameTime.Minutes(gameTime);
    let hourText: String = StrReplace(SpaceFill(IntToString(hours), 2, ESpaceFillMode.JustifyRight), " ", "0");
    let minuteText: String = StrReplace(SpaceFill(IntToString(minutes), 2, ESpaceFillMode.JustifyRight), " ", "0");
    return hourText + ":" + minuteText;
  }

  public final static func FormatWithSeconds(gameTime: GameTime) -> String {
    let seconds: Int32 = GameTime.Seconds(gameTime);
    let secondText: String = StrReplace(SpaceFill(IntToString(seconds), 2, ESpaceFillMode.JustifyRight), " ", "0");
    return Clock24hUtils.Format(gameTime) + ":" + secondText;
  }

  public final static func SetClockText(widget: wref<inkWidget>, text: String) -> Void {
    let compoundWidget: wref<inkCompoundWidget> = widget as inkCompoundWidget;
    let textWidget: wref<inkText> = widget as inkText;
    let i: Int32 = 0;
    if IsDefined(textWidget) {
      textWidget.SetText(text);
    }
    if IsDefined(compoundWidget) {
      while i < compoundWidget.GetNumChildren() {
        Clock24hUtils.SetClockText(compoundWidget.GetWidgetByIndex(i), text);
        i += 1;
      }
    }
  }

  // Rebuild the hub clock text after the game time is updated.
  public final static func UpdateHubClock(
    player: ref<GameObject>,
    timeController: wref<gameuiTimeDisplayLogicController>,
    timeContainer: inkWidgetRef
  ) -> Void {
    let timeSystem: ref<TimeSystem> = GameInstance.GetTimeSystem(player.GetGame());
    let gameTime: GameTime;
    let isGlitchEnabled: Bool;
    if IsDefined(timeSystem) {
      isGlitchEnabled = GameTimeUtils.IsTimeDisplayGlitched(player as PlayerPuppet);
      gameTime = timeSystem.GetGameTime();
      timeController.UpdateTime(isGlitchEnabled, gameTime);
      if !isGlitchEnabled {
        Clock24hUtils
          .SetClockText(inkWidgetRef.Get(timeContainer), Clock24hUtils.Format(gameTime));
      }
    }
  }
}

@wrapMethod(hudDroneController)
protected cb func OnInitialize() -> Bool {
  let result: Bool = wrappedMethod();
  inkTextRef.SetText(this.m_Timer, Clock24hUtils.FormatWithSeconds(this.currentTime));
  return result;
}

@wrapMethod(PanzerHUDGameController)
protected cb func OnInitialize() -> Bool {
  let result: Bool = wrappedMethod();
  inkTextRef.SetText(this.m_Timer, Clock24hUtils.FormatWithSeconds(this.currentTime));
  return result;
}

@replaceMethod(MenuHubGameController)
private final func UpdateTimeDisplay() -> Void {
  Clock24hUtils
    .UpdateHubClock(
      this.GetPlayerControlledObject(),
      this.m_gameTimeController,
      this.m_gameTimeContainer
    );
}

@replaceMethod(RadialMenuHubGameController)
private final func UpdateTimeDisplay() -> Void {
  Clock24hUtils
    .UpdateHubClock(
      this.GetPlayerControlledObject(),
      this.m_gameTimeController,
      this.m_gameTimeContainer
    );
}

@replaceMethod(GameTimeUtils)
public final static func SetGameTimeText(textWidgetRef: inkTextRef, textParamsRef: ref<inkTextParams>, gameTime: GameTime) -> Void {
  // Use the 24h formatter everywhere the engine writes a game-time label.
  inkTextRef.SetText(textWidgetRef, Clock24hUtils.Format(gameTime));
}

@replaceMethod(PhoneContactItemVirtualController)
private final func SetTimeText(time: GameTime) -> Void {
  let textParams: ref<inkTextParams> = new inkTextParams();
  inkTextRef.SetText(this.m_msgCount, "{TIME,time,HH:mm}");
  textParams.AddTime("TIME", time);
  inkTextRef.SetTextParameters(this.m_msgCount, textParams);
}

@replaceMethod(VehicleComponent)
protected final func PassGameTimeToVehBB() -> Void {
  let timeSystem: ref<TimeSystem> = GameInstance.GetTimeSystem(this.GetVehicle().GetGame());
  let gameTime: GameTime = timeSystem.GetGameTime();
  this
    .m_vehicleBlackboard
    .SetString(GetAllBlackboardDefs().Vehicle.GameTime, Clock24hUtils.Format(gameTime));
}

