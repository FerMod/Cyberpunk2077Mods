
public class PoliceAgentRegistry extends IScriptable {

  private let m_game: GameInstance;

  private let m_vehicleAgents: [ref<VehicleAgent>];

  private let m_npcAgents: [ref<NPCAgent>];

  private let m_requestTickets: [TicketData];

  public final func GetNPCList() -> [ref<NPCAgent>] {
    return this.m_npcAgents;
  }

  public final func GetVehicleList() -> [ref<VehicleAgent>] {
    return this.m_vehicleAgents;
  }

  public final func GetTotalVehicleCount() -> Int32 {
    return ArraySize(this.m_vehicleAgents);
  }

  public final func GetTotalPendingTicketsCount() -> Int32 {
    return ArraySize(this.m_requestTickets);
  }

  public final func GetTotalNPCCount() -> Int32 {
    let count: Int32;
    let i: Int32 = 0;
    while i < ArraySize(this.m_npcAgents) {
      if !this.m_npcAgents[i].isQuestNPC {
        count += 1;
      };
      i += 1;
    };
    return count;
  }

  public final func GetFallbackNPCCount() -> Int32 {
    let count: Int32;
    let i: Int32 = 0;
    while i < ArraySize(this.m_npcAgents) {
      if this.m_npcAgents[i].spawnedAsFallback {
        count += 1;
      };
      i += 1;
    };
    return count;
  }

  public final func GetPendingFallbackOnFootTicketCount() -> Int32 {
    let count: Int32;
    let i: Int32 = 0;
    while i < ArraySize(this.m_requestTickets) {
      if this.m_requestTickets[i].isFallback {
        count += 1;
      };
      i += 1;
    };
    return count;
  }

  public final func GetPendingVehicleTicketsCount() -> Int32 {
    let count: Int32;
    let i: Int32 = 0;
    while i < ArraySize(this.m_requestTickets) {
      if NotEquals(this.m_requestTickets[i].policeStrategy, vehiclePoliceStrategy.None) {
        count += 1;
      };
      i += 1;
    };
    return count;
  }

  public final func GetExternalNPCCount() -> Int32 {
    let count: Int32;
    let i: Int32 = 0;
    while i < ArraySize(this.m_npcAgents) {
      if !this.m_npcAgents[i].spawnedAsFallback && Equals(this.m_npcAgents[i].spawnedType, DynamicVehicleType.None) {
        count += 1;
      };
      i += 1;
    };
    return count;
  }

  public final func GetMaxTacNPCCount() -> Int32 {
    let count: Int32;
    let i: Int32 = 0;
    while i < ArraySize(this.m_npcAgents) {
      if Equals(this.m_npcAgents[i].spawnedType, DynamicVehicleType.AV) {
        count += 1;
      };
      i += 1;
    };
    return count;
  }

  public final func GetMaxTacNPCList() -> [ref<NPCAgent>] {
    let list: array<ref<NPCAgent>>;
    let i: Int32 = 0;
    while i < ArraySize(this.m_npcAgents) {
      if Equals(this.m_npcAgents[i].spawnedType, DynamicVehicleType.AV) {
        ArrayPush(list, this.m_npcAgents[i]);
      };
      i += 1;
    };
    return list;
  }

  public final func IsPreventionMaxTac(puppet: ref<gamePuppet>) -> Bool {
    let arr: array<ref<NPCAgent>> = this.GetMaxTacNPCList();
    let i: Int32 = 0;
    while i < ArraySize(arr) {
      if arr[i].id == puppet.GetEntityID() {
        return true;
      };
      i += 1;
    };
    return false;
  }

