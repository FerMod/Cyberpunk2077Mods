
public abstract class TweakAIActionAbstract extends AIbehaviortaskScript {

  private let m_actionRecord: wref<AIAction_Record>;

  private let m_actionDebugName: String;

  private let m_actionActivationTimeStamp: Float;

  private let m_startActionTimeStamp: Float;

  protected let m_hasGracefulInterruptionConditions: Bool;

  protected let m_gracefulInterruptionCheckRandomizedInterval: Float;

  protected let m_gracefullyInterrupted: Bool;

  private let m_actionPhase: EAIActionPhase;

  private let m_phaseRecord: wref<AIActionPhase_Record>;

  private let m_nextPhaseConditionCount: Int32;

  private let m_repeatPhaseConditionCount: Int32;

  private let m_phaseActivationTimeStamp: Float;

  private let m_phaseConditionSuccessfulCheckTimeStamp: Float;

  private let m_phaseConditionCheckTimeStamp: Float;

  private let m_phaseConditionCheckRandomizedInterval: Float;

  private let m_phaseIteration: Uint32;

  private let m_phaseDuration: Float;

  private let m_phaseAnimationDuration: Float;

  private let m_lookatEvents: [ref<LookAtAddEvent>];

  private let m_movePolicy: ref<MovePolicies>;

  private let m_generalSubActionsResults: [AIbehaviorUpdateOutcome; 8];

  private let m_phaseSubActionsResults: [AIbehaviorUpdateOutcome; 8];

  private let m_phaseSubActionsCount: Int32;

  private let m_phaseForceZeroUpdateInterval: Bool;

  private let m_generalSubActionsCount: Int32;

  private let m_repeatPhaseConditionsCount: Int32;

  private let m_tickForActionDurationOnly: Bool;

  private let m_tickForActionDurationActivePhase: EAIActionPhase;

  private let m_hasTicketDeactivationConditions: Bool;

  private let m_isActionImmediate: Bool;

  private let m_lookatActivated: Bool;

  private let m_ticketsCommited: Bool;

  private let m_ticketsAcknowledged: Bool;

  private let m_failureStatus: Bool;

  private let m_animationLoaded: Bool;

  private let m_initializedAfterActivation: Bool;

  protected let m_shouldCallGetActionRecordAgain: Bool;

  private final func Initialize(const context: ScriptExecutionContext) -> Void {
    this.m_actionPhase = EAIActionPhase.Inactive;
    this.m_shouldCallGetActionRecordAgain = false;
    AIbehaviortaskScript.SetUpdateInterval(context, 0.00);
    if !this.GetActionRecord(context, this.m_actionDebugName, this.m_actionRecord, this.m_shouldCallGetActionRecordAgain) {
      if !this.m_shouldCallGetActionRecordAgain {
        this.m_actionRecord = null;
      };
    } else {
      this.ActionUpdateIntervalCheck(context);
    };
  }

  private final func ActionUpdateIntervalCheck(const context: ScriptExecutionContext) -> Void {
    let animData: wref<AIActionAnimData_Record>;
    let endConditions: Bool;
    let phase: ref<AIActionPhase_Record>;
    this.m_generalSubActionsCount = 0;
    this.m_repeatPhaseConditionsCount = 0;
    this.m_tickForActionDurationOnly = false;
    this.m_hasTicketDeactivationConditions = false;
    this.m_isActionImmediate = false;
    this.m_tickForActionDurationActivePhase = EAIActionPhase.Inactive;
    if this.IsActionImmediate() {
      this.m_isActionImmediate = true;
      return;
    };
    if this.HasTicketDeactivationCondition(context) {
      this.m_hasTicketDeactivationConditions = true;
    };
    this.m_generalSubActionsCount = this.m_actionRecord.GetSubActionsCount();
    if this.m_generalSubActionsCount > 0 {
      return;
    };
    if this.m_actionRecord.GetStartupSubActionsCount() > 0 {
      return;
    };
    if this.m_actionRecord.GetLoopSubActionsCount() > 0 {
      return;
    };
    if this.m_actionRecord.GetRecoverySubActionsCount() > 0 {
      return;
    };
    phase = this.m_actionRecord.Startup();
    if IsDefined(phase) {
      if phase.GetToNextPhaseConditionCount() > 0 {
        endConditions = true;
      };
      if phase.GetNotRepeatPhaseConditionCount() > 0 {
        this.m_repeatPhaseConditionsCount += 1;
      };
    };
    phase = this.m_actionRecord.Loop();
    if IsDefined(phase) {
      if phase.GetToNextPhaseConditionCount() > 0 {
        endConditions = true;
      };
      if phase.GetNotRepeatPhaseConditionCount() > 0 {
        this.m_repeatPhaseConditionsCount += 1;
      };
    };
    phase = this.m_actionRecord.Recovery();
    if IsDefined(phase) {
      if phase.GetToNextPhaseConditionCount() > 0 {
        endConditions = true;
      };
      if phase.GetNotRepeatPhaseConditionCount() > 0 {
        this.m_repeatPhaseConditionsCount += 1;
      };
    };
    if endConditions {
      return;
    };
    if this.m_hasTicketDeactivationConditions {
      return;
    };
    if this.m_hasGracefulInterruptionConditions {
      return;
    };
    if this.GetTotalActionDuration() > 0.00 {
      this.m_tickForActionDurationOnly = true;
      return;
    };
    animData = this.m_actionRecord.AnimData();
    if IsDefined(animData) && IsNameValid(animData.AnimFeature()) {
      this.m_tickForActionDurationOnly = true;
    };
  }

  protected final func VerifyActionRecord() -> Bool {
    if this.m_actionRecord != null || this.m_shouldCallGetActionRecordAgain {
      return true;
    };
    return false;
  }

  protected func Activate(context: ScriptExecutionContext) -> Void {
    this.Initialize(context);
    this.m_initializedAfterActivation = false;
    this.m_ticketsAcknowledged = false;
    this.m_animationLoaded = false;
    this.m_ticketsCommited = false;
    this.m_failureStatus = false;
    this.m_lookatActivated = false;
    if IsDefined(this.m_actionRecord) {
      this.ActivateAnimationWrapperOverrides(context);
    };
  }

  protected final func RetryGetActionRecord(context: ScriptExecutionContext) -> Bool {
    if this.m_shouldCallGetActionRecordAgain {
      this.m_shouldCallGetActionRecordAgain = false;
      if this.GetActionRecord(context, this.m_actionDebugName, this.m_actionRecord, this.m_shouldCallGetActionRecordAgain) {
        this.ActionUpdateIntervalCheck(context);
        if this.m_shouldCallGetActionRecordAgain {
          this.m_shouldCallGetActionRecordAgain = false;
          return true;
        };
        return true;
      };
      if this.m_shouldCallGetActionRecordAgain {
        AIBehaviorScriptBase.GetAIComponent(context).ForceTickNextFrame();
        return false;
      };
      this.m_actionRecord = null;
      return false;
    };
    return true;
  }

