
public class CheckReaction extends AIbehaviorconditionScript {

  public edit let m_reactionToCompare: gamedataOutput;

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(Equals(AIBehaviorScriptBase.GetPuppet(context).GetStimReactionComponent().GetDesiredReactionName(), this.m_reactionToCompare));
  }
}

public class CheckReactionValueThreshold extends AIbehaviorconditionScript {

  public edit let m_reactionValue: EReactionValue;

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let currentStat: Float;
    let threshold: Float;
    switch this.m_reactionValue {
      case EReactionValue.Fear:
        currentStat = AIBehaviorScriptBase.GetStatPoolValue(context, gamedataStatPoolType.Fear);
        threshold = TweakDBInterface.GetCharacterRecord(AIBehaviorScriptBase.GetPuppet(context).GetRecordID()).ReactionPreset().FearThreshold();
        break;
      default:
        return AIbehaviorConditionOutcomes.False;
    };
    if threshold == 0.00 {
      return AIbehaviorConditionOutcomes.False;
    };
    if currentStat >= threshold - 0.01 {
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class InvestigateController extends AIbehaviorconditionScript {

  protected let m_investigateData: stimInvestigateData;

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    this.m_investigateData = AIBehaviorScriptBase.GetPuppet(context).GetStimReactionComponent().GetActiveReactionData().stimInvestigateData;
    return Cast<AIbehaviorConditionOutcomes>(this.m_investigateData.investigateController);
  }
}

public class CheckReactionStimType extends AIbehaviorconditionScript {

  public edit let m_stimToCompare: gamedataStimType;

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(Equals(AIBehaviorScriptBase.GetPuppet(context).GetStimReactionComponent().GetActiveReactionData().stimType, this.m_stimToCompare));
  }
}

public class CheckStimTag extends AIbehaviorconditionScript {

  public edit const let m_stimTagToCompare: [CName];

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let i: Int32;
    let tags: array<CName>;
    let activeReactionData: ref<AIReactionData> = AIBehaviorScriptBase.GetPuppet(context).GetStimReactionComponent().GetActiveReactionData();
    if !IsDefined(activeReactionData) {
      activeReactionData = AIBehaviorScriptBase.GetPuppet(context).GetStimReactionComponent().GetDesiredReactionData();
    };
    tags = activeReactionData.stimRecord.Tags();
    i = 0;
    while i < ArraySize(this.m_stimTagToCompare) {
      if ArrayContains(tags, this.m_stimTagToCompare[i]) {
        return AIbehaviorConditionOutcomes.True;
      };
      i += 1;
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class PlayInitFearAnimation extends AIbehaviorconditionScript {

  public let m_grenadePanic: Bool;

  public let m_initialized: Bool;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let ownerPuppet: wref<ScriptedPuppet>;
    if this.m_initialized {
      return;
    };
    this.m_initialized = true;
    ownerPuppet = ScriptExecutionContext.GetOwner(context) as ScriptedPuppet;
    if ownerPuppet.IsBoss() {
      return;
    };
    if ownerPuppet.IsElite() {
      return;
    };
    if AIActionHelper.CheckAbility(ownerPuppet, TweakDBInterface.GetGameplayAbilityRecord(t"Ability.HasSandevistan")) {
      return;
    };
    if AIActionHelper.CheckAbility(ownerPuppet, TweakDBInterface.GetGameplayAbilityRecord(t"Ability.HasKerenzikov")) {
      return;
    };
    if AIActionHelper.CheckAbility(ownerPuppet, TweakDBInterface.GetGameplayAbilityRecord(t"Ability.IsTier3Archetype")) {
      return;
    };
    if AIActionHelper.CheckAbility(ownerPuppet, TweakDBInterface.GetGameplayAbilityRecord(t"Ability.IsAggressive")) {
      return;
    };
    if AIActionHelper.CheckAbility(ownerPuppet, TweakDBInterface.GetGameplayAbilityRecord(t"Ability.IsReckless")) {
      return;
    };
    if AIActionHelper.CheckAbility(ownerPuppet, TweakDBInterface.GetGameplayAbilityRecord(t"Ability.IsManMassive")) {
      return;
    };
    this.m_grenadePanic = true;
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let ownerPuppet: wref<ScriptedPuppet> = ScriptExecutionContext.GetOwner(context) as ScriptedPuppet;
    let activeReactionData: ref<AIReactionData> = ownerPuppet.GetStimReactionComponent().GetActiveReactionData();
    if !IsDefined(activeReactionData) {
      activeReactionData = ownerPuppet.GetStimReactionComponent().GetDesiredReactionData();
    };
    if activeReactionData.initAnimInWorkspot && NotEquals(activeReactionData.stimType, gamedataStimType.Scream) {
      return AIbehaviorConditionOutcomes.False;
    };
    if activeReactionData.skipInitialAnimation {
      return AIbehaviorConditionOutcomes.False;
    };
    if Equals(activeReactionData.stimType, gamedataStimType.GrenadeLanded) && !this.m_grenadePanic {
      return AIbehaviorConditionOutcomes.False;
    };
    if Equals(activeReactionData.reactionBehaviorName, gamedataOutput.DodgeToSide) {
      return AIbehaviorConditionOutcomes.False;
    };
    if activeReactionData.stimRecord.TagsContains(n"NoInitFearAnimation") {
      return AIbehaviorConditionOutcomes.False;
    };
    return AIbehaviorConditionOutcomes.True;
  }
}

public class PlayStartupLocoFearAnimation extends AIbehaviorconditionScript {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let ownerPuppet: wref<ScriptedPuppet> = ScriptExecutionContext.GetOwner(context) as ScriptedPuppet;
    let reactionCmp: ref<ReactionManagerComponent> = ownerPuppet.GetStimReactionComponent();
    let activeReactionData: ref<AIReactionData> = reactionCmp.GetActiveReactionData();
    if !IsDefined(activeReactionData) {
      activeReactionData = reactionCmp.GetDesiredReactionData();
    };
    if activeReactionData.initAnimInWorkspot && reactionCmp.GetPreviousFearPhase() != 2 {
      return AIbehaviorConditionOutcomes.False;
    };
    return AIbehaviorConditionOutcomes.True;
  }
}

