
public abstract class AINPCHighLevelStateCheck extends AINPCStateCheck {

  public let m_blackboard: wref<IBlackboard>;

  private func GetStateToCheck() -> gamedataNPCHighLevelState {
    return gamedataNPCHighLevelState.Relaxed;
  }

  private func Activate(context: ScriptExecutionContext) -> Void {
    if !IsDefined(this.m_blackboard) {
      this.m_blackboard = AIBehaviorScriptBase.GetPuppet(context).GetPuppetStateBlackboard();
    };
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(Equals(this.GetStateToCheck(), IntEnum<gamedataNPCHighLevelState>(this.m_blackboard.GetInt(GetAllBlackboardDefs().PuppetState.HighLevel))));
  }
}

public class AINPCPreviousHighLevelStateCheck extends AINPCStateCheck {

  private func GetStateToCheck() -> gamedataNPCHighLevelState {
    return gamedataNPCHighLevelState.Relaxed;
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let puppet: ref<ScriptedPuppet> = AIBehaviorScriptBase.GetPuppet(context);
    return Cast<AIbehaviorConditionOutcomes>(Equals(puppet.GetStatesComponent().GetPreviousHighLevelState(), this.GetStateToCheck()));
  }
}

public class IsDead extends AIbehaviorconditionScript {

  public let m_statPoolsSystem: ref<StatPoolsSystem>;

  public let m_entityID: EntityID;

  private func Activate(context: ScriptExecutionContext) -> Void {
    if !IsDefined(this.m_statPoolsSystem) {
      this.m_statPoolsSystem = GameInstance.GetStatPoolsSystem(ScriptExecutionContext.GetOwner(context).GetGame());
      this.m_entityID = ScriptExecutionContext.GetOwner(context).GetEntityID();
    };
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(this.m_statPoolsSystem.HasStatPoolValueReachedMin(Cast<StatsObjectID>(this.m_entityID), gamedataStatPoolType.Health));
  }
}

public class IsRagdolling extends AIbehaviorconditionScript {

  public let m_npc: wref<NPCPuppet>;

  private func Activate(context: ScriptExecutionContext) -> Void {
    if !IsDefined(this.m_npc) {
      this.m_npc = ScriptExecutionContext.GetOwner(context) as NPCPuppet;
    };
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(this.m_npc.IsRagdolling());
  }
}

public class CheckHighLevelState extends AINPCHighLevelStateCheck {

  public edit let m_state: gamedataNPCHighLevelState;

  private func GetStateToCheck() -> gamedataNPCHighLevelState {
    return this.m_state;
  }
}

public class InRelaxedHighLevelState extends AINPCHighLevelStateCheck {

  private func GetStateToCheck() -> gamedataNPCHighLevelState {
    return gamedataNPCHighLevelState.Relaxed;
  }
}

public class InAlertedHighLevelState extends AINPCHighLevelStateCheck {

  private func GetStateToCheck() -> gamedataNPCHighLevelState {
    return gamedataNPCHighLevelState.Alerted;
  }
}

public class InCombatHighLevelState extends AINPCHighLevelStateCheck {

  private func GetStateToCheck() -> gamedataNPCHighLevelState {
    return gamedataNPCHighLevelState.Combat;
  }
}

public class InStealthHighLevelState extends AINPCHighLevelStateCheck {

  private func GetStateToCheck() -> gamedataNPCHighLevelState {
    return gamedataNPCHighLevelState.Stealth;
  }
}

public class InUnconsciousHighLevelState extends AINPCHighLevelStateCheck {

  private func GetStateToCheck() -> gamedataNPCHighLevelState {
    return gamedataNPCHighLevelState.Unconscious;
  }
}

public class InDeadHighLevelState extends AINPCHighLevelStateCheck {

  private func GetStateToCheck() -> gamedataNPCHighLevelState {
    return gamedataNPCHighLevelState.Dead;
  }
}

public class CheckPreviousHighLevelState extends AINPCPreviousHighLevelStateCheck {

  public edit let m_state: gamedataNPCHighLevelState;

  private func GetStateToCheck() -> gamedataNPCHighLevelState {
    return this.m_state;
  }
}

public abstract class AINPCUpperBodyStateCheck extends AINPCStateCheck {

  public let m_blackboard: wref<IBlackboard>;

  private func GetStateToCheck() -> gamedataNPCUpperBodyState {
    return gamedataNPCUpperBodyState.Normal;
  }

  private func Activate(context: ScriptExecutionContext) -> Void {
    if !IsDefined(this.m_blackboard) {
      this.m_blackboard = AIBehaviorScriptBase.GetPuppet(context).GetPuppetStateBlackboard();
    };
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(Equals(this.GetStateToCheck(), IntEnum<gamedataNPCUpperBodyState>(this.m_blackboard.GetInt(GetAllBlackboardDefs().PuppetState.UpperBody))));
  }
}

