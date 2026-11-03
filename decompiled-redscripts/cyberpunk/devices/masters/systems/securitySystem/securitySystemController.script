
public class SecuritySystemController extends DeviceSystemBaseController {

  public const func GetPS() -> ref<SecuritySystemControllerPS> {
    return this.GetBasePS() as SecuritySystemControllerPS;
  }
}

public class SecuritySystemControllerPS extends DeviceSystemBaseControllerPS {

  private let m_level_0: [SecurityAccessLevelEntry];

  private let m_level_1: [SecurityAccessLevelEntry];

  private let m_level_2: [SecurityAccessLevelEntry];

  private let m_level_3: [SecurityAccessLevelEntry];

  private let m_level_4: [SecurityAccessLevelEntry];

  @runtimeProperty("tooltip", "if all security areas are safe and/or disabled then security system will disable itself and hide from the minimap")
  @default(SecuritySystemControllerPS, true)
  private let m_allowSecuritySystemToDisableItself: Bool;

  @runtimeProperty("customEditor", "TweakDBGroupInheritance;AttitudeGroup")
  @runtimeProperty("tooltip", "All devices connected to security system will have this attitude group set. It DOES NOT Have to be the same attitude group as NPCs")
  private persistent let m_attitudeGroup: TweakDBID;

  @runtimeProperty("tooltip", "BE CAREFUL WHEN SETTING UP! IF YOU TURN THIS ON -> Security System will still work normally, but the relation of security system group will not change towards anyone with whom Security System is in COMBAT. You can still change attitude through quest block")
  private let m_suppressAbilityToModifyAttitude: Bool;

  private persistent let m_attitudeChangeMode: EShouldChangeAttitude;

  @runtimeProperty("tooltip", "In case player triggers Security System, how much time should pass before security system changes its attitude towards player back to default. Setting this up is optional. If unchanged Security System will not reset automatically")
  private let m_performAutomaticResetAfter: Time;

  @runtimeProperty("tooltip", "IF TRUE > Player will not see areas on the minimap and he will not receive UI Notification that he is in certain area")
  private persistent let m_hideAreasOnMinimap: Bool;

  private persistent let m_isUnderStrictQuestControl: Bool;

  @default(SecuritySystemControllerPS, ESecuritySystemState.SAFE)
  private persistent let m_securitySystemState: ESecuritySystemState;

  @runtimeProperty("unsavable", "true")
  private persistent let m_agentsRegistry: ref<AgentRegistry>;

  private let m_securitySystem: ref<SecuritySystemControllerPS>;

  @runtimeProperty("unsavable", "true")
  private persistent let m_latestOutputEngineTime: Float;

  @default(SecuritySystemControllerPS, 1.0f)
  private let m_updateInterval: Float;

  @default(SecuritySystemControllerPS, 60)
  private const let m_restartDuration: Int32;

  @runtimeProperty("unsavable", "true")
  private persistent let m_protectedEntityIDs: [EntityID];

  @runtimeProperty("unsavable", "true")
  private persistent let m_entitiesRemainingAtGate: [EntityID];

  @runtimeProperty("unsavable", "true")
  private persistent let m_blacklist: [ref<BlacklistEntry>];

  @runtimeProperty("unsavable", "true")
  private persistent let m_currentReprimandID: Int32;

  @runtimeProperty("unsavable", "true")
  private persistent let m_blacklistDelayValid: Bool;

  @runtimeProperty("unsavable", "true")
  private persistent let m_blacklistDelayID: DelayID;

  @default(SecuritySystemControllerPS, 4)
  private const let m_maxGlobalWarningsCount: Int32;

  @runtimeProperty("unsavable", "true")
  private persistent let m_delayIDValid: Bool;

  @runtimeProperty("unsavable", "true")
  private persistent let m_deescalationEventID: DelayID;

  @runtimeProperty("unsavable", "true")
  private persistent let m_outputsSend: Int32;

  @runtimeProperty("unsavable", "true")
  private persistent let m_inputsReceived: Int32;

  protected final func HandleSecuritySystemInputByTask(inputEvent: ref<SecuritySystemInput>) -> Void {
    let data: ref<SecuritySystemInputTaskData> = new SecuritySystemInputTaskData();
    data.cachedEvt = inputEvent;
    GameInstance.GetDelaySystem(this.GetGameInstance()).QueueTask(this, data, n"HandleSecuritySystemInputTask", gameScriptTaskExecutionStage.Any);
  }

  protected final func HandleSecuritySystemInputTask(data: ref<ScriptTaskData>) -> Void {
    let inputData: ref<SecuritySystemInputTaskData> = data as SecuritySystemInputTaskData;
    if IsDefined(inputData) {
      this.HandleSecuritySystemInput(inputData.cachedEvt);
    };
  }

  protected func Initialize() -> Void {
    let evt: ref<PSInitializeEvent>;
    super.Initialize();
    evt = new PSInitializeEvent();
    this.QueuePSEvent(this, evt);
  }

  public final func OnPSInitializeEvent(evt: ref<PSInitializeEvent>) -> EntityNotificationType {
    if !this.IsRegistryReady() {
      this.InitiateAgentRegistry();
    };
    if !IsNameValid(this.GetSecuritySystemAttitudeGroupName()) {
      this.SetSecuritySystemAttitudeGroup(t"Attitudes.Group_Neutral");
    };
    this.NotifyAboutAttitudeChange();
    return EntityNotificationType.DoNotNotifyEntity;
  }

  protected cb func OnInstantiated() -> Bool {
    let evt: ref<PSInstantiateEvent>;
    super.OnInstantiated();
    evt = new PSInstantiateEvent();
    this.QueuePSEvent(this, evt);
  }

  public final func OnPSInstantiateEvent(evt: ref<PSInstantiateEvent>) -> EntityNotificationType {
    this.m_attitudeChangeMode = EShouldChangeAttitude.TEMPORARLY;
    if !this.IsRegistryReady() {
      this.InitiateAgentRegistry();
    };
    if this.IsPoliceSecuritySystem() {
      PreventionSystem.PreventionPoliceSecuritySystemRequest(this.GetGameInstance(), this.GetID());
    };
    return EntityNotificationType.DoNotNotifyEntity;
  }

  private final const func IsRegistryReady() -> Bool {
    return this.m_agentsRegistry.IsReady();
  }

  private final func InitiateAgentRegistry() -> Void {
    let areas: array<ref<SecurityAreaControllerPS>>;
    if this.IsDisabled() {
      return;
    };
    areas = this.GetSecurityAreas();
    if ArraySize(areas) == 0 {
      return;
    };
    this.CompileSecurityAgentRegistry();
  }

  private final func CreateRegistry() -> Void {
    this.m_agentsRegistry = AgentRegistry.Construct();
  }

  private final func CompileSecurityAgentRegistry() -> Void {
    let i: Int32;
    let slaves: array<ref<DeviceComponentPS>>;
    if this.IsDisabled() {
      return;
    };
    if !this.m_agentsRegistry.IsReady() {
      this.CreateRegistry();
    };
    this.GetAllDescendants(slaves);
    i = 0;
    while i < ArraySize(slaves) {
      if IsDefined(slaves[i] as SecurityAreaControllerPS) || IsDefined(slaves[i] as CommunityProxyPS) {
      } else {
        this.AddAgentRecord(DeviceLink.Construct(slaves[i] as SharedGameplayPS), slaves[i].GetSecurityAreas(true), false);
      };
      i += 1;
    };
  }

  private final func AddAgentRecord(agent: DeviceLink, const connectedAreas: script_ref<[ref<SecurityAreaControllerPS>]>, requestLatestOutput: Bool) -> Void {
    this.m_agentsRegistry.RegisterAgent(agent, connectedAreas);
    if requestLatestOutput {
      this.RequestLatestOutput(DeviceLink.GetLinkID(agent));
    };
  }

  public final const func GetSensors() -> [ref<SensorDeviceControllerPS>] {
    let sensControllers: array<ref<SensorDeviceControllerPS>>;
    let sensor: ref<SensorDeviceControllerPS>;
    let sensAgents: array<Agent> = this.GetAgentRegistry().GetSensors();
    let i: Int32 = 0;
    while i < ArraySize(sensAgents) {
      sensor = this.GetPS(sensAgents[i].link) as SensorDeviceControllerPS;
      if IsDefined(sensor) {
        ArrayPush(sensControllers, sensor);
      };
      i += 1;
    };
    return sensControllers;
  }

  public final const quest func IsSystemSafe() -> Bool {
    return Equals(this.m_securitySystemState, ESecuritySystemState.SAFE);
  }

  public final const quest func IsSystemAlerted() -> Bool {
    return Equals(this.m_securitySystemState, ESecuritySystemState.ALERTED);
  }

  public final const quest func IsSystemInCombat() -> Bool {
    return Equals(this.m_securitySystemState, ESecuritySystemState.COMBAT);
  }

  private final const func IsSystemSafeOrUninitialized() -> Bool {
    return Equals(this.m_securitySystemState, ESecuritySystemState.SAFE) || Equals(this.m_securitySystemState, ESecuritySystemState.UNINITIALIZED);
  }

  public final const func IsHidden() -> Bool {
    return this.m_hideAreasOnMinimap;
  }

  public final const func GetAgentRegistry() -> ref<AgentRegistry> {
    return this.m_agentsRegistry;
  }

  public final const func GetSecurityState() -> ESecuritySystemState {
    return this.m_securitySystemState;
  }

  public const func GetDeviceStatusAction() -> ref<SecuritySystemStatus> {
    return this.ActionSecuritySystemStatus();
  }

  public final const func GetSecuritySystemAttitudeGroupName() -> CName {
    let attitudeName: CName;
    let record: ref<AttitudeGroup_Record> = TweakDBInterface.GetAttitudeGroupRecord(this.m_attitudeGroup);
    if IsDefined(record) {
      attitudeName = record.Name();
    };
    return attitudeName;
  }

  public final const func IsPoliceSecuritySystem() -> Bool {
    return Equals(this.GetSecuritySystemAttitudeGroupName(), n"police");
  }

  public final const func GetReprimandReceiver(agentID: PersistentID) -> EntityID {
    return this.m_agentsRegistry.GetReprimandReceiver(agentID);
  }

  public final const func DetermineSecurityAreaTypeForEntityID(entityID: EntityID) -> ESecurityAreaType {
    let i: Int32;
    let areaType: ESecurityAreaType = this.GetMostDangerousSecurityAreaForEntityID(entityID).GetSecurityAreaType();
    if Equals(areaType, ESecurityAreaType.DANGEROUS) {
      i = 0;
      while i < ArraySize(this.m_entitiesRemainingAtGate) {
        if entityID == this.m_entitiesRemainingAtGate[i] {
          areaType = ESecurityAreaType.RESTRICTED;
        };
        i += 1;
      };
    };
    return areaType;
  }

  public final const func GetMostDangerousSecurityAreaForEntityID(entityID: EntityID) -> ref<SecurityAreaControllerPS> {
    let foundSecurityArea: ref<SecurityAreaControllerPS>;
    let i: Int32;
    let currentSecAreaType: ESecurityAreaType = ESecurityAreaType.DISABLED;
    let secAreas: array<ref<SecurityAreaControllerPS>> = this.GetSecurityAreasWithUserInside(entityID);
    if ArraySize(secAreas) == 0 {
      return null;
    };
    i = 0;
    while i < ArraySize(secAreas) {
      if EnumInt(secAreas[i].GetSecurityAreaType()) > EnumInt(currentSecAreaType) {
        foundSecurityArea = secAreas[i];
        currentSecAreaType = secAreas[i].GetSecurityAreaType();
      };
      i += 1;
    };
    return foundSecurityArea;
  }

  public final const func GetMostDangerousSecurityAreaForEntityID(go: ref<GameObject>) -> ref<SecurityAreaControllerPS> {
    if IsDefined(go) {
      return this.GetMostDangerousSecurityAreaForEntityID(go.GetEntityID());
    };
    return null;
  }

  public final const func ShouldReactToTarget(suspect: EntityID, reporter: EntityID) -> Bool {
    if this.IsDisabled() || this.IsUnpowered() {
      return false;
    };
    if this.m_agentsRegistry.IsAgent(Cast<PersistentID>(suspect)) && NotEquals(this.GetAttitudeTowards(suspect), EAIAttitude.AIA_Hostile) {
      return false;
    };
    if Equals(this.GetAttitudeTowards(suspect), EAIAttitude.AIA_Friendly) {
      return false;
    };
    if Equals(this.GetAttitudeTowards(suspect), EAIAttitude.AIA_Hostile) {
      return true;
    };
    if this.IsEntityBlacklistedForAtLeast(suspect, BlacklistReason.COMBAT) {
      return true;
    };
    if this.m_securitySystemState > ESecuritySystemState.ALERTED && this.IsEntityBlacklistedForSpecificReason(suspect, BlacklistReason.TRESPASSING) {
      return true;
    };
    if this.m_securitySystemState > ESecuritySystemState.ALERTED {
      return this.IsUserInsideSystem(suspect);
    };
    return this.IsTargetTresspassingMyZone(suspect, reporter);
  }

  public final func TryReleaseFromReprimand(entityID: EntityID) -> Void {
    let target: EntityID;
    if this.IsReprimandOngoing() {
      target = this.GetReprimandReceiver(Cast<PersistentID>(entityID));
      if EntityID.IsDefined(target) {
        this.ReleaseCurrentPerformerFromReprimand(EReprimandInstructions.CONCLUDE_SUCCESSFUL, target);
      };
    };
  }

  protected final const func GetAgentAreas(agentID: PersistentID) -> [ref<SecurityAreaControllerPS>] {
    let area: ref<SecurityAreaControllerPS>;
    let areaLinks: array<DeviceLink>;
    let areas: array<ref<SecurityAreaControllerPS>>;
    let i: Int32;
    if IsDefined(this.m_agentsRegistry) {
      areaLinks = this.m_agentsRegistry.GetAgentAreas(agentID);
      i = 0;
      while i < ArraySize(areaLinks) {
        area = this.GetPS(areaLinks[i]) as SecurityAreaControllerPS;
        if IsDefined(area) {
          ArrayPush(areas, area);
        };
        i += 1;
      };
    };
    return areas;
  }

