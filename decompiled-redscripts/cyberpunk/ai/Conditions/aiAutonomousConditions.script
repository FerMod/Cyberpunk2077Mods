
public abstract class AIAutonomousConditions extends AIbehaviorconditionScript {

  public final static func HasHostileThreats(context: ScriptExecutionContext, opt onlyEntities: Bool) -> Bool {
    let reactionSystem: ref<ReactionSystem>;
    let puppet: ref<ScriptedPuppet> = AIBehaviorScriptBase.GetPuppet(context);
    let trackerComponent: ref<TargetTrackerComponent> = puppet.GetTargetTrackerComponent();
    if trackerComponent == null {
      return false;
    };
    reactionSystem = GameInstance.GetReactionSystem(puppet.GetGame());
    if puppet.IsCharacterCivilian() && !reactionSystem.IsRegisteredAsAggressive(puppet.GetEntityID()) {
      return false;
    };
    return trackerComponent.HasHostileThreat(false, onlyEntities);
  }

  public final static func HasCombatAICommand(context: ScriptExecutionContext) -> Bool {
    let commandTarget: wref<GameObject> = ScriptExecutionContext.GetArgumentObject(context, n"CommandCombatTarget");
    if IsDefined(commandTarget) && ScriptedPuppet.IsActive(commandTarget) {
      return true;
    };
    if AIActionHelper.HasCombatAICommand(AIBehaviorScriptBase.GetPuppet(context)) {
      return true;
    };
    return false;
  }

  protected final func HasUnknownThreats(context: ScriptExecutionContext) -> Bool {
    return false;
  }

  public final static func IsPlayerInCombat(context: ScriptExecutionContext) -> Bool {
    let player: ref<ScriptedPuppet> = GameInstance.GetPlayerSystem(AIBehaviorScriptBase.GetGame(context)).GetLocalPlayerControlledGameObject() as ScriptedPuppet;
    return Equals(IntEnum<gamePSMCombat>(AIActionChecks.GetPSMBlackbordInt(player, GetAllBlackboardDefs().PlayerStateMachine.Combat)), gamePSMCombat.InCombat);
  }

  public final static func WaitForAnimationToFinish(context: ScriptExecutionContext) -> Bool {
    let puppetState: gamedataNPCUpperBodyState;
    let puppet: ref<ScriptedPuppet> = AIBehaviorScriptBase.GetPuppet(context);
    if puppet.GetMovePolicesComponent().IsOnOffMeshLink() {
      AIAutonomousConditions.SchedulePassiveConditionEvaluation(puppet, 0.25);
      return true;
    };
    if GameInstance.GetCoverManager(puppet.GetGame()).IsEnteringOrLeavingCover(puppet) {
      AIAutonomousConditions.SchedulePassiveConditionEvaluation(puppet, 0.25);
      return true;
    };
    puppetState = puppet.GetUpperBodyStateFromBlackboard();
    if Equals(puppetState, gamedataNPCUpperBodyState.Equip) {
      AIAutonomousConditions.SchedulePassiveConditionEvaluation(puppet, 0.25);
      return true;
    };
    if Equals(puppetState, gamedataNPCUpperBodyState.Attack) {
      AIAutonomousConditions.SchedulePassiveConditionEvaluation(puppet, 0.25);
      return true;
    };
    if Equals(puppetState, gamedataNPCUpperBodyState.ChargedAttack) {
      AIAutonomousConditions.SchedulePassiveConditionEvaluation(puppet, 0.25);
      return true;
    };
    if Equals(puppetState, gamedataNPCUpperBodyState.Taunt) {
      AIAutonomousConditions.SchedulePassiveConditionEvaluation(puppet, 0.25);
      return true;
    };
    if puppet.GetPuppetStateBlackboard().GetBool(GetAllBlackboardDefs().PuppetState.WorkspotAnimationInProgress) {
      AIAutonomousConditions.SchedulePassiveConditionEvaluation(puppet, 0.25);
      return true;
    };
    return false;
  }

  public final static func SchedulePassiveConditionEvaluation(puppet: wref<ScriptedPuppet>, delay: Float) -> Void {
    GameInstance.GetDelaySystem(puppet.GetGame()).DelayEvent(puppet, new DelayPassiveConditionEvaluationEvent(), delay, false);
  }

