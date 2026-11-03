
public class PlayRadioArgs extends IScriptable {

  public let instance: GameInstance;

  public let delay: Float;

  public let entryName: CName;

  public let onlyPlayIfPlayerIsBeingChased: Bool;

  public let shouldCheckDistrictAfterDelay: Bool;

  public let handleVehicleEntranceEdgeCase: Bool;

  public let handleVehicleLostOrSpottedEdgeCase: Bool;

  public let stateUsedOnRequest: EStarState;

  public final static func CheckPlayerIsChasedAndDistrictArgs(gameInstance: GameInstance, entry: CName, timeDelay: Float) -> ref<PlayRadioArgs> {
    let args: ref<PlayRadioArgs> = PlayRadioArgs.CheckPlayerIsChasedArgs(gameInstance, entry, timeDelay);
    args.shouldCheckDistrictAfterDelay = true;
    return args;
  }

  public final static func CheckPlayerIsChasedAndVehicleEntranceArgs(gameInstance: GameInstance, entry: CName, timeDelay: Float) -> ref<PlayRadioArgs> {
    let args: ref<PlayRadioArgs> = PlayRadioArgs.CheckPlayerIsChasedArgs(gameInstance, entry, timeDelay);
    args.handleVehicleEntranceEdgeCase = true;
    return args;
  }

  public final static func CheckPlayerIsChasedAndVisibilityArgs(gameInstance: GameInstance, entry: CName, timeDelay: Float, state: EStarState) -> ref<PlayRadioArgs> {
    let args: ref<PlayRadioArgs> = PlayRadioArgs.CheckPlayerIsChasedArgs(gameInstance, entry, timeDelay);
    args.handleVehicleLostOrSpottedEdgeCase = true;
    args.stateUsedOnRequest = state;
    return args;
  }

  public final static func CheckPlayerIsChasedArgs(gameInstance: GameInstance, entry: CName, timeDelay: Float) -> ref<PlayRadioArgs> {
    let args: ref<PlayRadioArgs> = PlayRadioArgs.DefaultDelayedArgs(gameInstance, entry, timeDelay);
    args.onlyPlayIfPlayerIsBeingChased = true;
    return args;
  }

  public final static func DefaultDelayedArgs(gameInstance: GameInstance, entry: CName, timeDelay: Float) -> ref<PlayRadioArgs> {
    let args: ref<PlayRadioArgs> = PlayRadioArgs.DefaultArgs(gameInstance, entry);
    args.delay = timeDelay;
    return args;
  }

  public final static func DefaultArgs(gameInstance: GameInstance, entry: CName) -> ref<PlayRadioArgs> {
    let args: ref<PlayRadioArgs> = new PlayRadioArgs();
    args.instance = gameInstance;
    args.delay = -1.00;
    args.entryName = entry;
    args.onlyPlayIfPlayerIsBeingChased = false;
    args.shouldCheckDistrictAfterDelay = false;
    args.handleVehicleEntranceEdgeCase = false;
    args.handleVehicleLostOrSpottedEdgeCase = false;
    args.stateUsedOnRequest = EStarState.Default;
    return args;
  }
}

public class PoliceRadioScriptSystem extends ScriptableSystem {

  public final static func GetSystemName() -> CName {
    return n"PoliceRadioScriptSystem";
  }

  private final static func IsPlayerInVehicle(instance: GameInstance) -> Bool {
    return GetPlayer(instance).GetPlayerStateMachineBlackboard().GetBool(GetAllBlackboardDefs().PlayerStateMachine.MountedToVehicle);
  }

  public final static func PlayRadio(instance: GameInstance, entryName: CName) -> Void {
    let args: ref<PlayRadioArgs> = PlayRadioArgs.DefaultArgs(instance, entryName);
    PoliceRadioScriptSystem.PlayRadio(args);
  }