  public final func DistanceSquaredToTClosestMaxTacAgent(positionToCheck: Vector4) -> Float {
    let currentDistanceSquared: Float;
    let maxTacAgentsList: array<ref<NPCAgent>> = this.GetMaxTacNPCList();
    let minDistanceSquared: Float = Vector4.DistanceSquared(maxTacAgentsList[0].unit.GetWorldPosition(), positionToCheck);
    let i: Int32 = 1;
    while i < ArraySize(maxTacAgentsList) {
      currentDistanceSquared = Vector4.DistanceSquared(maxTacAgentsList[i].unit.GetWorldPosition(), positionToCheck);
      minDistanceSquared = currentDistanceSquared < minDistanceSquared ? currentDistanceSquared : minDistanceSquared;
      i += 1;
    };
    return minDistanceSquared;
  }

  public final func GetEngagedVehicleList() -> [ref<VehicleAgent>] {
    let engagedVehicles: array<ref<VehicleAgent>>;
    let vehicle: ref<VehicleAgent>;
    let i: Int32 = 0;
    while i < ArraySize(this.m_npcAgents) {
      if NotEquals(this.m_npcAgents[i].spawnedType, DynamicVehicleType.Car) || !NPCPuppet.IsInCombat(this.m_npcAgents[i].unit) {
      } else {
        if !this.TryGetVehicleAgentByID(this.m_npcAgents[i].TryGetAssignedVehicleId(), vehicle) {
        } else {
          if ArrayContains(engagedVehicles, vehicle) {
          } else {
            ArrayPush(engagedVehicles, vehicle);
          };
        };
      };
      i += 1;
    };
    return engagedVehicles;
  }

  public final func GetEngagedNotDisengagingVehicleList(out vehicleArray: [ref<VehicleAgent>]) -> Bool {
    let i: Int32;
    ArrayClear(vehicleArray);
    vehicleArray = this.GetEngagedVehicleList();
    i = ArraySize(vehicleArray) - 1;
    while i >= 0 {
      if Equals(vehicleArray[i].lifetimeStatus, LifetimeStatus.Disengaging) {
        ArrayErase(vehicleArray, i);
      };
      i -= 1;
    };
    return ArraySize(vehicleArray) > 0;
  }

  public final func GetSupportVehicleList() -> [ref<VehicleAgent>] {
    let supportVehicles: array<ref<VehicleAgent>>;
    let vehicle: ref<VehicleAgent>;
    let i: Int32 = 0;
    while i < ArraySize(this.m_npcAgents) {
      if NotEquals(this.m_npcAgents[i].spawnedType, DynamicVehicleType.Car) || NPCPuppet.IsInCombat(this.m_npcAgents[i].unit) {
      } else {
        if !this.TryGetVehicleAgentByID(this.m_npcAgents[i].TryGetAssignedVehicleId(), vehicle) {
        } else {
          if ArrayContains(supportVehicles, vehicle) {
          } else {
            ArrayPush(supportVehicles, vehicle);
          };
        };
      };
      i += 1;
    };
    return supportVehicles;
  }

  public final func GetAvCount() -> Int32 {
    let count: Int32;
    let i: Int32 = 0;
    while i < ArraySize(this.m_vehicleAgents) {
      if Equals(this.m_vehicleAgents[i].spawnedType, DynamicVehicleType.AV) {
        count += 1;
      };
      i += 1;
    };
    return count;
  }

  public final func GetRoadblockCount() -> Int32 {
    let count: Int32;
    let i: Int32 = 0;
    while i < ArraySize(this.m_vehicleAgents) {
      if Equals(this.m_vehicleAgents[i].spawnedType, DynamicVehicleType.RoadBlockade) || Equals(this.m_vehicleAgents[i].spawnedType, DynamicVehicleType.RoadBlockadeWithAV) {
        count += 1;
      };
      i += 1;
    };
    return count;
  }

  public final func GetRoadblockNPCList() -> [ref<NPCAgent>] {
    let list: array<ref<NPCAgent>>;
    let i: Int32 = 0;
    while i < ArraySize(this.m_npcAgents) {
      if Equals(this.m_npcAgents[i].spawnedType, DynamicVehicleType.RoadBlockade) || Equals(this.m_npcAgents[i].spawnedType, DynamicVehicleType.RoadBlockadeWithAV) {
        ArrayPush(list, this.m_npcAgents[i]);
      };
      i += 1;
    };
    return list;
  }