  public final static func IsPlayerRecentlyDroppedThreat(owner: wref<GameObject>) -> Bool {
    let threatData: DroppedThreatData;
    let threatObject: wref<GameObject>;
    let tte: wref<TargetTrackingExtension>;
    if !TargetTrackingExtension.Get(owner as ScriptedPuppet, tte) {
      return false;
    };
    threatData = tte.GetRecentlyDroppedThreat();
    if !IsDefined(threatData.threat) {
      return false;
    };
    threatObject = threatData.threat as GameObject;
    return IsDefined(threatObject) && threatObject.IsPlayer();
  }

  public final static func AlertedCondition(context: ScriptExecutionContext) -> Bool {
    let highLevelState: gamedataNPCHighLevelState;
    let inVehicle: Bool;
    let puppet: ref<ScriptedPuppet> = AIBehaviorScriptBase.GetPuppet(context);
    if AIAutonomousConditions.WaitForAnimationToFinish(context) {
      if NPCPuppet.IsInAlerted(puppet) {
        return true;
      };
      return false;
    };
    if ScriptedPuppet.IsPlayerCompanion(puppet) {
      return false;
    };
    if puppet.IsCrowd() && !puppet.IsPrevention() {
      return false;
    };
    if !puppet.IsAggressive() {
      return false;
    };
    if puppet.IsPrevention() && puppet.GetPreventionSystem().IsChasingPlayer() {
      if NPCManager.HasTag(AIBehaviorScriptBase.GetPuppet(context).GetRecordID(), n"InActivePoliceChase") || puppet.GetPreventionSystem().ShouldWorkSpotPoliceJoinChase(puppet) {
        if !NPCManager.HasTag(puppet.GetRecordID(), n"Scripted_Patrol") {
          return true;
        };
      };
    };
    if puppet.IsPrevention() && !PreventionSystem.ShouldReactionBeAgressive(puppet.GetGame()) {
      return false;
    };
    highLevelState = puppet.GetHighLevelStateFromBlackboard();
    inVehicle = VehicleComponent.IsMountedToVehicle(ScriptExecutionContext.GetOwner(context).GetGame(), ScriptExecutionContext.GetOwner(context));
    if Equals(highLevelState, gamedataNPCHighLevelState.Alerted) && (!puppet.IsPrevention() || !inVehicle) {
      return true;
    };
    if inVehicle {
      return false;
    };
    if Equals(highLevelState, gamedataNPCHighLevelState.Combat) && AIAutonomousConditions.IsPlayerRecentlyDroppedThreat(puppet) {
      return true;
    };
    return false;
  }

  public final static func CombatCondition(context: ScriptExecutionContext) -> Bool {
    if AIAutonomousConditions.WaitForAnimationToFinish(context) {
      if NPCPuppet.IsInCombat(AIBehaviorScriptBase.GetPuppet(context)) {
        return true;
      };
      return false;
    };
    if AIBehaviorScriptBase.GetPuppet(context).IsCrowd() && !AIBehaviorScriptBase.GetPuppet(context).IsAggressive() {
      return false;
    };
    if AIAutonomousConditions.HasCombatAICommand(context) {
      return true;
    };
    if ScriptedPuppet.IsPlayerCompanion(ScriptExecutionContext.GetOwner(context)) {
      if AIActionHelper.HasFollowerCombatAICommand(AIBehaviorScriptBase.GetPuppet(context)) {
        return true;
      };
      if !AIAutonomousConditions.IsPlayerInCombat(context) {
        return false;
      };
    } else {
      if !AIBehaviorScriptBase.GetPuppet(context).IsAggressive() {
        return false;
      };
    };
    if AIAutonomousConditions.HasHostileThreats(context, true) {
      return true;
    };
    return false;
  }

  public final static func NoWeaponCombatConditions(context: ScriptExecutionContext) -> Bool {
    if NotEquals(AIBehaviorScriptBase.GetPuppet(context).GetNPCType(), gamedataNPCType.Human) {
      return false;
    };
    if !AIAutonomousConditions.HasWeaponInInventory(context) {
      if AIAutonomousConditions.WaitForAnimationToFinish(context) {
        if NPCPuppet.IsInCombat(AIBehaviorScriptBase.GetPuppet(context)) {
          return true;
        };
        return false;
      };
      return true;
    };
    return false;
  }

