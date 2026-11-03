
public class AnimationsLoadedCondition extends AIbehaviorconditionScript {

  public edit let m_coreAnims: Bool;

  public edit let m_melee: Bool;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.10));
  }

  private func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    if this.m_coreAnims {
      return Cast<AIbehaviorConditionOutcomes>(AIActionHelper.PreloadCoreAnimations(AIBehaviorScriptBase.GetPuppet(context), this.m_melee));
    };
    return Cast<AIbehaviorConditionOutcomes>(AIActionHelper.PreloadBaseAnimations(AIBehaviorScriptBase.GetPuppet(context), this.m_melee));
  }
}

public class AnimationsLoadedTask extends AIbehaviortaskScript {

  public edit let m_coreAnims: Bool;

  public edit let m_setSignal: Bool;

  public edit let m_melee: Bool;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviortaskScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  private func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    if this.m_coreAnims {
      if AIActionHelper.PreloadCoreAnimations(AIBehaviorScriptBase.GetPuppet(context), this.m_melee) {
        if this.m_setSignal && !this.m_melee {
          AIActionHelper.AnimationsLoadedSignal(AIBehaviorScriptBase.GetPuppet(context));
        } else {
          return AIbehaviorUpdateOutcome.SUCCESS;
        };
      };
      return AIbehaviorUpdateOutcome.IN_PROGRESS;
    };
    if AIActionHelper.PreloadBaseAnimations(AIBehaviorScriptBase.GetPuppet(context), this.m_melee) {
      if this.m_setSignal && !this.m_melee {
        AIActionHelper.AnimationsLoadedSignal(AIBehaviorScriptBase.GetPuppet(context));
      } else {
        return AIbehaviorUpdateOutcome.SUCCESS;
      };
    };
    return AIbehaviorUpdateOutcome.IN_PROGRESS;
  }
}
