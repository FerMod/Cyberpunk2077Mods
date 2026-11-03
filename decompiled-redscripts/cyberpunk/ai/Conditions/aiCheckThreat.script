
public class CheckThreat extends AIbehaviorconditionScript {

  public inline edit let m_targetObjectMapping: ref<AIArgumentMapping>;

  protected let m_targetThreat: wref<GameObject>;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.10));
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let i: Int32;
    let threats: array<TrackedLocation>;
    this.m_targetThreat = FromVariant<wref<GameObject>>(ScriptExecutionContext.GetMappingValue(context, this.m_targetObjectMapping));
    let trackerComponent: ref<TargetTrackerComponent> = AIBehaviorScriptBase.GetPuppet(context).GetTargetTrackerComponent();
    if !IsDefined(trackerComponent) {
      return AIbehaviorConditionOutcomes.False;
    };
    if !IsDefined(this.m_targetThreat) {
      return AIbehaviorConditionOutcomes.False;
    };
    threats = trackerComponent.GetThreats(true);
    if ArraySize(threats) == 0 {
      return AIbehaviorConditionOutcomes.False;
    };
    i = 0;
    while i < ArraySize(threats) {
      if threats[i].entity == this.m_targetThreat {
        return Cast<AIbehaviorConditionOutcomes>(AIActionHelper.TryChangingAttitudeToHostile(AIBehaviorScriptBase.GetPuppet(context), this.m_targetThreat));
      };
      i += 1;
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class CheckDroppedThreat extends CheckThreat {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let threatData: DroppedThreatData;
    let tte: ref<TargetTrackingExtension> = AIBehaviorScriptBase.GetPuppet(context).GetTargetTrackerComponent() as TargetTrackingExtension;
    if !IsDefined(tte) {
      return AIbehaviorConditionOutcomes.False;
    };
    threatData = tte.GetRecentlyDroppedThreat();
    return Cast<AIbehaviorConditionOutcomes>(IsDefined(threatData.threat));
  }
}