  public final func GetRoadblockVehicleList() -> [ref<VehicleAgent>] {
    let list: array<ref<VehicleAgent>>;
    let i: Int32 = 0;
    while i < ArraySize(this.m_vehicleAgents) {
      if Equals(this.m_vehicleAgents[i].spawnedType, DynamicVehicleType.RoadBlockade) || Equals(this.m_vehicleAgents[i].spawnedType, DynamicVehicleType.RoadBlockadeWithAV) {
        ArrayPush(list, this.m_vehicleAgents[i]);
      };
      i += 1;
    };
    return list;
  }

  public final func GetSupportVehiclesWithStrategyCount(strategy: vehiclePoliceStrategy) -> Int32 {
    let count: Int32;
    let list: array<ref<VehicleAgent>> = this.GetSupportVehicleList();
    let i: Int32 = 0;
    while i < ArraySize(list) {
      if Equals(list[i].unit.GetPoliceStrategy(), strategy) {
        count += 1;
      };
      i += 1;
    };
    return count;
  }

  public final func GetEngagedVehicleCount() -> Int32 {
    let list: array<ref<VehicleAgent>> = this.GetEngagedVehicleList();
    return ArraySize(list);
  }

  public final func GetSupportVehicleCount() -> Int32 {
    let list: array<ref<VehicleAgent>> = this.GetSupportVehicleList();
    return ArraySize(list);
  }