  public final const func GetSecurityBlacklist() -> [ref<BlacklistEntry>] {
    return this.m_blacklist;
  }

  public final const func IsTargetTresspassingMyZone(suspect: EntityID, reporter: EntityID) -> Bool {
    let breachLevel: ESecurityAccessLevel;
    let commonAreas: array<ref<SecurityAreaControllerPS>>;
    let i: Int32;
    let validAreas: array<ref<SecurityAreaControllerPS>>;
    if this.IsEntityBlacklistedForAtLeast(suspect, BlacklistReason.COMBAT) {
      return true;
    };
    commonAreas = this.GetOverlappingAreas(this.GetAgentAreas(Cast<PersistentID>(reporter)), this.GetSecurityAreasWithUserInside(suspect));
    i = 0;
    while i < ArraySize(commonAreas) {
      if commonAreas[i].GetSecurityAreaType() > ESecurityAreaType.SAFE {
        ArrayPush(validAreas, commonAreas[i]);
      };
      i += 1;
    };
    if ArraySize(validAreas) == 0 {
      return false;
    };
    breachLevel = this.FindHighestSecurityAccessLevel(validAreas);
    return !this.IsUserAuthorized(suspect, breachLevel);
  }

  public final const func IsUserInsideSystem(userToBeChecked: EntityID) -> Bool {
    let trash: ESecurityAccessLevel;
    return this.IsUserInsideSystem(userToBeChecked, trash);
  }

  public final const func IsUserInsideSystem(userToBeChecked: EntityID, out highestSecurityAccessLevel: ESecurityAccessLevel) -> Bool {
    let threat: ESecurityAreaType;
    return this.IsUserInsideSystem(userToBeChecked, highestSecurityAccessLevel, threat);
  }

  public final const func IsUserInsideSystem(userToBeChecked: EntityID, out highestSecurityAccessLevel: ESecurityAccessLevel, out highestThreat: ESecurityAreaType) -> Bool {
    let isInside: Bool;
    let secAreas: array<ref<SecurityAreaControllerPS>> = this.GetSecurityAreas();
    let i: Int32 = 0;
    while i < ArraySize(secAreas) {
      if secAreas[i].IsUserInside(userToBeChecked) {
        if highestSecurityAccessLevel < secAreas[i].GetSecurityAccessLevel() {
          highestSecurityAccessLevel = secAreas[i].GetSecurityAccessLevel();
        };
        if highestThreat < secAreas[i].GetSecurityAreaType() {
          highestThreat = secAreas[i].GetSecurityAreaType();
        };
        isInside = true;
      };
      i += 1;
    };
    return isInside;
  }

  public final const func IsEntityBlacklisted(entityID: EntityID) -> Bool {
    let index: Int32 = this.GetEntityBlacklistIndex(entityID);
    if index >= 0 {
      return true;
    };
    return false;
  }

  public final const func IsEntityBlacklisted(gameObject: ref<GameObject>) -> Bool {
    if IsDefined(gameObject) {
      return this.IsEntityBlacklisted(gameObject.GetEntityID());
    };
    return false;
  }

  public final const func IsEntityBlacklistedForAtLeast(entityID: EntityID, reason: BlacklistReason) -> Bool {
    let entryIndex: Int32 = this.GetEntityBlacklistIndex(entityID);
    if entryIndex >= 0 {
      if EnumInt(reason) > EnumInt(this.m_blacklist[entryIndex].GetReason()) {
        return false;
      };
      if Equals(reason, BlacklistReason.REPRIMAND) {
        return this.m_blacklist[entryIndex].GetWarningsCount() > this.m_maxGlobalWarningsCount;
      };
      if EnumInt(this.m_blacklist[entryIndex].GetReason()) >= EnumInt(reason) {
        return true;
      };
    };
    return false;
  }

  protected final const func IsEntityBlacklistedForSpecificReason(entityID: EntityID, reason: BlacklistReason) -> Bool {
    let entryIndex: Int32 = this.GetEntityBlacklistIndex(entityID);
    if entryIndex >= 0 {
      if EnumInt(this.m_blacklist[entryIndex].GetReason()) == EnumInt(reason) {
        return true;
      };
    };
    return false;
  }

  public final const func IsEntityBlacklistedForAtLeast(go: ref<GameObject>, reason: BlacklistReason) -> Bool {
    if IsDefined(go) {
      return this.IsEntityBlacklistedForAtLeast(go.GetEntityID(), reason);
    };
    return false;
  }

  public final const func HasEntityBeenSpottedTooManyTimes(reporter: PersistentID, target: EntityID) -> Bool {
    if this.HasSurpassedGlobalWarningsCount(target) {
      return true;
    };
    if IsDefined(this.m_agentsRegistry) {
      return this.m_agentsRegistry.HasEntityBeenSpottedTooManyTimes(reporter, target);
    };
    return false;
  }

  public final const func HasEntityBeenSpottedTooManyTimes(reporter: PersistentID, target: ref<GameObject>, notificationType: ESecurityNotificationType) -> Bool {
    if Equals(notificationType, ESecurityNotificationType.REPRIMAND_SUCCESSFUL) {
      return false;
    };
    if IsDefined(target) {
      return this.HasEntityBeenSpottedTooManyTimes(reporter, target.GetEntityID());
    };
    return false;
  }

  public final const func HasSurpassedGlobalWarningsCount(target: EntityID) -> Bool {
    let i: Int32 = 0;
    while i < ArraySize(this.m_blacklist) {
      if this.m_blacklist[i].GetEntityID() == target && this.m_blacklist[i].GetWarningsCount() > this.m_maxGlobalWarningsCount {
        return true;
      };
      i += 1;
    };
    return false;
  }

  public final const func IsReprimandOngoing() -> Bool {
    return this.m_agentsRegistry.IsReprimandOngoing();
  }

  public final const func IsReprimandOngoingAgainst(suspect: EntityID) -> Bool {
    return this.m_agentsRegistry.IsReprimandOngoingAgainst(suspect);
  }

  public final const func GetReprimandPerformer(opt target: EntityID) -> ref<GameObject> {
    let agent: Agent;
    let ps: ref<DeviceComponentPS>;
    if !EntityID.IsDefined(target) {
      target = GetPlayer(this.GetGameInstance()).GetEntityID();
    };
    if this.m_agentsRegistry.GetReprimandPerformer(target, agent) {
      ps = this.GetPS(agent.link);
      return ps.GetOwnerEntityWeak() as GameObject;
    };
    return null;
  }

  public const func GetSecurityAreas(opt includeInactive: Bool, opt acquireOnlyDirectlyConnected: Bool) -> [ref<SecurityAreaControllerPS>] {
    let areas: array<ref<SecurityAreaControllerPS>>;
    let children: array<ref<DeviceComponentPS>> = this.GetImmediateSlaves();
    let i: Int32 = 0;
    while i < ArraySize(children) {
      if IsDefined(children[i] as SecurityAreaControllerPS) {
        if (children[i] as SecurityAreaControllerPS).IsActive() {
          ArrayPush(areas, children[i] as SecurityAreaControllerPS);
        } else {
          if includeInactive {
            ArrayPush(areas, children[i] as SecurityAreaControllerPS);
          };
        };
      };
      i += 1;
    };
    return areas;
  }

  protected final func SetSecuritySystemAttitudeGroup(newAttitude: TweakDBID) -> Void {
    let i: Int32;
    if newAttitude == this.m_attitudeGroup {
      return;
    };
    this.m_attitudeGroup = newAttitude;
    this.m_agentsRegistry.CleanUpOnNewAttitudeGroup(this.GetGameInstance(), this.GetSecuritySystemAttitudeGroupName());
    i = ArraySize(this.m_blacklist) - 1;
    while i >= 0 {
      if Equals(this.GetAttitudeSystem().GetAttitudeRelation(this.GetAttitudeSystem().GetAttitudeGroup(this.m_blacklist[i].GetEntityID()), this.GetSecuritySystemAttitudeGroupName()), EAIAttitude.AIA_Friendly) {
        this.RemoveIndexFromBlacklist(i);
      };
      i -= 1;
    };
    this.NotifyAboutAttitudeChange();
  }

  private final func RemoveIndexFromBlacklist(index: Int32) -> Void {
    let entityId: EntityID;
    if index >= 0 && index < ArraySize(this.m_blacklist) {
      entityId = this.m_blacklist[index].GetEntityID();
      ArrayErase(this.m_blacklist, index);
      this.TryUpdateBlackboardAreaDataFor(entityId);
    };
  }

  private final func TryUpdateBlackboardAreaDataFor(entityId: EntityID) -> Void {
    if this.IsPlayersEntityID(entityId) {
      this.UpdateBlackboardAreaDataForPlayer();
    };
  }

  private final func UpdateBlackboardAreaDataForPlayer() -> Void {
    let securityAreaController: ref<SecurityAreaControllerPS>;
    let securityAreaData: SecurityAreaData;
    let playerId: EntityID = this.GetPlayerEntityID();
    if this.IsEntityInsideAnyArea(playerId) {
      securityAreaController = this.GetMostDangerousSecurityAreaForEntityID(playerId);
      securityAreaData = this.GetSecurityDataForArea(securityAreaController);
      this.UpdateSecurityZoneDataBlackboard(securityAreaData);
    };
  }

  private final func IsEntityInsideAnyArea(entityId: EntityID) -> Bool {
    let areasWithEntityInside: array<ref<SecurityAreaControllerPS>> = this.GetSecurityAreasWithUserInside(entityId);
    return ArraySize(areasWithEntityInside) > 0;
  }

  private final func UpdateSecurityZoneDataBlackboard(securityAreaData: SecurityAreaData) -> Void {
    let bbSystem: ref<BlackboardSystem> = GameInstance.GetBlackboardSystem(this.GetGameInstance());
    let playerId: EntityID = this.GetPlayerEntityID();
    let playerStateMachineBB: ref<IBlackboard> = bbSystem.GetLocalInstanced(playerId, GetAllBlackboardDefs().PlayerStateMachine);
    if IsDefined(playerStateMachineBB) {
      securityAreaData.shouldHideOnMinimap = this.IsHidden();
      playerStateMachineBB.SetVariant(GetAllBlackboardDefs().PlayerStateMachine.SecurityZoneData, ToVariant(securityAreaData), true);
    };
  }

  private final func GetSecurityDataForArea(area: ref<SecurityAreaControllerPS>) -> SecurityAreaData {
    let playerId: EntityID;
    let securityAreaData: SecurityAreaData;
    if IsDefined(area) {
      securityAreaData = area.GetSecurityAreaData();
      playerId = this.GetPlayerEntityID();
      if this.IsEntityBlacklistedForAtLeast(playerId, BlacklistReason.COMBAT) || this.HasSurpassedGlobalWarningsCount(playerId) {
        securityAreaData.securityAreaType = ESecurityAreaType.DANGEROUS;
      };
    } else {
      securityAreaData = new SecurityAreaData();
    };
    return securityAreaData;
  }

  protected final func NotifyAboutAttitudeChange() -> Void {
    let forceAttitudeChange: ref<SecuritySystemForceAttitudeChange> = new SecuritySystemForceAttitudeChange();
    forceAttitudeChange.newAttitude = this.GetSecuritySystemAttitudeGroupName();
    this.SendActionToAllSlaves(forceAttitudeChange);
    this.RequestTargetsAssessment(null);
  }

  private final func SetSecuritySystemAttitude(desiredAttitude: EAIAttitude, input: ref<SecuritySystemInput>, opt isComingFromQuest: Bool) -> Void {
    let currentRelation: EAIAttitude;
    let targetAttitudeGroup: CName;
    if this.m_attitudeGroup == t"Attitudes.Group_Friendly" {
      return;
    };
    if this.m_attitudeGroup == t"Attitudes.Group_Neutral" {
      return;
    };
    if this.m_attitudeGroup == t"Attitudes.Group_Hostile" {
      return;
    };
    if this.IsPoliceSecuritySystem() {
      return;
    };
    if !isComingFromQuest {
      if this.m_suppressAbilityToModifyAttitude {
        return;
      };
    };
    targetAttitudeGroup = GameInstance.GetAttitudeSystem(this.GetGameInstance()).GetAttitudeGroup(input.GetWhoBreached().GetEntityID());
    if !CanChangeAttitudeRelationFor(targetAttitudeGroup) {
      return;
    };
    currentRelation = this.GetAttitudeSystem().GetAttitudeRelation(this.GetSecuritySystemAttitudeGroupName(), targetAttitudeGroup);
    if Equals(currentRelation, desiredAttitude) {
      return;
    };
    if !isComingFromQuest && Equals(currentRelation, EAIAttitude.AIA_Friendly) && Equals(desiredAttitude, EAIAttitude.AIA_Hostile) {
      return;
    };
    if !this.m_suppressAbilityToModifyAttitude {
      if Equals(this.m_attitudeChangeMode, EShouldChangeAttitude.TEMPORARLY) {
        this.GetAttitudeSystem().SetAttitudeRelation(this.GetSecuritySystemAttitudeGroupName(), targetAttitudeGroup, desiredAttitude);
      } else {
        if Equals(this.m_attitudeChangeMode, EShouldChangeAttitude.PERSISTENTLY) {
          this.GetAttitudeSystem().SetAttitudeGroupRelationPersistent(this.GetSecuritySystemAttitudeGroupName(), targetAttitudeGroup, desiredAttitude);
        };
      };
    };
    if Equals(desiredAttitude, EAIAttitude.AIA_Friendly) {
      this.RemoveFromBlacklist(input.GetWhoBreached());
    };
    this.NotifyAboutAttitudeChange();
  }

