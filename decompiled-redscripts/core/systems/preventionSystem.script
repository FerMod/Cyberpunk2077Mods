
public class PreventionSystem extends ScriptableSystem {

  private persistent let m_districtManager: ref<DistrictManager>;

  @runtimeProperty("unsavable", "true")
  private persistent let m_agentRegistry: ref<PoliceAgentRegistry>;

  @default(PreventionSystem, false)
  private persistent let m_ignoreSecurityAreasByQuest: Bool;

  @default(PreventionSystem, false)
  private persistent let m_forceEternalGreyStars: Bool;

  @default(PreventionSystem, false)
  private persistent let m_blockOnFootSpawnByQuest: Bool;

  @default(PreventionSystem, false)
  private persistent let m_blockVehicleSpawnByQuest: Bool;

  @default(PreventionSystem, false)
  private persistent let m_blockReconDroneSpawnByQuest: Bool;

  @default(PreventionSystem, 1.f)
  private persistent let m_crimeScoreMultiplierByQuest: Float;

  private persistent let m_preventionQuestEventSources: [CName];

  private persistent let m_systemLockSources: [CName];

  private persistent let m_systemEnabled: Bool;

  private let m_player: wref<PlayerPuppet>;

  private let m_preventionPreset: wref<DistrictPreventionData_Record>;

  private let m_preventionDataMatrix: wref<PreventionHeatDataMatrix_Record>;

  private let m_preventionDataTable: wref<PreventionHeatTable_Record>;

  private let m_systemLocked: Bool;

  private let m_nodeEventSources: [CName];

  private let m_heatStage: EPreventionHeatStage;

  private let m_heatChangeReason: String;

  @default(PreventionSystem, true)
  private let m_ignoreSecurityAreas: Bool;

  private let m_playerIsInSecurityArea: [PersistentID];

  private let m_playerIsInPreventionFreeArea: Bool;

  private let m_policeSecuritySystems: [PersistentID];

  private let m_agentGroupsList: [ref<PreventionAgents>];

  private let m_lastKnownPosition: Vector4;

  private let m_lastKnownVehicle: wref<VehicleObject>;

  @default(PreventionSystem, 1.f)
  private let m_districtMultiplier: Float;

  private let m_shouldForceStarStateUIToActive: Bool;

  private let m_lastAttackTime: Float;

  private let m_lastAttackTargetIDs: [EntityID];

  private let m_viewers: [wref<GameObject>];

  private let m_hasViewers: Bool;

  private let m_starState: EStarState;

  private let m_starStateUIChanged: Bool;

  private let m_isPlayerMounted: Bool;

  private let m_policeKnowsPlayerLocation: Bool;

  private let m_isInitialSearchState: Bool;

  private let m_heatLevelChanged: Bool;

  private let m_playerCrossedBufferDistance: Bool;

  private let m_crimescoreTimerDelayID: DelayID;

  private let m_starStateBufferTimerDelayID: DelayID;

  private let m_beliefAccuracyTimerDelayID: DelayID;

  private let m_blinkingStatusDelayID: DelayID;

  private let m_searchingStatusDelayID: DelayID;

  private let m_transitionToGreyStateDelayID: DelayID;

  private let m_policemenSpawnDelayID: DelayID;

  private let m_securityAreaResetDelayID: DelayID;

  private let m_inputlockDelayID: DelayID;

  private let m_freeAreaResetDelayID: DelayID;

  private let m_securityAreaResetCheck: Bool;

  private let m_hadOngoingSpawnRequest: Bool;

  private let m_totalCrimeScore: Float;

  private let m_canSpawnFallbackEarly: Bool;

  private let m_failsafePoliceRecordT1: TweakDBID;

  private let m_failsafePoliceRecordT2: TweakDBID;

  private let m_failsafePoliceRecordT3: TweakDBID;

  private let m_blinkReasonsStack: [CName];

  private let m_wantedBarBlackboard: wref<IBlackboard>;

  private let m_onPlayerChoiceCallID: ref<CallbackHandle>;

  private let m_playerAttachedCallbackID: Uint32;

  private let m_playerDetachedCallbackID: Uint32;

  private let m_playerHLSID: ref<CallbackHandle>;

  private let m_playerVehicleStateID: ref<CallbackHandle>;

  private let m_playerHLS: gamePSMHighLevel;

  private let m_playerVehicleState: gamePSMVehicle;

  private let m_unhandledInputsReceived: Int32;

  private let m_preventionUnitKilledDuringLock: Bool;

  private let m_previousHitTargetID: EntityID;

  private let m_previousHitAttackTime: Float;

  @default(PreventionSystem, false)
  private let m_reconPhaseEnabled: Bool;

  private let m_reconDeployed: Bool;

  private let m_reconDestroyed: Bool;

  @default(PreventionSystem, EPreventionHeatStage.Heat_0)
  private let m_minHeatLevel: EPreventionHeatStage;

  @default(PreventionSystem, EPreventionHeatStage.Heat_5)
  private let m_maxHeatLevel: EPreventionHeatStage;

  @default(PreventionSystem, true)
  private let m_defaultHeatLevels: Bool;

  @default(PreventionSystem, EVehicleSpawnBlockSide.Default)
  private let m_vehicleSpawnBlockSide: EVehicleSpawnBlockSide;

  @default(PreventionSystem, 1.f)
  private let m_damageToPlayerMultiplier: Float;

  @default(PreventionSystem, 1.f)
  private let m_chaseMultiplier: Float;

  private let m_policeChaseBlackboard: wref<IBlackboard>;

  @default(PreventionSystem, false)
  private let m_blockShootingFromVehicle: Bool;

  private let Debug_ProcessReason: EPreventionDebugProcessReason;

  private let Debug_LastAttackType: gamedataAttackType;

  private let Debug_LastDamageDealt: Float;

  private let Debug_LastCrimeDistance: Float;

  private let Debug_lastAVRequestedSpawnPosition: Vector3;

  @default(PreventionSystem, false)
  private let m_temp_const_false: Bool;

  private let m_preventionTickCaller: ref<IntervalCaller>;

  private let m_roadblockadeRespawnTickCaller: ref<IntervalCaller>;

  private let m_maxtacTicketID: Uint32;

  private let m_avSpawnPointList: [Vector3];

  @default(PreventionSystem, 20.f)
  private let m_maxAllowedDistanceToPlayer: Float;

  private let m_lastAVRequestedSpawnPositionsArray: [Vector4];

  private let m_shouldPreventionUnitsStartRetreating: Bool;

  private let m_numberOfMaxtacSquadsSpawned: Int32;

  private let m_maxtacTroopBeingAliveTimeStamp: Float;

  private let m_civilianVehicleDestructionCount: Int32;

  @default(PreventionSystem, -1.f)
  private let m_lastCivilianVehicleDestructionTimeStamp: Float;

  @default(PreventionSystem, 3)
  private let m_civilianVehicleDestructionThreshold: Int32;

  @default(PreventionSystem, 60.f)
  private let m_civilianVehicleDestructionTimeout: Float;

  private let m_vehicleSpawnTickCaller: ref<IntervalCaller>;

  private let m_ressuplyVehicleTicketCaller: ref<IntervalCaller>;

  private let m_isVehicleDelayOver: Bool;

  private let m_currentVehicleTicketCount: Int32;

  private let m_failedVehicleSpawnAttempts: Int32;

  private let m_codeRedReinforcement: Bool;

  private let m_lastStarChangeTimeStamp: Float;

  private let m_firstStarTimeStamp: Float;

  private persistent let m_setCallRejectionIncrement: Bool;

  public final static func GetSystemName() -> CName {
    return n"PreventionSystem";
  }

  public final static func GetPreventionQuestDisabledFactName() -> CName {
    return n"prevention_quest_disabled";
  }

  public final static func GetPreventionQuestDisabledTweakContentTag() -> CName {
    return n"PreventionGlobalQuest";
  }

  public final static func GetPreventionQuestDisabledGenericQuestReason() -> CName {
    return n"prevention_state_managed_by_quest_generic";
  }

  public final static func GetPreventionHeatTableRecord(game: GameInstance) -> wref<PreventionHeatTable_Record> {
    let instance: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(game).Get(n"PreventionSystem") as PreventionSystem;
    return instance.m_preventionDataTable;
  }

  public final static func UseCWMask(game: GameInstance) -> Void {
    let preventionForceDeescalateRequest: ref<PreventionForceDeescalateRequest>;
    let ps: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(game).Get(n"PreventionSystem") as PreventionSystem;
    if !ps.IsChasingPlayer() || Equals(ps.GetHeatStage(), EPreventionHeatStage.Heat_5) || Equals(ps.GetStarState(), EStarState.Active) {
      return;
    };
    preventionForceDeescalateRequest = new PreventionForceDeescalateRequest();
    preventionForceDeescalateRequest.fakeBlinkingDuration = TweakDBInterface.GetFloat(t"PreventionSystem.setup.forcedDeescalationUIStarsBlinkingDurationSeconds", 4.00);
    preventionForceDeescalateRequest.telemetryInfo = "MaskCyberware";
    ps.QueueRequest(preventionForceDeescalateRequest);
  }

  public final static func NotifyPolice(owner: ref<GameObject>) -> Void {
    let ps: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(owner.GetGame()).Get(n"PreventionSystem") as PreventionSystem;
    let puppetTarget: ref<ScriptedPuppet> = owner as ScriptedPuppet;
    if ps.IsChasingPlayer() && (puppetTarget.IsCrowd() || puppetTarget.IsVendor() || puppetTarget.IsCharacterCivilian() || puppetTarget.IsPrevention() || NPCManager.HasTag(puppetTarget.GetRecordID(), n"TriggerPrevention")) {
      ps.UpdateStarState();
    };
  }