  private final func WaitForAnimToLoad(const context: ScriptExecutionContext) -> Bool {
    let animFeatureName: CName;
    let animVariation: Int32;
    let phaseToCheck: Int32;
    let variationSubAction: ref<AISubAction_Record>;
    let animData: ref<AIActionAnimData_Record> = this.m_actionRecord.AnimData();
    if !IsDefined(animData) {
      return false;
    };
    if !IsDefined(animData.AnimSlot()) {
      return false;
    };
    animFeatureName = animData.AnimFeature();
    if !IsNameValid(animFeatureName) {
      return false;
    };
    phaseToCheck = 0;
    if IsDefined(this.m_actionRecord.Startup()) {
      phaseToCheck = 1;
    } else {
      if IsDefined(this.m_actionRecord.Loop()) {
        phaseToCheck = 2;
      } else {
        if IsDefined(this.m_actionRecord.Recovery()) {
          phaseToCheck = 3;
        };
      };
    };
    if animData.AnimSlot().UsePoseMatching() {
      animVariation = -1;
    } else {
      variationSubAction = animData.AnimVariationSubAction();
      if IsDefined(variationSubAction) {
        animVariation = AIScriptUtils.CallGetAnimVariation(context, variationSubAction);
      } else {
        animVariation = animData.AnimVariation();
      };
    };
    if AIScriptUtils.CheckAnimation(context, animFeatureName, animVariation, phaseToCheck, true) {
      this.m_animationLoaded = true;
      return false;
    };
    return true;
  }

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let phaseChanged: Bool;
    let squadInterface: ref<PuppetSquadInterface>;
    let subActionsOutcome: AIbehaviorUpdateOutcome;
    if !this.RetryGetActionRecord(context) {
      return AIbehaviorUpdateOutcome.IN_PROGRESS;
    };
    if !IsDefined(this.m_actionRecord) {
      this.m_actionDebugName = "No Action Record Selected";
      this.m_actionRecord = null;
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    if !this.m_lookatActivated {
      this.DeactivateLookat(context);
      if this.m_actionRecord.GetLookatsCount() > 0 {
        this.ActivateLookat(context);
      };
      this.m_lookatActivated = true;
    };
    if !this.m_animationLoaded && this.m_actionRecord.WaitForAnimationToLoad() && this.WaitForAnimToLoad(context) {
      return AIbehaviorUpdateOutcome.IN_PROGRESS;
    };
    if AISquadHelper.GetSquadBaseInterface(ScriptExecutionContext.GetOwner(context), squadInterface) {
      if !this.m_ticketsCommited {
        this.m_actionActivationTimeStamp = EngineTime.ToFloat(ScriptExecutionContext.GetAITime(context));
        this.m_startActionTimeStamp = 0.00;
        AIScriptSquad.CommitToTickets(context, this.m_actionRecord);
        this.m_ticketsCommited = true;
      };
      if !this.m_ticketsAcknowledged {
        if AIScriptSquad.WaitForTicketsAcknowledgement(context, this.m_actionRecord) {
          if this.m_actionRecord.TicketAcknowledgeTimeout() > 0.00 && this.GetActionDuration(context) > this.m_actionRecord.TicketAcknowledgeTimeout() {
            this.m_failureStatus = true;
            return AIbehaviorUpdateOutcome.FAILURE;
          };
          return AIbehaviorUpdateOutcome.IN_PROGRESS;
        };
        this.m_ticketsAcknowledged = true;
      };
    };
    if !this.m_initializedAfterActivation {
      this.m_actionActivationTimeStamp = EngineTime.ToFloat(ScriptExecutionContext.GetAITime(context));
      this.m_startActionTimeStamp = 0.00;
      this.ActivateGeneralSubActions(context);
      this.ChangeToNextPhase(context);
      this.TrackCommands(context, false);
      if IsDefined(this.m_actionRecord.AnimData()) {
        this.ActivateAnimData(context);
      };
      this.m_initializedAfterActivation = true;
    };
    this.StartActionTimeStamp(context);
    if this.UpdateActivePhase(context, subActionsOutcome, phaseChanged) {
      switch subActionsOutcome {
        case AIbehaviorUpdateOutcome.FAILURE:
          this.m_failureStatus = true;
          return AIbehaviorUpdateOutcome.FAILURE;
        case AIbehaviorUpdateOutcome.SUCCESS:
          if !phaseChanged {
            this.ReactOnAllPhaseSubActionsCompleted(context);
          };
          return AIbehaviorUpdateOutcome.IN_PROGRESS;
        default:
          return AIbehaviorUpdateOutcome.IN_PROGRESS;
      };
    };
    if this.m_failureStatus {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    if this.m_actionRecord.CompleteWithFailure() {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    return AIbehaviorUpdateOutcome.SUCCESS;
  }

  protected func Deactivate(context: ScriptExecutionContext) -> Void {
    if !this.ChangePhaseTo(context, EAIActionPhase.Inactive) {
      AIbehaviortaskScript.SetUpdateInterval(context, 0.00);
    };
    this.DeactivateGeneralSubActions(context, this.GetActionDuration(context));
    this.DeactivateLookat(context);
    this.TrackCommands(context, true);
    if IsDefined(this.m_actionRecord) {
      this.DeactivateAnimationWrapperOverrides(context);
      if IsDefined(this.m_actionRecord.AnimData()) {
        this.DeactivateAnimData(context);
      };
      this.StartCooldowns(context);
      if IsDefined(this.m_actionRecord.AnimData()) && IsDefined(this.m_actionRecord.AnimData().AnimVariationSubAction()) {
        TweakAISubAction.Deactivate(context, this.m_actionRecord.AnimData().AnimVariationSubAction(), this.GetActionDuration(context), false);
      };
      AIScriptSquad.CompleteTickets(context, this.m_actionRecord, !this.m_failureStatus);
      AIScriptSquad.CloseTickets(context, this.m_actionRecord);
      if !IsFinal() {
        ScriptExecutionContext.GetTweakActionSystem(context).Debug_OnActionEnded(context, this.m_actionRecord.GetID());
      };
    };
    this.m_initializedAfterActivation = false;
  }

  protected func ChildCompleted(context: ScriptExecutionContext, status: AIbehaviorCompletionStatus) -> Void {
    if Equals(status, AIbehaviorCompletionStatus.FAILURE) {
      this.m_failureStatus = true;
    };
  }

  private final func GetActionDuration(const context: ScriptExecutionContext) -> Float {
    if this.m_startActionTimeStamp == 0.00 {
      return EngineTime.ToFloat(ScriptExecutionContext.GetAITime(context)) - this.m_actionActivationTimeStamp;
    };
    return EngineTime.ToFloat(ScriptExecutionContext.GetAITime(context)) - this.m_startActionTimeStamp;
  }

  private final func GetTotalActionDuration() -> Float {
    let startup: Float = this.m_actionRecord.Startup().Duration();
    let loop: Float = this.m_actionRecord.Loop().Duration();
    let recovery: Float = this.m_actionRecord.Recovery().Duration();
    if startup < 0.00 {
      startup = 0.00;
    };
    if loop < 0.00 {
      loop = 0.00;
    };
    if recovery < 0.00 {
      recovery = 0.00;
    };
    return startup + loop + recovery;
  }

  private final func IsActionImmediate() -> Bool {
    let startup: Float = this.m_actionRecord.Startup().Duration();
    let loop: Float = this.m_actionRecord.Loop().Duration();
    let recovery: Float = this.m_actionRecord.Recovery().Duration();
    if startup < 0.00 {
      return false;
    };
    if loop < 0.00 {
      return false;
    };
    if recovery < 0.00 {
      return false;
    };
    return startup + loop + recovery <= 0.10;
  }

  private final func StartActionTimeStamp(const context: ScriptExecutionContext) -> Void {
    if this.m_startActionTimeStamp == 0.00 {
      this.m_startActionTimeStamp = EngineTime.ToFloat(ScriptExecutionContext.GetAITime(context));
    };
  }

  private final func HasTicketDeactivationCondition(const context: ScriptExecutionContext) -> Bool {
    let baseSquadRecord: wref<AISquadParams_Record>;
    let i: Int32;
    let squadRecord: ref<AISquadParams_Record>;
    let ticket: ref<AITicket_Record>;
    let ticketType: wref<AITicketType_Record>;
    let count: Int32 = this.m_actionRecord.GetTicketsCount();
    if count > 0 {
      AIScriptSquad.GetBaseSquadRecord(baseSquadRecord);
      i = 0;
      while i < count {
        ticketType = this.m_actionRecord.GetTicketsItem(i);
        if AIScriptUtils.GetTicketType(ticketType.EnumName(), AIBehaviorScriptBase.GetPuppet(context), baseSquadRecord, ticket, squadRecord) {
          if ticket.GetDeactivationConditionCount() > 0 {
            return true;
          };
        };
        i += 1;
      };
    };
    return false;
  }

  private final func SetPhaseUpdateInterval(const context: ScriptExecutionContext, subActionsOutcome: AIbehaviorUpdateOutcome, generalSubActionsOutcome: AIbehaviorUpdateOutcome) -> Void {
    let phaseDuration: Float;
    if Equals(this.m_actionPhase, EAIActionPhase.Inactive) {
      return;
    };
    if this.m_isActionImmediate {
      return;
    };
    if this.m_phaseDuration < 0.00 {
      phaseDuration = 999999.00;
    } else {
      phaseDuration = this.m_phaseDuration;
    };
    if this.m_tickForActionDurationOnly {
      AIbehaviortaskScript.SetUpdateInterval(context, phaseDuration);
      this.m_tickForActionDurationActivePhase = this.m_actionPhase;
      return;
    };
    if this.m_phaseSubActionsCount > 0 && Equals(subActionsOutcome, AIbehaviorUpdateOutcome.IN_PROGRESS) {
      return;
    };
    if this.m_phaseSubActionsCount == 0 && this.m_generalSubActionsCount > 0 && Equals(generalSubActionsOutcome, AIbehaviorUpdateOutcome.IN_PROGRESS) {
      return;
    };
    if (this.m_nextPhaseConditionCount > 0 || this.m_hasGracefulInterruptionConditions || this.m_hasTicketDeactivationConditions) && this.m_phaseDuration > 0.00 {
      return;
    };
    if this.m_phaseForceZeroUpdateInterval {
      AIbehaviortaskScript.SetUpdateInterval(context, 0.00);
      return;
    };
    if this.m_hasGracefulInterruptionConditions && this.m_nextPhaseConditionCount > 0 {
      if this.m_gracefulInterruptionCheckRandomizedInterval < this.m_phaseConditionCheckRandomizedInterval {
        AIbehaviortaskScript.SetUpdateInterval(context, this.m_gracefulInterruptionCheckRandomizedInterval);
        return;
      };
      AIbehaviortaskScript.SetUpdateInterval(context, this.m_phaseConditionCheckRandomizedInterval);
      return;
    };
    if this.m_nextPhaseConditionCount > 0 {
      AIbehaviortaskScript.SetUpdateInterval(context, this.m_phaseConditionCheckRandomizedInterval);
      return;
    };
    if this.m_hasGracefulInterruptionConditions {
      AIbehaviortaskScript.SetUpdateInterval(context, this.m_gracefulInterruptionCheckRandomizedInterval);
      return;
    };
    if this.m_hasTicketDeactivationConditions {
      AIbehaviortaskScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.40));
      return;
    };
    if this.GetTotalActionDuration() > 0.00 && this.GetTotalActionDuration() > this.GetActionDuration(context) {
      AIbehaviortaskScript.SetUpdateInterval(context, phaseDuration - this.GetPhaseDuration(context));
      return;
    };
    AIbehaviortaskScript.SetUpdateInterval(context, phaseDuration);
  }