  private final func SetSecurityState(newState: ESecuritySystemState, opt input: ref<SecuritySystemInput>, opt isComingFromQuest: Bool) -> Void {
    if Equals(this.m_securitySystemState, newState) {
      return;
    };
    if Equals(newState, ESecuritySystemState.COMBAT) {
      this.m_securitySystem = this;
      this.SetSecuritySystemAttitude(EAIAttitude.AIA_Hostile, input, isComingFromQuest);
      this.SendSupportEvents(false);
    };
    if Equals(this.m_securitySystemState, ESecuritySystemState.COMBAT) {
      this.m_securitySystem = null;
      this.SendSupportEvents(true);
    };
    if !IsFinal() {
    };
    this.m_securitySystemState = newState;
    if IsDefined(input) {
    };
    this.NotifyParents();
  }

  protected final func OnMadnessDebuff(evt: ref<MadnessDebuff>) -> EntityNotificationType {
    if !this.IsRegistryReady() {
      this.InitiateAgentRegistry();
    };
    this.ReleaseAllReprimands();
    this.m_agentsRegistry.UnregisterAgent(evt.object.GetDeviceLink().GetID());
    this.CleanSecuritySystemMemory();
    this.BlacklistEntityID(evt.object.GetEntityID(), BlacklistReason.COMBAT);
    this.RequestTargetsAssessment(null);
    return EntityNotificationType.DoNotNotifyEntity;
  }

  protected final func OnSuppressSecuritySystemReaction(evt: ref<SuppressSecuritySystemReaction>) -> EntityNotificationType {
    let dummyInputEvent: ref<SecuritySystemInput>;
    let securityAreaType: ESecurityAreaType;
    if evt.entered {
      if !ArrayContains(this.m_entitiesRemainingAtGate, evt.protectedEntityID) {
        ArrayPush(this.m_entitiesRemainingAtGate, evt.protectedEntityID);
      };
    } else {
      if ArraySize(this.m_entitiesRemainingAtGate) > 0 {
        if evt.hasEntityWithdrawn {
          if this.IsReprimandOngoingAgainst(evt.protectedEntityID) {
            securityAreaType = this.GetMostDangerousSecurityAreaForEntityID(evt.protectedEntityID).GetSecurityAreaType();
            if securityAreaType < ESecurityAreaType.RESTRICTED {
              this.Deescalate(dummyInputEvent);
              this.ReleaseCurrentPerformerFromReprimand(EReprimandInstructions.CONCLUDE_SUCCESSFUL, evt.protectedEntityID);
            };
          };
        };
        ArrayRemove(this.m_entitiesRemainingAtGate, evt.protectedEntityID);
      };
    };
    if evt.enableProtection {
      if !this.IsEntityBlacklistedForAtLeast(evt.protectedEntityID, BlacklistReason.REPRIMAND) && !ArrayContains(this.m_protectedEntityIDs, evt.protectedEntityID) {
        ArrayPush(this.m_protectedEntityIDs, evt.protectedEntityID);
      };
    } else {
      this.RevokeProtection(evt.protectedEntityID);
    };
    return EntityNotificationType.DoNotNotifyEntity;
  }

  private final func RevokeProtection(entityID: EntityID) -> Void {
    if ArrayContains(this.m_protectedEntityIDs, entityID) {
      ArrayRemove(this.m_protectedEntityIDs, entityID);
      this.RequestTargetsAssessment(null);
    };
  }

  public func OnSecurityAreaCrossingPerimeter(evt: ref<SecurityAreaCrossingPerimeter>) -> EntityNotificationType {
    let areas: array<ref<SecurityAreaControllerPS>>;
    let dummyInputEvent: ref<SecuritySystemInput>;
    let modifyOverlapEvent: ref<ModifyOverlappedSecurityAreas>;
    let playerControlledObj: ref<PlayerPuppet>;
    let secData: SecurityAreaData;
    let securityAreaData: SecurityAreaData;
    let securityAreaType: ESecurityAreaType;
    let mostDangerousArea: ref<SecurityAreaControllerPS> = this.GetMostDangerousSecurityAreaForEntityID(evt.GetWhoBreached());
    if IsDefined(mostDangerousArea) {
      securityAreaType = mostDangerousArea.GetSecurityAreaType();
    } else {
      if !this.IsSystemInCombat() {
        this.m_securitySystem = null;
      };
    };
    if !evt.GetEnteredState() && this.IsReprimandOngoingAgainst(evt.GetWhoBreached().GetEntityID()) {
      if securityAreaType < ESecurityAreaType.RESTRICTED {
        this.Deescalate(dummyInputEvent);
        this.ReleaseCurrentPerformerFromReprimand(EReprimandInstructions.CONCLUDE_SUCCESSFUL, evt.GetWhoBreached().GetEntityID());
      };
    };
    if this.IsDisabled() {
      if !evt.GetEnteredState() {
        PreventionSystem.PreventionSecurityAreaEnterRequest(this.GetGameInstance(), false, evt.GetSecurityAreaID());
      };
      return EntityNotificationType.DoNotNotifyEntity;
    };
    if evt.GetWhoBreached().IsPlayer() {
      secData = evt.GetSecurityAreaData();
      ArrayPush(areas, secData.securityArea);
      this.RequestTargetsAssessment(this.m_agentsRegistry.GetAgents(areas), evt.GetWhoBreached());
      this.PropagateEventToAgents(evt);
      if evt.GetEnteredState() {
        if securityAreaType > ESecurityAreaType.SAFE && !this.IsPoliceSecuritySystem() {
          PreventionSystem.PreventionSecurityAreaEnterRequest(this.GetGameInstance(), true, evt.GetSecurityAreaID());
        };
      } else {
        PreventionSystem.PreventionSecurityAreaEnterRequest(this.GetGameInstance(), false, evt.GetSecurityAreaID());
      };
    };
    dummyInputEvent = new SecuritySystemInput();
    playerControlledObj = evt.GetWhoBreached() as PlayerPuppet;
    if playerControlledObj != null {
      modifyOverlapEvent = new ModifyOverlappedSecurityAreas();
      modifyOverlapEvent.isEntering = evt.GetEnteredState();
      modifyOverlapEvent.zoneID = evt.GetSecurityAreaID();
      playerControlledObj.SetSecurityAreaTypeE3HACK(securityAreaType);
      playerControlledObj.QueueEvent(modifyOverlapEvent);
      securityAreaData = this.GetSecurityDataForArea(mostDangerousArea);
      securityAreaData.entered = evt.GetEnteredState();
      this.UpdateSecurityZoneDataBlackboard(securityAreaData);
      if !evt.GetEnteredState() || securityAreaData.securityAreaType > ESecurityAreaType.SAFE {
        if evt.GetEnteredState() {
          GameInstance.GetAudioSystem(this.GetGameInstance()).HandleDynamicMixAreaEnter(playerControlledObj);
        } else {
          GameInstance.GetAudioSystem(this.GetGameInstance()).HandleDynamicMixAreaExit(playerControlledObj);
        };
      };
    };
    return EntityNotificationType.DoNotNotifyEntity;
  }

  private final func OnAgentSpawned(evt: ref<SecurityAgentSpawnedEvent>) -> EntityNotificationType {
    if Equals(evt.eventType, gameEntitySpawnerEventType.Spawn) {
      this.AddAgentRecord(evt.spawnedAgent, evt.securityAreas, true);
    } else {
      this.m_agentsRegistry.UnregisterAgent(DeviceLink.GetLinkID(evt.spawnedAgent));
    };
    return EntityNotificationType.DoNotNotifyEntity;
  }

  public final const func HasSupport(agentID: PersistentID) -> Bool {
    let agent: Agent;
    this.m_agentsRegistry.GetAgent(agentID, agent);
    return Agent.HasSupport(agent);
  }

  protected final func OnPlayerSpotted(evt: ref<PlayerSpotted>) -> EntityNotificationType {
    let hasAnySupport: Bool;
    let modifiedAgents: array<Agent>;
    if this.m_agentsRegistry.ProcessOnPlayerSpotted(evt, modifiedAgents, hasAnySupport) {
      if this.IsSystemInCombat() {
        this.SendSupportEvents(modifiedAgents, false);
      };
    };
    if hasAnySupport {
      this.m_securitySystem = this;
    } else {
      if !this.IsSystemInCombat() {
        this.m_securitySystem = null;
      };
    };
    return EntityNotificationType.DoNotNotifyEntity;
  }

  protected final func SendSupportEvents(opt modifiedAgents: [Agent], forceRevokeSupport: Bool) -> Void {
    let agents: array<Agent>;
    let i: Int32;
    let supportEvent: ref<SecuritySystemSupport>;
    if forceRevokeSupport {
      this.m_agentsRegistry.ClearSupport();
    };
    if ArraySize(modifiedAgents) > 0 {
      agents = modifiedAgents;
    } else {
      agents = this.m_agentsRegistry.GetAgents();
    };
    i = 0;
    while i < ArraySize(agents) {
      supportEvent = new SecuritySystemSupport();
      supportEvent.supportGranted = Agent.HasSupport(agents[i]);
      this.QueuePSEvent(this.GetPS(agents[i].link), supportEvent);
      i += 1;
    };
  }

  public final const func RequestLatestOutput(id: PersistentID) -> Void {
    let agent: Agent;
    let agentAreas: array<ref<SecurityAreaControllerPS>>;
    let i: Int32;
    let output: ref<SecuritySystemOutput>;
    let outputs: array<ref<SecuritySystemOutput>>;
    if !IsDefined(this.m_agentsRegistry) || !this.m_agentsRegistry.GetAgent(id, agent) {
      return;
    };
    agentAreas = this.GetAgentAreas(id);
    i = 0;
    while i < ArraySize(agentAreas) {
      output = agentAreas[i].GetLastOutput();
      if IsDefined(output) {
        ArrayPush(outputs, output);
      };
      i += 1;
    };
    i = 0;
    while i < ArraySize(outputs) {
      if outputs[i].GetOriginalInputEvent().GetID() > output.GetOriginalInputEvent().GetID() {
        output = outputs[i];
      };
      i += 1;
    };
    if IsDefined(output) {
      this.QueuePSEvent(this.GetPS(agent.link), output);
    };
  }

  public final const func GetTurrets(area: ref<SecurityAreaControllerPS>, turrets: script_ref<[ref<SecurityTurretControllerPS>]>) -> Bool {
    let agents: array<Agent>;
    let filter: array<ref<SecurityAreaControllerPS>>;
    let found: Bool;
    let i: Int32;
    let turret: ref<SecurityTurretControllerPS>;
    ArrayPush(filter, area);
    agents = this.m_agentsRegistry.GetAgents(filter);
    i = 0;
    while i < ArraySize(agents) {
      turret = this.GetPS(agents[i].link) as SecurityTurretControllerPS;
      if IsDefined(turret) {
        ArrayPush(Deref(turrets), turret);
        found = true;
      };
      i += 1;
    };
    return found;
  }

  private final func OnSecurityAreaTypeChangedNotification(evt: ref<SecurityAreaTypeChangedNotification>) -> EntityNotificationType {
    if Equals(evt.currentType, ESecurityAreaType.SAFE) || Equals(evt.currentType, ESecurityAreaType.DISABLED) {
      if this.ShouldSecuritySystemDisableItself() {
        this.DisableSecuritySystem(evt.wasScheduled);
        return EntityNotificationType.DoNotNotifyEntity;
      };
    };
    if Equals(evt.currentType, ESecurityAreaType.DISABLED) {
      this.HandleAreaBeingDisabled(evt.area);
    } else {
      if Equals(evt.previousType, ESecurityAreaType.DISABLED) {
        if this.IsDisabled() {
          this.OnQuestForceON(this.ActionQuestForceON());
        } else {
          this.HandleAreaBeingEnabled(evt.area);
        };
      };
    };
    this.RequestTargetsAssessment(null);
    return EntityNotificationType.DoNotNotifyEntity;
  }

  private final func HandleAreaBeingEnabled(area: ref<SecurityAreaControllerPS>) -> Void {
    let slaves: array<ref<DeviceComponentPS>>;
    if IsDefined(this.m_agentsRegistry) {
      area.GetChildren(slaves);
      this.m_agentsRegistry.AddArea(area, slaves);
    } else {
      this.InitiateAgentRegistry();
    };
  }

  private final func HandleAreaBeingDisabled(area: ref<SecurityAreaControllerPS>) -> Void {
    let affectedAgents: array<Agent>;
    let dataArray: array<OnDisableAreaData>;
    let filter: array<ref<SecurityAreaControllerPS>>;
    let i: Int32;
    let updateData: OnDisableAreaData;
    if !IsDefined(this.m_agentsRegistry) {
      return;
    };
    ArrayPush(filter, area);
    affectedAgents = this.m_agentsRegistry.GetAgents(filter);
    i = 0;
    while i < ArraySize(affectedAgents) {
      updateData.agent = DeviceLink.GetLinkID(affectedAgents[i].link);
      updateData.remainingAreas = this.GetPS(affectedAgents[i]).GetSecurityAreas();
      ArrayPush(dataArray, updateData);
      i += 1;
    };
    this.m_agentsRegistry.RemoveArea(dataArray);
  }

  private final func DisableSecuritySystem(wasScheduled: Bool) -> Void {
    let agents: array<Agent>;
    let areas: array<ref<SecurityAreaControllerPS>>;
    let disableArea: ref<QuestExecuteTransition>;
    let i: Int32;
    let ps: ref<DeviceComponentPS>;
    let securityAreaData: SecurityAreaData;
    let transition: AreaTypeTransition;
    this.SetSecurityState(ESecuritySystemState.UNINITIALIZED);
    this.DisableDevice();
    transition.transitionTo = ESecurityAreaType.DISABLED;
    transition.transitionMode = ETransitionMode.FORCED;
    areas = this.GetSecurityAreas();
    i = 0;
    while i < ArraySize(areas) {
      disableArea = new QuestExecuteTransition();
      disableArea.transition = transition;
      PreventionSystem.PreventionSecurityAreaEnterRequest(this.GetGameInstance(), false, areas[i].GetID());
      this.QueuePSEvent(areas[i], disableArea);
      if !wasScheduled {
        this.QueuePSEvent(areas[i], new PurgeAllTransitions());
      };
      i += 1;
    };
    agents = this.m_agentsRegistry.GetAgents();
    this.SendSupportEvents(true);
    i = 0;
    while i < ArraySize(agents) {
      ps = this.GetPS(agents[i].link);
      if IsDefined(ps) {
        this.QueuePSEvent(ps, new SecuritySystemDisabled());
      };
      i += 1;
    };
    securityAreaData.securityAreaType = ESecurityAreaType.DISABLED;
    securityAreaData.accessLevel = ESecurityAccessLevel.ESL_NONE;
    this.UpdateSecurityZoneDataBlackboard(securityAreaData);
    this.CleanSecuritySystemMemory();
    this.GetPersistencySystem().ForgetObject(this.GetID(), false);
  }

