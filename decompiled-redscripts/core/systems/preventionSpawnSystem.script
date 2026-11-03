
public native class PreventionSpawnSystem extends IPreventionSpawnSystem {

  public final native func CancelSpawnRequest(requestID: Uint32) -> Void;

  public final native func CancelAllSpawnRequests() -> Void;

  public final native func RequestUnitSpawn(recordID: TweakDBID, spawnTransform: WorldTransform) -> Uint32;

  public final native func RequestChaseVehicle(vehicleRecordID: TweakDBID, passengersRecordIDs: [TweakDBID], strategy: ref<BaseStrategyRequest>) -> Uint32;

  public final native func SetStrategyPreCheckRequests(preCheckRequests: [ref<BaseStrategyRequest>]) -> Void;

  public final native func ClearStrategyPreCheckRequests() -> Void;

  public final native const func IsStrategyAvailable(strategy: vehiclePoliceStrategy) -> Bool;

  public final native const func IsAnyStrategyAvailable() -> Bool;

  public final native const func GetAvailableStrategies(out strategies: [vehiclePoliceStrategy]) -> Bool;

  public final native const func GetRandomAvailableStrategyInRange(minStrat: Uint8, maxStrat: Uint8) -> vehiclePoliceStrategy;

  public final native const func GetRandomAvailableStrategy(wantedStrategies: [vehiclePoliceStrategy]) -> vehiclePoliceStrategy;

  public final native const func DebugTryOverrideWithForcedStrategy(out strategy: vehiclePoliceStrategy) -> Void;

  public final native const func GetIntersectionInFrontOfPlayerPos() -> Vector4;

  public final native const func IsPlayerOnHighway() -> Bool;

  public final native const func IsPlayerInDogTown() -> Bool;

  public final native const func GetNearestRoadFromPlayerInfo(out info: NearestRoadFromPlayerInfo) -> Void;

  public final native func RequestRoadBlockadeSpawn(vehiclessRecordIDs: [TweakDBID], spawnDistanceRange: Vector2, numberNPCsPerCar: Uint32) -> Uint32;

  public final native func NotifyPlayerMounted(isPlayerMounted: Bool) -> Void;

  public final native func IsPlayerInSoftDeescalationTrigger() -> Bool;

  public final native func IsInUnmountingRange(position: Vector3) -> Bool;

  public final native func RequestAVSpawnPoints(scriptable: wref<IScriptable>, functionName: String, spawnDistanceRange: Vector2, maxSpawnPoints: Uint32, useOffTrafficPoints: Bool) -> Uint32;

  public final native func RequestAVSpawnAtLocation(recordID: TweakDBID, location: Vector3) -> Uint32;

  public final native func RequestAVSpawn(recordID: TweakDBID, spawnDistanceRange: Vector2, useOffTrafficPoints: Bool) -> Uint32;

  public final native func ReinitAll() -> Void;

  public final native func RequestDespawn(entityID: EntityID) -> Void;

  public final native func RequestDespawnVehicleAndPassengers(vehicle: wref<VehicleObject>) -> Void;

  public final native func RequestDespawnAll(shouldUseAggressiveDespawn: Bool) -> Void;

  public final native func GetNumberOfSpawnedPreventionUnits() -> Int32;

  public final native func IsPreventionVehicleEnabled() -> Bool;

  public final native const func FindPursuitPointsRangeAsync(spawnOriginPositions: [Vector4], radiusMin: Float, radiusMax: Float, unitCount: Uint32, characterRecords: [TweakDBID], navVisCheck: Bool, agentSize: NavGenAgentSize, scriptable: wref<IScriptable>, functionName: String) -> Void;

  public final native func ToggleFreeArea(areaReference: NodeRef, enable: Bool) -> Void;

  public final native func TogglePreventionQuestTrigger(areaReference: NodeRef, enable: Bool) -> Void;

  public final native func GetPreventionSystemCanSpawnInCrowd() -> Bool;

  public final native func RegisterEntityDeathCallback(scriptable: wref<IScriptable>, functionName: String, entityID: EntityID) -> Void;

  public final native func UnregisterEntityDeathCallback(scriptable: wref<IScriptable>, functionName: String, entityID: EntityID) -> Void;

  public final native func TogglePreventionCrowdSpawns(toggle: Bool) -> Void;

  public final native func TogglePreventionActive(isActive: Bool) -> Void;

  public final native func InterruptAllActionAndCommands(veh: wref<VehicleObject>) -> Void;

  public final native func IsEntityRegistered(id: EntityID) -> Bool;

  public final native func TryGetVehicleType(id: EntityID, out vehicleType: DynamicVehicleType) -> Bool;

  public final native func IsPointInPreventionFreeArea(point: Vector4) -> Bool;

  public final native func MarkAsDead(entityID: EntityID) -> Void;

  protected final func SpawnRequestFinished(requestResult: SpawnRequestResult) -> Void {
    let request: ref<PreventionUnitSpawnedRequest>;
    let system: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(GetGameInstance()).Get(n"PreventionSystem") as PreventionSystem;
    if IsDefined(system) {
      request = new PreventionUnitSpawnedRequest();
      request.requestResult = requestResult;
      system.QueueRequest(request);
    };
  }

  protected final func DespawnCallback(entityID: EntityID) -> Void {
    let request: ref<PreventionUnitDespawnedRequest>;
    let system: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(GetGameInstance()).Get(n"PreventionSystem") as PreventionSystem;
    if IsDefined(system) {
      request = new PreventionUnitDespawnedRequest();
      request.entityID = entityID;
      system.QueueRequest(request);
    };
  }

  public final const func TryFillPreventionSystemDebugData(out dataToFill: PreventionSystemDebugData) -> Bool {
    let preventionSystem: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(GetGameInstance()).Get(n"PreventionSystem") as PreventionSystem;
    if IsDefined(preventionSystem) {
      preventionSystem.FillPreventionSystemDebugData(dataToFill);
      return true;
    };
    return false;
  }

  protected final func Debug_EmulateDamageDealt(damageAmount: Float) -> Void {
    let playerPos: Vector4;
    let preventionSystemRequest: ref<PreventionDamageRequest>;
    let crimeScorePercent: Float = 25.00;
    let preventionSystem: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(GetGameInstance()).Get(n"PreventionSystem") as PreventionSystem;
    if IsDefined(preventionSystem) {
      playerPos = GetPlayer(GetGameInstance()).GetWorldPosition();
      preventionSystemRequest = new PreventionDamageRequest();
      preventionSystemRequest.damageDealtPercentValue = crimeScorePercent * damageAmount;
      preventionSystemRequest.isInternal = false;
      preventionSystemRequest.targetPosition = playerPos;
      preventionSystemRequest.requestedHeat = EPreventionHeatStage.Heat_1;
      preventionSystemRequest.attackType = gamedataAttackType.Direct;
      preventionSystemRequest.telemetryInfo = "DEBUG";
      preventionSystem.QueueRequest(preventionSystemRequest);
    };
  }

  protected final func VehicleEarlyInit(vehicleObject: ref<WheeledObject>) -> Void {
    PreventionSystem.StartActiveVehicleBehaviour(vehicleObject.GetGame(), vehicleObject);
  }

  protected final func RoadblockadeNPCEarlyInit(puppet: ref<gamePuppet>) -> Void {
    PreventionSystem.StartRoadblockNPCAgentBehaviour(puppet as ScriptedPuppet);
  }

  protected final func OnEnterPreventionQuestTrigger(disablePreventionSystem: Bool) -> Void {
    let preventionForceDeescalateRequest: ref<PreventionForceDeescalateRequest>;
    let refreshDeescalationTimersRequest: ref<RefreshDeescalationTimers>;
    let preventionSystem: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(GetGameInstance()).Get(n"PreventionSystem") as PreventionSystem;
    if !IsDefined(preventionSystem) || !preventionSystem.IsChasingPlayer() {
      return;
    };
    if disablePreventionSystem {
      preventionForceDeescalateRequest = new PreventionForceDeescalateRequest();
      preventionForceDeescalateRequest.fakeBlinkingDuration = TweakDBInterface.GetFloat(t"PreventionSystem.setup.forcedDeescalationUIStarsBlinkingDurationSeconds", 4.00);
      preventionForceDeescalateRequest.telemetryInfo = "QuestPreventionTriggerForceDeescalation";
      preventionSystem.QueueRequest(preventionForceDeescalateRequest);
    } else {
      refreshDeescalationTimersRequest = new RefreshDeescalationTimers();
      preventionSystem.QueueRequest(refreshDeescalationTimersRequest);
    };
  }

  public final func SetIfAvailable(value: vehiclePoliceStrategy) -> vehiclePoliceStrategy {
    return this.IsStrategyAvailable(value) ? value : vehiclePoliceStrategy.None;
  }
}