  private final func UpdateActivePhase(const context: ScriptExecutionContext, out subActionsOutcome: AIbehaviorUpdateOutcome, out phaseChanged: Bool) -> Bool {
    let generalSubActionsOutcome: AIbehaviorUpdateOutcome;
    if Equals(this.m_actionPhase, EAIActionPhase.Inactive) {
      return false;
    };
    if !IsDefined(this.m_phaseRecord) {
      phaseChanged = this.ChangeToNextPhase(context);
      return Equals(this.m_actionPhase, EAIActionPhase.Inactive) ? false : true;
    };
    subActionsOutcome = this.UpdateSubActions(context, generalSubActionsOutcome);
    if this.m_nextPhaseConditionCount > 0 {
      if this.m_phaseConditionCheckRandomizedInterval <= 0.00 || this.m_phaseConditionCheckRandomizedInterval > 0.00 && EngineTime.ToFloat(ScriptExecutionContext.GetAITime(context)) >= this.m_phaseConditionCheckTimeStamp + this.m_phaseConditionCheckRandomizedInterval {
        if AICondition.NextPhaseCheck(context, EnumInt(this.m_actionPhase), this.m_actionRecord) {
          if this.m_phaseRecord.ConditionSuccessDuration() > 0.00 && this.m_phaseConditionSuccessfulCheckTimeStamp < 0.00 {
            this.m_phaseConditionSuccessfulCheckTimeStamp = EngineTime.ToFloat(ScriptExecutionContext.GetAITime(context));
          };
          if IsDefined(this.m_phaseRecord) && this.m_phaseRecord.CompleteActionWithFailureOnCondition() {
            this.m_failureStatus = true;
          };
          if this.m_phaseRecord.ConditionSuccessDuration() <= 0.00 || this.m_phaseRecord.ConditionSuccessDuration() > 0.00 && EngineTime.ToFloat(ScriptExecutionContext.GetAITime(context)) >= this.m_phaseConditionSuccessfulCheckTimeStamp + this.m_phaseRecord.ConditionSuccessDuration() {
            phaseChanged = this.ChangeToNextPhase(context);
          };
        } else {
          this.m_phaseConditionSuccessfulCheckTimeStamp = -1.00;
        };
        this.m_phaseConditionCheckTimeStamp = EngineTime.ToFloat(ScriptExecutionContext.GetAITime(context));
      };
    };
    if this.m_tickForActionDurationOnly && Equals(this.m_tickForActionDurationActivePhase, this.m_actionPhase) || this.m_phaseDuration == 0.00 || this.m_phaseDuration > 0.00 && this.GetPhaseDurationWithoutFrameDelta(context) >= this.m_phaseDuration {
      if !this.RepeatPhase(context) {
        if Equals(subActionsOutcome, AIbehaviorUpdateOutcome.SUCCESS) {
          subActionsOutcome = AIbehaviorUpdateOutcome.IN_PROGRESS;
        };
        phaseChanged = this.ChangeToNextPhase(context);
      };
    };
    this.SetPhaseUpdateInterval(context, subActionsOutcome, generalSubActionsOutcome);
    return Equals(this.m_actionPhase, EAIActionPhase.Inactive) ? false : true;
  }

  private final func UpdateSubActions(const context: ScriptExecutionContext, out generalResult: AIbehaviorUpdateOutcome) -> AIbehaviorUpdateOutcome {
    let phaseResult: AIbehaviorUpdateOutcome;
    generalResult = this.UpdateGeneralSubActions(context, this.GetActionDuration(context));
    switch this.m_actionPhase {
      case EAIActionPhase.Startup:
        phaseResult = this.UpdateStartupSubActions(context, this.GetPhaseDuration(context), this.m_phaseSubActionsCount);
        break;
      case EAIActionPhase.Loop:
        phaseResult = this.UpdateLoopSubActions(context, this.GetPhaseDuration(context), this.m_phaseSubActionsCount);
        break;
      case EAIActionPhase.Recovery:
        phaseResult = this.UpdateRecoverySubActions(context, this.GetPhaseDuration(context), this.m_phaseSubActionsCount);
        break;
      default:
    };
    if Equals(generalResult, AIbehaviorUpdateOutcome.FAILURE) {
      return generalResult;
    };
    if this.m_actionRecord.SubActionsCanCompleteAction() && this.m_phaseSubActionsCount == 0 && Equals(generalResult, AIbehaviorUpdateOutcome.SUCCESS) {
      return generalResult;
    };
    return phaseResult;
  }