  public final static func CrowdCombatConditions(context: ScriptExecutionContext) -> Bool {
    let reactionSystem: ref<ReactionSystem>;
    let timestamp: Float;
    if AIAutonomousConditions.WaitForAnimationToFinish(context) {
      if NPCPuppet.IsInCombat(AIBehaviorScriptBase.GetPuppet(context)) {
        return true;
      };
      return false;
    };
    timestamp = AIBehaviorScriptBase.GetPuppet(context).GetAIControllerComponent().GetActionBlackboard().GetFloat(GetAllBlackboardDefs().AIAction.avoidLOSTimeStamp);
    if timestamp > 0.00 && EngineTime.ToFloat(ScriptExecutionContext.GetAITime(context)) - timestamp > 7.00 {
      return false;
    };
    if NotEquals(AIBehaviorScriptBase.GetPuppet(context).GetNPCType(), gamedataNPCType.Human) {
      return false;
    };
    reactionSystem = GameInstance.GetReactionSystem(AIBehaviorScriptBase.GetPuppet(context).GetGame());
    if AIBehaviorScriptBase.GetPuppet(context).IsCrowd() && reactionSystem.IsRegisteredAsAggressive(AIBehaviorScriptBase.GetPuppet(context).GetEntityID()) {
      return true;
    };
    if AIBehaviorScriptBase.GetPuppet(context).IsCrowd() && AIBehaviorScriptBase.GetPuppet(context).IsPrevention() {
      return true;
    };
    return false;
  }

  public final static func HasWeaponInInventory(context: ScriptExecutionContext) -> Bool {
    let itemID: ItemID;
    let weaponCategory: wref<ItemCategory_Record> = TweakDBInterface.GetItemCategoryRecord(t"ItemCategory.Weapon");
    if IsDefined(weaponCategory) && AIActionTransactionSystem.GetFirstItemID(ScriptExecutionContext.GetOwner(context), weaponCategory, n"None", itemID) {
      return true;
    };
    return false;
  }
}

public class NoWeaponCombatConditions extends AIAutonomousConditions {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    if AIAutonomousConditions.NoWeaponCombatConditions(context) {
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class CombatConditions extends AIAutonomousConditions {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    if AIAutonomousConditions.CombatCondition(context) {
      return AIbehaviorConditionOutcomes.True;
    };
    AIComponent.InvokeBehaviorCallback(AIBehaviorScriptBase.GetPuppet(context), n"OnActiveCombatConditionFailed");
    return AIbehaviorConditionOutcomes.False;
  }
}

public class AlertedConditions extends AIAutonomousConditions {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(AIAutonomousConditions.AlertedCondition(context));
  }
}

public class CrowdCombatConditions extends AIAutonomousConditions {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(1.00));
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    if AIAutonomousConditions.CrowdCombatConditions(context) {
      return AIbehaviorConditionOutcomes.True;
    };
    AIComponent.InvokeBehaviorCallback(AIBehaviorScriptBase.GetPuppet(context), n"OnCrowdCombatConditionFailed");
    return AIbehaviorConditionOutcomes.False;
  }
}

public class PassiveNoWeaponCombatConditions extends PassiveAutonomousCondition {

  protected let m_delayEvaluationCbId: Uint32;

  protected let m_onItemAddedToSlotCbId: Uint32;

  protected final func Activate(context: ScriptExecutionContext) -> Void {
    this.m_delayEvaluationCbId = ScriptExecutionContext.AddBehaviorCallback(context, n"OnDelayPassiveConditionEvaluation", this);
    this.m_onItemAddedToSlotCbId = ScriptExecutionContext.AddBehaviorCallback(context, n"OnItemAddedToSlotConditionEvaluation", this);
  }

  protected final func Deactivate(context: ScriptExecutionContext) -> Void {
    ScriptExecutionContext.RemoveBehaviorCallback(context, this.m_delayEvaluationCbId);
    ScriptExecutionContext.RemoveBehaviorCallback(context, this.m_onItemAddedToSlotCbId);
  }

  protected final func CalculateValue(context: ScriptExecutionContext) -> Variant {
    if AIAutonomousConditions.NoWeaponCombatConditions(context) {
      return ToVariant(true);
    };
    return ToVariant(false);
  }
}

public class PassiveCrowdCombatConditions extends PassiveAutonomousCondition {

  protected let m_threatCbId: Uint32;

  protected let m_delayEvaluationCbId: Uint32;

  protected let m_onItemAddedToSlotCbId: Uint32;

  protected let m_crowdCombatConditionCbId: Uint32;