public class CheckUpperBodyState extends AINPCUpperBodyStateCheck {

  public edit let m_state: gamedataNPCUpperBodyState;

  private func GetStateToCheck() -> gamedataNPCUpperBodyState {
    return this.m_state;
  }
}

public class InNormalUpperBodyState extends AINPCUpperBodyStateCheck {

  private func GetStateToCheck() -> gamedataNPCUpperBodyState {
    return gamedataNPCUpperBodyState.Normal;
  }
}

public class InShootUpperBodyState extends AINPCUpperBodyStateCheck {

  private func GetStateToCheck() -> gamedataNPCUpperBodyState {
    return gamedataNPCUpperBodyState.Shoot;
  }
}

public class InReloadUpperBodyState extends AINPCUpperBodyStateCheck {

  private func GetStateToCheck() -> gamedataNPCUpperBodyState {
    return gamedataNPCUpperBodyState.Reload;
  }
}

public class InDefendUpperBodyState extends AINPCUpperBodyStateCheck {

  private func GetStateToCheck() -> gamedataNPCUpperBodyState {
    return gamedataNPCUpperBodyState.Defend;
  }
}

public class InAttackUpperBodyState extends AINPCUpperBodyStateCheck {

  private func GetStateToCheck() -> gamedataNPCUpperBodyState {
    return gamedataNPCUpperBodyState.Attack;
  }
}

public class InParryUpperBodyState extends AINPCUpperBodyStateCheck {

  private func GetStateToCheck() -> gamedataNPCUpperBodyState {
    return gamedataNPCUpperBodyState.Parry;
  }
}

public class InTauntUpperBodyState extends AINPCUpperBodyStateCheck {

  private func GetStateToCheck() -> gamedataNPCUpperBodyState {
    return gamedataNPCUpperBodyState.Taunt;
  }
}

public abstract class AINPCStanceStateCheck extends AINPCStateCheck {

  public let m_blackboard: wref<IBlackboard>;

  private func GetStateToCheck() -> gamedataNPCStanceState {
    return gamedataNPCStanceState.Stand;
  }

  private func Activate(context: ScriptExecutionContext) -> Void {
    if !IsDefined(this.m_blackboard) {
      this.m_blackboard = AIBehaviorScriptBase.GetPuppet(context).GetPuppetStateBlackboard();
    };
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(Equals(this.GetStateToCheck(), IntEnum<gamedataNPCStanceState>(this.m_blackboard.GetInt(GetAllBlackboardDefs().PuppetState.Stance))));
  }
}

public class CheckStanceState extends AINPCStanceStateCheck {

  public edit let m_state: gamedataNPCStanceState;

  private func GetStateToCheck() -> gamedataNPCStanceState {
    return this.m_state;
  }
}

public class InStandStanceState extends AINPCStanceStateCheck {

  private func GetStateToCheck() -> gamedataNPCStanceState {
    return gamedataNPCStanceState.Stand;
  }
}

public class InCrouchStanceState extends AINPCStanceStateCheck {

  private func GetStateToCheck() -> gamedataNPCStanceState {
    return gamedataNPCStanceState.Crouch;
  }
}

public class InCoverStanceState extends AINPCStanceStateCheck {

  private func GetStateToCheck() -> gamedataNPCStanceState {
    return gamedataNPCStanceState.Cover;
  }
}

public class InSwimStanceState extends AINPCStanceStateCheck {

  private func GetStateToCheck() -> gamedataNPCStanceState {
    return gamedataNPCStanceState.Swim;
  }
}

public class IsCrowdNPC extends AIbehaviorconditionScript {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(AIBehaviorScriptBase.GetPuppet(context).IsCrowd());
  }
}

public class IsAggressiveCrowd extends AIbehaviorconditionScript {

  public let m_reactionSystem: ref<ReactionSystem>;

  public let m_entityID: EntityID;

  public let m_npc: wref<NPCPuppet>;

  private func Activate(context: ScriptExecutionContext) -> Void {
    if !IsDefined(this.m_reactionSystem) {
      this.m_npc = ScriptExecutionContext.GetOwner(context) as NPCPuppet;
      this.m_entityID = this.m_npc.GetEntityID();
      this.m_reactionSystem = GameInstance.GetReactionSystem(this.m_npc.GetGame());
    };
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    if this.m_reactionSystem.IsRegisteredAsAggressive(this.m_entityID) {
      return AIbehaviorConditionOutcomes.True;
    };
    if this.m_npc.GetWasAggressiveCrowd() {
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class WasNPCForcedToJoinCrowd extends AIbehaviorconditionScript {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(AIBehaviorScriptBase.GetAIComponent(context).WasForcedToEnterCrowd());
  }
}