  private func OnAttach() -> Void {
    this.m_districtManager = new DistrictManager();
    this.m_districtManager.Initialize(this);
    this.m_agentRegistry = PoliceAgentRegistry.Construct(this.GetGame());
    this.SetIsPlayerMounted(VehicleComponent.IsMountedToVehicle(this.GetGame(), GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerControlledGameObject()));
    this.m_failsafePoliceRecordT1 = t"Character.prevention_unit_tier1";
    this.m_failsafePoliceRecordT2 = t"Character.prevention_unit_tier2";
    this.m_failsafePoliceRecordT3 = t"Character.prevention_unit_tier3";
    this.SyncTweakDistrictData();
    this.GetDataTableForCurrentHeat();
    this.m_wantedBarBlackboard = GameInstance.GetBlackboardSystem(this.GetGame()).Get(GetAllBlackboardDefs().UI_WantedBar);
    this.RegisterToBBCalls();
    this.ChangeAgentsAttitude(EAIAttitude.AIA_Neutral);
    this.m_roadblockadeRespawnTickCaller = IntervalCaller.Create(this);
    this.m_preventionTickCaller = IntervalCaller.Create(this);
    this.m_vehicleSpawnTickCaller = IntervalCaller.Create(this);
    this.m_ressuplyVehicleTicketCaller = IntervalCaller.Create(this);
    this.ReevaluttatePreventionLockSources();
    GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).TogglePreventionActive(false);
    this.SetWantedLevelFact(0);
    if !IsFinal() {
      this.RefreshDebug();
    };
  }

  private func OnDetach() -> Void {
    if this.IsChasingPlayer() {
      GameInstance.GetTelemetrySystem(this.GetGameInstance()).LogHeatLevelChanged(0u, "OnGameExit", this.ComputeTotalCrimeScoreForTelemetry(this.m_heatStage));
    };
    this.m_civilianVehicleDestructionCount = 0;
    this.m_lastCivilianVehicleDestructionTimeStamp = -1.00;
    this.UnregisterBBCalls();
  }

  private func OnRestored(saveVersion: Int32, gameVersion: Int32) -> Void {
    this.m_districtManager.Initialize(this);
    this.SyncTweakDistrictData();
    this.GetDataTableForCurrentHeat();
    this.ReevaluttatePreventionLockSources();
    if !this.IsChasingPlayer() {
      FastTravelSystem.RemoveFastTravelLock(n"PreventionSystem", this.GetGameInstance());
      this.ChangeAgentsAttitude(EAIAttitude.AIA_Neutral);
      this.SendDropPointLockRequest(true);
    };
    this.UpdateStrategyPreCheckRequests();
    this.SetWantedLevelFact(0);
  }

  public final const func IsSystemEnabled() -> Bool {
    return this.m_systemEnabled;
  }

  public final const func IsSystemLocked() -> Bool {
    return this.m_systemLocked;
  }

  public final const func IsChasingPlayer() -> Bool {
    return NotEquals(this.m_heatStage, EPreventionHeatStage.Heat_0);
  }

  public final const func IsMaxTacDefeated() -> Bool {
    return this.m_agentRegistry.GetMaxTacNPCCount() < 1;
  }

  private final func IsPreventionInputLocked() -> Bool {
    return this.m_inputlockDelayID != GetInvalidDelayID();
  }

  private func IsSavingLocked() -> Bool {
    return this.IsChasingPlayer();
  }

  public final const func GetLastAttackTime() -> Float {
    return this.m_lastAttackTime;
  }

  public final const func GetLastAttackTargetIDs() -> [EntityID] {
    return this.m_lastAttackTargetIDs;
  }

  public final const func GetLastKnownPlayerPosition() -> Vector4 {
    return this.m_lastKnownPosition;
  }

  public final const func GetLastKnownPlayerVehicle() -> wref<VehicleObject> {
    return this.m_lastKnownVehicle;
  }

  public final const func GetPlayer() -> wref<PlayerPuppet> {
    return this.m_player;
  }

  public final const func GetHeatStage() -> EPreventionHeatStage {
    return this.m_heatStage;
  }

  public final const func GetStarState() -> EStarState {
    return this.m_starState;
  }

  public final const func GetHeatStageAsInt() -> Uint32 {
    return EnumInt(this.m_heatStage);
  }

  public final const func IsShootingFromVehicleBlocked() -> Bool {
    return this.m_blockShootingFromVehicle;
  }

  public final const func GetGame() -> GameInstance {
    return this.GetGameInstance();
  }

  public final const func GetDamageToPlayerMultiplier() -> Float {
    return this.m_damageToPlayerMultiplier;
  }

  public final const func AreTurretsActive() -> Bool {
    return this.m_temp_const_false;
  }

  public final const func GetCurrentDistrict() -> wref<District> {
    return this.m_districtManager.GetCurrentDistrict();
  }

  public final const func GetLastStarChangeStartTimeStamp() -> Float {
    return this.m_lastStarChangeTimeStamp;
  }

  public final const func GetFirstStarTimeStamp() -> Float {
    return this.m_firstStarTimeStamp;
  }

  public final const func IsPlayerMounted() -> Bool {
    return this.m_isPlayerMounted;
  }

  private final func IsPlayerInQuestArea() -> Bool {
    return EnumInt(this.m_playerHLS) > 1 && EnumInt(this.m_playerHLS) <= 5;
  }

  private final func SetIsPlayerMounted(isPlayerMounted: Bool) -> Void {
    this.m_isPlayerMounted = isPlayerMounted;
    GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).NotifyPlayerMounted(isPlayerMounted);
  }

  private final func GetSoftDeescalationBlinkingStarsDuration() -> Float {
    let duration: Float = TweakDBInterface.GetFloat(t"PreventionSystem.setup.softDeescalationUIStarsBlinkingDurationSeconds", 4.00);
    return duration;
  }

  private final func GetSoftDeescalationGreyStarsDuration() -> Float {
    let duration: Float = TweakDBInterface.GetFloat(t"PreventionSystem.setup.softDeescalationUIStarsGreyDurationSeconds", 5.00);
    return duration;
  }

  public final const func IsPoliceUnawareOfThePlayerExactLocation() -> Bool {
    if this.m_beliefAccuracyTimerDelayID != GetInvalidDelayID() {
      return true;
    };
    return NotEquals(this.GetStarState(), EStarState.Active);
  }

  private final const func GetAgentRegistry() -> ref<PoliceAgentRegistry> {
    if IsDefined(this.m_agentRegistry) {
      return this.m_agentRegistry;
    };
    return PoliceAgentRegistry.Construct(this.GetGame());
  }

  public final static func CheckNPCSpawnedType(game: GameInstance, entityID: EntityID, spawnedTypeToCheck: DynamicVehicleType) -> Bool {
    let preventionSystem: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(game).Get(n"PreventionSystem") as PreventionSystem;
    return Equals(preventionSystem.m_agentRegistry.GetNPCSpawnedType(entityID), spawnedTypeToCheck);
  }

  public final const func ShouldWorkSpotPoliceJoinChase(puppet: ref<ScriptedPuppet>) -> Bool {
    if NPCManager.HasVisualTag(puppet, n"Inspector") || NPCManager.HasVisualTag(puppet, n"Investigator") || NPCManager.HasVisualTag(puppet, n"Agent") || NPCManager.HasVisualTag(puppet, n"Constable") || NPCManager.HasTag(puppet.GetRecordID(), n"AndroidNCPD_NotPrevention") || NPCManager.HasTag(puppet.GetRecordID(), n"HazmatNCPD_NotPrevention") {
      return false;
    };
    if NPCManager.HasTag(puppet.GetRecordID(), n"MaxTac_NotPrevention") {
      return Equals(this.GetHeatStage(), EPreventionHeatStage.Heat_5);
    };
    return this.GetHeatStageAsInt() > 2u && !this.m_isPlayerMounted;
  }

  private final const func ShouldSpawnPatrolVehicleWhenInSearch() -> Bool {
    return !(this.GetAgentRegistry().GetSupportVehiclesWithStrategyCount(vehiclePoliceStrategy.InitialSearch) < this.m_preventionDataTable.SpawnedEngagedCars());
  }

  private final func UpdateDataMatrixOnDistrictChange(district: wref<District>) -> Void {
    this.GetPreventionMatrixPresetForCurrentDistrict(district);
    this.GetDataTableForCurrentHeat();
  }

  private final func GetDataTableForCurrentHeat() -> Void {
    let heatDataRecord: ref<PreventionHeatTable_Record>;
    if !IsDefined(this.m_preventionDataMatrix) {
      return;
    };
    heatDataRecord = this.GetDataTableForHeat(this.m_heatStage);
    if IsDefined(heatDataRecord) {
      this.m_preventionDataTable = heatDataRecord;
    };
  }

  private final const func GetDataTableForHeat(heatStage: EPreventionHeatStage) -> ref<PreventionHeatTable_Record> {
    switch heatStage {
      case EPreventionHeatStage.Heat_0:
        return this.m_preventionDataMatrix.Heat0();
      case EPreventionHeatStage.Heat_1:
        return this.m_preventionDataMatrix.Heat1();
      case EPreventionHeatStage.Heat_2:
        return this.m_preventionDataMatrix.Heat2();
      case EPreventionHeatStage.Heat_3:
        return this.m_preventionDataMatrix.Heat3();
      case EPreventionHeatStage.Heat_4:
        return this.m_preventionDataMatrix.Heat4();
      case EPreventionHeatStage.Heat_5:
        return this.m_preventionDataMatrix.Heat5();
      default:
        return null;
    };
  }

  public final const func GetPreventionInputLockTime() -> Float {
    if IsDefined(this.m_preventionPreset) {
      return this.m_preventionPreset.InputLockTime();
    };
    return 3.00;
  }

  public final const func GetInputLockOverrideThreshold() -> Int32 {
    if IsDefined(this.m_preventionPreset) {
      return this.m_preventionPreset.InputLockOverrideThreshold();
    };
    return 4;
  }

  public final const func GetSpawnOriginMaxDistance() -> Float {
    if IsDefined(this.m_preventionPreset) {
      return this.m_preventionPreset.SpawnOriginMaxDistance();
    };
    return 30.00;
  }

  private final func GetDataTableForCurrentHeat(heatStage: EPreventionHeatStage, characterRecords: script_ref<[TweakDBID]>, out spawnRange: Vector2, out unitsCount: Uint32, out spawnInterval: Float, out hasRecon: Bool) -> Bool {
    let characterRecord: TweakDBID;
    let characterRecordPool: array<wref<PreventionUnitPoolData_Record>>;
    let heatData: wref<PreventionHeatData_Record>;
    let i: Int32;
    ArrayClear(Deref(characterRecords));
    if IsDefined(this.m_preventionPreset) {
      if this.m_reconPhaseEnabled && !this.m_reconDeployed && Equals(heatStage, EPreventionHeatStage.Heat_1) {
        heatData = this.m_preventionPreset.Recon();
      };
      if !IsDefined(heatData) {
        switch heatStage {
          case EPreventionHeatStage.Heat_0:
            return false;
          case EPreventionHeatStage.Heat_1:
            heatData = this.m_preventionPreset.Heat1();
            break;
          case EPreventionHeatStage.Heat_2:
            heatData = this.m_preventionPreset.Heat2();
            break;
          case EPreventionHeatStage.Heat_3:
            heatData = this.m_preventionPreset.Heat3();
            break;
          case EPreventionHeatStage.Heat_4:
            heatData = this.m_preventionPreset.Heat4();
            break;
          case EPreventionHeatStage.Heat_5:
            heatData = this.m_preventionPreset.Heat5();
            break;
          default:
            return false;
        };
      } else {
        hasRecon = true;
      };
      if IsDefined(heatData) && heatData.GetUnitRecordsPoolCount() > 0 {
        heatData.UnitRecordsPool(characterRecordPool);
        unitsCount = Cast<Uint32>(heatData.UnitsCount());
        spawnRange = heatData.SpawnRange();
        spawnInterval = MaxF(heatData.SpawnInterval(), 0.00);
        i = 0;
        while i < Cast<Int32>(unitsCount) {
          if this.GetCharacterRecordFromPool(characterRecordPool, characterRecord) {
            ArrayPush(Deref(characterRecords), characterRecord);
          } else {
            break;
          };
          i += 1;
        };
        if ArraySize(Deref(characterRecords)) > 0 {
          return true;
        };
      };
    };
    switch heatStage {
      case EPreventionHeatStage.Heat_0:
        return false;
      case EPreventionHeatStage.Heat_1:
        ArrayPush(Deref(characterRecords), this.m_failsafePoliceRecordT1);
        unitsCount = 2u;
        spawnRange.X = 45.00;
        spawnRange.Y = 65.00;
        break;
      case EPreventionHeatStage.Heat_2:
        ArrayPush(Deref(characterRecords), this.m_failsafePoliceRecordT2);
        unitsCount = 2u;
        spawnRange.X = 45.00;
        spawnRange.Y = 65.00;
        break;
      case EPreventionHeatStage.Heat_5:
      case EPreventionHeatStage.Heat_4:
      case EPreventionHeatStage.Heat_3:
        ArrayPush(Deref(characterRecords), this.m_failsafePoliceRecordT3);
        unitsCount = 2u;
        spawnRange.X = 45.00;
        spawnRange.Y = 65.00;
        break;
      default:
    };
    if ArraySize(Deref(characterRecords)) > 0 {
      return true;
    };
    return false;
  }

  private final func GetVehicleRecordFromPool(const pool: script_ref<[wref<PreventionVehiclePoolData_Record>]>, out outVehicleRecord: wref<Vehicle_Record>) -> Bool {
    let accumulator: Float;
    let vehicleRecord: wref<Vehicle_Record>;
    let weightSum: Float;
    let randomVal: Float = 0.00;
    let i: Int32 = 0;
    while i < ArraySize(Deref(pool)) {
      weightSum += Deref(pool)[i].Weight();
      i += 1;
    };
    randomVal = RandRangeF(0.00, weightSum);
    i = 0;
    while i < ArraySize(Deref(pool)) {
      accumulator += Deref(pool)[i].Weight();
      if randomVal <= accumulator {
        vehicleRecord = Deref(pool)[i].VehicleRecord();
        if IsDefined(vehicleRecord) {
          outVehicleRecord = vehicleRecord;
          return true;
        };
      };
      i += 1;
    };
    return false;
  }

  private final func GetCharacterRecordsFromPool(const recordsCount: Int32, const pool: script_ref<[wref<PreventionUnitPoolData_Record>]>, recordIDs: script_ref<[TweakDBID]>) -> Bool {
    let recordID: TweakDBID;
    let count: Int32 = 0;
    if ArraySize(Deref(pool)) <= 0 {
      return false;
    };
    while count < recordsCount {
      if this.GetCharacterRecordFromPool(pool, recordID) {
        ArrayPush(Deref(recordIDs), recordID);
        count += 1;
      };
    };
    return true;
  }

  private final func GetCharacterRecordFromPool(const pool: script_ref<[wref<PreventionUnitPoolData_Record>]>, out recordID: TweakDBID) -> Bool {
    let accumulator: Float;
    let characterRecord: wref<Character_Record>;
    let weightSum: Float;
    let randomVal: Float = 0.00;
    let i: Int32 = 0;
    while i < ArraySize(Deref(pool)) {
      weightSum += Deref(pool)[i].Weight();
      i += 1;
    };
    randomVal = RandRangeF(0.00, weightSum);
    i = 0;
    while i < ArraySize(Deref(pool)) {
      accumulator += Deref(pool)[i].Weight();
      if randomVal < accumulator {
        characterRecord = Deref(pool)[i].CharacterRecord();
        if IsDefined(characterRecord) {
          recordID = characterRecord.GetID();
          return true;
        };
      };
      i += 1;
    };
    return false;
  }

  private final func TryGetRoadblockDataFromHeatStage(heatStage: EPreventionHeatStage, out outVehicleRecord: wref<Vehicle_Record>, out spawnDistanceRange: Vector2) -> Bool {
    let heatData: wref<PreventionHeatData_Record>;
    let vehicleRecordPool: array<wref<PreventionVehiclePoolData_Record>>;
    if IsDefined(this.m_preventionPreset) {
      switch heatStage {
        case EPreventionHeatStage.Heat_3:
          heatData = this.m_preventionPreset.Heat3();
          break;
        case EPreventionHeatStage.Heat_4:
          heatData = this.m_preventionPreset.Heat4();
          break;
        case EPreventionHeatStage.Heat_5:
          heatData = this.m_preventionPreset.Heat5();
          break;
        default:
          return false;
      };
    };
    if IsDefined(heatData) && heatData.GetVehicleRecordPoolCount() > 0 {
      heatData.VehicleRecordPool(vehicleRecordPool);
      this.GetVehicleRecordFromPool(vehicleRecordPool, outVehicleRecord);
      spawnDistanceRange = heatData.RoadblockadeSpawnRange();
    };
    return TDBID.IsValid(outVehicleRecord.GetID());
  }

  private final func TryGetVehicleDataFromHeatStage(heatStage: EPreventionHeatStage, out outVehicleRecord: wref<Vehicle_Record>) -> Bool {
    let heatData: wref<PreventionHeatData_Record>;
    let vehicleRecordPool: array<wref<PreventionVehiclePoolData_Record>>;
    let questSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.GetGameInstance());
    if IsDefined(this.m_preventionPreset) {
      switch heatStage {
        case EPreventionHeatStage.Heat_0:
          return false;
        case EPreventionHeatStage.Heat_1:
          heatData = this.m_preventionPreset.Heat1();
          break;
        case EPreventionHeatStage.Heat_2:
          heatData = this.m_preventionPreset.Heat2();
          break;
        case EPreventionHeatStage.Heat_3:
          heatData = this.m_preventionPreset.Heat3();
          break;
        case EPreventionHeatStage.Heat_4:
          heatData = this.m_preventionPreset.Heat4();
          break;
        case EPreventionHeatStage.Heat_5:
          heatData = this.m_preventionPreset.Heat5();
          break;
        default:
          return false;
      };
      if IsDefined(heatData) && heatData.GetVehicleRecordPoolCount() > 0 {
        if IsDefined(questSystem) && questSystem.GetFact(n"q302_ps_motorbikes_disabled") == 1 {
          heatData.QuestVehicleRecordPool(vehicleRecordPool);
        } else {
          heatData.VehicleRecordPool(vehicleRecordPool);
        };
        this.GetVehicleRecordFromPool(vehicleRecordPool, outVehicleRecord);
      };
    };
    return TDBID.IsValid(outVehicleRecord.GetID());
  }

  private final func GetHeatData() -> wref<PreventionHeatData_Record> {
    let heatData: wref<PreventionHeatData_Record>;
    if IsDefined(this.m_preventionPreset) {
      switch this.GetHeatStage() {
        case EPreventionHeatStage.Heat_1:
          heatData = this.m_preventionPreset.Heat1();
          break;
        case EPreventionHeatStage.Heat_2:
          heatData = this.m_preventionPreset.Heat2();
          break;
        case EPreventionHeatStage.Heat_3:
          heatData = this.m_preventionPreset.Heat3();
          break;
        case EPreventionHeatStage.Heat_4:
          heatData = this.m_preventionPreset.Heat4();
          break;
        case EPreventionHeatStage.Heat_5:
          heatData = this.m_preventionPreset.Heat5();
          break;
        case EPreventionHeatStage.Heat_0:
        default:
      };
    };
    return heatData;
  }

  private final func TryGetUnitDataFromVehicleRecord(vehicleRecord: wref<Vehicle_Record>, const recordsCount: Int32, recordIDs: script_ref<[TweakDBID]>) -> Bool {
    let i: Int32;
    let j: Int32;
    let unitRecordPool: array<wref<Character_Record>>;
    if IsDefined(vehicleRecord) && vehicleRecord.GetPreventionPassengersCount() > 0 {
      vehicleRecord.PreventionPassengers(unitRecordPool);
      while i < recordsCount {
        j = RandRange(0, ArraySize(unitRecordPool));
        ArrayPush(Deref(recordIDs), unitRecordPool[j].GetID());
        i += 1;
      };
      return true;
    };
    return false;
  }

  private final func TryGetUnitDataFromHeatStage(heatStage: EPreventionHeatStage, const recordsCount: Int32, recordIDs: script_ref<[TweakDBID]>) -> Bool {
    let unitRecordPool: array<wref<PreventionUnitPoolData_Record>>;
    let heatData: wref<PreventionHeatData_Record> = this.GetHeatData();
    if IsDefined(heatData) && heatData.GetUnitRecordsPoolCount() > 0 {
      heatData.UnitRecordsPool(unitRecordPool);
      return this.GetCharacterRecordsFromPool(recordsCount, unitRecordPool, recordIDs);
    };
    return false;
  }

  private final func TryGetDistinctUnitDataFromHeatStage(recordIDs: script_ref<[TweakDBID]>) -> Bool {
    let i: Int32;
    let unitRecordPool: array<wref<PreventionUnitPoolData_Record>>;
    let heatData: wref<PreventionHeatData_Record> = this.GetHeatData();
    if IsDefined(heatData) && heatData.GetUnitRecordsPoolCount() > 0 {
      heatData.UnitRecordsPool(unitRecordPool);
      i = 0;
      while i < ArraySize(unitRecordPool) {
        ArrayPush(Deref(recordIDs), unitRecordPool[i].CharacterRecord().GetID());
        i += 1;
      };
      return ArraySize(Deref(recordIDs)) > 0;
    };
    return false;
  }

  private final func GetFindSpawnPointsOrigin(out pos: Vector4, out dir: Vector4) -> Void {
    let offsetDist: Float;
    let vehSpeed: Float;
    let vehicle: wref<VehicleObject>;
    dir = this.m_player.GetWorldForward();
    if VehicleComponent.GetVehicle(this.m_player.GetGame(), this.m_player, vehicle) {
      vehSpeed = vehicle.GetBlackboard().GetFloat(GetAllBlackboardDefs().Vehicle.SpeedValue);
      if vehSpeed > 0.50 {
        offsetDist = LerpF(vehSpeed / 30.00, 20.00, 60.00, true);
        pos = pos + offsetDist * vehicle.GetWorldForward();
        dir *= -1.00;
      };
    } else {
      pos = this.GetLastKnownPlayerPosition();
    };
  }

  private final func GetFindSpawnPointsOriginsData(spawnOriginsPositions: script_ref<[Vector4]>) -> Void {
    let currentOriginPosition: Vector4;
    let distanceToCheck: Float;
    let i: Int32;
    let offsetDist: Float;
    let pointData: ref<PointData>;
    let singleSortedResult: HandleWithValue;
    let sortedResults: array<HandleWithValue>;
    let vehSpeed: Float;
    let vehicle: wref<VehicleObject>;
    let viewerPos: Vector4;
    let lastKnownPlayerPos: Vector4 = this.GetLastKnownPlayerPosition();
    let playerPos: Vector4 = this.m_player.GetWorldPosition();
    if VehicleComponent.GetVehicle(this.m_player.GetGame(), this.m_player, vehicle) {
      vehSpeed = vehicle.GetBlackboard().GetFloat(GetAllBlackboardDefs().Vehicle.SpeedValue);
      if vehSpeed > 0.50 {
        offsetDist = LerpF(vehSpeed / 30.00, 20.00, 60.00, true);
        currentOriginPosition = playerPos + offsetDist * vehicle.GetWorldForward();
      } else {
        currentOriginPosition = playerPos;
      };
      ArrayPush(Deref(spawnOriginsPositions), currentOriginPosition);
    } else {
      currentOriginPosition = playerPos;
      ArrayPush(Deref(spawnOriginsPositions), currentOriginPosition);
      i = 0;
      while i < ArraySize(this.m_viewers) {
        viewerPos = this.m_viewers[i].GetWorldPosition();
        distanceToCheck = Vector4.Distance(playerPos, viewerPos);
        if distanceToCheck <= this.GetSpawnOriginMaxDistance() {
          pointData = new PointData();
          pointData.position = viewerPos;
          singleSortedResult.value = distanceToCheck;
          singleSortedResult.handle = pointData;
          ArrayPush(sortedResults, singleSortedResult);
        };
        i += 1;
      };
      if !Vector4.IsZero(lastKnownPlayerPos) && NotEquals(lastKnownPlayerPos, playerPos) {
        distanceToCheck = Vector4.Distance(playerPos, lastKnownPlayerPos);
        if distanceToCheck <= this.GetSpawnOriginMaxDistance() {
          pointData = new PointData();
          pointData.position = lastKnownPlayerPos;
          singleSortedResult.value = distanceToCheck;
          singleSortedResult.handle = pointData;
          ArrayPush(sortedResults, singleSortedResult);
        };
      };
      if ArraySize(sortedResults) > 0 {
        SortHandleWithValueArray(sortedResults);
        i = 0;
        while i < ArraySize(sortedResults) {
          pointData = sortedResults[i].handle as PointData;
          if IsDefined(pointData) {
            currentOriginPosition = pointData.position;
            ArrayPush(Deref(spawnOriginsPositions), currentOriginPosition);
          };
          i += 1;
        };
      };
    };
  }

  private final func UpdateTotalCrimeScore(request: ref<PreventionDamageRequest>) -> Void {
    if request.isTargetVehicle {
      this.CalculateCrimeScoreForVehicle(request);
    } else {
      this.CalculateCrimeScoreForNPC(request);
    };
  }

  private final func CalculateCrimeScoreForNPC(request: ref<PreventionDamageRequest>) -> Void {
    let score: Float;
    if !request.isTargetPrevention {
      if request.isTargetKilled {
        this.m_totalCrimeScore += this.m_preventionDataTable.HeatKillCiv() * this.m_crimeScoreMultiplierByQuest;
        return;
      };
      switch request.attackType {
        case gamedataAttackType.StrongMelee:
        case gamedataAttackType.QuickMelee:
        case gamedataAttackType.Melee:
          score = this.m_preventionDataTable.HeatMeleAttackCiv();
          break;
        case gamedataAttackType.Thrown:
        case gamedataAttackType.Ranged:
        case gamedataAttackType.Direct:
          score = this.m_preventionDataTable.HeatRangeAttackCiv();
          break;
        case gamedataAttackType.Hack:
          score = this.m_preventionDataTable.HeatQuickHackCiv();
          break;
        case gamedataAttackType.Explosion:
        case gamedataAttackType.PressureWave:
          score = this.m_preventionDataTable.HeatExplosionCiv();
          break;
        default:
          score = request.damageDealtPercentValue / 2.00;
      };
    } else {
      if request.isTargetKilled {
        this.UnregisterPreventionUnit(request.targetID);
        GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).MarkAsDead(request.targetID);
        this.m_totalCrimeScore += this.m_preventionDataTable.HeatKillPolice() * this.m_crimeScoreMultiplierByQuest;
        return;
      };
      switch request.attackType {
        case gamedataAttackType.StrongMelee:
        case gamedataAttackType.QuickMelee:
        case gamedataAttackType.Melee:
          if this.TryMarkAsAttackedByPlayer(request.targetID) {
            score = this.m_preventionDataTable.HeatMeleAttackPolice();
          };
          break;
        case gamedataAttackType.Thrown:
        case gamedataAttackType.Ranged:
        case gamedataAttackType.Direct:
          if this.TryMarkAsAttackedByPlayer(request.targetID) {
            score = this.m_preventionDataTable.HeatRangeAttackPolice();
          };
          break;
        case gamedataAttackType.Hack:
          score = this.m_preventionDataTable.HeatQuickHackPolice();
          break;
        case gamedataAttackType.Explosion:
        case gamedataAttackType.PressureWave:
          score = this.m_preventionDataTable.HeatExplosionPolice();
          break;
        default:
          score = request.damageDealtPercentValue;
      };
    };
    this.m_totalCrimeScore += score * this.m_crimeScoreMultiplierByQuest;
  }

  private final func CalculateCrimeScoreForVehicle(request: ref<PreventionDamageRequest>) -> Void {
    let score: Float;
    if request.isTargetPrevention {
      score = request.damageDealtPercentValue * this.m_preventionDataTable.PoliceVehicleCrimeScoreMultiplier();
    } else {
      score = request.damageDealtPercentValue * this.m_preventionDataTable.CivVehicleCrimeScoreMultiplier();
    };
    this.m_totalCrimeScore += score * this.m_crimeScoreMultiplierByQuest;
  }

  private final func TryMarkAsAttackedByPlayer(targetId: EntityID) -> Bool {
    let policeAgent: ref<NPCAgent>;
    if !this.m_agentRegistry.TryGetNPCAgentByID(targetId, policeAgent) || policeAgent.hasBeenAttackedByPlayer {
      return false;
    };
    policeAgent.hasBeenAttackedByPlayer = true;
    return true;
  }

  private final func GetDistrictMultiplier() -> Float {
    if IsDefined(this.m_districtManager) {
      return this.m_districtMultiplier;
    };
    return 1.00;
  }

  protected final func SetLastAttackTime(value: Float) -> Void {
    this.m_lastAttackTime = value;
  }

  protected final func UpdateLastAttackTargetIDs(value: EntityID) -> Void {
    ArrayPush(this.m_lastAttackTargetIDs, value);
  }

  protected final func ClearLastAttackTargetIDs() -> Void {
    ArrayClear(this.m_lastAttackTargetIDs);
  }

  protected final func SetLastKnownPlayerPosition(value: Vector4) -> Void {
    this.m_lastKnownPosition = value;
  }

  protected final func SetSystemLock(value: Bool) -> Void {
    this.m_systemLocked = value;
  }

  protected final func SetCrimeScoreMultiplier(value: Float) -> Void {
    this.m_crimeScoreMultiplierByQuest = value;
  }

  protected final func SetVehicleSpawnBlockSide(value: EVehicleSpawnBlockSide) -> Void {
    this.m_vehicleSpawnBlockSide = value;
  }

  protected final func SetDamageToPlayerMultiplier(value: Float) -> Void {
    this.m_damageToPlayerMultiplier = value;
  }

  protected final func SetChaseMultiplier(value: Float) -> Void {
    this.m_chaseMultiplier = value;
  }

  protected final func SetBlockVehicleSpawn(value: Bool) -> Void {
    this.m_blockVehicleSpawnByQuest = value;
  }

  protected final func SetBlockOnFootSpawn(value: Bool) -> Void {
    this.m_blockOnFootSpawnByQuest = value;
  }

  protected final func SetBlockShootingFromVehicle(value: Bool) -> Void {
    this.m_blockShootingFromVehicle = value;
  }

  protected final func SetBlockReconDroneSpawn(value: Bool) -> Void {
    this.m_blockReconDroneSpawnByQuest = value;
  }

  protected final func SetMinMaxResetHeatLevels(MinLevel: Int32, MaxLevel: Int32, isDefault: Bool) -> Void {
    this.m_minHeatLevel = IntToEPreventionHeatStage(MinLevel);
    this.m_maxHeatLevel = IntToEPreventionHeatStage(MaxLevel);
    this.m_defaultHeatLevels = isDefault;
  }

  protected final func SetStarStateUI(newState: EStarState) -> Void {
    if this.m_shouldForceStarStateUIToActive {
      if NotEquals(newState, EStarState.Active) {
        return;
      };
    };
    if NotEquals(this.m_starState, newState) {
      this.m_starStateUIChanged = true;
    } else {
      return;
    };
    PoliceRadioScriptSystem.UpdatePoliceRadioOnPlayerVisibilityChanged(this.GetGameInstance(), this.GetLastStarChangeStartTimeStamp(), this.m_heatStage, this.m_starState, newState);
    this.SetWantedStateFact(newState);
    this.m_starState = newState;
    PreventionSystemHackerLoop.UpdateStarStateUI(this.GetGameInstance());
    if IsDefined(this.m_wantedBarBlackboard) {
      switch newState {
        case EStarState.Active:
          this.m_wantedBarBlackboard.SetName(GetAllBlackboardDefs().UI_WantedBar.CurrentChaseState, n"Active", true);
          break;
        case EStarState.Searching:
          this.m_wantedBarBlackboard.SetName(GetAllBlackboardDefs().UI_WantedBar.CurrentChaseState, n"Searching", true);
          break;
        case EStarState.Blinking:
          this.m_wantedBarBlackboard.SetName(GetAllBlackboardDefs().UI_WantedBar.CurrentChaseState, n"Dropping", true);
          break;
        case EStarState.Default:
          this.m_wantedBarBlackboard.SetName(GetAllBlackboardDefs().UI_WantedBar.CurrentChaseState, n"Default", true);
          break;
        default:
          this.m_wantedBarBlackboard.SetName(GetAllBlackboardDefs().UI_WantedBar.CurrentChaseState, n"Default", true);
      };
    };
  }

  private final func GetWantedLevelFact() -> Int32 {
    let questSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.GetGameInstance());
    let wantedLevel: Int32 = questSystem.GetFact(n"wanted_level");
    return wantedLevel;
  }

  private final func SetWantedLevelFact(level: Int32) -> Void {
    let questSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.GetGameInstance());
    if IsDefined(questSystem) {
      questSystem.SetFact(n"wanted_level", level);
    };
  }

  private final func SetWantedStateFact(state: EStarState) -> Void {
    let questSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.GetGameInstance());
    if IsDefined(questSystem) {
      if Equals(state, EStarState.Active) {
        questSystem.SetFact(n"wanted_chase_active", 1);
      } else {
        questSystem.SetFact(n"wanted_chase_active", 0);
      };
    };
  }

  private final func SetAgentsSupport(hasSupport: Bool) -> Void {
    let i1: Int32;
    let i: Int32 = 0;
    while i < ArraySize(this.m_agentGroupsList) {
      i1 = 0;
      while i1 < this.m_agentGroupsList[i].GetAgentsNumber() {
        this.SetSingleAgentSupport(this.m_agentGroupsList[i].GetAgetntByIndex(i1), hasSupport);
        i1 += 1;
      };
      i += 1;
    };
  }

  private final func SetSingleAgentSupport(ps: wref<PersistentState>, hasSupport: Bool) -> Void {
    let evt: ref<SecuritySystemSupport>;
    if !PersistentID.IsDefined(ps.GetID()) {
      return;
    };
    evt = new SecuritySystemSupport();
    evt.supportGranted = hasSupport;
    GameInstance.GetPersistencySystem(this.GetGameInstance()).QueuePSEvent(ps.GetID(), ps.GetClassName(), evt);
  }

  public final const func CanPreventionReactToInput() -> Bool {
    if !IsDefined(this.m_player) {
      return false;
    };
    if !this.IsSystemEnabled() || IsMultiplayer() || this.IsSystemLocked() {
      return false;
    };
    if this.m_securityAreaResetCheck {
      return false;
    };
    if EnumInt(this.m_playerHLS) > 1 && EnumInt(this.m_playerHLS) <= 5 {
      return false;
    };
    if StatusEffectSystem.ObjectHasStatusEffectWithTag(this.m_player, n"VehicleCombat") {
      return false;
    };
    return true;
  }

  private final func RegisterToBBCalls() -> Void {
    if !IsDefined(this.m_onPlayerChoiceCallID) {
      this.m_onPlayerChoiceCallID = GameInstance.GetBlackboardSystem(this.GetGame()).Get(GetAllBlackboardDefs().UIInteractions).RegisterListenerVariant(GetAllBlackboardDefs().UIInteractions.LastAttemptedChoice, this, n"OnPlayerChoice");
    };
    this.m_playerAttachedCallbackID = GameInstance.GetPlayerSystem(this.GetGameInstance()).RegisterPlayerPuppetAttachedCallback(this, n"PlayerAttachedCallback");
    this.m_playerDetachedCallbackID = GameInstance.GetPlayerSystem(this.GetGameInstance()).RegisterPlayerPuppetDetachedCallback(this, n"PlayerDetachedCallback");
  }

  private final func UnregisterBBCalls() -> Void {
    if IsDefined(this.m_onPlayerChoiceCallID) {
      GameInstance.GetBlackboardSystem(this.GetGame()).Get(GetAllBlackboardDefs().UIInteractions).UnregisterListenerVariant(GetAllBlackboardDefs().UIInteractions.LastAttemptedChoice, this.m_onPlayerChoiceCallID);
    };
    GameInstance.GetPlayerSystem(this.GetGameInstance()).UnregisterPlayerPuppetAttachedCallback(this.m_playerAttachedCallbackID);
    GameInstance.GetPlayerSystem(this.GetGameInstance()).UnregisterPlayerPuppetDetachedCallback(this.m_playerDetachedCallbackID);
  }

  private final func PlayerAttachedCallback(playerPuppet: ref<GameObject>) -> Void {
    let psmBlackboard: ref<IBlackboard>;
    this.m_player = playerPuppet as PlayerPuppet;
    if !IsDefined(this.m_player) {
      return;
    };
    psmBlackboard = GameInstance.GetBlackboardSystem(this.GetGame()).GetLocalInstanced(playerPuppet.GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    if IsDefined(psmBlackboard) {
      this.m_playerHLSID = psmBlackboard.RegisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.HighLevel, this, n"OnPlayerHLSChange", true);
      this.m_playerVehicleStateID = psmBlackboard.RegisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Vehicle, this, n"OnPlayerVehicleStateChange", true);
    } else {
      this.m_playerHLSID = null;
      this.m_playerVehicleStateID = null;
    };
  }

  private final func PlayerDetachedCallback(playerPuppet: ref<GameObject>) -> Void {
    this.m_player = null;
    let psmBlackboard: ref<IBlackboard> = GameInstance.GetBlackboardSystem(this.GetGame()).GetLocalInstanced(playerPuppet.GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    if IsDefined(psmBlackboard) {
      if IsDefined(this.m_playerHLSID) {
        psmBlackboard.UnregisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.HighLevel, this.m_playerHLSID);
      };
      if IsDefined(this.m_playerVehicleStateID) {
        psmBlackboard.UnregisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Vehicle, this.m_playerVehicleStateID);
      };
    };
  }

  protected cb func OnPlayerHLSChange(value: Int32) -> Bool {
    this.m_playerHLS = IntEnum<gamePSMHighLevel>(value);
    this.ReevaluateSecurityAreaReset();
  }

  protected cb func OnPlayerVehicleStateChange(value: Int32) -> Bool {
    this.m_playerVehicleState = IntEnum<gamePSMVehicle>(value);
  }

  private final func StartTransitiontoGreyStateTimerRequest() -> Void {
    let request: ref<PreventionTransitionToGreyStateTimerRequest>;
    if this.m_transitionToGreyStateDelayID == GetInvalidDelayID() {
      request = new PreventionTransitionToGreyStateTimerRequest();
      this.m_transitionToGreyStateDelayID = GameInstance.GetDelaySystem(this.GetGameInstance()).DelayScriptableSystemRequest(n"PreventionSystem", request, 2.50);
    };
    if !IsFinal() {
      this.RefreshDebugEvents();
    };
  }

  private final func CancelTransitiontoGreyStateTimerRequest() -> Void {
    if this.m_transitionToGreyStateDelayID != GetInvalidDelayID() {
      GameInstance.GetDelaySystem(this.GetGameInstance()).CancelDelay(this.m_transitionToGreyStateDelayID);
      GameInstance.GetDelaySystem(this.GetGameInstance()).CancelCallback(this.m_transitionToGreyStateDelayID);
      this.m_transitionToGreyStateDelayID = GetInvalidDelayID();
      if !IsFinal() {
        this.RefreshDebugEvents();
      };
    };
  }

  private final func ResetTransitiontoGreyStateTimerRequest() -> Void {
    if this.m_transitionToGreyStateDelayID != GetInvalidDelayID() {
      this.CancelTransitiontoGreyStateTimerRequest();
      this.StartTransitiontoGreyStateTimerRequest();
    };
  }

  private final func StartStateBufferTimerRequest() -> Void {
    let request: ref<PreventionStarStateBufferTimerRequest>;
    if this.m_starStateBufferTimerDelayID == GetInvalidDelayID() {
      request = new PreventionStarStateBufferTimerRequest();
      this.m_starStateBufferTimerDelayID = GameInstance.GetDelaySystem(this.GetGameInstance()).DelayScriptableSystemRequest(n"PreventionSystem", request, this.m_preventionDataTable.StateBufferTimer());
    };
    if !IsFinal() {
      this.RefreshDebugEvents();
    };
  }

  private final func CancelStateBufferTimerRequest() -> Void {
    if this.m_starStateBufferTimerDelayID != GetInvalidDelayID() {
      GameInstance.GetDelaySystem(this.GetGameInstance()).CancelDelay(this.m_starStateBufferTimerDelayID);
      GameInstance.GetDelaySystem(this.GetGameInstance()).CancelCallback(this.m_starStateBufferTimerDelayID);
      this.m_starStateBufferTimerDelayID = GetInvalidDelayID();
      if !IsFinal() {
        this.RefreshDebugEvents();
      };
    };
  }

  private final func ResetStateBufferTimerRequest() -> Void {
    if this.m_starStateBufferTimerDelayID != GetInvalidDelayID() {
      this.CancelStateBufferTimerRequest();
      this.StartStateBufferTimerRequest();
    };
  }

  private final func UpdateStateBufferTimerRequest() -> Void {
    let request: ref<PreventionStarStateBufferTimerRequest>;
    let timeRemain: Float;
    let increment: Float = 5.00;
    if this.m_starStateBufferTimerDelayID != GetInvalidDelayID() {
      timeRemain = GameInstance.GetDelaySystem(this.GetGameInstance()).GetRemainingDelayTime(this.m_starStateBufferTimerDelayID);
      timeRemain = MinF(this.m_preventionDataTable.StateBufferTimer(), timeRemain + increment);
      this.CancelStateBufferTimerRequest();
      request = new PreventionStarStateBufferTimerRequest();
      this.m_starStateBufferTimerDelayID = GameInstance.GetDelaySystem(this.GetGameInstance()).DelayScriptableSystemRequest(n"PreventionSystem", request, timeRemain);
    };
  }

  private final func StartSearchingTimerRequest() -> Void {
    let duration: Float;
    let request: ref<PreventionSearchingStatusRequest>;
    if this.m_searchingStatusDelayID != GetInvalidDelayID() {
      return;
    };
    if GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).IsPlayerInSoftDeescalationTrigger() {
      duration = this.GetSoftDeescalationGreyStarsDuration();
    } else {
      duration = this.m_preventionDataTable.StateGreyStarTime();
    };
    request = new PreventionSearchingStatusRequest();
    this.m_searchingStatusDelayID = GameInstance.GetDelaySystem(this.GetGameInstance()).DelayScriptableSystemRequest(n"PreventionSystem", request, duration);
    if !IsFinal() {
      this.RefreshDebugEvents();
    };
  }

  private final func CancelSearchingTimerRequest() -> Void {
    if this.m_searchingStatusDelayID != GetInvalidDelayID() {
      GameInstance.GetDelaySystem(this.GetGameInstance()).CancelDelay(this.m_searchingStatusDelayID);
      GameInstance.GetDelaySystem(this.GetGameInstance()).CancelCallback(this.m_searchingStatusDelayID);
      this.m_searchingStatusDelayID = GetInvalidDelayID();
      if !IsFinal() {
        this.RefreshDebugEvents();
      };
    };
  }

  private final func ResetSearchingTimerRequest() -> Void {
    if this.m_searchingStatusDelayID != GetInvalidDelayID() {
      this.CancelSearchingTimerRequest();
      this.StartSearchingTimerRequest();
    };
  }

  private final func UpdateSearchingTimerRequest() -> Void {
    let request: ref<PreventionSearchingStatusRequest>;
    let timeRemain: Float;
    let increment: Float = 3.00;
    if this.m_searchingStatusDelayID != GetInvalidDelayID() {
      timeRemain = GameInstance.GetDelaySystem(this.GetGameInstance()).GetRemainingDelayTime(this.m_searchingStatusDelayID);
      timeRemain = MinF(this.m_preventionDataTable.StateGreyStarTime(), timeRemain + increment);
      this.CancelSearchingTimerRequest();
      request = new PreventionSearchingStatusRequest();
      this.m_searchingStatusDelayID = GameInstance.GetDelaySystem(this.GetGameInstance()).DelayScriptableSystemRequest(n"PreventionSystem", request, timeRemain);
    };
  }

  private final func StartBlinkingTimerRequest() -> Void {
    let duration: Float;
    let telemetryInfo: String;
    if GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).IsPlayerInSoftDeescalationTrigger() {
      duration = this.GetSoftDeescalationBlinkingStarsDuration();
      telemetryInfo = "QuestPreventionTriggerSoftDeescalation";
    } else {
      duration = this.m_preventionDataTable.StateBlinkingStarTime();
      telemetryInfo = "SystemTimeOut";
    };
    this.StartBlinkingTimerRequest(duration, false, telemetryInfo);
  }

  private final func StartBlinkingTimerRequest(duration: Float, lockWhileBlinking: Bool, telemetryInfo: String) -> Void {
    let request: ref<PreventionBlinkingStatusRequest>;
    if lockWhileBlinking {
      this.TogglePreventionSystem(false);
    };
    if this.m_blinkingStatusDelayID == GetInvalidDelayID() {
      request = new PreventionBlinkingStatusRequest();
      request.m_lockPreventionSystemWhileBlinking = lockWhileBlinking;
      request.m_telemetryInfo = telemetryInfo;
      this.m_blinkingStatusDelayID = GameInstance.GetDelaySystem(this.GetGameInstance()).DelayScriptableSystemRequest(n"PreventionSystem", request, duration);
      this.m_wantedBarBlackboard.SetFloat(GetAllBlackboardDefs().UI_WantedBar.BlinkingStarsDurationTime, duration, true);
      if !IsFinal() {
        this.RefreshDebugEvents();
      };
    };
  }

  private final func CancelBlinkingTimerRequest() -> Void {
    if this.m_blinkingStatusDelayID != GetInvalidDelayID() {
      GameInstance.GetDelaySystem(this.GetGameInstance()).CancelDelay(this.m_blinkingStatusDelayID);
      GameInstance.GetDelaySystem(this.GetGameInstance()).CancelCallback(this.m_blinkingStatusDelayID);
      this.m_blinkingStatusDelayID = GetInvalidDelayID();
      if !IsFinal() {
        this.RefreshDebugEvents();
      };
    };
  }

  private final func ResetBlinkingTimerRequest() -> Void {
    if this.m_blinkingStatusDelayID != GetInvalidDelayID() {
      this.CancelBlinkingTimerRequest();
      this.StartBlinkingTimerRequest();
    };
  }

  private final func StartCrimescoreDropTimerRequest() -> Void {
    let request: ref<PreventionCrimeScoreZeroRequest>;
    if this.m_crimescoreTimerDelayID == GetInvalidDelayID() {
      request = new PreventionCrimeScoreZeroRequest();
      this.m_crimescoreTimerDelayID = GameInstance.GetDelaySystem(this.GetGameInstance()).DelayScriptableSystemRequest(n"PreventionSystem", request, this.m_preventionDataTable.HeatCrimeScoreResetTime());
      if !IsFinal() {
        this.RefreshDebugEvents();
      };
    };
  }

  private final func CancelCrimescoreDropTimerRequest() -> Void {
    if this.m_crimescoreTimerDelayID != GetInvalidDelayID() {
      GameInstance.GetDelaySystem(this.GetGameInstance()).CancelDelay(this.m_crimescoreTimerDelayID);
      this.m_crimescoreTimerDelayID = GetInvalidDelayID();
      if !IsFinal() {
        this.RefreshDebugEvents();
      };
    };
  }

  private final func ResetCrimescoreDropTimerRequest() -> Void {
    if this.m_crimescoreTimerDelayID != GetInvalidDelayID() {
      this.CancelCrimescoreDropTimerRequest();
      this.StartCrimescoreDropTimerRequest();
    };
  }

  private final func CancelNPCSpawnDelay() -> Bool {
    if this.m_policemenSpawnDelayID != GetInvalidDelayID() {
      GameInstance.GetDelaySystem(this.GetGameInstance()).CancelDelay(this.m_policemenSpawnDelayID);
      this.m_policemenSpawnDelayID = GetInvalidDelayID();
      return true;
    };
    return false;
  }

  private final func OnResupplyVehicleTicketsRequest(evt: ref<ResupplyVehicleTicketsRequest>) -> Void {
    this.TryResupplyTicket();
    this.TryRequestVehicleSpawnWithStrategy();
  }

  private final func TryResupplyTicket() -> Void {
    if this.m_currentVehicleTicketCount < this.m_preventionDataTable.VehicleTicketsAmount() {
      this.m_currentVehicleTicketCount = Min(this.m_preventionDataTable.VehicleTicketsAmount(), this.m_currentVehicleTicketCount + 1);
    };
  }

  private final func OnSpawnPoliceVehicleRequest(evt: ref<SpawnPoliceVehicleWithDelayRequest>) -> Void {
    this.m_isVehicleDelayOver = true;
    this.TryRequestVehicleSpawnWithStrategy();
  }

  private final func OnSpawnRoadblockRequest(evt: ref<SpawnRoadblockadeWithDelayRequest>) -> Void {
    if this.ShouldSpawnRoadblockade() {
      this.SpawnRoadblockade(this.GetHeatStage());
    };
  }

  private final func CanRequestAVSpawn() -> Bool {
    let timeSinceLastMaxtacTroopDied: Float;
    let maxNumberOfMaxTacAVsAtTheSameTime: Int32 = 1;
    if this.GetAgentRegistry().GetMaxTacNPCCount() > 1 {
      this.m_maxtacTroopBeingAliveTimeStamp = EngineTime.ToFloat(GameInstance.GetSimTime(this.GetGameInstance()));
      return false;
    };
    if ArraySize(this.m_lastAVRequestedSpawnPositionsArray) >= maxNumberOfMaxTacAVsAtTheSameTime {
      return false;
    };
    if NotEquals(this.GetHeatStage(), EPreventionHeatStage.Heat_5) {
      return false;
    };
    if NotEquals(this.GetStarState(), EStarState.Active) {
      return false;
    };
    if !PreventionSystemHackerLoop.AVCanBeSpawned(this.GetGame()) {
      return false;
    };
    timeSinceLastMaxtacTroopDied = EngineTime.ToFloat(GameInstance.GetSimTime(this.GetGameInstance())) - this.m_maxtacTroopBeingAliveTimeStamp;
    if timeSinceLastMaxtacTroopDied < this.m_preventionDataTable.TimeBetweenAVSpawnsAfterEncounter() {
      return false;
    };
    return true;
  }

  private final func TryRequestVehicleSpawnWithStrategy() -> Bool {
    let canSpawnEngagedVehicle: Bool;
    let canSpawnSupportVehicle: Bool;
    if this.m_blockVehicleSpawnByQuest {
      return false;
    };
    if !this.IsChasingPlayer() || !this.m_isVehicleDelayOver {
      return false;
    };
    if this.m_agentRegistry.GetTotalNPCCount() >= this.m_preventionDataTable.MaxUnitCount() {
      return false;
    };
    if this.m_currentVehicleTicketCount > 0 {
      if !this.ReachedEngagedVehiclesLimit() {
        canSpawnEngagedVehicle = true;
      };
      if !this.ReachedSupportVehiclesLimit() {
        canSpawnSupportVehicle = true;
      };
    } else {
      return false;
    };
    if !canSpawnEngagedVehicle && !canSpawnSupportVehicle {
      return false;
    };
    if this.ReachedTotalVehiclesLimit() {
      return false;
    };
    if this.SpawnPoliceVehicle() == 0u {
      this.m_failedVehicleSpawnAttempts += 1;
      if this.m_failedVehicleSpawnAttempts >= this.m_preventionDataTable.FallbackVehicleSpawnFailedAttempts() {
        this.TrySpawnPoliceOnFootFallback();
      };
      return false;
    };
    return true;
  }

  private final func OnPreventionStarStateBufferTimerRequest(evt: ref<PreventionStarStateBufferTimerRequest>) -> Void {
    this.PoliceLostPlayer();
    if !IsFinal() {
      this.RefreshDebug();
    };
  }

  private final func PoliceLostPlayer() -> Void {
    this.m_canSpawnFallbackEarly = false;
    this.m_policeKnowsPlayerLocation = false;
    this.CancelStateBufferTimerRequest();
    if !this.m_forceEternalGreyStars {
      this.StartSearchingTimerRequest();
    };
    if !IsFinal() {
      this.RefreshDebug();
    };
  }

  private final func OnPreventionTransitionToGreyStateTimerRequest(evt: ref<PreventionTransitionToGreyStateTimerRequest>) -> Void {
    this.CancelTransitiontoGreyStateTimerRequest();
    this.UpdateStarStateTo(EStarState.Searching);
  }

  private final func OnPreventionSearchingStatusRequest(evt: ref<PreventionSearchingStatusRequest>) -> Void {
    this.CancelSearchingTimerRequest();
    this.StartBlinkingTimerRequest();
    this.SetStarStateUI(EStarState.Blinking);
    if !IsFinal() {
      this.RefreshDebug();
    };
  }

  private final func OnPreventionBlinkingStatusRequest(evt: ref<PreventionBlinkingStatusRequest>) -> Void {
    this.execInstructionSafe(evt.m_telemetryInfo);
    if evt.m_lockPreventionSystemWhileBlinking {
      this.TogglePreventionSystem(true);
    };
    if !IsFinal() {
      this.RefreshDebug();
    };
  }

  private final func OnPreventionForceDeescalateRequest(evt: ref<PreventionForceDeescalateRequest>) -> Void {
    if !this.m_systemEnabled || !this.IsChasingPlayer() {
      return;
    };
    this.StartBlinkingTimerRequest(evt.fakeBlinkingDuration, true, evt.telemetryInfo);
    this.SetStarStateUI(EStarState.Blinking);
  }

  private final func OnRefreshDeescalationTimers(evt: ref<RefreshDeescalationTimers>) -> Void {
    let remainingDelayTime: Float;
    if !this.m_systemEnabled || !this.IsChasingPlayer() {
      return;
    };
    if this.m_forceEternalGreyStars {
      return;
    };
    if this.m_blinkingStatusDelayID != GetInvalidDelayID() {
      remainingDelayTime = GameInstance.GetDelaySystem(this.GetGameInstance()).GetRemainingDelayTime(this.m_blinkingStatusDelayID);
      if remainingDelayTime > this.GetSoftDeescalationBlinkingStarsDuration() {
        this.ResetBlinkingTimerRequest();
      };
    };
    if this.m_searchingStatusDelayID != GetInvalidDelayID() {
      remainingDelayTime = GameInstance.GetDelaySystem(this.GetGameInstance()).GetRemainingDelayTime(this.m_searchingStatusDelayID);
      if remainingDelayTime > this.GetSoftDeescalationGreyStarsDuration() {
        this.ResetSearchingTimerRequest();
      };
    };
  }

  private final func RequestUnitSpawn(recordID: TweakDBID, spawnTransform: WorldTransform) -> Void {
    let ticketID: Uint32 = GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).RequestUnitSpawn(recordID, spawnTransform);
    this.m_agentRegistry.CreateTicket(ticketID, vehiclePoliceStrategy.None, true);
  }

  private final func RemovePreventionInputLockRequest() -> Void {
    if this.IsPreventionInputLocked() {
      GameInstance.GetDelaySystem(this.GetGameInstance()).CancelDelay(this.m_inputlockDelayID);
      this.m_inputlockDelayID = GetInvalidDelayID();
      this.m_unhandledInputsReceived = 0;
      this.m_preventionUnitKilledDuringLock = false;
    };
  }

  private final func PreventionInputLockRequest() -> Void {
    let inputLockTime: Float;
    let request: ref<UnlockPreventionInputRequest>;
    if this.IsPreventionInputLocked() {
      this.RemovePreventionInputLockRequest();
    };
    inputLockTime = this.GetPreventionInputLockTime();
    if inputLockTime > 0.00 {
      request = new UnlockPreventionInputRequest();
      this.m_inputlockDelayID = GameInstance.GetDelaySystem(this.GetGameInstance()).DelayScriptableSystemRequest(n"PreventionSystem", request, inputLockTime);
    };
  }

  private final func OnUnlockPreventionInputRequest(request: ref<UnlockPreventionInputRequest>) -> Void {
    if this.m_preventionUnitKilledDuringLock {
      this.SendInternalSystem(1.00);
    };
    this.RemovePreventionInputLockRequest();
  }

  private final func SendDropPointLockRequest(isEnabled: Bool) -> Void {
    let lockDropPointSystem: ref<ToggleDropPointSystemRequest> = new ToggleDropPointSystemRequest();
    lockDropPointSystem.isEnabled = isEnabled;
    lockDropPointSystem.reason = n"PreventionSystem";
    GameInstance.QueueScriptableSystemRequest(this.GetGameInstance(), n"DropPointSystem", lockDropPointSystem);
  }

  private final func OnPreventionCrimeScoreZeroRequest(request: ref<PreventionCrimeScoreZeroRequest>) -> Void {
    this.m_totalCrimeScore = 0.00;
  }

  private final func OnPreventionUnitDespawnedRequest(request: ref<PreventionUnitDespawnedRequest>) -> Void {
    this.UnregisterPreventionUnit(request.entityID);
  }

  private final func OnPreventionUnitSpawnedRequest(request: ref<PreventionUnitSpawnedRequest>) -> Void {
    let ticketData: TicketData;
    if !this.m_agentRegistry.PopRequestTicket(request.requestResult.requestID, ticketData) {
      return;
    };
    if request.requestResult.success {
      this.HandleSpawnRequestSuccess(request.requestResult, ticketData);
    } else {
      this.HandleSpawnRequestFailure(request.requestResult, ticketData);
    };
  }

  private final func HandleSpawnRequestSuccess(result: SpawnRequestResult, ticketData: TicketData) -> Void {
    let spawnedObject: ref<GameObject>;
    let vehicleType: DynamicVehicleType = result.vehicleType;
    this.m_failedVehicleSpawnAttempts = 0;
    let isRoadblockade: Bool = Equals(vehicleType, DynamicVehicleType.RoadBlockade) || Equals(vehicleType, DynamicVehicleType.RoadBlockadeWithAV);
    let i: Int32 = 0;
    while i < ArraySize(result.spawnedObjects) {
      spawnedObject = result.spawnedObjects[i];
      this.RegisterPreventionUnit(spawnedObject, vehicleType, true, result.policeStrategy, ticketData.isFallback);
      if isRoadblockade {
        this.HandleRoadblockadeUnitSpawned(spawnedObject);
      };
      i += 1;
    };
  }

  private final func HandleRoadblockadeUnitSpawned(spawnedObject: ref<GameObject>) -> Void {
    if spawnedObject.IsVehicle() {
      (spawnedObject as VehicleObject).ApplyAvgZOffset();
    };
  }

  private final func HandleSpawnRequestFailure(result: SpawnRequestResult, ticketData: TicketData) -> Void {
    if Equals(result.vehicleType, DynamicVehicleType.Car) {
      this.m_failedVehicleSpawnAttempts += 1;
      this.TryResupplyTicket();
      if this.m_agentRegistry.GetPendingVehicleTicketsCount() <= 0 {
        this.TryRequestVehicleSpawnWithStrategy();
      };
    };
  }

  private final func OnRegisterNPC(request: ref<RegisterNPCRequest>) -> Void {
    let vehicleType: DynamicVehicleType = DynamicVehicleType.None;
    let preventionNPC: ref<ScriptedPuppet> = request.puppet;
    if !this.IsChasingPlayer() {
      return;
    };
    if !IsDefined(preventionNPC) || !preventionNPC.IsPrevention() {
      return;
    };
    if preventionNPC.IsCrowd() {
      vehicleType = DynamicVehicleType.None;
    } else {
      GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).TryGetVehicleType(preventionNPC.GetEntityID(), vehicleType);
    };
    this.RegisterPreventionUnit(preventionNPC, vehicleType, false);
  }

  private final func RegisterPreventionUnit(preventionUnit: ref<GameObject>, vehicleType: DynamicVehicleType, overrideExisting: Bool, opt strategy: vehiclePoliceStrategy, opt isFallback: Bool) -> Bool {
    if !this.m_agentRegistry.RegisterAgent(preventionUnit, vehicleType, strategy, isFallback, overrideExisting) {
      return false;
    };
    GameInstance.GetPreventionSpawnSystem(this.GetGame()).RegisterEntityDeathCallback(this, "OnPreventionEntityDestroyed", preventionUnit.GetEntityID());
    return true;
  }

  private final func CheckLastMaxTacAlone() -> Void {
    let maxTacAgent: ref<NPCAgent>;
    let maxTacArray: array<ref<NPCAgent>> = this.GetAgentRegistry().GetMaxTacNPCList();
    if ArraySize(maxTacArray) == 1 {
      maxTacAgent = maxTacArray[0];
      StatusEffectHelper.ApplyStatusEffect(maxTacAgent.gameObject, t"BaseStatusEffect.MaxTacAlone", maxTacAgent.gameObject.GetEntityID());
    };
  }

  private final func UnregisterPreventionUnit(entityID: EntityID) -> Void {
    let result: UnregisterResult = this.m_agentRegistry.UnregisterAgent(entityID);
    if !result.success {
      return;
    };
    switch result.spawnedType {
      case DynamicVehicleType.Car:
        this.m_isVehicleDelayOver = false;
        if result.isVehicle {
          this.TryRequestVehicleSpawnWithStrategy();
        };
        break;
      case DynamicVehicleType.AV:
        if !result.isVehicle {
          this.CheckLastMaxTacAlone();
        };
        if !result.isVehicle && this.IsMaxTacDefeated() {
          this.m_shouldPreventionUnitsStartRetreating = false;
          this.GetNewBatchMaxTacSpawnPositions();
        };
        break;
      case DynamicVehicleType.RoadBlockade:
        break;
      case DynamicVehicleType.RoadBlockadeWithAV:
        break;
      default:
    };
  }

  private final func OnPreventionEntityDestroyed(destroyedEntityID: EntityID) -> Void {
    this.UnregisterPreventionUnit(destroyedEntityID);
  }

  public final const func TrySetNPCMarkedForDespawnAI(entityID: EntityID, markedForDespawn: Bool) -> Bool {
    let npcAgent: ref<NPCAgent>;
    if this.GetAgentRegistry().TryGetNPCAgentByID(entityID, npcAgent) {
      npcAgent.markedToBeDespawned = markedForDespawn;
      return true;
    };
    return false;
  }

  public final const func TryGetNPCMarkedForDespawnAI(entityID: EntityID, out markedForDespawn: Bool) -> Bool {
    let npcAgent: ref<NPCAgent>;
    if this.GetAgentRegistry().TryGetNPCAgentByID(entityID, npcAgent) {
      markedForDespawn = npcAgent.markedToBeDespawned;
      return true;
    };
    return false;
  }

  public final const func UpdateVehiclePassengerCount(entityID: EntityID, passengersCount: Int32) -> Void {
    this.GetAgentRegistry().UpdateVehiclePassengerCount(entityID, passengersCount);
  }

  public final const func IsRegistered(entityID: EntityID) -> Bool {
    return this.GetAgentRegistry().Contains(entityID);
  }

  private final func OnPreventionTickRequest(request: ref<PreventionTickRequest>) -> Void {
    this.UpdateViewers();
    this.TryUpdateStarState();
    if !this.m_ignoreSecurityAreas && ArraySize(this.m_playerIsInSecurityArea) > 0 && !this.m_isPlayerMounted {
      this.ReevaluateSecurityAreaReset();
    };
    if this.CanRequestAVSpawn() {
      this.CheckPossibleSpawnPosAndRequestAVSpawn();
    };
    this.UpdateVehicles();
    this.UpdateMaxTacUnits();
    this.UpdateRoadblockadeUnits();
    if IsDefined(this.m_lastKnownVehicle) && !this.m_isPlayerMounted {
      StimBroadcasterComponent.BroadcastStim(this.m_lastKnownVehicle, gamedataStimType.CrimeWitness);
    };
    if this.m_starStateUIChanged {
      this.TryUpdateWantedLevelFact();
      this.m_starStateUIChanged = false;
    };
    this.UpdateNPCs();
    this.TryResolveIndefiniteStarState();
    if !IsFinal() {
      this.RefreshDebug();
    };
  }

  private final func CheckPlayerDistanceToLKP() -> Void {
    let currentDistance: Float;
    let thresholdDistance: Float = 175.00;
    if this.m_playerCrossedBufferDistance || Vector4.IsZero(this.m_lastKnownPosition) {
      return;
    };
    currentDistance = Vector4.Distance(this.m_player.GetWorldPosition(), this.m_lastKnownPosition);
    if thresholdDistance < currentDistance {
      this.m_playerCrossedBufferDistance = true;
      this.PoliceLostPlayer();
    };
  }

  private final func TryResolveIndefiniteStarState() -> Void {
    if NotEquals(this.m_starState, EStarState.Searching) {
      return;
    };
    if !this.m_forceEternalGreyStars && this.m_starStateBufferTimerDelayID == GetInvalidDelayID() && this.m_searchingStatusDelayID == GetInvalidDelayID() && this.m_blinkingStatusDelayID == GetInvalidDelayID() {
      this.StartSearchingTimerRequest();
    };
  }

  private final func TryUpdateStarState() -> Void {
    let isPoliceInCombarWithPlayer: Bool;
    if this.m_securityAreaResetCheck {
      return;
    };
    isPoliceInCombarWithPlayer = this.m_agentRegistry.IsPoliceInCombatWithPalyer();
    if isPoliceInCombarWithPlayer {
      this.SetLastKnownPlayerPosition(this.GetPlayer().GetWorldPosition());
      this.UpdateStarStateTo(EStarState.Active);
    } else {
      if !this.m_isInitialSearchState && !isPoliceInCombarWithPlayer && this.m_starStateBufferTimerDelayID == GetInvalidDelayID() && Equals(this.m_starState, EStarState.Active) {
        this.StartTransitiontoGreyStateTimerRequest();
        this.PoliceLostPlayer();
      } else {
        if this.m_isInitialSearchState && !isPoliceInCombarWithPlayer {
          this.m_isInitialSearchState = false;
          this.m_canSpawnFallbackEarly = true;
          this.SetStarStateUI(EStarState.Searching);
          this.StartStateBufferTimerRequest();
        } else {
          this.CheckPlayerDistanceToLKP();
        };
      };
    };
  }

  private final func UpdateMaxTacUnits() -> Void {
    let currentPlayerPosition: Vector4;
    let despawnDistanceSquared: Float;
    let i: Int32;
    let maxTacAgent: ref<NPCAgent>;
    let maxTacPosition: Vector4;
    let maxTacArray: array<ref<NPCAgent>> = this.GetAgentRegistry().GetMaxTacNPCList();
    if ArraySize(maxTacArray) < 1 {
      return;
    };
    currentPlayerPosition = this.m_player.GetWorldPosition();
    despawnDistanceSquared = TweakDBInterface.GetFloat(t"PreventionSystem.av_spawn_setup.despawnDistance", despawnDistanceSquared);
    despawnDistanceSquared = despawnDistanceSquared * despawnDistanceSquared;
    i = 0;
    while i < ArraySize(maxTacArray) {
      maxTacAgent = maxTacArray[i];
      if !IsDefined(maxTacAgent) || VehicleComponent.IsMountedToVehicle(this.GetGame(), maxTacAgent.unit) {
      } else {
        maxTacPosition = maxTacAgent.unit.GetWorldPosition();
        if Vector4.DistanceSquared(currentPlayerPosition, maxTacPosition) > despawnDistanceSquared {
          GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).RequestDespawn(maxTacAgent.unit.GetEntityID());
        };
      };
      i += 1;
    };
  }

  private final func UpdateRoadblockadeUnits() -> Void {
    let currentPlayerPosition: Vector4;
    let despawnDistanceSquared: Float;
    let i: Int32;
    let roadblockAgent: ref<NPCAgent>;
    let roadblockPosition: Vector4;
    let roadblockVehicle: ref<VehicleAgent>;
    let raodblockNPCsArray: array<ref<NPCAgent>> = this.GetAgentRegistry().GetRoadblockNPCList();
    let raodblockVehiclesArray: array<ref<VehicleAgent>> = this.GetAgentRegistry().GetRoadblockVehicleList();
    if ArraySize(raodblockNPCsArray) < 1 && ArraySize(raodblockVehiclesArray) < 1 {
      return;
    };
    currentPlayerPosition = this.m_player.GetWorldPosition();
    despawnDistanceSquared = TweakDBInterface.GetFloat(t"PreventionSystem.roadblockade_spawn_setup.despawnDistance", despawnDistanceSquared);
    despawnDistanceSquared = despawnDistanceSquared * despawnDistanceSquared;
    i = 0;
    while i < ArraySize(raodblockNPCsArray) {
      roadblockAgent = raodblockNPCsArray[i];
      if !IsDefined(roadblockAgent) {
      } else {
        roadblockPosition = roadblockAgent.unit.GetWorldPosition();
        if Vector4.DistanceSquared(currentPlayerPosition, roadblockPosition) > despawnDistanceSquared {
          GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).RequestDespawn(roadblockAgent.unit.GetEntityID());
        };
      };
      i += 1;
    };
    i = 0;
    while i < ArraySize(raodblockVehiclesArray) {
      roadblockVehicle = raodblockVehiclesArray[i];
      if !IsDefined(roadblockVehicle) {
      } else {
        roadblockPosition = roadblockVehicle.unit.GetWorldPosition();
        if Vector4.DistanceSquared(currentPlayerPosition, roadblockPosition) > despawnDistanceSquared {
          GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).RequestDespawn(roadblockVehicle.unit.GetEntityID());
        };
      };
      i += 1;
    };
  }

  private final func UpdateStarStateTo(state: EStarState) -> Void {
    if !this.m_systemEnabled {
      return;
    };
    this.UpdateStarStateTimers(state);
    this.SetStarStateUI(state);
  }

  private final func UpdateStarStateTimers(state: EStarState) -> Void {
    if Equals(state, EStarState.Active) {
      this.CancelTransitiontoGreyStateTimerRequest();
      this.CancelStateBufferTimerRequest();
      this.CancelSearchingTimerRequest();
      this.CancelBlinkingTimerRequest();
    } else {
      this.CancelBlinkingTimerRequest();
      this.CancelTransitiontoGreyStateTimerRequest();
      if this.m_heatLevelChanged {
        this.ResetSearchingTimerRequest();
        this.m_heatLevelChanged = false;
      } else {
        this.UpdateSearchingTimerRequest();
      };
    };
  }

  private final func UpdateStarState() -> Void {
    if this.m_agentRegistry.IsPoliceInCombatWithPalyer() {
      this.UpdateStarStateTo(EStarState.Active);
    } else {
      this.UpdateStarStateTo(EStarState.Searching);
    };
  }

  private final func TryUpdateWantedLevelFact() -> Void {
    if this.GetWantedLevelFact() == EnumInt(this.m_heatStage) {
      return;
    };
    if this.m_forceEternalGreyStars && Equals(this.m_starState, EStarState.Searching) {
      this.SetWantedLevelFact(0);
    } else {
      this.SetWantedLevelFact(EnumInt(this.m_heatStage));
    };
  }

  private final func CheckPossibleSpawnPosAndRequestAVSpawn() -> Void {
    let closestSpawnPointDistanceSquared: Float;
    let currentDistanceSquared: Float;
    let currentPlayerPosition: Vector4;
    let estimatedPositionToSpawnAV: Vector4;
    let i: Int32;
    let maxDistanceToClosestPointSquared: Float;
    let playerDirection: Vector4;
    let playerSpeed: Float;
    if ArraySize(this.m_avSpawnPointList) != 0 {
      currentPlayerPosition = this.m_player.GetWorldPosition();
      playerDirection = Vector4.Normalize(currentPlayerPosition - this.m_player.GetTransformHistoryComponent().GetInterpolatedPositionFromHistory(3.00));
      playerSpeed = Vector4.Length(this.m_player.GetTransformHistoryComponent().GetVelocity(3.00));
      estimatedPositionToSpawnAV = currentPlayerPosition + playerDirection * playerSpeed + playerDirection * this.m_maxAllowedDistanceToPlayer;
      closestSpawnPointDistanceSquared = Vector4.DistanceSquared(estimatedPositionToSpawnAV, Cast<Vector4>(this.m_avSpawnPointList[0]));
      i = 0;
      while i < ArraySize(this.m_avSpawnPointList) {
        if this.IsMaxTacDefeated() && this.CanSpawnAvAtPosition(estimatedPositionToSpawnAV, Cast<Vector4>(this.m_avSpawnPointList[i])) {
          this.RequestAVSpawnAtPosition(this.m_avSpawnPointList[i]);
          return;
        };
        currentDistanceSquared = Vector4.DistanceSquared(estimatedPositionToSpawnAV, Cast<Vector4>(this.m_avSpawnPointList[i]));
        if currentDistanceSquared < closestSpawnPointDistanceSquared {
          closestSpawnPointDistanceSquared = currentDistanceSquared;
        };
        i += 1;
      };
      maxDistanceToClosestPointSquared = SqrF(this.m_preventionDataTable.AvMaxDistanceForNewRequest());
      if closestSpawnPointDistanceSquared >= maxDistanceToClosestPointSquared {
        this.GetNewBatchMaxTacSpawnPositions();
      };
    } else {
      this.GetNewBatchMaxTacSpawnPositions();
    };
  }

  private final func CanSpawnAvAtPosition(playerPosition: Vector4, position: Vector4) -> Bool {
    let minDistToLastRequestedAVSquared: Float = SqrF(this.m_preventionDataTable.AvMinDistToSpawnedAV());
    let i: Int32 = 0;
    while i < ArraySize(this.m_lastAVRequestedSpawnPositionsArray) {
      if Vector4.DistanceSquared(this.m_lastAVRequestedSpawnPositionsArray[i], position) < minDistToLastRequestedAVSquared {
        return false;
      };
      i += 1;
    };
    return Vector4.DistanceSquared(playerPosition, position) <= SqrF(this.m_maxAllowedDistanceToPlayer);
  }

  public final const func ShouldPreventionUnitsRetreat() -> Bool {
    return this.m_shouldPreventionUnitsStartRetreating;
  }

  private final func IsPlayerCloseToLastCrimePosition() -> Bool {
    let currentDistance: Float = Vector4.Distance(this.m_player.GetWorldPosition(), this.GetLastKnownPlayerPosition());
    if currentDistance <= this.m_preventionDataTable.CrimeAreaRadius() {
      return true;
    };
    return false;
  }

  private final func StartSecurityAreaResetRequest(opt resetDelay: Float) -> Void {
    let request: ref<SecurityAreaResetRequest>;
    if !this.IsChasingPlayer() {
      return;
    };
    if this.m_securityAreaResetCheck {
      return;
    };
    request = new SecurityAreaResetRequest();
    if resetDelay <= 0.00 {
      resetDelay = 5.00;
    };
    this.m_securityAreaResetDelayID = GameInstance.GetDelaySystem(this.GetGameInstance()).DelayScriptableSystemRequest(n"PreventionSystem", request, resetDelay);
    this.m_securityAreaResetCheck = true;
    this.m_wantedBarBlackboard.SetFloat(GetAllBlackboardDefs().UI_WantedBar.BlinkingStarsDurationTime, resetDelay, true);
    this.SetStarStateUI(EStarState.Blinking);
    if this.CancelNPCSpawnDelay() {
      this.m_hadOngoingSpawnRequest = true;
    };
    if !IsFinal() {
      this.RefreshDebugEvents();
    };
  }

  private final func CancelSecurityAreaResetRequest() -> Void {
    if !this.m_securityAreaResetCheck {
      return;
    };
    GameInstance.GetDelaySystem(this.GetGameInstance()).CancelDelay(this.m_securityAreaResetDelayID);
    this.m_securityAreaResetCheck = false;
    if this.m_hadOngoingSpawnRequest {
      this.m_hadOngoingSpawnRequest = false;
    };
    this.UpdateStarState();
    if !IsFinal() {
      this.RefreshDebugEvents();
    };
  }

  private final func OnSecurityAreaResetRequest(request: ref<SecurityAreaResetRequest>) -> Void {
    this.m_securityAreaResetCheck = false;
    if this.m_defaultHeatLevels && Equals(this.m_minHeatLevel, EPreventionHeatStage.Heat_0) {
      this.execInstructionSafe("SecurityAreaReset");
    };
  }

  protected final func OnDamageInput(request: ref<PreventionDamageRequest>) -> Void {
    this.ProcessPreventionDamageRequest(request);
  }

  private final func ProcessPreventionDamageRequest(request: ref<PreventionDamageRequest>) -> Void {
    if !this.CanPreventionReactToInput() {
      this.Debug_ProcessReason = EPreventionDebugProcessReason.Abort_SystemLockedBySceneTier;
      if !IsFinal() {
        this.RefreshDebugProcessInfo();
      };
      return;
    };
    if this.IsPreventionInputLocked() {
      if !request.isTargetPrevention && request.isTargetKilled {
        this.m_preventionUnitKilledDuringLock = true;
      };
    };
    this.Debug_ProcessReason = EPreventionDebugProcessReason.Process_NewDamage;
    if request.damageDealtPercentValue < 0.00 {
      this.Debug_ProcessReason = EPreventionDebugProcessReason.Abort_DamageZero;
      if !IsFinal() {
        this.RefreshDebugProcessInfo();
      };
      return;
    };
    if !this.m_ignoreSecurityAreas && ArraySize(this.m_playerIsInSecurityArea) > 0 {
      if !IsFinal() {
        this.RefreshDebugProcessInfo();
      };
      return;
    };
    this.SetLastKnownPlayerPosition(this.GetPlayer().GetWorldPosition());
    if !this.IsPlayerInQuestArea() {
      this.CancelSecurityAreaResetRequest();
    };
    if Equals(request.requestedHeat, EPreventionHeatStage.Heat_0) {
      this.execInstructionSafe("DEBUG");
      return;
    };
    if this.m_crimescoreTimerDelayID == GetInvalidDelayID() {
      this.StartCrimescoreDropTimerRequest();
    } else {
      this.ResetCrimescoreDropTimerRequest();
    };
    if this.IsChasingPlayer() {
      this.UpdateStarState();
    };
    this.UpdateTotalCrimeScore(request);
    if !IsFinal() {
      this.Debug_LastAttackType = request.attackType;
      this.Debug_LastDamageDealt = request.damageDealtPercentValue * 100.00;
      this.RefreshDebug();
    };
    if this.m_totalCrimeScore >= this.m_preventionDataTable.HeatThresholdCapacity() {
      this.m_totalCrimeScore = 0.00;
      this.StartPipeline(request);
    };
  }

  private final func StartPipeline(request: ref<PreventionDamageRequest>) -> Void {
    this.PreDamageChange();
    this.DamageChange();
    this.PostDamageChange(request);
    if !IsFinal() {
      this.RefreshDebug();
    };
  }

  private final func PreDamageChange() -> Void;

  private final func DamageChange() -> Void;

  private final func PostDamageChange(request: ref<PreventionDamageRequest>) -> Void {
    this.HeatPipeline(request.telemetryInfo);
  }

  private final func HeatPipeline(heatChangeReason: String) -> Void {
    let heatStageToSet: EPreventionHeatStage = IntToEPreventionHeatStage(EnumInt(this.m_heatStage) + 1);
    this.ChangeHeatStage(heatStageToSet, heatChangeReason);
  }

  private final func ComputeTotalCrimeScoreForTelemetry(newHeatStageEnum: EPreventionHeatStage) -> Uint32 {
    let heatDataRecord: ref<PreventionHeatTable_Record>;
    let newHeatStage: Int32 = EnumInt(newHeatStageEnum);
    let totalCrimeScore: Float = 0.00;
    let i: Int32 = 0;
    while i < newHeatStage {
      heatDataRecord = this.GetDataTableForHeat(IntEnum<EPreventionHeatStage>(i));
      if IsDefined(heatDataRecord) {
        totalCrimeScore += heatDataRecord.HeatThresholdCapacity();
      };
      i += 1;
    };
    return Cast<Uint32>(totalCrimeScore + this.m_totalCrimeScore);
  }

  private final func ChangeHeatStage(newHeatStage: EPreventionHeatStage, heatChangeReason: String) -> Void {
    let previousHeatStage: EPreventionHeatStage;
    if !IsDefined(this.m_wantedBarBlackboard) {
      return;
    };
    if !this.m_defaultHeatLevels {
      newHeatStage = IntToEPreventionHeatStage(Clamp(EnumInt(newHeatStage), EnumInt(this.m_minHeatLevel), EnumInt(this.m_maxHeatLevel)));
    };
    if Equals(this.m_heatStage, newHeatStage) {
      return;
    };
    previousHeatStage = this.m_heatStage;
    this.m_heatStage = newHeatStage;
    this.m_heatChangeReason = heatChangeReason;
    GameInstance.GetTelemetrySystem(this.GetGameInstance()).LogHeatLevelChanged(EnumInt(this.m_heatStage), heatChangeReason, this.ComputeTotalCrimeScoreForTelemetry(newHeatStage));
    this.m_wantedBarBlackboard.SetInt(GetAllBlackboardDefs().UI_WantedBar.CurrentWantedLevel, EnumInt(this.m_heatStage), true);
    this.m_lastStarChangeTimeStamp = EngineTime.ToFloat(GameInstance.GetSimTime(this.GetGameInstance()));
    this.GetDataTableForCurrentHeat();
    this.OnHeatChanged(previousHeatStage);
  }

  private final func OnHeatChanged(previousHeat: EPreventionHeatStage) -> Void {
    let elevator: wref<GameObject>;
    let i: Int32;
    let rammingAttemptTime: Float;
    let rammingTime: Float;
    let targetTrackerComponent: ref<TargetTrackerComponent>;
    let threat: TrackedLocation;
    let reserveAssignedSeatEvt: ref<ReserveAssignedSeat> = new ReserveAssignedSeat();
    let npcAgents: array<ref<NPCAgent>> = this.m_agentRegistry.GetNPCList();
    let agressivenessMultiplier: Float = this.m_chaseMultiplier;
    GamepadLightScriptableSystem.UpdatePoliceSiren(this.GetGameInstance(), this.m_heatStage);
    PoliceRadioScriptSystem.UpdatePoliceRadioOnHeatChange(this.GetGameInstance(), this.m_heatStage, this.GetCurrentDistrict());
    PreventionSystemHackerLoop.UpdateHeatLevel(this.GetGame(), this.m_preventionDataTable.IsVehicleHackingLoopEnabled());
    this.SetLastKnownPlayerPosition(this.GetPlayer().GetWorldPosition());
    GameInstance.GetAudioSystem(this.GetGame()).RegisterPreventionHeatStage(Cast<Uint8>(EnumInt(this.GetHeatStage())));
    if LiftDevice.GetCurrentElevator(this.GetGame(), elevator) {
      elevator.QueueEvent(new RefreshPlayerAuthorizationEvent());
    };
    rammingAttemptTime = 4.00 * agressivenessMultiplier;
    GameInstance.GetVehicleSystem(this.GetGame()).SetRammingAttemptDuration(rammingAttemptTime);
    this.TryUpdateWantedLevelFact();
    if Equals(previousHeat, EPreventionHeatStage.Heat_0) {
      GameInstance.GetPreventionSpawnSystem(this.GetGame()).ReinitAll();
      this.ReinitAll();
    };
    switch this.m_heatStage {
      case EPreventionHeatStage.Heat_0:
        GameInstance.GetVehicleSystem(this.GetGame()).ResetChaseManager();
        GameInstance.GetPreventionSpawnSystem(this.GetGame()).CancelAllSpawnRequests();
        GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).TogglePreventionActive(false);
        GameInstance.GetAudioSystem(this.GetGame()).Play(n"gmp_ui_prevention_player_reset");
        FastTravelSystem.RemoveFastTravelLock(n"PreventionSystem", this.GetGameInstance());
        i = 0;
        while i < ArraySize(npcAgents) {
          if this.IsNPCValid(npcAgents[i].unit) {
            npcAgents[i].unit.QueueEvent(reserveAssignedSeatEvt);
            npcAgents[i].unit.StopPoliceBehaviour();
            targetTrackerComponent = npcAgents[i].unit.GetTargetTrackerComponent();
            if IsDefined(targetTrackerComponent) {
              if targetTrackerComponent.ThreatFromEntity(this.m_player, threat) {
                AISquadHelper.RemoveThreatFromSquad(npcAgents[i].unit, threat);
                GameObject.ChangeAttitudeToNeutral(npcAgents[i].unit, this.m_player);
              };
              targetTrackerComponent.RemoveThreat(targetTrackerComponent.MapThreat(this.m_player));
              targetTrackerComponent.ResetRecentlyDroppedThreat();
            };
            NPCPuppet.ChangeHighLevelState(npcAgents[i].unit, gamedataNPCHighLevelState.Relaxed);
            StatusEffectHelper.ApplyStatusEffect(npcAgents[i].unit, t"PreventionStatusEffect.OnStarDropToZero");
            ScriptedPuppet.RevokeAllTicketsForPrevention(npcAgents[i].unit);
            StatusEffectHelper.ApplyStatusEffect(npcAgents[i].unit, t"BaseStatusEffect.MemoryWipeLevel2Police");
          };
          i += 1;
        };
        this.SendDropPointLockRequest(true);
        this.RemovePreventionInputLockRequest();
        this.m_reconDeployed = false;
        this.m_reconDestroyed = false;
        this.m_shouldPreventionUnitsStartRetreating = false;
        this.m_codeRedReinforcement = false;
        this.CancelAllIntervalCallers();
        this.TogglePreventionGlobalQuestObjective_Internal(false, n"prevention_state_managed_by_quest_generic");
        break;
      case EPreventionHeatStage.Heat_1:
        this.m_firstStarTimeStamp = EngineTime.ToFloat(GameInstance.GetSimTime(this.GetGameInstance()));
        rammingTime = 1.00 * agressivenessMultiplier;
        GameInstance.GetVehicleSystem(this.GetGame()).SetRammingUponCollisionDuration(rammingTime);
        GameInstance.GetVehicleSystem(this.GetGame()).SetSuicideSpeedChancePercentage(0.00);
        GameInstance.GetAudioSystem(this.GetGame()).Play(n"gmp_ui_prevention_player_commit_crime");
        break;
      case EPreventionHeatStage.Heat_2:
        rammingTime = 1.50 * agressivenessMultiplier;
        GameInstance.GetVehicleSystem(this.GetGame()).SetRammingUponCollisionDuration(rammingTime);
        GameInstance.GetVehicleSystem(this.GetGame()).SetSuicideSpeedChancePercentage(0.00);
        GameInstance.GetAudioSystem(this.GetGame()).Play(n"gmp_ui_prevention_player_commit_crime");
        break;
      case EPreventionHeatStage.Heat_3:
        rammingTime = 2.00 * agressivenessMultiplier;
        GameInstance.GetVehicleSystem(this.GetGame()).SetRammingUponCollisionDuration(rammingTime);
        GameInstance.GetVehicleSystem(this.GetGame()).SetSuicideSpeedChancePercentage(0.03);
        GameInstance.GetAudioSystem(this.GetGame()).Play(n"gmp_ui_prevention_player_commit_crime");
        this.TryStartRoadblockRespawn();
        break;
      case EPreventionHeatStage.Heat_4:
        rammingTime = 2.50 * agressivenessMultiplier;
        GameInstance.GetVehicleSystem(this.GetGame()).SetRammingUponCollisionDuration(rammingTime);
        GameInstance.GetVehicleSystem(this.GetGame()).SetSuicideSpeedChancePercentage(0.05);
        GameInstance.GetAudioSystem(this.GetGame()).Play(n"gmp_ui_prevention_player_commit_crime");
        this.TryStartRoadblockRespawn();
        this.WakeUpAllAgents(true);
        break;
      case EPreventionHeatStage.Heat_5:
        this.m_numberOfMaxtacSquadsSpawned = 0;
        rammingTime = 3.00 * agressivenessMultiplier;
        GameInstance.GetVehicleSystem(this.GetGame()).SetRammingUponCollisionDuration(rammingTime);
        GameInstance.GetVehicleSystem(this.GetGame()).SetSuicideSpeedChancePercentage(0.25);
        GameInstance.GetAudioSystem(this.GetGame()).Play(n"gmp_ui_prevention_player_marked_psycho");
        this.TryStartRoadblockRespawn();
        this.WakeUpAllAgents(true);
        this.ProcessDogtownLawAchievement();
    };
    this.UpdateStrategyPreCheckRequests();
    if this.IsChasingPlayer() {
      this.m_heatLevelChanged = true;
      this.TryInitializePreventionTick();
      this.TryStartVehicleRespawn();
      this.TryRessuplyVehicleTickets();
      GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).TogglePreventionActive(true);
      this.m_currentVehicleTicketCount = this.m_preventionDataTable.VehicleTicketsAmount();
      GameInstance.GetVehicleSystem(this.GetGame()).SetChaseManagerLimit(this.m_preventionDataTable.SpawnedEngagedCars());
      if !this.m_ignoreSecurityAreas && ArraySize(this.m_playerIsInSecurityArea) > 0 {
        this.ReevaluateSecurityAreaReset();
      };
      this.ChangeAgentsAttitude(EAIAttitude.AIA_Hostile);
      this.PreventionMinimapOverride();
      this.TutorialAddPoliceSystemFact();
      FastTravelSystem.AddFastTravelLock(n"PreventionSystem", this.GetGameInstance());
      this.SendDropPointLockRequest(false);
      this.SpawnPipeline();
    };
    if !IsFinal() {
      this.RefreshDebug();
    };
  }

  private final func TryRessuplyVehicleTickets() -> Void {
    this.m_ressuplyVehicleTicketCaller.Start(this.m_preventionDataTable.VehicleTicketCooldown(), new ResupplyVehicleTicketsRequest());
  }

  private final func TryStartVehicleRespawn() -> Void {
    this.m_vehicleSpawnTickCaller.Start(this.m_preventionDataTable.VehicleSpawnCooldown(), new SpawnPoliceVehicleWithDelayRequest());
  }

  private final func TryStartRoadblockRespawn() -> Void {
    this.m_roadblockadeRespawnTickCaller.Start(this.m_preventionDataTable.RoadblockT1Cooldown(), new SpawnRoadblockadeWithDelayRequest());
  }

  private final func TryInitializePreventionTick() -> Void {
    if !this.m_preventionTickCaller.IsRunning() {
      this.m_preventionTickCaller.Start(0.33, new PreventionTickRequest());
      this.m_isInitialSearchState = true;
    };
  }

  private final func TutorialAddPoliceSystemFact() -> Void {
    let questSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.GetGameInstance());
    if questSystem.GetFact(n"police_system_tutorial") == 0 && questSystem.GetFact(n"disable_tutorials") == 0 {
      questSystem.SetFact(n"police_system_tutorial", 1);
    };
  }

  private final func SpawnPipeline() -> Void {
    if !this.CanPreventionReactToInput() {
      return;
    };
    this.TryRequestVehicleSpawnWithStrategy();
  }

  private final func TrySpawnPoliceOnFootFallback() -> Void {
    let characterRecordIDs: array<TweakDBID>;
    let hasRecon: Bool;
    let minUnitCount: Int32;
    let spawnInterval: Float;
    let spawnOriginsPositions: array<Vector4>;
    let spawnRange: Vector2;
    let unitCount: Uint32;
    if !IsDefined(this.m_player) || this.m_blockOnFootSpawnByQuest || this.m_isPlayerMounted {
      return;
    };
    if !this.m_policeKnowsPlayerLocation && !this.m_canSpawnFallbackEarly && !this.m_forceEternalGreyStars {
      return;
    };
    if this.m_agentRegistry.GetPendingFallbackOnFootTicketCount() > 0 {
      return;
    };
    if this.GetDataTableForCurrentHeat(this.GetHeatStage(), characterRecordIDs, spawnRange, unitCount, spawnInterval, hasRecon) {
      minUnitCount = Min(this.m_preventionDataTable.MaxUnitCount() - this.m_agentRegistry.GetTotalNPCCount() + this.m_preventionDataTable.MaxUnitFallbackCount(), this.m_preventionDataTable.MaxUnitFallbackCount() - this.m_agentRegistry.GetFallbackNPCCount());
      if Min(minUnitCount, Cast<Int32>(unitCount)) <= 0 {
        return;
      };
      unitCount = Cast<Uint32>(Min(minUnitCount, Cast<Int32>(unitCount)));
      this.GetFindSpawnPointsOriginsData(spawnOriginsPositions);
      GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).FindPursuitPointsRangeAsync(spawnOriginsPositions, spawnRange.X, spawnRange.Y, unitCount, characterRecordIDs, true, NavGenAgentSize.Human, this, "SpawnFallbackUnits");
    };
  }

  private final func SpawnFallbackUnits(const spawnPoints: [Vector3], const characterRecords: [TweakDBID], unitCount: Uint32) -> Int32 {
    let sentRequests: Int32;
    if this.SpawnUnits(spawnPoints, characterRecords, unitCount, sentRequests) {
      if sentRequests >= Cast<Int32>(unitCount) {
        this.m_failedVehicleSpawnAttempts = 0;
        return sentRequests;
      };
    };
    return sentRequests;
  }

  private final func SpawnUnits(const spawnPoints: script_ref<[Vector3]>, const characterRecords: script_ref<[TweakDBID]>, unitCount: Uint32, out sentRequests: Int32) -> Bool {
    let currentRecordIdx: Int32;
    let i: Int32;
    let lastRecordIdx: Int32;
    let spawnTransform: WorldTransform;
    if ArraySize(Deref(spawnPoints)) > 0 {
      lastRecordIdx = ArraySize(Deref(characterRecords)) - 1;
      i = 0;
      while i < ArraySize(Deref(spawnPoints)) {
        WorldTransform.SetPosition(spawnTransform, Cast<Vector4>(Deref(spawnPoints)[i]));
        WorldTransform.SetOrientationFromDir(spawnTransform, Vector4.Normalize2D(this.m_player.GetWorldPosition() - Cast<Vector4>(Deref(spawnPoints)[i])));
        this.RequestUnitSpawn(Deref(characterRecords)[currentRecordIdx], spawnTransform);
        sentRequests += 1;
        if currentRecordIdx < lastRecordIdx {
          currentRecordIdx += 1;
        };
        if sentRequests >= Cast<Int32>(unitCount) {
          return true;
        };
        i += 1;
      };
      return true;
    };
    return false;
  }

  private final func ReachedEngagedVehiclesLimit() -> Bool {
    return this.GetAgentRegistry().GetEngagedVehicleCount() >= this.m_preventionDataTable.SpawnedEngagedCars();
  }

  private final func ReachedSupportVehiclesLimit() -> Bool {
    return this.GetAgentRegistry().GetSupportVehicleCount() >= this.m_preventionDataTable.SpawnedSupportCars();
  }

  private final func ReachedTotalVehiclesLimit() -> Bool {
    let totalVehicles: Int32 = this.GetAgentRegistry().GetSupportVehicleCount() + this.GetAgentRegistry().GetEngagedVehicleCount() + this.m_agentRegistry.GetPendingVehicleTicketsCount();
    let totalVehicleLimit: Int32 = Max(this.m_preventionDataTable.SpawnedEngagedCars(), this.m_preventionDataTable.SpawnedSupportCars());
    return totalVehicles >= totalVehicleLimit;
  }

  private final func ShouldSpawnRoadblockade() -> Bool {
    if !this.IsChasingPlayer() || this.m_blockVehicleSpawnByQuest {
      return false;
    };
    if !VehicleComponent.IsMountedToVehicle(this.GetGame(), GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerControlledGameObject()) {
      return false;
    };
    if Equals(this.GetStarState(), EStarState.Blinking) {
      return false;
    };
    if this.ReachedRoadblockLimit() {
      return false;
    };
    return true;
  }

  private final func ReachedRoadblockLimit() -> Bool {
    let limitReached: Bool = this.GetAgentRegistry().GetRoadblockCount() >= this.m_preventionDataTable.RoadblockT1TicketAmount();
    return limitReached;
  }

  private final func GetNewBatchMaxTacSpawnPositions() -> Void {
    if this.m_maxtacTicketID != 0u {
      return;
    };
    this.m_maxtacTicketID = GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).RequestAVSpawnPoints(this, "TryGetAVSpawnPointsCallback", this.m_preventionDataTable.AvSpawnRange(), Cast<Uint32>(this.m_preventionDataTable.AvSpawnPointsPerRequest()), this.UseOffTrafficPoints());
    this.m_agentRegistry.CreateTicket(this.m_maxtacTicketID, vehiclePoliceStrategy.None);
  }

  private final func UseOffTrafficPoints() -> Bool {
    if IsDefined(this.m_districtManager) {
      return !this.m_districtManager.GetCurrentDistrict().IsBadlands();
    };
    return false;
  }

  private final func TryGetAVSpawnPointsCallback(requestResult: AVSpawnPointsRequestResult) -> Void {
    if this.m_maxtacTicketID == requestResult.requestID {
      this.m_maxtacTicketID = 0u;
    };
    this.m_agentRegistry.PopRequestTicket(requestResult.requestID);
    if ArraySize(requestResult.spawnPoints) != 0 {
      this.m_avSpawnPointList = requestResult.spawnPoints;
    };
  }

  private final func RequestAVSpawnAtPosition(position: Vector3) -> Void {
    let randomValue: Int32;
    let ticketID: Uint32;
    let tweakId: TweakDBID;
    let request: ref<RemoveRecentAvSpawnLocationFromCacheRequest> = new RemoveRecentAvSpawnLocationFromCacheRequest();
    PreventionSystemHackerLoop.ForceCarToStop(this.GetGame());
    this.m_numberOfMaxtacSquadsSpawned += 1;
    randomValue = RandRange(1, 4);
    switch randomValue {
      case 1:
        tweakId = this.m_numberOfMaxtacSquadsSpawned == 1 ? t"Vehicle.max_tac_av1" : t"Vehicle.max_tac_av_2nd_wave1";
        break;
      case 2:
        tweakId = this.m_numberOfMaxtacSquadsSpawned == 1 ? t"Vehicle.max_tac_av2" : t"Vehicle.max_tac_av_2nd_wave2";
        break;
      case 3:
        tweakId = this.m_numberOfMaxtacSquadsSpawned == 1 ? t"Vehicle.max_tac_av3" : t"Vehicle.max_tac_av_2nd_wave3";
        break;
      default:
        tweakId = this.m_numberOfMaxtacSquadsSpawned == 1 ? t"Vehicle.max_tac_av1" : t"Vehicle.max_tac_av_2nd_wave";
    };
    ticketID = GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).RequestAVSpawnAtLocation(tweakId, position);
    this.m_agentRegistry.CreateTicket(ticketID, vehiclePoliceStrategy.None);
    ArrayPush(this.m_lastAVRequestedSpawnPositionsArray, Cast<Vector4>(position));
    this.Debug_lastAVRequestedSpawnPosition = position;
    this.m_shouldPreventionUnitsStartRetreating = true;
    PreventionSystem.QueueRequest(this.GetGameInstance(), request, 60.00);
  }

  private final func OnRemoveRecentAvSpawnLocationFromCacheRequest(req: ref<RemoveRecentAvSpawnLocationFromCacheRequest>) -> Void {
    if ArraySize(this.m_lastAVRequestedSpawnPositionsArray) > 0 {
      ArrayErase(this.m_lastAVRequestedSpawnPositionsArray, 0);
    };
  }

  private final func SpawnRoadblockade(heatStage: EPreventionHeatStage) -> Void {
    let passengerIDs: array<TweakDBID>;
    let spawnDistanceRange: Vector2;
    let ticketID: Uint32;
    let vehicleIDs: array<TweakDBID>;
    let vehicleRecord: wref<Vehicle_Record>;
    if this.TryGetRoadblockDataFromHeatStage(heatStage, vehicleRecord, spawnDistanceRange) && this.TryGetDistinctUnitDataFromHeatStage(passengerIDs) {
      ArrayPush(vehicleIDs, vehicleRecord.GetID());
      ticketID = GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).RequestRoadBlockadeSpawn(vehicleIDs, spawnDistanceRange, 2u);
      this.m_agentRegistry.CreateTicket(ticketID, vehiclePoliceStrategy.None);
    };
  }

  private final func UpdateStrategyPreCheckRequests() -> Void {
    let preCheckRequests: array<ref<BaseStrategyRequest>>;
    let isChasingPlayer: Bool = this.IsChasingPlayer();
    if !isChasingPlayer {
      GameInstance.GetPreventionSpawnSystem(this.GetGame()).ClearStrategyPreCheckRequests();
    };
    if this.IsChasingPlayer() || !IsFinal() {
      ArrayPush(preCheckRequests, this.CreateStrategyRequest(vehiclePoliceStrategy.DriveTowardsPlayer));
      ArrayPush(preCheckRequests, this.CreateStrategyRequest(vehiclePoliceStrategy.DriveAwayFromPlayer));
      ArrayPush(preCheckRequests, this.CreateStrategyRequest(vehiclePoliceStrategy.PatrolNearby));
      ArrayPush(preCheckRequests, this.CreateStrategyRequest(vehiclePoliceStrategy.InterceptAtNextIntersection));
      ArrayPush(preCheckRequests, this.CreateStrategyRequest(vehiclePoliceStrategy.GetToPlayerFromAnywhere));
      ArrayPush(preCheckRequests, this.CreateStrategyRequest(vehiclePoliceStrategy.InitialSearch));
      ArrayPush(preCheckRequests, this.CreateStrategyRequest(vehiclePoliceStrategy.SearchFromAnywhere));
      GameInstance.GetPreventionSpawnSystem(this.GetGame()).SetStrategyPreCheckRequests(preCheckRequests);
    };
  }

  private final const func IsStrategyAvailable(strategy: vehiclePoliceStrategy) -> Bool {
    return GameInstance.GetPreventionSpawnSystem(this.GetGame()).IsStrategyAvailable(strategy);
  }

  private final func IsDistanceRangeValid(range: Vector2) -> Bool {
    return range.X >= 0.00 && range.Y >= 0.00;
  }

  private final func SelectRange(strategyDataRec: wref<StrategyData_Record>) -> Vector2 {
    if GameInstance.GetPreventionSpawnSystem(this.GetGame()).IsPlayerOnHighway() && this.IsDistanceRangeValid(strategyDataRec.VehicleSpawnDistanceRangeHighway()) {
      return strategyDataRec.VehicleSpawnDistanceRangeHighway();
    };
    if !this.m_isPlayerMounted && this.IsDistanceRangeValid(strategyDataRec.VehicleSpawnDistanceRangeOnFoot()) {
      return strategyDataRec.VehicleSpawnDistanceRangeOnFoot();
    };
    return strategyDataRec.VehicleSpawnDistanceRange();
  }

  private final func CreateStrategyRequest(strategy: vehiclePoliceStrategy) -> ref<BaseStrategyRequest> {
    if Equals(strategy, vehiclePoliceStrategy.DriveTowardsPlayer) {
      return DriveTowardsPlayerStrategyRequest.Create(this.m_preventionDataTable.Strategy1().VehicleSpawnDistanceRange(), this.m_preventionDataTable.Strategy1().MinDirectDistance());
    };
    if Equals(strategy, vehiclePoliceStrategy.DriveAwayFromPlayer) {
      return DriveAwayFromPlayerStrategyRequest.Create(this.m_preventionDataTable.Strategy2().VehicleSpawnDistanceRange(), this.m_preventionDataTable.Strategy2().MinDirectDistance());
    };
    if Equals(strategy, vehiclePoliceStrategy.PatrolNearby) {
      return PatrolNearbyStrategyRequest.Create(this.m_preventionDataTable.Strategy3().VehicleSpawnDistanceRange(), this.m_preventionDataTable.Strategy3().VehicleSpawnAngleRange());
    };
    if Equals(strategy, vehiclePoliceStrategy.InterceptAtNextIntersection) {
      return InterceptAtNextIntersectionStrategyRequest.Create(this.m_preventionDataTable.Strategy4().VehicleSpawnDistanceRange(), this.m_preventionDataTable.Strategy4().MinDirectDistance());
    };
    if Equals(strategy, vehiclePoliceStrategy.GetToPlayerFromAnywhere) {
      return GetToPlayerFromAnywhereStrategyRequest.Create(this.m_preventionDataTable.Strategy5().VehicleSpawnDistanceRange(), this.m_preventionDataTable.Strategy5().MinDirectDistance());
    };
    if Equals(strategy, vehiclePoliceStrategy.InitialSearch) {
      return InitialSearchStrategyRequest.Create(this.SelectRange(this.m_preventionDataTable.Strategy6()), this.m_preventionDataTable.Strategy6().MinDirectDistance());
    };
    return SearchFromAnywhereStrategyRequest.Create(this.SelectRange(this.m_preventionDataTable.Strategy7()), this.m_preventionDataTable.Strategy7().VehicleSpawnAngleRange());
  }

  private final func SpawnPoliceVehicle() -> Uint32 {
    let passengerIDs: array<TweakDBID>;
    let passengersCount: Int32;
    let strategy: vehiclePoliceStrategy;
    let strategyRequest: ref<BaseStrategyRequest>;
    let vehicleRecord: wref<Vehicle_Record>;
    let wantedStrategies: array<vehiclePoliceStrategy>;
    let preventionSpawnSystem: ref<PreventionSpawnSystem> = GameInstance.GetPreventionSpawnSystem(this.GetGameInstance());
    let ticketID: Uint32 = 0u;
    let canVehicleTryToBeInFront: Bool = RandF() < 0.60;
    let strat7Available: Bool = this.IsStrategyAvailable(vehiclePoliceStrategy.SearchFromAnywhere);
    let playerOnHighway: Bool = preventionSpawnSystem.IsPlayerOnHighway();
    if !this.TryGetVehicleDataFromHeatStage(this.GetHeatStage(), vehicleRecord) || !preventionSpawnSystem.IsAnyStrategyAvailable() {
      return ticketID;
    };
    if !this.TrySpawnOnFootFallbackBasedOnRoadInfo(preventionSpawnSystem) {
      return ticketID;
    };
    if this.IsAnyVehicleChasingTarget() && this.m_isPlayerMounted {
      ArrayPush(wantedStrategies, vehiclePoliceStrategy.DriveTowardsPlayer);
      ArrayPush(wantedStrategies, vehiclePoliceStrategy.DriveAwayFromPlayer);
      ArrayPush(wantedStrategies, vehiclePoliceStrategy.InterceptAtNextIntersection);
      if playerOnHighway {
        ArrayPush(wantedStrategies, vehiclePoliceStrategy.SearchFromAnywhere);
      };
      if this.IsPursuedVehicleFast() {
        strategy = preventionSpawnSystem.GetRandomAvailableStrategy(wantedStrategies);
      };
      if Equals(strategy, vehiclePoliceStrategy.None) {
        ArrayPush(wantedStrategies, vehiclePoliceStrategy.PatrolNearby);
        strategy = preventionSpawnSystem.GetRandomAvailableStrategy(wantedStrategies);
      };
    } else {
      if this.m_codeRedReinforcement {
        this.m_codeRedReinforcement = false;
        strategy = preventionSpawnSystem.SetIfAvailable(vehiclePoliceStrategy.DriveTowardsPlayer);
      } else {
        if EnumInt(this.GetHeatStage()) > 1 && this.m_agentRegistry.IsPoliceInCombatWithPalyer() && !this.m_isPlayerMounted && !this.ShouldPreventionUnitsRetreat() {
          ArrayPush(wantedStrategies, vehiclePoliceStrategy.DriveTowardsPlayer);
          ArrayPush(wantedStrategies, vehiclePoliceStrategy.InterceptAtNextIntersection);
          if EnumInt(this.GetHeatStage()) > 2 {
            ArrayPush(wantedStrategies, vehiclePoliceStrategy.GetToPlayerFromAnywhere);
          };
          strategy = preventionSpawnSystem.GetRandomAvailableStrategy(wantedStrategies);
          if Equals(strategy, vehiclePoliceStrategy.None) || EnumInt(this.GetHeatStage()) >= 4 {
            strategy = preventionSpawnSystem.SetIfAvailable(vehiclePoliceStrategy.GetToPlayerFromAnywhere);
          };
        } else {
          if this.ShouldSpawnPatrolVehicleWhenInSearch() {
            strategy = preventionSpawnSystem.SetIfAvailable(vehiclePoliceStrategy.PatrolNearby);
          } else {
            ArrayPush(wantedStrategies, vehiclePoliceStrategy.InitialSearch);
            if playerOnHighway {
              ArrayPush(wantedStrategies, vehiclePoliceStrategy.DriveAwayFromPlayer);
              ArrayPush(wantedStrategies, vehiclePoliceStrategy.SearchFromAnywhere);
            };
            strategy = preventionSpawnSystem.GetRandomAvailableStrategy(wantedStrategies);
          };
        };
      };
    };
    if !canVehicleTryToBeInFront && !playerOnHighway && (Equals(strategy, vehiclePoliceStrategy.DriveTowardsPlayer) || Equals(strategy, vehiclePoliceStrategy.DriveAwayFromPlayer) || Equals(strategy, vehiclePoliceStrategy.InitialSearch)) {
      strategy = strat7Available ? vehiclePoliceStrategy.SearchFromAnywhere : strategy;
    };
    preventionSpawnSystem.DebugTryOverrideWithForcedStrategy(strategy);
    if Equals(strategy, vehiclePoliceStrategy.None) {
      if strat7Available && this.m_failedVehicleSpawnAttempts > 4 {
        strategy = vehiclePoliceStrategy.SearchFromAnywhere;
      } else {
        return ticketID;
      };
    };
    strategyRequest = this.CreateStrategyRequest(strategy);
    this.m_currentVehicleTicketCount = Max(0, this.m_currentVehicleTicketCount - 1);
    passengersCount = RandRange(vehicleRecord.MinVehiclePassengersCount(), vehicleRecord.MaxVehiclePassengersCount() + 1);
    this.TryGetUnitDataFromVehicleRecord(vehicleRecord, passengersCount, passengerIDs);
    ticketID = preventionSpawnSystem.RequestChaseVehicle(vehicleRecord.GetID(), passengerIDs, strategyRequest);
    this.m_agentRegistry.CreateTicket(ticketID, strategy);
    return ticketID;
  }

  private final func TrySpawnOnFootFallbackBasedOnRoadInfo(system: ref<PreventionSpawnSystem>) -> Bool {
    let heightAbs: Float;
    let roadInfo: NearestRoadFromPlayerInfo;
    let playerPos: Vector4 = this.m_player.GetWorldPosition();
    system.GetNearestRoadFromPlayerInfo(roadInfo);
    if Vector4.IsXYZZero(roadInfo.point) {
      return false;
    };
    heightAbs = AbsF(playerPos.Z - roadInfo.point.Z);
    if roadInfo.pathLength < 0.00 || roadInfo.pathLength >= this.m_preventionDataTable.FallbackMaxDistanceToRoad() || heightAbs >= this.m_preventionDataTable.FallbackMaxHeightDifference() && roadInfo.pathLength >= this.m_preventionDataTable.FallbackMaxDistanceForHeight() {
      this.TrySpawnPoliceOnFootFallback();
    };
    return true;
  }

  private final func IsPursuedVehicleFast() -> Bool {
    let speed: Float;
    let vehicle: wref<VehicleObject>;
    if VehicleComponent.GetVehicle(this.GetGameInstance(), GetPlayer(this.GetGameInstance()), vehicle) {
      speed = vehicle.GetCurrentSpeed();
      return speed > 30.00;
    };
    return false;
  }

  public final static func SetSpawnCodeRedReinforcement(game: GameInstance, shouldSpawnReinforcement: Bool) -> Void {
    let ps: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(game).Get(n"PreventionSystem") as PreventionSystem;
    ps.m_codeRedReinforcement = shouldSpawnReinforcement;
  }

  private final func DespawnAllPolice(useAggressiveDespawn: Bool) -> Void {
    GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).RequestDespawnAll(useAggressiveDespawn);
  }

  public final static func ShowMessage(gameInstance: GameInstance, const message: script_ref<String>, time: Float) -> Void {
    let warningMsg: SimpleScreenMessage;
    warningMsg.isShown = true;
    warningMsg.duration = time;
    warningMsg.message = Deref(message);
    GameInstance.GetBlackboardSystem(gameInstance).Get(GetAllBlackboardDefs().UI_Notifications).SetVariant(GetAllBlackboardDefs().UI_Notifications.WarningMessage, ToVariant(warningMsg), true);
  }

  private final func OnRefreshDistrict(request: ref<RefreshDistrictRequest>) -> Void {
    if !IsDefined(request.preventionPreset) {
      this.RestoreDefaultPreset();
    } else {
      this.m_preventionPreset = request.preventionPreset;
    };
    if !IsFinal() {
      this.RefreshDebugDistrictInfo();
    };
  }

  private final func RestoreDefaultConfig() -> Void {
    this.RestoreDefaultPreset();
  }

  private final func UpdateVehicles() -> Void {
    let i: Int32;
    let vehicleAgents: array<ref<VehicleAgent>>;
    this.m_agentRegistry.GetVehiclesWithoutRegisteredPassengers(vehicleAgents);
    i = ArraySize(vehicleAgents) - 1;
    while i >= 0 {
      GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).MarkAsDead(vehicleAgents[i].id);
      i -= 1;
    };
    ArrayClear(vehicleAgents);
    vehicleAgents = this.m_agentRegistry.GetVehicleList();
    i = ArraySize(vehicleAgents) - 1;
    while i >= 0 {
      vehicleAgents[i].UpdateLifetimeStatus(this.m_player.GetWorldPosition());
      i -= 1;
    };
  }

  private final func UpdateNPCs() -> Void {
    let npcAgents: array<ref<NPCAgent>> = this.m_agentRegistry.GetNPCList();
    let i: Int32 = ArraySize(npcAgents) - 1;
    while i >= 0 {
      if !this.IsNPCValid(npcAgents[i].unit) {
        this.UnregisterPreventionUnit(npcAgents[i].id);
        GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).MarkAsDead(npcAgents[i].id);
      };
      i -= 1;
    };
  }

  protected final func OnViewerRequest(request: ref<PreventionVisibilityRequest>) -> Void {
    if !IsDefined(this.m_player) {
      return;
    };
    if request.seePlayer {
      this.ViewerRegister(request.requester);
      this.SetLastKnownPlayerPosition(this.m_player.GetWorldPosition());
    } else {
      this.ViewerUnRegister(request.requester);
    };
  }

  protected final func OnVehicleStolenRequest(request: ref<PreventionVehicleStolenRequest>) -> Void {
    if !this.CanPreventionReactToInput() {
      return;
    };
    if NotEquals(request.vehicleAffiliation, gamedataAffiliation.NCPD) {
      return;
    };
    if !this.IsChasingPlayer() {
      this.HeatPipeline("PlayerStoleVehicle");
    } else {
      this.UpdateStarState();
    };
  }

  protected final func OnCombatStartedRequest(request: ref<PreventionCombatStartedRequest>) -> Void {
    if !this.CanPreventionReactToInput() {
      return;
    };
    if !this.IsChasingPlayer() {
      this.HeatPipeline("EnterCombat");
    };
    this.m_policeKnowsPlayerLocation = true;
    this.UpdateStarState();
    this.SetLastKnownPlayerPosition(request.requesterPosition);
  }

  protected final func OnCrimeWitnessRequest(request: ref<PreventionCrimeWitnessRequest>) -> Void {
    if !this.CanPreventionReactToInput() {
      return;
    };
    if !this.IsChasingPlayer() {
      this.HeatPipeline("CrimeWitness");
    } else {
      this.UpdateStarState();
    };
    this.SetLastKnownPlayerPosition(request.criminalPosition);
  }

  private final func UpdateViewers() -> Bool {
    let i: Int32;
    if ArraySize(this.m_viewers) <= 0 {
      this.HasViewersChanged(false);
      return false;
    };
    i = ArraySize(this.m_viewers) - 1;
    while i >= 0 {
      if !IsDefined(this.m_viewers[i]) || !this.m_viewers[i].IsActive() {
        ArrayErase(this.m_viewers, i);
      };
      i -= 1;
    };
    this.HasViewersChanged(true);
    return true;
  }

  private final func HasViewersChanged(currentViewerState: Bool) -> Void {
    if NotEquals(currentViewerState, this.m_hasViewers) {
      this.m_hasViewers = currentViewerState;
      this.OnViewersStateChanged();
    };
  }

  private final func OnViewersStateChanged() -> Void {
    if this.AreTurretsActive() {
      this.SetAgentsSupport(this.m_hasViewers);
    };
  }

  private final func ViewerRegister(viewer: wref<GameObject>) -> Void {
    if !IsDefined(viewer) {
      return;
    };
    this.SetLastKnownPlayerPosition(this.m_player.GetWorldPosition());
    if !ArrayContains(this.m_viewers, viewer) {
      ArrayPush(this.m_viewers, viewer);
    };
  }

  private final func ViewerUnRegister(viewer: wref<GameObject>) -> Void {
    ArrayRemove(this.m_viewers, viewer);
  }

  protected final func OnRegisterRequest(request: ref<PreventionRegisterRequest>) -> Void {
    if request.register {
      this.Register(request.attitudeGroup, request.requester);
    } else {
      this.UnRegister(request.attitudeGroup, request.requester);
    };
  }

  private final func Register(attitudeGroup: CName, ps: wref<PersistentState>) -> Void {
    let newGroup: ref<PreventionAgents>;
    let i: Int32 = 0;
    while i < ArraySize(this.m_agentGroupsList) {
      if Equals(this.m_agentGroupsList[i].GetGroupName(), attitudeGroup) {
        if !this.m_agentGroupsList[i].IsAgentalreadyAdded(ps) {
          this.m_agentGroupsList[i].AddAgent(ps);
        };
        if this.AreTurretsActive() {
          this.WakeUpAgent(ps, true);
        } else {
          this.WakeUpAgent(ps, false);
        };
        return;
      };
      i += 1;
    };
    if IsNameValid(attitudeGroup) {
      newGroup = new PreventionAgents();
      newGroup.CreateGroup(attitudeGroup, ps);
      ArrayPush(this.m_agentGroupsList, newGroup);
    };
  }

  private final func UnRegister(attitudeGroup: CName, ps: wref<PersistentState>) -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.m_agentGroupsList) {
      if Equals(this.m_agentGroupsList[i].GetGroupName(), attitudeGroup) {
        this.m_agentGroupsList[i].RemoveAgent(ps);
        if !this.m_agentGroupsList[i].HasAgents() {
          ArrayErase(this.m_agentGroupsList, i);
          break;
        };
      };
      i += 1;
    };
  }

  protected final func OnPreventionSecurityAreaRequest(request: ref<PreventionSecurityAreaRequest>) -> Void {
    if request.playerIsIn {
      if !ArrayContains(this.m_playerIsInSecurityArea, request.areaID) {
        ArrayPush(this.m_playerIsInSecurityArea, request.areaID);
      };
    } else {
      if ArrayContains(this.m_playerIsInSecurityArea, request.areaID) {
        ArrayRemove(this.m_playerIsInSecurityArea, request.areaID);
      };
    };
    this.ReevaluateSecurityAreaReset();
    if !IsFinal() {
      this.RefreshDebugSecAreaInfo();
    };
  }

  protected final func OnPreventionPoliceSecuritySystemRequest(request: ref<PreventionPoliceSecuritySystemRequest>) -> Void {
    let removeFromBlacklist: ref<RemoveFromBlacklistEvent>;
    if !ArrayContains(this.m_policeSecuritySystems, request.securitySystemID) {
      ArrayPush(this.m_policeSecuritySystems, request.securitySystemID);
      if IsDefined(this.m_player) && !this.IsChasingPlayer() {
        removeFromBlacklist = new RemoveFromBlacklistEvent();
        removeFromBlacklist.entityIDToRemove = this.m_player.GetEntityID();
        removeFromBlacklist.isPlayerEntity = true;
        GameInstance.GetPersistencySystem(this.GetGame()).QueuePSEvent(request.securitySystemID, n"SecuritySystemControllerPS", removeFromBlacklist);
      };
    };
  }

  public final const func ShouldReactionBeAggressive() -> Bool {
    if this.IsChasingPlayer() {
      return true;
    };
    if !this.m_ignoreSecurityAreas && ArraySize(this.m_playerIsInSecurityArea) > 0 {
      return false;
    };
    if !this.CanPreventionReactToInput() {
      return false;
    };
    return true;
  }

  public final static func NotifyVehicleExplosion(veh: ref<VehicleObject>) -> Void {
    let preventionSystem: ref<PreventionSystem> = veh.GetPreventionSystem();
    if IsDefined(preventionSystem) {
      preventionSystem.OnVehicleExplosion();
    };
  }

  private final func OnVehicleExplosion() -> Void {
    let now: Float = EngineTime.ToFloat(GameInstance.GetSimTime(this.GetGame()));
    if this.IsChasingPlayer() {
      return;
    };
    if this.m_lastCivilianVehicleDestructionTimeStamp >= 0.00 && now - this.m_lastCivilianVehicleDestructionTimeStamp > this.m_civilianVehicleDestructionTimeout {
      this.m_lastCivilianVehicleDestructionTimeStamp = -1.00;
      this.m_civilianVehicleDestructionCount = 0;
    };
    this.m_lastCivilianVehicleDestructionTimeStamp = now;
    this.m_civilianVehicleDestructionCount += 1;
    if this.m_civilianVehicleDestructionCount >= this.m_civilianVehicleDestructionThreshold {
      this.HeatPipeline("CivilianVehicleDestroyed");
    } else {
      if !IsFinal() {
        this.RefreshDebug();
      };
    };
  }

  public final static func ShouldReactionBeAgressive(game: GameInstance) -> Bool {
    let preventionSystem: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(game).Get(n"PreventionSystem") as PreventionSystem;
    if IsDefined(preventionSystem) {
      return preventionSystem.ShouldReactionBeAggressive();
    };
    return true;
  }

  public final static func CanPreventionReact(game: GameInstance) -> Bool {
    let preventionSystem: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(game).Get(n"PreventionSystem") as PreventionSystem;
    if IsDefined(preventionSystem) {
      return preventionSystem.CanPreventionReactToInput();
    };
    return true;
  }

  public final static func GetDamageReactionThreshold() -> Float {
    return 0.01;
  }

  public final static func CreateNewPreventionDamageRequest(context: GameInstance, target: ref<GameObject>, attackTime: Float, attackType: gamedataAttackType, damageDealt: Float, isTargetKilled: Bool) -> Void {
    let request: ref<PreventionDamage> = new PreventionDamage();
    request.target = target;
    request.attackTime = attackTime;
    request.attackType = attackType;
    request.damageDealtPercent = damageDealt;
    request.isTargetKilled = isTargetKilled;
    GameInstance.GetScriptableSystemsContainer(context).Get(n"PreventionSystem").QueueRequest(request);
  }

  protected final func OnPreventionDamage(evt: ref<PreventionDamage>) -> Void {
    let preventionSystemRequest: ref<PreventionDamageRequest>;
    if PreventionSystem.ShouldPreventionSystemReactToAttack(evt.target, evt.attackTime, evt.isTargetKilled) {
      preventionSystemRequest = new PreventionDamageRequest();
      if IsDefined(evt.target) {
        preventionSystemRequest.targetID = evt.target.GetEntityID();
        preventionSystemRequest.targetPosition = evt.target.GetWorldPosition();
        preventionSystemRequest.isTargetPrevention = evt.target.IsPrevention();
        preventionSystemRequest.isTargetVehicle = evt.target.IsVehicle();
        preventionSystemRequest.isTargetKilled = evt.isTargetKilled;
        preventionSystemRequest.telemetryInfo = evt.GetTelemetryDescription();
      };
      preventionSystemRequest.attackType = evt.attackType;
      preventionSystemRequest.damageDealtPercentValue = evt.damageDealtPercent;
      this.ProcessPreventionDamageRequest(preventionSystemRequest);
    };
  }

  public final static func ShouldPreventionSystemReactToAttack(target: wref<GameObject>, attackTime: Float, istargetDefeated: Bool) -> Bool {
    let puppetTarget: wref<ScriptedPuppet>;
    let shouldReact: Bool;
    let system: ref<PreventionSystem>;
    let targetIDList: array<EntityID>;
    let vehicleTarget: wref<VehicleObject>;
    let targetID: EntityID = target.GetEntityID();
    if attackTime >= 0.00 {
      system = GameInstance.GetScriptableSystemsContainer(target.GetGame()).Get(n"PreventionSystem") as PreventionSystem;
      if system.GetLastAttackTime() != attackTime {
        system.SetLastAttackTime(attackTime);
        system.ClearLastAttackTargetIDs();
      };
      targetIDList = system.GetLastAttackTargetIDs();
      if !ArrayContains(targetIDList, targetID) {
        system.UpdateLastAttackTargetIDs(targetID);
        shouldReact = true;
      };
      if !shouldReact {
        return false;
      };
    };
    if target.IsPuppet() {
      puppetTarget = target as ScriptedPuppet;
      if puppetTarget.GetPuppetPS().IsPreventionNotified() {
        return false;
      };
      if istargetDefeated {
        puppetTarget.GetPuppetPS().SetIsPreventionNotified(true);
      };
      if NPCManager.HasTag(puppetTarget.GetRecordID(), n"DoNotTriggerPrevention") {
        return false;
      };
      if puppetTarget.IsCrowd() || puppetTarget.IsVendor() || puppetTarget.IsCharacterCivilian() || puppetTarget.IsPrevention() || NPCManager.HasTag(puppetTarget.GetRecordID(), n"TriggerPrevention") {
        return true;
      };
    } else {
      if target.IsVehicle() {
        vehicleTarget = target as VehicleObject;
        if vehicleTarget.IsDestroyed() {
          return false;
        };
        if vehicleTarget.IsPrevention() || vehicleTarget.HasPassengers() {
          return true;
        };
      };
    };
    return false;
  }

  public final static func ShouldPreventionSystemReactToDamageDealt(puppet: wref<ScriptedPuppet>) -> Bool {
    if !IsDefined(puppet) || !puppet.IsActive() {
      return false;
    };
    if puppet.IsPrevention() || NPCManager.HasTag(puppet.GetRecordID(), n"TriggerPrevention") {
      return true;
    };
    return false;
  }

  public final static func ShouldPreventionSystemReactToCombat(puppet: wref<ScriptedPuppet>) -> Bool {
    if !IsDefined(puppet) || puppet.IsIncapacitated() {
      return false;
    };
    if puppet.IsPrevention() || NPCManager.HasTag(puppet.GetRecordID(), n"TriggerPrevention") {
      return true;
    };
    return false;
  }

  protected cb func OnPlayerChoice(value: Variant) -> Bool {
    let attemptedChoice: InteractionAttemptedChoice = FromVariant<InteractionAttemptedChoice>(value);
    if attemptedChoice.isSuccess && Equals(attemptedChoice.visualizerType, EVisualizerType.Dialog) && !attemptedChoice.choice.doNotTurnOffPreventionSystem {
      this.execInstructionSafe("PlayerChoice");
    };
  }

  private final func OnDistrictAreaEntered(request: ref<DistrictEnteredEvent>) -> Void {
    let currentDistrict: wref<District>;
    if IsDefined(this.m_districtManager) {
      this.m_districtManager.Update(request);
      currentDistrict = this.m_districtManager.GetCurrentDistrict();
      this.m_districtMultiplier = currentDistrict.GetCrimeMultiplier();
      PoliceRadioScriptSystem.UpdatePoliceRadioOnDistrictChange(this.GetGameInstance(), currentDistrict, this.m_heatStage);
      this.UpdateDataMatrixOnDistrictChange(currentDistrict);
    };
    if !IsFinal() {
      this.RefreshDebug();
    };
  }

  private final func SyncTweakDistrictData() -> Void {
    let currentDistrict: wref<District>;
    if IsDefined(this.m_districtManager) {
      currentDistrict = this.m_districtManager.GetCurrentDistrict();
      this.GetPreventionMatrixPresetForCurrentDistrict(currentDistrict);
      this.GetPreventionDataForCurrentDistrict(currentDistrict);
    } else {
      this.RestoreDefaultPreventionMatrixPreset();
      this.RestoreDefaultPreset();
    };
  }

  private final func GetPreventionMatrixPresetForCurrentDistrict(district: wref<District>) -> Void {
    let questSystem: ref<QuestsSystem>;
    if !IsDefined(district) {
      this.RestoreDefaultPreventionMatrixPreset();
      return;
    };
    if district.IsDogTown() {
      this.m_preventionDataMatrix = TweakDBInterface.GetPreventionHeatDataMatrixRecord(t"PreventionData.DogTownDataMatrix");
      questSystem = GameInstance.GetQuestsSystem(this.GetGameInstance());
      if !IsDefined(questSystem) {
        return;
      };
      if questSystem.GetFact(n"mq304_city_scenes_active") == 1 {
        this.m_preventionDataMatrix = TweakDBInterface.GetPreventionHeatDataMatrixRecord(t"PreventionData.DogTown_Kurt_DataMatrix");
      } else {
        if questSystem.GetFact(n"mq304_bennett_prevention") == 1 {
          this.m_preventionDataMatrix = TweakDBInterface.GetPreventionHeatDataMatrixRecord(t"PreventionData.DogTown_Bennet_DataMatrix");
        };
      };
      this.m_wantedBarBlackboard.SetBool(GetAllBlackboardDefs().UI_WantedBar.IsDogtown, true, true);
    } else {
      this.m_preventionDataMatrix = TweakDBInterface.GetPreventionHeatDataMatrixRecord(t"PreventionData.NCPDDataMatrix");
      this.m_wantedBarBlackboard.SetBool(GetAllBlackboardDefs().UI_WantedBar.IsDogtown, false, true);
    };
  }

  private final func GetPreventionDataForCurrentDistrict(district: wref<District>) -> Void {
    if !IsDefined(district) {
      this.RestoreDefaultPreset();
      return;
    };
    TweakDBInterface.GetDistrictPreventionDataRecord(district.GetPresetID());
  }

  private final func RestoreDefaultPreventionMatrixPreset() -> Void {
    this.m_preventionDataMatrix = TweakDBInterface.GetPreventionHeatDataMatrixRecord(t"PreventionData.NCPDDataMatrix");
  }

  private final func RestoreDefaultPreset() -> Void {
    this.m_preventionPreset = TweakDBInterface.GetDistrictPreventionDataRecord(t"PreventionData.NCPD");
  }

  private final func ChangeAgentsAttitude(desiredAffiliation: EAIAttitude) -> Void {
    let groupName: CName;
    let i: Int32;
    let playerAttitude: CName;
    let spawnedEntities: array<wref<Entity>>;
    let player: ref<GameObject> = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerMainGameObject();
    if !IsDefined(player) {
      return;
    };
    playerAttitude = player.GetAttitudeAgent().GetAttitudeGroup();
    GameInstance.GetAttitudeSystem(this.GetGameInstance()).SetAttitudeGroupRelationPersistent(n"police", playerAttitude, desiredAffiliation);
    i = 0;
    while i < ArraySize(this.m_agentGroupsList) {
      groupName = this.m_agentGroupsList[i].GetGroupName();
      if !CanChangeAttitudeRelationFor(groupName) {
      } else {
        GameInstance.GetAttitudeSystem(this.GetGameInstance()).SetAttitudeGroupRelationPersistent(groupName, playerAttitude, desiredAffiliation);
      };
      i += 1;
    };
    GameInstance.GetCompanionSystem(this.GetGameInstance()).GetSpawnedEntities(spawnedEntities);
    i = 0;
    while i < ArraySize(spawnedEntities) {
      this.ChangeAttitude(spawnedEntities[i] as GameObject, player, desiredAffiliation);
      i += 1;
    };
  }

  private final func ChangeAttitude(owner: wref<GameObject>, target: wref<GameObject>, desiredAttitude: EAIAttitude) -> Void {
    let attitudeOwner: ref<AttitudeAgent>;
    let attitudeTarget: ref<AttitudeAgent>;
    if !IsDefined(owner) || !IsDefined(target) {
      return;
    };
    attitudeOwner = owner.GetAttitudeAgent();
    attitudeTarget = target.GetAttitudeAgent();
    if !IsDefined(attitudeOwner) || !IsDefined(attitudeTarget) {
      return;
    };
    attitudeOwner.SetAttitudeTowards(attitudeTarget, desiredAttitude);
  }

  private final func WakeUpAllAgents(wakeUp: Bool) -> Void {
    let i1: Int32;
    let i: Int32 = 0;
    while i < ArraySize(this.m_agentGroupsList) {
      i1 = 0;
      while i1 < this.m_agentGroupsList[i].GetAgentsNumber() {
        this.WakeUpAgent(this.m_agentGroupsList[i].GetAgetntByIndex(i1), wakeUp);
        i1 += 1;
      };
      i += 1;
    };
  }

  private final func WakeUpAgent(ps: wref<PersistentState>, wakeUp: Bool) -> Void {
    let evt: ref<ReactoToPreventionSystem> = new ReactoToPreventionSystem();
    evt.wakeUp = wakeUp;
    GameInstance.GetPersistencySystem(this.GetGameInstance()).QueuePSEvent(ps.GetID(), ps.GetClassName(), evt);
    if wakeUp {
      this.SetSingleAgentSupport(ps, this.m_hasViewers);
    } else {
      this.SetSingleAgentSupport(ps, false);
    };
  }

  private final func ReevaluateSecurityAreaReset() -> Void {
    if this.m_ignoreSecurityAreasByQuest || this.m_forceEternalGreyStars {
      return;
    };
    if this.IsPlayerInQuestArea() {
      this.StartSecurityAreaResetRequest(2.00);
    };
  }

  private final func CancelAllDelayedEvents() -> Void {
    this.CancelTransitiontoGreyStateTimerRequest();
    this.CancelStateBufferTimerRequest();
    this.CancelSearchingTimerRequest();
    this.CancelBlinkingTimerRequest();
    this.CancelCrimescoreDropTimerRequest();
    this.CancelNPCSpawnDelay();
    this.CancelSecurityAreaResetRequest();
    this.m_preventionTickCaller.Cancel();
  }

  private final func CancelAllIntervalCallers() -> Void {
    this.m_roadblockadeRespawnTickCaller.Cancel();
    this.m_preventionTickCaller.Cancel();
    this.m_vehicleSpawnTickCaller.Cancel();
    this.m_ressuplyVehicleTicketCaller.Cancel();
  }

  private final func ReevaluttatePreventionLockSources() -> Void {
    if ArraySize(this.m_systemLockSources) <= 0 {
      this.TogglePreventionGlobalQuestObjective_Internal(true, n"prevention_state_managed_by_quest_generic");
      this.execInstructionOn();
    } else {
      if ArraySize(this.m_systemLockSources) > 0 {
        this.execInstructionOff();
      };
    };
    this.RefreshDebugLockSources();
  }

  private final func OnClearPreventionSystemLocks(evt: ref<ClearPreventionSystemLocks>) -> Void {
    ArrayClear(this.m_systemLockSources);
    this.execInstructionOn();
    this.RefreshDebugLockSources();
  }

  private final func OnTogglePreventionSystem(evt: ref<TogglePreventionSystem>) -> Void {
    if !IsNameValid(evt.sourceName) {
      return;
    };
    this.RefreshDebugRemoveAllLockSources();
    if evt.isActive {
      if ArrayContains(this.m_systemLockSources, evt.sourceName) {
        ArrayRemove(this.m_systemLockSources, evt.sourceName);
        if ArraySize(this.m_systemLockSources) <= 0 {
          this.TogglePreventionGlobalQuestObjective_Internal(true, n"prevention_state_managed_by_quest_generic");
          this.execInstructionOn();
        };
      };
    } else {
      if !ArrayContains(this.m_systemLockSources, evt.sourceName) {
        ArrayPush(this.m_systemLockSources, evt.sourceName);
        if ArraySize(this.m_systemLockSources) > 0 {
          this.execInstructionOff();
        };
      };
    };
    this.RefreshDebugLockSources();
  }

  private final func OnTogglePreventionCrowdSpawns(evt: ref<TogglePreventionCrowdSpawns>) -> Void {
    GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).TogglePreventionCrowdSpawns(evt.toggle);
  }

  private final func OnSetWantedLevel(evt: ref<SetWantedLevel>) -> Void {
    let preventionForceDeescalateRequest: ref<PreventionForceDeescalateRequest>;
    if NotEquals(evt.m_wantedLevel, EPreventionHeatStage.Invalid) {
      this.TogglePreventionSystem(true);
      this.m_ignoreSecurityAreasByQuest = evt.m_forceIgnoreSecurityAreas;
      if evt.m_resetGreyStars {
        this.m_forceEternalGreyStars = false;
      };
      if Equals(evt.m_wantedLevel, EPreventionHeatStage.Heat_0) && this.IsChasingPlayer() {
        preventionForceDeescalateRequest = new PreventionForceDeescalateRequest();
        preventionForceDeescalateRequest.fakeBlinkingDuration = TweakDBInterface.GetFloat(t"PreventionSystem.setup.forcedDeescalationUIStarsBlinkingDurationSeconds", 4.00);
        preventionForceDeescalateRequest.telemetryInfo = "QuestEvent";
        this.QueueRequest(preventionForceDeescalateRequest);
        return;
      };
      if Equals(evt.m_wantedLevel, EPreventionHeatStage.Heat_0) && !this.IsChasingPlayer() {
        return;
      };
      if evt.m_forcePlayerPositionAsLastCrimePoint || Vector4.IsZero(this.GetLastKnownPlayerPosition()) {
        this.SetLastKnownPlayerPosition(this.m_player.GetWorldPosition());
      };
      if evt.m_forceGreyStars {
        this.m_forceEternalGreyStars = true;
      };
      this.TogglePreventionGlobalQuestObjective_Internal(true, n"prevention_state_managed_by_quest_generic");
      this.ChangeHeatStage(evt.m_wantedLevel, "QuestEvent");
    };
  }

  private final func RestoreMinimapToDefault() -> Void {
    GameInstance.GetMinimapSystem(this.GetGameInstance()).RestoreDefaultVehicleSettings();
  }

  private final func PreventionMinimapOverride() -> Void {
    let data: wref<PreventionMinimapData_Record> = this.m_preventionDataMatrix.MinimapData();
    GameInstance.GetMinimapSystem(this.GetGameInstance()).OverrideVehicleSettings(data.MinRadius(), data.MaxRadius(), data.MinSpeed(), data.MaxSpeed());
  }

  private final func HandleDebugEventSourceTracking(sourceName: CName, tryRemoveLock: Bool) -> Void {
    if !IsNameValid(sourceName) {
      return;
    };
    if tryRemoveLock {
      if ArrayContains(this.m_nodeEventSources, sourceName) {
        ArrayRemove(this.m_nodeEventSources, sourceName);
      };
    } else {
      if !ArrayContains(this.m_nodeEventSources, sourceName) {
        ArrayPush(this.m_nodeEventSources, sourceName);
      };
    };
    this.RefreshDebugEventSources();
  }

  private final func OnSetHeatCounterMultiplier(evt: ref<SetHeatCounterMultiplier>) -> Void {
    this.HandleDebugEventSourceTracking(evt.source, evt.m_reset);
    if evt.m_reset {
      this.SetCrimeScoreMultiplier(1.00);
    } else {
      this.SetCrimeScoreMultiplier(evt.m_heatMultiplier);
    };
  }

  private final func OnSetHeatLevelLimiter(evt: ref<SetHeatLevelLimiter>) -> Void {
    this.HandleDebugEventSourceTracking(evt.source, evt.m_HeatLevelReset);
    if evt.m_HeatLevelReset {
      this.SetMinMaxResetHeatLevels(0, 5, evt.m_HeatLevelReset);
    } else {
      this.SetMinMaxResetHeatLevels(evt.m_HeatLevelMin, evt.m_HeatLevelMax, evt.m_HeatLevelReset);
    };
  }

  private final func OnSetPreventionPath(evt: ref<SetPreventionPath>) -> Void {
    this.HandleDebugEventSourceTracking(evt.source, evt.m_resetToDefault);
    if evt.m_resetToDefault {
      this.SetVehicleSpawnBlockSide(EVehicleSpawnBlockSide.Default);
    } else {
      this.SetVehicleSpawnBlockSide(evt.m_blockSpawnFrom);
    };
  }

  private final func OnSetPreventionDifficulty(evt: ref<SetPreventionDifficulty>) -> Void {
    this.HandleDebugEventSourceTracking(evt.source, evt.m_difficuiltyReset);
    if evt.m_difficuiltyReset {
      this.SetChaseMultiplier(1.00);
      this.SetDamageToPlayerMultiplier(1.00);
    } else {
      this.SetChaseMultiplier(evt.m_chaseAggressivnessMultiplier);
      this.SetDamageToPlayerMultiplier(evt.m_damageDealtToPlayerMultiplier);
    };
  }

  private final func OnSetPoliceSearchArea(evt: ref<SetPoliceSearchArea>) -> Void {
    this.HandleDebugEventSourceTracking(evt.source, evt.m_resetToDefault);
    if evt.m_resetToDefault {
      this.m_policeChaseBlackboard.SetFloat(GetAllBlackboardDefs().PoliceChaseParams.SearchAreaRadius, -1.00, true);
      this.m_policeChaseBlackboard.SetFloat(GetAllBlackboardDefs().PoliceChaseParams.ChasePlayerDistance, -1.00, true);
    } else {
      this.m_policeChaseBlackboard.SetFloat(GetAllBlackboardDefs().PoliceChaseParams.SearchAreaRadius, evt.m_SearchAreaRadius, true);
      this.m_policeChaseBlackboard.SetFloat(GetAllBlackboardDefs().PoliceChaseParams.ChasePlayerDistance, evt.m_ChaseDistance, true);
    };
  }

  private final func OnSetBlockShootingFromVehicle(evt: ref<SetBlockShootingFromVehicle>) -> Void {
    this.SetBlockShootingFromVehicle(evt.m_enable);
  }

  private final func OnTogglePreventionFreeArea(evt: ref<TogglePreventionFreeArea>) -> Void {
    GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).ToggleFreeArea(evt.m_areaReference, evt.m_enable);
  }

  private final func OnToggleQuestPreventionTrigger(evt: ref<ToggleQuestPreventionTrigger>) -> Void {
    GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).TogglePreventionQuestTrigger(evt.m_areaReference, evt.m_enable);
  }

  private final func OnTogglePreventionGlobalQuestObjective(evt: ref<TogglePreventionGlobalQuestObjective>) -> Void {
    this.TogglePreventionGlobalQuestObjective_Internal(evt.m_preventionGlobalQuestDisabled, evt.m_eventSource);
  }

  private final func TogglePreventionGlobalQuestObjective_Internal(preventionGlobalQuestDisabled: Bool, eventSource: CName) -> Void {
    let ignoreRequest: Bool;
    let preventionGlobalQuestShouldBeDisabled: Bool;
    let questSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.GetGameInstance());
    if !IsDefined(questSystem) {
      return;
    };
    ignoreRequest = Equals(preventionGlobalQuestDisabled, ArrayContains(this.m_preventionQuestEventSources, eventSource));
    if ignoreRequest {
      return;
    };
    if preventionGlobalQuestDisabled {
      ArrayPush(this.m_preventionQuestEventSources, eventSource);
    } else {
      ArrayRemove(this.m_preventionQuestEventSources, eventSource);
    };
    if !IsFinal() {
      this.RefreshDebug();
    };
    preventionGlobalQuestShouldBeDisabled = ArraySize(this.m_preventionQuestEventSources) > 0;
    questSystem.SetFact(n"prevention_quest_disabled", preventionGlobalQuestShouldBeDisabled ? 1 : 0);
  }

  private final func IsPreventionGlobalQuestObjectiveEnabled() -> Bool {
    let factValue: Int32;
    let questSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.GetGameInstance());
    if !IsDefined(questSystem) {
      return false;
    };
    factValue = questSystem.GetFact(n"prevention_quest_disabled");
    return factValue <= 0;
  }

  private final func OnToggleBlockSceneInteractions(evt: ref<ToggleBlockSceneInteractions>) -> Void {
    let interactionManager: ref<InteractionManager> = GameInstance.GetInteractionManager(this.GetGame());
    if IsDefined(interactionManager) {
      interactionManager.SetBlockAllInteractions(evt.m_block);
    };
  }

  private final func OnSetPoliceForcesPool(evt: ref<SetPoliceForcesPool>) -> Void {
    this.HandleDebugEventSourceTracking(evt.source, evt.m_resetToDefault);
    if evt.m_resetToDefault {
      this.SetBlockVehicleSpawn(false);
      this.SetBlockOnFootSpawn(false);
      this.SetBlockReconDroneSpawn(false);
    } else {
      this.SetBlockVehicleSpawn(evt.m_disableVehicleSpawn);
      this.SetBlockOnFootSpawn(evt.m_disableOnFootSpawn);
      this.SetBlockReconDroneSpawn(evt.m_disableDroneSpawn);
    };
  }

  public final static func IsChasingPlayer(game: GameInstance) -> Bool {
    let self: ref<PreventionSystem>;
    if !GameInstance.IsValid(game) {
      return false;
    };
    self = GameInstance.GetScriptableSystemsContainer(game).Get(n"PreventionSystem") as PreventionSystem;
    if !IsDefined(self) {
      return false;
    };
    if self.IsChasingPlayer() {
      return true;
    };
    return false;
  }

  public final static func ForceStarStateToActive(context: GameInstance, value: Bool) -> Void {
    let ps: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(context).Get(n"PreventionSystem") as PreventionSystem;
    ps.m_shouldForceStarStateUIToActive = value;
    if value {
      ps.UpdateStarStateTo(EStarState.Active);
    } else {
      ps.TryUpdateStarState();
    };
  }

  public final static func SetLastKnownPlayerPosition(context: GameInstance, value: Vector4) -> Void {
    let ps: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(context).Get(n"PreventionSystem") as PreventionSystem;
    ps.m_lastKnownPosition = value;
  }

  public final static func SetLastKnownPlayerVehicle(context: GameInstance, value: wref<VehicleObject>) -> Void {
    let ps: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(context).Get(n"PreventionSystem") as PreventionSystem;
    ps.m_lastKnownVehicle = value;
  }

  public final static func GetLastKnownPlayerVehicle(context: GameInstance) -> ref<VehicleObject> {
    let ps: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(context).Get(n"PreventionSystem") as PreventionSystem;
    return ps.m_lastKnownVehicle;
  }

  public final static func SetPlayerMounted(context: GameInstance, value: Bool) -> Void {
    let ps: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(context).Get(n"PreventionSystem") as PreventionSystem;
    if NotEquals(ps.m_isPlayerMounted, value) {
      ps.SetIsPlayerMounted(value);
    };
  }

  public final static func GetAgentRegistry(context: GameInstance) -> ref<PoliceAgentRegistry> {
    let ps: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(context).Get(n"PreventionSystem") as PreventionSystem;
    return ps.m_agentRegistry;
  }

  public final static func IsPreventionMaxTac(context: GameInstance, owner: ref<gamePuppet>) -> Bool {
    let agentRegistry: ref<PoliceAgentRegistry>;
    let preventionSystem: ref<PreventionSystem> = owner.GetPreventionSystem();
    if IsDefined(preventionSystem) {
      agentRegistry = PreventionSystem.GetAgentRegistry(context);
      if IsDefined(agentRegistry) {
        return agentRegistry.IsPreventionMaxTac(owner);
      };
    };
    return false;
  }

  private final func IsVehicleValid(vehicle: wref<VehicleObject>) -> Bool {
    return IsDefined(vehicle) && !vehicle.IsDestroyed() && VehicleComponent.HasAnyPreventionPassengers(vehicle);
  }

  private final func IsNPCValid(puppet: wref<ScriptedPuppet>) -> Bool {
    let isAlive: Bool;
    let isPrevention: Bool;
    if IsDefined(puppet) {
      isAlive = ScriptedPuppet.IsActive(puppet);
      isPrevention = puppet.IsPrevention();
      return isAlive && isPrevention;
    };
    return false;
  }

  public final static func GetDamageToPlayerMultiplier(game: GameInstance) -> Float {
    let self: ref<PreventionSystem>;
    if !GameInstance.IsValid(game) {
      return 1.00;
    };
    self = GameInstance.GetScriptableSystemsContainer(game).Get(n"PreventionSystem") as PreventionSystem;
    if !IsDefined(self) {
      return 1.00;
    };
    return self.GetDamageToPlayerMultiplier();
  }

  public final static func QueueRequest(context: GameInstance, request: ref<ScriptableSystemRequest>, opt delay: Float) -> Bool {
    let preventionSystem: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(context).Get(n"PreventionSystem") as PreventionSystem;
    if IsDefined(preventionSystem) {
      if delay <= 0.00 {
        preventionSystem.QueueRequest(request);
      } else {
        GameInstance.GetDelaySystem(context).DelayScriptableSystemRequest(n"PreventionSystem", request, delay);
      };
      return true;
    };
    return false;
  }

  public final static func CreateNewDamageRequest(context: GameInstance, target: ref<GameObject>, attackType: gamedataAttackType, damageDealt: Float, opt isTargetKilled: Bool) -> Void {
    let preventionSystemRequest: ref<PreventionDamageRequest> = new PreventionDamageRequest();
    if IsDefined(target) {
      preventionSystemRequest.targetID = target.GetEntityID();
      preventionSystemRequest.targetPosition = target.GetWorldPosition();
      preventionSystemRequest.isTargetPrevention = target.IsPrevention();
      preventionSystemRequest.isTargetVehicle = target.IsVehicle();
      preventionSystemRequest.isTargetKilled = isTargetKilled;
      preventionSystemRequest.telemetryInfo = PreventionDamage.GetTelemetryDescription(target, isTargetKilled);
    };
    preventionSystemRequest.attackType = attackType;
    preventionSystemRequest.damageDealtPercentValue = damageDealt;
    GameInstance.GetScriptableSystemsContainer(context).Get(n"PreventionSystem").QueueRequest(preventionSystemRequest);
  }

  public final static func RegisterToPreventionSystem(context: GameInstance, requester: ref<Device>) -> Void {
    let request: ref<PreventionRegisterRequest>;
    return;
  }

  public final static func UnRegisterToPreventionSystem(context: GameInstance, requester: ref<Device>) -> Void {
    let request: ref<PreventionRegisterRequest>;
    return;
  }

  public final static func RegisterAsViewerToPreventionSystem(context: GameInstance, requester: ref<GameObject>) -> Void {
    let request: ref<PreventionVisibilityRequest>;
    let self: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(context).Get(n"PreventionSystem") as PreventionSystem;
    if EnumInt(self.GetHeatStage()) == 0 {
      return;
    };
    request = new PreventionVisibilityRequest();
    request.requester = requester;
    request.seePlayer = true;
    GameInstance.QueueScriptableSystemRequest(context, n"PreventionSystem", request);
  }

  public final static func UnRegisterAsViewerToPreventionSystem(context: GameInstance, requester: ref<GameObject>) -> Void {
    let request: ref<PreventionVisibilityRequest>;
    let self: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(context).Get(n"PreventionSystem") as PreventionSystem;
    if EnumInt(self.GetHeatStage()) == 0 {
      return;
    };
    request = new PreventionVisibilityRequest();
    request.requester = requester;
    request.seePlayer = false;
    self.QueueRequest(request);
  }

  public final static func CombatStartedRequestToPreventionSystem(context: GameInstance, requester: wref<GameObject>) -> Void {
    let request: ref<PreventionCombatStartedRequest>;
    let self: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(context).Get(n"PreventionSystem") as PreventionSystem;
    if IsDefined(self) {
      request = new PreventionCombatStartedRequest();
      request.requesterPosition = requester.GetWorldPosition();
      request.requester = requester;
      self.QueueRequest(request);
    };
  }

  public final static func CrimeWitnessRequestToPreventionSystem(context: GameInstance, criminalPosition: Vector4) -> Void {
    let self: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(context).Get(n"PreventionSystem") as PreventionSystem;
    let request: ref<PreventionCrimeWitnessRequest> = new PreventionCrimeWitnessRequest();
    request.criminalPosition = criminalPosition;
    self.QueueRequest(request);
  }

  public final static func PreventionSecurityAreaEnterRequest(context: GameInstance, playerIsIn: Bool, areaID: PersistentID) -> Void {
    let request: ref<PreventionSecurityAreaRequest>;
    let preventionSystem: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(context).Get(n"PreventionSystem") as PreventionSystem;
    if IsDefined(preventionSystem) {
      request = new PreventionSecurityAreaRequest();
      request.playerIsIn = playerIsIn;
      request.areaID = areaID;
      preventionSystem.QueueRequest(request);
    };
  }

  public final static func PreventionPoliceSecuritySystemRequest(context: GameInstance, securitySystemID: PersistentID) -> Void {
    let request: ref<PreventionPoliceSecuritySystemRequest>;
    let preventionSystem: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(context).Get(n"PreventionSystem") as PreventionSystem;
    if IsDefined(preventionSystem) {
      request = new PreventionPoliceSecuritySystemRequest();
      request.securitySystemID = securitySystemID;
      preventionSystem.QueueRequest(request);
    };
  }

  public final static func StartRoadblockNPCAgentBehaviour(unit: wref<ScriptedPuppet>) -> Void {
    let aiHoldPositionCommand: ref<AIHoldPositionCommand> = new AIHoldPositionCommand();
    aiHoldPositionCommand.duration = 240.00;
    AIComponent.SendCommand(unit, aiHoldPositionCommand);
  }

  private final func ReinitAll() -> Void {
    let wheeledObject: ref<WheeledObject>;
    let vehicles: array<ref<VehicleAgent>> = this.m_agentRegistry.GetVehicleList();
    let npcs: array<ref<NPCAgent>> = this.m_agentRegistry.GetNPCList();
    let i: Int32 = 0;
    while i < ArraySize(npcs) {
      if VehicleComponent.IsMountedToVehicle(this.GetGame(), npcs[i].unit) {
      } else {
        NPCPuppet.ChangeHighLevelState(npcs[i].unit, gamedataNPCHighLevelState.Alerted);
      };
      i += 1;
    };
    i = 0;
    while i < ArraySize(vehicles) {
      wheeledObject = vehicles[i].unit as WheeledObject;
      wheeledObject.SetPoliceStrategy(vehiclePoliceStrategy.SearchFromAnywhere);
      wheeledObject.SetPoliceStrategyDestination(this.m_lastKnownPosition);
      PreventionSystem.StartActiveVehicleBehaviour(this.GetGameInstance(), wheeledObject);
      i += 1;
    };
  }

  private final static func LogChaseVehicleInitBehaviorError(wheeledVehicleObject: wref<WheeledObject>, strat: vehiclePoliceStrategy) -> Void;

  public final static func StartActiveVehicleBehaviour(context: GameInstance, wheeledVehicleObject: wref<WheeledObject>) -> Void {
    let strat: vehiclePoliceStrategy = wheeledVehicleObject.GetPoliceStrategy();
    let ps: ref<PreventionSystem> = wheeledVehicleObject.GetPreventionSystem();
    let destIsLastKnownPlayerPos: Bool = Equals(strat, vehiclePoliceStrategy.InitialSearch) || Equals(strat, vehiclePoliceStrategy.SearchFromAnywhere);
    let driveToPointNeeded: Bool = destIsLastKnownPlayerPos || Equals(strat, vehiclePoliceStrategy.DriveTowardsPlayer) || Equals(strat, vehiclePoliceStrategy.DriveAwayFromPlayer) || Equals(strat, vehiclePoliceStrategy.InterceptAtNextIntersection);
    if !IsDefined(ps) {
      return;
    };
    if destIsLastKnownPlayerPos {
      wheeledVehicleObject.SetPoliceStrategyDestination(ps.GetLastKnownPlayerPosition());
    };
    if driveToPointNeeded {
      if !PreventionSystem.StartDriveToPoint(wheeledVehicleObject) {
        PreventionSystem.LogChaseVehicleInitBehaviorError(wheeledVehicleObject, strat);
      };
      return;
    };
    if Equals(strat, vehiclePoliceStrategy.PatrolNearby) {
      PreventionSystem.StartPatrol(wheeledVehicleObject, ps);
      return;
    };
    if Equals(strat, vehiclePoliceStrategy.GetToPlayerFromAnywhere) {
      PreventionSystem.ChasePlayer(wheeledVehicleObject);
      return;
    };
    PreventionSystem.LogChaseVehicleInitBehaviorError(wheeledVehicleObject, strat);
  }

  private final static func VehicleRegistered(vehicle: wref<VehicleObject>) -> Bool {
    let id: EntityID;
    if !IsDefined(vehicle) {
      return false;
    };
    id = vehicle.GetEntityID();
    return PreventionSystem.GetAgentRegistry(vehicle.GetGame()).Contains(id);
  }

  private final static func ChasePlayer(vehicle: wref<WheeledObject>) -> Void {
    let command: ref<AIVehicleChaseCommand> = new AIVehicleChaseCommand();
    let evt: ref<AICommandEvent> = new AICommandEvent();
    command.target = GameInstance.GetPlayerSystem(vehicle.GetGame()).GetLocalPlayerMainGameObject();
    command.distanceMin = 3.00;
    command.distanceMax = 10.00;
    command.forcedStartSpeed = PreventionSystem.VehicleRegistered(vehicle) ? -1.00 : 10.00;
    evt.command = command;
    vehicle.QueueEvent(evt);
    vehicle.GetAIComponent().SetInitCmd(command);
  }

  private final static func StartDriveToPoint(vehicle: wref<WheeledObject>) -> Bool {
    let command: ref<AIVehicleDriveToPointAutonomousCommand> = new AIVehicleDriveToPointAutonomousCommand();
    let evt: ref<AICommandEvent> = new AICommandEvent();
    let destination: Vector4 = Vector4.Vector3To4(vehicle.GetPoliceStrategyDestination());
    let isStrat2: Bool = Equals(vehicle.GetPoliceStrategy(), vehiclePoliceStrategy.DriveAwayFromPlayer);
    if Vector4.IsXYZZero(destination) {
      return false;
    };
    if Equals(vehicle.GetPreventionSystem().GetHeatStage(), EPreventionHeatStage.Heat_1) {
      command.clearTrafficOnPath = true;
      command.maxSpeed = 20.00;
      command.minSpeed = 10.00;
    };
    if isStrat2 {
      command.maxSpeed = 15.00;
      command.minSpeed = 10.00;
    };
    command.targetPosition = Vector4.Vector4To3(destination);
    command.minimumDistanceToTarget = 20.00;
    command.forcedStartSpeed = PreventionSystem.VehicleRegistered(vehicle) ? -1.00 : 10.00;
    command.driveDownTheRoadIndefinitely = isStrat2;
    evt.command = command;
    vehicle.QueueEvent(evt);
    vehicle.GetAIComponent().SetInitCmd(command);
    return true;
  }

  private final static func StartPatrol(vehicle: wref<WheeledObject>, ps: ref<PreventionSystem>) -> Void {
    let cmd: ref<AIVehicleDrivePatrolCommand> = new AIVehicleDrivePatrolCommand();
    let evt: ref<AICommandEvent> = new AICommandEvent();
    cmd.maxSpeed = 20.00;
    cmd.minSpeed = 5.00;
    cmd.clearTrafficOnPath = false;
    cmd.emergencyPatrol = NotEquals(ps.GetHeatStage(), EPreventionHeatStage.Heat_0);
    cmd.numPatrolLoops = 2u;
    cmd.forcedStartSpeed = PreventionSystem.VehicleRegistered(vehicle) ? -1.00 : 10.00;
    evt.command = cmd;
    vehicle.QueueEvent(evt);
    vehicle.GetAIComponent().SetInitCmd(cmd);
  }

  private final func IsAnyVehicleChasingTarget() -> Bool {
    let vehicles: array<ref<VehicleAgent>> = this.m_agentRegistry.GetVehicleList();
    let i: Int32 = ArraySize(vehicles) - 1;
    while i >= 0 {
      if this.IsVehicleValid(vehicles[i].unit) && vehicles[i].unit.IsChasingTarget() {
        return true;
      };
      i -= 1;
    };
    return false;
  }

  public final static func IsPlayerInAPoliceCarChase(gameInstance: GameInstance) -> Bool {
    let system: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"PreventionSystem") as PreventionSystem;
    return system.IsAnyVehicleChasingTarget();
  }

  private final func SendInternalSystem(damageDealt: Float, opt heatStage: EPreventionHeatStage) -> Void {
    let playerPos: Vector4;
    let preventionSystemRequest: ref<PreventionDamageRequest>;
    this.TogglePreventionSystem(true);
    playerPos = GetPlayer(this.GetGameInstance()).GetWorldPosition();
    preventionSystemRequest = new PreventionDamageRequest();
    preventionSystemRequest.damageDealtPercentValue = damageDealt;
    preventionSystemRequest.isInternal = true;
    preventionSystemRequest.isTargetPrevention = false;
    preventionSystemRequest.requestedHeat = heatStage;
    preventionSystemRequest.targetPosition = playerPos;
    preventionSystemRequest.attackType = gamedataAttackType.Ranged;
    preventionSystemRequest.telemetryInfo = "KillPrevention";
    this.QueueRequest(preventionSystemRequest);
  }

  protected final func OnPreventionConsoleInstructionRequest(request: ref<PreventionConsoleInstructionRequest>) -> Void {
    switch request.instruction {
      case EPreventionSystemInstruction.Safe:
        this.execInstructionSafe("DEBUG");
        break;
      case EPreventionSystemInstruction.Active:
        if Equals(request.heatStage, EPreventionHeatStage.Heat_0) {
          this.execInstructionSafe("DEBUG");
        } else {
          this.execInstructionActive(request.heatStage);
        };
        break;
      case EPreventionSystemInstruction.On:
        this.execInstructionOn();
        break;
      case EPreventionSystemInstruction.Off:
        this.execInstructionOff();
        break;
      case EPreventionSystemInstruction.ReconPhaseOn:
        this.m_reconPhaseEnabled = true;
        break;
      case EPreventionSystemInstruction.ReconPhaseOff:
        this.m_reconPhaseEnabled = false;
        break;
      default:
    };
  }

  protected final func OnPreventionConsoleLockRequest(request: ref<PreventionConsoleLockRequest>) -> Void {
    this.SetSystemLock(!this.IsSystemLocked());
  }

  protected final func OnPreventionMinMaxHeatLevels(request: ref<PreventionMinMaxHeatLevels>) -> Void {
    this.SetMinMaxResetHeatLevels(request.minLvl, request.maxLvl, request.isDefault);
  }

  private final func RemovePlayerFromSecuritySystemBlacklist() -> Void {
    let i: Int32;
    let removeFromBlacklist: ref<RemoveFromBlacklistEvent>;
    if !IsDefined(this.m_player) {
      return;
    };
    removeFromBlacklist = new RemoveFromBlacklistEvent();
    removeFromBlacklist.entityIDToRemove = this.m_player.GetEntityID();
    removeFromBlacklist.isPlayerEntity = true;
    i = 0;
    while i < ArraySize(this.m_policeSecuritySystems) {
      if PersistentID.IsDefined(this.m_policeSecuritySystems[i]) {
        GameInstance.GetPersistencySystem(this.GetGame()).QueuePSEvent(this.m_policeSecuritySystems[i], n"SecuritySystemControllerPS", removeFromBlacklist);
      };
      i += 1;
    };
  }

  private final func TogglePreventionSystem(toggle: Bool) -> Void {
    if Equals(this.m_systemEnabled, toggle) {
      return;
    };
    this.m_systemEnabled = toggle;
    GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).TogglePreventionCrowdSpawns(toggle);
  }

  private final func StartPreventionFreeAreaReset() -> Void {
    let request: ref<TryResetPreventionFreeArea> = new TryResetPreventionFreeArea();
    this.m_freeAreaResetDelayID = GameInstance.GetDelaySystem(this.GetGameInstance()).DelayScriptableSystemRequest(n"PreventionSystem", request, 0.50);
  }

  private final func UpdatePreventionFreeAreas(isPlayerInFreeArea: Bool) -> Void {
    let togglePreventionRequest: ref<TogglePreventionSystem>;
    if isPlayerInFreeArea && this.m_freeAreaResetDelayID == GetInvalidDelayID() {
      this.StartPreventionFreeAreaReset();
    };
    if Equals(this.m_playerIsInPreventionFreeArea, isPlayerInFreeArea) {
      return;
    };
    this.m_playerIsInPreventionFreeArea = isPlayerInFreeArea;
    togglePreventionRequest = new TogglePreventionSystem();
    togglePreventionRequest.sourceName = n"PreventionFreeArea";
    togglePreventionRequest.isActive = !isPlayerInFreeArea;
    this.QueueRequest(togglePreventionRequest);
  }

  protected final func OnTryResetPreventionFreeArea(request: ref<TryResetPreventionFreeArea>) -> Void {
    let playerPosition: Vector4 = this.GetPlayer().GetWorldPosition();
    this.m_freeAreaResetDelayID = GetInvalidDelayID();
    this.UpdatePreventionFreeAreas(GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).IsPointInPreventionFreeArea(playerPosition));
  }

  private final func execInstructionSafe(heatChangeReason: String) -> Void {
    let i: Int32;
    let vehicles: array<ref<VehicleAgent>>;
    if this.IsSystemLocked() {
      return;
    };
    this.DespawnAllPolice(Equals(heatChangeReason, "ResetOnPlayerChoice"));
    if !this.IsChasingPlayer() {
      return;
    };
    this.TogglePreventionSystem(true);
    this.m_policeKnowsPlayerLocation = false;
    this.m_canSpawnFallbackEarly = false;
    this.m_isVehicleDelayOver = false;
    this.m_playerCrossedBufferDistance = false;
    this.m_totalCrimeScore = 0.00;
    this.ChangeAgentsAttitude(EAIAttitude.AIA_Neutral);
    this.RestoreMinimapToDefault();
    this.WakeUpAllAgents(false);
    this.RemovePlayerFromSecuritySystemBlacklist();
    this.CancelAllDelayedEvents();
    this.CancelAllIntervalCallers();
    GameInstance.GetPreventionSpawnSystem(this.GetGame()).CancelAllSpawnRequests();
    this.ChangeHeatStage(EPreventionHeatStage.Heat_0, heatChangeReason);
    vehicles = this.m_agentRegistry.GetVehicleList();
    i = ArraySize(vehicles) - 1;
    while i >= 0 {
      if this.IsVehicleValid(vehicles[i].unit) && vehicles[i].unit.IsA(n"vehicleWheeledBaseObject") {
        GameInstance.GetPreventionSpawnSystem(this.GetGameInstance()).InterruptAllActionAndCommands(vehicles[i].unit);
        this.StartVehicleDeescalationBehavior(vehicles[i].unit);
      };
      i -= 1;
    };
    this.SetStarStateUI(EStarState.Default);
    this.SetWantedLevelFact(0);
    if !IsFinal() {
      this.RefreshDebug();
    };
  }

  private final func StartVehicleDeescalationBehavior(vehicle: wref<VehicleObject>) -> Void {
    let panicDrivingCmd: ref<AIVehiclePanicCommand> = new AIVehiclePanicCommand();
    let evt: ref<AICommandEvent> = new AICommandEvent();
    panicDrivingCmd.allowSimplifiedMovement = true;
    panicDrivingCmd.ignoreTickets = true;
    panicDrivingCmd.useSpeedBasedLookupRange = true;
    evt.command = panicDrivingCmd;
    vehicle.QueueEvent(evt);
    vehicle.GetAIComponent().SetInitCmd(panicDrivingCmd);
  }

  private final func execInstructionActive(opt heatStage: EPreventionHeatStage) -> Void {
    this.TogglePreventionSystem(true);
    this.ChangeHeatStage(heatStage, "DEBUG");
  }

  private final func execInstructionOn() -> Void {
    this.TogglePreventionSystem(true);
    if !IsFinal() {
      this.RefreshDebug();
    };
  }

  private final func execInstructionOff() -> Void {
    this.execInstructionSafe("DEBUG");
    this.TogglePreventionSystem(false);
    if !IsFinal() {
      this.RefreshDebug();
    };
  }

  public final const func FillPreventionSystemDebugData(out dataToFill: PreventionSystemDebugData) -> Void {
    let i: Int32 = 0;
    dataToFill.totalCrimeScore = this.m_totalCrimeScore;
    dataToFill.heatStage = EnumInt(this.m_heatStage);
    dataToFill.heatThreshold = this.m_preventionDataTable.HeatThresholdCapacity();
    dataToFill.heatMultiplierDistrict = 1.00;
    dataToFill.heatMultiplierQuest = this.m_crimeScoreMultiplierByQuest;
    dataToFill.totalVehiclesCount = this.m_agentRegistry.GetTotalVehicleCount();
    dataToFill.totalAVsCount = this.m_agentRegistry.GetAvCount();
    dataToFill.totalBlockadesCount = this.m_agentRegistry.GetRoadblockCount();
    dataToFill.totalNPCCount = this.m_agentRegistry.GetTotalNPCCount();
    dataToFill.currentVehicleTicketCount = this.m_currentVehicleTicketCount;
    dataToFill.maxVehicleTicketCount = this.m_preventionDataTable.VehicleTicketsAmount();
    dataToFill.maxTacNPCCount = this.m_agentRegistry.GetMaxTacNPCCount();
    dataToFill.engagedVehiclesCount = this.GetAgentRegistry().GetEngagedVehicleCount();
    dataToFill.engagedVehiclesLimit = this.m_preventionDataTable.SpawnedEngagedCars();
    dataToFill.supportVehiclesCount = this.GetAgentRegistry().GetSupportVehicleCount();
    dataToFill.supportVehiclesLimit = this.m_preventionDataTable.SpawnedSupportCars();
    dataToFill.maxAVPlayerDistance = this.m_maxAllowedDistanceToPlayer;
    dataToFill.lastAVRequestedSpawnPosition = this.Debug_lastAVRequestedSpawnPosition;
    dataToFill.totalNPCLimit = this.m_preventionDataTable.MaxUnitCount();
    dataToFill.externalNPCCount = this.GetAgentRegistry().GetExternalNPCCount();
    dataToFill.fallbackNPCCount = this.GetAgentRegistry().GetFallbackNPCCount();
    dataToFill.registeredPendingTickets = this.GetAgentRegistry().GetTotalPendingTicketsCount();
    dataToFill.awaitedAVSpawnPointsRequestID = this.m_maxtacTicketID;
    dataToFill.lastKnownPosition = this.m_lastKnownPosition;
    dataToFill.systemEnabled = this.m_systemEnabled;
    ArrayClear(dataToFill.systemLockEventSources);
    i = 0;
    while i < ArraySize(this.m_systemLockSources) {
      ArrayPush(dataToFill.systemLockEventSources, NameToString(this.m_systemLockSources[i]));
      i += 1;
    };
    dataToFill.heatChangeReason = this.m_heatChangeReason;
  }

  private final func DebugGetCivilianDestroyedVehicleCount() -> Int32 {
    let now: Float = EngineTime.ToFloat(GameInstance.GetSimTime(this.GetGame()));
    if this.IsChasingPlayer() || this.m_lastCivilianVehicleDestructionTimeStamp < 0.00 {
      return 0;
    };
    if now - this.m_lastCivilianVehicleDestructionTimeStamp > this.m_civilianVehicleDestructionTimeout {
      return 0;
    };
    return this.m_civilianVehicleDestructionCount;
  }

  private final func RefreshDebug() -> Void {
    let district: wref<District>;
    let i: Int32;
    let sink: SDOSink;
    let wantedLevel: Int32;
    let questSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.GetGameInstance());
    let delaySystem: ref<DelaySystem> = GameInstance.GetDelaySystem(this.GetGameInstance());
    if IsDefined(questSystem) {
      wantedLevel = questSystem.GetFact(n"wanted_level");
    };
    sink = GameInstance.GetScriptsDebugOverlaySystem(this.GetGameInstance()).CreateSink();
    SDOSink.SetRoot(sink, "Prevention");
    SDOSink.PushString(sink, "Heat", EnumValueToString("EPreventionHeatStage", Cast<Int64>(EnumInt(this.m_heatStage))));
    SDOSink.PushInt32(sink, "QuestWantedLevel", wantedLevel);
    SDOSink.PushString(sink, "----TIMERS----", "---------TIMERS---------");
    SDOSink.SetKeyColor(sink, "----TIMERS----", new Color(255u, 255u, 255u, 255u));
    SDOSink.PushBool(sink, "Is Transition Timer Active", this.m_transitionToGreyStateDelayID != GetInvalidDelayID());
    SDOSink.PushFloat(sink, "Transition time Remaining", delaySystem.GetRemainingDelayTime(this.m_transitionToGreyStateDelayID));
    SDOSink.PushBool(sink, "Is Buffer Timer Active", this.m_starStateBufferTimerDelayID != GetInvalidDelayID());
    SDOSink.PushFloat(sink, "Buffer time Remaining", delaySystem.GetRemainingDelayTime(this.m_starStateBufferTimerDelayID));
    SDOSink.PushBool(sink, "Is Search Timer Active", this.m_searchingStatusDelayID != GetInvalidDelayID());
    SDOSink.PushFloat(sink, "Searching time Remaining", delaySystem.GetRemainingDelayTime(this.m_searchingStatusDelayID));
    SDOSink.PushBool(sink, "Is Blinking Timer Active", this.m_blinkingStatusDelayID != GetInvalidDelayID());
    SDOSink.PushFloat(sink, "Blinking time Remaining", delaySystem.GetRemainingDelayTime(this.m_blinkingStatusDelayID));
    SDOSink.PushString(sink, "----AGENT REGISTRY----", "---------AGENT REGISTRY---------");
    SDOSink.SetKeyColor(sink, "----AGENT REGISTRY----", new Color(255u, 255u, 255u, 255u));
    SDOSink.PushInt32(sink, "Active NPC ", this.m_agentRegistry.GetTotalNPCCount());
    SDOSink.PushInt32(sink, "Active Vehicles ", this.m_agentRegistry.GetEngagedVehicleCount());
    SDOSink.PushInt32(sink, "Support Vehicles ", this.m_agentRegistry.GetSupportVehicleCount());
    SDOSink.PushBool(sink, "Is Police in combat with Player", this.m_agentRegistry.IsPoliceInCombatWithPalyer());
    SDOSink.PushInt32(sink, "NPC that see Player", ArraySize(this.m_viewers));
    SDOSink.PushString(sink, "----CHASE----", "---------CHASE---------");
    SDOSink.SetKeyColor(sink, "----CHASE----", new Color(100u, 100u, 100u, 255u));
    SDOSink.PushBool(sink, "Vehicle Delay over?", this.m_isVehicleDelayOver);
    SDOSink.PushInt32(sink, "Tickets available", this.m_currentVehicleTicketCount);
    SDOSink.PushInt32(sink, "Tickets pending", this.m_agentRegistry.GetPendingVehicleTicketsCount());
    SDOSink.PushBool(sink, "Vehicle limit reached", this.ReachedTotalVehiclesLimit());
    SDOSink.PushInt32(sink, "Requests pending", this.m_agentRegistry.GetTotalPendingTicketsCount());
    SDOSink.PushInt32(sink, "spawned as engaged vehicles", this.m_agentRegistry.GetEngagedVehicleCount());
    SDOSink.PushInt32(sink, "spawned as support vehicles", this.m_agentRegistry.GetSupportVehicleCount());
    SDOSink.PushString(sink, "----MAXTAC----", "---------MAXTAC---------");
    SDOSink.SetKeyColor(sink, "----MAXTAC----", new Color(100u, 100u, 100u, 255u));
    SDOSink.PushInt32(sink, "Active MaxTac NPC ", this.m_agentRegistry.GetMaxTacNPCCount());
    SDOSink.PushInt32(sink, "Deployed AVs (Agent Registry) ", this.m_agentRegistry.GetAvCount());
    SDOSink.PushBool(sink, "Is MaxTacDefeated ", this.IsMaxTacDefeated());
    SDOSink.PushString(sink, "----DISTRICT----", "---------DISTRICT---------");
    SDOSink.SetKeyColor(sink, "----DISTRICT----", new Color(100u, 200u, 100u, 255u));
    district = this.m_districtManager.GetCurrentDistrict();
    if IsDefined(district) {
      SDOSink.PushString(sink, "District", TDBID.ToStringDEBUG(district.GetDistrictID()));
      SDOSink.PushString(sink, "Preset", TDBID.ToStringDEBUG(district.GetPresetID()));
    };
    SDOSink.PushString(sink, "----REACTION----", "---------TYPE---------");
    SDOSink.SetKeyColor(sink, "----REACTION----", new Color(100u, 100u, 200u, 255u));
    SDOSink.PushString(sink, "ProcessInfo", EnumValueToString("EPreventionDebugProcessReason", Cast<Int64>(EnumInt(this.Debug_ProcessReason))));
    SDOSink.PushBool(sink, "Prevention input lock", this.IsPreventionInputLocked());
    if this.IsPreventionInputLocked() {
      SDOSink.PushInt32(sink, "Unhandled input lock threshold", this.GetInputLockOverrideThreshold());
      SDOSink.PushInt32(sink, "Unhandled prevention inputs", this.m_unhandledInputsReceived);
    };
    SDOSink.PushBool(sink, "Is Prevention Locked", this.m_systemLocked);
    SDOSink.PushBool(sink, "Are security areas disabled by Quest", this.m_ignoreSecurityAreasByQuest);
    SDOSink.PushString(sink, "Heat Data Table used:", this.m_preventionDataTable.DisplayName());
    SDOSink.PushFloat(sink, "Last damage dealt (in %)", this.Debug_LastDamageDealt);
    SDOSink.PushString(sink, "Last attack type", EnumValueToString("EAttackType", Cast<Int64>(EnumInt(this.Debug_LastAttackType))));
    SDOSink.PushFloat(sink, "Total crime score", this.m_totalCrimeScore);
    SDOSink.PushFloat(sink, "Heat threshold", this.m_preventionDataTable.HeatThresholdCapacity());
    SDOSink.PushString(sink, "Current Star state", EnumValueToString("EStarState", Cast<Int64>(EnumInt(this.m_starState))));
    SDOSink.PushString(sink, "Civilian Car Destroyed", IntToString(this.DebugGetCivilianDestroyedVehicleCount()) + "/" + IntToString(this.m_civilianVehicleDestructionThreshold));
    SDOSink.PushString(sink, "----ACTIVE----", "---------ACTIVE---------");
    SDOSink.SetKeyColor(sink, "----ACTIVE----", new Color(100u, 100u, 100u, 255u));
    SDOSink.PushBool(sink, "Should reaction be aggressive", this.ShouldReactionBeAggressive());
    SDOSink.PushBool(sink, "Player is in security area", ArraySize(this.m_playerIsInSecurityArea) > 0);
    SDOSink.PushBool(sink, "Player is in prevfree area", this.m_playerIsInPreventionFreeArea);
    SDOSink.PushString(sink, "----DISTANCE----", "---------DISTANCE---------");
    SDOSink.SetKeyColor(sink, "----DISTANCE----", new Color(0u, 0u, 0u, 0u));
    SDOSink.PushFloat(sink, "Distance", this.Debug_LastCrimeDistance);
    SDOSink.PushString(sink, "----EVENTS----", "---------EVENTS---------");
    SDOSink.SetKeyColor(sink, "----EVENTS----", new Color(255u, 255u, 255u, 255u));
    SDOSink.PushBool(sink, "securityAreaResetCheck", this.m_securityAreaResetCheck);
    i = 0;
    while i < ArraySize(this.m_systemLockSources) {
      SDOSink.PushName(sink, "sourceName" + i, this.m_systemLockSources[i]);
      i += 1;
    };
    SDOSink.PushBool(sink, "prevention global quest locked", ArraySize(this.m_preventionQuestEventSources) > 0);
    i = 0;
    while i < ArraySize(this.m_preventionQuestEventSources) {
      SDOSink.PushName(sink, "global quest lock sourceName" + i, this.m_preventionQuestEventSources[i]);
      i += 1;
    };
  }

  private final func RefreshDebugRemoveAllLockSources() -> Void {
    let i: Int32;
    let sink: SDOSink = GameInstance.GetScriptsDebugOverlaySystem(this.GetGameInstance()).CreateSink();
    SDOSink.SetRoot(sink, "Prevention");
    i = 0;
    while i < ArraySize(this.m_systemLockSources) {
      SDOSink.PushName(sink, "locks/sourceName" + i, n"NONE - debug error ignore");
      i += 1;
    };
  }

  private final func RefreshDebugLockSources() -> Void {
    let i: Int32;
    let sink: SDOSink = GameInstance.GetScriptsDebugOverlaySystem(this.GetGameInstance()).CreateSink();
    SDOSink.SetRoot(sink, "Prevention");
    i = 0;
    while i < ArraySize(this.m_systemLockSources) {
      SDOSink.PushName(sink, "locks/sourceName" + i, this.m_systemLockSources[i]);
      i += 1;
    };
  }

  private final func RefreshDebugEventSources() -> Void {
    let i: Int32;
    let sink: SDOSink = GameInstance.GetScriptsDebugOverlaySystem(this.GetGameInstance()).CreateSink();
    SDOSink.SetRoot(sink, "Prevention");
    i = 0;
    while i < ArraySize(this.m_nodeEventSources) {
      SDOSink.PushName(sink, "events/sourceName" + i, this.m_nodeEventSources[i]);
      i += 1;
    };
  }

  private final func RefreshDebugEvents() -> Void {
    let sink: SDOSink = GameInstance.GetScriptsDebugOverlaySystem(this.GetGameInstance()).CreateSink();
    SDOSink.SetRoot(sink, "Prevention");
    SDOSink.PushString(sink, "----EVENTS----", "---------EVENTS---------");
    SDOSink.SetKeyColor(sink, "----EVENTS----", new Color(255u, 255u, 255u, 255u));
    SDOSink.PushBool(sink, "securityAreaResetCheck", this.m_securityAreaResetCheck);
  }

  private final func RefreshDebugProcessInfo() -> Void {
    let sink: SDOSink = GameInstance.GetScriptsDebugOverlaySystem(this.GetGameInstance()).CreateSink();
    SDOSink.SetRoot(sink, "Prevention");
    SDOSink.PushString(sink, "ProcessInfo", EnumValueToString("EPreventionDebugProcessReason", Cast<Int64>(EnumInt(this.Debug_ProcessReason))));
  }

  private final func RefreshDebugDistrictInfo() -> Void {
    let sink: SDOSink = GameInstance.GetScriptsDebugOverlaySystem(this.GetGameInstance()).CreateSink();
    SDOSink.SetRoot(sink, "Prevention");
    SDOSink.PushString(sink, "District", TDBID.ToStringDEBUG(this.m_districtManager.GetCurrentDistrict().GetDistrictID()));
    SDOSink.PushString(sink, "Preset", TDBID.ToStringDEBUG(this.m_districtManager.GetCurrentDistrict().GetPresetID()));
  }

  private final func RefreshDebugSecAreaInfo() -> Void {
    let sink: SDOSink = GameInstance.GetScriptsDebugOverlaySystem(this.GetGameInstance()).CreateSink();
    SDOSink.SetRoot(sink, "Prevention");
    SDOSink.PushBool(sink, "Player is in seciurity area", ArraySize(this.m_playerIsInSecurityArea) > 0);
  }

  private final func ProcessDogtownLawAchievement() -> Void {
    let achievementRequest: ref<AddAchievementRequest>;
    let achievement: gamedataAchievement = gamedataAchievement.DogtownLaw;
    let dataTrackingSystem: ref<DataTrackingSystem> = GameInstance.GetScriptableSystemsContainer(this.GetGame()).Get(n"DataTrackingSystem") as DataTrackingSystem;
    let currentDistrict: wref<District> = this.m_districtManager.GetCurrentDistrict();
    if !currentDistrict.IsDogTown() {
      return;
    };
    achievementRequest = new AddAchievementRequest();
    achievementRequest.achievement = achievement;
    dataTrackingSystem.QueueRequest(achievementRequest);
  }
}