  protected final func Activate(context: ScriptExecutionContext) -> Void {
    this.m_threatCbId = ScriptExecutionContext.AddBehaviorCallback(context, n"OnThreatsChanged", this);
    this.m_delayEvaluationCbId = ScriptExecutionContext.AddBehaviorCallback(context, n"OnDelayPassiveConditionEvaluation", this);
    this.m_onItemAddedToSlotCbId = ScriptExecutionContext.AddBehaviorCallback(context, n"OnItemAddedToSlotConditionEvaluation", this);
    this.m_crowdCombatConditionCbId = ScriptExecutionContext.AddBehaviorCallback(context, n"OnCrowdCombatConditionFailed", this);
  }

  protected final func Deactivate(context: ScriptExecutionContext) -> Void {
    ScriptExecutionContext.RemoveBehaviorCallback(context, this.m_threatCbId);
    ScriptExecutionContext.RemoveBehaviorCallback(context, this.m_delayEvaluationCbId);
    ScriptExecutionContext.RemoveBehaviorCallback(context, this.m_onItemAddedToSlotCbId);
    ScriptExecutionContext.RemoveBehaviorCallback(context, this.m_crowdCombatConditionCbId);
  }

  protected final func CalculateValue(context: ScriptExecutionContext) -> Variant {
    if AIAutonomousConditions.CrowdCombatConditions(context) {
      return ToVariant(true);
    };
    return ToVariant(false);
  }
}

public class PassiveCombatConditions extends PassiveAutonomousCondition {

  protected let m_combatCommandCbId: Uint32;

  protected let m_roleCbId: Uint32;

  protected let m_threatCbId: Uint32;

  protected let m_playerCombatCbId: Uint32;

  protected let m_activeCombatConditionCbId: Uint32;

  protected let m_delayEvaluationCbId: Uint32;

  protected final func Activate(context: ScriptExecutionContext) -> Void {
    this.m_combatCommandCbId = ScriptExecutionContext.AddBehaviorCallback(context, n"OnCombatCommandChanged", this);
    this.m_roleCbId = ScriptExecutionContext.AddBehaviorCallback(context, n"OnAIRoleChanged", this);
    this.m_threatCbId = ScriptExecutionContext.AddBehaviorCallback(context, n"OnThreatsChanged", this);
    this.m_playerCombatCbId = ScriptExecutionContext.AddBehaviorCallback(context, n"OnPlayerCombatChanged", this);
    this.m_activeCombatConditionCbId = ScriptExecutionContext.AddBehaviorCallback(context, n"OnActiveCombatConditionFailed", this);
    this.m_delayEvaluationCbId = ScriptExecutionContext.AddBehaviorCallback(context, n"OnDelayPassiveConditionEvaluation", this);
  }

  protected final func Deactivate(context: ScriptExecutionContext) -> Void {
    ScriptExecutionContext.RemoveBehaviorCallback(context, this.m_combatCommandCbId);
    ScriptExecutionContext.RemoveBehaviorCallback(context, this.m_roleCbId);
    ScriptExecutionContext.RemoveBehaviorCallback(context, this.m_threatCbId);
    ScriptExecutionContext.RemoveBehaviorCallback(context, this.m_playerCombatCbId);
    ScriptExecutionContext.RemoveBehaviorCallback(context, this.m_activeCombatConditionCbId);
    ScriptExecutionContext.RemoveBehaviorCallback(context, this.m_delayEvaluationCbId);
  }

  protected final func CalculateValue(context: ScriptExecutionContext) -> Variant {
    if AIBehaviorScriptBase.GetPuppet(context).IsCrowd() && !AIBehaviorScriptBase.GetPuppet(context).IsPrevention() {
      return ToVariant(AIAutonomousConditions.CrowdCombatConditions(context));
    };
    return ToVariant(AIAutonomousConditions.CombatCondition(context));
  }
}

public class PassiveAlertedConditions extends PassiveAutonomousCondition {

  protected let m_highLevelCbId: Uint32;

  protected let m_delayEvaluationCbId: Uint32;

  protected final func Activate(context: ScriptExecutionContext) -> Void {
    this.m_highLevelCbId = ScriptExecutionContext.AddBehaviorCallback(context, n"OnHighLevelChanged", this);
    this.m_delayEvaluationCbId = ScriptExecutionContext.AddBehaviorCallback(context, n"OnDelayPassiveConditionEvaluation", this);
  }

  protected final func Deactivate(context: ScriptExecutionContext) -> Void {
    ScriptExecutionContext.RemoveBehaviorCallback(context, this.m_highLevelCbId);
    ScriptExecutionContext.RemoveBehaviorCallback(context, this.m_delayEvaluationCbId);
  }