  public final func GetNPCsAssignedToVehicle(vehicleEntityId: EntityID, toFill: script_ref<[ref<NPCAgent>]>) -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.m_npcAgents) {
      if this.m_npcAgents[i].TryGetAssignedVehicleId() == vehicleEntityId {
        ArrayPush(Deref(toFill), this.m_npcAgents[i]);
      };
      i += 1;
    };
  }

  public final func GetVehiclesWithoutRegisteredPassengers(toFill: script_ref<[ref<VehicleAgent>]>) -> Void {
    let vehicleID: EntityID;
    let vehiclesAssignedToNPCs: array<EntityID>;
    let i: Int32 = 0;
    while i < ArraySize(this.m_npcAgents) {
      vehicleID = this.m_npcAgents[i].TryGetAssignedVehicleId();
      if !ArrayContains(vehiclesAssignedToNPCs, vehicleID) {
        ArrayPush(vehiclesAssignedToNPCs, vehicleID);
      };
      i += 1;
    };
    i = 0;
    while i < ArraySize(this.m_vehicleAgents) {
      if NotEquals(this.m_vehicleAgents[i].spawnedType, DynamicVehicleType.Car) {
      } else {
        if !this.m_vehicleAgents[i].everHadPassengers {
        } else {
          vehicleID = this.m_vehicleAgents[i].id;
          if ArrayContains(vehiclesAssignedToNPCs, vehicleID) {
            ArrayRemove(vehiclesAssignedToNPCs, vehicleID);
          } else {
            ArrayPush(Deref(toFill), this.m_vehicleAgents[i]);
          };
        };
      };
      i += 1;
    };
  }

  public final func IsPoliceInCombatWithPalyer() -> Bool {
    let player: ref<Entity> = GetPlayerObject(this.m_game);
    let i: Int32 = 0;
    while i <= ArraySize(this.m_npcAgents) {
      if NPCPuppet.IsInCombatWithTarget(this.m_npcAgents[i].unit, player) {
        return true;
      };
      i += 1;
    };
    return false;
  }

  public final func HasPoliceRecentlyDeescalated() -> Bool {
    let targetTrackingExtension: ref<TargetTrackingExtension>;
    let threatData: DroppedThreatData;
    let i: Int32 = 0;
    while i <= ArraySize(this.m_npcAgents) {
      targetTrackingExtension = this.m_npcAgents[i].unit.GetTargetTrackerComponent() as TargetTrackingExtension;
      if IsDefined(targetTrackingExtension) {
        threatData = targetTrackingExtension.GetRecentlyDroppedThreat();
        if IsDefined(threatData.threat) && (threatData.threat as GameObject).IsPlayer() {
          return true;
        };
      };
      i += 1;
    };
    return false;
  }

  public final func HasNPCBeenAttackedByPlayer(id: EntityID) -> Bool {
    let agent: ref<NPCAgent>;
    if this.TryGetNPCAgentByID(id, agent) {
      if agent.hasBeenAttackedByPlayer {
        return true;
      };
    };
    return false;
  }

  public final static func Construct(game: GameInstance) -> ref<PoliceAgentRegistry> {
    let registry: ref<PoliceAgentRegistry> = new PoliceAgentRegistry();
    registry.m_game = game;
    return registry;
  }

  public final func Contains(id: EntityID) -> Bool {
    let contains: Bool = this.TryGetIndexOf_NPC(id) || this.TryGetIndexOf_Vehicle(id);
    return contains;
  }

  public final func TryGetNPCAgentByID(id: EntityID, agent: script_ref<ref<NPCAgent>>) -> Bool {
    let i: Int32;
    if this.TryGetIndexOf_NPC(id, i) {
      agent = this.m_npcAgents[i];
      return true;
    };
    return false;
  }

  public final func TryGetVehicleAgentByID(id: EntityID, agent: script_ref<ref<VehicleAgent>>) -> Bool {
    let i: Int32;
    if this.TryGetIndexOf_Vehicle(id, i) {
      agent = this.m_vehicleAgents[i];
      return true;
    };
    return false;
  }

  public final func GetNPCSpawnedType(id: EntityID) -> DynamicVehicleType {
    let agent: ref<NPCAgent>;
    if this.TryGetNPCAgentByID(id, agent) {
      return agent.spawnedType;
    };
    return DynamicVehicleType.None;
  }

  public final func RegisterAgent(unit: ref<GameObject>, type: DynamicVehicleType, opt strategy: vehiclePoliceStrategy, opt isFallback: Bool, overrideExisting: Bool) -> Bool {
    let i: Int32;
    let npcAgent: ref<NPCAgent>;
    let vehicleAgent: ref<VehicleAgent>;
    let id: EntityID = unit.GetEntityID();
    if unit.IsPuppet() {
      if this.TryGetIndexOf_NPC(id, i) {
        if overrideExisting {
          npcAgent = this.m_npcAgents[i];
        } else {
          return false;
        };
      } else {
        npcAgent = new NPCAgent();
        ArrayPush(this.m_npcAgents, npcAgent);
      };
      npcAgent.id = id;
      npcAgent.gameObject = unit;
      npcAgent.unit = unit as ScriptedPuppet;
      npcAgent.spawnedType = type;
      npcAgent.spawnedAsFallback = isFallback;
      npcAgent.isQuestNPC = NPCManager.HasTag((unit as ScriptedPuppet).GetRecordID(), n"Scripted_Patrol");
      if Equals(type, DynamicVehicleType.AV) {
        StatusEffectHelper.ApplyStatusEffectOnSelf(unit.GetGame(), t"BaseStatusEffect.MaxtacCloaked", unit.GetEntityID());
      };
    } else {
      if unit.IsVehicle() {
        if this.TryGetIndexOf_Vehicle(id, i) {
          if overrideExisting {
            vehicleAgent = this.m_vehicleAgents[i];
          } else {
            return false;
          };
        } else {
          vehicleAgent = new VehicleAgent();
          ArrayPush(this.m_vehicleAgents, vehicleAgent);
        };
        vehicleAgent.id = id;
        vehicleAgent.gameObject = unit;
        vehicleAgent.unit = unit as VehicleObject;
        vehicleAgent.spawnedType = type;
      };
    };
    return true;
  }

  public final func UnregisterAgent(id: EntityID) -> UnregisterResult {
    let i: Int32;
    let result: UnregisterResult;
    if this.TryGetIndexOf_NPC(id, i) {
      result.success = true;
      result.isVehicle = false;
      result.spawnedType = this.m_npcAgents[i].spawnedType;
      ArrayErase(this.m_npcAgents, i);
    } else {
      if this.TryGetIndexOf_Vehicle(id, i) {
        result.success = true;
        result.isVehicle = true;
        result.spawnedType = this.m_vehicleAgents[i].spawnedType;
        ArrayErase(this.m_vehicleAgents, i);
      };
    };
    return result;
  }

  public final func UnregisterAll() -> Void {
    ArrayClear(this.m_npcAgents);
    ArrayClear(this.m_vehicleAgents);
  }

  public final func UpdateVehiclePassengerCount(vehicleID: EntityID, passengers: Int32) -> Void {
    let i: Int32;
    let vehicleAgent: ref<VehicleAgent>;
    if this.TryGetIndexOf_Vehicle(vehicleID, i) {
      vehicleAgent = this.m_vehicleAgents[i];
      vehicleAgent.passangers = passengers;
      vehicleAgent.slotsAvailable = vehicleAgent.slotsTotal - passengers;
      if passengers > 0 {
        vehicleAgent.everHadPassengers = true;
      };
    };
  }

  private final func TryGetIndexOf_NPC(id: EntityID, opt index: script_ref<Int32>) -> Bool {
    let i: Int32 = 0;
    while i <= ArraySize(this.m_npcAgents) - 1 {
      if this.m_npcAgents[i].id == id {
        index = i;
        return true;
      };
      i += 1;
    };
    return false;
  }

  private final func TryGetIndexOf_Vehicle(id: EntityID, opt index: script_ref<Int32>) -> Bool {
    let i: Int32 = 0;
    while i <= ArraySize(this.m_vehicleAgents) - 1 {
      if this.m_vehicleAgents[i].id == id {
        index = i;
        return true;
      };
      i += 1;
    };
    return false;
  }

  private final const func TryGetIndexOf_Ticket(id: Uint32, opt index: script_ref<Int32>) -> Bool {
    let i: Int32 = 0;
    while i <= ArraySize(this.m_requestTickets) - 1 {
      if this.m_requestTickets[i].requestID == id {
        index = i;
        return true;
      };
      i += 1;
    };
    return false;
  }

  public final func CreateTicket(request: Uint32, strategy: vehiclePoliceStrategy, opt isFallback: Bool) -> Void {
    let ticket: TicketData;
    ticket.requestID = request;
    ticket.policeStrategy = strategy;
    ticket.isFallback = isFallback;
    ArrayPush(this.m_requestTickets, ticket);
  }

  public final func PopRequestTicket(request: Uint32, opt ticketData: script_ref<TicketData>) -> Bool {
    let i: Int32;
    if !this.TryGetIndexOf_Ticket(request, i) {
      return false;
    };
    ticketData = this.m_requestTickets[i];
    ArrayErase(this.m_requestTickets, i);
    return true;
  }
}