public class ShouldPoliceReactionBeAggressive extends PreventionConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    if AIBehaviorScriptBase.GetPuppet(context).IsPrevention() && !PreventionSystem.ShouldReactionBeAgressive(ScriptExecutionContext.GetOwner(context).GetGame()) {
      return AIbehaviorConditionOutcomes.False;
    };
    return AIbehaviorConditionOutcomes.True;
  }
}

public class PreventionDamage extends ScriptableSystemRequest {

  public let target: wref<GameObject>;

  public let attackTime: Float;

  public let attackType: gamedataAttackType;

  public let damageDealtPercent: Float;

  public let isTargetKilled: Bool;

  public final const func GetTelemetryDescription() -> String {
    return PreventionDamage.GetTelemetryDescription(this.target, this.isTargetKilled);
  }

  public final static func GetTelemetryDescription(target: ref<GameObject>, isTargetKilled: Bool) -> String {
    return isTargetKilled ? "Kill" : "Damage" + PreventionDamage.GetTargetTelemetryDescription(target);
  }

  private final static func GetTargetTelemetryDescription(target: ref<GameObject>) -> String {
    let puppet: ref<ScriptedPuppet> = target as ScriptedPuppet;
    if IsDefined(puppet) && puppet.IsCharacterCivilian() {
      return "Civilian";
    };
    if IsDefined(target) && target.IsPrevention() {
      return "Prevention";
    };
    return "Other";
  }
}