public class IsWorkspotReaction extends AIbehaviorconditionScript {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>((ScriptExecutionContext.GetOwner(context) as ScriptedPuppet).GetStimReactionComponent().GetWorkSpotReactionFlag());
  }
}

public class IsValidCombatTarget extends AIbehaviorconditionScript {

  public edit let m_considerSourceAVehicleDriver: Bool;

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let driverInstigator: wref<GameObject>;
    let instigator: ref<ScriptedPuppet>;
    let investigateData: stimInvestigateData;
    let source: ref<ScriptedPuppet>;
    let vehicle: ref<VehicleObject>;
    let puppet: ref<ScriptedPuppet> = AIBehaviorScriptBase.GetPuppet(context);
    let stimReactionComp: ref<ReactionManagerComponent> = puppet.GetStimReactionComponent();
    let activeReactionData: ref<AIReactionData> = stimReactionComp.GetActiveOrDesiredReactionData();
    stimReactionComp.LogStart(EReactLogSource.BehaviorCombatCheck, "IsValidCombatTarget check");
    if activeReactionData.stimRecord.TagsContains(n"NoAutoCombatStart") {
      stimReactionComp.LogFailure("this stim can not start combat");
      return AIbehaviorConditionOutcomes.False;
    };
    investigateData = activeReactionData.stimInvestigateData;
    instigator = investigateData.attackInstigator as ScriptedPuppet;
    source = activeReactionData.stimEventData.source as ScriptedPuppet;
    vehicle = activeReactionData.stimEventData.source as VehicleObject;
    if !IsDefined(source) && IsDefined(vehicle) && this.m_considerSourceAVehicleDriver {
      driverInstigator = VehicleComponent.GetDriver(puppet.GetGame(), vehicle, vehicle.GetEntityID());
      source = driverInstigator as ScriptedPuppet;
    };
    if puppet.IsPrevention() && !this.IsValidForPrevention(instigator, source) {
      stimReactionComp.LogFailure("non-player combat stim can\'t start prevention combat");
      return AIbehaviorConditionOutcomes.False;
    };
    if stimReactionComp.ShouldIgnoreCombatStim(activeReactionData.stimType, instigator, source, activeReactionData.stimSource, true) {
      stimReactionComp.LogFailure("combat stim explicitely ignored");
      return AIbehaviorConditionOutcomes.False;
    };
    stimReactionComp.LogSuccess("combat can be started");
    return AIbehaviorConditionOutcomes.True;
  }

  private final func IsValidForPrevention(instigator: ref<ScriptedPuppet>, source: ref<ScriptedPuppet>) -> Bool {
    if IsDefined(source) {
      return source.IsPlayer();
    };
    if IsDefined(instigator) {
      return instigator.IsPlayer();
    };
    return false;
  }
}

