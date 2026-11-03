
public native class VehicleSystem extends IVehicleSystem {

  private let m_restrictionTags: [CName];

  public final native func SpawnActivePlayerVehicle(opt vehicleType: gamedataVehicleType) -> Bool;

  public final native func SpawnPlayerVehicle(opt vehicleType: gamedataVehicleType, opt vehicleID: TweakDBID, opt spawnOnlyOnValidRoad: Bool) -> Bool;

  public final native func IsActivePlayerVehicleOnCooldown(opt vehicleType: gamedataVehicleType) -> Bool;

  public final native func IsPlayerVehicleOnCooldown(opt vehicleType: gamedataVehicleType, opt vehicleID: TweakDBID) -> Bool;

  public final native func ToggleSummonMode() -> Void;

  public final native func DespawnPlayerVehicle(vehicleID: GarageVehicleID) -> Void;

  public final native func UnregisterPlayerVehicle(vehicleID: GarageVehicleID) -> Void;

  public final native func EnablePlayerVehicle(vehicle: String, enable: Bool, opt despawnIfDisabling: Bool) -> Bool;

  public final native func EnableAllPlayerVehicles() -> Void;

  public final native func SetRammingAttemptDuration(value: Float) -> Void;

  public final native func SetRammingUponCollisionDuration(value: Float) -> Void;

  public final native func SetSuicideSpeedChancePercentage(value: Float) -> Void;

  public final native func CanDriverShootInCarChase(vehicleID: EntityID) -> Bool;

  public final native func CanPassengersShootInCarChase(vehicleID: EntityID) -> Bool;

  public final native func ResetChaseManager() -> Void;

  public final native func SetChaseManagerLimit(limit: Int32) -> Void;

  public final native func GetPlayerVehicles(out vehicles: [PlayerVehicle]) -> Void;

  public final native func GetPlayerUnlockedVehicles(out unlockedVehicles: [PlayerVehicle]) -> Void;

  public final native func IsVehiclePlayerUnlocked(recordID: TweakDBID) -> Bool;

  public final native func GetActivePlayerVehicle(opt vehicleType: gamedataVehicleType) -> PlayerVehicle;

  public final native func TogglePlayerActiveVehicle(vehicleID: GarageVehicleID, vehicleType: gamedataVehicleType, enable: Bool) -> Void;

  public final native func TogglePlayerFavoriteVehicle(vehicleID: GarageVehicleID) -> Bool;

  public final native func EnablePlayerVehicleCollision() -> Void;

  public final const func GetVehicleRestrictions() -> [CName] {
    return this.m_restrictionTags;
  }

  protected final func OnVehicleSystemAttach() -> Void {
    PlayerGameplayRestrictions.AcquireHotkeyRestrictionTags(EHotkey.DPAD_RIGHT, this.m_restrictionTags);
  }

  public final static func IsPlayerInVehicle(game: GameInstance) -> Bool {
    let player: ref<PlayerPuppet> = GetPlayer(game);
    return player.GetPlayerStateMachineBlackboard().GetBool(GetAllBlackboardDefs().PlayerStateMachine.MountedToVehicle);
  }

  public final static func IsSummoningVehiclesRestricted(game: GameInstance) -> Bool {
    let blackboard: ref<IBlackboard>;
    let gameplayRestricted: Bool;
    let garageReady: Bool;
    let garageState: Uint32;
    let isPlayerInVehicle: Bool;
    let isUIRadialContextActive: Bool;
    let playerStateMachineBlackboard: ref<IBlackboard>;
    let questRestricted: Bool;
    let remoteControlVehicleID: EntityID;
    let restrictions: array<CName>;
    let uiQuickSlotsDataBB: ref<IBlackboard>;
    let unlockedVehicles: array<PlayerVehicle>;
    let player: ref<PlayerPuppet> = GetPlayer(game);
    if StatusEffectSystem.ObjectHasStatusEffectWithTag(player, n"CustomVehicleSummon") {
      return false;
    };
    questRestricted = GameInstance.GetQuestsSystem(game).GetFact(n"unlock_car_hud_dpad") == 0;
    if questRestricted {
      return true;
    };
    playerStateMachineBlackboard = GameInstance.GetBlackboardSystem(game).GetLocalInstanced(player.GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    remoteControlVehicleID = playerStateMachineBlackboard.GetEntityID(GetAllBlackboardDefs().PlayerStateMachine.EntityIDVehicleRemoteControlled);
    if EntityID.IsDefined(remoteControlVehicleID) {
      return true;
    };
    blackboard = GameInstance.GetBlackboardSystem(game).Get(GetAllBlackboardDefs().VehicleSummonData);
    garageState = blackboard.GetUint(GetAllBlackboardDefs().VehicleSummonData.GarageState);
    garageReady = Equals(IntEnum<vehicleGarageState>(garageState), vehicleGarageState.SummonAvailable);
    isPlayerInVehicle = player.GetPlayerStateMachineBlackboard().GetBool(GetAllBlackboardDefs().PlayerStateMachine.MountedToVehicle);
    uiQuickSlotsDataBB = GameInstance.GetBlackboardSystem(game).Get(GetAllBlackboardDefs().UI_QuickSlotsData);
    isUIRadialContextActive = uiQuickSlotsDataBB.GetBool(GetAllBlackboardDefs().UI_QuickSlotsData.UIRadialContextRequest);
    GameInstance.GetVehicleSystem(game).GetPlayerUnlockedVehicles(unlockedVehicles);
    if !garageReady || ArraySize(unlockedVehicles) == 0 || isPlayerInVehicle && !isUIRadialContextActive {
      return true;
    };
    restrictions = GameInstance.GetVehicleSystem(game).GetVehicleRestrictions();
    if ArraySize(restrictions) > 0 {
      gameplayRestricted = StatusEffectSystem.ObjectHasStatusEffectWithTags(player, restrictions);
    } else {
      gameplayRestricted = PlayerGameplayRestrictions.IsHotkeyRestricted(game, EHotkey.DPAD_RIGHT);
    };
    return gameplayRestricted;
  }

  protected cb func OnSummonVehicleFailed() -> Bool {
    let warningMsg: SimpleScreenMessage;
    warningMsg.isShown = true;
    warningMsg.duration = 1.50;
    warningMsg.message = GetLocalizedTextByKey(n"Gameplay-Vehicles-DelamainTaxi-CantFindDelamainTaxi");
    warningMsg.type = SimpleMessageType.DelamainTaxi;
    GameInstance.GetBlackboardSystem(GetGameInstance()).Get(GetAllBlackboardDefs().UI_Notifications).SetVariant(GetAllBlackboardDefs().UI_Notifications.WarningMessage, ToVariant(warningMsg), true);
  }
}