public class TogglePreventionCrowdSpawns extends ScriptableSystemRequest {

  public edit let toggle: Bool;

  public final func GetFriendlyDesctiption() -> String {
    return "Toggles Prevention System units spawning in crowd. Enabled by default. Please re-enable after disabling.";
  }
}

public class SetWantedLevel extends ScriptableSystemRequest {

  @default(SetWantedLevel, EPreventionHeatStage.Heat_0)
  public edit let m_wantedLevel: EPreventionHeatStage;

  @default(SetWantedLevel, false)
  public edit let m_forceGreyStars: Bool;

  @default(SetWantedLevel, false)
  public edit let m_resetGreyStars: Bool;

  public edit let m_forcePlayerPositionAsLastCrimePoint: Bool;

  @default(SetWantedLevel, false)
  public edit let m_forceIgnoreSecurityAreas: Bool;

  public final func GetFriendlyDescription() -> String {
    return "Set Wanted Level";
  }
}

public class SetHeatCounterMultiplier extends ScriptableSystemRequest {

  @default(SetHeatCounterMultiplier, 1.f)
  public edit let m_heatMultiplier: Float;

  public edit let m_reset: Bool;

  public edit let source: CName;

  public final func GetFriendlyDesctiption() -> String {
    return "Set Heat Counter Multiplier";
  }
}

