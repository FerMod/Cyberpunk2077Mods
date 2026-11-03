
public class TargetNPCIsCrowdHitPrereqCondition extends BaseHitPrereqCondition {

  public func Evaluate(hitEvent: ref<gameHitEvent>) -> Bool {
    let target: ref<ScriptedPuppet> = hitEvent.target as ScriptedPuppet;
    if IsDefined(target) && target.IsCrowd() {
      return !this.m_invert;
    };
    return this.m_invert;
  }
}