public class IsPlayerAKiller extends AIbehaviorconditionScript {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let investigateData: stimInvestigateData = AIBehaviorScriptBase.GetPuppet(context).GetStimReactionComponent().GetActiveReactionData().stimInvestigateData;
    let killer: ref<GameObject> = investigateData.attackInstigator as GameObject;
    if killer.IsPlayer() {
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class CheckStimRevealsInstigatorPosition extends AIbehaviorconditionScript {

  public edit let m_checkStimType: Bool;

  public edit let m_stimType: gamedataStimType;

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let investigateData: stimInvestigateData;
    let stimuliCache: array<ref<StimEventTaskData>> = (ScriptExecutionContext.GetOwner(context) as ScriptedPuppet).GetStimReactionComponent().GetStimuliCache();
    if ArraySize(stimuliCache) != 0 {
      investigateData = stimuliCache[ArraySize(stimuliCache) - 1].cachedEvt.stimInvestigateData;
      if investigateData.revealsInstigatorPosition {
        if !this.m_checkStimType || Equals(stimuliCache[ArraySize(stimuliCache) - 1].cachedEvt.GetStimType(), this.m_stimType) {
          return AIbehaviorConditionOutcomes.True;
        };
      };
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class CheckLastTriggeredStimuli extends AIbehaviorconditionScript {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let stimSourcePos: Vector4;
    let stimuliEvent: ref<StimuliEvent>;
    let stimuliCache: array<ref<StimEventTaskData>> = (ScriptExecutionContext.GetOwner(context) as ScriptedPuppet).GetStimReactionComponent().GetStimuliCache();
    if ArraySize(stimuliCache) != 0 {
      stimuliEvent = stimuliCache[ArraySize(stimuliCache) - 1].cachedEvt;
      if Equals(stimuliEvent.GetStimType(), gamedataStimType.Whistle) || Equals(stimuliEvent.GetStimType(), gamedataStimType.CombatWhistle) {
        return AIbehaviorConditionOutcomes.False;
      };
      stimSourcePos = stimuliEvent.sourcePosition;
      if !Vector4.IsZero(stimSourcePos) {
        if Equals(stimuliEvent.GetStimType(), gamedataStimType.CrimeWitness) {
          if PreventionSystem.IsChasingPlayer(ScriptExecutionContext.GetOwner(context).GetGame()) && stimuliEvent.sourceObject.GetEntityID() == PreventionSystem.GetLastKnownPlayerVehicle(ScriptExecutionContext.GetOwner(context).GetGame()).GetEntityID() {
            PreventionSystem.SetLastKnownPlayerPosition(ScriptExecutionContext.GetOwner(context).GetGame(), PreventionSystem.GetLastKnownPlayerVehicle(ScriptExecutionContext.GetOwner(context).GetGame()).GetWorldPosition());
            if !VehicleComponent.IsMountedToVehicle(ScriptExecutionContext.GetOwner(context).GetGame(), ScriptExecutionContext.GetOwner(context)) {
              return AIbehaviorConditionOutcomes.False;
            };
          };
        };
        ScriptExecutionContext.SetArgumentVector(context, n"StimSource", stimSourcePos);
        return AIbehaviorConditionOutcomes.True;
      };
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class CheckAnimSetTags extends AIbehaviorconditionScript {

  public edit const let m_animsetTagToCompare: [CName];

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    if (ScriptExecutionContext.GetOwner(context) as ScriptedPuppet).HasRuntimeAnimsetTags(this.m_animsetTagToCompare) {
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class HasPositionFarFromThreat extends AIbehaviorconditionScript {

  public edit let desiredDistance: Float;

  public edit let minDistance: Float;

  public edit let minPathLength: Float;

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let currentPosition: Vector4;
    let destination: Vector4;
    let pathLength: Float;
    let pathResult: ref<NavigationPath>;
    let threatPosition: Vector4;
    let threat: ref<GameObject> = ScriptExecutionContext.GetArgumentObject(context, n"StimTarget");
    if threat == null {
      return AIbehaviorConditionOutcomes.False;
    };
    currentPosition = ScriptExecutionContext.GetOwner(context).GetWorldPosition();
    threatPosition = threat.GetWorldPosition();
    if !GameInstance.GetNavigationSystem(AIBehaviorScriptBase.GetGame(context)).FindNavmeshPointAwayFromReferencePoint(currentPosition, threatPosition, this.desiredDistance, NavGenAgentSize.Human, destination, 5.00, 90.00) {
      return AIbehaviorConditionOutcomes.False;
    };
    if Vector4.LengthSquared(threatPosition - destination) < this.minDistance * this.minDistance {
      return AIbehaviorConditionOutcomes.False;
    };
    pathResult = GameInstance.GetAINavigationSystem(AIBehaviorScriptBase.GetGame(context)).CalculatePathForCharacter(currentPosition, destination, 1.00, ScriptExecutionContext.GetOwner(context));
    if IsDefined(pathResult) {
      pathLength = pathResult.CalculateLength();
    };
    if pathLength < this.minPathLength {
      return AIbehaviorConditionOutcomes.False;
    };
    ScriptExecutionContext.SetArgumentFloat(context, n"PathLength", pathLength);
    ScriptExecutionContext.SetArgumentVector(context, n"MovementDestination", destination);
    return AIbehaviorConditionOutcomes.True;
  }
}

public class CanNPCRun extends AIbehaviorconditionScript {

  public edit let m_maxRunners: Int32;

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let reactionSystem: ref<ScriptedReactionSystem> = GameInstance.GetScriptableSystemsContainer(ScriptExecutionContext.GetOwner(context).GetGame()).Get(n"ScriptedReactionSystem") as ScriptedReactionSystem;
    let runners: Int32 = reactionSystem.GetFleeingNPCsCount();
    let reactionData: ref<AIReactionData> = AIBehaviorScriptBase.GetPuppet(context).GetStimReactionComponent().GetActiveReactionData();
    if !IsDefined(reactionData) {
      reactionData = AIBehaviorScriptBase.GetPuppet(context).GetStimReactionComponent().GetDesiredReactionData();
    };
    if runners >= this.m_maxRunners && NotEquals(reactionData.stimType, gamedataStimType.HijackVehicle) {
      if reactionSystem.GetRegisterTimeout() > EngineTime.ToFloat(GameInstance.GetSimTime(ScriptExecutionContext.GetOwner(context).GetGame())) {
        runners = reactionSystem.GetFleeingNPCsCountInDistance(ScriptExecutionContext.GetOwner(context).GetWorldPosition(), 10.00);
        if runners >= this.m_maxRunners {
          return AIbehaviorConditionOutcomes.False;
        };
      };
    };
    return AIbehaviorConditionOutcomes.True;
  }
}

public class ShouldNPCContinueInAlerted extends AIbehaviorconditionScript {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let npcIgnoreList: array<EntityID>;
    let reactionComponent: ref<ReactionManagerComponent>;
    let searchEndTimestamp: Float;
    let alertedWithCorpses: Bool = false;
    let puppet: ref<ScriptedPuppet> = ScriptExecutionContext.GetOwner(context) as ScriptedPuppet;
    let aiComponent: ref<AIHumanComponent> = puppet.GetAIControllerComponent();
    if IsDefined(aiComponent) && Equals(aiComponent.GetAIRole().GetRoleEnum(), EAIRole.Patrol) && aiComponent.GetAIPatrolBlackboard().GetBool(GetAllBlackboardDefs().AIPatrol.forceAlerted) {
      return AIbehaviorConditionOutcomes.True;
    };
    if puppet.IsConnectedToSecuritySystem() {
      if puppet.GetSecuritySystem().IsReprimandOngoing() {
        return AIbehaviorConditionOutcomes.True;
      };
      reactionComponent = puppet.GetStimReactionComponent();
      npcIgnoreList = reactionComponent.GetIgnoreList();
      if reactionComponent.IsAlertedByDeadBody() || ArraySize(npcIgnoreList) > 0 {
        alertedWithCorpses = true;
      };
    };
    searchEndTimestamp = ScriptExecutionContext.GetArgumentFloat(context, n"SearchingStarted");
    if alertedWithCorpses {
      searchEndTimestamp += TweakDBInterface.GetFloat(t"AIGeneralSettings.alertedSearchDurationWithCorpses", 5.00);
    } else {
      searchEndTimestamp += TweakDBInterface.GetFloat(t"AIGeneralSettings.alertedSearchDurationNormal", 5.00);
    };
    return Cast<AIbehaviorConditionOutcomes>(searchEndTimestamp > EngineTime.ToFloat(GameInstance.GetSimTime(ScriptExecutionContext.GetOwner(context).GetGame())));
  }
}

public class IsInTrafficLane extends AIbehaviorconditionScript {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(AIBehaviorScriptBase.GetPuppet(context).GetStimReactionComponent().IsInTrafficLane());
  }
}

public class IsBlockedInTraffic extends AIbehaviorconditionScript {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(AIBehaviorScriptBase.GetPuppet(context).GetCrowdMemberComponent().IsBlockedInTraffic());
  }
}

public class PreviousFearPhaseCheck extends AIbehaviorconditionScript {

  public edit let m_fearPhase: Int32;

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(AIBehaviorScriptBase.GetPuppet(context).GetStimReactionComponent().GetPreviousFearPhase() == this.m_fearPhase);
  }
}

public class HearStimThreshold extends AIbehaviorconditionScript {

  public edit let m_thresholdNumber: Int32;

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let curThresholdNumber: Int32;
    let stimTime: Float;
    let puppet: ref<ScriptedPuppet> = ScriptExecutionContext.GetOwner(context) as ScriptedPuppet;
    let reactionComponent: ref<ReactionManagerComponent> = puppet.GetStimReactionComponent();
    if !IsDefined(reactionComponent) {
      return AIbehaviorConditionOutcomes.False;
    };
    stimTime = reactionComponent.GetCurrentStimTimeStamp();
    curThresholdNumber = reactionComponent.GetCurrentStimThresholdValue();
    if stimTime >= EngineTime.ToFloat(GameInstance.GetSimTime(ScriptExecutionContext.GetOwner(context).GetGame())) {
      if curThresholdNumber >= this.m_thresholdNumber {
        return AIbehaviorConditionOutcomes.True;
      };
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class StealthStimThreshold extends AIbehaviorconditionScript {

  public edit let m_stealthThresholdNumber: Int32;

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let curThresholdNumber: Int32;
    let stimTime: Float;
    let puppet: ref<ScriptedPuppet> = ScriptExecutionContext.GetOwner(context) as ScriptedPuppet;
    let reactionComponent: ref<ReactionManagerComponent> = puppet.GetStimReactionComponent();
    if !IsDefined(reactionComponent) {
      return AIbehaviorConditionOutcomes.False;
    };
    stimTime = reactionComponent.GetCurrentStealthStimTimeStamp();
    curThresholdNumber = reactionComponent.GetCurrentStealthStimThresholdValue();
    if stimTime >= EngineTime.ToFloat(GameInstance.GetSimTime(ScriptExecutionContext.GetOwner(context).GetGame())) {
      if curThresholdNumber >= this.m_stealthThresholdNumber {
        return AIbehaviorConditionOutcomes.True;
      };
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class CanDoReactionAction extends AIbehaviorconditionScript {

  public edit let m_reactionName: CName;

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let reactionSystem: ref<ReactionSystem> = GameInstance.GetReactionSystem(ScriptExecutionContext.GetOwner(context).GetGame());
    if IsDefined(reactionSystem) && Equals(reactionSystem.RegisterReaction(this.m_reactionName), AIReactionCountOutcome.Succeded) {
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class CheckTimestamp extends AIbehaviorconditionScript {

  public edit let m_validationTime: Float;

  public edit let m_timestampArgument: CName;

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let timestamp: Float = ScriptExecutionContext.GetArgumentFloat(context, this.m_timestampArgument);
    if timestamp + this.m_validationTime > EngineTime.ToFloat(GameInstance.GetSimTime(ScriptExecutionContext.GetOwner(context).GetGame())) {
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class EscalateProvoke extends AIbehaviorconditionScript {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let reactionData: ref<AIReactionData> = AIBehaviorScriptBase.GetPuppet(context).GetStimReactionComponent().GetActiveReactionData();
    if !IsDefined(reactionData) {
      reactionData = AIBehaviorScriptBase.GetPuppet(context).GetStimReactionComponent().GetDesiredReactionData();
    };
    if IsDefined(reactionData) && reactionData.escalateProvoke {
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class ReactAfterDodge extends AIbehaviorconditionScript {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let mountInfo: MountingInfo;
    let target: ref<GameObject>;
    let ownerPuppet: ref<ScriptedPuppet> = ScriptExecutionContext.GetOwner(context) as ScriptedPuppet;
    if ScriptedPuppet.IsPlayerFollower(ScriptExecutionContext.GetOwner(context)) {
      return AIbehaviorConditionOutcomes.False;
    };
    if ownerPuppet.IsCrowd() {
      return AIbehaviorConditionOutcomes.True;
    };
    target = ScriptExecutionContext.GetArgumentObject(context, n"StimTarget");
    if GameObject.IsVehicle(target) {
      mountInfo = GameInstance.GetMountingFacility(ownerPuppet.GetGame()).GetMountingInfoSingleWithObjects(target);
      target = GameInstance.FindEntityByID(ownerPuppet.GetGame(), mountInfo.childId) as GameObject;
    };
    if IsDefined(target) && Equals(GameObject.GetAttitudeBetween(ownerPuppet, target), EAIAttitude.AIA_Friendly) {
      return AIbehaviorConditionOutcomes.False;
    };
    return AIbehaviorConditionOutcomes.True;
  }
}
