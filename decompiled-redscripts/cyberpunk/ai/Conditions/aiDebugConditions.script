
public class CheckIfCombatAllowed extends AIDebugConditions {

  private func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    if IsFinal() {
      return AIbehaviorConditionOutcomes.True;
    };
    return Cast<AIbehaviorConditionOutcomes>(!AIBehaviorScriptBase.GetPuppet(context).GetBoolFromCharacterTweak("Combat_Disabled"));
  }
}

public class CheckIfSearchAllowed extends AIDebugConditions {

  private func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    if IsFinal() {
      return AIbehaviorConditionOutcomes.True;
    };
    return Cast<AIbehaviorConditionOutcomes>(!AIBehaviorScriptBase.GetPuppet(context).GetBoolFromCharacterTweak("Search_Disabled"));
  }
}

public class CheckIfPatrolAllowed extends AIDebugConditions {

  private func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    if IsFinal() {
      return AIbehaviorConditionOutcomes.True;
    };
    return Cast<AIbehaviorConditionOutcomes>(AIBehaviorScriptBase.GetPuppet(context).GetBoolFromCharacterTweak("Is_Patrolling"));
  }
}

public class Debug_CheckIfShouldReturnToSpawn extends AIDebugConditions {

  private func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    if IsFinal() {
      return AIbehaviorConditionOutcomes.True;
    };
    return Cast<AIbehaviorConditionOutcomes>(AIBehaviorScriptBase.GetPuppet(context).GetBoolFromCharacterTweak("Debug_ShouldReturnToSpawnOnIdle") || TDB.GetBool(t"AIGeneralSettings.Debug_ShouldReturnToSpawnOnIdle"));
  }
}

public class Debug_LookatTestEnabled extends AIDebugConditions {

  private func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    if AIBehaviorScriptBase.GetPuppet(context).GetBoolFromCharacterTweak("Debug_LookatTest") {
      return AIbehaviorConditionOutcomes.True;
    };
    if AIBehaviorScriptBase.GetPuppet(context).GetBoolFromCharacterTweak("Debug_AimingLookatTest") {
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class Debug_AimingLookatTestEnabled extends AIDebugConditions {

  private func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(AIBehaviorScriptBase.GetPuppet(context).GetBoolFromCharacterTweak("Debug_AimingLookatTest"));
  }
}

public class Debug_RotationTestEnabled extends AIDebugConditions {

  private func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(AIBehaviorScriptBase.GetPuppet(context).GetBoolFromCharacterTweak("Debug_RotationTest"));
  }
}