public class SetHeatLevelLimiter extends ScriptableSystemRequest {

  @default(SetHeatLevelLimiter, 0)
  public edit let m_HeatLevelMin: Int32;

  @default(SetHeatLevelLimiter, 5)
  public edit let m_HeatLevelMax: Int32;

  @default(SetHeatLevelLimiter, false)
  public edit let m_HeatLevelReset: Bool;

  public edit let source: CName;

  public final func GetFriendlyDesctiption() -> String {
    return "Set Minimum and Maximum Heat levels.";
  }
}

public class SetPreventionPath extends ScriptableSystemRequest {

  @default(SetPreventionPath, EVehicleSpawnBlockSide.Default)
  public edit let m_blockSpawnFrom: EVehicleSpawnBlockSide;

  public edit let m_resetToDefault: Bool;

  public edit let source: CName;

  public final func GetFriendlyDesctiption() -> String {
    return "Set Spawning points for vehicles. This will enforce or block certain spawn angles for police vehicles.";
  }
}

public class SetPreventionDifficulty extends ScriptableSystemRequest {

  @default(SetPreventionDifficulty, 1.f)
  public edit let m_damageDealtToPlayerMultiplier: Float;

  @default(SetPreventionDifficulty, 1.f)
  public edit let m_chaseAggressivnessMultiplier: Float;