  private final func ShouldSecuritySystemDisableItself() -> Bool {
    let i: Int32;
    let areas: array<ref<SecurityAreaControllerPS>> = this.GetSecurityAreas();
    if !this.m_allowSecuritySystemToDisableItself || this.IsDisabled() && ArraySize(areas) == 0 {
      return false;
    };
    i = 0;
    while i < ArraySize(areas) {
      if NotEquals(areas[i].GetSecurityAreaType(), ESecurityAreaType.SAFE) {
        return false;
      };
      i += 1;
    };
    return true;
  }

  protected final const func ProcessBreachNotificationWithRecipientsList(const addresseeList: script_ref<[EntityID]>, securitySystemInput: ref<SecuritySystemInput>) -> Void {
    securitySystemInput.AttachCustomRecipientsList(addresseeList);
    this.QueuePSEvent(this.GetID(), this.GetClassName(), securitySystemInput);
  }

  public final const func ReportPotentialSituation(input: ref<SecuritySystemInput>) -> Bool {
    let puppetTarget: ref<ScriptedPuppet>;
    this.m_inputsReceived += 1;
    puppetTarget = input.GetWhoBreached() as ScriptedPuppet;
    if IsDefined(puppetTarget) && (puppetTarget.IsCharacterCivilian() || !puppetTarget.IsActive()) {
      return false;
    };
    if this.IsRestarting() || this.IsUnpowered() || this.IsDisabled() {
      return false;
    };
    return this.ProcessInput(input);
  }

  private final const func ProcessInput(input: ref<SecuritySystemInput>) -> Bool {
    let forward: Bool;
    let relation: EAIAttitude;
    if Equals(input.GetNotificationType(), ESecurityNotificationType.ALARM) || Equals(input.GetNotificationType(), ESecurityNotificationType.DEVICE_DESTROYED) {
      forward = true;
    } else {
      relation = this.GetAttitudeTowards(input.GetWhoBreached());
      if Equals(relation, EAIAttitude.AIA_Friendly) {
        forward = this.ProcessFriendly(input);
      } else {
        if Equals(relation, EAIAttitude.AIA_Hostile) || Equals(input.GetNotificationType(), ESecurityNotificationType.COMBAT) || this.IsEntityBlacklistedForAtLeast(input.GetWhoBreached().GetEntityID(), BlacklistReason.COMBAT) {
          forward = this.ProcessHostile();
        } else {
          forward = this.ProcessNeutral(input);
        };
      };
    };
    if forward {
      GameInstance.GetPersistencySystem(this.GetGameInstance()).QueuePSEvent(this.GetID(), this.GetClassName(), input);
      return true;
    };
    return false;
  }

  private final const func ProcessHostile() -> Bool {
    if this.IsRefreshRequired() || NotEquals(this.m_securitySystemState, ESecuritySystemState.COMBAT) {
      return true;
    };
    return false;
  }

  private final const func ProcessNeutral(input: ref<SecuritySystemInput>) -> Bool {
    let isReprimandOngoing: Bool;
    if this.IsNotificationValid(input) {
      isReprimandOngoing = this.IsReprimandOngoing();
      if this.IsRefreshRequired() || Equals(input.GetNotificationType(), ESecurityNotificationType.COMBAT) || isReprimandOngoing && Equals(input.GetNotificationType(), ESecurityNotificationType.REPRIMAND_SUCCESSFUL) || isReprimandOngoing && Equals(input.GetNotificationType(), ESecurityNotificationType.REPRIMAND_ESCALATE) || !isReprimandOngoing && input.CanPerformReprimand() || NotEquals(this.m_securitySystemState, this.DetermineSecuritySystemState(input, true)) {
        return true;
      };
      return false;
    };
    return false;
  }

  private final const func ProcessFriendly(input: ref<SecuritySystemInput>) -> Bool {
    return this.IsReprimandOngoingAgainst(input.GetWhoBreached().GetEntityID());
  }

  private final const func IsRefreshRequired() -> Bool {
    let currentTime: Float = EngineTime.ToFloat(GameInstance.GetSimTime(this.GetGameInstance()));
    if currentTime - this.m_latestOutputEngineTime > this.m_updateInterval {
      return true;
    };
    return false;
  }

  public final func OnSecuritySystemInput(evt: ref<SecuritySystemInput>) -> EntityNotificationType {
    this.HandleSecuritySystemInputByTask(evt);
    return EntityNotificationType.DoNotNotifyEntity;
  }

  private final func HandleSecuritySystemInput(evt: ref<SecuritySystemInput>) -> Void {
    let i: Int32;
    if evt.GetNotificationType() > ESecurityNotificationType.REPRIMAND_ESCALATE {
      i = 0;
      while i < ArraySize(this.m_protectedEntityIDs) {
        if this.m_protectedEntityIDs[i] == evt.GetWhoBreached().GetEntityID() {
          this.RevokeProtection(evt.GetWhoBreached().GetEntityID());
          break;
        };
        i += 1;
      };
    };
    this.ResolveNotificationImmediately(evt);
  }

  public final const func GetValidRecipients(input: ref<SecuritySystemInput>) -> [SecuritySystemOutputData] {
    let areasOfAgentInCombat: array<ref<SecurityAreaControllerPS>>;
    let breachedAreas: array<ref<SecurityAreaControllerPS>>;
    let i: Int32;
    let recipients: array<SecuritySystemOutputData>;
    let notifier: ref<SharedGameplayPS> = input.GetNotifierHandle();
    let secSysNotifier: ref<SecuritySystemControllerPS> = notifier as SecuritySystemControllerPS;
    if Equals(input.GetNotificationType(), ESecurityNotificationType.QUEST) && IsDefined(secSysNotifier) && secSysNotifier == this {
      breachedAreas = this.GetSecurityAreas();
    } else {
      if IsDefined(notifier as SecurityGateControllerPS) || Equals(input.GetNotificationType(), ESecurityNotificationType.ALARM) || Equals(input.GetNotificationType(), ESecurityNotificationType.DEVICE_DESTROYED) {
        breachedAreas = this.GetAgentAreas(notifier.GetID());
      } else {
        breachedAreas = this.GetOverlappingAreas(input);
      };
    };
    if Equals(input.GetNotificationType(), ESecurityNotificationType.COMBAT) || Equals(this.GetAttitudeTowards(input.GetWhoBreached()), EAIAttitude.AIA_Hostile) {
      areasOfAgentInCombat = this.GetAgentAreas(notifier.GetID());
      i = 0;
      while i < ArraySize(areasOfAgentInCombat) {
        if ArrayContains(breachedAreas, areasOfAgentInCombat[i]) {
        } else {
          ArrayPush(breachedAreas, areasOfAgentInCombat[i]);
        };
        i += 1;
      };
    };
    recipients = this.m_agentsRegistry.GetValidAgents(this.GetSecurityState(), breachedAreas);
    return recipients;
  }

  private final func ProduceOutput(input: ref<SecuritySystemInput>, securityStateChanged: Bool) -> Void {
    let agentData: AgentDistanceToTarget;
    let agentsData: array<AgentDistanceToTarget>;
    let closestDistance: Float;
    let closestIndex: Int32;
    let ent: ref<Entity>;
    let i: Int32;
    let output: ref<SecuritySystemOutput>;
    let recipients: array<SecuritySystemOutputData>;
    let secAreas: array<ref<SecurityAreaControllerPS>>;
    this.m_outputsSend += 1;
    output = new SecuritySystemOutput();
    output = this.ActionSecuritySystemBreachResponse(input);
    output.SetSecurityStateChanged(securityStateChanged);
    if input.HasCustomRecipients() {
      output.SetBreachOrigin(EBreachOrigin.LOCAL);
      this.SendResponseToCustomRecipients(output);
      return;
    };
    recipients = this.GetValidRecipients(input);
    if Equals(input.GetNotificationType(), ESecurityNotificationType.DEVICE_DESTROYED) {
      i = 0;
      while i < ArraySize(recipients) {
        if recipients[i].delayDuration > 0.00 {
          ent = GameInstance.FindEntityByID(this.GetGameInstance(), PersistentID.ExtractEntityID(DeviceLink.GetLinkID(recipients[i].link)));
          if IsDefined(ent) {
            agentData.distance = Vector4.DistanceSquared(ent.GetWorldPosition(), input.GetLastKnownPosition());
            agentData.index = i;
            ArrayPush(agentsData, agentData);
          };
        };
        i += 1;
      };
      i = 0;
      while i < ArraySize(agentsData) {
        if closestDistance > agentsData[i].distance {
          closestDistance = agentsData[i].distance;
          closestIndex = agentsData[i].index;
        };
        i += 1;
      };
      this.QueuePSEvent(this.GetPS(recipients[closestIndex].link), output);
      ArrayErase(recipients, closestIndex);
    };
    i = 0;
    while i < ArraySize(recipients) {
      output = new SecuritySystemOutput();
      output = this.ActionSecuritySystemBreachResponse(input);
      output.SetSecurityStateChanged(securityStateChanged);
      output.SetBreachOrigin(recipients[i].breachOrigin);
      if recipients[i].delayDuration > 0.00 {
        GameInstance.GetDelaySystem(this.GetGameInstance()).DelayPSEvent(DeviceLink.GetLinkID(recipients[i].link), DeviceLink.GetLinkClassName(recipients[i].link), output, recipients[i].delayDuration);
      } else {
        this.QueuePSEvent(this.GetPS(recipients[i].link), output);
      };
      i += 1;
    };
    this.m_latestOutputEngineTime = EngineTime.ToFloat(GameInstance.GetSimTime(this.GetGameInstance()));
    secAreas = this.GetSecurityAreas(true);
    i = 0;
    while i < ArraySize(secAreas) {
      output = new SecuritySystemOutput();
      output = this.ActionSecuritySystemBreachResponse(input);
      output.SetSecurityStateChanged(securityStateChanged);
      output.SetBreachOrigin(EBreachOrigin.EXTERNAL);
      this.QueuePSEvent(secAreas[i], output);
      i += 1;
    };
    this.NotifyParents();
  }

  private final func ResolveNotificationImmediately(evt: ref<SecuritySystemInput>) -> Void {
    let notifiedSecSysAboutCombat: ref<NotifiedSecSysAboutCombat>;
    let desiredSecurityState: ESecuritySystemState = this.DetermineSecuritySystemState(evt);
    if this.IsSystemSafe() && Equals(desiredSecurityState, ESecuritySystemState.SAFE) {
      if Equals(evt.GetNotificationType(), ESecurityNotificationType.DEVICE_DESTROYED) {
        this.SetSecurityStateAndTriggerResponse(desiredSecurityState, evt);
      };
      return;
    };
    if Equals(desiredSecurityState, ESecuritySystemState.COMBAT) {
      notifiedSecSysAboutCombat = new NotifiedSecSysAboutCombat();
      this.QueuePSEvent(evt.GetNotifierHandle(), notifiedSecSysAboutCombat);
    };
    if Equals(desiredSecurityState, ESecuritySystemState.ALERTED) || Equals(desiredSecurityState, ESecuritySystemState.COMBAT) {
      this.InitiateAutomaticDeescalationEvent(evt);
    };
    this.ResolveReprimand(evt, desiredSecurityState);
    if this.IsReprimandOngoing() {
      return;
    };
    this.SetSecurityStateAndTriggerResponse(desiredSecurityState, evt);
  }

  public final const func DetermineSecuritySystemState(evt: ref<SecuritySystemInput>, opt isSimulation: Bool) -> ESecuritySystemState {
    if Equals(this.GetAttitudeTowards(evt.GetWhoBreached()), EAIAttitude.AIA_Hostile) {
      if !isSimulation {
        if !IsFinal() {
        };
      };
      return ESecuritySystemState.COMBAT;
    };
    if this.HasEntityBeenSpottedTooManyTimes(evt.GetNotifierHandle().GetID(), evt.GetWhoBreached(), evt.GetNotificationType()) {
      if !isSimulation {
        if !IsFinal() {
        };
      };
      return ESecuritySystemState.COMBAT;
    };
    if this.IsEntityBlacklistedForAtLeast(evt.GetWhoBreached(), BlacklistReason.COMBAT) {
      if !isSimulation {
        if !IsFinal() {
        };
      };
      return ESecuritySystemState.COMBAT;
    };
    switch this.m_securitySystemState {
      case ESecuritySystemState.SAFE:
        return this.ResolveTransitionFromSafe(evt, isSimulation);
      case ESecuritySystemState.ALERTED:
        return this.ResolveTransitionFromAlerted(evt, isSimulation);
      case ESecuritySystemState.COMBAT:
        return this.ResolveTransitionFromCombat(evt, isSimulation);
      default:
        return ESecuritySystemState.UNINITIALIZED;
    };
    if !IsFinal() {
    };
  }