  private final func UpdateGeneralSubActions(const context: ScriptExecutionContext, const duration: Float) -> AIbehaviorUpdateOutcome {
    let countFailure: Int32;
    let countSuccess: Int32;
    let i: Int32;
    let subAction: ref<AISubAction_Record>;
    let subActionCount: Int32 = this.m_actionRecord.GetSubActionsCount();
    if subActionCount == 0 {
      return AIbehaviorUpdateOutcome.IN_PROGRESS;
    };
    i = 0;
    while i < subActionCount {
      if Equals(this.m_generalSubActionsResults[i], AIbehaviorUpdateOutcome.IN_PROGRESS) {
        subAction = this.m_actionRecord.GetSubActionsItem(i);
        this.m_generalSubActionsResults[i] = TweakAISubAction.Update(context, subAction, duration);
      };
      if Equals(this.m_generalSubActionsResults[i], AIbehaviorUpdateOutcome.FAILURE) {
        countFailure += 1;
      } else {
        if Equals(this.m_generalSubActionsResults[i], AIbehaviorUpdateOutcome.SUCCESS) {
          countSuccess += 1;
        };
      };
      i += 1;
    };
    if countFailure > 0 {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    if countSuccess >= subActionCount {
      return AIbehaviorUpdateOutcome.SUCCESS;
    };
    return AIbehaviorUpdateOutcome.IN_PROGRESS;
  }

  private final func UpdateStartupSubActions(const context: ScriptExecutionContext, const duration: Float, subActionCount: Int32) -> AIbehaviorUpdateOutcome {
    let countFailure: Int32;
    let countSuccess: Int32;
    let i: Int32;
    let subAction: ref<AISubAction_Record>;
    subActionCount = this.m_actionRecord.GetStartupSubActionsCount();
    if subActionCount == 0 {
      return AIbehaviorUpdateOutcome.IN_PROGRESS;
    };
    i = 0;
    while i < subActionCount {
      if Equals(this.m_phaseSubActionsResults[i], AIbehaviorUpdateOutcome.IN_PROGRESS) {
        subAction = this.m_actionRecord.GetStartupSubActionsItem(i);
        this.m_phaseSubActionsResults[i] = TweakAISubAction.Update(context, subAction, duration);
      };
      if Equals(this.m_phaseSubActionsResults[i], AIbehaviorUpdateOutcome.FAILURE) {
        countFailure += 1;
      } else {
        if Equals(this.m_phaseSubActionsResults[i], AIbehaviorUpdateOutcome.SUCCESS) {
          countSuccess += 1;
        };
      };
      i += 1;
    };
    if countFailure > 0 {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    if countSuccess >= subActionCount {
      return AIbehaviorUpdateOutcome.SUCCESS;
    };
    return AIbehaviorUpdateOutcome.IN_PROGRESS;
  }

  private final func UpdateLoopSubActions(const context: ScriptExecutionContext, const duration: Float, subActionCount: Int32) -> AIbehaviorUpdateOutcome {
    let countFailure: Int32;
    let countSuccess: Int32;
    let i: Int32;
    let subAction: ref<AISubAction_Record>;
    subActionCount = this.m_actionRecord.GetLoopSubActionsCount();
    if subActionCount == 0 {
      return AIbehaviorUpdateOutcome.IN_PROGRESS;
    };
    i = 0;
    while i < subActionCount {
      if Equals(this.m_phaseSubActionsResults[i], AIbehaviorUpdateOutcome.IN_PROGRESS) {
        subAction = this.m_actionRecord.GetLoopSubActionsItem(i);
        this.m_phaseSubActionsResults[i] = TweakAISubAction.Update(context, subAction, duration);
      };
      if Equals(this.m_phaseSubActionsResults[i], AIbehaviorUpdateOutcome.FAILURE) {
        countFailure += 1;
      } else {
        if Equals(this.m_phaseSubActionsResults[i], AIbehaviorUpdateOutcome.SUCCESS) {
          countSuccess += 1;
        };
      };
      i += 1;
    };
    if countFailure > 0 {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    if countSuccess >= subActionCount {
      return AIbehaviorUpdateOutcome.SUCCESS;
    };
    return AIbehaviorUpdateOutcome.IN_PROGRESS;
  }

  private final func UpdateRecoverySubActions(const context: ScriptExecutionContext, const duration: Float, subActionCount: Int32) -> AIbehaviorUpdateOutcome {
    let countFailure: Int32;
    let countSuccess: Int32;
    let i: Int32;
    let subAction: ref<AISubAction_Record>;
    subActionCount = this.m_actionRecord.GetRecoverySubActionsCount();
    if subActionCount == 0 {
      return AIbehaviorUpdateOutcome.IN_PROGRESS;
    };
    i = 0;
    while i < subActionCount {
      if Equals(this.m_phaseSubActionsResults[i], AIbehaviorUpdateOutcome.IN_PROGRESS) {
        subAction = this.m_actionRecord.GetRecoverySubActionsItem(i);
        this.m_phaseSubActionsResults[i] = TweakAISubAction.Update(context, subAction, duration);
      };
      if Equals(this.m_phaseSubActionsResults[i], AIbehaviorUpdateOutcome.FAILURE) {
        countFailure += 1;
      } else {
        if Equals(this.m_phaseSubActionsResults[i], AIbehaviorUpdateOutcome.SUCCESS) {
          countSuccess += 1;
        };
      };
      i += 1;
    };
    if countFailure > 0 {
      return AIbehaviorUpdateOutcome.FAILURE;
    };
    if countSuccess >= subActionCount {
      return AIbehaviorUpdateOutcome.SUCCESS;
    };
    return AIbehaviorUpdateOutcome.IN_PROGRESS;
  }

  protected final func RequestGracefulInterruption(const context: ScriptExecutionContext) -> Bool {
    switch this.m_actionPhase {
      case EAIActionPhase.Startup:
        if this.m_phaseRecord.Duration() < 0.00 {
          if this.ChangePhaseTo(context, EAIActionPhase.Recovery) {
            if this.m_phaseRecord.Duration() < 0.00 {
              this.ChangePhaseTo(context, EAIActionPhase.Inactive);
            };
            break;
          };
        };
        return false;
      case EAIActionPhase.Loop:
        if this.ChangePhaseTo(context, EAIActionPhase.Recovery) {
          if this.m_phaseRecord.Duration() < 0.00 {
            this.ChangePhaseTo(context, EAIActionPhase.Inactive);
          };
          break;
        };
        this.ChangePhaseTo(context, EAIActionPhase.Inactive);
        break;
      case EAIActionPhase.Recovery:
        if this.m_phaseRecord.Duration() < 0.00 {
          this.ChangePhaseTo(context, EAIActionPhase.Inactive);
        };
        break;
      case EAIActionPhase.Inactive:
    };
    return true;
  }

  private final func ReactOnAllPhaseSubActionsCompleted(const context: ScriptExecutionContext) -> Void {
    if this.m_phaseRecord.Duration() <= 0.00 {
      if !this.RepeatPhase(context) && !this.m_phaseRecord.DontStopInfiniteOnSubActionsCompletion() {
        this.ChangeToNextPhase(context);
      };
    };
  }

  private final func GetPhaseDuration(const context: ScriptExecutionContext) -> Float {
    return EngineTime.ToFloat(ScriptExecutionContext.GetAITime(context)) - this.m_phaseActivationTimeStamp;
  }

  private final func GetPhaseDurationWithoutFrameDelta(context: ScriptExecutionContext) -> Float {
    return EngineTime.ToFloat(ScriptExecutionContext.GetAITimeLastFrame(context)) - this.m_phaseActivationTimeStamp;
  }

  private final func CalculatePhaseDuration(const context: ScriptExecutionContext, opt phaseDurationFromAnimSlot: Float) -> Void {
    let allowBlend: Float;
    let animData: ref<AIActionAnimData_Record>;
    let ratio: Float;
    let scaledDuration: Float;
    if phaseDurationFromAnimSlot > 0.00 {
      this.m_phaseDuration = phaseDurationFromAnimSlot;
      this.m_phaseAnimationDuration = phaseDurationFromAnimSlot;
    } else {
      if IsDefined(this.m_phaseRecord) {
        if this.m_phaseRecord.MaxDuration() > this.m_phaseRecord.Duration() {
          this.m_phaseDuration = MaxF(0.00, RandRangeF(this.m_phaseRecord.Duration(), this.m_phaseRecord.MaxDuration()));
        } else {
          this.m_phaseDuration = this.m_phaseRecord.Duration();
        };
        if this.m_phaseRecord.AnimationDuration() >= 0.00 {
          this.m_phaseAnimationDuration = this.m_phaseRecord.AnimationDuration();
        } else {
          this.m_phaseAnimationDuration = this.m_phaseDuration;
        };
      };
    };
    if this.m_phaseDuration <= 0.10 {
      return;
    };
    animData = this.m_actionRecord.AnimData();
    if !IsDefined(animData) || !IsNameValid(animData.AnimFeature()) {
      return;
    };
    if IsDefined(this.m_phaseRecord) && IsDefined(this.m_phaseRecord.DynamicDuration()) && TweakAISubAction.GetPhaseDuration(context, this.m_phaseRecord.DynamicDuration(), this.m_actionPhase, this.m_phaseDuration, scaledDuration) {
      ratio = scaledDuration / this.m_phaseDuration;
      this.m_phaseDuration = scaledDuration;
      if ratio > 0.00 {
        this.m_phaseAnimationDuration *= ratio;
      };
    };
    allowBlend = 0.00;
    if IsDefined(this.m_actionRecord) {
      allowBlend = this.GetAllowBlendDuration();
      if this.m_actionRecord.AllowBlendPercCap() >= 0.00 {
        allowBlend = MinF(allowBlend, this.m_actionRecord.AllowBlendPercCap() * this.m_phaseDuration);
      };
    };
    this.m_phaseDuration = MaxF(this.m_phaseDuration - allowBlend, 0.00);
  }

  private final func GetAllowBlendDuration() -> Float {
    if this.m_actionRecord.AllowBlendDuration() <= 0.00 {
      return 0.00;
    };
    if IsDefined(this.m_actionRecord.Recovery()) && this.m_actionRecord.Recovery().Duration() != 0.00 {
      if NotEquals(this.m_actionPhase, EAIActionPhase.Recovery) {
        return 0.00;
      };
    } else {
      if IsDefined(this.m_actionRecord.Loop()) && this.m_actionRecord.Loop().Duration() != 0.00 {
        if NotEquals(this.m_actionPhase, EAIActionPhase.Loop) {
          return 0.00;
        };
      } else {
        if IsDefined(this.m_actionRecord.Startup()) && this.m_actionRecord.Startup().Duration() != 0.00 {
          if NotEquals(this.m_actionPhase, EAIActionPhase.Startup) {
            return 0.00;
          };
        } else {
          return 0.00;
        };
      };
    };
    return this.m_actionRecord.AllowBlendDuration();
  }

  private final func RepeatPhase(const context: ScriptExecutionContext) -> Bool {
    this.m_phaseIteration += 1u;
    if this.m_phaseRecord.Repeat() < 0 || this.m_phaseIteration == Cast<Uint32>(this.m_phaseRecord.Repeat()) {
      return false;
    };
    if this.m_repeatPhaseConditionCount > 0 && AICondition.RepeatPhaseCheck(context, EnumInt(this.m_actionPhase), this.m_actionRecord) {
      if this.m_phaseRecord.CompleteActionWithFailureOnCondition() {
        this.m_failureStatus = true;
      };
      return false;
    };
    switch this.m_actionPhase {
      case EAIActionPhase.Startup:
        this.DeactivateStartupSubActions(context, this.GetPhaseDuration(context));
        this.ActivateStartupSubActions(context);
        break;
      case EAIActionPhase.Loop:
        this.DeactivateLoopSubActions(context, this.GetPhaseDuration(context));
        this.ActivateLoopSubActions(context);
        break;
      case EAIActionPhase.Recovery:
        this.DeactivateRecoverySubActions(context, this.GetPhaseDuration(context));
        this.ActivateRecoverySubActions(context);
        break;
      case EAIActionPhase.Inactive:
    };
    this.CalculatePhaseDuration(context);
    if IsDefined(this.m_actionRecord.AnimData()) {
      this.SendAnimData(context);
    };
    if IsDefined(this.m_phaseRecord.MovePolicy()) {
      AIActionMovePolicy.Pop(context, this.m_movePolicy);
      AIActionMovePolicy.Add(context, this.m_phaseRecord.MovePolicy(), this.m_movePolicy);
    };
    this.m_phaseActivationTimeStamp = EngineTime.ToFloat(ScriptExecutionContext.GetAITimeLastFrame(context));
    this.m_phaseConditionSuccessfulCheckTimeStamp = -1.00;
    return true;
  }

  private final func ChangeToNextPhase(const context: ScriptExecutionContext) -> Bool {
    if Equals(this.m_actionPhase, EAIActionPhase.Inactive) {
      if this.ChangePhaseTo(context, EAIActionPhase.Startup) {
        return true;
      };
    };
    if Equals(this.m_actionPhase, EAIActionPhase.Startup) {
      if this.ChangePhaseTo(context, EAIActionPhase.Loop) {
        return true;
      };
    };
    if Equals(this.m_actionPhase, EAIActionPhase.Loop) {
      if this.ChangePhaseTo(context, EAIActionPhase.Recovery) {
        return true;
      };
    };
    if this.ChangePhaseTo(context, EAIActionPhase.Inactive) {
      return true;
    };
    return false;
  }

  private final func ChangePhaseTo(const context: ScriptExecutionContext, const newPhase: EAIActionPhase) -> Bool {
    if Equals(newPhase, this.m_actionPhase) {
      return false;
    };
    if !IsFinal() {
      if Equals(newPhase, EAIActionPhase.Startup) {
        ScriptExecutionContext.GetTweakActionSystem(context).Debug_OnActionStarted(context, this.m_actionRecord.GetID(), this.Debug_GetBaseActionId(), this.Debug_GetCompositeId());
      };
    };
    if IsDefined(this.m_phaseRecord) {
      this.OnPhaseEnded(context, this.GetPhaseDuration(context));
    };
    this.m_actionPhase = newPhase;
    this.m_phaseActivationTimeStamp = EngineTime.ToFloat(ScriptExecutionContext.GetAITimeLastFrame(context));
    this.m_phaseConditionSuccessfulCheckTimeStamp = -1.00;
    this.m_phaseIteration = 0u;
    this.m_phaseSubActionsCount = 0;
    this.m_nextPhaseConditionCount = 0;
    this.m_repeatPhaseConditionCount = 0;
    this.m_phaseForceZeroUpdateInterval = false;
    switch this.m_actionPhase {
      case EAIActionPhase.Startup:
        this.m_phaseRecord = this.m_actionRecord.Startup();
        this.m_phaseSubActionsCount = this.m_actionRecord.GetStartupSubActionsCount();
        if IsDefined(this.m_phaseRecord) {
          this.m_nextPhaseConditionCount = this.m_phaseRecord.GetToNextPhaseConditionCount();
          this.m_repeatPhaseConditionCount = this.m_phaseRecord.GetNotRepeatPhaseConditionCount();
          this.m_phaseForceZeroUpdateInterval = this.m_phaseRecord.ForceZeroUpdateInterval();
        };
        break;
      case EAIActionPhase.Loop:
        this.m_phaseRecord = this.m_actionRecord.Loop();
        this.m_phaseSubActionsCount = this.m_actionRecord.GetLoopSubActionsCount();
        if IsDefined(this.m_phaseRecord) {
          this.m_nextPhaseConditionCount = this.m_phaseRecord.GetToNextPhaseConditionCount();
          this.m_repeatPhaseConditionCount = this.m_phaseRecord.GetNotRepeatPhaseConditionCount();
          this.m_phaseForceZeroUpdateInterval = this.m_phaseRecord.ForceZeroUpdateInterval();
        };
        break;
      case EAIActionPhase.Recovery:
        this.m_phaseRecord = this.m_actionRecord.Recovery();
        this.m_phaseSubActionsCount = this.m_actionRecord.GetRecoverySubActionsCount();
        if IsDefined(this.m_phaseRecord) {
          this.m_nextPhaseConditionCount = this.m_phaseRecord.GetToNextPhaseConditionCount();
          this.m_repeatPhaseConditionCount = this.m_phaseRecord.GetNotRepeatPhaseConditionCount();
          this.m_phaseForceZeroUpdateInterval = this.m_phaseRecord.ForceZeroUpdateInterval();
        };
        break;
      default:
        this.m_phaseRecord = null;
    };
    this.m_phaseConditionCheckRandomizedInterval = 0.00;
    if this.m_nextPhaseConditionCount > 0 && this.m_phaseRecord.ToNextPhaseConditionCheckInterval() > 0.00 {
      this.m_phaseConditionCheckRandomizedInterval = AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(this.m_phaseRecord.ToNextPhaseConditionCheckInterval());
    };
    this.OnPhaseStarted(context);
    return this.m_phaseRecord != null;
  }

  private final func OnPhaseStarted(const context: ScriptExecutionContext) -> Void {
    if IsDefined(this.m_phaseRecord) {
      if !IsFinal() {
        ScriptExecutionContext.GetTweakActionSystem(context).Debug_OnActionPhaseStarted(context, this.m_actionRecord.GetID(), EnumInt(this.m_actionPhase));
      };
      switch this.m_actionPhase {
        case EAIActionPhase.Startup:
          this.ActivateStartupSubActions(context);
          break;
        case EAIActionPhase.Loop:
          this.ActivateLoopSubActions(context);
          break;
        case EAIActionPhase.Recovery:
          this.ActivateRecoverySubActions(context);
          break;
        default:
      };
    };
    this.CalculatePhaseDuration(context);
    AIbehaviortaskScript.SetUpdateInterval(context, 0.00);
    if IsDefined(this.m_actionRecord.AnimData()) && (IsDefined(this.m_phaseRecord) || Equals(this.m_actionPhase, EAIActionPhase.Inactive)) {
      this.SendAnimData(context);
    };
    if !IsDefined(this.m_phaseRecord) {
      return;
    };
    if IsDefined(this.m_phaseRecord.ChangeNPCState()) {
      this.ChangeNPCState(context);
    };
    if IsDefined(this.m_phaseRecord.MovePolicy()) {
      AIActionMovePolicy.Add(context, this.m_phaseRecord.MovePolicy(), this.m_movePolicy);
    };
  }

  private final func OnPhaseEnded(const context: ScriptExecutionContext, const duration: Float) -> Void {
    switch this.m_actionPhase {
      case EAIActionPhase.Startup:
        this.DeactivateStartupSubActions(context, duration);
        if this.m_repeatPhaseConditionCount > 0 {
          this.m_repeatPhaseConditionsCount -= 1;
        };
        break;
      case EAIActionPhase.Loop:
        this.DeactivateLoopSubActions(context, duration);
        if this.m_repeatPhaseConditionCount > 0 {
          this.m_repeatPhaseConditionsCount -= 1;
        };
        break;
      case EAIActionPhase.Recovery:
        this.DeactivateRecoverySubActions(context, duration);
        if this.m_repeatPhaseConditionCount > 0 {
          this.m_repeatPhaseConditionsCount -= 1;
        };
        break;
      default:
    };
    if IsDefined(this.m_phaseRecord.ChangeNPCState()) {
      this.ResetNPCState(context);
    };
    if IsDefined(this.m_movePolicy) {
      AIActionMovePolicy.Pop(context, this.m_movePolicy);
    };
  }

  private final func ActivateGeneralSubActions(const context: ScriptExecutionContext) -> Void {
    let i: Int32;
    let subAction: ref<AISubAction_Record>;
    let count: Int32 = this.m_actionRecord.GetSubActionsCount();
    if count > ArraySize(this.m_generalSubActionsResults) {
      return;
    };
    i = 0;
    while i < count {
      subAction = this.m_actionRecord.GetSubActionsItem(i);
      if TweakAISubAction.Activate(context, subAction) {
        this.m_generalSubActionsResults[i] = AIbehaviorUpdateOutcome.IN_PROGRESS;
      } else {
        this.m_generalSubActionsResults[i] = AIbehaviorUpdateOutcome.FAILURE;
      };
      i += 1;
    };
  }

  private final func ActivateStartupSubActions(const context: ScriptExecutionContext) -> Void {
    let i: Int32;
    let subAction: ref<AISubAction_Record>;
    let count: Int32 = this.m_actionRecord.GetStartupSubActionsCount();
    if count > ArraySize(this.m_phaseSubActionsResults) {
      return;
    };
    i = 0;
    while i < count {
      subAction = this.m_actionRecord.GetStartupSubActionsItem(i);
      if TweakAISubAction.Activate(context, subAction) {
        this.m_phaseSubActionsResults[i] = AIbehaviorUpdateOutcome.IN_PROGRESS;
      } else {
        this.m_phaseSubActionsResults[i] = AIbehaviorUpdateOutcome.FAILURE;
      };
      i += 1;
    };
  }

  private final func ActivateLoopSubActions(const context: ScriptExecutionContext) -> Void {
    let i: Int32;
    let subAction: ref<AISubAction_Record>;
    let count: Int32 = this.m_actionRecord.GetLoopSubActionsCount();
    if count > ArraySize(this.m_phaseSubActionsResults) {
      return;
    };
    i = 0;
    while i < count {
      subAction = this.m_actionRecord.GetLoopSubActionsItem(i);
      if TweakAISubAction.Activate(context, subAction) {
        this.m_phaseSubActionsResults[i] = AIbehaviorUpdateOutcome.IN_PROGRESS;
      } else {
        this.m_phaseSubActionsResults[i] = AIbehaviorUpdateOutcome.FAILURE;
      };
      i += 1;
    };
  }

  private final func ActivateRecoverySubActions(const context: ScriptExecutionContext) -> Void {
    let i: Int32;
    let subAction: ref<AISubAction_Record>;
    let count: Int32 = IsDefined(this.m_actionRecord) ? this.m_actionRecord.GetRecoverySubActionsCount() : 0;
    if count > ArraySize(this.m_phaseSubActionsResults) {
      return;
    };
    i = 0;
    while i < count {
      subAction = this.m_actionRecord.GetRecoverySubActionsItem(i);
      if TweakAISubAction.Activate(context, subAction) {
        this.m_phaseSubActionsResults[i] = AIbehaviorUpdateOutcome.IN_PROGRESS;
      } else {
        this.m_phaseSubActionsResults[i] = AIbehaviorUpdateOutcome.FAILURE;
      };
      i += 1;
    };
  }

  private final func DeactivateGeneralSubActions(const context: ScriptExecutionContext, const duration: Float) -> Void {
    let subAction: ref<AISubAction_Record>;
    let count: Int32 = IsDefined(this.m_actionRecord) ? this.m_actionRecord.GetSubActionsCount() : 0;
    let i: Int32 = 0;
    while i < count {
      subAction = this.m_actionRecord.GetSubActionsItem(i);
      TweakAISubAction.Deactivate(context, subAction, duration, this.m_gracefullyInterrupted);
      i += 1;
    };
  }

  private final func DeactivateStartupSubActions(const context: ScriptExecutionContext, const duration: Float) -> Void {
    let subAction: ref<AISubAction_Record>;
    let count: Int32 = IsDefined(this.m_actionRecord) ? this.m_actionRecord.GetStartupSubActionsCount() : 0;
    let i: Int32 = 0;
    while i < count {
      subAction = this.m_actionRecord.GetStartupSubActionsItem(i);
      TweakAISubAction.Deactivate(context, subAction, duration, this.m_gracefullyInterrupted);
      i += 1;
    };
  }

  private final func DeactivateLoopSubActions(const context: ScriptExecutionContext, const duration: Float) -> Void {
    let subAction: ref<AISubAction_Record>;
    let count: Int32 = IsDefined(this.m_actionRecord) ? this.m_actionRecord.GetLoopSubActionsCount() : 0;
    let i: Int32 = 0;
    while i < count {
      subAction = this.m_actionRecord.GetLoopSubActionsItem(i);
      TweakAISubAction.Deactivate(context, subAction, duration, this.m_gracefullyInterrupted);
      i += 1;
    };
  }

  private final func DeactivateRecoverySubActions(const context: ScriptExecutionContext, const duration: Float) -> Void {
    let subAction: ref<AISubAction_Record>;
    let count: Int32 = IsDefined(this.m_actionRecord) ? this.m_actionRecord.GetRecoverySubActionsCount() : 0;
    let i: Int32 = 0;
    while i < count {
      subAction = this.m_actionRecord.GetRecoverySubActionsItem(i);
      TweakAISubAction.Deactivate(context, subAction, duration, this.m_gracefullyInterrupted);
      i += 1;
    };
  }

  private final func ActivateAnimationWrapperOverrides(const context: ScriptExecutionContext) -> Void {
    if this.m_actionRecord.GetAnimationWrapperOverridesCount() <= 0 {
      return;
    };
    this.SetAnimationWrapperOverrides(context, 1.00);
  }

  private final func DeactivateAnimationWrapperOverrides(const context: ScriptExecutionContext) -> Void {
    if this.m_actionRecord.GetAnimationWrapperOverridesCount() <= 0 {
      return;
    };
    this.SetAnimationWrapperOverrides(context, 0.00);
  }

  private final func SetAnimationWrapperOverrides(const context: ScriptExecutionContext, value: Float) -> Void {
    let i: Int32;
    let items: array<wref<ItemObject>>;
    let j: Int32;
    let wrappers: array<CName> = this.m_actionRecord.AnimationWrapperOverrides();
    if ArraySize(wrappers) > 0 {
      AIActionHelper.GetItemsFromWeaponSlots(ScriptExecutionContext.GetOwner(context), items);
      i = 0;
      while i < ArraySize(wrappers) {
        AnimationControllerComponent.SetAnimWrapperWeight(ScriptExecutionContext.GetOwner(context), wrappers[i], value);
        j = 0;
        while j < ArraySize(items) {
          AnimationControllerComponent.SetAnimWrapperWeight(items[j], wrappers[j], value);
          j += 1;
        };
        i += 1;
      };
    };
  }

  private final func ActivateAnimData(const context: ScriptExecutionContext) -> Void {
    if this.m_actionRecord.AnimData().RagdollOnDeath() {
      if (ScriptExecutionContext.GetOwner(context) as NPCPuppet).IsCrowd() && ScriptExecutionContext.GetOwner(context) as NPCPuppet.m_shouldBeImmuneToVehicleHit {
        NPCPuppet.ChangeForceRagdollOnDeath(ScriptExecutionContext.GetOwner(context), false);
      } else {
        NPCPuppet.ChangeForceRagdollOnDeath(ScriptExecutionContext.GetOwner(context), true);
      };
    };
    if this.m_actionRecord.AnimData().WeaponOverride() > 0 {
      this.WeaponOverride(context, this.m_actionRecord.AnimData().WeaponOverride());
    };
  }

  private final func DeactivateAnimData(const context: ScriptExecutionContext) -> Void {
    if this.m_actionRecord.AnimData().RagdollOnDeath() {
      NPCPuppet.ChangeForceRagdollOnDeath(ScriptExecutionContext.GetOwner(context), false);
    };
    if this.m_actionRecord.AnimData().WeaponOverride() > 0 {
      this.WeaponOverride(context, 0);
    };
    if IsDefined(this.m_actionRecord.AnimData().AnimSlot()) {
      AIBehaviorScriptBase.GetPuppet(context).GetPuppetStateBlackboard().SetBool(GetAllBlackboardDefs().PuppetState.SlotAnimationInProgress, false);
    };
  }

  private final func SendAnimData(const context: ScriptExecutionContext) -> Void {
    let animFeature: ref<AnimFeature_AIAction>;
    let i: Int32;
    let items: array<wref<ItemObject>>;
    let animData: ref<AIActionAnimData_Record> = this.m_actionRecord.AnimData();
    let animFeatureName: CName = animData.AnimFeature();
    if !IsNameValid(animFeatureName) {
      return;
    };
    animFeature = this.GetAnimFeature(context);
    if IsDefined(animData.AnimSlot()) {
      this.PlayAnimationOnSlot(context, animFeature);
    } else {
      AnimationControllerComponent.ApplyFeatureToReplicate(ScriptExecutionContext.GetOwner(context), animFeatureName, animFeature);
    };
    if AIActionHelper.GetItemsFromWeaponSlots(ScriptExecutionContext.GetOwner(context), items) {
      i = 0;
      while i < ArraySize(items) {
        AnimationControllerComponent.ApplyFeatureToReplicate(items[i], animFeatureName, animFeature);
        i += 1;
      };
    };
  }

  private final func GetAnimFeature(const context: ScriptExecutionContext) -> ref<AnimFeature_AIAction> {
    let animVariation: Int32;
    let blackBoard: ref<IBlackboard>;
    let animFeature: ref<AnimFeature_AIAction> = new AnimFeature_AIAction();
    animFeature.state = EnumInt(this.m_actionPhase);
    animFeature.stateDuration = this.m_phaseAnimationDuration;
    if IsDefined(this.m_actionRecord.AnimData().Direction()) {
      animFeature.direction = this.GetAnimDirection(context, this.m_actionRecord.AnimData().Direction());
    };
    if IsDefined(this.m_actionRecord.AnimData().AnimVariationSubAction()) {
      if IsDefined(this.m_actionRecord.AnimData().AnimVariationSubAction() as AISubActionRandomize_Record) {
        blackBoard = (ScriptExecutionContext.GetOwner(context) as ScriptedPuppet).GetAIControllerComponent().GetActionBlackboard();
        if FromVariant<TweakDBID>(blackBoard.GetVariant(GetAllBlackboardDefs().AIAction.ownerLastAnimVariationAction)) != this.m_actionRecord.GetID() {
          blackBoard.SetBool(GetAllBlackboardDefs().AIAction.ownerCurrentAnimVariationSet, false);
        };
        blackBoard.SetVariant(GetAllBlackboardDefs().AIAction.ownerLastAnimVariationAction, ToVariant(this.m_actionRecord.GetID()));
        if TweakAISubAction.GetAnimVariation(context, this.m_actionRecord.AnimData().AnimVariationSubAction() as AISubActionRandomize_Record, animVariation) {
          animFeature.animVariation = animVariation;
        } else {
          animFeature.animVariation = this.m_actionRecord.AnimData().AnimVariation();
        };
      } else {
        if TweakAISubAction.GetAnimVariation(context, this.m_actionRecord.AnimData().AnimVariationSubAction(), animVariation) {
          animFeature.animVariation = animVariation;
        } else {
          animFeature.animVariation = this.m_actionRecord.AnimData().AnimVariation();
        };
      };
    } else {
      animFeature.animVariation = this.m_actionRecord.AnimData().AnimVariation();
    };
    return animFeature;
  }

  private final func GetAnimDirection(const context: ScriptExecutionContext, animDirection: wref<AIActionAnimDirection_Record>) -> Float {
    let targetPos: Vector4;
    let vecToTarget: Vector4;
    if AIActionTarget.GetPosition(context, animDirection.Target(), targetPos, false) {
      vecToTarget = targetPos - ScriptExecutionContext.GetOwner(context).GetWorldPosition();
      return AngleNormalize180(Vector4.GetAngleDegAroundAxis(ScriptExecutionContext.GetOwner(context).GetWorldForward(), vecToTarget, ScriptExecutionContext.GetOwner(context).GetWorldUp()) + animDirection.DirectionAngle());
    };
    return AngleNormalize180(animDirection.DirectionAngle());
  }

  private final func PlayAnimationOnSlot(const context: ScriptExecutionContext, animFeature: wref<AnimFeature_AIAction>) -> Void {
    let phaseDurationFromAnimSlot: Float;
    let slideParams: ActionAnimationSlideParams;
    let slideTarget: wref<GameObject>;
    let slideTargetPositionProvider: ref<IPositionProvider>;
    let slideTargetTrackingMode: gamedataTrackingMode;
    let actionAnimationScriptProxy: ref<ActionAnimationScriptProxy> = AIBehaviorScriptBase.GetPuppet(context).GetAIControllerComponent().GetActionAnimationScriptProxy();
    if IsDefined(actionAnimationScriptProxy) {
      AIBehaviorScriptBase.GetPuppet(context).GetPuppetStateBlackboard().SetBool(GetAllBlackboardDefs().PuppetState.SlotAnimationInProgress, true);
      if Equals(this.m_actionPhase, EAIActionPhase.Inactive) {
        actionAnimationScriptProxy.Stop();
        actionAnimationScriptProxy.Setup(this.m_actionRecord.AnimData().AnimFeature(), new AnimFeature_AIAction(), false, false, false, false, this.m_actionRecord.AnimData().UpdateMovePolicy(), slideParams, slideTarget, this.m_actionRecord.AnimData().MarginToPlayer());
        actionAnimationScriptProxy.Launch();
      } else {
        if this.GetSlideTarget(context, slideTarget, slideTargetTrackingMode) {
          slideParams = this.GetSlideParams(context, slideTarget);
        };
        if NotEquals(slideTargetTrackingMode, gamedataTrackingMode.RealPosition) {
          slideTargetPositionProvider = AIActionMovePolicy.GetTargetPositionProvider(ScriptExecutionContext.GetOwner(context) as ScriptedPuppet, slideTarget, slideTargetTrackingMode);
        };
        actionAnimationScriptProxy.Stop();
        if IsDefined(this.m_phaseRecord) && this.m_phaseRecord.UseDurationFromAnimSlot() && this.m_phaseRecord.Duration() > 0.00 {
          phaseDurationFromAnimSlot = actionAnimationScriptProxy.GetPhaseDuration(this.m_actionRecord.AnimData().AnimFeature(), animFeature);
          this.CalculatePhaseDuration(context, phaseDurationFromAnimSlot);
          if AbsF(this.m_phaseAnimationDuration - phaseDurationFromAnimSlot) >= 0.01 {
            animFeature.stateDuration = this.m_phaseAnimationDuration;
          } else {
            if animFeature.stateDuration > 0.00 {
              animFeature.stateDuration = 0.00;
            };
          };
        };
        actionAnimationScriptProxy.Setup(this.m_actionRecord.AnimData().AnimFeature(), animFeature, this.m_actionRecord.AnimData().AnimSlot().UseRootMotion(), this.m_actionRecord.AnimData().AnimSlot().UsePoseMatching(), this.m_actionRecord.AnimData().AnimSlot().ResetRagdollOnStart(), this.m_actionRecord.AnimData().AnimSlot().UseDynamicObjectsCheck(), this.m_actionRecord.AnimData().UpdateMovePolicy(), slideParams, slideTarget, this.m_actionRecord.AnimData().MarginToPlayer(), slideTargetPositionProvider);
        actionAnimationScriptProxy.Launch();
      };
    };
  }

  private final func GetSlideParams(context: ScriptExecutionContext, slideTarget: wref<GameObject>) -> ActionAnimationSlideParams {
    let slideActionParams: ref<AIActionSlideData_Record>;
    let slideParams: ActionAnimationSlideParams;
    let weaponData: ref<gameItemData>;
    switch this.m_actionPhase {
      case EAIActionPhase.Startup:
        if !IsDefined(this.m_actionRecord.AnimData().AnimSlot().StartupSlide()) {
          break;
        };
        slideParams = GetActionAnimationSlideParams(this.m_actionRecord.AnimData().AnimSlot().StartupSlide());
        slideActionParams = this.m_actionRecord.AnimData().AnimSlot().StartupSlide();
        break;
      case EAIActionPhase.Loop:
        if !IsDefined(this.m_actionRecord.AnimData().AnimSlot().LoopSlide()) {
          break;
        };
        slideParams = GetActionAnimationSlideParams(this.m_actionRecord.AnimData().AnimSlot().LoopSlide());
        slideActionParams = this.m_actionRecord.AnimData().AnimSlot().LoopSlide();
        break;
      case EAIActionPhase.Recovery:
        if !IsDefined(this.m_actionRecord.AnimData().AnimSlot().RecoverySlide()) {
          break;
        };
        slideParams = GetActionAnimationSlideParams(this.m_actionRecord.AnimData().AnimSlot().RecoverySlide());
        slideActionParams = this.m_actionRecord.AnimData().AnimSlot().RecoverySlide();
        break;
      default:
    };
    if slideTarget.IsPlayer() {
      if slideActionParams.OverrideOffsetToTargetFromWeapon() {
        weaponData = GameInstance.GetTransactionSystem(ScriptExecutionContext.GetOwner(context).GetGame()).GetItemData(ScriptExecutionContext.GetOwner(context), ScriptedPuppet.GetActiveWeapon(ScriptExecutionContext.GetOwner(context)).GetItemID());
        slideParams.offsetToTarget = weaponData.GetStatValueByType(gamedataStatType.Range);
      };
      return slideParams;
    };
    if slideActionParams.DisablePositionSlideAgainstNpc() {
      slideParams.usePositionSlide = false;
    };
    slideParams.offsetToTarget = 1.00;
    return slideParams;
  }

  private final func GetSlideTarget(const context: ScriptExecutionContext, out slideTarget: wref<GameObject>, out slideTargetTrackingMode: gamedataTrackingMode) -> Bool {
    slideTargetTrackingMode = gamedataTrackingMode.RealPosition;
    switch this.m_actionPhase {
      case EAIActionPhase.Startup:
        if !IsDefined(this.m_actionRecord.AnimData().AnimSlot().StartupSlide()) || !IsDefined(this.m_actionRecord.AnimData().AnimSlot().StartupSlide().Target()) {
          break;
        };
        slideTargetTrackingMode = this.m_actionRecord.AnimData().AnimSlot().StartupSlide().Target().TrackingMode().Type();
        return AIActionTarget.GetObject(context, this.m_actionRecord.AnimData().AnimSlot().StartupSlide().Target(), slideTarget);
      case EAIActionPhase.Loop:
        if !IsDefined(this.m_actionRecord.AnimData().AnimSlot().LoopSlide()) || !IsDefined(this.m_actionRecord.AnimData().AnimSlot().LoopSlide().Target()) {
          break;
        };
        slideTargetTrackingMode = this.m_actionRecord.AnimData().AnimSlot().LoopSlide().Target().TrackingMode().Type();
        return AIActionTarget.GetObject(context, this.m_actionRecord.AnimData().AnimSlot().LoopSlide().Target(), slideTarget);
      case EAIActionPhase.Recovery:
        if !IsDefined(this.m_actionRecord.AnimData().AnimSlot().RecoverySlide()) || !IsDefined(this.m_actionRecord.AnimData().AnimSlot().RecoverySlide().Target()) {
          break;
        };
        slideTargetTrackingMode = this.m_actionRecord.AnimData().AnimSlot().RecoverySlide().Target().TrackingMode().Type();
        return AIActionTarget.GetObject(context, this.m_actionRecord.AnimData().AnimSlot().RecoverySlide().Target(), slideTarget);
    };
    return false;
  }

  private final func ActivateLookat(const context: ScriptExecutionContext) -> Void {
    let debugActionName: String;
    let lookAtEvent: ref<LookAtAddEvent>;
    let record: ref<AIActionLookAtData_Record>;
    let count: Int32 = this.m_actionRecord.GetLookatsCount();
    let i: Int32 = 0;
    while i < count {
      record = this.m_actionRecord.GetLookatsItem(i);
      if !IsFinal() {
        debugActionName = TDBID.ToStringDEBUG(record.Preset().GetID());
        if AIActionHelper.ActionDebugHelper("", ScriptExecutionContext.GetOwner(context), debugActionName) {
        };
      };
      if IsDefined(record.ActivationCondition()) && !AICondition.CheckActionCondition(context, record.ActivationCondition()) {
      } else {
        AIActionLookat.Activate(context, record, lookAtEvent);
        if IsDefined(lookAtEvent) {
          if Equals(lookAtEvent.bodyPart, n"RightHand") {
            AIBehaviorScriptBase.GetPuppet(context).GetAIControllerComponent().GetShootingBlackboard().SetInt(GetAllBlackboardDefs().AIShooting.rightArmLookAtLimitReached, 1);
          };
          ArrayPush(this.m_lookatEvents, lookAtEvent);
        };
      };
      i += 1;
    };
  }

  private final func DeactivateLookat(const context: ScriptExecutionContext) -> Void {
    if ArraySize(this.m_lookatEvents) == 0 {
      return;
    };
    AIActionLookat.Deactivate(ScriptExecutionContext.GetOwner(context), this.m_lookatEvents);
  }

  private final func TrackCommands(const context: ScriptExecutionContext, stop: Bool) -> Void {
    let commandNames: array<CName>;
    let signal: ref<CommandSignal>;
    let signalId: Uint16;
    let signalTable: ref<gameBoolSignalTable>;
    if IsDefined(this.m_actionRecord) {
      commandNames = this.m_actionRecord.Commands();
    };
    if ArraySize(commandNames) == 0 {
      return;
    };
    signalTable = AIBehaviorScriptBase.GetPuppet(context).GetAIControllerComponent().GetSignals();
    if !IsDefined(signalTable) {
      return;
    };
    signal = new CommandSignal();
    signal.track = !stop;
    signal.commandClassNames = commandNames;
    signalId = signalTable.GetOrCreateSignal(n"CommandSignal");
    signalTable.Set(signalId, false);
    signalTable.SetWithData(signalId, signal);
  }

  private final func WeaponOverride(const context: ScriptExecutionContext, const value: Int32) -> Void {
    let weaponOverride: ref<AnimFeature_WeaponOverride> = new AnimFeature_WeaponOverride();
    weaponOverride.state = value;
    AnimationControllerComponent.ApplyFeatureToReplicate(ScriptExecutionContext.GetOwner(context), n"weaponOverride", weaponOverride);
  }

  private final func ChangeNPCState(context: ScriptExecutionContext) -> Void {
    let signal: ref<NPCStateChangeSignal>;
    let signalId: Uint16;
    let signalTable: ref<gameBoolSignalTable> = AIBehaviorScriptBase.GetPuppet(context).GetAIControllerComponent().GetSignals();
    if !IsDefined(signalTable) {
      return;
    };
    signal = new NPCStateChangeSignal();
    signalId = signalTable.GetOrCreateSignal(n"NPCStateChangeSignal");
    if NotEquals(this.m_phaseRecord.ChangeNPCState().HighLevelState(), n"None") {
      signal.m_highLevelState = IntEnum<gamedataNPCHighLevelState>(Cast<Int32>(EnumValueFromName(n"gamedataNPCHighLevelState", this.m_phaseRecord.ChangeNPCState().HighLevelState())));
      signal.m_highLevelStateValid = true;
    } else {
      if this.m_phaseDuration > 0.00 && this.m_phaseDuration <= 0.10 && !IsDefined(this.m_actionRecord.AnimData()) {
        return;
      };
    };
    if NotEquals(this.m_phaseRecord.ChangeNPCState().UpperBodyState(), n"None") {
      signal.m_upperBodyState = IntEnum<gamedataNPCUpperBodyState>(Cast<Int32>(EnumValueFromName(n"gamedataNPCUpperBodyState", this.m_phaseRecord.ChangeNPCState().UpperBodyState())));
      signal.m_upperBodyStateValid = true;
    };
    if NotEquals(this.m_phaseRecord.ChangeNPCState().StanceState(), n"None") {
      signal.m_stanceState = IntEnum<gamedataNPCStanceState>(Cast<Int32>(EnumValueFromName(n"gamedataNPCStanceState", this.m_phaseRecord.ChangeNPCState().StanceState())));
      signal.m_stanceStateValid = true;
    };
    if NotEquals(this.m_phaseRecord.ChangeNPCState().HitReactionMode(), n"None") {
      signal.m_hitReactionModeState = IntEnum<EHitReactionMode>(Cast<Int32>(EnumValueFromName(n"EHitReactionMode", this.m_phaseRecord.ChangeNPCState().HitReactionMode())));
      signal.m_hitReactionModeStateValid = true;
    };
    if NotEquals(this.m_phaseRecord.ChangeNPCState().DefenseMode(), n"None") {
      signal.m_defenseMode = IntEnum<gamedataDefenseMode>(Cast<Int32>(EnumValueFromName(n"gamedataDefenseMode", this.m_phaseRecord.ChangeNPCState().DefenseMode())));
      signal.m_defenseModeValid = true;
    };
    if NotEquals(this.m_phaseRecord.ChangeNPCState().LocomotionMode(), n"None") {
      signal.m_locomotionMode = IntEnum<gamedataLocomotionMode>(Cast<Int32>(EnumValueFromName(n"gamedataLocomotionMode", this.m_phaseRecord.ChangeNPCState().LocomotionMode())));
      signal.m_locomotionModeValid = true;
    };
    signalTable.Set(signalId, false);
    signalTable.SetWithData(signalId, signal);
  }

  private final func ResetNPCState(context: ScriptExecutionContext) -> Void {
    let signal: ref<NPCStateChangeSignal>;
    let signalId: Uint16;
    let signalTable: ref<gameBoolSignalTable>;
    if this.m_phaseDuration > 0.00 && this.m_phaseDuration <= 0.10 && !IsDefined(this.m_actionRecord.AnimData()) {
      return;
    };
    signalTable = AIBehaviorScriptBase.GetPuppet(context).GetAIControllerComponent().GetSignals();
    if !IsDefined(signalTable) {
      return;
    };
    signal = new NPCStateChangeSignal();
    signalId = signalTable.GetOrCreateSignal(n"NPCStateChangeSignal");
    if NotEquals(this.m_phaseRecord.ChangeNPCState().UpperBodyState(), n"None") {
      signal.m_upperBodyState = gamedataNPCUpperBodyState.Normal;
      signal.m_upperBodyStateValid = true;
    };
    if NotEquals(this.m_phaseRecord.ChangeNPCState().StanceState(), n"None") {
      signal.m_stanceState = gamedataNPCStanceState.Stand;
      signal.m_stanceStateValid = true;
    };
    if NotEquals(this.m_phaseRecord.ChangeNPCState().HitReactionMode(), n"None") {
      signal.m_hitReactionModeState = EHitReactionMode.Regular;
      signal.m_hitReactionModeStateValid = true;
    };
    if NotEquals(this.m_phaseRecord.ChangeNPCState().DefenseMode(), n"None") {
      signal.m_defenseMode = gamedataDefenseMode.NoDefend;
      signal.m_defenseModeValid = true;
    };
    if NotEquals(this.m_phaseRecord.ChangeNPCState().LocomotionMode(), n"None") {
      signal.m_locomotionMode = gamedataLocomotionMode.Moving;
      signal.m_locomotionModeValid = true;
    };
    signalTable.Set(signalId, false);
    signalTable.SetWithData(signalId, signal);
  }

  private final func StartCooldowns(const context: ScriptExecutionContext) -> Void {
    let record: ref<AIActionCooldown_Record>;
    let count: Int32 = this.m_actionRecord.GetCooldownsCount();
    let i: Int32 = 0;
    while i < count {
      record = this.m_actionRecord.GetCooldownsItem(i);
      AIActionHelper.StartCooldown(ScriptExecutionContext.GetOwner(context), record);
      i += 1;
    };
  }

  public func GetDescription(context: ScriptExecutionContext) -> String {
    return this.m_actionDebugName;
  }

  private func GetActionRecord(const context: ScriptExecutionContext, actionDebugName: script_ref<String>, out actionRecord: wref<AIAction_Record>, out shouldCallAgain: Bool) -> Bool {
    return false;
  }

  private func Debug_GetBaseActionId() -> TweakDBID {
    return t"NewPerks.Intelligence_Left_Milestone_2.preventInQueueAgain";
  }

  private func Debug_GetCompositeId() -> TweakDBID {
    return t"NewPerks.Intelligence_Left_Milestone_2.preventInQueueAgain";
  }
}