  public final static func PlayRadio(args: ref<PlayRadioArgs>) -> Void {
    let currentTime: Float;
    let delay: Float;
    let evt: ref<RadioDelayedRequest>;
    let heatLevel: EPreventionHeatStage;
    let preventionSystem: ref<PreventionSystem>;
    let radioSystem: ref<PoliceRadioSystem>;
    let starState: EStarState;
    if !IsNameValid(args.entryName) {
      return;
    };
    if args.delay > 0.01 {
      delay = args.delay;
      evt = new RadioDelayedRequest();
      evt.data = args;
      evt.data.delay = -1.00;
      GameInstance.GetDelaySystem(args.instance).DelayScriptableSystemRequest(n"PoliceRadioScriptSystem", evt, delay);
      return;
    };
    preventionSystem = GameInstance.GetScriptableSystemsContainer(args.instance).Get(n"PreventionSystem") as PreventionSystem;
    radioSystem = GameInstance.GetPoliceRadioSystem(args.instance);
    if PoliceRadioScriptSystem.IsHeat1Line(args.entryName, preventionSystem.GetCurrentDistrict()) {
      radioSystem.isHeat1LineRequestOngoing = false;
    } else {
      if radioSystem.isHeat1LineRequestOngoing {
        return;
      };
    };
    if !PoliceRadioScriptSystem.IsPlayerInVehicle(args.instance) {
      return;
    };
    if args.shouldCheckDistrictAfterDelay && IsNameValid(radioSystem.lastDistrictEntry) && NotEquals(args.entryName, radioSystem.lastDistrictEntry) {
      return;
    };
    if !args.onlyPlayIfPlayerIsBeingChased {
      radioSystem.PoliceRadioRequest(args.entryName);
      return;
    };
    heatLevel = preventionSystem.GetHeatStage();
    starState = preventionSystem.GetStarState();
    if Equals(heatLevel, EPreventionHeatStage.Heat_0) {
      return;
    };
    if args.handleVehicleLostOrSpottedEdgeCase {
      if Equals(args.stateUsedOnRequest, starState) {
        radioSystem.PoliceRadioRequest(args.entryName);
      };
      return;
    };
    if !args.handleVehicleEntranceEdgeCase {
      radioSystem.PoliceRadioRequest(args.entryName);
      return;
    };
    currentTime = EngineTime.ToFloat(GameInstance.GetSimTime(args.instance));
    if preventionSystem.IsPoliceUnawareOfThePlayerExactLocation() || currentTime - preventionSystem.GetFirstStarTimeStamp() < 21.00 {
      radioSystem.PoliceRadioRequest(preventionSystem.GetCurrentDistrict().GetRadioEntryName());
    } else {
      if Equals(starState, EStarState.Active) && (Equals(heatLevel, EPreventionHeatStage.Heat_3) || Equals(heatLevel, EPreventionHeatStage.Heat_4)) {
        radioSystem.PoliceRadioRequest(args.entryName);
      };
    };
  }