  @default(SetPreventionDifficulty, false)
  public edit let m_difficuiltyReset: Bool;

  public edit let source: CName;

  public final func GetFriendlyDesctiption() -> String {
    return "Change Difficuilty of Police.";
  }
}

public class SetPoliceSearchArea extends ScriptableSystemRequest {

  @default(SetPoliceSearchArea, -1.f)
  public edit let m_SearchAreaRadius: Float;

  @default(SetPoliceSearchArea, -1.f)
  public edit let m_ChaseDistance: Float;

  @default(SetPoliceSearchArea, false)
  public edit let m_resetToDefault: Bool;

  public edit let source: CName;

  public final func GetFriendlyDesctiption() -> String {
    return "Edit search area of the police when searching for the player. Edit chase distance (how far the police can fall behind) when player is running away from the police.";
  }
}

public class TogglePreventionFreeArea extends ScriptableSystemRequest {

  public edit let m_areaReference: NodeRef;

  public edit let m_enable: Bool;

  public final func GetFriendlyDesctiption() -> String {
    return "Enables the free area, previously added to the world. Prevention NPCs won\'t enter or spawn in the area.";
  }
}

public class ToggleQuestPreventionTrigger extends ScriptableSystemRequest {

  public edit let m_areaReference: NodeRef;