  private final const func ResolveTransitionFromSafe(evt: ref<SecuritySystemInput>, opt isSimulation: Bool) -> ESecuritySystemState {
    let breachedAreaType: ESecurityAreaType;
    let logMessage: String = "Resolving transition from safe: ";
    if this.HasEntityBeenSpottedTooManyTimes(evt.GetNotifierHandle().GetID(), evt.GetWhoBreached(), evt.GetNotificationType()) {
      logMessage += "and entity was already blacklisted for reprimand. Result: COMBAT";
      if !IsFinal() {
      };
      return ESecuritySystemState.COMBAT;
    };
    if Equals(evt.GetNotificationType(), ESecurityNotificationType.SECURITY_GATE) {
      logMessage += "Security Gate breached. Security Gate set to: REPRIMAND";
      if !IsFinal() {
      };
      return ESecuritySystemState.ALERTED;
    };
    if Equals(evt.GetNotificationType(), ESecurityNotificationType.ALARM) {
      logMessage += "Someone is requesting ALARM";
      if !IsFinal() {
      };
      return ESecuritySystemState.ALERTED;
    };
    breachedAreaType = this.DetermineSecurityAreaTypeForEntityID(evt.GetWhoBreached().GetEntityID());
    if Equals(breachedAreaType, ESecurityAreaType.DANGEROUS) || Equals(evt.GetNotificationType(), ESecurityNotificationType.COMBAT) {
      logMessage += "breached area = dangerous or notification type = combat. Result: COMBAT";
      if !IsFinal() {
      };
      return ESecuritySystemState.COMBAT;
    };
    if Equals(breachedAreaType, ESecurityAreaType.RESTRICTED) {
      logMessage += "breached area = restricted ";
      logMessage += "Result: ALERTED";
      if !IsFinal() {
      };
      return ESecuritySystemState.ALERTED;
    };
    if Equals(breachedAreaType, ESecurityAreaType.SAFE) {
      logMessage += "breached area = safe ";
      if Equals(evt.GetNotificationType(), ESecurityNotificationType.ILLEGAL_ACTION) || Equals(evt.GetNotificationType(), ESecurityNotificationType.SECURITY_GATE) {
        logMessage += "and illegal action spotted. Result: ALERTED";
        if !IsFinal() {
        };
        return ESecuritySystemState.ALERTED;
      };
    };
    logMessage += "Result: SAFE";
    if !IsFinal() {
    };
    return ESecuritySystemState.SAFE;
  }

  private final const func ResolveTransitionFromAlerted(evt: ref<SecuritySystemInput>, opt isSimulation: Bool) -> ESecuritySystemState {
    let logMessage: String = "Resolving transition from alerted: ";
    let breachedAreaType: ESecurityAreaType = this.DetermineSecurityAreaTypeForEntityID(evt.GetWhoBreached().GetEntityID());
    if Equals(breachedAreaType, ESecurityAreaType.DANGEROUS) || Equals(evt.GetNotificationType(), ESecurityNotificationType.COMBAT) {
      if !isSimulation {
        logMessage += "breached area = dangerous or notification type = combat. Result: COMBAT";
        if !IsFinal() {
        };
      };
      return ESecuritySystemState.COMBAT;
    };
    if this.IsReprimandOngoing() {
      if Equals(evt.GetNotificationType(), ESecurityNotificationType.REPRIMAND_SUCCESSFUL) {
        if !isSimulation {
          logMessage += "reprimand successful. Result: SAFE";
          if !IsFinal() {
          };
        };
        return ESecuritySystemState.SAFE;
      };
      if Equals(evt.GetNotificationType(), ESecurityNotificationType.ILLEGAL_ACTION) {
        if !isSimulation {
          logMessage += "and illegal action spotted. Result: COMBAT";
          if !IsFinal() {
          };
        };
        return ESecuritySystemState.COMBAT;
      };
      if !isSimulation {
        logMessage += "Result: ALERTED";
        if !IsFinal() {
        };
      };
      return ESecuritySystemState.ALERTED;
    };
    if this.IsEntityBlacklistedForAtLeast(evt.GetWhoBreached(), BlacklistReason.COMBAT) || Equals(evt.GetNotificationType(), ESecurityNotificationType.ILLEGAL_ACTION) {
      if !isSimulation {
        logMessage += "entity was already blacklisted for combat or illegal action noticed. Result: COMBAT";
        if !IsFinal() {
        };
      };
      return ESecuritySystemState.COMBAT;
    };
    if !isSimulation {
      logMessage += "Result: ALERTED";
      if !IsFinal() {
      };
    };
    return ESecuritySystemState.ALERTED;
  }

  private final const func ResolveTransitionFromCombat(evt: ref<SecuritySystemInput>, opt isSimulation: Bool) -> ESecuritySystemState {
    let i: Int32;
    let logMessage: String = "Resolving transition from combat: ";
    if evt.GetNotificationType() > ESecurityNotificationType.DEESCALATE {
      if !isSimulation {
        logMessage += "notification is not about deescalating. Result: COMBAT";
        if !IsFinal() {
        };
      };
      return ESecuritySystemState.COMBAT;
    };
    logMessage += "checking if deescalation is possible...";
    i = 0;
    while i < ArraySize(this.m_blacklist) {
      if this.IsUserInsideSystem(this.m_blacklist[i].GetEntityID()) && Equals(this.m_blacklist[i].GetReason(), BlacklistReason.COMBAT) {
        if !isSimulation {
          logMessage += " entity still within system and blacklisted for combat. Result: COMBAT";
          if !IsFinal() {
          };
        };
        return ESecuritySystemState.COMBAT;
      };
      i += 1;
    };
    if !isSimulation {
      logMessage += "entity left system vicinity. Result: ALERTED";
      if !IsFinal() {
      };
    };
    return ESecuritySystemState.ALERTED;
  }

  private final func ResolveReprimand(evt: ref<SecuritySystemInput>, determinedState: ESecuritySystemState) -> Bool {
    let target: EntityID;
    if !IsDefined(evt.GetWhoBreached()) {
      return false;
    };
    if !evt.GetWhoBreached().IsActive() {
      return false;
    };
    target = evt.GetWhoBreached().GetEntityID();
    if Equals(determinedState, ESecuritySystemState.COMBAT) {
      this.ReleaseCurrentPerformerFromReprimand(EReprimandInstructions.CONCLUDE_FAILED, target);
      return true;
    };
    if Equals(determinedState, ESecuritySystemState.SAFE) {
      this.ReleaseCurrentPerformerFromReprimand(EReprimandInstructions.CONCLUDE_SUCCESSFUL, target);
      return true;
    };
    if Equals(evt.GetNotificationType(), ESecurityNotificationType.REPRIMAND_SUCCESSFUL) {
      this.ReleaseCurrentPerformerFromReprimand(EReprimandInstructions.CONCLUDE_SUCCESSFUL, target);
      return true;
    };
    if !evt.CanPerformReprimand() {
      return false;
    };
    if this.HasEntityBeenSpottedTooManyTimes(evt.GetNotifierHandle().GetID(), evt.GetWhoBreached(), evt.GetNotificationType()) {
      return false;
    };
    if !this.IsReprimandOngoing() {
      this.m_currentReprimandID += 1;
      this.SetReprimandPerformer(evt, EReprimandInstructions.INITIATE_FIRST);
      return true;
    };
    if IsDefined(this.GetReprimandPerformer(evt.GetWhoBreached().GetEntityID()) as Device) && evt.GetNotifierHandle().IsPuppet() {
      this.SetReprimandPerformer(evt, EReprimandInstructions.TAKEOVER);
      return true;
    };
    if Equals(evt.GetNotificationType(), ESecurityNotificationType.REPRIMAND_ESCALATE) {
      this.m_currentReprimandID += 1;
      this.SetReprimandPerformer(evt, EReprimandInstructions.INITIATE_FIRST);
      return true;
    };
    return false;
  }

  private final func SetSecurityStateAndTriggerResponse(newState: ESecuritySystemState, evt: ref<SecuritySystemInput>, opt isComingFromQuest: Bool) -> Bool {
    let changed: Bool;
    if NotEquals(this.m_securitySystemState, newState) {
      changed = true;
      this.RequestTargetsAssessment(evt.GetWhoBreached());
      if this.m_isUnderStrictQuestControl && NotEquals(evt.GetNotificationType(), ESecurityNotificationType.QUEST) {
        if !IsFinal() {
        };
        this.ProduceOutput(evt, changed);
        return false;
      };
      if Equals(newState, ESecuritySystemState.SAFE) && this.m_securitySystemState > ESecuritySystemState.SAFE {
        this.RemoveFromBlacklist(evt.GetWhoBreached());
      };
      if Equals(newState, ESecuritySystemState.ALERTED) && this.m_securitySystemState < ESecuritySystemState.ALERTED {
        this.BlacklistEntityID(evt.GetWhoBreached(), BlacklistReason.TRESPASSING);
      };
      if Equals(newState, ESecuritySystemState.COMBAT) {
        this.BlacklistEntityID(evt.GetWhoBreached(), BlacklistReason.COMBAT);
      };
      if !IsFinal() {
        if IsDefined(evt.GetNotifierHandle()) {
        };
      };
      this.SetSecurityState(newState, evt, isComingFromQuest);
    };
    this.ProduceOutput(evt, changed);
    return changed;
  }

  private final const func SendResponseToCustomRecipients(response: ref<SecuritySystemOutput>) -> Void {
    let recipientsIDs: array<EntityID> = response.GetOriginalInputEvent().GetCustomRecipientsList();
    let i: Int32 = 0;
    while i < ArraySize(recipientsIDs) {
      GameInstance.GetPersistencySystem(this.GetGameInstance()).QueuePSEvent(Cast<PersistentID>(recipientsIDs[i]), n"ScriptedPuppetPS", response);
      i += 1;
    };
  }

  private final func RequestTargetsAssessment(opt providedAgents: [Agent], target: ref<GameObject>) -> Void {
    let agents: array<Agent>;
    let i: Int32;
    let request: ref<TargetAssessmentRequest> = new TargetAssessmentRequest();
    if ArraySize(providedAgents) > 0 {
      agents = providedAgents;
    } else {
      agents = this.m_agentsRegistry.GetAgents();
    };
    if IsDefined(target) {
      request.targetToAssess = target;
    };
    i = 0;
    while i < ArraySize(agents) {
      this.QueuePSEvent(this.GetPS(agents[i].link), request);
      i += 1;
    };
  }

  public final const func PropagateEventToAgents(evt: ref<Event>) -> Void {
    let agents: array<Agent> = this.m_agentsRegistry.GetAgents();
    let i: Int32 = 0;
    while i < ArraySize(agents) {
      this.QueuePSEvent(this.GetPS(agents[i].link), evt);
      i += 1;
    };
  }

  private final const func IsNotificationValid(evt: ref<SecuritySystemInput>) -> Bool {
    let breachLevel: ESecurityAccessLevel;
    let commonAreas: array<ref<SecurityAreaControllerPS>>;
    let i: Int32;
    if IsDefined(this.m_agentsRegistry) && this.m_agentsRegistry.IsAgent(Cast<PersistentID>(evt.GetWhoBreached().GetEntityID())) {
      return false;
    };
    if evt.GetNotificationType() >= ESecurityNotificationType.REPRIMAND_ESCALATE {
      return true;
    };
    if this.IsEntityBlacklistedForAtLeast(evt.GetWhoBreached().GetEntityID(), BlacklistReason.COMBAT) {
      return true;
    };
    if Equals(evt.GetNotificationType(), ESecurityNotificationType.REPRIMAND_SUCCESSFUL) {
      return true;
    };
    if Equals(this.m_securitySystemState, ESecuritySystemState.SAFE) && Equals(evt.GetNotificationType(), ESecurityNotificationType.ALARM) || Equals(evt.GetNotificationType(), ESecurityNotificationType.DEVICE_DESTROYED) {
      return true;
    };
    if this.IsReprimandOngoingAgainst(evt.GetWhoBreached().GetEntityID()) {
      return true;
    };
    if evt.GetNotificationType() <= ESecurityNotificationType.REPRIMAND_ESCALATE {
      i = 0;
      while i < ArraySize(this.m_protectedEntityIDs) {
        if this.m_protectedEntityIDs[i] == evt.GetWhoBreached().GetEntityID() {
          return false;
        };
        i += 1;
      };
    };
    commonAreas = this.GetOverlappingAreas(this.GetAgentAreas(evt.GetNotifierHandle().GetID()), this.GetSecurityAreasWithUserInside(evt.GetWhoBreached().GetEntityID()));
    breachLevel = this.FindHighestSecurityAccessLevel(commonAreas);
    return !this.IsUserAuthorized(evt.GetWhoBreached().GetEntityID(), breachLevel);
  }

  private final const func GetOverlappingAreas(input: ref<SecuritySystemInput>) -> [ref<SecurityAreaControllerPS>] {
    let empty: array<ref<SecurityAreaControllerPS>>;
    if !IsDefined(input.GetNotifierHandle()) {
      return empty;
    };
    if !IsDefined(input.GetWhoBreached()) {
      return empty;
    };
    return this.GetOverlappingAreas(this.GetAgentAreas(input.GetNotifierHandle().GetID()), this.GetSecurityAreasWithUserInside(input.GetWhoBreached().GetEntityID()));
  }

  private final const func GetOverlappingAreas(const bunch1: script_ref<[ref<SecurityAreaControllerPS>]>, const bunch2: script_ref<[ref<SecurityAreaControllerPS>]>) -> [ref<SecurityAreaControllerPS>] {
    let bunch3: array<ref<SecurityAreaControllerPS>>;
    let i: Int32;
    let k: Int32;
    if ArraySize(Deref(bunch1)) == 0 || ArraySize(Deref(bunch2)) == 0 {
      return bunch3;
    };
    i = 0;
    while i < ArraySize(Deref(bunch1)) {
      if !IsDefined(Deref(bunch1)[i]) {
      } else {
        k = 0;
        while k < ArraySize(Deref(bunch2)) {
          if !IsDefined(Deref(bunch2)[k]) {
          } else {
            if Equals(Deref(bunch1)[i].GetID(), Deref(bunch2)[k].GetID()) {
              ArrayPush(bunch3, Deref(bunch1)[i]);
            };
          };
          k += 1;
        };
      };
      i += 1;
    };
    return bunch3;
  }

  private final const func IsSystemClean() -> Bool {
    let k: Int32;
    let areas: array<ref<SecurityAreaControllerPS>> = this.GetSecurityAreas();
    let i: Int32 = 0;
    while i < ArraySize(this.m_blacklist) {
      k = 0;
      while k < ArraySize(areas) {
        if areas[k].IsUserInside(this.m_blacklist[i].GetEntityID()) {
          return false;
        };
        k += 1;
      };
      i += 1;
    };
    return true;
  }