  private final static func GetHeatStageRadioEntryName(instance: GameInstance, heatStage: EPreventionHeatStage, currentDistrict: wref<District>) -> CName {
    let currentDistrictLine: CName;
    let i: Int32;
    let isSpam: Bool;
    let radioSystem: ref<PoliceRadioSystem> = GameInstance.GetPoliceRadioSystem(instance);
    let recentValues: [CName; 3] = radioSystem.GetRecentRequests();
    if IsDefined(currentDistrict) {
      if currentDistrict.IsDogTown() {
        switch heatStage {
          case EPreventionHeatStage.Heat_0:
            return n"dogtown_losing_player_start";
          case EPreventionHeatStage.Heat_1:
            return n"dogtown_heat_1_start";
          case EPreventionHeatStage.Heat_2:
            return n"dogtown_heat_2_start";
          case EPreventionHeatStage.Heat_3:
            return n"dogtown_heat_3_start";
          case EPreventionHeatStage.Heat_4:
            return n"dogtown_heat_4_start";
          case EPreventionHeatStage.Heat_5:
            return n"dogtown_heat_5_start";
        };
      };
    };
    currentDistrictLine = currentDistrict.GetRadioEntryName();
    i = 0;
    while i < ArraySize(recentValues) {
      if Equals(heatStage, EPreventionHeatStage.Heat_0) {
        if Equals(n"nc_heat_0_start_1", recentValues[i]) {
          return n"nc_heat_0_start_2";
        };
        if Equals(n"nc_heat_0_start_2", recentValues[i]) {
          return n"nc_heat_0_start_1";
        };
      };
      if Equals(recentValues[i], currentDistrictLine) {
        isSpam = true;
        break;
      };
      i += 1;
    };
    switch heatStage {
      case EPreventionHeatStage.Heat_0:
        i = RandRange(0, 2);
        if i == 1 {
          return n"nc_heat_0_start_1";
        };
        return n"nc_heat_0_start_2";
      case EPreventionHeatStage.Heat_1:
        if isSpam {
          return n"nc_heat_1_start";
        };
        return currentDistrictLine;
      case EPreventionHeatStage.Heat_2:
        return n"nc_heat_2_start";
      case EPreventionHeatStage.Heat_3:
        return n"nc_heat_3_start";
      case EPreventionHeatStage.Heat_4:
        return n"nc_heat_4_start";
      case EPreventionHeatStage.Heat_5:
        return n"nc_heat_5_start";
      default:
        return n"None";
    };
  }

  private final static func IsHeat1Line(line: CName, currentDistrict: wref<District>) -> Bool {
    let currentDistrictLine: CName = currentDistrict.GetRadioEntryName();
    return Equals(line, currentDistrictLine) || Equals(line, n"dogtown_heat_1_start") || Equals(line, n"nc_heat_1_start");
  }

  public final static func UpdatePoliceRadioOnHeatChange(instance: GameInstance, heatStage: EPreventionHeatStage, currentDistrict: wref<District>) -> Void {
    let args: ref<PlayRadioArgs>;
    let radioSystem: ref<PoliceRadioSystem> = GameInstance.GetPoliceRadioSystem(instance);
    if Equals(heatStage, EPreventionHeatStage.Heat_1) {
      radioSystem.isHeat1LineRequestOngoing = true;
      args = PlayRadioArgs.DefaultDelayedArgs(instance, PoliceRadioScriptSystem.GetHeatStageRadioEntryName(instance, heatStage, currentDistrict), 3.00);
    } else {
      args = PlayRadioArgs.DefaultArgs(instance, PoliceRadioScriptSystem.GetHeatStageRadioEntryName(instance, heatStage, currentDistrict));
    };
    PoliceRadioScriptSystem.PlayRadio(args);
  }

  public final static func UpdatePoliceRadioOnDistrictChange(instance: GameInstance, currentDistrict: wref<District>, heatStage: EPreventionHeatStage) -> Void {
    let rnd: Int32;
    let radioSystem: ref<PoliceRadioSystem> = GameInstance.GetPoliceRadioSystem(instance);
    let delay: Float = 5.00;
    let districtEntry: CName = currentDistrict.GetRadioEntryName();
    if Equals(districtEntry, radioSystem.lastDistrictEntry) {
      return;
    };
    if !currentDistrict.IsDogTown() {
      if NotEquals(heatStage, EPreventionHeatStage.Heat_2) {
        return;
      };
      rnd = RandRange(0, 3);
    } else {
      if Equals(heatStage, EPreventionHeatStage.Heat_4) {
        return;
      };
      if Equals(heatStage, EPreventionHeatStage.Heat_5) {
        radioSystem.lastDistrictEntry = districtEntry;
        PoliceRadioScriptSystem.PlayRadio(PlayRadioArgs.CheckPlayerIsChasedArgs(instance, n"dogtown_heat_5_start", delay));
        return;
      };
    };
    if rnd == 0 {
      PoliceRadioScriptSystem.PlayRadio(PlayRadioArgs.CheckPlayerIsChasedAndDistrictArgs(instance, districtEntry, delay));
    };
    radioSystem.lastDistrictEntry = districtEntry;
  }