  protected final func CalculateValue(context: ScriptExecutionContext) -> Variant {
    ScriptExecutionContext.DebugLog(context, n"autocond", "PassiveAlertedConditions calculated.");
    return ToVariant(AIAutonomousConditions.AlertedCondition(context));
  }
}

public class PassiveRoleCondition extends AIbehaviorexpressionScript {

  public edit let m_role: EAIRole;

  private let m_roleCbId: Uint32;

  protected final func Activate(context: ScriptExecutionContext) -> Void {
    this.m_roleCbId = ScriptExecutionContext.AddBehaviorCallback(context, n"OnAIRoleChanged", this);
  }

  protected final func Deactivate(context: ScriptExecutionContext) -> Void {
    ScriptExecutionContext.RemoveBehaviorCallback(context, this.m_roleCbId);
  }

  protected final func CalculateValue(context: ScriptExecutionContext) -> Variant {
    let role: ref<AIRole> = AIBehaviorScriptBase.GetAIComponent(context).GetAIRole();
    if IsDefined(role) && Equals(role.GetRoleEnum(), this.m_role) {
      return ToVariant(true);
    };
    return ToVariant(false);
  }

  public final func GetEditorSubCaption() -> String {
    return "Role " + ToString(this.m_role);
  }
}

public class PassiveCommandCondition extends AIbehaviorexpressionScript {

  public edit let m_commandName: CName;

  @default(PassiveCommandCondition, true)
  public edit let m_useInheritance: Bool;

  private let m_cmdCbId: Uint32;

  protected final func Activate(context: ScriptExecutionContext) -> Void {
    this.m_cmdCbId = ScriptExecutionContext.AddBehaviorCallback(context, n"OnCommandStateChanged", this);
  }

  protected final func Deactivate(context: ScriptExecutionContext) -> Void {
    ScriptExecutionContext.RemoveBehaviorCallback(context, this.m_cmdCbId);
  }

  protected final func CalculateValue(context: ScriptExecutionContext) -> Variant {
    let aiComp: ref<AIHumanComponent> = AIBehaviorScriptBase.GetAIComponent(context);
    return ToVariant(aiComp.IsCommandWaiting(this.m_commandName, this.m_useInheritance) || aiComp.IsCommandExecuting(this.m_commandName, this.m_useInheritance));
  }

  public final func GetEditorSubCaption() -> String {
    return "CMD " + ToString(this.m_commandName);
  }
}

public class PassivePatrolConditions extends PassiveAutonomousCondition {

  private let m_roleCbId: Uint32;

  private let m_cmdCbId: Uint32;

  protected final func Activate(context: ScriptExecutionContext) -> Void {
    this.m_roleCbId = ScriptExecutionContext.AddBehaviorCallback(context, n"OnAIRoleChanged", this);
    this.m_cmdCbId = ScriptExecutionContext.AddBehaviorCallback(context, n"OnCommandStateChanged", this);
  }

  protected final func Deactivate(context: ScriptExecutionContext) -> Void {
    ScriptExecutionContext.RemoveBehaviorCallback(context, this.m_roleCbId);
    ScriptExecutionContext.RemoveBehaviorCallback(context, this.m_cmdCbId);
  }

  protected final func CalculateValue(context: ScriptExecutionContext) -> Variant {
    let role: ref<AIRole>;
    let aiComp: ref<AIHumanComponent> = AIBehaviorScriptBase.GetAIComponent(context);
    if aiComp.IsCommandExecuting(n"AIPatrolCommand", true) || aiComp.IsCommandWaiting(n"AIPatrolCommand", true) {
      return ToVariant(true);
    };
    role = aiComp.GetAIRole();
    if IsDefined(role) && Equals(role.GetRoleEnum(), EAIRole.Patrol) {
      return ToVariant(true);
    };
    return ToVariant(false);
  }
}

public class PassiveCoverSelectionConditions extends PassiveAutonomousCondition {

  private let m_statsChangedCbId: Uint32;

  private let m_ability: wref<GameplayAbility_Record>;

  private let m_statListener: ref<AIStatListener>;