  @default(ToggleQuestPreventionTrigger, false)
  public edit let m_enable: Bool;

  public final func GetFriendlyDesctiption() -> String {
    return "Enables the quest trigger, previously added to the world. Prevention System will get disabled upon entering active trigger";
  }
}

public class TogglePreventionGlobalQuestObjective extends ScriptableSystemRequest {

  @default(TogglePreventionGlobalQuestObjective, true)
  public edit let m_preventionGlobalQuestDisabled: Bool;

  @default(TogglePreventionGlobalQuestObjective, fill_in_with_valid_source_name)
  public edit let m_eventSource: CName;

  public final func GetFriendlyDesctiption() -> String {
    return "Toggle functionality that enables prevention system to interrupt current quest objective";
  }
}

public class ToggleBlockSceneInteractions extends ScriptableSystemRequest {

  @default(ToggleBlockSceneInteractions, false)
  public edit let m_block: Bool;

  public final func GetFriendlyDesctiption() -> String {
    return "Toggle functionality that enables prevention system to interrupt current quest objective";
  }
}

public class TryResetPreventionFreeArea extends ScriptableSystemRequest {

  public final func GetFriendlyDesctiption() -> String {
    return "This event is used to poll whether player is inside prevention free area, and reset the status if that is no longer the case.";
  }
}

public class SetBlockShootingFromVehicle extends ScriptableSystemRequest {

  public edit let m_enable: Bool;

  public final func GetFriendlyDesctiption() -> String {
    return "Toggles NPC shooting from vehicle behaviour, enabled by default";
  }
}

public class SetPoliceForcesPool extends ScriptableSystemRequest {

  @default(SetPoliceForcesPool, false)
  public edit let m_disableOnFootSpawn: Bool;

  @default(SetPoliceForcesPool, false)
  public edit let m_disableVehicleSpawn: Bool;

  @default(SetPoliceForcesPool, false)
  public edit let m_disableDroneSpawn: Bool;

  @default(SetPoliceForcesPool, false)
  public edit let m_resetToDefault: Bool;

  public edit let source: CName;

  public final func GetFriendlyDesctiption() -> String {
    return "Allows to block spawning Police NPC on certain conditions.";
  }
}

public static func IntToEPreventionHeatStage(index: Int32) -> EPreventionHeatStage {
  if index < 0 {
    index = 0;
  };
  if index >= 6 {
    index = 5;
  };
  return IntEnum<EPreventionHeatStage>(index);
}