  private final func SetReprimandPerformer(evt: ref<SecuritySystemInput>, instructions: EReprimandInstructions) -> Void {
    let globalWarningsCount: Int32;
    let i: Int32;
    let reprimandUpdate: ref<ReprimandUpdate>;
    let target: EntityID;
    if !IsDefined(evt.GetNotifierHandle()) {
      return;
    };
    target = evt.GetWhoBreached().GetEntityID();
    if Equals(instructions, EReprimandInstructions.TAKEOVER) {
      this.ReleaseCurrentPerformerFromReprimand(EReprimandInstructions.RELEASE_TO_ANOTHER_ENTITY, target);
    };
    this.BlacklistEntityID(target, BlacklistReason.REPRIMAND);
    if Equals(instructions, EReprimandInstructions.INITIATE_FIRST) {
      i = 0;
      while i < ArraySize(this.m_blacklist) {
        if this.m_blacklist[i].GetEntityID() == target {
          globalWarningsCount = this.m_blacklist[i].GetWarningsCount();
          break;
        };
        i += 1;
      };
      if this.m_agentsRegistry.HowManyTimesEntityReprimandedByThisAgentAlready(target, evt.GetNotifierHandle().GetID()) > 0 || globalWarningsCount == this.m_maxGlobalWarningsCount - 1 {
        instructions = EReprimandInstructions.INITIATE_SUCCESSIVE;
      };
    };
    this.m_agentsRegistry.StoreReprimand(evt.GetNotifierHandle().GetID(), target, this.m_currentReprimandID, this.GetAttitudeSystem().GetAttitudeGroup(target));
    reprimandUpdate = ReprimandUpdate.Construct(evt.GetNotifierHandle().GetOwnerEntityWeak() as GameObject, target, instructions, evt.GetLastKnownPosition());
    this.SendReprimandEvent(reprimandUpdate);
  }

  private final func ReleaseAllReprimands() -> Void {
    let agents: array<Agent>;
    let i: Int32;
    let reprimandUpdate: ref<ReprimandUpdate>;
    this.m_agentsRegistry.ReleaseAllReprimands(agents);
    i = 0;
    while i < ArraySize(agents) {
      reprimandUpdate = ReprimandUpdate.Construct(this.GetPS(agents[i].link).GetOwnerEntityWeak() as GameObject, Agent.GetReprimandReceiver(agents[i]), EReprimandInstructions.CONCLUDE_SUCCESSFUL);
      this.SendReprimandEvent(reprimandUpdate);
      i += 1;
    };
  }

  private final func ReleaseCurrentPerformerFromReprimand(instructions: EReprimandInstructions, target: EntityID) -> Void {
    let agent: Agent;
    let agentGO: ref<GameObject>;
    let reprimandUpdate: ref<ReprimandUpdate>;
    if !this.IsReprimandOngoing() {
      return;
    };
    if Equals(instructions, EReprimandInstructions.INITIATE_FIRST) || Equals(instructions, EReprimandInstructions.INITIATE_SUCCESSIVE) || Equals(instructions, EReprimandInstructions.TAKEOVER) {
      if !IsFinal() {
      };
      return;
    };
    if Equals(instructions, EReprimandInstructions.CONCLUDE_SUCCESSFUL) {
    };
    if this.m_agentsRegistry.GetReprimandPerformer(target, agent) {
      agentGO = this.GetPS(agent.link).GetOwnerEntityWeak() as GameObject;
      reprimandUpdate = ReprimandUpdate.Construct(agentGO, target, instructions);
      this.SendReprimandEvent(reprimandUpdate);
      this.m_agentsRegistry.ReleaseFromReprimandAgainst(target, DeviceLink.GetLinkID(agent.link));
    };
  }

  private final func SendReprimandEvent(evt: ref<ReprimandUpdate>) -> Void {
    let performer: EntityID = evt.currentPerformer.GetEntityID();
    if EntityID.IsDefined(performer) {
      this.QueueEntityEvent(performer, evt);
    };
  }

  private final const func ResolvePotentialDeescalation() -> Bool {
    let dummyInputEvent: ref<SecuritySystemInput> = new SecuritySystemInput();
    if this.IsReprimandOngoing() {
      return false;
    };
    if this.IsSystemSafeOrUninitialized() {
      return false;
    };
    if this.IsSystemClean() {
      this.Deescalate(dummyInputEvent);
      return true;
    };
    return false;
  }

  private final func InitiateAutomaticDeescalationEvent(evt: ref<SecuritySystemInput>) -> Void {
    let autoDeescalate: ref<AutomaticDeescalationEvent>;
    this.CancelAutomaticDeescalationEvent();
    autoDeescalate = new AutomaticDeescalationEvent();
    autoDeescalate.originalNotification = evt;
    this.m_deescalationEventID = GameInstance.GetDelaySystem(this.GetGameInstance()).DelayPSEvent(this.GetID(), this.GetClassName(), autoDeescalate, 25.00);
    this.m_delayIDValid = true;
  }

  private final func CancelAutomaticDeescalationEvent() -> Void {
    if !this.m_delayIDValid {
      return;
    };
    GameInstance.GetDelaySystem(this.GetGameInstance()).CancelDelay(this.m_deescalationEventID);
    GameInstance.GetDelaySystem(this.GetGameInstance()).CancelCallback(this.m_deescalationEventID);
    this.m_delayIDValid = false;
  }

  public final func OnAutomaticDeescalationEvent(evt: ref<AutomaticDeescalationEvent>) -> EntityNotificationType {
    if this.IsSystemSafeOrUninitialized() {
      return EntityNotificationType.DoNotNotifyEntity;
    };
    if this.IsReprimandOngoing() {
      this.InitiateAutomaticDeescalationEvent(evt.originalNotification);
      return EntityNotificationType.DoNotNotifyEntity;
    };
    if !this.IsSystemClean() {
      this.InitiateAutomaticDeescalationEvent(evt.originalNotification);
      return EntityNotificationType.DoNotNotifyEntity;
    };
    this.Deescalate(evt.originalNotification);
    return EntityNotificationType.DoNotNotifyEntity;
  }

  private final const func Deescalate(evt: ref<SecuritySystemInput>) -> Void {
    let deescalationEvent: ref<DeescalationEvent> = new DeescalationEvent();
    deescalationEvent.originalNotification = evt;
    this.QueuePSEvent(this.GetID(), this.GetClassName(), deescalationEvent);
  }

  private final func OnDeescalation(evt: ref<DeescalationEvent>) -> EntityNotificationType {
    let i: Int32;
    let newState: ESecuritySystemState;
    if this.IsSystemSafeOrUninitialized() {
      this.ProduceOutput(evt.originalNotification, false);
      return EntityNotificationType.DoNotNotifyEntity;
    };
    if Equals(this.m_securitySystemState, ESecuritySystemState.COMBAT) {
      i = 0;
      while i < ArraySize(this.m_blacklist) {
        if this.IsUserInsideSystem(this.m_blacklist[i].GetEntityID()) {
          this.InitiateAutomaticDeescalationEvent(evt.originalNotification);
          return EntityNotificationType.DoNotNotifyEntity;
        };
        i += 1;
      };
    };
    if !IsFinal() {
    };
    newState = IntEnum<ESecuritySystemState>(EnumInt(this.m_securitySystemState) - 1);
    this.SetSecurityStateAndTriggerResponse(newState, evt.originalNotification);
    if NotEquals(this.m_securitySystemState, ESecuritySystemState.SAFE) {
      this.InitiateAutomaticDeescalationEvent(evt.originalNotification);
    };
    return EntityNotificationType.DoNotNotifyEntity;
  }

  private final func BlacklistEntityID(entityID: EntityID, reason: BlacklistReason) -> Void {
    let addToBlacklistEvent: ref<AddToBlacklistEvent>;
    let blacklistedEntityIndex: Int32;
    let newEntry: ref<BlacklistEntry>;
    if !EntityID.IsDefined(entityID) {
      return;
    };
    newEntry = new BlacklistEntry();
    newEntry.Initialize(entityID, reason, this.m_currentReprimandID);
    blacklistedEntityIndex = this.GetEntityBlacklistIndex(entityID);
    if this.IsPlayersEntityID(entityID) {
      addToBlacklistEvent = new AddToBlacklistEvent();
      addToBlacklistEvent.entityIDToAdd = entityID;
      addToBlacklistEvent.isPlayerEntity = true;
      addToBlacklistEvent.reason = reason;
      this.PropagateEventToAgents(addToBlacklistEvent);
    };
    if blacklistedEntityIndex >= 0 {
      if this.m_blacklist[blacklistedEntityIndex].UpdateBlacklistEntry(reason, this.m_currentReprimandID) {
        this.TriggerBlacklistWipeCountdown(entityID);
      };
    } else {
      this.TriggerBlacklistWipeCountdown(entityID);
      ArrayPush(this.m_blacklist, newEntry);
    };
    this.TryUpdateBlackboardAreaDataFor(entityID);
  }

  private final func TriggerBlacklistWipeCountdown(entityID: EntityID) -> Void {
    let blacklistWipe: ref<BlacklistPeriodEnded>;
    if !this.IsPlayersEntityID(entityID) {
      return;
    };
    this.ResetBlacklistWipeCountdown(entityID);
    blacklistWipe = new BlacklistPeriodEnded();
    blacklistWipe.entityID = entityID;
    this.m_blacklistDelayID = GameInstance.GetDelaySystem(this.GetGameInstance()).DelayPSEvent(this.GetID(), this.GetClassName(), blacklistWipe, 300.00, true);
    this.m_blacklistDelayValid = true;
  }

  private final func ResetBlacklistWipeCountdown(entityID: EntityID) -> Void {
    if !this.m_blacklistDelayValid || !this.IsPlayersEntityID(entityID) {
      return;
    };
    GameInstance.GetDelaySystem(this.GetGameInstance()).CancelCallback(this.m_blacklistDelayID);
    GameInstance.GetDelaySystem(this.GetGameInstance()).CancelDelay(this.m_blacklistDelayID);
    this.m_blacklistDelayValid = false;
    this.m_blacklistDelayID = new DelayID();
  }

  private final func OnBlacklistPeriodEnded(evt: ref<BlacklistPeriodEnded>) -> EntityNotificationType {
    if !this.m_blacklistDelayValid {
      return EntityNotificationType.DoNotNotifyEntity;
    };
    this.m_blacklistDelayValid = false;
    this.m_blacklistDelayID = new DelayID();
    this.RemoveFromBlacklist(evt.entityID);
    return EntityNotificationType.DoNotNotifyEntity;
  }

  private final func BlacklistEntityID(go: ref<GameObject>, reason: BlacklistReason) -> Void {
    if IsDefined(go) {
      this.BlacklistEntityID(go.GetEntityID(), reason);
    };
  }

  private final const func GetEntityBlacklistIndex(entityID: EntityID) -> Int32 {
    let i: Int32 = 0;
    while i < ArraySize(this.m_blacklist) {
      if this.m_blacklist[i].GetEntityID() == entityID {
        return i;
      };
      i += 1;
    };
    return -1;
  }

  private final const func RemoveFromBlacklist(entityID: EntityID) -> Void {
    let removeFromBlacklist: ref<RemoveFromBlacklistEvent>;
    if this.IsEntityBlacklisted(entityID) {
      removeFromBlacklist = new RemoveFromBlacklistEvent();
      removeFromBlacklist.entityIDToRemove = entityID;
      removeFromBlacklist.isPlayerEntity = this.IsPlayersEntityID(entityID);
      this.PropagateEventToAgents(removeFromBlacklist);
      this.GetPersistencySystem().QueuePSEvent(this.GetID(), this.GetClassName(), removeFromBlacklist);
    };
  }

  public final const func RemoveFromBlacklist(go: ref<GameObject>) -> Void {
    if IsDefined(go) {
      this.RemoveFromBlacklist(go.GetEntityID());
    };
  }

  private final func OnRemoveFromBlacklist(evt: ref<RemoveFromBlacklistEvent>) -> EntityNotificationType {
    if this.IsEntityBlacklisted(evt.entityIDToRemove) {
      this.RemoveIndexFromBlacklist(this.GetEntityBlacklistIndex(evt.entityIDToRemove));
      this.m_agentsRegistry.WipeReprimandData(evt.entityIDToRemove);
      this.ResetBlacklistWipeCountdown(evt.entityIDToRemove);
      this.ResolvePotentialDeescalation();
    };
    return EntityNotificationType.DoNotNotifyEntity;
  }

  private final const func IsPlayersEntityID(entityID: EntityID) -> Bool {
    let localPlayer: ref<GameObject> = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerControlledGameObject();
    let mainPlayer: ref<GameObject> = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerMainGameObject();
    if entityID == localPlayer.GetEntityID() || entityID == mainPlayer.GetEntityID() {
      return true;
    };
    return false;
  }

  public final const func GetSecurityAccessData(level: ESecurityAccessLevel) -> [SecurityAccessLevelEntry] {
    let emptyData: array<SecurityAccessLevelEntry>;
    switch level {
      case ESecurityAccessLevel.ESL_NONE:
        return emptyData;
      case ESecurityAccessLevel.ESL_0:
        return this.ProvideAccessDataLevel_0();
      case ESecurityAccessLevel.ESL_1:
        return this.ProvideAccessDataLevel_1();
      case ESecurityAccessLevel.ESL_2:
        return this.ProvideAccessDataLevel_2();
      case ESecurityAccessLevel.ESL_3:
        return this.ProvideAccessDataLevel_3();
      case ESecurityAccessLevel.ESL_4:
        return this.ProvideAccessDataLevel_4();
      default:
        return emptyData;
    };
    if !IsFinal() {
    };
  }

  public final const func IsUserAuthorized(user: EntityID, level: ESecurityAccessLevel) -> Bool {
    let i: Int32;
    if Equals(level, ESecurityAccessLevel.ESL_NONE) {
      return true;
    };
    if Equals(this.GetAttitudeTowards(user), EAIAttitude.AIA_Friendly) {
      return true;
    };
    i = 0;
    while i < ArraySize(this.m_currentlyAuthorizedUsers) {
      if this.m_currentlyAuthorizedUsers[i].user == user {
        if EnumInt(this.m_currentlyAuthorizedUsers[i].level) >= EnumInt(level) {
          return true;
        };
      };
      i += 1;
    };
    return false;
  }