  protected final func Activate(context: ScriptExecutionContext) -> Void {
    this.m_ability = TweakDBInterface.GetGameplayAbilityRecord(t"Ability.CanUseCovers");
    this.m_statsChangedCbId = ScriptExecutionContext.AddBehaviorCallback(context, n"OnUseCoverStatChanged", this);
    this.m_statListener = new AIStatListener();
    this.m_statListener.SetInitData(AIBehaviorScriptBase.GetPuppet(context), n"OnUseCoverStatChanged");
    this.m_statListener.SetStatType(gamedataStatType.CanUseCovers);
    GameInstance.GetStatsSystem(ScriptExecutionContext.GetOwner(context).GetGame()).RegisterListener(Cast<StatsObjectID>(ScriptExecutionContext.GetOwner(context).GetEntityID()), this.m_statListener);
  }

  protected final func Deactivate(context: ScriptExecutionContext) -> Void {
    if IsDefined(this.m_statListener) {
      GameInstance.GetStatsSystem(ScriptExecutionContext.GetOwner(context).GetGame()).UnregisterListener(Cast<StatsObjectID>(ScriptExecutionContext.GetOwner(context).GetEntityID()), this.m_statListener);
      this.m_statListener = null;
    };
    ScriptExecutionContext.RemoveBehaviorCallback(context, this.m_statsChangedCbId);
  }

  protected final func CalculateValue(context: ScriptExecutionContext) -> Variant {
    if !IsDefined(this.m_ability) {
      return ToVariant(false);
    };
    if !AICondition.CheckAbility(context, this.m_ability) {
      return ToVariant(false);
    };
    return ToVariant(true);
  }
}

public class AIStatListener extends ScriptStatsListener {

  private let m_owner: wref<ScriptedPuppet>;

  private let m_behaviorCallbackName: CName;

  public final func SetInitData(owner: wref<ScriptedPuppet>, behaviorCallbackName: CName) -> Void {
    this.m_owner = owner;
  }

  public func OnStatChanged(ownerID: StatsObjectID, statType: gamedataStatType, diff: Float, total: Float) -> Void {
    AIComponent.InvokeBehaviorCallback(this.m_owner, n"OnUseCoverStatChanged");
  }
}

public class IsConnectedToSecuritySystem extends AIAutonomousConditions {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    if AIBehaviorScriptBase.GetPuppet(context).IsConnectedToSecuritySystem() {
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class IsReprimandOngoing extends AIAutonomousConditions {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let puppet: ref<ScriptedPuppet> = AIBehaviorScriptBase.GetPuppet(context);
    let secSys: ref<SecuritySystemControllerPS> = puppet.GetSecuritySystem();
    if !secSys.IsReprimandOngoing() {
      return AIbehaviorConditionOutcomes.False;
    };
    if puppet.GetSecuritySystem().GetReprimandPerformer() == puppet.GetDeviceLink() {
      return AIbehaviorConditionOutcomes.False;
    };
    if NotEquals((puppet.GetSecuritySystem().GetReprimandPerformer() as ScriptedPuppet).GetHighLevelStateFromBlackboard(), gamedataNPCHighLevelState.Relaxed) {
      return AIbehaviorConditionOutcomes.False;
    };
    return AIbehaviorConditionOutcomes.True;
  }
}

public class IsTargetObjectPlayer extends AIbehaviorconditionScript {

  protected inline edit let m_targetObject: ref<AIArgumentMapping>;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let targetObject: wref<GameObject> = FromVariant<wref<GameObject>>(ScriptExecutionContext.GetMappingValue(context, this.m_targetObject));
    if IsDefined(targetObject) && targetObject.IsPlayer() {
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class IsBoss extends AIbehaviorconditionScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    if AIBehaviorScriptBase.GetPuppet(context).IsBoss() {
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class IsAggressive extends AIbehaviorconditionScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    if AIBehaviorScriptBase.GetPuppet(context).IsAggressive() {
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class PassiveCannotMoveConditions extends PassiveAutonomousCondition {

  protected let m_statusEffectRemovedId: Uint32;

  protected final func Activate(context: ScriptExecutionContext) -> Void {
    this.m_statusEffectRemovedId = ScriptExecutionContext.AddBehaviorCallback(context, n"OnStatusEffectRemoved", this);
  }

  protected final func Deactivate(context: ScriptExecutionContext) -> Void {
    ScriptExecutionContext.RemoveBehaviorCallback(context, this.m_statusEffectRemovedId);
  }

  protected final func CalculateValue(context: ScriptExecutionContext) -> Variant {
    if StatusEffectSystem.ObjectHasStatusEffectWithTag(ScriptExecutionContext.GetOwner(context), n"LocomotionMalfunction") {
      return ToVariant(true);
    };
    return ToVariant(false);
  }
}