public class NPCAgent extends AgentBase {

  public let unit: wref<ScriptedPuppet>;

  public let hasBeenAttackedByPlayer: Bool;

  public let isQuestNPC: Bool;

  public let spawnedAsFallback: Bool;

  public let markedToBeDespawned: Bool;

  public final func TryGetAssignedVehicleId() -> EntityID {
    let assignedVehicleID: EntityID;
    if IsDefined(this.unit) {
      assignedVehicleID = this.unit.GetAIControllerComponent().GetAssignedVehicleId();
    };
    return assignedVehicleID;
  }
}

public class VehicleAgent extends AgentBase {

  public let unit: wref<VehicleObject>;

  public let passangers: Int32;

  public let slotsTotal: Int32;

  public let slotsReserved: Int32;

  public let slotsAvailable: Int32;

  @default(VehicleAgent, false)
  public let everHadPassengers: Bool;

  public let distanceToPlayerSquared: Float;

  public let lifetimeStatus: LifetimeStatus;

  @default(VehicleAgent, -1.f)
  public let nearTimeStamp: Float;

  public final func UpdateLifetimeStatus(playerPos: Vector4) -> Void {
    let now: Float;
    let unitStrong: ref<VehicleObject> = this.unit;
    let vehicleStrategyDespawnDistanceSquared: Float = TweakDBInterface.GetFloat(t"PreventionSystem.setup.vehicleStrategyDespawnDistanceSquared", 490000.00);
    let vehicleStrategyNearDespawnDistanceSquared: Float = TweakDBInterface.GetFloat(t"PreventionSystem.setup.vehicleStrategyNearDespawnDistanceSquared", 40000.00);
    let vehicleStrategyEnterNearStateDistanceSquared: Float = TweakDBInterface.GetFloat(t"PreventionSystem.setup.vehicleStrategyEnterNearStateDistanceSquared", 40000.00);
    if !IsDefined(unitStrong) {
      return;
    };
    if NotEquals(this.spawnedType, DynamicVehicleType.Car) {
      return;
    };
    if NotEquals(this.lifetimeStatus, LifetimeStatus.Disengaging) {
      if unitStrong.IsDestroyed() {
        this.Disengage();
        return;
      };
    };
    this.distanceToPlayerSquared = Vector4.DistanceSquared(playerPos, unitStrong.GetWorldPosition());
    now = EngineTime.ToFloat(GameInstance.GetEngineTime(unitStrong.GetGame()));
    if Equals(this.lifetimeStatus, LifetimeStatus.Base) {
      if this.distanceToPlayerSquared > vehicleStrategyDespawnDistanceSquared {
        this.Disengage();
      } else {
        if this.distanceToPlayerSquared < vehicleStrategyEnterNearStateDistanceSquared {
          if this.nearTimeStamp < 0.00 {
            this.nearTimeStamp = now;
          } else {
            if now - this.nearTimeStamp > 3.00 {
              this.lifetimeStatus = LifetimeStatus.Near;
            };
          };
        } else {
          if this.nearTimeStamp > 0.00 {
            this.nearTimeStamp = -1.00;
          };
        };
      };
    } else {
      if Equals(this.lifetimeStatus, LifetimeStatus.Near) && this.distanceToPlayerSquared > vehicleStrategyNearDespawnDistanceSquared {
        this.Disengage();
      };
    };
  }