  public final const func IsUserAuthorized(user: ref<GameObject>, level: ESecurityAccessLevel) -> Bool {
    if IsDefined(user) {
      return this.IsUserAuthorized(user.GetEntityID(), level);
    };
    return false;
  }

  public const func GetUserAuthorizationLevel(user: EntityID) -> ESecurityAccessLevel {
    let i: Int32 = 0;
    while i < ArraySize(this.m_currentlyAuthorizedUsers) {
      if this.m_currentlyAuthorizedUsers[i].user == user {
        return this.m_currentlyAuthorizedUsers[i].level;
      };
      i += 1;
    };
    return ESecurityAccessLevel.ESL_NONE;
  }

  public final func AddAccessLevelData(entryLevel: ESecurityAccessLevel, opt password: CName, opt keycard: TweakDBID) -> Void {
    switch entryLevel {
      case ESecurityAccessLevel.ESL_0:
        this.AddAccessLevelEntry(this.m_level_0, password, keycard);
        break;
      case ESecurityAccessLevel.ESL_1:
        this.AddAccessLevelEntry(this.m_level_1, password, keycard);
        break;
      case ESecurityAccessLevel.ESL_2:
        this.AddAccessLevelEntry(this.m_level_2, password, keycard);
        break;
      case ESecurityAccessLevel.ESL_3:
        this.AddAccessLevelEntry(this.m_level_3, password, keycard);
        break;
      case ESecurityAccessLevel.ESL_4:
        this.AddAccessLevelEntry(this.m_level_4, password, keycard);
    };
  }

  public final const func AuthorizeUser(user: EntityID, opt password: CName) -> Bool {
    let keycardLevel: ESecurityAccessLevel;
    let passLevel: ESecurityAccessLevel;
    let currentUserLevel: ESecurityAccessLevel = this.FindCurrentAuthorizationLevelForUser(user);
    if IsNameValid(password) {
      passLevel = this.PerformAuthorizationAttemptUsingPassword(user, password);
    };
    keycardLevel = this.PerformAuthorizationAttemptUsingKeycard(user);
    if EnumInt(currentUserLevel) >= EnumInt(passLevel) && EnumInt(currentUserLevel) >= EnumInt(keycardLevel) {
      return false;
    };
    if EnumInt(keycardLevel) > EnumInt(passLevel) {
      this.AddUser(user, keycardLevel);
    } else {
      this.AddUser(user, passLevel);
    };
    return true;
  }

  public final const func AuthorizeUser(user: EntityID, level: ESecurityAccessLevel) -> Void {
    this.AddUser(user, level);
    this.ResolvePotentialDeescalation();
  }

  public func OnAddUserEvent(evt: ref<AddUserEvent>) -> EntityNotificationType {
    super.OnAddUserEvent(evt);
    this.RemoveFromBlacklist(evt.userEntry.user);
    this.RequestTargetsAssessment(null);
    return EntityNotificationType.DoNotNotifyEntity;
  }

  protected final func OnRevokeAuthorization(evt: ref<RevokeAuthorization>) -> EntityNotificationType {
    let i: Int32 = 0;
    while i < ArraySize(this.m_currentlyAuthorizedUsers) {
      if this.m_currentlyAuthorizedUsers[i].user == evt.user {
        if this.m_currentlyAuthorizedUsers[i].level > evt.level {
          return EntityNotificationType.DoNotNotifyEntity;
        };
        this.m_currentlyAuthorizedUsers[i].level = ESecurityAccessLevel.ESL_NONE;
      };
      i += 1;
    };
    return EntityNotificationType.DoNotNotifyEntity;
  }

  protected func RemoveUser(user: EntityID) -> Bool {
    let removeUserSuccessful: Bool = super.RemoveUser(user);
    this.RequestTargetsAssessment(null);
    return removeUserSuccessful;
  }

  private final func AddAccessLevelEntry(level: script_ref<[SecurityAccessLevelEntry]>, opt password: CName, opt keycard: TweakDBID) -> Void {
    let newEntry: SecurityAccessLevelEntry;
    if TDBID.IsValid(keycard) {
      newEntry.m_keycard = keycard;
      if !IsFinal() {
      };
    };
    if IsNameValid(password) {
      newEntry.m_password = password;
      if !IsFinal() {
      };
    };
    ArrayPush(Deref(level), newEntry);
  }

  private final const func ProvideAccessDataLevel_0() -> [SecurityAccessLevelEntry] {
    let accessData: array<SecurityAccessLevelEntry> = this.m_level_0;
    let higherLevelAccessData: array<SecurityAccessLevelEntry> = this.ProvideAccessDataLevel_1();
    let i: Int32 = 0;
    while i < ArraySize(higherLevelAccessData) {
      ArrayPush(accessData, higherLevelAccessData[i]);
      i += 1;
    };
    return accessData;
  }

  private final const func ProvideAccessDataLevel_1() -> [SecurityAccessLevelEntry] {
    let accessData: array<SecurityAccessLevelEntry> = this.m_level_1;
    let higherLevelAccessData: array<SecurityAccessLevelEntry> = this.ProvideAccessDataLevel_2();
    let i: Int32 = 0;
    while i < ArraySize(higherLevelAccessData) {
      ArrayPush(accessData, higherLevelAccessData[i]);
      i += 1;
    };
    return accessData;
  }

  private final const func ProvideAccessDataLevel_2() -> [SecurityAccessLevelEntry] {
    let accessData: array<SecurityAccessLevelEntry> = this.m_level_2;
    let higherLevelAccessData: array<SecurityAccessLevelEntry> = this.ProvideAccessDataLevel_3();
    let i: Int32 = 0;
    while i < ArraySize(higherLevelAccessData) {
      ArrayPush(accessData, higherLevelAccessData[i]);
      i += 1;
    };
    return accessData;
  }

  private final const func ProvideAccessDataLevel_3() -> [SecurityAccessLevelEntry] {
    let accessData: array<SecurityAccessLevelEntry> = this.m_level_3;
    let higherLevelAccessData: array<SecurityAccessLevelEntry> = this.ProvideAccessDataLevel_4();
    let i: Int32 = 0;
    while i < ArraySize(higherLevelAccessData) {
      ArrayPush(accessData, higherLevelAccessData[i]);
      i += 1;
    };
    return accessData;
  }

  private final const func ProvideAccessDataLevel_4() -> [SecurityAccessLevelEntry] {
    return this.m_level_4;
  }

  private final const func PerformAuthorizationAttemptUsingKeycard(user: EntityID) -> ESecurityAccessLevel {
    let minimumLevel: ESecurityAccessLevel = this.FindCurrentAuthorizationLevelForUser(user);
    let currentLevel: ESecurityAccessLevel = ESecurityAccessLevel.ESL_4;
    let keycardMatchNotFound: Bool = true;
    while keycardMatchNotFound {
      keycardMatchNotFound = !this.IsUserAuthorizedViaCard(user, currentLevel);
      if keycardMatchNotFound && Equals(currentLevel, minimumLevel) {
        return ESecurityAccessLevel.ESL_NONE;
      };
      if Equals(keycardMatchNotFound, false) {
        return currentLevel;
      };
      currentLevel = this.ReduceLevelByOne(currentLevel);
    };
    return ESecurityAccessLevel.ESL_NONE;
  }

  private final const func PerformAuthorizationAttemptUsingPassword(user: EntityID, password: CName) -> ESecurityAccessLevel {
    let minimumLevel: ESecurityAccessLevel = this.FindCurrentAuthorizationLevelForUser(user);
    let currentLevel: ESecurityAccessLevel = ESecurityAccessLevel.ESL_4;
    let passwordNotFound: Bool = true;
    while passwordNotFound {
      passwordNotFound = !this.IsUserAuthorizedViaPassword(password, currentLevel);
      if passwordNotFound && Equals(currentLevel, minimumLevel) {
        return ESecurityAccessLevel.ESL_NONE;
      };
      if Equals(passwordNotFound, false) {
        return currentLevel;
      };
      currentLevel = this.ReduceLevelByOne(currentLevel);
    };
    return ESecurityAccessLevel.ESL_NONE;
  }