  public final static func UpdatePoliceRadioOnVehicleEntrance(instance: GameInstance) -> Void {
    let args: ref<PlayRadioArgs>;
    let preventionSystem: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(instance).Get(n"PreventionSystem") as PreventionSystem;
    if preventionSystem.GetCurrentDistrict().IsDogTown() {
      args = PlayRadioArgs.CheckPlayerIsChasedAndVehicleEntranceArgs(instance, n"dogtown_on_vehicle_start", 2.00);
    } else {
      args = PlayRadioArgs.CheckPlayerIsChasedAndVehicleEntranceArgs(instance, n"nc_on_vehicle_start", 2.00);
    };
    PoliceRadioScriptSystem.PlayRadio(args);
  }

  public final static func UpdatePoliceRadioOnPlayerVisibilityChanged(instance: GameInstance, lastStarChangeStartTimeStamp: Float, currentHeatState: EPreventionHeatStage, currentVisibilityState: EStarState, futureVisibilityState: EStarState) -> Void {
    let args: ref<PlayRadioArgs>;
    let entry: CName;
    let preventionSystem: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(instance).Get(n"PreventionSystem") as PreventionSystem;
    let playerNotInVehicle: Bool = !PoliceRadioScriptSystem.IsPlayerInVehicle(instance);
    if playerNotInVehicle {
      return;
    };
    if EngineTime.ToFloat(GameInstance.GetSimTime(instance)) - lastStarChangeStartTimeStamp < 10.00 {
      return;
    };
    if !(Equals(currentHeatState, EPreventionHeatStage.Heat_1) || Equals(currentHeatState, EPreventionHeatStage.Heat_2) || Equals(currentHeatState, EPreventionHeatStage.Heat_3)) {
      return;
    };
    if preventionSystem.GetCurrentDistrict().IsDogTown() {
      if Equals(currentVisibilityState, EStarState.Active) && Equals(futureVisibilityState, EStarState.Searching) {
        entry = n"dogtown_almost_losing_player_start";
        if PoliceRadioScriptSystem.IsARecentEntry(instance, entry) {
          return;
        };
        args = PlayRadioArgs.CheckPlayerIsChasedAndVisibilityArgs(instance, entry, 3.00, futureVisibilityState);
        PoliceRadioScriptSystem.PlayRadio(args);
      };
    } else {
      if Equals(currentVisibilityState, EStarState.Active) && Equals(futureVisibilityState, EStarState.Searching) {
        entry = n"losing_player_start";
        if PoliceRadioScriptSystem.IsARecentEntry(instance, entry) {
          return;
        };
        args = PlayRadioArgs.CheckPlayerIsChasedAndVisibilityArgs(instance, entry, 3.00, futureVisibilityState);
        PoliceRadioScriptSystem.PlayRadio(args);
      } else {
        if (Equals(currentVisibilityState, EStarState.Searching) || Equals(currentVisibilityState, EStarState.Blinking)) && Equals(futureVisibilityState, EStarState.Active) {
          entry = n"nc_on_vehicle_spotted";
          if PoliceRadioScriptSystem.IsARecentEntry(instance, entry) {
            return;
          };
          args = PlayRadioArgs.CheckPlayerIsChasedAndVisibilityArgs(instance, entry, 1.00, futureVisibilityState);
          PoliceRadioScriptSystem.PlayRadio(args);
        };
      };
    };
  }

  private final static func IsARecentEntry(instance: GameInstance, entryName: CName) -> Bool {
    let radioSystem: ref<PoliceRadioSystem> = GameInstance.GetPoliceRadioSystem(instance);
    let recentRequests: [CName; 3] = radioSystem.GetRecentRequests();
    let i: Int32 = 0;
    while i < 3 {
      if Equals(recentRequests[i], entryName) {
        return true;
      };
      i += 1;
    };
    return false;
  }

  private final func OnRadioDelayedRequest(request: ref<RadioDelayedRequest>) -> Void {
    PoliceRadioScriptSystem.PlayRadio(request.data);
  }
}