  public final func Disengage() -> Void {
    let unitStrong: ref<VehicleObject> = this.unit;
    if Equals(this.lifetimeStatus, LifetimeStatus.Disengaging) {
      return;
    };
    if IsDefined(unitStrong) {
      GameInstance.GetPreventionSpawnSystem(unitStrong.GetGame()).RequestDespawnVehicleAndPassengers(unitStrong);
    };
    this.lifetimeStatus = LifetimeStatus.Disengaging;
  }
}

public class IsNPCMarkedForDespawn extends AIbehaviorconditionScript {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let isMarkedForDespawn: Bool;
    let preventionSystem: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(ScriptExecutionContext.GetOwner(context).GetGame()).Get(n"PreventionSystem") as PreventionSystem;
    if !IsDefined(preventionSystem) {
      return AIbehaviorConditionOutcomes.False;
    };
    if preventionSystem.TryGetNPCMarkedForDespawnAI(ScriptExecutionContext.GetOwner(context).GetEntityID(), isMarkedForDespawn) {
      return Cast<AIbehaviorConditionOutcomes>(isMarkedForDespawn);
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class MarkNPCAgentForDespawn extends AIbehaviortaskScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let preventionSystem: ref<PreventionSystem> = GameInstance.GetScriptableSystemsContainer(ScriptExecutionContext.GetOwner(context).GetGame()).Get(n"PreventionSystem") as PreventionSystem;
    if !IsDefined(preventionSystem) {
      return;
    };
    preventionSystem.TrySetNPCMarkedForDespawnAI(ScriptExecutionContext.GetOwner(context).GetEntityID(), true);
  }
}