  private final const func IsUserAuthorizedViaCard(user: EntityID, level: ESecurityAccessLevel) -> Bool {
    let validSecurityData: array<SecurityAccessLevelEntry> = this.GetSecurityAccessData(level);
    let viableKeycards: array<TweakDBID> = this.ExtractKeycardsFromAuthorizationData(validSecurityData);
    let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGameInstance());
    let i: Int32 = 0;
    while i < ArraySize(viableKeycards) {
      if transactionSystem.HasItem(GameInstance.FindEntityByID(this.GetGameInstance(), user) as GameObject, ItemID.CreateQuery(viableKeycards[i])) {
        return true;
      };
      i += 1;
    };
    return false;
  }

  private final const func IsUserAuthorizedViaPassword(password: CName, level: ESecurityAccessLevel) -> Bool {
    let validSecurityData: array<SecurityAccessLevelEntry> = this.GetSecurityAccessData(level);
    let viablePasswords: array<CName> = this.ExtractPasswordsFromAuthorizationData(validSecurityData);
    let i: Int32 = 0;
    while i < ArraySize(viablePasswords) {
      if Equals(viablePasswords[i], password) {
        return true;
      };
      i += 1;
    };
    return false;
  }

  public func GetActions(out actions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    if !super.GetActions(actions, context) {
      return false;
    };
    if FullSystemRestart.IsDefaultConditionMet(this, context) {
      ArrayPush(actions, this.ActionFullSystemRestart());
    };
    this.SetActionIllegality(actions, this.m_illegalActions.regularActions);
    return true;
  }

  protected final const func ActionSecuritySystemStatus() -> ref<SecuritySystemStatus> {
    let action: ref<SecuritySystemStatus> = new SecuritySystemStatus();
    action.clearanceLevel = 1;
    action.SetUp(this);
    action.SetProperties(this);
    action.AddDeviceName(this.GetDeviceName());
    action.CreateActionWidgetPackage();
    return action;
  }

  public final const func ActionSecuritySystemBreachResponse(notificationEvent: ref<SecuritySystemInput>) -> ref<SecuritySystemOutput> {
    let action: ref<SecuritySystemOutput> = new SecuritySystemOutput();
    action.SetUp(this);
    action.SetProperties(this.m_securitySystemState, notificationEvent);
    action.AddDeviceName(this.GetDeviceName());
    return action;
  }

  private final const func ActionFullSystemRestart() -> ref<FullSystemRestart> {
    let action: ref<FullSystemRestart> = new FullSystemRestart();
    action.clearanceLevel = 10;
    action.SetUp(this);
    action.SetProperties(this.m_isRestarting, this.m_restartDuration);
    action.AddDeviceName(this.GetDeviceName());
    action.CreateActionWidgetPackage();
    return action;
  }

  public func OnFullSystemRestart(evt: ref<FullSystemRestart>) -> EntityNotificationType {
    let notifier: ref<ActionNotifier> = new ActionNotifier();
    notifier.SetExternalOnly();
    if this.m_isRestarting {
      return EntityNotificationType.DoNotNotifyEntity;
    };
    if !IsFinal() {
    };
    super.OnFullSystemRestart(evt);
    this.SendActionToAllSlaves(evt);
    this.Notify(notifier, evt);
    this.NotifyParents();
    return EntityNotificationType.DoNotNotifyEntity;
  }

  protected func OnQuestForceON(evt: ref<QuestForceON>) -> EntityNotificationType {
    let agents: array<Agent>;
    let i: Int32;
    if !this.IsDisabled() || !this.IsOFF() {
    };
    super.OnQuestForceON(evt);
    this.InitiateAgentRegistry();
    agents = this.m_agentsRegistry.GetAgents();
    i = 0;
    while i < ArraySize(agents) {
      this.QueuePSEvent(this.GetPS(agents[i].link), new SecuritySystemEnabled());
      i += 1;
    };
    this.NotifyParents();
    return EntityNotificationType.DoNotNotifyEntity;
  }

  protected final func OnActionTakeOverSecuritySystem(evt: ref<TakeOverSecuritySystem>) -> EntityNotificationType {
    if evt.GetExecutor().IsPlayer() {
      this.SetSecuritySystemAttitudeGroup(t"Attitudes.Group_Player");
    };
    return EntityNotificationType.DoNotNotifyEntity;
  }

  public func OnActionForceResetDevice(evt: ref<ActionForceResetDevice>) -> EntityNotificationType {
    let restart: ref<FullSystemRestart> = this.ActionFullSystemRestart();
    restart.SetProperties(true, evt.m_restartDuration);
    this.CleanSecuritySystemMemory();
    this.OnFullSystemRestart(restart);
    return EntityNotificationType.DoNotNotifyEntity;
  }

  private final func CleanSecuritySystemMemory() -> Void {
    this.ReleaseAllReprimands();
    this.m_agentsRegistry = null;
    this.InitiateAgentRegistry();
    this.m_blacklistDelayValid = false;
    this.m_currentReprimandID = 0;
    ArrayClear(this.m_blacklist);
    this.m_securitySystemState = ESecuritySystemState.SAFE;
    this.UpdateBlackboardAreaDataForPlayer();
  }

  private final const func GetPS(const agent: script_ref<Agent>) -> ref<DeviceComponentPS> {
    return this.GetPS(Deref(agent).link);
  }

  private final const func ReduceLevelByOne(level: ESecurityAccessLevel) -> ESecurityAccessLevel {
    let reducedLevel: ESecurityAccessLevel;
    if Equals(level, ESecurityAccessLevel.ESL_NONE) {
      return level;
    };
    reducedLevel = IntEnum<ESecurityAccessLevel>(EnumInt(level) - 1);
    return reducedLevel;
  }

  private final const func GetAttitudeSystem() -> ref<AttitudeSystem> {
    return GameInstance.GetAttitudeSystem(this.GetGameInstance());
  }

  private final const func GetAttitudeTowards(target: EntityID) -> EAIAttitude {
    if EntityID.IsDefined(target) {
      return this.GetAttitudeTowards(this.GetAttitudeSystem().GetAttitudeGroup(target));
    };
    return EAIAttitude.AIA_Neutral;
  }

  private final const func GetAttitudeTowards(target: ref<GameObject>) -> EAIAttitude {
    if IsDefined(target) {
      return this.GetAttitudeTowards(target.GetEntityID());
    };
    return EAIAttitude.AIA_Friendly;
  }

  private final const func GetAttitudeTowards(otherGroup: CName) -> EAIAttitude {
    let secSysGroup: CName = this.GetSecuritySystemAttitudeGroupName();
    let relation: EAIAttitude = this.GetAttitudeSystem().GetAttitudeRelation(secSysGroup, otherGroup);
    return relation;
  }

  protected final func OnQuestIllegalActionNotification(evt: ref<QuestIllegalActionNotification>) -> EntityNotificationType {
    this.QuestIllegalActionNotification(evt);
    return EntityNotificationType.DoNotNotifyEntity;
  }

  protected final func OnQuestCombatActionNotification(evt: ref<QuestCombatActionNotification>) -> EntityNotificationType {
    this.QuestCombatActionNotification(evt);
    return EntityNotificationType.DoNotNotifyEntity;
  }

  protected final func OnSetSecuritySystemState(evt: ref<SetSecuritySystemState>) -> EntityNotificationType {
    this.QuestChangeSecuritySystemState(evt);
    return EntityNotificationType.DoNotNotifyEntity;
  }

  protected final func OnQuestAuthorizePlayer(evt: ref<AuthorizePlayerInSecuritySystem>) -> EntityNotificationType {
    this.QuestAuthorizePlayer(evt);
    return EntityNotificationType.DoNotNotifyEntity;
  }

  protected final func OnQuestBlackListPlayer(evt: ref<BlacklistPlayer>) -> EntityNotificationType {
    this.QuestBlacklistPlayer(evt);
    return EntityNotificationType.DoNotNotifyEntity;
  }

  protected final func OnQuestExclusiveQuestControl(evt: ref<SuppressSecuritySystemStateChange>) -> EntityNotificationType {
    this.QuestSuppressSecuritySystem(evt);
    return EntityNotificationType.DoNotNotifyEntity;
  }

  protected final func OnQuestChangeSecuritySystemAttitudeGroup(evt: ref<QuestChangeSecuritySystemAttitudeGroup>) -> EntityNotificationType {
    this.QuestChangeSecuritySystemAttitudeGroup(evt);
    return EntityNotificationType.DoNotNotifyEntity;
  }

  public final func QuestChangeSecuritySystemAttitudeGroup(evt: ref<QuestChangeSecuritySystemAttitudeGroup>) -> Void {
    if !IsFinal() {
    };
    this.SetSecuritySystemAttitudeGroup(evt.newAttitudeGroup);
  }

  private final func ExtractNPCIDsFromQuestNotification(evt: ref<QuestSecuritySystemInput>) -> [EntityID] {
    let agentsList: array<PersistentID>;
    let currentSpawnerID: EntityID;
    let k: Int32;
    let secAreasWithPlayer: array<ref<SecurityAreaControllerPS>>;
    let spawnerFound: Bool;
    let spawnersData: array<SpawnerData>;
    let specificNPCs: array<EntityID>;
    let i: Int32 = 0;
    while i < ArraySize(evt.notifySpecificNPCs) {
      spawnerFound = false;
      if NPCReference.IsValid(evt.notifySpecificNPCs[i]) {
        currentSpawnerID = NPCReference.GetSpawnerEntityID(evt.notifySpecificNPCs[i]);
        k = 0;
        while k < ArraySize(spawnersData) {
          if spawnersData[k].spawnerID == currentSpawnerID {
            ArrayPush(spawnersData[k].entryNames, evt.notifySpecificNPCs[i].entryName);
            spawnerFound = true;
          };
          k += 1;
        };
        if !spawnerFound {
          ArrayPush(spawnersData, SpawnerData.Construct(currentSpawnerID, evt.notifySpecificNPCs[i].entryName));
        };
      };
      i += 1;
    };
    if Equals(evt.notificationScope, SecurityEventScopeSettings.GLOBAL) {
      agentsList = this.m_agentsRegistry.GetAgentsIDs();
    } else {
      if Equals(evt.notificationScope, SecurityEventScopeSettings.AREA_WHERE_PLAYER_IS) {
        secAreasWithPlayer = this.GetSecurityAreasWithUserInside(this.GetPlayerEntityID());
        if ArraySize(secAreasWithPlayer) > 0 {
          agentsList = this.m_agentsRegistry.GetAgentsIDs(secAreasWithPlayer);
        };
      };
    };
    i = 0;
    while i < ArraySize(spawnersData) {
      GetFixedEntityIdsFromSpawnerEntityID(spawnersData[i].spawnerID, spawnersData[i].entryNames, this.GetGameInstance(), specificNPCs);
      i += 1;
    };
    i = 0;
    while i < ArraySize(agentsList) {
      ArrayPush(specificNPCs, PersistentID.ExtractEntityID(agentsList[i]));
      i += 1;
    };
    return specificNPCs;
  }

  public final func QuestIllegalActionNotification(evt: ref<QuestIllegalActionNotification>) -> Void {
    let LKP: Vector4;
    let actionSecuritySystemInput: ref<SecuritySystemInput>;
    let playerPup: ref<GameObject>;
    let specificNPCs: array<EntityID> = this.ExtractNPCIDsFromQuestNotification(evt);
    if ArraySize(specificNPCs) == 0 {
      return;
    };
    if Equals(evt.revealPlayerSettings.revealPlayer, ERevealPlayerType.REVEAL_ONCE) {
      playerPup = this.GetPlayerMainObject();
      if IsDefined(playerPup) {
        LKP = playerPup.GetWorldPosition();
      };
    };
    actionSecuritySystemInput = this.ActionSecurityBreachNotification(LKP, playerPup, ESecurityNotificationType.ILLEGAL_ACTION);
    this.ProcessBreachNotificationWithRecipientsList(specificNPCs, actionSecuritySystemInput);
  }

  public final func QuestCombatActionNotification(evt: ref<QuestCombatActionNotification>) -> Void {
    let LKP: Vector4;
    let actionSecuritySystemInput: ref<SecuritySystemInput>;
    let playerPup: ref<GameObject>;
    let specificNPCs: array<EntityID> = this.ExtractNPCIDsFromQuestNotification(evt);
    if ArraySize(specificNPCs) == 0 {
      return;
    };
    if Equals(evt.revealPlayerSettings.revealPlayer, ERevealPlayerType.REVEAL_ONCE) {
      playerPup = this.GetPlayerMainObject();
      if IsDefined(playerPup) {
        LKP = playerPup.GetWorldPosition();
      };
    };
    actionSecuritySystemInput = this.ActionSecurityBreachNotification(LKP, playerPup, ESecurityNotificationType.COMBAT);
    this.ProcessBreachNotificationWithRecipientsList(specificNPCs, actionSecuritySystemInput);
  }

  public final func QuestChangeSecuritySystemState(evt: ref<SetSecuritySystemState>) -> Void {
    if !IsFinal() {
    };
    this.SetSecurityStateAndTriggerResponse(evt.state, this.ActionSecurityBreachNotification(this.GetLocalPlayerControlledGameObject().GetWorldPosition(), this.GetLocalPlayerControlledGameObject(), ESecurityNotificationType.QUEST), true);
  }

  public final func QuestSuppressSecuritySystem(evt: ref<SuppressSecuritySystemStateChange>) -> Void {
    if !IsFinal() {
    };
    this.m_isUnderStrictQuestControl = evt.forceSecuritySystemIntoStrictQuestControl;
    this.RequestTargetsAssessment(null);
  }

  public final func QuestAuthorizePlayer(evt: ref<AuthorizePlayerInSecuritySystem>) -> Void {
    if evt.forceRemoveFromBlacklist {
      if !IsFinal() {
      };
      this.RemoveFromBlacklist(this.GetPlayerEntityID());
    };
    if evt.authorize {
      if !IsFinal() {
      };
      this.AddUser(this.GetPlayerEntityID(), evt.ESL);
    } else {
      if !IsFinal() {
      };
      this.RemoveUser(this.GetPlayerEntityID());
    };
  }

  public final func QuestBlacklistPlayer(evt: ref<BlacklistPlayer>) -> Void {
    if evt.forceRemoveAuthorization {
      if !IsFinal() {
      };
      this.RemoveUser(this.GetPlayerEntityID());
    };
    if evt.blacklist {
      if !IsFinal() {
      };
      this.BlacklistEntityID(this.GetPlayerEntityID(), evt.reason);
    } else {
      if !IsFinal() {
      };
      this.RemoveFromBlacklist(this.GetPlayerEntityID());
    };
  }

  public final const func DebugGetOutputsCount() -> Int32 {
    return this.m_outputsSend;
  }

  public final const func DebugGetInputsCount() -> Int32 {
    return this.m_inputsReceived;
  }

  public func OnMaraudersMapDeviceDebug(sink: ref<MaraudersMapDevicesSink>) -> Void {
    if IsFinal() {
      return;
    };
    sink.BeginCategory("SecuritySystem Specific");
    sink.PushString("STATE: ", ToString(this.m_securitySystemState));
    sink.PushString("PLAYER BLACKLIST STATUS: ", EnumValueToString("BlacklistReason", EnumInt(this.Debug_GetPlayerBlacklistReason())));
    sink.PushString("PLAYER AUTHORIZATION LEVEL: ", EnumValueToString("ESecurityAccessLevel", EnumInt(this.GetUserAuthorizationLevel(this.GetPlayerEntityID()))));
    sink.PushString("SEC SYS ATTITUDE GROUP: ", ToString(this.GetSecuritySystemAttitudeGroupName()));
    sink.PushString("HIDDEN ON UI: ", BoolToString(this.m_hideAreasOnMinimap));
    sink.EndCategory();
  }

  public final const func Debug_GetReprimandID() -> Int32 {
    return this.m_currentReprimandID;
  }

  public final const func Debug_GetPlayerBlacklistReason() -> BlacklistReason {
    let localPlayer: ref<GameObject> = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerControlledGameObject();
    let i: Int32 = 0;
    while i < ArraySize(this.m_blacklist) {
      if this.m_blacklist[i].GetEntityID() == localPlayer.GetEntityID() {
        return this.m_blacklist[i].GetReason();
      };
      i += 1;
    };
    return BlacklistReason.UNINITIALIZED;
  }

  public final const func Debug_GetPlayerWarningCount() -> Int32 {
    let localPlayer: ref<GameObject> = GameInstance.GetPlayerSystem(this.GetGameInstance()).GetLocalPlayerControlledGameObject();
    let i: Int32 = 0;
    while i < ArraySize(this.m_blacklist) {
      if this.m_blacklist[i].GetEntityID() == localPlayer.GetEntityID() {
        return this.m_blacklist[i].GetWarningsCount();
      };
      i += 1;
    };
    return 0;
  }

  public const func GetDebugTags() -> String {
    let tags: String = super.GetDebugTags();
    if this.m_isUnderStrictQuestControl {
      tags += "QUEST CONTROL ";
    };
    if this.IsReprimandOngoing() {
      tags += "IN REPRIMAND ";
    };
    tags += "#P INSIDE: " + BoolToString(this.IsUserInsideSystem(this.GetPlayerEntityID())) + " ";
    tags += "#P BLACKLISTED: " + BoolToString(this.IsUserInsideSystem(this.GetPlayerEntityID())) + " ";
    return tags;
  }

  public final const func IsUnderStrictQuestControl() -> Bool {
    return this.m_isUnderStrictQuestControl;
  }

  private final const func SecuritySystemLog(const message: script_ref<String>) -> Void {
    GameInstance.GetActivityLogSystem(this.GetGameInstance()).AddLog("Security System: " + message);
  }

  private final const func SecuritySystemLog(evt: ref<ReprimandUpdate>) -> Void {
    let message: String = "[REPRIMAND] ";
    let currentPerformer: String = "Undefined";
    if IsDefined(evt.currentPerformer as ScriptedPuppet) {
      currentPerformer = "NPC: ";
    } else {
      if IsDefined(evt.currentPerformer as SecurityTurret) {
        currentPerformer = "TURRET: ";
      };
    };
    switch evt.reprimandInstructions {
      case EReprimandInstructions.INITIATE_FIRST:
        message += currentPerformer + "INITIATE REPRIMAND!";
        break;
      case EReprimandInstructions.INITIATE_SUCCESSIVE:
        message += currentPerformer + "INITIATE SUCCESSIVE REPRIMAND!";
        break;
      case EReprimandInstructions.TAKEOVER:
        message += currentPerformer + "TAKEOVER REPRIMAND!";
        break;
      case EReprimandInstructions.CONCLUDE_SUCCESSFUL:
        message += currentPerformer + "RERPIMAND SUCCESSFUL!";
        break;
      case EReprimandInstructions.CONCLUDE_FAILED:
        message += currentPerformer + "RERPIMAND FAILED!";
        break;
      default:
        return;
    };
    this.SecuritySystemLog(message);
  }

  protected func GetDeviceIconTweakDBID() -> TweakDBID {
    return t"DeviceIcons.SecuritySystemDeviceIcon";
  }

  protected func GetBackgroundTextureTweakDBID() -> TweakDBID {
    return t"DeviceIcons.SecuritySystemDeviceBackground";
  }

  protected func ActionThumbnailUI() -> ref<ThumbnailUI> {
    let tweak: TweakDBID;
    let action: ref<ThumbnailUI> = super.ActionThumbnailUI();
    switch this.m_deviceUIStyle {
      case gamedataComputerUIStyle.Orange:
        tweak = t"DevicesUIDefinitions.SystemDeviceThumnbnailWidgetOA";
      default:
        tweak = t"DevicesUIDefinitions.SystemDeviceThumnbnailWidget";
    };
    action.CreateThumbnailWidgetPackage(tweak, "LocKey#42210");
    return action;
  }
}
